#!/usr/bin/env ruby
# frozen_string_literal: true

# Sentence-Granularity Embedding for UDON Enablement Analysis
#
# Chunks responses into meaningful semantic units:
#   1. UDON code blocks → "dsl_example"
#   2. Prose sentences  → "claim"
#   3. |element names   → "concept"
#
# Uses ollama qwen3-embedding and pgvector.

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
    DROP TABLE IF EXISTS chunk_embeddings;

    CREATE TABLE chunk_embeddings (
      id SERIAL PRIMARY KEY,
      result_id TEXT,
      topic TEXT,
      test_type TEXT,
      chunk_type TEXT,        -- 'dsl_example', 'claim', 'concept'
      chunk_text TEXT,
      embedding vector(4096)
    );
  SQL
  puts "Database schema created."
end

# Extract UDON code blocks from markdown
def extract_udon_blocks(text)
  blocks = []

  # Match ```udon ... ``` blocks
  text.scan(/```udon\s*\n(.*?)```/m) do |match|
    content = match[0].strip
    blocks << content if content.length > 20  # Skip trivial examples
  end

  # Match ``` blocks that look like UDON (contain | elements)
  text.scan(/```\s*\n(.*?)```/m) do |match|
    content = match[0].strip
    if content =~ /^\s*\|[a-z]/i && !blocks.include?(content)
      blocks << content
    end
  end

  blocks.uniq
end

# Extract |element names from text (concepts invented)
def extract_element_names(text)
  # Match |elementname patterns
  elements = text.scan(/\|([a-z][-a-z0-9_]*)/i).flatten

  # Filter out common/generic ones
  generic = %w[code example section div span p br hr ul ol li table tr td th]
  elements.reject { |e| generic.include?(e.downcase) }
          .uniq
          .map { |e| "|#{e}" }
end

# Extract prose sentences (excluding code blocks)
def extract_sentences(text)
  # Remove code blocks first
  prose = text.gsub(/```.*?```/m, ' ')

  # Remove markdown headers for cleaner sentences
  prose = prose.gsub(/^#+\s+/, '')

  # Split into sentences (simple heuristic)
  sentences = prose.split(/(?<=[.!?])\s+(?=[A-Z])/)

  sentences.map(&:strip)
           .reject { |s| s.length < 30 }      # Too short
           .reject { |s| s.length > 500 }     # Too long (probably not a sentence)
           .reject { |s| s =~ /^\s*[-*]\s*$/ } # Empty list items
           .reject { |s| s =~ /^\|/ }          # UDON fragments
           .map { |s| s.gsub(/\s+/, ' ') }     # Normalize whitespace
           .uniq
end

def load_results
  files = Dir.glob("#{RESULTS_DIR}/udon-topic*.yaml")
  puts "Found #{files.size} topic result files."

  results = []
  files.each do |f|
    data = YAML.safe_load(File.read(f), permitted_classes: [Time])
    next unless data["response"]

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
  puts "Sentence-Granularity Embedding"
  puts "=" * 60
  puts

  conn = PG.connect(dbname: DB_NAME)
  setup_database(conn)

  results = load_results

  total_chunks = 0

  results.each_with_index do |r, i|
    puts "\n[#{i + 1}/#{results.size}] Processing: #{r[:topic]}"

    chunks = []

    # 1. Extract UDON code blocks
    udon_blocks = extract_udon_blocks(r[:response])
    udon_blocks.each do |block|
      chunks << { type: "dsl_example", text: block[0..1000] }
    end
    puts "  - #{udon_blocks.size} DSL examples"

    # 2. Extract element names as concepts
    elements = extract_element_names(r[:response])
    # Group elements into a single "concept vocabulary" chunk per response
    if elements.any?
      chunks << { type: "concept", text: "UDON elements invented: #{elements.join(', ')}" }
    end
    puts "  - #{elements.size} element concepts"

    # 3. Extract prose sentences
    sentences = extract_sentences(r[:response])
    sentences.each do |sent|
      chunks << { type: "claim", text: sent }
    end
    puts "  - #{sentences.size} prose sentences"

    # Embed and store each chunk
    chunks.each_with_index do |chunk, ci|
      print "\r  Embedding chunk #{ci + 1}/#{chunks.size}..."

      embedding = embed_text(chunk[:text])

      conn.exec_params(
        "INSERT INTO chunk_embeddings (result_id, topic, test_type, chunk_type, chunk_text, embedding)
         VALUES ($1, $2, $3, $4, $5, $6)",
        [r[:id], r[:topic], r[:test_type], chunk[:type], chunk[:text], "[#{embedding.join(',')}]"]
      )
    end

    total_chunks += chunks.size
    puts "\r  Embedded #{chunks.size} chunks.          "
  end

  puts "\n\nTotal chunks embedded: #{total_chunks}"

  # Quick stats
  stats = conn.exec(<<~SQL)
    SELECT chunk_type, COUNT(*) as count
    FROM chunk_embeddings
    GROUP BY chunk_type
    ORDER BY count DESC;
  SQL

  puts "\nChunk distribution:"
  stats.each do |row|
    puts "  #{row['chunk_type']}: #{row['count']}"
  end

  conn.close
  puts "\n" + "=" * 60
  puts "Embedding complete. Run analyze_chunks.rb for clustering."
end

main
