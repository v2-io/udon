---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: true
terms: [head-position]
per: []
depends: [def:marker, def:left-edge]
consequences: [def:element-line, rule:fence-opens-with-backticks, rule:fence-anywhere-structure, rule:deeper-marker-lines-are-text, rule:prose-line-start-reserved, rule:line-start-escape]
---

# head-position

*A «head-position» is a place in the source where a «marker» can begin structure. It is Joseph's July 2026 term, which agents renamed "Structure Position" without him; lite's cards currently paraphrase it as "where structure can start".*

## Terms

- **head-position:** a place where a «marker» is recognized and can begin structure. It covers the start of a line's content at or left of any established text «left-edge», and the places on a «sameline» where a new element, attribute, comment or fence can begin. *(Working definition of the thing, under Joseph's name for it. Neither the name nor the extent is reviewed for lite.)*
  - *Avoid:*
    - **"Structure Position"**: coined in Grok's greenfield rewrite "3b" (commit `b10d16d`, 2026-07-19; `v2/.archived/first-pass/greenfield-3b/new-spec/DECISIONS.md` D4, which "retired … head position"). The second pass listed the naming under "Own next (no steward required)" (`v2/.archived/second-pass/STATUS.md`). It became `v2/DECISIONS.md` **N-pos** (2026-07-21), then 0.9.1 and 0.10.0. A Gemini reviewer flagged it as parser jargon on 2026-07-22 (`v2/OPEN.md` **N-jargon**, "a steward call"), and nothing shows Joseph answering. *(The brief I was given dates the rename to 0.10.0. It happened earlier, in 0.9.1 via the 2026-07-21 ledger, and Joseph was still writing "head-position" on 2026-07-23.)*
    - **"open position"**: the alias from greenfield "2a", allowed "once" by N-pos.
    - **"structure position"** (lower case): `main.outline.md`, gap row `rule:markers` ("What opens what at a structure position").
    - **"where structure can start"**, "where a structure line or sameline structure can start": lite's fence cards. These are paraphrases standing in for an undecided name.
    - **"value-expected position"**: 0.10.0. It is a different place, the slot where a *value* is expected; don't merge the two.
    - **"the head"** for an element's name, key and traits: pre-design 01's history agent. In 0.10.1, **"Head"** is the addressing expression a reference carries (`@head`; GLOSSARY "New"). Both clash with "head position".

## Working notes

- **Not reviewed with Joseph.** The coordinator's vocabulary inventory raised it on 2026-10-09 (`.int/lexicon-inventory-2026-10-09.md` §5). The last use of the term in Joseph's own prompts is 2026-07-23.

### Joseph's words

All from `~/.claude/history.jsonl`, project `udon`.

- 2026-07-12T04:06Z (line 15839): "*Head position*  -- that needs to be a prominent part of the lexicon / spec---  specifies that we're still deciding if it's prose or block and includes same-line..."
- 2026-07-12 (line 15850): "Right, head-position structural directives…"
- 2026-07-12 (line 15858): "whether or not to sunset the "'" as a head-position escape character (answer is yes, we will remove)"; 2026-07-13 (line 16045): "WE JUST DROPPED head-position escape!"
- 2026-07-14 (line 16137): "I think the intent was that triple back-tick fences were valid in every head position", and in the example, "``` this is also prose because only the column aligned with the first column of the prose is a head position".
- 2026-07-14 (line 16139): "|a |b :a value ```this starts a code fence because it was a same-line head position" / "|a |b but not ```this one".
- 2026-07-14 (line 16150): "Is there ambiguity right now on whether the beginning of :cttr 3 is a head-position or not?"
- 2026-07-14 (line 16202): "escaping any initial head-position character is valid, even if it turns out to not be an *actual* block-level/head-level element".
- 2026-07-14 (line 16217): "the first backslash there at the head-position means the next space is a literal prose space, which also (after the backslash is consumed so the text backs up one column) sets the current indent-level / head-position".
- 2026-07-19 (line 16875): "whitespace past the prose-head column"; "prose that ends at or before the prose head position".
- 2026-07-23 (line 17392): "udon with the leftmost head-position (primary content) being primarily markdown".
- 0.9 mainline `spec/CORE.md` "Head Position" (written in his July sessions): "the state in which the parser has not yet decided whether what comes next is a structural marker or prose. It is **re-entered at the start of every line**, and it has two faces": block-line start, and the "sameline scan".

### Readings of his usage (mine)

He used "head position" in three senses, and they agree only under the July 2026 model.

1. **A state:** "still deciding if it's prose or block".
2. **A place:** "valid in every head position", "a same-line head position".
3. **A column:** "the column aligned with the first column of the prose is a head position", "sets the current indent-level / head-position", "prose-head column". This is the column structure must reach or pass left of, which lite calls the text's «left-edge».

Sense 3 means his "head position" and lite's «left-edge» are, in his July usage, partly the same thing seen from two sides. The left edge is where text lines are dedented to; the head position is the column where a line may still start structure.

### What changed under lite

- In 0.9, a line "committed to prose" at its first text word, ending head position for the rest of the line.
- In lite, sameline text never commits: it ends at ` |name`, ` :name`, a framed ` ; ` or ` \ ` ([[rule:text-value-end]]). So on a sameline, a head position recurs after every finished value. The "still deciding prose or block" sense (1) now fits only line starts; on a sameline, nothing is ever prose.
- **A gap this exposes:** [[rule:fence-anywhere-structure]] says a fence may open "on an element's or attribute's line, wherever structure can start", but [[rule:text-value-end]]'s list of what ends sameline text has no fence in it. So `|a some text ```js` is text, and a fence opens only where no text is running (`|a |b ```js`, `:x ```sh`). Joseph's 07-14 "|a |b but not ```this one" agrees. The set of head positions on a sameline is therefore not one set: some markers are recognized only where no text is running (fence), others also where text is (` |`, ` :`, ` ; `, ` \ `). [[rule:reserved-spellings]] reserves `@name` and `!word` "on an element's or attribute's line" without saying whether that includes the middle of running sameline text (`|p see @jw now`). One name for "places a marker is recognized" may need to say which markers.

### Other agents' leans

- greenfield 3b, N-pos, 0.9.1, 0.10.0: "Structure Position", "the state in which markers are recognized" (a state, sense 1).
- The Gemini reviewer (2026-07-22) proposed author-centric names, "Element Definition Phase" and "Inline Context", against parser jargon.
- Lite's drafters avoided naming it ("where structure can start").

### Precedents

- **Regex and lexers:** the `^` anchor and flex's `^`-patterns ("match only at the beginning of a line"); flex "start conditions" and ANTLR "lexer modes" for states in which different tokens are recognized. Sense 1 maps to a lexer mode, sense 2 to an anchor.
- **YAML 1.2** parameterizes its grammar by a context (block-in, block-out, flow-in, flow-out, block-key, flow-key; from memory). What an indicator means depends on the context it appears in. That is the nearest precedent for "a place where markers are live", and YAML keeps it as grammar notation, not a reader-facing term.
- **CommonMark** decides block starts from "the first non-whitespace character" of a line, allowing "up to three spaces of indentation". It has no name for the position, only the rule.
- **Haskell** layout reasons about "the indentation of the next lexeme": a column, matching sense 3.

### Questions about meaning, register and affordance

- **"Head" reads as "start".** That fits line starts and his sense 3, but a reader may not expect a "head position" in the middle of a sameline after a value. His "same-line head position" shows he meant it there too.
- **"Position" reads as a place**, or a column if it is numeric. Neither reading suggests a state; sense 1 is a state.
- **Collisions in the corpus:** `@head` (0.10.1 references); "the head" of an element (pre-design 01); "headings" in Markdown, which UDON hosts. Without highlighting, "head" next to `|h1` examples could be misread.
- **Is a term needed?** Lite's cards manage with "where structure can start", and the gap row `rule:markers` will need *some* name for where each marker is recognized. If «marker» is defined by where it is recognized, "head position" may be needed only as "a place where markers are recognized". Or the card could list those places and skip the term.
- **Two possible splits:** "line head" (the start of a line) and "sameline boundary" (a place on a sameline where a new construct may begin). This would separate senses 1/3 from sense 2. That is an agent idea, not his.

### My own opinion (the drafter's; not a lean of Joseph's)

- Restore **head position** as the term for sense 2, *a place where a marker may begin structure*, because it is his, he asked for it to be "a prominent part of the lexicon", and the replacement was never put to him.
- Let «left-edge» carry sense 3, the column.
- Drop sense 1 (the state), since lite's sameline no longer commits to prose.
- The fence/sameline-text gap above needs his ruling either way. It is a rule question that the name exposes, not a naming question.

### Cards and rows a rename would touch (left unedited)

- `main.outline.md` gap row `rule:markers` ("at a structure position").
- `src/rule-fence-opens-with-backticks.md` ("where a structure line or sameline structure can start").
- `src/rule-fence-anywhere-structure.md` ("wherever structure can start").
