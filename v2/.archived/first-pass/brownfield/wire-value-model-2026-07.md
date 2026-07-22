	# Wire / value-model refresh — grammar-vs-spec audit + the attribute-value fix

> **Status: design-in-progress (2026-07-19).** Triggered by the deratification of the flat "Event Encoding (0.9 Wire)" (CHANGELOG alpha.2 → *DERATIFIED*). Joseph asked for the *big picture* (grammar constructs vs. spec, a vocabulary refresh, a PEG/railroad-style formalism over positional/delimited/sameline) so we can **carve a minimal subset** that fixes the attribute-value wire with confidence plus adjacent low-hanging fruit — the whole refresh need not land in 0.9.
>
> This note = the audit + the recommended minimal subset + the deferred refresh. Nothing here is ratified; the value-bracket direction awaits Joseph's ratify.

---

## 1. The defect, in one line

The flat wire encodes an attribute's **value extent implicitly** — a value's end is inferred from the *absence* of a re-emitted `Attr` (plus `BareValue`-vs-`Text`). So the event stream alone cannot separate *an attribute's value* from *the element's child content*. Exhibit (probed, current parser):

```
|el :v1 hey        →  Attr "v1" / Bare "hey" / Text "more text\n" / ElementStart child
  more text            └────────┘  └ v1's ┘   └── el's child?? nothing on the wire says so ──┘
  |child
```

`"more text"` belongs to `el`, not `v1` — carried *only* by "there is no re-emitted `Attr v1` in front of it, and `hey` came as `Bare` (a completed token) not `Text`." Ownership rides on what is **not** emitted. The parser ran the full attr-vs-child/indent analysis to *decide* whether to re-emit, then discarded the answer — so every consumer must re-derive it, and the event fixtures cannot even *express* it. The mixed-interpolation leaks (`:href !{{base}}/x` → `/x` silently the element's) are the same defect surfacing on the sameline.

**Corrected intent (Joseph):** *an `Attr` is always followed by exactly its value, and that value is a **self-delimiting** unit (a scalar, or an explicitly bracketed collection) — so the value's end is never ambiguous.* The flat "infer the extent" mechanism was a later substitution that lost this.

---

## 2. Grammar inventory (the nouns), as they stand

### 2a. Event vocabulary (`00-core` `|type` decls)

| Class | Events |
|---|---|
| **BRACKET** (Start/End) | `Element`, `Embedded`, `Directive`, `Array`, `Freeform`, `Comment` |
| **CONTENT** (one event) | `Name`, `Text`, `Attr`, `StringValue`, `BareValue`, `BoolTrue`, `BoolFalse`, `Nil`, `Interpolation`, `Reference`, `RawContent`, `Raw`, `Integer`, `Float`, `Rational`, `Complex`, `Warning`, `BlankLine` |
| (errors) | `Error{code}` |

### 2b. Functions / constructs, by file

- **00-core**: `document` (head-position dispatch: `:line/:eol/:dispatch/:check_*`), `count_indent`, `skip_single_quoted`, `skip_brace_balanced`.
- **10-elements**: `element`, `parse_element_identity`, `name`, `class_name`.
- **20-attributes**: `attr_ident`, `block_attr`, `sameline_attr`, `sameline_attr_embedded`, `flag_value`, `attr_key`, `attr_key_quoted`, `attr_deferred_body`, `attr_trailing_blob`, `attr_text_verbatim`.
- **30-values**: `value`, `quoted`, `array`, `envelope`, `typed_value` (+ the number sub-machines), `emit_bare_value`, `keywords[bare_kw]`.
- **40-prose**: `bs_escape`, `verbatim_text`, `prose`, `prose_backticks`, `text_backticks`, `text`, `sameline_text`.
- **50-comments**: `line_comment`, `line_comment_content`, `brace_comment`, `comment_text_braced`.
- **60-embedded**: `embedded`, `embed_content`.
- **70-dynamics**: `block_directive`, `directive_args`, `sameline_directive`, `interpolation`, `sameline_raw`, `sameline_raw_body`, `sameline_dir_body`.
- **80-freeform**: `freeform`.
- **90-references**: `block_ref`.

---

## 3. Grammar-vs-spec comparison — where it lags / shows its age

The lag clusters in exactly the two areas Joseph named — **samelines and attributes** — and its root is a single pattern: **content events carry no role; role is inferred from surrounding structure.** The attribute-value wire is the worst case, but it is not the only one.

1. **Attribute value extent is implicit** (§1). *The* defect. Grammar mechanism: `SAVE(akey)` / `USE_SAVED(akey)` re-emit the `Attr` before each value segment; the *absence* of a re-emit = element content. No `AttrValueStart/End`. → **Fix target (this note).**

2. **`Text` is massively overloaded.** One `Text` event means all of: element child prose · attribute text-blob segment · comment content · embedded-element content · freeform body · directive args. The consumer reads role from the enclosing structural events. This is the *general* form of defect #1 — the attribute case just also lost its delimiter.

3. **Text-carrying events are a thicket with contextual, overlapping meaning.** `Text` (blob/prose) vs `BareValue` (a *completed single-token* scalar string) vs `StringValue` (quoted) — the `Bare`-vs-`Text` split exists **partly to power the ownership inference** (Bare = complete, Text = still-collecting), which is exactly the fragile signal §1 removes. `RawContent` (raw block + inline-raw body) is verbatim content — **yet freeform bodies emit `Text`, not `RawContent`** (inconsistent: two "exact verbatim" constructs, two events).

4. **`BlankLine` is three things.** Prose/directive/deferred-body blank lines emit `BlankLine`; **freeform** blank lines emit `Text "\n"` (D2); **raw** blank lines emit `RawContent "\n"`. Principled *if* framed as "interpreted vs exact modes," but the vocabulary never says so — it reads as drift.

5. **Near-duplicate function families (the "age" smell).** `text` / `sameline_text` / `text_backticks` (+ `verbatim_text`) are ~4 copies of the same `|{`/`!{`/`;{`-dispatch + terminator machine with small deltas; the value-boundary logic is duplicated across `kw_boundary` / `str_boundary`; three attribute functions (`block_attr` / `sameline_attr` / `sameline_attr_embedded`) diverge only in a terminator set and tail ownership. Much of this is the "reuse old fixtures/event flows" residue Joseph suspected — the same construct re-expressed per context instead of one construct parameterized by positional/delimited/sameline mode.

6. **References lag** — interim `Reference` raw-text wire; spec wants structured (`ReferenceStart/Name/Attr $key/…`). Known, tracked in `TODO-SPEC-CORE`.

7. **Provisional scalars in bare space** — `Rational`/`Complex` recognized bare; spec flags them as dialect candidates. Known, tracked in `TODO-SPEC-OTHER`.

**Aligned / current** (not lagging): the `<…>` `envelope` as its own delimited construct; `Comment` as a bracket; EOF positional/delimited generation; the text-wire terminator-carrying recast. So the grammar is *current* on the recent recasts — the lag is specifically the **attribute/value/sameline** layer, which predates them and was patched rather than rebuilt.

---

## 4. The organizing principle for the refresh

**Make role explicit by bracketing, not by inference.** The wire should tell a consumer *what a run of content is* without re-running the layout logic. The three delimited "modes" Joseph named are the natural frame:

- **positional construct** — extent from geometry (EOL / dedent / EOF): elements, directives, comments, prose, deferred values.
- **delimited construct** — extent from a printed end-sequence: strings, arrays, embeds, envelopes, interpolation, freeform, identity keys — **and (the fix) an attribute's value.**
- **sameline mode** — the scan along an element/attr line.

An attribute value is *currently* modeled as "whatever positional stuff follows the `Attr` until inference says stop." The fix reclassifies it as a **delimited construct with an explicit closer** — which is precisely the corrected intent.

---

## 5. Recommended MINIMAL 0.9 subset — the attribute-value fix + adjacent fruit

Smallest change that fixes the value problem *with confidence* and improves toward the goal, without pulling the whole refresh into 0.9.

### 5.1 `AttrValueEnd` — one new event; `Attr` is the implicit start

An attribute's value is the run of events **between its `Attr` and its `AttrValueEnd`.** Nothing outside that bracket is the attribute's.

```
W5:   Attr "v1" / BareValue "hey" / AttrValueEnd / Text "more text\n" / ElementStart child
                  └──── v1's value ────┘            └───────── el's children ─────────┘

blob: Attr "v1" / Text "value " / EmbeddedStart…EmbeddedEnd / Text " more" / AttrValueEnd
                  └──────────────── v1's value (all segments) ───────────────┘

mixed interp (J1):  Attr "v1" / Interpolation "the-value" / Text " a b c" / AttrValueEnd
node value:         Attr "h"  / ElementStart header … ElementEnd / AttrValueEnd
flag + child:       Attr "a?" / BoolTrue / AttrValueEnd / ElementStart beta … ElementEnd
present-empty:      Attr "n"  / AttrValueEnd                     (:n ;{} → empty; comment is inert inside)
missing value:      Attr "a"  / Error(MissingAttributeValue) / Nil / AttrValueEnd
```

**What it retires, for free:**
- the `SAVE(akey)`/`USE_SAVED` **re-emit machinery** (segments just sit inside the bracket — no key re-emission);
- the **empty-`Text ""`-for-present-empty** workaround (present-empty = an empty bracket; missing = a bracket containing the error/Nil);
- the **blob-segment-vs-stacked-assignment conflation** (a second assignment is a second `Attr`+bracket; a multi-segment value is one bracket — now distinct);
- the fragile **`BareValue`-vs-`Text` ownership signal** (role now comes from the bracket, so the split can revert to a pure *typing* distinction, or later collapse — see §6).

**Reconstruction contract: untouched.** `AttrValueEnd` is structural, not text-bearing; pure-concat text reconstruction is unaffected.

**Blast radius (contained to the attribute layer):**
- grammar: `block_attr` / `sameline_attr` / `sameline_attr_embedded` / `attr_deferred_body` / `flag_value` emit `AttrValueEnd` at value-completion; drop the re-emit;
- `00-core` `|type[AttrValueEnd] …`;
- AST (`tree.rs`): consume the bracket instead of aggregating re-emitted keys;
- fixtures: every attribute expectation re-derived (spec-first, gate red → green);
- CORE "Event Encoding" rewritten from the deratified flat text to the bracket.

### 5.2 The `*{` boundary behavior, *built on the bracket*

With the bracket, the whole `*{` ruling lands cleanly (and is finally *testable* at the event level): brace forms (`|{`/`!{`/`;{`) and mixed interp are value **segments inside the bracket**; block-form `|name` is a node value inside the bracket; the boundary rule (marker → single-segment value + close bracket; text/brace → blob continues in the bracket) is the delimiter's own logic. The semantic CORE text for this already landed today (it is encoding-independent).

### 5.3 Adjacent low-hanging fruit (cheap, same neighborhood)

- **`;{` space-keep** (`value ;{…}` keeps the space before `;{`) — a `TERM(-2)`→ `TERM(-1)` correction; ruled.
- **`;{}` → empty value** and **`;x` unframed literal** — fall out of the bracket + the `*{` boundary rewrite.
- **mixed interp J1–J4** (interp/embed then text → one bracketed multi-segment value) — the bracket is exactly what makes this expressible; the leading-token cases (all of J1–J4) come with the boundary rule; the glued literal-*before*-interp (`pre!{{x}}`) stays deferred (§6).

---

## 6. The broader refresh — DEFERRED (tracked, not 0.9)

Real value, but not needed to fix attributes; do after 0.9 with a clear head:

- **Generalize role-by-bracket** beyond attributes — decide whether element child text, comment content, freeform/raw bodies should each be unambiguously framed, so a single `Text` event's role is always the enclosing bracket. (The attribute bracket already disambiguates value-vs-child; this is the *rest* of #2/§3.)
- **Consolidate the text-carrying vocabulary** — revisit `Text` / `BareValue` / `StringValue` / `RawContent`: with the bracket, `Bare`-vs-`Text` no longer carries ownership; keep only the *typing* distinctions we actually want, rename for clarity ("BareValue" = "untyped scalar token"). Unify freeform-vs-raw body.
- **`BlankLine` framing** — state the interpreted-vs-exact rule explicitly (prose → `BlankLine`; freeform/raw → exact `"\n"`), or unify.
- **De-duplicate the function families** — one text machine + one attribute machine parameterized by positional/delimited/sameline mode, replacing the ~4 text and 3 attribute near-copies. This is where most of the "age" lives.
- **A PEG / railroad-diagram formalism** over the positional/delimited/sameline abstractions — Joseph's preference (PEG, given little lookahead; or railroad for legibility), **excluding** indent/dedent/head-position (those stay a separate layer, not baked into the grammar formalism). This becomes the readable "spine" the literate-fusion item (`TODO-META`) wants.
- **Structured references** (`ReferenceStart/…`), **rational/complex → dialect** — already tracked; fold into the refresh.
- **Glued literal-before-interp** (`pre!{{x}}post`) — the one mixed-interp case the boundary rule doesn't cover (interp firing *inside* a bare-token scan).

---

## 7. Recommendation & open questions for Joseph

**Recommend:** land **§5 only** in 0.9 — `AttrValueEnd` + the `*{` behavior on top
+ the adjacent fruit — and open a tracked "wire/vocabulary refresh" lane for §6. That fixes the attribute-value problem with confidence, makes the sameline/attr area finally testable at the event level, and is a *strict* improvement toward the role-explicit goal, while keeping 0.9 bounded.

**Open questions (need your ratify before grammar work resumes):**
1. **`AttrValueEnd` only, or `AttrValueStart`+`End`?** I lean End-only (`Attr` already marks the start; one new event). Symmetric pair is more uniform but heavier and redundant with `Attr`.
2. **Do we also want the bracket around *node* values** (so `:h |header…` is `Attr h / AttrValueEnd`-wrapped) — yes in my model (uniform: every value is bracketed), confirm.
3. **Scope line for 0.9:** §5 only (my rec), or pull any specific §6 item forward (e.g., the freeform-vs-raw `Text`/`RawContent` unification is nearly free)?
4. **Blob-vs-stack:** the bracket *naturally* separates them (one bracket = multi-segment value; two `Attr`s = two assignments). Adopt that distinction now (it's free), or keep them merged? I lean adopt — it removes a documented round-trip caveat at no cost.
```
