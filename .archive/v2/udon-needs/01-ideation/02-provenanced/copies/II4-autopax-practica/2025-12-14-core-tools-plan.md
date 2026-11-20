---
source: 2025-12-14-core-tools-plan.md (autopax/practica ideology corpus, Part II sec 4)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/autopax/docs/tactical/2025-12-14-core-tools-plan.md
source_commit: 033af13c5ca686ca5898645f6dc772e4435c0523
categories: [tool-suite, implementation-plan, edit-tools, feature-parity]
why_included: >
  Dec 14 2025. Implementation plan for the core file/shell tools "to achieve feature parity with Claude Code" -- the concrete tool-by-tool design behind ADR-013. Shipped-practice witness of exactly which agent tools were judged the minimum set.
---

---
Status: "WORKING MODEL (not canonical)"
Date: 2025-12-14
Author: "Claude-5282599b"
Epistemic Level: Pattern
Purpose: Plan for implementing core INSTRUMENTA tools
---

# Core Tools Implementation Plan - THINKING ARTIFACT

## Context

Implementing core file system and shell tools for INSTRUMENTA to achieve
feature parity with Claude Code. These tools are the foundation for entity
agency - allowing entities to read, write, and manipulate files and execute
commands.

## Tools to Implement

Based on Claude Code's tool design patterns:

### 1. read-file

**Purpose:** Read file contents with optional line range.

**Schema:**
```ruby
tool_schema(
  type: 'object',
  properties: {
    file_path: { type: 'string', description: 'Absolute path to file' },
    offset: { type: 'integer', description: 'Line number to start (1-indexed)' },
    limit: { type: 'integer', description: 'Number of lines to read' }
  },
  required: ['file_path']
)
```

**Key behaviors:**
- Returns line-numbered output (like `cat -n`)
- Handles binary files gracefully (detect and warn)
- Supports image/PDF reading (future: multimodal)
- Default limit ~2000 lines for large files

### 2. write-file

**Purpose:** Create or overwrite a file with content.

**Schema:**
```ruby
tool_schema(
  type: 'object',
  properties: {
    file_path: { type: 'string', description: 'Absolute path' },
    content: { type: 'string', description: 'Content to write' }
  },
  required: ['file_path', 'content']
)
```

**Key behaviors:**
- Creates parent directories if needed
- Preserves file permissions when overwriting
- Warns before overwriting (via instruction guidance)

### 3. edit

**Purpose:** Make targeted edits by replacing exact strings.

**Schema:**
```ruby
tool_schema(
  type: 'object',
  properties: {
    file_path: { type: 'string', description: 'Absolute path' },
    old_string: { type: 'string', description: 'Text to replace' },
    new_string: { type: 'string', description: 'Replacement text' },
    replace_all: { type: 'boolean', description: 'Replace all occurrences', default: false }
  },
  required: ['file_path', 'old_string', 'new_string']
)
```

**Key behaviors:**
- Requires unique match (or replace_all: true)
- Shows context around edit for verification
- Critical for surgical file modifications
- Must preserve exact whitespace/indentation

### 4. bash

**Purpose:** Execute shell commands with timeout and safety.

**Schema:**
```ruby
tool_schema(
  type: 'object',
  properties: {
    command: { type: 'string', description: 'Command to execute' },
    timeout: { type: 'integer', description: 'Timeout in ms', default: 30000 },
    description: { type: 'string', description: 'What this command does' }
  },
  required: ['command']
)
```

**Key behaviors:**
- Timeout protection (default 30s, max 6 min)
- Truncate long output (~30000 chars)
- Capture both stdout and stderr
- Return exit code
- Audit logging (per ADR-013)

### 5. glob

**Purpose:** Find files by pattern.

**Schema:**
```ruby
tool_schema(
  type: 'object',
  properties: {
    pattern: { type: 'string', description: 'Glob pattern (e.g., "**/*.rb")' },
    path: { type: 'string', description: 'Base directory' }
  },
  required: ['pattern']
)
```

**Key behaviors:**
- Support recursive patterns (`**`)
- Sort by modification time (most recent first)
- Use Ruby's Dir.glob

### 6. grep

**Purpose:** Search file contents with regex.

**Schema:**
```ruby
tool_schema(
  type: 'object',
  properties: {
    pattern: { type: 'string', description: 'Regex pattern' },
    path: { type: 'string', description: 'File or directory to search' },
    glob: { type: 'string', description: 'Filter files by glob' },
    output_mode: {
      type: 'string',
      enum: ['content', 'files_with_matches', 'count'],
      default: 'files_with_matches'
    }
  },
  required: ['pattern']
)
```

**Key behaviors:**
- Use ripgrep (`rg`) if available, fallback to Ruby grep
- Support context lines (-A, -B, -C)
- Multiple output modes
- File type filtering

## Implementation Order

1. **read-file** - Foundation for all file operations
2. **write-file** - Pairs with read-file
3. **edit** - Most sophisticated, needs careful design
4. **glob** - Simple, uses Ruby stdlib
5. **grep** - Can shell out to rg
6. **bash** - Most complex (timeout, safety, audit)

## Design Decisions

### Absolute vs Relative Paths

All tools require absolute paths. This:
- Avoids ambiguity about working directory
- Makes audit trails clearer
- Matches Claude Code behavior

### Error Handling

Return structured results:
```ruby
{ success: true, result: ... }
{ success: false, error: '...' }
```

### Line Numbering

read-file uses 1-indexed line numbers to match editor conventions.
Output format: `     1→content here`

### Edit Uniqueness

The edit tool fails if old_string isn't unique (unless replace_all: true).
This prevents accidental mass changes and ensures surgical precision.

## Security Considerations

Per ADR-013:
- Bash has audit logging enabled by default
- Full file access for now (no path restrictions)
- Future: card-based tool permissions

## Testing Strategy

Each tool needs:
1. Unit specs for handler logic
2. Integration specs with real files (in tmp/)
3. Edge cases (binary files, permissions, timeouts)

## Files to Create

```
lib/autopax/instrumenta/handlers/
├── read_file.rb
├── write_file.rb
├── edit.rb
├── bash.rb
├── glob.rb
└── grep.rb

lib/autopax/instrumenta/instructions/
├── read-file.md
├── write-file.md
├── edit.md
├── bash.md
├── glob.md
└── grep.md

spec/autopax/instrumenta/handlers/
├── read_file_spec.rb
├── write_file_spec.rb
├── edit_spec.rb
├── bash_spec.rb
├── glob_spec.rb
└── grep_spec.rb
```
