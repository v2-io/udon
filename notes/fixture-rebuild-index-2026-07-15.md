# v0.8 Fixture-Rebuild Index — 2026-07-15

> **Note (2026-07-15, later):** `core/PLAN.md` — referenced by line number
> below — has been drained into the lane TODOs and **deleted** (its
> spec-alignment worklist is subsumed by this rebuild). Retrieve it from git
> history if needed; author fixtures from CORE.md, not from PLAN breadcrumbs.

**What this is.** A multi-agent scan of the whole repo, indexing everything the
[P0] v0.8 fixture rebuild (TODO-META.md) needs in one place: (1) every testable
normative requirement extracted from spec/CORE.md v0.8.0-alpha.1, with fixture
sketches; (2) the exact harness/fixture-file contract; (3) tracking-lane
constraints and Joseph-gates; (4) the known-divergence map (which RED is
expected vs surprising).

**Epistemic status.** The requirement statements below were extracted by
parallel readers of CORE.md and are *unverified secondary artifacts* — per repo
ground rules, each fixture's expectation must be re-derived from the CORE.md
section directly at authoring time. This index is a worklist and coverage
checklist, never a source. `ambiguity` flags are *candidates* for
spec/TODO-SPEC-CORE.md — verify against CORE before filing, since some may be
answered elsewhere in the spec.

**Known gaps in this scan** (two agents hit a session limit; rerun or do inline):
- **Legacy quarry assessment not done** — the per-file validity verdict over
  `core/fixtures/legacy-pre-0.8/` (32 files) against the ratified 0.8 changes.
  Partial substitute: core/PLAN.md lines 153-163 ("Test-first worklist,
  2026-07-14 audit") already lists UPDATE/NEW buckets.
- **Coverage-critic pass not done** — the 146 requirements below have not been
  adversarially checked for missed CORE sections or duplicates.

---

## 1. Harness / fixture-file contract (verified from source)

# v0.8 fixture-file contract (as-implemented, 2026-07-15)

Primary sources read directly: `core/udon-core/tests/common/loader.rs`, `common/harness.rs`, `common/mod.rs`, `tests/canonical.rs`, `tests/boundaries.rs` (fixture-consuming portion), `core/fixtures/v0.8/smoke.yaml`, `core/fixtures/README.md`, `core/udon-core/src/parser.rs` (Event + ParseErrorCode enums).

## Discovery & entrypoints
- Active group is `core/fixtures/v0.8/` — selected by `ACTIVE_GROUP: &str = "v0.8"` in loader.rs:13; `fixtures_root()` = `CARGO_MANIFEST_DIR/../fixtures`. Discovery is dynamic: `active_fixture_names()` globs `*.yaml` (extension exactly `yaml`; `.yml` ignored), sorted by file stem. New files are picked up with no harness edits.
- Consumers: `tests/canonical.rs::v0_8_compliance_group` (main runner; also asserts the group is non-empty), and `tests/boundaries.rs::stochastic_eof_on_fixtures` (re-parses every case truncated at random byte positions, asserting no panic and balanced ElementStart/End). `tests/spans.rs` does not consume fixtures. `canonical.rs` also has an inline `smoke_test` and `fuzz_temporal_values` independent of the yaml files.

## YAML shape (loader.rs `TestCase`)
Top level: a YAML **sequence** of cases. Fields:
- `id: String` (required) — used in failure output; ids containing "unclosed"/"error" suppress variation testing.
- `desc: String` (required)
- `udon: String` (required) — raw source, passed as bytes.
- `events:` (required, may be `[]`) — list where each entry is either a bare string (`ElementStart`) or a 2-tuple `[Name, "div"]` (serde untagged: `Bare(String)` | `WithContent(String, String)`).
- `root_only: bool` (optional, default false) — variation runs skip element-wrapping/indent mutations, only inject blank lines.

## Matching semantics (harness.rs)
Both sides are stringified: actual via `format_event` (e.g. `Name "div"`, using Rust `{:?}` quoting of lossy-UTF8 content; bare names for span-only events), expected via `format_expected` (`Name` or `Name "div"`). Then:
- **Canonical run (`run_test`)**: exact, ordered, full-list equality — event count must match and each position must match string-for-string. No substring matching, no wildcards, no span assertions (spans are stripped).
- **Variation runs (`run_with_variations`)**: input is stochastically wrapped (40% random UDON above/below, geometric indent, injected blank lines); expected events must appear **in order as a subsequence** of actual; extra events are allowed; any `Error …` event not in expected is a failure. Canonical runs once per case plus Poisson(λ=3, min 1) variations (`UDON_TEST_COUNT=0` disables, `UDON_TEST_SEED` reproduces).

## Event vocabulary (parser.rs `Event` enum, lines 12–48)
Span-only (expected as bare strings): `ElementStart`, `ElementEnd`, `EmbeddedStart`, `EmbeddedEnd`, `DirectiveStart`, `DirectiveEnd`, `ArrayStart`, `ArrayEnd`, `FreeformStart`, `FreeformEnd`, `CommentStart`, `CommentEnd`.
Content-carrying (expected as `[Name, "content"]`): `Name`, `Text`, `Attr`, `StringValue`, `BareValue`, `Interpolation`, `Reference`, `RawContent`, `Raw`, `Integer`, `Float`, `Rational`, `Complex`, `Warning`, `Date`, `Time`, `DateTime`, `Duration`, `RelativeTime`.
Quirk: `BoolTrue`, `BoolFalse`, `Nil`, `BlankLine` carry `content` in the enum but `format_event` renders them **bare** — fixtures must write them as bare strings, never `[BoolTrue, "true"]`.
`Error { code: ParseErrorCode }` renders as `Error "Code"`, so fixtures write `[Error, "UnclosedInterpolation"]` (legacy examples confirm). `ParseErrorCode` values: `UnexpectedEof`, `UnexpectedChar`, `Unclosed`, `UnclosedStringValue`, `UnclosedArray`, `UnclosedFreeform`, `UnclosedText`, `NoTabs`, `UnclosedInterpolation`.

## Errors, panics, expected failures
- **Panics** are not caught — a parser panic aborts the test binary; every case (including `events: []`) exercises the parser, so panic-freedom is asserted implicitly by all cases and by the boundaries EOF fuzzer.
- **`events: []` = TODO case**: comparison skipped, but any emitted `Error …` event fails the case ("Unexpected error in TODO test").
- **Expected parse failures** are expressed as ordinary expected events containing `[Error, "<ParseErrorCode>"]` in the exact position they're emitted (the parser recovers and keeps emitting; there is no "this input is invalid, full stop" assertion form). Cases expecting Error, with "unclosed"/"error" in the id, or expecting `FreeformStart` skip variations entirely.

## Harness limitations constraining v0.8 authoring (findings, not verdicts)
1. **Vocabulary is the pre-0.8 parser's enum.** There are no events for CORE 0.8's `<…>` typed values (no `TypedValue`/type-annotation event), and no `Key`/`Trait` events for the identity `key`/`traits` model — only `Name`. Bracket/trait syntax in legacy fixtures was expressed through `Name`/`Attr` events of the old model. Any v0.8 fixture asserting typing or identity semantics has nothing in the current vocabulary to name them with; authoring them will require deciding the 0.8 event vocabulary first (that's a spec/design call for Joseph, per the divergence policy).
2. **Error codes are closed and pre-0.8.** New 0.8 error conditions (e.g. escape-model violations) have no code; adding one requires regenerating the parser enum.
3. **One content string per event, exact `{:?}`-escaped match.** No partial/regex matching, no span or line/column assertions in fixtures (spans are tested separately in spans.rs, not via yaml). Content is compared post lossy-UTF8; invalid-UTF8 payload cases can't be expressed precisely.
4. **`events: []` is overloaded**: it means both "smoke/TODO" and implicitly "must not error" — there is no way to say "parses with no output asserted, errors allowed", nor a `skip`/`pending` flag.
5. **Variation subsequence matching** can mask wrong *extra* events (only missing expected events and unexpected Errors fail), and its wrapping generator (`generators.rs`) produces pre-0.8-shaped context fragments — a rebuilt 0.8 parser may make those generated wrappers themselves invalid; worth flagging for the rebuild.
6. **Temporal events (`Date`/`Time`/…) still exist in the vocabulary** while README states temporal is moving to a `<…>` dialect — fixtures asserting them would encode the pre-0.8 model; the `fuzz_temporal_values` test in canonical.rs likewise assumes the old temporal model.
7. Whole yaml file fails to load on any malformed case (panic in `load_fixtures`), and boundaries' EOF fuzzer runs over every active case regardless of `root_only`/error flags — truncation of intentionally-erroring inputs must still keep Start/End balanced or that separate test fails.

Key file paths: loader `core/udon-core/tests/common/loader.rs`; harness `core/udon-core/tests/common/harness.rs`; runner `core/udon-core/tests/canonical.rs`; event enum `core/udon-core/src/parser.rs:12-48,199-209` (generated file — vocabulary changes go through `core/generator/*.desc` + regenerate).
---

## 2. Tracking lanes, method constraints, Joseph-gates

## The [P0] rebuild task — what it specifies

Canonical statement: /Users/josephwecker-v2/src/udon/TODO-META.md, first Open item ("[P0] Semantic spec-versioning + per-version compliance-fixture groups — principled"). The versioning spine is already done (2026-07-14): spec/CHANGELOG.md, CORE.md at 0.8.0-alpha.1, CommonMark-style model. What REMAINS, exactly as written:

1. **Build the 0.8.0 compliance-fixture group in `core/fixtures/v0.8/`.** Bundling done 2026-07-14 (legacy set aside at `core/fixtures/legacy-pre-0.8/`, tag `grammar-v0.7`; v0.8 group live; harness rewired to discover `*.yaml` in v0.8/ dynamically via `core/udon-core/tests/common/loader.rs::active_fixture_names`, constant `ACTIVE_GROUP`). Remaining scope: **encode CORE exhaustively — edge / degenerate / combination cases — mining legacy for still-valid regressions, segregating temporal/dialect material out.** Described as "the big, workflow-shaped rebuild."
2. **Stand up the unified compliance gate** — event-level fixtures by default (easiest place to reason about/fix the descent grammar); AST-level only where a core-syntax property is genuinely easier to assert there.
3. **`udon-core` declares targeting core-v0.8.0** (a `CORE_COMPLIANCE` marker) → gate RED until green; finalize + tag `core-v0.8.0` when a parser passes.
4. **Wire the drift-check**: CI asserts CORE.md header + CHANGELOG top entry match `spec/CORE-VERSION`.

Done-criterion for the fixture group itself: the group *is* the compliance definition — "compliant with core-0.8.0" means passing `core/fixtures/v0.8/` (core/fixtures/README.md). RED against the held pre-0.8 parser is the intended honest state while cases land; the tag `core-v0.8.0` fires only when a parser passes.

## Constraints / decisions already recorded (fixture format & event model)

- **Format**: YAML fixtures, `- id / desc / udon / events` list; `events: []` = run-for-panics-only (see v0.8/smoke.yaml and harness.rs::run_test). Legacy files show the event vocabulary (ElementStart, [Name, "div"], ElementEnd, Text, CommentStart/End, Reference, Warning, ...).
- **Never trace parser output into expectations** — repeated anti-pattern, work reverted for it. Workflow: read CORE section → write spec-based expectations → tests fail → fix parser. (core/CLAUDE.md; core/PLAN.md "CRITICAL WARNING".)
- **Event-level by default**, AST-level only when genuinely easier (TODO-META gate item).
- **Spec-behavior parser items ARE fixtures**, not CORE-PARSING tasks — "a 'make the parser do spec-behavior X' item *is* a v0.8 compliance fixture" (TODO-META bootstrap rule, echoed in TODO-CORE-PARSING).
- **Segregate temporal/dialect**: bare temporal now → String/BareValue; temporal moves to a `<…>` dialect; `temporal.yaml` (~40 cases) is in the update-when-flipped bucket, and dialect cases don't belong in the core group.
- Legacy quarry: 32 files in legacy-pre-0.8/, frozen and unsorted; the rebuild lifts still-valid regressions out.
- Wire-name change: `id`/`class` → `$key`/`$traits` (~60 legacy expectations flip).
- **Small internal contradiction worth noting**: v0.8/smoke.yaml's header says "Real cases are MINED from ../legacy-pre-0.8/ ... not authored here," whereas TODO-META (and fixtures/README.md) make exhaustive CORE encoding the primary method with mining as a supplement. TODO-META is the fresher, principled statement; the smoke comment understates the scope.

### Ready-made worklists in core/PLAN.md (stale-bannered overall, but the 2026-07-14 sections are current breadcrumbs)

- "Spec Alignment — catch up to CORE (2026-07-13)" (PLAN.md:73–163): the parser-lag items that become fixtures — wire-names, `:id`/`:class` hijack (defect #4), typed bracket/key values (#2), `:`-after-content=prose (#9), duplicate-(element,key) policy enum, head-position `!{{value}}`, escape-model rewrite (`\` head-position force-prose, `'` retired), `@`-reference divergences, multi-attr block-line Warning, D-TRAIT-SUFFIX (`.foo?` = trait "foo?"), `0d`/`0D` prefix, `<…>` typing envelope (zero fixtures today — flagged "biggest test hole").
- "Test-first worklist (2026-07-14 audit)" (PLAN.md:153–163): explicit UPDATE list (temporal.yaml, escapes/escape_prefix/literal_escape, references.yaml `:[id]` merge removed, the $key/$traits rename) and a NEW-fixtures list (`<…>` typing all forms; attribute stacking; `@`-inert; duplicate-policy enum; head-position edges; fence head/scan edges; `\`-escape forms; array quote/`}`/UnclosedArray; typed bracket keys).

## Dependencies / unblocks across lanes

- **SPEC-CORE**: CORE is "current with all ratified decisions as of 2026-07-14" — the spec prerequisite for the rebuild is satisfied. Two open items: FULL-EBNF.md fate (deferred by Joseph — do NOT cite FULL-EBNF while authoring fixtures; it has already caused confusion) and filename-designator↔pragma binding *(discuss w/ Joseph)* — the latter is schema-layer, unlikely to gate core fixtures.
- **CORE-PARSING** is downstream: once the fixture group exists it holds only residuals (streaming resumption/defect #1, grammar DRY, descent-tool items). Its "pull residuals from PLAN.md / delete PLAN when drained" task is entangled with the rebuild's deprecate-subsumed rule.
- **PARSER** (AST lane) is predicated on a stable event parser; only relevant if any fixture is AST-level.
- **META bootstrap task** (drain legacy tracking, deprecate subsumed) executes largely *through* the rebuild.
- REBOOT-PLAN backlog items H2 (fixture suite default-on) and H4 (CI drift gate) fold into the compliance-gate step.

## '(discuss w/ Joseph)' gates and stop-conditions

Explicit markers: filename-designator↔pragma binding (spec/TODO-SPEC-CORE.md) and user-facing parser API decisions (core/TODO-PARSER.md) — neither directly blocks event-level fixture authoring. Real gates for authoring: (a) FULL-EBNF adjudication pending — treat it as non-source; (b) rational/complex bare-vs-dialect is an open design fork (design/composite-types.md), explicitly NOT a parser task — don't author bare rational/complex fixtures without a ruling; (c) standing rule: any spec silence/contradiction found while encoding CORE goes to `spec/TODO-SPEC-CORE.md` with evidence and to Joseph, never resolved locally; the smoke.yaml-vs-TODO-META method wording above is a minor instance already found.

Key files: /Users/josephwecker-v2/src/udon/TODO-META.md, /Users/josephwecker-v2/src/udon/core/PLAN.md (lines 73–163), /Users/josephwecker-v2/src/udon/core/fixtures/README.md, /Users/josephwecker-v2/src/udon/core/fixtures/v0.8/smoke.yaml, /Users/josephwecker-v2/src/udon/core/udon-core/tests/common/loader.rs.
---

## 3. Known divergences — expected-RED map

Known parser/grammar divergences from CORE (v0.8.0-alpha.1), from REVIEW-JULY-2026.md §2 + §4 and core/TODO-CORE-PARSING.md. Two tiers: (I) the wholesale pre-0.8 lag, (II) the review's numbered defects. All fixture-area names refer to legacy-pre-0.8 group names, which the v0.8 rebuild will likely mirror.

TIER I — WHOLESALE: the parser and grammar still build the *pre-0.8* model (README "Status", 2026-07-14). Every v0.8-ratified change is therefore an expected RED across its whole area:
- Escape unification → escapes / escape_prefix / literal_escape fixtures RED.
- `<…>` typing (typed values dialect; temporal moving into a `<…>` dialect per README) → value_types / values / temporal fixtures RED.
- Numbers / `0d` → values / value_types RED.
- Identity `key`/`traits` (was $id/id/key three-way, §2 class C, decision 1) → element_id / element_class / element_combined / element_suffix RED.
- `@`-inert → references RED (defect #16's `@[` promotion find is subsumed here).
- Fences ratification (decision 8 outcome) → freeform_blocks RED.

TIER II — NUMBERED DEFECTS (§4; open ones = expected RED, fixed ones = should be GREEN in their area and RED would be surprising):
- #1 StreamingParser cannot survive chunk boundaries (spurious ElementEnd, child-as-root; 4KB overflow mislabeled UnexpectedEof). OPEN (TODO-CORE-PARSING "streaming resumption"). Affects streaming harness, not one-shot fixtures — RED only if the rebuild adds chunk-split cases (indentation_hierarchy shapes).
- #2 Typed bracket-IDs not typed (`["01"]` keeps quotes, raw capture). OPEN; rides with identity decision → element_id RED.
- #3 Temporal validation layer absent (P1W2D etc. accepted; no warnings; YYYY-MM → Date not YearMonth). OPEN → temporal RED (recognition itself was 44/49 in-sync).
- #4 tree.rs paper cuts — FIXED 2026-07-11 except BareValue-only id/class intercept (rides with #2/decision 1) → element_id/element_class residual RED only.
- #5 span.rs dead — FIXED (wired; all nodes carry Span). GREEN expected.
- #6 byte-not-char columns — FIXED. Multibyte-position cases should be GREEN; RED = surprising.
- #7 codegen hygiene (warnings, copy-paste) — behavior-neutral; no fixture RED.
- #8 interpolation inside embedded attr values treated as literal. OPEN (recorded, not re-verified) → dynamics / embedded_elements / inline_attributes RED.
- #9 attrs-before-children unenforced (`:attr` after prose silently an attribute). OPEN, class D founding aspiration → attributes / indentation_hierarchy RED.
- #10 sameline fences unrecognized (line-initial only; spec's own example breaks). OPEN, class D; final form depends on decision 8 → freeform_blocks RED.
- #11 fence closing-indent: impl closes on more-indented closers (spec said "or less"); impl also captures info strings (```python → Name) unspec'd. Class B — impl was the later deliberate choice; whether GREEN or RED depends on what 0.8 CORE ratified for fences (verify against CORE at fixture-write time) → freeform_blocks.
- #12 line-initial `:` with non-name content ate the colon — data-loss half FIXED (intact fallback everywhere); the promotion boundary itself remains decision 9 → comments_and_text / text: fallback cases GREEN, promotion-rule cases RED-pending-decision.
- #13 dots broke bare array items (`[a.b]`) — FIXED (descent SCAN inference root cause). arrays GREEN expected.
- #14 multi-word fence info strings truncated (```rust ignore → Name("rust") only). OPEN → freeform_blocks RED.
- #15 blank lines dropped inside freeform — FIXED (BlankLine emitted, ws-only lines exact Text). freeform round-trip GREEN expected.
- #16 prose span offsets on guard-char-initial lines — span half FIXED (asserted in tests/spans.rs); `![`/`!(` phantom-directive and `@[` promotion remain decision 9 / @-inert → text/dynamics RED for those.

Also from §2 genealogy, not defect-numbered: sameline fences (class D, never attempted — freeform_blocks RED); BlankLine event (class B impl innovation, decision 7 — whether blank-line fixtures expect the event depends on what 0.8 CORE says); fence info strings (class B, unspec'd — see #11/#14).

Adjacent: the full fixture conformance suite runs only under `cargo test -- --ignored` (H2 makes it default-on) — a "green" default run proves nothing about compliance.

Caveat per repo ground rules: defect numbering and class calls above are the review's reads against FULL-SPEC (pre-0.8). At fixture-writing time each expectation must be re-derived from spec/CORE.md directly, not from this list — especially fences (#10/#11/#14), BlankLine, and identity, where 0.8 may have ratified something different from either the old spec or the impl.

Sources: /Users/josephwecker-v2/src/udon/REVIEW-JULY-2026.md (§2 lines 52–104, §4 lines 289–343), /Users/josephwecker-v2/src/udon/core/TODO-CORE-PARSING.md, /Users/josephwecker-v2/src/udon/core/fixtures/{v0.8,legacy-pre-0.8}/.
---

## 4. Requirements extracted from CORE.md (146)

One entry per testable normative behavior. `⚠ ambiguity` marks a candidate spec gap/contradiction — verify, then file in spec/TODO-SPEC-CORE.md.

### `head-reentry-every-line` — Positional Contexts > Head Position (~L83-95)

Head position is re-entered at the start of every line at a structural column, including lines following prose lines; child elements, fences, and prose lines may freely interleave under one element.

- **Fixture sketch:** |a with prose line, then |b child, then more prose, then a ``` fence — expect Element(a), Text, Element(b), Text, Fence events, all children of a.
- edge: marker line immediately after a prose line at same column still parses as structure
- edge: fence after prose

### `prose-deeper-line-not-head` — Head Position (~L88-91)

A line indented deeper than the current prose's content column is inside that prose, not head position — markers on it are literal.

- **Fixture sketch:** |a\n  prose base\n    |not-an-element — expect the deeper line as prose text '|not-an-element' continuing the block, no Element event.
- edge: deeper ':key' line inside prose
- edge: deeper ``` inside prose

### `sameline-scan-through-markers` — Head Position (~L92-94)

On an element line, head position persists through consecutive elements and attributes (|a |b :k v); elements and attributes keep the scan open, and the first prose word ends it for that line.

- **Fixture sketch:** |a |b :k v word :notattr — expect nested Element(b) with Attr k=v, prose 'word :notattr' (the second : literal).
- edge: |a |b |c chained nesting
- edge: attribute then another element? (order variations)
- **⚠ ambiguity:** The spec shows attrs then prose; whether an element marker after an attribute (|a :k v |b) re-opens structure or the value swallows '|b' is governed by sameline value rules elsewhere — this section alone doesn't say when a sameline value ends vs when scan continues.

### `prose-commit-per-line` — Head Position (~L100-104)

Once the line commits to prose, any later occurrence of | : ! ; @ or ``` on that same line is literal text; head position returns on the next line.

- **Fixture sketch:** |p a | b :-) ! ; ``` — all literal in one Text event; Markdown table row '| a | b |' at line start where guard fails.

### `markdown-table-pipe-prose` — Elements > recognition rule (~L276-279)

| is an element marker only when followed by a letter, [, ., {, or '; otherwise the | is prose (e.g. '| cell |' table rows, '|-', '|=', '| ').

- **Fixture sketch:** Lines: '| a | b |', '|-', '|1', '|', '| x' — each expect Text, no Element.
- edge: '|1' (digit — not a letter) is prose
- edge: '|-' prose
- edge: bare '|' at EOL prose
- edge: non-ASCII letter after |
- **⚠ ambiguity:** Guard says 'letter' while bare names use XID_Start — unclear if the guard admits non-ASCII XID_Start letters. Also the guard list omits ? ! * + yet Anonymous Elements ratifies '|?' as an element — direct contradiction (see anon-suffix-only).

### `bang-guard` — Marker Recognition (~L286-290)

! at head position is a directive only when followed by an identifier character or ':' (!if, !for, !:lang:); ![img], !=, !( are prose. !{...} is a prose-level inline form, not a head-position block directive.

- **Fixture sketch:** '![img](pic.jpg)' as a line -> Text; '!if x' -> directive event; '!:elixir:' -> directive/fence-lang form.
- edge: '!=' prose
- edge: '!' alone prose
- edge: '!{x}' at line start — inline form in prose?
- **⚠ ambiguity:** Whether a line beginning '!{...}' at head position is prose containing an inline interpolation or something else is stated only by exclusion ('not a head-position block directive').

### `at-guard` — Marker Recognition (~L291-293)

@ at head position is a reference marker only when followed by [ or an identifier character: @[key], @element[key]; otherwise prose. The core emits the reference; meaning is consumer-level (@ is inert).

- **Fixture sketch:** '@name', '@[k]' -> Reference events; '@ x', '@!', 'email@host mid-prose' -> prose.
- edge: @ mid-prose never a reference
- edge: '@1' — digit is XID_Continue not Start; identifier start required?
- **⚠ ambiguity:** 'followed by an identifier' — unclear if that means an identifier-start character (excluding digits) or any identifier character.

### `colon-phase-restriction` — Marker Recognition (~L294-297)

Line-initial ':' is an attribute only while the element has no child content yet; once any text or child element has appeared, a line-initial ':' is prose. A ':' not followed by a name also falls back to prose intact.

- **Fixture sketch:** |a\n  :k v\n  prose\n  :later x — expect Attr(k), Text('prose'), Text(':later x'). Also ': foo' and ':-)' at attribute-phase position -> prose including the colon.
- edge: ':' after a child element (not just after prose)
- edge: ': ' colon-space
- edge: ':-)' emoticon
- edge: block vs sameline phase interaction

### `semicolon-comment-contexts` — Marker Recognition (~L298-299) + Positional Contexts

';' is a line comment at root, sameline, and after attribute values, but literal inside block prose.

- **Fixture sketch:** Root '; note' -> Comment event; '|a :k v ; c' -> Attr k=v + Comment; block prose line 'a ; b' under an element -> is the ';' literal? Per this rule literal in block prose.
- edge: '; ' at very start of file
- edge: ' ;' terminating a block attr value (Attributes section L457)
- **⚠ ambiguity:** This section defers to 'the Comments table' (outside 69-443); the exact matrix (e.g. ';' at start of a block-prose line vs mid-prose-line) must be cross-checked there.

### `backtick-fence-head-only` — Prefixes/Head Position (~L166-169, 299)

Triple-backtick is recognized as a freeform block opener only at head position; after prose has begun on a line it is literal.

- **Fixture sketch:** '|p code ``` x' -> backticks literal; line-start '```' under an element -> fence event.
- edge: fence marker on line after prose line (head re-entry — should open fence)

### `block-vs-sameline-attr-values` — Block vs Sameline (~L108-128)

Block attribute values run to end of line and may contain unquoted spaces; sameline attribute values are space-delimited and require quoting for spaces.

- **Fixture sketch:** |a\n  :author Alice Smith -> Attr author='Alice Smith'. |a :author Alice Smith -> Attr author='Alice', prose 'Smith'? (or Smith as next token — per sameline scan, 'Smith' is first prose word).
- edge: trailing spaces on block value
- edge: block value ' ;' comment terminator

### `block-prose-sets-indent` — Block vs Sameline (~L120-128)

Block prose sets the indent-column for continuation (multi-line prose at consistent indentation joins one prose block); sameline prose does not set an indent-column.

- **Fixture sketch:** |s :name intro\n  line one\n  line two -> one prose flow at column 3. |p same line prose\n  child-indented line — what column governs?
- edge: continuation line at same column as first prose line
- edge: sameline prose followed by an indented line
- **⚠ ambiguity:** What indent-column governs lines following sameline prose (since sameline prose 'does NOT set indent-column') is not specified here.

### `inline-element-basic` — Inline Elements (~L130-142)

|{name ...} inside prose creates an inline element: identity rules identical to block elements, sameline-style attributes, content terminating at the matching brace (brace-balanced), nested |{...} allowed, block form |name not allowed inside.

- **Fixture sketch:** |p Click |{a :href /home here} to continue. -> Text('Click '), InlineElement(a, href=/home, text 'here'), Text(' to continue.'). Nested: |{em |{strong x}}. Brace balance: |{code {not end} still content}.
- edge: brace balancing with literal { } in content
- edge: |{a[k].t ...} identity sugar inline
- edge: embedded attr value terminated by }
- edge: unclosed |{ at EOL/EOF
- **⚠ ambiguity:** Behavior of unclosed |{...} (EOF/newline before }) and of a literal '|name' inside |{...} ('not allowed' — prose? warning?) is unspecified.

### `escape-head-forces-prose` — Escape (~L171-190)

A backslash at head position is consumed and forces the rest of the physical line to verbatim prose, regardless of what follows (| : @ ; fence, or nothing special); position, not a character set, defines the escape.

- **Fixture sketch:** Each of \|element, \:not-an-attr, \@name see this, \```not a fence, \![img](pic.jpg) as child lines -> Text equal to the line minus the leading backslash.
- edge: \ before a non-special char (\hello -> 'hello'? no — spec says \![img] harmless: the \ is still consumed at head position)
- edge: \ then EOL (empty prose line?)
- **⚠ ambiguity:** '\![img] ... never special -- harmless' shows the \ consumed even before a non-marker; but 'Any other \ is literal' example '|a hello \world -> "\world" literal' concerns non-head backslashes. A head-position '\hello' should yield 'hello' by the position rule; worth a fixture to pin.

### `escape-sameline` — Escape (~L192-202)

In the sameline scan, a \ reached before any prose forces the remainder of the line to prose on the current element; the \ consumes only itself so a following space is kept, and ';' after it is literal.

- **Fixture sketch:** |element |another :val [234 19] \ how wonderful ; it is -> another gets :val [234 19] and child prose ' how wonderful ; it is' (leading space preserved).

### `escape-inline-openers` — Escape (~L204-213)

In prose flow, \ immediately before an inline opener — |{, !{, or ;{ — is consumed and makes the opener literal; prose continues. These are the only prose-flow escapes.

- **Fixture sketch:** |p see \|{em x} -> literal '|{em x}'; |p price \!{cost}; |p wink \;{x}.
- edge: \| not followed by { in prose (literal \, per next rule)
- edge: \!{ covering interpolation/directive/raw uniformly

### `backslash-otherwise-literal` — Escape (~L215-224)

Any \ not at head position and not before an inline opener is emitted literally; escape sequences like \n, \t and trailing-\ line-join are NOT interpreted by the core (host/app layer).

- **Fixture sketch:** |p Windows path C:\Users\me -> text unchanged; |p wrap this line \ -> trailing backslash preserved; |a hello \world -> prose contains '\world'.
- edge: \n mid-prose stays two chars
- edge: trailing \ does not join lines

### `double-backslash-leading` — Escape (~L226-228)

A leading \\ yields a single literal \: the first is consumed (forces prose), the second passes through — \\ -> \ universally, even \\hello -> \hello.

- **Fixture sketch:** Child lines '\\path\to' -> '\path\to'; '\\hello' -> '\hello'.

### `escape-anchors-prose-base` — Escape (~L230-244)

A head-position \ takes up no column: the following text backs up one column into the \'s position, which becomes the prose content-base; only the first line needs the \, later lines follow normal dedentation, and dedenting past the base fires a Warning and resets the base.

- **Fixture sketch:** The L239-244 example verbatim: expect prose lines with interior indentation preserved relative to the \ column, plus one Warning event on the final under-indented line with base reset.
- edge: more-indented later lines kept with extra indent
- edge: less-indented-but-past-base line kept
- **⚠ ambiguity:** The spec itself flags (L257-260) that the precise column bookkeeping of the consumed \ is 'a grammar-level detail to settle' — fixture expectations for exact column arithmetic are provisional.

### `backslash-past-base-warning` — Escape (~L246-256)

A \ beginning a line's content but deeper than an established prose content-base is not at head position: it is passed through literally and a Warning fires.

- **Fixture sketch:** |element\n  \  start some prose\n    \some more prose -> second line text '  \some more prose' (backslash literal) + Warning event.

### `apostrophe-not-escape` — Escape (~L262-266)

' is not an escape: a line beginning '| is prose starting with an apostrophe. Inside quoted strings, \ follows the string's own escaping rules, not the head-position rule.

- **Fixture sketch:** Child line ''|foo' -> Text("'|foo"); attr :k 'a\'b' exercises in-string escaping (cross-check Value Types section).

### `identity-desugar` — Identity and Classification (~L305-341)

[key] and .trait are pure sugar over ordinary attributes: |el[k] == |el :'$key' k; |el.a.b == two stacked :'$traits' attrs (a then b, order preserved, NOT one list value); the model has only name + ordered attributes + children.

- **Fixture sketch:** |el[k].a.b -> events Attr($key,k), Attr($traits,a), Attr($traits,b) in that order; compare byte-for-byte with |el :'$key' k :'$traits' a :'$traits' b hand-written form — identical event streams.
- edge: interleaving with real attrs preserves document order
- edge: single trait still stacks as one $traits attr

### `key-value-typing` — Identity (~L325-327)

The value inside [...] follows normal attribute-value typing: [1] is integer 1, ["01"] is string "01", [abc-123] is string abc-123.

- **Fixture sketch:** Three elements |a[1] |a["01"] |a[abc-123] -> $key values typed Int(1), Str(01), Str(abc-123).
- edge: [true]/[0d...]/other core scalars inside [...]
- edge: list inside [...]? (core doesn't proscribe — 'no array-valued $key' is explicitly a schema example at L47)

### `dollar-names-quoted-longhand` — Identity (~L329-336)

$-names are legal ordinary attribute names; since $ is not a bare-name character, writing one requires quotes (:'$key' v), and a longhand :'$key' 3890 is indistinguishable from |el[3890].

- **Fixture sketch:** |el :'$key' 3890 vs |el[3890] -> identical event streams; also an arbitrary :'$custom' v is accepted.
- edge: :$key unquoted — $ ends bare-name-start, so this should fall back to prose/error per bare-name rules

### `bare-name-charset` — Identity (~L343-354)

A bare element name (and bare trait value) starts with a Unicode XID_Start character (digits, _, - excluded first) and continues with XID_Continue or '-'; any other character (space, ., [, :, $, punctuation) ends the name; quoting (|'weird name', .'ns.kind') admits arbitrary names.

- **Fixture sketch:** |my-element ok; |_x and |-x and |9x should NOT parse as those names (| guard: _ 9 - not letters -> prose); |a$b -> name 'a' then '$b' is... boundary case; |'weird name' -> Element('weird name'); .'ns.kind' quoted trait.
- edge: kebab-case first-class
- edge: trailing '-' in name
- edge: non-ASCII identifier (e.g. |café)
- edge: name ended by '[' immediately (|a[k])
- **⚠ ambiguity:** What happens to the residue when a non-name char like $ ends the name mid-token (|a$b) — attribute? prose? error? — is not stated. Also Unicode version pinning is explicitly host-decided (L356-362), so fixtures should avoid version-sensitive codepoints.

### `suffix-desugar` — Element Suffixes (~L369-384)

Suffixes ? ! * + desugar to specially-designated boolean-true attributes :'$?' :'$!' :'$*' :'$+'; the core performs only the expansion, attaching no meaning.

- **Fixture sketch:** |field[name]? -> Attr($key,name), Attr($?,true); one fixture per suffix character.
- edge: suffix with no key: |name?
- edge: multiple different suffixes on one element? (not shown — allowed?)
- **⚠ ambiguity:** Whether an element may carry more than one suffix (|el?! or |el? !) is unstated.

### `suffix-positions` — Element Suffixes (~L386-395)

A suffix binds to element identity and is legal: after the name; after name before key; after name before key and traits; after key; after key with space before traits; and space-separated at the end after traits.

- **Fixture sketch:** Six fixtures mirroring L388-393 (|name?, |name?[key], |name?[key].trait, |name[key]?, |name[key]? .trait, |name[key].trait ?) — all yield the same $? placement (plus the attr-order question).
- edge: does suffix position affect attribute order in the event stream?
- **⚠ ambiguity:** Desugared *ordering* of $? relative to $key/$traits when the suffix appears in different positions is unspecified (matters given ordered-attribute model).

### `suffix-chars-in-traits` — Element Suffixes (~L397-407)

* ! ? + touching a .trait are part of the trait value (.foo? is trait "foo?"); an element suffix after a trait must be space-separated or precede the trait: |el.bar? -> traits ["bar?"]; |el.bar ? -> traits ["bar"] + $?=true; |el?.bar -> $?=true + traits ["bar"].

- **Fixture sketch:** The three L403-405 cases as exact event-stream fixtures.
- edge: .foo?* multi-suffix-char trait
- edge: .foo? followed by [key]?

### `anon-elements` — Anonymous Elements (~L409-423)

The element name is optional: | followed directly by a key, trait, or suffix yields a nameless element that is ordinary in every respect (may carry attrs, children); the core attaches no meaning to namelessness.

- **Fixture sketch:** |[k], |.some-trait, |.some-trait :adapter pg, |? -> Element(name=none) with respective $key/$traits/$? attrs; give one children.
- edge: |[k].t? full sugar combo, nameless
- edge: |'quoted' — quoted name, not anonymous
- **⚠ ambiguity:** '|?' contradicts the element recognition rule (L276-278: | marks only before letter, [, ., {, '). Either the guard list is incomplete (missing ? ! * +) or |? is not recognizable — CORE says different things in two places. Same question for |!, |*, |+ standalone.

### `host-views-traits-list` — Host Views (~L425-440)

(Recommended, not mandatory) Hosts expose all_attributes (document order, including $-designated) and the key/traits/attributes split where traits is ALWAYS a list — the sole normalization beyond desugaring.

- **Fixture sketch:** AST-level (not event-level) fixture: element with zero/one/two traits -> traits [], ["a"], ["a","b"]; a $custom attr appears in all_attributes but not in attributes-split? — actually 'attributes' excludes designated ones, so $custom excluded there.
- edge: multiple $key values ('value(s) of $key' — stacking applies to $key too)
- **⚠ ambiguity:** This is a recommendation ('the spec recommends a default shape'), so compliance-fixture status is unclear — likely belongs to a host/AST fixture tier, not the core event group. Also 'key is the value(s) of $key' implies stacked $key surfaces plural — shape unstated (scalar vs list when single?).

### `attr-novalue-booltrue` — Attributes (~L461-470, context just past range)

An attribute followed immediately by ':', newline, or a context terminator (}) has no value and is boolean true — the parser emits BoolTrue.

- **Fixture sketch:** |button :disabled :type submit -> Attr(disabled, BoolTrue), Attr(type, 'submit'); block-context ':flag' alone on line; embedded |{x :flag} terminated by }.
- edge: valueless attr at end of line sameline
- edge: valueless attr before }

### `warning-blankline-events` — Overview parser-behavior note (~L28-31, context)

Comments, blank lines (BlankLine event), and recoverable anomalies (Warning event, e.g. inconsistent indentation) are emitted as events by the main parser alongside structural ones.

- **Fixture sketch:** Doc with blank lines between children -> BlankLine events present in stream; inconsistent-indent doc -> Warning, parse continues (recoverable).

### `attr-sameline-multiple` — Attributes (~l446-459)

Multiple attributes may appear on the element definition line; sameline values are space-delimited, and a `:` after a space begins the next attribute.

- **Fixture sketch:** `|element :key value :another-key another value` → wait: sameline values are space-delimited, so expect Attr(key,"value"), then `another` etc. Better minimal: `|el :a 1 :b 2` → Attr(a,1), Attr(b,2). Also `|el :k v w :b 2` → Attr(k,"v"), then `w` becomes sameline prose? — see ambiguity.
- edge: attribute at end of line
- edge: attribute immediately followed by next `:`
- **⚠ ambiguity:** The intro example `|element :key value :another-key another value` shows a sameline value 'another value' containing a space, but the Sameline Attribute Values rules say SPACE terminates the value ('quote for spaces'). The intro example appears inconsistent with the normative terminator rule — unclear whether the trailing bare words become prose, an error, or are absorbed.

### `attr-block-context` — Attributes / Block Attribute Values (~l452-546)

An attribute on its own indented line under an element is a block attribute; its unquoted value runs to end of line (spaces allowed unquoted), terminated only by `\n` or ` ;`.

- **Fixture sketch:** `|el\n  :key value with spaces allowed here` → Attr(key, "value with spaces allowed here").
- edge: trailing spaces before newline — included in value or trimmed? (spec silent)
- edge: value containing `:` mid-line

### `attr-valueless-booltrue` — Attributes (~l461-470)

An attribute with no value — followed immediately by `:`, newline, or a context terminator — emits BoolTrue.

- **Fixture sketch:** `|button :disabled :type submit` → Attr(disabled, BoolTrue), Attr(type, "submit"). Also `|el :flag` (EOL), `|{a :flag}` (terminator `}`), block line `  :flag` alone.
- edge: valueless attr terminated by `}` in embedded context
- edge: valueless attr terminated by `]`? (arrays don't contain attrs — n/a)
- edge: valueless block attr followed by ` ; comment`

### `attr-inline-list` — Inline Lists (~l472-482)

Square brackets make a list value; items are space-delimited; quoted strings allow items with spaces.

- **Fixture sketch:** `|server :ports [8080 8443 9000] :tags [api public]` → ports = list(8080,8443,9000), tags = list("api","public"). `:t ["hello world" foo bar]` → 3 items.
- edge: empty list `[]`
- edge: single item
- edge: list followed immediately by next `:attr`

### `attr-stacking` — Attribute Stacking (~l484-497)

Repeated attribute keys stack: each `:key` occurrence emits its own Attr event, in source order; last-wins is prohibited.

- **Fixture sketch:** `|el :x 1 :x 2` → Attr(x,1), Attr(x,2), both preserved in order; host view x = [1,2].
- edge: stacking across sameline+block contexts (`|el :x 1` then block `:x 2`)
- edge: stacking of $traits via `.a.b` desugar

### `attr-stacking-list-orthogonal` — Attribute Stacking (~l498-509)

Stacking and list literals are orthogonal multiplicity axes and compose: a `[...]` is one value; stacked lists yield a list of lists.

- **Fixture sketch:** `|el :x [1 2] :x [3]` → two Attr events, values list(1,2) and list(3); host x = [[1,2],[3]].
- edge: scalar stacked with list: `:x 1 :x [2 3]`

### `attr-stacking-uniform-core` — Attribute Stacking (~l505-509)

Core never forbids multiplicity — even designated attributes like `$key` stack; restriction is a schema concern only.

- **Fixture sketch:** `|el[a][b]` or `|el :$key a :$key b` → two $key Attr events with no core error/warning.
- edge: multi-valued $key surfaced through host `key` view

### `attr-complex-value-indent` — Complex Attribute Values (~l511-523)

An attribute followed by newline + indent takes the indented block as its structured value.

- **Fixture sketch:** `|api-endpoint\n  :headers\n    |header :name A` → the `|header` element is the value/content of `:headers`, not a child of `|api-endpoint`.
- edge: attr with sameline value AND indented content — allowed?
- edge: prose (not elements) indented under a block attr
- **⚠ ambiguity:** The event-stream shape is unspecified: does `:headers` emit Attr with a structured value, or an attr-scope open/close with nested Element events? Also unclear whether the valueless `:headers` still emits BoolTrue per the valueless rule before the indented block reassigns meaning — the two rules (valueless→BoolTrue at newline vs newline+indent→structured value) conflict on the same input prefix.

### `block-attr-semicolon` — Block Attribute Values (~l529-543)

In a block attribute value, `;` preceded by a space starts a comment; `;` without a preceding space is literal value content.

- **Fixture sketch:** `  :url https://example.com/path?q=1;s=2` → value keeps `;s=2`. `  :note this too ; but comment` → value "this too", Comment("but THIS is a comment").
- edge: value ending exactly at ` ;` with empty comment
- edge: `;` as first char of block value

### `block-attr-one-per-line` — Block Attribute Values (~l545-550)

A block attribute line holds exactly one attribute: a later ` :name ` sequence is part of the value, and additionally triggers a Warning for the likely mistake.

- **Fixture sketch:** `|el\n  :bttr 2 :cttr 3` → Attr(bttr, "2 :cttr 3") plus a Warning event; no `cttr` attribute.
- edge: ` :x` at very end of line
- edge: colon without surrounding spaces (`a:b`) — no warning

### `sameline-attr-terminators` — Sameline Attribute Values (~l552-564)

Sameline unquoted values terminate on space or newline; quoted values may contain spaces; a ` ;` after values starts a comment that is a child of the element.

- **Fixture sketch:** `|el :key1 value1 :key2 value2 ; comment` → Attr×2, Comment nested under el. `|el :key "hello world"` → Attr(key,"hello world").
- edge: `;` glued to value (`:k v;x`) — literal per Literal Semicolons table
- edge: URL value `:url https://x.com` (colon inside value, no preceding space)

### `embedded-attr-terminators` — Embedded Attribute Values (~l566-575)

Inside `|{...}`, unquoted attribute values additionally terminate on `}`, and the `}` is not consumed (it still closes the embedded element).

- **Fixture sketch:** `|p Click |{a :href /home :title Home here} now.` → embedded `a` with href=/home, title="Home", content "here", then prose resumes with " now.". Minimal: `|p x |{a :k v} y` → Attr(k,"v"), embedded closes, prose continues.
- edge: valueless attr directly before `}`: `|{a :flag}`
- edge: value glued to brace: `:k v}` vs `:k v }`

### `array-item-terminators` — Array Item Values (~l577-591)

Array items terminate on space, newline, or `]` (not consumed); terminators are the same in block and embedded contexts; `}` is literal inside `[...]`; an array with no closing `]` ends as an UnclosedArray error.

- **Fixture sketch:** `:tags [one two three]` → 3 items. `|{el :a [x}y] z}` → item `x}y`, then `}` after `]` closes embedded. `:a [x y` EOF/EOL → UnclosedArray error event.
- edge: newline inside array — does `\n` terminate the item only, or the array? (terminator list includes `\n` for items; multiline arrays unaddressed — see ambiguity)
- edge: `]` glued to last item
- **⚠ ambiguity:** `\n` is listed as an item terminator, but the spec does not say whether an array may continue on the next line or whether newline-before-`]` immediately yields UnclosedArray.

### `array-quoted-adjacency` — Array Item Values, quoted-item nuance (~l593-596)

A quoted item's closing `"` ends the item; an immediately following character starts a new item: `["x"y]` and `["x""y"]` each yield ["x","y"].

- **Fixture sketch:** `:a ["x"y]` → list("x","y"); `:a ["x""y"]` → list("x","y"); both equal `:a ["x" y]`.
- edge: `["x"]y]`? — first `]` closes; `y]` is outside

### `prose-unprefixed-line` — Prose Content (~l611-633)

Any line not starting with a prefix character is prose belonging to the enclosing parent; nested elements interrupt prose and prose may resume afterward at the parent.

- **Fixture sketch:** `|article\n  Prose one\n  |blockquote\n    inner\n  Back to prose` → Text under article, Element blockquote with its text, Text "Back to prose" under article again.
- edge: prose lines beginning with `-`, digits, `#`, `*` (Markdown) are still plain prose
- edge: prose spanning multiple lines

### `prose-block-vs-sameline` — Prose Content (~l635-638)

Block prose sets an indent-column for continuation and preserves literal semicolons; sameline prose sets no indent-column and treats ` ;` as a comment start.

- **Fixture sketch:** `|el\n  use x; do y` → Text "use x; do y" (semicolon literal). `|p text ; comment` → Text "text", Comment("comment").
- edge: block prose line with ` ; ` mid-line stays literal
- edge: sameline prose with glued `;` (`text;more`) — literal per Literal Semicolons

### `prose-hash-not-special` — Prose Content (~l639-640)

`#` has no special meaning in prose; it is literal text.

- **Fixture sketch:** `|el\n  # heading-looking line` → Text "# heading-looking line", no comment event.
- edge: `#` at column 0 at document root

### `prose-opaque` — Prose Content (~l642-645)

The parser treats prose as opaque text — Markdown inside prose is not interpreted into events.

- **Fixture sketch:** `|el\n  **bold** and `code`` → single Text event(s) with markers verbatim; no strong/code structure.
- edge: Markdown link syntax `[x](y)` — brackets must not be parsed as arrays in prose

### `prose-embedded-elements` — Prose Content (~l660-668)

Embedded elements `|{name ...}` may appear within prose; surrounding prose and the embedded element interleave in order.

- **Fixture sketch:** `|p a |{em b} c` → Text "a ", Element em with text "b", Text " c" (exact whitespace handling at the boundary is a fixture assertion point).
- edge: embedded element at start of prose line
- edge: two embedded elements adjacent
- edge: embedded with attributes: `|{a :href /r a reference link}`

### `comment-context-table` — Comments (~l673-684)

`;` starts a line comment at document root, in sameline prose, and after values on block-attr and sameline-attr lines; it is literal in block prose; inside inline/embedded content only `;{...}` opens a comment.

- **Fixture sketch:** One fixture per row: root `; hdr` → Comment; `|el\n  use x; y` → literal; `|p t ; c` → Comment; `:k v ; c` → Comment; `|{em text ;{note}}` → inline Comment; `|{em a ; b}` → `; b` literal text.
- edge: `;` at column 0 vs indented under an element (block comment)
- edge: bare `;` inside embedded with no `{`

### `comments-are-events` — Comments (~l686-688)

Comments are emitted as events, never silently discarded by the parser.

- **Fixture sketch:** Every comment fixture asserts a Comment event with content; stripping is asserted to be absent at parser level.
- edge: empty comment `;` alone on a line

### `comment-continuation-indent` — Comments (~l690-698)

A line comment is continued by a following more-indented line that does not start with a prefix; such lines are comment content until dedent.

- **Fixture sketch:** `; comment\n  still comment\n\\; escaped line` → Comment spanning two lines (or two Comment events — shape TBD), then Text "; But this line..." via head `\`.
- edge: more-indented line that DOES start with a prefix (e.g. `  |el`) after a comment — not continuation
- edge: blank line between comment and indented line
- **⚠ ambiguity:** Whether continuation applies to all line comments (sameline-attr trailing comments too?) or only block comments is unstated; also whether continuation yields one multi-line Comment event or several.

### `comment-inline-brace-counting` — Comments / Inline (~l719-727, 759-768)

`;{...}` is the only in-prose comment form; it ends at the balancing `}`, with nested balanced `{}` pairs allowed; stripping it leaves surrounding prose intact including original spacing collapse to the documented result.

- **Fixture sketch:** `|p This is some text ;{TODO: improve this} and more text.` → Text + Comment("TODO: improve this") + Text; consumer-stripped text equals "This is some text and more text.". Nested: `;{a {b} c}` → Comment("a {b} c").
- edge: unbalanced brace inside `;{...}` — behavior unspecified (error? runs to EOL?)
- edge: `;{` in sameline prose vs block prose
- **⚠ ambiguity:** Stripped output "This is some text and more text." implies one of the two spaces around the comment is absorbed; which side (space before `;{` kept, space after `}` kept?) is not specified. Unbalanced-brace failure mode is also unspecified beyond 'use line-comment form instead'.

### `comment-indent-participation` — Comments and Indentation (~l729-757)

Block comments participate in indent/dedent: a comment at a shallower column closes open elements (emitting ElementEnd events) before subsequent content; same column as an element = sibling; deeper = inside.

- **Fixture sketch:** The spec's own example: `|parent\n  |child\n   ;in-child\n  ;sibling-of-child\n    |grandchild\n;col0-comment\n|sibling` → col-0 comment preceded by three ElementEnd events (grandchild, child, parent).
- edge: comment column between two element columns
- edge: comment as first thing in file at col 0
- **⚠ ambiguity:** Sibling case: '; this comment is SIBLING of |child (same column = sibling!)' — but then `|grandchild` is indented deeper than that comment; whether the comment can PARENT the grandchild (comment-continuation rule says a more-indented prefixed line is not continuation, but the hierarchy of `|grandchild` relative to the sibling comment vs |child is unstated — the example implies grandchild nests under child despite the intervening sibling-level comment, which needs pinning).

### `comment-past-prose-base` — Comments and Indentation (~l752-757)

Within block prose, a `;` line indented one column past the prose's indent-column is a comment inside the element, and prose at the base column resumes afterward.

- **Fixture sketch:** `|element\n  Some prose\n   ; comment\n  More prose` → Text, Comment, Text all within element.
- edge: `;` line at exactly the prose base column — comment or literal prose? (block prose says `;` is literal in block prose, but a line STARTING with `;` at base column…)
- **⚠ ambiguity:** Direct tension: 'Block prose: `;` is Literal (not comment)' vs the block-comment rule that a line starting with `;` is a comment participating in hierarchy. For a `;`-initial line at the prose indent-column, CORE says both things; the example only shows the one-column-deeper case.

### `escape-head-backslash-prose` — Comments / Escaping Semicolons (~l695-697, 770-779) + Literal Semicolons (~l783-798)

A `\` at head position forces the line to prose: `\;` at line start outputs a literal `;`-initial prose line; a `\` not at head position is passed through literally (no `\;` escape exists).

- **Fixture sketch:** `\; starts with semicolon` → Text "; starts with semicolon". `|el a\;b` → Text contains `\;` verbatim? — assert `\` mid-line passes through literally.
- edge: `\` head-position before other prefixes (`\|`, `\:`)
- edge: `\` at head of an indented line under an element

### `literal-semicolon-positions` — Literal Semicolons (~l783-808)

A `;` is literal in block prose, in block attr values (unquoted), in sameline contexts when not preceded by a space, and bare inside `|{...}`; quoting (`:k "a; b"`) yields a literal `;` in any attr value.

- **Fixture sketch:** `|el :key and-this;-is-ok this is prose ; and this is a comment` → attr value keeps `;`, trailing Comment emitted; embedded `|{em a;b}` → text "a;b".
- edge: `:sql 'SELECT; DROP'` — single-quoted value with ` ;` inside stays literal (also tests single-quote strings in block attrs)
- edge: block-prose continuation line `this is also prose ; but this is not a comment` — whole line literal

### `semi-block-prose-literal` — Literal Semicolons (~l.788)

In block prose (indented content lines), a `;` mid-line is literal content, not a comment start.

- **Fixture sketch:** |pre with indented line `code; more code` — Text event contains the semicolon verbatim.
- edge: `;` at end of block prose line
- edge: multiple `;` on one line

### `semi-block-attr-literal` — Literal Semicolons (~l.791)

In a block-form attribute value, `;` is literal; quoting (`:sql 'SELECT; DROP'`) also yields a literal `;`.

- **Fixture sketch:** Attribute with quoted value containing `;` — attr value event includes the semicolon.
- edge: unquoted block attr value with `;` not preceded by space

### `semi-sameline-space-comment` — Literal Semicolons (~l.792)

On a sameline (attr or prose tail), a `;` preceded by a space starts a comment; a `;` NOT preceded by a space is literal.

- **Fixture sketch:** `|el :key and-this;-is-ok this is prose ; and this is a comment` — attr value keeps `;`, prose ends before ` ;`, Comment event carries the trailing text.
- edge: `;` immediately after element name
- edge: ` ;` at very end of line (empty comment)
- edge: tab before `;` — spec says 'space'; is tab a comment trigger?
- **⚠ ambiguity:** Spec says 'a ` ;` starts a comment' on samelines — silent on whether a tab (or other whitespace) before `;` also triggers a comment.

### `semi-block-prose-space-still-literal` — Literal Semicolons example (~l.800-802)

In block prose, even a space-preceded `;` is literal (`this is also prose ; but this is not a comment`).

- **Fixture sketch:** Element with indented prose line containing ` ; ...` — full line emitted as text including the semicolon and tail.
- edge: contrast fixture with same text on the element's sameline where it IS a comment
- **⚠ ambiguity:** Tension with Comments section (~l.752-757), whose example shows a line-starting `;` inside an element's prose block acting as a block comment. Reconciliation appears to be: `;` at line start in a block = comment, `;` mid-line in block prose = literal — but CORE never states the mid-line-block rule explicitly outside the table and example.

### `semi-embedded-literal` — Literal Semicolons (~l.793)

Inside embedded `|{...}`, a bare `;` is literal; only the two-char sequence `;{` opens an inline comment.

- **Fixture sketch:** `|p |{code a; b}` — embedded element text is `a; b`; `|p x ;{note} y` — Comment event for `note`, text `x  y`/`x y`.
- edge: `;{` with nested balanced braces inside
- edge: `; {` (space between) stays literal

### `semi-no-backslash-escape` — Literal Semicolons (~l.796-798)

There is no `\;` escape: a `\` not at head position passes through literally; a head-position `\` forces the whole line/tail to prose (making a leading `;` literal).

- **Fixture sketch:** Line `\; starts with semicolon` → text `; starts with semicolon`; mid-line `a\;b` → text `a\;b` (backslash literal).
- edge: head-position `\` on a sameline tail vs at line start
- edge: `\` before ` ;` mid-sameline does NOT prevent comment

### `hier-pop-rule` — Hierarchy — Parser Rule (~l.816-820)

On a new element, pop the stack while new_column <= stack_top.base_column; the element becomes a child of the surviving top. Each pop emits an ElementEnd.

- **Fixture sketch:** |one/|two/|three inline then `|alpha` at col 2 → ElementEnd(three), ElementEnd(two), alpha child of one.
- edge: new column equal to top (sibling)
- edge: column 0 closing everything
- edge: column between two stack entries

### `hier-same-col-sibling` — The Column Rules (~l.849-856)

Same column = sibling (pop then push under same parent); greater column = child; to be INSIDE an element you must be at column strictly greater than the element's column.

- **Fixture sketch:** |parent / two children at col 2, then col-3 element → child of the second col-2 element, not of the first.
- edge: child at exactly parent_col+1 (minimum valid child indent)

### `hier-inline-columns-real` — Inline Nesting / Python Perspective (~l.883-964)

Inline elements on one line nest left-to-right, each pushed at its actual `|` column, exactly equivalent to the vertical form; subsequent lines resolve against those columns.

- **Fixture sketch:** `|one |two |three` → nested Start events; then `|e` at column of |two → sibling of |two; at |two_col+1..|three_col → child of |two.
- edge: element at column between two inline elements' columns
- edge: many inline elements (7-deep, l.1013 example)

### `hier-inline-sibling-alignment` — Column-Aligned Siblings (~l.896-911)

A later line's element at the same column as a prior inline element is its sibling (child of that element's parent).

- **Fixture sketch:** Table example l.901-907: |td A2 aligned under |td A1 → both children of |tr; second |tr aligned under first |tr → children of |table; |caption at col 2 → child of |table.
- edge: deep table with mixed alignment levels

### `hier-stack-is-only-state` — The Critical Insight (~l.986-1008)

Only current stack state matters: once elements are popped, later lines coinciding with their old columns do not resurrect them.

- **Fixture sketch:** l.991-994: `|one |two |three` then `|alpha` at col 2, then `|beta` at col 5 (old |two column) → beta is child of alpha, not related to two.
- edge: column exactly equal to a closed element's old column

### `hier-close-multiple` — Closing Multiple Levels (~l.1037-1053)

A dedent (element, prose, or comment line at a lesser/equal column) fires one ElementEnd per popped level, in innermost-first order, before the new node's event.

- **Fixture sketch:** Four nested elements then col-0 prose line → 4 ElementEnd events then Text (sibling of |one at root).
- edge: dedent by prose vs by element vs by comment
- edge: EOF closing all open elements
- **⚠ ambiguity:** Section text says 'Three or four ElementEnd events fire' for a case where the pop rule gives exactly four (col-0 prose, 0 <= one@0 pops |one too). The hedged 'three or four' is a spec-text imprecision; the algorithm implies four.

### `hier-comment-participates` — Comments and Indentation (~l.734-757, context for Hierarchy)

Block comment lines participate in indent/dedent: a comment at a lesser column triggers ElementEnd pops before the Comment event; same column as an element = sibling position.

- **Fixture sketch:** l.739-746 example: comment at col 0 after |grandchild → three ElementEnd events, then Comment, then |sibling at root.
- edge: comment one column past prose base (inside)
- edge: comment at element's own column
- **⚠ ambiguity:** Whether a block comment's column interacts with content_base of an open prose block (warn? reset content_base?) is unstated — comments 'participate in hierarchy' but Automatic Prose Dedentation never mentions comment lines.

### `hier-nonauthoritative-style` — Style Recommendation (~l.822-847)

Inconsistent sibling indent choices are 'poor form (warn or error)' but both positions remain technically valid siblings — structure must still parse.

- **Fixture sketch:** `|one |two |three` then |alpha at col 5 and |beta at col 2 → both siblings of |two (children of |one); optionally a diagnostic.
- **⚠ ambiguity:** '(warn or error)' leaves the diagnostic behavior implementation-defined — no normative requirement on whether/which diagnostic fires; the structural outcome (both siblings) IS testable.

### `dedent-inline-no-base` — Automatic Prose Dedentation — The Rule (~l.1097-1098)

Inline (sameline) content does not establish content_base_column and is emitted with no leading strip.

- **Fixture sketch:** `|section **The great indent**` + 2-space-indented lines → output first line unindented, later lines stripped of 2 (l.1149-1162 example).
- edge: element with only inline content, no indented lines

### `dedent-line2-establishes` — The Rule (~l.1099)

The first indented content line establishes content_base_column at whatever column the user chose; any choice within the valid range produces no warning.

- **Fixture sketch:** Three variants (l.1113-1129): line 2 at col 2, col 16, col 7 — all warning-free, each stripped fully to column 0 in output.
- edge: line 2 aligned exactly with an inline child's `|` column (inclusive bound)
- edge: line 2 at parent_col+1 (minimum)

### `dedent-deeper-preserved` — The Rule (~l.1100)

Subsequent lines at column >= content_base emit no warning; columns beyond content_base are preserved as literal leading spaces in output.

- **Fixture sketch:** content_base 3, line at col 7 → output `    four extra spaces` (4 preserved spaces), per l.1207/1217.
- edge: line exactly at content_base (zero extra spaces)

### `dedent-lesser-warns-updates` — The Rule (~l.1101-1105)

A subsequent prose line at column < content_base (but still > parent's column) emits a warning, updates content_base to the lesser column, and continues as content of the same element.

- **Fixture sketch:** l.1201-1219 full example: base 6 → warn at 3, no warn at repeated 3, preserve at 7, warn again at 2; verify exact output text block.
- edge: two successive drops (6→3→2) each warn once
- edge: line returning to the ORIGINAL base column after a drop → no warning, extra spaces preserved

### `dedent-streaming-no-restrip` — Streaming Behavior (~l.1225-1231)

Dedentation is per-line and immediate: earlier lines already emitted with the old (larger) strip are NOT re-emitted or corrected when content_base later drops.

- **Fixture sketch:** Streaming-event fixture: base 6 line emitted stripped-of-6; after drop to 3, no correction event; later lines stripped of 3.

### `dedent-valid-range` — The Rule / Valid Indentation Range (~l.1107-1108, 1185-1197)

Valid indented-content columns lie between the parent's `|`+1 (inclusive of parent_col+1; spec phrases it as parent's `|` exclusive) and any inline child's `|` column (inclusive); at the inline child's exact column the line is that child's sibling, one further right is the child's child.

- **Fixture sketch:** `|the-parent |on-line-child` then `|sibling` at col 12 (child's col) → sibling of on-line-child; at col 5 → same semantic (child of the-parent); prose at those columns analogous.
- edge: prose (not element) exactly at inline child's column — sibling text of the inline child, i.e. child of parent?
- **⚠ ambiguity:** The 'valid range' bounds and the with-nested-inline example (l.1133-1144) coexist uneasily: l.1141-1143 shows prose at a column LEFT of the inline child's column but right of content_base being a 'direct child of element-bigger' with 'no warning, but extra leading spaces' — while l.1137 shows a lesser-than-line-2 element getting a WARNING. Whether prose landing at/inside an inline child's column range attaches to the inline child or the outer parent is not crisply specified; also 'any inline child's `|` (inclusive)' as an UPPER bound for parent-content conflicts with 'one more column right = child of on-line-child' (which would make columns beyond the child's column belong to the child, not invalid).

### `dedent-warning-vs-dedent-boundary` — Inline Content Freedom (~l.1113-1119)

A prose line at exactly the element's own column is a dedent (becomes sibling content of the element's parent), not a warned continuation; a line at element_col+1 up to below content_base is a warned continuation.

- **Fixture sketch:** l.1114-1118: |element at col 0, base col 2; line at col 1 → warning + content; line at col 0 → closes element, prose is sibling.
- edge: element at col 0 means a col-0 prose line always dedents — no in-range warning column exists below base 1

### `dedent-freeform-exempt` — Exception: Freeform Blocks (~l.1236-1246)

Triple-backtick freeform blocks preserve interior whitespace exactly — no automatic dedentation applies to their content.

- **Fixture sketch:** |code with fenced block containing `def foo():` / 8-space-indented `return 1` — text events carry exact original spacing.
- edge: fence itself indented — is the fence's indent column stripped from interior lines, or is content byte-exact from column 0?
- **⚠ ambiguity:** 'Preserved exactly as written' is ambiguous when the fence is indented (as in the l.1239-1244 example where the fence sits at col 2): is the fence's own indent stripped from interior lines (relative preservation) or included (absolute)? The section does not say; the Fences section elsewhere in CORE may — cross-check needed.

### `dedent-inline-comment-strip` — Inline Comments (context, ~l.759-768)

Stripping an inline `;{...}` comment from prose yields the surrounding text joined (spec example shows `text ;{c} and` → `text and`).

- **Fixture sketch:** `|p This is some text ;{TODO} and more text.` — Comment event + text events whose concatenation-with-comment-removed matches `This is some text and more text.`
- edge: `;{...}` at start or end of prose tail
- edge: adjacent spaces around the comment — example implies the space before `;{` and after `}` collapse to one
- **⚠ ambiguity:** Whether one or both flanking spaces are consumed by the inline comment (example output has a single space) is not stated as a rule — only inferable from the l.767-768 example.

### `embedded-basic` — Inline and Embedded Elements (~L1295)

`|{name ...}` inside prose parses as an embedded element containing element name, optional key/traits, optional attributes, and content; it becomes a child of the containing element, a sibling to surrounding text.

- **Fixture sketch:** `|p This has |{em emphasized text} and |{a :href /foo a link} inline.` -> ElementOpen p; Text 'This has '; ElementOpen em; Text 'emphasized text'; ElementClose; Text ' and '; ElementOpen a; Attr href=/foo; Text 'a link'; ElementClose; Text ' inline.'
- edge: embedded element with key/traits: |{a[home].nav ...}
- edge: embedded element with no content: |{br}
- edge: embedded at very start / very end of the prose line

### `embedded-brace-balanced` — Inline and Embedded Elements (~L1304)

Embedded-element content terminates at the closing `}` found by brace-balancing, so balanced nested `{}` pairs inside content are part of the content.

- **Fixture sketch:** `|p |{code fn f() { g() } done} tail` -> the em/code content includes 'fn f() { g() } done'; Text ' tail' after close.
- edge: unbalanced `{` inside content (unclosed |{ at EOL/EOF — behavior unspecified?)
- **⚠ ambiguity:** Spec states brace-balanced termination but never says what happens when an embedded element's `}` is never found (EOF). Error? Implicit close?

### `embedded-siblings` — Inline and Embedded Elements (~L1310)

Multiple embedded elements on one line are siblings under the containing element, in order.

- **Fixture sketch:** `|nav |{a :href / Home} |{a :href /about About}` -> nav with two `a` children in written order (plus the interstitial space text — verify whether whitespace-only text between them is emitted).

### `embedded-nested` — Inline and Embedded Elements (~L1316)

Embedded elements nest: `|{a ... |{em official} ...}` yields the inner element as a child of the outer, with surrounding text as siblings inside the outer.

- **Fixture sketch:** `|p See |{a :href /doc the |{em official} documentation} for details.` -> a contains Text 'the ', em('official'), Text ' documentation'.

### `bracket-mode-stays` — Bracket Mode Rules (~L1322)

Inside `|{...}`, line-form `|element` syntax is invalid; all nested elements must use embedded `|{...}` form.

- **Fixture sketch:** `|ul |{li |a Home}` — the `|a` inside braces must NOT open an element.
- edge: bare `|` followed by space inside braces (example `|{a Home} | }` shows a stray `| ` — what is it?)
- **⚠ ambiguity:** Spec labels `|a` inside `|{...}` INVALID but does not say the resulting behavior: parse error, or literal prose '|a Home'? Also the example `|ul |{li |{a Home} | }|{li ...}` at L1330 contains an unexplained `| }` sequence that looks like a typo — needs clarification.

### `embedded-multiline` — Inline and Embedded Elements (~L1336)

An embedded element may span multiple lines; indentation inside it is ignored, and only the balanced closing `}` ends it, after which prose continues on that line.

- **Fixture sketch:** `|p This has |{a :href /docs\n   a link that spans\n   multiple lines} and continues.` -> single `a` child whose text spans the lines; then Text ' and continues.'
- edge: how line breaks/leading indent inside the multi-line body appear in emitted Text (joined with space? newline preserved?) — spec says indentation 'ignored' but not the join rule
- **⚠ ambiguity:** 'indentation inside is ignored' — unspecified whether the emitted content preserves newlines, collapses to spaces, or strips leading whitespace per line.

### `inline-dispatch-no-lookahead` — Unified Inline Syntax (~L1349)

Every prefix has a bracket inline form and the character immediately after the prefix determines the parse mode with no lookahead: `|{` embedded element, `!{{` interpolation, `!{name` inline directive, `!{:kind:` inline raw, `;{` inline comment.

- **Fixture sketch:** One prose line containing all four/five forms; assert each dispatches to its distinct event type (Element / Interpolation / Directive / Raw / Comment).
- edge: `!{` followed by `{` vs `:` vs letter — three-way dispatch on the char after `!{`
- edge: bare `;` mid-prose stays literal (only `;{` opens inline comment, per L793)

### `escape-inline-openers` — Unified Inline Syntax note (~L1361) + Escape (~L171)

A mid-prose `\` immediately before an inline opener (`|{`, `!{`, `;{`) is consumed and makes the opener literal text; `\` at head position forces the entire line to prose.

- **Fixture sketch:** `|p wink \;{x}` -> Text 'wink ;{x}' (no comment event); `|p a \|{b} c` -> Text 'a |{b} c'; head-position `\|not an element` -> prose line '|not an element'.
- edge: `\` before a non-opener character (e.g. `\x`) — is the backslash literal?
- edge: `\!{{...}}` escaping interpolation (all `!{` forms covered by one opener per L206)

### `quote-not-escape` — Unified Inline Syntax note (~L1363)

`'` is not an escape character; it functions only as a string/name/key delimiter.

- **Fixture sketch:** Prose containing `don't` and `'|{x}'` — apostrophe is literal in prose; `'|{x}'` inside prose does NOT suppress the embedded element (the |{ still opens).
- **⚠ ambiguity:** Whether a quoted span in prose position has any effect at all is only stated negatively; fixture should pin that `|{` inside prose quotes still parses as embedded.

### `raw-block-verbatim` — Raw Directives (Block) (~L1371)

`!:label:` opens a block raw directive: the indented body is captured verbatim with no UDON marker interpretation (`|`, `:`, `!`, `;` are literal), and the label is carried on the event for the host.

- **Fixture sketch:** `!:elixir:` with body containing `|> pipe`, `:key`, `; not-a-comment` -> single Raw event, label='elixir', content preserves those lines exactly.
- edge: label characters: is `!:c++:` or `!:foo-bar:` a valid label? (label lexical rules unstated)
- edge: empty body
- edge: `!::` empty label
- **⚠ ambiguity:** Lexical constraints on the raw label are unspecified (allowed chars, empty label).

### `raw-block-dedent` — Raw Directives (Block) (~L1386)

Raw block content follows normal indentation rules: it must be indented under the directive, ends when indentation returns to/above the directive's level, and is dedented on output relative to the directive's indent level.

- **Fixture sketch:** Directive at col 2, body lines at col 4 and col 6 -> emitted content has 2 leading spaces stripped from every line (col-4 lines flush, col-6 lines keep 2 spaces); a following col-2 line ends the raw block.
- edge: blank lines inside the body (preserved? indentation-exempt?)
- edge: body line indented LESS than first body line but more than directive
- edge: dedent base: directive's indent level vs first-content-line column — which one? (§Implementation at L1270 suggests first-line-establishes-base for prose; raw section says 'relative to the directive's indent level')
- **⚠ ambiguity:** Dedent anchor conflict: L1389 says dedent 'relative to the directive's indent level', but the general prose/content model (L1270-1288) dedents to the first content line's column. For a body indented 4 under a directive at 2, do emitted lines keep 2 spaces or 0?

### `raw-inline` — Inline Raw Content (~L1393)

`!{:kind: ...}` is inline raw content, terminated by brace-counting; balanced nested `{}` pairs are allowed inside; content is verbatim and the kind label is passed through.

- **Fixture sketch:** `|p The response was !{:json: {"status": "ok", "count": 42}} as expected.` -> Raw(kind=json, content='{"status": "ok", "count": 42}') between two Text events; also `!{:regex: [a-z]{3,5}}`.
- edge: leading space after the second colon — is it part of content or separator? (examples imply one separating space consumed)
- edge: empty content `!{:x:}`
- **⚠ ambiguity:** Whether exactly one space after `!{:kind:` is a separator (stripped) or content is not stated.

### `raw-inline-unbalanced-fails` — Inline Raw Content (~L1409)

An inline raw with an unbalanced `{` in its content fails — `!{:text: missing close {}` does not parse as a completed inline raw; the block form is the prescribed alternative.

- **Fixture sketch:** `|p x !{:text: missing close {}` -> must not yield a well-formed Raw event ending at that `}`... assert error/diagnostic.
- **⚠ ambiguity:** Spec says only 'Fails' — the concrete failure behavior (hard parse error? raw runs to EOF? falls back to literal prose?) is unspecified.

### `raw-not-attribute-value` — Inline Raw Content (~L1417)

Raw content cannot be an attribute value directly (attribute values are typed scalars).

- **Fixture sketch:** `|x :k !{:json: {"a":1}}` -> must NOT produce an attribute whose value is a Raw node.
- **⚠ ambiguity:** What it DOES produce is unspecified: the literal string '!{:json: ...}' as the attr value, or an error?

### `fence-open-head-position` — Triple-Backtick Escape (~L1424)

Triple-backticks open a freeform block at any head position: at the start of a line at a structural column, or in sameline scan after elements and attributes before prose has begun.

- **Fixture sketch:** (a) fence on its own line under `|a`; (b) `|a |b :k v \`\`\`` sameline after attributes — both open a fence whose body starts after the backticks.
- edge: fence directly after element name with no attrs: |a ```
- edge: fence at column 0 top level

### `fence-not-after-prose` — Triple-Backtick Escape (~L1452)

Triple-backticks appearing after prose has begun on the line are literal prose, not a fence.

- **Fixture sketch:** `|a |b but now \`\`\`` -> 'but now ```' is prose text of b; no freeform block.

### `fence-deeper-than-prose-literal` — Triple-Backtick Escape (~L1455)

Backtick lines indented deeper than the current prose's content column sit inside that prose (literal), not at head position — no fence opens.

- **Fixture sketch:** Element with prose base at col 2; a line at col 5 starting with ``` -> literal prose text, not a fence.

### `fence-parent-by-indent` — Triple-Backtick Escape (~L1429)

The opening backticks' indentation determines the freeform block's structural parent — it is a child of whatever owns that column (fences are not column-1-only).

- **Fixture sketch:** `|a` / two-space-indented fence -> freeform block is a child of a; sibling positions of surrounding prose/child elements preserved (interleaving example at L1440).

### `fence-info-string` — Triple-Backtick Escape (~L1433)

Everything after the opening backticks on the opening line begins the captured body — an info string like `rust ignore` is simply the body's first content; there is no separate info-string rule.

- **Fixture sketch:** ```` ```text and the fence begins ```` -> body begins with 'text and the fence begins'.
- **⚠ ambiguity:** Whether the space between backticks and the info string is included in the body is not stated.

### `fence-body-exact` — Triple-Backtick Escape (~L1421)

Freeform body is captured exactly — no prose dedentation and no marker interpretation of any kind.

- **Fixture sketch:** Fence body containing `|el`, `:attr`, `!dir`, `;comment`, and mixed/less indentation than the fence -> content byte-identical to source (up to the closer rule).

### `fence-close-any-indent` — Triple-Backtick Escape (~L1458)

A line whose first non-space content is triple-backticks closes the block at ANY indentation, and must be followed by a newline; trailing whitespace after the closing backticks is ignored.

- **Fixture sketch:** Fence opened at col 2, closer at col 0 and (separate case) col 6 — both close; closer followed by trailing spaces then newline still closes.
- edge: closer with non-whitespace after the backticks (e.g. ```` ```rust ```` mid-block) — must NOT close (fails 'followed by a newline')
- edge: closer as the last line of the file with no trailing newline (EOF)
- **⚠ ambiguity:** 'must be followed by a newline' at EOF-without-newline is unaddressed — does the fence close or run unterminated?

### `fence-closer-indent-is-body` — Triple-Backtick Escape (~L1464)

The body runs to the newline BEFORE the closing line, so an indented closer's leading whitespace was already... is NOT... wait — the closer's leading whitespace IS part of the captured body; only whitespace to the right of the closing backticks is trimmed.

- **Fixture sketch:** Fence with closer indented 4 spaces -> captured body ends with a final line consisting of those 4 spaces? Verify: body = everything up to the newline before the closer line PLUS the closer line's leading indent per the Caution note. Compare col-0 closer (no trailing indent in body) vs indented closer (indent appears in body).
- edge: closer at column 0 -> no extra whitespace in body
- **⚠ ambiguity:** The Caution note is internally tense: 'the body runs to the newline *before* the closer' yet 'that indentation was already body' — the two sentences reconcile only if the closer's leading indent is appended after that newline; a fixture must pin the exact byte-level rule.

### `fence-interleaves-with-prose` — Triple-Backtick Escape (~L1436)

Because head position is re-entered every line, a fence may open after prose lines and child elements have already appeared under the same parent.

- **Fixture sketch:** The L1440 example verbatim: |a with prose, |b child, more prose, then a fence at the same column -> events: text, element b, text, freeform block, all children of a.

### `dyn-directive-block` — Dynamics (~L1487)

`!name ...` at head position emits a Directive event with any name (not a fixed keyword set); its body is parsed as normal UDON.

- **Fixture sketch:** `!if cond` with indented UDON body containing `|child :k v` -> Directive(name=if) whose body events are parsed UDON (element, attr); also an arbitrary name `!frobnicate`.
- edge: directive with no body
- edge: directive args on the same line — how are they captured (unparsed arg string?)
- **⚠ ambiguity:** How the same-line remainder after `!name` is represented (raw arg text vs parsed) is not specified in this section.

### `dyn-inline-directive` — Dynamics (~L1493)

`!{directive ...}` emits an inline directive whose body is UDON-parsed.

- **Fixture sketch:** `|p x !{if flag |{em y}} z` -> inline Directive(if) containing an embedded em element, between Text 'x ' and ' z'.

### `dyn-interpolation` — Dynamics (~L1491)

`!{{expr}}` emits an Interpolation event whose expression is captured UNPARSED for host evaluation.

- **Fixture sketch:** `|p Hello !{{user.name | upcase}}!` -> Text 'Hello ', Interpolation(expr='user.name | upcase'), Text '!'.
- edge: braces inside the expression `!{{ {'a': 1} }}` — termination rule (double-brace close? balance-counted?) is not explicitly stated
- edge: empty expr `!{{}}`
- **⚠ ambiguity:** Termination of `!{{...}}` (first `}}` vs brace-balanced) is not specified in these sections.

### `dyn-syntax-only-conformance` — Dynamics (~L1495)

A conformant parser recognizes `!` syntax and emits Directive/Raw/Interpolation events; it need not implement any dialect semantics (evaluation, truthiness, filters are DYNAMICS.md, not core).

- **Fixture sketch:** Fixtures assert only event shape for !if/!for/!let/!{{...}} — never evaluated output; a parser with zero evaluation passes.

### `ref-explicit-and-shorthand` — References (@) (~L1505)

`@element[key]` is an explicit reference to the element of that type with that key; `@[key]` is shorthand that ERRORS if the key is ambiguous across element types.

- **Fixture sketch:** Doc defining |license[mit], then `:license @[mit]` -> reference event/value; second doc defining |license[mit] and |user[mit] with `@[mit]` -> ambiguity error; `@license[mit]` in the same doc -> ok.
- edge: @[key] where key matches nothing — error, inert, or consumer concern?
- **⚠ ambiguity:** The ambiguity error requires document-wide knowledge, but the section also says references are inert at core and the streaming parser is stateless — so the `@[key]`-ambiguous error must be a Document-layer check, though the spec doesn't say so explicitly. Unresolved-key behavior is also unstated.

### `ref-not-augmentable` — References (@) (~L1518)

A reference is not augmentable: there is no `@[mit].trait` decoration.

- **Fixture sketch:** `:x @[mit].trait` -> must not parse as reference-plus-trait.
- **⚠ ambiguity:** What `@[mit].trait` DOES parse as (error? reference '@[mit]' followed by string '.trait'? whole thing a string?) is unspecified.

### `ref-inert-at-core` — References (@) (~L1522)

The core parser emits a reference and never resolves it; transclude/merge/inert are optional host resolution modes, with inert as the streaming default.

- **Fixture sketch:** Event-level fixture: `:license @[mit]` -> a Reference event/value only; no transcluded license content in the event stream.

### `attr-merge-syntax-removed` — References (@) (~L1531)

The former `:[id]` attribute-merge syntax is removed from core — it must not be recognized as a merge construct.

- **Fixture sketch:** `|x :[mit]` -> no merge semantics; assert whatever the current attribute grammar makes of it (legacy fixtures using :[id] must now fail/behave differently).
- **⚠ ambiguity:** What `:[id]` now parses as (attribute named '[mit]'? error? attr with list-ish name?) is not stated — only that the old semantics are gone.

### `duplicate-definition-policy` — Duplicate Definitions (~L1536)

Two elements with the same (element-type, key) are a duplicate definition — never a re-open or merge. This is a Document-layer check: default policy is ERROR; the builder exposes error | allow-if-identical | first-wins | last-wins | keep-all, plus optional warn; allow-if-identical uses tree-equality ignoring spans. The event/streaming layer never checks it; @-references never count.

- **Fixture sketch:** (1) streaming fixture: |user[1] twice -> two independent ElementOpen events, no error at event layer; (2) Document-layer fixture: same input -> error by default; (3) allow-if-identical with byte-different but tree-equal duplicates (differing spans/indent) -> accepted; (4) |user[1] plus @user[1] reference -> no duplicate.
- edge: same key, different element types (|user[1] and |group[1]) -> NOT duplicates
- edge: first-wins/last-wins/keep-all each observable in assembled Document
- edge: anonymous elements (no key) never collide

### `mixins-not-core` — Mixins (~L1556)

Mixin behavior (anonymous trait-only element whose attributes are inherited by elements carrying the same trait) is a host decision, not core: the core parser must emit only what is written — an anonymous element with a trait and attributes, and a separate element carrying that trait — with no inheritance; a parser doing no mixin resolution is fully conformant.

- **Fixture sketch:** `|.defaults` with :adapter/:host, then `|database[prod].defaults` with :database -> event fixture asserts database has ONLY :database (no adapter/host) and .defaults is an anonymous element with trait 'defaults'.
- edge: anonymous element syntax `|.trait` itself parses (cross-check Anonymous Elements section)

### `quoted-string-type` — Value Types > Type Table (~1590)

Double- or single-quoted attribute values are type String, regardless of content.

- **Fixture sketch:** :a "hello", :b 'world', :c "true", :d "42" → all string values ("true" not boolean, "42" not integer).
- edge: quoted numeric "42" stays string
- edge: quoted "true" stays string

### `integer-bare-recognition` — Value Types > Numbers (~1663)

Bare decimal, hex (0x/0X), octal (0o/0O), and binary (0b/0B) integer patterns parse as Integer; underscores between digits of any base are ignored; optional leading +/- signs.

- **Fixture sketch:** :a 42, :b 1_000_000, :c 0xFF_FF, :d 0o755, :e 0b1010, :f -42, :g +7 → integers with correct values.
- edge: 0X/0O/0B uppercase prefixes
- edge: underscores in hex
- edge: signed values

### `leading-zero-decimal` — Numbers (~1672)

A leading 0 followed by more decimal digits is decimal, not octal: 0755 == 755.

- **Fixture sketch:** :perm 0755 → integer 755 (not 493).
- edge: single 0 is integer 0

### `0d-prefix` — Numbers (~1667, 1686)

0d/0D is an explicit decimal-base prefix: 0d42 == 42.

- **Fixture sketch:** :a 0d42, :b 0D42 → integer 42. (Grammar note admits 0d is a pending grammar addition — fixture will be RED against pre-0.8 parser.)
- edge: 0D uppercase
- edge: 0d0

### `float-recognition` — Numbers (~1676)

Decimal tokens with a fractional part, an exponent (e/E, optional sign), or both are Float; a decimal token with neither is Integer.

- **Fixture sketch:** :a 3.14, :b 1e10, :c 1.5e-3, :d 1E+2 → floats; :e 42 → integer.
- edge: exponent only, no dot (1e10)
- edge: E uppercase
- edge: e+ / e- signs
- edge: underscore in float 1_000.5

### `rational-complex-provisional` — Numbers (~1691)

Bare rational (1/3r) and complex (5i, 3+4i) are provisional/parser-decided — explicitly not frozen; a fixture may document current recognition but must not be a core-0.8 compliance gate.

- **Fixture sketch:** Mark rational/complex cases as provisional group, not v0.8 compliance.
- edge: 1/3r
- edge: 3+4i
- edge: 5i
- **⚠ ambiguity:** Type Table lists Rational/Complex as types, but the Numbers section says their status is parser-decided and candidates to move to a <...> dialect — the spec deliberately does not freeze them; compliance fixtures cannot assert either way.

### `boolean-lowercase-only` — Booleans (~1707)

Bare true/false (lowercase only) are Boolean; TRUE, True, FALSE etc. are strings.

- **Fixture sketch:** :a true, :b false, :c TRUE, :d True, :e FALSE → bool, bool, string, string, string.
- edge: True/TRUE/FALSE as strings

### `flag-attr-true` — Booleans / Type Table (~1598, 1711)

An attribute with no value (:flag) is Boolean true.

- **Fixture sketch:** |e :flag → attr flag=true (boolean).
- edge: flag followed by another attr on same line
- edge: :flag as last token on line

### `nil-spellings` — Nil (~1717)

Bare null and nil are both the Nil value, equivalent.

- **Fixture sketch:** :a null, :b nil → both nil; :c NULL / Nil → strings (implied by lowercase-only pattern).
- edge: NULL/Nil case variants
- **⚠ ambiguity:** Spec says 'lowercase only' explicitly for booleans but is silent on case for null/nil — is NULL a string? Presumably yes by syntactic typing, but not stated.

### `unquoted-string-fallback` — Strings / Type Table (~1599, 1727)

Any bare value not matching a frozen core scalar pattern is a String (unquoted text, including multi-word).

- **Fixture sketch:** :desc unquoted text here → string "unquoted text here".
- edge: value that almost matches number (e.g. 42abc) → string
- edge: bare date 2026-07-11 → string (per Temporal note ~1649)

### `bare-date-is-string` — Explicit Typing > Temporal (~1649)

A bare 2026-07-11 is the string "2026-07-11"; all temporal values require the <...> envelope.

- **Fixture sketch:** :date 2026-07-11 → string; :when <2026-07-11> → envelope value.
- edge: time-like 12:30 bare
- edge: ISO datetime bare

### `list-syntax` — Lists (~1737)

[...] in attribute-value position is a List; elements space-separated, each element typed independently by the same rules; [] is the empty list.

- **Fixture sketch:** :ports [8080 8443], :mixed [1 two 3.0 true], :quoted ["hello world" foo], :empty [] → lists with per-element types (int, string, float, bool; quoted string with space is one element).
- edge: empty list
- edge: quoted element containing space
- edge: mixed types
- edge: nested typing rules apply per element

### `absent-nil-false-distinct` — Absent vs Nil vs False (~1747)

Absent key, nil value, false value, and flag-true are four distinct observable states in the parse output.

- **Fixture sketch:** |config with :debug (flag), :verbose false, :deprecated null, no :timeout → events/tree distinguish all four.

### `envelope-recognition` — Explicit Typing (~1616)

In bare attribute-value position, a value beginning with < opens a <...> envelope terminated by the matching >; the envelope content is passed through for dialect resolution (parser emits it, does not resolve).

- **Fixture sketch:** :when <2026-07-11>, :size <u64:0xf902>, :span <temporal:interval:x> → typed-envelope events with raw content; core emits without resolving.
- edge: envelope followed by more attrs on the line
- edge: envelope as list element? (unspecified)

### `envelope-literal-lt-quoted` — Explicit Typing > Recognition (~1618)

A literal string value beginning with < must be quoted; quoting suppresses envelope recognition. Outside bare attribute-value position (prose, inside quotes) < has no special meaning.

- **Fixture sketch:** :x "<not a type>" → string "<not a type>"; prose line containing <stuff> → plain text.
- edge: < mid-value (:x a<b) — envelope only when value *begins* with <

### `envelope-label-ladder` — Explicit Typing > Label ladder (~1634)

Envelope may be unlabelled <...>, type-labelled <type:...>, or dialect-and-type-labelled <dialect:type:...>; the parser must preserve/expose the label structure.

- **Fixture sketch:** <5m>, <u64:0xf902>, <temporal:interval:...> → three distinct label shapes surfaced.
- edge: content containing colons that isn't a label
- **⚠ ambiguity:** How the core parser distinguishes label colons from content colons (e.g. <2026-07-11T10:00> — is 2026-07-11T10 a 'type label'?) is not specified in this section.

### `envelope-unlabelled-dispatch-error` — Explicit Typing > Unlabelled dispatch (~1638)

An unlabelled <content> is offered to declared dialects in declared order, first claim wins; if all decline it is an ERROR (no sniffing).

- **Fixture sketch:** Document-layer fixture: unlabelled envelope with no active dialect claiming it → error. (Core-parser fixture only checks the envelope is emitted; dispatch is host layer.)
- edge: zero declared dialects → error

### `envelope-nesting-balanced` — Explicit Typing > Nesting (~1623)

Envelope termination is <>-depth-counted (balanced), forward-looking: nested < inside an envelope must not prematurely close it. Routing of nested typed values is deliberately unspecified.

- **Fixture sketch:** :v <r: <i: 3 -7> 0d83.23> → single envelope value spanning the balanced content.
- edge: nested <> one level deep
- **⚠ ambiguity:** Section is explicitly 'deliberately under-specified' on routing; only <>-balance is fixed. Fixture should assert only the span, not inner semantics.

### `frozen-bare-set-closed` — Explicit Typing (~1602)

The bare-recognized scalar set (string/int/float/bool/nil/list + provisional rational/complex) is closed; dialect types are never recognized bare — e.g. <5m> is a duration envelope but bare 5m is a string.

- **Fixture sketch:** :d 5m → string "5m"; :d <5m> → envelope.
- edge: duration-like, unit-like bare tokens all strings

### `attrs-before-children` — Design Principles > Attributes Before Children (~1767)

Attributes must precede child content; an attribute line appearing after child content is an error (no scattered attributes).

- **Fixture sketch:** |e / :a 1 / child text / :b 2 → error (or :b line not an attribute).
- edge: attr after blank line then prose
- edge: attr after child element
- **⚠ ambiguity:** Spec says 'must precede' but does not state the failure mode: hard error, or the late :b line reparsed as prose? Fixture needs a ratified expected behavior.

### `no-tabs` — Design Principles > Strict Whitespace (~1778)

Indentation is spaces only; tabs are an error.

- **Fixture sketch:** Line indented with \t → error.
- edge: tab after spaces
- edge: tab inside prose content (mid-line) — presumably allowed? spec says indentation

### `mixed-indent-error` — Strict Whitespace (~1780)

Mixed indentation is an error.

- **Fixture sketch:** File mixing tab+space indentation → error.
- edge: space-then-tab indent
- edge: inconsistent sibling indent (warning vs error)
- **⚠ ambiguity:** 'Error on mixed indentation' — mixed tabs/spaces on one line, or inconsistent space counts across siblings? Elsewhere (Prose Dedentation test list ~1838) inconsistent indentation yields *warnings*, suggesting 'mixed' here means tabs+spaces; not explicit.

### `streaming-parse-modes` — Design Principles > Streaming Parse (~1782)

Parser must support callback/event mode: parse as data arrives, emit complete subtrees as they close, pause/resume with state preservation.

- **Fixture sketch:** Feed a document byte-at-a-time / in arbitrary chunks; event stream identical to one-shot parse.
- edge: chunk boundary mid-token
- edge: pause/resume state round-trip

### `streaming-mid-guard-suspend` — Bounded Lookahead (~1863)

A chunk boundary landing mid-guard (e.g. after '|' before its next byte) must be held as suspended state; nothing is emitted until the guard resolves on the next chunk.

- **Fixture sketch:** Split input between '|' and element name across chunks → same events as unsplit; no premature emission.
- edge: split inside three-backtick fence guard
- edge: split inside <...> envelope open

### `config-example-parses` — Examples > Configuration (~1794)

The canonical config example (|database[primary].postgres with :host/:port/:pool) parses to element type=database, key=primary, trait=postgres, attrs string/int/int.

- **Fixture sketch:** Exact spec example as fixture; :port 5432 and :pool 10 integers, :host string.

### `tc-hierarchy-suite` — Test Cases (Non-Normative) (~1826)

Spec-suggested fixture list: inline nesting equivalence, sibling-after-inline, column-alignment=sibling, child-of-inline, multi-line progression, many-inline complex, closing multiple levels (normative source: Hierarchy section).

- **Fixture sketch:** One fixture per listed scenario, content mined from the Hierarchy section's examples.

### `tc-prose-dedent-suite` — Test Cases (Non-Normative) (~1835)

Spec-suggested fixtures: inline content indent freedom, nested inline elements with indented siblings, inconsistent-indentation WARNINGS, extra spaces preserved, blank lines passed through, freeform blocks preserve whitespace (normative source: Automatic Prose Dedentation section).

- **Fixture sketch:** Prose block with extra internal spaces and blank lines → preserved verbatim after dedent; inconsistent indent → warning event, not error.
- edge: warning (not error) for inconsistent prose indent

### `tc-comment-suite` — Test Cases (Non-Normative) (~1843)

Spec-suggested fixtures: block comments participate in indent/dedent (col-0 block comment closes nested elements; comment within element stays within it); ;{...} inline comments stripped from output; head-position \ forces prose and \; yields literal ';'; a \ past established prose base is literal and warns.

- **Fixture sketch:** (a) nested elements, then '; comment' at col 0 → dedent events close elements; (b) prose with ;{note} → note absent from text; (c) line '\; literal' at head → prose starting ';'; (d) '\' mid prose-block indent → literal backslash + warning event.
- edge: \ literal-with-warning vs head-position escape

### `bounded-lookahead-constraint` — Bounded Lookahead (~1855)

Every head-position guard resolves within a few characters (2-3 typical), single-level, no deep backtracking — a language-level constraint (design gate, not directly fixture-testable except via streaming split fixtures).

- **Fixture sketch:** Covered operationally by chunk-split fixtures at every guard: '|x', '|{', ';{', '```', '<', ':'.

### `impl-note-interp-unimplemented` — Implementation Notes (~1876)

Interpolation in attribute values and element keys is defined in DYNAMICS.md, not CORE — core fixtures should not assert interpolation semantics; core parser presumably passes !{...} through per DYNAMICS status.

- **Fixture sketch:** No core-0.8 fixture asserts interpolation resolution; a pass-through case may live in a DYNAMICS-scoped group.
- **⚠ ambiguity:** CORE doesn't state what the core parser does with !{...} in attr values today (literal string? error? dynamics event?) — deferred to DYNAMICS.md, which carries its own status banner.

### `raw-freeform-host-behavior` — Implementation Notes (~1878)

Raw directives and freeform blocks parse per spec; host behavior (highlighting, execution) is host-defined — fixtures assert parse events only, never execution.

- **Fixture sketch:** !:elixir: fenced block → raw/freeform event with verbatim content; no host-behavior assertion.

