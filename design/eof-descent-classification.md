# EOF: positional/delimited classification of the UDON grammar (design record)

> [!note] **Status (2026-07-18):** this is the design record behind the
> **generated-EOF work that landed** (descent auto-supplies both EOF halves; see
> `spec/TODO-EOF-refactor.md` for the design-of-record framing, `../CHANGELOG`
> and `tools/descent/CHANGELOG.md` for what shipped, and `core/TODO-CORE-PARSING.md`
> / `tools/descent/TODO-DESCENT.md` for the residuals). Every active
> `core/generator/*.descent.udon` function was read directly (not reconstructed).
> The classifier described here is implemented as `descent-rs classify`; the
> gaps below are annotated where the spike resolved or refined them.

*Classifies each function by the design-of-record rule: **delimited** iff it
closes only on a printed end-sequence; **positional** iff it has any geometric
close (newline / dedent / EOF with no anomaly). Semantics (needs-a-value,
cardinality) are a third thing, out by the litmus.*

## The generative thesis this grounds

CORE §End-of-input: **"EOF is newline + maximal dedent."** The grammar already
declares, per construct, what happens at a newline and at a dedent. So EOF
handling should not be *authored* — it is **derivable**:

- **Positional** → **inject a synthetic newline + maximal dedent at the cursor
  and run the machine** (Joseph's framing, empirically confirmed). *NOT* "clone
  the state's `\n` arm" — my first pass said that and it is **false** (see A-1
  below, verified): a whole family of states have neither a `\n` arm nor an
  `|eof` arm and route newline via a *fall-through* (`default → :string`), so
  there is no arm to clone; only running the machine through the fall-through
  emits the value. The `\n`-arm-equals-`|eof`-arm equality is a property of
  **leaf** states only; loop states take the dedent-return, fall-through states
  follow the default path, and semantic-close states run their own check. All
  three are subsumed by "inject `\n`+dedent, run," which is why that is the
  primitive and arm-cloning is only its leaf-state corollary.
- **Delimited** → the construct waits for a printed closer; a synthetic `\n` is
  geometry it is immune to (it would be swallowed as content). So at true EOF
  the generator **force-unwinds** it: keep content-so-far, emit
  `Unclosed<Construct>` **warning**, emit `End` (if BRACKET), return — attributed
  to the **activation** entry site (closer-in-callee is the norm; see gap-1),
  owning **partial-closer restoration** (gap-4) and a **positional-tail-after-
  closer** carve-out (freeform `post_close`; agent-3 B-7).

So EOF handling is derivable from **geometry + classification**: positional gets
synthetic-geometry-run, delimited gets force-unwind; **classification is the
only inferred thing, and it routes between the two halves.** The semantic-close
arms (`MissingAttributeValue` etc.) are a third thing — *not* geometry, *not*
deletable unless codegen reproduces the deferred-body dedent cascade (agent-3
A-3). So "delete all ~75 arms" holds only for the leaf value/text/comment arms.

**Classifier confirms the delimited set mechanically.** `descent-rs classify`
(new `tools/descent/.../classify.rs`, encoding the rule not my answers):
positional=33 **delimited=11** MIXED=1 — the 11 delimited match this doc's hand
set exactly; the 1 MIXED is `typed_value` (the `<…>` envelope sub-region), i.e.
gap-3, pinned mechanically. Independent third computation, agrees with reading +
fresh-eyes review.

## Classification table (every function)

### Positional — EOF arm = the `\n` arm (∘ dedent-return for loops)
| Function(s) | Kind detail |
|---|---|
| `document` | root line-loop; EOF = dedent-return (`:eol eof→return`) |
| `element` | children line-loop; 6 `\|eof→return` arms = dedent-returns |
| `name`, `class_name` | CONTENT; `default→TERM→return`; EOF=`\n`-arm (auto content-emit) |
| `suffix`, `spaced_suffix` | emit attr flag; geometric |
| `block_attr`, `sameline_attr`, `sameline_attr_embedded` | line scan; **+ semantic MissingAttributeValue at close (out)** |
| `attr_deferred_body` | deeper-line loop; **+ MissingAttributeValue / AttributeUnderAttribute (out)** |
| `flag_value` | emits BoolTrue/Text geometrically |
| `attr_key` | CONTENT; geometric |
| `attr_trailing_blob`, `attr_text_verbatim` | Text blob to `\n`/EOF/`:bracket` (bracket = enclosing embed's terminator, unconsumed) |
| `prose`, `prose_backticks`, `text`, `text_backticks`, `sameline_text`, `verbatim_text`, `bs_escape` | **void** manual-emit Text; EOF=`\n`-arm |
| `line_comment`, `line_comment_content` | comment (BRACKET/scan); geometric |
| `block_ref` | Reference; scan-to `]`/geometric (interim raw-text wire) |
| `value`, `typed_value` (all number/string/blob states), `emit_bare_value` | positional; **per-state emit type** (Integer/Float/Complex/Rational/BareValue/Text) |
| `block_directive` (raw_content, children loops), `directive_args` | geometric block forms — *never* "unclosed" |
| `count_indent` | INTERNAL |

### Delimited — EOF = keep + `Unclosed<Construct>` + End (synthesized)
| Construct (owner fn) | Closer | Line-bound? (see §gap-6) | Unclosed code | Notes / bug |
|---|---|---|---|---|
| quoted string (`quoted :q`) | `:q` **param byte** | undefined (spans today) | `UnclosedStringValue` | infer must see a param closer |
| array (`array`) | `]` literal | grammar: yes (`\n→warn`); **CORE: undefined** | `UnclosedArray` | divergence, §gap-6 |
| `<…>` envelope (sub-region of `typed_value`) | `>` **depth-counted** | **CORE: defined single-line** | `UnclosedTypeEnvelope` | **warning-FIRST outlier**; mixed-machine, §gap-3 |
| embed (`embedded`→`embed_content`) | `}` | **multi-line (settled)** | `UnclosedEmbedded` | **closer-in-callee**; any-phase-drop bug (§gap-1) |
| interpolation (`interpolation`) | `}}` **multi-byte** | undefined (spans today) | `UnclosedInterpolation` | **partial-closer-consumed** drops trailing `}` (§gap-4) |
| inline directive (`sameline_dir_body`) | `}` via `embed_content` | undefined | `UnclosedInlineDirective`* | **closer-in-callee**; emits wrong code (`UnclosedEmbedded`) today |
| inline raw (`sameline_raw`) | `}` **depth-counted** | undefined | `UnclosedInlineRaw`* | **no `\|eof` arm at all** → silently drops all content |
| inline comment (`brace_comment`→`comment_text_braced`→`skip_brace_balanced`) | `}` **depth** | undefined | `UnclosedInlineComment` | closer **two callees** deep |
| freeform (`freeform`) | ` ``` ` **fence line** | **multi-line (settled)** | `UnterminatedFreeform` | closer is a line-shape, not a byte |
| identity `[…]` key (`parse_element_identity` `:bracket`) | `]` | undefined | `UnclosedIdentityKey` | **never warns today**; `$partial-key` ruling; §gap-2 |

*`UnclosedInlineDirective`/`UnclosedInlineRaw` are ruled in the CHANGELOG but
**not yet in CORE's Warning-codes table** — a real spec/changelog drift found
by reading both wholes.

### Delimited *helpers* (void; closer matched here, owner is the caller)
`skip_single_quoted` (`'`), `skip_brace_balanced` (`}` depth), `embed_content`
(`}`). These carry the closer for a caller that owns the construct identity —
the crux of gap-1.

## Vision gaps / refinements (the "does the plan account for X" yield)

**gap-1 — Closer-in-callee is the norm, not the exception.** embed,
inline-directive, inline-comment, inline-raw, quoted-name all match their
closer in a *callee* while the construct identity (and the `Unclosed*` code, and
the `End`) belong to the *caller*. Today's `infer_expects` looks at a single
function's own return cases, so it sees the caller returning via
`default→/callee→return` (reads *positional*!) and never classifies these as
delimited — which is exactly why the FINDINGS bugs exist (embed any-phase drop,
raw silent-drop, directive wrong-code). **The classifier must work on the
activation (opener→End) and count a callee's closer toward the caller's
hard-success.** The design doc anticipated this ("classify at the activation
root"); grounding shows it's the *common* case, so it's the center of the
implementation, not an edge.

**gap-2 — A shared, closer-parameterized function is *both kinds*, per call
site.** `parse_element_identity(:close)` is **positional** as a block element's
identity (`:close` unused; `default→return` = anonymous-done) and **delimited**
as an embedded/identity-bracket scan (`:close='}'`/`']'`, EOF mid-scan must warn
`UnclosedEmbedded`/`UnclosedIdentityKey`). One function, both kinds — a
per-function static label *cannot* express it. Resolution that stays true:
delimited-ness lives in the **caller's frame** (embedded owns `}` and its entry
site drives the warning); the shared callee is a positional sub-scan that
returns cleanly, and the *frame* emits the anomaly. So the reified pushdown
stack + entry-site-in-frame-state (already planned) is load-bearing here, and
"kind" is a property of an **activation**, inherited by shared callees from
their caller — not a function attribute.

**gap-3 — Mixed machine inside one function; the `<…>` envelope wants to be its
own function.** `typed_value` is positional at `:main` but its `:envelope`/
`:env_check` sub-states are a delimited `<…>` span. The design doc's "statically
reject a function that mixes a closer-accept and a geometric-accept" would
**false-positive reject `typed_value`.** The beautiful fix is the design doc's
own advice applied: **extract `<…>` into its own `/envelope` delimited
function.** Then `typed_value` is cleanly positional and `envelope` cleanly
delimited, the reject-rule holds without exception, and (bonus) the envelope's
warning-first emission is regenerated content-first, retiring the lone
emission-order outlier for free. *Recommend the extraction as part of the
grammar phase.*

**gap-4 — Multi-byte / depth-counted closers, and partial-closer restoration.**
Closers are richer than one literal byte: `}}` (interpolation, two states), `>`
depth-counted (envelope), `}` depth-counted (raw, comment), and the freeform
fence *line*. Inference must recognize these exit *shapes*. And keep-everything
demands the **partial-closer bug** be handled generically: `!{{a}`<EOF> loses
the consumed `}` today — when a multi-byte closer is partially matched then EOF
hits, the synthesized failure must **restore the consumed partial-closer bytes
into content** (they were never a closer). This is a property the generator can
own once, instead of each construct re-deriving it.

**gap-5 — Param-byte closer.** `quoted(:q)` closes on a runtime byte param; the
grammar comment already notes "expects-inference can't see a param terminator."
A `c[:param]→return` must count as a closer-accept.

**gap-6 — Line-boundedness is an *unsettled per-construct decision*; do NOT
treat CORE's text as authority for it.** *(CORRECTED after verification — my
first pass said "the grammar diverges from CORE," treating CORE as a compliance
target. Wrong frame: this is a descent-first spike; CORE's EOF specifics lag the
decisions and are provisional (CORE line 39 says so). The spike defines the
target; CORE follows.)* EOF-failure IS a ratified ruling (fully defined). The
**newline** behavior of delimited constructs is genuinely unsettled, and the
evidence is that CORE contradicts *itself*, not the grammar:
- CORE §End-of-input (line 66) says line-bound `[...]`/`<...>` **close-with-a-
  warning on a newline** (and feeds incomplete-input accounting) — so the
  grammar's `\n`→`UnclosedArray` (30-values:46) *matches* that section.
- CORE §Line-boundedness (line 76) lumps arrays into **"deliberately undefined,
  may change."**
- These two CORE sections disagree → array line-boundedness was **never actually
  decided**; it's provisional text. (The design doc agrees: "a live UX choice,
  one flag on that one construct.")
- And the three "undefined" constructs actually behave **three ways** today
  (verified): envelope warns+closes on `\n` (30-values:127), array warns+closes
  (30-values:46), **string silently spans** (`quoted` has *no* `\n` arm,
  30-values:30-36) — so the blanket "close them on the line they open" oversells
  a uniformity that isn't there.
⇒ Treat line-boundedness as an open per-construct **flag** the spike/grammar
declares (default: EOF-only; opt-in: newline also closes-with-warning) — a
decision to make, not to read off CORE. Infer **EOF**; do **not** infer/cement
undefined and the array/CORE divergence is explicit, not smuggled in by
inference. *(This is the one scoping refinement to the design doc's table, which
presents `newline ≡ EOF for line-bound` as more settled than CORE is.)*

**gap-7 — EOF-inference subsumes the "self-terminating value" TODO.** The ~30
number/string `|eof` arms in `typed_value` are each a twin of their `\n` arm;
"positional EOF = the `\n` arm" deletes them with no state-template mechanism
needed. The two open descent items (`TODO-DESCENT` self-terminating-value +
EOF-inference) **converge** — worth noting so they're not solved twice.

**gap-8 — the generative primitive is newline-injection, not return-type emit
*or* arm-cloning.** Prose/text/blob functions are **void** with manual
`Text(USE_MARK)` emits, so descent's "CONTENT→auto content-emit at EOF" rule
doesn't cover them. "Inject `\n`+dedent and run" does, uniformly — void or
typed, leaf or fall-through. (Return-type auto-emit and leaf-state arm-cloning
are both corollaries of it, correct only where they apply.)

**gap-9 — NEW, VERIFIED: a state family silently DROPS content at EOF today.**
*(Found by fresh-eyes adversarial review, re-verified by me via
`examples/stdin_parse`.)* States entered by *consuming* a marker/sign byte that
route newline through a fall-through (`default → :string`/`:accumulate`) have
**no `\n` arm and no `|eof` arm**, so at true EOF they hit `typed_value`'s
INTERNAL default (bare return, no emit) and the accumulated bytes vanish:
```
|e :x +      → Attr "x", ElementEnd            ; the "+" value is GONE
|e :x +\n    → Attr "x", BareValue "+", …      ; newline emits it
|e :x abc :  → Attr "x", ElementEnd            ; "abc :" entirely GONE
```
Implicated (30-values): `:num_sign`, `:num_complex_sign`, `:maybe_ref`,
`:maybe_interp*`, `:strb_*`, `:kwb_*`. This is a real keep-everything violation
the earlier classification missed, and the decisive reason the primitive is
newline-**injection** (which follows the fall-through and emits) not
arm-cloning (nothing to clone). These are undocumented reds-in-waiting →
`core/fixtures/_wip/`. (Also verified: gap-5's inferred `skip_single_quoted`
path emits a *generic* `Error{Unclosed}`, warning-first, wrong severity — the
normalization must reach the inferred helpers, not just top-level constructs.)

## Unwind is per-frame and kind-agnostic (VERIFIED — must stay true)
The generated EOF handling is **strictly per-frame**: `delimited_code` force-unwind
and `eof_run_default`/`eof_run_newline` both fire on the *current* function's EOF,
and the recursive backend unwinds the call stack **innermost-first regardless of
kind**. There is NO aggregate/global "unwind all delimited, then all positional"
step — so no ordering assumption to break. Verified: `|p |{a |{b x`<EOF> →
`…Text("x"), Warning(UnclosedEmbedded)[b], EmbeddedEnd[b], Warning(UnclosedEmbedded)[a],
EmbeddedEnd[a], ElementEnd` (inner frame closes before outer; content before each
frame's warning). This is exactly what the **future "positional within delimited"**
needs (Joseph, 2026-07-18 — e.g. array-start → indented positional children →
array-end): a positional frame nested in a delimited one emits its content and
closes first, then the delimited frame force-unwinds. Do NOT introduce any
kind-nesting invariant or aggregate-unwind that would assume delimited-before-
positional.

## Build status (LANDED 2026-07-18, merged to `main`; both backends)
1. **Classification** — ✅ DONE (`classify.rs`; report-only).
2. **Positional EOF ≡ newline** — ✅ DONE, and the *hypothesis was refined*: it
   needed **no runtime byte-source change**. Instead codegen runs the state's
   own returning `\n` arm (`eof_run_newline`) or its fall-through `default`
   (`eof_run_default`) at EOF — same effect as "inject `\n` + dedent, run the
   machine," achieved purely in the generator. Fixed gap-9's silent drops.
3. **Delimited EOF = force-unwind** (keep → `Warning(Unclosed<C>)` → End) — ✅
   DONE (`delimited_code`), attributed per-frame. Fixed the embed any-phase-drop.
   *Not yet:* **partial-closer restoration** (gap-4/B-3: interpolation `!{{a}`
   still loses the consumed `}`); accumulating-BRACKET content-keeping
   (`sameline_raw` raw-body drop).
4. **Extract `/envelope`** from `typed_value` (gap-3) — ⬜ NOT done; `typed_value`
   remains the one MIXED machine. Needed before a **static reject** of mixed
   machines is sound (else it false-positives — see TODO-DESCENT).
5. **Semantic-close arms survive** — ✅ they do (compose correctly before the
   force-unwind; verified `|{a :b`<EOF>).
6. **Line-boundedness stays a declared flag** — ✅ not inferred; and CORE's own
   §66-vs-§76 inconsistency on arrays is filed (spec/TODO-SPEC-CORE).
7. **Derive `Unclosed<Construct>` from the construct name** — 🔶 PARTIAL:
   `Unclosed<ReturnType>` derivation works for the regular constructs;
   `UnterminatedFreeform` normalized to `UnclosedFreeform`; the irregular
   callee-scanned codes (InlineRaw/InlineDirective, embed_content→Embedded) await
   the **`|unclosed <Name>`** directive (TODO-DESCENT).
8. **Both backends at parity** — ✅ pushdown ported; `eof_run` predicates shared
   in `ir.rs`; `pushdown_differential` green.
9. **Remaining hand `|eof`:** freeform (fence-LINE closer, invisible to the
   classifier) + the callee-scanners keep a one-line declaration; ~40 prose/
   comment leaf arms are still deletable (diminishing, per-state care).
