---
source: nexum repo — .archive/ (testing checklist for an agent-facing CLI)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/_core/nexum/docs/.archive/cli-testing-requirements.md
source_commit: c87c75ce20aeaad9290732e17be256601b45a338
categories: [agent-cli-conventions, exit-codes, stream-separation, signal-handling, testing, compliance-checklist]
why_included: >
  Committed 2025-11-07 (sourced from sapientia/cli-conventions/examples-and-patterns.md). The "what a
  compliant agent tool must pass" list, expanded with rationale: meaningful exit codes (sysexits.h),
  stdout pipeable-only, stderr for all diagnostics, works non-interactively and under set -euo pipefail,
  graceful SIGINT/SIGTERM, validates inputs, helpful errors, docs match implementation. For the harness
  consumer this is a ready-made conformance checklist for tools an agent will drive.
---
# CLI Testing Requirements

**Date:** 2025-01-06
**Source:** ~/src/sapientia/cli-conventions/examples-and-patterns.md
**Purpose:** Define testing requirements and implementation considerations

---

## Overview

This document expands on the CLI testing checklist from conventions, providing context, rationale, and implementation considerations for each requirement.

**Testing Checklist (from conventions):**

- [ ] All exit codes are meaningful
- [ ] stdout contains only pipeable data
- [ ] stderr used for all diagnostics
- [ ] Works in non-interactive mode
- [ ] Handles Ctrl+C gracefully (SIGINT)
- [ ] Responds to SIGTERM for clean shutdown
- [ ] Validates all inputs
- [ ] Provides helpful error messages
- [ ] Documentation matches implementation
- [ ] Works with `set -euo pipefail`

---

## 1. All Exit Codes Are Meaningful

### Requirement

Every exit path must return appropriate exit code following sysexits.h conventions.

### Rationale

Exit codes enable:
- Shell scripting (`if nexum ...; then`)
- CI/CD error detection
- Automated error classification
- Retry logic based on error type

### Standard Exit Codes (sysexits.h)

```
0     SUCCESS             Operation successful
1     GENERAL_ERROR       Unspecified error
2     USAGE_ERROR         Invalid command-line usage

# sysexits.h codes
64    EX_USAGE            Command line usage error
65    EX_DATAERR          Data format error
66    EX_NOINPUT          Cannot open input file
67    EX_NOUSER           Addressee unknown
68    EX_NOHOST           Host name unknown
69    EX_UNAVAILABLE      Service unavailable
70    EX_SOFTWARE         Internal software error
71    EX_OSERR            System error
72    EX_OSFILE           Critical OS file missing
73    EX_CANTCREAT        Can't create output file
74    EX_IOERR            Input/output error
75    EX_TEMPFAIL         Temporary failure
76    EX_PROTOCOL         Remote error in protocol
77    EX_NOPERM           Permission denied
78    EX_CONFIG           Configuration error

# Signal-based codes
130   SIGINT              Interrupted by Ctrl+C (128 + 2)
143   SIGTERM             Terminated by signal (128 + 15)
```

### Nexum-Specific Codes (80+)

**Proposed:**
```
80    SESSION_NOT_FOUND   Session ID not found
81    AUTH_FAILED         API authentication failed
82    CONTEXT_OVERFLOW    Context window exceeded
83    PROVIDER_ERROR      Provider-specific error
84    TOOL_EXECUTION_ERROR Tool execution failed
```

**Open Questions:**
- Should we reserve 80-99 range?
- Should provider-specific errors have sub-codes?
- Should context overflow be distinct from unavailable (69)?

### Implementation Considerations

**Key Points:**
1. Every error path must set explicit exit code
2. Never exit without code (implies 0 = success)
3. Catch-all must return EX_SOFTWARE (70)
4. Document all codes in help and docs

**Testing Strategy:**
- Unit tests: Each error class → correct exit code
- Integration tests: End-to-end scenarios
- Smoke tests: All documented codes reachable

**Example Test Cases:**
```bash
# Success
nexum -p "test" --format=json
echo $?  # Should be 0

# Invalid flag
nexum --invalid-flag
echo $?  # Should be 2 or 64

# Missing file
nexum --system-prompt /nonexistent.md
echo $?  # Should be 66

# Session not found
nexum --resume nonexistent-id
echo $?  # Should be 80

# API failure
ANTHROPIC_API_KEY=invalid nexum -p "test"
echo $?  # Should be 81
```

---

## 2. stdout Contains Only Pipeable Data

### Requirement

stdout must contain ONLY data that downstream tools can consume. All diagnostics, progress, errors must go to stderr.

### Rationale

**Enables:**
```bash
nexum -p "test" --format=json | jq .status
nexum --list-sessions | grep conversation_2025
nexum -p "test" --format=json | jq -r .session_id | xargs nexum --resume
```

**Prevents:**
```bash
# BAD: Status messages pollute output
nexum -p "test" | jq .
# parse error: Starting session... is not valid JSON
```

### What Goes Where

**stdout (data only):**
- Conversation responses (text or JSON)
- Session listings (when requested)
- Query results
- Exported data

**stderr (diagnostics):**
- Status messages ("Starting session...")
- Progress indicators (token counts, percentages)
- Warnings
- Errors
- Debug output
- Informational messages

### Stream Merging Detection

**Challenge:** Users may redirect stderr to stdout (`2>&1`).

**Detection:**
```ruby
# Check if stdout and stderr point to same file descriptor
streams_merged = $stdout.stat.ino == $stderr.stat.ino &&
                 $stdout.stat.dev == $stderr.stat.dev
```

**Behavior When Merged:**
- Suppress progress indicators (can't separate)
- Prefix errors: "ERROR: message"
- Prefix warnings: "WARNING: message"
- Or switch to structured output (JSON events)

**Alternative:** Structured output mode
```json
{"type":"status","message":"Starting session..."}
{"type":"data","content":{...}}
{"type":"error","message":"Something failed"}
```

### Implementation Considerations

**Key Principles:**
1. Default: Assume streams separate
2. Detect merging, adapt behavior
3. Agent mode: Suppress all progress, errors to stderr only
4. Test: Every output path must use correct stream

**Common Mistakes:**
```ruby
# BAD: Diagnostic to stdout
puts "Starting session..."
puts JSON.generate(result)

# GOOD: Diagnostic to stderr, data to stdout
$stderr.puts "Starting session..."
puts JSON.generate(result)
```

**Testing Strategy:**
```bash
# Test stdout isolation
output=$(nexum -p "test" --format=json 2>/dev/null)
echo "$output" | jq .  # Should not fail

# Test stderr contains diagnostics
diagnostics=$(nexum -p "test" 2>&1 >/dev/null)
echo "$diagnostics" | grep "Starting"  # Should match
```

---

## 3. Works in Non-Interactive Mode

### Requirement

Must function correctly when:
- stdin is not a TTY
- stdout is not a TTY
- No terminal capabilities
- CI environment
- Piped input/output

### Rationale

**Use Cases:**
- CI/CD pipelines
- Cron jobs
- Scripting and automation
- Remote execution (SSH)
- Docker containers

### Mode Detection

**Interactive Mode When:**
- `$stdin.isatty && $stdout.isatty`
- Not in CI environment
- `NEXUM_AGENT_MODE != '1'`

**Non-Interactive/Agent Mode When:**
- `!$stdout.isatty` (piped output)
- `ENV['CI']` set
- `NEXUM_AGENT_MODE=1`
- `--format=json` requested
- `--batch` flag present

### Behavior Differences

**Interactive Mode:**
- Multi-line input prompts
- Colors and formatting
- Progress bars and spinners
- Interactive confirmations
- TTY-Reader for editing

**Non-Interactive/Agent Mode:**
- No prompts (fail if input missing)
- No colors
- No progress indicators
- No interactive confirmations (use defaults or fail)
- Deterministic output

### Implementation Considerations

**Fail Fast in Batch Mode:**
```bash
# Interactive: Prompts for missing input
nexum

# Batch: Should fail immediately
nexum --batch
# Error: Prompt required in non-interactive mode
# Exit code: 64 (usage error)
```

**No Prompts:**
```ruby
# BAD: Blocks forever in batch mode
def get_user_confirmation
  print "Continue? (y/n): "
  gets.chomp
end

# GOOD: Respects mode
def get_user_confirmation
  if agent_mode?
    raise "Cannot prompt in batch mode"
  end
  print "Continue? (y/n): "
  gets.chomp
end
```

**Testing Strategy:**
```bash
# Simulate non-interactive
echo "test" | nexum --batch

# Verify no prompts
timeout 5 nexum --batch
# Should fail immediately, not hang

# CI environment detection
CI=1 nexum -p "test"
# Should auto-enable agent mode
```

---

## 4. Handles Ctrl+C Gracefully (SIGINT)

### Requirement

When user presses Ctrl+C:
1. Save session state
2. Clean up resources
3. Print clear message
4. Exit with 130 (128 + SIGINT(2))

### Rationale

**User Expectations:**
- Ctrl+C means "stop now"
- Work should be saved
- State should be consistent
- Can resume later

**Anti-Pattern:**
- Lose work in progress
- Leave partial writes
- Exit without cleanup
- No indication of what happened

### Implementation Considerations

**Signal Handler Requirements:**
1. Respond immediately (no long delays)
2. Idempotent (handle multiple signals)
3. Save session checkpoint
4. Close file descriptors
5. Print to stderr (stdout may be piped)
6. Exit with 130

**Ruby Signal Handling:**
```ruby
Signal.trap('INT') do
  # Non-blocking, brief handler
  $stderr.puts "\nInterrupted. Saving session..."
  save_session_checkpoint
  exit(130)
end
```

**Challenges:**
1. **Re-entrant signals** - Handler called multiple times
2. **Thread safety** - Concurrent access to session
3. **IO safety** - Don't corrupt JSONL file
4. **Timing** - Save quickly, don't delay exit

**Solutions:**
1. Flag to prevent re-entry
2. Mutex around critical sections
3. Use atomic writes (write temp, rename)
4. Flush and close files in handler

**Testing Strategy:**
```bash
# Start long-running session
nexum &
PID=$!

# Send SIGINT
sleep 2
kill -INT $PID

# Verify:
# 1. Exit code 130
wait $PID
echo $?  # Should be 130

# 2. Session saved
ls ~/.local/share/nexum/sessions/*/interrupted
# Should exist

# 3. Clean message
# Should see "Interrupted. Saving session..."
```

**Open Questions:**
- Should Ctrl+C save named checkpoint ("interrupted")?
- Should it be resumable exactly where it left off?
- What about mid-API-call interruption?
- Should there be "force quit" (double Ctrl+C)?

---

## 5. Responds to SIGTERM for Clean Shutdown

### Requirement

When receiving SIGTERM:
1. Close session cleanly
2. Flush all buffers
3. Clean up temp files
4. Exit with 143 (128 + SIGTERM(15))

### Rationale

**SIGTERM vs SIGINT:**
- SIGTERM: "Please shut down cleanly" (from system/process manager)
- SIGINT: "User interrupted" (Ctrl+C)

**Use Cases:**
- Container shutdown (Docker, Kubernetes)
- Service manager (systemd, supervisord)
- Process manager (PM2, foreman)
- Deployment rollouts

### Implementation Considerations

**Handler Requirements:**
1. Graceful shutdown (not abrupt like SIGINT)
2. Complete current operation if possible
3. Proper cleanup (files, connections, temp data)
4. Log shutdown reason
5. Exit with 143

**Timeout Handling:**
- SIGTERM should initiate shutdown
- If shutdown takes too long, SIGKILL follows (can't catch)
- Goal: Complete within 5-10 seconds

**Testing Strategy:**
```bash
# Start session
nexum &
PID=$!

# Send SIGTERM
kill -TERM $PID

# Verify:
# 1. Exit code 143
wait $PID
echo $?  # Should be 143

# 2. Clean shutdown message
# Should see "Received termination signal..."

# 3. Session closed properly
# No corrupted files, all resources released
```

**Open Question:**
- Should SIGTERM behave differently than SIGINT?
- Should it try to complete current turn before exiting?
- Should it save "terminated" checkpoint vs "interrupted"?

---

## 6. Validates All Inputs

### Requirement

Validate all inputs before processing:
- Argument types and ranges
- File existence and readability
- Configuration values
- Session IDs
- Conflicting options

### Rationale

**Fail Fast:**
- Don't start processing if inputs invalid
- Clear errors before expensive operations
- Better UX (immediate feedback)

**Security:**
- Prevent injection attacks
- Validate file paths
- Check permissions

**Robustness:**
- Catch errors early
- Prevent cascading failures

### Validation Categories

**1. Type Validation**
```bash
--temperature 1.5     # Invalid: > 1.0
--max-tokens abc      # Invalid: not integer
--format xml          # Invalid: not supported format
```

**2. Range Validation**
```bash
--temperature -0.5    # Invalid: < 0.0
--top-p 2.0           # Invalid: > 1.0
--max-tokens 0        # Invalid: must be positive
```

**3. File Validation**
```bash
--system-prompt /nonexistent.md    # Invalid: file not found
--config /path/to/dir              # Invalid: is directory not file
--initial-context /no/permission   # Invalid: can't read
```

**4. Format Validation**
```bash
--resume "invalid format"          # Invalid: session ID format wrong
--checkpoint "spaces not allowed"  # Invalid: tag format
```

**5. Conflict Detection**
```bash
--continue --resume session-123    # Invalid: conflicting options
--batch --interactive              # Invalid: mutually exclusive
```

**6. Semantic Validation**
```bash
--resume session-123               # Invalid: session doesn't exist
--temperature 0.5 --deterministic  # Warning: conflicting intent
```

### Implementation Considerations

**Validation Phases:**

1. **Parse Phase** - Syntax validation
   - Are flags recognized?
   - Are values present?
   - Are types correct?

2. **Semantic Phase** - Logic validation
   - Do files exist?
   - Are ranges valid?
   - Do combinations make sense?

3. **Business Logic Phase** - Domain validation
   - Does session exist?
   - Is API key valid?
   - Is config well-formed?

**Error Accumulation:**
```ruby
# Collect all errors, report at once
errors = []
errors << "Temperature out of range" if invalid_temp
errors << "File not found" if missing_file
errors << "Conflicting options" if conflict

if errors.any?
  $stderr.puts "Validation errors:"
  errors.each { |e| $stderr.puts "  - #{e}" }
  exit(64)
end
```

**Testing Strategy:**
- Unit tests: Each validation rule
- Integration tests: Combined scenarios
- Property-based tests: Random inputs (fuzzing)

**Open Questions:**
- Fail on first error or collect all?
- Warnings vs errors (temperature + top-p together)?
- Should validation be strict or permissive?

---

## 7. Provides Helpful Error Messages

### Requirement

Errors must include:
1. What went wrong
2. Why it went wrong
3. What to do next
4. Where to get help

### Error Message Template

**Human-Readable (default):**
```
Error: <Error Type>
  <Context>
  <Details>

<Suggestions>
  - <Action 1>
  - <Action 2>

For more help: <URL or command>
```

**Machine-Readable (--format=json):**
```json
{
  "error": {
    "type": "SessionNotFoundError",
    "code": "SESSION_NOT_FOUND",
    "message": "Session not found",
    "context": {
      "session_id": "conversation_20251107_150000",
      "search_path": "~/.local/share/nexum/sessions/"
    },
    "suggestions": [
      "Run 'nexum list-sessions' to see available sessions",
      "Use 'nexum --continue' to resume last session"
    ],
    "help_url": "https://docs.nexum.dev/errors/session_not_found"
  }
}
```

### Examples

**1. Session Not Found**
```
Error: Session not found
  ID: conversation_20251107_150000
  Searched: ~/.local/share/nexum/sessions/

Try one of these:
  - nexum list-sessions         # View all sessions
  - nexum --continue            # Continue last session
  - nexum "new conversation"    # Start new session

For help: nexum --help
```

**2. Authentication Failed**
```
Error: Authentication failed
  API returned: 401 Unauthorized

Check your API key:
  1. Set environment variable: export ANTHROPIC_API_KEY=sk-...
  2. Or create file: ~/anthropic-default-api-key
  3. Verify key at: https://console.anthropic.com

For help: https://docs.anthropic.com/authentication
```

**3. Configuration Error**
```
Error: Configuration file invalid
  File: ~/.config/nexum/config.json
  Line: 5
  Problem: Expected closing brace, found comma

Fix the JSON syntax:
  - Use a JSON validator
  - See example: https://github.com/you/nexum/blob/main/examples/config.json
  - Or delete file to use defaults

For help: nexum validate-config ~/.config/nexum/config.json
```

### Implementation Considerations

**Key Principles:**
1. Be specific (not vague)
2. Be actionable (tell them what to do)
3. Be helpful (provide context)
4. Be consistent (same format)

**Error Context:**
- What operation was attempted
- What input was provided
- What was expected
- What actually happened

**Progressive Disclosure:**
- Brief error by default
- `--verbose` shows more details
- `--debug` shows stack traces

**Testing Strategy:**
- Trigger each error type
- Verify message format
- Check suggestions are accurate
- Validate help URLs exist

**Open Questions:**
- Should we have error codes (E001, E002)?
- Should errors link to docs automatically?
- Should there be a "did you mean..." suggestions?
- Should color be used in error messages?

---

## 8. Documentation Matches Implementation

### Requirement

- Help text accurate
- Examples work
- Flags documented
- Exit codes documented
- Behavior described correctly

### Why This Fails

**Common Causes:**
1. Help text written before implementation
2. Implementation changes, help not updated
3. Examples not tested
4. Copy-paste errors
5. Assumptions about behavior

### Solutions

**1. Generate Help from Code**
- Define flags in one place
- Generate help text from definitions
- Reduces duplication

**2. Test Examples**
```ruby
# Extract examples from help text
help_text = `nexum --help`
examples = help_text.scan(/^\s*nexum[^\n]+/)

# Test each example can parse
examples.each do |example|
  result = system("#{example} --dry-run")
  expect(result).to be_truthy
end
```

**3. Smoke Tests**
```bash
# Verify every flag in help actually works
nexum --help | grep "^  --" | while read flag desc; do
  nexum $flag --dry-run 2>/dev/null || echo "Broken: $flag"
done
```

**4. Version Control**
- Help text in version control
- Review changes to help in PRs
- CI checks for broken examples

**5. Documentation-Driven Development**
- Write help first (specification)
- Implement to match
- Ensures alignment

### Implementation Considerations

**Help Text Location:**
- Option A: Inline in code
- Option B: Separate file
- Option C: Generated from schema

**Machine-Readable Help:**
```bash
nexum --help --format=json
```
```json
{
  "version": "0.1.0",
  "usage": "nexum [options] [prompt]",
  "options": [
    {
      "flag": "--format",
      "type": "string",
      "values": ["text", "json", "stream-json"],
      "default": "text",
      "description": "Output format"
    }
  ]
}
```

**Benefits:**
- Tool can query capabilities
- Agents can discover options
- Shell completion can use it

**Testing Strategy:**
- Parse help text, extract flags
- Verify each flag exists in parser
- Run each example with --dry-run
- Check exit codes documented match actual

---

## 9. Works with `set -euo pipefail`

### Requirement

Must work correctly in strict shell mode:
- `set -e` - Exit on error
- `set -u` - Error on undefined variable
- `set -o pipefail` - Pipe fails if any command fails

### Why This Matters

**Strict Mode Enables:**
- Safe shell scripting
- Error detection
- Pipeline reliability
- Production deployment

**Common Pattern:**
```bash
#!/bin/bash
set -euo pipefail

# Script should exit if nexum fails
SESSION=$(nexum -p "test" --format=json | jq -r .session_id)
nexum --resume "$SESSION" -p "continue"
```

### Requirements

**1. Proper Exit Codes**
```bash
set -e
nexum --invalid-flag  # Must exit non-zero
echo "not reached"    # Should not execute
```

**2. No Undefined Variables**
```bash
set -u
nexum -p "test"  # Must not reference $UNDEFINED_VAR internally
```

**3. Pipeline Failures**
```bash
set -o pipefail
nexum -p "test" | jq .status  # If nexum fails, pipeline fails
```

**4. Clean Output**
```bash
# stdout must be clean for pipeline
nexum -p "test" --format=json | jq .  # Must not fail
```

### Testing Strategy

**Shell Script Test Suite:**
```bash
#!/bin/bash
# test/shell_integration_test.sh
set -euo pipefail

echo "Testing basic usage..."
nexum --version
echo "✓"

echo "Testing JSON pipeline..."
SESSION=$(nexum -p "test" --format=json 2>/dev/null | jq -r .session_id)
[[ -n "$SESSION" ]]
echo "✓"

echo "Testing error handling..."
if nexum --invalid-flag 2>/dev/null; then
  echo "✗ Should have failed"
  exit 1
fi
echo "✓"

echo "Testing resume..."
RESUMED=$(nexum --resume "$SESSION" -p "continue" --format=json 2>/dev/null | jq -r .session_id)
[[ "$SESSION" == "$RESUMED" ]]
echo "✓"

echo "All tests passed!"
```

**CI Integration:**
```yaml
# .github/workflows/test.yml
- name: Shell Integration Tests
  run: |
    bash -c "set -euo pipefail && ./test/shell_integration_test.sh"
```

---

## Testing Strategy Summary

### Unit Tests (RSpec)

**Scope:** Individual components
- Argument parser
- Validator
- Error formatter
- Exit code selection
- Mode detection

**Example:**
```ruby
describe "ArgumentParser" do
  it "validates temperature range" do
    parser = ArgumentParser.new(['--temperature', '2.0'])
    expect(parser.valid?).to be false
    expect(parser.errors).to include(/range/)
  end
end
```

### Integration Tests (PTY Harness)

**Scope:** End-to-end scenarios
- Interactive sessions
- Signal handling
- Multi-turn conversations
- Session resume

**Example:**
```ruby
describe "Signal handling" do
  it "saves on SIGINT" do
    pty = Support::PtyHarness.new
    pty.spawn("bin/nexum")
    pty.wait_for("> ")
    pty.send_signal('INT')

    output = pty.read_until("Saving session")
    expect(output).to include("Interrupted")
    expect(pty.exit_status).to eq(130)
  end
end
```

### Smoke Tests (Shell Scripts)

**Scope:** Basic functionality
- All flags work
- Examples in help work
- Exit codes correct
- Pipelines work

**Example:**
```bash
# Basic smoke test
nexum --version || exit 1
nexum -p "test" --format=json | jq . || exit 1
echo "Smoke tests passed"
```

### Property-Based Tests (Optional)

**Scope:** Random inputs
- Fuzzing argument parser
- Random temperature/top-p values
- Random file paths
- Stress testing

---

## Continuous Integration

### CI Pipeline Requirements

**Phase 1: Fast Tests (<30s)**
- Unit tests (RSpec)
- Smoke tests (basic invocations)
- Help text validation

**Phase 2: Integration Tests (<2min)**
- PTY integration tests
- Signal handling
- Session management

**Phase 3: Shell Integration (<5min)**
- Strict mode tests
- Pipeline tests
- Multi-command scenarios

**Phase 4: End-to-End (Optional, <10min)**
- Full conversation tests
- API integration (with mocks)
- Performance benchmarks

### GitHub Actions Example

```yaml
name: Test

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: 3.2
          bundler-cache: true

      - name: Unit Tests
        run: bundle exec rspec spec/unit

      - name: Integration Tests
        run: bundle exec rspec spec/integration

      - name: Shell Integration
        run: bash test/shell_integration_test.sh

      - name: Smoke Tests
        run: |
          bin/nexum --version
          bin/nexum --help | grep "USAGE"
```

---

## Open Questions

### Testing Priorities

**Q1:** Which tests are MVP (Phase 1) vs later?

**Proposal:**
- Phase 1: Unit tests, basic smoke tests
- Phase 2: Integration tests, shell tests
- Phase 3: Property-based tests, fuzzing

**Q2:** How much mocking of API calls?

**Options:**
- A: Mock all API calls (fast, isolated)
- B: Real API calls with test key (slow, realistic)
- C: Hybrid (mock in unit tests, real in integration tests)

**Q3:** Test fixtures vs generated data?

**Options:**
- A: Check in fixture JSONL files
- B: Generate on the fly
- C: Both (fixtures for regression, generated for coverage)

### CI/CD Integration

**Q4:** Run tests on every commit or only PRs?

**Q5:** Required coverage percentage?

**Proposal:** 80% for Phase 1, 90% for Phase 2+

**Q6:** Performance regression testing?

---

## Success Criteria

CLI testing is successful when:

- [ ] All 10 checklist items pass
- [ ] Test suite runs in <5 minutes
- [ ] Coverage >80%
- [ ] Shell integration tests pass
- [ ] CI prevents broken commits
- [ ] Tests run on every PR
- [ ] Documentation examples tested
- [ ] No flaky tests

---

## Document Status

- **Draft:** 2025-01-06
- **Implementation:** TBD
- **Review:** Pending
