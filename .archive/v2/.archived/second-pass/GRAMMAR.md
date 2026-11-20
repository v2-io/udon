# Grammar — mechanical recognition extract

**Status:** non-normative companion. **If this file and [SPEC.md](SPEC.md) disagree, SPEC wins** (**P3**).  
**Role:** Scannable control-flow restatement for implementers. Not a generator `.desc` input (yet).

---

## 1. Encoding and columns

- UTF-8 source.
- **Column** = count of leading U+0020 only.
- **Tab in indent (**L4**):** Warning; keep as text of current owner (spaces before tab as column); **not** line-lost. Tab elsewhere = ordinary content.
- Lines split on U+000A. Missing final newline OK (EOF ≡ newline for Geometric Constructs).

---

## 2. Nesting Rule

Each open structural item has `base_column` (column of introducing marker).

On new structural line at column `c`:

```text
while stack nonempty and c <= top.base_column:
    close(top)
open new item under new top (or document top-level)
```

| Relation | Meaning |
|----------|---------|
| `c > top.base_column` | child |
| `c == top.base_column` | sibling (while pops old top first) |
| `c < top.base_column` | dedent |

**Sameline:** later `|…` on the same line use the column of that `|`.  
**Prose interior:** if Content Base set, lines with `c > content_base` are Text interior (markers literal). Structure only at `c ≤ content_base`.

---

## 3. Structure Position and Markers

Markers fire only in **Structure Position**:

1. Line start at a structural column (not prose interior), or  
2. **Line Scan** on an element-rooted line through elements/attributes before prose commits.

| Marker | Guard (sketch) |
|--------|----------------|
| `\|` | next is XID_Start, `[` `.` `{` `'`, or `?!*+` — else prose (Markdown tables) |
| `:` | element not yet in Content Phase; Key follows — else prose (+ Warning if late ancestor `:`) |
| `!` | next is ident or `:` — else prose |
| `@` | next is `[` `.` or ident |
| `;` | context-dependent (SPEC §8) |
| `` ``` `` | three backticks at Structure Position |

`\` is **not** a Marker (positional only).

Failed guard → character is ordinary Text. First bare prose word **commits the line to prose** (Markers literal), except framed sameline ` ; `.

---

## 4. Bare-Token Boundary

After an unquoted value token, look at the next non-space character:

1. **Guard-confirmed** block-form Boundary Marker (`:`, block `|`/`@`/`!`, Fence, boundary `\`, framed ` ; `) → finish as **single-token value**; continue scan. Marker-looking char that fails guard is *not* a boundary (`:3`, `|~`, `!=` → flow with the bare token).
2. **Anything else**, including inline brace forms → commit **Flow Value** from this token to EOL (or framed comment).

**Inline-Brace Principle (**R4**):** `|{` `!{` `;{` (and anticipated `@{`) **never** finish a bare token; they open Flow segments.

**Keywords** `true`/`false`/`null`/`nil` type only when alone at a boundary; else they start Flow text.

**Failed numeric mid-token** (`12ab`) falls through to bare token; boundary applies at its end.

---

## 5. Escape (`\`) — position only

| Position | Effect |
|----------|--------|
| Structure Position | consume `\`; rest of line = prose; no sameline comment; inline forms still live |
| Before `\|{` `!{` `;{` in prose/flow | consume `\`; opener literal |
| Value-expected (plain attr needs value) | consume `\`; Flow text mode; no sameline comment on that line |
| Else | literal `\` |

Leading `\\` at Structure Position → one literal `\`. **No Core in-string escapes (**L2**)**.

---

## 6. Tail ownership (priority)

When Flow / trailing text starts:

1. Open Attribute still needs value **or** is **collecting** (Attribute-rooted line) → that Attribute (further assignment + Warning if value already finished).
2. Else nearest Element on the line → Element Content (Content Phase).
3. Else ordinary column owner (not an Error).

**Element-rooted** finished attr → tail is Element Content.  
**Attribute-rooted** finished attr → warn-ingest under that key.

**Node Value one-way door:** once block `|name` (or block Verbatim/Fence) opens as a value, the rest of that line binds to the **node**, not the outer Element.

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
| **Delimited** | matching end-sequence; **per-construct multi-line OPEN ML** |

At true EOF, close innermost-first:

- Geometric → silent close.
- Delimited still open → keep content, **Warning** per frame, set **Incomplete Input** on the document (**R2**, **C6**).

Chunk boundaries ≠ EOF. Emission order unclosed: content → Unclosed* → End (**R12**).

---

## 9. Anomaly defaults

| Severity | Meaning |
|----------|---------|
| Warning | kept; may not match intent |
| Error | loss / absent intended value; **do not halt** recognition (**L0**, **R11**) |

Keep-Everything wherever SPEC defines a keep path. Halt/reject = Consumer policy above recognition.

| Situation | Severity | Keep |
|-----------|----------|------|
| Root `:key` | Warning | document Text (**L1**) |
| Tab in indent | Warning | text of owner (**L4**) |
| Attr-under-attr | Error | text of open value (**L6**) |
| Plain `:key` no value | Error | Nil assignment (**R6**) |

---

## 10. Pointers into SPEC

| Topic | SPEC |
|-------|------|
| Full marker guards | §4 |
| Elements, sugar, inline `\|{…}` | §5 |
| Attributes, flags, stacking, phase | §6 |
| Comments | §8 |
| Verbatim forms | §10 |
| Scalars, lists, envelopes | §13 |
| Dynamics / references (syntax) | §11–12 |
| Anomalies | §15 |

ADM shape: [ADM.md](ADM.md). Wire: [WIRE.md](WIRE.md). Stages: [PIPELINE.md](PIPELINE.md).
