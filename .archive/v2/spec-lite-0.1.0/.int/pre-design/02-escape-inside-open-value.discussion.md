# 02 — Escape inside an open value: history

**Who wrote this:** a history agent (Claude, Opus 5.5), 2026-09-29, one of thirteen parallel history passes. I was deliberately not shown the coordinator's lean, and I did not read `initial-leans-2026-09-29.md` in the shared scratchpad.

**What this covers:** everything I could find, in date order, about one question: in `:a hello \:-) how are you?`, does the escaped material (and what follows) continue `a`'s open value, or start the element's `$main` / body text? Because the question only became sharp after several other rulings, the history also includes the escape's older jobs, like "break out of the attribute and start the body," since the two are tangled.

**Method.**

- **Joseph's own words** come from `~/.claude/history.jsonl` (his typed prompts only; no model output). I read them with a small script that keeps line breaks and indentation. Line numbers are given as `history.jsonl:L<n>`. Times are local (MDT).
- **Agent replies** come from `memorata-search`, restricted to `agent-to-human`, `agent-to-human-flanking`, `subagent-final-response`, and `human-user` classes. **The memorata index strips newlines and indentation.** Agent prose is quoted as returned. Where an agent's UDON example is reproduced, I restored the line breaks between one-line examples and say so. No multi-line agent example is reproduced whose indentation I could not recover.
- **Repo files** were read directly: `spec/CORE.md`, `spec/msc/CHANGELOG.md`, `core/fixtures/v0.9/*.yaml`, `v2/DECISIONS.md`, `v2/OPEN.md`, `v2/spec-0.09.01/`, `v2/spec-0.10.00/` (CORE, TUTORIAL, working-notes), `v2/msc/for-joseph/`, `v2/spec-0.10.01/` (CORE, working-notes, fixtures), `v2/theory/to-integrate/` (primary/sameline-value-space-*, K9-DRAFT, unification-matrix), `v2/JOSEPH-FOR-0.10.01-FIX.md`, `v2/.archived/first-pass/` (spot-checked; the greenfield rewrites restate the 0.9 rule and add nothing on this question).
- **2011 originals:** these are at `~/src/_older/udon/` and `~/src/_older/udon-c/`, not `~/src/_ref/` as the brief said.
- **Git:** `git log -S` for `how are you`, `ESC-BREAKOUT`, `frame split`, `Block-Level Escape`, `never its owner`; `git show` of commits `c0025bd`, `dfbcfa9`, `2de5907`.
- **Evidence of what was built:** I ran the current reference parser (`core/`, parser generated 2026-07-19, `examples/stdin_parse`) on five spellings of the example. This is evidence of the 0.9 implementation only, not of intent.

**Searches run** (so a "nothing found" can be checked):

- memorata, `--joseph`:
  - "It's ' \ ' that commits to text, right?"
  - "One of the primary uses of \ was to break out…"
  - "backslash forces the rest of the line to be text in udon"
  - "udon escape backslash sameline attribute value text"
  - "forced text backslash udon"
  - "commit to text mode backslash"
  - "force-prose backslash udon"
  - "escape the colon so it is not an attribute udon"
  - "\ at the start of the line means literal text udon"
  - "R3 the backslash just changes the mode…" (Jul 15–17)
  - "backslash start the most recent element's prose or mark the beginning of a prose block"
  - "backslash at the beginning of the intended column…"
  - "hypothetical newline, but indent to the current cursor location anyway"
- memorata, agent classes:
  - "attribute hello \:-) how are you emoticon escape commits to text" (Aug 8–12)
  - several queries scoped with `--in` to the Aug 8–9 session `6ce33695…`: "backslash escape framed commit text breakout", "ESC-BREAKOUT closed K10 framed backslash terminates", "some words backslash and body…", "emoticon", "probe"
  - the Jul 16 session directory ("backslash boundary prose element attribute R3 archeology grok")
  - "ownership of the rest of the line doubles the semantic load…"
  - "alpha something backslash I'd like this to be part of el…" (Jul 16 + Grok scopes)
  - "7 hundred hold one character framed hold rest of line"
- Grok sessions (`~/.grok.bak-2026-07-21`, `~/.grok.bak-2026-08-29`) and `-t grok_session`: "backslash sameline attribute value prose element text", "backslash escape udon". Almost nothing is indexed there beyond the Jul 15 Grok review quoted below. I did not search Codex logs.
- `history.jsonl` scan: every udon/libudon/descent/v2 prompt containing a backslash (80 hits, all read). Separately, every udon/arch prompt after 2026-08-09 01:00 matching `D3|Q8|emoticon|:-)|joins the open|breakout|break out|backslash`.
- Repo: grep for `\:-)` across the udon repo. Grep of live `.ud`/`.un`/`.udon` files under `~/src/arch` for sameline `\` usage.

**What didn't work:**

- One unfiltered memorata query (the "7 hundred" search) returned an `agent-thinking` chunk. I did not use it.
- One search was killed mid-run (exit 144), probably from load. I re-ran it.
- Nothing was blocked by the platform.

---

## History (chronological)

### 2011-08-15 — 2011 syntax notes: in unquoted attribute values, `\ ` escapes whitespace

- **Source:** `~/src/_older/udon/.attic/syntax2.udon` lines 139–231 (last commit `dd667d3`, 2011-08-15).
- **Speaker:** Joseph, in a design document.
- **What it says:**
  - "A node with a first child that starts with a colon needs to have the colon escaped or the end of the attributes/identity block delimited with a pipe."
  - The escaping table marks unquoted `attr values` as allowing **WSE (whitespace escape): YES** and backslash "emit". The file ends with the fragment `|something :attr value\ `.
- **Bears on the question:**
  - In 2011, unquoted attribute values ended at whitespace. `\ ` (backslash-space) meant *escaped space: the value continues*. That is the opposite of today's framed ` \ ` ("the rest of the line is text").
  - Escaping a leading `:` of body text after the attributes was already a named need.
- **Incidental:** the rest of the escape table (quote forms, metacharacter sets).

### 2011-08-15 to 08-22 — 2011 overview: ` | ` separates attributes from body text

- **Source:** `~/src/_older/udon/examples/overview.udon` lines 122–136 (commits `1b57c3a`, `0cd4b33`).
- **Speaker:** Joseph (example file).
- **Verbatim:**

  ```
  |post-data :urlencode :xmlentities |
    blah blah blah
  ...
  |post-data :urlencode :xmlentities | blah
   blah blah
  ```

- **Bears on the question:** the 2011 way to say "attributes are over; this is body text" was a pipe-space marker, not `\`.
- **Incidental:** the `<:…:>` interpolation forms elsewhere in the file.

### 2011-12-14 to 12-22 — udon-c DECIDED: unquoted values stop at "space plus marker"

- **Source:** `~/src/_older/udon-c/docs/DECIDED.md` lines 20–30 and 94–97.
- **Speaker:** Joseph (design ledger).
- **Verbatim:**
  - "VALUE: Non-delimited scalars including text — APPLIES TO: attribute-values, on-line node data, after '| ' — STOPS ON: dedented newline or space __plus__ [|#.!:]"
  - "Once data text has started on a line, pipes etc. are all treated literally like any other text. Need a newline or embedded to get back to structured data."
- **Bears on the question:** this is the same terminator shape K10 ruled in 2026 (a value ends at space + marker). No escape rule is stated with it.
- **Incidental:** grim attributes, protected `(…)` values, and the implied root node (relevant to question 04, not here).

### 2025-12-27 — Joseph: `\` before an inline opener disappears

- **Source:** `history.jsonl:L6004` (libudon).
- **Speaker:** Joseph.
- **Verbatim:** `'|{element this is actually all still just prose but the "'" disappears}   \|{and so is this but the "\" disappears}`
- **Bears on the question:** an early instance of `\` as a one-character escape that is consumed. There is no attribute-value context here.

### 2025-12-31 — Joseph: sameline values end at space; `\` escapes `;` inside a sameline value

- **Source:** `history.jsonl:L6425`, `L6434`, `L6435` (libudon).
- **Speaker:** Joseph.
- **Verbatim:**
  - "sameline attr only needs \n ␣ or if it starts with a quote, closing quote, right?"
  - "For sameline comments (whether sameline as element or sameline within attribute-block), backslash is appropriate for escaping it."
  - Quoting the agent's table row back: `| Sameline attr/prose | Backslash | `\|el :k val\;ue ; comment` |`
- **Bears on the question:** the first attached escape *inside a sameline value*. `val\;ue` keeps the value going, and the `;` is literal. It is mid-token, though, and sameline values were one token long, so the "open value vs body" question could not arise yet.

### 2026-01-01 — FULL-SPEC: `'` is the block-level escape, `\` the sameline/embedded escape

- **Source:** `git show c0025bd:FULL-SPEC.md`, lines 96–143 and 453–469.
- **Speaker:** the spec document.
- **Verbatim:**
  - "Backslash escapes a literal semicolon in **sameline** or **embedded** contexts"
  - Example: `|el :key value\;more text ; this part is a comment`
  - "**Sameline** values are space-delimited; quote for spaces"
- **Bears on the question:** background only. The escape did not yet decide who owns any text.

### 2026-01-03 — Joseph: worries about having two escape mechanisms

- **Source:** `history.jsonl:L7020`.
- **Speaker:** Joseph.
- **Verbatim:** "AI worry about the dual escaping mechanisms -- ' for block and \ for sameline. I wonder if we should just have `\\` for all escaping."
- **Bears on the question:** the push toward a single escape that later produced the positional `\`.

### 2026-07-14 — Joseph: one positional `\`; on the sameline it starts the element's prose

- **Source:** `history.jsonl:L16202–L16226` (udon).
- **Speaker:** Joseph.
- **Verbatim** (L16209, 15:58; he typed `/` for `\`, and confirmed the backslash reading at L16212):
  > "OK-- Now I'm settled. backslash always forces prose (and is consumed / not passed on) when at head-position (including same-line-- e.g.:
  >
  > |element |another :val [234 19] / how wonderful ; it is     -> the 'another' node gets its array attribute and child prose of ` how wonderful ; it is` (note even the first space before 'how')"
- **Also verbatim:**
  - L16210: "And, again, important to note (and show) that '\' *within prose* or any non head position is simply passed on through..."
  - L16212: "Escaping has gone from 2 delimiters each with extra complexity and nuance down to one simple and coherent one."
- **Bears on the question:** this is where `\` became the sameline breakout: after a **finished** value (an array), **framed** by spaces, and giving text to the nearest element. `\` at non-head positions (including mid-value) was ruled literal.
- **Incidental:** the column-anchor idiom (L16213–L16218) and trailing-`\` line continuation (L16205, L16209).

### 2026-07-15 — Ruled: forced text is comment-dead; a bare token followed by `\` is a single-token value

- **Source:** `spec/msc/CHANGELOG.md` lines 340–347 (the 2026-07-15 block) and lines 407–409.
- **Speaker:** Joseph's rulings as recorded.
- **What was ruled:**
  - "bare-token boundary rule (provisionally-open scan at a bare token's boundary; marker → single-token value, text → blob to ownership)"
  - "`\`-forced text = line-verbatim but inline forms fire, framed ` ; ` literal"
- **Bears on the question:** `\` was in the boundary-marker set. So `:a hello \…` gives `a="hello"` and forced text after it. But after two or more words the flow committed to end of line, and a mid-flow `\` was literal. From here on, whether `\` breaks out depended on **how many tokens came before it**.

### 2026-07-15 18:03 — Grok's review warns against the first character deciding ownership

- **Source:** memorata, `~/.grok.bak-2026-07-21/sessions/…/019f67df-…/updates.jsonl:762` (class agent-to-human-flanking).
- **Speaker:** a Grok agent reviewing the "greedy text" proposal.
- **Verbatim:** "3. **One character flips ownership of the whole tail.** `"hello" world` → element prose; `hello world` → all value. First-character commitment already decides *typing*; making it also decide *extent and ownership of the rest of the line* doubles the semantic load on the least visible feature of the line."
- **Bears on the question:** a general principle, not about `\`: small, low-visibility spelling differences should not decide ownership. It applies directly to the one-space attached/framed difference discussed below.

### 2026-07-15 21:19 — Joseph: wants `\` to break out of a value; floats pipe-space as another way

- **Source:** `history.jsonl:L16354`.
- **Speaker:** Joseph.
- **Verbatim:**
  > "One thing I've been afraid to bring up because I keep blowing up the whole spec with everything like this, but maybe now's the right time:
  >
  > |el :alpha something \ I'd like this to be part of |el, not "end-of-line-text" for :alpha.
  > I know it could now (with current proposal) done with:
  > |el :alpha "something" I'd like this to be part of .....
  >
  > But the truth is I would also not mind
  > |el :alpha something | and this is the text child of |el... but it would be creating a whole new bag of problems... but it *looks* so good!"
- **Bears on the question:** Joseph's breakout example is **framed**. He also names an alternative breakout marker (` | `) that echoes the 2011 idiom.

### 2026-07-16 02:17 — Joseph: the `\` breakout inside an inline element

- **Source:** `history.jsonl:L16386`.
- **Speaker:** Joseph.
- **Verbatim:**
  > "Add the following too:
  > |{a :href /home :title Home \ Welcome home!}
  > and note that the following will probably be added once dialects are good to go:
  > |{a :href /home :title Home \ Welcome home! ; hope that helps}"
- **Bears on the question:** the breakout is framed again, now inside `|{…}`.

### 2026-07-16 02:36–02:50 — R3 ruled "opposite of draft": `\` sets the mode, never the owner

- **Sources:** `history.jsonl:L16387`, `L16389`; commit `dfbcfa9` (2026-07-16 02:45). The commit message: "R3 ratified opposite of draft: boundary-\ never changes ownership… The \ changes text mode only."
- **Speaker:** Joseph, with the Fable agent drafting.
- **Verbatim, Joseph (L16387):** "…an end-of-line-blob needs to attach to the attribute to its left, and if the attribute already had a value, then it attaches to the rightmost element to its left, *and if there is no element **on that line*** then it needs to warn+[array-stack to the attribute's value]"
- **Verbatim, Joseph (L16389):**
  > "I now also realize that you probably already had in the spec something like:
  >
  > ```
  > |el
  >   :attr <val> another value ; <- warn + stack & warning should note that backing this up to the line with an element will cause it to bind to the element instead...
  > ```
  >
  > and this was more a result of "Does the backslash act like a "start the most recent element's prose" or does it act like "mark the beginning of a prose block"? (And my take is the latter, for the same reason that the example directly above acts the same...)"
- **Bears on the question:** this is the clearest statement of **what `\` is for**: it sets a text *mode*, not an *owner*. Ownership comes from the ordinary rules, which in Joseph's words start with "attach to the attribute to its left." The ruling was about a `\` **after a finished value on a block-attribute line**. Applying it to an attached escape inside a still-open value is an extension of the principle, not a ruling on it.
- **Incidental:** the warn-and-stack wording, and flags.

### 2026-07-19 — Joseph: `\` is the one sameline way to start the element's text

- **Source:** `history.jsonl:L16906`.
- **Speaker:** Joseph.
- **Verbatim:**
  > "The *only* way on sameline to be able to start text mode as a child of |el is using \ or potentially (although it should warn) the one after:
  > |el :href !{{base}}/users/!{{id}} still href \ now child text of |el ; and so is this because \ disables sameline comments"
- **Bears on the question:** a framed `\` after a multi-word unquoted value, giving text to the element. Under the 0.9 text as written this example did **not** work (mid-flow `\` was literal). This mismatch is what ESC-BREAKOUT later named.
- **Incidental:** interpolation and flags in the same message. The `L16895` examples on explicit final newlines (`|el :hello? :hi there \` followed by a child line) are about newline disposition, not ownership.

### 2026-07-22 — The 0.9.1 consolidated spec carries the 0.9 rule unchanged

- **Source:** `v2/spec-0.09.01/CORE.md` line 309 (the boundary list includes `\`) and line 361.
- **Speaker:** the document.
- **Verbatim (line 361):** "A `\` at a *finished* value's boundary is the ordinary boundary escape — the rest of the line is text, owned by the rows above; the `\` sets the text's *mode*, never its owner."
- **Bears on the question:** same as the 07-15 and 07-16 rulings. Only the single-token case can break out.

### 2026-07-29 16:54 — Joseph: a multi-word value, then `\`, gives the element's text

- **Source:** `history.jsonl:L17935`.
- **Speaker:** Joseph.
- **Verbatim:**
  > "I thought 0.9.1 fixed that -- the final trailing text all goes to the attribute's value there at the end. You quote if you need some of the tail to go to an earlier element:
  >
  > |el :a this is all value for a
  > |el :a "this" now this is child of |el
  > |el :a this \ this is also all child of |el"
- **Bears on the question:** a third framed breakout. Here "this" is a single token, so 0.9 already honored it. He also asked for a Sonnet agent to check how 0.9.1 deviated. I found no record of that agent's result.

### 2026-07-30 — Joseph: framed `\` in an empty value slot

- **Source:** `history.jsonl:L18173`.
- **Speaker:** Joseph.
- **Verbatim:** "My preferred fix-- let me know if this is valid as per current 0.9.1: `:see \ [[stem]] ....`"
- **Bears on the question:** framed `\` where the slot is **empty** fills the slot, which is the opposite of breaking out. See "framed ` \ ` is not uniform" under *What the neutral file misses*.

### 2026-08-08 13:01–13:08 — The "case 4" worksheet; ESC-BREAKOUT is parked

- **Source:** `history.jsonl:L18832`, `L18834`; `v2/OPEN.md` line 68–69 (the ESC-BREAKOUT record).
- **Speaker:** Joseph.
- **Verbatim, L18832 (the worksheet line later called case 4):**
  ```
  |element :one 1 :two 2 :plus more attribute \ and this is the first content/prose ; which continues-- we (possibly might change our mind) don't watch for comments after \...
  ```
- **Verbatim, L18834:**
  > "wrt Case 4 --- that current behavior in the spec is a bug if true. One of the primary uses of \ was to break out of attribute-value pairs on sameline. We had to put it in place when we started associating the text with the most recent attribute instead of the prior 0.8 and earlier behavior … where `|e :a x y z` would assign "x" as the value for :a, and "y z" is the child text for |e. That was the way udon was for a long time-- when we changed it, it made it more visually coherent, but it became difficult to say "and now the body line" (or, in the potential new proposal, the :'$main' value)."
- **Bears on the question:** Joseph states the escape's main historical job: **breaking out** of an attribute's value into the body / `$main`. Every example is framed.
- **Incidental:** the other worksheet rows (late attributes, and whether `"some prose" :and` defines `:and`).

### 2026-08-08 13:31 — Joseph: the sameline has "pseudo-line-feeds"

- **Source:** `history.jsonl:L18835`.
- **Speaker:** Joseph.
- **Verbatim:** "sameline has (1) certain syntax-sugaring available that isn't other places, and (2) has pseudo-line-feeds (actual original purpose LF, NOT newlines- but rather hypothetical newline but indent to the current cursor location anyway)"
- **Bears on the question:** the capture doc (`v2/theory/to-integrate/primary/sameline-value-space-2026-08-08.md` lines 19–25) turned this into "`\` inserts a pseudo-LF." Under that reading a breakout lands on a new virtual line, owned by the element.
- **Pushback, same day:**
  - The fork (`…fork-notes.md` §4, lines 111–128): "`\` is not just 'insert LF' … The operator that actually reproduces the rulings is: **`\` forces text mode at the current cursor** … the pseudo-LF is the derived effect, not the definition."
  - The couplings pass (`…couplings-2026-08-08.md` flag 4): pin the operator "to **the Line Scan / sameline value space only**," or it silently gives every framed mid-prose `\` breakout semantics.
- **Incidental:** the `$main` stacking and `|{embed-1} |{embed-2}` material in the same message.

### 2026-08-08 13:56 — Joseph: "ALL prose on same-line is basically an attribute value"

- **Source:** `history.jsonl:L18837`/`L18838`.
- **Speaker:** Joseph.
- **Verbatim:**
  - "…we kind of lost the ability to "break out of attributes to work on body initial text" apparently--- but if we say "ALL prose on same-line is basically an attribute value-- it's just a question of which attribute you are assigning to..." I like it more and more..."
  - And: "the intent for strings starting with numbers need quotes is the same: |el :a "1 extra" (or) |el :a \1 extra"
- **Bears on the question:** after this (K9), "break out to the body" means "switch which attribute receives the text" (to `$main`). So this question became purely about **ownership between two attributes**.

### 2026-08-08 22:28 — Joseph: the escape is still unsettled on the sameline

- **Source:** `history.jsonl:L18872`.
- **Verbatim:** "3. Yes--- we still haven't figured out \ exactly yet when it comes to a mid-sameline semantics..."

### 2026-08-08 22:44–23:07 — An agent proposes K10; ESC-BREAKOUT closes into it

- **Source:** memorata, session `6ce33695…jsonl:469`, `:482`, `:504`; `v2/DECISIONS.md` K10 (line 177); commit `003f7db` (23:07).
- **Speaker:** a Claude (Fable-era) agent.
- **Verbatim (22:49):**
  - "Mid-flow, a guard-confirmed *framed* marker terminates the flow value and resumes the scan — ` :key`, ` |name`, ` @ref`, ` !name`, ` \`, fence…"
  - "ESC-BREAKOUT largely dissolves into it: `\` becomes just one more framed marker that ends the open flow"
  - "Historical note that supports re-opening: 0.8 attached *one* token; 0.9 went *fully greedy*; the middle position — greedy until a framed guard-confirmed marker — appears never to have been tried."
- **K10 as ruled:** "**ESC-BREAKOUT resolves as a corollary**: framed `\` is one more terminating marker — `:a some words \ and body` → a="some words", `$main`="and body"".
- **Bears on the question:** K10 names only the **framed** `\` as a terminator. The Dec-2011 `DECIDED.md` entry above shows that the "middle position" *had* been written down before.

### 2026-08-08 23:47–23:57 — Joseph asks how `\` now works; approves the agent's answer

- **Source:** `history.jsonl:L18883` and `L18884`/`L18885`; agent reply memorata `…jsonl:531` (23:48).
- **Joseph:** "Hmmm... Explain to me now \ works according to what was "closed"?" Then: "Excellent-- that all looks exactly right to me. Wonderful. Closed indeed."
- **Agent (verbatim prose):** "**`\` forces text mode at the cursor; it never chooses the owner** (§6.5's existing sentence…) … K10 changed exactly one thing: *where* a framed `\` can fire."
- **Agent example** (line breaks restored):
  ```
  |el :a some words \ and body
  ; a = "some words"; then forced text → owner rows → element → $main = "and body"
  ```
- **Bears on the question:** Joseph approved "mode, never owner." At this point the spec still treated attached and framed `\` as one operator, so the approval did not cover the split made an hour later.

### 2026-08-09 00:00 — The agent's K12 options name the emoticon hazard

- **Source:** memorata `…jsonl` 00:00:39 (agent-to-human-flanking).
- **Verbatim:** "If `-` `.` `,` `/` `=` `|` can *start* a bare key, then every framed emoticon and colon-idiom in a sameline text value becomes a guard-passing attribute opener: `|el :mood happy :-) ok` → attribute `-)` … the quote/`\` discipline covers deliberate cases — but emoticons are exactly the text people *don't* think to escape."
- **Bears on the question:** this is where the `\:-)` need comes from. Before K12, `:-)` could not open an attribute. The 0.9 parser confirms this: `|el :a hello :-) how are you?` is one text value there.

### 2026-08-09 00:06 — Joseph introduces the example

- **Source:** `history.jsonl:L18887`.
- **Speaker:** Joseph.
- **Verbatim:**
  > "2 seems safer, but it's not. My gut is telling me it's going to be another instance of limiting an important use-case because of an unimportant failure mode. I'm completely fine now saying that $main type text and sameline text generally needs to be more careful because that's where attributes live. Are we all good with this, by the way?
  >
  > |element :attribute hello \:-) how are you?
  >
  > It's ' \ ' that commits to text, right?"
- **Bears on the question:** this is the example the neutral file uses. Joseph gave it to show that escaping the emoticon is easy. It carries **no annotation of who owns** `:-) how are you?`. Its question is about **mode** (framed commits, attached doesn't).

### 2026-08-09 00:07 — The agent's answer supplies the "breakout" (B) reading

- **Source:** memorata `…jsonl:560` (agent-to-human).
- **Speaker:** the Claude agent.
- **Verbatim prose:** "Almost — one precision: it's the **space before** that matters, not spaces around. At a token boundary (space after `hello`), `\` fires as a marker with *no* trailing space needed — it consumes itself and everything after is committed text, dead to markers and comments alike."
- **Agent examples** (line breaks restored):
  ```
  |element :attribute hello \:-) how are you?
  ; attribute = "hello" · $main = ":-) how are you?" · comment-dead after the \
  |element :attribute hello \ :-) how are you?
  ; same thing (separator space consumed) — both spellings work
  |element :attribute hello\:-) how are you?
  ; NO break: unframed \ inside a token is literal — attribute value contains "hello\:-)"
  ; and then... " how are you?" continues the same flow value
  ```
- **Bears on the question:** this is where the Option B annotation first appears. It was **written by the agent**, describing the pre-K13 spec text, which treated attached and framed `\` as one operator.

### 2026-08-09 00:11 — Joseph: "Ugh... that's not good"; the frame split

- **Source:** `history.jsonl:L18888` (indentation preserved).
- **Speaker:** Joseph.
- **Verbatim:**
  > "Ugh... that's not good. Dang it.
  >
  > I thought this was the rule laid down:
  >
  > ' \ ' with *both spaces* commits to text. Otherwise it's just escaping the thing after it, especially when it's otherwise a block beginning character!
  >
  > ```
  > |element :hello \:value
  > ===
  > |element
  >          :hello
  >                 \:value
  >
  > |element
  >   \   Those spaces to the left are preserved
  >       this has preserved spaces to the left as well ; and this is not a comment
  >       THAT's what "commit to text mode" was meant for.
  >   \:this should be text
  >   whether or not it's sameline or the beginning of the block.
  > ```
  >
  > It looks like we have another relic of "before the simplification" times where a bunch of adhoc rules put in place to try to make the old stuff work now just get in the way."
- **Bears on the question:**
  - Attached `\X` is "just escaping the thing after it." The worked example is an attached escape at the **start** of a value (`:hello \:value`), where joining the value is automatic.
  - He does not say who owns escaped material that follows *other words* in an open value.
  - "That's not good" responds to the agent's claim that `\:-)` and `\ :-)` are "the same thing" (the conflation, including comment-deadness). Whether it also rejects the ownership in the agent's annotation is **not stated**.

### 2026-08-09 00:12 — K13 lands

- **Source:** `v2/DECISIONS.md` K13 (line 174); commit `1e61e8b` (00:12:56). The agent reply is at memorata `…jsonl:578`.
- **Verbatim, K13:**
  - "(2) **attached `\X`** — escapes exactly the next character where it would otherwise be structural: `\|element :hello \:value` → `hello=":value"` … the scan continues normally after the escaped token — framed ` ; ` still comments, K10 terminators still terminate (`:hello \:value more :next 1` → `:next` is a real attribute)."
  - "Corrects K10's corollary example: `\:-)` *escapes* (flow continues, comments live); ` \ :-) ` *commits* (comment-dead)."
- **Bears on the question:** "flow continues" is the agent's wording in a row marked "jaw 2026-08-09." It reads naturally as "the value keeps going" (Option A), but the only worked examples again start the value with the escape. **Neither K13 nor Joseph's message covers the mid-value case explicitly.**

### 2026-08-09 00:23 — Joseph: how often emoticons need escaping, and where they live

- **Source:** `history.jsonl:L18890`.
- **Verbatim:** "Almost all my decisions try to reduce to not violating the principle of least surprise the most (so sometimes taking into account estimated or hypothesized frequencies of edge-case occurance etc.-- like 'emoticons in the $main attribute text and forgetting to escape' -- pretty unlikely-- it's mostly a human thing, and it's unlikely needed even for humans as the special text, and for humans a syntax highlighter … will immediately show them that the :-) has turned into a :'-' + error on the parenthasese I assume--- so unlikely compared to how often we'll want multiple attributes on the same line or subsequent lines)."
- **Bears on the question:** he pictures the emoticon inside **`$main` text**. There, A and B give the same result. The A/B split only shows up after a *named* attribute's unquoted value.

### 2026-08-09 00:27 — Fresh-reader probe A: "The backslash escapes the colon"

- **Source:** memorata `…jsonl:631`; `v2/spec-0.10.00/working-notes/UNIF-PASS-QUESTIONS.md` line 19.
- **Speaker:** a Sonnet probe agent with no spec context.
- **Verbatim:** "3. The backslash escapes the colon, so `:hello` holds the literal string ":value"."
- **Bears on the question:** a naive reader handled the value-start attached escape as K13 does. The mid-value case was not probed.
- **Incidental:** the same probe read `|el :a 1 extra` as `"1 extra"` and let `:note hello there :b 2` swallow `:b` (the retired greedy rule).

### 2026-08-09 00:47 — Unification pass 1 drafts §6.4 and contradicts itself

- **Source:** commit `2de5907`, `v2/current-0.9.1-spec/CORE.md` §6.4 (seen via `git show`).
- **Speaker:** a fork agent (0.10.0 pass 1).
- **Verbatim:** "An **attached `\X`** escape (§4) makes a would-be terminator ordinary content and the value continues (`:a hello \:-) how are you?` → one attribute, then `$main` — no: see §4's worked examples; the escaped token joins the open value only when one is open at that position)."
- **Bears on the question:** the drafting agent began writing B ("then `$main`"), stopped itself mid-sentence ("— no:"), and moved to A. This is the seam pass 2 named Q8.

### 2026-08-09 00:53 — Pass 2 names the seam as Q8

- **Source:** commit `4ccd9f8`; `v2/spec-0.10.00/working-notes/MORNING-ADJUDICATION.md` lines 37–48 (identical to `v2/msc/for-joseph/MORNING-ADJUDICATION.md`).
- **Speaker:** a fork agent (0.10.0 pass 2).
- **Verbatim:** "**When you said** (introducing this very example, pre-K13-split) "It's ' \ ' that commits to text, right?", **it was assumed** after K13 that the attached spelling `\:-)` escapes one character and — because `:attribute`'s unquoted value is still open — the emoticon joins *that value*, not `$main`. The framed spelling ` \ :-) ` still gives your original reading (`attribute="hello"`, `$main=":-) how are you?"`). **Does the implication hold** — attached-escape material lands in whatever value is open, with the framed form as the way to break out — or did you want any escaped emoticon after a value to read as `$main`?"
- **Bears on the question:** this is the question itself. "Your original reading" refers to the framed spelling, which is accurate for what Joseph's L18888 said about the frame.

### 2026-08-09 09:06 — The plain decision sheet, D3

- **Source:** commit `8a65c27`; `v2/msc/for-joseph/01-PLAIN-DECISIONS.md` lines 31–40.
- **Speaker:** the coordinating agent.
- **Verbatim:**
  - "**Option A (drafted, K13-consistent):** the escaped `:-)` joins the still-open value → `attribute = "hello :-) how are you?"`, no `$main`. Break out with the framed form…"
  - "**Option B (your original pre-K13 annotation):** any escape after a value starts element text…"
  - "**Recommendation: A** — one rule ("escape = make one character literal, change nothing else"), and the framed/attached distinction stays meaningful."
- **Bears on the question:** the label "your original pre-K13 annotation" appears to be a **misattribution**. Joseph's 00:06 message has no annotation. The `attribute="hello"` / `$main=":-) how are you?"` annotation is the agent's 00:07 description of the pre-split spec. (I read Joseph's prompts directly; memorata shows no other Joseph annotation of this example.)

### 2026-08-09 09:40–09:42 — Joseph: separating the value from `$main` should be visible in the source

- **Source:** `history.jsonl:L18912`, `L18913`.
- **Speaker:** Joseph.
- **Verbatim:**
  - "|html |body |a :href google.com Here's where to search / what does that render to?"
  - Then: "Excellent-- that's what I thought. And it's good. It makes it clear in the source the separation between the last attribute's value and the element's $main, which in the case of html etc. will always be interpreted as the first and sometimes only part of the inner-content."
- **Context:** the agent's reply (memorata `…jsonl:905`, 09:41) says `href` takes the whole tail under K10, and "quote and framed-`\` are the disambiguators."
- **Bears on the question:** Joseph likes the handoff from a value to `$main` being **explicit in the source**. Both A and B keep it explicit. They differ in which spellings count as the explicit marker.

### 2026-08-09 09:43 — D3 re-listed; never ruled

- **Source:** memorata `…jsonl` 09:43:09 (agent-to-human-flanking).
- **Verbatim:** "**D3–D9** — the small ones: attached-escape-joins-open-value (rec A)…"
- **Searched:** every Joseph udon/arch prompt after 2026-08-09 01:00 for `D3`, `Q8`, emoticon, `:-)`, "joins the open", breakout, or backslash. **No ruling on D3/Q8 was found.** Joseph spent that morning on D2/K16 and stacking ("Let's hit them here in chat one at a time. Give me D2 fully" — L18914). `v2/msc/for-joseph/00-QUEUE.md` and `README.md` still list D3 as open.

### 2026-08-10 — 0.10.0-alpha.1 text states A, flagged as an open lean

- **Source:** `v2/spec-0.10.00/CORE.md` lines 142, 150–175, 349, 386; `working-notes/CHANGELOG.md` line 27 ("Q7, Q8 remain open").
- **Verbatim, §6.4 (line 349):** "An **attached `\X`** escape (§4) makes a would-be terminator ordinary content: with a text value **open** at that position, the escaped material joins it and the value continues — `:a hello \:-) how are you?` → `a = "hello :-) how are you?"`, no `$main`. *(Open lean — working-notes Q8.)*"
- **Verbatim, §6.5 (line 386):** "At any *finished*-value position, `\` behaves per §4 with ownership by the rules above — the `\` sets the text's mode, never its owner."
- **Verbatim, TUTORIAL §7:** "`\` does two things, told apart by spacing."
- **Bears on the question:** A is written into the text as an open lean. After a *finished* value (quoted or typed), an attached escape starts `$main` under this text too (§6.5 ownership). So A and B agree everywhere except after an open unquoted value.

### 2026-08-27 — 0.10.1-draft states A as law, reframed as "hold"

- **Sources:**
  - `v2/theory/to-integrate/unification-matrix-2026-08-27.md` line 14: "attached `\X` = hold one item; framed ` \ ` = hold the rest of the line. One story instead of a two-operation table."
  - `v2/spec-0.10.01/CORE.md` line 194: "an attached `\X` makes a would-be terminator content — with a text value open, the escaped material joins it and the value continues" (no lean marker).
  - `v2/spec-0.10.01/NUANCE-AUDIT.md` line 14: escape frame split "**derives**."
- **Speaker:** a Fable agent (the draft Joseph later called a misfire).
- **Bears on the question:** A was promoted from lean to law without a ruling.

### 2026-08-28 08:15 — Joseph: the one-space ambiguity worries him

- **Source:** `history.jsonl:L20554`.
- **Speaker:** Joseph.
- **Verbatim:** "…it looks like it has resurrected an old (many years old) udon idiom of '| ' specifically denoting text somehow, but the `:a \7 hundred` vs `:a \ 7 hundred` ambiguity worries me on the second and third column…"
- **Agent reply** (memorata `147848c4…jsonl:737`, `:752`, verbatim prose):
  - "With the slot still open, **both spellings give `a = "7 hundred"`** … attached `\7` leaves the scan alive, so `:a \7 hundred :b 2` → `a="7 hundred", b=2`; framed ` \ ` holds the whole rest of the line, so `:a \ 7 hundred :b 2` → `a="7 hundred :b 2"`."
  - "What I'll concede without churning: a semantic fork riding on one space is a genuine visual hazard … if your instinct … has a shape for the rest-of-line form that doesn't ride on a single space, I'd genuinely like to hear it."
- **Recorded as:** `v2/spec-0.10.01/working-notes/spelling-grid.md` note 6, "under discussion."
- **Bears on the question:** Joseph's own recorded unease with meaning that depends on one space next to `\`. The example is at an **empty** slot, where both spellings keep the text in `a`. After an open value, A makes the same one space also decide **ownership**. See the threads below.

### 2026-09-01 — The audit flags "Q8 promoted to law"; a fixture encodes A

- **Sources:**
  - `v2/spec-0.10.01/working-notes/AUDIT-2026-09-01.md` line 73: "**C3. Q8 promoted to law.** 0.10.0 §6.4 marked "attached `\X` under an open value joins it" as *(Open lean — working-notes Q8)*. The draft states it flatly (§6.4). Either row it or keep the lean marker."
  - `v2/spec-0.10.01/fixtures/comprehensive/material.yaml` lines 117–127, `guard_emoticon_held`: `a: "hello :-) how are you?"`, "(Q8 reading, stated as law)".
  - Both committed in `9f69f42` on 2026-09-21.
- **Speaker:** the Sep 1 audit agent.
- **Bears on the question:** the audit noticed the promotion without a ruling. Joseph judged 0.10.1-draft a misfire the same day (see `v2/WHERE-THINGS-STAND-2026-09-27.md`).

### 2026-09-01 (committed 09-21) — The "0.10.0 + three changes" proposal

- **Source:** `v2/JOSEPH-FOR-0.10.01-FIX.md` line 37 (agent's text, per WHERE-THINGS-STAND).
- **Verbatim:** "An unquoted value ends at the next ` :label`, ` |name`, ` @ref`, ` !name`, ` ; `, or ` \ `."
- **Bears on the question:** lists only the framed ` \ ` as a terminator, which fits A. It does not discuss attached escapes.

### 2026-09-29 — What the 0.9 reference parser does (evidence only)

- **Source:** run today; `core/target/debug/examples/stdin_parse` on the parser generated 2026-07-19.

| Input | Events (summarized) |
|---|---|
| `\|el :a hello \:-) how are you?` | `Attr a`, `BareValue "hello"`, then element `Text ":-) how are you?\n"` → **B-shaped** |
| `\|el :a hello there \:-) how are you?` | `Attr a`, `Text "hello there \:-) how are you?\n"`: backslash **kept literal**, all in `a` |
| `\|el :a hello \ :-) how are you?` | `a="hello"`, element `Text " :-) how are you?\n"` (leading space kept) |
| `\|el :a hello there \ :-) how are you?` | all in `a`, backslash literal (the ESC-BREAKOUT bug) |
| `\|el :a hello :-) how are you?` | all in `a`; `:-)` is not an attribute in 0.9 (pre-K12) |

- **Bears on the question:** in what was built, ownership depends on how many tokens precede the `\`, not on its framing. Neither A nor B describes it.

### 2026-09-29 17:55 — Joseph lists "making sure that sameline capture works" as possibly open

- **Source:** `history.jsonl:L21297`.
- **Verbatim:** "It seems to me there are still some (*possibly*) still open things to look into, like better markdown-like tables, or making sure that sameline capture works…"
- **Bears on the question:** possibly related. "Sameline capture" may mean value extent and ownership on the element line, but it is not specific to the escape. My interpretation is uncertain.

---

## Threads worth noticing

*My own reading of the history above, marked as mine. None of this is a lean.*

1. **Every breakout example Joseph wrote is framed.** Jul 14 (`[234 19] \ how wonderful`), Jul 15 (`something \ I'd like…`), Jul 16 (`Home \ Welcome home!`), Jul 19 (`still href \ now child text`), Jul 29 (`this \ this is also all child`), Aug 8 case 4 (`more attribute \ and this…`). I found **no** Joseph example where an *attached* `\X` after words in a value was meant to break out. I also found none where it was meant to join. The one attached-after-value example (Aug 9, `hello \:-)`) came with a question about mode ("It's ' \ ' that commits to text, right?"), not about ownership.

2. **"Mode, never owner" is Joseph's earlier principle, but it was about a different case.** In July he framed `\` as "mark the beginning of a prose block," not "start the most recent element's prose." R3 was ratified "opposite of draft" on that ground, and he approved the "never chooses the owner" restatement on Aug 8. Applying it here means ownership comes from "the open slot owns," which gives A. But R3 was about a framed `\` after a *finished* value on a block-attribute line. Using it to decide an attached escape inside an *open* value is an extension. Both the 0.10.0 pass-2 agent and the D3 sheet made that extension without it being ruled.

3. **D3's label "your original pre-K13 annotation" for Option B does not match the record.** The B annotation is the agent's 00:07 text, describing the spec before the attached/framed split. Joseph objected four minutes later. His objection is clearly about mode and conflation. Whether it also rejected the ownership is not stated. If Joseph "vaguely recalls" having wanted B, the record found here doesn't show him saying it.

4. **The one space now decides a lot.**
   - Under **A**, after an open value, `hello \:-)` gives the text to `a` and `hello \ :-)` gives it to `$main`. One space decides the **owner** and whether later markers and comments stay live.
   - Under **B**, the two spellings share an owner and differ only in liveness, as the neutral file says.
   - On Aug 28, Joseph voiced unease about exactly this kind of one-space difference (`\7` vs `\ 7`), in a case where it only affected liveness.
   - The Jul 15 Grok review makes the general version of the point: a low-visibility character shouldn't decide ownership of the tail.
   - Against that: under **B**, whether a `\` breaks out depends on whether the next character "would otherwise be structural." `\:-)` breaks out (post-K12 `:-` passes the guard). `\w` or `\(` stays literal and stays in the value. So B moves the hard-to-see dependency from spacing onto the guard tables. Under A the guard only decides whether the `\` byte is kept.
   - Under 0.9 as built, ownership depended on the number of preceding tokens. Every version so far has had some hard-to-see input deciding ownership.

5. **The emoticon hazard only exists because of K12**, and was accepted on a frequency argument that places emoticons in `$main` text, where A and B agree. The case that splits A from B, an emoticon after a *named* attribute's unquoted multi-word value, is narrower than the case Joseph weighed.

6. **The escape's history is mostly a breakout history.** From 2011 (` | `, whitespace escapes) through 0.8 (one-token values) to 0.9/0.10, the recurring need Joseph names is "and now the body line." The one-character escape was a separate, older job (`\;`, `\|{`) that until K13 lived at other positions: mid-token, or before inline openers. K13 is the first time both jobs apply at the same position (a space, then `\`, inside an open value). That overlap is why this question exists.

7. **The terminator rule is older than the Aug 8 claim.** The agent that proposed K10 said the "middle position … appears never to have been tried." Joseph's Dec-2011 udon-c `DECIDED.md` has it ("STOPS ON: … space __plus__ [|#.!:]"). That doesn't settle this question, but it is 2011 evidence that Joseph intended the value to run until a real marker.

---

## What the neutral file misses

**Alternatives the history shows:**

- **C — `\` inside an open unquoted value is literal (the 0.9 rule for multi-word flow).** ` \:-)` is not "space + `:`", so the `:` is not a framed marker and the value continues anyway, with the backslash kept: `a = "hello \:-) how are you?"`. The escape is not needed to stop termination; the only question is whether the `\` byte is consumed. This was mainline law from 07-15 to 08-09 (`spec/CORE.md` "Any other `\` is literal," fixture `backslash_after_prose_begins_literal`). The parser does this today for two or more preceding words.
- **D — breakout depends on how many tokens precede the `\`** (0.9 as ruled and as built). Almost certainly not wanted, but it is the behavior of the only existing parser, and the reason ESC-BREAKOUT was opened.
- **E — a breakout marker that doesn't depend on one space next to `\`.**
  - Pipe-space ` | ` (2011 `overview.udon`; Joseph Jul 15: "it *looks* so good!"; Aug 28: "resurrected an old … udon idiom of '| '"). The Aug 28 agent notes that `| ` fails the element guard to protect Markdown tables, which ties this to question 08.
  - Or quoting as the only breakout, which Joseph endorsed as visible on Aug 9 09:42 for `:href`.

**Cases the neutral file doesn't show:**

- **Finished value, then an attached escape:** `|el :a "hello" \:-) hi` or `|el :a 42 \:-) hi` → `$main` under both A and B (0.10.0 §6.5). Only an *unquoted text value still open* separates A from B.
- **Escape inside `$main`'s own text:** `|el Hello \:-) there :b 2` → joins `$main` under both. Joseph's frequency argument is about this case.
- **Block-attribute line, no element on it:**
  ```udon
  |el
    :a hello \:-) there
  ```
  There is no `$main` here. Block-line leftovers stack onto the line's label (R3/K11; the Aug 9 09:39 agent summary). Under B this gives `a = ["hello", ":-) there"]`; under A, `a = "hello :-) there"`. Framed ` \ ` here also stacks onto `a`, not into a body.
- **Inside an inline element:** `|{a :title Home \:-) x}` alongside Joseph's R2 idiom `|{a :href /home :title Home \ Welcome home!}`.
- **Mid-token backslash:** `hello\:-)` is literal under K13 point 3. `a = "hello\:-) how are you?"` under both.
- **Escaped character not structural:** `:a hello \world` is literal under both, backslash kept. Under B, ownership then depends on the guard table (`\:-)` breaks out; `\(` or `\w` does not).
- **Framed ` \ ` is not uniform either:**
  - At an **empty** slot it fills the slot. From spelling-grid note 6: `:a \ 7 hundred :b 2` → `a = "7 hundred :b 2"`; compare `:a \7 hundred :b 2` → `a="7 hundred", b=2`.
  - **After** material it breaks out.
  - So "the framed form is how you break out" (A's companion rule) holds only when the value already has content.
- **Framed ` \ ` at end of line after material:** `|el :hi there \` followed by a child line. Joseph's Jul 19 final-terminator ruling: a trailing `\` means an explicit newline. Under A/B, where does that empty forced text go (`$main`?).
- **Real-corpus LaTeX:** `design/examples/mathml-to-latex.udon` (Dec 2025 xml2udon output) has `|text \`, `|{text \}}`, `|{text \left\{}`, `:name mo \circ`.
  - An attached `\}` before a context terminator inside an open value escapes the `}`, so the element doesn't close where the author meant it to.
  - A trailing `\` in a value slot becomes the empty-string/forced-text form instead of a literal backslash.
  - Neither is the A/B question, but both are "escape inside an open value" cases a lite spec has to answer.

**Framings the history adds:**

- **The axis is mode versus owner.** Joseph's July 16 question, "start the most recent element's prose, or mark the beginning of a prose block?", is the same question one level up. The neutral file frames it as "join vs `$main`" without naming that principle or its history.
- **`\ ` (backslash-space) in 2011 UDON and in POSIX shells means an escaped, literal space that continues the token.** This is a least-surprise data point for any reading where framed ` \ ` means "stop here."
- **Attribution.** If D3's options are shown to Joseph again, the "your original annotation" label on B is worth correcting (thread 3).
