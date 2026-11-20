#!/usr/bin/env ruby
# frozen_string_literal: true

# Vector Embedding Analysis for UDON Enablement Tests
#
# Uses ollama qwen3-embedding and pgvector to find semantic patterns
# in the topic enablement responses.

require 'yaml'
require 'json'
require 'net/http'
require 'pg'

OLLAMA_URL = "http://localhost:11434/api/embed"
EMBED_MODEL = "qwen3-embedding:latest"
DB_NAME = "udon_analysis"
RESULTS_DIR = File.join(__dir__, "results")

def embed_text(text)
  uri = URI(OLLAMA_URL)
  http = Net::HTTP.new(uri.host, uri.port)
  http.read_timeout = 120

  request = Net::HTTP::Post.new(uri)
  request["Content-Type"] = "application/json"
  request.body = JSON.generate({ model: EMBED_MODEL, input: text })

  response = http.request(request)

  unless response.is_a?(Net::HTTPSuccess)
    raise "Ollama error: #{response.body}"
  end

  JSON.parse(response.body)["embeddings"][0]
end

def setup_database(conn)
  conn.exec(<<~SQL)
    DROP TABLE IF EXISTS response_embeddings;
    DROP TABLE IF EXISTS sentence_embeddings;

    CREATE TABLE response_embeddings (
      id SERIAL PRIMARY KEY,
      result_id TEXT,
      topic TEXT,
      test_type TEXT,
      response_preview TEXT,
      embedding vector(4096)
    );

    CREATE TABLE sentence_embeddings (
      id SERIAL PRIMARY KEY,
      result_id TEXT,
      topic TEXT,
      sentence_type TEXT,
      sentence TEXT,
      embedding vector(4096)
    );

    -- Skip index for now (small dataset, pgvector limit is 2000 dims for indexed)
    -- Will do brute force similarity which is fine for ~30 docs
  SQL
  puts "Database schema created."
end

def extract_verdict_sentences(response)
  sentences = []

  # Find sentences with assessment language
  patterns = [
    /[^.]*\b(genuine|genuinely)\b[^.]*\./i,
    /[^.]*\b(forced|forcing)\b[^.]*\./i,
    /[^.]*\b(surprising|surprised)\b[^.]*\./i,
    /[^.]*\b(useful|useless)\b[^.]*\./i,
    /[^.]*\b(natural fit|strong fit|poor fit|mismatch)\b[^.]*\./i,
    /[^.]*\b(irrelevant|relevant)\b[^.]*\./i,
    /[^.]*\bwhy this works\b[^.]*\./i,
    /[^.]*\bdoesn't help\b[^.]*\./i,
  ]

  patterns.each do |pattern|
    response.scan(pattern).each do |match|
      text = match.is_a?(Array) ? match.first : match
      sentences << { type: "verdict", text: text.to_s.strip[0..500] }
    end
  end

  # Find "## Verdict" or "## Assessment" sections
  if response =~ /##\s*(Verdict|Assessment|Honest Assessment)[^\n]*\n((?:(?!##).)*)/mi
    sentences << { type: "verdict_section", text: $2.strip[0..1000] }
  end

  sentences.uniq { |s| s[:text] }
end

def load_results
  files = Dir.glob("#{RESULTS_DIR}/udon-topic*.yaml")
  puts "Found #{files.size} result files."

  results = []
  files.each do |f|
    data = YAML.safe_load(File.read(f), permitted_classes: [Time])
    next unless data["response"]

    # Extract topic from task
    topic = data["task"].sub(/^Topic (DSL|enablement): /, "")

    results << {
      id: data["id"],
      topic: topic,
      test_type: data["test_type"],
      response: data["response"]
    }
  end

  results
end

def main
  puts "=" * 60
  puts "UDON Enablement Embedding Analysis"
  puts "=" * 60
  puts

  conn = PG.connect(dbname: DB_NAME)
  setup_database(conn)

  results = load_results
  puts "\nEmbedding #{results.size} responses..."

  # Embed full responses
  results.each_with_index do |r, i|
    print "\r[#{i + 1}/#{results.size}] Embedding: #{r[:topic][0..40]}..."

    # Truncate response for embedding (model limit)
    text = r[:response][0..8000]
    embedding = embed_text(text)

    conn.exec_params(
      "INSERT INTO response_embeddings (result_id, topic, test_type, response_preview, embedding) VALUES ($1, $2, $3, $4, $5)",
      [r[:id], r[:topic], r[:test_type], r[:response][0..200], "[#{embedding.join(',')}]"]
    )

    # Extract and embed verdict sentences
    sentences = extract_verdict_sentences(r[:response])
    sentences.each do |s|
      emb = embed_text(s[:text])
      conn.exec_params(
        "INSERT INTO sentence_embeddings (result_id, topic, sentence_type, sentence, embedding) VALUES ($1, $2, $3, $4, $5)",
        [r[:id], r[:topic], s[:type], s[:text], "[#{emb.join(',')}]"]
      )
    end
  end

  puts "\n\nEmbedding complete. Running analysis...\n\n"

  # Analysis 1: Find most similar response pairs
  puts "=== MOST SIMILAR RESPONSE PAIRS ==="
  similar = conn.exec(<<~SQL)
    SELECT
      a.topic AS topic_a,
      b.topic AS topic_b,
      a.test_type AS type_a,
      b.test_type AS type_b,
      1 - (a.embedding <=> b.embedding) AS similarity
    FROM response_embeddings a, response_embeddings b
    WHERE a.id < b.id
    ORDER BY a.embedding <=> b.embedding
    LIMIT 15;
  SQL

  similar.each do |row|
    puts "  #{(row['similarity'].to_f * 100).round(1)}%  #{row['topic_a']} (#{row['type_a']}) <-> #{row['topic_b']} (#{row['type_b']})"
  end

  # Analysis 2: Find most different response pairs (for contrast)
  puts "\n=== MOST DIFFERENT RESPONSE PAIRS ==="
  different = conn.exec(<<~SQL)
    SELECT
      a.topic AS topic_a,
      b.topic AS topic_b,
      1 - (a.embedding <=> b.embedding) AS similarity
    FROM response_embeddings a, response_embeddings b
    WHERE a.id < b.id
    ORDER BY a.embedding <=> b.embedding DESC
    LIMIT 10;
  SQL

  different.each do |row|
    puts "  #{(row['similarity'].to_f * 100).round(1)}%  #{row['topic_a']} <-> #{row['topic_b']}"
  end

  # Analysis 3: Cluster verdict sentences
  puts "\n=== VERDICT SENTENCE CLUSTERS ==="
  puts "(Finding similar assessments across topics)\n"

  verdict_clusters = conn.exec(<<~SQL)
    SELECT
      a.topic AS topic_a,
      b.topic AS topic_b,
      a.sentence AS sentence_a,
      b.sentence AS sentence_b,
      1 - (a.embedding <=> b.embedding) AS similarity
    FROM sentence_embeddings a, sentence_embeddings b
    WHERE a.id < b.id
      AND a.topic != b.topic
      AND a.sentence_type = 'verdict'
      AND b.sentence_type = 'verdict'
    ORDER BY a.embedding <=> b.embedding
    LIMIT 10;
  SQL

  verdict_clusters.each do |row|
    puts "\n  #{(row['similarity'].to_f * 100).round(1)}% similar:"
    puts "    [#{row['topic_a']}] #{row['sentence_a'][0..100]}..."
    puts "    [#{row['topic_b']}] #{row['sentence_b'][0..100]}..."
  end

  # Analysis 4: Compare baseline vs DSL-focus
  puts "\n=== BASELINE vs DSL-FOCUS COMPARISON ==="

  comparison = conn.exec(<<~SQL)
    SELECT
      a.topic,
      1 - (a.embedding <=> b.embedding) AS similarity
    FROM response_embeddings a
    JOIN response_embeddings b ON a.topic = b.topic AND a.id != b.id
    WHERE a.test_type = 'topic_enablement'
      AND b.test_type = 'topic_dsl'
    ORDER BY a.embedding <=> b.embedding;
  SQL

  if comparison.ntuples > 0
    puts "Same topic, different prompt - how similar are responses?"
    comparison.each do |row|
      puts "  #{row['topic']}: #{(row['similarity'].to_f * 100).round(1)}% similar"
    end

    avg = comparison.map { |r| r['similarity'].to_f }.sum / comparison.ntuples
    puts "\n  Average similarity: #{(avg * 100).round(1)}%"
    puts "  (Lower = DSL prompt produces meaningfully different responses)"
  else
    puts "  No matching baseline/DSL pairs found."
  end

  # Analysis 5: Find the "centroid" topics (most representative)
  puts "\n=== MOST REPRESENTATIVE TOPICS ==="
  puts "(Closest to the center of all responses)"

  centroid = conn.exec(<<~SQL)
    WITH centroid AS (
      SELECT AVG(embedding) as center FROM response_embeddings
    )
    SELECT topic, test_type, 1 - (embedding <=> (SELECT center FROM centroid)) AS centrality
    FROM response_embeddings
    ORDER BY embedding <=> (SELECT center FROM centroid)
    LIMIT 10;
  SQL

  centroid.each do |row|
    puts "  #{(row['centrality'].to_f * 100).round(1)}%  #{row['topic']} (#{row['test_type']})"
  end

  # Analysis 6: Find outliers
  puts "\n=== OUTLIER TOPICS ==="
  puts "(Furthest from center - most unique responses)"

  outliers = conn.exec(<<~SQL)
    WITH centroid AS (
      SELECT AVG(embedding) as center FROM response_embeddings
    )
    SELECT topic, test_type, 1 - (embedding <=> (SELECT center FROM centroid)) AS centrality
    FROM response_embeddings
    ORDER BY embedding <=> (SELECT center FROM centroid) DESC
    LIMIT 10;
  SQL

  outliers.each do |row|
    puts "  #{(row['centrality'].to_f * 100).round(1)}%  #{row['topic']} (#{row['test_type']})"
  end

  conn.close
  puts "\n" + "=" * 60
  puts "Analysis complete."
end

main
