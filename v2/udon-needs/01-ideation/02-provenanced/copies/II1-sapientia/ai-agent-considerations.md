---
source: sapientia tool-consciousness corpus (Joseph & Zi-am-tur, Sept 2025) — verbatim copy of cli-conventions/ai-agent-considerations.md
gathered: 2026-07-21
status: gathered (verbatim whole-file copy)
paths:
  - ~/src/_core/sapientia/cli-conventions/ai-agent-considerations.md
source_commit: 1ecc9f77e4884906dec1d2c1032f2a51ff3ee5e4
categories: [tier1-ideology, agent-mode-detection, agent-cli, structured-io]
why_included: >
  Concrete agent-mode contract: auto-detect agent mode (!isatty, CI env, merged streams, *_AGENT_MODE=1, --format=json); agent-mode behavior (no spinners/colors, structured output, deterministic ordering, fail-not-prompt); machine-readable help/--list-flags/completions. The most operational single answer in the corpus to 'what should a tool DO differently when its caller is an agent, not a human.'
---

## AI Agent Considerations

### Auto-Detection of Agent Mode
Trigger agent mode when:
- Non-interactive terminal (`!isatty()`)
- CI environment variable set
- Streams are merged (stdout==stderr)
- `MYTOOL_AGENT_MODE=1` environment variable
- `--format=json` or other structured format requested

### Agent Mode Behavior
- No progress indicators or spinners
- No colors or text formatting
- Structured output preferred
- No interactive prompts (fail instead)
- Deterministic output ordering
- Include metadata in structured output

### Recommended Agent Invocation
```bash
# Explicit agent-friendly invocation
mytool [command] \
  --format=json \
  --no-progress \
  --no-color \
  --batch

# Or via environment
export MYTOOL_AGENT_MODE=1
mytool [command]
```

### Help for Agents
```bash
# Machine-readable help
mytool --help --format=json

# List available commands/flags
mytool --list-commands
mytool --list-flags
mytool subcommand --list-flags

# Generate shell completions
mytool --generate-completion bash|zsh|fish
```

