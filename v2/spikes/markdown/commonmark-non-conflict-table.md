# The CommonMark non-conflict table — measured

**What this is:** a first-pass measurement report. The seed
([`thoughts-on-scope.md`](thoughts-on-scope.md) §3) asserted a "decided" column
for markdown/UDON glyph clashes and asked for it to be measured. This runs the
measurement and reports what came back, including two places where the
measurement and CORE's prose disagree. It rules nothing.

**Spine:** *what UDON's recognizer does to markdown text — measured, not
claimed* — plus the two places that measurement and the spec text disagree.
Everything below hangs off that; background, confirmations, and instrument
caveats are in the appendices.

**Run:** 2026-07-28 · CommonMark spec 0.31.2 (`spec.txt`, all **652** embedded
examples, no sampling) · reference parser at `core/` HEAD. Scripts and raw
per-case output: [`probes/`](probes/).

---

## Bottom line

1. **No CommonMark construct in the corpus triggers any UDON structure except
   the fence.** Across 652 examples, in both framings, the recognizer emitted
   zero elements, attributes, comments, directives, references, or inline forms.
   The `|`/`:`/`!`/`;`/`@` guards held throughout.
2. **Byte-exact survival: 76.2% at document root, 86.7% embedded in a UDON
   element.** The embedded number is the one describing the real A1/A3 surface
   (markdown prose living in a UDON document).
3. **The non-fence residue is three mechanisms:** indentation absorbed as
   geometry, line-initial `\`, and tabs — sizes in §1.
4. **Five glyph clashes are missing from the seed's §3 table**, four of them at
   line start (§2). Four are CORE-decided; the fifth is a parser lag on a
   ledgered DELTAS row. The pipe-space "preserves markdown tables" claim wants
   narrowing: it covers `| a | b |`, not `|a|b|`.
5. **Two divergences found** between the parser and CORE's prose (§3), reported
   as three-way facts. One — the framed ` ; ` — decides whether markdown prose
   containing " ; " is safe or silently truncated, so it is consequential rather
   than pedantic.

**What this does not establish**, stated here rather than at the end:

- It measures **recognition only**, not rendering. Which markdown subset
  renderers honor is untouched (CARVEOUTS **MD**/S16 stays open).
- **The corpus has no GFM** — no tables, mentions, task lists, or strikethrough.
  Three of the five findings in §2 had to be probed by hand, and are therefore
  *sampled by my judgment of what is common*, not corpus-derived. A GFM corpus
  run would put them on the same footing as the rest.
- The parser is **0.9.0-alpha.2, not 0.9.1** (Appendix C). It is an instrument,
  not an oracle.
- Neither divergence in §3 is resolved here. Both are steward calls, and I do
  not have a view on which way either should go.

---

## 1. The numbers

Each example was run in two framings, because the framing changed the answer
enough to become a finding in itself (§3.1):

- **ROOT** — the example as a whole document, as `spec.txt` writes it.
- **EMBEDDED** — the example as markdown prose *inside* a UDON element
  (`|doc` + two-space indent).

| Outcome | ROOT | EMBEDDED | Register |
|---|---|---|---|
| Byte-exact prose — every byte reconstructs as text, no UDON structure recognized | **497** (76.2%) | **565** (86.7%) | — |
| Indentation absorbed as geometry (content base / re-base) | 107 (16.4%) | 49 (7.5%) | LAW §7.2 (embedded) / **DIVERGENCE** (root — §3.1) |
| Markdown ``` fence recognized as a UDON fence | 32 (4.9%) | 27 (4.1%) | LAW §10.3 — [fence-knot table](fence-knot-table.md) |
| Line-initial `\` consumed by UDON's escape | 11 (1.7%) | 11 (1.7%) | LAW §4 — absent from the seed's table |
| Tab in indentation | 5 (0.8%) | 0 | **DELTAS row 1** — alpha.2 drops the line; 0.9.1 keeps it |

Register keys (LAW / PINS CURRENT PARSER / OPEN / DIVERGENCE / INFERRED) are in
**Appendix A**.

Two readings of the same data, kept apart on purpose:

- **Measured:** markdown's *inline* vocabulary is inert to UDON recognition
  throughout this corpus; its *block* vocabulary is inert except for fenced code
  blocks, indentation, and line-initial backslash.
- **Inferred, not measured:** that this generalizes to markdown in the wild. The
  corpus is a *conformance* corpus — it over-samples edge cases, under-samples
  ordinary prose, and omits GFM. Which way that bias cuts here, I don't know.

---

## 2. Clashes the seed's §3 table does not have

The section with new information in it. All five were found by direct probe
(`probes/out/glyph-cases.frame`), since GFM is absent from the corpus.

| # | Construct | What UDON does | Register |
|---|---|---|---|
| **N1** | **Line-initial `\`** — markdown's own escape (`\*not em*`, `\## foo`, `\[foo]`) | Consumed at Structure Position; the rest of the line is forced prose, and markdown loses one backslash. 11 of 652 corpus examples — the most frequent non-fence interaction measured. Mid-line `\` is untouched (`1\. not a list`, `\A\a` survive). | **LAW §4** |
| **N2** | **Tight GFM table** `\|a\|b\|` | `\|a` passes the element guard → element named `a`. It fails *partially*: the delimiter row `\|-\|-\|` and data row `\|1\|2\|` survive as text (`-` and digits fail the guard), so only the header row becomes structure. Probes `g02`, `g03`, `h07`. | **LAW §3** — narrows the seed's pipe-space row |
| **N3** | **Line-initial `@`** — GFM mention, or a bare domain | `@alice`, `@example.com` → Reference; the token leaves the text stream. Mid-prose `@alice` is safe (`g05`), as is `- @alice` (`g29`). Probes `g04`, `h06`. | **LAW §3, §12.2** |
| **N4** | **Line-initial `!word`** — `!important`, and anything `!`+identifier | Opens a directive (`g22`). `![`, `!=`, `!(` are safe by the guard; `!!!` python-markdown admonitions safe (`h02`); `:::` Docusaurus admonitions safe (`h01`). | **LAW §3, §9** |
| **N5** | **Line-initial `:key value`** | 0.9.1: Warning, kept as document-level text including the `:`. alpha.2 instead drops the line from the text stream (`g10`). YAML-style `title: Test` in `---` frontmatter is safe (no leading colon, `g25`); Pandoc definition lists (`: definition`) are safe — `:` + space is not a key (`g09`). | **DELTAS row 2** — measured behavior is superseded |

**Not a glyph, and larger by case count than any of the above: indentation.**
Markdown gives leading whitespace semantics (4-space code blocks, list
continuation columns); UDON treats it as geometry. 107 root / 49 embedded cases
turn on it. The seed's table is glyph-shaped and has no row for whitespace; on
this evidence it wants one.

**One row that did not fire, and would matter if it did:** the framed sameline
comment ` ; `. CORE §8 says a framed ` ; ` in block text at the content base
opens a line comment — which would eat the tail of any markdown prose line
containing " ; " (routine in French typography, and when prose quotes code). The
parser does not do this outside an element's sameline tail. That disagreement is
§3.2, and it decides whether ` ; ` belongs in the collision table at all.

---

## 3. Divergences — three-way facts, no verdict

Per the house rule: what CORE says, what the parser does, what is open. Which
resolution applies (backport / fix / evolve) is a steward call.

### 3.1 Document-root text has no content base

**CORE says.** §7.2 r2–r3: the first indented text line establishes the content
base; later lines at ≥ the base strip base-many leading spaces, and *"extra
indentation beyond the base is preserved as text."* r4: a shallower line warns
(`InconsistentIndentation`) and re-bases. §14.2: *"Silent drop of author-visible
material is non-conformant."*

**The parser does.** Inside an element, exactly that — base honored, extra
indent preserved, re-base warning fires. At document root, all leading
whitespace on every line is discarded as geometry, with no anomaly:

```text
"alpha\n  beta\n"           -> Text "alpha\n"  Text "beta\n"      (root: 2 spaces gone, silently)
"|sec\n  alpha\n    beta\n" -> Text "alpha\n"  Text "  beta\n"    (element: 2 extra spaces kept)
```

Whitespace-only lines behave alike: `"a\n  \nb\n"` at root yields `Text "\n"`,
while the same shape inside an element preserves the spaces — and CORE §7.4 says
whitespace protruding past the base *is* prose content.

**What is open.** CORE §7.2 is written entirely in terms of *"the element"* and
*"the parent"*. It never states the content base for text owned by the
**document**. So this is not purely an implementation question — the spec text
has a gap at document root, and the parser filled it one way, silently. I don't
know which of the three resolutions is right and am not guessing.

**Why it matters for markdown.** It accounts for the 107→49 drop between
framings, and causes 5 of the fence recognitions: `cm263`, `cm278`, `cm318`,
`cm321`, `cm324` are markdown fences indented inside list items. At root, with
no base, the indented ` ``` ` sits at a structural column and opens a fence;
embedded, it is deeper than the base and is correctly literal (CORE §10.3). One
root cause, two symptoms. Practical statement: *markdown parsed as a bare UDON
document at root loses its indentation structure; the same markdown nested
inside any UDON element keeps it.*

### 3.2 The framed sameline comment in block text

**CORE says.** §8's position table: *"In block text **at** the content base →
line comment"*; *"In block text deeper than the base → literal"*. §2.2: after
prose commits, markers are literal *"with exactly **one** exception — the
whitespace-framed sameline comment ` ; `"*.

**The parser does.** Opens a comment only on an element-rooted sameline tail:

```text
"|li Item one ; TODO expand\n"   -> Text "Item one " CommentStart Text " TODO expand" CommentEnd
"|sec\n  Some prose ; a note\n"  -> Text "Some prose ; a note\n"      (literal)
"Some prose ; a note\n"          -> Text "Some prose ; a note\n"      (literal)
```

**What is open.** Nothing — `;` is not in CARVEOUTS. §8's "at the content base"
row and the parser disagree flatly.

**Why it matters.** The measured behavior is the markdown-friendly one; the
written law is the hazardous one. If CORE is right, ` ; ` is a first-class row
in the collision table and the non-conflict guarantee has a real hole. If the
parser is right, §8's row wants narrowing to the sameline-tail position. Both
are internally coherent readings, which is why this wants a ruling rather than a
guess from me.

---

## 4. What this licenses

- **Does** support upgrading the seed's rows for `![`, `#`/`<`, emphasis and
  inline constructs from *decided-by-assertion* to *decided-and-measured*
  (row-by-row confirmations in Appendix B).
- **Does** narrow the pipe-space claim to the space-separated form.
- **Does not** settle the markdown subset question, the fence policy question,
  or either divergence.

---

## Appendix A — register keys

The load-bearing convention (suite rule **S2**, CORE §13.2's caution). Five
kinds of fact live in these tables and are not interchangeable:

| Register | Means |
|---|---|
| **LAW** | a rule in `current-0.9.1-spec/CORE.md`, cited by section. An implementation that disagrees is wrong or lagging. |
| **PINS CURRENT PARSER** | what *this build* does, in territory the spec does not fix. Descriptive only; never cite as language behavior. |
| **OPEN** | a `CARVEOUTS.md` item — deliberately unspecified, with a reason. Openness is design intent, not defect. |
| **DIVERGENCE** | parser and CORE prose demonstrably disagree. Three-way facts; resolution is a steward ruling. |
| **INFERRED** | my reasoning from the measurements, not itself measured. Used in §1's second bullet and in the fence table's forward-looking suggestions. |

## Appendix B — the seed's existing §3 rows, confirmed

Confirmatory detail; nothing new. This is the evidence behind bottom-line item 1.

| Glyph / construct | Seed said | Measured | Register |
|---|---|---|---|
| `\| a \| b \|` pipe-space tables | *decided* — always literal | Holds for the spaced form (`g01`). **Not corpus-tested** — CommonMark has no tables; probed directly instead. Tight form breaks (§2 N2). | LAW §3 (`\| ` fails the guard) |
| `![img](x.png)` | *decided* — text | Holds. All Images examples (`cm581`–`cm600`) byte-exact; probes `g23`, `h04`. | LAW §3 |
| `#`, `<` in prose | *decided* — inert | Holds. ATX-heading and HTML-block examples inert to UDON structure (deltas are indentation only). Autolinks `g17`, inline HTML `g18`, MDX components `h14` verbatim. | LAW §7.1 |
| `**bold**`, `` `code` ``, `*em*` | *decided* — opaque | Holds. Every Emphasis and Code-spans example byte-exact. | LAW §7.1 |
| ` ``` ` fences | *open* | Recognized as UDON fences — 32 root / 27 embedded. Mechanics: [fence-knot table](fence-knot-table.md). | LAW §10.3 |
| `---` | *open* | Inert as text (`g16`, `g25`, `cm43`–`cm62`). A `---` frontmatter delimiter is *available* because UDON attaches no meaning to it — which is what makes B1 possible. | LAW (no rule claims it) / OPEN PRAGMA |
| `[text](url)`, `[[wikilink]]` | *open* | Inert as text (all Links examples byte-exact but for the two with line-initial `\`; `g21` verbatim). | LAW §7.1 |
| `-`, `1.` list markers | *open* | Benign as glyphs (`g20`, `g28` verbatim). List *indentation* is the real interaction (§2). | LAW §7.1 |

## Appendix C — instrument caveats

- **The parser implements 0.9.0-alpha.2, not 0.9.1.** The eleven ledgered
  differences are in [`DELTAS.md`](../../current-0.9.1-spec/DELTAS.md); rows 1
  (tab-in-indent) and 2 (root `:key`) are hit here and flagged inline. Where a
  measured row sits on a DELTAS row, **0.9.1 is the authority and the
  measurement is of the older behavior.**
- The text-law check (`concat(Text, BlankLine) == input`, no structure events)
  follows CORE §15.10 / MODEL §6, which is what makes "survived verbatim" a
  mechanical question rather than a judgment call.
- `BlankLine` carries empty bytes but denotes `"\n"`. An early version of this
  instrument summed its literal bytes and produced a false text-law defect
  across ~170 cases; corrected before any table was written. Recorded so it is
  not rediscovered as a finding.
- Comment bodies are emitted as `Text`, so text-preservation alone does not
  separate prose from comment content; the structure check does, and runs first.
- Verbatim bodies arrive as `RawContent`, excluded from the text total by
  design — a block-verbatim case shows a large delta while losing nothing.
- `analyze.py` does not re-implement CORE §7.2 as a scoring oracle, on purpose:
  an elaborate oracle would quietly make the script the spec. Cases are labeled
  by observable mechanism; register is assigned in prose, with cites.

**Reproduce:** [`probes/README.md`](probes/README.md) — one `curl`, one
`cargo build`, three commands.
