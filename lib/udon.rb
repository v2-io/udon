# frozen_string_literal: true

# UDON Ruby bindings via FFI.
#
# Usage:
#   require_relative 'lib/udon'
#   events = Udon.parse("|div Hello")
#   events.each { |e| puts e.inspect }

require 'ffi'

module Udon
  extend FFI::Library

  # Find the library
  LIB_PATH = File.expand_path('../../crates/target/release/libudon_ffi.dylib', __FILE__)

  unless File.exist?(LIB_PATH)
    raise LoadError, "UDON FFI library not found at #{LIB_PATH}. Run: cd crates && cargo build --release -p udon-ffi"
  end

  ffi_lib LIB_PATH

  # Event types (must match Rust enum)
  module EventType
    ELEMENT_START = 1
    ELEMENT_END = 2
    ATTRIBUTE = 3
    EMBEDDED_START = 4
    EMBEDDED_END = 5
    DIRECTIVE_START = 6
    DIRECTIVE_END = 7
    INLINE_DIRECTIVE = 8
    INTERPOLATION = 9
    TEXT = 10
    RAW_CONTENT = 11
    COMMENT = 12
    ID_REFERENCE = 13
    ATTRIBUTE_MERGE = 14
    FREEFORM_START = 15
    FREEFORM_END = 16
    ERROR = 17

    NAMES = {
      ELEMENT_START => :element_start,
      ELEMENT_END => :element_end,
      ATTRIBUTE => :attribute,
      EMBEDDED_START => :embedded_start,
      EMBEDDED_END => :embedded_end,
      DIRECTIVE_START => :directive_start,
      DIRECTIVE_END => :directive_end,
      INLINE_DIRECTIVE => :inline_directive,
      INTERPOLATION => :interpolation,
      TEXT => :text,
      RAW_CONTENT => :raw_content,
      COMMENT => :comment,
      ID_REFERENCE => :id_reference,
      ATTRIBUTE_MERGE => :attribute_merge,
      FREEFORM_START => :freeform_start,
      FREEFORM_END => :freeform_end,
      ERROR => :error
    }.freeze
  end

  # Value types (must match Rust enum)
  module ValueType
    NONE = 0
    NIL = 1
    BOOL = 2
    INTEGER = 3
    FLOAT = 4
    RATIONAL = 5
    COMPLEX = 6
    STRING = 7
    QUOTED_STRING = 8
    LIST = 9
  end

  # FFI struct for byte slices
  class UdonSlice < FFI::Struct
    layout :ptr, :pointer,
           :len, :size_t

    def to_s
      return nil if self[:ptr].null? || self[:len] == 0
      self[:ptr].read_bytes(self[:len]).force_encoding('UTF-8')
    end
  end

  # FFI struct for spans
  class UdonSpan < FFI::Struct
    layout :start, :uint32,
           :end, :uint32

    def to_h
      { start: self[:start], end: self[:end] }
    end
  end

  # FFI struct for values
  class UdonValue < FFI::Struct
    layout :value_type, :int,
           :data, UdonSlice,
           :int_value, :int64,
           :float_value, :double

    def to_ruby
      case self[:value_type]
      when ValueType::NONE then nil
      when ValueType::NIL then nil
      when ValueType::BOOL then self[:int_value] != 0
      when ValueType::INTEGER then self[:int_value]
      when ValueType::FLOAT then self[:float_value]
      when ValueType::RATIONAL
        Rational(self[:int_value], self[:float_value].to_i)
      when ValueType::COMPLEX
        Complex(self[:float_value], 0) # imag not fully wired yet
      when ValueType::STRING, ValueType::QUOTED_STRING
        self[:data].to_s
      when ValueType::LIST
        [] # Lists need special handling
      else
        nil
      end
    end
  end

  # Element start data
  class UdonElementStart < FFI::Struct
    MAX_CLASSES = 16

    layout :name, UdonSlice,
           :id, UdonValue,
           :classes, [UdonSlice, MAX_CLASSES],
           :num_classes, :uint8,
           :suffix, :char,
           :span, UdonSpan

    def to_h
      classes = (0...self[:num_classes]).map { |i| self[:classes][i].to_s }.compact
      suffix_char = self[:suffix] != 0 ? self[:suffix].chr : nil

      {
        name: self[:name].to_s,
        id: self[:id].to_ruby,
        classes: classes,
        suffix: suffix_char,
        span: self[:span].to_h
      }
    end
  end

  # Attribute data
  class UdonAttribute < FFI::Struct
    layout :key, UdonSlice,
           :value, UdonValue,
           :span, UdonSpan

    def to_h
      {
        key: self[:key].to_s,
        value: self[:value].to_ruby,
        span: self[:span].to_h
      }
    end
  end

  # Directive data
  class UdonDirective < FFI::Struct
    layout :name, UdonSlice,
           :namespace, UdonSlice,
           :is_raw, :bool,
           :span, UdonSpan

    def to_h
      {
        name: self[:name].to_s,
        namespace: self[:namespace].to_s,
        is_raw: self[:is_raw],
        span: self[:span].to_h
      }
    end
  end

  # Inline directive data
  class UdonInlineDirective < FFI::Struct
    layout :name, UdonSlice,
           :namespace, UdonSlice,
           :is_raw, :bool,
           :content, UdonSlice,
           :span, UdonSpan

    def to_h
      {
        name: self[:name].to_s,
        namespace: self[:namespace].to_s,
        is_raw: self[:is_raw],
        content: self[:content].to_s,
        span: self[:span].to_h
      }
    end
  end

  # Content data (text, comment, etc.)
  class UdonContent < FFI::Struct
    layout :content, UdonSlice,
           :span, UdonSpan

    def to_h
      {
        content: self[:content].to_s,
        span: self[:span].to_h
      }
    end
  end

  # Error data
  class UdonError < FFI::Struct
    layout :message, :pointer,
           :span, UdonSpan

    def to_h
      msg = self[:message].null? ? nil : self[:message].read_string
      {
        message: msg,
        span: self[:span].to_h
      }
    end
  end

  # Event data union - we access raw memory based on event_type
  class UdonEventData < FFI::Union
    layout :element_start, UdonElementStart,
           :attribute, UdonAttribute,
           :directive, UdonDirective,
           :inline_directive, UdonInlineDirective,
           :content, UdonContent,
           :error, UdonError,
           :span, UdonSpan
  end

  # Main event struct
  class UdonEvent < FFI::Struct
    layout :event_type, :int,
           :data, UdonEventData

    def type
      EventType::NAMES[self[:event_type]] || :unknown
    end

    def to_h
      data = case self[:event_type]
             when EventType::ELEMENT_START, EventType::EMBEDDED_START
               self[:data][:element_start].to_h
             when EventType::ATTRIBUTE
               self[:data][:attribute].to_h
             when EventType::DIRECTIVE_START
               self[:data][:directive].to_h
             when EventType::INLINE_DIRECTIVE
               self[:data][:inline_directive].to_h
             when EventType::TEXT, EventType::RAW_CONTENT, EventType::COMMENT,
                  EventType::ID_REFERENCE, EventType::ATTRIBUTE_MERGE, EventType::INTERPOLATION
               self[:data][:content].to_h
             when EventType::ERROR
               self[:data][:error].to_h
             when EventType::ELEMENT_END, EventType::EMBEDDED_END,
                  EventType::DIRECTIVE_END, EventType::FREEFORM_START, EventType::FREEFORM_END
               { span: self[:data][:span].to_h }
             else
               {}
             end

      { type: type }.merge(data)
    end
  end

  # FFI function bindings
  attach_function :udon_parser_new, [:pointer, :size_t], :pointer
  attach_function :udon_parser_next, [:pointer], :pointer
  attach_function :udon_parser_reset, [:pointer], :void
  attach_function :udon_parser_event_count, [:pointer], :size_t
  attach_function :udon_parser_free, [:pointer], :void
  attach_function :udon_version, [], :string

  # Batch JSON interface (much faster for scripting languages)
  attach_function :udon_parse_json, [:pointer, :size_t], :pointer
  attach_function :udon_free_string, [:pointer], :void

  # High-level API

  # Parse a UDON string and return an array of event hashes.
  def self.parse(input)
    input = input.encode('UTF-8') if input.respond_to?(:encode)
    input_bytes = input.b

    # Create FFI memory buffer
    buf = FFI::MemoryPointer.from_string(input_bytes)

    parser = udon_parser_new(buf, input_bytes.bytesize)
    raise "Failed to create parser" if parser.null?

    events = []
    begin
      while (event_ptr = udon_parser_next(parser)) && !event_ptr.null?
        event = UdonEvent.new(event_ptr)
        events << event.to_h
      end
    ensure
      udon_parser_free(parser)
    end

    events
  end

  # Parse and yield events one at a time (memory efficient for large files)
  def self.each_event(input)
    return enum_for(:each_event, input) unless block_given?

    input = input.encode('UTF-8') if input.respond_to?(:encode)
    input_bytes = input.b

    buf = FFI::MemoryPointer.from_string(input_bytes)

    parser = udon_parser_new(buf, input_bytes.bytesize)
    raise "Failed to create parser" if parser.null?

    begin
      while (event_ptr = udon_parser_next(parser)) && !event_ptr.null?
        event = UdonEvent.new(event_ptr)
        yield event.to_h
      end
    ensure
      udon_parser_free(parser)
    end
  end

  # Get library version
  def self.version
    udon_version
  end

  # Parse using batch JSON interface (faster, single FFI call).
  # Returns array of event hashes with symbolized keys.
  def self.parse_fast(input)
    require 'json'

    input = input.encode('UTF-8') if input.respond_to?(:encode)
    input_bytes = input.b

    buf = FFI::MemoryPointer.from_string(input_bytes)
    json_ptr = udon_parse_json(buf, input_bytes.bytesize)

    raise "Failed to parse" if json_ptr.null?

    begin
      json_str = json_ptr.read_string
      events = JSON.parse(json_str, symbolize_names: true)
      # Convert span arrays to hashes for consistency with parse()
      events.each do |e|
        if e[:span].is_a?(Array)
          e[:span] = { start: e[:span][0], end: e[:span][1] }
        end
      end
      events
    ensure
      udon_free_string(json_ptr)
    end
  end
end

# Quick test if run directly
if __FILE__ == $0
  puts "UDON FFI version: #{Udon.version}"
  puts

  input = <<~UDON
    ; A simple test
    |div[main].container
      :class content-wrapper
      |h1 Hello, World!
      |p This is a paragraph.
  UDON

  puts "Input:"
  puts input
  puts
  puts "Events:"
  Udon.parse(input).each do |event|
    puts event.inspect
  end
end
