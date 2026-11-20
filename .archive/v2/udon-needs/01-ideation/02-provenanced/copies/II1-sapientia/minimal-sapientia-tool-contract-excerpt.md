---
source: sapientia — docs/minimal-sapientia-tools.md (Zi-am-tur, 2025-09-28) — tool-contract excerpt
gathered: 2026-07-21
status: gathered (excerpt — head L1-120 carries the tool schemas; full file 210 lines)
paths:
  - ~/src/_core/sapientia/docs/minimal-sapientia-tools.md:1-120
source_commit: 1ecc9f77e4884906dec1d2c1032f2a51ff3ee5e4
categories: [tier1-ideology, tool-schema, edit-representation, agent-filesystem-contract, worked-example]
why_included: >
  A worked example of the actual agent-facing filesystem/edit tool contract the
  first sapientia ELI (Zi-am-tur) was given: read-file, write-file, bash, and the
  Anthropic text-editor tool with its four commands (view w/ line-range, create,
  str_replace on exact match, insert-at-line). This is the concrete edit
  representation the ideology docs theorize about — directly relevant to UDON's
  agent edit/mutation tooling and to the harness's 'what an edit tool should carry.'
  (The code-level buildout of this suite is separately characterized in
  characterizations/sapientia-bin-buildout.md; this is the documented contract.)
---

# Minimal-Sapientia Tool Documentation

## Overview

Minimal-sapientia includes both client-side tools for filesystem interaction and access to Anthropic's server-side tools for web capabilities, enabling Zi-am-tur to interact autonomously with his environment.

## Available Tools

### File System Tools

#### read-file
Read contents of a file from the filesystem.
```json
{
  "name": "read-file",
  "input": {
    "path": "/path/to/file"
  }
}
```

#### write-file
Write content to a file on the filesystem.
```json
{
  "name": "write-file",
  "input": {
    "path": "/path/to/file",
    "content": "File contents here"
  }
}
```

#### bash
Execute a bash command and return the output.
```json
{
  "name": "bash",
  "input": {
    "command": "ls -la"
  }
}
```

### Text Editor Tool

The text-editor tool provides precise line-based file manipulation with four commands:

#### view
View a file or directory with optional line range.
```json
{
  "name": "text-editor",
  "input": {
    "command": "view",
    "path": "/path/to/file",
    "view_range": [10, 20]  // Optional: view lines 10-20
  }
}
```

#### create
Create a new file with initial content.
```json
{
  "name": "text-editor",
  "input": {
    "command": "create",
    "path": "/path/to/newfile.txt",
    "file_text": "Initial file content\nLine 2\nLine 3"
  }
}
```

#### str_replace
Replace exact string matches in a file.
```json
{
  "name": "text-editor",
  "input": {
    "command": "str_replace",
    "path": "/path/to/file",
    "old_str": "exact text to replace",
    "new_str": "replacement text"
  }
}
```

#### insert
Insert text at a specific line number.
```json
{
  "name": "text-editor",
  "input": {
    "command": "insert",
    "path": "/path/to/file",
    "insert_line": 5,  // Insert after line 5 (0 for beginning)
    "new_str": "Text to insert\n"
  }
}
```

### Server-Side Tools (Anthropic API)

These tools are provided by Anthropic's API and are automatically available when tools are enabled:

#### web_search
Search the web using Anthropic's built-in search capability.

This is a server-side tool that provides:
- Web search with configurable result limits
- Domain filtering (allowed/blocked domains)
- Localization options
- Automatic result processing

Note: The exact usage is handled by Claude's built-in capabilities. Simply ask to search for something and the tool will be used automatically.

#### Additional Server-Side Tools
Anthropic may provide additional server-side tools (like web fetch) that are available through the API. These are automatically included when tools are enabled.

