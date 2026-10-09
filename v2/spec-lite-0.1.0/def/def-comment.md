---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: true
terms: [comment, comment-block, framed-comment, inline-comment]
per: []
depends: [def:text, def:embed, def:body, rule:comment-blocks, rule:comment-block-owns-deeper-lines, rule:framed-comments, rule:framed-comment-owns-deeper-lines, rule:inline-comments, rule:fence-line-comments, rule:comments-in-tree]
consequences: [def:node]
---

# comment · comment-block · framed-comment · inline-comment

*A «comment» is text written for the document's maintainers that lite carries in the «tree» and never interprets. Lite has three spellings of one: a `;` line with its deeper lines (a «comment-block»), a ` ; ` with a space on each side after structure on a line (a «framed-comment»), and `;{…}` inside a «text» (an «inline-comment»).*

## Terms

- **comment:** text that lite carries in the «tree» and never interprets as UDON. The general word for all three spellings below.
- **comment-block:** a line whose first non-space character is `;`, together with every following line indented deeper than that `;` ([[rule:comment-blocks]], [[rule:comment-block-owns-deeper-lines]]).
- **framed-comment:** on a line that begins with an element or an attribute, a `;` with at least one space on each side, running to the end of the line ([[rule:framed-comments]]); also after a fence's opening or closing backticks ([[rule:fence-line-comments]]). Lines deeper than its `;` belong to it, with a «warning» (a lean, [[rule:framed-comment-owns-deeper-lines]]).
- **inline-comment:** `;{…}` inside a «text», an «embed» of it ([[rule:inline-comments]], [[def:text]]).

## Invariants

- Every «comment» is in the «tree» ([[rule:comments-in-tree]]). A «comment-block» and a «framed-comment» are nodes; an «inline-comment» is a «piece» of a «text».
- A «comment»'s content is never scanned for structure: an element, attribute or fence written inside one is comment text.
- A `;` in the middle of a prose line is text, framed or not ([[rule:framed-comments]]).

## Examples

```udon
|config
  ; the old settings
    :timeout 30
  :timeout 60 ; seconds
  |p
    Keep calm ; carry on.
    Text ;{todo} here.
```

- Lines 2–3 are one «comment-block»: its text is `" the old settings\n:timeout 30"`.
- `; seconds` on line 4 is a «framed-comment».
- Line 6 is text. A ` ; ` in prose is not a comment.
- `;{todo}` on line 7 is an «inline-comment», a «piece» of the text.

## Avoid

Earlier names and confusions, so a later reader recognizes them. "Joseph" marks his own words; everything else is an agent's or a spec draft's.

**For «comment» as a whole:**
- **annotation** — 0.10.1 draft (2026-08-27) renamed comment to annotation ("comment | **annotation** (rename; behavior unchanged; opacity principled)", `v2/spec-0.10.01/GLOSSARY.md`); Joseph called 0.10.1 "a misfire" (2026-09-01). It also collides with 0.10.0 §12.5's "annotation convention" (`|{note …}`, an element) and with type annotations.
- **comment-text** as a separate thing from the comment — Joseph, 2026-07-15, "everything is comment-text until there's something new at head-position" (`~/.claude/history.jsonl` L16323): his phrase for the comment's content, not a second construct.
- **stripped / discarded** — Dec 2025 `SPEC.md` "Comments are stripped by the parser"; replaced by "carried" (Joseph 2025-12-28: "we will be outputing events and comment text instead of discarding it") and in lite by "in the tree".
- **`#` comment, `#|` comment, `|# … #|`** — 2011 spellings (`~/src/_older/udon`).

**For «comment-block»:**
- **block comment** — Joseph, 2025-12-25: "; block comment (i.e., any time a line starts with this. **TRIGGERS INDENT/DEDENT BEHAVIOR** even though it is effectively blank output" (`history.jsonl` L5702); 2026-07-15: "I can't find any compelling reason to essentially neuter block-comments either" (L16323); 0.9 CORE heading "Block Comments". Collides with C-family usage, where a block comment is the delimited `/* … */`.
- **line comment** — 0.10.0 §8 calls both the `;` line and the framed ` ; ` "line comment"; C-family "line comment" means `//` to end of line. Using it for the `;` line hides that the construct owns deeper lines.
- **comment continuation / continuation lines** — 0.10.0 §8 "Continuation", the Jan 2026 parser; names the deeper lines only.
- **comment line** — loose drafter usage for the `;` line alone.

**For «framed-comment»:**
- **sameline comment** — Joseph's own ratified name, 2026-07-15: "we can call it its own specific lexical thing--- "sameline comments" which are allowed to be after prose and are conditioned on a space before and a space after the ';'" (L16319); also 2025-12-31 (L6428). Still a live candidate, not an Avoid, unless another wins (see Working notes).
- **sameline trailing comment** — Joseph, 2026-07-19 (L16862).
- **child comment** — Joseph, 2025-12-31: "it is a child comment of the last element" (L6429); on 2026-10-09 he used "child comments" for the *deeper lines* under a framed `;`, a different thing.
- **line comment** — 0.10.0 §8 (see above).
- **comment to EOL / line-ending comment** — 2011 (`overview.udon`; `DECIDED.md`).
- **inline comment** in the PEP 8 sense ("An inline comment is a comment on the same line as a statement") — the meaning a Python reader brings. In lite, "inline comment" is `;{…}`.
- **framed ` ; ` in block text is a comment** — 0.10.0 §2.2/§8 ("In block text **at** the content base | line comment"). The rule drifted in during the 2026-08-09 rewrite and lite removed it (`.int/history-semicolon-in-text-2026-10-08.md`). Prose ` ; ` is text.

**For «inline-comment»:**
- **embedded comment** — 2011 (`<(# datadata #)>`, "Embedded comment"); Joseph, 2026-10-08: "saying newlines in embedded comments are simply reserved with error" (STEWARD-VERBATIM). A live candidate, not only an Avoid.
- **comment embed, emb-comment** — Joseph, 2026-07-19: ";{} is a no-op empty comment embed" (L16906); "[emb-comment ""]" (L16907, an event sketch).
- **inline comment contributes no text / is stripped from the value** — 0.10.0 §7.3 ("inline comment; contributes no text") and MODEL; lite keeps it as a piece (`:n ;{}` is "a text AST node with an empty comment as its only inner part", Joseph 2026-10-09).

## Working notes

- **Not reviewed with Joseph.** Joseph, 2026-10-09: "I haven't looked at any or been asked about any of those things … but the idea that they can just kind of organically be whatever would cause serious trouble really soon if allowed to continue." Every term here is provisional until he rules on it; `.int/lexicon-inventory-2026-10-09.md` lists where each came from.
- **"Avoid" is a new section name.** Joseph asked for it on 2026-10-09; [[sop/conv:record-cadence]] lists Discussion, Sources, Cautions and Regression guards as the optional sections and doesn't name it yet.

### comment

- **Settled in practice?** Joseph has said "comment" throughout (2025-12 to 2026-10). The one rename was 0.10.1's "annotation", in a draft he called a misfire. Nothing found of his preferring another word.
- **Precedents.** Universal. Lite's comments being tree nodes matches XML/DOM, where a comment is a node (DOM `Comment`, XPath `comment()`); YAML and TOML drop comments from the data, and Roslyn, SwiftSyntax and rust-analyzer carry them as "trivia" attached to tokens. A reader from YAML or JSON may assume comments vanish; lite's Invariant says otherwise.
- **Joseph on the tree:** "in practice comments are only ever leaf nodes" (2026-01-14, L7873); "Don't forget comments show up in the AST" (2026-10-09). His 2026-01-14 hesitation, "I'm not sure if we make comments first-order nodes or haec them part of the metadata? Or maybe a node if it's a block-level comment? (but that breaks our block-level = inline symmetry)" (L7871), is the question lite answered by making `;{…}` a piece and the other two nodes.

### comment-block (the `;` line and its deeper lines)

- **Joseph's words, both orders.** "block comment" (2025-12-25, L5702; 2026-07-15, L16323) and "comment block" (2026-01-02: "starts a comment block", L6837; "the semantics of the comment block are just like the other block types (|!) except a lot less to do inside it (no inner children, no attributes, no "sameline" behavior, etc. etc.)", L6808). On 2026-10-08: "available as their own block, which also comments everything in that block that is indented further as per the usual with blocks and the indentation." *Reading (mine):* he uses "block" in UDON's indentation sense in both orders, and doesn't seem to distinguish them.
- **What each order invites.**
  - "block comment": for a C, Java, JS, CSS, SQL or Lua reader, a delimited comment (`/* … */`, `--[[ … ]]`) that can sit mid-line and needs a closer. An agent reading "block comment" without highlighting may look for a closing token. In lite the delimited comment is `;{…}`, and it can't span lines.
  - "comment block": reads as "a block, in UDON's sense, that is a comment", parallel to "text block" and to Joseph's "their own block". Its risk is that it names the whole (line plus deeper lines) and leaves no name for the `;` line itself.
- **Precedents for the indentation sense.** PEP 8 "Block Comments": "Block comments generally apply to some (or all) code that follows them, and are indented to the same level as that code" (a paragraph of `#` lines, not owning deeper lines). Pug "Block Comments": `//` with an indented block under it, all commented. Haml: "You can also nest text beneath a silent comment" (`-#`). Joseph cited this family himself: "One nice thing in similar dialects like less or haml or something was that you could comment a whole block of things with a semicolon or equivalent at just the right indent" (2026-07-15, L16322).
- **Questions.**
  - Does the term name the region (line plus deeper lines) or the node? The tree has one node with text `" a note\nstill the note"`, so a single word can do both.
  - Is the `;` line's own text "the comment's first line" and the deeper lines its «body»? See [[def:body]] on whether "body" should cover these lines.
  - A line starting with `;{`: is it a «comment-block» (whose text starts `{`) or a text line starting with an «inline-comment»? 0.10.1 audit C6 found 0.10.0's table made it a line comment that "swallows the whole line (and deeper lines)". [[rule:comment-blocks]] says "first non-space character is `;`", which reads as comment-block. Not discussed with Joseph; it is a rule question with a naming consequence.
- **Other candidates seen:** "standalone comment", "own-line comment" (ESLint's `line-comment-position` says "above" vs "beside"), "full-line comment".
- **My lean (this agent's, not Joseph's):** «comment-block» for the construct, because lite already uses "block" for indentation-owned regions and Joseph's 2026-10-08 wording is "their own block". I'd keep "block comment" off the list, because C-family readers hear "delimited".

### framed-comment (the ` ; ` after structure)

- **Three axes are being named at once:** where it may sit (after structure on an element or attribute line, or on a fence line), its lexical condition (a space on each side), and what it does (runs to the end of the line, and may own deeper lines).
  - "sameline comment" names the position. It is Joseph's ratified name (L16319), and "sameline" is now one of lite's ruled words.
  - "framed comment" names the lexical condition. "Framed" is an agent's word: Joseph asked on 2026-08-28, "when you say "framed" you mean at least one space on either side of the thing that is framed, right?" (L20555), and adopted it for the backslash on 2026-10-09: "wrt " \ " spaces around it as frame-- I support that."
  - "trailing comment" names what it does (Joseph's "sameline trailing comment", L16862; ESLint and most style guides).
- **Where "sameline" may not fit.** [[rule:fence-line-comments]] allows ` ; ` after a fence opener's word and after a closer's backticks. A fence opening at the start of its own line (```` ```sh ; note ````), or a closing line, is not an element or attribute line. Is a fence line a "sameline" in Joseph's sense ("node or attribute started lines", 2026-10-08)? If not, "sameline comment" doesn't cover fence-line comments and "framed" or "trailing" would.
- **"Framed" is shared.** Lite also has the framed ` \ ` that ends a text ([[rule:framed-backslash-frame]]). One adjective for the shared lexical condition is a feature if it stays an adjective ("a framed `;`", "a framed `\`") and not a noun.
- **Where the old name broke.** The history in `.int/pre-design/03-semicolon-in-prose.discussion.md` (entries 15, 23 and 30) shows the 07-15 ratification named a *position* ("sameline comments … allowed to be after prose"), while the sentence carried into CORE named only the *frame*. That position-free sentence is how ` ; ` drifted into block prose in 0.10.0. *Reading (the history agent's, which I share):* a name that carries the position guards against that drift better than one that carries only the frame.
- **The deeper-lines lean.** Joseph, 2026-10-09: "my lean for the sameline inner comment column with children that are indented more than the ';' column: correct-- child comments (and rare, and *warn*)". Here he says "sameline inner comment" for the comment, and "child comments" or "children" for the deeper lines. *Reading:* "inner" probably means "within the line", not "inner comment" as a term; flagged as ambiguous.
- **Precedents.** PEP 8 "inline comment" means this construct (collision with lite's `;{…}`). YAML and the shell require a space before `#` only. Joseph's own instinct on 2026-07-15: "I kind of want to force a space on both sides, but I can't think of other languages or formats that force that" (pre-design 03, entry 18). MySQL's `--` needs a space after it.
- **My lean (this agent's):** "sameline comment" if fence lines count as sameline lines (which keeps Joseph's ratified name and puts the position in the name), otherwise "trailing comment", with "framed" kept as an adjective for the condition. I'd avoid "inline" for this one.

### inline-comment (`;{…}`)

- **Joseph's words.** "inline comment" consistently from 2025-12-25 ("`;{...}`  inline comment -- the only way to do udon-level comments within prose", L5702) to 2026-01-02 (L6837). Then "comment embed" (2026-07-19) and "embedded comments" (2026-10-08). *Reading:* his word moved toward "embed" as the brace forms came to be thought of as one family ("brace-form are embeds", 2026-07-19, L16906). Lite's [[def:embed]] now names that family «embed».
- **Coupled with the other embeds.** `|{…}` is "inline element" (0.10.0 retired "embedded element" for it), `@{…}` is "reference", `;{…}` is "inline comment". If the embed family's naming is settled ([[def:embed]]), this term probably follows it: "inline comment" alongside "inline element", or "comment embed" alongside «embed».
- **Collision.** PEP 8's "inline comment" is a trailing comment on a statement's line. A Python reader seeing "inline comment" will picture `|el :a 1 ; note`, not `;{…}`.
- **Precedent for the brace form.** Raku's delimited comments, headed "Multi-line / embedded comments", start with `#` and a backtick and close at the matching bracket. They nest brackets as `;{…}` does, and can sit mid-line. Common Lisp `#| … |#` and Lua `--[[ … ]]` are delimited "block comments".
- **My lean (this agent's):** keep "inline comment" (his longest-standing use, and it pairs with "inline element"), and add a Caution about the PEP 8 meaning. If the family is renamed around «embed», "comment embed" would be my second choice.

### Coordinator's lean (Opus 5.5, 2026-10-09; my opinion for Joseph, not a lean of his)

- «comment» as the general word; **«comment-block»** for the `;` line with its deeper lines (his "their own block"; "block comment" sounds delimited to C-family readers).
- **For the trailing ` ; `: "sameline comment"**, his own ratified name (2025-12-31, 2026-07-15), which carries the position and so guards against the drift that put ` ; ` into prose in 0.10.0. "Framed" stays the adjective for its spaces. A comment after a fence's backticks is named by its place ("a comment after a fence's backticks"), not by stretching "sameline".
- **«inline-comment»** for `;{…}`, pairing with "inline element"; both are «embed»s.
- **A line starting `;{`** is a rule question for him, not a naming one: comment block, or a text line opening with an inline comment? I lean the second, since `;{` is an embed opener everywhere else, but it ties to item 12's "space after `;`".
