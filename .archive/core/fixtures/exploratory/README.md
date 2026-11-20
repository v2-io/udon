# `exploratory/` — a non-gating multi-line sandbox

> **This is not a compliance group. Nothing here is ratified.**

A sibling of the version-scoped compliance groups (`v0.9/`, `v0.8/`,
`legacy-pre-0.8/`) that the harness runs. This directory is **deliberately
outside** all of them: the compliance gate only ever reads
`ACTIVE_GROUP` (`v0.9/`, see `../udon-core/tests/common/loader.rs`), so
nothing here can gate a release.

## What it's for

CORE's **"Line-boundedness (current version)"** subsection locks two delimited
constructs multi-line (`|{...}` embedded, ` ``` ` freeform) and declares every
*other* delimited construct **single-line for now, multi-line deliberately
undefined** — "close them on the line they open," and "what the current parser
does at an embedded newline is not a guarantee and varies — some warn, some
silently tolerate it — and either may change."

This sandbox is a **testing-ground for those undefined cases**: for each such
construct — `<...>` typing envelope, `"..."`/`'...'` strings, `[...]` arrays,
`[...]` identity keys, `!{{...}}` interpolation, `;{...}` inline comments, and
`!{...}` / `!{:kind:...}` inline directive/raw — a few multi-line-spanning
variations (closer on a later line vs never closed; interior indentation;
nested), each recording **what the parser does today** and noting **what
ambiguity it opens up** for the eventual multi-line/dialect ruling.

## The inverted discipline (important)

Normal UDON fixtures assert *desired* behavior from CORE and a mismatch is a
parser bug (see `../fixtures/README.md` and `core/CLAUDE.md`). **Here it is the
opposite.** These inputs are undefined-by-ruling, so there is no "correct"
answer to assert. Each recorded `events:` block is **CURRENT, exploratory, NOT
ratified** parser output — and *this is the one place where capturing current
output is legitimate and desired*, precisely because the ruling left these
undefined. A future diff is **informative** (the parser or spec moved), **not a
failure**. Do not "fix the parser to this file"; when the multi-line/dialect
ruling lands, the illuminating cases graduate into a real versioned group with
spec-derived expectations.

Two kinds of case:

- **`events:` filled** — current output is stable, recorded as CURRENT.
- **`events: []`** — current output is messy/buggy/undefined; the case is a
  no-panic probe only, with the observed behavior described in the comment
  (asserting buggy output would risk cementing it).

Cases marked **`★ BUG`** are genuine parser bugs surfaced while building this
(they contradict ratified rules — keep-everything, "Unclosed\* are Warnings,"
the Warning-codes registry), written up in the session report — not merely
"undefined multi-line."

## How to run

Never runs in CI or the compliance gate. Play it explicitly:

```bash
cargo test -p udon-core --test exploratory -- --ignored --nocapture
```

The runner (`../udon-core/tests/exploratory.rs`) loads every `*.yaml` here and
prints each case's input and current events; where a case has recorded
`events:`, it reports MATCH or **DRIFT** — drift is reported, **never
asserted**, so this test cannot fail a build (a genuine parser *panic* would,
and that is itself a find).

## Adding cases

Drop more cases into `multi-line.yaml` (or a new `*.yaml` here). The runner
discovers files dynamically. Keep each case's comment answering two questions:
`# CURRENT (exploratory, not ratified):` what the parser does, and
`# ambiguity:` what would need deciding for real multi-line support.
