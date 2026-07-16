#!/usr/bin/env ruby
# Estimate potential of different approaches

require_relative '../lib/udon'
require 'json'
require 'benchmark'

path = File.expand_path('../examples/comprehensive.udon', __dir__)
content = File.read(path)

puts "=== Theoretical limits of different approaches ==="
puts

iterations = 100

# Current: JSON parse (simulated - 864 events)
events_json = nil
single_event = '{"type":"text","content":"hello","span":[0,5]}'
json_str = "[#{([single_event] * 864).join(',')}]"
time_json = Benchmark.measure {
  iterations.times do
    events_json = JSON.parse(json_str, symbolize_names: true)
  end
}

# Simulate: just String#unpack (binary buffer)
# Assume 20 bytes per event: type(4) + start(4) + end(4) + offset(4) + len(4)
binary_data = "\x00" * (864 * 20)
time_unpack = Benchmark.measure {
  iterations.times do
    # Unpack as array of 5 integers per event
    binary_data.unpack("L<" * (864 * 5))
  end
}

# Current batch JSON (actual)
time_actual = Benchmark.measure {
  iterations.times { Udon.parse_fast(content) }
}

puts "#{iterations} iterations, 864 events each:"
puts
puts "Actual UDON batch (JSON):  #{(time_actual.real * 1000).round(1)}ms"
puts "JSON.parse only:           #{(time_json.real * 1000).round(1)}ms"
puts "String#unpack (binary):    #{(time_unpack.real * 1000).round(1)}ms"
puts
puts "If we used binary instead of JSON:"
json_parse_time = time_json.real
unpack_time = time_unpack.real
savings = json_parse_time - unpack_time
puts "  Could save ~#{(savings * 1000).round(1)}ms per #{iterations} parses"
puts "  That's ~#{(savings / time_actual.real * 100).round(0)}% of current time"
puts

# What about just creating Ruby hashes?
time_hash_creation = Benchmark.measure {
  iterations.times do
    events = []
    864.times do |i|
      events << { type: :text, content: "hello", span: { start: 0, end: 5 } }
    end
  end
}
puts "Pure Ruby Hash creation:   #{(time_hash_creation.real * 1000).round(1)}ms"
puts "  (This is the floor - native extension would still need to do this)"
