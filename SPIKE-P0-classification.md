# P0 — Static positional/delimited classification of the whole UDON grammar

*Spike deliverable. Every active `core/generator/*.descent.udon` function read
directly (not reconstructed). Classifies each by the design-of-record rule
(`spec/TODO-EOF-refactor.md`): **delimited** iff it closes only on a printed
end-sequence; **positional** iff it has any geometric close (newline / dedent /
EOF with no anomaly). Semantics (needs-a-value, cardinality) are a third thing,
out by the litmus.*

## The generative thesis this grounds

CORE §End-of-input: **"EOF is newline + maximal dedent."** The grammar already
declares, per construct, what happens at a newline and at a dedent. So EOF
handling should not be *authored* — it is **derivable**:

- **Positional** → at EOF, do the state's **`\n` arm** (unconsumed), and where
  that arm continues a line-loop, take the loop's **dedent-return**. That is
  the entire positional-EOF behavior, and it already lives in the grammar as
  the `\n`/dedent arms. *Every one of the ~55 positional `|eof` arms is a
  verbatim twin of its own state's `\n` arm.* (Verified across prose, values,
  comments, attributes, elements.)
- **Delimited** → the construct has *no* geometric close (it either spans
  lines, or its `\n` is itself the soft-failure) — it waits for a printed
  closer. At EOF (the ultimate dedent) it cannot close normally, so the
  generator **synthesizes** the soft-failure: keep content-so-far (TERM + emit
  pending), emit `Unclosed<Construct>` **warning**, emit `End` (if BRACKET),
  return — *uniform, at every state of the activation, attributed to the
  activation's entry site.*

Two synthesized primitives replace all 90 hand `|eof` arms. Classification is
the only thing that has to be inferred.

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

**gap-6 — Line-boundedness is a *declared per-construct property*, and the
grammar diverges from CORE.** EOF-failure is fully defined; **newline**-as-close
is NOT uniformly defined:
- envelope: CORE **defines** single-line (`\n`→`UnclosedTypeEnvelope`).
- array: grammar **hand-codes** `\n`→`UnclosedArray`, but CORE §Line-boundedness
  lists array among **"deliberately undefined"** — the grammar is *more*
  committed than the spec. **Surface this: either CORE adopts array-as-line-
  bound, or the grammar's `\n` arm is the parser's undefined-behavior choice,
  not a guarantee.**
- strings, interpolation, inline comment/directive/raw, identity key: multi-line
  **undefined**; parser varies (quoted/interp span lines today).
- embed, freeform: settled **multi-line**.
⇒ The generator should infer **EOF** behavior but must **not** infer/cement
newline-as-close. Model line-boundedness as a per-construct **flag** (default:
EOF-only; opt-in: newline also closes-with-warning), so undefined stays
undefined and the array/CORE divergence is explicit, not smuggled in by
inference. *(This is the one scoping refinement to the design doc's table, which
presents `newline ≡ EOF for line-bound` as more settled than CORE is.)*

**gap-7 — EOF-inference subsumes the "self-terminating value" TODO.** The ~30
number/string `|eof` arms in `typed_value` are each a twin of their `\n` arm;
"positional EOF = the `\n` arm" deletes them with no state-template mechanism
needed. The two open descent items (`TODO-DESCENT` self-terminating-value +
EOF-inference) **converge** — worth noting so they're not solved twice.

**gap-8 — "EOF = the `\n` arm" beats "auto-emit by return type."** Prose/text/
blob functions are **void** with manual `Text(USE_MARK)` emits, so descent's
current "CONTENT→auto content-emit at EOF" rule doesn't cover them — but
"EOF = the `\n` arm" does, uniformly, void or typed. So the generative primitive
should be *newline-arm cloning*, not return-type-driven emit. (The latter stays
a correct special case *of* the former.)

## Implementation shape for P1 (descent-rs)
1. **Positional EOF = clone the `\n` arm** (biggest, safest win: ~55 arms;
   behavior-identical → gate stays green). Proves the primitive; subsumes gap-7.
2. **Delimited classification by activation** (gaps 1,4,5): generalize
   `infer_expects` → recognize param/multi-byte/depth closers *and* closer-in-
   callee via a light call-graph pass; emit content→`Unclosed<Construct>`→End at
   every state; record entry site in frame state. Fixes the FINDINGS bugs; reds
   → correct.
3. **Static-reject mixed machines** *after* extracting `/envelope` (gap-3), so
   the reject rule has no false positive.
4. Leave newline-boundedness a declared flag (gap-6); do **not** infer it.
