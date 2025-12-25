#!/usr/bin/env ruby
# frozen_string_literal: true

# Performance comparison: UDON vs YAML vs XML
#
# Run: ruby test/benchmark.rb

require_relative '../lib/udon'
require 'yaml'
require 'rexml/document'
require 'benchmark'

# Try to load nokogiri for fast XML parsing
begin
  require 'nokogiri'
  HAS_NOKOGIRI = true
rescue LoadError
  HAS_NOKOGIRI = false
  puts "Note: Install nokogiri gem for fast XML comparison"
end

# Generate test documents of various sizes
def generate_udon(depth, breadth, text_size)
  lines = []
  generate_udon_recursive(lines, "", depth, breadth, text_size)
  lines.join("\n") + "\n"
end

def generate_udon_recursive(lines, indent, depth, breadth, text_size)
  return if depth <= 0

  breadth.times do |i|
    text = "Content #{i} " * (text_size / 10)
    lines << "#{indent}|item[id-#{depth}-#{i}].class-a.class-b :attr value-#{i}"
    lines << "#{indent}  #{text}" unless text.empty?
    generate_udon_recursive(lines, indent + "  ", depth - 1, breadth, text_size)
  end
end

def generate_yaml(depth, breadth, text_size)
  generate_yaml_recursive(depth, breadth, text_size, 0)
end

def generate_yaml_recursive(depth, breadth, text_size, level)
  return "" if depth <= 0

  indent = "  " * level
  lines = []

  breadth.times do |i|
    text = "Content #{i} " * (text_size / 10)
    lines << "#{indent}- id: id-#{depth}-#{i}"
    lines << "#{indent}  class: [class-a, class-b]"
    lines << "#{indent}  attr: value-#{i}"
    lines << "#{indent}  text: \"#{text}\"" unless text.empty?
    children = generate_yaml_recursive(depth - 1, breadth, text_size, level + 1)
    lines << "#{indent}  children:" unless children.empty?
    lines << children unless children.empty?
  end

  lines.join("\n")
end

def generate_xml(depth, breadth, text_size)
  "<?xml version=\"1.0\"?>\n<root>\n" +
    generate_xml_recursive(depth, breadth, text_size, 1) +
    "</root>\n"
end

def generate_xml_recursive(depth, breadth, text_size, level)
  return "" if depth <= 0

  indent = "  " * level
  lines = []

  breadth.times do |i|
    text = "Content #{i} " * (text_size / 10)
    lines << "#{indent}<item id=\"id-#{depth}-#{i}\" class=\"class-a class-b\" attr=\"value-#{i}\">"
    lines << "#{indent}  #{text}" unless text.empty?
    lines << generate_xml_recursive(depth - 1, breadth, text_size, level + 1)
    lines << "#{indent}</item>"
  end

  lines.join("\n")
end

# Benchmark function
def run_benchmark(name, iterations, &block)
  # Warmup
  3.times { block.call }

  # GC before timing
  GC.start

  times = []
  iterations.times do
    start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    block.call
    elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
    times << elapsed
  end

  avg = times.sum / times.size
  min = times.min
  max = times.max

  { name: name, avg: avg, min: min, max: max, times: times }
end

def format_rate(bytes, seconds)
  mb_per_sec = (bytes / 1_000_000.0) / seconds
  if mb_per_sec >= 1
    "#{mb_per_sec.round(1)} MB/s"
  else
    kb_per_sec = (bytes / 1_000.0) / seconds
    "#{kb_per_sec.round(1)} KB/s"
  end
end

def format_time(seconds)
  if seconds < 0.001
    "#{(seconds * 1_000_000).round(1)} µs"
  elsif seconds < 1
    "#{(seconds * 1_000).round(2)} ms"
  else
    "#{seconds.round(3)} s"
  end
end

puts "=" * 70
puts "UDON Parser Performance Benchmark"
puts "=" * 70
puts

# Test configurations: [depth, breadth, text_size, iterations]
configs = [
  { name: "Small",  depth: 2, breadth: 3,  text: 20,  iters: 100 },
  { name: "Medium", depth: 3, breadth: 5,  text: 50,  iters: 50 },
  { name: "Large",  depth: 4, breadth: 5,  text: 100, iters: 20 },
]

configs.each do |config|
  puts "-" * 70
  puts "#{config[:name]} document (depth=#{config[:depth]}, breadth=#{config[:breadth]})"
  puts "-" * 70

  # Generate documents
  udon_doc = generate_udon(config[:depth], config[:breadth], config[:text])
  yaml_doc = generate_yaml(config[:depth], config[:breadth], config[:text])
  xml_doc = generate_xml(config[:depth], config[:breadth], config[:text])

  puts "Document sizes:"
  puts "  UDON: #{udon_doc.bytesize.to_s.rjust(8)} bytes"
  puts "  YAML: #{yaml_doc.bytesize.to_s.rjust(8)} bytes"
  puts "  XML:  #{xml_doc.bytesize.to_s.rjust(8)} bytes"
  puts

  results = []

  # Benchmark UDON (batch JSON - recommended)
  udon_batch_result = run_benchmark("UDON (batch)", config[:iters]) do
    Udon.parse_fast(udon_doc)
  end
  udon_batch_result[:bytes] = udon_doc.bytesize
  results << udon_batch_result

  # Benchmark UDON (streaming - for comparison)
  udon_result = run_benchmark("UDON (streaming)", config[:iters]) do
    Udon.parse(udon_doc)
  end
  udon_result[:bytes] = udon_doc.bytesize
  results << udon_result

  # Benchmark YAML (Psych - C extension)
  yaml_result = run_benchmark("YAML (Psych)", config[:iters]) do
    YAML.safe_load(yaml_doc)
  end
  yaml_result[:bytes] = yaml_doc.bytesize
  results << yaml_result

  # Benchmark XML (REXML - pure Ruby)
  rexml_result = run_benchmark("XML (REXML)", [config[:iters], 10].min) do
    REXML::Document.new(xml_doc)
  end
  rexml_result[:bytes] = xml_doc.bytesize
  results << rexml_result

  # Benchmark XML (Nokogiri - C extension) if available
  if HAS_NOKOGIRI
    noko_result = run_benchmark("XML (Nokogiri)", config[:iters]) do
      Nokogiri::XML(xml_doc)
    end
    noko_result[:bytes] = xml_doc.bytesize
    results << noko_result
  end

  # Print results
  puts "Results (#{config[:iters]} iterations):"
  puts

  # Find fastest for comparison
  fastest = results.min_by { |r| r[:avg] }

  results.each do |r|
    rate = format_rate(r[:bytes], r[:avg])
    time = format_time(r[:avg])
    slower = r[:avg] / fastest[:avg]
    slower_str = slower > 1.1 ? " (#{slower.round(1)}x slower)" : " (fastest)"

    puts "  #{r[:name].ljust(20)} #{time.rjust(12)}  #{rate.rjust(12)}#{slower_str}"
  end
  puts
end

# Also test with real file if available
comprehensive_path = File.expand_path('../examples/comprehensive.udon', __dir__)
if File.exist?(comprehensive_path)
  puts "-" * 70
  puts "Real file: comprehensive.udon"
  puts "-" * 70

  content = File.read(comprehensive_path)
  puts "File size: #{content.bytesize} bytes"
  puts

  result = run_benchmark("UDON parse", 100) do
    Udon.parse(content)
  end

  events = Udon.parse(content)
  puts "Events: #{events.size}"
  puts "Time: #{format_time(result[:avg])} avg (#{format_time(result[:min])} min, #{format_time(result[:max])} max)"
  puts "Rate: #{format_rate(content.bytesize, result[:avg])}"
  puts
end

puts "=" * 70
puts "Summary"
puts "=" * 70
puts
puts "UDON parsing via Rust FFI is competitive with production parsers."
puts "The event-based design enables streaming and low memory usage."
puts
