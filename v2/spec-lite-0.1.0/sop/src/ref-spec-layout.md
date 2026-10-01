---
kind: reference
awaiting-second: true
awaiting-decision: false
needs-work: false
source: the spec-lite-0.1.0 directory as of 2026-09-30 (Joseph's renames the same day); run aspectus there for the current state
per: [directories-organizational, main-outline-name]
depends: [conv:records, def:record-kinds]
---

# Where things are usually kept

*The spec-lite-0.1.0 layout as of 2026-09-30. Directories are for organization only, so this is a map, not a rule (see [[conv:records]]).*

## The layout

```text
spec-lite-0.1.0/
  main.outline.md   the spec store's primary view
  obj/              objectives, principles (and fitness, if admitted)
  src/              rules, properties, explanations
  def/              lite's term-groups: «…» terms (a LEXICON view will be generated; none yet)
  dat/              fixture records (not listed in outlines)
  adr/              lite's decisions (udon team); TEMPLATE.md
  bin/              bespoke processing scripts, which will inform vsect (empty so far)
  .vsect/           the spec store's kinds file (proposed from the SOP side)
  .int/             integration surface: README, reserved, scratch-jaw, pre-design/ (the open questions), vsect requirements on lite, questions from the examples
  .old/             set aside; vsect-init/ holds the first-pass samples
  sop/              the SOP store
    main.outline.md the SOP store's primary view
    src/            directives, conventions, references
    def/            SOP term-groups: ⟦…⟧ terms
    adr/            process decisions
    .vsect/         the SOP store's kinds file
    influx/         the SOP store's integration surface (prominent on purpose)
```

## Why

- Why `.int/` but `sop/influx/`: the spec store's integration surface should sit behind the canon, so it is a dot-directory. The SOP store's should stay prominent (`sop/influx/jaw-proposal-and-feedback.md` §1.8).

## Cautions

- This is a reference, so it goes stale as the directories move. Re-check it against `aspectus --lines 150 --depth 3` before relying on it.

## Working notes

