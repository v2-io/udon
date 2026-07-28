# Markdown × UDON — thoughts on scope

**Status:** broad ideation seed, not a spike. Possibility-opening, not
decision-making. Everything here is **proposed / leaning / open** unless it cites
a ratified source — and where it does, that ruling is the authority, not this
page. `../../current-0.9.1-spec/CORE.md` + `MODEL.md` are the oracle for current
language facts; `CARVEOUTS.md` (**MD / S16**) is the current *ruled* position on
the markdown layer, and it is deliberately minimal.

**Register note.** Claims are marked in their true voice: *decided* (a CORE/MODEL
rule or a CARVEOUTS entry — cited), *evidenced* (prior design work or the demand
corpus supports it — cited), *proposed* (generated here — decides nothing),
*open*. Written in markdown by design (dogfooding UDON for this waits on an MVP
parser — Joseph, 2026-07-23).

**Two framings held apart on purpose** (mirroring the paths seed):
- *Theoretical* — is markdown *subsumed* by UDON, a *peer* to it, or a *guest*
  inside it? Is there even a seam (§0)? Separate track; does **not** gate
  ideation.
- *Practical* — what should the markdown/UDON relationship *look like* across the
  surfaces where they actually touch? That is this page. And "one relationship"
  is **not** a requirement — a coherent **collection** of distinct surfaces, each
  with its own owner and failure mode, is on the table (this is exactly the shape
  the four-layers work already found).

**The load-bearing prior art** (same author, treat as design intent — the layer
*boundaries* are called sound, the *enumerations* open):
- `../../../spec/MARKDOWN.md` + `../../../design/markdown-layers.md` — Joseph's
  **four layers** (2026-07-11), draft/unratified: (1) markdown *inside* UDON
  prose, opaque; (2) the markdown-equivalent UDON **`doc` schema**; (3)
  conversion `udon2md`/`md2udon`; (4) rendering to display targets. This seed
  does **not** replace that taxonomy — it *sits it inside a bigger frame* (§1)
  and adds the regime it doesn't cover.
- `../../../defining-udon.md` §"Level 1: Show UDON acting exactly like Markdown"
  — pedagogy already bets that markdown-shaped UDON is the on-ramp.
- CORE §"Committing to prose" + MODEL "Markdown — text is opaque; anything inside
  it is above recognition" — the *decided* baseline: **core interprets no
  markdown at all.**

---

## 0. Is the seam even real? — markdown as *degenerate* UDON

The paths seed opened by asking whether the *to/into* seam dissolves. The same
move is available here, and it is the most generative stance to have an opinion
about first.

UDON's founding claim is **documents and data are the same thing.** Markdown is a
*document* format with a small, fixed inline vocabulary (`**`, `*`, `` ` ``,
`[](—)`, `#`, `-`, `>`) and **no data layer** — no attributes, no named
structure, no typing. Read through the founding claim, markdown is therefore not
a *different* language UDON must interoperate with; it is **UDON with the data
layer amputated and the surface frozen to one blessed vocabulary** — precisely
Joseph's Layer-2 `doc` schema, wearing markdown's sugar instead of `|element`
spellings.

If that identity holds, three things follow that reshape everything below:

1. **The "surfaces" are viewpoints on one object, not separate features.** Layer 1
   (markdown *in* prose) and Layer 2 (the `doc` schema) stop feeling like two
   things you keep confusing — they are the *outside* and *inside* view of the
   same subset. "Markdown inside UDON prose" is what the `doc` subset looks like
   before you parse it; the `doc` schema is what it looks like after.
2. **Round-trip becomes a *retraction*, not a conversion.** UDON → markdown is a
   projection onto the `doc` subspace; anything outside it (`:attributes`,
   non-`doc` elements, dynamics) has nowhere to land. The **fixed point** of
   `udon → md → udon` is exactly the `doc`-schema subset — which tells you what
   "lossless round-trip" can and cannot mean *before* you build a converter.
3. **The real core-spec decisions are not "support markdown."** They are (a) the
   *surface-sugar competition* — when both `**bold**` and `|{strong bold}` say
   emphasis, what is their relationship? (§3) — and (b) *host ownership* — who
   owns the outer document? (§1). Everything else is downstream.

**Counter-stance worth holding (proposed, keeps us honest):** the seam may be
*real and worth keeping*. Markdown's value is precisely that it is *not* extensible
— its ceiling is its feature. A `doc` schema that "is" markdown invites scope
creep (tables? footnotes? task lists? admonitions? — every markdown flavor drew
that line differently, §4). Maybe the healthy relationship is a **hard, thin
boundary** — markdown stays an opaque guest and a degradation target, and UDON
never pretends to *be* it. Which stance we take is §0's open question, and it
sets the altitude for §2.

---

## 1. The organizing axis the four layers don't have — *who is the host?*

Joseph's new surface list adds something the 2026-07-11 taxonomy quietly assumed
away. **All four layers put UDON on the outside** — markdown lives *inside* UDON
prose (L1), *as* a UDON schema (L2), or as a *conversion target/source* (L3), and
rendering (L4) is UDON→display. But half of the new list is the **inverse**:
markdown is the outer document and UDON is the guest. So the top-level cut isn't
the four layers — it's **which grammar owns the top of the file**, and the four
layers are one of its three values.

| Regime | Who owns the outer doc | Covers Joseph's surfaces | Four-layers coverage |
|---|---|---|---|
| **A — UDON hosts** | UDON parser; markdown is guest/target | structured-UDON-with-prose, prose-dominant UDON, prose-with-UDON-embeds, the `doc` schema, markdown-validation | **all four layers live here** |
| **B — Markdown hosts** | a markdown parser; UDON is guest | markdown-with-UDON-frontmatter, UDON-in-code-fences, UDON-from-a-markdown-parser's-eye | **not covered** — the gap |
| **C — Peer / transform** | neither; a mapping between two standalone docs | udon↔md conversion, round-tripping | Layer 3 (+ Layer 4 as projection) |

Three *cross-cutting* dimensions then generate the actual design questions inside
any regime:

- **Interpretation depth** — *opaque* (survives verbatim, renderer's problem) →
  *recognized* (parsed into a tree) → *validated* (schema-checked). CORE fixes
  the floor: markdown-in-prose is **opaque** (*decided*). Layer 2 is *recognized*;
  Joseph's "markdown validation within UDON" is *validated*. One surface can sit
  at different depths for different tools — that is a feature, not a contradiction.
- **Which markdown?** — CommonMark · GFM · Djot · MDX · Obsidian-flavored ·
  Pandoc-markdown. "Markdown" is not one language (the Norway-problem analog for
  this whole area). Every surface silently picks one, and the Layer-1 subset is
  *"not yet enumerated"* (evidenced, `spec/MARKDOWN.md` D4a). This choice is
  load-bearing and currently unpinned.
- **Direction of the *toward*** — markdown as *source* (lift/import — the
  adoption on-ramp) · *guest* (embed — coexistence) · *target* (degrade/export —
  interop) · *peer* (round-trip — fidelity). The same two formats, four different
  jobs, four different fidelity contracts.

---

## 2. The surface catalog — Joseph's list, reorganized and extended

Each surface: what it is, the sharpest question, and a status. Nothing here closes
anything. Joseph's originals are marked ⟨J⟩; surfaces added here are ⟨+⟩.

### Regime A — UDON hosts (the four layers live here)

| # | Surface | Sharpest question | Status |
|---|---|---|---|
| **A1** ⟨J⟩ | **Structured UDON, markdown prose sections** — *the base case*. Structure-first doc; prose regions carry markdown formatting. | = **Layer 1**. Which markdown subset do renderers honor, and is the *non-conflict guarantee* (markdown survives verbatim) actually met against the CommonMark corpus? | opaque = *decided*; subset = *open* (D4a) |
| **A2** ⟨J⟩ | **UDON whose head/primary content is mostly markdown** — the leftmost/top content is prose, structure is secondary. The `defining-udon.md` "Level 1 acts like Markdown" doc. | Where is the line between "a UDON doc that reads as markdown" and "markdown that happens to parse as UDON"? Is A2 just A1 with a different *center of gravity*, or its own thing? | *evidenced* (pedagogy bets on it) |
| **A3** ⟨J⟩ | **Markdown prose with UDON embeds** — prose-dominant, structure sprinkled inline (`\|{…}`) or as occasional block elements. | This is A1 read from the prose side — the emphasis inverts but the mechanism (opaque prose + recognized inline/block forms) is the same. Direct **MDX** analog (§4). Does the inline-form recognition (`\|{`, `!{`, `@`) ever collide with markdown constructs in real prose? | *decided* baseline; collision map *open* (§3) |
| **A4** ⟨J⟩ | **The `doc` schema — UDON as "parsed markdown"** — an explicit element vocabulary (`\|heading`, `\|em`, `\|a :href`) that is markdown/HTML semantics made structural; markdown as an intermediate on the way to HTML. | = **Layer 2**. What is the element set, and *how much of markdown's range* does it cover (tables? footnotes? task lists?) — i.e. where does §0's scope-creep line get drawn? This is literally **Pandoc's AST** as a UDON schema (§4). | *evidenced* (named, unenumerated — D4b) |
| **A5** ⟨+⟩ | **Markdown validation within UDON** ⟨J's #6, promoted to its own row⟩ — schema-checking that a prose region conforms to the blessed Layer-1 subset, or that a `doc` subtree is well-formed markdown-equivalent. | This is the *validated* depth (§1) applied to A1/A4. Is "is this valid markdown?" a schema question (`doc`-schema conformance) or a lint question (renderer-subset compliance)? Two different owners. | *proposed* |

### Regime B — Markdown hosts (the gap the four layers leave)

| # | Surface | Sharpest question | Status |
|---|---|---|---|
| **B1** ⟨J⟩ | **Markdown with UDON frontmatter** — an otherwise-markdown doc whose metadata block is UDON instead of YAML. | Note the **irony**: UDON's whole pitch is "Markdown + YAML frontmatter *grows up*" (README) — using UDON *only* for the frontmatter is the minimal-commitment **gateway**, almost the pitch run backwards. Real questions: the **delimiter** (`---` fence, as YAML? a UDON-native open? column-0 `\|`?), and how a plain markdown parser treats the block (§B3). | *proposed*; high adoption value |
| **B2** ⟨J⟩ | **UDON in markdown code-fences** — ` ```udon ` blocks inside a markdown doc. | This is **what this very repo already does** (every seed, including this one, is markdown with UDON in fences). Two questions: the **fence-collision** knot — UDON's own blob/fence forms (`!:lang:`) nested inside markdown ` ``` ` (the repo already fights this; nested-fence examples are `.fmt-mdignore`-protected) — and whether a fenced UDON block is *inert display* or a *live embed* a tool extracts and parses. | *evidenced* (lived daily); fence rule *open* |
| **B3** ⟨J⟩ | **UDON from a markdown parser's perspective** — how a dumb CommonMark/GFM parser (GitHub's renderer, a chat client, an Obsidian preview) *sees* a `.udon` document or a UDON embed. | UDON's stated goal is "crystal clear even without syntax highlighting" (README) — does that extend to **degrading gracefully in a plain markdown renderer**? `\|heading Welcome` renders as literal `\|heading Welcome` on GitHub — ugly. Is that acceptable, or is there design pressure toward markdown-compatible spellings? A real robustness constraint, not just a curiosity. | *proposed* (generative) |
| **B4** ⟨+⟩ | **UDON in markdown *editor/tooling* estate** — syntax highlighters, LSPs, linters that own `.md` and now meet UDON (tree-sitter-udon injection into markdown fences, the Obsidian plugin's split reality). | The harness's whole documentation world *is* markdown; UDON has to live in tooling built for markdown. Injection grammars (tree-sitter, TextMate) are the concrete mechanism. Pulls on `ux/` directly. | *evidenced* (repo has the pieces) |

### Regime C — Peer / transform (a mapping between two standalone docs)

| # | Surface | Sharpest question | Status |
|---|---|---|---|
| **C1** ⟨J⟩ | **udon ↔ markdown conversion** — `udon2md` / `md2udon`. | = **Layer 3**. The two directions are asymmetric: **md→UDON is near-lossless *into* the `doc` schema** (adoption on-ramp — the strongest strategic surface, §0); **UDON→md is lossy-by-design** and needs a *degradation policy* for non-`doc` structure (`\|process[valve] :health broken` → ?). | *evidenced* (D4c open) |
| **C2** ⟨J⟩ | **Round-tripping** — `udon→md→udon` and `md→udon→md`. | Per §0 this is a **retraction/fixed-point** question, not a fidelity dial: the stable set is exactly the `doc` subset. What is the *contract* — "round-trips iff `doc`-schema-only," stated up front? A false "round-trips" claim over general UDON is the named failure mode (`spec/MARKDOWN.md` L3). | *proposed* (frame from §0) |
| **C3** ⟨+⟩ | **Rendering as projection** — UDON → ANSI / HTML / PDF / Obsidian view. | = **Layer 4**, but worth separating from C1: rendering targets a *display*, not the markdown *format*. Proposed first cut (`spec/MARKDOWN.md` D4d): render Layer-1 prose subset + show structure skeleton-style; Layer-2 awareness later. | *evidenced* (D4d) |
| **C4** ⟨+⟩ | **Markdown as a *lift source* / migration corpus** — every README, every Obsidian vault, every chat log is existing markdown that *could* become UDON. | This is C1's md→UDON direction seen as **adoption strategy**, not a tool: the on-ramp is "your markdown already is (degenerate) UDON; here's the upgrade." The founding-claim payoff (§0) cashed out as a growth path. | *proposed* (strategic) |

**One surface deliberately *not* here:** "markdown *is* UDON, full stop" — the §0
seam-dissolves endpoint — is not a surface, it's the *stance* that collapses A4,
C1, and C2 into one object. Carried in §0, not catalogued.

---

## 3. The collision surface — where the two grammars mechanically clash

The most concrete, spec-grounded section: markdown and UDON share glyphs, and CORE
has **already ruled** on several clashes (the *non-conflict guarantee*). This is
the *decided* baseline every surface above inherits — worth stating so no spike
re-opens a settled call.

| Glyph / construct | Markdown means | UDON (CORE) does | Status |
|---|---|---|---|
| `\| a \| b \|` (pipe-space, tables) | table row | **`\| ` (pipe-space) is always literal** — preserves markdown tables verbatim | *decided* (CORE Line Scan) |
| `![img](x.png)` | image | `!` opens a dynamic only before an identifier/`:`; `![` is **text** | *decided* (CORE `!` rule) |
| `#`, `<` in prose | heading / HTML | inert in prose — no meaning in flow text | *decided* (CORE §prose) |
| `**bold**`, `` `code` ``, `*em*` | inline emphasis/code | **opaque** — survives as prose; renderer's concern | *decided* (MODEL) |
| ` ``` ` fences | code block | UDON has its **own** blob/fence forms (`!:lang:`); nesting the two is the open knot (B2) | *open* (fence rewrite) |
| `---` | thematic break / YAML frontmatter delimiter | no ruled meaning as a doc delimiter yet — bears on B1 | *open* |
| `[text](url)`, `[[wikilink]]` | link | `@`/`\|{a …}` are UDON's link forms; relationship to markdown links unresolved | *open* |
| `-`, `1.` list markers | list item | UDON `- ` list vs markdown list — coexistence largely fine, edge cases unmapped | *open* (largely benign) |

**The one decided *lean* worth citing:** CORE pedagogy already says *"prefer
Markdown for simple emphasis; reserve `\|{…}` for attributed structure"* (§prose,
non-normative). That is the surface-sugar competition (§0.3) with a **standing
answer**: markdown sugar is the prose default, `\|{…}` earns its keep when you
need attributes/structure. A spike on A3/A4 should start from that lean, not
re-litigate it.

**The fence knot deserves its own probe** (mirrors the paths seed's terminator
table): enumerate every way UDON's `!:lang:`/blob fences and markdown ` ``` `
fences nest — UDON-in-md-fence (B2), md-code-in-UDON-blob, and the ugly middle
(a UDON blob containing a markdown code sample containing a UDON example) — and
produce the *table of what survives*. The repo already hit this hard enough to
need `.fmt-mdignore` protection; that pain is evidence the table is worth forcing.

---

## 4. Prior art to mine (so a spike builds on, not over)

- **Pandoc's AST** — the definitive "parsed markdown as a typed tree." Pandoc's
  `Block`/`Inline` types *are* Joseph's Layer-2 `doc` schema, already designed and
  battle-tested across ~40 formats. The `doc` element set should be read against
  Pandoc's before being invented. **The single strongest source for A4/C1.**
- **MDX** (markdown + JSX components) — the shipped precedent for "prose with
  structured embeds" (A3/B). What worked (components inline in prose), what hurt
  (the parse ambiguity between prose and component boundaries — UDON's `\|{…}`
  faces the same seam). Direct competitor worth positioning against.
- **Djot** (Beyond Markdown, by CommonMark's own author) — the Layer-1-subset
  inspiration already named (`spec/MARKDOWN.md`): markdown reimagined for
  *unambiguous* parsing. The blessed-subset design is a solved problem to borrow.
- **CommonMark + the CommonMark corpus** — the *non-conflict guarantee* is
  measured against this (does UDON leave every CommonMark construct intact as
  prose?). The conformance corpus is the falsifier for §3's "decided" column.
- **Quarto / R Markdown / Jupytext** — the "markdown host with frontmatter +
  fenced live blocks" world (B1+B2 combined, shipping at scale). How they delimit
  frontmatter and execute fenced blocks is directly transferable.
- **GitHub-Flavored Markdown & Obsidian-flavored** — the *rendering realities*
  UDON degrades into (B3), and Obsidian is already a live `ux/` target.
- **AsciiDoc / reStructuredText** — the "markdown grown up" predecessors that
  *lost*. Why they lost (ceremony, learning cliff) is UDON's cautionary corpus —
  the same ambition, and the failure modes to avoid.
- **The repo's own four-layers spec** — `spec/MARKDOWN.md` is the home taxonomy;
  this seed extends it (§1) but does not replace it. Reconcile back to it.

---

## 5. Relationship to the current (0.9.1) spec — the honest baseline

So a spike doesn't over-claim what's settled:

- **Decided (minimal):** core interprets **no** markdown — prose is opaque, "above
  recognition" (MODEL). Specific glyph clashes are ruled (§3). Pedagogy leans
  markdown-sugar-for-emphasis (§3).
- **Ruled-open (CARVEOUTS MD / S16):** *"which Markdown subset renderers honor,
  the Markdown-equivalent element vocabulary, conversion/degradation policy.
  Companion stub only; core text stays opaque."* — i.e. **all of Layers 1–3 above
  the opacity floor are formally open**, and deliberately deferred to demand-side.
- **Drafted-but-unratified:** the four-layers taxonomy (`spec/MARKDOWN.md`) — sound
  boundaries, open enumerations. Cite as design intent, not law.
- **This seed adds:** Regime B (markdown-hosts, §1) — *not present* in any current
  spec artifact, and the half of Joseph's list with no home yet.

**Demand-side hook:** S16 says the markdown layer closes when demand names it. The
`udon-needs` tooling report is where that demand lives — a spike here should check
whether the report's chapters (rendering, progressive disclosure, the harness's
markdown estate) already generate the requirements the four layers list as open,
rather than inventing them.

---

## 6. Orthogonal / open — carried, not resolved

- **§0's stance is the fork in the road.** Whether markdown is *degenerate UDON*
  (seam dissolves; A4/C1/C2 collapse into one object) or *a peer with a thin hard
  boundary* (keep it opaque forever) sets the altitude for every surface. Worth an
  opinion **before** any converter or `doc`-schema spike.
- **Which markdown** (§1) is unpinned and load-bearing — no surface is fully
  specifiable until the Layer-1 subset is enumerated (D4a). A candidate first
  probe: run the CommonMark corpus through the current parser and *produce the
  non-conflict table* (§3), converting the "decided" column from claim to measured.
- **The fence knot** (§3) is the concrete, already-painful thing — the highest-
  value small probe, analogous to the paths seed's terminator table.
- **Frontmatter delimiter** (B1) touches PRAGMA / doc-preamble territory — likely
  interacts with whatever doc→dialect/schema binding the dialect work (S16's
  sibling carve-out) lands.
- **Adoption framing** (C4/B1) is strategy, not mechanics — but it may be the
  *reason* the whole area matters: the on-ramp for a markdown-soaked world.

---

*Seed authored 2026-07-23. This is a scope map for a brainstorm, not a design.
The generative forks to have opinions about first: §0 (is the seam real?), §1
(does Regime B deserve equal standing with the four layers?), and §3's fence knot
(the smallest concrete probe). Pointers: the home taxonomy is `spec/MARKDOWN.md`;
the ruled position is `CARVEOUTS.md` (MD/S16); the sibling in shape and register
is `../paths-ideation/README.md`.*
