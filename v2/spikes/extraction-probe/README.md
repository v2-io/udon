# extraction-probe — probe 8 run against the live estate

**Register: measured-by-instrument, PINS CURRENT PARSER** (the 0.9.0-alpha.2
lineage in `core/`; per S2 every number here describes what *that parser*
reads, never what the language defines). Run 2026-07-29 by one agent (Fable),
instrument built the same day. The probe is schema-ideation §6.3 item 8; its
three questions — is extraction near-mechanical, is the result
author-recognizable, does rerun-diffing detect drift — are answered below at
their honest states (measured / **open, needs authors** / procedure-ready).
Full per-corpus tool output: [`raw/2026-07-29/`](raw/2026-07-29/). The tool:
[`extractor/`](extractor/) (`cargo build`, then
`extractor/target/debug/defacto-extract <files…>`; output is deliberately
debug-shaped scratch — **not a schema format**, per the O11 discipline that
incidental formats get imitated as law).

---

## 0. Conclusions

1. **Extraction is near-mechanical in UDON — the §1.0 claim held.** One
   ~600-line event-stream walker, zero per-corpus configuration, produced a
   recognizable-to-me de-facto schema for every corpus tried: per element —
   attribute presence tiers, value kinds, sameline-vs-block placement,
   dominant attribute order, child vocabulary with cardinality, layout shape.
   The judgment content of this run was in *building the instrument once*
   (value-ownership inference, below), not per-corpus.
2. **The de-facto schemas of the live corpora are crisp, not mushy.**
   Attribute presence clusters at 100% or ≤30% with almost nothing in
   between; attribute *order* is near-uniform where records repeat
   (`[date by status topic session]` on 91/121 vivarium decisions;
   `[date by status context]` on 15/15 register thoughts; `[to kind]` on
   62/62 lexicon rels); the sameline convention O6 predicted is measurable
   (short greppable state sameline, prose-length values block).
3. **Presence is not intent — confirmed concretely.** The stats cannot say
   whether `:session` (100% present) is *required* or merely never-omitted;
   extraction yields the open half of a schema exactly as O6's needs-note
   predicted. The deliberateness bits UDON has seats for (`$!`/`$?`
   suffixes) appear in exactly one corpus — the schema-dsl *example* — and
   in no live corpus; the O11 gap is visible in the data.
4. **The drift-detector claim demonstrated itself incidentally**: the run
   surfaced live latent defects nobody knew about (§3) — including one
   record in vivarium's DECISIONS whose `:session` is silently prose, and a
   parse bug in this estate's own DISCUSSION-THOUGHTS register (fixed this
   run, §3.2).
5. **The dogfood finding is the sharpest (§4):** the descent grammar files —
   the oldest continuously-working UDON in the estate, the source the
   current parser is generated from — read as ~80 warnings + ~20 errors
   under that very parser. The divergences are systematic, not noise, and
   they land on two already-open design questions (bracket-interior
   raw-vs-value = REF-BRACKET/O13; pre-0.9 bare flags = a ready-made O7
   migration census with exact counts).

## 1. Instrument notes (read before trusting any number)

- **Event-pass only, by necessity.** The shipped tree layer
  (`udon_core::tree`) *drops the key of flow-valued attributes*: for
  `:author Alice Smith`, `current_attr` is never flushed by a `Text` event,
  so the attribute vanishes and the text leaks into element content
  (demonstrated on `examples/tree_parse.rs`'s own document — `article`
  shows `:date`/`:tags` but no `:author`, and "Joseph Wecker" appears as a
  text child). This is the implied-value wire defect (the R8 deratification
  trigger) manifest in the AST; in prose-heavy corpora it would have
  silently deleted most of the interesting attributes from the stats.
  Deliberately **not** filed as a 0.9-route repair ticket (that lane is
  closed per C7); it stands here as one more live exhibit for the v2 wire
  direction — W1d's self-delimiting values dissolve this class wholesale.
- So the extractor consumes raw `Parser` events and performs the ownership
  inference itself, following the fixture-documented wire semantics
  (`core/fixtures/v0.9/attributes.yaml`: `Attr` carries the key; the next
  value/Text event is its value; arrays credit the key once; a comment
  mid-value re-emits the key, which this tool counts as a stacked
  assignment — a small known artifact).
- **Validation before use:** the instrument reproduced CONSUMERS.md's
  independent counts for PROCESS-MAP-v0 exactly (50 keyed elements, 6
  suffix flags, 1 verbatim, 1 date attribute, clean).
- Vocabulary in the outputs: `flow-text` = prose-shaped value; `bare` =
  single-token string; `sameline a/b` = of b assignments, a sat on the
  element's own line; `pos~` = mean index among the element's ordinary
  attributes; `stacked` = same key twice on one element.

## 2. The de-facto schemas found (highlights per corpus)

*(Summaries; the full extractions are in `raw/`. Everything here is
presence-statistics, i.e. the open half — closure/intent is not claimed.)*

**vivarium `DECISIONS.decision-log.udon`** (121 records, one-file-many-records
layout): `|decision[slug]` with **five 100% attributes** — `:date :by :status
:topic` sameline (in that order, 91/121 exact), `:session` always block;
optional tier `:council` 18%, `:supersedes` 8% (bare *and* array spellings
both live), `:note`/`:superseded-by` 2%. Children: `|reason` 120/121,
`|impact` 110, `|ref` 107 — max 2 reasons, else max 1 each. Tail (drift
candidates / O10's "anomalous record" material): `|context-first`,
`|council`, `|execution`, `|judgment` — one parent each; `:status-note` ×1.

**vivarium `LEXICON.udon`** (single-root, 8 `|section[key]` regions):
`|term[key]` with `:status` 100%-sameline-first; `|rel :to X :kind Y` is a
**pure edge record** — 62/62 leaf, one order signature; satellite prose
children (`|source` 21, `|not` 19, `|confused` 15) each ≤1–2 per term.

**vivarium `tabularium/terrestris.ordinum.udon`**: the trait-classification
specimen — `|promise.state/.capability/.regime/.limit` (traits as kind, 32
elements), `|charge :tag` 100%, `|defeasance :voids :by` 5/5 uniform, and
dotted-string cross-references (`"2.water-covered-surface"`) — a hand-rolled
path convention living in quoted strings (paths-territory demand evidence).

**autopax `taxonomy.udon`**: document-genre (title'd sections/subsections);
`|component :v :a :d` integer triple 19/30 uniform; the known 0.9 meaning
shift is visible in the stats (`:authors Joseph, Architectus` → flow-text vs
`:author Joseph` → bare).

**ASF `PROCESS-MAP-v0.udon`**: `|process` 37× with `:name :health :drain`
at ≥91% block-placed, `$?` suffix ×6 — the one live corpus using suffix
flags; `:drain nil` ×8 (explicit-nil idiom in the wild).

**v2 registers** (DISCUSSION-THOUGHTS / FOR-JOSEPH / ONLY-IN-UDON): the most
uniform corpora measured — every record carries its full attribute set at
100% with a single order signature; `|thought` slugs ride as traits;
`!:quote:` verbatim bodies 16×. The registers are already, measurably, the
schema they describe informally.

**design/examples**: `schema-dsl.udon` is the only corpus where `$!`/`$?`
(required/optional) appear — the deliberateness vocabulary exists as an
example, unused in live data. `docbook-*`/`mathml-*` are a distinct genre
(machine transliteration: 0 blank lines, 700–2100 elements, one root) worth
keeping separate in any future extraction baseline.

## 3. Incidental catches (live defects surfaced by the run)

### 3.1 In vivarium (reported here; theirs to fix)

- `DECISIONS.decision-log.udon` **line 945**: a `:session` line sits after
  the record's children began → `AttributeAfterChildren`; that decision's
  session id is prose, not data — any tool reading `:session` misses it.
- Three `InconsistentIndentation` warnings (lines 954, 1031, 1405).

### 3.2 In this estate's own register (fixed this run)

`schema-review/DISCUSSION-THOUGHTS.udon` line 534: an assessment prose line
began with `@element[key]:attribute …` at column start → the parser read a
**Reference plus a stray attribute** (`AttributeAfterChildren`), so the O13
assessment's prose was partially structure. Fixed by `\`-escaping the
line-initial `@` (parser-verified clean). The hazard class — line-initial
`@`/`!` in prose silently promoting to structure — now has three field
instances (CONSUMERS' PROCESS.udon directive-promotion, this, and the
`|assessment > @ref` counts that flagged it).

### 3.3 In the shipped AST layer

The flow-value attribute drop (§1). One-line repro:
`printf '|el :author Alice Smith\n'` → tree has no `author` attribute.
Carried as v2 wire-direction evidence only — not a 0.9-route ticket.

## 4. The dogfood divergences (three-way facts, no verdicts)

The current-generation descent grammars (`core/generator/[0-9]*.descent.udon`,
~2,300 lines) read, under the parser generated *from them*, as:
`UnclosedIdentityKey` ×63, `NoDialectsLoaded` ×67, `MissingAttributeValue`
(Error) ×20 — plus the legacy pre-0.8 file at ×28/×75/×18. Three systematic
constructs, not noise:

| Construct (descent idiom) | Current parser reads | CORE 0.9.1 says |
|---|---|---|
| `\|if[sfx == FIN]` — multi-token predicate in the bracket | bare token `sfx` finishes; bracket unclosed at line end → `$partial-key` + Warning | bracket interior uses the normal **value rules** (§5.3); interim behavior closes at newline (§13.2, descriptive) |
| `\|c[<BS>]` — envelope inside the bracket | envelope recognized, no dialects bound → `NoDialectsLoaded` | envelopes are dialect hand-off (§11.6); warning is the specified interim |
| `\|function[…] :close` — bare flag, no `?` | plain key, no value → **Error** + Nil (§6.2) | 0.9 spells presence-flags `:close?`; the fixture suite itself calls `?` "the 0.8 idiom, spelled with ?" |

Facts worth carrying, no resolution proposed:

- descent's own toolchain parses these files as intended (its `[…]` capture
  is effectively raw) — so the estate's **oldest working UDON dogfood sits
  on the raw side of the bracket fork**, the same raw-capture-vs-value-slot
  question OPEN's REF-BRACKET poses for `@[…]` and O13 poses for paths.
  The dogfood is demand evidence for that adjudication, not a verdict.
- The `:close` → `:close?` class is a **ready-made O7 adjudication-point
  migration**: mechanically enumerable (this tool prints exact lines), with
  a census/burn-down falling out for free. If O7 wants a first customer
  smaller than SEG-SPLIT, this is it.
- Whether the grammar files are *supposed* to be current-UDON-clean is a
  steward/fact question (they are parsed by descent, not by udon-core;
  nothing today requires them to be udon-core-clean). Recording the counts
  is not a claim that they should be zero.

## 5. Probe status against its three questions, and what this feeds

- **Near-mechanical?** Yes — measured (this run). The remaining judgment
  lives at exactly the two spots the seed predicted: the instrument's
  ownership inference (built once), and reading intent off presence
  (unsolved by design — the open half).
- **Author-recognizable?** **Open — needs the corpus authors.** The §2
  summaries are the artifact to check: Joseph / vivarium agents, do these
  read as *your* schemas? False-requirement inference (e.g. ":session is
  required") is precisely what only you can refute.
- **Drift-on-rerun?** Procedure ready, needs time to pass: re-run the same
  invocations (`raw/` preserves this run's exact outputs), diff. The
  incidental catches in §3 are early evidence the signal is real.

Feeds: **O6** (extraction validated at estate scale), **O10** (the §2 tails
are the "anomalous record" material its dialogue needs), **O7** (§4's
bare-flag census as first customer), **O11** (the deliberateness gap is now
measured, not asserted: one corpus uses `$!`/`$?`, and it's an example
file), **REF-BRACKET / O13** (§4's bracket-fork demand evidence), and the
paths territory (terrestris's quoted dotted-path convention, §2).

## Working Notes

*(X4 sidecar — open thinking, not deliverable.)*

Things I'd want the next agent to know: the extractor's `sameline`
join between the event pass and per-element stats keys on the *display
name*, so an element and its inline `{…}` twin are tracked separately —
fine for these corpora, but check it before trusting inline-heavy ones.
The comment-mid-value re-emission artifact slightly inflates `stacked` on
`:note`-like keys (seen once in the smoke test, not material here). And the
biggest thing this run made me want: run the recognizability check as a
real dialogue (show Joseph §2 one corpus at a time and record his
"that's-not-a-requirement" corrections) — that conversation *is* the
closure data O6 says observation can't supply.
