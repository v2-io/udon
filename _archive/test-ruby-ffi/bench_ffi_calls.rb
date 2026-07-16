#!/usr/bin/env ruby
# Measure the cost of FFI calls themselves

require_relative '../lib/udon'
require 'benchmark'

# Test 1: How many events for comprehensive.udon?
path = File.expand_path('../examples/comprehensive.udon', __dir__)
content = File.read(path)
events = Udon.parse(content)
puts "comprehensive.udon: #{content.bytesize} bytes, #{events.size} events"
puts "Bytes per event: #{content.bytesize.to_f / events.size}"
puts

# Test 2: Cost of FFI calls
iterations = 1000

# Baseline: just call udon_version (minimal FFI call)
time_version = Benchmark.measure {
  iterations.times { Udon.version }
}
puts "#{iterations} udon_version() calls: #{(time_version.real * 1000).round(2)}ms"
puts "Per call: #{(time_version.real * 1_000_000 / iterations).round(2)}µs"
puts

# Test 3: Parse and count events (many FFI calls)
time_parse = Benchmark.measure {
  100.times { Udon.parse(content) }
}
puts "100 full parses of comprehensive.udon:"
puts "  Total: #{(time_parse.real * 1000).round(2)}ms"
puts "  Per parse: #{(time_parse.real * 10).round(2)}ms"
puts "  Events per parse: #{events.size}"
puts "  Time per event: #{(time_parse.real * 1_000_000 / (100 * events.size)).round(2)}µs"
puts

# Test 4: What if we just counted events without creating Ruby hashes?
# (We can't easily test this, but we can estimate)
puts "Estimated breakdown:"
ffi_overhead_us = time_version.real * 1_000_000 / iterations
events_per_parse = events.size
total_ffi_time_ms = (ffi_overhead_us * events_per_parse) / 1000
parse_time_ms = time_parse.real * 10  # per parse

puts "  FFI call overhead: ~#{ffi_overhead_us.round(2)}µs each"
puts "  #{events_per_parse} events × #{ffi_overhead_us.round(2)}µs = #{total_ffi_time_ms.round(2)}ms just for FFI"
puts "  Actual parse time: #{parse_time_ms.round(2)}ms"
puts "  Ratio: #{(total_ffi_time_ms / parse_time_ms * 100).round(1)}% is FFI overhead"
