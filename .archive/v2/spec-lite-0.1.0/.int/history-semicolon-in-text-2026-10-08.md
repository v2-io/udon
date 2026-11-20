# Was there a reason for ` ; ` comments on text lines? — history, 2026-10-08

*Written by Claude (Opus 5.5), a history agent, on 2026-10-08, for the lite coordinator. The coordinator will relay it to Joseph.*

**The question.** Earlier today Joseph ruled that in lite a framed ` ; ` is a comment only on lines that start with an element or an attribute. A line that starts with `;` is a comment block, and a ` ; ` in the middle of a text line is text (`.int/STEWARD-VERBATIM.md`, the "I vote for strict-lean except ' ; '…" answer). 0.10.0 says otherwise: §2.2 and the §8 row "In block text **at** the content base | line comment". Joseph asked what rationale, if any, lay behind 0.10.0 making that comment available on prose lines.

**How this relates to the 09-29 history.** `pre-design/03-semicolon-in-prose.discussion.md`, the 09-29 history pass, already traces this question through 34 dated entries, and I re-checked its load-bearing quotes against the primary sources. This file does three things that pass didn't:
- It reads the **raw drafting transcripts**, where the 0.10.0 sentence and the §8 row were written. The 09-29 pass didn't open raw `.jsonl` transcripts.
- It finds the **answer to Joseph's 2026-07-19 question**, which the 09-29 pass couldn't find.
- It **measures the live corpus** for ` ; ` on text lines. That turned up the one thing here that cuts against today's ruling (§3).

**Labels used below:**
- **[J]** Joseph's own typed words, verbatim. I re-read each one from `~/.claude/history.jsonl`, `~/.codex/history.jsonl`, or the session transcript.
- **[A]** an agent's words, verbatim.
- **[D]** a document's text.
- *Inference:* my own reading.

---

## 1. Short answer

**Was there a reason?** I found no reason on record for making a framed ` ; ` a comment in the middle of block text. I looked for a ruling, an argued use case and a measurement, and found none of the three. Every rationale ever written for the framed form names the element line: `|li Item ; TODO`, "sameline", "trailing annotations". The 0.10.0 sentence that puts it in text-space came in as an unflagged step in a large rewrite. The rewriting agent's own reasoning (§2, 2026-08-09) carries the exception across by citing §8. The §8 row it leaned on descends from a row whose author meant a line that *starts* with `;` (§2, 2026-07-20). So on the evidence, the 0.10.0 wording **drifted in through drafting**. Today's ruling overrides no decision.

**What cuts against today's ruling.** Writers keep reaching for a trailing ` ; ` note on **row-shaped text lines**: table rows, and one-record-per-line lists under an element. I found three instances:
- Very likely Joseph himself, on 2025-12-23, annotating Markdown table rows in `comprehensive.udon`.
- Joseph's own chat examples on 2025-12-25.
- An Opus 5.5 agent yesterday, 2026-10-07, writing UDON by eye with no parser to check against. It wrote 15 annotated rows and said "I used comments".

Under today's ruling all of these notes become part of the text. That is a real cost, and nobody has weighed it. The live corpus also holds the opposite hazard: ordinary prose with ` ; ` in it, which 0.10.0's reading would silently cut off. So this doesn't overturn the ruling. It names the use case the ruling has to serve another way, most naturally with `;{…}`. Today Joseph gave a strong lean to making `;{…}` available in prose. §3 has the specimens.

---

## 2. Chronology

Entries marked **NEW** aren't in the 09-29 history. Entries without the mark are re-verified and condensed, and the 09-29 file has their full context. All times are UTC unless marked MT (Mountain).

### 2011 — the shape is there from the start (09-29 entries 1–3)
- **[D]** `~/src/_older/udon/examples/overview.udon`: the end-of-line comment is "only available in identity section", meaning the element's line.
- **[J]** 2011-12-15, `udon-c/docs/DECIDED.md`, on a comment at the end of a free-text line: *"and here is some normal text blah blah    #| comment even though I'm in freetext / meh... probably opens a can of worms..."* He left it undecided.

### 2025-12-23 ~18:14–18:57 MT — **NEW** — Joseph annotates Markdown table rows with trailing ` ; ` notes
- **[J]** 18:14 MT (`history.jsonl:5490`), on the agent's `|table` version of the example: *"That is absolutely incorrect UDON... but it's an example that keeps reappearing! (it has td's inside td's)"*.
- **[J]** 18:27 MT (`:5491`): *"I've begun tightening up comprehensive.udon some more."*
- **[J]** 18:39 MT (`:5493`): *"OK. I'm done cleaning up the comprehensive udon example now."*
- **[D]** Commit `b96cad0`, 18:57 MT, replaces that `|table` with a Markdown table. It is still in the repo at `core/examples/comprehensive.udon:422-427`:
  ```
    Current limits by tier:
    '| Tier       | Requests/min | Burst    |
    '|------------|--------------|----------|
    '| Free       | |{n 60}      | |{n 10}  |  ; It is assumed that inlines like |{..} are
    '| Pro        | |{n 600}     | |{n 100} |  ;   processed before any markdown rendering/processing
    '| Enterprise | |{n 6000}    | |{n 1000}|
  ```
  In late-2025 syntax, `'` at the start of a line was the text escape. Two days later he described `'` as working "like with the others". So these are **text lines** carrying trailing ` ; ` comments.
- *Inference, unverified:* the hunk is Joseph's hand edit. The timing fits, and the comment's voice reads as a design assumption. The session transcript was purged before the earliest backup (`~/.claude.bak.2026-01-26`), so I can't confirm it wasn't the agent's edit. The commit is co-authored by Opus 4.5.

### 2025-12-25 20:38 and 21:00 — **NEW** — Joseph's examples annotate prose lines, then three minutes later he rules `;{…}` "the only way"
- **[J]** 20:38 (`history.jsonl:5698`), in an example about indentation:
  ```
  |the-parent |on-line-child
        first-line-of-prose that is sibling to on-line (inner part of the-parent)
     but what about this one???  ; warning about changed indentation-- "did you mean to line it up with 'first-line' on line __?"
  ```
- **[J]** 21:00 (`:5701`):
  ```
  |element-bigger and some child text |and-another inner
                                This is also a direct child of element-bigger,
                                    just in a very unconventional spot. ; no warnings, extra spaces output with this line though
  ```
- **[J]** 21:03 (`:5702`), verbatim:
  > I would like to make one more change to the spec before we continue.
  > ; block comment (i.e., any time a line starts with this. **TRIGGERS INDENT/DEDENT BEHAVIOR** even though it is effectively blank output
  > ;{...}  inline comment -- the only way to do udon-level comments within prose.
- *Inference:* the ` ; ` notes in 5698 and 5701 work as **explanatory annotations in a chat example**. That is Joseph's habitual Lisp/Rebol margin note, not a claim about how UDON parses. Writing them and then, three minutes later, ruling that `;{…}` is "the only way to do **udon-level** comments within prose" looks like Joseph separating the two. I can't confirm that the examples prompted the ruling, because the agent's reply is in a purged transcript. Either way his own hand reaches for ` ; ` at the end of text lines.

### 2025-12-31 15:30 — Joseph states rule B, with a reason (09-29 entry 7)
- **[J]** (`history.jsonl:6428`): *"sameline prose is treated a little differently than block prose, even-- sameline prose doesn't set the indent-column position … so … it won't be a problem really to say that sameline prose also allows ';' comments at the end unlike block-level prose. Sameline comments should be allowed on attribute+value block lines as well…"*
- **[D]** Commit `7ac593b` writes it into `SPEC-UPDATE.md`'s table ("Block prose | **Literal** (not comment)"), with the reason *"Block prose … captures literal content including semicolons. This allows code examples, prose with semicolons, etc."*

### 2025-12-31 ~19:08 MT — Joseph's worked example (09-29 entry 9)
- **[J]** (`~/.codex/history.jsonl:1026`):
  ```
  |el :key and-this\;-is-ok this is prose ; and this is a comment
    this is also prose ; but this is not a comment
  ```

### 2026-01-02 18:56 — Joseph's full list of where comments can occur (09-29 entry 11)
- **[J]** (`history.jsonl:6837`): it has three entries: (1) `;` at the start of a line, which starts a comment block; (2) after a space on the element or attribute line ("sameline"); (3) `;{...}`. It has no mid-line ` ; ` in block text.
- **[D]** Commit `7003996` makes a mid-line ` ; ` in text literal at the root too: "Mid-line `;` in prose is now ALWAYS literal".

### 2026-07-15 — "sameline comment" ratified as an element-line form; "at the base column" means a line that starts with `;` (09-29 entries 15, 16, 18)
- **[J]** vault `18aabafc` :1968: *"It quite literally was a practical carve out that we forgot when we added more assertive language about the head-position prose."*
- **[J]** 21:51 (`history.jsonl:16335`): *"Comments after prose is already a sameline special convention... it's the one place I wouldn't mind enforcing ' ; ' but *only* if it is sameline (including, now, attribute-sameline) AND prose / text has already started (without quotes)...."*
- **[D]** The CORE sentence that came out of this is worded without a position: *"opens a line comment even after the line has committed to prose"*. "Commits" applies to every line (`spec/CORE.md:123`).
- **[D]** Same day: *"a `;` **at the prose base column** is a comment"* (`spec/CORE.md:800`). This came from the ruling that a line *starting* with `;` at the base column comments, while one starting deeper is text. The same file still says (`:763`) *"Block prose … preserves literal semicolons. Sameline prose … a whitespace-framed ` ; ` in it starts a comment"*, and keeps the example `this is prose of |el ; but this is not a comment` (`:922`).

### 2026-07-19 17:11 — **NEW** — the answer to Joseph's question "Does the spec currently say a sameline trailing comment needs ' ; '?"
- **[A]** (`~/.claude.bak.2026-07-22/projects/-Users-josephwecker-v2-src-udon/305776aa-….jsonl:~761`): *"Yes, with one asymmetry worth noting… a sameline comment is a `;` with **a space before it, and a space *or end-of-line* after it**."* Every example it gives is on an `|li` element line, and it names the exclusions (`\`-forced text, inside `|{…}`, an unspaced `;`). The 09-29 pass couldn't find this reply. It settles nothing about block text, but it shows that as of 07-19 nobody, Joseph or agent, was treating the framed form as a block-text form.

### 2026-07-19 20:36 MT — **NEW** — the table's row notes get moved to `;` lines when checked against the parser
- **[D]** Commit `926d786`, co-authored by Opus 4.8: "examples: modernize the shorter design examples to 0.9 … validated against the reference parser … Incidental, caught via parser validation: … the retired '-escape, … a stray Markdown-table apostrophe hack". In `design/examples/comprehensive.udon:458-461` the 2025-12-23 trailing row notes became a `;` comment block *above* the table:
  ```
    ; It is assumed that inlines like |{..} are processed before any
    ; markdown rendering/processing. A leading "| " is already always literal
    ; prose (pipe-space preserves Markdown table compatibility), so no
    ; leading apostrophe is needed to keep these rows out of element parsing.
    Current limits by tier:
    | Tier       | Requests/min | Burst    |
  ```
  The `core/examples/` copy kept the original.
- *Inference:* this is the B-world remedy, already applied once. Faced with a parser that treats a ` ; ` on a text line as text, the note moved to a line-start comment. It reads fine here because the note was about the whole table. A per-row note (§3, specimen 2) has no such home except `;{…}`.

### 2026-07-20 05:40 — **NEW detail** — greenfield 2a writes the row and means a line that starts with `;`
- **[D]** 2a's `SPEC.md`, as written in session `1601121c` (`~/.claude.bak.2026-07-22/…`, line 129). The §6.4 table:
  ```
  | After a finished value (framed ` ; `) | line comment |
  | In sameline text (framed ` ; `)       | line comment |
  | In block text at the content base     | line comment |
  | In block text deeper than the base    | literal      |
  ```
- **[D]** 2a's §6.2, the prose the row cross-refers to: *"A comment `;` **at** the content base is a comment, interleaving with the text; deeper it is literal (§6.4)."*
- **[D]** 2a §5: *"A framed ` ; ` opens a comment on element and block-attribute lines."*
- *Inference:* in 2a's own text, the framed rows say "(framed ` ; `)" and the content-base row doesn't. The content-base row is the 07-15 line-start rule, restated. But 2a §3.3 also generalized "commit" to every line with "exactly one exception — the framed sameline comment". That sentence is where the ambiguity lives.

### 2026-07-22 — 0.9.1 takes 2a's structure (09-29 entry 23)
- **[D]** §2.2:102 has the per-line "one exception". §6.6:374 says *"A framed ` ; ` opens a comment on element and block-attribute lines"*. §8:487 has the row.
- **[D]** It dropped the "not a comment" example and the "Literal Semicolons" table. Its DELTAS lists no change about `;`.

### 2026-07-28 — SEMI-BASE opened, measured, then deferred (09-29 entries 24, 25)
- **[D]** `OPEN.md:91`: *"markdown prose containing `" ; "` is **silently truncated** under CORE-as-written, safe under the parser. Both readings internally coherent."*
- **[J]** On the whole queue of open binary questions, SEMI-BASE included: *"These are open binary questions that shouldn't be asked yet on a spec that hasn't been written yet."*

### 2026-08-09 06:11 — **NEW** — Joseph, about 15 minutes before the 0.10.0 rewrite began, labels a block-text ` ; ` "not a comment"
- **[J]** (`history.jsonl:18888`, in session `6ce33695`):
  ```
  |element
    \   Those spaces to the left are preserved
        this has preserved spaces to the left as well ; and this is not a comment
        THAT's what "commit to text mode" was meant for.
  ```
- *Inference:* he gives the reason as "commit to text mode", not as a block-text rule. Under 0.10.0's own column-anchor idiom that line is *deeper* than the content base, so 0.10.0's table also calls it literal. The example is compatible with both readings and doesn't settle SEMI-BASE. What it does show is Joseph's expectation, written in the session that produced 0.10.0: a ` ; ` partway along a text line under an element is text.

### 2026-08-09 06:28 — **NEW** — the moment the exception moves into text-space
- The UNIF-PASS fork (session `6ce33695`, subagent `agent-a2a87c49aab940bdc`) was briefed with a "suspect-list rule". **[A]** from the brief: *"every pre-K9 sentence mentioning 'prose,' 'blob,' 'forced text,' or 'commits' gets rederived from the value-space model, never consolidated as-is."*
- **[A]** The fork's reasoning when it rewrote §2.2 (its thinking, line 15, 06:28:18Z), verbatim:
  > For §2.2's "Committing" section, I'm revising to clarify that element-rooted lines don't commit prose—the scan runs the whole line in value-space per K10—while non-structural lines at structural columns are text owned by that column, where marker characters are literal except for the framed ` ; ` per §8.
- **[D]** Result (`spec-0.10.00/CORE.md:108`): *"Within a text line, marker characters are literal, with the framed ` ; ` comment as the one carve-out (§8) — the old *commit* model, now scoped to text-space only."*
- It also rewrote the tutorial line *"One deliberate exception survives commitment"* as *"In prose, one deliberate exception: a semicolon **framed by spaces** is a trailing comment"*. Its only example is `|li Buy milk ; TODO check brand`, which under K9 is a value-space line, not prose (`TUTORIAL.md:52`).
- **[D]** The fork's question file for Joseph (`spec-0.10.00/working-notes/UNIF-PASS-QUESTIONS.md`) asks only whether a framed ` ; ` still ends an open value (Q4.2). It doesn't raise the text-space carve-out. DELTAS has no row for it.
- *Inference:* the rederivation the brief asked for was applied to "commits". Its output kept the exception and gave it a new home. The step went unremarked: there is no question to Joseph and no DELTAS row. In the same rewrite, §6.6:400 still says *"A framed ` ; ` opens a comment on element and block-attribute lines"*, so 0.10.0 contradicts itself. Its own README (line 16) says *"Behavior differences between this suite and the old text are exactly the ledgered rows in DELTAS.md — if you find one not listed there, that's a defect here."* By that standard the A-reading is a defect of the suite.

### 2026-08-27 → 09-01 — 0.10.1 carries the wording forward; its audit flags it (09-29 entries 32, 33)
- **[D]** 0.10.1 `CORE.md:70`: *"Markers are literal there, with the framed ` ; ` annotation as the one carve-out (§8)."*
- **[D]** `AUDIT-2026-09-01.md:97` D15: SEMI-BASE is still undisambiguated.

### 2026-09-30 00:38 — Joseph on his January note (09-29 entry 34)
- **[J]** *"saw my Jan note-- a good example of how far my thinking has changed from January! (on both doc root AND inline comments…"*. He typed it into the history subagent while it was reading the January material (`5930da5d/subagents/agent-a4671149…jsonl:250`).
- *Inference:* "inline comments" most plausibly means the January note's item 3: `;{…}` anywhere, even inside a name (`|ele;{hmmmm}ment`). I found nothing tying it to a mid-line ` ; ` in block text, and today's ruling is consistent with the January list anyway.

### 2026-10-07 — **NEW** — an Opus 5.5 agent writes annotated rows by eye
- See §3, specimen 2.

### 2026-10-08 — today's ruling
- **[J]** *"I vote for strict-lean except ' ; ' only counts as a comment when part of sameline and with at least one space on each side. Comments: available on node or attribute started lines, and available as their own block, which also comments everything in that block that is indented further…"*, with *"(d) passed through"* for `Keep calm ; carry on.`
- **[J]** The same exchange: *"I *do* think ;{...} comments, with essentially opaque spans inbetween with the same escape rules (matched {} and \ escape-all) as the others-- which *will* be available in prose. (strong lean unless someone has a reason it conflicts with something that is likely)"*.

---

## 3. What cuts against today's ruling: the live corpus

**What I scanned.** I scanned 414 `.udon`/`.ud` files under `~/src`. I excluded the udon repo itself, `_ref`, `_older`, `.git`, agent worktrees, `node_modules` and `target`; `.moved-and-integrated/` was included. I counted lines carrying a framed ` ; ` (whitespace before; whitespace or end of line after), outside ``` fences. This is regex by first character, not a parse. The scripts are in my scratchpad and aren't committed.

| Line starts with | Lines with a framed ` ; ` |
|---|---|
| a marker (`\|` `:` `!` `@`) | 750 |
| `;` | 7 |
| text | **25** |

The 25 text-line hits sort into two groups.

**Demand: a trailing note on a row-shaped text line** (17 lines in two documents).
1. `comprehensive.udon` table rows, 2025-12-23, very likely Joseph (§2): 2 lines. The hit is in the pre-umbrella copy under `.moved-and-integrated/`. The same text is live at `core/examples/comprehensive.udon:425-426`. The `design/examples/` copy was rewritten to a line-start `;` block on 2026-07-19 (§2).
2. `~/src/ai-risk-model/influx/thin-pass/notation/{sb53,oai,ant,ny-raise,xai}.ud`, committed 2026-10-07 (`0961af3`), 15 lines. The author is Claude Opus 5.5, per the README header. **[D]** `README.md`: *"The files follow the `def/` house style … by eye. The built udon parser (pre-0.8) warns on the existing `def/` files too, so it couldn't be used to validate these."* **[A]** `notes.md:93`, on attributing who asserts a relation: *"rows need a `:by` or a trailing attribution. I used comments."* A typical row, at the content base under `|resolutions[sb53]`:
   ```
   |resolutions[sb53]
     - R-cr-origin           P-sb53-bp-csi    "catastrophic risk" (limb 2)  => @{sb53.bp:catastrophic-risk}                   ; walk, within sb53.bp
     - R-foreseeable         P-sb53-bp-cr     "foreseeable"                 => -> ca-law:foreseeable ?                       ; delegated
   ```
   - Under today's lite ruling: each row is text that includes `; walk, within sb53.bp`.
   - Under 0.10.0's A-reading: text up to the ` ; `, then a comment.

   The writer clearly meant comments. (These lines also hold `@{…}` and `{a | b}`, so lite has other things to say about them. The ` ; ` question stands on its own.)

**Hazard: ordinary content that 0.10.0's A-reading would silently cut** (3 lines).
3. `~/src/arch/vivarium/.orient/answers.stub.udon:14` (agent-written prose). ` ; ` is clause punctuation, used so that each `#anchor` stays a separate token:
   ```
   |answer[P4]
     (register, edge log, stack, capture field). Where hints *appear* on the globe is #disc-explorer-human-chrome ; what a capture pair must record is #disc-explorer-debug-capture ; converting inventability failures into mechanisms is #norm-caught-disciplines-become-mechanisms .
   ```
   Under the A-reading, two-thirds of the answer becomes a comment.
4. `03-modifying.scenarios.udon` (the original and its provenanced copy in `udon-needs/…/copies/`): prose *about* UDON, `… sigil-leading blobs, framed ` ; ` in blobs, digit-leading strings like "0042")`. Under the A-reading the comment starts inside the backticks.

**Neither: Joseph's glosses inside a verbatim block** (5 lines). `DISCUSSION-THOUGHTS.udon:498-509`, his brainstorm words inside `!:quote:`, so never parsed: `- @[key] ; relies on key being unique for that dataset's kinds of`. Joseph writes ` ; ` as a margin gloss in his own prose by habit. Whether he means it as content or as a comment there is his call. It's the same habit as the 2025-12-25 chat examples.

*Inference, the honest weighing:*
- The demand isn't "comments in paragraphs". In every case it is a **note at the end of a line whose line is a unit**: a table row, or a one-record-per-line list. No specimen asks for a comment in the middle of flowing prose.
- The hazard specimens are flowing prose. That split gives today's ruling a clean way to serve the demand without A: `;{…}` in prose, Joseph's strong lean today. For example `- R-foreseeable … ;{delegated}` or `'| Free | … | ;{assumed: inlines before markdown}`. Another way is to make each row an element.
- The cost is real, though. The failure under lite is quiet: the note becomes visible content, with no error. Both writers who reached for it did so without a parser to tell them otherwise, and one may have been Joseph.
- If lite wants a guard, one idea follows from the history and is not a recommendation. A framed ` ; ` on a text line could earn a **warning** rather than an error or a comment, given the "keep everything, surface it" ethos. That's for the coordinator and Joseph to weigh against the vivarium P4 specimen, where such a warning would fire on legitimate prose.

---

## 4. My read

1. **No rationale existed for the 0.10.0 behavior.** Every stated reason for the framed comment names the element or attribute line. That holds for 2011, 2025-12-31, 2026-01-02, 07-15, 08-08, RATIONALE.md and NUANCE-AUDIT. The text-space placement shows up first as a derivation step in the 2026-08-09 rewrite, with no question to Joseph and no DELTAS row, and it contradicts §6.6 of the same suite. The §8 row it leaned on was a line-start row in its first author's own text. So today's ruling overrides an accident. Calling it a reversal of a decision would be wrong.
2. **Today's ruling matches Joseph's stated intent all through the record**, including his example written 15 minutes before the drifting rewrite.
3. **The ruling has one real cost, and the history shows it.** Writers, very likely Joseph in Dec 2025 and an agent yesterday, reach for a trailing ` ; ` note on row-shaped text lines. Lite should serve that on purpose. `;{…}` in prose looks like the natural carrier and is already Joseph's strong lean. A pedagogy line, "notes on table rows: use `;{…}`", would close the loop. If the coordinator wants a single example for Joseph, the `comprehensive.udon` table hunk is the one. It may well be his own, and it puts the whole trade-off in five lines.

---

## 5. What I searched, and what I didn't

**Searched:**
- **Raw transcripts in `~/.claude.bak.*/projects/`.** These are the older session files no longer under `~/.claude/projects`. I searched them with `rg` for the exact 0.10.0 sentence and the §8 row wording, then read the hits:
  - session `6ce33695` and the fork subagent `agent-a2a87c49…` (0.10.0);
  - `1601121c` (greenfield 2a);
  - `305776aa` (the 07-19 reply);
  - `5930da5d` and its subagent `a4671149` (the 09-29 remark).
- **Joseph's prompt logs**, scanned programmatically for UDON examples with a framed ` ; ` on a text line (`~/.claude/history.jsonl`, `~/.codex/history.jsonl`). That gave 6 hits; the relevant ones are quoted above.
- **memorata:**
  - `--joseph` since 2026-07-20 with four queries on annotations and on comments on prose lines. That surfaced only the 08-08 element-line message.
  - Agent classes for the 07-19 reply and the Dec 25 reply. The Dec 25 reply isn't indexed.
- **Primary texts:** `spec/CORE.md` (alpha.2), `spec-0.09.01/CORE.md`, `spec-0.10.00/{CORE,TUTORIAL,RATIONALE,README,DELTAS,GLOSSARY}.md`, `spec-0.10.00/working-notes/*`, `spec-0.10.01/CORE.md`, `OPEN.md`, and lite's `STEWARD-VERBATIM.md`.
- **Corpus:** the scan described in §3, plus `git log -S` and blame for the `comprehensive.udon` hunk.

**Not searched, or couldn't be:**
- The 2025-12-23 and 2025-12-25 session transcripts. They were purged before the earliest backup, so authorship of the table hunk and the agent's reply to 5702 stay unverified.
- Codex and Gemini raw session logs, beyond `~/.codex/history.jsonl`.
- 0.9.1's own drafting session (`f5f3ddc3`, 2026-07-22). I only confirmed that it read the row as input. I didn't read its reasoning, since 0.9.1 added no new wording on this point.
- The `def/` files in `ai-risk-model` (outside my scan's hits) and any `.udon` inside the udon repo itself (excluded by design).

---

## 6. Feedback on the brief, and things noticed on the way

- The brief was well aimed. Pointing at the 09-29 discussion file saved me re-deriving 30 entries, so the time went into the raw drafting transcripts and the corpus. If a future history brief needs the *reasoning* behind a drafting step, the place to look is `~/.claude.bak.YYYY-MM-DD/projects/…/<session>/subagents/*.jsonl`. Memorata indexes these, but `rg -F` on an exact phrase found the authoring turn much faster.
- `OPEN.md:91` (SEMI-BASE) says the parser honors the framed form "only … on an element's sameline tail". It also honors it after attribute values (`spec/CORE.md` Literal Semicolons table; fixture `comments.yaml`). This is minor, but it matters if anyone cites the row as a description of the parser.
- 0.10.0 `TUTORIAL.md:52` calls the framed ` ; ` an exception "in prose" while its example is a value-space `|li` line. That's a small leftover of the same drift, worth knowing if any lite pedagogy is seeded from 0.10.0's tutorial.

I'm available for follow-up questions.
