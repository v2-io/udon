# UDON

**Universal Document & Object Notation**

UDON is what you get when "Markdown with YAML frontmatter" grows up—structure and prose interleaved freely, at any depth, without the seams, crystal clear even without syntax highlighting, for humans and AI alike.

```
|article[intro].featured
  :author Joseph Wecker
  :date 2025-12-22
  :tags [udon notation design]

  |heading Welcome to UDON

  UDON treats documents and data as the same thing—because they are.
  Structure and prose coexist naturally.

  - The **readability** of Markdown for prose
  - The **structure** of XML without closing tags
  - The **simplicity** of YAML without the footguns

  !code :elixir
    defmodule Hello do
      def world, do: IO.puts("Hello from UDON")
    end
```

The project originated in 2011, paused, and is now being revived with the benefit of 14 years of hindsight—including the rise of AI agents that read and write configuration constantly, streaming output in terminals without syntax highlighting, and the hard-won lessons of YAML's "Norway problem."

Dynamics (`!if`, `!for`, `!{interpolation}`) leverage indentation to eliminate closing tags entirely.

## Documentation

| Document | Description |
|----------|-------------|
| [SPEC.md](SPEC.md) | Full specification (v0.7-draft) |
| [analysis.md](analysis.md) | Design rationale, TST evaluation, and historical context |
| [examples/](examples/) | Comprehensive syntax examples |

## Historical Repositories

The original work is preserved in reference repositories:

| Repository | Contents |
|------------|----------|
| `~/src/_ref/udon/` | Main specification, examples, Ruby parser |
| `~/src/_ref/udon-c/` | C implementation with high-performance state machine parser |

### Key Files in Historical Repos

| Purpose | Location |
|---------|----------|
| Best syntax examples | `~/src/_ref/udon/examples/overview.udon` |
| Original design decisions | `~/src/_ref/udon-c/docs/DECIDED.md` |
| C parser source | `~/src/_ref/udon-c/lib/udon.c` |
| Original objectives | `~/src/_ref/udon/doc/objectives.asciidoc` |
| State machine spec | `~/src/_ref/udon/ruby/udon/udon.statetable` |

## Published Artifacts

- **RubyGems:** `udon` gem, version 0.0.4 (namespace reserved)
- **License:** MIT

## Status

Revival in progress. See [analysis.md](analysis.md) for resolved design decisions and next steps.
