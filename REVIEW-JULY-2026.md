# UDON Review — July 2026

**A full-estate review, fresh-eyes audit, and the seed of the reboot.**

> *"Lessons learned, time for a reboot that uses all the very best lessons and
> possibly much of the solid parts of the code. New day, new needs, new
> audience — fewer constraints, more urgency in the things that would
> immediately help agentic-systems and vivarium, with an eye toward it helping
> all the things we had hoped it would help before, in time, as well."*
> — Joseph, 2026-07-08 (the charter for this document)

Written 2026-07-08 by a Claude instance working with Joseph, after: reading
FULL-SPEC.md, TIME-SPEC.md, udon-ast.md, udon-paths.md, udon-agentic.md (and
agent-assisted reads of the remaining docs); a four-repo archaeology sweep
(udon, libudon, descent, udon-ruby); a fresh build of libudon on this machine
(first since the machine transfer — the old `target/` binaries were stale
transfers); a 49-case behavioral audit of temporal parsing against TIME-SPEC;
and hands-on authoring (the ASF process map, now under active use in
agentic-systems, was written in UDON this week). Revised the same day through
several calibration rounds with Joseph (concerns re-ranked, the empirical
corpus mined into §3, the per-feature genealogy added to §2, decisions 8–9
and defects 9–12 discovered live). Claims marked **[verified]** were
established by running code or reading primary sources this week; unmarked
judgments are exactly that.

---

## 1. Why now

- **ASF adopted the format.** `agentic-systems` process maps are being authored
  and actively evolved in UDON as of this week.
- **vivarium wants it immediately**, as Rust-consumable structured documents.
- The ecosystem has been dormant since ~2026-01-14. The dormancy was clean —
  work stopped at green tests, not mid-break — but pointers rotted, three of
  the best design docs were never committed, and nothing had ever been built
  on the current machine.
- **The audience changed.** The original bet was partly "humans will adopt a
  better notation" — the graveyard bet every unified-markup attempt lost. The
  new bet is different and better: **the marginal author is now a model.** A
  format that fits in a few hundred prompt tokens, streams line-by-line, needs
  no closing-tag bookkeeping, and treats comments as a first-class tier of
  voice is built for the author who just arrived. Agent onboarding replaces
  human adoption as the critical path. That inverts several old constraints —
  hence the reboot.

## 2. State of the estate (archaeology summary)

| Repo | Role | Last real commit | State |
|---|---|---|---|
| `~/src/udon` | Spec + design notes | 2026-01-14 | **FULL-SPEC.md is the authoritative spec** (v0.7-draft). CLAUDE.md/README pointed at archived "SPEC.md" until 2026-07-08 (fixed with this review's commit). The final January session's three then-uncommitted docs are the newest thinking: `implementation-status.md` (cross-repo reconciliation map), `udon-guarantees.md`, `udon-schema-exploration.md` — committed 2026-07-08 alongside this review. |
| `~/src/libudon` | Rust parser core | 2026-01-13 | Green (38 tests **[verified]**), builds clean on this machine **[verified]**. Real arena AST exists (`tree.rs`), not just streaming events. Docs ~2wks staler than code (wrong branch name, phantom `value.rs`). |
| `~/src/descent` | Parser generator (Ruby gem) | 2026-01-09 | Rust target healthy and **provably untouched** by the abandoned Ruby-target detour (byte-identical output before/after **[verified by regeneration diff]**). Published `descent 0.7.1` on rubygems (2026-01-10) is HEAD-faithful — the only clean release artifact in the ecosystem. |
| `~/src/udon-ruby` | Ruby gem binding | 2026-01-02 | **Superseded.** Won't compile against current libudon (6 unhandled Event variants). Prebuilt Jan-2 bundle still runs under Ruby 4.0 but is semantically frozen. Salvage: its 15-test suite as an event-model spec. The `udon` gem name on rubygems is a **2011 ancestor** (v0.0.4) — the modern gem was never published. |

No git tags exist in any repo. Version numbers drifted (udon-ruby says 0.9.0,
resolves udon-core 0.10.0). The "source of truth trading places" history is
real but is visible only in git; `implementation-status.md` (uncommitted at the
time of this writing) is its only written map and ranks the layers correctly: design
docs *ahead of* spec *ahead of* libudon (de facto) *ahead of* udon-ruby.

### Per-feature authority genealogy

The ranking above is a *median*; authority is feature-dependent, and git is
the arbiter (Joseph's calibration, 2026-07-08). The load-bearing date:
**FULL-SPEC.md was created 2026-01-01 18:02 and never edited again** — its
whole history is three same-day commits — while libudon lived twelve more
days. So every post-Jan-1-evening implementation choice is, by construction,
either an unbackported landing (B) or a frozen experiment (C). Classes:
**(A)** spec post-dates the experiments — spec is authoritative, code
retains vestiges; **(B)** impl landed final forms not backported — impl is
authoritative, spec stale; **(C)** froze mid-experiment — neither is
authoritative, comments and present/missing tests are the tells; **(D)**
spec'd but never attempted. The census for the divergences this review
found **[dates verified via git]**:

| Feature | Spec | Impl | Class | Authority read |
|---|---|---|---|---|
| Fence closing rule | "or less" — Jan 1, 11:16→18:02 | any-line closes — Jan 1, **19:14**, documented in `udon.desc:589` | **B** | The impl is the later deliberate decision (by one hour, then 6 months of stasis). Backport to spec pending decision 8. |
| Sameline fences | Dec 23 (initial commit), carried into FULL-SPEC | never implemented; no vestige of an attempt | **D** | Spec aspiration. Decide: implement or drop (decision 8). |
| Fence info strings (`\`\`\`python` → `Name`) | absent | ~Jan 1–2 | **B** | Impl innovation the frozen spec never saw. Spec it; wire `Raw.lang`. |
| Temporal recognition | TIME-SPEC, Jan 9–13 | Jan 9 | co-evolved | In sync — confirmed by the 49-case audit (44/49, all misses elsewhere). |
| Temporal validation/warnings | TIME-SPEC finalized Jan 13 | deferred Jan 9, *in-tree note* (`temporal.yaml:565`) | **A** | Spec finalized knowing the impl deferred — authoritative aspiration. Implement. |
| Typed bracket-IDs | Dec 23 / Jan 1 | never (raw capture, quotes kept) | **D** | Spec'd, unattempted (defect #2). |
| Attrs-before-children | Dec 23 (initial commit) | never enforced | **D** | Spec'd, unattempted (defect #9). |
| BlankLine event | absent | Jan 13 (last commit) | **B** | Impl innovation; spec decision 7. |
| Identity (`$id` / `id` / `key`) | spec says `$id` (Jan 1); udon-ast says `key` (Jan 14) | impl emits `id` | **C** | Three artifacts, three answers, frozen mid-evolution — *the* identity decision (decision 1). |

The pattern worth noting: every (D) is from the **initial-commit era** (Dec
23) — founding aspirations that implementation never circled back to; every
(B) is from the **final sprint** (Jan 1–13) — practical landings the frozen
spec never heard about. The (C) is the one genuinely open experiment. This
is what "trading places as source of truth" actually looked like at feature
grain — and it is the precise failure mode the fused-ground-truth CTQ item
exists to end.

**Hygiene debts** (cheap, do first): fix CLAUDE.md/README "SPEC.md" pointers →
FULL-SPEC.md; commit or consciously curate the uncommitted trio; tag releases
going forward; refresh libudon's CLAUDE.md/PLAN.md.

## 3. The language — judgment

### Where it sits

Every neighbor holds one corner: YAML is data that hates prose; Markdown/MDX
is prose whose data lives in a frontmatter ghetto; XML has real mixed content
at a ceremony cost nobody will pay again; KDL nails node-config with no prose
story; Haml/Slim are element trees but template-only. **UDON's claim —
symmetric mixed content, structure⊃prose⊃structure arbitrarily deep under one
grammar, with prose as the *unmarked* case — is genuinely unclaimed
territory.** That is the load-bearing innovation and it is real.

### Proven strengths

1. **Sigil economy with compositional inline forms.** Four prefixes with clean
   domains; the `X{...}` rule means learning one prefix teaches five syntaxes.
   This regularity is why cold-start authoring works (demonstrated: the ASF
   process map was authored cold from the spec this week).
2. **Syntactic typing** kills the Norway-problem *class*. The
   absent/nil/false/flag-true four-way distinction is more careful ontology
   than any config format we know of — and maps directly onto what schema
   evolution and patch semantics need later.
3. **The single stack rule** (`pop while col <= base_col`) covers block
   nesting, inline rightward chains, and column-aligned siblings with one
   mental model. The parser inherits the elegance (call stack = element
   stack).
4. **`;` for comments, freeing `#`** — the small decision that lets Markdown
   coexist instead of collide.
5. **key/traits as core identity ontology** — `|user[alice].admin` with
   type-scoped key uniqueness is a database-grade identity model inside a
   markup language; it is what makes the single-source-of-truth vision
   coherent rather than aspirational.
6. **LLM-native shape**: token-light, streaming-shaped, comment-as-voice,
   promptable-in-full.

### Empirical support — the December 2025 agent-feedback corpus

A body of agentic feedback exists and is better than remembered:
`test/usability/` is a full eval harness (nine test categories, ~140 result
files, 2025-12-23) with judge-scored and mechanically-scored runs, plus
`feedback.md` — a captured fresh-model review written after studying 26 other
markup languages. "Proven" here is soft: small n, Claude-family models only
(Haiku/Sonnet/Opus 4.5-era), and syntax validity was judged by the Ruby
validator that predates FULL-SPEC (now in `_archive/`; the harness's
`require` path is broken against the current tree). But it is measurement,
not anecdote — and it supports five findings:

1. **Blind design convergence (the invention tests).** Agents given UDON's
   *constraint set* — never shown UDON — repeatedly (a) identified mixed
   content as the genuinely hard, underexplored problem (*"Most notation
   designs punt on it"*; *"if UDON solves this well, it's genuinely novel"*),
   (b) reinvented UDON-shaped answers (pipe-prefix boundary markers,
   indentation hierarchy, prose-as-ambient-default), and (c) judged the space
   nearly forced: *"the design space feels constrained enough that there
   might only be 2-3 viable approaches."* The core design is **discovered,
   not arbitrary** — blind redesign lands nearby.

2. **Onboarding cost, measured (the validated tests).** n=37 mechanically
   scored authoring runs (5 task types × 3 onboarding artifacts × 2 models):
   **89.6% aggregate**, 32/37 runs ≥80%, 8 perfect. A ~53-line cheatsheet
   context scored 84.9%; the minimal artifact (91.5%) essentially matched the
   comprehensive one (92.9%). **Haiku (90.3%) matched Sonnet (88.6%)** —
   competent authoring does not require frontier capability. This is the
   direct evidence behind §1's "agent onboarding replaces human adoption,"
   and the harness *is* the measurement instrument the CTQ's
   proven-onboarding item calls for — it needs refresh and re-pointing, not
   invention. Two calibrations from Joseph (2026-07-08): the models were
   Dec-2025 vintage — six months stale, an eternity at current pace — so
   read 89.6% as a **floor**; and the refreshed harness should widen beyond
   the Claude family: **Codex and Gemini at minimum, plus the higher-ranked
   open-weights/local models** — which also converts this section's
   same-family-bias caveat into a measured axis instead of an unknown.

3. **The positioning was independently reproduced — and predicted its
   adopters.** 27 topic-enablement tests converged on the same
   prose/data/inline matrix the docs claim (`enablement-synthesis.md`), and
   the synthesis's strong-fit list — compliance/audit artifacts, agent
   reasoning traces, living documents that are both specification and record
   — names precisely the July 2026 adopters: ASF process maps are living
   governance documents; vivarium's experiment narratives are its
   "pre-registration / audit-trail convergence" case verbatim. The corpus
   predicted its own first customers seven months early.

4. **Inline semantic annotation in prose judged "genuinely novel and
   valuable"** — with worked domain examples in the synthesis (RL traces:
   `|{state :theta 0.15 …}`, dialogue-entity annotation, XAI factor
   attribution). This is the exact affordance the new consumers need most.

5. **The corpus's critiques converge on this review's concern list,
   independently**: complexity budget (*"practitioners will use ~20% of
   features 80% of the time"*; a *"UDON-Simple subset might aid adoption"* —
   pre-echoing the core-vs-dialect CTQ), tooling chicken-and-egg
   (formatter/highlighting/linter as adoption-critical — concerns 4 and 7
   below), and the triple-backtick escape as a symptom of layout tension.
   Two assessments, seven months apart, same list — evidence the concern
   list is the *right* list.

A quiet companion finding: the harness ships with `ETHICS.md` — an
agent-interaction ethics charter (honesty including system prompts, no
fabricated turns, context-integrity, opt-in participation, "give agents the
*why*, ask them for the *how*") whose closing observation — *"Some of the
best insights have come from very common temporary test agents"* — this
corpus itself vindicates.

### Concerns, ranked by expected pain

*(Re-ranked 2026-07-08: Joseph's calibration demoted the column-alignment
concern — the first draft overweighted it — and a sweep of the Dec-2025
corpus surfaced two concerns the first draft missed. The recalibration is
preserved in item 7 because it is itself instructive.)*

1. **Type-space accretion erodes bare strings.** Temporal types are the live
   demonstration: every typed bare-pattern added silently retypes existing
   documents (`2025-12` was somebody's product code; now it's a YearMonth).
   This is a governance problem wearing syntax clothes. Resolution shape: see
   CTQ — freeze the core value grammar; route future typing through
   dialect/schema declaration.
2. **Identity syntax is unsettled while adoption begins.** `@[id]` vs `|[id]`
   (feedback.md votes drop-`@` for sigil economy; udon-paths.md *builds on*
   `@` for resolution — direct tension), and `$id` vs `key`/`traits` naming.
   Every ASF document written now is migration exposure. Decide first.
3. **Feature-surface budget** *(from the corpus; missing from the first
   draft)*. Three nil spellings (`null`/`nil`/`~`), two reference forms, two
   escape mechanisms, the suffix zoo, mixins, template directives. The
   corpus's sharpest critique: *"practitioners will use ~20% of features 80%
   of the time"*, with a *"UDON-Simple subset"* suggested. This is the demand
   signal for the core-vs-dialect split (CTQ-A): the answer is not feature
   removal but a small, blessed core profile — and the 53-line-cheatsheet
   result shows the effective core is already small. Name it and teach it.
4. **`;` context-sensitivity is defensible but subtle.** Real observed case
   **[verified]**: the ASF process map's own conventions block parses as an
   interleaving of comment-continuation lines and prose lines (the `| healing`
   rows survive only via the Markdown-table-pipe rule). It parses *correctly*
   — but the format's author produced a non-obvious parse in week one.
   Signal: syntax highlighting and the linter are near-mandatory companions,
   not accessories.
5. **The Markdown subset is undefined** — parser conformance is crisp,
   *renderer* conformance is undefined. `markup-feature-matrix.md` is the
   exploration; feedback.md's Djot-inspired enumerated subset is the right
   shape. Decide, then defer *parsing* of it to hosts/dialects (see CTQ).
6. **Prose plasticity vs layout-significance — reflow and transport**
   *(reflow face raised by Joseph 2026-07-08; transport face from the
   corpus)*. Prose wants to reflow — word-wrap, `gq`, fill-paragraph — and
   UDON gives layout meaning. The failure mode is sharper than Python's:
   Python fails *loudly* on botched indentation; **UDON prose is valid at
   any indent — it just silently belongs to someone else.** Probed
   **[verified — all four silent, zero warnings]**: a dedented paragraph
   tail reparents; and a wrap that lands a sigil-initial token at line
   start *promotes it to structure* — `:attr syntax` became a live
   attribute, `;-)` became a comment (the wink vanishes from rendered
   text), `!important` became a directive. Documentation about UDON written
   in UDON is the densest in sigil-initial tokens — this ecosystem is its
   own worst case. (The `:attr` promotion also exposed defect #9: the
   parser doesn't enforce attributes-before-children, so even the
   spec-invalid case is silent.) Transit-time face of the same tension:
   whitespace mangling in email/forums/copy-paste (corpus: *"brittle with
   copy-paste and display contexts"*). Calibration (Joseph's, endorsed):
   indent-aware fill is a solved editor class (vim `gq` with indent, emacs
   fill-prefix) and the tree-sitter grammar is the path to udon-aware fill;
   agents re-emit blocks through tooling rather than hard-wrapping;
   soft-wrap sidesteps entirely. The real exposure is **humans in
   udon-unaware editors** — bounded by tooling, except that the
   silent-promotion class is caught by *no* generic editor feature: it
   needs the linter's reflow-damage heuristics, and it is the strongest
   single argument on the board for shipping editor support early.
7. **Column alignment is an edit hazard in exactly one style** *(demoted
   from #1; calibration Joseph's, sharpened and verified by probe)*. The
   hazard requires inline nesting AND column-aligned continuation lines AND
   an edit that moves a sigil boundary *across* a continuation's column.
   **[verified]**: same-length renames are no-ops; shrinks are fully
   remediable by space-padding; a continuation placed mid-interval has slack
   proportional to the gap between the sigil columns bracketing it; only
   *growth* has no padding remedy, and exact-column alignments have zero
   slack (an unpadded shrink can cross those). Slack is the whole story:
   growth eats it, shrink is refundable. **Block-style documents — the
   practices-gotchas recommended default — are exactly as robust as
   Python**: renames never move structure. Under agent authorship,
   propose/apply tooling renormalizes alignment mechanically anyway.
   Residue: a linter rule (flag zero/low-slack continuations) + formatter
   renormalization close the corner. A style to know, not a design flaw.
8. **No version/dialect pragma exists yet** — a source-of-truth substrate must
   be able to survive its own evolution.

## 4. The implementation — audit findings

### The bones are excellent

- Layering is right: generated byte-level event core → hand-written arena tree
  → (future) utilities. Zero-copy `Cow` events; `NodeId(u32)` arena with real
  parent pointers and `Copy` handles; no `Rc<RefCell>` sins.
- **The grammar file reads like the spec.** `generator/udon.desc` cites
  FULL-SPEC line numbers at decision points; type declarations
  (BRACKET/CONTENT/INTERNAL) make the event protocol a declared property.
  1,837 lines of legible grammar → 7,501 generated.
- Test architecture is serious: YAML fixture suites audited against FULL-SPEC,
  property-style temporal generators, cross-parser benchmarks (~1.3 GiB/s
  streaming, ~313 MB/s tree per README).

### Verified defects (1–8 ranked worst-first; 9–12 appended as later probes landed)

| # | Finding | Where | Status |
|---|---|---|---|
| 1 | **StreamingParser is structurally incapable of its purpose**: re-instantiates `Parser::new()` per drained line-batch, so the element stack cannot survive a chunk boundary. Splitting `\|parent\n  \|child\n` across two `parse()` calls emits a spurious `ElementEnd` and delivers `\|child` as a sibling *root*. Also: 4KB default buffer; overflow mislabels as `UnexpectedEof` and silently discards data. | `parser.rs:7362+` | **[verified by probe]** |
| 2 | **Typed IDs aren't typed**: `\|step["01"]` yields `id() == Some("\"01\"")` — quote chars included; bracket content captured raw, contra FULL-SPEC ("all the same types are available") and practices-gotchas' own teaching example. | parser + `tree.rs:527` | **[verified by probe]** |
| 3 | **Temporal validation layer absent**: `P1W2D`, `P2WT4H`, `PT1.5H30M`, `9:30` accepted as typed values; `2025-1-3` correctly rejected but without the specified warning. Zero temporal warnings exist in the parser. Known deferral (`temporal.yaml:565` note). Also: `YYYY-MM` emits `Date`, not TIME-SPEC's `YearMonth`. | `values.desc` | **[verified: 49-case audit, 5 divergences — all in the validation layer, none in recognition]** |
| 4 | tree.rs paper cuts: dead identical if/else (`:512-516`); id/class intercept fires only on `BareValue` (`:527`); `Comment` node's content field never populated (content lives in Text children — two representations, one dead); `Raw.lang` always `None` though the name sits on the adjacent Directive node (`:631,648`); `all_text()` jams lines (`"Hello theresecond line"`); nodes carry **no spans**; `Document::parse` reports first error only, message = `Debug` of the code. | `tree.rs` | **[verified by read + probes]** |
| 5 | `span.rs` is dead code — exported (`lib.rs:40`), zero internal uses. | `span.rs` | **[verified]** |
| 6 | Column tracking counts **bytes not chars** — error columns wrong on any multibyte line (i.e., most real prose). | `parser.rs:262-273` | **[verified by read]** |
| 7 | Codegen hygiene: generated code ships two `unreachable_patterns` warnings (`parser.rs:3949`, temporal keyword overlap), blanket `#[allow(unused_variables, dead_code)]`, 135-line copy-paste `format_line`. Warnings in generated code train consumers to ignore warnings. | generated | **[verified]** |
| 8 | Known open parser bug: interpolation inside embedded attr values (`\|{a :href !{{url}} text}`) treated as literal. | `PLAN.md:134` | recorded, not independently re-verified |
| 9 | **Attribute-ordering unenforced**: FULL-SPEC's "attributes must precede child content" is not checked — `:attr` on its own line *after* prose parses silently as an attribute. Discovered probing reflow damage (concern §3.6): it makes reflow's colon-promotion silent when it should be the loud case. | parser / `udon.desc` | **[verified by probe]** |
| 10 | **Sameline fences broken on the spec's own example**: `\|element … \`\`\`` leaves the backticks as literal text, closes the element at EOL, dumps the intended freeform lines to root as prose — and a later fence line then opens a freeform that errors at EOF. Spec says fences "need not be at line start"; impl only recognizes line-initial fences. | parser vs FULL-SPEC | **[verified by probe]** |
| 11 | **Fence closing-indent rule diverges from spec** — in the impl's favor: spec says a closer at "opening indent *or less*" closes (a more-indented closer should not); the impl closes on a more-indented closer too, which is friendlier to markdown muscle-memory (fences in list items, sloppy pastes). Also **beyond spec**: `\`\`\`python` emits `Name("python")` — markdown-style info strings are captured by the impl but unmentioned by the spec (and then dropped by tree.rs, see defect #4's `Raw.lang`). Decide, then spec it (open decision 8). | parser vs FULL-SPEC | **[verified by probe]** |
| 12 | **Line-initial `:` with non-name content eats the colon**: `:-) ok` in prose parses to `Text("-) ok")` — the `:` silently vanishes from content. Failed attr-parse should fall back to *intact* prose (as `\| maybe` does via the pipe guard). | parser / `udon.desc` | **[verified by probe]** |

Adjacent hygiene findings **[verified]**: the fixture conformance suite
(`canonical.rs:230 test_all_fixtures`) runs only under `cargo test --
--ignored` — default runs skip it (it *passes* when run, but an opt-in
conformance gate is a footgun); and the ignored StreamingParser doctest
(`parser.rs:7342`) does not compile (`ParseResult` unresolved).

**Not defects, but absent** (the utilities backlog): serialization back to
UDON (round-trip); value coercion (`as_i64()` etc. — Values hold raw text);
path/selector implementation (udon-paths has none); mixin/reference
*resolution* (Reference nodes are inert); node spans + rich diagnostics.

**Judgment**: a strong foundation roughly 2–3 focused weeks from being a
substrate to trust under vivarium. Every weakness found is in hand-written
peripheral code; none is in the generated parser's actual parsing. Note the
deep tension behind defect #1: *"call stack = element stack"* is the parser's
most elegant property **and** the direct obstacle to resumable streaming — a
suspended Rust call stack cannot be reified. See §5.

## 5. The descent approach — verdict

Judging the *approach*, not the Ruby implementation (which is acknowledged
tech-debt and explicitly out of scope here).

**What it is**: not a yacc/PEG relative — a **Ragel-lineage state-machine
compiler** with two genuine innovations: (a) the type system *declares
event-emission semantics* (BRACKET = paired Start/End, CONTENT =
emit-on-return), making stream well-formedness a property of the grammar
rather than programmer discipline; (b) scanning acceleration (memchr SCAN)
*inferred* from grammar shape. Plus: `.desc` is UDON-shaped — dogfooded,
bootstrappable.

**Against alternatives** (all still available):

- *Hand-written recursive descent*: most debuggable, best errors — but 7.5k
  hand-maintained lines against a moving spec churns badly, and it loses the
  property that matters most now: a grammar file reviewable by someone (human
  or model) who doesn't read Rust. Wrong today; viable after 1.0 freeze.
- *Combinators (winnow/nom)*: indentation sensitivity and context-dependent
  `;` are exactly what combinators handle ugliest.
- *pest/PEG*: cannot express the layout sensitivity; no natural event stream.
  Disqualified by the language's shape.
- *LALR (lalrpop)*: needs a hand-written INDENT/DEDENT lexer — but UDON's
  subtlety *lives* in the layout layer, so you'd hand-write the hard part and
  generate the easy part. Backwards.
- *tree-sitter*: right *editor* companion (incremental, error-tolerant), wrong
  core parser. The existing `tree-sitter-udon` spike is correctly scoped;
  keep both.

**Verdict**: the approach is right for the phase UDON is in — the grammar file
pays dividends on every syntax decision while the spec moves. The
checked-in-generated-code discipline plus the published, pinnable
`descent 0.7.1` gem caps the toolchain risk. The Ruby-target detour's lesson
generalizes: **don't invest in descent's breadth (multi-target); invest in its
depth for the one target that matters.** The one depth investment that changes
the game: **an explicit-stack (pushdown) backend** — same grammars, same
events, but reified state — which makes true resumable streaming fall out for
free and resolves defect #1 at the generator level. If descent gets one more
feature in its life, that's it. If instead the spec freezes and streaming
still matters, the honest fallback is graduating the generated parser to a
hand-maintained artifact.

The IR is currently Rust-coupled (it bakes Rust byte-literals into what should
be target-neutral form — this is what the Ruby detour tripped over). Any
future descent work (Ruby-iterated or Rust-rewritten) should fix the IR first;
it is an IR design flaw, not just messy code.

## 6. Gems recovered from the design notes

The Jan-14 design docs contain settled-in-shape ideas that are easy to forget
and expensive to re-derive. The best of them:

- **key/traits ontology** (`udon-ast.md:74-103`): `[key]` = singular identity,
  existence beyond tree position; `.traits` = plural classification. Not an
  HTML shortcut — a fundamental modeling distinction, with syntax that
  mnemonically matches (brackets = lookup, dot = membership).
- **Type-scoped key uniqueness** (`udon-ast.md:104-134`): `(element-name,
  key)` unique like a per-table primary key; `|user[1]` ≠ `|order[1]`.
- **Typed references + ambiguity-erroring shorthand**
  (`udon-ast.md:137-165`): `@user[1]` explicit; `@[key]` allowed only when
  unambiguous, *error* otherwise — safety by default.
- **ReferenceIndex** (`udon-ast.md:381-432`): bidirectional (inbound/outbound)
  with `unresolved()` — broken-link detection as a first-class document view.
- **The skeleton view** (`udon-ast.md:481-552`): a document map where **every
  line is a valid, copy-pasteable path** (with `[*]` for multiples, attr
  lists, prose indicators, counts). Quietly the single best agent-orientation
  affordance in the whole design — any document becomes its own query
  documentation.
- **SourceInfo as a parallel metadata layer** (`udon-ast.md:271-300`): spans,
  line/col, form (block/sameline/embedded), `original_whitespace`,
  `attr_order` — the round-trip enabler, kept out of the clean tree.
- **Document computed views** (`udon-ast.md:344-378`): `mixins`, `by_type`,
  `by_key`, `by_key_only`, `traits_index`.
- **Comments as a tier of voice** (`udon-ast.md:248-268`): first-class leaf
  nodes carrying AI reasoning, confidence, TODOs — trivially skippable,
  never stripped by default.
- **Path syntax = UDON linearized** (`udon-paths.md`): no new symbols;
  `:customer@` follows a reference stored in an attribute; traits AND-filter;
  positional `[0]` vs identity `[alice]`; `||` recursive descent (flagged by
  its own author as worth user-testing); formal pseudo-BNF included.
- **Agentic tools with intent-not-mechanics philosophy** (`udon-agentic.md`):
  `glance`/`focus` (context-efficient reading), **`propose`/`apply`**
  (preview-with-diff-validation-and-impact-analysis before any mutation — the
  existing design for "declarative correctness-guaranteed edits"), `session`,
  `trace`, `infer`, `validate`, `search`, plus `annotate`/`extract`/`diff`/
  `timeline`/`audit`. The tool definitions are themselves written in UDON.
- **Schema as single source of truth** (`udon-schema-exploration.md`,
  uncommitted): 13 puzzle pieces — types, constraints, relationships,
  actions, policies, evolution metadata (`was`/`since`/`deprecated`), **soft
  regions**, storage projection, derivation targets (SQL DDL, JSON Schema,
  host classes), meta-schema, **dialect declarations**, provenance/confidence
  (uncertainty markers `;?` `;??` `;!`). "The Archema principle extended."
- **The guarantee ladder & consistency profiles** (`udon-guarantees.md`,
  uncommitted): syntactic → schema → referential → atomic → concurrent →
  queryable; Casual/Careful/Critical profiles; the soft/hard content
  distinction named as the underserved territory.
- **The usability harness itself** (`test/usability/`): nine test categories
  including the *invention* protocol (give agents the constraints blind,
  compare what they design — convergence as evidence) and mechanically-scored
  *validated* authoring tests. A reusable eval methodology, not just old
  results. Ships with `ETHICS.md`, the agent-interaction ethics charter —
  a consciousness-infrastructure practice document hiding in a test
  directory.

## 7. CTQ — Critical to Quality

What UDON must have (IN), must not spend on (EX), and must decide (DECIDE) to
be a usable format for its actual near-term consumers (agentic-systems,
vivarium) and its actual authors (agents). Consolidated from Joseph's
2026-07-08 brainstorm, refined against this review; additions beyond the
brainstorm are marked ⊕.

### A. Core language

| | CTQ | Notes / status |
|---|---|---|
| IN | **Core grammar distinct from dialects and host decisions**, with in-language dialect declaration | The seam already exists (`!` = host-owned dynamics; schema-exploration's `!dialect` sketch). Core parses surfaces; dialects/hosts assign semantics. |
| IN | **Pragma**: dialect(s) + expected host-interpreter+version + reserved core-version slot | ⊕ concretization. Nothing exists yet. Design once, tiny surface, future-proofs everything. |
| EX | **Template evaluation** as core | Already decided and implemented correctly: core parses `!if`/`!{{…}}` into inert nodes; evaluation is a host dialect. Keep the syntactic underpinnings; ship no evaluator. |
| IN | **Fully deterministic core** — systematically, checkably | ⊕ concrete mechanism: determinism is checkable *by the generator* — every state's transitions on disjoint byte classes. The `unreachable_patterns` warnings are precisely overlap the generator failed to reject. Make descent verify no-conflict and the .desc grammar *is* the determinism proof. |
| IN | **Non-conflict with the majority of Markdown dialects — measured** | ⊕ make it a corpus test: run CommonMark spec examples through the parser, assert they survive as prose (modulo sigil-initial lines). Currently a design intention, not a measurement. |
| EX | **Parsing Markdown** in core | Defer to host/dialect. But the *subset* must be **named** (Djot-inspired enumeration per feedback.md) because renderer conformance is undefined without it. |
| DECIDE | **Identity syntax**: `@[id]` vs `|[id]`; `$id` vs `key`/`traits`; suffix-attr naming | Blocking — ASF documents accumulate exposure now. Tension to resolve: feedback.md wants `@` dropped (sigil economy); udon-paths builds on `@` (resolution ≠ insertion). Weak lean: keep `@` for reference/resolution, adopt `key`/`traits` naming per udon-ast. Decide as one bundle. |
| DECIDE | **Explicit typing mechanism, temporal as first instance** | The accretion valve for concern §3.2: freeze the core value grammar (strings/numbers/bool/nil/arrays); exotic bare-pattern types (temporal now, others later) become **value-dialects** — on by default in a std profile, pinnable/excludable via pragma, extensible via schema. Preserves least-surprise in both directions. Cost if adopted: `2026-07-07` in a pragma-less strict-core doc is a string. Needs Joseph's call. |
| EX(?) | **Partials & validated references in core semantics** — unless completely, provably ironed out | Joseph's gate, endorsed. Mixin subtree inheritance is explicitly under-defined in FULL-SPEC; references are inert in the implementation. Posture that keeps coherence: core *recognizes* the syntax (reserved), **resolution lives in the tooling layer** — the same move as templates-to-hosts. Graduate into core only with the udon-ast semantics (type-scoped keys, ambiguity-erroring shorthand, ReferenceIndex) fully specified and conformance-tested. |
| IN | **Escape unification decision** (`'` vs `\`) and the rest of the open-syntax list burned down | The list (from feedback.md + implementation-status.md): escapes, hard line-break `\⏎`, BlankLine/Warning spec status, reference augmentation (`|[header].highlighted` — mutable at reference site or not), `||` descent operator confirmation. Cheap pre-1.0, expensive after. |

### B. Confidence & conformance

| | CTQ | Notes / status |
|---|---|---|
| IN | **Practical confidence the grammar is congealed**, with the right extension hooks | Definition of congealed: open-decision list empty + conformance corpus green + generator-verified determinism + extension seams documented (`!` dialects, suffix expansion, pragma). Not a feeling — a checklist. |
| IN | **Conformance corpus as a spec artifact** | ⊕ elevate the existing YAML fixture suites into the host-independent conformance definition (spec-cited, like the CommonMark spec tests). Any future parser passes it or isn't UDON. And it must run **by default**: today `test_all_fixtures` is gated behind `--ignored` (see §4 hygiene note) — an opt-in conformance gate is how divergence hides. |
| IN | **No-panic guarantee + whole-grammar fuzzing** | ⊕ fuzzing exists for temporal only; extend across the grammar. "Any byte sequence → events or Error events, never a crash" is a statable, testable guarantee (the byte-based core makes it cheap). |
| IN | **Spec–impl sync as a standing discipline** | The uncommitted `implementation-status.md` is a snapshot of exactly the right shape; make it a maintained gate (per change: spec'd? implemented? fixture'd?) so "current de facto" never silently diverges from "current authoritative" again. |

### C. Rust ecosystem, first-class

| | CTQ | Notes / status |
|---|---|---|
| IN | **Solid event, streaming-AST, and one-shot AST** | Event core: solid today. One-shot AST: solid bones, needs §4 fixes. Streaming: **broken as shipped** (§4.1) — fate is a DECIDE: descent explicit-stack backend (right fix), or delete `StreamingParser` and document single-shot honestly (honest fix). No third option. |
| IN | **The §4 defect list fixed** | Including: typed IDs, temporal validation layer (implement it — TIME-SPEC's host contract *"we know it's valid"* is the promise the type events make; emitting `Duration("P1W2D")` breaks it), spans on nodes, char-correct columns, `all_text` separators, `Raw.lang`, dead code out. |
| IN | **Round-trip: parse ∘ serialize = identity** | ⊕ no serializer exists. SourceInfo (`original_whitespace`, `attr_order`) is the designed enabler. Prerequisite for every agentic edit tool. |
| IN | **Value coercion API** (`as_i64()`, `as_date()`, …) | Values hold validated raw text by design (good); the ergonomic layer is missing. |
| IN | **Path syntax nailed down + implemented** | udon-paths.md is settled-in-shape; zero implementation. Feeds linter, agentic tools, schema. |
| IN | **Linter + hinter** | Spec warnings (inconsistent indent), style (alignment fragility, over-quoting), plus *hints* (the observed comment-continuation subtlety §3.4 is exactly what a hinter catches). Add **reflow-damage heuristics** (§3.6): attr-after-prose (loud once defect #9 is fixed), comment/directive lines interrupting a paragraph mid-flow, sudden dedent of a paragraph tail — the silent-promotion class no generic editor catches. |
| IN | **Canonical formatter (`udon fmt`)** | ⊕ the gofmt move, with several jobs: canonical style for agent round-trips, ingest/paste renormalization (concern §3.6), and closing the column-alignment corner (concern §3.7, demoted per Joseph's calibration — the first draft over-leaned on it as this row's sole justification). |
| IN | **Common conversions, bidirectional, spec-faithful** | JSON/YAML/XML/MD. The udon-ruby `bin/` scripts were regex sketches (5 of 6 never touched the parser) — reference-only; rebuild on the real tree. |
| IN | **Schema tooling woven through** linter, agentic tools, converters | The schema-exploration puzzle pieces become real here; schema is also the resolution mechanism for the typing DECIDE above. |
| IN | **Error-message quality bar** | Was already a phase-2 goal ("world-class"); plumbing absent (first-error-only, Debug-string messages, no node spans, byte columns). |
| EX | **Ruby and other host-language ecosystems, for now** | udon-ruby: freeze as reference (its 15-test suite documents the event model; its Event→hash mapping is a template for any future projection). Revival is rebuild-from-drift, small but real. |
| EX | **Performance work beyond current** | ⊕ ~1.3 GiB/s streaming / ~313 MB/s tree is already past any near-term need. Don't chase. |
| EX | **WASM / Python / C-FFI bindings** | Phase-6 stays parked. (FFI was already deleted once — Dec 2025.) |

### D. Agent-first affordances

| | CTQ | Notes / status |
|---|---|---|
| IN | **Proven agent minimal-onboarding artifacts** — *proven* = measured | The measurement instrument already exists: `test/usability/` validated-test harness, with a Dec-2025 baseline of **89.6% over 37 mechanically-scored runs** (§3, Empirical support). Refresh the artifacts (`examples/cheatsheet.udon` + practices-gotchas are stale vs current decisions), re-point the harness's broken validator require at the real parser, and re-run — don't reinvent. Widen the model matrix: Codex + Gemini at minimum, plus higher-ranked open-weights/local models; the Dec-2025 scores are a floor from six-month-old Claude-family models. |
| IN | **Agentic tool definitions attached to utilities — declarative, correctness-guaranteed edits** | udon-agentic.md already designed this: `propose` (diff + validation + impact analysis) / `apply`, `glance`/`focus`, `validate`, `session`. Prerequisites, in order: round-trip serializer → node spans → paths impl → schema validation. |
| IN | **Skeleton view, early** | Best orientation affordance in the design (§6); implement in the first utilities pass, not the last. |
| IN | **Syntax highlighting & editor affordances** | tree-sitter-udon spike is the seed; scope TBD. Elevated from nicety by §3.4. |
| EX | **Adoption/pickup worry** | Assuming agent onboarding works, adoption is a consequence, not a workstream. |
| EX | **Training regimes for lower-powered models** (short term) | Grammar-constrained generation notes exist (`docs/`); park them. |

### E. descent & toolchain

| | CTQ | Notes / status |
|---|---|---|
| IN | **Checked-in generated parser + pinned generator** | Keep the discipline; `descent 0.7.1` is published and pinnable. Note: libudon's committed parser was generated by 0.6.17; 0.7.0 changed `/error` semantics (no auto-return) and `udon.desc` is authored for the *new* semantics — **regenerate with 0.7.1 and re-run the suite** before building on top. |
| IN | **Codegen hygiene**: warning-free generated output | Generated warnings erode the only signal channel reviewers of generated code have. |
| IN | **Generator-verified determinism** | See CTQ-A; the single highest-leverage descent feature for the "mathematically consistent core" aspiration. |
| EX | **Iterating the Ruby descent beyond PoC necessity** | Per Joseph: use it as the proof of concept. A Rust descent is justified when (and only when) one of: (a) the explicit-stack streaming backend is wanted, (b) the literate-spec merge (below) begins. Fix the Rust-coupled IR first in either case. |
| IN | **Fused ground truth: spec + grammar + conformance corpus from one source** | Upgraded from aspirational to IN by Joseph (2026-07-08), after this review reconciled *five* divergent opinions by hand — FULL-SPEC prose, `udon.desc`, generated `parser.rs`, the (opt-in) fixture corpus, and live probes (one round of which was itself wrong) — to answer one fence question. Defects #10/#11 are what un-fused ground truth costs. Mechanism options, in rough order of appeal: literate extraction (one source → FULL-SPEC render + `.desc` + fixture YAMLs — and since `.desc` is already UDON-shaped, the fused source can literally be a UDON document: the single-source-of-truth vision applied to the format's own definition); or relocate FULL-SPEC into libudon; or make libudon a subproject of udon. The extraction discipline matters more than the repo mechanics. Full form gated on grammar congealment; the *direction* is no longer optional. Addendum (Joseph): the fused document's test blocks can drop to `!:rust:` for specialized inline tests wherever the fixture DSL comes up short — doctests, UDON-style. See also §2's per-feature genealogy for exactly what this fusion prevents. |

### F. Open decisions (the valve — genuinely Joseph's calls)

1. **Identity syntax bundle** — `@`/`|[id]`, `$id`/`key`/`traits`, suffix
   naming. *Blocking: ASF exposure accumulates now.*
2. **Value-dialect architecture** — freeze core value grammar; temporal as
   first standard dialect (default-on profile?). *Resolves type-accretion
   permanently.*
3. **StreamingParser fate** — descent explicit-stack backend vs honest
   deletion.
4. **Markdown subset** — adopt a Djot-inspired enumeration (renderer
   conformance definition).
5. **Escape unification** — `\` everywhere, `'` deprecated? (feedback.md's
   vote.)
6. **Reference augmentation** — is `|[header].highlighted` legal? (Posed in
   feedback.md, never answered.)
7. **BlankLine/Warning events** — spec-level or implementation-defined?
8. **Fence semantics bundle** — three sub-decisions the probes surfaced
   (defects #10/#11): closing-indent rule (spec's "or less" vs the impl's
   friendlier any-indent-closes), sameline fences (implement per spec, or
   drop from spec), and info strings (`\`\`\`python` → `Name` — impl does
   it, spec doesn't know it; spec it and wire `Raw.lang`). Also decide the
   markdown-fence-in-prose story explicitly: current behavior converts
   fences to structured freeform blocks (reconstructable via the info
   string) rather than passing them through as prose — defensible, but it
   should be a decision, not an accident.
9. **Line-initial sigil guards** — `\|`'s guard (pipe + space = prose) is
   the existence proof that promotion hazards are grammar problems, not
   user problems (Joseph's framing, verified). Decide tightened guards for
   `:` (require name-start; fix the colon-eating of defect #12; with #9
   fixed, attr-after-prose becomes loud), `;` (comment only when followed
   by space/`{`/EOL would rescue `;-)` — check corpus idiom first), and
   `!` (letter-guard exists de facto but `!important` remains unavoidable —
   accept residual risk, rely on linter).

## 8. Reboot sequencing (sketch, not a plan)

Ordered by what unblocks agentic-systems and vivarium soonest:

- **Phase 0 — hygiene (days):** fix stale spec pointers; curate/commit the
  uncommitted trio *(both done 2026-07-08 with this review's commit)*;
  regenerate parser with descent 0.7.1 + full suite (spike 7); make the
  fixture suite run by default; kill codegen warnings; tag a baseline
  release.
- **Phase 1 — decisions (the valve):** §7-F items 1–3 minimum; 8–9 are cheap
  and unblock defect fixes. The decision-brief spikes (§9.2) feed this
  phase. Everything downstream moves faster decided.
- **Phase 2 — the utilities crate (the vivarium/ASF payload):** §4 defect
  fixes; coercion; serializer + round-trip tests; node spans + real
  diagnostics; paths implementation; skeleton view; linter skeleton;
  conversions.
- **Phase 3 — the agentic layer:** propose/apply on top of round-trip + spans
  + paths; schema tooling; onboarding-artifact refresh + measurement.

**What carries forward unchanged** (the "solid parts of the code"): the event
core and its `.desc` grammars; the arena-tree design; the fixture suites; the
descent Rust target (pinned 0.7.1); the design docs' conceptual layer
(key/traits, skeleton, SourceInfo, propose/apply, schema pieces) — which was
never the weak part. **What does not carry forward:** udon-ruby's binding
(reference-only), the StreamingParser façade, the descent Ruby-target detour,
and the assumption that human adoption is the audience.

## 9. Candidate spikes (launchable now)

Concrete investigations this review makes launchable, ordered roughly by
leverage-per-effort. Spikes 1–5 are mutually independent and could run in
parallel today. Per the spike discipline: each should land self-contained at
an honest tier — succeed-beyond-claim, succeed-at-claim, or a demonstrated
no-go, any of which is a real result.

1. **Onboarding re-measurement.** Refresh `test/usability/` (artifacts
   updated to current decisions; scoring re-pointed at the real parser — a
   tiny Rust CLI shim emitting valid/features/warnings JSON beats reviving
   the archived Ruby validator). Run current-generation models: Claude,
   Codex, Gemini, top open-weights/local. Deliverable: the new floor, a
   per-model matrix, and the cheatsheet-vs-minimal artifact ranking. Feeds:
   CTQ-D, the §1 adoption thesis.
2. **Decision briefs for the valve** (three small, parallel): identity
   syntax (decision 1), value-dialects/temporal (decision 2), fence
   semantics (decision 8). Each yields a one-page brief — reconstructed
   context, options, recommendation, honest uncertainty — per the ASF
   decision-surfacing pattern. §2's genealogy table is half the evidence
   already assembled.
3. **Prose-collision corpus study.** Run the CommonMark spec examples (and a
   sample of real ASF/udon markdown) through the parser as prose bodies;
   measure survival vs sigil-promotion rates and line-initial `:`/`;`/`!`
   token frequencies under simulated reflow. Turns CTQ-A's markdown
   non-conflict into a number and gives decision 9 (sigil guards) real
   frequencies instead of anecdotes. Small — about a day.
4. **Round-trip serializer spike.** Emit UDON from the tree; success =
   `parse ∘ serialize` identity over `examples/`. Attempt the hardest part
   first (whitespace/attr-order preservation); a no-go that enumerates
   exactly what `SourceInfo` must capture is as valuable as success — it
   *is* the SourceInfo requirements document. Gates the agentic edit layer.
5. **Explicit-stack backend feasibility (descent).** Prototype pushdown-
   style generation for a small grammar subset; the question is whether
   `.desc` semantics can reify parser state without grammar changes.
   Answers StreamingParser's fate (decision 3) with evidence.
6. **Literate fusion pilot.** Fuse *one* feature — fences, the demonstrated
   divergence — into a single UDON source that extracts to spec prose, a
   `.desc` fragment, and fixture YAMLs (with `!:rust:` doctest blocks where
   the fixture DSL falls short). Proves the CTQ-E pipeline on the exact
   feature whose un-fused cost we just paid.
7. **Regeneration validation.** Regenerate `parser.rs` with published
   descent 0.7.1; diff event streams across `examples/` + fixtures; confirm
   the intended `/error`-semantics delta and nothing else. Phase-0 blocking,
   spike-shaped, an afternoon.
8. **vivarium dogfood MVP.** Minimal `at`/`all` path resolution
   (udon-paths.md subset) over the existing tree, exercised against the live
   ASF process map. Earliest real-consumer signal; surfaces path-syntax
   issues (`||`, `[*]`) before the full implementation commits to them.

## 10. Epistemic status & sources

- **Verified this week** (by execution or primary-source reading): everything
  marked [verified]; the build-from-clean on this machine; the 49-case
  temporal audit; the StreamingParser chunk-boundary probe; the typed-id,
  all_text, Raw.lang, span.rs probes; descent Rust-output byte-identity across
  the Ruby detour; registry states (rubygems: descent 0.7.1 = 2026-01-10,
  HEAD-faithful; `udon` = 2011 fossil at 0.0.4); the reflow/sigil-promotion
  probes and the fence/freeform probes behind defects #9–#12. A methods
  note on the last: the first round of fence probes was invalid — shell
  quoting fed the parser literal `\`` sequences — and briefly produced a
  false "freeform is unimplemented" conclusion; the passing fixture suite
  contradicted it, which forced the re-check. Findings #10–#12 are from the
  clean re-run. When a probe disagrees with a passing test suite, audit the
  probe first.
- **Read in full**: FULL-SPEC.md, TIME-SPEC.md, tree.rs, lib.rs, span.rs,
  udon-ast.md, udon-paths.md, `test/usability/results/AGENT_FEEDBACK.md`,
  `enablement-synthesis.md`, `ETHICS.md`; sampled: parser.rs (structure +
  joints), udon.desc (~150 lines), values.desc (grep-level), udon-agentic.md
  (structure + propose), usability result YAMLs (structure + scoring rubric
  in `lib/validated_tests.rb`). Validated-test aggregates (89.6% etc.) were
  computed from the corpus during this review, not quoted from it.
- **Secondhand** (agent-assisted deep-dives, spot-checked): feedback.md,
  analysis.md, positioning.md, implementation-status.md,
  udon-schema-exploration.md, udon-guarantees.md, NEXT.md, udon-ruby and
  descent internals.
- Comparative-format claims (KDL, Djot, MDX, Ragel, etc.) are from model
  knowledge, not fresh survey — verify before any becomes load-bearing.

*This document is the seed of the reboot, not its plan. Correct the carve
freely.*
