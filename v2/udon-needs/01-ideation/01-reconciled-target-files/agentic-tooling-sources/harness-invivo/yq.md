---
source: agentic-tooling in-vivo sweep — repo ~/src-ext/yq (jq-for-YAML CLI)
gathered: 2026-07-21
status: vetted mining-spot map
repo_version: HEAD 588d0bb3 (2025-11-26), git-describe v4-1-g588d0bb3 (yq v4.x line)
---

# yq — mining-spot map

**Why this repo is here:** yq is not a coding harness; it's the closest mature
prior art to what UDON wants — a **path/expression language over a
structured-text format with in-place edits, streaming, and comment/format
preservation**. The gold is its *interface design*: how you address a node
(path), how you edit one (assign/setpath/delpaths), how spans/positions are
exposed (line/column/match-offset), and the agent-friendly CLI surface
(exit-status, null-input, -i in-place, NUL separators, front-matter, split).

Center of mass = `pkg/yqlib/doc/operators/*.md` (the expression-language
reference, 64 operators, prose + worked I/O examples) and `cmd/root.go` (the
whole CLI flag surface). Go internals deliberately skipped per brief.

---

## CLI interface surface

- **`cmd/root.go` L101–222** — the entire flag surface in one block. Highest-value
  agent-relevant flags, each with its one-line help string: `-n/--null-input`
  (don't read input, build docs from scratch), `-i/--inplace` (edit first file
  in place), `-e/--exit-status` (set exit status when no matches / null / false —
  the grep-style agent contract), `-0/--nul-output` (NUL-separate values, fails
  if unwrapped scalar contains NUL), `-r/--unwrapScalar` (raw value, no
  quotes/colors/comments — machine-readable default for yaml), `-o/--output-format`
  and `-p/--input-format` (auto|yaml|json|xml|csv|tsv|props|toml|lua|... —
  format-agnostic conversion), `-s/--split-exp` (route each result/doc to a
  computed filename, `$index` available, dirs auto-created), `-f/--front-matter`
  (extract|process — operate on YAML front-matter, leave the rest intact),
  `--from-file` (load expression from file), `-M/--no-colors` & `-C/--colors`
  (force color state — matters for piping), `--expression` (force the expression
  arg when yq's arg-detection thinks it's a filename), and two sandbox flags
  `--security-disable-env-ops` / `--security-disable-file-ops` (disable env/`load`
  ops — relevant to running untrusted expressions in an agent). Date 2025-11.
  **Priority: HIGH** — this is the canonical menu of "what an agent-facing
  query/edit CLI exposes."

- **`cmd/evaluate_sequence_command.go` L153** and **`cmd/evaluate_all_command.go`
  L135** — the exit-status contract implementation: `if err == nil && exitStatus
  && !printer.PrintedAnything()` returns an error → nonzero exit. Shows the two
  execution modes: **sequence** (`eval`, files processed one at a time) vs
  **all** (`eval-all`/`ea`, all docs loaded at once, needed for cross-file
  merge). Date 2025-11. **Priority: MEDIUM** — the machine-readable "did it
  match anything" convention UDON tooling will need an analogue of.

---

## Path addressing & span/position primitives (most UDON-relevant)

- **`pkg/yqlib/doc/operators/path.md`** — the core addressing model. `path`
  returns a node's traversal path as an array (`.a.b | path` → `[a, b]`);
  `.[-1]` gets the key/index. **L98–180: `setpath(pathArray; value)`** and
  **L181–233: `delpaths([[...],[...]])`** — programmatic edit-by-path, the
  round-trip primitive (get path → mutate at path). L218–233 documents the
  sharp edge: `delpaths` takes an *array of* path arrays, and errors loudly if
  given one. Date 2025-11. **Priority: HIGH** — this is exactly the
  path-addressing + path-based-edit pair UDON's udon-paths work is circling.

- **`pkg/yqlib/doc/operators/line.md`** and **`column.md`** — `line` returns a
  matching node's source line (1-based, 0 = no line data); `column` returns
  "the number of characters that precede that node on the line it starts."
  Source-position exposure on parsed nodes. Date 2025-11. **Priority: HIGH** —
  direct prior art for span-sensitive tooling: the parser retains source
  coordinates and the query language surfaces them.

- **`pkg/yqlib/doc/operators/string-operators.md` L160–200** — `match(regex)`
  returns `{string, offset, length, captures}` — i.e. **byte-offset + length
  spans** for substring matches, with `"g"` for global and named `capture`
  groups; `sub(regex, replacement)` does in-value substring replacement
  referencing captures; `test(regex)` boolean. Date 2025-11. **Priority: HIGH**
  — offset/length span reporting is precisely the primitive UDON's value-bracket
  wire needs; worth studying how a query language returns spans as data.

- **`pkg/yqlib/doc/operators/parent.md`** — `parent` returns parent nodes;
  paired with `path` gives full tree navigation up and down. Date 2025-11.
  **Priority: LOW.**

---

## Edit semantics (str-replace analogue = expression assignment)

- **`pkg/yqlib/doc/operators/assign-update.md`** — the edit model. Two forms:
  **plain `=`** (LHS := RHS, RHS run against root context) and **relative `|=`**
  (RHS run with *each LHS node as context* — the increment/transform-in-place
  form). Flags: `c` clobber custom tags. yq has no line-based str-replace; edits
  are **structural, expressed as path-targeted assignments** — a fundamentally
  different (and comment/format-preserving) edit paradigm than the diff/patch
  approach coding harnesses use. Date 2025-11. **Priority: HIGH** — the contrast
  (structural-assignment edit vs textual str-replace) is a live design axis for
  UDON's edit tooling.

- **`pkg/yqlib/doc/operators/delete.md`** — `del(.path)` deletes map/array
  entries by path (worked nested + array examples). Date 2025-11. **Priority:
  MEDIUM.**

- **`pkg/yqlib/doc/operators/comment-operators.md`** — get/set `line_comment` and
  `head_comment`/`foot_comment` with the same `=`/`|=` syntax; documents the
  subtlety that line comments attach to the *key* node, not the value. Shows the
  parser preserves comments as first-class node metadata across edits. Date
  2025-11. **Priority: MEDIUM** — trivia/comment preservation across
  round-trip edits is a known-hard problem UDON shares.

- **`pkg/yqlib/doc/operators/style.md`** — read/set the serialization *style* of
  a node (flow/block/single-quote/double-quote/literal/folded) as editable
  metadata; `-P/--prettyPrint` is shorthand for `style=""`. Date 2025-11.
  **Priority: MEDIUM** — formatting-as-editable-metadata is directly relevant to
  UDON round-tripping.

---

## Execution model, recipes, streaming

- **`how-it-works.md` (182 lines)** — plain-English model of the expression
  engine: a *context of nodes* is piped operator→operator; splat, select,
  extract shown as a worked pipeline; and the load-bearing note (L~85) that "this
  node holds not only its value but comments and metadata too, including path and
  parent information" — i.e. nodes are rich, not raw strings. Date 2025-11.
  **Priority: HIGH** — the cleanest short statement of the whole model; read
  before the operator docs.

- **`pkg/yqlib/doc/usage/recipes.md` (264 lines)** — task-oriented cookbook:
  find/update items in an array by field-match (L7–60), deeply prune a tree
  (L62–99), multiple/complex updates (L100–129), sort/filter/flatten/unique,
  and **export-as-env-vars / custom-format** (L194–263) — how yq is driven as a
  scripting/codegen tool. Each recipe has an "Explanation" subsection. Date
  2025-11. **Priority: MEDIUM** — real-world invocation patterns, the shape of
  how an agent would actually call it.

- **`pkg/yqlib/doc/operators/split-into-documents.md`** + **`--split-exp`** flag —
  multi-document streaming: split one stream into many, route to computed
  filenames. Date 2025-11. **Priority: LOW-MEDIUM** — streaming/multi-doc
  handling, tangential to UDON but a data point.

- **`pkg/yqlib/doc/usage/` (base64, convert, csv-tsv, xml, toml, properties, lua,
  formatting-expressions, shellvariables)** — per-format round-trip docs; each
  shows how yq maps a foreign format onto its one node model. Date 2025-11.
  **Priority: LOW** — breadth evidence that one path/edit language can sit over
  many concrete syntaxes (the UDON multi-format aspiration), but not worth deep
  reading for this sweep.

- **`README.md` L10–74 (Quick Usage Guide)** — canonical invocation examples:
  `yq -i '.a.b[0].c = "cool"' file.yaml` (in-place edit by path),
  `NAME=mike yq -i '... = strenv(NAME)'` (env injection into edits), merge via
  `ea` + globs, select-then-assign `(.[] | select(.name=="foo") | .address) =
  "..."`, and format conversions. Date 2025-11. **Priority: MEDIUM** — the
  compressed "how it's actually invoked" surface.

---

## Dry wells / skipped (honest log)

- **`pkg/yqlib/*.go` (Go internals, ~200 files), `cmd/*.go` beyond flags/exit** —
  per brief, skipped internals; only mined `cmd/root.go` (flags) and the two
  `evaluate_*_command.go` files (exit-status contract).
- **`acceptance_tests/`, `test/`, `*_test.go`** — not read; test fixtures, no
  interface-design content beyond what the docs already state.
- **`snap/`, `github-action/`, `Dockerfile*`, `scripts/`, `release_*`,
  `mkdocs.yml`, `action.yml`, `CODE_OF_CONDUCT.md`, `CONTRIBUTING.md`** —
  packaging/CI/meta; no tooling-design signal. Dry.
- **~45 of the 64 operator docs** (arithmetic add/subtract/multiply/modulo,
  boolean/compare/equals, group-by/sort/unique/reverse/shuffle, datetime, kind,
  tag, anchors/aliases, encode-decode, env-variable, reduce, pick/omit,
  pivot/column, array-to-map, etc.) — scanned the inventory, not individually
  read; they are the query-language breadth but not span/edit-relevant. Listed
  here so the omission is deliberate, not an inventory gap. The ~19 I did read
  and vet are the entries above.

## Searches / commands run

- `git log -1` → HEAD 588d0bb3, 2025-11-26; `git describe` → v4-1-g588d0bb3.
- `find . -name '*.md' -path '*doc*'` → located the 64-operator doc tree + usage docs.
- `grep -rn 'Flags()|StringVar|BoolVar|Var(' cmd/*.go` → full flag surface (root.go L101–222).
- `grep -n 'exitStatus|os.Exit|PrintedAnything'` → exit-status contract in the two eval commands.
- Read intros/bodies of: path, assign-update, delete, traverse-read, comment-operators,
  line, column, string-operators (match/sub/test), parent, style; plus how-it-works.md,
  README.md L1–74, recipes.md headers, and the operator/usage inventories.
