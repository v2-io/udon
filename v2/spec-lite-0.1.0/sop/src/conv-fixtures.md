---
kind: convention
awaiting-second: true
awaiting-decision: false
needs-work: false
per: [fixtures-are-records, fixture-file-shape, notes-disposition-at-freeze]
depends: [def:record-kinds, def:fixture-profiles, conv:references]
---

# Fixtures are records that no outline lists

*A ⟦fixture⟧ file is one record of kind `fixture`. Rules cite it; outlines don't list it. Case ids inside it are stable anchors.*

## Statement

- **A fixture file is one record of kind `fixture`**, at file grain, with a slug of its own (`dat/implied-root.yaml` → `[[fixture:implied-root]]` in the spec store).
- **Its shape is one YAML mapping** ([[decision:fixture-file-shape]]): the record's fields first (`kind: fixture`, the three flags, `depends`, `notes`), then `cases:`, a list of cases each with a stable `id`. `notes:`, on the file or on a case, holds working notes. A case's reason for existing, once *kept*, goes in its `why:` field ([[decision:notes-disposition-at-freeze]]).
- **No outline lists fixtures.** Being in an outline is a view's choice. It is not what makes something a record.
- **A rule cites its fixtures** through ⟦test-fixtures⟧ in its frontmatter. Prose may transclude one case: `![[dat/implied-root.yaml#root_top_level_label]]`.
- **Case ids are stable names that are never reused.** A name like `root_top_level_label` survives reordering; a positional id like `C7` does not.
- **Each case has a ⟦profile⟧** (see [[def:fixture-profiles]]). Canonical and idiomatic cases are normative even though no outline lists them, so flipping one changes what the spec means.
- **Prose around a transcluded case goes stale** when that case changes.

## How a violation shows

- A `test-fixtures:` entry or a transclusion that doesn't resolve.
- A reused case id.
- A fixture file with no kind key, or more than one YAML document.
- A fixture file named with another kind's prefix.

## Why

- Joseph: "It's a kind of record that is used for mechanisms outside of the outline..." (`sop/influx/jaw-proposal-and-feedback.md` §1.6). He rejected the idea that fixtures should stop being records at all: "I'm all the more confused though by what looks like a suggestion to make them *not* verisectorium records, while simultaneously giving them *more* verisectorium-record machinery" (§1.7 item 10).

## Working notes

- **A record-level `per`** is not part of the decided shape. The example keeps `per` on each case, because cases rest on different decisions, and a descriptive case gains one when it flips.
- **Parked machinery** (§1.7 item 10, §3.12). A rule's verification ("a parser agrees") could record the fixture file's git hash beside its own, so a flipped canonical case marks the rule stale. This is more advanced than anything else here so far. This may be the place that machinery is first built and made concrete.
