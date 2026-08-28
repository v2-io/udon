# UDON Core Specification

**Universal Document & Object Notation — 0.10.1-draft (material/deferred unification)**  
**Status: PROPOSAL DRAFT — nothing here is ratified.** This suite restates the language on the two-kind ontology (material / deferred) of the lexical-forms-redux line and the addressing theory (`../references/def/`). The 0.9.1/0.10.0 suites remain the authoritative record; behavior changes are exactly the [DELTAS.md](DELTAS.md) rows; **material-half sections here are condensed restatements** — where this draft's condensation loses a 0.10.0 nuance without a DELTAS row, that is a defect here, not a change. Spelling decisions this draft mints are marked **⟨PROPOSED⟩** with alternatives.

**Companions:** [MODEL.md](MODEL.md) · [GLOSSARY.md](GLOSSARY.md) · [SEMANTICS.md](SEMANTICS.md) · [CARVEOUTS.md](CARVEOUTS.md) · [DELTAS.md](DELTAS.md) · [README.md](README.md).

The key words MUST, MUST NOT, SHOULD, and MAY are per RFC 2119.

---

## 0. The guiding model

Orientation, not law; sections govern.

- **G1 — Indentation is the hierarchy.** Deeper = child, same = sibling, shallower = closed (the Nesting Rule, §2.1); no closing tags. Delimited constructs close by their printed closer, never by geometry.
- **G2 — Why sameline works.** Blocks-plus-indent give every geometric construct a place to end; sameline structure sits at its true column as if written vertically, and block-opening markers double as value terminators.
- **G3 — Sameline is value-space; block interiors are text-space.** All sameline material is an assignment value; prose lives in block interiors, where markers are literal.
- **G4 — Everything named about an element is an assignment.** Identity, traits, suffixes, sameline text — all sugar over designated assignments; repetition stacks silently; every assignment takes a value.
- **G5 — Two kinds of item: material and deferred.** Material (things, facts, text) is determined at writing. Deferred material — **references** (stand for; `@`) and **generators** (produce; `!`) — is determined at *use*, from an origin, as of a moment. **The recognizer's schedule is: hold everything.** Recognition never resolves, dereferences, or evaluates; it delivers deferred items as artifacts. (The whole of def-reference/def-generator applies; this spec defines only the surface.)
- **G6 — Hold is one operator at every level.** `\` holds at the character/line level; the capture bracket holds spans and — composed with a species sigil — holds a deferred item as a value. Held material travels as data; a consumer un-holds by one level when it determines.
- **G7 — Typing is syntactic and the bare set is frozen.** The bare scalar set is closed forever; growth lives visibly in captures `<…>`. A vocabulary structurally cannot retype bare space.
- **G8 — Keep everything; severity is loss.** Recognition never silently drops author-visible bytes. Resolution-side misses are not recognition anomalies at all: their meaning comes from intended-cardinality, their response from the consumer.

## 1. Conformance and ownership

A conforming **recognizer** maps any finite UTF-8 input to a Document (MODEL §1) — content, anomalies, result — holding all deferred material unresolved. It MUST recognize every marker, guard, and desugaring here; it MUST NOT determine (resolve, dereference, evaluate) anything.

| Concern | Owner |
|---|---|
| Path grammar, origin, resolution policy, misses | the addressing theory (`../references/`), exercised by consumers |
| Evaluation of generators (which vocabulary acts, how) | consumer + generator vocabularies |
| Interpretation of held spans (kinds) | the named vocabulary (dialect) |
| Constraint (allowed/required) | Schema — judges the model, never shapes it |
| Projection to native values; `$main` presentation | Host |
| Duplicate `(name,key)` policy | Document layer — **collide policing** (def-binding); menu: `error \| allow-if-identical \| first-wins \| last-wins \| keep-all` |
| Stance schedules (what determines when) | pipelines/stores above recognition |

Menu-vs-knob and additivity rules carry from 0.10.0 §1.1 unchanged.

## 2. Source text and geometry *(condensed carry: 0.10.0 §2)*

Lines by U+000A; column = leading spaces from 0; **indentation is spaces only** (tab in indent: Warning, best-effort keep). **The Nesting Rule** (§2.1): `pop while c <= top.base_column, then push`; sameline items occupy true columns; text interiors deeper than an established content base are literal. **The two spaces** (§2.2): value-space (all sameline material is an assignment value) vs text-space (block interiors; markers literal; the framed ` ; ` annotation is the one carve-out). Structure Position and bounded lookahead as language law carry unchanged.

## 3. Marker guards

| Marker | Opens | Guard |
|---|---|---|
| `\|` | element; `\|{` inline element | identifier-start, `[`, `.`, `'`, `{`, or suffix char — `\| ` stays literal |
| `:` | assignment | non-space follows |
| `@` | **reference** | `[`, `.`, `{`, `<`, or identifier-start |
| `!` | **generator** | identifier char or `{` — `!=`, `![img](x)` stay literal |
| `<` | capture (value position only) | value-expected position; literal in text-space |
| `;` | annotation | per position table (§8) |
| ` ``` ` | fence | any Structure Position |
| `\` | hold (one char / rest of line) | §4 |

`!{{` is no longer a form (DELTAS 1). A marker failing its guard is ordinary text.

## 4. Hold at the lexical level: `\` *(carry: 0.10.0 §4, reframed)*

`\` is the hold operator applied to source characters. **Attached `\X`**: hold one character — `X` is literal, scan machinery stays live. **Framed ` \ `**: hold the rest of the physical line as text (spaces preserved, dead to markers and annotations; terminates an open value; the column-anchor idiom carries). Anywhere else `\` is a literal backslash (`C:\Users\me`). All 0.10.0 §4 behavior carries, including the empty-forced-tail rule.

## 5. Elements *(condensed carry: 0.10.0 §5)*

Shape (name? + ordered assignments + ordered content), names (UAX #31 + `-` `/`; declared Unicode host profile), identity `[key]` as a value slot, traits, suffixes, anonymous elements, inline `|{…}` (brace-balanced, bracket mode, multi-line, mixed interior), `$partial-key` fail-safe, empty-bracket collapse — all carry unchanged. Sugar desugars to designated assignments (`$key`, `$traits`, `$?`…, `$main`), born finished.

## 6. Assignments *(condensed carry: 0.10.0 §6)*

Labeled edges with ordered heterogeneous content; expressive labels, no flag semantics; every assignment takes a value (missing → Error + Nil, the sole core Error); the Line Scan with self-announcing values and unquoted-text terminators (space + guard-confirmed marker · framed `\` · framed ` ; ` · EOL · context terminator); slots and line roots; deferred bodies with the value-expected first line; one value grammar at every value-expected position; stacking silent, a label names a collection; node values and the one-way door; late assignments accepted + warned. All carry unchanged. **One addition**: a reference or generator at a value-expected position is a value like any other (§9); a *held* one (§9.4) is a value whose type is reference/generator.

## 7. Text *(carry: 0.10.0 §7)*

Flow (one prose-shaped content model: ordered segments), content base and dedentation, blank-line two-layer model, final-terminator disposition, the text law — all carry unchanged. Flow's segment inventory changes only by DELTAS 1/2: embedded references `@{…}` replace interpolations; inline generators `!{name …}` continue as segments.

## 8. Annotations *(carry: 0.10.0 §8, principled)*

`;` opens an **annotation**: uninterpreted material addressed to the document's maintainers instead of its consumer. The position table, framing rules, continuation-ownership, and carried-not-discarded rule all carry from 0.10.0 §8 unchanged. What is now principled rather than accidental: an annotation's interior is **opaque by definition** — "structure" inside it is the spelling of structure — which is why one `;` can silence anything, and why annotations need no interior grammar at any position. `;{…}` is the in-flow form, contributing no text.

## 9. Deferred material

Everything in this section is recognized and **held**. Determination — resolving a reference, evaluating a generator, construing a capture — belongs to consumers, per their own schedules, from their own origins, as of their own moments.

### 9.1 References `@`

A reference is recorded material standing for referents (def-reference). Surface family:

| Position | Form |
|---|---|
| Block / sameline (the scan) | `@head` — a reference child / reference value; equal footing with `\|` |
| Embedded in flow | `@{head}` — a flow segment whose determination yields material in place ⟨PROPOSED — replaces `!{{expr}}`; DELTAS 1⟩ |
| Held as a value | `@<head>` — the reference itself is the value; its type is "reference" ⟨PROPOSED — Joseph's 2026-08 seed; alternative: `<ref: head>` via the capture ladder⟩ |

- **`head` is a path expression whose grammar the addressing theory owns** (CARVEOUTS §PATH). This version recognizes the 0.10.0 selector subset (`name?`, `[key]`, `.trait`*) plus, in the `@{…}`/`@<…>` delimited forms, a raw brace/bracket-balanced head carried whole for the future grammar. The frozen-selector rule (no incremental field growth) carries.
- **Intended-cardinality ⟨PROPOSED⟩**: a trailing suffix on the head declares it — none = `{1,1}`, `?` = `{0,1}`, `*` = `{0,N}`, `+` = `{1,N}` (`@author` · `@reviewer?` · `@tags*` · `@authors+`). This reuses the existing suffix vocabulary in exactly its schema/arity sense and gives every miss its meaning (def-reference) with no per-construct error rules. Recognition records it; it never fires at recognition.
- **Unclosed/truncated heads fail safe**: recognized-but-partial, marked so no consumer determines them (`$partial-key` discipline, carried).
- Origin-posture (relative vs universal-origin) is part of the path grammar — owner: addressing theory.

### 9.2 Generators `!`

A generator is deferred material that *produces* (def-generator). **A generator parses exactly as an element does** — same name rules, identity, assignments, sameline values, geometric body, one-way door — with `!` marking the species (DELTAS 2):

```udon
!if @{user.admin?}
  |admin-panel
!else
  You are not an administrator.
!for :item @{posts*} :as post
  |card :title @{post.title}
!let :featured @{posts | featured}     ; head grammar: addressing theory
```

- **The head-line is parsed, not swallowed** — `!if @{c} :y 2` gives `y` to the generator by the ordinary node-value one-way door, not to a special rule. Arguments are ordinary values: references, scalars, captures.
- Chains (`!else`, `!elif`) are same-column adjacency, a vocabulary concern, not core structure.
- Inline form `!{name …}` (UDON-parsed body) continues as a flow segment and value.
- **Recognition holds every generator** — carried verbatim in the model, never evaluated. (0.10.0's "inert this version" becomes the permanent recognition-layer stance rather than an interim mode; *evaluation-time* hold — a generator surviving one evaluation as data — is the schedule's business: CARVEOUTS §HOLD.)
- Which generator names exist and what they do is a vocabulary's (the baseline template vocabulary is a companion, not core). Evaluation's failure vocabulary is open (def-generator).

### 9.3 Captures `<…>` — held spans for a vocabulary

A capture holds a span for interpretation by a named vocabulary; it unifies 0.10.0's envelope and verbatim families (DELTAS 3):

| Geometry | Form | Body |
|---|---|---|
| value | `<body>` · `<kind: body>` · `<vocab:kind: body>` | span, `<>`-depth-counted, multi-line |
| block (geometric) | `!:kind:` + deeper body ⟨spelling retained; re-owned as the capture family's geometric form — respelling open, CARVEOUTS §CAP⟩ | dedented to the raw base |
| fence | ` ``` ` | byte-exact |
| in-flow | `!{:kind: …}` | brace-balanced segment |

- The ladder (`<content>` → `<kind:content>` → `<vocab:kind:content>`) carries from 0.10.0 §11.6; "envelope" remains its name in value position.
- **Unlabelled dispatch is resolution, not bespoke machinery**: the capture is a reference into the document's declared-vocabulary scope; declared order is a *preference* policy; all-decline is a miss against `{1,1}` (meaning from cardinality; response from the consumer). No dialect loaded: the span passes through lexically, nothing lost — carried behavior, now derived.
- Bare recognition stays frozen (G7): a capture is the only growth surface.

### 9.4 Stance and schedules *(informative)*

The recognizer holds; consumers determine. A pipeline or store is a schedule of uses: which items get determined at which stage, from which origin, as of which moment — and which are held past it. "Uncooked" is a property of an item, not a stage; outer-vs-inner template material is one mechanism at two origins; a store may keep held references and resolve per-query (a later as-of moment). None of this is recognition's business, which is precisely why this spec got smaller.

## 10. Values and types *(condensed carry: 0.10.0 §11)*

The frozen bare scalar set (string, integer, float, boolean, nil, list), numbers (four bases, `_`), strings (no in-string escapes; the other quote kind), booleans/nil (four states, lowercase, alone-at-terminator), lists (`[…]`, items by the full value grammar, no multi-word bare text) — all carry unchanged. **Each delimited capture's grammar owns its own line-span** (the ML dissolution, DELTAS 4): `<…>`, `|{…}`, fences span; strings span; lists and identity brackets keep 0.10.0's current behavior *as this draft's stated rule* pending the capture-sugar question (CARVEOUTS §CAP).

## 11. Extent and end of input *(carry: 0.10.0 §13)*

Geometric vs delimited; every construct declares its kind; EOF ≡ end-of-line + full dedent; unclosed delimited constructs keep content + one Warning citing the opener; `incomplete-input` as the document result. All carry unchanged. §13.2's per-construct multi-line table is retired (DELTAS 4).

## 12. Anomalies *(carry: 0.10.0 §14)*

Two severities defined by loss; the sole core Error is the missing required value; keep-everything wherever a coherent keep exists; the consumer response ladder. All carry unchanged. **Removed from the recognition inventory**: resolution-side conditions (`NoDialectsLoaded` and kin) — those are misses, meaning from cardinality, response from consumers; a recognizer MAY surface them as advisories when it also plays a consumer role.

## 13. Design principles (normative constraints)

1. Sameline is value-space; prose lives in bodies.
2. Spaces only in indentation.
3. Syntactic typing; the bare set frozen; captures are the only growth surface.
4. Stacking, not last-wins — silently.
5. Bounded lookahead as language law.
6. Sugar is designated assignments, never parallel model fields.
7. **Recognition holds; it never determines.**
8. **One hold operator per level; one deferred family per species** — a new deferred construct is a new head in an existing family or it is ill-formed.
9. Keep-everything; severity = loss; miss meaning from cardinality.
10. Every construct declares its extent kind and inherits its EOF story.
11. The text law (MODEL §6).
12. **No spelling fixes origin or moment** — those belong to uses and schedules; the surface carries only the writer's declared origin-posture and cardinality.
