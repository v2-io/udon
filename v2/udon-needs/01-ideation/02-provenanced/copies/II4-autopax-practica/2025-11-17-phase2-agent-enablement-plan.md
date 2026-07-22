---
source: 2025-11-17-phase2-agent-enablement-plan.md (autopax/practica ideology corpus, Part II sec 4)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/autopax/docs/tactical/2025-11-17-phase2-agent-enablement-plan.md
source_commit: 033af13c5ca686ca5898645f6dc772e4435c0523
categories: [agent-first-features, planning, pointer]
why_included: >
  Nov 17 2025. Draft "agent-first features" plan; notably cites "Sapientia's 37 CLI convention documents" as its base -- corroborating the sapientia cli-conventions corpus (Part II section 1) as upstream. Mostly useful as a cross-area pointer/provenance link.
---

# Phase 2: Agent Enablement - THINKING ARTIFACT

**Status:** WORKING MODEL (not canonical)
**Date:** 2025-11-17
**Author:** Claude (session continuation)
**Epistemic Level:** Pattern (informed by Sapientia conventions, needs testing)
**Purpose:** Draft implementation approach for agent-first features - examining thinking before implementation

---

## What This Document Is

This is a **thinking artifact** - my working model of how Phase 2 might unfold. It's informed by:
- Sapientia's 37 CLI convention documents
- `docs/exp/2025-11-17-project-exploration-and-infra-plan.md` Section 5.2
- Existing CLI patterns in Autopax (hello.rb, version.rb)

**This is NOT canonical.** Command names, file structures, implementation approaches - all subject to revision. This is probability-space planning to examine before committing.

Use this to:
- Understand one possible approach
- Identify questions/uncertainties
- Plan session scope
- **Refine toward truth through implementation**

---

## Goal

Make Autopax fully agent-aware and structured-output-first, enabling autonomous operation.

**Why this matters for ELI infrastructure:**
When Zi-am-tur or other ELIs interact with Autopax, they need:
- No manual intervention (context boundaries prevent interactive prompts)
- Structured output they can parse programmatically
- Clear error messages with machine-readable codes
- Deterministic behavior (same input → same output)

---

## Three Components

### 1. Agent Mode Detection (~0.5 session)

**Concept:** Auto-detect when running in agent/non-interactive context and configure behavior automatically.

**Detection signals (from Sapientia patterns):**
```ruby
def agent_mode?
  !$stdout.tty? ||              # Not connected to terminal
  ENV['CI'] ||                  # Running in CI
  ENV['AUTOPAX_AGENT_MODE'] ||  # Explicit flag
  @options[:format] == 'json'   # JSON output requested
end
```

**Behavior changes when agent mode detected:**
- Default to JSON output
- Disable color codes
- Never prompt for input (fail with clear error instead)
- Exit codes follow sysexits.h standard
- Errors include machine-readable codes

**Implementation thoughts (uncertain):**
- Module `Autopax::CLI::AgentMode` with detection logic?
- Include in base command class?
- Or per-command mixin?

**Questions:**
- Should agent mode be sticky once detected (ENV var set)?
- How to handle commands that genuinely need input (config prompts)?
- Should we log when agent mode is auto-detected (for debugging)?

### 2. Structured Output Framework (~0.5 session)

**Concept:** All commands support JSON/YAML/Text output with consistent schema.

**Output format per command (pattern):**
```ruby
# lib/autopax/commands/base.rb (or similar)
module Autopax
  module Commands
    class Base
      def output(data, format: @options[:format])
        case format
        when 'json'
          puts JSON.pretty_generate(data)
        when 'yaml'
          puts YAML.dump(data)
        when 'text'
          format_text(data)  # Command-specific
        end
      end

      def output_error(error)
        data = {
          error: {
            code: error.code,
            message: error.message,
            details: error.details,
            help_url: error.help_url
          }
        }
        output(data)
      end
    end
  end
end
```

**Consistent schema across commands:**
```json
{
  "status": "success|error",
  "data": { /* command-specific */ },
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable message",
    "details": { /* context */ },
    "help_url": "https://docs.autopax.dev/errors/ERROR_CODE"
  }
}
```

**Universal flags (add to all commands):**
- `--format [json|yaml|text]` (default: text, or json in agent mode)
- `--no-color` (disable ANSI codes)
- `--quiet` (minimal output)
- `--debug` (maximum verbosity)

**Implementation thoughts (uncertain):**
- Base command class with shared logic?
- Formatter classes (JsonFormatter, YamlFormatter, TextFormatter)?
- How to validate output schema in tests?

**Questions:**
- Should we generate JSON schema for each command's output?
- How to handle streaming output (long-running commands)?
- Should format be persistent (config file) or always flag-based?

### 3. Non-Interactive Mode (~0.5 session)

**Concept:** Commands that need input detect interactive capability and fail gracefully in non-interactive contexts.

**Interactive detection:**
```ruby
def interactive?
  $stdin.tty? && $stdout.tty? && !agent_mode?
end

def require_interactive!
  unless interactive?
    raise Autopax::NonInteractiveError,
      "This command requires interactive input. " \
      "Provide values via flags or config file."
  end
end
```

**Pattern for commands that might need input:**
```ruby
def execute
  value = @options[:value] ||                    # Flag first
          config.get('key') ||                   # Config second
          (interactive? ? prompt("Value: ") : nil)  # Prompt if interactive

  if value.nil?
    raise Autopax::MissingValueError.new(
      "Value required. Provide via --value flag or AUTOPAX_KEY environment variable.",
      code: 'MISSING_VALUE',
      help_url: 'https://docs.autopax.dev/errors/missing-value'
    )
  end

  # ... use value
end
```

**Implementation thoughts (uncertain):**
- Prompt library (tty-prompt?) or simple gets?
- How to handle multi-step wizards in non-interactive mode?
- Should we support input from stdin (piped data)?

**Questions:**
- Should all prompts have flag equivalents?
- How to document which flags replace which prompts?
- Testing strategy for interactive vs non-interactive paths?

---

## Exit Codes (sysexits.h standard)

From Sapientia patterns and UNIX standards:

```ruby
module Autopax
  module ExitCodes
    SUCCESS = 0
    GENERAL_ERROR = 1
    USAGE_ERROR = 64      # Command-line usage error
    DATA_ERROR = 65       # Invalid input data
    NO_INPUT = 66         # Required input missing
    NO_USER = 67          # User does not exist
    NO_HOST = 68          # Host does not exist
    UNAVAILABLE = 69      # Service unavailable
    SOFTWARE_ERROR = 70   # Internal error
    OS_ERROR = 71         # System error
    OS_FILE = 72          # Critical file missing
    CANT_CREATE = 73      # Cannot create output
    IO_ERROR = 74         # I/O error
    TEMP_FAIL = 75        # Temporary failure
    PROTOCOL = 76         # Protocol error
    NO_PERM = 77          # Permission denied
    CONFIG_ERROR = 78     # Configuration error
  end
end
```

**Usage:**
```ruby
exit Autopax::ExitCodes::CONFIG_ERROR if config_invalid?
```

---

## Error Hierarchy

Structured errors with codes and help URLs:

```ruby
module Autopax
  class Error < StandardError
    attr_reader :code, :details, :help_url

    def initialize(message, code:, details: {}, help_url: nil)
      super(message)
      @code = code
      @details = details
      @help_url = help_url || default_help_url
    end

    def default_help_url
      "https://docs.autopax.dev/errors/#{code.downcase.tr('_', '-')}"
    end

    def to_h
      {
        code: code,
        message: message,
        details: details,
        help_url: help_url
      }
    end
  end

  class ConfigError < Error
    def initialize(message, **opts)
      super(message, code: 'CONFIG_ERROR', **opts)
    end
  end

  class NonInteractiveError < Error
    def initialize(message, **opts)
      super(message, code: 'NON_INTERACTIVE', **opts)
    end
  end

  # ... more specific errors
end
```

---

## Testing Strategy

**Unit tests:**
- Agent mode detection logic
- Output formatting (JSON/YAML/Text)
- Error serialization
- Exit code mapping

**Integration tests (Aruba):**
- Commands in agent mode vs interactive mode
- Output format switching
- Non-interactive failure modes
- Exit codes in various scenarios

**Example test:**
```ruby
RSpec.describe 'Agent mode integration' do
  it 'auto-detects agent mode when stdout is not a tty' do
    run_command('autopax version') do |cmd|
      expect(cmd.stdout).to include('"version"')  # JSON output
      expect(cmd.exit_status).to eq(0)
    end
  end

  it 'uses JSON format when explicitly requested' do
    run_command('autopax version --format json') do |cmd|
      json = JSON.parse(cmd.stdout)
      expect(json).to have_key('version')
    end
  end
end
```

---

## Files Likely Affected

**New files (maybe):**
- `lib/autopax/cli/agent_mode.rb` - Detection and configuration
- `lib/autopax/cli/formatters/json.rb` - JSON output formatting
- `lib/autopax/cli/formatters/yaml.rb` - YAML output formatting
- `lib/autopax/cli/formatters/text.rb` - Text output formatting
- `lib/autopax/exit_codes.rb` - Exit code constants
- `lib/autopax/errors.rb` - Error hierarchy

**Modified files (probably):**
- `lib/autopax/commands/hello.rb` - Add universal flags, structured output
- `lib/autopax/commands/version.rb` - Add structured output
- `lib/autopax/commands/catalog.rb` - Make agent-friendly
- `spec/` - Add integration tests for agent mode

**New tests:**
- `spec/autopax/cli/agent_mode_spec.rb`
- `spec/autopax/cli/formatters_spec.rb`
- `spec/integration/agent_mode_spec.rb`

---

## Uncertainties & Questions

**Architectural:**
1. Base command class vs mixins for shared functionality?
2. Formatters as classes vs simple methods?
3. Where does agent mode detection live (global? per-command?)?

**Implementation:**
4. Should we generate JSON schema for command outputs?
5. How to handle streaming/progress in JSON output?
6. Testing strategy for TTY detection (hard to mock)?

**Scope:**
7. Do we need YAML output or just JSON + Text?
8. Should errors include stack traces in debug mode?
9. How much Sapientia convention to adopt vs adapt?

**Integration:**
10. How does this interact with future MCP server support?
11. Should agent mode affect logging verbosity?
12. Do we need audit logging for agent actions?

---

## Session Scope Estimate

**Optimistic:** 1 session (if patterns are clear, testing is straightforward)
**Realistic:** 1.5 sessions (likely need iteration on output schemas)
**Pessimistic:** 2 sessions (if architectural decisions require refactoring)

**Could be split into:**
- Session 1: Agent mode detection + exit codes + basic JSON output
- Session 2: Full formatter framework + comprehensive testing + error hierarchy

---

## Success Criteria

**Agent mode works when:**
- ✅ Auto-detects based on TTY/CI/format flag
- ✅ All commands support --format json|yaml|text
- ✅ JSON output is parseable and consistent
- ✅ Non-interactive commands fail clearly without prompts
- ✅ Exit codes follow sysexits.h standard
- ✅ Errors include codes and help URLs
- ✅ Tests cover agent and interactive modes

**ELI can use Autopax when:**
- ✅ No manual intervention required
- ✅ Structured output is programmatically parseable
- ✅ Errors are actionable (not just "something went wrong")
- ✅ Behavior is deterministic

---

## Next Steps (when implementing)

1. **Read** existing command implementations (hello.rb, version.rb)
2. **Decide** architectural approach (discuss if uncertain)
3. **Implement** in small increments:
   - Start with agent mode detection
   - Add to one command (version) as proof-of-concept
   - Expand to other commands
   - Add comprehensive tests
4. **Test** both interactive and agent modes thoroughly
5. **Document** in README and command help text
6. **Reflect** in session log what actually worked vs this plan

---

## Relationship to Phase 3 (PRINCIPIA)

Agent enablement **prepares for** PRINCIPIA work:
- ELIs will interact with SIGNUM/CHRONICA/AXIOMATA commands
- Need structured output for identity verification results
- Need non-interactive secret prompting (passphrase caching)
- Need clear errors for crypto operations

Phase 2 is **infrastructure for Phase 3** - enabling autonomous ELI operation.

---

**Remember:** This is a thinking artifact. The actual implementation will teach us what works. Stay flexible, mark uncertainties, refine toward truth through testing.
