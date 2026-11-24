# Spike 2 Findings — UDON as a DDD Schema & Algebraic Data Language (1:1 Nouns → OCaml ADTs)

## What Was Built & Verified Live (`ocamlc` 5.5.2)

Everything in this directory compiles and runs end-to-end via `python3 run_spike.py`:

- **Generic UDON → OCaml compiler** (`udon2ml.py`): indentation-aware UDON parser (faithful to `spec/def/element.md`: optional `«element-name»`, `$key` `[id]`, `$traits` `.a.b`, `$main`, unordered & repeated `:attributes`, indented element-valued attributes, ordered children, prose with inline `@{ref}` extraction, and `# line "file.ud"` directives) + schema compiler (`*.schema.ud` → `.mli`/`.ml`) + data lowerer (`*.ud` → `.mli`/`.ml`).
- **Two cooperating DDD Bounded Contexts defined in UDON**:
  - `schemas/verisectorium.schema.ud` → `build/verisectorium.{mli,ml}` (from `verisectorium` Note 30: `piece`, `outline`, `slot`, `act`, `decision-how`, `attribution`, `reliance`, disjoint trait axes `.draft | .accepted` and `.working | .deliverable`, additive traits `.repeatable .steward-words .derived`).
  - `schemas/udon_spec.schema.ud` → `build/udon_spec.{mli,ml}` (from UDON v2 `canonical.outline.md`, `spec/def/{AST,element,root}.md`, `term.kdl`, and `def-{binding,reference}.ud`: `term`, repeated `:pos+`, native `{min,max}` `card`, recursive `ast-node`, and cross-context `:backing @verisectorium:piece?`).
- **Two concrete valid UDON stores** (`data/verisectorium_store.ud`, `data/udon_part1.ud`) lowered to OCaml, compiled cleanly with `ocamlc`, and checked by `checks.ml` (0 findings).
- **11 deliberate breakage cases** (`broken/01_*.ud` through `broken/08_*.ud`), each verified live across three distinct catching layers.

---

## 1. Where the 1:1 Correspondence Felt Genuinely Uncanny

### A. `|element :attr val` ↔ OCaml Inline-Record Variants (`| Ctor of { ... }`)
The correspondence is nearly literal — down to the `|` sigil and **unordered attribute literals**:
- In OCaml, `{ by = "Joseph"; how = Ruling }` and `{ how = Ruling; by = "Joseph" }` are the exact same value, directly satisfying UDON's `def/element.md` invariant (*"Two «elements» that differ only in the order their «attributes» were written are the same «element»"*) for every schema-typed element.
- Passing undeclared attributes straight through to the OCaml record literal lets `ocamlc` itself catch both missing required attributes and typos without re-implementing a type-checker:
  ```text
  File "broken/04a_unknown_attr.ud", line 14, characters 4-9:
  Error:   The field metod is not part of the record argument for the Verisectorium.act.Checked constructor
  Hint: Did you mean method_?
  ```
  ```text
  File "broken/04b_missing_required.ud", lines 13-14, characters 25-3:
  Error: Some record fields are undefined: how
  ```

### B. `[id]` (`$key`) → Typed OCaml Entity Witnesses (`let piece_p_ast_def : ...`)
Joseph's `[variable-binding]` intuition landed even harder than expected. Splitting data lowering into two passes — Pass 1 minting typed `let` witnesses for every `[id]`, Pass 2 emitting the records — bought four things at once:
1. **Forward references work freely** (matching `DECISIONS.kdl`'s `outline-order-is-for-comprehension`: `p-ast-def` references `@[p-element-def]` declared below it).
2. **Compile-time entity-kind safety**: passing an `Outline` ID into `:about` (`broken/02_wrong_entity_kind.ud`) is caught directly by `ocamlc`:
   ```text
   File "broken/02_wrong_entity_kind.ud", line 18, characters 12-32:
   Error: The value outline_working_spec has type
            [ `Working ] Verisectorium.Outline.id = [ `Working ] Verisectorium.outline_id
          but an expression was expected of type
            Verisectorium.piece_any_id = [ `Accepted | `Draft ] Verisectorium.piece_id
   ```
3. **Compile-time checking of prose-embedded Ubiquitous Language references**: scanning prose lines (and `$main`) for `@{slug}` and lowering them into `prose_refs : Term.any_id list` meant a prose sentence citing an undefined `@{block}` (literally Note 30 §3's example!) failed `ocamlc` at the exact `.ud` line (`broken/01_dangling_prose_term.ud`):
   ```text
   File "broken/01_dangling_prose_term.ud", line 13, characters 6-16:
   Error: Unbound value term_block
   ```
4. **`# line "file.ud"` directives** make `ocamlc` report diagnostics directly against `.ud` filenames and line numbers. *(Honest caveat: character offsets still refer to the generated OCaml line, not the `.ud` column.)*

### C. Disjoint Trait Axes (`.draft` | `.accepted`) → Covariant Phantom Types (`type +'s id`)
Using OCaml covariant polymorphic-variant phantom types (`type +'s piece_id` abstract in `.mli`, `= string` in `.ml`, with `type piece_any_id = [ `Draft | `Accepted ] piece_id`) gave:
- Zero runtime boxing overhead and normal `=` equality.
- Zero-cost upcasting `(id :> Piece.any_id)` for heterogeneous lists.
- **Compile-time state enforcement** directly from a single dot-trait: declaring `|settled :piece @piece.accepted` in `verisectorium.schema.ud` made `broken/03_draft_in_settled_slot.ud` fail `ocamlc`:
  ```text
  File "broken/03_draft_in_settled_slot.ud", line 16, characters 12-28:
  Error: The value piece_p_root_def has type
           [ `Draft ] Verisectorium.Piece.id = [ `Draft ] Verisectorium.piece_id
         but an expression was expected of type
           [ `Accepted ] Verisectorium.piece_id
         These two variant types have no intersection
  ```

### D. DDD Bounded Contexts ↔ OCaml `.mli` Module Encapsulation
Because `Verisectorium.Piece.id` is abstract in `verisectorium.mli`, `udon-spec` can reference `Verisectorium.Piece.any_id` across the boundary (e.g., `:backing @v:p-element-def`) without being able to forge one or accidentally substitute its own `Term.id` (`broken/05_cross_context_leak.ud`):
```text
File "broken/05_cross_context_leak.ud", line 13, characters 19-33:
Error: The value term_element has type
         [ `Accepted ] Udon_spec.Term.id = [ `Accepted ] Udon_spec.term_id
       but an expression was expected of type
         Verisectorium.Piece.any_id = [ `Accepted | `Draft ] Verisectorium.piece_id
```

### E. Exhaustive Pattern Matching Keeps Executable Invariants Honest
Global/relational invariants that don't fit static types (maker ≠ checker, Note 30 §10's refuted-ground → unsettled-decision → unsettled-rule propagation, reliance cycles, symmetric `:dual`, `|avoid` collisions) live in `checks.ml` (`broken/07` & `broken/08`). Because `checks.ml` pattern-matches exhaustively over the generated ADTs, adding a new `decision-how`, `act`, or `reliance-kind` in `.schema.ud` immediately causes `ocamlc` to flag every check function that forgot to account for it.

---

## 2. Where UDON Clashed with OCaml (Honest Friction Catalog)

These were **real** clashes encountered directly while building and compiling:

1. **Schema-blind 1:1 lowering is NOT enough for typed ADTs.**
   To emit valid OCaml records/variants from `.ud` data, `udon2ml.py` *had* to consult the schema to know: which omitted attributes are optional (`T?` → `None`) vs. required (left out so `ocamlc` errors), which attributes are multi-valued (`:pos noun` + `:pos verb` → `Nonempty (Noun, [Verb])`), which bare tokens are enums (`lean` → `Lean`), and which entity refs need covariant upcasting (`:> any_id`). Pure syntax-only UDON → OCaml only gets you a generic untyped AST.
2. **Anonymous UDON elements (`|`, `|[id]`, `|.trait`) have no OCaml ADT constructor.**
   UDON v2 (`spec/def/element.md`) explicitly allows nameless elements. OCaml variants strictly require a capitalized constructor name. In a strict DDD schema, anonymous elements must either be rejected (`broken/06c_anonymous_element.ud`) or routed to a synthetic `Anon` constructor.
3. **Heterogeneous ordered children vs. ergonomic DDD child fields.**
   UDON's `def/element.md` gives every element ONE strictly ordered heterogeneous child list (`|rel`, prose, `|invariant`, prose). We had to support *two* lowering modes:
   - `|children-ordered slot` (single `slot list` — 100% lossless order, great for `|outline` and `|ast-node`, awkward if free prose is interleaved unless prose is a variant constructor too).
   - `|children` partitioned slots (`avoid_items`, `rel_items`, `invariant_items`, `example_items`, `prose` on `|term`) — super ergonomic for domain code, **but silently discards cross-kind interleaving order**.
4. **Generic AST unordered attributes break OCaml polymorphic `=`.**
   Verified live in `run_valid.ml`: for `ast_element` with `attrs : ast_attr list`, two ASTs differing only in attribute order (`$key` before `role` vs. `role` before `$key`) returned `Checks.ast_equal a b = true`, while raw OCaml `a = b` returned `false`. Using `StringMap.t` breaks clean literal syntax *and* still fails polymorphic `=` on differently balanced trees; you genuinely need a custom equality observer (matching `PRAXIS.md` Rule 2's `partitioned by` observer sets!).
5. **OCaml `let`-shadowing silently swallows duplicate `[id]` keys.**
   Two `|piece[p1]` elements lowered to two `let piece_p1 = ...` bindings would silently compile in OCaml! Uniqueness cannot be delegated to `let`-bindings — the translator had to guard it explicitly (`broken/06b_duplicate_key.ud`). *(Alternative: emitting IDs as constructors of a closed variant or fields of a record would let `ocamlc` reject duplicates natively, at the cost of less ergonomic multi-file composition.)*
6. **Identifier mangling & OCaml reserved keyword leakage.**
   - Kebab-case → snake_case (`-` → `_`) creates a collision hazard if a schema ever has both `:foo-bar` and `:foo_bar` (translator checks this).
   - Real domain names collided with OCaml keywords immediately: `def-binding.ud`'s `:to` became `to_`, and Verisectorium's `:method` became `method_` — and `ocamlc` leaked `Hint: Did you mean method_?` straight back to the UDON author (`broken/04a_unknown_attr.ud`).
7. **OCaml's acyclic module graph vs. `one-term-per-file` (`DECISIONS.kdl`).**
   Within one file, two-pass lowering + mutually recursive `type ... and ...` handled forward references effortlessly (both `rel-entry` before `entity[term]` in schemas and `p-ast-def` before `p-element-def` in data). **Across files**, however, OCaml forbids circular module dependencies (`reference.ml` ↔ `referent.ml`). If UDON uses one file per term with mutual `:dual` links, a Bounded Context's directory must lower either into one combined OCaml module OR into a two-stage layout (`<ctx>_ids.ml` minted across all files first, then per-file body modules).
8. **Multi-axis traits & additive traits don't scale cleanly as phantom types.**
   One disjoint trait axis (`.draft | .accepted`) mapped cleanly to `type +'s id`. Additive traits (`.repeatable.steward-words.derived`) fell back to a runtime `trait list` (no compile-time dedup or capability check). Multiple disjoint axes on one entity would require multi-parameter phantom types `('s, 'm) id` or object-row encodings, where OCaml error messages quickly degrade.
9. **Repeated attributes vs. single-valued fields & open/extra attributes.**
   OCaml records are closed and single-valued per field. Closedness is great for DDD Ubiquitous Language enforcement, and declared multi-valued attributes (`pos+` → `pos nonempty`) folded cleanly, but any schema wanting open extension attributes needs an explicit `extra : (string * value) list` escape hatch.

---

## 3. Surprises & Unexpected Payoffs for DDD / UDON / Verisectorium

1. **The Three-Layer Division of Labor Is Remarkably Clean.**
   - **Layer 1 (Translator — `udon2ml.py`, 1,395 lines including parser + schema compiler + data lowerer):** UDON-specific shape rules OCaml can't express (`[id]` uniqueness, disjoint trait-axis sanity, anonymous elements, kebab/keyword collision checks, sugar folding).
   - **Layer 2 (`ocamlc` — zero custom type-checker code!):** Schema conformance, missing/typo attributes, entity-kind safety, phantom-typed state rules (`.accepted` in `|settled`), prose-embedded `@{term}` resolution, and Bounded Context `.mli` isolation — all reported at exact `.ud` lines.
   - **Layer 3 (Compiled OCaml invariants — `checks.ml`, 274 lines):** Relational/graph/domain laws (asymmetric `:dual`, `|avoid` collisions, `maker != checker`, Note 30 §10's transitive unsettled-grounds propagation, weak-decision downstream load, reliance cycles) protected by exhaustive pattern matching against the schema.
2. **Prose-embedded `@{term}` / `«term»` checking is a killer app for `udon/spec/` and `verisectorium`.**
   Extending the prose scanner to recognize `«term»` (using declared `:pl` / verb forms from `term.kdl`!) would let `ocamlc` catch undefined or mis-spelled spec terms inside ordinary Markdown/UDON prose in milliseconds.
3. **Verisectorium's "held as fact, computed on demand" architecture (Note 30 §§7–8) is a natural match for UDON + OCaml.**
   Authoring immutable facts (`|piece`, `|outline`, `|made`, `|checked`, `|decided`, `|knowingly-left`) in prose-friendly UDON and compiling them into typed OCaml ADTs for pure functional rest/frontier computation avoids hand-maintained `status` drift *and* guarantees every act/decision record conforms to the store's Ubiquitous Language before it ever lands.
4. **Even `Deliverable` outline rules could move from Layer 3 → Layer 2 if desired.**
   Right now `|settled` enforces `.accepted` at Layer 2 (`ocamlc`), while forbidding `|on-approval` inside `.deliverable` outlines was checked in Layer 3 (`checks.ml`). Parameterizing `slot` by outline scope (`'scope slot`) would move that rule into `ocamlc` too — a clear illustration of the dial between simple ADTs + Layer 3 checks vs. fancier phantom/GADT encodings at Layer 2.

---

## Files in This Spike Directory

- `udon2ml.py` — Generic UDON parser, schema → `.mli`/`.ml` compiler, and data → `.mli`/`.ml` lowerer
- `schemas/verisectorium.schema.ud`, `schemas/udon_spec.schema.ud` — DDD Bounded Context schemas in UDON
- `data/verisectorium_store.ud`, `data/udon_part1.ud` — Valid concrete UDON stores
- `checks.ml`, `run_valid.ml` — Compiled OCaml Ubiquitous Language invariant checkers
- `broken/01_*.ud` … `broken/08_*.ud` — 11 deliberate breakage cases covering all three layers
- `run_spike.py` — One-command reproducible verifier (`python3 run_spike.py`)
- `build/` — Generated `.mli`/`.ml` artifacts and compiled `.cmi`/`.cmo`/executables
