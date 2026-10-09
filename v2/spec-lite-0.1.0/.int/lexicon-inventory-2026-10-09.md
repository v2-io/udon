# Lite's vocabulary: what the cards say, where each word came from, and what Joseph calls it (2026-10-09)

*Written by a fork of the coordinator (Opus 5.5) on 2026-10-09, at commit `de11b58`, answering Joseph's point 4 the same day: "is that an example of something that got a def/ lexical definition decided and it just wasn't communicated to me? or is it casual use/misuse, or have definitions not been nailed down yet". This is an inventory, not a proposal: nothing below is decided by being listed. It is meant to feed one-at-a-time questions to Joseph of the form "in this example, what do you call this piece?".*

**Sources.** All cards (`src/`), definitions (`def/`) and objectives (`obj/`), by grep; Joseph's typed words from `.int/STEWARD-VERBATIM.md` and, for older uses, `~/.claude/history.jsonl` (cited by line); `spec-0.10.00/GLOSSARY.md` for inherited terms; `references/def/` for addressing-theory terms. File counts are files in `src/` + `def/` containing the word, from case-insensitive greps; they show spread, not exact usage.

## The short answer to Joseph's question

None of the contested words was decided with him. Lite's `def/` holds eight definition files (anomaly, blank-line, document, node, reading-option, string, text, typed-value), all drafted by agents and all marked `awaiting-second`; only two of their terms trace to his own words (`typed value`, his 2026-09-30 choice, and empty-line / blank-line, defined by him on 2026-10-08). **"label" and "line scan" came in from 0.10.0's glossary**, an agent-written suite from the 2026-08-09 overnight unification pass that Joseph never ruled on, and the card drafters used them as if settled:

- **label.** 0.10.0 `GLOSSARY.md`: "**label** = an assignment's name-side (`:label value`)", one leg of an agent-made "three-way name split" (key / label / kind). Lite's `def/def-node.md` (drafted 2026-10-09, never shown to Joseph) carries it as "**attribute:** a label and a value on an «element»", and also "**fence:** a node carrying a label and a body". 39 card files use the word.
- **line scan.** 0.10.0 coined "Line Scan" (its glossary retires the earlier "the scan (as formal term)"). It is the title concept of `src/rule-line-scan.md` and appears in 3 files. Joseph has never used it; his word for the same territory is **sameline** ("sameline processing", "attribute-sameline").

So the honest category is the third one: definitions were never nailed down with him. The cards then used inherited words casually, which made them look settled.

He had already flagged one of these. On 2026-09-30 (`history.jsonl:21338`): *"is that "leftover values on a line go to the label that owns the line" verbatim? If so it's very problematic, as "label that owns the line" is ambiguous exactly where the lean is weighing in-- the question is what "label" owns the line for all of the remainder text."* The same message mentions the first lexicon attempt, deleted as "lazy and sloppy" (the day before he had written: *"same_line, same-line, and sameline all in the same document"*, `history.jsonl:21330`).

## Contested terms, most consequential first

Each entry gives what the cards use the word for, where it came from, Joseph's own words for the thing, and an example to put to him.

### 1. label

- **Cards:** the name part of an attribute (`:label value`, "a label with no value", "waiting label", "leftover values … stack on the attribute"); a fence's info string ("a fence's label"); in `def-typed-value`, the `u64` in `<u64:0xff>` («type-label»).
- **From:** 0.10.0 GLOSSARY (agent, 2026-08-09); `def-node` and `def-typed-value` (agents, 2026-09-29/10-09).
- **Joseph's uses, in order:**
  - 2026-08-09: "You really need to stop calling attribute labels keys though don't you?" (`history.jsonl`, quoted in pre-design 06): "attribute labels".
  - 2026-09-30: "label that owns the line" is ambiguous (above).
  - 2026-10-08: "a label with no value" (an attribute with no value); "special constructs for labels, e.g. `|'something "hey"\'' weird node name`" (a quoted element name); "the fence's label"; ":label-under-open-attribute".
  - 2026-10-09: "we have reserved nested attribute-labels".
  - 2026-10-09: *"'label' which I prefer to use as the rules for how identifying labels are put together (the node-name, the attribute-name, a trait-name, etc.--- all "labels" lexically)"*.
- **The conflict:** his stated preference makes "label" a lexical class (the shared spelling rules for names of several kinds), while the cards use it for one of those names (the attribute's) and for two unrelated things (fence info string, type tag).
- **Example to ask with:**
  ```udon
  |user[jw].admin :role editor
    ```sh
    make
    ```
  :when <u64:0xff>
  ```
  What do you call `user`, `role`, `admin`, `jw`, `sh`, and the `u64`? Which of them are "labels" in your sense?

### 2. sameline (and its spellings)

- **Cards:** "sameline" 31 files, "same-line"/"Same-line" 16, "same line" 14, often mixed within one card; also "element's line" (7) and "attribute's line" (9).
- **From:** "sameline" is Joseph's; "same-line" and "same line" are drafter variations; "element's line"/"attribute's line" are agent phrasings.
- **Joseph's words:** "sameline" throughout; "attribute-sameline" (2026-09-29, his coinage); "element-sameline vs attribute-sameline" (2026-09-30); "node or attribute started lines" (2026-10-08). He called the mixed spellings sloppy (2026-09-30).
- **Ask:** confirm "sameline" as the one spelling, and whether "element-sameline" / "attribute-sameline" are the terms for the two kinds of line (in place of "element's line" / "attribute's line").

### 3. line scan

- **Cards:** `rule-line-scan` ("One scan for element lines and attribute lines").
- **From:** 0.10.0 (agent).
- **Joseph's words:** "sameline processing", "sameline behavior".
- **Ask:** is there a name for the rule that reads a sameline run the same way whichever kind of line it is, or is it just "sameline"? (`rule-line-scan` would be renamed either way.)

### 4. tree / AST, raw-tree, reading option

- **Cards/defs:** «tree», «raw-tree», «reading-option» (`def-document`, `def-reading-option`).
- **From:** agents (2026-09-29 to 10-09).
- **Joseph's words:** "AST" ("AST-centric", "AST-only", "raw AST"), "representational-options", "an AST reading flag" (2026-10-09).
- **Ask:** tree or AST in the spec's own text; "raw AST"; "representational option" vs "reading option".

### 5. Where text lines start: left edge, content base, indent level, head position

- **Cards:** "left edge" (11 files); "content base" (1, inherited).
- **From:** "left edge" is a drafter's; "content base" is 0.10.0's; "Structure Position" is 0.10.0's replacement for Joseph's term.
- **Joseph's words:** "indent level", "active indent", "first-inner-sets-indent"; and **head position**, his July term: *"*Head position*  -- that needs to be a prominent part of the lexicon / spec---  specifies that we're still deciding if it's prose or block and includes same-line..."* (2026-07-11, `history.jsonl:15839`); 0.10.0 renamed it "Structure Position" without him. Lite's cards use neither and paraphrase ("where structure can start").
- **Ask:** the name for the column a block of text is dedented to, and whether "head position" comes back for "a place where a marker is recognized".

### 6. What sits under an attribute: body, value lines, child block

- **Cards:** "body" (24 files, for fence bodies, comment bodies, an attribute's indented lines); the gap card `rule:attribute-bodies` ("Values written on the lines under a label").
- **From:** 0.10.0 "deferred body"; drafters.
- **Joseph's words:** "fence body" (2026-10-08); today: "values as indented child blocks of an attribute".
- **Ask:** "body" for fences and comments, and what to call an attribute's indented lines.

### 7. Same-line text pieces: piece, run, embed, chunk

- **Defs:** `def-text`: «text» = «piece»s, each a «run» or an «embed».
- **From:** agents (2026-10-09), from Joseph's words.
- **Joseph's words:** "text has any number of pieces some of which are not strings" (2026-10-08); "embeds", "a distinct chunk of distinct text as if it were a word" (2026-10-09). "run" is not his.
- **Ask:** "piece" and "embed" look like his; "run" for a stretch of plain characters?

### 8. string / text / prose

- **Defs:** «string» and «text» defined (`def-string`, `def-text`); "prose" undefined in `def/` but used in 35 card files as "the source region of text lines".
- **Joseph's words:** he asked on 2026-10-09 whether the three are clearly defined, and on the same day listed "clean definition and distinction for 'string', 'text', and 'prose'" among lite's defining changes. He also worried "about 'string' being its own distinct type from 'text'" (2026-10-08).
- **Ask:** confirm the three as defined (string = quoted value; text = pieces; prose = the source lines that produce text), and whether prose gets a def file.

### 9. Smaller agent coinages in card titles

- "waiting label" (`rule-waiting-label`), "leftover values" (`rule-leftover-values`), "opaque span" (agent 2026-10-08, used back by Joseph the same day), "framed" (agent; Joseph: "spaces around it as frame"), "block form" (Joseph's, 2026-10-08), "text terminator" (Joseph's, 2026-10-09), "comment block" (agent; Joseph: "available as their own block"), "verbatim flag" (agent; Joseph: "'-' suffix for verbatim"), "anomaly" (0.10.0/agent; Joseph uses error and warning), "value slot" (0.10.0).
- **Ask:** probably in a batch, after the bigger ones settle.

### 10. element / node / attribute

- **Defs:** `def-node` defines «element», «attribute», «comment», «fence» as the nodes; the trees show text pieces too.
- **Joseph's words:** "node" and "element" both ("node-name", "node or attribute started lines", "|elements"); "attribute" throughout. 0.10.0's "assignment" never reached lite.
- **Ask:** is an attribute a node? Is "element" the name for `|name` nodes and "node" the general word?

## Terms that look settled (Joseph's own, or his choice)

typed value (explicit / implicit), $main, key, trait, root node (implied), meta, fence, nil, empty line / blank line, reference, reserved, error, warning, stacking, embeds, sameline (as a word, spelling aside).

## Notes

- `def-typed-value`'s «type-label» collides with whatever "label" ends up meaning; it is the agent's word, not Joseph's ("with spelling for namespace or type undecided", 2026-09-29).
- The addressing theory (`references/def/`) uses "label" only for scope-graph edge labels (`def-scope.ud`), a separate sense; lite has no addressing, so no clash today.
- Renaming cards and definitions waits for his answers; none of this file changes them.
