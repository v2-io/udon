# Prose-collision corpus study (spike S3) — 2026-07-11

**Refs:** REVIEW-JULY-2026.md §3.6 (reflow/silent promotion), §7-A
"non-conflict with markdown — measured", §7-F decision 9 (line-initial sigil
guards), §9 spike 3.
**Parser:** `core/target/release/examples/stdin_parse`, built `--release`
from udon @ `eb9aca1` (2026-07-11).
**Instrument:** `prose_collision_probe.py` (this directory; runnable —
`python3 prose_collision_probe.py all`). Corpus snapshot:
`commonmark-spec-0.31.2.json` (fetched from spec.commonmark.org 2026-07-11,
652 examples).
**Tier claim:** succeed-at-claim. Both questions turned into numbers; two
side-findings (a span-offset defect class, and the empirical `!`-guard being
weaker than the review recorded).

## Empirical trigger rules (probed first, not assumed)

Line-initial behavior of the real parser, established by direct probes before
any measurement (all mid-line occurrences are inert — promotion is strictly
line-initial after indent):

| Line starts with | Behavior | Loud? |
|---|---|---|
| `:` + ASCII letter | **Attr** (promotion) | silent |
| `:` + anything else | `:` silently consumed, rest is Text | **silent mutation** (defect #12 class) |
| `;` + anything | **Comment** (promotion; `;-)` loses the wink) | silent |
| `!` + letter | named **Directive** (promotion) | silent |
| `!` + anything else | phantom empty Directive emitted **and `!` consumed** | **silent mutation** |
| `\|` + letter or `[` | **Element** / anonymous element with id | silent |
| `\|` + space/EOL/other | prose (the existing guard) | — |
| `@[` | **Reference** (promotion) | silent |
| 3+ backticks | **Freeform** block (info string → Name, body preserved) | silent transform |

Correction to the review's decision-9 text: the `!` letter-guard does **not**
exist de facto at the event level. `!(`, `!=`, `![` all emit a phantom empty
Directive and eat the `!`. The guard exists only in the sense that the
directive gets no *name*; the prose is still mutated.

## Measurement 1 — CommonMark survival

**Method.** Each of the 652 CommonMark 0.31.2 spec examples' *markdown
source* embedded verbatim as prose under a UDON element (`|doc`, every
non-blank line prefixed with 2 spaces), parsed with the real parser,
classified from the event stream:

- **clean** — only Text/BlankLine events, and Text contents reproduce the
  original non-blank lines exactly (content-compared, whitespace-normalized);
- **promoted** — any structural event (Attr, Comment, Directive, Element,
  Freeform, Reference);
- **mutated-silent / -warned** — no structural event but Text content
  differs from the source;
- **warning-only** — intact content, Warning event(s) emitted;
- **error** — Error event.

### Headline

| class | n | % |
|---|---:|---:|
| clean (survives as prose, byte-faithful content) | 585 | **89.7%** |
| promoted (structure appeared) | 42 | 6.4% |
| mutated (silent content change, no structure) | 0 | 0.0% |
| warning-only (intact, loud) | 19 | 2.9% |
| error (UnclosedFreeform) | 6 | 0.9% |

### Every promotion is one of exactly two constructs

- **21 examples: markdown images/image-links (`![alt](url)` at line start)** —
  `!` + `[`. Under current behavior: phantom directive + eaten `!`. **A real
  letter-guard on `!` rescues all 21** (`[` is not a letter). Sections:
  Images 20/22, Links 1/90.
- **21 examples: backtick fences** (`` ``` ``) → Freeform blocks. This is the
  *deliberate* fence-to-freeform conversion (open decision 8), not an
  accident: info string and body are preserved in events, so the block is
  reconstructable. The 6 **errors** are the same construct's pathological
  edge: asymmetric fences — tilde-fences with backticks inside (#123, #126),
  fences opened but never closed in the example (#145, #347), a fence inside
  a blockquote (#237) — leave an UnclosedFreeform at EOF. (CommonMark
  closes fences at EOF; UDON errors. Also note **tilde fences `~~~` are
  inert in UDON** — they pass as prose, which is what makes the
  mixed-fence examples asymmetric.)

Not a single `:`, `;`, or `|` promotion in 652 examples: CommonMark's
construct inventory simply never puts those characters at line start.
**Zero silent text mutations** across the corpus.

### The 19 warnings are all one thing

All 19 warning-only examples emit "Inconsistent indentation" — markdown's
own indentation conventions (indented code blocks, hanging list
continuations, tab/space mixes, 2–3-space paragraph leads) look like UDON's
dedent hazard. Content survives untouched; the parser is *loud* about
exactly the class §3.6 worried was silent-when-dedent-reparents. Sections:
List items 4, Setext 4, Tabs 3, Paragraphs 3, Indented code 2, Link ref
defs 2, Block quotes 1.

### Counterfactual survival rates (what the guards buy)

| Regime | survives as prose | prose + reconstructable freeform + loud-intact |
|---|---:|---:|
| current parser | 89.7% | 89.7 + 3.2(fence) + 2.9(warn) = 95.9% |
| + `!` letter-guard (no eat before non-letter) | **93.0%** | **99.1%** |

Hard-failure floor either way: 0.9% (6 asymmetric-fence examples). The
CommonMark-corpus CTQ (§7-A) can therefore be asserted today as: **≥89% of
CommonMark examples embed as byte-faithful prose; 100% of non-fence,
non-image examples do (with 19 loud-but-intact indentation warnings); zero
silent mutations.** `prose_collision_probe.py commonmark` is the runnable
form; wiring it into CI as a ratchet (rates may improve, never regress) is
a one-liner away.

## Measurement 2 — line-initial token frequencies under reflow

**Method.** Corpus: `udon/*.md` + `udon/notes/**/*.md` (excluding this
spikes dir) + every 4th of the 3,311 archema-io `.md` files ≤100KB
(deterministic by sorted path; target/node_modules/.build-scrbook
excluded) — **842 files, 10.6 MB** of real ASF/UDON-ecosystem prose, which
is the review's predicted worst case ("documentation about UDON written in
UDON is the densest in sigil-initial tokens"). Each paragraph (contiguous
non-blank lines outside code fences) was greedily re-wrapped at widths
60/72/80; only **reflow-created line starts** (continuation lines, not
paragraph-initial lines) were classified against the probed trigger rules.
Two variants: prose-only (tables/headings/rules excluded — the blocks
nobody fills) and all-blocks.

### Headline rates (prose-only variant)

| width | reflow-created line starts | collisions (current parser) | per 10k | residual with all decision-9 guards | per 10k |
|---:|---:|---:|---:|---:|---:|
| 60 | 144,892 | 9 | 0.6 | 5 | 0.3 |
| 72 | 117,402 | 14 | **1.2** | 8 | **0.7** |
| 80 | 103,822 | 11 | 1.1 | 3 | 0.3 |

All-blocks variant is the same picture, slightly higher (0.9–1.3/10k
current; 0.4–0.7/10k residual). Intuition for scale: at 72 cols, one
collision per ~750 KB of prose reflowed — rare per line, but a whole-repo
reflow of this corpus would plant ~14 silent structure changes.

### The actual colliding-token inventory (72-col prose-only, plus notable others)

| class | tokens seen | source of the idiom |
|---|---|---|
| colon-eaten (silent) | `:=` ×3, bare `:` (from `foo :` splits — present at every width), `:[id]`, `:--`/`:---` (table alignment), `:64,` `:77,` `:95,` (line-number refs) | math definition operator, table syntax, `file.rs:NN` refs |
| colon→Attr | `:default` ×2, `:date?`, `:optional`, `:enabled`, `:attr=val` | **UDON's own docs quoting attr syntax** (also the Ruby-symbol shape) |
| pipe→Element | `\|[id]`, `\|figure?`, `\|field[name]`, `\|child!` (UDON doc tokens); `\|E\|)$`, `\|V\|)$.`, `\|Delta-H\|`, `\|delta\|` (math) | UDON docs + **set-cardinality/absolute-value notation in math prose** |
| bang→Directive | `!directive),` | UDON docs |
| bang-phantom | `![alt](url)` | markdown image |
| semi→Comment | `;$$`, bare `;` ×2 | inline-math punctuation; no `;-)` emoticon appeared anywhere in 10.6 MB |
| fence→Freeform | ` ``` `, ` ```` ` (all-blocks w80 only) | fence lines joined into a paragraph |

## What the data says

**For decision 9 (guards), ranked by measured purchase:**

1. **Fix the `:`-eating (defect #12): the single biggest win.** Colon-eaten
   is the largest reflow class at every width (4–10 of each width's
   collisions) and it is *silent mutation*, the worst failure mode. Sources
   are ordinary technical prose (`:=`, `file.rs:77,`, table `:---`), not
   exotica. Rescues 100% of its class by construction.
2. **Make the `!` letter-guard real (stop eating `!` before non-letters).**
   Cheap, and it is the entire difference between 89.7% and 93.0% CommonMark
   survival — every markdown image line. In the reflow corpus it buys little
   (1 token) because this corpus has few images; the CommonMark number is
   the load-bearing one. Residual after guard: letter-initial directives in
   prose (`!important`-class; here `!directive),`) — accept, linter's job,
   as the review already concluded.
3. **`;` guard (comment only before space/`{`/EOL): weakly supported by
   frequency.** The corpus-idiom check decision 9 asked for comes back
   near-empty: zero `;-)` emoticons in 10.6 MB of this ecosystem's prose;
   total `;` collisions 1–2 per ~120k wrapped lines, and the bare-`;` token
   (still a comment under the guard) is half of them. The guard is
   harmless and principled, but the honest statement is that it buys ~1
   token per corpus, not a rescue of a live idiom. Decide it on grammar
   aesthetics, not on these frequencies.
4. **The `|`+space guard already carries the pipe load.** Every observed
   markdown-table row token was bare `|` (guarded). What remains is
   `|letter`/`|[` — and the residual inventory says the real-world shapes
   are (a) UDON's own docs quoting element syntax and (b) **math notation
   `|E|`, `|delta|`** — a source the review's anecdotes missed. No cheap
   guard distinguishes `|E|` from `|em phasis`; this is squarely the
   linter's reflow-damage heuristic plus escaping-in-docs territory.

**Residual after all decision-9 guards: 0.3–0.7 per 10k wrapped lines**, and
the survivors are almost exclusively (a) sigil-syntax tokens in documentation
*about* UDON and (b) `|…|` math notation. The review's "own worst case"
prediction (§3.6) is confirmed and now bounded: it is real, it is small, and
it is exactly the class the linter + `udon fmt` were already slated to catch.

**For the CommonMark CTQ (§7-A):** the intention can graduate to a measured
guarantee now — 89.7% byte-faithful today, 93.0% with the `!` guard, zero
silent mutations, and the only structural interactions are the two
*documented* markdown constructs (fences → freeform by decision 8;
images → fixed by the `!` guard). Suggested CI assertion: clean ≥ 585,
mutated = 0, ratcheting up as guards land.

## Side-findings (not this spike's questions, but verified en route)

1. **Span-offset defect on backtick/quote-initial prose lines.** A prose
   line starting with `` ` `` emits Text whose *content* is intact but whose
   span start is off by the sigil width (e.g. content `` `foo` `` with a
   span covering `foo` + 1 — start is 1 byte late; `` `` … `` lines are 2
   late; `'…'` lines similar). First detected as false "mutations" by a
   span-coverage fidelity check; content comparison exonerated the text.
   Harmless for events-as-text, but **it will corrupt the round-trip
   serializer and span-based agentic edits** (§7-C round-trip CTQ; spike 4
   should know before it starts).
2. **`@[` promotes to Reference in prose** (with an "Inconsistent
   indentation" warning as a side effect). Not in decision 9's `:`/`;`/`!`
   list; zero occurrences in either corpus; noting for completeness since
   the identity-syntax decision (decision 1) may move this sigil anyway.
3. **Whitespace-only lines inside prose emit empty Text events** (not
   BlankLine). Cosmetic, but event consumers that treat Text as "has
   content" will trip.

## Limitations — honest edges

- **Reflow model is naive by design**: greedy re-wrap of whole paragraphs at
  fixed width, no indent modeling (real fill preserves indent, shrinking
  effective width — the 60/72/80 spread brackets this), no hyphenation, and
  contiguous non-blank lines are treated as one paragraph (this joins list
  items — realistic for careless fill, generous to collision-finding). It
  models *udon-unaware* editors, which §3.6 already identified as the real
  exposure; udon-aware fill makes all of this moot.
- **Corpus is one ecosystem** (ASF/udon/archema prose, deterministic 1-in-4
  sample of archema-io). That is deliberate — it is the predicted worst
  case — but rates for, say, a fiction corpus or general README corpus were
  not measured. The CommonMark corpus partially covers "generic markdown".
- **CommonMark examples are short** (median a few lines). Survival is
  per-example, so the per-line collision base rate is not directly
  comparable to measurement 2's per-10k-lines numbers.
- **Classification is event-level, not tree-level.** A phantom empty
  directive that a tree-builder might drop still counts as promotion here;
  that is the right call for a format whose consumers include event-level
  tooling, but it is a choice.
- Warning-only examples were verified content-intact, but I did not verify
  *tree shape* (e.g. whether a dedented tail reparents) — the §3.6
  reparenting probe already covered that class.
