---
source: 2025-12-14-tool-definition-anatomy.md (autopax/practica ideology corpus, Part II sec 4)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/autopax/docs/tactical/2025-12-14-tool-definition-anatomy.md
source_commit: 033af13c5ca686ca5898645f6dc772e4435c0523
categories: [tool-schema, tool-description, hybrid-design, edit-tools, cross-tier]
why_included: >
  Dec 14 2025 (Claude-5282599b). Reverse-engineers Claude Code's own tool definitions (Read/Bash/Grep/Edit/Task) into three parts -- name / JSON-schema / free-text description -- with a schema-to-description ratio table (Bash ~1:10) and argues a hybrid design: schema in code, execution in code, guidance in a separate markdown file with templating. This is the exact "how should an agent tool be specified" question UDON utilities and any harness tool-registry face; a primary-source read of a shipped harness's tool contract.
---

---
Status: "WORKING MODEL (not canonical)"
Date: 2025-12-14
Author: "Claude-5282599b"
Epistemic Level: Pattern (observed from my own tool access)
Purpose: Understand tool definition structure by examining my own tools
---

# Tool Definition Anatomy - From Claude's Perspective

This document captures what I can observe about my own tool definitions to inform
INSTRUMENTA architectural decisions. The key question: **how much is structured
schema vs free-text instruction?**

## Observation: Tool Definitions Have Three Parts

1. **Name** - Short identifier (e.g., `Read`, `Bash`, `Grep`)
2. **Schema** - JSON Schema for parameters (structured)
3. **Description** - Free-text instructions (often VERY long)

## Example: Read Tool

**Name:** `Read`

**Schema (structured):**
```json
{
  "type": "object",
  "properties": {
    "file_path": {
      "type": "string",
      "description": "The absolute path to the file to read"
    },
    "offset": {
      "type": "number",
      "description": "The line number to start reading from. Only provide if the file is too large to read at once"
    },
    "limit": {
      "type": "number",
      "description": "The number of lines to read. Only provide if the file is too large to read at once."
    }
  },
  "required": ["file_path"]
}
```

**Description (free-text, ~20 lines):**
```
Reads a file from the local filesystem. You can access any file directly by using this tool.
Assume this tool is able to read all files on the machine. If the User provides a path to a file assume that path is valid. It is okay to read a file that does not exist; an error will be returned.

Usage:
- The file_path parameter must be an absolute path, not a relative path
- By default, it reads up to 2000 lines starting from the beginning of the file
- You can optionally specify a line offset and limit (especially handy for long files), but it's recommended to read the whole file by not providing these parameters
- Any lines longer than 2000 characters will be truncated
- Results are returned using cat -n format, with line numbers starting at 1
- This tool allows Claude Code to read images (eg PNG, JPG, etc). When reading an image file the contents are presented visually as Claude Code is a multimodal LLM.
- This tool can read PDF files (.pdf). PDFs are processed page by page, extracting both text and visual content for analysis.
- This tool can read Jupyter notebooks (.ipynb files) and returns all cells with their outputs, combining code, text, and visualizations.
- This tool can only read files, not directories. To read a directory, use an ls command via the Bash tool.
- You can call multiple tools in a single response. It is always better to speculatively read multiple potentially useful files in parallel.
- You will regularly be asked to read screenshots. If the user provides a path to a screenshot, ALWAYS use this tool to view the file at the path. This tool will work with all temporary file paths.
- If you read a file that exists but has empty contents you will receive a system reminder warning in place of file contents.
```

## Example: Bash Tool

**Name:** `Bash`

**Schema (structured):**
```json
{
  "type": "object",
  "properties": {
    "command": {
      "type": "string",
      "description": "The command to execute"
    },
    "description": {
      "type": "string",
      "description": "Clear, concise description of what this command does in 5-10 words, in active voice."
    },
    "timeout": {
      "type": "number",
      "description": "Optional timeout in milliseconds (max 600000)"
    },
    "run_in_background": {
      "type": "boolean",
      "description": "Set to true to run this command in the background."
    }
  },
  "required": ["command"]
}
```

**Description (free-text, ~150+ lines!):**

The Bash tool description is MASSIVE. It includes:
- Basic usage instructions
- Directory verification requirements
- Command quoting rules with examples
- Timeout behavior
- Output truncation limits
- When NOT to use Bash (prefer specialized tools)
- Multiple command handling (parallel vs sequential)
- Working directory guidance
- **Entire git commit workflow** (~50 lines)
- **Entire PR creation workflow** (~30 lines)
- Git safety protocol (never force push, etc.)
- Example commit message format with HEREDOC

## Example: Grep Tool

**Name:** `Grep`

**Schema (structured):**
```json
{
  "type": "object",
  "properties": {
    "pattern": {"type": "string", "description": "The regular expression pattern to search for"},
    "path": {"type": "string", "description": "File or directory to search in"},
    "glob": {"type": "string", "description": "Glob pattern to filter files"},
    "type": {"type": "string", "description": "File type to search (js, py, rust, go, java, etc.)"},
    "output_mode": {"type": "string", "enum": ["content", "files_with_matches", "count"]},
    "-A": {"type": "number", "description": "Lines after match"},
    "-B": {"type": "number", "description": "Lines before match"},
    "-C": {"type": "number", "description": "Lines of context"},
    "-i": {"type": "boolean", "description": "Case insensitive"},
    "-n": {"type": "boolean", "description": "Show line numbers"},
    "multiline": {"type": "boolean", "description": "Enable multiline mode"},
    "head_limit": {"type": "number"},
    "offset": {"type": "number"}
  },
  "required": ["pattern"]
}
```

**Description (free-text, ~15 lines):**
```
A powerful search tool built on ripgrep

Usage:
- ALWAYS use Grep for search tasks. NEVER invoke `grep` or `rg` as a Bash command.
- Supports full regex syntax (e.g., "log.*Error", "function\\s+\\w+")
- Filter files with glob parameter or type parameter
- Output modes: "content" shows matching lines, "files_with_matches" shows only file paths (default)
- Use Task tool for open-ended searches requiring multiple rounds
- Pattern syntax: Uses ripgrep (not grep) - literal braces need escaping
- Multiline matching: By default patterns match within single lines only
```

## Example: Edit Tool

**Name:** `Edit`

**Schema:**
```json
{
  "type": "object",
  "properties": {
    "file_path": {"type": "string"},
    "old_string": {"type": "string", "description": "The text to replace"},
    "new_string": {"type": "string", "description": "The text to replace it with"},
    "replace_all": {"type": "boolean", "default": false}
  },
  "required": ["file_path", "old_string", "new_string"]
}
```

**Description (free-text, ~15 lines):**
```
Performs exact string replacements in files.

Usage:
- You must use your `Read` tool at least once in the conversation before editing.
- When editing text from Read tool output, ensure you preserve the exact indentation...
- ALWAYS prefer editing existing files in the codebase. NEVER write new files unless explicitly required.
- Only use emojis if the user explicitly requests it.
- The edit will FAIL if `old_string` is not unique in the file. Either provide a larger string...
- Use `replace_all` for replacing and renaming strings across the file.
```

## Example: Task Tool (Agent Spawning)

**Name:** `Task`

**Schema:**
```json
{
  "type": "object",
  "properties": {
    "prompt": {"type": "string", "description": "The task for the agent to perform"},
    "description": {"type": "string", "description": "A short (3-5 word) description"},
    "subagent_type": {"type": "string", "description": "The type of specialized agent"},
    "model": {"type": "string", "enum": ["sonnet", "opus", "haiku"]},
    "resume": {"type": "string", "description": "Agent ID to resume"},
    "run_in_background": {"type": "boolean"}
  },
  "required": ["description", "prompt", "subagent_type"]
}
```

**Description (free-text, ~80 lines):**

Includes:
- When to use vs not use
- Available agent types with their tool access
- Usage notes on parallel execution
- Multiple detailed examples with reasoning
- Background execution guidance

---

## Analysis: Free-Text to Schema Ratio

| Tool | Schema Lines | Description Lines | Ratio |
|------|-------------|-------------------|-------|
| Read | ~15 | ~20 | 1:1.3 |
| Bash | ~15 | ~150+ | 1:10 |
| Grep | ~25 | ~15 | 1:0.6 |
| Edit | ~12 | ~15 | 1:1.2 |
| Task | ~15 | ~80 | 1:5 |

**Key Insight:** The free-text description often contains:
1. **Usage patterns** - When to use, when NOT to use
2. **Behavioral guidance** - How to think about using the tool
3. **Workflows** - Multi-step procedures (git commits, PRs)
4. **Examples** - Concrete usage examples
5. **Warnings** - What to avoid, edge cases
6. **Cross-tool coordination** - "Use X instead of Y for this case"

## Implications for INSTRUMENTA

### What Pure Ruby DSL handles well:
- Schema definition (already have this)
- Parameter validation
- Execution logic
- Type safety

### What Ruby DSL struggles with:
- Long behavioral guidance (awkward as string constants)
- Examples (need good formatting)
- Cross-tool coordination instructions
- Workflows that span multiple tool uses

### Possible Hybrid Approach:

```ruby
class ReadFile < Autopax::Instrumenta::Tool
  tool_name 'read-file'
  tool_description_from 'read-file.md'  # Load from template
  tool_schema(
    type: 'object',
    properties: {
      path: { type: 'string', description: 'File path to read' }
    },
    required: ['path']
  )

  def execute(input)
    # Ruby logic
  end
end
```

Where `lib/templates/instrumenta/read-file.md` contains:
```markdown
---
name: read-file
---

Reads a file from the filesystem and returns its contents.

## Usage

- Provide absolute paths only
- Large files are automatically truncated
- Binary files return base64 encoding

## When to Use

Use this tool when you need to examine file contents...

## Examples

To read a configuration file:
...
```

This separates:
- **Schema** (Ruby, type-checked)
- **Execution** (Ruby, full logic)
- **Documentation/Guidance** (Markdown, rich formatting)

---

## Questions This Raises

1. **How much guidance do entities need?** My tools have extensive guidance because
   I'm a general-purpose agent. Entity-specific tools might need less.

2. **Who writes the guidance?** If it's mostly for the LLM's benefit, should it
   be auto-generated or human-curated?

3. **Is the guidance part of the tool or part of the system prompt?** Some of my
   "tool description" content feels more like system prompt material.

4. **Versioning?** If guidance changes, does the tool change? If schema changes?
