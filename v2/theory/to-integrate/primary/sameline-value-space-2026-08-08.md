# Sameline as value-space — the $main / virtual-line-stream model

**Status: converged brainstorm + leans, NOT ruled.** Captured 2026-08-08 from the
live session (jaw + Fable-parent), per the DISCUSSION-THOUGHTS precedent — the
ledger must not lend this authority before ratification. The interleaved-attributes
work (K-series) continues first; this is its emerging mental-model successor.
Spike pass requested (hidden couplings) before any K9 drafting completes.

---

## The model in one line

**All sameline prose is an attribute value — the only question is which attribute
you are assigning to.** (jaw: "if we say 'ALL prose on same-line is basically an
attribute value-- it's just a question of which attribute you are assigning
to...' I like it more and more.")

A document is a virtual line stream. Sameline syntax is a compressed spelling of
virtual lines, governed by two dual operators:

- **`\` inserts a pseudo-LF** — "hypothetical newline, but indent to the current
  cursor location anyway" (jaw). Break out of value-space to the body / next
  virtual line. (This *derives* ESC-BREAKOUT — see OPEN — instead of patching it:
  a framed `\` mid-line is an explicit pseudo-LF at the element's content column,
  exactly what a real Structure-Position `\` does on a real line.)
- **`}` suppresses a pseudo-LF** — closes the inline element *without* the
  newline its block form would need, returning the scan to the same virtual
  cursor. (jaw: "`|{element ...}` — closing `}` essentially just suppresses LF.")

Derivations this yields (previously bare stipulations):

1. `|{a} |{b}` are **siblings** while `|a |b` **nest** — the `}` closed a before
   b opened; block b lands deeper on the virtual stack.
2. **Bracket mode** (CORE §5.6 "only inline forms nest inside `|{…}`") becomes a
   theorem: a block form's only closer is LF/dedent, and braces suspend LFs, so
   a block form inside braces could never close.
3. §6.4's bare-token boundary list is the pseudo-LF model formalized: the
   scan-continuing characters are exactly the **block-form markers** — "would
   this character start a fresh line's structure? then behave as if
   newline+indent were written here."

## $main — sameline text is a designated attribute (jaw: SOLD)

```udon
|element[123]  And here is some sameline text
  :attr1  <1234>
===
|element
  :'$key'  123
  :'$main' And here is some sameline text
  :attr1   <1234>
```

- Same move as identity/traits/flags (K1/K2 sugar philosophy, MODEL §3.1): the
  tail was the last sameline convenience living as a parallel content mechanism.
- **Model-hole fix (the strongest "why"):** MODEL §6 — anything a consumer must
  consult the source to reconstruct is a model hole. Sameline-vs-block text
  position was recoverable only via spans; $main closes it structurally.
  (jaw: "it allows round-trip transformations from the wire to properly
  distinguish those same-line main values that it couldn't before without
  original position metadata which gets unwieldy.")
- Wire cost only; AST builders may re-inject into the first child slot behind a
  host flag (jaw sketch: `first_is_main: false`).
- Retro-derives §7.1 "sameline tail establishes no content base" (of course — an
  attribute value doesn't).
- A $main-only element **never leaves attribute mode** → the original
  interleave pain case (tail, then block attributes) is silent with no tier
  machinery at all.
- Inline elements are exempt from the $main *sugar* (genuinely mixed
  text-and-structure in one bracket; bracket mode is its own context).

## The sameline slot is a typed value position

- `"…"` / `<…>` / `[…]` / numbers self-announce at the slot, become $main
  values, and **return the scan** — so `|element "here we go!" |child "…"
  |grandchild and here we stop ; comment` chains correctly.
- Unquoted prose commits flow (ordinary §6.4) → $main flow value to EOL.
- **Sequences via stacking** (canonical substrate: stacked $main assignments;
  array is the ergonomic view — SEMANTICS §2.4 keeps stacked ≠ list, so the
  substrate must be named; PIN for jaw confirm).
- **The accepted price** (jaw ruled the posture): sameline prose can no longer
  *begin* with `"`/`<`/`[` innocently — those are delimiters at the slot.
  Guidance sentence: *sameline text is a scalar; starting a body of text, go
  next-line indented, especially if it opens with `"` or `<`.* Escapes: `\` at
  the slot forces flow; quote the whole thing. Dialogue idiom:

  ```udon
  |element "hello," she said        ; $main stack: "hello," + flow «she said»
    "oh, hi," he responded.         ; body prose — quotes literal
    they then parted ways.
  ```

- `|el :a 1 extra` → `a=1`, `$main="extra"` (jaw: "reads as close to the intent
  as possible"). Consequence, **by design**: sameline ≢ vertical for text — the
  vertical form's `extra` stays :a's warned extension. The old
  sameline≡first-indented-line ideal is deliberately dropped *for text*.
  Numbers-first strings keep the same discipline as everywhere: `:a "1 extra"`
  or `:a \1 extra`.
- `|element <1234>` sameline = $main envelope; block-body `<9292>` = prose
  (elements' content never types; the element's one value position is the
  sameline slot — symmetric with K7's "an attribute's one value position is its
  first body line").

## R4 overturn at the clean value-expected position (jaw's intent, not yet ruled)

Current §5.6 "intervening text — including a single space — is real content" is
**the tell that inline siblings were squatting in a text block** (jaw: "the
current spec is the hack -- the tell is the space").

New: at a **clean value-expected position** (no flow committed), a brace form
self-delimits as a value and the scan continues; whitespace is a separator.

```udon
|el |{embed-1} |{embed-2}    ; two stacked $main values — no space content,
                             ; no implication of being in a text block
```

- Mid-flow, R4 stands untouched: `|el :n value |{em x} :a 1` still gives n the
  whole flow (the ruled example is unchanged — flow had committed).
- Flipped case to state loudly: `:n |{em x} :a 1` → n = the inline element as
  its value; `:a` = a real attribute (previously: one flow, no :a).
- This is an **Overturns-section change to R4's scope** if ratified — never a
  silent consequence. §6.8's "block binds / braces inline" sentence needs
  re-wording (braces bind too, at the clean slot; the distinction becomes
  node-value vs inline-value vs flow).

## Open pins before K9

1. Stacked $mains vs one-list $main as canonical (lean: stacked; array = view).
2. The designated name (`$main` vs `$text`/`$label`/`$tail`) — paths will type
   it forever.
3. Render-stitching rule ($main before content) — core guidance vs host.
4. Exact R4-overturn wording + which ruled examples flip (spike pass).
5. Warned-accept tier for genuinely-late attributes (after real block content)
   — still wanted? $main removed the common case; the rogue-after-children case
   from the worksheet remains, incl. the late-`$key` streaming carve.
6. ESC-BREAKOUT (OPEN) — likely *dissolves into* the `\`-inserts-LF operator if
   this model lands; do not close it separately.

## Worksheet (from the session, for fixtures later)

The six-case sheet + ten permutations live in the session transcript
(2026-08-08); cases 1/2/5/6 verified against current CORE, case 3 resolved by
typed-$main + stacking, case 4 superseded by the `\`-operator reading.
