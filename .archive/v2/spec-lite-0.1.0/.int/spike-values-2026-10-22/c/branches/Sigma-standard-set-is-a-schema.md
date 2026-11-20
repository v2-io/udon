# Branch Σ: the standard set is a schema, not a grammar

*Spike c, worked by the spike agent after D0 and Cv, before the `B` and `core` forks reported; revised after they did (see the end). A synthesis branch: it claims that B and C stop being rival grammars once the frame geometry (`../00-frame.md`) is taken seriously. Labels: checked / guess / taste.*

## The claim

The question "is bare `8080` a number?" has been posed as a grammar question (B: yes, in the tree; C: no, text in the tree, a view may read it). Under the geometry, kind comes from the slot, the start mark or the spelling. Spelling-decided kind is just one particular slot type, applied to every slot:

> **`std`**: a value whose whole run spells a number, `true`, `false` or `nil` in the standard notation is that primitive; anything else is its text.

So:

- **Lite's grammar is C.** A bare run is a «text» in the tree, always.
- **B's reading is the `std` schema** applied to a document. It is selectable the way any schema is: by the reader, by a converter's flag, or by the schema-name convention a file already carries (`name.schema.ud`).
- **One standard notation** (the `core` fork's territory) is used in three places: inside an explicit mark (`<8080>`, committing, an error on a mismatch), by a typed read (`int(:port)`), and by the `std` schema. Lite's spec defines it once, as the value grammar of `<…>`; the other two are companions.

## Why this is more than relabeling (checked against the factors)

1. **The streaming cost lands on whoever chooses it** (`../checks/streaming-holdback.md`). A reader with a real schema knows each slot's kind before the value: kind-first, no holdback. A reader with `std` decides at each value's close, and a kind-first transcoder under `std` holds the undecided prefix, boundable by a cap that the `std` schema (not the grammar) can state. The grammar stays B1-clean however the reading question is answered.
2. **The traps go with the schema too.** `:version 1.10` → 1.1 under `std`, exactly as in JSON, TOML and YAML, which agents already know to quote. Under any real schema (`version: text`) it can't happen, and under no schema it stays ‹1.10›. A writer who opts into `std` opts into JSON's semantics, knowingly.
3. **A3 / A2 split cleanly.** A cold reader who assumes "`8080` is a number" is right under `std` and wrong only in the raw tree, which a typed reader never shows. A writer who writes `:port 8080` meaning a number gets a number from every consumer that brings a slot or `std`. The silent miss is confined to a consumer that applies no schema at all *and* wanted numbers: the D0 case.
4. **B3 holds.** One tree per document. Different readings by schema is what schemas are; the tree never varies.

## What Σ leaves to Joseph (and doesn't pretend to settle)

- **The default reading for a document that names no schema.** This is the only remaining form of the B-vs-C question, and it is no longer a grammar question. Options: `std` by default (B's ergonomics, JSON's traps); text by default (Cv's strings-by-default converter); or by convention, `std` when the file is named for data (taste: a generic schema name such as `*.data.ud`). **My lean: text by default in the API (the raw tree), `std` by default in generic converters to JSON/YAML.** The converter's whole job is to produce JSON, and JSON-trained writers meant `8080` as a number. Confidence low; it is a judgment about who gets surprised.
- **Whether `<…>` primitive marks are still needed.** Yes, for exactly one job: a writer asserting kind to a reader who brings no schema (and nil, which only a mark can spell under C). Under `std` they are redundant except `<>`/`<nil>` and forcing (`<"1.10">` is just `"1.10"`).

## Scores (hypotheses; where Σ differs from Cv)

Σ's tree and grammar are Cv's, so the grammar-side factors (A6, A7, B1, B2, B3, B5, B6, C10) score as Cv does. It differs on the reading side:

| Factor | Σ | Cv | Basis |
|---|---|---|---|
| A2 generative guessability (10) | 7 | 5 | `:port 8080` meaning a number is honored wherever `std` or a slot applies, which includes the generic converter under my lean |
| A5 domain-forward (9) | 8 | 7 | schema-less data needs no marks if it opts into `std` |
| A9 conciseness (6) | 7 | 5 | same |
| C1 structured data (10) | 7 | 5 | JSON round-trips under `std` (strict notation keeps `01234` text; `1.10` is JSON's own trap) |
| A6 spec clarity (9) | 9 | 9 | one notation, defined once, used three ways; the spec's spine stays "bare is text" |
| B4 errors that teach (8) | 7 | 7 | — |

**Verdict: survives**, as the frame in which Cv and B are one design read two ways. Confidence: medium. The risk I can see is a reader who doesn't know which schema a document is read under. That is the "self-description" factor A10 (5), deliberately low.

## Revisions after the forks reported

- **From `B`:** B keeps the spelling and says "slots read the spelling, not the kind", so under any schema B's kind is only advice. That makes B *exactly* Σ with `std` as the default reading, materialized in the tree. The remaining differences between them: whether fixtures and transcripts show the `std` kind (B: yes; Σ: no), and whether the grammar has to pass B1 on "characters until the kind is known" (B: fails on whitespace; Σ: the tree's kind is text, known at the first character). Σ moves the whitespace deferral out of the grammar and into the `std` reader, where it is a reader's choice.
- **From `core`:** its four-part test for the core (parameter-free, host-portable, collision-light, earns its grammar) defines `std`'s membership. Its strict spelling makes `std` lose nothing a writer likely meant as text (`01234` stays text). The float question (does the view read `1.10`?) becomes "does `std` include floats?", an open setting of the same schema.
- **From `Cv`:** the typed read (`int(:port)`) is the per-slot form of the same reading. Cv's strings-by-default converter is Σ with "text" as the default schema. So the one dial has four settings, and the debrief puts them side by side: `std` in the tree (B), `std` as the generic converters' default (Σ, my lean), `std` opt-in (Cv), no `std` at all (D0).
