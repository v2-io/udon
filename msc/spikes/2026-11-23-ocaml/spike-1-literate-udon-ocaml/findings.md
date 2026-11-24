# Spike 1 Findings: Literate UDON Container over Standard OCaml

## What Was Built & Verified

All artifacts live in this directory (leaving `udon` and `verisectorium` git trees untouched):

- [`udon_ast.ud`](./udon_ast.ud) (847 lines) — A literate UDON v2 document modeling **UDON Part 1: Foundation AST Bounded Context** (`«Udon»`, `«AST»`, `«node»`, `«element-name»`, `«element»`, `«text»`, `«attribute»`, `«value»`, `«partial»`, `«document»`, `«root»`), grounded in `udon/spec/{canonical.outline.md, PRAXIS.md, def/{AST,element,root}.md, DECISIONS.kdl}`. Written in **human comprehension order** (`AST` → `node` → `element-name` → `element` → `text` → `attribute` → `value` → `partial` → `document` → `root` → observer-set equality), carrying prose, `|decision[...]` provenance records, `|contract` (`.mli`), `|impl` (`.ml`), `.shared` transparent types, executable `|invariant[...].ie` checks, executable `|example[...].eg` tests, and `|working-notes`.
- [`udon_lit.ml`](./udon_lit.ml) — Zero-dependency OCaml 5.5.2 prototype implementing:
  1. An indentation-sensitive UDON v2 subset parser (including `def-fence.md`'s element-line fence openers and `rule-fence-body-dedent`'s first-non-blank-line dedenting with `.exact` override).
  2. Multi-projection tangler emitting `gen/udon_ast.mli` (Consumer), `gen/udon_ast.ml` (Implementer), and `gen/udon_ast_verify.ml` (Verification), with `# <line> "udon_ast.ud"` directives, `:layout` section ordering, `:join-type-rec` / `:join-let-rec` mutual-recursion joining, `.shared` dual-target emission, and `:auto-runner true` automatic check registration.
  3. Verisectorium ubiquitous-language & coverage auditor (`«term»` resolution with `:pl`/`:forms`/`«shown|term»`, `:avoid` linting in normative prose, and a computed per-term standing/coverage summary).
- [`gen/`](./gen/) — Generated & compiled OCaml artifacts (`udon_ast.mli`, `udon_ast.ml`, `udon_ast_verify.ml`, and compiled `.cmi`/`.cmo`/executable).
- [`build.sh`](./build.sh) — One-command build, tangle, audit, compile (`ocamlc -g`), and test execution.
- [`run_probes.sh`](./run_probes.sh) — Five deliberate failure probes testing real error paths on temporary mutated copies (type/signature mismatch, abstraction leak, runtime invariant failure with backtrace, ubiquitous-language violation, and multi-line string indentation hazard).

### Verified Run Output (`./build.sh`, exit 0)
- **50 OCaml chunks** (7 `.shared`, 10 `.mli`, 20 `.ml`, 7 `.check`, 6 `.test`) tangled cleanly into `gen/udon_ast.mli` (17 chunks), `gen/udon_ast.ml` (27 chunks), and `gen/udon_ast_verify.ml` (13 chunks).
- **Verisectorium audit:** 4 decisions (all with verbatim `:words`), 11 terms, 7 executable `I.e.` invariants (5 standalone + 2 parameterized helpers invoked by examples), 6 executable `E.g.` examples, 3 open `|working-notes` items, 0 undefined `«terms»`, 0 `:avoid` violations.
- **`ocamlc -g` compilation & execution:** Consumer `.mli`, Implementer `.ml`, and `udon_ast_verify` compiled cleanly and passed all **11 auto-registered checks** in well under a second.

---

## 1. What Felt Unexpectedly Clean, Ergonomic, or Powerful

### A. OCaml's `.mli` / `.ml` split maps almost 1:1 onto `PRAXIS.md`'s Consumer vs. Implementer projections
Keeping `|contract` (`.mli`) and `|impl` (`.ml`) side by side inside each `|term[...]` — instead of scattered across `spec/def/element.md`, `udon_ast.mli`, `udon_ast.ml`, and `test_ast.ml` — felt genuinely cohesive.
- `type element`, `type partial`, and `type document` are **opaque** in `.mli` and concrete in `.ml`. In **Probe 2**, attempting `el.Udon_ast.el_attrs` from an `E.g.` test failed at compile time with:
  ```
  File "_probe_tmp/p2.ud", line 451, characters 13-30:
  Error: Unbound record field Udon_ast.el_attrs
  ```
  That enforces `PRAXIS.md`'s **Abstraction Integrity** mechanically: AST consumers physically cannot depend on internal attribute storage order (`StringMap`).
- Even better, in **Probe 1** (mutating `let element_name e = 123` in `.ml`), `ocamlc` pointed to **both** the Consumer contract and the Implementer body inside the **same `.ud` file**:
  ```
  File "_probe_tmp/p1.ud", line 288, characters 6-55:
    Expected declaration
  File "_probe_tmp/p1.ud", line 359, characters 10-22: Actual declaration
  ```

### B. `.shared` unexpectedly eliminates OCaml's worst boilerplate papercut
While authoring `udon_ast.ud`, copy-pasting transparent ADTs (`type node`, `type attribute`, `type value`, `type span`, `type meta`, `type ast`, `type file_metadata`) identically into both `|contract` and `|impl` immediately felt painful. Adding a `.shared` trait on the fence (routed to both `udon_ast.mli` and `udon_ast.ml`) fixed it in ~5 lines of tangler code:
- Transparent data definitions live **once** in `.ud` and emit to both `.mli` and `.ml` with `# <line>` pointing to that single definition.
- Opaque abstractions (`element`, `partial`, `document`) stay explicitly split between `|contract` and `|impl`.
This is a concrete ergonomic advantage of a literate `.ud` container *over* plain `.mli`/`.ml` files.

### C. UDON v2's element-line fences (`def-fence.md`) + OCaml have zero lexical collisions
Because UDON v2 fence openers parse like element lines (` ```ocaml[element-sig].mli :section types-rec `) and never scan the body:
- OCaml's `|`, `:`, `;`, `'a`, `` `Poly ``, and `(* ... *)` pass through untouched.
- Triple backticks never occur in OCaml syntax (and if an OCaml raw string literal ever contains ` ``` `, UDON's `N >= 3` backtick nesting handles it cleanly).
- OCaml's `# <line> "file.ud"` directive works even **mid-declaration** inside `type ... and ...` and `let rec ... and ...` blocks, and feeds both `ocamlc` type diagnostics and `OCAMLRUNPARAM=b` runtime backtraces (Probe 3: `Fatal error: exception Assert_failure("_probe_tmp/p3.ud", 391, 2)`).

### D. Auto-registered `I.e.` invariants & `E.g.` examples prevent silent test omission
With `:auto-runner true`, every non-`.helper` `.check` fence inside `|invariant[id].ie` and `.test` fence inside `|example[id].eg` is automatically wrapped and registered in `udon_ast_verify.ml` with its `.ud` line number. You cannot add an executable invariant or example to the prose and forget to wire it into a runner.

### E. One parse drives both compilation and Verisectorium/DDD checks
From the same `.ud` AST, `udon_lit` computes per-term projection coverage, counts executable `I.e.`/`E.g.` checks and open `|working-notes`, checks decision `:words` provenance, and catches undefined `«terms»` (Probe 4: `_probe_tmp/p4.ud:256: undefined term «widget»`).

---

## 2. Real Friction, Awkwardness, & Diminishing Returns

### A. Comprehension order vs. OCaml declaration order forces two mental models
Presenting `«AST»` before `«node»` before `«element»` works, *but* only by tagging fences with `:section` buckets (`preamble`, `types-rec`, `types-derived`, `helpers`, `eq-rec`, `values`), declaring a `|tangle` `:layout` map, and using `:join-type-rec` / `:join-let-rec` to rewrite leading `type ` / `let rec ` into `and `.
- **Friction:** The author has to keep both narrative order and OCaml's dependency/mutual-recursion buckets in mind. Put a chunk in the wrong `:section` and you get an `Unbound type` error whose root cause is `:layout` ordering rather than the local code.
- **Scaling limit:** `:join-type-rec` / `:join-let-rec` cleanly handles top-level mutual recursion while keeping each fence valid standalone OCaml, *without* needing ugly `and foo = ...` fragments in `.ud`. Going further (splicing sub-expressions inside function bodies like `noweb` `<<chunk>>`) would break standalone readability of fences.

### B. Standard UDON fence dedenting vs. `ocamlc` column fidelity (empirically proven tradeoff)
Because fences sit nested inside `|context` → `|term` → `|impl` (column 6+), two behaviors collide:
- **Standard UDON dedenting (`rule-fence-body-dedent`):** produces clean, readable `.ml` files and keeps multi-line OCaml raw strings intact (Probe 5: `"line1\nline2"`), **but shifts `ocamlc` character columns left by `dedent`** (Probe 1: `characters 0-49` instead of `6-55`).
- **`--preserve-indent`:** gives exact `.ud` column numbers in `ocamlc` because OCaml is indentation-insensitive (Probe 1: `characters 6-55`), **but silently corrupts indented multi-line OCaml strings** (Probe 5: `"line1\n    line2"`!).
- **Two extra `# <line>` quirks noticed empirically:**
  1. `ocamlc` suppresses its inline contextual source-code underline excerpt whenever `# <line>` redirects to a filename different from the `.ml` file being compiled.
  2. `# <line>` **bleeds into generated glue code** if you forget to reset it! On our first run of Probe 3, the generated `let () =` runner frame falsely reported `_probe_tmp/p3.ud:744` because the preceding test chunk had set `# 731 "p3.ud"`. Adding `# 1 "udon_ast_verify.ml (generated runner)"` before synthesized code fixed it cleanly.

### C. Prose `:avoid` linting is much noisier than `«term»` resolution
- `«term»` resolution (against `|term[id]` + `:pl` + `:forms` + `«shown|term»`) had zero false positives and felt rock-solid.
- Word-level `:avoid` linting immediately false-positived on our own line 108 (`"Abstract Syntax Tree"` tripped `|term[AST] :avoid [tree]`)! Exempting declared `:synonyms` fixed that specific case, *but* `spec/def/AST.md`'s real rule is contextual (`avoid "tree" "as a term of its own; the «AST» is the tree"` — phrases like `"in the tree sense"` are deliberately allowed). Mechanical `:avoid` checks should probably be advisory warnings, not hard gates, unless `:avoid` carries structured context/exceptions.

### D. Single-file size & IDE/LSP gap
- **Size:** Even for just 11 Part 1 terms, `udon_ast.ud` is 847 lines — noticeably heavier than `DECISIONS.kdl`'s `one-term-per-file` lean (`spec/def/<term>.md`).
- **Tooling (architectural note, not directly measured since we used `ocamlc` only):** `ocamlc` gives sub-second batch feedback (ideal for agent loops), but human interactive editing inside `.ud` fences loses `merlin` / `ocaml-lsp` hover, autocomplete, and `ocamlformat` unless an editor bridge or LSP proxy exists.

---

## 3. Surprises & Adjacent Ideas That Popped Out

1. **Outline-driven multi-file tangling (reconciling `one-term-per-file` with OCaml modules):**
   Nothing in `udon_lit` requires one monolithic `.ud` file. A tangler could take a **verisectorium canonical outline** referencing small per-term files (`def/AST.ud`, `def/element.ud`, `def/root.ud`) and assemble them into one `udon_ast.mli` / `udon_ast.ml` / `udon_ast_verify.ml` — with `# <line> "def/element.ud"` pointing errors straight to the individual term file! That keeps files small, preserves `one-term-per-file`, and still gives OCaml's module-level abstraction boundary.
2. **Cross-checking `|rels` against inferred `.cmi` / OCaml types:**
   In `udon_ast.ud`, `|term[element]` declares `|rels :has «attribute» {0,N} :has-child «node» {0,N}` right above `val attr_values : element -> string -> value list` and `val children : element -> node list`. Parsing `ocamlc -i` output (or `.cmi` metadata) could mechanically verify that the DDD ubiquitous-language relation graph and the OCaml module signature haven't drifted apart.
3. **Dedent-aware diagnostic remapper:**
   Because UDON v2 already preserves `dedent` per fence in AST metadata (`rule-fence-dedent-in-meta`), keeping standard UDON dedenting + emitting a tiny JSON/line map lets a ~20-line wrapper around `ocamlc` stderr add `dedent` back to `characters A-B` and render the exact `.ud` source underline — solving the Probe 1 / Probe 5 tradeoff cleanly without breaking multi-line strings.
4. **Bottom-line assessment of Spike 1's direction:**
   As a **verisectorium-native literate container**, UDON + standard OCaml already feels *surprisingly real* rather than gimmicky — specifically because OCaml's `.mli`/`.ml` boundary, opaque types, exhaustive ADTs, `# <line>` directives, and sub-second `ocamlc` loop reinforce what `PRAXIS.md` and verisectorium are trying to do (Consumer vs. Implementer projections, marked `I.e.`/`E.g.` cross-register redundancy, repeatable checks). Its main costs are **`:layout`/`:section` plumbing** for comprehension-order tangling and **loss of native OCaml LSP inside fences**; its biggest surprise win is **`.shared` eliminating `.mli`/`.ml` transparent-type duplication** while keeping opaque abstractions strictly enforced.
