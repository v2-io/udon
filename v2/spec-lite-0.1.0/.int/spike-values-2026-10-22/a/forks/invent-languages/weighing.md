# Weighing the inventions (judged after)

*Invention fork of spike a, 2026-10-22. Each score is my hypothesis, 0–10, and was assigned only after the inventions were rendered. Weights are from CTQ-FACTORS.md. Only the factors where the notation designs differ are scored; the rest add the same to every row. Script: `weigh.py` (`python3 -I weigh.py`).*

**A bias to name first.** I invented N1 and I like it. The angle fork scored ANG-4c on its own factor set and scale (1250 of 1660). I re-scored ANG-4c here on the same reduced set as the inventions, so the comparison is like for like, but the person scoring has a favorite. Discount N1's margin accordingly.

## Scores

| Design | All differing factors | Beauty group only (A1–A9) |
|---|---|---|
| **N1** `` date`…` `` (tagged code values) | **7.83** | **7.85** |
| N1 + N2's named lists `rgb[…]` | 7.64 | 7.53 |
| N1 + a closed `<…>` for assertion (ANG-3) | 7.53 | 7.32 |
| N2 `date"…"` / `rgb[…]` | 7.07 | 7.20 |
| ANG-4c `<date: …>` (spike a's lead) | 6.70 | 6.24 |
| N3 `2026-07-21<date>` (type trails) | 5.53 | 5.61 |

N4 (the clef) and N5 (glyphs) aren't alternatives for writing a notation. N4 is a reading convention that needs no grammar, and N5 is a spelling for nil, so they aren't scored against the rest. Each composes with any row.

## Where the differences come from

- **Beauty, A1 (my judgment): N1 9, ANG-4c 6.** N1 is one idea at two sizes, uses no new character, and leads with the domain word. ANG-4c gives `<` three roles and `:` a third, and the colon-space inside an angle reads to me as an invented syntax rather than a found one.
- **Generative guessability, A2: N2 8, N1 7, ANG-4c 5, N3 4.** Prefix-string literals and tagged templates are everywhere in what agents read. `<date: …>` is learnable but not guessable. A value with a trailing `<…>` reads as HTML.
- **Parsimony, A8: N1 9.** Backticks already mean "verbatim" in lite (fences) and in Markdown; nothing gains a role.
- **Headroom, B6: N1 9, ANG-4c 5.** N1 leaves `<…>` wholly free for a later UDON.
- **Errors that teach, B4: ANG-4c 9, N1 6.** This is N1's real loss. A closed `<…>` lets lite itself reject `<8O80>` and `<920px>` with a "did you mean"; a tagged code value is carried unread, so the typo surfaces only in a reader. That's why "N1 + closed `<…>`" is in the table. It wins back B4 at the cost of spending `<…>` again, and lands a little below N1 alone. **I'm not sure which of the two I'd choose.** It depends on how much Joseph wants lite itself to catch an insisted-on number.
- **Other languages exactly, C8: N1 9.** Raw bodies with no escapes: `` re`^\d+$` ``, `` html`<b>x</b>` ``.

## What the inventing found that the judging alone wouldn't have

1. **A notation is a fence at value size.** Lite already has the beautiful version of the notation construct; it just only had it for blocks. That's true whichever spelling wins: ANG-4c's own justification was the fence analogy, and N1 makes the analogy literal.
2. **Elixir's modifiers are traits.** `~r/…/i` → `` re.i`…` ``: lite's traits already mean "what kind of this thing", so they absorb sigil modifiers with nothing new.
3. **Units want to trail and notations want to lead** (N3's lesson). That's why `920px` should stay bare text and `date` should come first.
4. **The slot type belongs on the element, once** (N4, the clef). It matches the slots fork's "declared once per element type" and uses a mark lite already has.
5. **Raku built Cc already and named it**: an allomorph, the text `8080` that is also the integer 8080 (N6).

## What I'd put to Joseph, as examples

```udon
|decision :date date`2026-07-21` :pattern re.i`^\d+$` :html html`<b>x</b>`
|decision :date <date: 2026-07-21> :pattern <re.i: ^\\d+$> :html "<b>x</b>"
|server.inet :port ssh :timeout 5m :backup ∅
```

- Which of the first two lines reads as more beautiful to you, and why?
- Does the third line's trait-as-clef feel like the domain showing, or like a trait doing a job it wasn't made for?
