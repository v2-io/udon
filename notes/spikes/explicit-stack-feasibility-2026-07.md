# S5 — Explicit-stack (pushdown) backend feasibility for descent

**Spike 5 from REVIEW-JULY-2026 §9; answers open decision 3 (StreamingParser fate).**
Run 2026-07-11. Question: can descent's `.desc` grammars be compiled to an
explicit-stack machine — reified, suspendable at any byte boundary — **without
changing `.desc` grammar semantics**?

**Verdict: yes — succeed-at-claim, demonstrated.** The transformation is a
mechanical defunctionalization of a closed, statically-known call graph. A
hand-translated prototype covering all four crux mechanisms is event-identical
to the recursive form across **273 chunking configurations (every chunk size
1..=len over 16 documents), 0 failures**, including the exact chunk-boundary
case that breaks the shipped StreamingParser (REVIEW §4 defect 1). Prototype:
`scratchpad/s5-explicit-stack/proto.rs` (session scratch; ~700 lines, single
`rustc` file — copy into the repo if it should persist).

---

## 1. The emission model (how descent generates code today)

Read for this spike: `tools/descent/lib/descent/generator.rb`,
`templates/rust/parser.liquid`, `templates/rust/_command.liquid`,
`lib/descent/ir.rb`, plus `core/generator/udon.desc` / `values.desc` and the
generated `core/udon-core/src/parser.rs`.

The pipeline is lexer → AST → IR (`IR::Function{params, param_types, locals,
states[cases[commands]], entry_actions, eof_handler, …}`) → Liquid templates.
Per generated function:

- **BRACKET** return type → emit `{Type}Start` on entry, `{Type}End` on every
  return path (including inferred EOF). **CONTENT** → `self.mark()` on entry,
  emit `{Type}{content: self.term(), span}` on return. **INTERNAL** → returns
  `i32`, no emit.
- Each multi-state function compiles to a **local `State` enum + `loop` +
  `match`** — i.e., each function body is *already* a flat state machine.
  Cases become match arms (byte literals / class predicates / `:param`
  matches / `if[...]` guards); commands become straight-line Rust via
  `_command.liquid` (advance, scan_toN, mark, set_term, prepend, assign,
  inline emits, call, return, transition).
- All capture state is **already reified on `self`**: `pos`, `mark_pos`,
  `term_pos`, `prepend_buf`, `line`, `column`. `term()` returns
  `Cow::Borrowed` normally, `Cow::Owned` when `prepend_buf` is non-empty.
- The **only** use of the Rust call stack is the ~139 `self.parse_*` call
  sites (grammar `/function(args)` commands). That is the entire gap between
  the current parser and a suspendable one.

This is the load-bearing observation: descent does not need to *become* a
state-machine compiler — it already is one, per function. The pushdown backend
only has to replace native calls/returns with frame pushes/pops.

## 2. The four crux analyses

### Crux 1 — calls with arguments and return values → frames + continuation labels

What a pushdown frame holds, derived from `IR::Function`:

- **Params.** Three types exist (inferred by the IR builder): `i32` (columns:
  `/element(col, -1)`), `u8` (closer bytes: `/parse_element_identity('}')`),
  `&'static [u8]` (PREPEND payloads). All are `Copy`/`'static` — trivially
  frame-storable; no lifetime or ownership issue. Call arguments are
  expressions over params/locals/`COL`/`PREV` — evaluated *at push time*
  exactly as they are evaluated at call time today; no semantic change.
- **Locals.** All `i32`, few per function (max ~3: `element` has
  `content_base` + `col`; `line_comment` adds `comment_col`). Live in the
  frame instead of Rust stack slots.
- **Continuation.** A call can sit mid-command-sequence
  (`TERM(-1) | Text(USE_MARK) | -> | /embedded |>> :after_inline`), inside a
  conditional clause (`|if[…] | /element(COL - 1, :elem_col) |>> :post_child`),
  or in entry actions (`block_reference` is *entirely* entry actions). The fix
  is classic defunctionalization: the backend allocates one **continuation
  label per call site**, holding the remainder of the command sequence plus
  the pending transition. The frame's state enum grows from "states" to
  "states ∪ call-site continuations." All statically enumerable at codegen
  time. (In the prototype these are the `AfterName` / `AfterCount` /
  `AfterChild` variants.)
- **Return values.** Only INTERNAL functions return values, always `i32`, and
  the full corpus has exactly **three** such call sites, all of the shape
  `col = /count_indent` (udon.desc:69,886,911). A single machine-level `ret:
  i32` register plus an assign-from-ret continuation covers it. The IR
  builder must split `assign var = /call` into call + resume-assign — small.
- **Keywords fallback** (`lookup_bare_kw_or_fallback` → `/emit_bare_value`) is
  just another call site; same mechanism.

No higher-order calls, no recursion through data, no varargs. **Feasible,
purely mechanical.**

### Crux 2 — mark_pos / term_pos / prepend_buf across suspension

Already on `self`, so already suspension-safe *within* one buffer. The new
work is chunk boundaries, and the existing `prepend_buf`/`Cow` design turns
out to be exactly the right shape:

- **Suspend rule:** if a mark is active when input runs out mid-document,
  flush `input[mark_pos..pos]` into a carry buffer (the prototype's `carry`,
  structurally identical to `prepend_buf`) and restart `mark_pos = 0` on the
  next chunk. `term()` already knows how to produce `Cow::Owned(prefix +
  slice)` — same code path PREPEND uses today.
- **The one genuine subtlety: `TERM(-1)` across a boundary.** Sequence: text
  sees `;`, advances, chunk ends, `;` gets flushed to carry; next chunk opens
  with `;` → `TERM(-1)` must now excise a byte that lives in the *carry
  buffer*, not the slice (`pos + offset < mark_start` ⇒ truncate carry by the
  deficit). Implemented and differential-tested in the prototype (`;;` split
  at every boundary; also `\;;` escapes). Max negative offset in the current
  grammars is −1, but the general rule is a 5-line clamp.
- **Multi-advance sequences** (`|c[<BS>] | -> | ->` in `skip_single_quoted`,
  `double_quoted`, `single_quoted` — 3 sites): the second advance may have no
  byte in the current chunk. In single-shot code, advance-past-end is a no-op
  (correct only at true EOF). The backend needs a `pending_skip: u8` counter
  drained at the trampoline top before state dispatch — suspension *between*
  two advances of one command sequence then works. Implemented and tested in
  the prototype (chunk boundary between `\` and the escaped byte, every
  position).
- **Spans** become global offsets (chunk-base + pos) — the prototype emits
  global spans and they match the single-buffer run exactly. This also
  quietly fixes the span story the current StreamingParser fakes with
  post-hoc offset addition.
- **Events/lifetimes:** an event whose content crossed a boundary is
  necessarily owned; others can borrow from the live chunk. `Cow` already
  expresses this; a streaming API can surface `Event<'chunk>` with the rule
  "consume before the next push_chunk," or plain owned events (the existing
  `StreamEvent` shape).

### Crux 3 — the indent stack implicit in recursion

The indent stack **is** the frame stack. `:elem_col`/`:parent_col` are frame
params; dedent is `|if[col <= :elem_col] |return` in a `:check` state, and the
cascade (`text` at column 0 closing three nested elements) is a run of frame
pops where each parent's after-child continuation re-dispatches on the *same
unconsumed byte* and re-checks its own param. Two properties make this
suspension-proof:

1. The dedent guard consumes **no input** — evaluated before any peek — so
   unwinding never blocks on a chunk boundary; the whole cascade runs from
   the already-computed `col`.
2. Returns consume no input either, so a suspension landing anywhere in the
   cascade resumes mid-unwind with identical results (verified: "dedent
   cascade" and "deep unwind at EOF" documents at every chunk size).

EOF unwinding falls out for free: `finish()` sets the eof flag and the
trampoline pops frames one at a time, each running its type-driven EOF
behavior (End-emit / content-emit / return-0) — same inference rules the
template applies today.

### Crux 4 — hand-written table interpreter vs. templated codegen backend

**Codegen wins, and it isn't close.** The reason: `.desc` conditions and
expressions (`COL - 1`, `content_base >= 0 && col >= content_base`,
`depth == 0`) are *transpiled into native Rust* by `rust_expr`. A serialized
state-machine table would need an expression IR + runtime evaluator — a
bigger semantic surface than the thing being replaced — and would forfeit the
memchr SCAN specialization and dense match dispatch that the 1.3 GiB/s figure
rests on. Meanwhile the codegen delta is localized:

- **IR pass** (new, the real work): split command sequences at call
  boundaries, allocate continuation labels, compute per-function frame layout
  (params + locals + state/cont enum). Est. 300–500 lines of Ruby in the
  ir_builder stage. This pass is also where the Rust-coupled-IR flaw
  (REVIEW §5) would naturally get fixed if descent is touched at all.
- **Template** (`templates/rust/parser_pushdown.liquid` + a command-partial
  variant): the per-state match bodies are *reused as-is*; only three command
  renderings change (call → push + label, return → pop [+ ret], transition
  unchanged), wrapped in one trampoline loop over a generated `Frame` enum,
  plus the carry/pending-skip runtime helpers (~150 lines of static template
  Rust).
- Emit both backends from the same `.desc` (a `--backend` flag): the
  recursive parser stays the single-shot fast path until benchmarks say the
  pushdown one can replace it.

## 3. Prototype findings

`proto.rs` implements a toy grammar exercising every crux shape from
`udon.desc` — `document` (dispatch + `col = /count_indent` return value),
`count_indent` (INTERNAL), `element(:elem_col, :parent_col)` (BRACKET,
recursive with computed args, dedent-check state), `name` (CONTENT auto-emit),
`text` (manual TERM(-1) two-byte lookahead + `-> | ->` escapes) — twice:

- `Rec`: descent's current output shape, verbatim (State enum + loop + match,
  capture on self).
- `Pd`: the pushdown machine — `Vec<Frame>`, `ret` register, carry buffer,
  pending-skip counter, `push_chunk()/finish()` API, suspendable at any byte.

Result: **273 chunking configurations, 0 event-stream divergences** (content,
order, *and* global spans), up to 41 suspensions in a single parse. The
REVIEW defect-1 input `|parent\n  |child\n` fed one byte at a time yields the
correct nested stream (`ElementStart, Name("parent"), ElementStart,
Name("child"), ElementEnd, ElementEnd`) — the shipped StreamingParser emits a
spurious `ElementEnd` and a sibling root on the same input.

**Not covered by the prototype, analyzed only** (all judged mechanical, none
load-bearing for feasibility): SCAN/memchr resumption (a scan that exhausts
the chunk consumes-all and re-scans on resume — scannable states are
self-loops, so re-entry is idempotent; the backend must distinguish
chunk-exhausted from EOF where the template currently infers Unclosed
errors); PREPEND `:param` payloads in frames (`&'static [u8]`, trivially
storable); keyword lookup across boundaries (content comes from
carry-aware `term()`, so it composes); `--trace` plumbing; performance (frame
push/pop vs native calls — unmeasured; scan-dominated throughput should
survive, but benchmark before promoting the backend to default).

**A bonus not in the original question:** the reified stack is inspectable.
At any suspension the machine can report the open element path, depths, and
pending capture — the raw material for the error messages and agent-facing
diagnostics (skeleton-view-at-point) that the recursive parser structurally
cannot provide mid-parse.

## 4. Feasibility verdict and effort

**Feasible without any `.desc` grammar change — demonstrated, not just
argued.** The `.desc` semantics (states, cases, commands, type-driven emits,
params, INTERNAL returns, inferred EOF) map 1:1 onto frames + continuation
labels; no grammar construct resists reification. The only semantics the
grammar author ever sees are unchanged: same events, same spans (now global),
same EOF inference.

Effort for a production backend in descent (Ruby-iterated, current gem):

| Piece | Est. |
|---|---|
| IR continuation-split + frame-layout pass | 3–5 days |
| Pushdown template pair (+ runtime helpers: carry, pending_skip, chunk API) | 3–5 days |
| Chunk-boundary differential harness (fixtures × chunk sizes vs single-shot — oracle already exists in the fixture suite) | 1–2 days |
| Full udon.desc+values.desc shakeout (scan resumption edges, keywords, PREPEND) | 3–5 days |

≈ **2–3 focused weeks** end-to-end, consistent with REVIEW §4's "2–3 weeks"
scale for substrate work. Risk concentrates in the IR pass and scan-edge
plumbing, not in the concept — the concept is now demonstrated.

## 5. What this means for decision 3 (StreamingParser fate)

The decision is no longer "backend *vs* deletion" on feasibility grounds —
feasibility is settled. It is a priority call, and there are three honest
options:

1. **Build the backend** (~2–3 wks) — true resumable streaming at any byte
   boundary, defect 1 resolved at the generator level, plus the inspectable-
   stack diagnostics dividend. The right move *if* a real consumer needs
   incremental parsing of in-flight documents (agent-generated UDON arriving
   over a stream is the plausible one).
2. **Interim: delete the façade now, regardless of 1.** The current
   StreamingParser is structurally broken and should not survive in any
   branch of this decision; single-shot `Parser` is honest and fast. If
   cheap streaming is wanted meanwhile, a **thread-coroutine adapter**
   (parser on its own thread, events over a bounded channel — suspension via
   real stack, ~a day, zero descent changes) delivers correct streaming
   semantics at thread cost.
3. **Document single-shot only** (hours) — defensible for vivarium/ASF today,
   since both consume whole files.

Recommendation: **2 now, 1 when a streaming consumer is concrete** — and per
REVIEW §5, if descent gets exactly one more feature in its life, this remains
the right one; the spike removes the risk that it's a dead end.

---

*Epistemic status: emission model read from generator.rb + both Liquid
templates + ir.rb (primary source); call-site/param/return inventory greped
from udon.desc, values.desc, and generated parser.rs; all "demonstrated"
claims backed by the 273-configuration differential run this session
(`rustc 1.96.0`, first-compile pass); SCAN/keywords/PREPEND boundary behavior
and the performance question are analysis, marked as such above.*
