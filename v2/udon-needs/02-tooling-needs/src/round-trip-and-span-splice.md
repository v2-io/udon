---
slug: round-trip-and-span-splice
type: demand
register: [evidenced, decided]
support-kind: [design, observational]
strength: robust-qualitative   # the two-guarantee demand holds from several directions; product family deliberately open
convergent: [design, observational]   # estate design plus shipped-tool behavior as an independent failure mode
verified:
  - 2026-07-22 · frontmatter-migration · pilot-A · axes assigned from the chapter's claim; convergent legs audited under the failure-mode-independence key
stage: drafted
consumers: "udon-primary (harness: edit-tool substrate requirements)"
depends: [schema-guarded-mutation, freshness-and-atomicity]
sources:
  - ../../01-ideation/02-provenanced/commentary/spikes/agent-utility-NOTES.md  # §4 read whole
  - ../../pipeline-discussion.md  # ornamental criterion turns (~L98–130, 500s)
  - ../../01-ideation/02-provenanced/syntheses/tier2-invivo-digest.md  # obsidian-linter, yq singletons
  - ../../01-ideation/needs-map.md  # S6
---

# Round-trip and span-splice: the edit substrate is not the formatter

**Claim.** An agent editing a document needs two guarantees at once:
**byte identity for every span it didn't touch**, and **model identity
for the span it changed** — serialize the changed subtree with correct
geometry for its insertion site, splice it in, leave every other byte
alone. Whole-file house-style formatting is a *different product* that
shares machinery but must never be the write path's default. Conflating
the two produces bad edit tools; the evidence says so from three
directions.

## The evidence

- **Why agents care — and it isn't aesthetics.** Two hard consumers
  need untouched regions to stay byte-identical: minimal-changeset
  economics (the theory's locality results — at equal size, a
  concentrated change costs less than a scattered one, and a small diff
  costs less to comprehend than a rewrite), and everything downstream
  that diffs or patches against the file on disk. The demand list from
  the design work: serialize a subtree with correct indentation for its
  destination; escape correctly without the agent thinking about it;
  re-apply idempotently under stable addresses — the
  bidirectional-programming "lens laws," which say an edit written back
  and re-read must yield the model you asked for, and writing back an
  unchanged read must change nothing. Its summary sentence: "Agents
  mostly want model-level certainty + local spatial correctness, not
  global pretty. Humans want fmt. Both are real; conflating them
  produces bad edit tools."
- **The ornamental criterion — a testable line between the two
  products.** Joseph's double-fixpoint test: strip discretionary
  geometry → build the model → emit in house style; then do it again;
  both the model and the bytes must come out stable. **Ornamental**
  means geometry that changes the look without changing the assembled
  meaning — extra blank lines, alignment padding, indent width beyond
  the minimum. Comments are *not* ornamental; they are content. This
  gives "what may the formatter touch?" a criterion instead of a taste
  war — and gives the edit tool its converse rule: the agent write path
  preserves untouched bytes and never applies house style unless asked.
- **Prior art at the two edges.** On the span side, the yq tool shows
  what the substrate looks like: a match operator returning the string,
  its byte offset, its length, and its captures, plus line/column
  operators — position as first-class queryable data. On the formatter
  side, a popular linter is the honest warning: its own documentation
  admits its rules interfere and don't compose cleanly. Many
  independently toggleable style rules form a non-commutative system —
  an argument for one coherent house-style profile over a rule bazaar.
- **The layers of "the same document."** Equivalence comes in grades:
  byte-identical; same recognized structure; same meaning after
  normalization; same value after an application projects it. The edit
  substrate works at byte identity for context and meaning identity for
  the change; a formatter works between the middle grades; and each
  conversion target (JSON, TOML, YAML, Markdown, native structures)
  picks its own grade and loss policy. That is why "the products" form
  an open family rather than a fixed list — a graph of transformations,
  not a single line.

## What it generates

- **For UDON:** the serializer-and-spans substrate sits on the build
  path *before* any edit tool — and its wire-side prerequisites are
  already decided in the [[DECISIONS.md|design ledger]]: value extents
  explicit on the wire, text reconstructable by pure concatenation. The
  open design work — sugar-aware round-trip (does `$traits` write back
  as `.trait`?), where emit-style profiles live — belongs to the
  round-trip product family, shaped by the fixpoint criterion rather
  than per-case taste.
- **For the harness:** any document-state tool it ships inherits the
  same split — mutation preserves bytes; normalization is a separate,
  explicit act. Human review of agent edits depends on exactly this:
  a reviewer can trust a three-line diff, and cannot trust a
  three-hundred-line reformat with an edit hidden inside it (the
  [[steering-and-verification-surfaces| steering chapter]] picks this
  up).

## What this opens (ideas, not designs)

- ✦ **The criterion as a running check.** The double-fixpoint test is
  executable: strip → model → emit → strip → model → emit, assert both
  stabilities. A formatter whose test suite *is* the criterion can
  never drift into meaning-changing "style."
- ✦ **Diff legibility as a measured property.** If span-splicing exists,
  agent edits produce minimal diffs; if it doesn't, reviewers wade
  through reformat noise. "Median human-reviewable diff size per agent
  edit" is a measurable number that would price the substrate's value
  in reviewer time — the human side's stake in what looks like an
  internals decision.
- ✦ **House style that travels with the file.** If emit-style profiles
  exist, a document could declare its own — style as data, applied by
  any conforming formatter, so "which style?" stops being a per-tool
  argument. Whether that declaration belongs in the document or beside
  it is exactly the kind of question the design work ahead owns.
- ✦ **The span map as a public product.** The substrate could expose what
  it knows: a per-node byte-span table emitted alongside any parse, so
  *any* tool — not just the blessed editor — can splice precisely
  without reparsing. The yq operator shows the demand; a first-class
  span product would answer it once, for every consumer.

## Honest edges

The lens-law framing is stated, not proven, for UDON's model —
idempotent re-apply under stable addresses is a target, unverified
against real parse trees; nothing here has running code. The ornamental
criterion is ratified *as a criterion*, but its full boundary — what
counts as discretionary geometry in every construct — is deliberately
unenumerated: that enumeration is formatter-product work, and an earlier
drafting effort's premature attempt at it is precisely what got
archived. The demand side must force it, case by case.
