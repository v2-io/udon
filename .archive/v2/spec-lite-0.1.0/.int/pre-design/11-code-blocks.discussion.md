# 11 — Code and other raw content in lite — history

**Written by:** Claude (Sonnet 5.5), history agent, 2026-09-29. Written after reading the neutral file `11-code-blocks.md` and before seeing any lean. There is no lean or recommendation section; that comes later.

## Method

**Read whole first:** `11-code-blocks.md`, `pre-design/README.md`, `spec-lite-0.1.0/README.md`, `v2/WHERE-THINGS-STAND-2026-09-27.md`. I also grepped the sibling `*.discussion.md` files for fence mentions (01 and 04 have some; cited below as *reported there*, not re-verified by me).

**Dates.** Local time: MST (−07:00) in 2025 and early 2026, MDT (−06:00) from spring 2026. "How I know" per entry is one of: git commit timestamp (`git log`), a `~/.claude/history.jsonl` timestamp (Joseph's typed prompts), a memorata result date (labelled where it is weak), or a date printed inside a document.

**Joseph's words, layout intact.** memorata strips indentation and line breaks, so I used it to *find* passages and took the quoted text from `~/.claude/history.jsonl` (`display` field, via a small script that prints only Joseph's typed prompts), from files, or from `git show`. Where a quote is his, it is verbatim with the original layout. Where I could not recover his layout, I say so.

**Searches run** (all memorata queries used `--sort oldest`, `--json`, and an explicit class list, see the thinking note below):

1. `sameline capture`
2. `verbatim capture code fence attribute value`
3. `triple backtick fence in udon raw block`
4. `|el :script !:sh: make build`
5. `fence knot backticks inside code block closes early`
6. `raw blocks verbatim code embed udon indentation byte-exact`
7. `--joseph` queries: `udon triple backtick fence code block closing indentation` (no results), `udon raw block !:lang: verbatim code body attribute value` (no results), `code fence inside udon nested backticks markdown` (2 results, both irrelevant), `fence closing indentation udon` (25 results, mostly unrelated; the useful ones were already found by other routes).

Beyond memorata, the productive route was a regex scan of `~/.claude/history.jsonl` (21,309 lines) restricted to the udon/libudon/descent/v2 projects, keyed on `fence|```|raw|!:x:|verbatim|freeform|geometric|capture`, run over three windows (2025-12 to 2026-06, 2026-07-11 to 07-22, 2026-07-29 to 2026-09-29). I then read every hit that touched code blocks or raw content. Repo work: `git log -S` on `fence`, `freeform`, `sameline`, `raw` in the umbrella repo; reads of the primary sources named in each entry; the 2011 originals at `~/src/_older/udon` and `~/src/_older/udon-c`.

**Things I ran myself, on 2026-09-29:** the current reference parser (`core/` at repo HEAD, 0.9.0-alpha.2 grammar, `cargo run --example stdin_parse`) on five small fence inputs (entry H29). A census of live `.udon` files under `~/src` for fences and `!:kind:` blocks (entry H29).

**Thinking-content caution, and what I hit.**
- Every memorata query listed the allowed classes explicitly (`human-user`, `agent-to-human-flanking`, `agent-to-human`, `document`, `agent-to-subagent`, `subagent-final-response`, `subagent-to-agent`, `other`). `agent-thinking` was never requested.
- Two exposures, both disclosed: (a) A `grep` of `core/_archive/generator/2025-12-28-afternoon.md` printed about thirty lines of what is rendered model-thinking narration (`*‹…›*`) before I recognized the file's nature. I have not used any of it. That file, `_older/libudon/_archive/generator/2025-12-28-evening.md` and `2025-12-29.md`, and commit `679cc1c`'s `2025-12-28.md` (27,845 lines) are transcript dumps with the same character; they appeared in results and I did not open them further. (b) Some `subagent-to-agent` snippets from 2026-07-11 to 07-28, and about five `document`-class snippets from the December transcript dumps (memorata query 6), read like first-person reasoning paraphrase ("I'm noticing…", "This makes perfect sense now"). I saw their first 200 characters in result listings, and did not quote or rely on them.
- Nothing was blocked for me.

**Limits.** No Joseph typed statement exists in the index for some things I looked for (listed under "What I looked for and did not find" at the end). His transcripts before the `~/.claude.bak.*` dates were reachable only through memorata and `history.jsonl`. The Dec-2025 sessions' full transcripts I did not read.

---

## History (chronological)

### H1 — 2011-07-31 — the word "fence" first appears: heredoc that declares a processor

- **How I know:** git commit `ab8bfe5` in `~/src/_older/udon`, 2011-07-31 02:57 −0700, message "Finalized syntax for text / interpolation / metachars / escaping / indent-sensitivity / filters/fences, etc." The file (`doc/syntax2.udon`) was moved to `.attic/` in `dc1cf05`, 2011-08-15.
- **Speaker:** Joseph, as a 2011 notes file (a notation sketch, not a spec).
- **Words:**

````text
# fence == filter == encoders/decoders ~= heredoc ~= processing-instruction

<<                      # unparsed DATA following indent rules ...
<uuu<                   # FENCED data (like heredoc that declares processor)
<uuu<'                  # or backtick or explicit double-quote to specify interpolation/metachar set
<{uuu<"www"}>           # embedded FENCE (also with single+back-tick variants)
````

  and a lexical summary: "Text is indent-sensitive unless inside a freeform block", with a table of `freeform` variants keyed by quote character (`"`, `'`, `` ` ``).
- **Bears on this question:** the original meaning of "fence" was a delimiter that also *names a processor* (`<uuu<`), i.e. the label-on-the-opener idea that today's `` ```sh `` and `!:sh:` both carry. It already had an "embedded" variant (`<{…}>`) beside the block one. Backtick was one of several quote characters, not the chosen one.
- **Incidental:** the metacharacter/escaping/percent-encoding matrix, the `!urlencode` chaining.

### H2 — 2011-12-15 — the same question, still open, in udon-c

- **How I know:** `~/src/_older/udon-c` commit `ecfaa4a`, 2011-12-15 01:00 −0800 ("Lots of notes, solidified syntax (esp. scalars)"), file `docs/DECIDED.md`.
- **Speaker:** Joseph.
- **Words** (under "IMPORTANT UNDECIDED"):

````text
* best, simplest way to have free text where indentation does _not_ apply,
  and/or that protects from udon structures being parsed:
  * yaml-like?
  * heredoc-like?
  * directive only? !{` .... `}
````

  and under scalars: "If you need a freeform text value - for example, unbalanced parenths, you need to use a grim attribute and put the text, indented appropriately, on the next line." Under decided: "FREEFORM: any time text starts its own line. Indentation rules still apply."
- **Bears on this question:** the question this file asks (how to hold content that must not be parsed) was already stated in 2011 in almost the same words as in 2025. The 2011 answer for *arbitrary text as an attribute's value* was the "grim attribute" (a value on the next indented line), not an inline capture. Note the name collision: in 2011, "freeform" meant ordinary prose starting its own line; the same word later meant the backtick fence (H9 onward), and by 2026-07 was retired for "fence" (H21).
- **Incidental:** the rest of the scalars/labels taxonomy.

### H3 — 2025-12-23 13:24 — the rewrite: two documents, two positions on fences

- **How I know:** umbrella-repo commit `f5813bd`, 2025-12-23 13:24 −0700, "Initial commit and rewrite based on analysis of the original + 12 more years of experience". Files `SPEC.md` and `analysis.md`, read via `git show f5813bd:…`.
- **Speaker:** documents written in a Claude session opened by Joseph. The commit carries no co-author trailer, so I cannot say which model wrote them. I found no Joseph prompt from that day that specifies the fence rules.
- **Words, `analysis.md` "Resolved Decisions (December 2025)" §1** (this document treats the fence as *the* answer):

````text
**Decision:** Triple-backtick blocks (Markdown-style)

|code-block :lang elixir
  ```
  def foo do
    # Indentation preserved exactly
    ...
  ```

**Rationale:**
- Markdown won. Everyone (human and AI) recognizes triple-backtick instantly.
- Visually distinct boundaries (you can see where freeform starts/ends)
- No conflict with existing UDON syntax
- Solves the "unbalanced parentheses" problem cleanly
````

- **Words, `SPEC.md` "Code and Raw Content"** (this document treats the fence as the *rare* form and puts `!code :elixir` first): "### Triple-Backtick Escape (Rare) / Triple-backticks break out of indentation sensitivity entirely. **Opening backticks:** The indentation of ``` determines the block's structural parent · Need not be at line start — can follow other content · Content after ``` on the same line is part of the freeform block". Its example puts a fence on an element's line, and one mid-sentence:

````text
|element and here we go with ```
freestyling it!
no indent rules in here
```

|parent
  |child
    some content then ``` and now we're free
anything goes
back at column 0
    ``` ; closing ideally matches but not required
```
````

  "**Closing backticks:** Should match opening indent (preferred) · Not strictly required — first ``` at opening indent or less closes the block". "Use this **only** when: assembling files from multiple sources without indent control · working with broken tooling that can't maintain indentation · the rare case where absolute positioning matters. **Do not use triple-backticks as the default for code samples.** Use `!code` instead."
- **Bears on this question:** this is where sameline (mid-line, even mid-prose) fences, "content after the backticks is part of the block", and the "rare / byte-exact / assembling files" purpose all first appear. The two documents disagree with each other on how central fences are. No byte-exactness rule is stated in words beyond "no indent rules in here".
- **Incidental:** `!code` as a directive; the EBNF line `freeform = "```" { CHAR }* NEWLINE { any_line }* "```"`.

### H4 — 2025-12-23 evening — agents push back on the fence

- **How I know:** `test/usability/results/udon-topic_enablement-20251223-*.yaml` (committed in `e339c56`, 2025-12-23 19:22 −0700, and neighbours) and `test/usability/enablement-synthesis.md` (commit `196f385`, 2025-12-24 08:11).
- **Speaker:** fresh one-shot agents asked to brainstorm from the spec, then a synthesis. Not Joseph.
- **Words** (three independent runs): "The triple-backtick escape feels like a code smell. If you need an escape hatch to 'break free' of your indentation model, maybe the indentation model is too rigid? I get why it exists, but it suggests tension in the design." · "You call it 'rare' but its existence suggests indentation semantics create problems." · "The triple-backtick escape feels like a smell—if you need an escape hatch from your indentation rules, maybe the rules are too strict?" The synthesis file lists "### 4. The Triple-Backtick Escape Hatch — Several responses note that needing an escape mechanism to 'break free' of indentation rules suggests possible tension in the core syntax design."
- **Bears on this question:** the first recorded pushback on fences, from readers who saw only the spec. It attacks the fence's *reason to exist* (an escape from indentation), not its details.
- **Incidental:** the rest of the enablement themes.

### H5 — 2025-12-24 07:39 — Joseph: fences exist; a shorthand could sit on top

- **How I know:** `~/.claude/history.jsonl`, project `udon`, session `ef2ca566`, 07:39:43 −0700.
- **Speaker:** Joseph. (The surrounding turns at 07:22 and 07:32 are about directives and dialects: "I suppose from the parser's perspective, the most important thing is knowing whether or not any particular dialect's 'inner body' is also UDON or not...?")
- **Words** (layout as typed):

````text
I suppose we should keep in mind that we already have the triple-backticks:

!graphql ```
  ~ ~ ~ ~ ~
  ```

we could have a shorthand for that, and everything else is udon:

!raw:graphql
  ~ ~ ~ ~ ~

Four extra characters and no extra lines instead of 7 (if you include the space after graphql), 1 line, and visual noise...
````

- **Bears on this question:** the block raw form was born as a *shorthand for a fence*, motivated by the fence's cost in lines and noise. Joseph's example also shows a fence on a directive's line (`!graphql ```). The dialect/`!` context of this message is why lite reserves the shorthand today, so this is one of the two roots of question 11.
- **Incidental:** the directive/dialect design it is nested in.

### H6 — 2025-12-24 07:58 — Joseph: raw cannot be an attribute value (attributes are typed)

- **How I know:** `history.jsonl`, same session, 07:58:39. The SPEC change is commit `abf273b`, 2025-12-24 08:10 −0700 ("Specify raw in a better way…").
- **Speaker:** Joseph; then the SPEC edit (agent).
- **Words:** "Inline raw would be like this: `|config !{raw:json {"status": "OK", "count": 42}}` and cannot be an attribute value-- those are typed." SPEC after the edit: "Note: Raw content cannot be an attribute value directly—attributes are typed scalars." Also in that day's messages: at 16:44, "for raw inline, do we require balanced curly brackets? I think yes-- with the understanding that if the user has curly braces in a string, for example, they'll just need to use block-level !raw."
- **Bears on this question:** the December position is the *opposite* of question Q1's ask: no raw content as an attribute value, because attribute values were typed scalars. That position was retired in July 2026 (H16). The same-day fallback "use the block form when braces are unbalanced" is the seed of the later "inline vs block raw" split.
- **Incidental:** the `!raw:lang` spelling (replaced by `!:lang:`, H7).

### H7 — 2025-12-27/28 — `!:json: {…}`: the body starts right after the second colon

- **How I know:** `history.jsonl`, project `libudon`, session `7947ca84`: 2025-12-27 20:11 (brace counting), 2025-12-28 13:16, 14:32, 15:12, 15:18. Implementation `97f7f0d` (2025-12-28 15:43); spec `2fe2fdb` (18:02).
- **Speaker:** Joseph.
- **Words** (12-28 15:12): "`!:label` is what I was thinking initially, but I think I'm going to land on `!:json: {"abc": 123, "def": "block level so } can be unbalanced"}` and `!{:json:{"abc",123}}` -- basically you start the "inner language" immediately after the second ':' (which would emit the raw label/namespace) instead of wondering what to do about whitespace in the other language."
  (15:18): "that would, in fact, be the preferred way to have json snippets in udon. The automatic dedentation would make the output become: …" (14:32): "a non-raw directive should work exactly like element, and raw directive should act exactly like a block comment." (13:16): if it starts with `raw:` "the parser treats the content as similar to prose (doesn't look for inner elements or anything-- just assumes it's all prose, uncluding output dedent, until the correct dedent happens to finish that block)."
- **Bears on this question:** the origin of (a) same-line body after the label (the first *capture-on-the-same-line* design), (b) geometric extent by dedent, like a block comment, and (c) auto-dedent of the block form, which is the opposite of the fence's byte-exactness. Question Q2's "dedent or not" is a live difference between the two forms from this day forward.
- **Incidental:** the interpolation/typed-value notes in the 13:16 message.

### H8 — 2026-01-01 — Joseph on fence whitespace and the closer

- **How I know:** `history.jsonl`, project `libudon`, session `31853cab` (2026-01-01, −0700): 09:08, 12:53, 18:52, 18:54. The spec had said "opening indent or less" (commits between 11:16 and 18:02); the implementation chose any-line-closes at 19:14 (`REVIEW-JULY-2026.md` §2 table, `udon.desc:589`).
- **Speaker:** Joseph.
- **Words:**
  - 09:08: "The variations tests need to not do indent for ``` blocks because by design those are meant to preserve all whitespace (including indents)-- or make the expectation softer by trimming whitespace from the output + expectation."
  - 12:53: "Also-- don't trust the tests about ``` unless you verify explicitly in the full-spec yourself."
  - 18:52: "The spec actually recommends that the closing ``` happen at the indent level of the parent (or something similar-- but not at column 0 necessarily)"
  - 18:54: "Honestly, column shouldn't matter for freeform-- it should just finish anywhere ``` starts a line after any amount of whitespace, and it doesn't affect the indent/dedent stack at all."
- **Bears on this question:** the earliest Joseph statement of byte-exact-by-design ("preserve all whitespace (including indents)") and of any-indent closing. Both are the rules the neutral file's Q2/§10.3 summary carries. Note the 18:52 message treats the closer's column as a recommendation about the *parent's* column; the 18:54 message says the closer "doesn't affect the indent/dedent stack".

### H9 — 2026-01-02 — fences meet Markdown conversion

- **How I know:** `history.jsonl`, project `libudon`, 2026-01-02 19:49 −0700, and a session summary at 19:57.
- **Speaker:** Joseph (19:49); agent-written summary (19:57).
- **Words:** Joseph, 19:49: "create a markdown->udon script (or visa versa?) … keeping things like list-items and code-fences pretty much identical". Summary: "md2udon corrupted code fences - fixed by protecting code blocks from transformation".
- **Bears on this question:** fences were kept identical to Markdown on purpose in tooling; a converter had to protect them. Small evidence for the Markdown-shape argument.
- **Incidental:** the rest of the comparison test.

### H10 — 2026-01-13 22:13 — Joseph: "if we continue supporting both"

- **How I know:** `history.jsonl`, project `udon`, session `c8003469`, 22:13:07 −0700.
- **Speaker:** Joseph.
- **Words:** "Exactly right. A raw node, or code-fence (if we continue supporting both) might be considered a leaf-node? Also, don't forget that an attribute is a container node that can also contain scalars."
- **Bears on this question:** one of only two places where Joseph himself raises whether both `!:lang:` and the fence should exist. The other is H12/H13's brief and his answer.
- **Incidental:** the tree-shape question it answers.

### H11 — 2026-07-08 to 07-11 14:59 — the July review and the decision brief

- **How I know:** `_archive/REVIEW-JULY-2026.md` §2 genealogy table and §4 defects 10, 11, 14, 15 (written 2026-07-08); `_archive/decisions-superseded/fence-semantics-brief.md`, commit `8e0e576`, 2026-07-11 14:59 −0600. Speaker: coordinator agent (commit trailers of the same session say Claude Opus 4.8).
- **Words (review):** sameline fences were "Dec 23 (initial commit), carried into FULL-SPEC" and "never implemented; no vestige of an attempt"; the spec's own example (`|element … ```) parsed as literal text.
- **Words (brief), the three sub-decisions:**
  - (a) closing indent: A1 spec's "or less" vs A2 any-line-closes. "Recommend A2." Reasoning: A1's protection "is illusory: freeform content is indent-free, so an embedded closer at column 0 … closes under either rule", and it "re-imports an indentation rule into the one construct whose purpose is escaping indentation."
  - (b) sameline fences: B1 implement vs B2 drop. "**Recommend B2.**" Reasoning: mid-line fence detection "collides with markdown-compatible prose, where a mid-line ``` is legitimately inline code-span content"; "Line-initial-only also matches CommonMark".
  - (c) info strings: C1 keep, whole rest of line preserved.
  - "Honest uncertainty" §1: "**Longer fences.** No position taken by spec or impl; probe shows ```` currently mis-parses (stray backtick `Text`). CommonMark's ≥-length closer rule is the principled nesting escape. Lean: *reserve* >3 backticks in the spec now (current behavior there is degenerate, so reserving costs nothing), implement later if `!:lang:` proves insufficient." And §4: "B2 removes the *only* mechanism for opening a freeform after sameline content. I found no use case that survives contact with the code-span collision, but this is judgment, not proof."
- **Bears on this question:** the first full statement of the sameline-fence cost/benefit, and the only place longer fences were discussed before 2026-07-28. (In the brief's recommendations, Joseph took (a) and (c) and overturned (b); see H12.) The proposal to reserve more than three backticks does not appear in any later spec text I searched (`spec/`, `v2/spec-*`, OPEN, DECISIONS: no hits for "longer fence", "four backtick", `~~~`).
- **Incidental:** the "fence promotion" meta point about Markdown fences in prose being promoted to structure. That is real and recurs (H22), but it is a Markdown-interop point.

### H12 — 2026-07-11 21:54 to 22:07 — Joseph decides: fences at head position, in either position

- **How I know:** `history.jsonl`, project `udon`, session `da5d1672`: 21:54:57, 21:57:23, 22:01:22, 22:02:21, 22:04:55, 22:06:04, 22:07:48 −0600. The records: `decisions/DECIDED.md` (now `_archive/DECIDED.bak.md`) entries D8 and D8-unify, commits `5fc2caf` (22:01), `50afb17` (22:02), `0259e1a` (22:04), `f8083c2` (22:06).
- **Speaker:** Joseph. Agent replies exist in the session vault (`v2/.archived/second-pass/spikes/session-vault/raw/claude/da5d1672-*.md`) and I quote none as Joseph's.
- **Words, 21:54** (answering an agent's "(b2)" recommendation; verbatim):

````text
Your recommendation for (b2) is ambiguous-- the spec is saying that the triple backticks need not start at column 1-- otherwise the parser would have no idea which element parent the fenced block is child to, and this differs from most markdown implementations. I'm fine having the rule simply be:  any line with 0 or more spaces (i.e., follow the indent stack) that starts with triple backtick starts a code fence (followed by whatever on that same line being captured and sent to the parser as part of the body-- so language name works etc.), and the same rule ends a code fence (except it should be followed by a newline although we may secretly allow whitespaces before the newline which get silently ignored), and the indent level is determined by the indent (as one would expect) of the starting one, and we recommend putting the closing one at the same indent level so if the fence is longer than a screenful the stuff underneath it will have a good idea of where the parent element's indent level is.

There is one possible shorthand that I'd still like to consider:

|a |b |c this is plain text
; equivalent to
|a
   |b
      |c
        this is plain text
---

so it would be nice iv |a |b (hold on, I'll finish this thought shortly-- harness issues are making it so I can't see what I'm typing)
````

- **Words, 21:57** (verbatim, layout as typed):

````text
|a
  |b
    ```rust
        some rust oh yeah
    ```

==

|a |b ```rust
  some rust oh yeah
```

Basically-- if the parser isn't already in free-text mode but rather is looking to see if the next thing is a sameline reserved indicator like | or : etc. -- then it also looks for ``` as if it were also the beginning of its own line.

We probably also need to make a note that the side-effect of indenting the closing fence is that the whitespace there is part of the result...
````

- **Words, 22:01** (verbatim; the opening double quote is never closed in the original): `Which is a unification-- "When in block mode (including sameline condensed) -- the following are special starts.... it's exactly the same as the comments rule, for example distinctly comments vs just part of the free-text.`
- **Words, 22:02:** `So you were right (if I was reading correctly)` then `|a |b hey there ```ruby   <---  definitely *not* a fence start-- already in prose mode`
- **Words, 22:04 and 22:06** (verbatim): "And there are necessarily a few characters of lookahead for the *actual* 'block-mode?' check-- for example, if the first character is followed by a space, or if the backtick isn't a set of 3 of them..." · `*Head position*  -- that needs to be a prominent part of the lexicon / spec---  specifies that we're still deciding if it's prose or block and includes same-line...`
- **What the record says was ratified** (D8 and D8-unify, agent-written): open = any line whose first non-space content is ``` ; "Everything after ` ``` ` on the opening line is captured as the start of the body — so language/info-strings come free, no separate info-string grammar"; close = any line whose first non-space content is ```, followed by a newline; the sameline fence is "an instance of" the one head-position rule for markers, "promoted proposed → RATIFIED"; the shorthand's boundary is head position only.
- **Bears on this question:** this is the source of *every* rule in the neutral file's "Current fence rules": indentation sets the parent; the fence may open on an element's line while the scan is still at head position; the rest of the opening line begins the body; byte-exactness ("the whitespace there is part of the result"); any-indent closing; and the fact that the brief's B2 (drop sameline fences) was *not* adopted. His answer to B2's Markdown code-span collision is the head-position rule: once prose starts, backticks are literal (22:02 message).
- **A caution about his examples:** the 21:54 message is about the fence rule and about a shorthand for `|a |b |c` nesting at once (that is question 01's territory). The `|a |b ```rust` example illustrates only the fence recognition. The shorthand he "hold[s] on" to finish is not this question.
- **Incidental:** `'`-as-escape removal (22:04), "head position" as a lexicon term (22:06).

### H13 — 2026-07-11 23:51 to 23:59 — Joseph on the closer's leading whitespace

- **How I know:** `history.jsonl`, session `da5d1672`: 23:51:51, 23:54:55, 23:58:52 −0600. Commits `b8ab375` (23:55), `f68c1a2` (23:57), `ac54086` (23:59).
- **Speaker:** Joseph; commit messages by the coordinator.
- **Words:**
  - 23:51: "Would you make sure your decisions about the fence opener and closer and what's already in the spec / spec-todo are exactly in line with my paragraph about it earlier and let me know what if anything is different?"
  - 23:54: "(note that I also stated later that we need to warn that one side-effect of an indented closing fence is that those whitespaces are part of the fenced text that gets output. (it is not automatically trimmed, unlike to the right of the closing fence, which we'll trim silently)"
  - 23:58: "(oh, and by "warning" -- I meant a warning in the spec-- not an output warning from the parser-- just to be very clear)"
- **What the record says was ratified** (commit `f68c1a2`): "the closer's LEADING whitespace is part of the fenced body output (NOT trimmed) — warn authors that indenting the closer injects whitespace into output; only the closer's TRAILING whitespace (right of ```) is silently trimmed. This reverses my earlier 'micro-edge' note, which wrongly said the closer's leading whitespace is consumed as terminator."
- **Bears on this question:** this is the rule the neutral file's Q2 ("an indented fence carries its indentation into the body") rests on. See "Threads" T4: the current parser and CORE's wording do not obviously do what this ratification says.

### H14 — 2026-07-11 — vivarium adopts a "verified safe subset": no fences

- **How I know:** `~/src/arch/vivarium/doc/PROCESS.udon` lines 138-143, added in vivarium commit `5b92773` (2026-07-11), "docs: front doors rebuilt for the new tree; norms + toolchain instituted".
- **Speaker:** an agent writing a norm in Joseph's repo, after a parser reconnaissance on the same day.
- **Words:** "author within the verified safe subset (recon 2026-07-11): … raw blocks via !:lang: never triple-backtick fences; no @-references; never start a prose line with a bare colon …"
- **Bears on this question:** the estate's first consumer norm about code blocks preferred `!:lang:` over fences, on the day fences had the defects in H11. That was a reaction to bugs, not a design statement, but it is the start of the practice that H23 later records as a "practice candidate".
- **Incidental:** the rest of the safe subset.

### H15 — 2026-07-13 22:37 and 22:39 — Joseph: fences in every head position, including after an attribute value

- **How I know:** `history.jsonl`, session `da5d1672`, 22:37:06, 22:37:33, 22:39:36 −0600. Spec rewrite commits `8578e52` (22:35) and `3a28213` (22:43).
- **Speaker:** Joseph (correcting a spec draft an agent had just written).
- **Words** (verbatim, layout as typed):

````text
Hold up, I think the intent was that triple back-tick fences were valid in every head position, so:
|a
  here is prose
  |and a child node
  and more prose
  ```text and a fence beginning
  ``` ; fence ending

|a here is prose
   this is also prose
     ``` this is also prose because only the column aligned with the first column of the prose is a head position
````

  then: "What you say in the spec that I saw scroll past was relevant for same-line head positions", then

````text
|a |b :a value ```this starts a code fence because it was a same-line head position
|a |b but not ```this one
````

- **Bears on this question:** the fullest statement of *where* a fence may open: any line-start head position (even after prose lines), any sameline head position (even after an attribute value), never after prose has started on that line, never in a column deeper than the current prose's. Note his second example puts the fence after `:a value`: as a sameline head position, not as `a`'s value (the mainline reading is that it becomes a child; see H16, H27 and T3).
- **Caution about his examples:** these mix the fence rule with the attribute syntax `:a value`; the point is only the head-position status of the token after the value.
- **Incidental:** the `'` and `@` marker messages at 22:41.

### H16 — 2026-07-15 15:05 to 15:07 — Joseph: raw and fence as attribute values; the Dec-2025 "typed scalars" rule is retired

- **How I know:** `history.jsonl`, project `udon`, session `18aabafc`, 15:05:07 −0600; the note `design/attribute-model-2026-07.md` (commit `dbcb10a`, 15:07:18); `spec/msc/CHANGELOG.md` 0.9.0-alpha.1 ("Attribute values may be nodes, text blobs, or segment arrays — edges may terminate at nodes; 'attributes are typed scalars' is retired").
- **Speaker:** Joseph (15:05); the note and changelog are agent-written.
- **Words** (verbatim, in the middle of a long message about references and blank lines):

````text
|element :one 123
  :two @other[xyz]  ; the more practical and likely usage because user/app doesn't have to overload/route/duck-type

  :three !:normal: ...   ; valid
  :four ```also-valid 

and so forth... Do you see any problems there? (basic sameline usage w/ the "attaches differently if started with an attribute" rules already discussed)
````

- **What the agent's note says was resolved:** "A value is: a scalar, a reference, an interpolation, or exactly one node (element / raw / freeform), or a text block", with `:four ```also-valid ; freeform-node value (opening-line remainder = body)`. "The one interaction, resolved by line-rooting: block-requiring value forms (node/raw/fence) bind to the attribute **only on attribute-rooted lines**. On element-rooted lines the existing sameline meanings stand — `|a |b :k v ``` ` opens a fence as b's *child* (ratified fixture `freeform_sameline_after_attrs`), and elements after attrs are the element's children." A later note (`attribute-model-2026-07.md` "semantic-`?`" alternative) says attributes *with values* are "untouched" by any change to flags.
- **Bears on this question:** this is where "fence/raw as an attribute's value" was introduced (reversing H6). It is the source of the neutral file's Q1 and of "sameline binding" in question 01. His own phrase, "attaches differently if started with an attribute", names the distinction the mainline implementation then makes: a fence right after an *open* attribute (`:script ```sh`) is that attribute's value; after a *finished* value (`:k v ```txt`) or a flag it is a child. Sibling file 01 reports the same mainline fixture and the agent's "b's child" statement.
- **Caution about his example:** the message is mostly about references as values; the `:three`/`:four` lines are illustrations of the taxonomy, sitting next to `:two @other[xyz]`. That `:four ```also-valid` has an open attribute and *no* body in the example is incidental.

### H17 — 2026-07-16 16:02 — Joseph: the same-line tail after `!:lang:` is a plain bug

- **How I know:** `history.jsonl`, session `5d686e10`, 16:02:42 −0600; commit `60e88b4`, 2026-07-16 16:19 −0600; `spec/msc/CHANGELOG.md` "Added (2026-07-16, Joseph — ruled a plain bug on both sides)".
- **Speaker:** Joseph; coordinator implementation.
- **Words:** "I think we can consider !:lang:...the-body-has-already-started...\n   not getting picked up just a plain ol' bug. If the specification says nothing is allowed same-line there then that is a bug too (unless I'm forgetting a good reason for it)."
- **Context:** the coordinator's report just before it listed "same-line text after `!:lang:` is silently dropped from the event stream — probe-confirmed, the only known keep-everything violation, latent since 0.8, with a live instance in vivarium's PROCESS.udon (a reflow put `!:lang:` at line start and the sentence's tail vanishes)".
- **What the record says was ruled:** "`!:lang: tail` captures the tail as the body's first content (whitespace after the label's closing `:` separates; the tail does not establish the raw base — same shape as fences and sameline prose; uniform in node-value position)." Fixtures `raw_block_node_value_sameline_body` (`|el :script !:sh: make build` → RawContent "make build\n") and `raw_block_node_value_sameline_body_plus_block`.
- **Bears on this question:** this is the one place in the record where a *same-line body being captured* was itself the issue. It is the strongest candidate for the phrase "same-line capture" in its literal sense (see the "sameline capture" thread below). It concerns `!:lang:`, which lite reserves; the equivalent fence behavior (rest of the opening line begins the body) was already H12.
- **Incidental:** the vivarium re-scan and reflow advice.

### H18 — 2026-07-18 — vocabulary: "fence" versus "freeform"

- **How I know:** `history.jsonl`, session `fb57249f`, 12:36:14 and 12:37:04 −0600.
- **Speaker:** Joseph.
- **Words:** "I see a "UnterminatedFreeform" how is such a warning ever possible?" then "(oh, maybe ``` is freeform? I always call it fence but can change my mental vocabulary :-) )"
- **Bears on this question:** the neutral file and Joseph both say "fence". The spec vocabulary was "freeform" until the 0.9.1/0.10.0 suites (`GLOSSARY`: "'Raw,' 'freeform,' and 'blob' as free nouns are retired in favor of this family").
- **Incidental:** the warning-code work on the same day (fences are *delimited*, so an unclosed one keeps content and warns, `UnclosedFreeform`; block `!:lang:` is geometric and has no unclosed state). CORE "Line-boundedness" (2026-07-18) settles fences as multi-line.

### H19 — 2026-07-19 11:52 — Joseph on verbatim text inside `<…>`

- **How I know:** `history.jsonl`, session `305776aa`, 11:52:06 −0600.
- **Speaker:** Joseph.
- **Words:** "Saw this: … Actual looks like what we should expect-- inner text verbatim -- including the two newlines" (pasted: input `|el :k <abc⏎⏎  def>`, expected `BareValue "<abc\n  def>"`, actual `"<abc\n\n  def>"`).
- **Bears on this question:** adjacent to Q4-C. It is Joseph's statement that a `<…>` envelope carries its interior *verbatim, newlines included*, and that the interior spans lines (closing only on `>` or EOF, ruled 2026-07-18). It says nothing about code specifically.
- **Incidental:** the parser test it arises from.

### H20 — 2026-07-19 to 07-22 — greenfield rewrites and the 0.9.1 suite consolidate to "the verbatim family"

- **How I know:** commits `4bfb91e`, `192e051`, `09fd522` (2026-07-19/20) for the clean-room specs in `v2/.archived/first-pass/`; `84454be` (2026-07-22) for `spec-0.09.01/CORE.md` §10.
- **Speaker:** agents (commit messages name "grok and gemini and fable" for the greenfield work), consolidation by an agent under Joseph's ruled rows.
- **Words** (0.9.1 CORE §10): three forms, one family: block `!:label:` (geometric, dedent, "to the body's first-content-line column"), fence (delimited, "none — byte-exact"), inline `!{:label: …}` (delimited, balanced `}`). §10.3: "A fence opens at any Structure Position — line start or in the Line Scan after elements and attributes — never after the line has committed to prose, never deeper than an established content base… everything after the opening backticks begins the body (an info label for free)… Use a fence when byte-exactness matters (assembling files without indent control, broken tooling); use `!:lang:` for ordinary code samples."
- **Bears on this question:** every 0.9.x/0.10.0 statement of the fence matches H12/H13 in substance. The "use a fence when byte-exactness matters" sentence carries H3's original purpose. The greenfield rewrites I looked at (2a, 3a, 3b, and the `greenfield` corpus) all kept the fence as a member of a verbatim family, and the ones I saw model it as a node value (`NodeValue = Element | Verbatim`); I did not read all of them.
- **Incidental:** the model vocabulary.

### H21 — 2026-07-21 — a demand-side witness: declarative structure with a code escape

- **How I know:** `v2/udon-needs/01-ideation/02-provenanced/commentary/I4-genre-seeds-witness.md` (gathered 2026-07-21).
- **Speaker:** agent commentary on Dec-2025-era example files by Joseph's tooling agents.
- **Words:** "Across all five resource/agent-domain seeds … the same shape recurs: a **declarative UDON structure with an inline fenced escape into a real host language** (`!:ex:` Elixir, `!:rb:` Ruby) placed *exactly where the declarative layer runs out**…" and its own caveat: "all one author, so coherence not corroboration".
- **Bears on this question:** the demand for code inside UDON documents, described by an agent. The example spellings are `!:lang:`, not fences.
- **Incidental:** the agent-coordination content of the seeds.

### H22 — 2026-07-28 — measured: fence knot and Markdown interop

- **How I know:** `v2/theory/to-integrate/refine-more/markdown/fence-knot-table.md` and `commonmark-non-conflict-table.md` (run 2026-07-28, commit `1e75f3f`), by an agent; reference parser at `core/` HEAD.
- **Speaker:** agent (measurements); Joseph's response is H23.
- **Words (fence-knot bottom line):** "UDON's ``` fence is exactly three backticks and has no length variation. The first three backticks open; a fourth becomes the first byte of the info string. So markdown's universal nesting escape hatch — open with more backticks than the content contains — does not exist here." "It does not fail loudly. Attempting it produces plausible-looking but scrambled structure … and one late `UnclosedFreeform` Warning at EOF, far from the cause." "The escape hatch that does work is `!:label:` block verbatim. Being geometric (dedent-closed) rather than delimited, no interior content can close it." "No divergence found in this probe. Every fence behavior measured matches CORE §10.3 as written. The pain is a design consequence, not a bug." Also: `~~~` is inert to UDON (case `f07`); a fence indented past an established content base is literal (`f06`), "only inside an element, since document root has no content base". (Non-conflict table): across CommonMark's 652 examples, "No CommonMark construct in the corpus triggers any UDON structure except the fence": 32 of 652 at document root, 27 embedded, are recognized as UDON fences; five of the root-level fence recognitions (`cm263`, `cm278`, `cm318`, `cm321`, `cm324`) "are markdown fences indented inside list items. At root, with no base, the indented ``` sits at a structural column and opens a fence" (the same gap is `ROOT-BASE` in `v2/OPEN.md`, and is reported in sibling 04).
  Its "suggestions", marked INFERRED by the author: the length-variation absence "could use one explicit spec sentence"; `.fmt-mdignore` "may be treating a symptom" (the repo writes nested examples with four-then-three backticks, "the one construction that cannot work").
- **Bears on this question:** this is the only measurement of Q3 (backticks inside code) and of the Markdown-collision face of Q1-Q4. The tally says fences are where a Markdown document and a UDON document meet, for good and ill.
- **Incidental:** the non-fence residue (line-initial `\`, tabs, indentation absorbed).

### H23 — 2026-07-28 21:54 — Joseph on `!:quote:`; the "prefer block verbatim" practice candidate

- **How I know:** `history.jsonl`, session `f9626a5b`, 21:54:33 −0600. The record: `v2/theory/to-integrate/primary/DISCUSSION-THOUGHTS.udon`, `|practice-candidate[prefer-block-verbatim-for-embedded-grammars]`, commit `e2b3fcf` and neighbours.
- **Speaker:** Joseph (the message); agent (the record).
- **Words** (Joseph): "Yes, I loved your !:quote: usage-- a very good candidate for "best practices" one day, and also one that disolves tension discovered in or rather being adjudicated in the spikes on markdown<->udon interchange."
- **Words** (the agent's record, status `candidate`, `:by joseph`): "Embed foreign or verbatim material — quotes, markdown-bearing text, code, anything carrying live-looking syntax — in geometric block verbatim (`!:label:`) rather than backtick fences, unless byte-exactness is the point. Why it works: geometric extent has no printed closer to collide with, so there is nothing for embedded content to prematurely terminate."
- **Bears on this question:** the neutral file's Q4 cites this as "0.10.0's recorded practice candidate". Joseph's own words are only the quoted sentence; the candidate's wording and the `:by joseph` attribution are the agent's compression of his reaction. Its scope is *embedding foreign material* (Markdown-bearing text, quotes), not code samples in general.
- **Incidental:** the rest of that session (de-facto schemas, extractor limits).

### H24 — 2026-07-29 14:57 — Joseph, on an array body's closer, by analogy to the fence closer

- **How I know:** `history.jsonl`, session `a71efbe5`, 14:57:12 −0600.
- **Speaker:** Joseph.
- **Words:** (about arrays opening a block-mode body)

````text
:some-attribute [
   <123>
   |another-child
     and some text in the heterogenous array's element
   and some text in the array itself
]  ; don't know -- probably same "guidance" as closing ``` -- end it where it will make the next lines clear about their parentage if you can....
````

- **Bears on this question:** a one-line restatement of the closer's principle (put it where it makes the parentage of what follows clear), which is the H12 recommendation. Note that it is about `[`…`]`, and is offered as a guess ("don't know").
- **Incidental:** everything else in the message.

### H25 — 2026-08-08 to 08-11 — K9/K16 and the three forms

- **How I know:** `v2/DECISIONS.md` rows K9, K10, K16 and the S11 overturn row; `v2/theory/to-integrate/lexical-forms-matrix-2026-08-11.md`; `history.jsonl`, session `6ce33695`, 2026-08-09 11:28:34 and 2026-08-11 10:43:52 −0600.
- **Speaker:** Joseph (the two prompts); agents (the ledger and matrix).
- **Words** (Joseph, 08-09 11:28): "I guess that starts to help crystalize me that there are / should be probably three distinct forms of many things. block/geometric, value, and embedded (or maybe it's embedded-value...) distinctly embedded in prose, where at least I have continued to loosely conflate value-form with embedded-form... (this is me thinking out loud, not necessarily asking for any resolution etc.)" (08-11): "Can you help me find where that table landed we were working on that had geometric vs. value vs. embed (etc.) for all of the main constructs?"
- **Words** (the 08-11 matrix's row for this question): "**Verbatim** | two forms: `!:kind:` (geometric) · fence (delimited) | `!:kind: body here` (same-line body); fence openable mid-scan | ruled, both spellings — `!:kind:` node value · `!{:kind:…}` *is the value* at any value-expected position (K9/K16) — spellings still borrowed". K10: a fence is one of the "framed markers" that ends an unquoted text value and resumes the scan.
- **Bears on this question:** the "block/geometric, value, embedded" lens is the frame under which the neutral file's Q4 (a geometric raw block with a lite-legal spelling) is asked. Joseph's message is thinking out loud about `@<{…}>`, not about code; it is included only because it is his statement of the three-forms idea.
- **Incidental:** the reference-value spelling debate.

### H26 — 2026-08-27 — 0.10.01 draft: fence kept, geometric raw re-spelled

- **How I know:** `v2/spec-0.10.01/` (commits `4c36510`, `adcb185`, 2026-08-27), `DELTAS.md` row 14, `CORE.md` §9.3, `NUANCE-AUDIT.md` rows and §2, `SEMANTICS.md` §4; `working-notes/AUDIT-2026-09-01.md` A1 and C4.
- **Speaker:** one Fable session (PROPOSAL DRAFT, single-author, unratified per `WHERE-THINGS-STAND`).
- **Words:** DELTAS 14: "**Block capture `<kind:`; in-flow capture dropped** … geometric capture spelled from the capture family (`<kind:` at Structure Position); `!:kind:` optionally retained as a migration alias; the in-flow form dropped pending demand (prose already carries code opaquely; value/block captures cover data)". NUANCE-AUDIT §2: "Fences. Byte-exactness is a real promise no other capture geometry makes (no dedent — even the *geometry* is content). The family holds only by letting one member opt out of the family's one shared behavior. Alternative — fences as their own material kind ('held bytes') outside captures — was rejected here for family-count economy, not principle. Genuinely unresolved." Fence rules kept "convention, kept": "opens at any Structure Position; closer at any indent; byte-exact".
- **Words, AUDIT A1** (2026-09-01): "The geometric capture is unreachable as an assignment value — a regression vs 0.10.0 … 0.10.0's `|el :script !:sh: make build` … has no 0.10.1 spelling … a code body that must now go through `<py: …>` closes at the first `>` in the code (`if a > b:`)… the body of a comparison-heavy program is un-writable except via fence." A1 also notes "the fence still works (its opener is not `<`)". C4: "Fence closer detail dropped: 0.10.0 §10.3 'the closer must be followed by its line end' … Draft §9.3 … silently widens the closer."
- **Bears on this question:** the only place in the record where the geometric block form and the value-position capture for code were *re-spelled* and what that costs (A1, the `>` problem) was measured. It is the direct source of Q4-B/C. The fence was kept precisely because byte-exactness "is a real promise". The draft was later called a misfire (H27), so treat its spellings as one agent's proposal, not as accumulated decision.
- **Incidental:** the generator and reference material in the draft.

### H27 — 2026-09-01 19:51 to 19:59 — Joseph on "the verbatim capture"

- **How I know:** `history.jsonl`, project `v2`, session `cdbd2a91`, 19:51:26, 19:53:32, 19:54:41, 19:55:48, 19:59:09 −0600; `v2/JOSEPH-FOR-0.10.01-FIX.md` (committed 2026-09-21, "Attempt some 0.10.01 fixtures and work", `9f69f42`).
- **Speaker:** Joseph; the FIX file's text is the agent's (per `WHERE-THINGS-STAND`: "The text is the agent's, not Joseph's").
- **Words** (Joseph):
  - 19:51: "So... seems like 0.10.01 mostly renames the parser to recognizer, says it doesn't do things *on purpose* instead of warning that nothing will handle it, and viola. Except it doesn't seem to work well for the verbatim capture you say?"
  - 19:53: "So was the agent confused about delimited forms vs geometric/block forms?"
  - 19:54: "Ugh, so much jargon and changed terms for such a simple thing, and the one thing that's not obvious is the thing that's broken."
  - 19:55: "All three things were my suggestions early on before any of the theory."
  - 19:59: "It's not like there's a ton of theory even. I'm going to call 0.10.01 a misfire. (which is unfortunate, but also why we might not want to spend too much time on fixtures for it). Do you have a clean proposal that you can explain to me in udon -> ast (to skip the exponentially exploding jargon)?"
- **Words** (agent, `JOSEPH-FOR-0.10.01-FIX.md` §5 "Code bodies"):

````text
|ex
  !:python:
    if a > b:
      print("| not udon")
  ```sh
  make build
  ```

element ex
  ├ verbatim python  "if a > b:\n  print(\"| not udon\")\n"
  └ fence    sh      "make build\n"

Block verbatim dedents to its first line and closes by dedent; the fence is byte-exact and closes at ```. Both work as an attribute's value: `:script !:sh: make build`. This is the part 0.10.01 broke; here it is simply kept.
````

- **Bears on this question:** "the verbatim capture" that Joseph says "doesn't seem to work well" is, by the agent's account (A1), the code-block-as-attribute-value form. His "delimited forms vs geometric/block forms" question is the axis Q4 turns on. I did not find a Joseph statement saying what he would want the *lite* rule to be.
- **A discrepancy in the record:** the FIX file's example puts a fence at column 2 with a body line `  make build` and shows the tree body as `"make build\n"`, i.e. dedented. Under the byte-exact rule (H8, H12, 0.10.0 §10.3, the neutral file's first example) the body would be `"  make build\n"`. This is the only place in the record where an indented fence's body is shown dedented.
- **Incidental:** the other seven sections of the FIX file (interpolation, references, generators).

### H28 — 2026-09-29 17:55 and 18:18 — "sameline capture"

- **How I know:** `history.jsonl`, session `5930da5d`, 17:55:23 and 18:18:03 −0600.
- **Speaker:** Joseph.
- **Words, 17:55:** "It seems to me there are still some (*possibly*) still open things to look into, like better markdown-like tables, or making sure that sameline capture works, or what if any special <..> should be part of lite …"
- **Words, 18:18:** "So I'm really not worried about "Making sure same-line capture works" (not sure what you're quoting there)."
- **Bears on this question:** the phrase "sameline capture" is in Joseph's own 17:55 message. Nothing else in the index uses that exact phrase; what it referred to is not stated. See "Threads" for the candidate meanings the history offers. His 18:18 reason for not worrying is that lite is close to mainline, which "already [has] a lightning fast recursive descent declarative grammar definition", so a bespoke parser is not the route.
- **Incidental:** the tables and `|---|---` comments.

### H29 — 2026-09-29 — what the current reference parser does, and what the live corpus contains (my own observations)

- **How I know:** run today on `core/` at repo HEAD (0.9.0-alpha.2 grammar; `cargo run --example stdin_parse`, printing events). The census: `grep` for `^\s*` + triple backtick and for `!:kind:` across the live `.udon` files (the four documents in `CONSUMERS.md`; a scan of all `.udon` under `~/src` outside `udon/`, `_older`, `_ref` found no others).
- **Speaker:** me; mechanical output.
- **Events observed** (text summarized, not bytes):

| input | events |
|---|---|
| `\|code⏎  ```⏎  line one⏎  ```⏎` | Element code → FreeformStart → Text `"  line one\n"` → FreeformEnd. The closer's own two leading spaces are **not** in any Text. |
| `\|job :script ```sh⏎make build⏎make test⏎```⏎` | Element job → Attr script → FreeformStart → Text `"sh\n"`, Text `"make build\n"`, Text `"make test\n"` → FreeformEnd. The info string is the **first body Text**; there is no separate kind. The fence follows the open `Attr` directly (node value). |
| `\|job :script ```sh⏎  make build⏎  ```⏎` | as above, second Text `"  make build\n"`: indentation kept. |
| `\|el :k v ```txt⏎body⏎```⏎` | Attr k → BareValue v → FreeformStart → `"txt\n"`, `"body\n"`. The fence comes *after* a finished value. |
| `\|a \|b ```rust⏎  some rust oh yeah⏎```⏎` | Element a → Element b → FreeformStart → `"rust\n"`, `"  some rust oh yeah\n"` → FreeformEnd → ElementEnd ×2. |

- **Live corpus:** four live documents contain code blocks. In total seven `!:kind:` blocks (`!:md:` ×4 in vivarium's `LEXICON.udon` and `DECISIONS.decision-log.udon`; `!:sh:` ×1 and `!:lang:` ×1 in vivarium's `PROCESS.udon`, where the `!:lang:` at line 143 is the accidental prose-to-directive promotion `CONSUMERS.md` records; `!:text:` ×1 in the ASF process map) and **zero** fences. The Dec-2025 teaching examples in `design/examples/` contain fences (`minimal.udon` 2, `cheatsheet.udon` 1, `comprehensive.udon` 2); the cheatsheet's is `|raw ```⏎literal |pipes and :colons⏎```` (a sameline fence at an element slot with a column-0 body).
- **Bears on this question:** the parser facts feed T4 and T5 below. The census is the only demand-side count I can offer: the estate's authors have not chosen fences in live documents, though two of the Dec-2025 teaching examples use them.

---

## Threads worth noticing

*These are my own reading, not the record's. Each one points back to the entries above.*

**T1. The fence has served at least four jobs, and the decision file has one job in mind.**
(a) Escape from indentation for assembling text without indent control (H3, H12; "when byte-exactness matters" in every spec since). (b) The base that a block-raw shorthand was defined against (H5). (c) The Markdown code block, kept identical on purpose to Markdown for conversion and for authoring habit (H9, H22). (d) An attribute's node value (H16). Which of these lite needs is not settled by the record; the neutral file's Q2 and Q3 are about (a) and (c) respectively.

**T2. A recurring pattern: the block form and the fence keep being separated by *what closes them*.**
The record's real distinction is geometric (dedent-closed: `!:lang:`, and from H7 "exactly like a block comment") versus delimited (printed closer: fence). Every one of the fence's nesting problems (H22) and both of its byte-exact properties (H8, H12) follow from delimitedness; the block form's absence of them follows from geometry. The 0.10.01 audit found the third combination (value-position capture, closed by `>`) worst of both. Q4's alternatives are all attempts to get geometry without `!`.

**T3. "Fence right after an open attribute" versus "after a finished value" is a distinction the mainline makes and the neutral file's Q1 example sits on one side of.**
`|job :script ```sh` (H29 row 2) binds the fence as `script`'s value; `|el :k v ```txt` (row 4) is the same tokens with a finished value and yields a child. H16 shows Joseph naming this ("attaches differently if started with an attribute"). For lite, any rule about fence-as-value implies the same open-vs-finished rule for fences, and — by K10 — for `:go? ```` (flag) as well (mainline fixture `flag_then_raw_block_is_child` for the raw form). I did not find a source stating what a fence at an element's own slot (`|job ```` with no attribute) is under K9's `$main` model; sibling 01 discusses `$main` and reports the fence case was answered "child" in July.

**T4. Three statements about the closer's leading whitespace do not agree, and I could not find where they were reconciled.**
(i) Joseph, 2026-07-11 (H13, verbatim): the closer's leading whitespace "is part of the fenced text that gets output"; ratified (commit `f68c1a2`) as "LEFT of the closer … IS part of the fenced body output". (ii) CORE §"Triple-Backtick Escape" and 0.10.0 §10.3 text: "the body runs to the newline *before* the closer, so that indentation was already body" and "Indentation *of* the closing line was already body on the preceding lines — put the closer at column 0 unless that indent is wanted." (iii) The observed parser and the fixture `freeform_closer_any_indent` (H29 row 1): the closer's leading spaces are not in any Text event. (i) and (iii) differ on a concrete input; (ii) reads as if it agrees with (i) but its own sentence describes (iii). The neutral file's Q2 says "byte-exact means an indented fence carries its indentation into the body", which is true of the *body lines'* indentation but not (on the parser I ran) of the closer's. Whether that is a wording issue or a behavior gap I cannot tell from here.

**T5. Info string: the mainline wire says "body", the 0.10.0 model and the neutral file say "kind".**
D8's stated purpose (H12) was to remove a separate info-string grammar ("retires spike-defect #14, multi-word truncation, by construction"); the wire still emits it as the first body Text (H29 rows 2, 5), and the fixture is named `freeform_info_string_is_body`. 0.10.0's `MODEL` has `Verbatim = { form, kind, body }` and the neutral file's trees split `sh` from the body. Multi-word info strings (`rust ignore`) are the case where "kind" and "first body line" differ visibly. The record has no Joseph statement on which reading he wants at the AST level.

**T6. Longer fences and `~~~` were raised by agents and never ruled.**
H11 (an agent's "reserve >3 backticks now") never landed; H22 measured the consequences. I found no Joseph statement on either, and no spec sentence. The neutral file's Q3 is the first place all three options (A/B/C) are set side by side.

**T7. Nobody proposed stripping the fence's indentation before today.**
The record is uniformly byte-exact (H8, H12, H13, H20, H27's "byte-exact"). The Markdown rule (Q2-B) appears in H11's brief only in the context of CommonMark's *closer* indent and longer fences. Q2-C ("both, by spelling") is new. The one place an indented fence's body is *shown* dedented is H27's FIX example, which I read as an example slip, not a proposal, but I cannot rule out that the author meant it.

**T8. The Sep-1 "verbatim capture" and the Jul-16 "same-line body captured" describe two different problems that share a spelling.**
Sep-1 (H26/H27): the geometric capture as an *assignment value* had no spelling. Jul-16 (H17): a same-line tail after `!:lang:` was *dropped*, a keep-everything violation. Both concern `!:kind:` in the node-value position and both are moot in lite as written (`!` reserved), which is why the neutral file's Q1 restates the question for fences. What lite loses is not the capture but the only spelling that had been fixed for both problems.

**T9. The neutral file's Q1 example has body starting on the opening line's next line; the record's own same-line-body precedent is `!:sh: make build`.**
For fences, "everything after the opening backticks begins the body" (H12) means a `:script ```make build` opener would carry `make build` as first body text, the same *shape* as H17's `!:sh: make build`. I found no source that writes a fence's body starting on the opening line as intended usage (the info string uses that slot).

**T10. The demand evidence is thin and one-sided.**
H14, H21 and H29's census point to `!:kind:` in practice and describe an escape into a host language; H4 (agents) called the fence a code smell; H9 and H22 tie fences to Markdown. Joseph's own statements about *why* a fence rather than a block form contain one purpose: byte-exact preservation (H8, H12; the fuller purposes list, assembling files and broken tooling, is H3's document text, not a Joseph message). None of the demand-side sources is independent of the author.

---

## What the neutral file misses

*Each item is either a fact from the history the file does not carry, or a place where its framing may not match the record. None is a recommendation.*

1. **"Sameline capture" is Joseph's own phrase (H28, 17:55).** The neutral file asks whether Q1 is what it refers to. The history does not say. The candidate meanings, each with evidence: (a) the same-line body of a code block (`!:sh: make build`, H17, "same-line body captured", Joseph 2026-07-16); (b) the "verbatim capture" Joseph says he could not see working on 2026-09-01 (H27), which the audit identifies as the block form as an assignment value (A1); (c) a fence opened on an element's or attribute's line (H3, H12, H16); (d) in 0.10.01's vocabulary, "capture" is the whole `<…>`/`<kind:`/fence family (H26), so "sameline capture" could also mean the value-position `<…>` form. Nothing selects among them.
2. **The "open attribute vs finished value" split (T3).** Q1's example is the open-attribute case. The other cases (`|el :k v ```, `|job ```, flags) are different rules in mainline, and the file's "A fence opens at … on an element's or attribute's line" hides that.
3. **The info string is body in the mainline wire, not a separate kind (T5).** The trees in the neutral file split it out.
4. **The closer's leading whitespace (T4).** The file says the byte-exact body carries the fence's own indentation; the ratified 2026-07-11 rule was about the *closer's* whitespace, and the parser I ran does something different.
5. **Head-position, not "structure position", is where fences open, and after prose has begun on the line the backticks are literal (H12, H15).** The file says "line start, or on an element's or attribute's line", which omits the boundary that keeps mid-prose backticks (Markdown code spans) safe. That boundary was Joseph's answer to the July brief's strongest objection to sameline fences (H11 B1/B2), and it is the property lite is relying on when it keeps them.
6. **Fences interleave with prose and children.** A fence opens at line-start head position even after prose lines and children, and prose can resume after (H15). The file's opening example shows only a fence as an element's sole child.
7. **The failure mode of Q3-A.** The file states that `~~~` is inert text today and that four backticks read as three plus a kind. What it does not carry (H22) is how the failure looks: the outer fence closes on the inner opener, the outer closer opens a new fence, and the only signal is one `UnclosedFreeform` at end of file, far from the cause. In H22's words it "does not fail loudly".
8. **Markdown collision is the main measured cost of fences in UDON documents (H22):** 27 of 652 CommonMark examples embedded in a UDON element, and 32 at root, are recognized as fences. The file lists Q3 as if the concern were code that contains three backticks; the larger measured effect is Markdown *prose* that contains fences in a UDON document (and, at root, indented fences inside Markdown list items, `ROOT-BASE` in `v2/OPEN.md`).
9. **The dedent difference between the two raw forms is the real Q2 axis in the record.** The block form dedents to its first content line (H7, `!:lang:`); the fence does not. Q4-B's "geometric raw block, non-reserved spelling" would inherit the dedent, so Q2 and Q4 interact (the file lists only 07 and 09).
10. **Live usage today (H29):** seven `!:kind:` blocks (one accidental) and no fences in live documents. The neutral file does not say what lite would leave the four live documents without.
11. **The December position that raw content cannot be an attribute value (H6).** Q1 assumes fence-as-value exists in 0.10.0; that was introduced 2026-07-15/16 (H16), reversing a rule Joseph stated on 2025-12-24. The reasoning for the reversal in the record is the "closed value taxonomy" note, not a statement of need.
12. **Layer note on Q3-B:** "Under 0.10.0, four backticks are read as three plus a kind starting with a backtick." In the mainline wire it is three plus a first *body* byte (T5); it reaches "kind" only if the AST splits the first line. Same fact, different layer.

## What I looked for and did not find

- Any Joseph statement on longer-than-three fences, `~~~`, or stripping a fence's indentation (Markdown's rule) before 2026-09-29.
- Any Joseph statement on what "sameline capture" means (the phrase appears once, in his 17:55 message).
- Any 2026-08-27 message from Joseph on the `<kind:` re-spelling (`history.jsonl` has none containing the search terms on that date).
- The Dec-2025 sessions' full text about the sameline fence in `SPEC.md` (H3); only the commit and Joseph's later messages.
- Anything on fences between 2026-01-14 and 2026-07-08; the project appears to have been idle.
