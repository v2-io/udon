# UDON ↔ OCaml Spikes — Side-by-Side Comparison (2026-11-23)

*Three independent, low-stakes creative spikes run in parallel on OCaml 5.5.2 (none read the others' directories; neither `udon` nor `verisectorium` git trees were touched). Every spike compiled and ran live against deliberate failure probes.*

## At a Glance

| | **Spike 1** (`spike-1-literate-udon-ocaml/`) | **Spike 2** (`spike-2-udon-ddd-adts/`) | **Spike 3** (`spike-3-ocaml-in-udon/`) |
|---|---|---|---|
| **Direction** | Literate UDON container over standard OCaml fences | UDON as DDD Schema + ADT data language (1:1 nouns → OCaml) | Full "OCaml written in UDON" (1:1 nouns *and* verbs, 0 fences, 0 tuples) |
| **Built & verified** | `udon_ast.ud` (847 L) + `udon_lit.ml` (OCaml) → 11 checks pass + 5 failure probes | `udon2ml.py` + 2 Bounded Context schemas (`verisectorium`, `udon-spec`) + 2 stores + `checks.ml` + 11 failure probes | `udon2ml.py` + `udon_part1_spec.ud` (526 L → 744 L `.ml`) + 5 tests pass (`-w +8` 0 warnings) + diagnostics probe |
| **Biggest surprise win** | `.shared` eliminates OCaml's `.mli`/`.ml` transparent-type duplication while keeping opaque types (`element`, `partial`, `document`) strictly split; `# <line>` points signature mismatches to both lines in `.ud` | `[id]` → two-pass typed `let` witnesses type-check forward refs *and* prose `@{term}` refs; `.draft`/`.accepted` → covariant phantom types reject `.draft` in `|settled` at compile time; `.mli` enforces Bounded Context isolation | `|sig` / `|type` / inline records + bare prose with compiler-checked `@{ref}` (51/51) + labeled args (`|fn :file-path "x"`) + flat `|let` / `|pipe` felt *cleaner* than raw OCaml on the upper half |
| **Main real friction** | `:layout`/`:section` plumbing for comprehension order; dedent vs. column-offset tradeoff on multi-line raw strings; no native LSP inside fences | Needs schema-aware lowering (not syntax-blind); `let`-shadowing swallows duplicate `[id]`; keyword mangling (`:to` → `to_`, `:method` → `method_`) leaks into `ocamlc` hints; anonymous `|` has no ctor; multi-axis traits bloat phantoms | Prose-first line grammar + sameline right-nesting (`|a |b |c`) + unquoted-run slurping fight dense expressions, forcing noisy `|{...}` everywhere; no tuples hurts simultaneous `match a, b with` |

## The Natural Seam All Three Independently Found

Taken together, the three spikes drew one crisp architectural boundary:

1. **Above the seam — UDON genuinely *beats* raw OCaml:**
   - DDD Bounded Contexts (`|context` / `|sig`), algebraic types & inline-record variants (`|variant`, `|record`), data instances with unordered `:attr val` and `[id]` entity witnesses, single-axis phantom traits (`.draft` | `.accepted`), bare prose with compiler-verified `@{ref}` / `«term»` links, and auto-registered `I.e.` / `E.g.` conformance checks.
   - Zero tuples were missed anywhere in data modeling (confirmed by both Spike 2 and Spike 3).
2. **Below the seam — standard OCaml genuinely *beats* UDON:**
   - Dense expressions, multi-scrutinee pattern matching (`match a, b with`), infix math/boolean algebra, and nested multi-argument inline calls — where UDON's prose-first grammar and sameline scoping turn code into noisy `|{...}` trees.

## Three Concrete Engineering Findings Shared Across Spikes

1. **Outline-driven multi-file bundling solves OCaml's acyclic-module vs. `one-term-per-file` tension** (converged on independently by Spikes 1 & 2): keep `def/AST.ud`, `def/element.ud`, `def/root.ud` as small per-term files and assemble a Bounded Context's outline into one OCaml module (or mint `<ctx>_ids.ml` first), using `# <line> "def/element.ud"` so `ocamlc` points directly to the right term file.
2. **`# <line> "file.ud"` works cleanly (even mid-`type ... and ...`), with two solvable quirks** (Spikes 1, 2, 3): character column numbers reflect generated `.ml` lines (fixable with a ~20-line dedent-aware stderr remapper using UDON's fence `dedent` metadata), and `# <line>` must be explicitly reset before synthesized runner glue.
3. **Generic AST unordered attributes break OCaml polymorphic `=`** (verified live in Spike 2: `Checks.ast_equal a b = true`, raw `a = b` is `false`) — directly reinforcing `spec/PRAXIS.md` Rule 2 (`partitioned by` observer equality) and Spike 1's opaque `type element` in `.mli`.

## Natural Hybrid (If Pursued Later)

Combine **Spike 2's UDON-native DDD schemas, data instances, `[id]` witnesses, `.draft`/`.accepted` phantom types, and prose `@{ref}`/`«term»` checks** for the outer Ubiquitous Language / spec layer, with **Spike 1's `.shared` + opaque `.mli`/`.ml` fences + outline-driven multi-file tangling** for dense algorithmic logic and executable invariants — getting the best of both worlds while skipping Spike 3's `|{...}` expression tax.

## Full Spike Debriefs
- Spike 1: `spike-1-literate-udon-ocaml/findings.md` (and `udon_ast.ud`, `udon_lit.ml`)
- Spike 2: `spike-2-udon-ddd-adts/findings.md` (and `schemas/udon_spec.schema.ud`, `data/udon_part1.ud`, `checks.ml`)
- Spike 3: `spike-3-ocaml-in-udon/findings.md` (and `udon_part1_spec.ud`, `udon2ml.py`)
