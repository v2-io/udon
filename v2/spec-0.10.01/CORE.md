# UDON Core Specification

**Universal Document & Object Notation — 0.10.1-draft (material/deferred unification)**
**Status: PROPOSAL DRAFT — nothing here is ratified.** This is the **full contract**, stated theory-first: the language on the two-kind ontology (material / deferred) of the lexical-forms-redux line, with the addressing theory (`../references/def/`) as vocabulary authority for the deferred half. Where the theory gives a more principled answer than a 0.8/0.9/0.10 idiom, this draft **overrides the idiom** — every such override, and every other behavior change, is a [DELTAS.md](DELTAS.md) row; the per-nuance reconciliation is [NUANCE-AUDIT.md](NUANCE-AUDIT.md). Minted spellings are marked **⟨PROPOSED⟩**.

**Companions:** [MODEL.md](MODEL.md) · [GLOSSARY.md](GLOSSARY.md) · [SEMANTICS.md](SEMANTICS.md) · [CARVEOUTS.md](CARVEOUTS.md) · [DELTAS.md](DELTAS.md) · [NUANCE-AUDIT.md](NUANCE-AUDIT.md) · [README.md](README.md).

The key words MUST, MUST NOT, SHOULD, and MAY are per RFC 2119.

---

## 0. The guiding model

Orientation, not law; sections govern.

- **G1 — Indentation is the hierarchy.** Deeper = child, same = sibling, shallower = closed (the Nesting Rule, §2.2); no closing tags. Delimited constructs close by their printed closer, never by geometry (§11).
- **G2 — Why sameline works.** Blocks-plus-indent give every geometric construct a place to end; structure written mid-line sits at its true column as if written vertically, and the markers that open block structure are the same set that terminates values.
- **G3 — Sameline is value-space; block interiors are text-space.** All sameline material is an assignment value — the only question is which assignment. Prose lives in block interiors, where markers are literal.
- **G4 — Everything named about an element is an assignment.** Identity, traits, suffixes, sameline text — sugar over designated assignments, never parallel mechanisms. Repetition stacks, silently; every assignment takes a value.
- **G5 — Two kinds of item: material and deferred.** Material (things, facts, text) is determined at writing. Deferred material — **references** (stand for; `@`) and **generators** (produce; `!`) — is determined at *use*, from an origin, as of a moment. **The recognizer's schedule is: hold everything.** Recognition never resolves, dereferences, evaluates, or construes; it delivers deferred items as artifacts.
- **G6 — Hold is one operator, with one precedence.** `\` holds source characters; captures hold spans; `@<…>` holds a reference as a value; recognition holds every deferred item. **Held material is dead to everything** — markers, annotations, further recognition — until a consumer un-holds by one level (§4, §9).
- **G7 — Typing is syntactic and the bare set is frozen.** The bare scalar set is closed forever; growth lives visibly in captures. A vocabulary structurally cannot retype bare space.
- **G8 — Keep everything; severity is loss.** Recognition never silently drops author-visible bytes. Misses are not recognition anomalies: their meaning comes from intended-cardinality, their response from the consumer.

## 1. Conformance and ownership

A conforming **recognizer** maps any finite UTF-8 input to a Document (MODEL §1) — content, anomalies, result — holding all deferred material. It MUST recognize every marker, guard, and desugaring here; it MUST NOT determine anything. When a canonical fixture suite exists for this version, passing it is compliance; until then this prose is authoritative, and prose-vs-suite divergence is resolved by ruling, never by an implementation's behavior.

| Concern | Owner |
|---|---|
| Head (path) grammar, origin, resolution policy, misses | the addressing theory, exercised by consumers |
| Evaluation of generators | consumer + generator vocabularies |
| Construal of captures (kinds) | the named vocabulary (dialect) |
| Constraint (allowed/required) | Schema — judges the model, never shapes it |
| Projection; `$main` presentation | Host |
| Duplicate `(name,key)` policy | Document layer — collide policing (def-binding); menu: `error \| allow-if-identical \| first-wins \| last-wins \| keep-all`, default `error`; tree-equality ignoring spans; references play no part |
| Stance schedules | pipelines/stores above recognition |

**Menu vs knob**: the core MAY fix an option space and default; consumers pick within it and MUST NOT invent options outside it. **Additivity**: vocabularies act only inside captures; bare recognition is frozen.

## 2. Source text and geometry

A document is a sequence of Unicode scalar values in UTF-8, divided into **lines** by U+000A; a final line need not end with one (EOF is newline-equivalent, §11.3). **Column** = count of leading U+0020 before a line's first other character, from 0.

**Indentation is spaces only.** A tab in a line's indentation is a Warning; the line is kept best-effort as text of the current column owner (a coherent keep exists, so severity is Warning by §12). A tab anywhere else is ordinary content.

### 2.1 Structure Position and bounded lookahead

**Structure Position** is the state in which markers are recognized: the start of every line's content at a structural column, and along the Line Scan wherever the scan sits between values. Every guard resolves within a few characters, single-level, no unbounded backtracking — a constraint on the **language**: new syntax MUST stay inside the bound. Consequence: a document parses identically whole or byte-at-a-time; chunk boundaries are never end of input.

### 2.2 The Nesting Rule

Open geometric items (elements, generators, block captures, annotations, text blocks) form a stack, each with a **base column** — its introducing marker's column. A new structural line at column `c`:

```text
pop while c <= stack_top.base_column
then push the new item under the resulting top
```

- **Deeper ⇒ child; same ⇒ sibling (old top closes first); shallower ⇒ dedent** (everything at ≥ the new column closes, innermost first).
- **Sameline nesting**: items introduced later on one line occupy their true columns — `|a |b |c` is, for all hierarchy purposes, the vertical form written compactly. A closed item's former column has no residual meaning.
- **Exception — text interior**: once an element has an established content base (§7.2), a line indented deeper than that base is inside the text, literal even if it begins with a marker. Structure resumes at or left of the base.

A consistent sibling indent (commonly 2 spaces) is RECOMMENDED style, not a rule (the tooling default unit stays open — CARVEOUTS carry: IND).

### 2.3 The two spaces

**Value-space** — every sameline position: the run of a line from its first marker through its end, traversed by the Line Scan (§6.4). No prose category exists there; all sameline material is an assignment value; markers are live wherever a value has finished.

**Text-space** — the block interior: lines not opening structure at a structural column are text of their column owner (§7). Markers are literal there, with the framed ` ; ` annotation as the one carve-out (§8).

## 3. Marker guards

| Marker | Opens | Guard (fails ⇒ the character is ordinary text) |
|---|---|---|
| `\|` | element; `\|{` inline element | followed by `XID_Start`, `[`, `.`, `'`, `{`, or a suffix char (`?` `!` `*` `+`). `\| ` (pipe-space) is always literal — Markdown tables survive |
| `:` | assignment | followed by non-space. `: ` and `:`⟨EOL⟩ are text |
| `@` | reference | followed by `[`, `.`, `{`, `<`, or `XID_Start` |
| `!` | generator | followed by an identifier char or `{`. `!=`, `![img](x.png)`, `!(` are text |
| `<` | capture | at a **value-expected position**, or at Structure Position when followed by `ident:` (block capture, §9.3). Literal in text-space and mid-token (`a<b`) |
| `;` | annotation | per the position table (§8) |
| ` ``` ` | fence | any Structure Position; never inside text deeper than an established content base |
| `\` | hold | §4 |

> **Least-surprise note (convention, kept).** A bare label may start with `-`/`/`, so framed emoticons in *sameline* text (` :-)`) pass the `:` guard and open assignments. Accepted collateral, weighed on frequency: sameline is careful territory; escape (`\:-)`) or quote, and highlighting surfaces the misread instantly. Text-space prose is unaffected.

## 4. Hold at the source level: `\`

`\` is the hold operator applied to source characters — two operations by **frame**, one fallback:

| Spelling | Operation |
|---|---|
| **Attached `\X`** (immediately before a character that would otherwise be structural here) | hold one character: `X` is literal; the token continues; the scan machinery stays live after it |
| **Framed ` \ `** (whitespace before; whitespace or EOL after) | hold the rest of the physical line as text: spaces after the `\` preserved, **dead to markers and annotations** (G6). If a value was open, the `\` first terminates it (§6.4). Ownership follows §6.5 — the `\` sets the mode, never the owner |
| anywhere else | a literal backslash: `C:\Users\me`, trailing `\` in a token, `\w` mid-word. Escape-sequence readings (`\n`) belong to hosts |

- A literal leading backslash doubles: `\\x` → text `\x`.
- **The column-anchor idiom**: a framed line-initial `\` occupies no column; the text after it backs into the `\`'s column, which becomes the content base — the idiom for indenting a whole text block (only the first line needs it).
- **An empty held tail is a real, kept value**: `:a \` with nothing after is the empty string — no warning, peer to `:a ""`. A lone framed `\` at end of input forces a kept empty text line.
- `'` is not an escape anywhere; inside quoted strings `\` is ordinary content (§10.3).

**One precedence, everywhere (G6): held beats everything.** In held text (framed-`\` mode, capture bodies, fence bodies, annotation interiors) no marker, frame, or guard fires. This resolves uniformly the edges 0.10.0 left unspecified (DELTAS 13): a framed ` ; ` after value-`\` text — anywhere, inline elements included — is literal.

## 5. Elements

### 5.1 Shape

An element is **name (optional) + ordered assignments + ordered content** — nothing else (MODEL §3). Identity, traits, suffixes, and sameline text are sugar over designated assignments.

### 5.2 Names

First character `XID_Start`; continue `XID_Continue`, `-`, `/` (kebab first-class; `/` conventional namespacing, core-inert). Other characters end the bare name; quote whole names containing them (`|'weird name'`). The suffix characters `? ! * +` are not name-continue for elements — a trailing one is a suffix. Recognizers MUST declare the Unicode data version resolving `XID_*`; non-ASCII identifiers are non-portable across differing declarations (pin: CARVEOUTS carry UNI).

### 5.3 Identity and traits (sugar)

`|element[key].trait1.trait2`

- **Identity `[key]` is a value slot**: the bracket interior takes the full value grammar (§6.4) with `]` as an added unconsumed terminator — `[1]` integer, `["01"]` string, `[one two]` text, `[[a b]]` list, `[<2026>]` capture, `[@{key}]` an embedded reference, `[|{x}]` an inline element. Material after a finished value stacks as a further `$key` assignment, silently. Block forms stay out of the bracket sugar (the longhand `:$key` always covers them); a reference as a key takes `@{key}` (delimited slots take delimited forms).
- **Multiple brackets stack** — each desugars to its own `:$key`, in order.
- **Traits** `.trait`: plural, stackable, order-preserved; trait-continue also includes `? ! * +` (`.foo?` is trait `foo?`); quotes for anything else. Two traits are two `$traits` assignments, never one list.
- **Identity is contiguous** with the name (plus one optional trailing space-separated suffix): `|p .gitignore is a file` has no traits — that is `$main`.
- **Unclosed identity fails safe → `$partial-key`** with a Warning citing the opener: consumers reading `$key` or resolving heads automatically exclude a truncated identity (§9.1). Kept, per G8.
- **Empty closed brackets**: identity `[ ]` → nil key; array `[ ]` → empty list; an *unclosed* whitespace bracket keeps its whitespace + the Warning.

| Written | Means |
|---|---|
| `\|el[k]` | `\|el :$key k` |
| `\|el.a.b` | `\|el :$traits a :$traits b` |
| `\|el?` (`!` `*` `+`) | `\|el :$? true` (`$!` `$*` `$+`) |
| `\|el some text` | `\|el :$main "some text"` |

**Designated, not reserved**: `$` is an ordinary label character; `:$key 3890` is directly writable, so a generator that only writes assignments produces a document indistinguishable from sugar. **Sugar-produced assignments are born finished** — deeper lines never attach to them.

### 5.4 Suffixes

Trailing `? ! * +` on the element identity desugar to designated assignments with explicit `true`; positions after name, after key, or space-separated at the end; suffixes stack (`|field?!`). Meaning belongs to the consuming schema/vocabulary. A suffix touching a trait belongs to the trait (`.bar?` → trait `bar?`; `.bar ?` → trait `bar` + `$?`).

### 5.5 Anonymous elements

`|[k]`, `|.trait`, `|?` — elements with no name, ordinary in every other way. The core attaches no meaning to namelessness.

### 5.6 Inline elements `|{…}`

- Brace-balanced; closes at the matching `}` (nested `{}` fine); multi-line (continuation indentation is geometry; each content line keeps its terminator).
- Name, identity, traits, suffixes, assignments as in §5–§6, with `}` an added unconsumed terminator.
- **Bracket mode**: only inline forms nest inside — the block form `|name` does not exist there.
- **Interior text model**: genuinely mixed text-and-structure; `$main` sugar does not apply inside braces; intervening text — including single spaces — is interior content (round-trip fidelity). Contrast value positions, where whitespace separates values.
- Empty `|{}` is a valid empty anonymous inline element.
- In flow it is a segment; at a value-expected position it is the value.

## 6. Assignments

### 6.1 Labeled edges

An assignment is a labeled edge with ordered heterogeneous content (`{ label, content: [Item] }`); a child names what it *is*, an assignment what it is *to the element* — **whose name is it?** is the design test. The common case is one-item content. On the line axis assignments are NOT element-like: the Line Scan's one-value-per-slot discipline keeps `|el :a 1 :b 2` two assignments.

**Root-level `:label`** (no owning element): Warning; kept as document-level text including the `:` — no phantom owner.

### 6.2 Labels and the four states

A **bare label** is a contiguous non-space run after `:`; beyond identifier characters it may contain, in any position, `* $ # ! ? ^ . , - + _ = ~ / : ; |` and interior quotes. A leading quote selects a quoted label. There are no flag labels and no built-in label semantics — presence is explicit.

**Every assignment takes a value.** A `:label` with no value material — EOL with nothing indented under it, or a context terminator — is an **Error**; the assignment stands with value Nil (the sole core Error: the intended value is genuinely absent). When deeper lines follow, the deferred body opens instead (§6.5). Four states, one Error: **Absent** · **Nil** (`nil`/`null`, or Error-produced) · **False** · **True** (explicit, or suffix sugar).

### 6.3 Value kinds

| Kind | Forms |
|---|---|
| Scalar | quoted string, bare single token, number, `true`/`false`/`null`/`nil` alone, list `[…]` |
| Reference | `@head` / `@{head}` — held by recognition (§9.1) |
| Held reference | `@<head>` — the artifact as the value ⟨PROPOSED⟩ |
| Capture | `<…>` value form; block capture / fence as node values (§9.3) |
| Generator | block `!name` as a node value; inline `!{name …}` (§9.2) |
| Node value | block-form `\|element` — the value IS the node |
| Text value | unquoted text or `\`-held text; a flow — may contain inline segments |

A reference in value position is the assignment's value; as a block line (or after a finished value at a terminator) it is the element's reference child — `@` and `|` have equal footing.

### 6.4 The Line Scan and value terminators

After a label, value material is collected; the scan then continues, uniformly, sameline and block alike.

**Self-announcing values** — digit/sign → number, quote → string, `<` → capture, `[` → list, `@` → reference, block-form `|name`/`!name` → node — self-terminate; the scan continues after each. A committed token going wrong mid-way (`12ab`) falls through token-locally to text.

**Brace forms at a value-expected position** (`|{…}`, `!{…}`, `@{…}`) self-delimit as values; whitespace between values separates. This holds at every value-expected position — the `$main` slot, assignment slots, list items, identity/selector brackets, a deferred body's first line — one value grammar, no per-context table. **Mid-flow the rule inverts**: once a text value has committed, a brace form is a segment of it, never a terminator.

**Unquoted text values** are strings with different closing delimiters. One begins at any value position where the material is not self-announcing, and runs until:

- a space + **guard-confirmed block-form marker** (`:label`, `|name`, `@head`, `!name`, a block capture, a fence) — terminates and the scan continues;
- a **framed `\`** — terminates and holds the rest of the line (§4);
- a **framed ` ; `** — terminates and opens an annotation;
- **EOL**, or the context's terminator (`}` inline, `]` in lists/brackets — unconsumed).

A marker failing its guard is content (`3:1`, `| `, `!=`); an attached `\X` makes a would-be terminator content — with a text value open, the escaped material joins it and the value continues.

**Keywords at a terminator**: `true`/`false`/`null`/`nil` type only when the token finishes alone; followed by more text they begin a text value (`:alpha true story` → `alpha="true story"`).

### 6.5 Slots and line roots (ownership)

1. **The open slot owns**: an assignment whose value is still expected owns the next value material.
2. **Otherwise the line root's stack**: on an element-rooted line further values stack as `$main` and further `:label`s open new assignments; on a block-assignment line further values stack on that label, silently, and further `:label`s open siblings.

**Deferred bodies.** A label ending its line with no finished value opens its body: deeper lines are the assignment's content under ordinary column/content-base rules — heterogeneous items, exactly like element content. **The body's first line carries the value-expected position** (a lone `5432` types Integer; `nil` alone is Nil; a brace form is a value; a text-committing line begins text); only the first line is value-special — re-wrapping text must never retype a document.

**Value-position `\`**: where a value is expected, attached `\X` escapes into a text value owned by that assignment; a lone `:a \` is the kept empty string.

### 6.6 Contexts and terminators

One value grammar; contexts differ only in added terminators and line root:

| Context | Added terminators | Post-value material |
|---|---|---|
| Element-rooted line | — | `$main` stack / new assignments |
| Block assignment line | — | the label's stack / new assignments |
| Inline element `\|{…}` | `}` (unconsumed) | interior content |
| List | `]` (unconsumed) | next item |
| Identity / selector bracket | `]` (unconsumed) | stacked `$key`, silent |

Framed ` ; ` opens an annotation on element and block-assignment lines; never inside held text (§4's precedence). Inside `|{…}` a bare `;` is literal; only `;{…}` annotates there. `}` is not a terminator inside `[…]`.

### 6.7 Stacking: a label names a collection

Each occurrence of a label appends its value as one contribution — sameline, block, or interleaved — and a bracketed list is one contribution that *is* a sequence. Nothing flattens, nothing is lost, last-wins does not exist, and stacking is **silent** everywhere. Default read (MODEL §3.2): one contribution → the value; several → the list of contributions in order. Stacked-vs-bracketed spelling is **ornamentation** — assemblers MAY annotate flavor; data consumers ignore it. What is *allowed* is schema territory.

### 6.8 Node values and the one-way door

An assignment's value may BE a node — block-form element, block capture, fence, or generator — with no wrapper. Block and brace forms both bind at a value-expected position and are model-equivalent there (SEMANTICS). **The one-way door**: once a block-form node opens, its Line Scan owns the rest of the line — `|api :headers |header :k v :timeout 30` gives `timeout` to the header. This applies to generators identically (DELTAS 2 — there is no harsher head rule). **No assignment-under-assignment**: a `:label`-shaped line directly under an open assignment body is kept as text of the body with a Warning (grouping sugar stays open — carry ATTR-GROUP). Maps-of-maps take a named node carrier.

### 6.9 Late assignments

A line-initial `:label` after an element's block content has begun is a **real assignment of that element**, with a Warning (likely-unintended placement, not invalidity). `$main` and an assignment's deferred body do not begin content. **Streaming-identity note**: a late `:$key` is possible; resolvers MUST NOT treat identity as complete before the element closes.

### 6.10 The element's value: `$main`

Sameline text is sugar for the designated assignment `$main` — a typed value position: self-announcing values become `$main` values and return the scan; sequences are stacked `$main` assignments. `$main` is an assignment, **not text material** (the text law, MODEL §6) — sameline and block text are different documents by design, and reflowing between them is a semantic edit. `$main` establishes no content base and does not begin content.

## 7. Text

### 7.1 Flow

**Flow** is the one prose-shaped content model: ordered segments — text runs, inline elements, embedded references `@{…}`, inline generators `!{name …}`, inline annotations `;{…}` — resolving to text as each segment's layer processes it. Three homes, one rule set: block text, text values, inline-form interiors. Text is **opaque** to the core: Markdown inside it is not interpreted.

### 7.2 The content base and dedentation

1. `$main` establishes nothing.
2. The first indented text line establishes the **content base** — the author's column, strictly inside the parent.
3. Later lines at ≥ the base contribute text with base-many spaces stripped; extra indentation is preserved as text.
4. A line shallower than the base but inside the element **warns and re-bases**.
5. A line deeper than an established base is inside the text; markers literal; structure resumes at or left of the base.

Each text line's terminator is part of its text; stripped indentation is geometry. Fences strip nothing.

### 7.3 Blank and whitespace-only lines

A blank line not protruding past the base is a **BlankLine** at recognition (round-trip safe; contributes `"\n"`). Whitespace protruding past the base is text. A framed `\` on an otherwise-blank line forces a kept empty text line. Interior blanks are text; edge blanks at structure boundaries are **ornamentation** (droppable by consumers, never surfaced as content). **Final-terminator disposition**: interior newlines are text; a run's final terminator riding inside its last content-bearing line is ornamental; an author's `\` at the very end of a line is an explicit kept newline.

## 8. Annotations

`;` opens an **annotation**: uninterpreted material addressed to the document's maintainers instead of its consumer. Interiors are **opaque by definition** — "structure" inside is the spelling of structure (G6: held) — which is why one `;` can silence anything and why annotations need no interior grammar at any position.

| Position | Behavior |
|---|---|
| Line start, structural column | line annotation (owns everything indented deeper — first continuation line sets its strip column; participates in the column hierarchy like any node) |
| After a finished value (framed ` ; `) | line annotation |
| Within an open unquoted text value (framed ` ; `) | line annotation — terminates the value |
| In block text at the content base | line annotation |
| In block text deeper than the base | literal |
| In any held text (framed-`\`, capture body, fence) | literal (G6) |
| Inside `\|{…}` (bare) | literal — only `;{…}` annotates there |
| In flow, `;{…}` | inline annotation; contributes no text; framing whitespace preserved on strip |

The frame (whitespace both sides) is required only in the framed positions; at no-frame positions `;comment` opens with or without the space (style advisory optional). **Annotations are carried, never interpreted** (MODEL §5); an annotation contributes no value anywhere — a value slot containing only `;{…}` has no value material, and the ordinary missing-value rule applies (DELTAS 11; overrides the 0.10.0 empty-string fabrication). To output a literal line-initial `;`, hold it: `\;`.

## 9. Deferred material

Recognized and **held**, always. Determination belongs to consumers — their schedules, origins, moments.

### 9.1 References `@`

| Position | Form |
|---|---|
| Block / sameline | `@head` — reference child / reference value; equal footing with `\|` |
| Embedded in flow, and in delimited slots | `@{head}` ⟨PROPOSED — replaces `!{{expr}}`; also the bracket-slot form `[@{key}]`⟩ |
| Held as a value | `@<head>` — the artifact is the value; type "reference" ⟨PROPOSED; alternative `<ref: head>`⟩ |

- **The head grammar is the addressing theory's** (CARVEOUTS §PATH). This version recognizes the selector subset — `name?`, `[key]` (a value slot; unclosed → partial), `.trait`* — and, in the delimited forms, a raw balanced head carried whole. The selector is frozen: the path grammar replaces it wholesale.
- **Intended-cardinality ⟨PROPOSED⟩**: trailing `?` `*` `+` on the head — `{0,1}`, `{0,N}`, `{1,N}`; default `{1,1}` (`@author` · `@reviewer?` · `@tags*` · `@authors+`). Declared at writing, belonging to the reference; recognition records, never enforces. Every miss gets its meaning from it; every response belongs to the consumer.
- A mixed literal-and-reference value (`pre@{x}post`) is a **text value** with reference segments. Escape: `\@`.
- **Truncated heads fail safe**: marked partial; every consumer excludes them from determination.
- Origin-posture (relative vs universal-origin) is written intent carried in the head — grammar owner: addressing theory.

### 9.2 Generators `!`

A generator **parses exactly as an element does** — names, identity, assignments, sameline values, geometric body, the same one-way door — with `!` marking the species (DELTAS 2):

```udon
!if @{user.admin?}
  |admin-panel
!else
  You are not an administrator.
!for :item @{posts*} :as post
  |card :title @{post.title}
```

- Heads are parsed; arguments are ordinary values (references, scalars, captures). Chains (`!else`/`!elif`) are same-column adjacency — a vocabulary concern, not core structure.
- Inline `!{name …}` (UDON-parsed body) is a flow segment and a value.
- **Recognition holds every generator, permanently** — carried whole in the model, never evaluated. Evaluation-time hold (surviving one evaluation as data) is a schedule concern (CARVEOUTS §HOLD).
- Generator names are open (the core does not enumerate); which exist and what they do is a vocabulary's. The baseline template vocabulary is a companion. Placement: anywhere a block-form element can go, and nowhere it can't — derived, not stipulated.

### 9.3 Captures — held spans for a vocabulary

A capture holds a span for construal by a named vocabulary; one family, three geometries (DELTAS 3/14):

| Geometry | Form | Body |
|---|---|---|
| **value** | `<body>` · `<kind: body>` · `<vocab:kind: body>` | `<>`-depth-counted to the matching `>`; multi-line; the ladder carries ("envelope" remains this geometry's name) |
| **block** ⟨PROPOSED⟩ | `<kind:` at Structure Position, body deeper | geometric: dedented to the first content line's column; a same-line tail after the `:` is body (and does not set the base); dedent closes |
| **fence** | ` ``` ` | byte-exact; no dedentation; closes at a line whose first non-space content is ` ``` ` |

- **Unlabelled dispatch is resolution**: an unlabelled capture is a reference into the document's declared-vocabulary scope; declared order is a preference policy; all-decline is a miss against `{1,1}` — meaning from cardinality, response from the consumer. No vocabulary bound: the span passes through lexically with nothing lost.
- The block form replaces `!:kind:` (which was the capture family wearing the generator sigil) ⟨PROPOSED; the conservative alternative retains `!:kind:` as an alias during migration⟩. The in-flow capture `!{:kind: …}` is **dropped pending demand** ⟨PROPOSED⟩ — prose carries code as opaque text (Markdown spans) already; value-position and block captures cover data (DELTAS 14).
- Use a fence when byte-exactness matters; the block capture for ordinary code/typed bodies.

### 9.4 Stance and schedules *(informative)*

Consumers determine — resolve/dereference references, evaluate generators, construe captures — each use from an origin, as of a moment. A pipeline or store is a schedule of uses; "uncooked" is a property of an item, not a stage; a store may keep held references and resolve per-query. None of this is recognition's business.

## 10. Values and types

### 10.1 The frozen bare set

String, integer, float, boolean, nil, list — recognized from bare syntax alone, **closed forever**. Everything else is written in a capture. `TRUE` is a string; a bare `2026-07-11` is the string `"2026-07-11"` — temporal values take the capture (`<2026-07-11>`); rational/complex are not bare (standard-types vocabulary, future).

### 10.2 Numbers

Integers: optional sign; `_` between digits, value-neutral; bases by prefix — decimal (none or `0d`), hex `0x`, octal `0o`, binary `0b`; `0755` is decimal 755. Floats: decimal with fraction and/or exponent.

### 10.3 Strings

`"…"` and `'…'`; a string closes at the next occurrence of its own quote; interior bytes — `\` included — pass through. **No core in-string escapes, ever**: to contain one quote kind, use the other. The bare fallback: an unquoted single token that is nothing else is a string.

### 10.4 Lists

`[…]`: items space-delimited, each typed by the full value grammar (numbers, strings, captures, nested lists, references, inline elements). No multi-word unquoted text inside — quote it. A quoted item's closing quote ends it (`["x"y]` is two items). `[ ]` closed is the empty list.

### 10.5 Delimited constructs span lines; fail-safes are declared

**A delimited construct closes at its printed closer — geometry is irrelevant — unless it declares a fail-safe boundary, with its reason** (DELTAS 12; this replaces the 0.10.0 per-construct multi-line table and its "deliberately unspecified" register):

| Construct | Spans lines? | Declared fail-safe |
|---|---|---|
| strings, `\|{…}`, `<…>` value captures, fences, `@{…}`/`@<…>` heads, `!{…}`, `;{…}` | **yes** | — |
| lists `[…]` | **yes** ⟨PROPOSED — was closed-at-EOL-with-Warning⟩ | — |
| identity / selector brackets `[…]` | no — **EOL fail-safe** | an editing accident (`\|el[k`) must not swallow the document; closes at EOL, captured-so-far → `$partial-key` / partial head + Warning |

An unclosed delimited construct at end of input keeps everything, closes with one Warning citing its opener, and marks the document `incomplete-input` (§11.3).

## 11. Extent and end of input

### 11.1 Geometric vs delimited

Every construct closes one of two ways and MUST declare which: **geometric** (EOL, dedent, EOF — closes silently) or **delimited** (matching printed closer — a promised closer that never arrives warns and keeps). Geometric: elements, assignments and bodies, annotations, generators, block captures, text blocks. Delimited: strings, lists, brackets, inline forms, value captures, fences.

### 11.2 Fail-safe boundaries

A delimited construct MAY declare a fail-safe boundary (§10.5) — an early close with a Warning and a fail-safe keep shape — only with a stated accident-containment reason. Fail-safes are recognition policy, not grammar: a future version may narrow one with a warning first, never silently.

### 11.3 End of input

**EOF ≡ end-of-line + full dedent** — no special cases. Geometric constructs close silently (a missing final newline is never an anomaly; `;`⟨EOF⟩ ≡ `;⏎`; a bare marker as the final byte is text by its failed guard). Delimited constructs still open keep everything, close innermost-first with one Warning each (content first, then the unclosed signal, then the close), and the document result is **incomplete-input** — a per-document fact surfaced by consumers as non-success. For streaming, end of input is the producer's explicit signal, never a chunk boundary.

## 12. Anomalies

### 12.1 Two severities, defined by loss

**Warning** = everything kept, may not match intent. **Error** = something lost, or a required value genuinely absent; recognition continues — nothing after an error point may be silently discarded. Mechanically checkable: if every author-visible byte is represented, severity MUST be Warning. **The sole core Error**: `:label` with no value → Nil + Error. Misses are not anomalies (G8).

### 12.2 Keep-everything

Wherever a coherent keep exists, keep and warn. Known keeps: text-value fallback with the marker restored; content-base re-basing; late assignments; tab best-effort; `$partial-key` / partial heads; unclosed delimited extents. Silent drop is non-conformant. The response ladder (drop/halt/reject) belongs to consumers over the complete model.

### 12.3 Representative cases

| Situation | Severity | Keep shape |
|---|---|---|
| Unclosed delimited construct | Warning (+ incomplete-input at EOF) | partial content, opener cited |
| Unclosed identity/selector bracket | Warning | `$partial-key` / partial head |
| Late assignment | Warning | accepted |
| `:label` under an open assignment body | Warning | text of the body |
| Inconsistent text indent | Warning | re-base |
| Root-level `:label` | Warning | document text |
| Tab in indentation | Warning | best-effort text keep |
| `:label` missing its value | **Error** | assignment with Nil |

## 13. Design principles (normative constraints)

1. Sameline is value-space; prose lives in bodies.
2. Spaces only in indentation.
3. Syntactic typing; the bare set frozen; captures are the only growth surface.
4. Stacking, not last-wins — silently.
5. Bounded lookahead as language law.
6. Sugar is designated assignments, never parallel model fields.
7. **Recognition holds; it never determines.**
8. **One hold operator per level, one precedence: held beats everything.**
9. **One deferred family per species** — a new deferred construct is a new head in an existing family or it is ill-formed.
10. Keep-everything; severity = loss; miss meaning from cardinality.
11. Every construct declares its extent kind — and any fail-safe boundary, with its reason.
12. The text law (MODEL §6): document text reconstructs by pure in-order concatenation; assignments (`$main` included) are not text material.
13. **No spelling fixes origin or moment**; the surface carries only the writer's declared origin-posture and cardinality.

---

## Appendix A — annotated surface map (non-normative)

```udon
; an annotation (owns anything indented deeper; interior opaque)
|element[key].trait :attr value :ok? true
;        │    │      │           └ presence explicit — no implicit true
;        │    │      └ assignment: the PARENT's label for the value   (§6.1)
;        │    └ trait: what KINDs of thing — stacks                   (§5.3)
;        └ identity: what makes it THIS one; @[key] points at it      (§5.3)
  :block-attr one value :and-another 2
; └ same value grammar on its own line; markers terminate values      (§6.4)
  :node-attr |config :first 1 :second 2
;            └ the node IS the value (one-way door applies)           (§6.8)
  Block prose with |{em inline}, @{user.name}, and ;{a note}.
; └ text-space: markers literal; braces are flow's own structure      (§7)
  :when <2026-07-11>
;       └ capture: everything beyond the frozen bare scalars —
;         a vocabulary construes it; bare space can never be retyped  (§9.3)
  <python:
    print("| not udon here")     ; held span — never parsed           (§9.3)
  @other[key]?                   ; reference, {0,1} declared, held    (§9.1)
  !if @{flag}                    ; generator: parses as an element,
    |shown-when-true             ;   held by recognition, a vocabulary
                                 ;   evaluates it later               (§9.2)
\| this line is literal text (the \ held the marker)                  (§4)
```

Sugar is honest (`|element[key].trait? Title` ≡ the longhand assignments), and nothing is ever thrown away: malformed input keeps its bytes with a Warning marking the spot (§12).
