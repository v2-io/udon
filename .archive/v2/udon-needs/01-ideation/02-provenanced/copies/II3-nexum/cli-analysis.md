---
source: nexum repo — research doc (capability matrix across shipped agent CLIs)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/_core/nexum/docs/research/cli-analysis.md
source_commit: c87c75ce20aeaad9290732e17be256601b45a338
categories: [cli-capability-matrix, shipped-practice, agent-cli-conventions, flag-naming]
why_included: >
  2025-11-06. A ~40-dimension capability matrix across codex / claude / gemini / minimal-sapientia
  CLIs (one-shot mode, resume, output-format, permission/approval modes, tool management, streaming,
  tracking snapshots), with per-tool "unique features" and design implications. CROSS-TIER VALUE: unlike
  most of this single-author section, this row surveys *shipped* commercial harnesses (Tier-2-flavored
  evidence), so its convergences with Joseph's own conventions are genuine triangulation, not coherence.
  The empirical grounding for agent-CLI flag design.
---
# CLI Capability Comparison Analysis

Comparison of command-line interfaces for codex, claude, gemini, and minimal-sapientia to inform Nexum CLI design.

## CLI Capability Comparison Matrix

| Capability                   | codex                                                                                      | claude                                                                                           | gemini                                                                  | minimal-sapientia                           |
| ---------------------------- | ------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------- | ------------------------------------------- |
| **Model Selection**          | `-m, --model <MODEL>`                                                                      | `--model <model>`                                                                                | `-m, --model`                                                           | ❌                                           |
| **One-shot/Non-interactive** | `exec` subcommand or `[PROMPT]`                                                            | `-p, --print`                                                                                    | positional `[query..]` (default)                                        | ❌ (always interactive)                      |
| **Interactive Mode**         | ✓ (default)                                                                                | ✓ (default)                                                                                      | `-i, --prompt-interactive`                                              | ✓ (default, only mode)                      |
| **Initial Prompt**           | `[PROMPT]` positional                                                                      | `[prompt]` positional                                                                            | `[query..]` positional                                                  | `-i, --initial-context FILE`                |
| **Resume/Continue Session**  | `resume` subcommand<br>`--last` flag                                                       | `-c, --continue`<br>`-r, --resume [sessionId]`                                                   | ❌                                                                       | `-c, --continue FILE`                       |
| **Session Management**       | `resume`, `apply`, `cloud` subcommands                                                     | `--fork-session`<br>`--session-id <uuid>`                                                        | ❌                                                                       | File-based only                             |
| **Debug Mode**               | `sandbox` subcommand                                                                       | `-d, --debug [filter]`<br>`--verbose`                                                            | `-d, --debug`                                                           | ❌                                           |
| **MCP Servers**              | `mcp` subcommand<br>`mcp-server` subcommand                                                | `mcp` command<br>`--mcp-config <configs...>`<br>`--strict-mcp-config`                            | `mcp` command<br>`--allowed-mcp-server-names`                           | ❌                                           |
| **System Prompt**            | ❌                                                                                          | `--system-prompt <prompt>`<br>`--append-system-prompt <prompt>`                                  | ❌                                                                       | `-p, --prompt FILE`                         |
| **Image Attachment**         | `-i, --image <FILE>...`                                                                    | ❌                                                                                                | ❌                                                                       | ❌                                           |
| **Working Directory**        | `-C, --cd <DIR>`<br>`--add-dir <DIR>`                                                      | `--add-dir <directories...>`                                                                     | `--include-directories`                                                 | ❌                                           |
| **Approval/Permission Mode** | `-a, --ask-for-approval`<br>  (untrusted/on-failure/<br>on-request/never)<br>`--full-auto` | `--permission-mode`<br>(acceptEdits/bypass/<br>default/plan)<br>`--dangerously-skip-permissions` | `--approval-mode`<br>(default/auto_edit/yolo)<br>`-y, --yolo`           | `--no-tools`                                |
| **Sandbox Mode**             | `-s, --sandbox`<br>(read-only/workspace-write/<br>danger-full-access)                      | ❌ (uses permission-mode)                                                                         | `-s, --sandbox`                                                         | ❌                                           |
| **Dangerous Bypass**         | `--dangerously-bypass-`<br>`approvals-and-sandbox`                                         | `--dangerously-skip-`<br>`permissions`<br>`--allow-dangerously-`<br>`skip-permissions`           | ❌ (uses `--yolo`)                                                       | ❌                                           |
| **Output Format**            | ❌                                                                                          | `--output-format`<br>(text/json/stream-json)                                                     | `-o, --output-format`<br>(text/json/stream-json)                        | ❌                                           |
| **Streaming**                | ❌                                                                                          | (via output-format)<br>`--include-partial-messages`                                              | (via output-format)                                                     | `-s, --stream`                              |
| **Input Format**             | ❌                                                                                          | `--input-format`<br>(text/stream-json)<br>`--replay-user-messages`                               | ❌                                                                       | ❌                                           |
| **Tool Management**          | ❌                                                                                          | `--allowedTools`<br>`--disallowedTools`<br>`--tools <tools...>`                                  | `--allowed-tools`                                                       | `--no-tools`                                |
| **Sampling Control**         | ❌                                                                                          | ❌                                                                                                | ❌                                                                       | `--temperature FLOAT`<br>`--top-p FLOAT`    |
| **Extended Thinking**        | ❌                                                                                          | ❌                                                                                                | ❌                                                                       | `-t, --no-thinking`<br>(enabled by default) |
| **Tracking Snapshots**       | ❌                                                                                          | ❌                                                                                                | ❌                                                                       | `--tracking`<br>(context/git/pwd)           |
| **Configuration**            | `-c, --config <key=value>`<br>`-p, --profile`                                              | `--settings <file-or-json>`<br>`--setting-sources`                                               | ❌                                                                       | ❌                                           |
| **Web Search**               | `--search`                                                                                 | ❌                                                                                                | ❌                                                                       | ❌                                           |
| **Extensions/Plugins**       | ❌                                                                                          | `plugin` command<br>`--plugin-dir <paths...>`                                                    | `-e, --extensions`<br>`-l, --list-extensions`<br>`extensions <command>` | ❌                                           |
| **Fallback Model**           | ❌                                                                                          | `--fallback-model <model>`                                                                       | ❌                                                                       | ❌                                           |
| **Custom Agents**            | ❌                                                                                          | `--agents <json>`                                                                                | ❌                                                                       | ❌                                           |
| **OSS/Local Models**         | `--oss` (Ollama)                                                                           | ❌                                                                                                | ❌                                                                       | ❌                                           |
| **Feature Flags**            | `--enable <FEATURE>`<br>`--disable <FEATURE>`<br>`features` subcommand                     | ❌                                                                                                | ❌                                                                       | ❌                                           |
| **IDE Integration**          | ❌                                                                                          | `--ide`                                                                                          | ❌                                                                       | ❌                                           |
| **Accessibility**            | ❌                                                                                          | ❌                                                                                                | `--screen-reader`                                                       | ❌                                           |
| **Experimental**             | `--experimental-acp` (gemini)                                                              | Various experimental flags                                                                       | `--experimental-acp`                                                    | `--tracking`                                |
| **Help**                     | `-h, --help`                                                                               | `-h, --help`                                                                                     | `-h, --help`                                                            | `-h, --help`                                |
| **Version**                  | `-V, --version`                                                                            | `-v, --version`                                                                                  | `-v, --version`                                                         | ❌                                           |

## Key Observations

### 1. Common Patterns
- All use positional arguments for initial prompts
- Model selection uses `-m, --model` (except minimal-sapientia which doesn't support it)
- MCP server support in codex, claude, and gemini
- Permission/approval modes exist in all three modern CLIs with different naming conventions

### 2. Unique to minimal-sapientia
- **File-based continuation** (`-c FILE`) - sessions tied to JSONL files
- **Sampling parameters** (temperature, top-p) - fine-grained control over generation
- **Extended thinking toggle** (`-t, --no-thinking`) - control over reasoning mode
- **Tracking snapshots** (`--tracking`) - experimental context/git/pwd monitoring
- **Initial context file** (`-i`) - inject context at session start

### 3. Unique to codex
- **OSS/local model support** (`--oss`) - direct Ollama integration
- **Feature flag system** (`--enable/--disable`) - runtime feature toggling
- **`apply` subcommand** - apply Codex diffs as git patches
- **Cloud integration** - browse and apply cloud tasks

### 4. Unique to claude
- **System prompt injection/appending** - runtime prompt customization
- **Custom agents via JSON** (`--agents`) - define specialized agent behaviors
- **Fallback model support** - automatic failover when primary overloaded
- **Session forking** (`--fork-session`) - branch conversations
- **Most granular tool control** - allowed/disallowed tool patterns

### 5. Unique to gemini
- **Screen reader accessibility** (`--screen-reader`) - a11y support
- **Extension system** - modular functionality
- **ACP mode** (`--experimental-acp`) - experimental protocol

## Design Implications for Nexum

Based on this analysis, Nexum should consider:

1. **Session management**: Adopt minimal-sapientia's file-based continuation (`-c FILE`) pattern for simplicity
2. **Initial context**: Support `-i/--initial-context FILE` for entity/AXIOMATA loading
3. **Sampling control**: Include `--temperature` and `--top-p` flags for generation control
4. **Thinking mode**: Support `--thinking/--no-thinking` flags (default: enabled)
5. **Tracking**: Consider `--tracking` flag for context/git/pwd snapshot inclusion
6. **Tool control**: Simple `--no-tools` flag initially, expand to granular control later
7. **Debug mode**: Support `-d/--debug` for development troubleshooting
8. **Model selection**: Use `-m/--model` for consistency with broader ecosystem
9. **One-shot mode**: Consider `--execute` or `--message` flag for non-interactive use
10. **System prompt**: Support `-p/--prompt FILE` for custom system prompts

### Flags to Avoid Initially
- Image attachment (out of scope)
- MCP servers (future enhancement)
- Plugin/extension systems (future enhancement)
- Web search (future enhancement)
- Cloud integration (future enhancement)
- IDE integration (future enhancement)

### Naming Conventions

**Provide both short and long forms:**
- Common flags: `-c, --continue` / `-m, --model` / `-i, --initial-context`
- Uncommon flags: `--temperature` / `--tracking` (long-only is fine)
- Let users choose based on context (interactive vs scripts)
- Example: `-vvv` for quick typing, `--verbose --verbose --verbose` for clarity

**Support aliases - let users use natural terminology:**
- `--resume` / `--continue` (both work as aliases for same functionality)
- `--model` / `-m` (short + long for common options)
- Don't force "one true name" - accommodate different mental models
- Example: Git supports both `git switch` and `git checkout`

**Skip patronizing prefixes - use standard conventions:**
- Use `--force` not `--dangerously-force`
- Use `--unsafe` not `--dangerously-unsafe`
- Trust users, document risks in help text
- Standard Unix convention: `rm -rf` not `rm --dangerously-recursive-force`

**Flag polarity follows defaults - make common case easy:**
- If default is **ON** → provide `--no-X` flag (e.g., `--no-thinking` since thinking defaults to enabled)
- If default is **OFF** → provide `--X` flag (e.g., `--tracking` since tracking defaults to disabled)
- Support both for flexibility: `--thinking/--no-thinking` as boolean pair
- Examples:
  - `nexum chat` → thinking enabled (default)
  - `nexum chat --no-thinking` → disable thinking
  - `nexum chat --tracking` → enable tracking (off by default)
