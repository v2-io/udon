# UDON Consumers — live usage registry

Documents in active use outside this repo. **Purpose**: when a spec release
lands, a defect fix changes behavior, or a new tool becomes available
(linter, formatter, paths), this is the list of who must be migrated or
told. Refresh with `bin/find-consumers` and update the table; last full
scan: **2026-07-16**, a *differential* scan — every document parsed with
both the `core-v0.8.0`-tagged parser and the current parser (CORE
0.9.0-alpha.1 attribute model, compliance gate green), full event streams
diffed. Counting method also tightened that day: exposure counts are now
occurrences on markup-rooted lines only, so prose *discussing* UDON syntax
(these docs do a lot of that) no longer inflates the numbers — totals are
not directly comparable to the 2026-07-11 scan's.

## Scan roots

- `~/src/archema-io/**/*.udon` — the ARCHEMA program (will become
  `~/src/archema/` eventually; distinct from `~/src/rowan/`, the former
  ruby ash port that previously held the archema name)
- `~/src/**/*.udon` (depth-limited) — catches consumers outside archema-io
- Excluded: this repo, `~/src/_ref/`, `.git`, `.claude/worktrees/` (agent
  worktree copies shadow their originals)

## Live inventory (2026-07-16)

| Document | Lines | Exposure | 0.9 parse | Notes |
|---|---|---|---|---|
| `archema-io/asf/msc/meta-process-review-2026-07-07/PROCESS-MAP-v0.udon` | 489 | 50 `[key]`, 6 `\|process[k]?` suffixes, 1 attr-date, 1 raw | clean | The founding adopter — ASF process map |
| `archema-io/vivarium/DECISIONS.decision-log.udon` | 903 | 75 `[key]`, **78 attr-dates**, 1 raw | clean | NEW since last scan (first commit 2026-07-12); largest doc, heaviest temporal exposure, actively growing (897→903 lines within hours during the scan) |
| `archema-io/vivarium/LEXICON.udon` | 617 | 112 `[key]`, 24 attr-dates, 3 raws | clean | Heavily reworked since last scan (was 1151 lines) |
| `archema-io/vivarium/doc/PROCESS.udon` | 198 | 24 `[key]`, 1 attr-date, 2 raws | clean | One of the two raws is an accidental prose→directive promotion (see findings) |
| `archema-io/vivarium/tabularium/terrestris.ordinum.udon` | 429 | 82 `[key]`, 1 attr-date | clean | NEW since last scan (first commit 2026-07-11) |
| `autopax/taxonomy.udon` | 371 | 51 `[key]`, 6 attr-dates | clean | 3 changelog `:authors` values changed meaning under 0.9 — toward author intent (see findings) |

**Aggregate exposure**: 394 `[key]` identities and 111 date-valued
attributes across ~3,000 lines (the 2026-07-11 scan saw ~2,200 lines in
four documents — the corpus is growing fast, mostly in vivarium). **Nobody
uses `@` references, inline `|{…}` elements, freeform fences, `<…>` value
envelopes, or `:key?` flags yet** — so those features still have zero
migration cost, and the pre-0.8 open decisions that used to be tracked here
(identity syntax, temporal/value-dialects, fences — the archived review's
"decisions 1/2/8") are all **resolved and ratified** in CORE 0.8/0.9:
`[key]` ⇒ `:'$key'`, suffixes ⇒ `:'$?'` etc., bare temporals demoted to
plain strings, `<…>` reserved for the dialect layer, fences specified.

## How the corpus fared under 0.8 → 0.9 (measured 2026-07-16)

- **Zero errors, zero warnings, all six documents, under both parsers.**
  Specifically: no valueless plain attributes anywhere, so the 0.9
  `MissingAttributeValue` error path never fires and no 0.8 implicit-true
  attribute needs respelling as a `:key?` flag; and **no block line holds
  more than one attribute** (`:a 1 :b 2`), so the block run-to-EOL →
  uniform-scan change has zero live sites.
- **The bulk of every diff is a wire-level rename, not a meaning change**:
  multi-word text-blob values now arrive as `Text` segments where 0.8 said
  `BareValue` — byte-identical content, same spans, same owner. Event-level
  consumers must accept `Text` in attribute-value position; tree-level
  meaning is unchanged. (Block-line values are also typed by the uniform
  scan now — a block `:a 1` yields `Integer` where 0.8 ran-to-EOL as a
  string — but no live site changes type.)
- **Two real meaning changes, both toward author intent**:
  1. `autopax/taxonomy.udon` — three changelog entries of the form
     `|entry :date 2025-09-28 :authors Joseph, Architectus`: 0.8 gave
     `authors = "Joseph,"` with `Architectus` stranded as element prose;
     0.9 gives `authors = "Joseph, Architectus"` (blob ownership row 1).
  2. `vivarium/doc/PROCESS.udon`, `|norm[flagged-file-routing]` — under
     0.8 the framed ` ; ` comment after the `:files […]` array value
     closed the element early, orphaning the norm's explanatory prose to
     its parent; under 0.9 the prose is inside the norm, where it belongs.
- **Bare dates are plain strings under both parsers** (0.8 removed bare
  temporal recognition) — all 111 date-valued attributes are unvalidated
  `"2026-07-12"`-style strings by design until the temporal dialect lands.
  A `<…>` envelope parses today but draws a `NoDialectsLoaded` warning; no
  consumer uses one, correctly.

## Migrations owed / offered (findings for the consumers' stewards)

- **None mandatory** — every live document parses clean under the current
  parser, and the two meaning changes above already read as the authors
  intended.
- `vivarium/doc/PROCESS.udon`: (a) in the `[udon-safe-subset]` norm, prose
  reflow left `!:lang:` at the start of a line — it parses as a real raw
  directive. Until 2026-07-16 the rest of that line was silently **absent
  from the event stream**; Joseph ruled that a plain bug the same day and
  the tail is now captured as the raw body — but the promotion itself
  remains (the sentence displays as a code block, not prose). Re-wrap the
  paragraph or escape the sigil (`\!:lang:`). The very next clause of that
  norm states the equivalent rule for line-initial `:`.
  (b) The same file's `[flagged-file-routing]` norm quotes its `:files`
  list items as a workaround for defect #13 ("fix pending") — that defect
  is fixed; bare dotted items (`.archive/…`, `ref/…/x.md`) now parse
  clean, so the workaround and its comment can be retired at leisure.
- `autopax/taxonomy.udon`: the three `:authors Joseph, X` values now mean
  what they say; if anything downstream compensated for the 0.8
  truncation, un-compensate.

## Notification triggers

Ping/migrate consumers when any of these land:

1. **Temporal dialect layer** — the 111 date-valued attributes are the
   migration surface (offer `<…>` envelopes or whatever pragma/profile the
   dialect design settles on). `DECISIONS.decision-log` (78) is the heavy
   one and grows daily.
2. **Identity tooling surface** — 394 `[key]` sites. The syntax is
   ratified (`[key]` ⇒ `:'$key'`), so remaining exposure is
   tooling-visible naming (AST accessors, paths, schema), not document
   edits.
3. **Parser regeneration or spec releases** — `bin/find-consumers --check`
   catches new errors/warnings; for *silent meaning changes*, repeat the
   differential method: build the previous release's parser from its tag
   (`git worktree add /tmp/udon-vX core-vX.Y.Z && cd /tmp/udon-vX/core &&
   cargo build --release --example stdin_parse`), run both over each
   document, diff the event streams.
4. **First tool releases** (`udon-cli` lint/fmt/skeleton) — proactively
   offer to the ASF/vivarium/autopax workflows. A linter that detects
   reflow sigil-promotion would have caught the live `!:lang:` promotion
   in PROCESS.udon — that hazard class now has a confirmed field instance.

## Candidate future consumers (unscanned — an adoption watchlist)

From the January backlog (preserved when `notes/NEXT.md` drained,
2026-07-16): document classes Joseph has considered moving to UDON —
ADRs, Axiomata, Signa, Archema, Operata, Lexicon *(now live — see
inventory)*, Memorata, descent grammars *(already are UDON)*, A2A agent
communications, mentoring-feedback docs, Loci. When one goes live, it
gets an inventory row and its exposure counted.

## Discipline

- Re-scan on every spec release and parser regeneration
  (`bin/find-consumers` diffs against the inventory above).
- New consumers: add a row with exposure counts (the scan prints them).
- Consumer documents are read-only from this repo's side — surface
  migrations to their stewards (vivarium/ASF/autopax), don't edit them.
- This registry is itself a candidate for `.udon` once the linter exists.
