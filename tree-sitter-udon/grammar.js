/**
 * Tree-sitter grammar for UDON (Universal Document & Object Notation)
 *
 * This grammar is designed for syntax highlighting, not full structural parsing.
 * It uses Python-style indent tracking rather than UDON's precise column semantics.
 *
 * Based on FULL-SPEC.md v0.7-draft (December 2025)
 */

// Precedence levels
const PREC = {
  ELEMENT: 10,
  ATTRIBUTE: 5,
  VALUE: 1,
};

module.exports = grammar({
  name: 'udon',

  externals: $ => [
    $._indent,
    $._dedent,
    $._newline,
    $.raw_block_content,
    $.freeform_content,
    $._eof,
  ],

  extras: $ => [
    /[ \t]/,
  ],

  word: $ => $.identifier,

  conflicts: $ => [
    [$.element],
    [$._named_element],
    [$._id_element],
    [$._class_element],
    [$.sameline_content],
    [$.prose],
    [$.block_attribute],
    [$.sameline_attribute],
    [$.embedded_attribute],
  ],

  rules: {
    // =========================================================================
    // Document Structure
    // =========================================================================

    document: $ => repeat($._block_item),

    _block_item: $ => choice(
      $.element,
      $.block_attribute,
      $.block_directive,
      $.raw_block,
      $.line_comment,
      $.block_escape,
      $.freeform_block,
      $.prose,
      $._newline,
    ),

    block: $ => seq(
      $._indent,
      repeat1($._block_item),
      $._dedent,
    ),

    // =========================================================================
    // Elements - Simplified structure
    // =========================================================================

    // Element: |name[id].class.class :attr value content
    // UDON requires an element to start with name, [id], or .class
    // We use separate rules to avoid ambiguity
    element: $ => prec(PREC.ELEMENT, choice(
      // Named element: |name...
      $._named_element,
      // Anonymous with id: |[id]...
      $._id_element,
      // Anonymous with class: |.class...
      $._class_element,
    )),

    _named_element: $ => prec.right(seq(
      '|',
      $.element_name,
      optional($.element_suffix),
      optional($.element_id),
      optional($.element_suffix),
      repeat($.element_class),
      repeat($.sameline_attribute),
      optional($.sameline_content),
      optional($.block),
    )),

    _id_element: $ => seq(
      '|',
      $.element_id,
      optional($.element_suffix),
      repeat($.element_class),
      repeat($.sameline_attribute),
      optional($.sameline_content),
      optional($.block),
    ),

    _class_element: $ => seq(
      '|',
      repeat1($.element_class),
      repeat($.sameline_attribute),
      optional($.sameline_content),
      optional($.block),
    ),

    element_name: $ => choice(
      $.identifier,
      $.quoted_identifier,
    ),

    element_id: $ => seq(
      '[',
      optional($._bracket_value),
      ']',
    ),

    element_class: $ => seq(
      token.immediate('.'),
      $.identifier,
    ),

    element_suffix: $ => choice('?', '*', '+'),
    // Note: '!' removed from suffix to avoid conflict with directives

    // Embedded element: |{name[id].class :attr value content}
    embedded_element: $ => seq(
      '|{',
      optional($._embedded_identity),
      repeat($.embedded_attribute),
      optional($.embedded_content),
      '}',
    ),

    _embedded_identity: $ => choice(
      seq(
        $.element_name,
        optional($.element_suffix),
        optional($.element_id),
        repeat($.element_class),
      ),
      seq(
        $.element_id,
        optional($.element_suffix),
        repeat($.element_class),
      ),
      repeat1($.element_class),
    ),

    // =========================================================================
    // Attributes
    // =========================================================================

    block_attribute: $ => seq(
      ':',
      field('key', $.attribute_key),
      optional(field('value', $._block_attr_value)),
    ),

    sameline_attribute: $ => prec(PREC.ATTRIBUTE, seq(
      ':',
      field('key', $.attribute_key),
      optional(field('value', $._sameline_attr_value)),
    )),

    embedded_attribute: $ => seq(
      ':',
      field('key', $.attribute_key),
      optional(field('value', $._embedded_attr_value)),
    ),

    attribute_key: $ => choice(
      $.identifier,
      $.quoted_identifier,
    ),

    // =========================================================================
    // Values by Context
    // =========================================================================

    _block_attr_value: $ => choice(
      $.nil_value,
      $.boolean,
      $.number,
      $.list,
      $.interpolation,
      $.quoted_string,
      $.block_bare_string,
      $.block,
    ),

    _sameline_attr_value: $ => choice(
      $.nil_value,
      $.boolean,
      $.number,
      $.list,
      $.interpolation,
      $.quoted_string,
      $.sameline_bare_string,
    ),

    _embedded_attr_value: $ => choice(
      $.nil_value,
      $.boolean,
      $.number,
      $.list,
      $.interpolation,
      $.quoted_string,
      $.embedded_bare_string,
    ),

    _bracket_value: $ => choice(
      $.nil_value,
      $.boolean,
      $.number,
      $.interpolation,
      $.quoted_string,
      $.bracket_bare_string,
    ),

    _array_item: $ => choice(
      $.nil_value,
      $.boolean,
      $.number,
      $.list,
      $.interpolation,
      $.quoted_string,
      $.array_bare_string,
    ),

    // =========================================================================
    // Scalar Types
    // =========================================================================

    nil_value: $ => choice('null', 'nil'),

    boolean: $ => choice('true', 'false'),

    number: $ => token(choice(
      // Float with decimal
      seq(optional('-'), /[0-9][0-9_]*/, '.', /[0-9][0-9_]*/, optional(seq(/[eE]/, optional(/[+-]/), /[0-9]+/))),
      // Scientific notation without decimal
      seq(optional('-'), /[0-9][0-9_]*/, /[eE]/, optional(/[+-]/), /[0-9]+/),
      // Hex
      seq(optional('-'), '0x', /[0-9a-fA-F][0-9a-fA-F_]*/),
      // Octal
      seq(optional('-'), '0o', /[0-7][0-7_]*/),
      // Binary
      seq(optional('-'), '0b', /[01][01_]*/),
      // Rational
      seq(optional('-'), /[0-9][0-9_]*/, '/', /[0-9][0-9_]*/, 'r'),
      // Complex (simplified)
      seq(optional('-'), /[0-9][0-9_]*/, optional(seq('.', /[0-9][0-9_]*/)), /[+-]/, /[0-9][0-9_]*/, optional(seq('.', /[0-9][0-9_]*/)), 'i'),
      seq(/[0-9][0-9_]*/, optional(seq('.', /[0-9][0-9_]*/)), 'i'),
      // Plain integer
      seq(optional('-'), /[0-9][0-9_]*/),
    )),

    list: $ => seq(
      '[',
      repeat($._array_item),
      ']',
    ),

    // =========================================================================
    // Strings
    // =========================================================================

    quoted_string: $ => choice(
      seq('"', repeat(choice(/[^"\\]+/, $.escape_sequence)), '"'),
      seq("'", repeat(/[^'\\]+|\\./), "'"),
    ),

    escape_sequence: $ => token(seq('\\', choice(
      /[\\'"0nrtbfv]/,
      /x[0-9a-fA-F]{2}/,
      /u[0-9a-fA-F]{4}/,
      /u\{[0-9a-fA-F]+\}/,
    ))),

    // Bare strings - different terminators per context
    block_bare_string: $ => /[^\n;][^\n]*|[^\n ]*;[^\n]*/,
    sameline_bare_string: $ => /[^ \t\n:\[\];|]+/,
    embedded_bare_string: $ => /[^ \t\n:\[\];|}]+/,
    bracket_bare_string: $ => /[^\]\n \t]+/,
    array_bare_string: $ => /[^ \t\n\[\]]+/,

    quoted_identifier: $ => seq("'", /[^'\n]+/, "'"),

    // =========================================================================
    // Dynamics
    // =========================================================================

    block_directive: $ => seq(
      '!',
      $.directive_name,
      optional($.directive_args),
      optional($.block),
    ),

    raw_block: $ => seq(
      '!:',
      field('language', $.identifier),
      ':',
      $.raw_block_content,
    ),

    directive_name: $ => $.identifier,
    directive_args: $ => /[^\n]+/,

    interpolation: $ => seq(
      '!{{',
      optional($.expression),
      repeat($.filter),
      '}}',
    ),

    expression: $ => /[^|}]+/,

    filter: $ => seq(
      '|',
      $.filter_name,
      optional($.filter_args),
    ),

    filter_name: $ => $.identifier,
    filter_args: $ => /[^|}]+/,

    inline_directive: $ => seq(
      '!{',
      choice(
        seq(':', $.identifier, ':', /[^}]*/),
        seq($.directive_name, optional(/[^}]*/)),
      ),
      '}',
    ),

    // =========================================================================
    // Comments
    // =========================================================================

    line_comment: $ => seq(';', optional(/[^\n]*/)),

    inline_comment: $ => seq(
      ';{',
      optional($._brace_content),
      '}',
    ),

    _brace_content: $ => repeat1(choice(
      /[^{}]+/,
      seq('{', optional($._brace_content), '}'),
    )),

    // =========================================================================
    // Content
    // =========================================================================

    sameline_content: $ => repeat1(choice(
      $.embedded_element,
      $.inline_directive,
      $.interpolation,
      $.inline_comment,
      $.sameline_text,
    )),

    embedded_content: $ => repeat1(choice(
      $.embedded_element,
      $.inline_directive,
      $.interpolation,
      $.inline_comment,
      $.embedded_text,
    )),

    prose: $ => repeat1(choice(
      $.embedded_element,
      $.inline_directive,
      $.interpolation,
      $.inline_comment,
      $.prose_text,
    )),

    // Text content - excludes special characters that start other constructs
    // Exclude spaces so they're handled as extras, allowing attributes to match
    // Exclude [ : . to allow element_id, attributes, and classes to match
    sameline_text: $ => /[^ \t|\n;!\[:\].]+/,
    embedded_text: $ => /[^ \t|};!\[:\].]+/,
    prose_text: $ => /[^ \t|\n;!\[:.]+/,

    // =========================================================================
    // Escapes and Special
    // =========================================================================

    block_escape: $ => seq(
      choice("'", '\\'),
      choice('|', ';', ':', '!', "'"),
      optional(/[^\n]*/),
    ),

    freeform_block: $ => seq(
      '```',
      optional($.freeform_language),
      $.freeform_content,
      '```',
    ),

    freeform_language: $ => $.identifier,

    // =========================================================================
    // Identifiers
    // =========================================================================

    identifier: $ => /[\p{L}][\p{L}\p{N}_-]*/u,
  },
});
