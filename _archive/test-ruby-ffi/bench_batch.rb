#!/usr/bin/env ruby
# Compare streaming vs batch parsing performance

require_relative '../lib/udon'
require 'benchmark'

path = File.expand_path('../examples/comprehensive.udon', __dir__)
content = File.read(path)

puts "=== UDON Parsing: Streaming vs Batch ==="
puts "File: comprehensive.udon (#{content.bytesize} bytes)"
puts

# Warm up
3.times { Udon.parse(content) }
3.times { Udon.parse_fast(content) }

iterations = 100

# Streaming (per-event FFI calls)
time_streaming = Benchmark.measure {
  iterations.times { Udon.parse(content) }
}

# Batch (single JSON FFI call)
time_batch = Benchmark.measure {
  iterations.times { Udon.parse_fast(content) }
}

events = Udon.parse(content)

puts "#{iterations} iterations:"
puts
puts "  Streaming (parse):      #{(time_streaming.real * 1000).round(1)}ms total, #{(time_streaming.real * 1000 / iterations).round(2)}ms/parse"
puts "  Batch JSON (parse_fast): #{(time_batch.real * 1000).round(1)}ms total, #{(time_batch.real * 1000 / iterations).round(2)}ms/parse"
puts
puts "Speedup: #{(time_streaming.real / time_batch.real).round(1)}x faster"
puts
puts "Throughput:"
bytes_per_sec_streaming = content.bytesize * iterations / time_streaming.real
bytes_per_sec_batch = content.bytesize * iterations / time_batch.real
puts "  Streaming:  #{(bytes_per_sec_streaming / 1_000_000).round(1)} MB/s"
puts "  Batch:      #{(bytes_per_sec_batch / 1_000_000).round(1)} MB/s"
puts
puts "Events: #{events.size}"

# Verify results match
streaming_events = Udon.parse(content)
batch_events = Udon.parse_fast(content)

# Quick sanity check
if streaming_events.size == batch_events.size
  puts "Verification: Both methods return #{streaming_events.size} events ✓"
else
  puts "WARNING: Event count mismatch! Streaming=#{streaming_events.size}, Batch=#{batch_events.size}"
end
