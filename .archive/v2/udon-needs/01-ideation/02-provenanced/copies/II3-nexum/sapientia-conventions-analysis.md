---
source: nexum repo — research doc distilling sapientia/cli-conventions/ (see Part II §1)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/_core/nexum/docs/research/sapientia-conventions-analysis.md
source_commit: c87c75ce20aeaad9290732e17be256601b45a338
categories: [agent-cli-conventions, universal-flags, exit-codes, stream-separation, agent-mode-detection, xdg-config, flag-naming]
why_included: >
  2025-11-08. The distilled agent-CLI convention set, applied to a concrete tool: universal flags
  (--format, --dry-run, stackable -v, --no-color), sysexits-style exit codes, strict stdout=data /
  stderr=diagnostics stream discipline, XDG config precedence, agent-mode auto-detection
  (non-TTY / CI / merged-streams / --format=json), specialized binary-name aliases, and a flag-naming
  philosophy ("skip patronizing --dangerously- prefixes; flag polarity follows defaults"). LINEAGE
  NOTE for synthesizers: this explicitly distills ~/src/_core/sapientia/cli-conventions/*.md
  (Part II §1) — same author, so treat as restatement-in-nexum-context (evolution evidence), NOT
  independent corroboration of the upstream conventions. Directly applicable to UDON's agent CLI/utils
  surface and to the harness's tool-presentation contract.
---
# Sapientia CLI Conventions Analysis for Nexum

Analysis of relevant patterns from `~/src/sapientia/cli-conventions/*.md` that may inform Nexum's CLI design.

## Key Ideas from Sapientia Conventions

### 1. Universal Flags (All Tools Should Support)

From `command-line-interface.md`:

```bash
-h, --help                    # Show help
-v, --verbose                 # Increase verbosity (stackable: -vvv)
-q, --quiet                   # Suppress non-error output
--version                     # Show version and exit
--format=FORMAT               # Output format (json|text|csv|tsv|yaml)
--no-color                    # Disable colored output
--color=auto|always|never     # Color output control
--dry-run                     # Preview what would be done
--debug                       # Maximum verbosity for debugging
```

**Relevance to Nexum:**
- `--format=json` would be useful for one-shot mode and scripting
- `--dry-run` could preview what an agent would do without executing
- `--debug` aligns with existing TODO item for `-d/--debug`
- `--version` is standard practice

---

### 2. Standard Exit Codes

From `command-line-interface.md`:

```bash
0     Success
1     General errors
2     Misuse of shell command (invalid options, missing arguments)
64    Command line usage error (EX_USAGE)
65    Data format error (EX_DATAERR)
66    Cannot open input (EX_NOINPUT)
69    Service unavailable (EX_UNAVAILABLE) - API errors?
70    Internal software error (EX_SOFTWARE)
74    I/O error (EX_IOERR)
78    Configuration error (EX_CONFIG)
```

**Relevance to Nexum:**
- Provides clear, standardized exit codes for scripting
- Exit code 69 could indicate provider API unavailable
- Exit code 78 for invalid config files
- Exit code 66 for missing JSONL continuation file

---

### 3. Core Design Philosophy

From `core-design-philosophy.md`:

**Unix Principles:**
- Do one thing well
- Composability - design for chaining with other tools
- Text streams as universal interface
- **Silence is golden - no output on success unless explicitly requested**
- Fail fast and explicitly
- Idempotency where possible

**AI Agent Principles:**
- **Predictable, deterministic behavior** - same inputs → same outputs
- **Structured output modes** - JSON/TSV/CSV via flags
- **Machine-readable errors** - parseable error formats
- **Explicit verbosity control** - separate operational vs diagnostic output
- **No interactive prompts in non-interactive mode** - fail fast instead

**Relevance to Nexum:**
- Ironic but important: Nexum IS an AI agent, but needs to be agent-friendly for scripting
- Determinism conflicts with LLM nature, but conversation replay should be deterministic
- Structured output mode for one-shot queries would be valuable
- Non-interactive mode detection critical for `--execute` flag

---

### 4. Configuration Precedence Order

From `configuration-management.md`:

**Hierarchy (highest to lowest):**
1. Command-line flags
2. Environment variables (`NEXUM_*` prefix)
3. Local config file (`./.nexumrc` or `./nexum.{json,yaml,toml}`)
4. User config file (`~/.config/nexum/config`)
5. System config (`/etc/nexum/config`)
6. Built-in defaults

**XDG Base Directory Specification:**
```bash
~/.config/nexum/           # User config directory
~/.local/share/nexum/      # User data directory (sessions?)
~/.cache/nexum/            # User cache directory (provider cache?)
```

**Environment Variables:**
```bash
NEXUM_CONFIG_FILE=/path/to/config
NEXUM_LOG_LEVEL=debug
NEXUM_FORMAT=json
NEXUM_NO_COLOR=1
NEXUM_PREFERRED_SUBSTRATE=claude-sonnet-4
NEXUM_TRACKING=1
```

**Relevance to Nexum:**
- Aligns perfectly with `anyway_config` capabilities
- XDG support is modern best practice
- Environment variables useful for CI/scripting
- Project-local `.nexumrc` for per-project preferences

---

### 5. AI Agent Mode Auto-Detection

From `ai-agent-considerations.md`:

**Trigger agent mode when:**
- Non-interactive terminal (`!isatty()`)
- CI environment variable set
- Streams are merged (`stdout==stderr`)
- `NEXUM_AGENT_MODE=1` environment variable
- `--format=json` or other structured format requested

**Agent Mode Behavior:**
- No progress indicators or spinners
- No colors or text formatting
- Structured output preferred
- No interactive prompts (fail instead)
- Deterministic output ordering
- Include metadata in structured output

**Relevance to Nexum:**
- Critical for one-shot mode and scripting use cases
- Could suppress the interactive TUI when running in CI
- Enables `nexum --execute "query" --format=json` for pipelines
- Deterministic output helps with testing

---

### 6. Specialized Alias Pattern

From `specialized-aliases-and-mode-conventions.md`:

**Purpose-Specific Binary Names:**
```bash
# AI/Agent optimized
nexum-ai           # nexum --format=json --no-progress --no-color --batch

# Safety levels
nexum-safe         # nexum --dry-run --confirm --backup-first
nexum-readonly     # nexum --no-tools --read-only

# Environment specific
nexum-dev          # nexum --verbose --debug --unsafe --no-cache
nexum-prod         # nexum --quiet --safe --cached --audit-log

# Use-case specific
nexum-quick        # nexum --fast --no-validation
nexum-careful      # nexum --validate --check-twice
```

**Implementation via symlinks or binary name detection:**
```ruby
binary_name = File.basename($0)
case binary_name
when 'nexum-ai', 'nexum-agent'
  options.merge!(format: :json, no_progress: true, no_color: true, batch: true)
when 'nexum-safe'
  options.merge!(dry_run: true, confirm: true)
end
```

**Relevance to Nexum:**
- `nexum-ai` for scripting/automation is particularly relevant
- `nexum-safe` could enable tool confirmation mode
- `nexum-readonly` for analysis without side effects
- Simple to implement via binary name detection

---

### 7. Stream Separation Discipline

From `input-output-handling.md`:

**Core Principle:**
- **stdout**: Primary output, pipeable data ONLY
- **stderr**: Errors, warnings, progress indicators, diagnostics

**Never mix status messages with data output on stdout.**

```bash
# Good - clean separation
$ nexum --execute "summarize data.txt" > summary.txt
Processing with claude-sonnet-4...    # stderr
Thinking...                           # stderr
Done!                                 # stderr
# summary.txt contains only the actual response

# Bad - mixed output
$ nexum --execute "summarize data.txt" > summary.txt
Processing...              # stdout - CONTAMINATES OUTPUT
{"response": "..."}        # stdout
Done!                      # stdout - CONTAMINATES OUTPUT
```

**Merged Stream Detection:**
```ruby
streams_merged = File.stat('/dev/stdout').ino == File.stat('/dev/stderr').ino
```

**Pipeline Safety Flag:**
```bash
--pipe           # Equivalent to: --quiet --format=text --no-progress
```

**Relevance to Nexum:**
- Critical for one-shot mode being useful in pipelines
- Progress indicators, thinking mode output → stderr only
- Actual LLM responses → stdout
- `--pipe` flag would ensure clean output

---

### 8. Interactive vs Non-Interactive Detection

From `input-output-handling.md`:

```bash
# Detection
if [ -t 0 ] && [ -t 1 ]; then
    # Interactive: colors, prompts, progress bars OK
else
    # Non-interactive: plain output, no prompts
fi

# Override flags
--interactive     # Force interactive mode
--batch          # Force non-interactive mode
--no-tty         # Assume no terminal
```

**Relevance to Nexum:**
- Auto-switch between TUI and plain mode based on terminal detection
- `--batch` aligns with agent mode
- Prevents hanging when run in CI without TTY

---

## Recommended Conventions for Nexum

Based on this analysis, here are suggested conventions to adopt:

### Universal Flags (High Priority)
```bash
-h, --help                    # Show help
-v, --verbose                 # Stackable verbosity
-q, --quiet                   # Suppress stderr diagnostics
--version                     # Show version
--format=json|text|markdown   # Output format
--no-color                    # Disable colors
--debug                       # Maximum verbosity
--dry-run                     # Preview mode (show what would be sent)
```

### Configuration System
- Follow XDG Base Directory spec: `~/.config/nexum/`, `~/.local/share/nexum/`, `~/.cache/nexum/`
- Support project-local `.nexumrc` or `nexum.yaml`
- Environment variables: `NEXUM_*` prefix
- Precedence: CLI flags > ENV > local config > user config > defaults

### Exit Codes
```bash
0     Success
1     General errors
2     Invalid command-line usage
66    Cannot open input file (missing JSONL)
69    Provider API unavailable
70    Internal error
78    Configuration error
```

### Stream Discipline
- **stdout**: LLM responses only (in one-shot mode)
- **stderr**: Progress, thinking, diagnostics, errors
- Add `--pipe` flag: `--quiet --format=text --no-progress`

### Mode Detection
```ruby
# Auto-detect agent mode when:
- !$stdout.isatty
- ENV['CI'] present
- ENV['NEXUM_AGENT_MODE'] == '1'
- --format=json specified
```

### Specialized Aliases (Future)
```bash
nexum-ai         # nexum --format=json --no-progress --no-color --batch
nexum-safe       # nexum --confirm --dry-run
nexum-readonly   # nexum --no-tools
```

### Flag Naming Patterns

**Provide both short and long forms:**
- Common flags: `-c, --continue` / `-m, --model` / `-i, --initial-context`
- Uncommon flags: `--temperature` / `--tracking` (long-only is fine)
- Users choose based on context: `-vvv` (quick) vs `--verbose --verbose --verbose` (clear)

**Support aliases for natural terminology:**
- `--resume` / `--continue` (both work as aliases)
- Don't force "one true name" - accommodate different mental models
- Example: Git supports both `git switch` and `git checkout`

**Skip patronizing prefixes:**
- Use `--force` not `--dangerously-force`
- Use `--unsafe` not `--dangerously-unsafe`
- Standard Unix: `rm -rf` not `rm --dangerously-recursive-force`
- Document risks in help text, trust users

**Flag polarity follows defaults:**
- Default **ON** → `--no-X` flag (e.g., `--no-thinking` since thinking enabled by default)
- Default **OFF** → `--X` flag (e.g., `--tracking` since tracking disabled by default)
- Support both for flexibility: `--thinking/--no-thinking` as boolean pair

**Other patterns:**
- Format flags: `--format=<value>`
- Repeatable flags: `-v`, `-vv`, `-vvv` for verbosity levels

---

## Conflicts with Nexum's Nature

Some conventions may not apply directly:

1. **"Silence is golden"** - Interactive chat mode inherently produces output
   - Resolution: Apply only to one-shot mode

2. **"Deterministic behavior"** - LLMs are non-deterministic
   - Resolution: Conversation replay from JSONL should be deterministic

3. **"Do one thing well"** - Nexum is an interactive assistant (complex by nature)
   - Resolution: Each subcommand does one thing (chat, resume, export, etc.)

4. **"No interactive prompts in non-interactive mode"** - Core feature is interactive
   - Resolution: Auto-detect TTY and fail fast if `--batch` with no `--execute`

---

## Implementation Priority

### Phase 1: Core Conventions (Immediate)
- [ ] Universal flags: `--help`, `--version`, `--debug`, `--quiet`, `--verbose`
- [ ] Exit codes: Standard codes for common errors
- [ ] Stream separation: stderr for diagnostics, stdout for data
- [ ] XDG directory support: `~/.config/nexum/`, `~/.local/share/nexum/`

### Phase 2: Agent-Friendly (High Priority)
- [ ] `--format=json` for structured output
- [ ] Agent mode auto-detection
- [ ] `--batch` / `--no-tty` flags
- [ ] `NEXUM_*` environment variables

### Phase 3: Advanced (Future)
- [ ] `--pipe` flag for pipeline safety
- [ ] Specialized aliases (`nexum-ai`, `nexum-safe`)
- [ ] Stackable verbosity (`-vvv`)
- [ ] `--dry-run` preview mode
