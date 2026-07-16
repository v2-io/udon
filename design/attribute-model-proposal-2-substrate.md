# Attribute model — substrate (switch-invariant)

**Companion to** [`attribute-model-proposal-3.md`](attribute-model-proposal-3.md)
(active binding proposal). Archaeology: proposal-2.

**Status:** **DECIDED** switch-invariant substrate for CORE. No open forks
here — unresolved binding questions live only in proposal 3.

Independent of the semantic-`?` switch: if that switch were rejected, this
substrate would still stand (with a different binding doc).

**Provenance:** distilled from
[`attribute-model-2026-07.md`](attribute-model-2026-07.md). Registers:

| Tag | Meaning |
|-----|---------|
| **[PROPOSED]** | High-confidence target for CORE (this design family) |
| **[CURRENT 0.8]** | What CORE + the event parser do *today* (contrast only) |

Examples are **[PROPOSED]** unless marked otherwise.

---

## S1. Frame: hash and array

**[PROPOSED]** An element automatically has a **hash** and an **array**:

- **Attributes (hash):** labeled edges from the *parent’s* perspective
  (`my address`, `my headers`). The label is conserved. Values stack under
  the already-ratified stacking rule (order preserved; heterogeneous).
- **Children (array):** positional, heterogeneous, self-named. A child
  names *what it is*; an attribute names *what it is to me*.

In graph terms: **attributes are edges; elements are nodes; edges may
terminate at leaf values or at nodes.** Restricting attributes to scalars
was XML residue, not a UDON design decision.

**Teaching reframe (replaces README “scalar → attr / structure → child”):**
ask **whose name is it?** Parent’s relationship-label → attribute; self-name
→ child.

**Already law (unchanged):** attributes before children (phase rule);
stacking uniformity; column hierarchy (`pop while col ≤ base`).

**[CURRENT 0.8]** CORE still says attributes are primarily typed scalars;
“complex attribute values” are underspecified; block attrs run to EOL
(one attr per block line).

---

## S2. Uniform scan (line shape, not flag policy)

**[PROPOSED]** A `:` enters attribute mode. The line proceeds by a **uniform
scan**: after each key, the next **value-shaped** thing (see S3) is that
attribute’s value — exactly one — then the scan continues (`:`, node openers
owned by line-rooting, prose, comment).

**[PROPOSED]** Multiplicity is always stacking; stacks are heterogeneous:

```
:a 1
:a |node
:a more text
; a = [1, ⟨node⟩, "more text"] in declaration order
```

**Mnemonic:** *key, then one value-shaped thing, then the scan continues;
prose requires an owner.*

How “no value” is treated (error vs true vs deferred deeper block) is
**not** in this substrate — that is the switch in proposal 2.

**[CURRENT 0.8]** Block lines run bare values to EOL, so
`:bttr 2 :cttr 3` is one attr with value `"2 :cttr 3"`. Uniform scan
**supersedes** that (see S8).

---

## S3. Closed value taxonomy

**[PROPOSED]** A value is exactly one of:

| Kind | Forms |
|------|--------|
| **Scalar** | quoted string, number, `true`/`false`/`null`/`nil` alone, `[…]` list, `<…>` envelope |
| **Reference** | `@…` (selector; inert at core) |
| **Interpolation** | `!{{…}}` |
| **Node** | exactly one of: `\|element`, `!:lang:` raw block, freeform `` ``` `` |
| **Text block** | bare prose (body rules S5; first-line extent in proposal 2) |

**[PROPOSED]** Types live on the **map side** (attributes / array items).
`<…>` is meaningful in value position and not in free child prose — labels
and types belong together; children own their own detection.

Block `!directive` as a node value is out of substrate scope (proposal 3 /
DYNAMICS).

**[PROPOSED]** `@` as attribute value is first-class and preferred for
“pointer to an existing element” (parent labels what the pointer is *to it*).

---

## S4. First-character commitment (typing)

**[PROPOSED]** The first character of a bare value commits the parse:

| First character | Commitment |
|-----------------|------------|
| Digit, sign, `"`, `'`, `<`, `[` | Typed scalar path |
| Letter / other non-committing | **Text** path (keywords only if the whole token is alone) |

Sub-rules:

1. **Within-token failure** on the typed path (`:count 32849…-to-1`) → fall
   through to **text** (token-local; no unbounded lookahead).
2. **Finished value, then more on the line** — the **parent element** owns
   the remainder on **both** element-rooted and attribute-rooted lines
   (further `:attrs`, children, or prose). Not “scalar forbids bare words,”
   and not an attr-rooted-only orphan error.
   - **Inside a node value’s scan**: leftover material is that **node’s**.
3. **Keywords** `true` / `false` / `null` / `nil` are typed **only** when
   they are the entire value token. So `|el :alpha true story` is
   `alpha=true` and el prose `"story"`, not one text value
   `"true story"`.

**Blessed asymmetry (typing commit path only):**

```
|el :alpha true           ; alpha = bool true (keyword alone)
|el :alpha true story     ; alpha = true; "story" is el prose
|el :count 7 apples       ; count = 7; "apples" is el prose
|el
  :count 7 apples         ; SAME: count = 7; el owns "apples"
```

Digits declare a typed scalar token; they do **not** forbid subsequent
parent-owned material. **How far a letter-first bare text value extends**
(one token vs more) is **not** specified here — see proposal 2 (open).

---

## S5. Text values (body rules only — not first-line extent)

**[PROPOSED]** Text is a first-class attribute value kind (substrate S3).

**Once a value is text, its body is fully literal** — same posture as
comment continuation: markers (`|`, `:`, `!`, `;`, `@`, fences, `|{…}`,
etc.) are ordinary characters. **No** inline forms fire inside a text
value. **No** in-text `\` escapes (unlike element prose). A `\` in the
body is a literal backslash.

**Not specified here** (lives in proposal 2 until settled):

- how much of an element-rooted sameline a letter-first bare value takes
  (one token vs rest of line);
- whether / how multi-line text continues after the first line;
- blank lines inside multi-line text.

**Dedentation** of multi-line text bodies, when multi-line text exists, uses
ordinary prose content-base machinery (same as element prose). Trailing
sameline comment frame (` ;` …) on a text-bearing line remains a comment
(ratified), not text content.

**AST advisory (S9):** marker-looking lines inside text values may warn
(e.g. `MarkerInTextValue`) — host/AST, not a second parse of structure.

---

## S6. Value-position escape (`\`)

**[PROPOSED]** `\` immediately in **value-expected** position (plain attr
still needs a value; no value token started) **enters text mode**. The `\`
is consumed and is not content. The resulting value is a text value (S5
body rules).

```
|el :count \7 apples
; enters text — *extent* of "7 apples" vs "7" + prose is proposal 2
```

This is a **fourth positional use** of `\`, distinct from:

- head-position `\` → force line to prose (ratified CORE)
- mid-**prose** `\` before `|{` / `!{` / `;{` → escape opener (ratified;
  element prose only — **not** inside text values, S5)
- post-value scan `\` → force remainder of element line to prose (ratified)

Position disambiguates. Full worked cases and extent after value-`\`:
proposal 2.

---

## S7. Node values (topology)

**[PROPOSED]** Exactly **one** node per attribute declaration — **no
anonymous wrapper**. The attribute’s value *is* the element (or raw /
freeform node):

```
:beta
  |veni-vidi-vici :working 1234
; beta IS a veni-vidi-vici
```

**[PROPOSED]** A second sibling node at the same value depth is an
**error** (“attribute gets one child — stack the key to add more”).
Recovery shape (stack-parse vs skip) is proposal 2, not substrate.

**[PROPOSED]** **No attribute-under-attribute.** A deeper line that is
itself `:key` under an attribute is an error (“attribute value cannot be
another attribute”). Maps-of-maps use a named node:

```
:theta
  |config :first 1 :second 2
```

Composite-key path sugar is out of scope here. Conventional namespacing via
`/` in identifiers (S10) covers today’s need: `:address/street 123`.

**Recursion:** attributes on the node-value element are that *element’s*
attributes — ordinary grammar. Never “attrs hanging on attrs.”

**How sameline `|node` binds** (to the attribute vs to the parent element)
is **not** in this substrate — that is the switch in proposal 2. Substrate
only requires: **once a node is accepted** as an attribute value, its scan
owns the remainder of that node’s grammar (identity, its attrs, its prose).

---

## S8. Line-rooting (who owns the leftover)

**[PROPOSED]** Independent of *whether* a given construct is accepted as an
attribute value (that policy is proposal 2):

1. **Element-rooted** lines (`|el …`) are owned by the element for material
   that is not part of an attribute’s value.
2. **Attribute-rooted** lines (block line starting `:key`) give the one
   value slot to that attribute; further siblings at the parent’s column
   belong to the parent element.
3. **After a finished non-text attribute value** on an element-rooted line,
   the remainder of the line is the **element’s** (S4) — standard UDON.
4. **Once a node is open** (as a child of the element, or as an accepted
   attribute value), **that node’s scan owns its interior** — its attrs,
   its prose, its children:

```
|el |another :alpha <some val>
      :beta |the-beta-element?[123].super :a :b :c "value for c" this prose is for the-beta-element
```

Here `:beta` is an attribute of `another` (child of `el`); if beta’s value
is accepted as a node, that node owns the trailing attrs/prose.

Attrs-before-children still applies *per element*.

**Not claimed here:** that a sameline `|node` after `:key` *is* the
attribute’s value — that is proposal 2’s switch.

---

## S9. Warning-placement guideline (keeper)

**[PROPOSED]** Independent of attribute flag policy; belongs in CORE notes /
`core/CLAUDE.md` when the model lands:

> If you need extra lexical/descent work only to emit a warning, put it on
> the **AST** builder. If an event consumer critically needs it, or the
> recursive parser already has the fact incidentally, keep it in the
> **grammar**. Keep a ledger of which codes live where.

Opening ledger (non-exhaustive):

| Layer | Codes / cases |
|-------|----------------|
| Grammar (incidental) | `InconsistentIndentation`; missing plain-attr value **error** (proposal 2); second node at value depth **error** |
| AST | `MarkerInTextValue`; distant-block-bound-to-attr advisory; `?`-key with non-bool value; optional framing advisories |

(Past-base `\` → already `EscapeOutsideHeadPosition` at AST, ratified.)

---

## S10. Identifier charset expansion

**[PROPOSED]** High-confidence piece only:

| Charset | Today (0.8) | Proposed |
|---------|-------------|----------|
| Element **names** | XID + `-` | + `/` — **not** `?!*+` (those stay element *suffixes*) |
| **Traits** | XID + `-` + `?!*+` | + `/` |
| Attribute **keys** | XID + `-` | + `/` and `?!*+` (unquoted); see proposal 3 for flag semantics of **terminal** `?` |

`/` is **conventional namespacing with zero core semantics**
(`:address/street`, `|acme/widget`, `.acme/experimental`).

---

## S11. Supersession (substrate only)

When this substrate is ratified into CORE, it **knowingly supersedes**:

1. **“Attributes are typed scalars”** / README decision table → S1 frame
   (edges may end at nodes/text).
2. Finished value → parent owns the rest of the line on both roots (S4).
3. Text bodies fully literal (S5) when text values exist.

**Preserves untouched:** stacking; attrs-before-children; column hierarchy;
sameline-comment lexeme; 2026-07-15 comment rulings; `$`-identity sugar;
duplicate-definition policy; core scalar set and `<…>` interim.

**Does not decide:** flag policy; sameline node binding; first-line bare
text extent; multi-line text entry — all proposal 2.

---

## S12. Event & AST sketch (implementation note — not CORE prose)

Parked so implementers don’t re-derive; refine when coding:

- Scalars / refs / interpolations: keep `Attr` + value event (low churn).
- Node and text values: bracket pair (working names `AttrStart` /
  `AttrEnd`) around ordinary element/text/raw/freeform events.
- AST: `Value::Node(NodeId)`, `Value::Text(...)`; `attr("beta")` returns
  the node directly — no wrapper.
- Error codes for: second sibling node at value depth; attr-under-attr;
  (proposal 2) plain attr missing value.

Timing of “defer until next non-blank line” depends on flag/value policy —
see proposal 2.

---

## S13. No open items here

Unresolved questions live **only** in
[`attribute-model-proposal-2.md`](attribute-model-proposal-2.md).
