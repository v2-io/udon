/**
 * External scanner for tree-sitter-udon
 *
 * Handles:
 * - INDENT/DEDENT tracking (Python-style)
 * - Raw block content (after !:lang:)
 * - Freeform content (between ```)
 * - NEWLINE tracking
 *
 * This is a simplified scanner for syntax highlighting purposes.
 * It doesn't track precise column positions for inline element nesting.
 */

#include "tree_sitter/parser.h"
#include <wctype.h>
#include <string.h>
#include <stdio.h>

// Token types (must match externals in grammar.js)
enum TokenType {
  INDENT,
  DEDENT,
  NEWLINE,
  RAW_BLOCK_CONTENT,
  FREEFORM_CONTENT,
  END_OF_FILE,
};

// Maximum indent stack depth
#define MAX_INDENT_DEPTH 256

// Scanner state
typedef struct {
  // Indent tracking
  uint16_t indent_stack[MAX_INDENT_DEPTH];
  uint8_t indent_depth;

  // Pending dedents to emit
  uint8_t pending_dedents;

  // Freeform fence tracking
  bool in_freeform;
  uint16_t freeform_open_column;

  // Raw block tracking
  bool in_raw_block;
  uint16_t raw_block_base_column;
} Scanner;

// ============================================================================
// Utility Functions
// ============================================================================

static inline void advance(TSLexer *lexer) {
  lexer->advance(lexer, false);
}

static inline void skip(TSLexer *lexer) {
  lexer->advance(lexer, true);
}

static inline bool is_eof(TSLexer *lexer) {
  return lexer->eof(lexer);
}

static uint16_t get_column(TSLexer *lexer) {
  return lexer->get_column(lexer);
}

// Count leading spaces on a line (tabs are errors in UDON, but we handle them)
static uint16_t count_indent(TSLexer *lexer) {
  uint16_t indent = 0;
  while (lexer->lookahead == ' ' || lexer->lookahead == '\t') {
    if (lexer->lookahead == '\t') {
      // UDON doesn't allow tabs, but handle gracefully
      indent += 8 - (indent % 8);  // Tab to next 8-column boundary
    } else {
      indent++;
    }
    skip(lexer);
  }
  return indent;
}

// Skip to end of line (including the newline)
static void skip_to_eol(TSLexer *lexer) {
  while (!is_eof(lexer) && lexer->lookahead != '\n') {
    advance(lexer);
  }
  if (lexer->lookahead == '\n') {
    advance(lexer);
  }
}

// Check if we're looking at ```
static bool looking_at_backticks(TSLexer *lexer) {
  if (lexer->lookahead != '`') return false;
  lexer->mark_end(lexer);
  advance(lexer);
  if (lexer->lookahead != '`') return false;
  advance(lexer);
  if (lexer->lookahead != '`') return false;
  return true;
}

// ============================================================================
// Scanner Functions
// ============================================================================

void *tree_sitter_udon_external_scanner_create() {
  Scanner *scanner = calloc(1, sizeof(Scanner));
  scanner->indent_stack[0] = 0;
  scanner->indent_depth = 1;
  return scanner;
}

void tree_sitter_udon_external_scanner_destroy(void *payload) {
  free(payload);
}

unsigned tree_sitter_udon_external_scanner_serialize(void *payload, char *buffer) {
  Scanner *scanner = (Scanner *)payload;
  unsigned size = 0;

  // Serialize indent stack
  buffer[size++] = scanner->indent_depth;
  for (uint8_t i = 0; i < scanner->indent_depth && i < MAX_INDENT_DEPTH; i++) {
    buffer[size++] = scanner->indent_stack[i] & 0xFF;
    buffer[size++] = (scanner->indent_stack[i] >> 8) & 0xFF;
  }

  // Serialize other state
  buffer[size++] = scanner->pending_dedents;
  buffer[size++] = scanner->in_freeform;
  buffer[size++] = scanner->freeform_open_column & 0xFF;
  buffer[size++] = (scanner->freeform_open_column >> 8) & 0xFF;
  buffer[size++] = scanner->in_raw_block;
  buffer[size++] = scanner->raw_block_base_column & 0xFF;
  buffer[size++] = (scanner->raw_block_base_column >> 8) & 0xFF;

  return size;
}

void tree_sitter_udon_external_scanner_deserialize(void *payload, const char *buffer, unsigned length) {
  Scanner *scanner = (Scanner *)payload;

  // Reset to defaults
  scanner->indent_stack[0] = 0;
  scanner->indent_depth = 1;
  scanner->pending_dedents = 0;
  scanner->in_freeform = false;
  scanner->freeform_open_column = 0;
  scanner->in_raw_block = false;
  scanner->raw_block_base_column = 0;

  if (length == 0) return;

  unsigned pos = 0;

  // Deserialize indent stack
  scanner->indent_depth = buffer[pos++];
  for (uint8_t i = 0; i < scanner->indent_depth && pos + 1 < length; i++) {
    scanner->indent_stack[i] = (uint8_t)buffer[pos] | ((uint8_t)buffer[pos + 1] << 8);
    pos += 2;
  }

  // Deserialize other state
  if (pos < length) scanner->pending_dedents = buffer[pos++];
  if (pos < length) scanner->in_freeform = buffer[pos++];
  if (pos + 1 < length) {
    scanner->freeform_open_column = (uint8_t)buffer[pos] | ((uint8_t)buffer[pos + 1] << 8);
    pos += 2;
  }
  if (pos < length) scanner->in_raw_block = buffer[pos++];
  if (pos + 1 < length) {
    scanner->raw_block_base_column = (uint8_t)buffer[pos] | ((uint8_t)buffer[pos + 1] << 8);
    pos += 2;
  }
}

// Main scan function
bool tree_sitter_udon_external_scanner_scan(
  void *payload,
  TSLexer *lexer,
  const bool *valid_symbols
) {
  Scanner *scanner = (Scanner *)payload;

  // Handle pending dedents first
  if (scanner->pending_dedents > 0 && valid_symbols[DEDENT]) {
    scanner->pending_dedents--;
    lexer->result_symbol = DEDENT;
    return true;
  }

  // Handle EOF
  if (is_eof(lexer)) {
    // Emit dedents for remaining indent levels
    if (scanner->indent_depth > 1 && valid_symbols[DEDENT]) {
      scanner->indent_depth--;
      lexer->result_symbol = DEDENT;
      return true;
    }
    if (valid_symbols[END_OF_FILE]) {
      lexer->result_symbol = END_OF_FILE;
      return true;
    }
    return false;
  }

  // -------------------------------------------------------------------------
  // Freeform content handling
  // -------------------------------------------------------------------------
  if (scanner->in_freeform && valid_symbols[FREEFORM_CONTENT]) {
    lexer->result_symbol = FREEFORM_CONTENT;
    lexer->mark_end(lexer);

    while (!is_eof(lexer)) {
      // Check for closing ```
      if (lexer->lookahead == '`') {
        uint16_t col = get_column(lexer);
        if (col <= scanner->freeform_open_column && looking_at_backticks(lexer)) {
          // Found closing fence - don't include it in content
          scanner->in_freeform = false;
          return true;
        }
      }

      // Consume content
      advance(lexer);
      lexer->mark_end(lexer);
    }

    // EOF inside freeform - return what we have
    scanner->in_freeform = false;
    return true;
  }

  // -------------------------------------------------------------------------
  // Raw block content handling
  // -------------------------------------------------------------------------
  if (scanner->in_raw_block && valid_symbols[RAW_BLOCK_CONTENT]) {
    lexer->result_symbol = RAW_BLOCK_CONTENT;
    lexer->mark_end(lexer);

    // Skip initial newline if present
    if (lexer->lookahead == '\n') {
      advance(lexer);
    }

    bool found_content = false;

    while (!is_eof(lexer)) {
      // At start of line, check indentation
      uint16_t line_indent = count_indent(lexer);

      // If we've dedented to or past the base, we're done
      if (lexer->lookahead != '\n' && line_indent <= scanner->raw_block_base_column) {
        scanner->in_raw_block = false;
        return found_content;
      }

      // Consume the rest of the line
      while (!is_eof(lexer) && lexer->lookahead != '\n') {
        advance(lexer);
        found_content = true;
      }
      lexer->mark_end(lexer);

      // Consume newline
      if (lexer->lookahead == '\n') {
        advance(lexer);
        lexer->mark_end(lexer);
      }
    }

    scanner->in_raw_block = false;
    return found_content;
  }

  // -------------------------------------------------------------------------
  // At start of line - handle indentation
  // -------------------------------------------------------------------------
  if (get_column(lexer) == 0) {
    uint16_t indent = count_indent(lexer);

    // Skip blank lines
    if (lexer->lookahead == '\n') {
      if (valid_symbols[NEWLINE]) {
        advance(lexer);
        lexer->result_symbol = NEWLINE;
        return true;
      }
      return false;
    }

    // Skip comment-only lines for indent purposes?
    // For now, let them participate in indentation like UDON spec says

    uint16_t current_indent = scanner->indent_stack[scanner->indent_depth - 1];

    // Check for freeform opening
    if (lexer->lookahead == '`' && looking_at_backticks(lexer)) {
      scanner->in_freeform = true;
      scanner->freeform_open_column = indent;
      // Let the grammar handle the ``` token
      return false;
    }

    // Check for raw block opening (!:)
    if (lexer->lookahead == '!' && valid_symbols[RAW_BLOCK_CONTENT]) {
      // Peek ahead to see if it's !:lang:
      // Actually, let the grammar handle this - we just need to know
      // when to capture raw content
    }

    // INDENT
    if (indent > current_indent) {
      if (valid_symbols[INDENT]) {
        if (scanner->indent_depth < MAX_INDENT_DEPTH) {
          scanner->indent_stack[scanner->indent_depth++] = indent;
        }
        lexer->result_symbol = INDENT;
        return true;
      }
    }

    // DEDENT (possibly multiple)
    if (indent < current_indent) {
      if (valid_symbols[DEDENT]) {
        // Count how many levels to dedent
        while (scanner->indent_depth > 1 &&
               scanner->indent_stack[scanner->indent_depth - 1] > indent) {
          scanner->indent_depth--;
          scanner->pending_dedents++;
        }

        // Emit first dedent now, rest are pending
        if (scanner->pending_dedents > 0) {
          scanner->pending_dedents--;
          lexer->result_symbol = DEDENT;
          return true;
        }
      }
    }

    // Same indent level - no token needed
    return false;
  }

  // -------------------------------------------------------------------------
  // NEWLINE handling (not at column 0)
  // -------------------------------------------------------------------------
  if (lexer->lookahead == '\n' && valid_symbols[NEWLINE]) {
    advance(lexer);
    lexer->result_symbol = NEWLINE;
    return true;
  }

  return false;
}
