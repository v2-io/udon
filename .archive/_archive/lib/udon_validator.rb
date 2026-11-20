#!/usr/bin/env ruby
# frozen_string_literal: true

# UDON Validator
#
# Basic lexer and validator based on SPEC.md grammar.
# Reports syntax validity and feature usage.

module UdonValidator
  class ValidationResult
    attr_accessor :valid, :errors, :warnings, :features, :stats

    def initialize
      @valid = true
      @errors = []
      @warnings = []
      @features = Set.new
      @stats = Hash.new(0)
    end

    def error!(line, col, msg)
      @valid = false
      @errors << { line: line, col: col, message: msg }
    end

    def warn!(line, col, msg)
      @warnings << { line: line, col: col, message: msg }
    end

    def feature!(name)
      @features << name
    end

    def stat!(name)
      @stats[name] += 1
    end

    def to_h
      {
        valid: @valid,
        errors: @errors,
        warnings: @warnings,
        features: @features.to_a.sort,
        stats: @stats.sort.to_h
      }
    end

    def summary
      lines = []
      lines << "Valid: #{@valid}"
      lines << "Features: #{@features.to_a.sort.join(', ')}" if @features.any?
      lines << "Stats: #{@stats.map { |k, v| "#{k}=#{v}" }.join(', ')}" if @stats.any?
      @errors.each { |e| lines << "ERROR [#{e[:line]}:#{e[:col]}] #{e[:message]}" }
      @warnings.each { |w| lines << "WARN [#{w[:line]}:#{w[:col]}] #{w[:message]}" }
      lines.join("\n")
    end
  end

  class Validator
    LABEL_PATTERN = /[a-zA-Z_][a-zA-Z0-9_-]*/
    SUFFIX_CHARS = %w[? ! * +]

    def validate(input)
      @result = ValidationResult.new
      @lines = input.lines
      @indent_stack = [0]
      @in_freeform = false
      @freeform_indent = 0

      @lines.each_with_index do |line, idx|
        @line_num = idx + 1
        validate_line(line.chomp)
      end

      @result
    end

    private

    def validate_line(line)
      # Handle freeform blocks
      if @in_freeform
        if line.strip.start_with?('```')
          @in_freeform = false
          @result.feature!(:freeform_block)
        end
        return
      end

      # Check for freeform start
      if line.include?('```')
        @in_freeform = true
        @freeform_indent = line.index('```') || 0
        @result.feature!(:freeform_block)
        return
      end

      # Empty line
      return if line.strip.empty?

      # Calculate indent
      indent = line[/\A */].length
      content = line[indent..]

      # Check for tabs
      if line.include?("\t")
        @result.error!(@line_num, line.index("\t") + 1, "Tabs not allowed, use spaces")
      end

      # Determine line type by prefix
      case content[0]
      when '|'
        validate_element(content, indent)
      when ':'
        validate_attribute(content, indent)
      when '!'
        validate_dynamic(content, indent)
      when ';'
        validate_comment(content)
      when "'"
        validate_escape(content)
      else
        validate_prose(content, indent)
      end
    end

    def validate_element(content, indent)
      @result.stat!(:elements)

      # Track indent
      check_indent(indent)

      # Parse element: |name[id].class.class :attr val |child
      pos = 1  # skip |

      # Class-only element (mixin)?
      if content[pos] == '.'
        @result.feature!(:mixin)
        pos = parse_classes(content, pos)
        @result.stat!(:mixins)
      elsif content[pos] == '['
        # ID-only element
        @result.feature!(:id_only_element)
        pos = parse_id(content, pos)
      elsif content[pos] =~ /[a-zA-Z_]/
        # Normal element with name
        name_match = content[pos..].match(/\A#{LABEL_PATTERN}/)
        if name_match
          pos += name_match[0].length
          @result.feature!(:element)

          # Check for suffix after name
          if SUFFIX_CHARS.include?(content[pos])
            @result.feature!(:element_suffix)
            @result.stat!(:suffixes)
            pos += 1
          end
        else
          @result.error!(@line_num, pos + 1, "Invalid element name")
          return
        end

        # Optional [id]
        if content[pos] == '['
          pos = parse_id(content, pos)
          # Suffix after id?
          if SUFFIX_CHARS.include?(content[pos])
            @result.feature!(:element_suffix)
            @result.stat!(:suffixes)
            pos += 1
          end
        end

        # Optional .classes
        if content[pos] == '.'
          pos = parse_classes(content, pos)
        end

        # Space-separated suffix? (but not !{ which is dynamics)
        if content[pos] == ' ' && SUFFIX_CHARS.include?(content[pos + 1]) && content[pos + 2] != '{'
          @result.feature!(:element_suffix)
          @result.stat!(:suffixes)
          pos += 2
        end
      elsif content[pos] == '{'
        # Embedded element at line start (unusual but valid)
        validate_embedded(content)  # Pass full content including |{
        return
      elsif content[pos].nil? || content[pos] == ' '
        # Empty element |
        @result.feature!(:empty_element)
      else
        @result.error!(@line_num, pos + 1, "Unexpected character after |: #{content[pos].inspect}")
        return
      end

      # Rest of line: attributes and inline children
      rest = content[pos..]
      validate_inline_content(rest) if rest && !rest.strip.empty?
    end

    def parse_id(content, pos)
      return pos unless content[pos] == '['

      @result.feature!(:element_id)
      @result.stat!(:ids)
      end_bracket = content.index(']', pos)

      if end_bracket.nil?
        @result.error!(@line_num, pos + 1, "Unclosed [id] bracket")
        return content.length
      end

      # IDs are more permissive than labels - can be numeric, etc.
      # Just check for obviously problematic characters
      id_content = content[(pos + 1)...end_bracket]
      if id_content.match?(/[\[\]|:;!]/)
        @result.warn!(@line_num, pos + 1, "ID contains reserved characters: #{id_content}")
      end

      end_bracket + 1
    end

    def parse_classes(content, pos)
      while content[pos] == '.'
        @result.feature!(:element_class)
        @result.stat!(:classes)
        pos += 1
        class_match = content[pos..].match(/\A#{LABEL_PATTERN}/)
        if class_match
          pos += class_match[0].length
        else
          @result.error!(@line_num, pos + 1, "Invalid class name")
          break
        end
      end
      pos
    end

    def validate_inline_content(content)
      return if content.nil? || content.empty?

      # Lint: multiple extra } suggests typo like |{em text}}
      embedded_opens = content.scan(/\|\{/).size
      dynamic_opens = content.scan(/!\{/).size
      all_closes = content.scan(/\}/).size
      expected_closes = embedded_opens + dynamic_opens
      extra = all_closes - expected_closes
      if extra > 0 && embedded_opens > 0
        @result.warn!(@line_num, 0, "Extra } - possibly confused nested closing (like LaTeX, each |{ needs exactly one })")
      end

      # Skip leading space
      content = content.lstrip

      while content && !content.empty?
        if content.start_with?(':')
          # Attribute
          attr_end = find_attr_end(content)
          validate_attribute(content[0...attr_end], 0)
          content = content[attr_end..]&.lstrip
        elsif content.start_with?('|{')
          # Embedded element
          close = find_embedded_close(content)
          if close
            validate_embedded(content[0..close])
            content = content[(close + 1)..]
          else
            @result.error!(@line_num, 0, "Unclosed embedded element |{...}")
            break
          end
        elsif content.start_with?('|')
          # Inline child element
          @result.feature!(:rightward_nesting)
          @result.stat!(:inline_children)
          # Find where this element ends
          child_end = find_inline_element_end(content)
          validate_element(content[0...child_end], 0)
          content = content[child_end..]
        elsif content.start_with?(';')
          # Inline comment
          validate_comment(content)
          break
        else
          # Inline text/prose
          break
        end
      end
    end

    def find_attr_end(content)
      # Attribute ends at: next :, next |, end of line
      pos = 1
      in_string = false
      string_char = nil
      in_list = false

      while pos < content.length
        char = content[pos]

        if in_string
          in_string = false if char == string_char
        elsif in_list
          in_list = false if char == ']'
        elsif char == '"' || char == "'"
          in_string = true
          string_char = char
        elsif char == '['
          in_list = true
        elsif char == ' ' && pos + 1 < content.length
          next_char = content[pos + 1]
          return pos if next_char == ':' || next_char == '|'
        end

        pos += 1
      end

      content.length
    end

    def find_inline_element_end(content)
      # Find where inline element ends (next | or end)
      pos = 1
      while pos < content.length
        return pos if content[pos] == '|' && content[pos - 1] == ' '
        pos += 1
      end
      content.length
    end

    def find_embedded_close(content)
      # Find matching } for |{, handling nesting
      depth = 0
      pos = 0
      while pos < content.length
        if content[pos..pos + 1] == '|{'
          depth += 1
          pos += 2
        elsif content[pos] == '}'
          depth -= 1
          return pos if depth == 0
          pos += 1
        else
          pos += 1
        end
      end
      nil
    end

    def validate_embedded(content)
      @result.feature!(:embedded_element)
      @result.stat!(:embedded_elements)

      # Basic validation: |{name ...}
      unless content.start_with?('|{')
        @result.error!(@line_num, 0, "Invalid embedded element syntax")
        return
      end

      inner = content[2..-2]  # Remove |{ and }
      return if inner.nil? || inner.empty?

      # Check for element name or attributes
      if inner.match?(/\A\s*#{LABEL_PATTERN}/)
        @result.feature!(:embedded_with_name)
      end

      # Check for nested embedded
      if inner.include?('|{')
        @result.feature!(:nested_embedded)
      end

      # Check for attributes in embedded
      if inner.include?(':')
        @result.feature!(:embedded_with_attrs)
      end
    end

    def validate_attribute(content, indent)
      @result.stat!(:attributes)
      @result.feature!(:attribute)

      # Parse :key value or :[id] reference
      unless content.start_with?(':')
        @result.error!(@line_num, 1, "Attribute must start with :")
        return
      end

      rest = content[1..]

      # Check for :[id] reference syntax
      if rest.start_with?('[')
        @result.feature!(:id_reference)
        @result.stat!(:id_references)
        end_bracket = rest.index(']')
        if end_bracket
          return  # Valid reference, done
        else
          @result.error!(@line_num, 2, "Unclosed :[id] reference")
          return
        end
      end

      key_match = rest.match(/\A#{LABEL_PATTERN}/)

      unless key_match
        @result.error!(@line_num, 2, "Invalid attribute key")
        return
      end

      key = key_match[0]
      value_start = key.length
      value = rest[value_start..]&.strip

      if value.nil? || value.empty?
        @result.feature!(:flag_attribute)
        @result.stat!(:flags)
        return
      end

      validate_value(value)
    end

    def validate_value(value)
      return if value.nil? || value.empty?

      case value
      when /\A".*"\z/, /\A'.*'\z/
        @result.feature!(:quoted_string)
        @result.stat!(:strings)
      when /\A\[.*\]\z/
        @result.feature!(:list_value)
        @result.stat!(:lists)
      when 'true', 'false'
        @result.feature!(:boolean_value)
        @result.stat!(:booleans)
      when 'null', 'nil', '~'
        @result.feature!(:nil_value)
        @result.stat!(:nils)
      when /\A-?\d+\z/
        @result.feature!(:integer_value)
        @result.stat!(:integers)
      when /\A-?\d+\.\d+/
        @result.feature!(:float_value)
        @result.stat!(:floats)
      when /\A0x[0-9a-fA-F_]+\z/
        @result.feature!(:hex_value)
        @result.stat!(:hex_numbers)
      when /\A\|\{/
        @result.feature!(:inline_element_value)
      else
        @result.feature!(:unquoted_string)
        @result.stat!(:strings)
      end
    end

    def validate_dynamic(content, indent)
      @result.stat!(:dynamics)
      @result.feature!(:dynamic)

      rest = content[1..]

      if rest.start_with?('{')
        @result.feature!(:interpolation)
        @result.stat!(:interpolations)

        unless rest.include?('}')
          @result.error!(@line_num, 0, "Unclosed interpolation !{...}")
        end

        if rest.include?('|')
          @result.feature!(:filter)
          @result.stat!(:filters)
        end
      elsif rest.start_with?('if')
        @result.feature!(:conditional)
        @result.stat!(:conditionals)
      elsif rest.start_with?('elif')
        @result.feature!(:conditional)
      elsif rest.start_with?('else')
        @result.feature!(:conditional)
      elsif rest.start_with?('for')
        @result.feature!(:loop)
        @result.stat!(:loops)
      elsif rest.start_with?('let')
        @result.feature!(:let_binding)
        @result.stat!(:let_bindings)
      elsif rest.start_with?('include')
        @result.feature!(:include)
        @result.stat!(:includes)
      elsif rest.start_with?('code')
        @result.feature!(:code_block)
        @result.stat!(:code_blocks)
      else
        @result.feature!(:custom_directive)
      end
    end

    def validate_comment(content)
      @result.stat!(:comments)
      @result.feature!(:comment)
    end

    def validate_escape(content)
      @result.stat!(:escapes)
      @result.feature!(:escape)

      if content.length < 2
        @result.error!(@line_num, 1, "Escape prefix ' must be followed by a character")
      end
    end

    def validate_prose(content, indent)
      @result.stat!(:prose_lines)
      @result.feature!(:prose)

      # Check for embedded elements in prose
      if content.include?('|{')
        @result.feature!(:prose_with_embedded)

        # Validate each embedded element
        pos = 0
        while (start = content.index('|{', pos))
          close = find_embedded_close(content[start..])
          if close
            validate_embedded(content[start..(start + close)])
            pos = start + close + 1
          else
            # Multi-line embedded element - valid UDON, skip without warning
            break
          end
        end
      end

      # Check for unescaped | that might be an element
      if content =~ /(?<!\|)\|(?!\{)[a-z]/i
        @result.warn!(@line_num, 0, "Possible unintended element in prose (use '| to escape)")
      end

      # Lint: multiple extra } suggests typo like |{em text}}
      # Single extra } might be closing a multi-line element from previous line
      embedded_opens = content.scan(/\|\{/).size
      dynamic_opens = content.scan(/!\{/).size
      all_closes = content.scan(/\}/).size
      expected_closes = embedded_opens + dynamic_opens
      extra = all_closes - expected_closes
      if extra > 0 && embedded_opens > 0
        @result.warn!(@line_num, 0, "Extra } - possibly confused nested closing (like LaTeX, each |{ needs exactly one })")
      end
    end

    def check_indent(indent)
      # Basic indent validation
      if indent > @indent_stack.last + 4
        @result.warn!(@line_num, 0, "Large indent jump (#{@indent_stack.last} → #{indent})")
      end

      if indent > @indent_stack.last
        @indent_stack.push(indent)
      elsif indent < @indent_stack.last
        while @indent_stack.last > indent && @indent_stack.size > 1
          @indent_stack.pop
        end
      end
    end
  end

  def self.validate(input)
    Validator.new.validate(input)
  end

  def self.validate_file(path)
    validate(File.read(path))
  end
end

# CLI
if __FILE__ == $0
  if ARGV.empty?
    puts "Usage: ruby udon_validator.rb <file.udon>"
    puts "       echo 'udon' | ruby udon_validator.rb -"
    exit 1
  end

  input = if ARGV[0] == '-'
            $stdin.read
          else
            File.read(ARGV[0])
          end

  result = UdonValidator.validate(input)
  puts result.summary

  exit(result.valid ? 0 : 1)
end
