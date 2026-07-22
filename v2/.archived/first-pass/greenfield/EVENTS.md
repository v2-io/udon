# Greenfield event design — derived from spec/ alone

*2026-07-19. Derived from a clean cover-to-cover read of CORE.md + companions, deliberately without reading the descent grammars, fixtures, TODO lanes, or the EBNF. Where this disagrees with the current implementation, that is the point of the exercise. Contamination note: the author had trace exposure to a few current-wire nouns (BlankLine, terminators-as-text) via project memory; the derivation below re-justifies everything it keeps.*

The spec's own constraints that shape the wire:

1. **Streaming, bounded lookahead** — events fire as soon as a guard decides; nothing requires whole-document knowledge except identity-key naming (below).
2. **Pure-concatenation reconstruction** — the document's *text material* must reconstruct by in-order concatenation of text-bearing events; terminators of text-bearing lines are text; structure bytes are geometry.
3. **Keep-everything anomaly posture** — warnings/errors are in-band events; nothing is silently dropped.
4. **Self-delimiting attribute values** — CORE's deratification note states the corrected intent verbatim: *"an `Attr` is always followed by exactly its value, and that value is a self-delimiting unit."* Greenfield, the natural reading of that intent is a **bracket**.

---

## The event vocabulary (19 events)

### Structure

| Event | Payload | Notes |
|---|---|---|
| `ElementStart` | `name?`, `inline?` | `name` absent for anonymous elements. `inline` marks the `\|{…}` form — one event type, form is a property (an inline element **is** an element: same identity, attrs, content model minus block children). |
| `ElementEnd` | | Fired by dedent, `}` (inline), or EOF unwind. |
| `AttrStart` | `key` | Key as written, quotes resolved; flag keys keep their `?`. Desugared identity/traits/suffixes arrive as ordinary `AttrStart "$key"` etc. |
| `AttrEnd` | | Closes the value bracket. Everything between the pair **is the value** — one scalar event, one bracketed construct, or a blob's segment sequence. |
| `ArrayStart` / `ArrayEnd` | | Literal `[…]` only. Items are value events. |

### Values

| Event | Payload | Notes |
|---|---|---|
| `Scalar` | `kind`, `text` | `kind` ∈ Str, Int, Float, Bool, Null (+ provisional Rational, Complex). `text` is the source form (`"0xFF"` stays `0xFF`); projection is the host's. |
| `Envelope` | `body` | The `<…>` span, interior verbatim (newlines included). *Interim per CORE: no dialects exist yet, so a conformant parser may instead emit `Warning NoDialectsLoaded` + `Scalar Str "<…>"`. Greenfield recommendation: emit `Envelope` always and let the host stringify — same information, no retyping when dialects land. Corpus uses `Envelope`.* |
| `Reference` | `name?`, `key?`, `traits[]` | One event, structured. The selector tuple is deliberately closed (no nesting, no attrs — CORE), so it needs no bracket; the "reuse element-identity machinery" plan buys generality the construct is defined not to have. |
| `Interpolation` | `expr` | `!{{…}}` — expression unparsed. |

### Text

| Event | Payload | Notes |
|---|---|---|
| `Text` | `content` | **The only text-chunk event.** A fragment, never guaranteed whole; terminators ride per the reconstruction contract. Its *interpretation* comes from its enclosing frame: bare = flow text; in a Verbatim frame = opaque capture; in a Comment frame = comment content (excluded from document text material). |
| `BlankLine` | | ≡ `"\n"` of text material; a real event so the AST can rule interior-vs-ornamental over the whole stream. (Inside Verbatim frames blank body lines are `Text "\n"` — exact mode has no interpretation layer.) |

### Frames (bracketed non-element constructs)

| Event | Payload | Notes |
|---|---|---|
| `CommentStart` / `CommentEnd` | `inline?` | Content arrives as `Text` inside the frame; the frame is the exclusion scope for reconstruction (stripping comments preserves line boundaries). Continuation lines are further `Text` events in the same frame. |
| `VerbatimStart` / `VerbatimEnd` | `form`, `label?` | `form` ∈ `block` (`!:lang:`), `fence` (```` ``` ````), `inline` (`!{:kind:…}`). **One frame for all verbatim capture**: same wire shape, three surface geometries (block dedents to the raw base; fence is byte-exact; inline is brace-counted). `label` is the language/kind/info-string. Body = `Text` events in the frame — text material, never UDON-parsed. |
| `DirectiveStart` / `DirectiveEnd` | `name`, `arg?`, `inline?` | `arg` is the unparsed rest-of-head-line (dialect's to interpret). Body between the pair is ordinary UDON events. |

### The noun system (normalization this vocabulary commits to)

- **Text flow** (or just *flow*) — a sequence of `Text` fragments, inline forms, and `BlankLine`s that **resolves to text** once inline forms are processed by their layers (comments stripped, interpolations evaluated, inline elements rendered). Three homes, one content model: **element flow** (prose), **flow values** (the attr value CORE 0.9 calls a *text blob*), and **inline-form interiors**.
- **Verbatim** — capture that is *never* UDON-parsed: one frame, three forms. Replaces the drifting raw/freeform/content trio ("raw" survives only as the `!:lang:` surface form's name).
- **Text material** — the reconstruction domain: every `Text` outside Comment frames, plus `BlankLine` as `"\n"`. One rule, no per-construct cases.

### Anomalies

| Event | Payload | Notes |
|---|---|---|
| `Warning` | `code` | Content was kept. |
| `Error` | `code` | Something was lost (e.g. `NoTabs` line drop) or shape violated (`MissingAttributeValue`, `AttributeUnderAttribute`). Non-halting. |

No `DocumentStart/End`: EOF flushes open frames innermost-first (positional silently; delimited as `…content… → Unclosed* → End`).

---

## The load-bearing choice: bracketed attribute values

`AttrStart k … AttrEnd` makes every consequence of CORE's attribute model fall out mechanically:

- **Value extent is explicit.** No inference from the *absence* of re-emission; the W5-shape ambiguity (deeper text: value continuation or element child?) is answered by where `AttrEnd` fires, on the wire, once, by the parser that already knows.
- **Stacking ≠ segmentation, structurally.** Stacked assignments are *sibling brackets* under the same key; blob segments are *events inside one bracket*. The flat wire's conflation of the two dissolves rather than being patched.
- **Node values need no convention.** `AttrStart k · ElementStart … ElementEnd · AttrEnd` — the element is inside the value bracket, so "the attr *is* the node" vs "flag settled, node is a child" is bracket membership, not an adjacency idiom.
- **Warn-ingested segments stay honest.** `AttributeValueExtendedByTrailingText` / `AttributeSecondValue` ingestion = `Warning` + a *new* bracket for the same key (it is stacking, per CORE's "in the same stacking spirit").
- **Empty and missing stop needing sentinels.** `:n ;{}` (empty string) = `AttrStart n · CommentStart/…/CommentEnd · AttrEnd` — an empty bracket whose only frame is a comment ⇒ value `""`. `MissingAttributeValue` = `AttrStart n · Error · Scalar Null · AttrEnd`.

Cost: two events where flat had one, only for attributes; every other frame in the vocabulary already pays it, so the wire becomes *more* uniform, not less.

**Terminator placement rule** (the one spot CORE leaves unassigned): the terminator of a text-bearing line belongs to the **innermost frame still open at line end that is text-bearing scope** — a blob value's line terminator rides the blob's last `Text` *inside* the bracket; when a trailing comment owns the line end, `AttrEnd` fires at the value's last material, the comment frame follows at owner scope, and the terminator-only `Text "\n"` lands at owner scope after `CommentEnd`. Pure-structure lines (scalar-valued attr lines, element-only lines) emit no terminator — geometry.

**The one hold:** an identity key's attr name (`$key` vs `$partial-key`) is decided by its *close* (`]` vs EOF/newline). The bracket wire holds the `AttrStart` until the close decides — bounded in practice (identity keys are values, not prose), and the fail-safe naming is worth it.

---

## Reversibility (the round-trip constraint, made explicit)

*(Constraint stated by Joseph mid-derivation, 2026-07-19: the event stream must reverse to the original document with no loss of **meaningful** data — ideally byte-exact; geometry variants like `:attr <val>` vs. deferred-block `:attr` + deeper `<val>` need not be distinguished, but prose newlines and all comments must survive.)*

Audit of the vocabulary against it — three fidelity classes:

**Byte-carried** (in event payloads, exact): all text material with its terminators (`Text` in flow and Verbatim frames, `BlankLine`≡`\n`); comment content (in frames); scalar *source* forms (`0xFF` stays `"0xFF"`); envelope interiors; interpolation expressions; raw labels / fence info strings; key/name/trait spellings.

**Flag-carried** (structural facts a serializer needs to regenerate the right surface form): `inline` on elements/directives/comments (block vs brace form); `kind` on raw frames (`!:lang:` vs fence vs `!{:…:}` — different capture geometry, must not swap); bracket membership (value vs child; stacked bracket vs blob segment); `$key`-desugar attrs (re-sugarable to `[k]` — or emittable longhand, which CORE defines as identical in meaning).

**Geometry** (dropped, canonically regenerable, meaning-free by spec): stripped indentation (content-base, raw base, continuation indent — *relative* indent beyond the base is byte-carried in the Text payloads); pure-structure line terminators; comment frame spaces; consumed escapes; quote characters around strings (`"x"` vs `'x'` collapse — meaning-equal per the type table); implicit vs explicit flag `true`.

Two spots where "meaningful" needed a ruling and the greenfield copy flags the choice: (1) a sameline comment's *frame* spaces are geometry (` ; c` and ` ;  c`… the space **after** `;` is content, only the frame space before is geometry); (2) quoted-string quote choice is geometry — if byte-exact round-trip is ever promised, both would need to move up a class (spans recover them regardless).

---

## Pseudo-grammar (line machine)

Notation: informal EBNF over a *line-oriented* machine; `→e` marks emission. The indent stack and head-position dispatch are the whole skeleton.

```
document       := line* EOF                 ; EOF: unwind all frames (End rules above)

line           := indent dispatch
indent         := ' '*                      ; tab in indentation →e Error NoTabs, line dropped
                                            ; column c: pop while c <= top.base →e ElementEnd*
                                            ; EXCEPT c > prose content-base ⇒ prose-interior line
                                            ; blank line →e BlankLine (no pops, no base effect)

dispatch       :=                           ; head position; each arm gated by its guard
    element-line                            ; '|' + (XID_Start | [ . { ' | suffix-char)
  | attr-line                               ; ':' + name-start, and owner not in children phase
  | directive-line                          ; '!' + (XID_Start | ':')
  | comment-line                            ; ';' per position table
  | fence-line                              ; '```'
  | reference-line                          ; '@' + ([ . | XID_Start)
  | escape-line                             ; '\'  (consumed; rest of line is prose, inline forms live)
  | prose-line                              ; anything else

element-line   := element-head sameline-tail
element-head   := '|' identity              →e ElementStart{name?}
identity       := name? key? trait* suffix?               ; contiguous
                | name? trait* suffix? key? trait*        ; suffix binds identity
                  ; key   := '[' value ']'  →e AttrStart "$key" value AttrEnd
                  ;          (unclosed ⇒ "$partial-key" + Warning UnclosedIdentityKey)
                  ; trait := '.' (bare-trait | quoted)    →e AttrStart "$traits" Scalar Str AttrEnd
                  ; suffix := [?!*+] touching identity, or space-separated at line end
                  ;          →e AttrStart "$?"|"$!"|"$*"|"$+" Scalar Bool true AttrEnd

sameline-tail  := (ws (element-head | attr | reference | fence-open | escape-tail))* prose-tail?
                  ; the scan: elements/attrs keep head position open; first prose word closes it

attr           := ':' key value?            →e AttrStart{key} … AttrEnd
value          := scalar | array | envelope | reference | interpolation
                | node | blob | deferred-block
  scalar       := quoted | number | keyword-alone | bare-token-finished
                  ; bare token holds the scan open at its boundary; next non-space char decides:
                  ;   block-form marker (: \ ``` |name @name !name framed-;) ⇒ token was the value
                  ;   anything else, inline brace forms included ⇒ blob from this token
  array        := '[' value* ']'            →e ArrayStart … ArrayEnd   ; no blobs inside
  node         := element-head …            ; block form only; its scan owns its interior
                | raw-block | fence         ; inside the AttrStart bracket
  blob         := (Text | inline-form)*     ; prose-shaped; runs to EOL or framed ' ; '
  deferred-block := (deeper lines under an open key)      ; prose rules, blanks included,
                                            ; AttrEnd fires at the dedent
  flag rule    := key ends in '?': next token exactly true|false|null|nil alone ⇒ value;
                  else →e Scalar Bool true, AttrEnd; material re-owned by the scan

prose-line     := (Text | inline-form)*     →e Text fragments, terminator on last
                  ; first indented prose line sets content-base; shallower line
                  ; →e Warning InconsistentIndentation, base rebases
inline-form    := '|{' identity sameline-attrs? content '}'   →e ElementStart{inline} … ElementEnd
                | '!{{' expr '}}'           →e Interpolation        ; first '}}' closes
                | '!{:' label ':' raw '}'   →e VerbatimStart{inline} Text VerbatimEnd  ; brace-counted
                | '!{' name body '}'        →e DirectiveStart{inline} … DirectiveEnd
                | ';{' comment '}'          →e CommentStart{inline} Text CommentEnd ; brace-counted
                | '\' before an opener      ; consumed, opener literal

directive-line := '!:' label ':' raw-block  →e VerbatimStart{block} Text* VerbatimEnd
                  ; raw base = first indented content line's column; sameline tail allowed
                | '!' name arg?             →e DirectiveStart{name, arg} … DirectiveEnd
                  ; body = deeper lines, ordinary UDON

fence-line     := '```' info? body '```'    →e VerbatimStart{fence, info?} Text* VerbatimEnd
                  ; exact capture, closer at any indent, must end its line

comment-line   := ';' …                     →e CommentStart Text* CommentEnd
                  ; participates in indent/dedent; continuation = every deeper line, verbatim
reference-line := '@' selector              →e Reference{name?, key?, traits}
```

Guards are 2–3 chars of bounded lookahead throughout; a failed guard means the character was prose. Suspended guards at chunk boundaries are saved state.

---

## What I looked for and did not find a need for

- **`Name` as a separate event** — folded into `ElementStart`; nothing in the spec needs a name to arrive after its start (identity is contiguous and bounded). *(If the implementation streams names byte-wise for zero-copy reasons, that is a payload-encoding concern, not vocabulary.)*
- **`EmbeddedStart/End`, `BareValue`, `BoolTrue`-style typed micro-events** — subsumed by `ElementStart{inline}` and `Scalar{kind}`.
- **A `Freeform`/`Raw` event split** — a fence is a verbatim with fence geometry; one frame serves all three surface forms.
- **`AttrValueEnd` asymmetry** (bracket-close with implicit open) — chose the symmetric pair instead; every other frame in the vocabulary is a Start/End pair, and the hold-for-identity case wants an explicit start anyway.

The corpus (`corpus/`) walks every construct family through this vocabulary.
