# I4: small glyphs that say what kind of number — №, ℕ ℤ ℚ ℝ ℂ, ∅, and a few that died

*Invention fork `invent-beyond`, spike a, 2026-10-22. Invented first, judged after. Sources: Stevens' levels of measurement (nominal, ordinal, interval, ratio), with the numero sign `№` and the ordinal suffixes natural languages already use to mark them; mathematics' blackboard-bold number systems and ∅; physics' concise uncertainty `1.00794(7)`; chemistry's isotope notation. Glyph facts **checked** with Python's `unicodedata`: ℕ U+2115, ℤ U+2124, ℚ U+211A, ℝ U+211D, ℂ U+2102 and ∅ U+2205 are East-Asian-width Narrow or Neutral; `№` U+2116 and the subscripts `₁` `₂` are **Ambiguous** (they can render double-width).*

## I4a: the identifier problem is a measurement-level problem, and English already marks it

The classification fork found that no spelling rule can tell `1234567` the commit from 1234567 the count; only the slot can. Here is why: **they are different levels of measurement written with the same digits.** A zip code is *nominal* (a name that happens to be numerals), `3rd` is *ordinal*, `5 m` is *ratio* with a unit. Written language marks the level when it matters:

- **nominal:** № 5, n° 5, #5, "No. 5";
- **ordinal:** 1st, 2nd, 3rd;
- **ratio:** a unit.

A bare numeral is the unmarked cardinal.

So: one glyph for the nominal level, the case that bites.

```udon
|part :zip №01234 :commit №1234567 :version №1.10 :count 1234567
```
````tree
root
  |part
    :zip ⸨01234⸩ nominal
    :commit ⸨1234567⸩ nominal
    :version ⸨1.10⸩ nominal
    :count ⸨1234567⸩ #integer
````

- **The tree.** `№` is consumed, like a quote. The text keeps its spelling, carries "nominal", and is never classified. A data reading gives the JSON string.
- **Beautiful to me** because it names the real distinction rather than a workaround ("quote it so it isn't a number"): this numeral is a *name*. `№01234` reads exactly as meant.
- **Against it:**
  - `№` is Ambiguous width;
  - no agent would guess it (A2 −);
  - quoting already does the job at no new character cost.
- **Its real contribution is the insight, not the glyph.** The DP3 hazard is nominal-vs-ratio, which is why the slot (which knows the domain) is the right decider, and why a legend (I3) entry like `:zip postal-code` resolves it.

## I4b: number-system letters as the assertion, and ∅ as nil

Where the parent's lead writes `<8080>` to insist on a number (K14), say *which* number:

```udon
|server[web] :port ℕ8080 :offset ℤ-3 :weight ℝ0.75 :ratio ℚ1/3 :z ℂ3+4i :backup ∅
|typo :port ℕ8O80
```
````tree
root
  |server
    :$key ⸨web⸩
    :port ⸨8080⸩ #integer ∈ℕ
    :offset ⸨-3⸩ #integer ∈ℤ
    :weight ⸨0.75⸩ #decimal ∈ℝ
    :ratio ⸨1/3⸩ ∈ℚ
    :z ⸨3+4i⸩ ∈ℂ
    :backup nil
````

`|typo` is an error: "`8O80` isn't in ℕ (the `O` after `8`); did you mean `ℕ8080`?"

- **What it does for rationals and complex numbers.** They never needed to be in the bare standard set. They have a home exactly when an author insists: `ℚ1/3`, `ℂ3+4i`. That's the clean answer to the old line's "provisional" rationals and complex numbers.
- **∅ for nil.** It reads as nothing to anyone who has seen a set, it is never ordinary text, and it is single width. It is a sharper spelling of nil than `<>`, which looks like an empty placeholder or tag.
- **Subscript bases,** a further step: `ff₁₆`, `755₈`, `1010₂` instead of `0x`, `0o`, `0b`, as a mathematician writes a base. Mixed widths among the subscript digits (`₁` and `₂` Ambiguous, `₆` and `₈` Neutral), poor tokenization, and they can't be typed, so this stays a curiosity.
- **Beautiful to me** because each letter is a whole sentence ("a natural number"), single-width, already known to every model from mathematics, and asserting a *set membership* is exactly what an assertion is.
- **Against it:**
  - five new characters (A8 −);
  - generative guessability is low (an agent would write `8080`, never `ℕ8080`, unprompted);
  - `ℝ` has no portable host meaning ("real" means f64 to most hosts, which is a lie about exactness).

My taste keeps **∅** and lets the letters go, unless Joseph finds them as beautiful as I half do.

## I4c: precision kept in the spelling (a reframing, not a syntax)

Physics writes `1.00794(7)`: the value and its uncertainty in the last digits. It also treats `1.10` and `1.1` as different measurements (three significant figures vs two). Under identity by spelling (the classification fork's Cc), `:version 1.10` keeping its trailing zero was framed as identifier safety. It is also **measurement honesty**: a lite tree keeps significant figures because it keeps spellings. Joseph's 07-14 remark that "tracking significant figures … will be crucial" (quoted by the history fork) is met by Cc with no syntax at all. A concise-uncertainty reading (`1.00794(7)<measured>`) is a notation for a reader, an I1 reading.

## Died, with the reason

| Idea | From | Why it died |
|---|---|---|
| Corner annotations around a value (`¹⁴₆C²⁺₂`: mass upper-left, number lower-left, charge upper-right, count lower-right) | chemistry | plain text has one dimension: before and after. The only way it gets a second dimension is a separate line, which is I2. The finding: **a gloss tier is the plain-text form of corner annotation.** |
| `✓` / `✗` for true / false | ballots, checklists | lovely in a task list (`:done ✓`), but two spellings of a boolean and nothing gained over `true` that a legend can't give |
| Superscript type tags (`ᵈᵃᵗᵉ2026-07-21`) | typography | the superscript alphabet has holes (no superscript q), the letters are tiny in a monospace font, and they tokenize badly |
| HGVS-style prefix-dot (`g.12345`, `c.76A>T`) | genetics | `.` is the trait mark in UDON |
| Linguistic brackets by level (`⟨spelling⟩`, `/phonemic/`, `[phonetic]`) | linguistics | the insight survives (bracket kind names the layer of representation: spelling vs what it means, Joseph's R vs T). The glyphs don't: `⟨⟩` is indistinguishable from `<>` to Joseph's eyes and probably to most fonts. Also: to a linguist, `⟨…⟩` means *the raw spelling*, the opposite of "a typed value", so an agent with that prior reads `<…>` as raw text. |

## The weighing, in short (Beauty first; hypotheses)

- **I4a (№):** A1 +½, A3 +1, A5 +1, but A2 −1, A8 −1, and Ambiguous width. Not worth a character; worth the insight.
- **I4b (ℕ…ℂ):** A1 +1, A3 +1, B4 +1 (the error names the set), against A2 −1, A8 −2, A12 −1, and host portability for ℝ.
- **∅:** A1 +1, A3 +1, A8 −½. **The one glyph here I'd put in front of Joseph** as nil's explicit spelling, beside or instead of `<>`.
