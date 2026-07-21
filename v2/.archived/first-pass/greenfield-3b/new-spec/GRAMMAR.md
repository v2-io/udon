# UDON Grammar — mechanical recognition (implementer view)

**Status:** non-normative companion to [CORE.md](CORE.md).  
If this file and CORE disagree, **CORE wins.**

This is the scannable extract of the rules a recognizer implements as control
flow. It exists so implementers need not mine CORE for “the pop-while loop.”
Semantic meaning of the resulting ADM is in [MODEL.md](MODEL.md) and CORE.

Peer note: greenfield-3a showed that a short grammar pillar dramatically
improves scannability; this file is that idea without demoting CORE’s
completeness.

---

## 1. Encoding and columns

- UTF-8 source.
- **Column** = count of leading U+0020 only. Tab in indentation → **Error**
  (keep parsing; best-effort keep). Tab elsewhere → ordinary content.
- Lines split on U+000A. Missing final newline is fine (EOF ≡ newline for
  Geometric Constructs).

---

## 2. Nesting Rule (the stack)

Each open structural item has `base_column` (column of its introducing marker,
e.g. `|`).

On a new structural line at column `c`:

```
while stack nonempty and c <= top.base_column:
    close(top)
open new item as child of new top  # or document top-level if stack empty
```

| Relation | Meaning |
|----------|---------|
| `c > top.base_column` | child (after the while, top is parent) |
| `c == top.base_column` | sibling (while pops the old top first) |
| `c < top.base_column` | dedent (while pops until relation holds) |

**Sameline:** later `|…` on the same line use the column of that `|`, as if each
were on its own line.

**Prose interior exception:** if Content Base is set, lines with
`c > content_base` are Text interior (not structure), even if they look like
markers. Structure only at `c ≤ content_base`.

---

## 3. Structure Position and Markers

Markers fire only in **Structure Position**:

1. Line start at a structural column (not prose interior), or
2. **Line Scan** on an element-rooted line through elements/attributes before
   prose commits.

| Marker | Guard (sketch) |
|--------|----------------|
| `\|` | next is XID_Start, `[` `.` `{` `'`, or `?!*+` — else prose (Markdown tables) |
| `:` | element not yet in Content Phase; Key follows — else prose (+ Warning if late ancestor `:`) |
| `!` | next is ident or `:` — else prose |
| `@` | next is `[` `.` or ident |
| `;` | context-dependent (see CORE §8) |
| `` ``` `` | three backticks at Structure Position |

`\` is **not** a Marker (it never begins structure); its effect is positional
only — see §5 and CORE §9.

Failed guard → character is ordinary Text (and at a bare-token boundary, not a
Boundary Marker — CORE §6.4). First bare prose word **commits the line to
prose** (Markers literal), except framed sameline ` ; `.

---

## 4. Bare-Token Boundary

After an unquoted value token, look at the next non-space character:

1. **Guard-confirmed** block-form Boundary Marker (`:`, block `|`/`@`/`!`,
   Fence, boundary `\`, framed ` ; `) → finish as **single-token value**;
   continue scan. A marker-looking char that fails its guard is *not* a
   boundary (`:3`, `|~`, `!=` → flow with the bare token).
2. **Anything else**, including inline brace forms → commit **Flow Value**
   from this token to EOL (or framed comment).

**Inline-Brace Principle:** `|{` `!{` `;{` (and anticipated `@{`) **never**
finish a bare token; they open Flow segments.

**Keywords** `true`/`false`/`null`/`nil` type only when alone at a boundary;
else they start Flow text (`true story`).

**Failed numeric mid-token** (`12ab`) falls through to bare token; boundary
applies at its end.

---

## 5. Escape (`\`) — position only

| Position | Effect |
|----------|--------|
| Structure Position | consume `\`; rest of line = prose; no sameline comment; inline forms still live |
| Before `\|{` `!{` `;{` in prose/flow | consume `\`; opener literal |
| Value-expected (plain attr needs value) | consume `\`; Flow text mode; no sameline comment on that line |
| Else | literal `\` |

Leading `\\` at Structure Position → one literal `\`.

---

## 6. Tail ownership (priority)

When Flow / trailing text starts:

1. Open Attribute still needs value **or** is **collecting** (Attribute-rooted
   line) → that Attribute (further assignment + Warning if value already finished).
2. Else nearest Element on the line → Element Content (Content Phase).
3. Else ordinary column owner (not an Error).

**Element-rooted** finished attr → tail is Element Content.  
**Attribute-rooted** finished attr → warn-ingest under that key.

**Node Value one-way door:** once block `|name` (or block Verbatim/Fence) opens
as a value, the rest of that line binds to the **node**, not the outer Element.

---

## 7. Prose Content Base

1. Sameline text does **not** set Content Base.
2. First indented content line sets `content_base`.
3. Later line `≥ content_base`: strip that many spaces; extras stay in Text.
4. Later line still in element but `< content_base`: **Warning**, rebase, continue.

Fence bodies: **no** prose dedent (byte-exact).

---

## 8. Extent and EOF

| Kind | Closes on |
|------|-----------|
| **Geometric** | EOL, dedent, or EOF (silent at EOF) |
| **Delimited** | matching end-sequence; multi-line **per construct** ([DECISIONS](DECISIONS.md) D1) — identity `[…]` is line-bound |

At true EOF, close innermost-first:

- Geometric → silent close.
- Delimited still open → keep content, **Warning** per frame, set
  **Incomplete Input** on the document.

Chunk boundaries ≠ EOF.

---

## 9. Anomaly defaults

| Severity | Meaning |
|----------|---------|
| Warning | kept; may not match intent |
| Error | loss / illegal geometry; **do not halt** recognition |

Keep-Everything wherever CORE defines a keep path. Halt/reject = Consumer policy
above recognition.

---

## 10. Pointers into CORE (do not skip for full conformance)

| Topic | CORE |
|-------|------|
| Full marker guards | §4 |
| Elements, sugar, inline `\|{…}` | §5 |
| Attributes, flags, stacking, phase | §6 |
| Comments | §8 |
| Verbatim forms | §10 |
| Scalars, lists, envelopes | §11 |
| Dynamics / references (syntax) | §12 |
| Design principles | §15 |

ADM shape: [MODEL.md](MODEL.md).  
Equivalence / round-trip: [SEMANTICS.md](SEMANTICS.md).
