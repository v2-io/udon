# 04 — Discussion: the implied root node, top-level text, and top-level `:labels`

**Who wrote this:** a history agent (Claude, Opus 5.5), 2026-09-29, for Joseph and the coordinating agent. I wrote it after reading the neutral file [`04-root-and-top-level-text.md`](04-root-and-top-level-text.md), [`README.md`](README.md), and [`../README.md`](../README.md). I did not see any leans file.

**What this holds:** the history of this one question, oldest first, followed by my own reading of it. There is no lean and no recommendation. Leans get added later by others.

**How to read it.** Everything in the History section is quoted or located so you can check it. Joseph's words are verbatim, taken from `~/.claude/history.jsonl` (his typed prompts only, with the layout intact), not from memorata, which drops indentation and newlines. UDON and file excerpts come from the files or from `git show` at the commit named. Where I give an interpretation, I say so. The sections called *Threads worth noticing* and *What the neutral file misses* are entirely mine.

## Method and searches (so every "nothing found" carries its search)

**Repository and file sources, read directly:**

- The 2011–2012 originals. The brief's `~/src/_ref/` path doesn't exist; they are at `~/src/_older/udon/` and `~/src/_older/udon-c/`.
- Mainline `spec/CORE.md`, `spec/msc/CHANGELOG.md`, `design/udon-ast.md`, `_archive/SPEC-INDENTS.md`.
- `core/generator/*.descent.udon` (current and legacy), `core/fixtures/`, the test harness, and `core/fixtures/_wip/FINDINGS.md`.
- In `v2/`: `DECISIONS.md`, `OPEN.md`, `spec-0.09.01/`, `spec-0.10.00/`, `spec-0.10.01/` (including the audit and the gaps fixtures), `theory/to-integrate/` (the underlying-logical-model letter, markdown scope, the CommonMark table), `references/.archive/second-theory-iteration-2026-08-08/`, `.archived/first-pass/` (the greenfields), `.archived/second-pass/` (RULING-TABLE, RULING-SUPPLEMENT, SPEC, ADM, FIXTURES), `.archived/FOR-JOSEPH.udon`, `udon-needs/pipeline-discussion.md`, and `msc/`.

**Repository greps:**

- Across the whole udon repo: `root-level`, `root level`, `document-level`, `top-level`, `toplevel`, `root attr`, `$DOCUMENT`, `document root`, `document-root`, `root node`, `root element`, `implicit root`, `implied root`, `document node`, `content base`, `column 0`, `frontmatter`, `ROOT-BASE`.
- `git log -S` / `-G` for the key sentences, to date them.
- A scan of all 408 `.udon`/`.ud`/`.un` files under `~/src` for column-0 `:label` lines. The only hits are inside a fence in `comprehensive.udon`. No live document uses top-level attributes.

**Joseph's prompts:** `jq` over `~/.claude/history.jsonl`, restricted to udon/descent/firmatum projects, for `document root|root level|root-level|top-level|toplevel|topmost|top level|root node|root element|pseudo.root|implicit root|implied root|frontmatter|$DOCUMENT|column 0|col 0|root text|at root`.

**memorata-search queries.** Speaker classes used: `--joseph`, or `-c human-user agent-to-human document subagent-final-response`. Never `agent-thinking`.

1. "udon root node implied document root element" (`--joseph`, pool 200)
2. "zero distinction between document root level and being children of an element"
3. "udon attribute at the top of the file with no element, root-level attribute"
4. "udon document metadata frontmatter top of file attributes". Found nothing new.
5. "document root udon" (`--joseph`, pool 250)
6. "root-level attribute top-level :key document root udon" (since 2026-07-01). **No results.**
7. "implied root node filename metadata everything starts as children" (since 2026-08-15). **No relevant results.** Joseph's 2026-09-29 statement isn't indexed yet; I took it from `history.jsonl`.
8. "difference between a udon doc meant to be a partial vs a whole record vs a store of records"
9. "$DOCUMENT pseudo-element root attributes get their owner" (classes, since 2026-07-15)
10. "DOCUMENT pseudo element every document is an element file path content hash" (`--joseph`). **No results.** Found via `history.jsonl` instead.
11. "content base for text at the document root, leading whitespace stripped top-level prose indentation" (`--joseph`). **No results.**
12. "ROOT-BASE document-root block text content base" (classes, pool 200)
13. "udon does not have to start at column 0 indentation relative to parent" (`--joseph`)
14. "How do block comments and prose dedentation work -- they are not in elements either" (Dec 2025 window)
15. "prose dedentation at document level, block comments outside elements, column" (Dec 2025 – Jan 2026)
16. "block comments and prose dedentation at the document level outside elements" (`-c agent-to-human`, Dec 27–30)
17. "udon root element top-level attributes pseudo root" (classes, Jul 25 – Sep 1)
18. "snippet is the interior of an element, markdown file is already a udon snippet, top-level attributes" (`--joseph`)
19. "yaml frontmatter udon" (`--joseph`)
20. "multiple top-level elements fragments streaming whole document list of nodes udon" (`--joseph`)
21. "L1 root attribute phantom owner warning document text" (`--joseph`, Jul 15 – Aug 20)
22. "root-level :key phantom owner warning document text L1" (`agent-to-human` + `subagent-final-response` + `human-user`, Jul 15 – Sep 28)
23. "no implicit root wrapper document is a list of nodes streaming fragments multi-root" (Jan 5 – Feb 20). **No results.** I could not find the session behind `design/udon-ast.md`'s "No implicit root wrapper".

**Measured today (2026-09-29).** I built `core/udon-core/examples/stdin_parse` at core HEAD (`parser.rs` last changed 2026-07-19) and ran it on the neutral file's examples and a few more. Results are quoted where relevant. This is the mainline parser, evidence of what was built, not an oracle.

**What I avoided or couldn't reach:**

- I didn't open any raw `.jsonl` transcripts.
- Some committed transcript files hold model thinking inline, e.g. `core/_archive/generator/2025-12-28-*.md` and `_older/libudon/_archive/generator/`. A memorata hit in one of them shows an agent reasoning about a "document base column" set by the first root-level line. It reads as thinking, so I didn't use it.
- For the `v2/.archived/second-pass/spikes/session-vault/` transcripts, I used only what memorata returned under non-thinking classes.
- Codex/Gemini/Grok chat logs I saw only through memorata; the greenfield files carry those models' positions directly.

---

## History (chronological)

Times are Joseph's local time (MST/MDT), taken from `history.jsonl` timestamps or commit dates.

### 2011 — the originals

**2011-08-03 · `~/src/_older/udon/ruby/udon/udon.statetable` lines 1–35 · document (Joseph's repo; commit "New statetable for comments")**

- The earliest state machine starts with `document()` → `:ws`, which consumes `[\s\t\n]` before dispatching to `#` (comment) or `|` (node). So at the top level, leading whitespace was simply skipped.
- The `comment(ns)` function sets `ipar=$indent` and later `ibase = $indent` from the first continuation line: the first-line-sets-the-base shape already existed, for comments.
- *Bears on Q1:* this is the oldest trace of both behaviors, skipping root whitespace and letting the first line set a base. *Incidental:* `#` as the comment character.

**2011-08-10/12 · `~/src/_older/udon/examples/ws-and-comments.udon` (moved from `test/` to `examples/` in commit 48f584d) · Joseph's test file.** Spaces shown as `·`:

```text
····#·Hello·comment·#1
······This·should·align
·····as·should·this
··#·A·new·one

····
··#·and·another·new·one
···woot
·····indented·by·2
```

- *Bears on Q1 (my reading):* the last two lines are top-level text. "woot" is at column 3 and the next line at column 5, and that line's own text says it is "indented by 2". That is only true relative to the first text line's column, which is option A's behavior at the top level.
- I found no expected-output file for this test, so this reading rests on the file's own wording.

**2011-08-15/19 · `~/src/_older/udon/examples/overview.udon` lines 1–10 · Joseph**

- The file opens at the top level with a comment whose continuation is indented (`# This is an UDON sample` / `  And the comment keeps on going...`).
- It also has top-level checklist text with an indented line under a text line: `[r] - raw data / text` / `  [r] - Can raw data have raw data children?`
- *Bears on Q1:* whether indented text under top-level text is its own thing was an open question in 2011.

**2011-08-22 · `~/src/_older/udon/doc/description.udon` lines 4–6 · Joseph**

> |Decision: Begin special block delimiters (| etc.)
>   So that the vast majority of documents are acceptable udon documents
>   (passthru). Unlike slim and to some degree yaml.

- *Bears on Q1:* a plain text file should pass through as UDON. How top-level text is treated decides how faithful that pass-through is.

**2011-12-14 · `~/src/_older/udon-c/docs/DECIDED.md` · Joseph (sole author).** From `git blame`: lines 9 and 103–108 were written 2011-12-14 (commit 4edf78e); lines 184–203 on 12-14 and 12-15. Under "Decided Syntax Elements":

```text
:{attribute ...}    # Inserted complex attribute, affecting the parent or root node
...
## "ROOT" NODE
* Implied
* ID is file path if applicable
* name is basename of path if applicable
* several :__ attributes for metadata- file access time, etc.
* stuff isn't, by convention, output during conversions
```

Under "UNDECIDED":

```text
## NODES
* Allow attributes of a node to continue to be scattered all over the place?
...
## ROOT NODE
* No way (from document) to set classes? - use :class-name true instead?
* No way to set id from source file? use :id (the id) instead?
```

- *Bears on both questions:*
  - The implied root with file metadata (path as ID, basename as name, `:__`-prefixed metadata attributes) is the 2011 design.
  - The proposed way to give the root an id or classes from inside the document was an ordinary `:id` / `:class-name true` attribute. That means a top-level `:label` becomes an attribute of the root.
  - Whether attributes could be "scattered" after children was open.
- *Incidental:* `:{…}` is an old embedded-attribute form, and `#` comments.

**2011-12-27 → 2012-01-06 · `~/src/_older/udon-c/lib/templates/udon.machine` lines 1–47 · Joseph (commits 49ce4bf, 70ab432) · evidence of what was built, not intent**

- The parser's entry point is `/node:child-shortcut`, which sets `S.node_type=ROOT`: the document is parsed as a ROOT node.
- In the child state, `c[:]` goes to the attribute state, which writes `S.attributes{…}`. So a top-level `:key value` became an attribute of the ROOT node, at any point in the document; there was no before-children check.
- The `:child` state skips `[ \t]` at the start of every content line. That is option C, but for every node, not only the root.
- `udon-c/docs/NOTES.md` lists "implement: toplevel data, toplevel comments".

### December 2025 — the revival

**2025-12-22 21:59 · `history.jsonl:5460` · Joseph** (the project at the time was `~/src`):

> It seems to solve that nagging disonance where AI likes markdown because it's got just enough expressiveness in its structure, but then needs yaml frontmatter for any deterministic processing... and the random xml tags or html but more as separators than structure... kind of a hodgepodge... maybe udon's time has really come-- where prose can be prose without ditching structure and where structure can be processable and easily schemad and checked without sacrificing prose and comments...

- *Bears on Q2:* part of the motivation for UDON is replacing frontmatter, which is exactly document-level metadata at the top of a file.

**2025-12-23 · `analysis.md` in the initial commit f5813bd (now archived under `notes/`) · a document that doesn't name its author** ("Analysis prepared December 2025, examining a 2011 project…"). It reads as agent-prepared; Joseph committed it. Section "Resolved Decisions (December 2025)", lines 472–481:

> ### 8. ID/Class on Root Node
> **Question:** No way to set ID/classes on root from within the document?
> **Decision:** Use regular attributes.
> **Rationale:**
> - `:id the-id` and `:class foo bar` as attributes work fine
> - The `[id]` and `.class` shortcuts are convenience for nested elements
> - No special syntax needed for root

- The summary table (line 523) repeats "Root ID/class | Use `:id` and `:class` attributes" and also says "Scattered attributes | No; attributes must precede children".
- *Bears on Q2:* this is option B, answering the 2011 "undecided" item, together with the before-first-child rule for the sub-question.
- The same commit's `SPEC.md` gives `document = { line }* ;`, with no root in the grammar.

**2025-12-23 21:45 · `history.jsonl:5527` · Joseph** (his paste, layout intact):

```text
This problem doesn't make sense to me. Markdown *is* correct UDON:
       22         # API Documentation
       23
       24         **Version:** 2.1.0
       25         **Last Updated:** 2025-01-15
       26
       27         ## Authentication
       ...
       35         | Tier | Requests/min |
       36         |------|--------------|
       ...
That is correct UDON from the beginning. I think you can do better-- at the very least have them convert the yaml frontmatter and a specific section into udon.
```

- *Bears on Q1:* a whole markdown document at the top level is "correct UDON".
- *Incidental here:* the `| Tier |` table lines are file 08's question.

**2025-12-24 09:12 · `history.jsonl:5569` · Joseph:**

> Pure prose-- markdown *is* a subset of udon-- except frontmatter can now be anywhere.

- *Bears on Q2, loosely:* structured metadata isn't confined to a top-of-file block.
- *Also on Q1:* pure prose at the top level is the markdown case.

**2025-12-25 · `_archive/SPEC-INDENTS.md` (commit 1d3f999, committed by Joseph; the file doesn't name its author)**

- States "**The one rule:** `pop while new_column <= stack_top.base_column`" and the content-base rule for prose, all in terms of "element".
- Its multi-level-dedent example ends with "Stop (stack empty or at root)".
- *Bears on Q1:* the rule is written for elements; the root appears only as the bottom of the stack.

**2025-12-28 14:25 · `history.jsonl:6050` · Joseph:**

> You understand that dedentation check is relative to the parent, and that nothing is hardcoded for literal column 0, right? There is no "root-level directives".  Tests shouldn't assume udon starts at column 0 or anything. You've read ~/src/udon/SPEC-INDENTS.md, right?

- *Bears on Q1:* a UDON document need not start at column 0. The subject was directives and dedent, but the principle ("nothing is hardcoded for literal column 0") is general.

**2025-12-28 14:27 · `history.jsonl:6052` · Joseph:**

> How do block comments and prose dedentation work -- they are not in elements either (at least not necessarily)

- *Bears on Q1 directly:* this is the top-level text-base question, asked by Joseph himself.

**2025-12-28 ~14:30 · the libudon session (memorata: `~/.claude.bak.2026-01-26/projects/-Users-josephwecker-v2-src-libudon/7947ca84…jsonl:3800`, class agent-to-human) · Claude (libudon agent), answering the question above:**

> **The key principle:** Everything participates in the column-based hierarchy uniformly. There's no special case for "document level" - there's just an implicit parent at column -∞.
> …
> At document level, the "parent" is implicitly at column -∞, so prose at any column is valid. Prose ends when the parser sees a prefixed line (element, directive, attribute, comment) at any column.
> …
> The `document` function doesn't need a COL parameter because the implicit document root has base_column = -∞ (or practically: just don't pop when stack is empty).

- *Bears on Q1:* this is an agent's answer, and it reads as option A: an implicit root parent, with the element content-base rule applying beneath it. It doesn't say in so many words that the first top-level text line sets the base.
- I found no reply from Joseph to it. The grammar that followed passes `-1` as the parent column for top-level text (see 2026-07-16 below) but strips per line.

**2025-12-28 18:08 · `history.jsonl:6100` · Joseph:**

> …our unit tests are severely deficient if, for example, they all presuppose column 0 parsing etc.

**2025-12-31 / 2026-01-01 · SPEC comment table (commits 7ac593b, c0025bd)** gains the row "Document root | Line comment | `; file header comment`". It is still in `spec/CORE.md` line 799. *Incidental to this file (see 03), but it is a root-specific rule.*

**2026-01-02 11:47 · `history.jsonl:6836` · Joseph:** "Why does that trigger a comment at document root?  Is that part of the spec?"

**2026-01-02 11:56 · `history.jsonl:6837` · Joseph** (layout intact):

```text
There should be zero distinction between "document root" level and being children of an element or attribute. "Document root" has no meaning in UDON (that I can think of).

Can you let me know everywhere else the spec mentions document root?

In the case of comments, they can happen as follows:

1.
     ;  anywhere at the beginning of a line (starts a comment block)
      still part of the same comment.

2.
  |el hello there  ; after a space in "sameline" mode
  |el :akey ; ditto
  |element :akey something |child prose within child ; ditto

3. Either anywhere as inline ;{...} (balanced brackets inside)
  or potentially, if easier, inline anywhere within prose or on sameline:
  |element ;{inline comment} :attr value
  (so whether you can do this is undefined- it would be nice if it's not too complicated:   |ele;{hmmmm}ment :attr value ; -> == |element :attr value -- but events get weird.)
```

- *Bears on both questions:* the principle is that the top level should behave like the inside of an element.
- *What prompted it* was a `;` rule (file 03). The comment examples illustrate `;`, not root text or attributes.
- The same session committed 7003996 (12:08): "remove document root distinction… Removed root_only test infrastructure (no longer needed)."

**2026-01-02 17:43 · `history.jsonl:6956` · Joseph:**

> Markdown uses text markings (headers, subheadings, list items, links, etc.) for semantic structure. It also uses yaml frontmatter but we can exclude that.

- *Context:* a markdown-structure discussion. I didn't trace what "exclude" referred to, so this is a weak data point.

### January 2026

**2026-01-14 · `design/udon-ast.md` (commit e8b82f7 by Joseph, "our desired AST"; the file doesn't name its author)**, lines 12–26:

```ruby
Document = [Node]
```

> No implicit root wrapper. This enables:
> - **Streaming**: Append nodes as they complete
> - **Fragments**: Same type as full documents (useful for includes/templates)
> - **Multi-root**: Valid UDON can have multiple top-level elements

- Also: `parent: Node?  # nil for root-level nodes` and `node.root  # document root (first top-level node)`.
- *Bears on the settled point and on Q2:* this is the first written position against an implied root, with three reasons.
- No session behind it turned up (search 23).

### July 2026 — mainline 0.9, the greenfields, v2

**2026-07-11 · commit 62777ec (core) · agent under Joseph**

- Reintroduces a root-only fixture: `legacy-pre-0.8/attributes.yaml` has `colon_non_name_at_document_root` with `root_only: true`.
- The test harness (`core/udon-core/tests/common/harness.rs` lines 274–286) runs every fixture with "element-wrapping mutations" unless the fixture is flagged `root_only`.
- *My reading:* the harness assumes the top level and an element's interior behave the same, except where flagged.

**2026-07-15 · `core/TODO-PARSER.md` (commit 2b9e324)** designs `TreeStream`, in which "completed root-level subtrees ship as one root-level subtree per shipment". *Bears on the implied root and on file 13:* the streaming unit is the top-level subtree.

**2026-07-16 · current descent grammar (`core/generator/00-udon.core.descent.udon` lines 94–135; the root-attr path already existed in `udon-legacy-pre-0.8.descent.udon` lines 75–100):**

- A top-level `:` goes to `:check_attr` → `/block_attr` → `:root_attr_check`, with the comment: "Deferred values are not supported at document root (attrs there are already an edge case) — an open attr resolves immediately."
- Top-level text goes to `/prose(col, -1, …)`: the parent column is `-1`, each line is dispatched separately, and leading spaces are counted as indentation and dropped.
- *Evidence of what was built:* top-level attributes are free-floating, and top-level text is stripped line by line (C).

**2026-07-18 12:29 · `core/fixtures/_wip/FINDINGS.md` line 120 (commit 6afd89b) · agent (EOF harvest):**

> 6. **Root-level `:x`<EOF> (attribute with no element).** `[agent]` — emits a free-floating `Attr "x" / MissingAttributeValue / Nil` with no owning `ElementStart`; CORE never defines a root-initial `:key`. Note the asymmetry the parser already has: `:`<EOF> (no name) → prose, but `:x`<EOF> → root attribute. **Ruling.**

- The harvested fixture comment adds: "What does a root-initial `:key` mean? (Prose? An attribute of an implicit root? An error?)"

**2026-07-18 13:28 · `history.jsonl:16654` · Joseph:**

> Mark root level :x as undefined in the spec right now. The rest should already be answered by the general pattern I would hope (eof = [or triggers] eol+full-dedent)

This became commit 6801224 (13:30). `spec/CORE.md` line 395 now reads:

> An attribute at the **document root** -- a line-initial `:key` with no owning element -- is **undefined** in this version: the parser currently emits a free-floating `Attr`, but do not rely on it (a future version may make it prose or an error).

The CHANGELOG entry at line 144 says the same.

- *Bears on Q2:* this is Joseph's last recorded direct word on top-level `:key` before v2. His word was "undefined", not a choice.

**2026-07-19 22:11 · greenfield rewrites (commit b10d16d; archived at `v2/.archived/first-pass/`)**

- **Gemini (3a)**, first draft, `2-SPECIFICATION.md` line 14: "The ADM is an ordered tree where every node is an **Element**. The document itself is implicitly a root Element holding the top-level definitions."
- **Grok (3b)**, `new-spec/DECISIONS.md` D3 (first version): "**Decision:** Error; keep line as Document-level Text including `:`. … **Reasoning:** Attributes are edges of Elements; root edges without a node are not in the ADM. Error + keep beats silent free-float."
- **Grok (3b)**, `MODEL.md`: "A Document has no implicit root Element. Multiple top-level Elements are siblings."

**2026-07-19 23:23 · Grok's feedback on 3a (`greenfield-3a/feedback-from-grok.md` lines 105–115, commit a5d834b):**

> **SPEC §1:** *"The document itself is implicitly a root Element."* The scrubbed model is a **forest** of top-level items (elements, directives, comments, prose), not an implicit root element. Implicit root changes Host APIs and duplicate-key scope narratives. If 3a *intends* a root Element as a greenfield ADM change, it needs a marked decision and reasoning — not a silent glide.

- **Gemini revised 3a in the same commit**, `new-spec/DECISIONS.md` lines 28–31: "## D6 — Document Root is a Forest … **Source:** Implicit root element was implied but muddy. **Decision:** The ADM is a forest of TopLevelItems… **Reasoning:** An implicit root changes duplicate-key scoping narratives and Host APIs."
- *Bears on the settled point:* the implied root was proposed and then withdrawn within hours, on Grok's objection.
- *Note (mine):* the objection was procedural ("a silent glide") as much as substantive. The substantive reasons given are host APIs and duplicate-key scope.

**2026-07-20 · Fable (Claude) · greenfield-2a `new-spec/OPEN-QUESTIONS.md` line 7 (commit 09fd522):**

> | Q1 | Attribute at document root (`:key` with no owning element) | free-floating attribute / text / error | Text with a warning — it preserves keep-everything, and a root "attribute" has no edge to hang from; a free-floating attribute invents a phantom owner. |

In the same commit:

- **Fable on 3a** (`greenfield-3a/feedback-fable.md`, line 9 in the current file): "**D6 (the document is a forest, no implicit root) is the best single decision in the suite.** Nobody's source text said it out loud, it has genuine API consequences (duplicate-key scoping, host surfaces)… This one deserves to survive into whatever the ratified spec becomes."
- **Fable on 3b** (`greenfield-3b/feedback-fable.md` line 33): "§14.3: root attribute → Error, kept as text (nothing lost)… the root-attribute row has no such defense… demote the root-attribute row to Warning." Grok's 3b D3 was then revised to Warning ("severity refined after Fable").
- **Grok on 2a** (`greenfield-2a/feedback-from-grok.md` §3.5): "Recommendation (text + warning) is sensible; 3a/3b pinned Error + keep. Undefined is fine if OPEN is canonical; just know three greenfields will disagree until Joseph rules."

**2026-07-20 (night) · `v2/.archived/second-pass/RULING-TABLE.md` line 104 and `RULING-SUPPLEMENT.md` lines 170–180 · Grok's draft, stress-checked by Fable**

- L1 was offered as: **A** Warning + document text · **B** Error + keep · **C** free-floating attribute · **D** carry "undefined".
- The table notes: "Prior **ruling was undefined**, not A/B. Greenfields re-litigated without that cite."
- The supplement describes C as "(invents a phantom owner — nobody wants this)".
- The drafter's lean was "**A** if defining now; **D** if v2 stays thin".
- **Joseph's Ruling column for L1 is empty** in the archived table. So is L0's.

**2026-07-21 02:49 · `v2/DECISIONS.md` lines 65–67 and 106–111 (commit 359fed3) · Grok, working overnight**

Joseph's framing at 11:08 the next morning (`history.jsonl`): "I asked a grok instance to see what they could do about taking some ownership and helping me be more of a steward and less the bottleneck". The section is titled "Operator / panel-lean closes (2026-07-21) — High-consensus greenfield + pipeline leans, landed thin. **Overturn freely** via PROCESS if wrong." L1 reads:

> **L1** | Root-level `:key` (no owning Element): **Warning** + keep as **document-level Text** (including `:`). Not a free-floating Attribute in the ADM. | Attributes are edges of Elements; no phantom owner. Bytes preserved → Warning under L0. Portable meaning: none — do not rely on root attrs as data.

- The same night's GLOSSARY: "**Document** | Ordered top-level content (no implicit root Element)… | Consensus forest model".
- The ADM has a `TopLevelItem` union and a fixture `root_attr_is_document_text`.

**2026-07-21 · `v2/udon-needs/pipeline-discussion.md`**

- Grok (line 588) lists "**L0/L1** (error = loss; root `:key` = warn + document text)" among the night's durable residue.
- Fable, relayed by Joseph in his own turn (line 668): "the panel-backed language closes (L0/L1/L2/L4, the CARRY citations) don't depend on the R/A/R/E ontology at all — both grok and I flagged that set as survivors — and a future session that can't see them may re-argue ruled ground."
- Joseph archived the skeleton and let DECISIONS graduate as a "first cherry-pick".

**2026-07-22 · `v2/spec-0.09.01/CORE.md` lines 252–253 and `MODEL.md` line 20**

- CORE: "**Root-level attribute.** A line-initial `:key` with no owning element is a **Warning**; the line is kept as document-level text, `:` included… *(Ruled L1, 2026-07-21 — supersedes alpha.2's "undefined"; see DELTAS.)*"
- MODEL: "There is no implicit root element; multiple top-level elements are true siblings."
- *Note (mine):* "Ruled" here labels a panel-lean that Grok landed with "overturn freely". Joseph's own last word on it was "undefined" (07-18).

**2026-07-23 12:20 · `history.jsonl:17392` · Joseph**, listing markdown/UDON surfaces to brainstorm, among them:

> - markdown with udon frontmatter
> - udon with the leftmost head-position (primary content) being primarily markdown

- These became rows B1 and A2 of `theory/to-integrate/refine-more/markdown/thoughts-on-scope.md` (2026-07-28).
- B1 asks about "the **delimiter** (`---` fence, as YAML? a UDON-native open? column-0 `\|`?)". Line 305 adds: "**Frontmatter delimiter** (B1) touches PRAGMA / doc-preamble territory."
- *Bears on Q2:* top-level metadata lines are UDON's natural frontmatter. *On Q1:* the "leftmost head-position being primarily markdown" case is top-level text.

**2026-07-28 · `v2/theory/to-integrate/refine-more/markdown/commonmark-non-conflict-table.md` §3.1 (lines 119–153) · agent, measured against all 652 CommonMark examples at core HEAD:**

> **The parser does.** Inside an element, exactly that — base honored, extra indent preserved, re-base warning fires. At document root, all leading whitespace on every line is discarded as geometry, with no anomaly:
>
> ```text
> "alpha\n  beta\n"           -> Text "alpha\n"  Text "beta\n"      (root: 2 spaces gone, silently)
> "|sec\n  alpha\n    beta\n" -> Text "alpha\n"  Text "  beta\n"    (element: 2 extra spaces kept)
> ```
> …
> **What is open.** CORE §7.2 is written entirely in terms of *"the element"* and *"the parent"*. It never states the content base for text owned by the **document**. … I don't know which of the three resolutions is right and am not guessing.

- Other findings in that file:
  - Byte-exact survival was 76.2% at the top level against 86.7% embedded.
  - 107 top-level cases turned on indentation, against 49 embedded.
  - Five markdown fences inside indented list items were wrongly recognized as UDON fences at the top level.
  - Its summary: "*markdown parsed as a bare UDON document at root loses its indentation structure; the same markdown nested inside any UDON element keeps it.*"
- That evening `v2/OPEN.md` line 90 gained the **ROOT-BASE** row (commit e2b3fcf).

**2026-07-28 · `v2/.archived/FOR-JOSEPH.udon` lines 45–66 · agent offer, then Joseph's answer**

- The agent listed ROOT-BASE as high-leverage: "(gates whole-document schema; one instance of the element-centric/root-silent defect class worth a systematic sweep)".
- Joseph (`|answer :by joseph :date 2026-07-28`):

> These are open binary questions that shouldn't be asked yet on a spec that hasn't been written yet. It's precisely our current work that will make the answers self-evident in the future. Consider marking the whole file "hypothetical" … consider anything open there or in the spec as "open for guidance from the schema/path/meta team"

- *Bears on Q1:* ROOT-BASE was deliberately left open, in the expectation that the design work would settle it.

**2026-07-29 04:40 · `history.jsonl:17797` · Joseph:**

> It's likely that in many usages, udon will already end up being pulled apart into pieces for chunking and vectorization for semantic indexing. Would it make sense, for example, to as a first effort, clearly distinguish between files that are (a) atomic (meant to be a single record in a table effectively, or a few with 1-1 mappings), (b) multi-document (ala yaml although I don't know that anyone ever used that feature, or like jsonl), (c) snippet -- something that's meant to be pulled into something else-- could, for example, have :attributes at the topmost level before normal children in the document....

- *Bears on Q2 and its sub-question:* top-level `:attributes`, "before normal children".
- *Context:* file roles, not a grammar ruling.

**2026-07-29 04:48 · `history.jsonl:17800` · Joseph:**

> Simple-- if it's a .md snippet-- auto-escape when interring. If it's .udon that happens to be mostly markdown but no elements declared, probably give a supressable warning...

- *Bears on both questions:* markdown brought into UDON gets its marker-looking lines escaped. That is one answer to "markdown lines that look like `:label`".

**2026-07-29 · `v2/theory/to-integrate/primary/underlying-logical-model.md` §5 (lines 85–109) and §8 (line 163) · Fable, as "a conversation record shaped into a letter … strictly provisional"**

On file roles:

> **(b) multi-record** — one file, many records as true siblings. UDON needs no `---` separator: multiple top-level elements are already siblings with no implicit root, and the streaming AST already ships completed root-level subtrees as its unit …
>
> **(c) snippet** — … **a snippet is the interior of an element whose opening line lives in the host.** Its top-level `:attributes` are the element's attributes, contributed by the file … *frontmatter, re-founded in one grammar* …

```udon
:register interior
:src fable
A snippet body — the interior of an element whose opening line lives in the host.
```

> *(Honest state: the current parser reads those attribute lines silently as text; 0.9.1's L1 ruling would warn and keep them as document text. … Note L1's own rationale is "no phantom owner"; a declared snippet role answers that rationale — the owner exists, elsewhere — rather than overriding it. But that's an argument, not a ruling.)*

§8 adds: "(c)'s root attributes are gated on the L1 conversation … The wrapper convention (an anonymous `|[id]` element, host splices) works today if demand arrives first."

- *Measurement discrepancy.* Running the letter's own example through the parser at core HEAD today gives `Attr "register"`, `BareValue "interior"`, `Attr "src"`, `BareValue "fable"`, `Text "A snippet body.\n"`. Those are free-floating attributes, not text. The parser file hasn't changed since 07-19, so I can't account for the letter's "silently as text".

**2026-07-30 · `v2/msc/read-log-2026-07-30/06-CORE.md` line 84 · agent reading log:** "G1 — content base defined for *an element*, document-root case genuinely absent | **HIT.**"

**2026-08-06 23:06 · `history.jsonl:18725` · Joseph** (his notebook notes, shared in the paths work):

> the other thing that I think might close things completely is having a document always be an internally designated pseude-element `|'$DOCUMENT'[unique-file-path][content-hash] ; and some file attributes, mtime, permissions, etc.`
>
> That allows us to do all sorts of "file-system-layout aware" vs "logical-only-ignore-all-document-boundaries"... or something...

- *Bears on the settled point:* the implied root comes back, this time from addressing, with the file path and content hash as its identity and file attributes as its attributes.
- *Incidental:* his example earlier in the same message (`|element` / `!if directive` / `; A comment` / `  :a-path @< … >`) is about references.

**2026-08-07 11:29 · `history.jsonl:18732` · Joseph:**

> …OH-- that reminds me, before I forget again if it's not already in the write-up (haven't gotten to the DOCUMENT part yet) -- having all udon documents with a pseudo root element solves the open "what to do with attributes at top-level" question in the spec, as well as "what's the difference between an udon doc meant to be a partial vs whole-record vs store of records..." etc. (just depends on what you decide to do with that root element).

- *Bears directly on Q2 and the settled point.*

**2026-08-07 · `v2/references/.archive/second-theory-iteration-2026-08-08/hypothetical-sketch.md` §6 (lines 81–94) · the paths-session agent ("wet clay"; origin "Joseph's notebook notes + the 2026-08-06 evening exchange")**

> - **Root attributes get their owner.** The "no phantom owner" rationale behind warn-on-root-`:key` is answered: `$DOCUMENT` is the owner. Frontmatter dissolves into `$DOCUMENT`'s attributes; a snippet is *the interior of a `$DOCUMENT`*.
> - **(Joseph, 2026-08-07) It also answers the partial/whole/store trichotomy** … One pseudo-root, three dispositions … Same move for the spec's open top-level-attribute question.
> - Consistent with the designated-`$` family: designated, not reserved, quoted-off in longhand, sugar-friendly.

- Archived 2026-08-08 with the rest of the second paths edition. The idea wasn't refuted; the reset was vocabulary-first.

**2026-08-08 13:01 and 2026-08-09 00:37 · `history.jsonl:18832` and `18897` · Joseph, on late attributes (K14).** This is not the top-level question, but it is the same pattern. His worksheet (layout intact):

```text
|element this prose is the first child ; this saved comment also on the wire usually
  :status pretty much open  ; This is attribute('status').value('pretty much open') -- no problem
  Some more children
  :a-rogue-attribute <value>  ; A warning is issued, but still becomes an attribute of 'element'
```

Then:

> (All that said, in the previous case, I'm pretty sure that I rember implying early on that "later it's just text with a warning 'looks like an attribute but it's just text'" -- and then later as I was working on the cheatsheet in the other area, I realized how useful it could be to have attributes further down after more of the content …)

- `v2/DECISIONS.md` K14 (line 173) records accept + warn, and its reasoning: "silent text-demotion of an attribute-shaped line is the bigger surprise."
- *Bears on Q2 by analogy:* L1 is also a text-demotion of an attribute-shaped line.
- *Bears on the sub-question:* for elements, attributes after content are now accepted with a warning.
- *Incidental in the worksheet:* the sameline `$main` and comment details.

**2026-08-09/10 · `v2/spec-0.10.00/CORE.md` §6.1 line 281, §14.3 line 807, §2.1, §7.2; `MODEL.md` line 19**

- 0.10.0-alpha.1 carries L1 unchanged ("Root-level `:label` … Warning; … document-level text").
- MODEL still says "There is no implicit root element".
- §7.2 still describes the content base only for "the element". §2.1's text-interior exception reads: "Once an element has an established **content base** for block text (§7.2), a line indented *deeper* than that base is inside the text — literal, even if it begins with a marker-looking character."

**2026-08-27 · `v2/spec-0.10.01/CORE.md` lines 157 and 391** (the draft Joseph later called a misfire) carries L1 again. Nothing new on the root.

**2026-09-01 · `v2/spec-0.10.01/working-notes/AUDIT-2026-09-01.md` line 97 · Fable (audit):** "**D15.** ROOT-BASE and SEMI-BASE from OPEN.md are still open and the draft still doesn't state the root content base…"

The gaps fixture `fixtures/descriptive/gaps.yaml` lines 425–433 lists three readings for `"  indented root text\n    deeper\n"`: `base_at_2`, `no_base`, `strip_all` ("the 0.9 parser's silent behavior"). These are the neutral file's A, B, C.

**2026-09-29 18:18 · `history.jsonl:21299` · Joseph:**

> We can also settle (unless someone feels we need to adjudicate it still) on the document being parsed has an implied root node -- so everything starts as children of that node, which might also have metadata like filename etc...

**2026-09-29 · measured today · parser at core HEAD (via `stdin_parse`)**

- Neutral Q1 example `"  indented first line\n    more indented\nback to zero\n"` → `Text "indented first line\n"`, `Text "more indented\n"`, `Text "back to zero\n"`. This is C, with no anomaly.
- `"NOTE: terms\n  - origin (== x)\n  - step\n"` → the list lines lose their two spaces.
- `"  intro text\n  |sib\n    |deeper\n"` → text, then element `sib` containing element `deeper`. At the top level, an indented marker line after text is structure.
- `"  |a\n  |b\n|c\n"` → three sibling elements.
- Neutral Q2 example → `Attr "title"`, `Text "My Notes\n"`, `Attr "author"`, `BareValue "jw"`, then the element. These are free-floating attributes.
- `"Title\n:note this line\n|el\n  :note inside\n  text\n  :late x\n"` → at the top level, `:note` after text is still an `Attr` with no warning. Inside `|el`, the late `:late x` gives `Warning "AttributeAfterChildren"` + `Text ":late x\n"` (the 0.9 rule, before K14).
- `":smile: great day\n"` → `Attr "smile"`, `Error`, `Nil`, `Text "great day\n"`. A markdown line that starts with an emoji shortcode is read as an attribute with a missing value.

---

## Threads worth noticing

*This section is my reading, not a finding.*

1. **The implied root is both the oldest and the newest position; "no implicit root" is the middle.**
   - 2011 (DECIDED.md, and the C parser's `ROOT` node) had an implied root carrying file metadata.
   - January 2026 (`udon-ast.md`) and the July greenfields (Gemini's revised D6, praised by Fable) chose a forest. Their reasons: streaming, fragments/includes, multi-root, host APIs, and duplicate-key scope.
   - August (`$DOCUMENT`) and September 29 bring the root back from a different direction: addressing, file roles, metadata.
   - As far as I found, nobody on the record has answered the forest reasons since the root came back. They may be easy to answer, since an implied root can still ship its children one subtree at a time and a fragment can be "the interior of a root". But the answer isn't written down anywhere, and file 13 inherits it.

2. **L1's rationale depends on there being no root. Three independent sources said so before today.** L1's stated reason is "Attributes are edges of Elements; no phantom owner." Before this question was posed:
   - Fable (07-29): "a declared snippet role answers that rationale — the owner exists, elsewhere".
   - The paths sketch (08-07): "`$DOCUMENT` is the owner".
   - Joseph (08-07): "a pseudo root element solves the open 'what to do with attributes at top-level' question".

   With the root settled, the "phantom" part of that rationale no longer applies. The keep-everything and severity parts (L0) do not depend on it.

3. **L1's authority is thinner than the "Ruled L1" label in 0.9.1 and 0.10.0 suggests.**
   - Joseph's recorded words on top-level `:key` are: 07-18 "Mark root level :x as undefined"; 07-29 "(c) snippet … could … have :attributes at the topmost level before normal children"; 08-07 "a pseudo root element solves" it.
   - L1 itself is a panel-lean landed overnight by Grok under an "overturn freely" banner. Its Ruling cell in the archived ruling table is blank.
   - The Dec-2025 analysis ("Use regular attributes") and 2011 ("use :id / :class-name true") both point to root attributes.

   None of this makes L1 wrong. It only means that choosing B wouldn't overturn anything Joseph himself decided.

4. **Joseph's Jan 2 principle ("zero distinction between 'document root' level and being children of an element") has been applied piecemeal.**
   - It was triggered by a `;` rule, and the fix that day was only about `;`.
   - Afterwards, top-level-only behavior came back in several places: the `Document root` comment-table row, `root_only` fixtures, free-floating top-level attributes, and per-line stripping of top-level text.
   - The 07-28 agent called this "the element-centric/root-silent defect class worth a systematic sweep".
   - An implied root that "behaves like an element" would settle the whole class by definition, where a rule-by-rule approach settles one row at a time. The difficulty is what the root's own column is. The descent grammar already uses parent column `-1`; the Dec-28 agent said "column -∞". Either way, column 0 falls "strictly inside the parent", so §7.2's wording could apply unchanged.

5. **On Q1, the history leans toward "no stripping at the top level" but has never written a top-level rule.** In order:
   - The 2011 whitespace test is worded as if the first text line sets the base.
   - The 2012 C parser stripped everything, for every node.
   - The Dec-28 agent said the root behaves like any element.
   - The mainline strips top-level lines individually. The 07-28 measurement calls this silent loss: §14.2, "Silent drop of author-visible material is non-conformant".
   - Joseph declined to rule on ROOT-BASE on 07-28, saying the work would make it self-evident.

   The 09-29 implied root may be that work arriving. If it is, "the root is an element" makes A the default reading unless something says otherwise.

6. **The sub-question has moved over time, parallel to K14.**
   - 2011: whether attributes may be "scattered" was undecided.
   - Dec 2025: "attributes must precede children".
   - 07-29: "at the topmost level before normal children".
   - K14 (08-09): late element attributes are accepted with a warning. Joseph recalled an earlier "just text with a warning" instinct and moved off it because late attributes proved useful.
   - Today's parser accepts top-level attributes anywhere, silently.

   If the root is treated as an element, the same K14 question arises for it with no new principle needed. The alternative is deciding that lite differs from K14 here.

---

## What the neutral file misses

*My observations: framings and cases the history raises that the neutral file doesn't carry. Stated neutrally.*

**1. Q2 has more than two alternatives in the history.**

- **C — a free-floating attribute:** the parser's actual behavior since at least legacy pre-0.8, measured today. Everyone who discussed it rejected it ("nobody wants this"), but it is the incumbent in the code.
- **D — undefined / do-not-rely:** Joseph's 07-18 instruction, and still mainline CORE line 395.
- **E — Error + keep as text:** Grok's first 3b draft.
- **F — role-scoped:** top-level attributes mean something only for files declared as snippets (the 07-29 letter), with an anonymous wrapper `|[id]` as the workaround meanwhile.

Separately, the lite contract ("reserve, don't ignore"; a lite-accepted document must give the same tree in every future full version) offers a **G: refuse top-level `:label` in lite as reserved**. The neutral file's A (warning + text) is a permanent commitment under that contract. If full UDON later chooses B, every lite document that used A would change meaning. So the contract turns A-versus-B from "which is nicer" into "which is final".

**2. The neutral Q1 example is the one shape where A and B differ.** In the shape the history keeps producing, A and B give the same tree and only C differs. Examples: Joseph's markdown paste (12-23), `CHEATSHEET-2.un`'s top-level note block with `  - origin (== …)` lines, and CommonMark list items. In all of them the first line is at column 0 and later lines are indented.

```udon
NOTE: terms
  - origin
  - step
```

- A and B: `text "NOTE: terms\n  - origin\n  - step\n"`
- C (today's parser): `text "NOTE: terms\n- origin\n- step\n"`

**3. A uniformly indented document.** This case comes from Joseph's "Tests shouldn't assume udon starts at column 0" (12-28) and "our unit tests are severely deficient if … they all presuppose column 0 parsing" (12-28). Think of UDON pasted with a 4-space indent from a code block or heredoc:

```udon
    |config
      :port 8080
    Some notes
      indented detail
```

- A: `element config …`, `text "Some notes\n  indented detail\n"`. Same as the unindented document.
- B: `text "    Some notes\n      indented detail\n"`. The indent becomes content.
- C: `text "Some notes\nindented detail\n"`

**4. The text-interior exception at the top level (0.10.0 §2.1; file 81).** Once an owner has a content base, a deeper line that starts with a marker is literal text. The neutral file's Q1 examples contain only text lines, so they don't show this.

```udon
Intro paragraph.
  |b looks like an element
|c
```

- Today's parser: `text "Intro paragraph.\n"`, `element b`, `element c`. There is no top-level base, so there is no exception.
- If the root is an element and §2.1 applies to it (A, or B): `text "Intro paragraph.\n  |b looks like an element\n"`, then `element c`.
- Under B the question is sharper. If the base is always column 0, then after any top-level text, every indented marker line is text. Indented top-level structure could then only come before the first top-level text line.

**5. Parser-supplied metadata versus authored root attributes.** The history keeps them apart:

- 2011: "several `:__` attributes for metadata … stuff isn't, by convention, output during conversions".
- The `$DOCUMENT` sketch put the file path and content hash in identity brackets (`[unique-file-path][content-hash]`) and mtime/permissions as attributes.

Under Q2-B, a document that writes `:filename x` at the top meets a parser that supplies `filename`. Collision, stacking, or a separate channel? File 13 Q1 asks "kept separate?"; the history's two answers were a naming prefix (2011) and designated identity (August).

**6. Root identity from inside the document.** Both 2011 ("use :id (the id) instead?") and Dec 2025 ("`:id the-id` and `:class foo bar`") wanted a document to be able to set the root's id or classes. In today's vocabulary: do top-level `:'$key' …` / `:'$traits' …` set the root's identity and traits, possibly stacking with a parser-supplied path identity? The neutral file doesn't raise designated labels at the top level.

**7. Markdown lines that look like `:label`.** B makes some ordinary markdown lines into structure:

- Today's parser reads `":smile: great day"` at the top level as `Attr "smile"` + Error + `Text "great day"`.
- Definition-list-style lines starting with `:` are the same kind of case.

The history's answer for markdown brought into UDON is escape-on-import (Joseph 07-29 04:48); for hand-written `.udon`, nothing is recorded. This is a least-surprise case for the neutral file's B (and for A it becomes text + warning). Label characters are file 76's question.

**8. Where root attributes may appear, with evidence.**

- Today's parser accepts top-level `:label` after text, with no warning.
- Inside elements the same parser demotes a late attribute to text with a warning (0.9).
- 0.10.0 K14 turned that into accept + warn.
- Joseph's 07-29 phrasing was "before normal children"; the Dec-2025 analysis said "attributes must precede children".

The neutral sub-question lists "only before the first child" and "anywhere, with a warning". The history adds that "anywhere, silently" is what the code does.

**9. Concatenation and the "store" role.** With an implied root and B, concatenating two files that both begin with top-level attributes stacks both files' metadata onto one root (`:title A` … `:title B`). Joseph's 08-07 "partial vs whole-record vs store of records … just depends on what you decide to do with that root element" and the multi-record role (b) both depend on this. The neutral file treats a document as a single file.

**10. Other rules that are silent about the root.** Once the root is settled, the same "is the root an element?" question applies to more than text and attributes (the 07-28 "root-silent class"):

- the comment-continuation base at the top level;
- where a fence may close at the top level;
- which owner a line with a tab in its indentation belongs to at the top level (0.10.0 §2: "text of the current column owner");
- CORE's separate `Document root | Line comment` row for `;` (file 03).
