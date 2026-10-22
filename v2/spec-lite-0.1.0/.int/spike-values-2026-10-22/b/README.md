# Spike b: how lite's values come to mean what they mean

*Opus 5.5, 2026-10-22, from the brief in `../BRIEF.md`. Nothing here is committed by me, and no card was edited; proposed card changes are named on each page. Joseph's two mid-run notes (CTQ-FACTORS is the compass; the corpus is ideation, never evidence) were carried into every page and passed to all three forks, which amended their files.*

## The question as I took it

The span asks for a type system and its notation to be explored "over the whole range of possibilities", with `<…>` reopened. Underneath, I think, is a smaller and sharper question: **which layer decides a value's kind, and what does each form of a value (bare, quoted, angled) say about who decides?** Once that is settled, most notation choices follow, and several disputes turn out to be one design described twice.

## Headline findings (each on its page, with labels for what was checked)

1. **Streaming does not decide between whole-run typing (B) and "bare is text" (C).** Fork S *ran* the 0.9 parser: it holds every run (numbers, words, text, quoted strings) to its end before emitting anything, and calls `4938…2p` a `BareValue` at the `p`. Both options are bounded by the line, and with a fragmenting wire both could stream, the kind trailing. The open bit of (C) was recorded as decided by streaming; it wasn't. → `fork-S-streaming.md`, `10` §1.
2. **The bit that does decide it is `:debug false`.** With no default reading, a schema-less consumer gets the string `"false"`, which is truthy in Python, JS, Ruby and Elixir (run). The opposite hazard, `:version 1.0` read as a float, is rarer. → `10` §2.
3. **The default reading should be JSON's number grammar plus `true`/`false`/`nil`: normative, frozen, on.** It is picked by a lossless test (only spellings every host reads back as written), so leading-zero integers like `01234` stay text. The rich set (`0xFF`, `1_000`, `0o755`) moves inside `<…>`, where it commits and errors. This is (C) completed rather than reversed: the raw tree is still all text. → `10` §3–4 (β3).
4. **A slot declared on one occurrence is a literal assertion in disguise**, so per-occurrence slot syntax (`:port:u16`) adds nothing over `<…>`. It also collides with `xml:lang`. Slot types belong in vocabularies that are themselves lite documents, addressed by element and attribute names (Joseph's "algebraic names"), and in **strict getters for kinds**, the twin of his strict getters for cardinality. Lite needs no slot syntax at all. → `20`.
5. **A delimited value should stand alone, or the whole run is text.** Today `|p "Hello," she said.` loses its quote marks to a string-plus-text stack, and `|li [Docs](https://x.org) for more` loses its link to a list. With the stand-alone rule both are one text, `:c 1 z` and `:c "1" z` behave alike, and most of `<`'s collisions with HTML and Markdown dissolve too. → `30`, `40`.
6. **Precedent (weighed, not obeyed):** the three-layer split of spelling in the document, slot type declared once elsewhere, and override on the value is what every mature schema system converged on (XSD, JSON-LD, YAML). Lite's combination, all text in the tree with a JSON-sized default reading, has no exact precedent. KDL 2.0 recently made bare words strings and put marks on keywords. → `fork-R-precedents.md`.

## Branch map

| Decision | Branch | Fate | Why | Page |
|---|---|---|---|---|
| D1 who reads a bare run | β1 first character commits (A) | dead | `920px` an error; Joseph's own reason | 10 |
| | β2 whole run, the old rich set | dead as a default | every old surprise becomes a silent misread (B3, A3); the set lives on inside `<…>` | 10 |
| | **β3 text in the tree; a JSON-grammar default reading, normative** | **recommended** | best on A2, A3, B3, C1 | 10 |
| | β3b canonical-only (`1.0` stays text) | pruned | fixes one case, and inconsistently (A6, A7) | 10 |
| | β4 no default reading | pruned after three attempts to make it work | `:debug false` is a truthy string | 10 |
| | β5 the view optional per consumer (the lean as written) | pruned | it is β3 or β4 depending on the consumer; it adds variability | 10 |
| | β6 no primitives in lite | dead | C1 | 10 |
| | β7 kind by strict getter | kept, inside β3 | the lightest slot type | 10, 20 |
| D2 what a delimiter commits | δ1 commit and stack (today) | incumbent | loses quotes and links in text | 30 |
| | δ2 only `$main` is exempt | pruned | breaks element/attribute sameness | 30 |
| | **δ3 must stand alone, else a run** | **recommended** | C2, C3, A3; one rule for both value shapes | 30 |
| | δ4 residue is an error | pruned | errors on the most ordinary prose (A2) | 30 |
| D3 the standard set | JSON grammar by default, the rich set in `<…>` | recommended | lossless test; "now we *can* commit/error" | 10, 40 |
| | units, temporal and rationals in the default | dead | no host equivalent; old surprises | 10, 20 |
| D4 the literal-side spelling | `<…>` strict, standing alone; labels reserved in lite | recommended for lite 0.1 | δ3 removes the prose collisions; B2 | 40 |
| | `⟨…⟩` | alive, weaker after δ3 | clashes with the transcripts' `‹›`; cold agents write `<` | P, 40 |
| | attached tag `date"…"` | alive for full UDON | most guessable for notations; needs a tag-length bound | P, 40 |
| | KDL `(t)v`, EDN `#t`, REBOL bare forms, carrying `<…>` raw | dead | silent prose collisions; the CTQ's own headroom note | P |
| D5 where slot types live | **σ1 data (vocabularies) + getters** | **recommended** | A5, B6, C2; no syntax | 20 |
| | σ2 per occurrence (`:port:u16`) | dead | a literal assertion in disguise; `xml:lang` | 20 |
| | σ3 header, σ4 trait-selected | collapsed into σ1 | conventions, not syntax | 20 |
| D6 overlapping unions | ordered | pruned | B3 | 20 |
| | disjoint arms checked when the vocabulary loads, plus an error at read | recommended | decidable for regular notations | 20 |
| D7 units | dimension = slot, unit = spelling, conversion = consumer | recommended | Joseph's "a bit of both", taken apart | 20 |
| D9 trailing `:` | ornamental or compulsory | open, beauty only | no type role under σ1; a name can't end in `:` | 20 |

## Files

- `debrief.md`: to Joseph, in examples and trees. **Start here.**
- `00-working-frame.md`: the first framing, the decision map, the composite example set (E1–E12).
- `10-who-decides-kind.md`: D1, D2, D3 (the bit, the set, the branches, scores).
- `20-slot-side.md`: D5, D6, D7, D9.
- `30-delimiter-must-stand-alone.md`: D2 on the `$main` side.
- `40-literal-side.md`: D4, given the above.
- `fork-S-streaming.md`: fork S; a run of the 0.9 parser, a shape inventory, a proposed B1 rewording.
- `fork-R-precedents.md`: fork R; YAML, KDL, XSD, JSON-LD, EDN, REBOL, Elixir, CUE, CSS, StrictYAML, with sources.
- `fork-P-literal-notation.md`: fork P; the literal side as play: ten branches, renderings, deaths.

## On the forking experiment (Joseph asked)

Three `fork` agents (full inherited context), launched in parallel at the first decision map. Their briefs were each one paragraph: a role and a file. The harness allowed it, and the forks resumed cleanly when the relayed notes arrived. What it bought: one real measurement I would not otherwise have made (S), one independent arrival at the same E6 collision (P, confirming it), and one source check I leaned on (R, YAML §3.3.2, which I re-read myself). What it didn't buy: variety of frame. Forks inherit the parent's framing, so they push branches hard but rarely reject the parent's frame. For "warm" variation a fresh agent with a bare brief would likely do better. I didn't fork deeper than one level; no branch got messy enough to need it.
