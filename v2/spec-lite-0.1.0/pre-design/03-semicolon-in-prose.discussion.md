# 03 — ` ; ` inside a paragraph: history

**Written by:** Claude (Opus 5.5), history agent for question 03, on 2026-09-29. I didn't see anyone's lean before writing this, and the file has no lean or recommendation section. That comes later.

**Method.**
- I read the neutral file, `pre-design/README.md` and `spec-lite-0.1.0/README.md` first.
- I traced the question through:
  - memorata;
  - git history (`git log -S` on the rule's wording across the umbrella repo);
  - the 2011 originals, which are at `~/src/_older/udon` and `~/src/_older/udon-c` (not `~/src/_ref/`);
  - mainline `spec/CORE.md` and its CHANGELOG;
  - `core/fixtures` and the grammar;
  - the v2 spec suites, `theory/`, `.archived/`, `msc/`, OPEN and DECISIONS;
  - one in-repo session extract (`v2/.archived/second-pass/spikes/session-vault/raw/claude/18aabafc-…md`). This is a markdown export of User/Assistant turns with tool calls stubbed out, and it contains no model thinking.
- I didn't open any raw `.jsonl` session transcripts, and nothing was blocked.

**Where the indentation in quotes comes from.** memorata drops leading whitespace and newlines from the text it returns. So every UDON-bearing quote of Joseph's below was re-read from his prompt logs, which hold only his own typed prompts (no model content):
- `~/.claude/history.jsonl` (by line number);
- `~/.codex/history.jsonl` line 1026.

The indentation shown for his quotes is the original. Quotes from repo files come from the files themselves.

**memorata searches run.** Unless noted, the classes were `human-user agent-to-human document subagent-final-response`, with `--pool 400 -n 150`. Results were de-duplicated and sorted by date.
- "semicolon comment in prose"
- "; comment mid-line in block prose literal"
- "framed semicolon sameline comment"
- "sameline comment whitespace-framed lexeme"
- "SEMI-BASE framed ; at the content base"
- "semicolon in markdown prose silently truncated comment"
- "commit to prose markers literal except comment"
- "block prose semicolons literal"
- "line comment continuation indentation"
- ";{ inline comment only way to comment within prose"
- "this is also prose ; but this is not a comment"
- `--joseph` with dates 2025-12-20 → 2026-01-10:
  - "document root should have no special meaning; comment at root vs inside element"
  - "mid-line semicolon literal root_only tests"
- `--joseph` from 2026-07-01:
  - "comments after prose sameline special convention enforcing ' ; '"
  - "comment deeper than the prose base literal head position"
  - "semicolon comment prose markdown"
  - "framed ; comment"
- `--joseph` from 2026-07-25:
  - "comment semicolon" (**0 results**)
  - "annotation ; comment text"
- Agent and document classes:
  - "markdown prose semicolon hazard truncated" (from 2026-07-25)
  - "positional certificate carve-out framed ; live control sequence"
- `--joseph`, no date limit:
  - "semicolon"
  - "trailing comment ; TODO"
  - "comments in udon"
  - "prose line comment"
- Two `agent-to-human` searches for the reply to Joseph's 2026-07-19 question (entry 22).

**Things I looked for and didn't find, with where I looked:**
- **No Joseph statement after 2026-07-28 about a mid-line ` ; ` in block text.** I checked the `--joseph` searches above from 07-25 on, plus the Aug 8–9 and Aug 27 materials in the repo.
- **No needs-corpus item about wanting comments inside paragraphs.** I grepped `v2/udon-needs/` for "semicolon", " ; comment", "trailing comment", and "comment" near "prose".
- **No record of the answer to Joseph's 2026-07-19 question.** It isn't in the session-vault extracts or in memorata's agent replies for that day.

---

## History (chronological)

### 1. 2011-08-15 — the first comment table (`#` was the comment character then)

**Source:** `~/src/_older/udon/examples/overview.udon:75-88`. Joseph wrote this (git blame 1b57c3a, 2011-08-15, "Another try at consolidating what I know").

```
|==Line-oriented
                           #      | embedded | child lines | metachars | embeds | prsv.ws | comments |
  datadata...              # Data | --       | Yes         | --        | Yes    | a-indent| Yes      |
  ...
  |# datadata              # Block comment - (children lines are parsed / udon markup ?)
  # datadata               # Also block comment if beginning text of the line
  ...  # datadata          # Comment to EOL (only available in identity section, single space after required
```

The same file (lines 192–196) also has a CSS-flavored example with a *different* mid-line form, `#|`, after attribute values: `background-color: #27470e            #| the darker colors help create the effect`.

**Bears on 03.** The earliest record already has the shape "a comment starting at the beginning of a line works everywhere, but an end-of-line comment only works on the element's own line (the 'identity section')". It already asks for a space before the comment marker, too.

**Incidental.** Nothing here decides the question: the character is `#`, and what the `comments | Yes` column means for plain data lines is unclear.

### 2. 2011-12 → 2012-01 — the C parser as built

**Source:** `~/src/_older/udon-c/lib/templates/udon.machine`. It is the state-machine source for `lib/udon.c`; repo commits run from 2011-12-07 to 2012-01-21.
- `|function[data:STRING]` reads a child text line up to the newline and never checks for `#`.
- `#` is recognized only in two places:
  - at the start of a child line: `|c[#] |.bcomment | -> | /block_comment`;
  - inside `|function[value:STRING]`, which reads attribute and inline values.

**Bears on 03.** What was built: a `#` in the middle of a text line was literal. This is evidence of what was implemented, not of intent.

### 3. 2011-12-15 — Joseph names the exact question and leaves it

**Source:** `~/src/_older/udon-c/docs/DECIDED.md:173-182`. Joseph wrote lines 176–182 (git blame ecfaa4a, 2011-12-15).

```
 #{...}              # Embedded comment. You know you love it. But would then
                       be impossible to use well w/ Ruby.

 nah, we should do |{#        }

 what about a simplification for line-ending comments though?

 and here is some normal text blah blah    #| comment even though I'm in freetext

 meh... probably opens a can of worms...
```

**Bears on 03.** This is the question itself: an end-of-line comment inside free text. It came with its own marker (`#|`), separate from the line-start comment. It was left undecided, with the note "probably opens a can of worms". The prose comment he did choose was a delimited embedded form (`|{# …}`), which is the ancestor of today's `;{…}`.

### 4. 2025-12-22 — the revival: markdown conflicts, and `;` from Rebol

**Source:** `~/.claude/history.jsonl:5394` (14:28) and `:5404` (16:07). Both are Joseph's.
- 14:28: *"Are comments and possibly tables the only things that would potentially conflict with markdown? (e.g., if the document were primarily markdown but had some udon sections like the frontmatter)"*
- 16:07: *"I'm actually considering more parts of Rebol-- including possibly using the semicolon as a comment-line marker and using (potentially) ' as a prefix to escape literal pipes etc."*

**Bears on 03.** From the first day of the revival, comments were on Joseph's short list of possible markdown conflicts. `;` came in as a *comment-line* marker.

### 5. 2025-12-23 — the first new spec says nothing about prose

**Source:** `SPEC.md` at f5813bd (the umbrella repo's first commit), §Comments.

> Semicolon starts a comment (Rebol/Lisp style): `; This entire line is a comment` / `|element :attr value  ; Inline comment after content` … Comments are stripped by the parser.

**Bears on 03.** Only the line-start form and the after-the-element-line form are shown. Block text isn't mentioned.

### 6. 2025-12-25 — Joseph: `;{…}` is "the only way" to comment inside prose

**Source:** `~/.claude/history.jsonl:5702` (14:03). Joseph, verbatim:

> I would like to make one more change to the spec before we continue.
> ; block comment (i.e., any time a line starts with this. **TRIGGERS INDENT/DEDENT BEHAVIOR** even though it is effectively blank output
> ;{...}  inline comment -- the only way to do udon-level comments within prose.
> (obviously '; something...   is how you would emit the ";" as the first character for that line without interpreting it as a comment, like with the others)

The same afternoon, `SPEC-INDENTS.md` (created 14:22, now `_archive/SPEC-INDENTS.md:523-534`) read: *"`;{...}` is an inline comment - the only way to comment within prose"*. Commit d974fa7 (2025-12-27) added `;{comment}` to SPEC.md: *"For inline comments within prose, use `;{...}`"*.

**Bears on 03.** "The only way to do udon-level comments within prose" excludes a mid-line ` ; ` in prose. In the same message, though, a `;` at the start of *any* line is a block comment, so this is alternative B plus `;{…}`, not alternative C.

**Incidental.** The `'` escape was retired later, and `\` is used today.

### 7. 2025-12-31 08:30 — Joseph: after-prose comments are for the element's line only, "unlike block-level prose"

**Source:** `~/.claude/history.jsonl:6428`, a libudon session. Joseph, verbatim:

> sameline_comment - |asdf and so forth ; and here's a comment although actually I don't known if this is allowed by the spec...
> The truth is, sameline prose is treated a little differently than block prose, even-- sameline prose doesn't set the indent-column position (only the first block-level line of prose does that), so, domain-language-wise and semantically it won't be a problem really to say that sameline prose also allows ';' comments at the end unlike block-level prose.
> Sameline comments should be allowed on attribute+value block lines as well, even though those allow strings with spaces without quoting them...

**Bears on 03.** This is the first explicit statement of alternative B, with a reason: text on the element's own line is already a different kind of thing, because it doesn't set the indent column.

### 8. 2025-12-31 08:54 — SPEC-UPDATE.md turns that into the context table

**Source:** `SPEC-UPDATE.md`, commit 7ac593b, co-authored by Claude Opus 4.5 (now `_archive/SPEC-UPDATE.md`).

| Context | `;` Behavior | Example |
|---|---|---|
| Document root | Line comment | `; file header comment` |
| Block prose | **Literal** (not comment) | `use x; do y` |
| Sameline prose | Line comment | `\|p text ; comment` |

Its "Why Block Prose Differs" section: *"Block prose sets an indent-column and captures literal content including semicolons. This allows code examples, prose with semicolons, etc."* and *"Sameline prose is brief (single line) and commonly followed by comments."*

**Bears on 03.** This is the B rule, now written into the spec.

**Note.** "Document root → line comment" was read by the parser of the time as applying to *mid-line* ` ; ` in root-level text as well. That is alternative A at the root; see entry 11.

### 9. 2025-12-31 ~19:08 — Joseph's worked example: a text line under an element keeps its ` ; `

**Source:** `~/.codex/history.jsonl:1026`, a Codex session. Joseph, verbatim with the original indentation:

```
; This would be a comment
  this is still part of the comment
'; But this is output as text.
\; This could output as text too. I don't like the syntax and probably won't publish it widely, but might as well support it.

|el :key and-this\;-is-ok this is prose ; and this is a comment
  this is also prose ; but this is not a comment

!:c:
  // And obviously semicolons anywhere here are ok...
```

**Bears on 03.** The second `|el` line is an indented text line at the content base with a framed ` ; ` in the middle. Joseph labels it "not a comment", which is B stated as an example. This example later went into the spec (entry 10), was pinned as a fixture (entry 20), and was dropped in the 2026-07 rewrites (entry 23).

**Incidental.** The `'` escape, `\;` inside a value, and comment continuation.

### 10. 2026-01-01 — the consolidated FULL-SPEC keeps the example

**Source:** commit c0025bd, `FULL-SPEC.md:475-476`. It carries the example above verbatim under "Examples", next to the context table.

### 11. 2026-01-02 — Joseph removes the "document root" distinction, so mid-line `;` in prose is literal everywhere

**Context (agents, libudon session, 10:14–11:57).** The Claude Opus 4.5 agent found that the parser treated `Some text ; with comment` as a comment at the root and as literal inside an element. It marked the root case `root_only`, reasoning that *"mid-line `; ` at document root triggers a comment, but inside element prose it's literal"*.

**Source for Joseph's reply:** `~/.claude/history.jsonl:6837` (11:56). Joseph, verbatim with the original indentation:

```
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

**What happened next.** Commit 7003996 (12:08, co-authored by Claude Opus 4.5): *"Removed 'document root' special case for semicolons: Mid-line `;` in prose is now ALWAYS literal (no comment trigger). Only `;` at line start or `;{...}` form creates comments. This makes behavior consistent regardless of nesting depth."* The fixture `text_with_comment` (`"Some text ; with comment\n"` → Comment) became `text_with_semicolon` (→ literal text).

**Bears on 03.** Alternative A *existed* at the root in the December parser. It was removed because of Joseph's principle that the root is no different from anywhere else. His list of comment positions has three entries: line start, the element or attribute line, and `;{…}`. It has no mid-line ` ; ` in block text.

**Indentation note.** In the original, "still part of the same comment." is one column deeper than the `;` line (column 6 under 5). Joseph's 2026-09-29 note (entry 34) says he "got the indentation wrong" here. But what he typed on Jan 2 already shows the continuation line indented. The flattening he saw came from memorata stripping whitespace.

**Incidental.** Whether `;{…}` may split a name (`|ele;{hmmmm}ment`).

### 12. 2026-01-01 → 2026-07-14 — the mainline spec keeps B

**Source:** `spec/CORE.md` (0.8 → 0.9.0-alpha.2).
- The Comments table kept "Block prose | **Literal** (not comment)".
- The "Literal Semicolons" table kept "Block prose | Already literal (`code; more code`)".
- The example became `|el :key and-this;-is-ok now part of the value ; and this is a comment` / `  this is prose of |el ; but this is not a comment`.

These still stand today at `spec/CORE.md:800, 912, 920-926`.

### 13. 2026-07-08 → 07-11 — a nearby hazard: reflow

**Joseph** (`~/.claude/history.jsonl:15385`, 2026-07-08), in part: *"The biggest weakness I see in the editing fragility is similar to Python's but much more pronounced … word-wrapping in particular … frankly the biggest concern there is the difficulty for humans using udon-unaware editors probably..."*

**The estate review** (agent, `_archive/REVIEW-JULY-2026.md` §3.6 and :552-562):
- *"a wrap that lands a sigil-initial token at line start promotes it to structure — … `;-)` became a comment (the wink vanishes from rendered text)"*.
- Measured: *"the `;` guard's motivating idiom is empirically absent (zero `;-)` in the corpus) — decide it on aesthetics."*

**Bears on 03.** This is about a `;` at the *start* of a line in prose, which still comments under alternative B. It is not about a mid-line ` ; `.

### 14. 2026-07-11 — the editor highlighters are built to B

**Source:** `ux/README.md:52-56`. An agent wrote it, to the brief *"as briefed"*.

> `;` context-sensitivity (spec §Comments table): colored as a comment only where the spec makes it one — line-initial (block comment), or whitespace-preceded on a structure line (element/attr/directive sameline context). Semicolons inside block prose are literal and stay plain; `;{...}` is the only comment form recognized inside prose.

### 15. 2026-07-15 (≈12:00) — "sameline comment" is named and ratified

**Source:** session-vault `18aabafc-…md:1928-1973`. The agent is Claude Fable 5; the commit is 74fee71.

**The agent's point.** The agent found that "Head Position" said every marker after the first prose word is literal, while the Comments table allowed `|li Item one ; TODO`. It recommended keeping the idiom, with this reason:

> the safety asymmetry is right: block prose is where semicolon-bearing content lives (code, URLs run to EOL), and it keeps full literality; sameline prose is short and structural-adjacent, where an end-of-line comment is natural and a literal ` ; ` is rare.

**Joseph (vault :1968-1969), verbatim:**

> That sounds right. It quite literally was a practical carve out that we forgot when we added more assertive language about the head-position prose.
> "... with one exception ..." is correct and ratified--  if it is not already stated, we need to be very clear that it needs a white space on either side of it-- we can call it its own specific lexical thing--- "sameline comments" which are allowed to be after prose and are conditioned on a space before and a space after the ';'...  Does that work?

**The commit message:** *"a sameline comment is its own lexical form: a ';' with whitespace on both sides … opens a line comment even after the line has committed to prose"*.

**Bears on 03.** The exception was ratified *as a sameline thing*. But the Head Position sentence that CORE got is worded without saying where: *"A `;` framed by whitespace on both sides … opens a line comment even after the line has committed to prose"*. And "commits to prose" is defined per physical line, for every line. That gap is what the later drift (entries 23 and 30) travels through.

### 16. 2026-07-15 (≈12:16–12:30) — "at the prose base" means a `;` that *starts* a line there

**Source:** vault :2009-2047 and :2101-2135.

**The agent's question.** The example in "Comments and Indentation" showed a comment *one column past* the prose base. The agent recommended treating anything deeper than the base as prose: *"a comment at the base column works (head position re-entry), and `;{…}` annotates anywhere inside prose"*. It also named a data-loss angle: *"a one-space indentation slip on a semicolon-initial prose line … would silently vanish into a comment."*

**Joseph (:2047):** *"I agree. The first example should end up with the three lines as prose."*

**Joseph (:2135)**, in the same half-hour, on how far a comment reaches (verbatim, in part):

> So basically a very simple "everything is comment-text until there's something new at head-position or dedented from it" seems like the clean right call and expectation

**Bears on 03.** This ruling is where the words "at the prose base column" come from. In context they are clearly about a line whose *first* character is `;`, at the base column rather than one column deeper. It is the ancestor of the ambiguous row in later tables. (The continuation ruling is question 78's territory.)

### 17. 2026-07-15 14:45 — the attribute-model note extends B to text-value bodies

**Source:** `design/attribute-model-2026-07.md:181-183`, commit 54c52d2. An agent's design note from the same collaboration.

> Comments: the first line honors the ratified whitespace-framed sameline comment (`:beta just some prose ; comment`); subsequent block lines follow block-prose rules — `;` literal. (Settled-provisional, matches ratified comment semantics exactly.)

### 18. 2026-07-15 15:51 — Joseph: the framed form is for the element or attribute line "*only*"

**The agent's question** (vault :2756-2775): should the both-sides frame also apply after attribute *values*? It cited YAML and POSIX shell (a space *before* `#` only) and MySQL `--` (the odd case that needs a space after). It argued that *"in prose flow, both-sides must stay … because `|p wink ;-)` has space-before and no space-after."*

**Joseph** (vault :2765, then `~/.claude/history.jsonl:16335`), verbatim:

> 1. I don't have strong opinions... I kind of want to force a space on both sides, but I can't think of other languages or formats that force that (can you?) which makes me think the principle of least surprise only requires a preceeding whitespace and maybe warn on no succeeding whitespace or something...

> Comments after prose is already a sameline special convention... it's the one place I wouldn't mind enforcing ' ; ' but *only* if it is sameline (including, now, attribute-sameline) AND prose / text has already started (without quotes)....

**Bears on 03.** This is Joseph's most explicit statement of *where* the framed form lives: on the element or attribute line, and only after text has begun. He also gives a least-surprise lean: other languages ask only for a space before the marker.

### 19. 2026-07-15 23:09 → 07-16 — the fresh-eyes review rewrites the table row

**The finding.** A fresh-eyes review subagent (session be2e5fbd, finding S4) wrote: *"`;` in block prose: the summary tables say 'literal,' the ratified rule says base-column `;` is a comment … only a deeper `;` is literal."*

**The fix** (commit 61158e5, rulings by Joseph on the other findings):
- The CORE table row became *"Block prose | Literal within the prose (deeper than the base); a `;` **at the prose base column** is a comment (see Comments and Indentation)"*.
- Marker Recognition became *"within block prose, comment at the base column, literal deeper"*.

**Bears on 03.** The row now reads "at the base column". It points to "Comments and Indentation", which is about lines that *start* with `;`. The "Literal Semicolons" table and the `this is prose of |el ; but this is not a comment` example stayed next to it.

### 20. 2026-07-16 — a fixture pins B

**Source:** `core/fixtures/v0.9/legacy_mined.yaml:817-824`, commit dd56d34, written by a delegated densification agent.

```yaml
- id: block_prose_framed_semicolon_literal
  desc: a whitespace-framed ' ; ' in BLOCK prose is literal (CORE Literal Semicolons example — the sameline-comment frame is a sameline-prose affordance)
  udon: "|el\n  this is prose of el ; but this is not a comment\n"
```

The expected result is `Text "this is prose of el ; but this is not a comment\n"`.

### 21. 2026-07-19 (≈15:48) — `;{}` described as an embed

**Source:** `~/.claude/history.jsonl` (turn at 2026-07-19T15:48; memorata hash 8a752be705). Joseph, in part: *"brace-form are embeds, and are always meant to be reduced to or surrounded by text / ;{} is a no-op empty comment embed"*.

**Bears on 03.** Only indirectly: `;{…}` is the delimited, text-level comment.

### 22. 2026-07-19 11:10 — Joseph asks whether the frame needs spaces on both sides

**Source:** `~/.claude/history.jsonl:16862`. *"Does the spec currently say a sameline trailing comment needs ' ; ' (with spaces on both sides)?"* I didn't find the reply (see the header).

### 23. 2026-07-19 → 07-22 — clean-room rewrites and 0.9.1: the row loses its context

**The input.** All the clean-room inputs (`v2/.archived/first-pass/greenfield-*/spec/CORE.md`, 2026-07-19) contained the alpha.2 table *and* the example `this is prose of |el ; but this is not a comment`.

**What each rewrite says about ` ; `:**
- **3a (Gemini):** `new-spec/1-GRAMMAR.md:48-63`: *"Sameline Comment: A `;` framed by spaces on both sides (` ; `) after sameline prose opens a comment … Inline Comment: `;{...}` is the only comment form allowed within a text flow"*.
- **3b (Grok):** `new-spec/CORE.md:127, 365`: *"commits the line to prose … except a whitespace-framed sameline comment"* and *"Framed ` ; ` opens a sameline comment on Element and Attribute lines"*.
- **2a (Fable, committed 2026-07-20 as 09fd522):** `new-spec/SPEC.md`. §3.3 is the generalization: *"The first content word **commits** the line to text: from there to end of line every marker character is literal, with exactly one exception — the **framed sameline comment**."* §6.2 says *"A comment `;` **at** the content base is a comment, interleaving with the text; deeper it is literal"*. The §6.4 table adds a separate row, *"In block text at the content base | line comment"*. **This is the first appearance of the exact row wording** (`git log -S` finds it first in 09fd522).
- **Second-pass spine (July 20–21 night, a Grok agent per WHERE-THINGS-STAND):** `second-pass/SPEC.md:396-407`: *"Sameline framed … Allowed after prose commit"*, *"Inline | `;{…}` | Only comment form inside ordinary prose flow / inside `\|{…}`"*, and *"Where `;` is literal: prose deeper than Content Base; unframed sameline prose; …"*. That list doesn't name the mid-line-at-base case either way.

None of the four rewrites carried over the "not a comment" example.

**Then 0.9.1** (commit 84454be, 2026-07-22, Claude Fable 5; now `v2/spec-0.09.01/`):
- It takes 2a's structure: §2.2 *"Committing to prose. The first content word ends Structure Position for that physical line: from there to end of line, marker characters are literal, with exactly **one** exception — the whitespace-framed sameline comment ` ; `"*, and the §8 row *"In block text **at** the content base | line comment"*.
- §6.6:374 also says *"A framed ` ; ` opens a comment on element and block-attribute lines"*.
- The "Literal Semicolons" table and the block-prose example were dropped.
- `DELTAS.md` says *"Everything not listed here is consolidation of existing law … no behavior change"*, and it lists nothing about `;`.
- RATIONALE.md:11: *"at the price of exactly one carve-out — the framed ` ; ` — chosen because trailing annotations (`|li Item ; TODO`) are worth one rule."*
- The primer (`udon-0.9.1-primer.md:80`): *"Exactly one carve-out survives commitment — a whitespace-framed ` ; ` opens a trailing comment."*

**Bears on 03.** Before this point, the texts gave one answer (B), plus one sentence phrased without a position. After it, the texts point both ways:
- §2.2 plus the §8 row read as A;
- §6.6, the row's history, and DELTAS' "no behavior change" read as B.

### 24. 2026-07-28 — measured; SEMI-BASE opened

**Source:** `v2/theory/to-integrate/refine-more/markdown/commonmark-non-conflict-table.md` §3.2, commit 1e75f3f. An agent ran it on all 652 CommonMark examples, against the parser at `core/` HEAD.
- What the parser does:
  - `"|li Item one ; TODO expand\n"` → comment;
  - `"|sec\n  Some prose ; a note\n"` → literal;
  - `"Some prose ; a note\n"` at the root → literal.
- It calls the measured behavior *"the markdown-friendly one; the written law is the hazardous one"*. It names French typography and prose that quotes code as routine sources of `" ; "`, and gives no verdict.
- OPEN.md's SEMI-BASE row was added in e2b3fcf the same night. It is the text the neutral file quotes, marked *STEWARD*.
- `thoughts-on-scope.md:229-236` repeats it as divergence (2).

### 25. 2026-07-28 — Joseph defers the whole queue of binary questions, SEMI-BASE included

**Source:** `v2/.archived/FOR-JOSEPH.udon:44-64`. The agent's item listed *"Also pending: SEMI-BASE, S4, FIX-FRAME, …"*. Joseph's answer, verbatim:

> These are open binary questions that shouldn't be asked yet on a spec that hasn't been written yet. It's precisely our current work that will make the answers self-evident in the future. Consider marking the whole file "hypothetical" or "as per a current (already stale) snapshot of spec vs path/schema/meta thinking... valuable only for ideation pros/cons" -- consider anything open there or in the spec as "open for guidance from the schema/path/meta team"

**Bears on 03.** SEMI-BASE was deliberately left open and not ruled.

### 26. 2026-07-29 — the security and generation angle; escaping markdown on import

**MINEFIELD-MAP.** `v2/theory/to-integrate/primary/format-failures/MINEFIELD-MAP.md:462`, by an Opus researcher, commit 8eab19a:

> **3.5 — The ` ; ` carve-out punctures the positional certificate (M12).** … a whitespace-framed ` ; ` opens a trailing comment *after* commitment to text. That is, by construction, a live control sequence inside content. … it is the difference between "no control characters in prose" (a certificate) and "one control sequence in prose" (a behavioral bound with one known case). Anyone generating UDON from untrusted text must escape or reject that sequence, forever, everywhere — which is the escaping regime the rest of the design avoids.

`BRIEF-FOR-EXTERNAL-PASS.md:168` lists it as an open question for outside reviewers: *"Does the whitespace-framed ` ; ` comment really survive commitment to text, making it a live control sequence inside prose?"*

**The "udon-soup" letter.** `v2/theory/to-integrate/primary/underlying-logical-model.md:109`, an agent, with *"two corollaries Joseph supplied"*:

> **`.md` → auto-escape** (a leading `\` on just the lines whose first character would pass a marker guard; `\` also kills the framed-`;` affordance, so both measured hazard classes — line-initial promotion … and the SEMI-BASE comment divergence — vanish in one reversible, idempotent character)

The text doesn't make clear whether this particular rule was Joseph's corollary or the agent's elaboration of it.

### 27. 2026-07-30 — an outside reader's prediction

**Source:** `v2/msc/read-log-2026-07-30/00-initial-predictions.md:56`, an agent working from memory before reading: *"`;` starts a comment; framed ` ; ` mid-line is (contested — SEMI-BASE) an inline comment."*

### 28. 2026-08-08 — Joseph: the element line has "syntax-sugaring available that isn't other places"

**Source:** `~/.claude/history.jsonl:18835` (13:31). Joseph, in part:

> I almost think of it as vim-modes or grammar state, and it feels like a lot of the time in the past same-line has somewhat forgotten the ideal -- sameline has (1) certain syntax-sugaring available that isn't other places, and (2) has pseudo-line-feeds …
>
> `|element "here we go!" |child "here we go some more" |grandchild and here we stop ; And this is a normal comment as usual...`

The earlier permutations list (`:18832`, 13:01) has an indented text line (`  Some more children`) with no ` ; ` in it, while its trailing comments all sit on element or attribute lines.

**Bears on 03.** Only framing: the element's line has sugar of its own. Neither message rules on block text.

### 29. 2026-08-08 → 08-10 — K9 and K10: no more prose on the element line; ` ; ` becomes a value terminator

**Source:** `v2/DECISIONS.md`.
- **K9:** *"Sameline is value-space; sameline text is `:'$main'` sugar."*
- **K10:** *"Unquoted text values terminate at framed markers — prose no longer exists on the sameline … it ends at … a framed ` ; `, EOL …"*.

The agents' confirmation questions:
- `msc/for-joseph/UNIF-PASS-QUESTIONS.md` item 2: *"Framed ` ; ` terminates an open unquoted text value … Confirm?"*
- `msc/for-joseph/01-PLAIN-DECISIONS.md` D5: *"Does a framed ` ; ` still end an open value?"* WHERE-THINGS-STAND says D5 still shows as open.

**Bears on 03.** The place the framed comment was ratified for ("sameline prose") stopped existing as a category. On the element line it now works as one of the value's closing delimiters.

### 30. 2026-08-09 → 08-11 — 0.10.0 puts the one exception in block text, in words

**Source:** `v2/spec-0.10.00/CORE.md:108`, commit 2de5907, Claude Fable 5, *"no pre-K9 prose/blob/forced/commits sentence consolidated as-is"*.

> **Text-space** is the block interior: lines that do not open structure at a structural column are **text of their column owner** (§7). Text-space is where prose lives. Within a text line, marker characters are literal, with the framed ` ; ` comment as the one carve-out (§8) — the old *commit* model, now scoped to text-space only.

- §8 keeps the row *"In block text **at** the content base | line comment"* and adds *"Within an open unquoted text value (framed ` ; `) | line comment — terminates the value"*.
- `DELTAS.md` has no row about `;`.

**Bears on 03.** This is the first text I found that says in plain words (not through a table row that needs interpreting) that a framed ` ; ` works *within text lines of the block interior*. That is alternative A. It arrives as a restatement, not as a listed change.

### 31. 2026-08-09 / 08-11 — the lexical-forms tables: the framed comment sits in the element-line column

**Sources.**
- `v2/theory/to-integrate/lexical-forms-discussion-2026-08.md`. Its seed is Joseph's, verbatim: *"there are / should be probably three distinct forms of many things. block/geometric, value, and embedded (or maybe it's embedded-value...) distinctly embedded in prose"*.
- `lexical-forms-matrix-2026-08-11.md` (an agent).

**The Comment row:**

| Block / geometric | Sameline (in the scan) | Value (in a slot) | Embedded (in prose) |
|---|---|---|---|
| `;` at line start (geometric, owns deeper lines) | framed ` ; ` (to end of line; ends an open value) | *deliberately none* | `;{…}` |

**Bears on 03.** In this taxonomy the framed form is an element-line form, and the in-prose form is `;{…}`. There is no cell for a framed ` ; ` in block text.

### 32. 2026-08-27 — 0.10.1-draft (later called a misfire) keeps the 0.10.0 wording

**Sources.**
- `v2/spec-0.10.01/CORE.md:70`: *"Text-space — the block interior … Markers are literal there, with the framed ` ; ` annotation as the one carve-out (§8)"*.
- §8:266 keeps *"In block text at the content base | line annotation"*.
- `NUANCE-AUDIT.md:56` (strain 1) calls the framed ` ; ` *"Held as the price of trailing annotations (`|li Item ; TODO`), explicitly a convenience purchase."*
- `theory/to-integrate/unification-matrix-2026-08-27.md:13`: *"comments `;` (all positions) | annotation | **survives**"*.

**Bears on 03.** It carries the A wording forward. The reason it gives is still the element-line idiom.

### 33. 2026-09-01 — the 0.10.1 audit flags SEMI-BASE as unresolved

**Source:** `v2/spec-0.10.01/working-notes/AUDIT-2026-09-01.md:97` (an agent; committed 2026-09-21):

> **D15.** ROOT-BASE and SEMI-BASE from OPEN.md are still open and the draft still doesn't state the root content base or disambiguate "in block text at the content base" (line-start `;` vs mid-line framed ` ; `).

The descriptive fixture `spec-0.10.01/fixtures/descriptive/gaps.yaml:414-423`, `gap_D15_semi_base_open`, has two readings:
- `annotation: "text 'one', annotation 'two'"`;
- `literal: "text 'one ; two\n' (the row means a line that STARTS with ';' at the base)"`.

**Related findings in the same audit:**
- C6 (:76): under §8's table, a line starting with `;{` at a structural column is a *line* annotation, so *"`;{note} then prose` at line start swallows the whole line (and deeper lines)"*.
- A6 (:51): a comment at the end of an element line followed by deeper lines — does the comment own them?

### 34. 2026-09-29 — Joseph, on reading the January note

He sent this to the coordinating agent, who passed it on. Verbatim:

> (just dropping by -- saw my Jan note-- a good example of how far my thinking has changed from January! (on both doc root AND inline comments-- also I notice I got the indentation wrong:
> ```
> ; this is a comment
> this is text
> ; this is a comment
>  this is still a comment...
> ```
> - Joseph)

**Bears on 03.** Two things:
- He says his thinking on *document root* and *inline comments* has moved since January. Entry 11 is the January note.
- On the indentation: the January prompt as typed (entry 11) had the continuation line indented one column deeper. The flattened version came from memorata, not from his typing.

---

## Threads worth noticing

*These are my readings of the history above. They are interpretation, not record.*

1. **Every statement of intent I found keeps the mid-line comment on the element's or attribute's own line.** That covers 2011 ("only available in identity section"; "can of worms"), 2025-12-25, both 2025-12-31 statements, 2026-01-02, 2026-07-15 ("*only* if it is sameline"), and 2026-08-08 ("sugaring available that isn't other places"). I found no one — Joseph or an agent — arguing *for* comments mid-line in block text. The A-shaped texts (0.9.1 §2.2 + §8, 0.10.0 §2, 0.10.1 §2.3) each call themselves restatements with no behavior change, and each repeats the element-line reason (`|li Item ; TODO`). Two caveats hold as strongly as the pattern:
   - Joseph has said his January thinking has moved (entry 34).
   - On 07-28 he deliberately declined to rule SEMI-BASE on a snapshot spec (entry 25).

2. **How it drifted, as I reconstruct it:**
   - The ratified exception was *named* for a position ("sameline comment"). But the sentence that carried it into CORE was worded without a position ("even after the line has committed to prose"). That was harmless while "commit" mostly mattered on element lines and a nearby example said "not a comment".
   - The row "at the content base" came from the same day's ruling about a line *starting* with `;` at the base column versus one column deeper (entries 16 and 19). The clean-room rewrite (2a) moved it into a separate table row that doesn't say line-start.
   - The example that settled it was dropped in all four rewrites and in 0.9.1.
   - 0.10.0 then did the most consequential step. After K9 removed prose from the element line, it moved the "commit" model *into* text-space, and the one exception went along. So the exception left the only place its own reason applies (trailing notes on the element's line) and ended up in the place the original reason said to protect ("block prose is where semicolon-bearing content lives").
   - DELTAS never logged a change, which is consistent with the move being unintended.

3. **"Both readings internally coherent" (OPEN SEMI-BASE) is true of the texts but hides the history.** Under the reading where the row means a *line-start* `;`, the row "In block text **at** the content base" says the same thing as "Line start, structural column" (the content base is a structural column). Being redundant is itself a small sign it was a line-start row. Under the other reading, it is the only row that turns on a comment in the middle of text.

4. **Which alternative "simplifies the grammar" depends on the model lite adopts.**
   - Under a single "every line starts open, then commits" model (0.9.1 §2.2), A is the one-sentence rule and B needs a positional exception.
   - Under 0.10.0's own two-space model (value-space on element/attribute lines, text-space below), B is the simpler one. Text-space becomes "markers are literal, full stop" (apart from a `;` at line start, which is structure, not inside a line). The framed ` ; ` becomes just one more value terminator in value-space (K10).
   - So the least-surprise-plus-simplicity test Joseph named may point in different directions depending on the mental model question 13 (AST shape) and the value-space/text-space split settle on.

5. **The frame was built to protect prose, and a text line is where prose lives.** The both-sides frame exists because of prose: `;-)` (entry 18), and "block prose is where semicolon-bearing content lives" (entry 15). Joseph's own least-surprise instinct on 07-15 leaned toward the *weaker* YAML/shell rule (a space before only) outside prose. Under A, the frame is the only thing keeping a comment from starting in every paragraph. Under B, the frame guards a short element-line tail.

6. **Nothing is measured on how often authors want it.** No needs-corpus item asks for a comment in the middle of a paragraph. The one measured corpus (CommonMark, entry 24) contains no " ; " cases that fired, because the parser is B. The review's reflow measurement (entry 13) found zero `;-)`. Neither side of this question has usage data.

---

## What the neutral file misses

These come from the history, not from anyone's preference.

1. **Top-level text had this exact split, and it was deliberately removed.**
   - In December 2025 a mid-line ` ; ` in root-level text was a comment (A) while the same line inside an element was literal (B).
   - Joseph's 2026-01-02 principle ("zero distinction between 'document root' level and being children of an element") made it literal everywhere (commit 7003996).
   - The neutral file points to 04 for "the same question at top level". The history shows the two have been decided together before, and that a root/element difference in ` ; ` is a known failure mode.

2. **Text bodies under an attribute raise the same question.** Examples are an attribute's deferred body, or a text value that continues onto deeper lines. The 07-15 attribute-model note ruled the first line keeps the framed comment and *"subsequent block lines follow block-prose rules — `;` literal"* (entry 17). The neutral file covers only text under an element.

3. **A line ending in ` ;` is its own case.** End-of-line counts as the "after" boundary: a trailing `x ;` is an empty comment (0.9.1 §8; the 07-15 ruling). Under A, a hard-wrapped paragraph whose line happens to end in " ;" loses that `;` into an empty comment, with nothing visibly wrong. French typography and prose that quotes code, both named in entry 24, are the realistic sources. The neutral file shows only ` ; ` followed by text.

4. **Alternative B still has a `;`-at-line-start hazard inside paragraphs, and alternative C is the only one without it.**
   - Under B, a wrap or edit that puts `; …` at the start of a line at the base column makes it a comment. Under the 07-15 continuation ruling, that comment also takes every deeper-indented line below it.
   - The estate review measured and named this reflow class (entry 13); the vim notes say "Do not `gq` UDON prose".
   - Alternative C removes it, but it contradicts Joseph's 2025-12-25 "any time a line starts with this" and the 07-15 "comments interleave with prose at the base column" ruling that Joseph agreed with. C would also need a rule for when a line counts as "inside the paragraph" rather than at the element's content column. The history never defined such a boundary, since lines at the base are structure positions.

5. **Other remedies the history shows** (listed, not weighed):
   - a separate marker for end-of-line comments inside free text (2011's `#|`, entry 3);
   - a space before the marker only, plus a warning when there's no space after (Joseph's first 07-15 instinct, with YAML and shell as precedent, entry 18);
   - escaping imported markdown line by line with `\`, which also switches off the framed form, so the SEMI-BASE divergence can't happen for files brought in from `.md` (entry 26);
   - `;{…}` as the one in-prose comment (entries 6 and 31).

6. **Generating UDON from untrusted text.** MINEFIELD-MAP 3.5 (entry 26) says the escape burden follows the rule:
   - under A, every prose line an agent or tool emits must escape or reject ` ; `, "forever, everywhere";
   - under B, only text placed on an element or attribute line must.

   The neutral file's "Why it matters" covers authors writing markdown by hand, not machine generation, and generation is a large part of how UDON gets written.

7. **The file's tree for A doesn't match the ruled text wire.**
   - The text-wire rule D1 (`spec/TODO-TEXT-WIRE.md:64`; fixture `core/fixtures/v0.9/comments.yaml:44-55`) splits a line with a trailing comment as `Text "Item one "` + comment `" TODO expand"` + `Text "\n"`. The space before `;` stays in the text, the comment body keeps its leading space, and the line terminator comes after the comment.
   - Under A, the same would apply to `Keep calm ; carry on.`: text `"Keep calm "`, comment `" carry on."`, then `"\n"`. The neutral file shows `text "Keep calm\n"` and comment `"carry on."`.
   - If lite is defined as the tree it produces, this detail is part of the choice.

8. **A line starting with `;{` interacts with 10 and C.** Under the §8 table, a line that *starts* with `;{…}` at a structural column is a line comment and swallows the rest of the line and any deeper lines (the 09-01 audit's C6, entry 33). If lite takes `;{…}` in (question 10) as the in-prose comment (alternative C, or B plus `;{…}`), what a line-initial `;{` means has to be settled at the same time.

9. **Where "at the content base" came from answers the neutral file's own open question.** The neutral file says the texts don't say whether "at the content base" means a `;` starting the line or a mid-line ` ; `. The wording traces to the 2026-07-15 base-column-versus-one-column-past ruling (entry 16) and the table fix that followed (entry 19). Both are about lines that *start* with `;`. The mid-line reading first appears in words in 0.10.0 §2 (entry 30).
