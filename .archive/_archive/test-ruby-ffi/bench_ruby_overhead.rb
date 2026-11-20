#!/usr/bin/env ruby
# Measure where the Ruby time goes

require_relative '../lib/udon'
require 'benchmark'

path = File.expand_path('../examples/comprehensive.udon', __dir__)
content = File.read(path)

puts "=== Breakdown of Ruby FFI overhead ==="
puts

# Warm up
3.times { Udon.parse(content) }

iterations = 100

# Full parse with Hash creation (current behavior)
time_full = Benchmark.measure {
  iterations.times { Udon.parse(content) }
}

# Parse but don't create Hashes - just count events
time_count_only = Benchmark.measure {
  iterations.times do
    input_bytes = content.b
    buf = FFI::MemoryPointer.from_string(input_bytes)
    parser = Udon.udon_parser_new(buf, input_bytes.bytesize)
    count = 0
    while (event_ptr = Udon.udon_parser_next(parser)) && !event_ptr.null?
      count += 1
      # Don't call to_h - just count
    end
    Udon.udon_parser_free(parser)
  end
}

# Parse, wrap in struct, but don't convert to Hash
time_struct_only = Benchmark.measure {
  iterations.times do
    input_bytes = content.b
    buf = FFI::MemoryPointer.from_string(input_bytes)
    parser = Udon.udon_parser_new(buf, input_bytes.bytesize)
    while (event_ptr = Udon.udon_parser_next(parser)) && !event_ptr.null?
      event = Udon::UdonEvent.new(event_ptr)
      type = event[:event_type]  # Just read the type, no Hash
    end
    Udon.udon_parser_free(parser)
  end
}

puts "#{iterations} iterations of comprehensive.udon (864 events each):"
puts
puts "Count only (FFI calls, no Ruby objects):  #{(time_count_only.real * 1000).round(2)}ms"
puts "Struct wrap (FFI + struct access):        #{(time_struct_only.real * 1000).round(2)}ms"
puts "Full (FFI + struct + Hash creation):      #{(time_full.real * 1000).round(2)}ms"
puts
puts "Per-parse breakdown:"
puts "  FFI + count:     #{(time_count_only.real * 1000 / iterations).round(3)}ms"
puts "  FFI + struct:    #{(time_struct_only.real * 1000 / iterations).round(3)}ms"
puts "  FFI + Hash:      #{(time_full.real * 1000 / iterations).round(3)}ms"
puts
puts "Hash creation overhead: #{((time_full.real - time_struct_only.real) / time_full.real * 100).round(1)}% of total"
