# Appendix C — The addressing and agent-utility explorations, in full

Two focused design explorations (2026-07) whose demand tables, trap lists, and open questions Part III–IV absorb: one on addressing (paths), one on agent-facing utility surfaces. Nothing in either is a ruling — they are demand maps, carried whole so the phase-3 spikes and any auditor can read exactly what the segments cite.

---

---
source: second-pass paths demand spike (Grok, 2026-07-21); free-form NOTES
gathered: 2026-07-21
status: gathered source material — NOT an authoritative decision document
paths:
  - v2/.archived/second-pass/spikes/paths/NOTES.md
  - design/udon-paths.md (stale spelling; this spike re-reads load-bearing ideas)
categories:
  - paths
  - addressing
  - at-all
  - embeddability
  - D1-through-D9
  - edit-tool-blocker
why_included: Addressing is the long pole for edit/query/error-as-menu/refs. Whole NOTES + demand table D1–D9. Complements (does not replace) design/udon-paths.md.
---

> **Why gathered:** Addressing is the long pole for edit/query/error-as-menu/refs. Whole NOTES + demand table D1–D9. Complements (does not replace) design/udon-paths.md.

# Paths spike — notes

Exploration pass: 2026-07-21. Free-form. Nothing here is a ruling.

---

## 1. What seems load-bearing (on merits, not on age)

From stale `design/udon-paths.md` + adjudication Part A — principles that
still *feel* right when restated cold:

| Principle | Gloss | Tension |
|-----------|--------|---------|
| **No new symbols** | Path language reuses `| : . [ ] @ *` | Positional index and parent-step both want new marks if ever needed |
| **Paths look like UDON** | Linearized document, not XPath-with-sigils | Forces identity purity (see §3) |
| **`at` vs `all`** | Exactly-one-or-error vs explicitly plural | Multiplicity of *matches* vs multiplicity of *stacked values* are different failures |
| **Traits AND-filter** | `.a.b` = both | Matches document desugaring of `$traits` stacking |
| **Refs ⊂ paths (direction)** | One segment today *is* the element segment of a path | Subset floor/ceiling still open |

**Surprise that survived field use** (scenarios corpus): almost every real
query starts with `||` (any depth). Structural root-to-leaf navigation is
the *secondary* mode. Agents address *relationally* —
`||element[key]` as type-scoped primary-key lookup — with the tree as
storage/rendering. That is not a decree; it is a one-day sample. Worth
stress-testing with append-only logs and prose-heavy docs where keys are
unnatural.

---

## 2. Map of consumers that will *pull* path shape

Paths are not a single feature. Demand arrives from different mouths:

```text
                    ┌─ in-document @ references (one segment today)
                    ├─ schema selectors / guarantees
                    ├─ skeleton (copy-pasteable lines)
                    ├─ at / all / each (query)
 assembly product ──┼─ patch / set / require / move (edit tool)
                    ├─ cross-file trace / orphan refs
                    ├─ dialect envelopes later (<path:…>?)
                    └─ multi-line repair / stream addressability (?)
```

**Implication for WAIT-DEMAND:** nailing a “full path language” for tools
before embeddability is understood risks a second language that cannot
live in documents. Nailing only the in-doc subset first risks path-debt
if the subset is grown by special cases (2a Q5 / OPEN S14 lean: keep
tuple until wholesale replacement).

---

## 3. Collision map (known forks — still open)

### 3.1 Positional `[0]` vs identity `[1]`  (adjudication P1)

Document law (CORE Identity): bracket contents follow normal value rules.
`[1]` is integer key 1; `["1"]` is string key `"1"`.

Stale path doc: integers are *positional*, strings are identity.

Those conflict under “paths look like UDON.”

**Sketch options (not chosen):**

| Opt | Idea | Cost |
|-----|------|------|
| A | Brackets = identity only; position via host `all(…)[i]` | No positional syntax until demand + distinct form |
| B | Distinct positional mark now (`[#0]`, `#0`, …) | New symbol; honest |
| C | Integers positional; quote/`<…>` for integer identities | Shadows legal document keys — worst of both |

Scenario evidence (Part A½): typed-key equality was used
(`||intent[42]` ≠ `||intent["0042"]`); positional access was never wanted
once. That is **evidence**, not a pin.

### 3.2 References: floor vs ceiling (P0)

Live CORE: one segment; “notably absent by design” for nesting/attrs/
predicates; multiplicity consumer-side; traits filter only.

**Floor candidate:** multi-segment absolute paths in references
(`@config|database[primary]`) — still “looks like linearized UDON.”

**Ceiling:** whole tool language including wildcards, `||`, `:attr@` follow.

**Hard constraint the standalone path doc never had:** reference-paths
must parse inside documents with clean terminators at value boundaries.
What does `@config|database` do to the sameline scan? Where does a path
end in arrays, in `|{…}`, after bare tokens?

Until that is forced by a real embeddability probe (grammar sketch or
hand-table of terminator cases), subset choice is under-constrained.

### 3.3 Stacked attributes and node values (P2)

```udon
|el :x 1 :x 2
|api
  :headers
    |header[auth] :value Bearer
```

Open readings:

- `at("…:x")` over stack → last value? first? error if plural values?
- `all("…:x")` → every assignment in order?
- Navigation into node values: `|api:headers|header[auth]:value` seems natural
- Pre-0.9 `:attr:nested` chaining without an element step — keep or drop?

Plural-path vs plural-value vs plural-reference want **distinct** failure
names if the edit tool is to be teachable (scenario draft vocabulary:
`PathNotUnique` / `PathNotFound` / `ReferencePlural` / …).

### 3.4 `|.trait` vs `|*.trait` (P3)

Document `|.defaults` = anonymous element with trait `defaults`.

Path `|.intro` could mean “anonymous only” (mirror document) or “any
element with trait” (XPath-ish). Mirror-the-document + `|*.intro` for any
removes ambiguity without new symbols.

### 3.5 Reference segments inside paths (P6)

- Leading `@user[alice]` — definition lookup (type-scoped index), not host “resolution mode”
- Trailing `:customer@` — follow ref stored in attr; continue at definition
- Unresolvable = loud failure under `at`/`all`, not silent empty?

Composition already appears in scenarios: `||process[valve]:fed-by@:health`,
`||*:feeds@`. Also noted as awkward: `||*:*@` (wildcard attr + follow).

### 3.6 What paths *don’t* address (P7, P8, P9)

Deliberate absences worth re-examining under edit-tool pressure, not
because “features are good”:

| Absence | Why it was deliberate | Where pressure returns |
|---------|----------------------|-------------------------|
| Parent `..` | Keep language selection-shaped | Relative paths from current node in interactive skeleton |
| Predicates beyond traits+keys | Host-over-`all()` escape | Scenario day: attr-value filter wanted ~4× |
| Globs `\|foo*` | `*` already suffix/trait soup | Never? |
| Prose / comment / raw body segments | Tree has Text nodes; syntax didn’t | Scenario `.gap`: no path addresses prose → no `|set` on paragraph |
| Suffix flags `? ! +` | Traits filter; flags invisible | “Every `?`-marked process” has no path today |

---

## 4. Embeddability sketches (terminator itch)

Today every scenario path is a **quoted string** because a bare leading
`|` or `@` in value position is a node/reference value, not text.

```udon
; works today (provisional spelling as string)
|when
  |at :path "||intent[311]:status"

; bare would be structure, not a path value
; |at :path ||intent[311]:status     — not what authors mean
```

**Possible futures (exploratory only):**

1. **Stay quoted forever for tool ops** — paths never need bare value form;
   in-doc refs stay one-segment `@…`.
2. **Dialect envelope** `<path:||intent[311]:status>` — self-delimiting;
   interior can use `|` freely; aligns with OPEN W1 self-delimiting lean.
3. **Grow bare `@`/`|` multi-segment** in value position with a hard
   terminator grammar — highest recognition cost; highest “paths *are*
   UDON” purity.

**Dead end to flag early:** inventing a second quoting regime just for
paths (e.g. special path quotes) while dialects already own envelopes.

### Sameline scan stress cases (hand table — incomplete)

Assume a multi-segment reference is allowed in value position someday:

| Written | Risk |
|---------|------|
| `:db @config\|database[primary]` | Does `\|` end the reference and start a sibling element? |
| `:db @config\|database[primary] :host x` | Where does ref end; is `:host` next attr of owner or of path? |
| `:xs [@a\|b, @c]` | Array item boundaries vs path `|` |
| prose then `@x\|y` mid-line | Head vs prose commitment — ref only at head/value guard sites |
| `:p "\|config\|db"` | String is fine; not a structured path on the wire |

These are the embeddability questions adjudication said a descent prototype
should force. **This spike does not build that prototype** — only records
that without it, subset claims are soft.

---

## 5. Multi-line (ML) — watch only, do not pin

OPEN **ML** is WAIT-DEMAND. Connection to paths is real but indirect:

- Emergent-span: an *inner* spanning construct defeats a line-bound
  *container*. Path/edit tools that rewrite interior values will re-hit
  that geometry.
- Addressing partial/unclosed identity (`$partial-key`) matters for
  stream repair and incomplete input — path resolution over partial keys
  should refuse to pretend completeness (already CORE posture for `@`).
- Patch sugar-aware serialization (scenario demand): setting `:'$traits'`
  should round-trip as `.trait` when possible — that is assembly/fmt
  territory pulled by path *writes*, not path *syntax* alone.

**Do not** use this spike to close multi-line. If a concrete geometry
demand appears, list it under §8 as a provisional proposal.

---

## 6. Multiple keys (OPEN S3) — path-shaped curiosity

Joseph lean (OPEN): `|phase[9][scribal]` valid; design with paths in 0.10.

Questions for later pressure (not answered here):

- Is uniqueness still `(type, key)` or `(type, key-tuple)`?
- Does a path segment allow multiple brackets `|phase[9][scribal]`?
- How does `@phase[9]` behave if keys are multi-part?
- Does this interact with typed equality (`[9]` vs `["9"]`)?

Scenario corpus uses single keys heavily; multi-key is under-exercised.

---

## 7. Wire (OPEN W3) under path pressure

Interim: `Reference` event carries **raw text after `@`**.

Planned: structured `ReferenceStart` / Name / `$key` / `$traits` / End —
symmetric with element identity.

Lean in OPEN: raw until paths force structure.

**When structure becomes hard to avoid:**

- Multi-segment paths as references (cannot stay opaque strings without
  a second parser at every consumer)
- Typed keys / quoted names / trait stacking free (already true on define side)
- Assembly sufficiency (W0): can you recover reference identity without
  re-lexing raw?

**Counterpressure:** keep tool paths *outside* the recognition stream
(always strings / dialect values) so core wire stays simple until demand
is undeniable.

---

## 8. Provisional boundary demands

> **Proposals only — not decisions.** Labeled so a later OPEN/PANEL pass
> can harvest or discard without archaeology.

If Recognition / Assembly / Resolution stages are the spine vocabulary,
paths mostly stress **Assembly** (document product, indexes) and
**Resolution** (follow `@`, `at`/`all`), with **Recognition** only for
in-document path/ref *syntax*.

| # | Stage | Provisional demand | Who pulls | Confidence |
|---|-------|-------------------|-----------|------------|
| D1 | Recognition | In-doc `@` remains self-delimiting as today (one segment) until embeddability of multi-segment is proven | Live consumers, parsers | high as *interim* |
| D2 | Recognition | If multi-segment ever embeds bare, terminator table must be explicit (value boundary, array, brace forms) | Path-in-document authors | medium |
| D3 | Assembly | Type-scoped key index sufficient for `\|type[key]` / `@type[key]` lookup; order-preserving child lists for structural paths | `at`/`all`, skeleton | high |
| D4 | Assembly | Stacked attr access exposes *assignment list*, not only host scalar-last view | edit tool, `all(:attr)` | medium |
| D5 | Resolution | Fail-loud on unresolvable follow (`:attr@`); distinguish PathNotFound / PathNotUnique / ReferencePlural | agent edit tool | high from scenarios |
| D6 | Resolution | Path evaluation for a patch is against **pre-patch** tree (CAS / composition) | multi-agent scenarios | high as *tool* law, maybe not core |
| D7 | Wire | Prefer raw `@` payload until multi-segment or typed structure is forced (aligns OPEN W3 lean) | WIRE suite | medium |
| D8 | Host/tool | Prose/comment/raw addressing may stay API-positional in v1 (no path segment) | edit tool | medium |
| D9 | Host/tool | `at` = exactly one match or error; `all` = explicit plural — do not overload one API | all query surfaces | high as *convention* |

Nothing in D1–D9 is suite law. Wrong is fine.

---

## 9. Dead ends / traps noticed this pass

1. **Treating `design/udon-paths.md` as law** — banner already says stale;
   positional-integer rule is the sharp trap.
2. **Growing the selector tuple field-by-field** (“add parent path,” “add
   attr filter”) — 2a Q5 warning; creates path debt without a language.
3. **Confusing match multiplicity with value multiplicity** — stacked
   `:fed-by` is not the same bug as two `|user[alice]`.
4. **Assuming skeleton paths must be valid *references*** — skeleton may
   speak the full tool language while in-doc `@` stays a subset forever.
5. **Supply-side multi-line pin “because paths need it”** — reverse of
   WAIT-DEMAND; demand should appear as concrete edit/stream cases first.
6. **Globs** — confusable with suffix `*` and trait soup; scenario corpus
   did not need them.
7. **Silent empty on miss** — agent tools need loud failure; JSONPath-ish
   empty sets teach the wrong habit for contested claims / CAS.

---

## 10. Open questions left richer than when we started

See README itch + the list below. The win condition for this spike is a
better question set, not an answer set.

1. **Is the relational (`||type[key]`) mode the primary mental model**, with
   tree paths as secondary sugar — or the reverse for human authors?
2. **What is the smallest in-document reference subset that is still a true
   subset of the tool path language** (no second dialect of addressing)?
3. **Where does a multi-segment path terminate** in every CORE value
   context? (Needs a forced table or tiny grammar probe.)
4. **Should positional addressing ever be syntax**, or only host indexing
   over ordered `all()` results + eventual patch anchors?
5. **How do multiple identity brackets (`\|phase[9][scribal]`) interact with
   uniqueness, `@`, and path segments?** (OPEN S3)
6. **Attr-value predicates:** host-only forever, or a second-class filter
   syntax when frequency data accumulates?
7. **Suffix flags on path segments** (`\|process[x]?`) — mirror document
   spelling or remain invisible?
8. **Does path *write* sugar (set `$traits` → emit `.trait`) belong in core
   assembly equivalence, a fmt profile, or only the edit tool?**
9. **Cross-file paths / document handles** — in-path (`file#||x`) vs out-of-band
   (`:file` on the op, as scenarios do)?
10. **When does W3 leave raw reference payloads** — first multi-segment,
    first structured consumer, or first sufficiency (W0) proof that needs it?

---

## 11. Pointers for the next agent

- Re-read adjudication Part A½ before inventing syntax — the day-in-the-life
  already exercised P1/P5/P6 and listed gaps.
- `test/scenarios/features/*.udon` paths are **provisional spelling**; if
  syntax moves, re-spell scenarios — their value is the *journeys*.
- Sibling spike `v2-spec/spikes/agent-utility/` (if populated) is a natural
  co-reader; paths without edit/stream stories are half the demand.
- Do not edit DECISIONS/PROCESS/CORE from path enthusiasm.
- Optional harvest: promote a sharpened OPEN row (e.g. embeddability
  terminator table as WAIT-DEMAND sub-bullet under S14/ML) — only if the
  question is clearer than what OPEN already says.

---

---
source: second-pass agent-utility demand spike (Grok, night of 2026-07-20/21); free-form NOTES
gathered: 2026-07-21
status: gathered source material — NOT an authoritative decision document
paths:
  - v2/.archived/second-pass/spikes/agent-utility/NOTES.md
  - v2/.archived/second-pass/spikes/agent-utility/README.md (orient only; not copied)
  - design/udon-agentic.md, design/agentic-ux-principles.md, ux/TODO-AGENT-UX.md (inputs mined into this spike)
categories:
  - agent-edit
  - streaming-partial-doc
  - payload-handoff
  - round-trip-span-splice
  - paths-dependency
  - P-A-through-P-H
why_included: Highest-density in-repo demand residue for agent surfaces (generate/stream/edit/payload/fmt). Not yet present in gathering; needs-map only *cites* it. Older design docs restated here against pipeline vocabulary — keep both this and the design originals when they differ in texture.
---

> **Why gathered:** Highest-density in-repo demand residue for agent surfaces (generate/stream/edit/payload/fmt). Not yet present in gathering; needs-map only *cites* it. Older design docs restated here against pipeline vocabulary — keep both this and the design originals when they differ in texture.

# Agent-utility notes

Spike residue. Free-form. Wrong is fine.

---

## 0. Starting itch

UDON’s primary consumers are agents. PROCESS is agent-primary. Yet most of the
deep agent tooling design still lives in Dec-2025 / Jan-2026 design docs,
partly superseded by CORE 0.9, with critical path named (paths → schema → edit)
but not demanded against the pipeline vocabulary now in flight
(recognition / assembly / resolution / evaluation).

This spike asks: **what surfaces must the language + suite expose so agents
can generate, stream, repair, address, tool-I/O, remember, and round-trip —
without making the steward the bottleneck for agent ergonomics?**

Not “what tools should we ship first” as a product roadmap. More: which
**properties of the format and of stage products** agents lean on, and which
gaps keep showing up in lived design.

---

## 1. Generation surface (streaming, repair, partial docs)

### What agents do that humans don’t

Agents emit bytes in long runs, often without a visual feedback loop. They
stop mid-document. They resume after tool calls. They produce almost-valid
structure with wrong indents. They need **semantic feedback while writing**,
not colors on a screen.

The Dec-2025 brainstorm called this “the agent equivalent of syntax
highlighting” (`UDON-AGENT-TOOLS.md` Tier 1; still open in `TODO-AGENT-UX`).

### Substrate that already exists

- Pushdown / `TreeStream` (2026-07-15): streaming parse, partial tree.
- Same wire from pushdown and one-shot RD (differential property).
- Incomplete-input is **not an event** (R2 / C6 direction): a **recognition
  verdict**, not something you recover by folding harder.

So generation/repair is not “finish the AST or fail.” It is:

```text
bytes-in-progress
  → recognition (events + recognition-verdict)
  → optional mid-assembly peek (open stack, open attr, text run state)
  → agent continues / repairs / hands off
```

### Affordances agents need here

| Need | Why |
|------|-----|
| **Partial-tree query mid-parse** | Open-element stack, current attr, depth — “where am I?” while generating |
| **Early anomaly surfacing** | Catch illegal geometry / bad attr shape before 500 more tokens |
| **Prefix / candidate validation** | Schema or enum: “`dra` is valid prefix of `draft`” |
| **Grammar-constrained generation** | Derive decoder grammar from descent; guaranteed-valid local models |
| **Interrupt / resume fidelity** | Partial tree + verdict is the handoff substrate when generation stops |
| **Repair without full reparse of intent** | Agent says “fix indent / close open element / complete attr”; tool owns spatial fix |

### Keep-everything meets generation

R11 / keep-everything at recognition: content kept with warnings where
coherent; halt/reject is **consumer menu**. That is agent-friendly for
streaming partial docs — the recognition product can stay honest while
assembly or a careful-profile gate refuses to commit.

**Tension:** generation wants soft recovery mid-stream; careful writes want
mutation-free refusal. Same language; different **stage + profile**.

### Multi-line / line-bound (ML in OPEN)

OPEN marks multi-line policy **WAIT-DEMAND**: needs paths + agent edit/stream
evidence, not supply-side pin. Generation/repair is exactly the demand side
that should force this:

- Can an agent stream a multi-line attr value without guessing R3?
- Does repair of a partial multi-line construct need self-delimiting value
  extent (W1)?
- Does line-bound policy change mid-generation feedback shape?

Until those hurt in concrete scenarios, do not nail ML.

---

## 2. Tool I/O / ACP-style payloads

### Thesis (still live, recontextualized)

`UDON-AS-ACP-FORMAT.md`: not “invent a new protocol” (predates MCP dominance),
but **UDON as payload convention** inside MCP / harnesses / handoffs.

What that buys agents that pure JSON often doesn’t:

- Mixed structure + prose in one object (explanation rides with data)
- Nested semantic layers (structure first, semantics later — streamable)
- Strippable annotations for metacognition
- Same query / diff / merge surface as ordinary documents
- Handoffs that are documents, not ad-hoc blobs

### Tool suite shape (`udon-agentic.md` + principles)

Core read path: **glance → focus** (progressive disclosure; P5 orient cheap).  
Core write path: **propose → apply** (or atomic edit that validates inside the
transaction; P4 tempo).

Principles that dominate sketches when they disagree (`agentic-ux-principles`):

1. Tool loop = epistemic organ (deterministic, honest readout)
2. Errors mutation-free + revelation-rich + law-rich (error-as-menu of exact paths)
3. Drive observation ambiguity toward zero (codes, counts, paths — not interpretive prose in the result channel)
4. One-call resolution over edit→check→revert loops
5. Structural vs parametric failure named in the error
6. Paths re-resolve at write time (never trust cache over file)
7. File’s own schema/law governs (declared ≠ theater)
8. Agent works in structure; tool owns indent/escape/spatial render
9. Confidence as first-class output; quiet success

Joseph priority signal (TODO-AGENT-UX): the **principled agentic edit** —
atomicity, right indents, conformant with file’s spec. Critical path:

```text
path syntax → schema syntax → serializer/round-trip + spans
  → edit v0 (atomic + indent + syntax-valid)
  → schema conformance v1
```

Staged: v0 can be syntax-only; schema later.

### Payload conventions agents need (regardless of tool names)

| Surface | Agent need |
|---------|------------|
| **Skeleton / path map** | Copy-pasteable paths; multiplicities; attr names without full body |
| **Focused subtree + breadcrumb** | Where am I; siblings summary; refs in/out |
| **Diff structural, not only line** | What changed in tree terms; move vs delete+add |
| **Impact / side-effects** | Broken refs, inherited changes |
| **Validation verdict** | Conforms / violates rule R at path P |
| **Confidence** | high/medium/low + reason |
| **Teaching refusal** | Candidates as ready-to-use exact paths; stale-model hypothesis on zero match |

### Annotation / metacognition layer (open syntax)

Agents want strippable, queryable residue: confidence, source, decision,
uncertainty — without polluting content. Dec form `|{@ ...}` is **not**
valid under 0.9. Needs convention ruling (named element / reserved trait /
new syntax) — currently `*(discuss w/ Joseph)*` in TODO-AGENT-UX. Same
family as `;?` / TBD / `.draft` markers from older feedback.

Until then: **convention experiments in house styles are fine; do not invent
CORE syntax in a spike.**

### Semantic merge

Only Tier-1 idea from `UDON-AGENT-TOOLS` that `udon-agentic` never absorbed.
Multi-agent concurrent edit of the same doc is real in agent workflows.
Merge needs structural awareness + annotation accumulation. Depends on paths
+ identity + maybe ornamental policy (what counts as conflict).

---

## 3. Memory / chunking / addressing

### Addressing is load-bearing

Almost every agentic affordance bottoms out on **paths**:

- `at` / `all` (exactly one or error vs explicit plural)
- Type-scoped uniqueness `(element-name, key)` — CORE, not only design docs
- References as subset of path syntax (ruled direction; design still open)
- Skeleton lines that are valid paths
- Error-as-menu of paths
- Span-splicing edits without canonicalizing whole files

`udon-paths.md` is **stale input**, not design of record. Live work: AUX /
adjudication packet. This spike does not redesign paths; it records the
dependency: **agent-utility is blocked on paths the way edit is.**

### Self-chunking / RAG (unmeasured claim)

README-level claim: element boundaries are intentional chunk boundaries for
retrieval. Nobody has measured it (`TODO-AGENT-UX`). Experiments would
compare:

- Element-boundary chunks
- Heuristic / fixed-size chunks
- Optional tooling that *emits* partitions as UDON or as payload envelopes

If true, recognition/assembly products should preserve enough structure for
chunk emission without re-indent archaeology. If false, kill the claim
cleanly.

### Handoff / compaction / memory

Three related but distinct channels (principles doc scopes **in-loop** vs
**cross-session** carefully):

| Channel | Need |
|---------|------|
| **In-loop session** | Navigation state, staged edits, undo — performance only; write semantics still fresh-resolve |
| **Handoff document** | Next agent: structure skeleton + high-confidence annotations + continuation note; compressed prose |
| **Persistent memory** | Decisions, uncertainties, todos, project context as UDON (or MD today) that reloads next session |

Live consumers to design against: ASF process maps; this repo’s own
STATUS/OPEN/DECISIONS discipline; Grok experimental memory (markdown +
index) from sibling spikes.

### What memory wants from the format

- Stable identity (keys) so “the same decision” survives rewrite
- Annotations or traits that mark decision vs draft vs uncertainty
- Structure that survives summarization (keep skeleton, compress prose)
- Extract/query over mixed documents
- Soft/hard interleave (`udon-guarantees`): metrics stay hard; rationale soft

---

## 4. fmt / round-trip / ornamental

### Why agents care (not aesthetics)

Edit tools need **span-splicing**: untouched regions stay byte-identical.
That is the opposite of “always pretty-print the whole file.” Minimal
changeset cost (TST / proximity) wants:

- Serialize a **subtree** with correct indent relative to insertion site
- Escape correctly without agent thinking about it
- Round-trip enough of the model that re-apply is idempotent under stable
  paths (lens GetPut/PutGet/PutPut conditional on addressing)

`fmt` as whole-file house style is a **different product** — useful, and
M5-shaped — but not a substitute for edit substrate.

### Ornamental criterion (from pipeline discussion)

Joseph’s testable criterion (paraphrased):

```text
original.udon → (drop ornamental) → model → house-style.udon
house-style.udon → (drop house ornamental) → same model → same house-style.udon
```

Ornamental = discretionary geometry (extra blanks, alignment padding, indent
width beyond minimum) that changes **look** without changing the assembly
product (except trivia namespace for exact byte round-trip). Comments are
**not** ornamental (they’re nodes).

### Agent-facing consequences

| Product | Agent use |
|---------|-----------|
| **Byte identity** | Patch/diff against disk; span splice |
| **Recognition identity** | Same events + same recognition-verdict (± trivia) |
| **Assembly model identity** | “Did my edit change structure/content that matters?” |
| **House-style emit** | Optional normalize for human review or CI |

Agents mostly want model-level certainty + local spatial correctness, not
global pretty. Humans want fmt. Both are real; conflating them produces bad
edit tools.

### Soft/hard guarantees (`udon-guarantees`)

Profiles casual / careful / critical: same notation, different enforcement.
Agent edit tool is the **careful** gatekeeper for writes that flow through
agents. Critical may need store/query later — not generation-surface day one.

---

## 5. Recognition vs assembly products

Pipeline vocabulary (deliberation, not suite law yet):

```text
bytes
  → Recognition  → (event stream, recognition-verdict)
  → Assembly     → document model (ADM-ish) ± trivia
  → Resolution   → keys/refs/mixins/dialects/schema as policy
  → Evaluation   → host artifacts (templates, native types, …)
```

Sufficiency / no-reachback (W0 lean): each stage’s product must suffice for
the next without re-reading source. That is also the public-API promise for
“bring your own fold/consumer.”

### Which product agents need, when

| Agent activity | Primary product | Why |
|----------------|-----------------|-----|
| Stream generate / mid-write feedback | Recognition events + open stack + verdict | Incomplete docs are normal |
| Grammar-constrained decode | Recognition state machine | Next-token legality |
| Structural glance / focus / path resolve | Assembly model (or streaming assembly of closed subtrees) | Paths address model nodes, not raw events |
| Schema validate / careful apply | Resolution (or assembly + schema pass) | Conformance is a verdict |
| Liquid/template run | Evaluation | Needs host context |
| Semantic diff / merge | Assembly (± resolution for refs) | Tree operations |
| Memory chunk emit | Assembly boundaries | Element extents as chunks |
| Exact patch / span splice | Spans from recognition + model path | Bridge wire↔model |
| Handoff compress | Assembly skeleton + selected annotations | Drop evaluation noise |

### Dual assertion (C5)

Fixtures asserting **events and assembly product** matches agent needs: agents
sometimes care about wire honesty (streaming, keep-everything, incomplete),
sometimes about “what tree did I get.” Profiles idiomatic / comprehensive /
descriptive are harness concerns; agents consume the same products with
different strictness knobs.

### Streaming assembly

Not a second wire. Mode of assembly: emit completed root/subtree when it
closes. Agent tool responses can stream layers (structure first, semantics
later) as in ACP-format examples — that is assembly/evaluation pacing, not
new recognition events.

---

## 6. What the design corpus keeps re-deriving

Convergence worth holding (not as proof, as signal):

1. **Fail-on-ambiguity at write boundary** (`at`) with assistive menus
2. **Atomic multi-site edits** (`all` as one transaction)
3. **Validate inside the write**, not post-hoc
4. **Progressive disclosure** for read
5. **Structure-first mental model**; tools own whitespace
6. **Format as protocol payload** for tool and handoff I/O
7. **Annotations as first-class metacognition**, strippable
8. **Soft/hard interleave** without splitting into two formats

Independent legs claimed in principles doc: ELI phenomenology, Anthropic
product tooling, UDON spec discipline. Treat agreement carefully when sources
share authorship.

---

## 7. Gaps and dead ends noticed

| Gap | Notes |
|-----|-------|
| Paths not designed | Blocks edit, query, error-as-menu, ref subset |
| Annotation syntax invalid under 0.9 | Convention vs CORE ruling needed |
| Semantic merge underspecified | Real multi-agent need, no suite home |
| Self-chunking unmeasured | Claim or kill |
| Cheat-sheets / usability harness stale | After compliance pins behavior |
| Mid-generation affordance layer | TreeStream exists; agent API doesn’t |
| Grammar artifact not derived from descent yet | Technique known; harnessable |
| udon-paths / many Dec examples stale | Read for shape; CORE + TODO for truth |
| Multi-line WAIT-DEMAND | Must not pin from this spike alone |
| Cross-session vs in-loop | Easy to conflate; principles warn |

Dead end to avoid: building a mega-tool suite before paths + round-trip +
partial-tree query. The principles’ build order still looks right.

---

## 8. Provisional proposals (not law)

Boundary demands that *appeared* while reading — **proposals only**. Do not
treat as DECISIONS or OPEN rows until harvested deliberately.

### P-A. Stage products as public agent surfaces

**Proposal:** Suite vocabulary should name recognition-product,
assembly-product, resolution-product, evaluation-product as **consumable
contracts**, not only internal parser stages — because agent tools naturally
bind to different stages.

**Demand on pipeline:** W0 sufficiency stated per boundary; agent docs say
which product each tool reads/writes.

### P-B. Recognition-verdict channel for partial generation

**Proposal:** Incomplete-input and related generation stops surface as
**verdicts** agents can branch on, not as malformed ASTs or silent truncation.

**Pairs with:** C6 / OPEN C6; mid-generation feedback item.

### P-C. Edit tool binds assembly + optional resolution

**Proposal:** Default careful edit: re-resolve paths against current file →
mutate assembly model → syntax-validate → (if schema bound) resolution check
→ span-splice write. Never mutate from a cached recognition-only guess.

### P-D. Ornamental is out of agent happy-path

**Proposal:** Agent write path preserves non-touched bytes (byte identity
locally); does not run house-style fmt unless asked. Ornamental fixpoint is a
separate tool/profile so agents don’t pay full-file rewrites.

### P-E. Payload convention > new protocol

**Proposal:** Keep north star: UDON documents as tool results / handoffs /
traces **inside** MCP and similar. Do not re-open “build ACP as competitor
protocol” as v2 work.

### P-F. Annotation layer as WAIT-DEMAND or steward-touch syntax

**Proposal:** Until syntax is ruled, agents use host conventions (traits,
named note elements, out-of-band sidecar) for metacognition; CORE stays
silent rather than inventing `|{@`.

### P-G. Multi-line / value extent demand from agent stream+edit

**Proposal:** When paths and mid-generation spikes exist, run scenarios that
force multi-line attr values and partial multi-line constructs — let **pain**
choose among greenfield strawmen. Until then ML stays WAIT-DEMAND.

### P-H. Memory chunk experiment as harness, not CORE

**Proposal:** Self-chunking evidence lives in UX/eval harness; CORE only needs
to keep element extents recoverable from assembly product.

---

## 9. Top agent-facing needs (harvest list)

If this spike is only remembered for one page, remember these:

1. **Stable structural addressing (paths)** — write `at`/`all`, error menus,
   skeleton, refs, merge, focus.
2. **Principled edit** — atomic; tool-owned indent/escape; mutation-free
   teaching refusals; apply-time re-resolution; syntax then schema.
3. **Mid-generation / partial-document fidelity** — open stack + recognition
   verdict + early anomalies (semantic streaming).
4. **Stage-appropriate products** — events for stream/constrain; assembly for
   tree ops; resolution for careful validate; don’t force one “the AST.”
5. **Progressive read** — glance/skeleton before focus/full; context window as
   design constraint.
6. **UDON as tool/handoff payload** — structured + prose + optional
   annotations; streamable layers; same tooling as documents.
7. **Round-trip / span-splice substrate** — edit without full pretty; model
   identity vs ornamental vs bytes kept distinct.
8. **Metacognition residue** — confidence/decision/uncertainty queryable and
   strippable (syntax open).
9. **Handoff & compaction** — preserve structure and decisions; compress
   prose; continuation point explicit.
10. **Soft/hard guarantees dial** — casual explore vs careful agent write vs
    critical store; same notation.
11. **Grammar-constrained generation** (local models) + harness measure of
    invalid rates.
12. **Evidence for chunking / multi-line / merge** before pinning those as law.

---

## 10. What not to do from this residue

- Do not implement tools here
- Do not edit DECISIONS or live CORE from these proposals
- Do not treat Dec-2025 syntax as current
- Do not nail multi-line, wire vocab, or annotation syntax supply-side
- Do not require the next spike to fill a template

---

## 11. Possible next explorations (optional, nonprescriptive)

- **Paths spike** — demand scenarios from edit + error-as-menu + ref subset
- **Partial-tree API sketch** against real TreeStream (read-only experiment)
- **Three day-in-the-life scenarios** (schema-guard-before-write,
  handoff-mid-edit, contested-claim) written as agent transcripts against
  stage products
- **Chunking micro-experiment** on design/examples or ASF maps
- **Annotation convention sandbox** without CORE change

Any of these can ignore the others. Residue that changes OPEN should cite
this NOTES section.

---

*End of free-form residue. 2026-07-21.*

