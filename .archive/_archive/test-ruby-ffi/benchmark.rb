#!/usr/bin/env ruby
# frozen_string_literal: true

# Performance comparison: UDON vs YAML vs XML
#
# This benchmark includes realistic "usage" - traversing the entire parsed
# structure to ensure we're measuring apples-to-apples.
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

# ========== AST Traversal Functions ==========
# These ensure we're measuring realistic usage, not just parsing

# Traverse UDON events and count nodes/text bytes
def traverse_udon_events(events)
  node_count = 0
  text_bytes = 0

  events.each do |event|
    case event[:type]
    when :element_start, :embedded_start
      node_count += 1
      # Access all fields to simulate real usage
      _ = event[:name]
      _ = event[:id]
      _ = event[:classes]&.each { |c| c.length }
    when :attribute
      _ = event[:key]
      _ = event[:value]
    when :text, :comment, :raw_content
      content = event[:content]
      text_bytes += content.bytesize if content
    end
    # Access span on every event
    _ = event[:span][:start]
    _ = event[:span][:end]
  end

  [node_count, text_bytes]
end

# Traverse YAML data structure recursively
def traverse_yaml(data)
  node_count = 0
  text_bytes = 0

  case data
  when Array
    data.each do |item|
      nc, tb = traverse_yaml(item)
      node_count += nc
      text_bytes += tb
    end
  when Hash
    node_count += 1
    data.each do |key, value|
      text_bytes += key.to_s.bytesize
      nc, tb = traverse_yaml(value)
      node_count += nc
      text_bytes += tb
    end
  when String
    text_bytes += data.bytesize
  end

  [node_count, text_bytes]
end

# Traverse Nokogiri DOM
def traverse_nokogiri(node)
  node_count = 0
  text_bytes = 0

  case node
  when Nokogiri::XML::Element
    node_count += 1
    # Access attributes
    node.attributes.each do |name, attr|
      _ = name
      _ = attr.value
    end
    # Traverse children
    node.children.each do |child|
      nc, tb = traverse_nokogiri(child)
      node_count += nc
      text_bytes += tb
    end
  when Nokogiri::XML::Text
    text_bytes += node.content.bytesize
  when Nokogiri::XML::Document
    node.children.each do |child|
      nc, tb = traverse_nokogiri(child)
      node_count += nc
      text_bytes += tb
    end
  end

  [node_count, text_bytes]
end

# Traverse REXML DOM
def traverse_rexml(node)
  node_count = 0
  text_bytes = 0

  case node
  when REXML::Element
    node_count += 1
    node.attributes.each { |name, value| _ = name; _ = value }
    node.children.each do |child|
      nc, tb = traverse_rexml(child)
      node_count += nc
      text_bytes += tb
    end
  when REXML::Text
    text_bytes += node.value.bytesize
  when REXML::Document
    node.children.each do |child|
      nc, tb = traverse_rexml(child)
      node_count += nc
      text_bytes += tb
    end
  end

  [node_count, text_bytes]
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
puts "All benchmarks include full AST traversal to measure realistic usage."
puts

# Test configurations
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

  # Benchmark UDON (native extension)
  udon_result = run_benchmark("UDON (native)", config[:iters]) do
    events = Udon.parse(udon_doc)
    traverse_udon_events(events)
  end
  udon_result[:bytes] = udon_doc.bytesize
  results << udon_result

  # Benchmark YAML (Psych - C extension)
  yaml_result = run_benchmark("YAML (Psych)", config[:iters]) do
    data = YAML.safe_load(yaml_doc)
    traverse_yaml(data)
  end
  yaml_result[:bytes] = yaml_doc.bytesize
  results << yaml_result

  # Benchmark XML (REXML - pure Ruby)
  rexml_result = run_benchmark("XML (REXML)", [config[:iters], 10].min) do
    doc = REXML::Document.new(xml_doc)
    traverse_rexml(doc)
  end
  rexml_result[:bytes] = xml_doc.bytesize
  results << rexml_result

  # Benchmark XML (Nokogiri - C extension) if available
  if HAS_NOKOGIRI
    noko_result = run_benchmark("XML (Nokogiri)", config[:iters]) do
      doc = Nokogiri::XML(xml_doc)
      traverse_nokogiri(doc)
    end
    noko_result[:bytes] = xml_doc.bytesize
    results << noko_result
  end

  # Print results
  puts "Results (#{config[:iters]} iterations, parse + full traversal):"
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

  result = run_benchmark("UDON parse + traverse", 100) do
    events = Udon.parse(content)
    traverse_udon_events(events)
  end

  events = Udon.parse(content)
  node_count, text_bytes = traverse_udon_events(events)

  puts "Events: #{events.size}"
  puts "Nodes: #{node_count}, Text bytes: #{text_bytes}"
  puts "Time: #{format_time(result[:avg])} avg (#{format_time(result[:min])} min, #{format_time(result[:max])} max)"
  puts "Rate: #{format_rate(content.bytesize, result[:avg])}"
  puts
end

puts "=" * 70
puts "Summary"
puts "=" * 70
puts
puts "All benchmarks include parsing + full AST/event traversal."
puts "This measures realistic usage, not just parsing speed."
puts
