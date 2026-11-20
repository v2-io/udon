# 91 — Must lite be readable in one pass, line by line? And does it set any limits?

## The question

1. **One pass.** 0.10.0 makes "bounded lookahead" a law of the language: every decision is made within a few characters, so a document parses the same whole or streamed a byte at a time. Does lite keep that law? Several alternatives in other pre-design files would break it.
2. **Limits.** Does lite say anything about nesting depth, line length, or document size — or leave them to implementations?

## Why lite must decide

The one-pass law decides which alternatives are even available elsewhere, and it is what lets small parsers in any language (the 2026-08-30 "tiny parser" request) be simple. Limits matter because a lite parser that recurses per nesting level can be crashed by a deep document; YAML tooling has hit this.

## What the texts say

- **Dec 2025, 0.7-draft** ("Streaming Parse"): "Parse as data arrives (LLM streaming) · Emit complete subtrees as they close · Pause/resume with state preservation." `_archive/analysis.md` §9 "Streaming / Online Parse Mode": "Decision: Yes. Support callback/event mode."
- **0.10.0 §2.3 "Bounded lookahead (language law)":** "Every guard resolves within a few characters, single-level, with no unbounded backtracking. This is a constraint on the **language**, not an implementation note: new syntax MUST stay inside the bound. … a document parses identically whole or byte-at-a-time."
- **0.10.0 §13.3:** end of input is the producer's signal, "never a chunk boundary"; a construct still open at end of input marks the document `incomplete-input`.
- **2026-08-30, `v2/INBOX-REQUESTS.md`:** tiny dependency-free parsers, "regex or very simple recursive descent."
- **2026-09-29, `spec-lite-0.1.0/README.md`:** "No bespoke lite parser needed. The mainline recursive-descent grammar (descent) is the implementation route."
- **Dec 2025 YAML stress test** (`udon-needs/02-tooling-needs/reports/yaml-stress-test.md` "Risk 6: Nesting Limit"): "Impact: High (catastrophic failure) … Add validation: Reject efforts with >100 levels nesting · Document limit clearly."
- **Nothing found** on limits in any UDON spec version. (Searched: case-insensitive grep "limit\|depth\|maximum" in `v2/spec-0.10.00/CORE.md` and `spec/CORE.md` — the only hits are "delimited" and "depth-counted".)

## Alternatives that need more than a few characters of lookahead (from other files)

| File | Alternative | What it must see first |
|---|---|---|
| [08](08-pipes-and-markdown-tables.md) B | a line starting and ending with `\|` is a table row | the end of the line |
| [81](81-structure-inside-an-indented-text-block.md) Q2-B | the text's left edge is its leftmost line | the whole text block |
| [74](74-attribute-values-on-following-lines.md) | whether `:label` alone is an error depends on whether something is indented under it | the next non-blank line |
| [13](13-ast-shape.md) Q5 | whether a trailing blank line is text or layout | what follows it |

## Alternatives

### One pass

**A — lite keeps the bounded-lookahead law as stated.** **B — lite requires only line-at-a-time reading** (a whole line may be seen before deciding). **C — lite is specified as a tree over a whole document; streaming is an implementation option.**

### Limits

**A — none stated.** **B — a minimum every lite parser must support** (e.g. nesting depth N, line length M), beyond which behavior is implementation-defined. **C — a hard maximum** (deeper documents are not valid lite).

## Interactions

- [12](12-missing-values-and-what-counts-as-valid.md): whether hitting a limit is an anomaly.
- [13](13-ast-shape.md): lite is AST-centric; streaming may or may not be part of its promise.
