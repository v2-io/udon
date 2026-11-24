# spec/.influx

Material brought in to be cut and placed into the spec. Nothing here is the spec. Files are kept as they arrived (`.md-pressignore` keeps md-press off them); each row says where a file came from, so a later mind can tell whether its source has moved since.

| Here | Copied from | Source version | Copied | Placed so far |
|---|---|---|---|---|
| `at-defs/*.ud` (7 files) | `~/src/address-theory/def/` (`github.com/v2-io/address-theory`) | commit `306e0ca` (2026-10-22), clean tree | 2026-11-20, byte-identical | nothing |
| `defining-udon.md` | `.archive/defining-udon.md` in this repository | as archived at `ba85d64` | 2026-11-20, byte-identical | nothing |
| `spec-lite-incoherences-2026-11-07.md` | the scratch notes of the session named "udon-lite-simplify" (Claude Fable 5.1, 2026-11-06 to 11-08, session `1edc52d1`), written after it read every rule card, definition card, objective and adr record of spec-lite-0.1.0 (sops skipped) | rebuilt from the two shell commands in that session's transcript that wrote it; the file itself, in that session's scratch directory, no longer exists | 2026-11-20 | nothing |
| `spec-notes.md` | lecture transcript on abstraction and specifications dropped at repo root by Joseph (2026-11-23) | moved unchanged from repo root | 2026-11-23 | nothing |
| `liskov-guttag-1986-insights.md` | reading notes on Barbara Liskov & John Guttag (1986), *Abstraction and Specification in Program Development* (`~/src/_ref/books/1986-liskov-guttag-abstraction-and-specification-B.djvu`), read against `udon` v2 and `verisectorium` by subagent `6c61de35` (2026-11-23 MST / 2026-11-24 UTC) | verbatim copy of scratch output; a verbatim copy with a provenance banner also lives at `~/src/verisectorium/msc/scratch/liskov-guttag-1986-insights.md` | 2026-11-23 | nothing |
| `transcript-JTEwC3HihFc.md` | timestamped, sentence-per-line transcript (with `[pause]` markers) of Michael Ryan Clarkson's CS 3110 lecture *Functional Programming - What* (`JTEwC3HihFc`), used for line-by-line experiential reading (2026-11-23) | moved unchanged from repo root | 2026-11-23 | nothing |
| `pedagogy-and-pacing-notes-2026-11-23.md` | working notes from the 2026-11-23 session comparing the spoken lecture transcript against the written textbook notes, on autobiographical surprisal and teaching-peer pacing | drafted directly in `spec/.influx/` | 2026-11-23 | nothing |
| `term-in-udon-refinements-2026-11-23.md` | Joseph's reaction, in this session, to a term definition written in UDON by the second OCaml spike: his rewritten example and his list of eight refinements, verbatim, with the recording session's notes on what each would touch | written directly here | 2026-11-23 | nothing |

Notes on `spec-lite-incoherences-2026-11-07.md`: it is one agent's reading, never reviewed by Joseph, and it describes spec-lite as of 2026-11-07 (no spec-lite file has changed since 2026-11-04). The card paths in it are relative to `.archive/v2/spec-lite-0.1.0/`.

Notes on `at-defs/`:

- In address-theory all seven term groups are `:status proposed`. Its `PRACTICA.ud` (updated 2026-10-09) lists proposed fixes to them awaiting Joseph's review (`inf/DEF-FIXES-PROPOSED-2026-10-09.md` there); those fixes are not applied in these copies and were not copied.
- They are written as term groups in an earlier udon. The term kind here (`spec/.kinds/term.kdl`) is one term per file, so a group placed here is split.
