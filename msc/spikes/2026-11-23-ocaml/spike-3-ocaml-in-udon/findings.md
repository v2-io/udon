# Spike 3 Debrief: Full "OCaml Written in UDON" (1:1 Nouns and Verbs)

**Artifacts in this directory** (all run live on OCaml 5.5.2 + Python 3.15.2):
- `udon2ml.py` (1,734 lines) — Prototype UDON v2 parser + 1:1 OCaml lowerer + `@{ref}` ubiquitous-language checker + `# line` source-map emitter + `ocamlc` runner.
- `udon_part1_spec.ud` (526 lines) → `udon_part1_spec.ml` (744 lines) → `udon_part1_spec.byte` — Executable, prose-interleaved formalization of UDON's own Part 1 AST (`spec/def/{AST,element,root}.md`, `spec/PRAXIS.md`): `|sig[UDON-AST]`, `|module[UdonAst] :sig UDON-AST`, mutually recursive ADTs/records/inline-records, `$root` document construction, layered observer-set equality (`ContentOnly` vs `ContentAndOrnament`), recursive invariant validation, tree queries, transcript rendering, and 5 runnable `|test[...]` conformance checks. Zero tuples, zero raw OCaml fences.
- `diagnostics_probe.ud` (19 lines) → `diagnostics_probe.ml` — Negative test verifying live `@{ref}` checking, `ocamlc -w +8` exhaustiveness warnings, and type errors mapped back to `.ud` lines.

**Live run verification (`python3 udon2ml.py --run --strict-refs udon_part1_spec.ud`):**
- Lowered cleanly to 744 lines of OCaml; **51/51** `@{...}` ubiquitous-language prose references resolved against declared OCaml symbols.
- Compiled under `ocamlc -w +8` with **0 errors, 0 warnings** (full pattern-match exhaustiveness checked).
- Executed `udon_part1_spec.byte`: **5/5** conformance tests passed (`attribute-order-invariance`, `stacked-attribute-values-preserve-order`, `child-order-is-strict`, `layered-observer-equality-comments`, `document-root-and-invariants`).
- Sample rendered output:
  `|$root :$file "spec.ud" { |user :$key "jw" :$traits "admin" "active" { Text("Joseph"); Fence.exact("1 + 1") } }`

---

## 1. What Felt Surprisingly Clean (and Sometimes *Better* Than Raw OCaml)

1. **ADTs, Records, Inline Records, and Module Signatures (`|sig`, `|type.variant`, `|type.record`, `|Fence.record`)**
   This is where the 1:1 correspondence genuinely sings. UDON's `|` element sigil is *already* OCaml's sum-type constructor sigil, and `:field type` attributes map directly onto both record fields and OCaml inline-record constructors (`udon_part1_spec.ud` L14–86):
   ```udon
   |type[node].variant.and
     Any vertex in a UDON AST.
     |Element :of element
       A structured @{element} vertex.
     |Comment :of string
       A comment preserved in the raw tree; invisible to `ContentOnly` equality.
     |Fence.record
       A fenced verbatim block whose body is never scanned for UDON syntax.
       :tag   string option
       :exact bool
       :body  string
   ```
   Prose lives bare inside signatures, types, constructors, and functions with zero `(** ... *)` ceremony — and automatically lowers to odoc comments while the compiler verifies every `@{symbol}` reference against declared OCaml bindings (`diagnostics_probe.ud:4` caught `@{phantom-concept}` immediately). For DDD ubiquitous-language specs, this felt *materially better* than raw OCaml.

2. **Single-Scrutinee Pattern Matching with Joseph's `|Ctor[binding] :field pat` Mapping**
   `|Element[e]`, `|Fence :tag t1 :exact x1 :body b1`, and `|Fence.partial :exact ex :body b` (lowering `.partial` to `{ exact = ex; body = b; _ }`) read naturally and stay faithful to UDON's head/key/trait/attribute grammar. Short arms (`:is expr`) and prose-commented multi-line arms compose well.

3. **OCaml Labeled Arguments Mapped to UDON `:attr val`**
   An unexpected Lego-brick fit: `|fn[make-document] :labeled [file-path partial]` lowers to `~file_path ~partial`, so call sites look like pure UDON data:
   ```udon
   |make-document :file-path "spec.ud" :partial [ |{Element user-el} ]
   ```
   Lowers to `make_document ~file_path:"spec.ud" ~partial:[Element user_el]`.

4. **Flat Sibling `|let` Chains and `|pipe` Pipelines**
   Treating leading `|let[...]` siblings inside a block as `let ... in` eliminates rightward drift (`equiv-element` L245–255), and `|pipe` with indented stage children (`filter-children` L192–204, `render-element` L408–426) feels arguably cleaner than repeating `|>` on every line.

5. **Executable `|test[...]` Spec Blocks & `# line "file.ud"` Diagnostics**
   Interleaving spec-invariant prose directly above executable assertions worked well. Emitting OCaml `# <line> "<file.ud>"` directives worked better than expected: `ocamlc -w +8` on `diagnostics_probe.ud` reported both `Warning 8 [partial-match]` (`lines 13-16`, missing `Gap`) and the type error (`line 19`, `string` vs `int`) directly against `.ud` line numbers, and `ocamlc` automatically suppressed misaligned source-snippet quoting when the directive pointed to a `.ud` file.

---

## 2. Where UDON Syntax Genuinely Fought OCaml Semantics

To keep this honest, `udon2ml.py` enforces UDON v2's real grammar (`peg-2026-10-21.md` and `labels-ascii-and-positions-2026-10-20.md`) rather than hacking around it. Doing so immediately exposed **six concrete points of friction** — several of which tripped me *live* while writing `udon_part1_spec.ud`:

1. **Prose-Mode vs. Expression-Mode Collision (The Fundamental Tax)**
   In UDON, any bare line under an element is prose text. You therefore *cannot* write a bare variable or literal on its own line (`x`, `attrs`, `1`, `"hello"`). I literally hit this live while drafting `sort-attrs` (before refactoring it to `|pipe` at L186–190) — writing `attrs` as a second indented line under `|List/sort` caused UDON to parse `attrs` as prose, leaving `List.sort` partially applied (thankfully caught immediately by `ocamlc`). Every expression child must start with `|` (e.g. `|val x`) or ride in a `:attr` / `$main` slot.

2. **UDON Sameline Scoping Fights Multi-Argument Inline Expressions (Hit Live Twice)**
   - **Unquoted attribute slurping (`rule:unquoted-run-is-one-value`):** Writing `|equiv-element :layer ContentOnly e1 e2` caused `:layer` to swallow `ContentOnly e1 e2` as one unquoted text value (`~layer:(ContentOnly e1 e2)`). In valid UDON, you must put positional args *before* `:layer` (`|equiv-element e1 e2 :layer ContentOnly`), insert a framed backslash (`:layer ContentOnly \ e1 e2`), or wrap `|{ContentOnly}`.
   - **Sameline element swallowing sibling attributes (`rule:sameline-element-is-child`):** Writing `|Some[n] :when |eq n "$root" :is []` attached `:is []` to `|eq` instead of `|Some[n]`, silently turning the match arm body into `()`. Fixing it required `|Some[n] :when |{eq n "$root"} :is []`.
   - **Right-nesting vs. sibling arguments:** In UDON, `|a |b |c` parses as `a(b(c))` (like OCaml `@@`), *not* `a(b, c)`. So any multi-arg expression on one line forces inline `|{...}` everywhere:
     ```udon
     |assert |eq |{count-nodes |{Element doc.root}} 4
     |and |{eq t1 t2} |{eq r1 r2}
     |let[e1] |mk-el |{Some "user"} [ a1 a2 ] [ |{Text "Hello"} ]
     ```
     That is noisier than OCaml's `(...)` (3 delimiter characters vs 2, plus visual `|` clutter), and relies heavily on `|{...}` — whose interior grammar is still officially OPEN in UDON lite (`peg-2026-10-21.md` L113).

3. **Skipping Tuples Works for Nouns, Hurts Verbs (Simultaneous Pattern Matching)**
   Joseph's intuition ("I don't know that we'd even really need tuples") held 100% for **data modeling** — every domain type in `udon_part1_spec.ud` was cleaner as a named record or ADT. **But** without multi-scrutinee `match a, b with`, comparing two ADTs (`list-equiv`, `opt-string-eq`, `equiv-value`, `equiv-node` — L160–279) required doubly-nested `|match v1` → `|match v2` trees, roughly doubling boilerplate and indentation. (Dedicated multi-scrutinee match syntax could patch this without adding general tuples, at the cost of extra surface syntax.)

4. **Small Expression Density (Infix Operators, Tiny Lambdas, Currying)**
   Prefix element calls for arithmetic, boolean combinations, and inline lambdas (`|{fun[a][b] |add a b}`, `|cat "\"" s "\""`, `|mul |{add a b} |{sub c d}`) turn expression-heavy code into a heavier S-expression dialect than OCaml. Currying works naturally inside `|pipe`, but passing a partially applied function inline (`|list-equiv |{equiv-value :layer layer} xs ys`) again triggers `|{...}` wrapping.

5. **`.` Collision Between UDON Traits and OCaml Module Paths**
   Per `labels-ascii-and-positions-2026-10-20.md` L26, `.` ends an element name and opens a `.trait`, so `|List.map` parses as element `List` + trait `.map`, not `List.map`. Using UDON's `/` namespacing (`|List/map`, `|String/concat`) keeps `.rec`/`.and`/`.partial` unambiguous, while record field access still uses `.` in value position (`e.children`) — workable, slightly asymmetric.

6. **Type Expressions & Error-Message Leakiness**
   - Concise type annotations (`:type file-path:string -> partial:partial -> document`, `:attrs attribute list`) only looked clean because UDON's `rule:unquoted-run-is-one-value` let OCaml type syntax ride as unquoted text. Pure-element type trees would be painful.
   - While `# line` maps line numbers cleanly back to `.ud`, column spans (`characters 2-24`) remain `.ml` offsets, and compiler errors name normalized `snake_case` identifiers (`has_key_q` instead of `has-key?`).

---

## 3. Verdict: Is "OCaml Written in UDON" a Real Sweet Spot?

**Short answer:**
- **For general-purpose algorithmic OCaml (all verbs in UDON): No — the friction outweighs the gain.** Expression-dense code fights UDON's prose-first line grammar and sameline right-nesting at every turn, turning small expressions into noisy `|{...}` trees.
- **For a focused "Executable Spec / Schema / Rule-Table / Bounded-Context" subset: Yes — genuinely compelling, and cleaner than raw OCaml on the upper half of the file.**

Look at the exact seam where `udon_part1_spec.ud` flips from *singing* to *fighting*:
- **Above the seam (sings):** Literate prose with compiler-verified `@{ref}` ubiquitous-language links, `|sig`, `|module`, `|type` (ADTs, records, inline records, aliases), labeled-arg constructors, declarative `|test` fixtures, flat `|let` pipelines (`|pipe`), and shallow single-scrutinee `|match` dispatch.
- **Below the seam (fights):** Multi-scrutinee matching, nested multi-arg inline expressions (`|{...}`), infix math/boolean algebra, and inline higher-order callbacks.

**What this suggests if pursued further:** Don't force dense ML expressions into `|{...}` element trees. Either (a) use UDON-OCaml strictly for the **outer domain/contract/rule/test layer** while importing dense algorithmic helpers from normal `.ml` files via `|open`, or (b) allow a clean expression island (e.g., an inline `<...>` expression span or dedicated expression syntax) inside otherwise pure-UDON `|sig` / `|type` / `|match` / `|test` modules.

### Honest Scope Note (What Was Not Checked)
- `udon2ml.py` is a prototype parser for the UDON v2 subset used here, not a conformance-tested UDON parser (notably, `|{...}` interior syntax is still OPEN in UDON lite).
- Polymorphic variants, GADTs, functors (implemented in `udon2ml.py` but not exercised in `udon_part1_spec.ud`), exceptions, refs/mutability, and multi-file `.mli`/`.ml` compilation were not stress-tested.
- The `@{ref}` checker uses flat whole-file symbol resolution with simple plural stripping, not lexical OCaml scope resolution (so a `@{ref}` matching a local variable in another function would falsely resolve).
