#!/usr/bin/env ruby
# frozen_string_literal: true

# End-to-end FFI tests for the UDON parser.
#
# Run: ruby test/test_ffi.rb
# Or:  ruby test/test_ffi.rb -v  (verbose)

require_relative '../lib/udon'
require 'minitest/autorun'

class UdonFFITest < Minitest::Test
  def test_version
    assert_match(/^\d+\.\d+\.\d+$/, Udon.version)
  end

  def test_empty_input
    events = Udon.parse("")
    assert_equal [], events
  end

  def test_simple_text
    events = Udon.parse("Hello, world!\n")
    assert_equal 1, events.size
    assert_equal :text, events[0][:type]
    assert_equal "Hello, world!", events[0][:content]
  end

  def test_comment
    events = Udon.parse("; This is a comment\n")
    assert_equal 1, events.size
    assert_equal :comment, events[0][:type]
    assert_equal " This is a comment", events[0][:content]
  end

  def test_simple_element
    events = Udon.parse("|div\n")
    assert_equal 2, events.size
    assert_equal :element_start, events[0][:type]
    assert_equal "div", events[0][:name]
    assert_equal :element_end, events[1][:type]
  end

  def test_element_with_id
    events = Udon.parse("|div[main]\n")
    assert_equal 2, events.size
    assert_equal :element_start, events[0][:type]
    assert_equal "div", events[0][:name]
    assert_equal "main", events[0][:id]
  end

  def test_element_with_class
    events = Udon.parse("|div.container\n")
    assert_equal 2, events.size
    assert_equal :element_start, events[0][:type]
    assert_equal "div", events[0][:name]
    assert_equal ["container"], events[0][:classes]
  end

  def test_element_with_id_and_classes
    events = Udon.parse("|div[main].container.primary\n")
    assert_equal 2, events.size
    assert_equal :element_start, events[0][:type]
    assert_equal "div", events[0][:name]
    assert_equal "main", events[0][:id]
    assert_equal ["container", "primary"], events[0][:classes]
  end

  def test_anonymous_element_with_id
    events = Udon.parse("|[hero]\n")
    assert_equal 2, events.size
    assert_equal :element_start, events[0][:type]
    assert_nil events[0][:name]
    assert_equal "hero", events[0][:id]
  end

  def test_anonymous_element_with_class
    events = Udon.parse("|.highlight\n")
    assert_equal 2, events.size
    assert_equal :element_start, events[0][:type]
    assert_nil events[0][:name]
    assert_equal ["highlight"], events[0][:classes]
  end

  def test_element_with_inline_content
    events = Udon.parse("|h1 Hello, World!\n")
    types = events.map { |e| e[:type] }
    assert_equal [:element_start, :text, :element_end], types
    assert_equal "h1", events[0][:name]
    assert_equal "Hello, World!", events[1][:content]
  end

  def test_inline_attribute
    events = Udon.parse("|div :class container\n")
    types = events.map { |e| e[:type] }
    assert_equal [:element_start, :attribute, :element_end], types
    assert_equal "div", events[0][:name]
    assert_equal "class", events[1][:key]
    assert_equal "container", events[1][:value]
  end

  def test_flag_attribute
    events = Udon.parse("|input :disabled\n")
    types = events.map { |e| e[:type] }
    assert_equal [:element_start, :attribute, :element_end], types
    assert_equal "disabled", events[1][:key]
    assert_nil events[1][:value]
  end

  def test_nested_elements_inline
    events = Udon.parse("|a |b |c\n")
    types = events.map { |e| e[:type] }
    # |a starts, |b starts (child of a), |c starts (child of b)
    # then all close at end
    assert_equal [:element_start, :element_start, :element_start,
                  :element_end, :element_end, :element_end], types
    assert_equal "a", events[0][:name]
    assert_equal "b", events[1][:name]
    assert_equal "c", events[2][:name]
  end

  def test_nested_elements_by_indent
    input = <<~UDON
      |parent
        |child
    UDON
    events = Udon.parse(input)
    types = events.map { |e| e[:type] }
    # parent starts, child starts, child ends, parent ends
    assert_equal [:element_start, :element_start, :element_end, :element_end], types
    assert_equal "parent", events[0][:name]
    assert_equal "child", events[1][:name]
  end

  def test_sibling_elements_by_indent
    input = <<~UDON
      |first
      |second
    UDON
    events = Udon.parse(input)
    types = events.map { |e| e[:type] }
    assert_equal [:element_start, :element_end, :element_start, :element_end], types
    assert_equal "first", events[0][:name]
    assert_equal "second", events[2][:name]
  end

  def test_complex_hierarchy
    input = <<~UDON
      |a
        |b
          |c
        |d
      |e
    UDON
    events = Udon.parse(input)
    types = events.map { |e| e[:type] }
    names = events.select { |e| e[:type] == :element_start }.map { |e| e[:name] }

    assert_equal %w[a b c d e], names

    # Expected structure:
    # a starts
    #   b starts
    #     c starts
    #     c ends
    #   b ends
    #   d starts
    #   d ends
    # a ends
    # e starts
    # e ends
    expected = [
      :element_start,  # a
      :element_start,  # b
      :element_start,  # c
      :element_end,    # c ends
      :element_end,    # b ends
      :element_start,  # d
      :element_end,    # d ends
      :element_end,    # a ends
      :element_start,  # e
      :element_end     # e ends
    ]
    assert_equal expected, types
  end

  def test_escape_pipe
    events = Udon.parse("'|not-element\n")
    types = events.map { |e| e[:type] }
    assert_equal [:text], types
    assert_equal "|not-element", events[0][:content]
  end

  def test_escape_semicolon
    events = Udon.parse("';not-comment\n")
    types = events.map { |e| e[:type] }
    assert_equal [:text], types
    assert_equal ";not-comment", events[0][:content]
  end

  def test_pipe_as_prose
    # | followed by space is prose, not element
    events = Udon.parse("a | b\n")
    types = events.map { |e| e[:type] }
    # Parser emits separate text events (could be combined by consumer)
    assert types.all? { |t| t == :text }, "Expected all text events"
    # Combined content should include the pipe
    combined = events.select { |e| e[:type] == :text }.map { |e| e[:content] }.join
    assert_includes combined, "|"
  end

  def test_tab_causes_error
    events = Udon.parse("|div\n\t|child\n")
    has_error = events.any? { |e| e[:type] == :error }
    assert has_error, "Expected error event for tab in indentation"
  end

  def test_unicode_element_name
    events = Udon.parse("|café\n")
    assert_equal :element_start, events[0][:type]
    assert_equal "café", events[0][:name]
  end

  def test_parse_comprehensive_file
    path = File.expand_path('../examples/comprehensive.udon', __dir__)
    skip "comprehensive.udon not found" unless File.exist?(path)

    input = File.read(path)
    events = Udon.parse(input)

    # Just verify it parses without crashing and produces events
    assert events.size > 0, "Expected events from comprehensive.udon"

    # Check for errors
    errors = events.select { |e| e[:type] == :error }
    if errors.any?
      puts "\nErrors in comprehensive.udon:"
      errors.each { |e| puts "  - #{e[:message]} at #{e[:span]}" }
    end
  end

  def test_each_event_enumerator
    input = "|a\n|b\n"
    events = Udon.each_event(input).to_a
    assert_equal 4, events.size # a start, a end, b start, b end
  end
end
