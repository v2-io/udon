---
source: ~/src/_ref/_arch/sar/indent-languages.md — a prior-art comparison matrix of indentation-based languages (Python / Nim / Haskell / F# / CoffeeScript), from the FULLER `sar` repo the §7 map rows missed
gathered: 2026-07-21
status: gathered (verbatim whole copy)
paths:
  - /Users/josephwecker-v2/src/_ref/_arch/sar/indent-languages.md
source_commit: (git repo, non-submodule) SHA 3840e23; source_mtime 2025-11-11
categories: [notation-design, prior-art-survey, indentation-based-languages, competitive-landscape, human-ux, tier2-shipped-practice]
why_included: >
  Prior-art survey of exactly UDON's notation family — the indentation-significant
  languages — compared across the dimensions a new notation must decide: function
  keyword, lambda syntax, string literals (incl. interpolation forms), type system,
  comment syntax, list/array literals, and method-call style (dot vs UFCS vs
  juxtaposition). This is the competitive-landscape homework behind SAR's (and by
  lineage UDON's) design choices, done by Joseph one project over. Directly useful
  to UDON's own design record: where UDON's indentation model, comment sigil (`;`),
  string/interpolation, and list forms sit relative to the established indentation-
  language design space. NOTE (surfaced below): this file lives in the bare `sar/`
  repo, which the §7 mining map did not cover — see the II7-ref-arch witness file's
  "map gap" flag.
---

| Feature          | Python           | Nim              | Haskell          | F#               | CoffeeScript     |
|------------------|------------------|------------------|------------------|------------------|------------------|
| Paradigm         | Multi-paradigm   | Multi-paradigm   | Pure functional  | Functional-first | Multi-paradigm   |
|                  | (OO, functional) | (imperative, OO) | (lazy)           | (OO, imperative) | (OO, functional) |
|------------------|------------------|------------------|------------------|------------------|------------------|
| Function keyword | def              | proc/func/method | (no keyword)     | let              | (no keyword)     |
|                  |                  | iterator/macro   | Pattern match    |                  | Optional ->      |
|------------------|------------------|------------------|------------------|------------------|------------------|
| Lambda syntax    | lambda x: x + 1  | proc(x: int) =   | \x -> x + 1      | fun x -> x + 1   | (x) -> x + 1     |
|                  |                  | x + 1            |                  |                  | or: (x) => x + 1 |
|------------------|------------------|------------------|------------------|------------------|------------------|
| String literals  | 'x' or "x"       | "x" only         | "x" only         | "x" only         | 'x' or "x"       |
|                  | f"val={x}"       | &"val={x}"       | (via libs)       | $"val={x}"       | "val=#{x}"       |
|                  | """multi"""      | """multi"""      | (concat lines)   | """multi"""      | """multi"""      |
|------------------|------------------|------------------|------------------|------------------|------------------|
| Type system      | Dynamic          | Static           | Static           | Static           | Dynamic          |
|                  | (gradual w/hints)| (inferred)       | (inferred)       | (inferred)       |                  |
|------------------|------------------|------------------|------------------|------------------|------------------|
| Comments         | #                | #                | --               | //               | #                |
|                  |                  |                  | {- multi -}      | (* multi *)      | ### multi ###    |
|------------------|------------------|------------------|------------------|------------------|------------------|
| List/Array       | [1, 2, 3]        | @[1, 2, 3]       | [1, 2, 3]        | [1; 2; 3]        | [1, 2, 3]        |
|                  |                  |                  | (linked list)    | (semicolons!)    |                  |
|------------------|------------------|------------------|------------------|------------------|------------------|
| Method calls     | obj.method(x)    | obj.method(x)    | method obj x     | obj.Method(x)    | obj.method(x)    |
|                  |                  | method(obj, x)   | (no dots)        | obj.Method x     | obj.method x     |
|                  |                  | (UFCS)           |                  | (pipes common)   | (parens optional)|