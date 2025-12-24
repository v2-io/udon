#!/usr/bin/env ruby
# frozen_string_literal: true

# Analyze sentence-level embeddings for emergent patterns

require 'pg'
require 'matrix'

DB_NAME = "udon_analysis"

conn = PG.connect(dbname: DB_NAME)

puts "=" * 60
puts "CHUNK-LEVEL SEMANTIC ANALYSIS"
puts "=" * 60

# Check what we have
stats = conn.exec(<<~SQL)
  SELECT chunk_type, COUNT(*) as count
  FROM chunk_embeddings
  GROUP BY chunk_type
  ORDER BY count DESC;
SQL

puts "\nChunk distribution:"
stats.each { |row| puts "  #{row['chunk_type']}: #{row['count']}" }

# Analysis 1: Most similar claims across different topics
puts "\n\n=== MOST SIMILAR CLAIMS ACROSS TOPICS ==="
puts "(Different topics, similar conclusions)\n"

similar_claims = conn.exec(<<~SQL)
  SELECT
    a.topic AS topic_a,
    b.topic AS topic_b,
    a.chunk_text AS claim_a,
    b.chunk_text AS claim_b,
    1 - (a.embedding <=> b.embedding) AS similarity
  FROM chunk_embeddings a, chunk_embeddings b
  WHERE a.id < b.id
    AND a.chunk_type = 'claim'
    AND b.chunk_type = 'claim'
    AND a.topic != b.topic
  ORDER BY a.embedding <=> b.embedding
  LIMIT 15;
SQL

similar_claims.each do |row|
  sim = (row['similarity'].to_f * 100).round(1)
  puts "\n#{sim}% similar:"
  puts "  [#{row['topic_a']}]"
  puts "    #{row['claim_a'][0..120]}..."
  puts "  [#{row['topic_b']}]"
  puts "    #{row['claim_b'][0..120]}..."
end

# Analysis 2: Most similar DSL examples
puts "\n\n=== MOST SIMILAR DSL EXAMPLES ==="

similar_dsl = conn.exec(<<~SQL)
  SELECT
    a.topic AS topic_a,
    b.topic AS topic_b,
    a.chunk_text AS dsl_a,
    b.chunk_text AS dsl_b,
    1 - (a.embedding <=> b.embedding) AS similarity
  FROM chunk_embeddings a, chunk_embeddings b
  WHERE a.id < b.id
    AND a.chunk_type = 'dsl_example'
    AND b.chunk_type = 'dsl_example'
    AND a.topic != b.topic
  ORDER BY a.embedding <=> b.embedding
  LIMIT 10;
SQL

similar_dsl.each do |row|
  sim = (row['similarity'].to_f * 100).round(1)
  puts "\n#{sim}% similar DSL patterns:"
  puts "  [#{row['topic_a']}] vs [#{row['topic_b']}]"
  puts "  Example A:"
  row['dsl_a'].lines.first(5).each { |l| puts "    #{l}" }
  puts "  Example B:"
  row['dsl_b'].lines.first(5).each { |l| puts "    #{l}" }
end

# Analysis 3: Concept vocabulary overlap
puts "\n\n=== CONCEPT VOCABULARY ANALYSIS ==="

concepts = conn.exec(<<~SQL)
  SELECT topic, chunk_text
  FROM chunk_embeddings
  WHERE chunk_type = 'concept'
  ORDER BY topic;
SQL

puts "Elements invented per topic:\n"
concepts.each do |row|
  elements = row['chunk_text'].sub('UDON elements invented: ', '')
  puts "  #{row['topic']}:"
  puts "    #{elements}"
end

# Analysis 4: Cluster claims by semantic similarity
puts "\n\n=== CLAIM CLUSTERS (Hierarchical) ==="

# Fetch all claims
claims = conn.exec(<<~SQL)
  SELECT id, topic, chunk_text, embedding::text
  FROM chunk_embeddings
  WHERE chunk_type = 'claim'
  ORDER BY id;
SQL

if claims.ntuples > 5
  # Parse embeddings
  data = claims.map do |row|
    embedding = row['embedding'].gsub(/[\[\]]/, '').split(',').map(&:to_f)
    {
      id: row['id'],
      topic: row['topic'],
      text: row['chunk_text'][0..80],
      embedding: Vector.elements(embedding)
    }
  end

  puts "Clustering #{data.size} claims...\n"

  # Compute pairwise distances
  n = data.size
  distances = Array.new(n) { Array.new(n, 0.0) }

  n.times do |i|
    (i+1...n).each do |j|
      dot = data[i][:embedding].inner_product(data[j][:embedding])
      norm_i = Math.sqrt(data[i][:embedding].inner_product(data[i][:embedding]))
      norm_j = Math.sqrt(data[j][:embedding].inner_product(data[j][:embedding]))
      cosine_sim = dot / (norm_i * norm_j)
      dist = 1.0 - cosine_sim
      distances[i][j] = dist
      distances[j][i] = dist
    end
  end

  # Agglomerative clustering - show early merges
  clusters = (0...n).map { |i| [i] }
  merge_history = []

  while clusters.size > 1 && merge_history.size < 20
    min_dist = Float::INFINITY
    merge_i, merge_j = nil, nil

    clusters.each_with_index do |c1, i|
      clusters.each_with_index do |c2, j|
        next if i >= j
        total = c1.sum { |p1| c2.sum { |p2| distances[p1][p2] } }
        avg = total / (c1.size * c2.size)
        if avg < min_dist
          min_dist = avg
          merge_i, merge_j = i, j
        end
      end
    end

    merged = clusters[merge_i] + clusters[merge_j]
    clusters.delete_at([merge_i, merge_j].max)
    clusters.delete_at([merge_i, merge_j].min)
    clusters << merged

    merge_history << {
      similarity: (1 - min_dist) * 100,
      items: merged.map { |idx| "#{data[idx][:topic]}: #{data[idx][:text]}" }
    }
  end

  puts "\nEarliest merges (most similar claim pairs):\n"
  merge_history.first(10).each_with_index do |merge, i|
    puts "#{i+1}. [#{merge[:similarity].round(1)}% sim]"
    merge[:items].first(2).each { |item| puts "     #{item[0..100]}..." }
    puts
  end
end

# Analysis 5: Find recurring themes
puts "\n=== RECURRING CLAIM PATTERNS ==="
puts "(Claims that appear semantically similar across 3+ topics)\n"

# Find claims that are close to many others
claim_connectivity = conn.exec(<<~SQL)
  WITH claim_pairs AS (
    SELECT
      a.id,
      a.topic,
      a.chunk_text,
      COUNT(DISTINCT b.topic) as connected_topics
    FROM chunk_embeddings a, chunk_embeddings b
    WHERE a.chunk_type = 'claim'
      AND b.chunk_type = 'claim'
      AND a.id != b.id
      AND a.topic != b.topic
      AND (a.embedding <=> b.embedding) < 0.15  -- High similarity threshold
    GROUP BY a.id, a.topic, a.chunk_text
  )
  SELECT topic, chunk_text, connected_topics
  FROM claim_pairs
  WHERE connected_topics >= 3
  ORDER BY connected_topics DESC
  LIMIT 15;
SQL

claim_connectivity.each do |row|
  puts "  [#{row['connected_topics']} topics] #{row['topic']}:"
  puts "    #{row['chunk_text'][0..100]}..."
  puts
end

conn.close
puts "=" * 60
