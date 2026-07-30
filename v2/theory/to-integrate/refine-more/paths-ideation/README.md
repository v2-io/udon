# Paths — ideation seed

**Status:** broad ideation, not a spike. Possibility-opening, not decision-making.
Everything here is **proposed / leaning / open** unless it cites a ratified ledger
row — and where it does (`DECISIONS`/`OPEN`), that ruling is the authority, not this
page. `spec/CORE.md` (0.9.1) is the oracle for current language facts.

**Register note.** Claims are marked in their true voice: *decided* (a ledger ruling
or Joseph's on-record lean — cited), *evidenced* (the demand corpus supports it —
chapter cited), *proposed* (generated here — decides nothing). Written in markdown
by design: dogfooding UDON for this waits on an MVP parser (Joseph, 2026-07-23 —
"markdown/frontmatter + plan to migrate" until then).

**Two framings held apart on purpose (Joseph, 2026-07-23):**
- *Theoretical* — is a path language *necessary*, *complete*, *unique*? This is a
  separate track and **does not gate ideation**. We brainstorm and spike plausible
  path solutions freely; whether any is load-bearing-necessary, or whether the set
  is complete/minimal, is adjudicated elsewhere.
- *Practical* — what would a good path capability *look like*? That is this page.
  And "one and only one path syntax" is **not** a requirement: a coherent
  **collection** of path forms with different strengths and affordances is on the
  table (colloquial-uniqueness is dropped).

Source of the substance: the tooling report's addressing work —
`../../udon-needs/02-tooling-needs/reports/addressing-exploration.md` (the demand
map, §4 terminator stress cases, §8 D1–D9, §9 traps),
`../../udon-needs/02-tooling-needs/src/addressing-is-the-long-pole.md` (the bridge),
and the ledgers (`../../DECISIONS.md`, `../../OPEN.md`).

---

## 0. The scope of the word — *to* / *into* / *across*

A framing correction seeds the rest (Joseph, 2026-07-23). "Path" in ordinary usage
means **to a resource** — `/usr/local/bin`, `https://…`, `~/src/udon`, a wikilink.
The addressing corpus (and an earlier draft of this seed) drifted into treating a
path as *only* the XPath-shaped descent **into** a document's tree — the exact
inherited habit the demand work warns about: the jq/JSONPath/XPath lineage hands the
document out-of-band, so "path" in that tradition definitionally *excludes* naming
the document, and that assumption bleeds forward. **PATH-1 exists to refuse the
narrowing** (cross-document is in scope by ruling). So the subject is one continuous
spectrum, not two:

- **To** — *locate the resource*: filesystem path, URL, project-root-anchored handle
  (`⊤`/`¤`, git-resolved), a remote address. The usual meaning; the half most easily
  under-weighted.
- **Into** — *descend the tree*: relational `\|\|type[key]`, tree `\|a\|b\|c`, attrs,
  traits, refs.
- **Across** — *they compose*: `⊤/spec/CORE.md#\|\|section[nesting-rule]` is a path-to
  plus a path-into, exactly as a URL carries a fragment and a wikilink carries a
  heading. The shipped precedent is real: sapientia's `@⊤/entities/zi-am-tur.md`
  imports *located a document and named it* in one expression.

**The UDON-native question underneath (proposed, not decided): is the seam even
real?** UDON's founding claim is that documents and data are the same thing — so a
directory of `.udon` files is *itself* a tree of named nodes, and
`⊤/spec/CORE/nesting-rule` could be **one descent through named structure** where
`CORE.md` is merely a file-backed node you walk *through* without "entering a
document." The filesystem would be the outer part of the same tree the elements form
inside; "path" would mean the same operation at every altitude. That is what
`⊤`-anchored imports already gesture at. If it holds, the to/into distinction
*dissolves* rather than needing a bridge — and it reframes much of §1–§3 below.

Consequences threaded through the rest of this doc:
- **Anchoring is the *locate* half** (§2a), co-equal with tree-selection, not a
  sub-item of it.
- **The harness pulls hardest here** — its native addressing is files, URLs,
  imports, and cross-repo LSP references; almost all path-*to*.
- **Templates, references/mixins, memory `@import`** are mostly *across*-document
  pulls (§1), not the in-document ones an XPath frame assumes.
- Two facts a "paths" language inherits by its own name: UDON already uses `/` as
  **namespacing inside names** (`acme/widget`, core-inert) — collision-or-rhyme with
  the filesystem `/`; and users who hear "path" arrive **expecting path-*to*
  affordances** (a separator, `..`, anchors, maybe globs) — an expectation an
  in-document-only design silently breaks.

---

## 0b. Two axes: *reach* and *role* — the joint situation

§0's to/into/across is one axis — **reach**: how far a *single* address travels to
name *one* place. It misses a second, orthogonal axis that is arguably more central
to agentic work — **role**: is the address *reaching* one place, or **joining** two
or more? (Joseph, 2026-07-23 — the earlier framing under-represented this.)

The exemplar is `from ..pkg import mod`: one statement joining a relative anchor
(`..`), a named descent (`pkg`), a member selection (`import mod`), and a **binding**
(the remote name becomes a local one) — three heterogeneous addressing modes and a
graft, across two operands of a construct. It is *across* on the reach axis and
**joint** on the role axis. Single-reach addressing (a filesystem path, an XPath) is
only one corner; the joint forms:

- **Multi-slot address** — locate and descend as *separate operands*, not one fused
  string: `from X import Y`, XInclude `href` + `xpointer`, JSON Patch
  `{op, path, value}`, `git checkout <rev> -- <path>`. **A third answer to the seam
  fork (§0/§2g):** neither one fused string nor a boundary glyph — two arguments a
  construct binds. It sidesteps the terminator problem entirely (nothing is fused, so
  nothing needs a terminator) *and* the substrate-collapse ambition. Likely the
  cheapest and most-precedented of the three.
- **Join by shared value** — relate two things because they *share a value*, not
  because one contains the other: SQL `JOIN … ON a.k = b.k`. The one structurally
  different paradigm the survey isolates.
- **Graft / mount / bind** — combine two trees: Plan 9 `bind`/`mount`, symlinks,
  transclusion (`xi:include`, `{{template}}`), and `from..import`'s local binding.
  The address serves *splicing one structure into another*.
- **Splice at an address** — edit/patch: a value placed *at* a path (address +
  payload joined) — `{op, path, value}`.

**Why this matters to us, sharply: UDON's own path-uses are overwhelmingly joint,
not single-reach.**
- `@` references — a stored address that, resolved, *joins* two places (transclude /
  merge-attributes).
- **Mixins are already a join-by-shared-value** — trait-matched attribute
  inheritance (CORE §12.4) is the relational paradigm *native in the language*: two
  elements combine because they *share a trait*, not because one contains the other.
  So the "predicates beyond traits+keys" pressure (§2f) and mixins are the same
  relational force, already inside UDON — not an external paradigm knocking.
- The **schema-guarded edit** is a splice (`{op, path, value}`); the **template**
  directive is `from X import Y`'s shape (locate a context, select within it); and
  **semantic merge** joins two edited trees.

The to/into/across frame described *reaching*; almost everything we actually do with
paths is *connecting*. The "collection of forms" (§3) must therefore include **joint
constructs** — the reference, the edit op, the template directive — whose *path* is
one operand among several, not a standalone string.

---

## 1. Why paths are the shared "where" — how the other areas pull on them

The through-line from the whole agentic-tooling body: **nearly every affordance
bottoms out on stably naming a place** — where "place" spans §0's range: another
document, a node inside one, or both at once. Paths are not one feature among many;
they are the primitive the other features consume. Many rows below have an
*across-document* form as real as their in-document one (imports, transclusion,
cross-file trace); read them through §0. Below, per area, is *what it needs from
paths* and *why* — UDON-primary, but the harness column is real (its markdown
estate has the same addressing needs, and LSP `references` ≈ `all()`, a tree-sitter
query ≈ a structural selector).

| Area | What it needs from paths | Why / pull strength |
|---|---|---|
| **Guarded structural edit** *(the #1 demand — the organizing customer)* | a write target that resolves to **exactly one** node or refuses loudly; re-resolve at write time; `all()` as one atomic transaction over the **pre-patch** tree (CAS); an address→byte-span bridge for splicing; a distinct **stale / not-found / not-unique** failure vocabulary | Paths are the "where" of every guarantee. Evidenced — the edit pulls paths+schema+spans+round-trip at once; that coupling is *why* addressing is the long pole. |
| **Query / read** | `at` (exactly-one) vs `all` (explicit plural); relational lookup `\|\|type[key]` at any depth; **skeleton lines that are themselves valid addresses**; error-as-menu of candidate paths; trace ("what refers to this / what does this refer to") | The read path and edit path become *one loop* only if what you can see (skeleton) is what you can address. Evidenced. |
| **Schema** | schema selectors — "node at path P must be type T / carry attribute A"; conformance verdicts *located at a path*; constraint scoping | Schema addressing **is** paths. Schema sits on top of the path layer. Evidenced (schema work names it). |
| **Dialects / value-typing** | the envelope's `<…>`-balanced extent and any `<path:…>` form share the **terminator question** with in-document paths; nested-envelope routing is the same "who owns the extent" problem | Indirect but real — the type-envelope wire and the in-doc path wire touch at exactly the unsolved boundary (§4). |
| **Templates / dynamics** | when the scope-context is itself UDON, `!{{…}}` interpolation and `!if`/`!for` **resolve by addressing into the context document**; the interrogable contract ("needs these names / predicates") is path-shaped | Templating couples to addressing *independently* of the edit tool — two unrelated products arriving at one dependency (Joseph's own realization). Evidenced. |
| **References (`@`)** | in-document `@` **is** an address the document makes; ref ⊂ path (ruled direction) | The smallest in-doc reference form that is a *true subset* of the full path language is the load-bearing open question (see §2, Embeddability). Decided-direction; subset open. |
| **Annotation / metacognition** | strippable residue must be **queryable by the same path language as content**; the designated-`$` accessor channel is path-reachable; a congruency reader addresses past states | "Queryable by the same paths as content" is a stated requirement of the annotation demand. Evidenced. |
| **Memory / continuity** | stable identity keys so "the same decision" survives a rewrite of the text around it = stable addressing; a retrieval hit that is **an address into the live document**, not an offset into a dead snapshot; attestation records addressed; handoff skeletons = addresses | The reinjection channel needs its contents to stay addressable across rewrites. Evidenced (persistence, self-chunking). |
| **Round-trip / span-splice** | a per-node **byte-span map** (address→{offset,length}); the prior art is one shipping tool's `match()` returning `{string, offset, length, captures}` | Span-precise editing without reparsing needs the address↔span bridge as a first-class product. Evidenced. |
| **Context economy / progressive disclosure** | glance→focus needs the skeleton to *be* addresses; spill-with-table-of-contents is an addressable parked artifact | A 200-token addressable glance replaces a 5000-token full read. Evidenced. |
| **Cross-file / multi-agent / human steering** | cross-document addressing (in scope); orphan-reference trace; soft-claims / leases over a path; **structural diff in path vocabulary** ("moved" vs "delete+add"); impact analysis before a risky write | Multi-writer editing is a present condition; reviewers trust a 3-line path-scoped diff, not a 300-line reformat. Evidenced. |

**Synthesis.** Read the column top to bottom and one word recurs: *stability*. The
common demand under all of these is **an address that does not rot** — survives a
rewrite (identity, not position), survives a file move (root anchors), survives a
concurrent edit (re-resolve + freshness), and survives being handed to another
agent or a human (portable, cross-document, legible). Paths matter to the other
areas because they are each, in the end, asking the same thing: *let me name this
place and still mean it later.*

---

## 2. Capabilities & considerations — an expansion of the earlier bullets

Clustered so it stays ideation, not a spec. Each cluster: the options / points to
consider, with a **status** column (`decided`/`leaning` cited · `evidenced` ·
`proposed` · `open`). Nothing here closes a `DECISIONS`/`OPEN` row.

### 2a. Locating the resource — paths *to* and *across* (the half most easily lost)

This is the ordinary meaning of "path," and per §0 it is co-equal with tree-descent,
not a sub-item.

| Consideration | Notes & evidence | Status |
|---|---|---|
| **Anchor kinds**: relative (from here) · absolute (fs root) · home (`~`) · document-root · **project-root** (`⊤`/`¤`, git-resolved) | Convention gives readers the first three everywhere. Project-root shipped in sapientia (`⊤` → `@⊤/entities/…`, clear error outside a repo); Joseph wants `¤/tests/fixtures` "from any file — comes up all the time"; **three sigil dressings converged** (`⊤`, `@⊥/`, `¤`). Motive on record: *address stability under motion* (a moved file breaks relative paths; root-anchored survives; a root-layout change repairs with one search-replace). | project-root **wanted** (Joseph); sigil undecided; multi-anchor a natural lean |
| **Resource kinds** the "to" half must reach: a local `.udon` file · a directory · a non-UDON file (markdown, the harness estate) · a URL / remote resource · an in-memory / streamed document | The harness's whole world is here (files, imports, cross-repo LSP references); `CONSUMERS.md` is a live registry of UDON docs *across* the filesystem that already needs cross-resource addressing. | evidenced (harness-primary) |
| **The compose syntax** (across): how *to* and *into* join — a fragment separator (`#`, like URLs/wikilinks), or a continuous descent (§0's seam-dissolves stance) with no separator at all | Shipped precedent: `@⊤/entities/x.md` located-and-named in one expression. In-path (`file#\|\|x`) vs out-of-band (`:file` on the op) is the open form question; interacts with PRAGMA (doc→dialect/schema binding). | decided-in-scope (PATH-1) · form open |
| **`/` collision-or-rhyme**: UDON already uses `/` as namespacing *inside names* (`acme/widget`, core-inert). A filesystem-style path-to also wants `/` | Either a genuine collision to resolve, or an opportunity to make one separator mean "descend a named tree" at both altitudes (which is the seam-dissolves reading). | open (sharp) |
| **Inherited-name affordances**: users who hear "path" expect `..`, a separator, anchors, maybe globs — the path-*to* vocabulary | An in-document-only design silently breaks the expectation its own name sets. Adoption + pedagogy consideration, not just mechanics. | proposed |
| **Resource-as-node** (§0): is a file-backed document just a node in the outer (directory) tree, walked *through* rather than *entered*? | If yes, path-to and path-into are one grammar and the terminator/seam questions (§2g) change shape. Deep, and the most generative open stance here. | proposed (open) |

### 2b. Selection model — relational vs tree

| Consideration | Notes & evidence | Status |
|---|---|---|
| **Relational-first** `\|\|type[key]` (any-depth, primary-key lookup) as the primary mental model; root-to-leaf `\|a\|b\|c` navigation as secondary | Nearly every scenario query began "find the element with this key, at any depth" — the tree served as storage, not as the mental model. **Inverts the XPath assumption.** | evidenced, but **one-day sample** — the thing I'd stress first |
| Falsifier to run early | Stress relational-first against **append-only logs** and **prose-heavy docs where keys are unnatural** — exactly where `[key]` lookup may not be the natural entry. | proposed (falsifier named) |

### 2c. Brackets — identity vs positional (collision P1)

| Consideration | Notes & evidence | Status |
|---|---|---|
| `[…]` = **identity** under normal value rules (`[1]`=int key, `["01"]`=string key); **position** via host indexing over `all()[i]`, not path syntax | Scenario evidence: typed-key equality *was* used (`\|\|intent[42]` ≠ `\|\|intent["0042"]`); positional access was **never wanted once**. Consistent with "paths look like UDON" and with CORE identity rules. | leaning (evidence-backed) |
| **Trap** | The stale `design/udon-paths.md` says the opposite (integers positional, strings identity). A spike agent trusting it inherits the sharpest known bug. | flagged |
| Distinct positional mark *if ever needed* (`[#0]`, `#0`) | Honest cost: a new symbol. Only if demand appears. | open |

### 2d. Cardinality & failure

| Consideration | Notes & evidence | Status |
|---|---|---|
| **`at` = exactly-one-or-error**; **`all` = explicit plural** — do not overload one API | High confidence from scenarios. A silently-empty result leaves the agent unable to tell "absent" from "wrong path" from "doc changed." | evidenced (high) |
| **Distinct failure names**: `PathNotFound` / `PathNotUnique` / `ReferencePlural` / `Stale` (file changed since read) | Four situations, four repairs (re-derive address / disambiguate / pick / re-read). One name covering two routes a reader to the wrong fix. Ties to errors-that-teach (menu-shaped, loud). | evidenced |
| Read may be fuzzy/plural; **write must resolve-one or refuse** | The generation-vs-careful-write posture split, applied to addressing. | proposed |

### 2e. Attributes, traits, references inside a path

| Consideration | Notes & evidence | Status |
|---|---|---|
| Traits AND-filter: `.a.b` = both (mirrors `$traits` stacking) | Matches document desugaring. | evidenced |
| `\|.trait` = anonymous-with-trait (mirror the document); `\|*.trait` = **any** element with trait | Mirror-the-document + `*` for wildcard removes the P3/P4 ambiguity with no new symbol. | proposed (leaning) |
| Stacked-attribute access (P2): `at(:x)` over a stack → last? first? error-if-plural? · `all(:x)` → every assignment in order · navigate into node-values (`\|api:headers\|header[auth]:value`) | Must keep **plural-match ≠ plural-value ≠ plural-reference** — three different failures needing distinct names (see 2d). | open |
| Reference segments (P5/P6): leading `@user[alice]` (definition lookup, type-scoped index) · trailing `:customer@` (follow the ref, continue at its definition) · unresolvable = loud under `at`/`all`, never silent-empty | Composition already appears in scenarios (`\|\|process[valve]:fed-by@:health`). | open (composition sketched) |

### 2f. What paths deliberately don't address (yet) — re-examine under edit pressure

| Absence | Where pressure returns | Status |
|---|---|---|
| Parent `..` | relative paths from a current node in an interactive skeleton | open |
| Predicates beyond traits+keys (attr-value filters) | scenario day wanted an attr-value filter **~4×** — the strongest "maybe a second-class filter" signal | open (frequency-gated) |
| Globs / Kleene `*` | **Rechecked 2026-07-29 (Joseph + Fable): the old "leaning: no / Never?" is retracted as unprincipled** — it was one narrow spelling fact (`\|foo*` bare in-document already means `$*`-flagged `foo`) plus a one-day absence claim, while the language had already committed to star semantics where it matters most (`\|\|` *is* recursive descent, `**`'s sibling), O13 sanctions `*`/`**` at file and stem altitudes, and the same scenario day wanted pattern filters ~4×. Sharper still (Joseph): the flag-suffix characters `? ! * +` were added **exactly for** grammar/cardinality readings (CORE §5.4's own gloss: "`?` 0-or-1, `*` 0-or-more, `+` 1-or-more") — so the definition-desugar semantics (`$*` = true) is an old grammar decision that must not swing selector syntax; on a *selector*, `\|foo*` has three candidate readings to adjudicate, not a collision to flee: (a) cardinality (0-or-more `foo` — the suffix's design intent), (b) match-by-flag (mirror-the-document: select elements carrying `$*` — which this table's own last row wants for `?`), (c) name-glob (probably wants a distinct spelling). Real constraints that survive: segment-repetition needs bag semantics or bounds (`*1..3`) to stay tractable (survey #173, NP-complete under simple-path semantics); name-stars are cheap filters everywhere. | **open** (three readings named; no lean) |
| **Prose / comment / verbatim-body** segments | the tree has Text nodes but the syntax doesn't address them → **no path can `set` a paragraph** today. A real gap the edit tool will hit. | open (real gap) |
| Suffix flags (`? ! +`) on path segments | "every `?`-marked process" has no path today; mirror-document spelling vs stay-invisible | open |

### 2g. Embeddability — the terminator table (D2, §4) — **the highest-value unbuilt thing**

Today every scenario path is a **quoted string**, because a bare leading `|`/`@` in
value position is already a node/reference value. Whether a path ever gets a bare
in-document form collides with value termination, arrays, and inline brace forms —
and `addressing-exploration §4` has the stress cases but **not the answers**: "this
spike does not build the prototype; without it, subset claims are soft."

Three futures (exploratory):
1. **Stay quoted forever** for tool ops; in-doc refs stay one-segment `@…`. Cheapest; keeps the wire simple.
2. **Dialect envelope** `<path:\|\|intent[311]:status>` — self-delimiting, interior can use `|` freely, aligns with the self-delimiting-value lean (W1d). *(This is where paths and the type-envelope wire literally share a boundary.)*
3. **Grow bare `@`/`|` multi-segment** in value position with a hard terminator grammar — highest "paths *are* UDON" purity, highest recognition cost.

> **The one concrete probe worth forcing whenever a spike happens:** run §4's
> terminator stress cases against real CORE value contexts with a descent prototype
> and *produce the table*. It converts every soft in-document-path claim into a
> decided one, and it is exactly where paths and types meet. (Named here, not run —
> this is an ideation seed.)

### 2h. Stability & freshness (multi-agent reality)

| Consideration | Notes & evidence | Status |
|---|---|---|
| Identity-addressed = stable under concurrent edits; position-addressed = fragile | The lived case is agents editing one document. | evidenced |
| Re-resolve at write time; staleness **scoped to the addressed subtree** (finer than file-level — fewer false refusals in the always-changing multi-writer world) | freshness-and-atomicity chapter. | evidenced |
| **Path + content-hash composition** — a path names the place, a hash pins the version; staleness detectable *at the address level* regardless of how the doc moved | grok-build's hash-anchored editing is the shipped prior art for the freshness half. | proposed |

### 2i. Writes, wire, multi-key

| Consideration | Notes & evidence | Status |
|---|---|---|
| Path *write* sugar-awareness: setting `$traits` should round-trip as `.trait` — core equivalence? fmt profile? edit-tool only? | pulled by path **writes**, not path syntax. | open |
| Wire (W3): raw-text-after-`@` interim vs structured `ReferenceStart/Name/$key/$traits` | Lean: **raw until multi-segment or a structured consumer forces it**. | leaning (ledger) |
| Multiple identity keys (S3): `\|phase[9][scribal]` — uniqueness `(type,key)` vs `(type,key-tuple)`; how `@phase[9]` behaves | Joseph lean: valid; **design with paths in 0.10**. Under-exercised in scenarios. | open (Joseph lean to defer here) |

---

## 3. Design-option *families* — where the generative ideas live

Selectors, navigators, transformers, and **locators** are different jobs; a
**coherent collection** of forms (Joseph, 2026-07-23) can serve them with different
strengths rather than one syntax straining to do all. Read each against §0's
dimension — does it address **to** a resource, **into** a tree, or **across** the
seam? Five candidate families, deliberately not mutually exclusive:

- **(A) Relational selector** — `\|\|type[key]:attr`, `at`/`all`, trait AND-filter.
  Strength: the primary agent mental model (2b); the natural type for query and for
  the edit tool's "where." *Leaning toward this as the spine.*

- **(B) Tree path** — `\|a\|b\|c`, root-to-leaf, positional-via-host. Strength:
  human navigation, skeleton lines, deterministic descent. Secondary to (A) for
  agents but the intuitive one for people (the two-audience bet).

- **(C) In-document reference subset** — `@…`, one segment today, frozen at three
  fields (S14, wholesale-replacement-only). Strength: links the *document* makes,
  inert selectors. The open question is the *largest* subset of (A)/(B) that stays a
  true subset — no second dialect of addressing.

- **(D) AST-search / template-transform** *(Joseph's seed, 2026-07-23)* — **"like
  text search, but conducted via the AST."** A `sed`-shaped match/replace over
  structure with capture groups and fuzzy prose matching:

  ```
  s/"|element.verbose *whose name is ({Fred})*"/"({1})rick The Great"/
  ```

  This family is distinctive and worth its own life, because it is **simultaneously
  a selector and a mutation** — it collapses "address the place" and "transform it"
  into one familiar gesture, which is exactly the ease-gradient the crystallized-
  process work argues for (models already know `sed`/regex; the right thing becomes
  the easy thing). Things it opens and the questions it raises:
  - **Capture + template** — `({Fred})` binds, `({1})` re-emits; the replacement is
    a template over captures. Structural where regex is textual.
  - **Fuzzy / prose matching** — `*whose name is (…)*` matches against structure and
    prose together. How fuzzy? What is the match unit — an attribute value, a text
    run, a subtree? This is the hard, interesting part.
  - **Prior art to mine hard:** **Rebol/Red's `parse` dialect** is the closest
    ancestor — a pattern-matching sub-language over structured values, and the same
    lineage as UDON's `<dialect>` idea. Also: `jq`'s structural edit, tree-sitter
    query `.scm` files (capture-named structural matches), and grok-build's
    hash-anchored batch edits.
  - **Composition with the guard** — an AST-search-replace is an *edit*, so it must
    live inside the schema-guarded transaction (validate inside the write, atomic,
    mutation-free refusal). A fuzzy structural match with multiple hits is the
    `PathNotUnique` case (2d) — the family inherits the whole failure vocabulary.
  - **It may itself be a dialect** — a `<search:…>` / `<patch:…>` envelope form,
    which would make family (D) a demonstration of the dialect mechanism rather than
    core syntax. Worth holding as a possibility, not a commitment.

- **(E) Resource locator / handle** *(paths **to** — the family the first draft
  omitted, §0)* — filesystem path, URL, project-root-anchored handle (`⊤`/`¤`), a
  document handle. Strength: this is what "path" means to everyone, and it is the
  harness's primary addressing world (files, imports, cross-repo references). Its
  live question is not its own syntax (borrow fs/URL convention) but **how it
  composes with (A)–(D)** — the *across* join. The most generative possibility is
  that (E) is not a separate family at all but the outer segments of the *same*
  descent (§0's resource-as-node): `⊤` `/spec` `/CORE.md` `/nesting-rule` is one
  grammar walking a named tree that happens to change substrate (directory → file →
  element) partway down.

**Scope tags** (per §0): (A) *into* · (B) *into* · (C) *into*, with an *across* form
its subset must decide · (D) *into*/transform · (E) *to*, reaching *across*. Note
that **nothing here is yet a native *across* form** except by composition — which is
where the real design (and PATH-1) lives.

**A cross-family question worth carrying:** if several forms coexist, which is
*canonical* for round-trip and equivalence, and how do they interconvert? A skeleton
line (B) that pastes back as an address, a relational selector (A) the edit tool
consumes, an `@`-ref (C) the document stores, a `s/…/…/` transform (D) an agent
types, and a `⊤/…`-anchored locator (E) that reaches another file — do they share
one core grammar with different surface sugar (the §0 seam-dissolves stance taken
seriously), or are they genuinely separate languages with defined bridges? *(Open —
and a good first thing to have an opinion about.)*

---

## 3b. Toward a common frame — state of the thinking (2026-07-23)

> **Status: provisional scaffolding, not settled theory.** This section tracks what
> has *gelled so far* toward a shared frame under the collection of path forms. It is
> **not** the frame; a more-principled underlying frame is still forming (Joseph's,
> not yet fully articulated) and is deliberately not encoded here. Claims are
> register-marked (*decided* / *evidenced* / *proposed*); the mappings onto ASF are
> **proposed synthesis**, held open for correction, not derivations. The candidate
> structures below are offered plurally, none declared correct. Primary sources sit
> beside this file: `paths-testimony-gemini-2026-07-22.md`,
> `paths-testimony-grok-2026-07-23.md`, `survey.md` (§W = formal theory), and
> `../doc-store-and-schemas-review/`.

**A recurring reframe (evidenced).** The estate's design work and de-novo testimony
from two substrates state the same thing about what a path *is*:
- design (the working-directories registry sketch): a named, typed set of roots the
  agent binds and composes, in place of implicit CWD.
- Gemini (2026-07-22): a path is a "**targeting vector**."
- Grok (2026-07-23): paths are the "**coordinate system of action**"; a path is "a
  **handle on a thing in a world model**," not "the characters between quotes."

*Epistemic note (corpus vocabulary):* two de-novo testimonies are one support-kind —
they raise the testimonial leg's strength, not the lock. The convergent lock is armed
by three independent kinds — design, testimonial, and the ASF grounding below.

**Components that recur (tracking — any path form should be placeable on these).**
The same decomposition appears across the type lattice, the testimonies, and the
doc-store review. Listed without ranking:
- **locus / target-set** — *to* a resource, *into* a structure, *across* the seam,
  *joint* (§0/§0b).
- **direction** — observe / act / both (see *orientation*, below).
- **cardinality** — one / at-most-one / many (the optics lattice, below).
- **currency** — fresh / stale / historical (Gemini #1, #7; Grok #4, #13).
- **base / root-role** — the anchor bound to, and its role (edit / git / build /
  publish / secret / user-visible — Grok #3).
- **host / execution-context** — the machine / container / worktree it resolves in
  (Grok #9, #17).
- **capability / permission** — path as authorization boundary (Grok #12).
- **existence-role / illocutionary force** — ExistingFile / CreatableFile /
  SearchRoot / GlobPattern / MaybeMissing (Grok #6).

The multi-agent handoff item (Grok #17) yields the same list from another angle —
what must accompany a path across an agent boundary: "root id, realpath, content
hash, role, host." One reading: a path is self-contained when it carries these, and
incomplete when it leans on ambient state.

**One structuring — the type lattice** (transmitted: survey §W; Foster et al.;
Pickering–Gibbons–Wu; Riley). Optics — Lens / (Affine) Prism / Traversal — type a
focus by **cardinality × directionality**, compose by ordinary composition, and
*compute* the composite type; the get–put / put–get / put–put laws are the
round-trip equations. *Proposed* correspondence (not derived): Lens = `at`,
Affine/Prism = `at?` (loud-miss), Traversal = `all`; the §2d failure vocabulary is
then cardinality mismatch. Scope: optics natively type the *into* locus only.
Extending them to *to* (naming/binding — survey §W, Saltzer) and to *joint /
relational* (relational lenses / updatable views — **unverified** as an extension) is
open.

**One grounding — orientation** (Joseph's framing + ASF concepts; the mapping is
*proposed*). The registry can be modeled in ASF as the agent's *orientation* — its
PERCEPTA (inbound) / ACTUS (outbound) configuration. Under that model a path's
**direction** is bidirectional because orientation is: observations flow in
(Level-1), actions flow out (`do()`, Level-2). Proposed maps, each held open: Getter =
observe-only (L1); Setter = act-only; Lens = both. Directed separation (theory report
§6.0) permits goals to shape *which events arrive* (selection) while forbidding
goal-shaped *processing*; orientation is selection, so an explicit registry places
goal-directed attention where the theory allows it and makes it inspectable. Which
resources are oriented-toward sets the causal-access surface (C1 coverage). Grok #4
states the read/write halves as "canonical form for **identity**, resolved form for
**actuation**," independently of this framing.

**One candidate spine — speech acts** (Grok #20). The testimony proposes organizing
the territory by what the agent *does* with a path — **resolve / propose / hand-off /
authorize / present / remember / recover** — each carrying explicit base, host, role,
identity, liveness. On this reading each speech act is an orientation through a path
at a particular direction × cardinality × locus × currency; the speech-act list and
the facet list above are two views of one structure. (`propose` is the one the
testimonies flag as uniquely agentic — Grok #10, Gemini #3: an invented path is an
unverified, self-generated observation.)

**Connections already in hand** (evidenced; see `../doc-store-and-schemas-review/`).
Directory-as-table is these handles at the filesystem altitude (`path_for(key)` =
`at`, `glob` = `all`); the record-vs-resource split (relata) is the identity /
actuation two-layer; schema-versioning (`was:` / `schema_history`) is the *currency*
facet — the machinery that keeps a key resolving across change.

**Open (left open on purpose):**
- The more-principled unifying frame (Joseph's; forming). This section is scaffolding
  toward it, not it.
- Whether the lattice reaches the *joint / relational* facet (relational lenses —
  read and verify before relying).
- Whether path *types* surface to the author/agent or stay underlying semantics only.
- The join-vs-orientation tension: a join faces two loci at once; a single-direction
  orientation does not obviously model that. The handoff facts (#17) suggest a path
  carries its full context — unclear whether that resolves it.

---

## 4. Prior art to mine (so the spike builds on, not over)

- **Rebol / Red `parse` dialect** — structural pattern-matching sub-language; direct
  ancestor of both the `<dialect>` idea and family (D). *(And Rebol's cautionary
  tale — bare-value over-recognition — is why UDON froze bare space; the parse
  dialect is the part worth keeping.)*
- **CSS selectors** — the clean relational subset to emulate (over XPath's bloat).
- **`jq` / JSONPath** — structural query *and* edit; note the file-handed-out-of-band
  habit that (wrongly) excludes naming the document — the inherited assumption
  PATH-1 corrects.
- **`yq` `match()`** — `{string, offset, length, captures}` + line/column operators:
  the cleanest shipped example of position-as-first-class-queryable-data (the span
  bridge, 2h/round-trip).
- **tree-sitter queries** (`.scm`) & **LSP `references`** — the harness's *current*
  structural addressing; `references` ≈ `all()`, a query ≈ a selector. (A proposed
  report chapter covers this territory read-side.)
- **grok-build hash-anchored edits** — freshness-at-the-address prior art.

## 5. Orthogonal / open — carried, not resolved

- **Necessity / completeness / uniqueness** — a *separate* track (Joseph). We ideate
  plausible solutions freely here; whether paths are strictly necessary for guarded
  mutation (a weaker exact-match-plus-post-conformance guard might ship sooner), and
  whether any path set is complete or minimal, is adjudicated elsewhere and does not
  gate this work.
- **New slots from de-novo practitioner testimony** (a cross-lineage agent on paths,
  in the corpus) — several absent from years of design work, carried for future
  exploration: paths with a **time dimension**; **path lifecycle / volatility**;
  **canonical-vs-literal identity**; **execution-path ↔ source-path** translation.
- **Dogfooding** — writing UDON's own tooling docs (this one included) *in* UDON is
  attractive and came up on the `arch` side too, but it waits on an MVP parser;
  until then, markdown/frontmatter with a migration plan (Joseph, 2026-07-23).

---

*Seed authored 2026-07-23. Expansion, forks, and any actual probes build from here.
Pointers: the demand map is `addressing-exploration.md` (read §4/§8/§9 whole before
sketching syntax); the ledgers are `../../DECISIONS.md` (PATH-1, S14, W1d) and
`../../OPEN.md` (S3, ML).*
