# Invention fork: value notations stolen from programming languages and made beautiful

*A fork of spike a, launched after Joseph's note on low creativity ("not a single mention of 'what if we used elixir-like sigils, but made more beautiful?'"). Invent first, judge after. Joseph's earlier notes hold: CTQ-FACTORS is the compass, and the estate's documents are ideation, not evidence. No commits.*

## The inventions

| | Idea | Stolen from | One line | Page |
|---|---|---|---|---|
| **N1** | **Tagged code values** | Elixir sigils, JS tagged templates, Markdown code spans, lite's own fences | `` :when date`2026-07-21` ``, `` :pattern re.i`^\d+$` ``: a label touching backticks names who reads a verbatim body; a fence at value size | [n1](n1-tagged-code-values.md) |
| N2 | Tagged quotes and named lists | Python/Julia prefixes (`v"1.10"`), CSS `rgb(…)` | `v"1.10"`, `rgb[255 0 0]`, `geo[40.71 -74.00]` | [n2–n6](n2-n6-other-inventions.md) |
| N3 | The type trails the value | F# units `1.0<cm>`, Rust `0xffu64` | `5<min>`, `5<m>`, `2026-07-21<date>` | same |
| N4 | The clef | music's key signature | `\|server.inet :port ssh`: a trait names the vocabulary that reads the element's bare values; a tagged value is the accidental | same |
| N5 | Glyph literals | APL, ALGOL 68 `⏨`, typography, Unicode `¤` | `:backup ∅`; currency signs as tags that are already glyphs | same |
| N6 | The allomorph | Raku `IntStr`, `:port<8080>` | a noun for spike a's lead: text that is also a number | same |

## What I'd say, judged after ([weighing](weighing.md); my hypotheses; I have a favorite)

- **N1 scores highest, with Beauty first:** 7.83 overall and 7.85 on the beauty group, against 6.70 and 6.24 for spike a's `<date: …>` lead, re-scored on the same factors. It adds no character, it unifies notations with fences, its bodies need no escapes, and it frees `<…>` for a later UDON.
- **Its real loss is errors that teach.** Lite carries the body unread, so a mistyped insisted-on number is caught only by a reader. Pairing N1 with a closed `<…>` for assertions wins that back for a little beauty.
- **Units want to trail and notations want to lead (N3).** So `920px` stays bare text and the notation name comes first.
- **N4 and N5 compose with anything.** N4 puts slot types once on the element, as a word about the domain. N5's `∅` is a nil no one writes by accident.

Files:
- [n1-tagged-code-values.md](n1-tagged-code-values.md): the full composite set and lines, with trees
- [n2-n6-other-inventions.md](n2-n6-other-inventions.md)
- [weighing.md](weighing.md), `weigh.py`
