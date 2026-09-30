# 10 — Inline elements `|{…}` and inline comments `;{…}`: history

**Written by:** Claude (Opus 5.5), history agent for question 10, 2026-09-29. I didn't see any lean file for this question and didn't write one.

**Method.** I read the neutral file, `pre-design/README.md` and `spec-lite-0.1.0/README.md` whole first. Then I rebuilt the history from these sources, oldest first:

- **Joseph's own typed prompts.** These come from `~/.claude/history.jsonl`, the Claude Code prompt log. It holds only his typed turns and pasted text, with no model output, and its layout is intact. I extracted it with `jq` and converted timestamps to local time (MST, UTC−7). I checked the 25 backup copies (`~/.claude.bak.*/history.jsonl`): the current file contains every prompt they have. The log starts in September 2025, so it covers the whole Dec-2025 reboot and all v2 work. It does not hold claude.ai web chats. I found no Codex prompt log.
- **The 2011–12 originals:** `~/src/_older/udon` (git dates) and `~/src/_older/udon-c/docs/DECIDED.md` (git dates).
- **Umbrella-repo git history** for `SPEC.md` → `spec/CORE.md` (commit diffs), `spec/msc/CHANGELOG.md`, `_archive/` and the fixtures. The fixtures count as evidence of what the parser did, never as intent.
- **v2:** `DECISIONS.md`, `spec-0.09.01/`, `spec-0.10.00/`, `spec-0.10.01/` (including the Sep-1 audit and fixtures), `JOSEPH-FOR-0.10.01-FIX.md`, `theory/to-integrate/`, `udon-needs/`, and `.archived/second-pass/` (the ruling table and supplement).
- **memorata-search** for agent-side and document passages. I restricted it to non-thinking classes and opened no raw `.jsonl` transcripts.

**Searches run** (so any "nothing found" below carries its search):

- *Prompt-log greps:* `\|\{`, `;\{`, `\*\{`, `inline element`, `inline comment`, `embedded element`, `brace form`, over all projects. A wider pass over udon, libudon and descent projects used `embed|inline|html|xml|comment|brace|curly` without the literal tokens; I screened about 250 hits by hand.
- *memorata:* `udon inline element |{`, `udon inline comment ;{`, `brace forms |{ !{ ;{ udon`, `udon html xml inline markup elements in prose`, `embedded element inside text udon` (all `--joseph --sort oldest --pool 300`). Also `inline comment semicolon brace ;{ udon`, `embedded element |{ bracket mode newline indent`, `unified inline syntax !{{ interpolation |{ ;{`, `table cells |{td} sibling`, `{|...|} vs |{...} symmetry with !{ inline element notation` (`-c agent-to-human`), `which do you prefer {|...|} or |{...} embedded inline element` (Dec 22–25), `udon inline comment semicolon brace`, `udon embedded element pipe brace inline`, `udon html xml inline markup elements`, `brace forms reduce to text embeds`, `inline elements xml html udon`. All Joseph-class hits outside the prompt log turned out to be compaction-summary copies of the same Claude Code sessions.
- *Repo greps:* `\|\{`, `;\{`, `embed`, `inline comment`, `framing (space|whitespace)`, `S18`, `element-rooted`, `line-initial`, across `spec/`, `_archive/`, `design/`, `core/fixtures/`, `v2/`.

**Gaps I know of.**

1. The agent's reply to Joseph's 2025-12-23 question "{|...|} vs |{...}?" was not reachable. The memorata queries above returned nothing from that session's agent turns, and the brief asked me not to open raw transcripts. Only Joseph's answer is recorded below.
2. I didn't read the Dec-2025 usability corpus directly. I used the 2026-07-21/22 characterizations of it in `udon-needs/`.
3. The 0.10.1-draft fixture set was only grepped.

**Reading notes.** Joseph's examples usually show several features at once. Below, I mark which part bears on *this* question. Quotes from Joseph are verbatim, typos included. UDON examples inside his quotes keep the layout from the prompt log.

---

## History (chronological)

### 2011-08-15 — early candidate spellings (`.attic/syntax2.udon`)

- **How dated:** git date. **Source:** `~/src/_older/udon/.attic/syntax2.udon`. **Speaker:** Joseph (sole author of the repo).
- The file lists several spellings side by side:

  ```
  <{mmmm}>                # embedded ELEMENT
  <{!uuuu}>               # embedded EXPRESSION (can be embedded many more places than elements)
  <{/uuuu}>               # embedded INTERPOLATION (non-embedded is just an expression)
  ...
  {|something :blah hi dude|}
  ```

  It also has a lexical note: "The following need to be escaped inside text to not be processed: `{|` `{!` `{/` · `|}` (if within an embedded element) …"
- **Bears on this question:** an embedded element with brace delimiters is present from the first sketches. So is the symmetric-closer variant `{|…|}`, which came back as an explicit choice in December 2025. Comments at this time were `#`.

### 2011-08-22 — `examples/overview.udon`: embedded elements, embedded comments, newline handling

- **How dated:** git date. **Source:** `~/src/_older/udon/examples/overview.udon`. **Speaker:** Joseph.
- The "Embedded" table in the file:

  ```
  <(ns/element ...)>       # Embedded element (has children lines if desired)
  <(# datadata #)>         # Embedded comment (allowed in identity sections as well) not <#..#> because <#{blah} is (surprisingly) common in ruby
  ```

- Sibling cells are written as `|tr <(td First stuff)> <(td Second stuff)>`.
- Also: "No indentation in embedded. all treated as 1-line (nl treated as space)".
- **Bears on:**
  - **Q2:** an *embedded comment* existed as a concept in 2011.
  - **Q1:** the first recorded multi-line rule was that a newline inside an embed acts as a space and indentation means nothing.
  - **Q3:** the embedded form was already the way to write *siblings* on one line.
- **Incidental:** the `<(…)>` spelling, and `class:` attribute syntax.

### 2011-08-22 — converter output uses `|{…}` for DocBook inlines (`.attic/examples_old/tmp.out`)

- **How dated:** git date. `latest.txt` (2011-Aug-22) points at this file as "various delimiters between tag and child text inline". **Source:** XML→UDON converter output. **Speaker:** a tool Joseph wrote.
- Examples from the output:
  - `the |{email docbook@lists.oasis-open.org} list`
  - `This Committee Draft was |{link :href http://lists.oasis-open.org/…/msg00007.html approved}`
  - Adjacent siblings with no space: `|{link :href http://sourceforge.net/ SourceForge}|{link :href … tracker}`
- **Bears on:** XML/HTML mixed content was the *original* use of `|{…}`. In this output, an attribute value inside the braces is one space-delimited token, and what follows it is the element's content. That is the reading the neutral file's example tree assumes; see 2026-07-16 for where that changed.

### 2011-12-05 — `declang/doc/notes3.txt`

- **Source:** git date, Joseph's notes.
- Contains `|{fenced/filter}`, which uses the braces for a different meaning (a filter/fence), and `|# multi-line comment, indent-insensitive #|`.
- **Mostly incidental.** It shows that a *delimited, indent-insensitive* comment form was being explored.

### 2011-12-22 — udon-c `docs/DECIDED.md`

- **How dated:** git, 2011-12-14 → 12-22. **Speaker:** Joseph.
- "Decided" section:

  ```
  ## EMBEDDED / DELIMITED
  |{node ...}         # Inserted Node child - effectively splits text to left and right
  :{attribute ...}    # Inserted complex attribute, affecting the parent or root node
  !{directive ...}    # Results injected
  ```

- One-liners are defined *through* the brace form: `|one|two|three    ==>    |{one |{two |{three}}}`, with the column-alignment variants.
- "Once data text has started on a line, pipes etc. are all treated literally like any other text. Need a newline or embedded to get back to structured data."
- "Undecided" section:

  ```
  ## Embeds
   #{...}              # Embedded comment. You know you love it. But would then
                         be impossible to use well w/ Ruby.

   nah, we should do |{#        }

   what about a simplification for line-ending comments though?

   and here is some normal text blah blah    #| comment even though I'm in freetext

   meh... probably opens a can of worms...
  ```

- **Bears on:**
  - **Q3:** an embed "splits text to left and right". The idea that once text starts, only an embed (or a newline) gets you back to structure is the 2011 ancestor of the 2026 "`*{` principle".
  - **Q2:** the embedded comment was considered and parked as undecided. Its spelling was chosen to avoid colliding with host-language syntax (`#{}` in Ruby).

### 2025-12-23 13:24 — reboot SPEC has no `|{…}` yet

- **Source:** commit `f5813bd` (`SPEC.md`).
- Inline children `|a |b |c` nest rightward. `;` comments run to end of line: `|element :attr value  ; Inline comment after content`. "Comments are stripped by the parser."
- **Bears on:** the baseline before this question's constructs were re-added.

### 2025-12-23 13:52 — Joseph asks for inline notation, with an HTML motivation

- **Source:** prompt log, udon project. **Speaker:** Joseph.
- > "The following `|p Some text |em emphasis` is already correct and valid udon. The problem is that currently `|a |b |c` is treated like c is a child of b (is a child of a) instead of b and c being siblings. … I also had several potential inline notations that I played with IIRC. … would you then look at the older ~/src/_ref/udon and ~/src/_ref/udon-c projects and look for notes on the one-line issue and also potential notations for inline (like |{...} or I like the idea of ` | ` with no element-name being a potential delimiter."
- His pasted example was HTML, laid out one construct per line:

  ```
        |p
          Some introductory text with
          |em emphasis
          and
          |strong strength
          .
  ```

- Earlier that day (13:31) he had asked for an XML/HTML→UDON converter script.
- **Bears on:** the reboot re-introduced `|{…}` specifically for HTML-style inline markup and for writing siblings on one line.

### 2025-12-23 14:13 and 14:20 — `{|…|}` vs `|{…}`

- **Source:** prompt log. **Speaker:** Joseph. The agent's reply was not found (see Gaps).
- > "What are your thoughts on {|...|} vs |{...} ?"
- > "Yes, it does, and I agree. The symmetry with !{...} is the most compelling for me.
  >
  > So we need the inline form |{...}, and while nesting is properly defined in SPEC.md, I don't know if sibling indentation rules are:"

  He pasted the 2011 DECIDED one-liner table (`|one |two` / `|three ==> |{one |{two} |{three}}` …).
- **Bears on:** why the spelling is `|{…}` (symmetry with `!{…}`). The `|{…}` form is what the column rules were written in terms of.

### 2025-12-23 15:03 — first SPEC text for embedded elements

- **Source:** commit `d82af7a` ("Update spec with inline usage, a quick and dirty xml2udon script, and several output examples"; adds `bin/xml2udon`).
- The spec text says the embedded element "Becomes a child of the containing element (sibling to surrounding text)". Its examples:
  - `|p … |{a :href /foo a link} inline.`
  - `|nav |{a :href / Home} |{a :href /about About} …` ("Multiple embedded elements are siblings")
  - nesting: `|{a :href /doc the |{em official} documentation}`
- The grammar: `embedded_content = embedded_element | { CHAR - "|{" - "}" }+`.
- **Bears on:** the base definition. As in 2011, `|{a :href /foo a link}` means href `/foo`, content "a link".

### 2025-12-23 18:14–18:15 — sibling table cells need `|{td}`

- **Source:** prompt log, and commit `acb8b94`. **Speaker:** Joseph (prompt); agent (commit).
- On a table written `|tr |td Free |td |{n 60} …`, Joseph said: "That is absolutely incorrect UDON... but it's an example that keeps reappearing! (it has td's inside td's)".
- The commit rewrote tables as `|tr |{td A} |{td B}`. Commit message: "For siblings, use embedded elements: |{a} |{b} |{c}".
- **Bears on Q3:** brace forms on an element's line were, from here on, *the* same-line-siblings idiom for HTML tables and lists.

### 2025-12-23 18:31 — an inline element as an attribute value

- **Source:** prompt log. **Speaker:** Joseph.
- > "It adds a form of data that isn't represented in any other format, including xml etc. I'm undecided still, but since it's in SPEC we'll keep it in comprehensive. I also see it's actually used in the "real world example":
  >
  >     :rate-limit |{limit :requests 100 :window 60s}
  >
  > So maybe it really does make sense..."
- **Bears on:** the neutral file's `|el :label |{em Hi}` case, and its history of flips: 2026-07-19 (blob segment) and 2026-08-08 (value again).

### 2025-12-23 (day's usability runs; characterized 2026-07-21/22)

- **Source:** `udon-needs/01-ideation/02-provenanced/characterizations/I1-usability-result-bodies.md` and `copies/I1-usability/agent-feedback-excerpts.md`. **Speaker:** agents (haiku-4-5 authors; sonnet-4.5 feedback).
- The single most-reproduced authoring error was an extra closing brace, `|{…}}`, "across at least five independent runs and three genres". For example `|{em jitteriness}}` and `|{data :value 3}}`. The characterization: "The `|{…}` boundary is where agents lose track of nesting depth."
- A feedback agent quoted `|p See |{a :href /docs the docs} for details.`, reading "the docs" as the link text.
- Typed inline data such as `|{measurement :value 245 :unit ms :sd 32}` recurs as the thing agents *wanted*.
- **Bears on:** Q1 (brace counting is where authors fail), and on XML/HTML demand.

### 2025-12-23 19:17 — "tiers of voice"

- **Source:** prompt log. **Speaker:** Joseph.
- > "In a sense, when you include udon comments and larger inline elements, you end up with three or four tiers of "voice" for various needs... and that's before templating..."
- **Bears on:** comments and inline elements were framed together as separate registers within a document. The README's "Tiers of Voice" section came from this.

### 2025-12-24 08:09 — prefer Markdown over inline UDON in prose

- **Source:** prompt log. **Speaker:** Joseph.
- > "In fact... maybe in SPEC we should specify that Udon should generally prefer markdown in prose rather than inline-udon equivalents."
- This became CORE's style note ("Reserve `|{...}` inline elements for cases where you need attributes or semantic structure that Markdown cannot express").
- **Bears on:** positioning of the feature, not its grammar.

### 2025-12-24 16:01 and 16:44 — indentation questions for inline brace forms, and balanced braces

- **Source:** prompt log. **Speaker:** Joseph. Both prompts are about inline *directives* and inline raw; the brace family is shared.
- > "Anything non-raw is by definition meant to allow udon syntax structurally inside. Whether or not there is any indent sensitivity within an inline directive is still an open question though... So that's 2 more open questions not in SPEC: indent sensitivity in inline directives (or, more likely, how to *not* need it elegantly), …"
- > "for raw inline, do we require balanced curly brackets? I think yes-- with the understanding that if the user has curly braces in a string, for example, they'll just need to use block-level !raw ."
- **Bears on:** Q1 (indentation inside brace forms was an explicitly open question), and on balanced-brace handling.

### 2025-12-25 14:03 — `;{…}` is born

- **Source:** prompt log. **Speaker:** Joseph.
- > "I would like to make one more change to the spec before we continue.
  > ; block comment (i.e., any time a line starts with this. **TRIGGERS INDENT/DEDENT BEHAVIOR** even though it is effectively blank output
  > ;{...}  inline comment -- the only way to do udon-level comments within prose.
  > (obviously '; something...   is how you would emit the ";" as the first character for that line without interpreting it as a comment, like with the others)"
- **Bears on Q2:** the stated purpose of `;{…}` is being "the only way to do udon-level comments within prose."

### 2025-12-27 19:25–20:11 — the unified brace family and "bracket mode"

- **Source:** prompt log, libudon project. **Speaker:** Joseph.
- 19:27: "Oh, here's a fun one: `|ul{|li{|{a Home} | }|li{|{a About us} | }|li{|{a Help} | }|li{|{a Exit}}` or something". This is a test-stress idea, not a proposed syntax.
- 20:02:

  ```
  What about...
  |{element ....}
  !{{val | filter}}
  ;{inline comment}
  '|{element this is actually all still just prose but the "'" disappears}   \|{and so is this but the "\" disappears}
  !{raw:kind .... any \} must be escaped}
  !{not-raw within this we still have |{inline blocks} and ;{comments} etc.} ; dialects...
  |{  element[...].abc.def ...}  I suppose we should allow this but maybe issue a warning...

  So a lot more similar to the parsing already available at the beginning of the lines, with the difference being that it is bracked-nested instead of indent-sensitive. That reminds me, we'll need good tests for multi-line nested inlines like this as well...  We should probably also *disallow* |{inline element |next |another ...} just for conceptual simplicity-- and say once you're in bracket mode-- you have to stay in bracket mode until you're all the way out...
  ```

- 20:07: "we will be outputing events and comment text instead of discarding it-- it will be the next layer that will decide whether to keep them or discard them etc."
- 20:11: raw bodies use plain bracket counting, "unlike |{...} or something which would actually find inner |{...} etc."
- **Bears on:**
  - Q1: bracket mode; multi-line nested inlines flagged as needing tests.
  - Q2: comments are carried as events, not stripped.
  - An unasked edge: `|{␠␠element…}` (whitespace right after `|{`), "allow but maybe issue a warning."
- **Incidental:** the `'` escape (retired July 2026) and `!{raw:…}` spelling.

### 2025-12-27 21:36 — SPEC: bracket mode, multi-line, unified inline syntax, `;{…}`

- **Source:** commit `d974fa7` ("…as per the latest decisions on the inline syntax").
- Adds "**Once in bracket mode, stay in bracket mode.**" and "Embedded elements can span multiple lines—indentation inside is ignored, and the closing `}` ends the element". The example:

  ```
  |p This has |{a :href /docs
     a link that spans
     multiple lines} and continues.
  ```

- Adds a "Unified Inline Syntax" table (`|{`, `!{{`, `!{`, `;{`). On the inline comment: "uses brace-counting to find its end … For comments with unbalanced braces, use line-comment form instead." Comments are "emitted as events, not discarded".
- **Bears on:** the Q1 rule text ("indentation inside is ignored") and the Q2 definition.

### 2025-12-27 21:42–21:43 — "newlines are very different in embedded mode"

- **Source:** prompt log, libudon. **Speaker:** Joseph.
- > "Keep in mind that newlines are very different in embedded mode-- there are some open indent-sensitivity questions still-- for example, the following probably should not be allowed:
  >
  > ```
  > |alpha |{beta one
  > two three ;{dedented too far even for embedded-mode}}
  > ```"

  In the original, `two three` starts at column 0, left of `|alpha`.
- 21:43: "BUT-- if you would have a much easier time with newlines and indent/dedent being passed through just like in ``` -- we can probably do that too..."
- **Bears directly on Q1.** Joseph's own open questions: whether a continuation line may dedent to or past the owning element's column, and whether interior newlines/indentation should instead pass through verbatim like a fence. The example also puts a `;{…}` on the continuation line (Q2, incidental here).

### 2025-12-27 22:51 — the space between embeds is text

- **Source:** prompt log. **Speaker:** Joseph.
- > "Lexically speaking, there is no problem with a space between '}' and '|{' -- If the user doesn't want a space in embedded text, they wouldn't put one-- they would just use '|{first one}|{second one}"
- **Bears on Q3:** in this era, whitespace between adjacent brace forms was content. Compare 2026-08-08.

### 2025-12-28 00:01 and 12-31 08:23 — inside braces, attribute values are space-delimited

- **Source:** prompt log. **Speaker:** Joseph.
- 00:01: "`:msg hello world` is attribute :msg with value "hello", and then moves onto inner text "world :count 5" -- it's awful looking syntax but that's (I thought) what the spec says- *for inline attributes*. For block-level attributes it's different".
- 12-31 08:23: "sameline attr value embedded adds '}' - which I assume would make it return without consuming it so that it properly closes the embed."
- A Codex SPEC edit on 2025-12-31 (memorata, agent-to-human-flanking) wrote: "**Embedded** values are space-delimited; `}` also terminates the value".
- **Bears on:** how `|{a :href /docs the docs}` parses. In this era it gives href `/docs`, content "the docs". Compare 2026-07-15/16.

### 2025-12-28 13:24 — lines that *start* with a brace form

- **Source:** prompt log. **Speaker:** Joseph.
- > "That reminds me, do we have a good tests for *starting* lines with embedded syntax?
  >
  > ```
  >    |like this:
  >      !{{'the-issue' | embed}}
  >    ;{and this, as an edge case}
  > ```"
- **Bears on:** line-initial `;{` and `|{`. The neutral file covers `|{` ("begins a text line") but not `;{`; see 2026-09-01.

### 2025-12-28 14:37 and 15:52; 2026-01-01 12:14 — spanning lines, and trailing whitespace

- **Source:** prompt log. **Speaker:** Joseph.
- "Inline directives are not limited to single-lines"
- "I can't think of any scenario where whitespace should be consumed after anything inline-- }..."
- "You know inline interpolation and directives can span any number of lines, right?"
- **Bears on:** Q1 (multi-line was assumed for the brace family). The whitespace after `}` is kept (Q2 framing, Q3).

### 2026-01-01 (agent summary) — `}` after a quoted string

- **Source:** memorata, libudon session compaction summary (agent text). **Speaker:** agent.
- "**embedded_with_braces_in_content**: The fixture expected `Text "}"` but per spec, the `}` after a quoted string closes the embedded element".
- **Bears on:** how quoted strings and brace counting interact inside `|{…}`. Neither the neutral file nor the 0.10.0 text states this.

### 2026-01-01 17:52 — the spaces around a stripped inline comment

- **Source:** prompt log, libudon. **Speaker:** Joseph. He was responding to a fixture change of `|p ;{This is inline} text` from `[Text, "text"]` to `[Text, " text"]`.
- > "This one I feel we really can go either way:
  > …
  > The truth is, conceptually it should shrink to `|p  text` if the comment were "extracted" -- which would then render as Text("text") without that extra space.
  >
  > So if it's already assuming it really hasn't started "Prose" until after it hits "text" -- I think that is a valid interpretation of the spec."
- **Bears on Q2:** the framing-whitespace question. Joseph was open either way, with a conceptual pull toward the space disappearing when the comment is removed. Compare S18 (2026-07-21).

### 2026-01-02 11:56 — where `;{…}` may appear

- **Source:** prompt log. **Speaker:** Joseph.
- > "3. Either anywhere as inline ;{...} (balanced brackets inside)
  >   or potentially, if easier, inline anywhere within prose or on sameline:
  >   |element ;{inline comment} :attr value
  >   (so whether you can do this is undefined- it would be nice if it's not too complicated:   |ele;{hmmmm}ment :attr value ; -> == |element :attr value -- but events get weird.)"
- **Bears on Q2:** the intended reach of `;{…}`. "Anywhere" was the ideal. Mid-token (`|ele;{…}ment`) was explicitly left undefined.

### 2026-01-13 19:13–22:10 — flavors, inline-vs-block metadata, comments as leaves

- **Source:** prompt log. **Speaker:** Joseph.
- 19:13: "udon-xml -- limited to forms that can be expressed in XML naturally-- e.g., no complex elements as an attribute's value"
- 19:48:

  ```
  |should this
    |be able
    to be represented sometimes

  |should this |{be able} to be represented sometimes
  ```

  followed by: "Unless in a raw or ``` block / directive, we don't make any guarantees except that one potentially... and we say "it's up to the consumer to decide if they want to automatically put spaces between everything and dedup multiple spaces..."
- 19:53: keep "metadata … that specifies what *was* originally inline vs. block".
- 22:10: "in practice comments are only ever leaf nodes."
- **Bears on:**
  - Q1/Q2: at this point, whitespace around and inside inline forms was not a core guarantee; the consumer decides.
  - The AST shape (13): whether an element was written inline or as a block is kept as metadata, not as a different node kind.
- **Incidental:** the "udon-xml" flavor list is a sketch, not a proposal.

### 2026-07-08 — the reflow hazard

- **Source:** `_archive/REVIEW-JULY-2026.md` §6 (agent review). Joseph's prompt of that day endorses the "wrapping making an inline sigil suddenly structural" catch.
- A reflow that lands a sigil at line start "*promotes it to structure*". Probed: "`;-)` became a comment".
- **Bears on:** line-initial `;{`/`|{` after a reflow of prose. The same class as the 2025-12-28 question.

### 2026-07-14 16:23–16:40 — escaping the inline openers

- **Source:** prompt log, and CHANGELOG 0.8.0-alpha.1 ("in prose flow a `\` before an inline opener `|{` / `!{` / `;{` makes it literal"). **Speaker:** Joseph.
- > "inline directives that we support right now absolutely need to be able to be escaped."
- > "Because we alreay definitively know if an inline opener is really an inline opener within two characters, … For inline-- we *can* list the exact sequence it is considered an escape (the exact allowed opening inline sequences, which I don't remember exactly)"
- **Bears on:** `\|{` (listed in the neutral file) and `\;{` (not listed there).

### 2026-07-15 — attribute values change; comments inside embeds ruled out "for now"

- **Source:** prompt log (20:30, 23:28); CHANGELOG "Changed (2026-07-15 fresh-eyes review pass)"; CORE pins in the 0.8.0 entry. **Speaker:** Joseph (prompts); agents (CHANGELOG).
- 20:30, on the new sameline attribute rule (an attribute's value no longer ends at the first space):
  > "I was very reluctant due to its departure from what the spec constantly used to warn about... but this new rule is so simple and clear *and* it aligns with principle of least surprise for newcomers to udon at least, so I'm going to bite the bullet :-)"

  The same prompt, on a line-initial embed inside a text body:

  ```
  |el
    the text has begun
    |{em x} clearly still text
      |also clearly still text although we will want to issue a warning
  ```

- 23:28:
  > "S1. I don't see any problem with |{em having comments in embeds ; emphasized to illustrate point while discussing} but we can rule it out for now in the spec with a note that we'll probably add it back into embeds once all of the dialect stuff and therefore embedded work is more fleshed out and well-understood."
- The CHANGELOG records this as R20: "Embedded `|{…}` framed ` ; ` comments ruled out for now (bare `;` literal, `;{…}` only)".
- The same day CORE pinned two things: "multiline embedded per-line Text", and "prose between embedded siblings" (`|nav |{a A} |{b B}` yields `Text " "`).
- **Bears on:**
  - Q2: inside braces, only `;{…}` comments; the framed ` ; ` is literal, provisionally.
  - Q3: whitespace between siblings is text.
  - Line-initial `|{`: its line is text.
  - The attribute-value change leads directly to the next entry.

### 2026-07-16 02:17 — "embedded is element-rooted sameline" (R2)

- **Source:** prompt log; CHANGELOG "R2 embedded = element-rooted sameline (+`}`)"; CORE "Contexts and Terminators". **Speaker:** Joseph ratifying an agent's option A.
- > "A can ratify it in concept though and the other two lines.
  > Add the following too:
  > |{a :href /home :title Home \ Welcome home!}
  > and note that the following will probably be added once dialects are good to go:
  > |{a :href /home :title Home \ Welcome home! ; hope that helps}
  > (but that it will have unspecified results in 0.9)"
- The resulting CORE text:

  ```
  |{a :href /home :title Home here}      ; title = "Home here" -- the blob runs to } -- NO content
  |{a :href /home :title "Home" here}    ; title = "Home"; content "here"
  ```

- Fixture evidence (`core/fixtures/v0.9/inline_embedded.yaml`, `multiple_embedded_are_siblings`): `|{a :href / Home}` → `[Attr, "href"] [Text, "/ Home"]`, with no content.
- **Bears on:** how an attribute value inside `|{…}` ends. Since this date, under mainline 0.9 an unquoted value inside braces runs to `}`. Link text needs quoting or `\`. This reverses the 2011 and 2025-12 reading.

### 2026-07-16 20:10 — embed internals expected to move to dialects

- **Source:** prompt log. **Speaker:** Joseph.
- > "I also don't think we can answer the EOF question completely in 0.9 because I highly suspect we will be turning over parsing of embedded/inline stuff to dialects.."
- **Bears on:** the several "revisit with dialects" rows below (framed ` ; ` in embeds; S18).

### 2026-07-18 — line-boundedness ruling

- **Source:** CHANGELOG "Ruled (2026-07-17/18)". **Speaker:** Joseph's rulings, recorded by agents.
- "Embedded `|{…}` … locked **multi-line**." Every remaining delimited construct — explicitly including `;{…}` — "is **single-line for now, multi-line deliberately undefined**".
- An embed open at EOF counts as delimited (content kept, `UnclosedEmbedded`).
- **Bears on:** Q1 (`|{…}` multi-line is settled). For Q2, `;{…}` across lines was left undefined.

### 2026-07-19 11:13–15:48 — `;{` and the `*{` principle

- **Source:** prompt log; CHANGELOG "Ruled (2026-07-19; densification pass)" and "The general `*{` principle — CONFIRMED". **Speaker:** Joseph.
- 11:25:
  > "the thing that would least surprise me as a user is `|el :n ;{}` === `|el :n ""`  and `|el :n ;{<EOF>` -> same but with unclosed comment warning.  `|el :n value ;{` == `|el :n "value "` and unclosed comment warning (note the trailing space)..  In other words, the right thing to do is definitely treat ;{ as a continuation of the text, and an opening of something that is meant to be reduced to text.  All *{...} constructs, embeds if you will, are assumed to *reduce to more text* (even if, in the case of the comment, that text is "" (not including comment events))."
- 11:27:
  > "*{ should never take someone out of text/prose mode, and if encountered as the beginning of something, should start text/prose mode as if it was literal text. Is that internally consistent in the spec?"
- 11:34:
  > "I would say `|el :n |{em x} :a 1` == `|el :n \|{em x} :a 1` (that is, all blob text for the :n, but with the sameline trailing ' ; ' comment still active unlike in the '\' case)"
- 11:36:
  > "a symmetry question (probably a 0.10 question) -- would it make things more symmetrical to have a @{...} embed as well?"
- 13:43: "S4 Ratify empty anon embedded element". This is R19: `|{}` is valid.
- 15:48:
  > "correct -- brace-form are embeds, and are always meant to be reduced to or surrounded by text
  > ;{} is a no-op empty comment embed"
- The same day, the text-wire recast made multi-line embed content per-line Text with terminators; continuation indentation is "geometry".
- **Bears on:**
  - Q2: `;{` in value position, `;{}` ≡ `""`, and the unclosed-at-EOF behavior.
  - Q3 prehistory: at this point a brace form *never* started a separate value; it always committed text.
  - Line-initial brace forms: "if encountered as the beginning of something, should start text/prose mode."

### 2026-07-20/21 — S18: framing whitespace "preserve" (panel lean, not a Joseph ruling)

- **Source:** `.archived/second-pass/RULING-TABLE.md` (status OPEN) and `RULING-SUPPLEMENT.md` §S18; `DECISIONS.md` S18, filed under "Operator / panel-lean closes (2026-07-21) … **Overturn freely**". **Speakers:** agents (grok draft, Fable stress-check).
- The supplement:

  ```udon
  |p This is some text ;{TODO} and more text.
  ```

  > "Stripping the comment leaves `…text  and…` — **two** spaces … **A** pin that (live behavior, concat-pure) · **B** collapse to one space (whose layer? not the parser's) · **C** defer with the dialect work … **Lean: C, or A-as-pin (both). B at the core layer would reintroduce fabricated-byte joining — the disease the text law just cured.**"
- The same batch has S11: inline raw in value position is a flow segment.
- **Bears on Q2:** where the neutral file's "both framing spaces are kept" came from. The pushback given was principled: core must not invent bytes.

### 2026-07-22 — 0.9.1 consolidated suite

- **Source:** `spec-0.09.01/CORE.md`, `MODEL.md`, primer. **Speaker:** agents, consolidating.
- Carries S18 as "ruled S18, revisit with dialects". It also states: "A line-initial `|{` opens an **inline element** as the first segment of a flow line, participating in hierarchy at its column."
- **Bears on:** the "begins a text line" rule the neutral file cites. The label "ruled" on S18 is discussed under Threads.

### 2026-07-29 01:23 and 07-30 13:35 — why agents want inline elements

- **Source:** prompt log. **Speaker:** Joseph.
- > "when I first starting pitching udon to agents, I remarked that they would easily be able to embed different perspectives such as confidence bounds as inline elemets etc."
- > "this kind of multiple voice levels in a single document is one of the reasons / uses that agents get most excited about using udon for (it's embedable epistemology and reasoning traces and so forth)"
- **Bears on:** the non-HTML demand for both `|{…}` and comments.

### 2026-08-08 13:31–14:03 — K9: sameline is value space; "`}` suppresses LF"

- **Source:** prompt log; `DECISIONS.md` K9 and Overturns (R4 scope, S11); `theory/to-integrate/primary/K9-DRAFT-2026-08-08.md` and siblings. **Speaker:** Joseph, then agents drafting.
- 13:31:
  > "What to do with this on sameline:  `|element |{embed-1} |{embed-2}`  This used to be mentioned as a way to have |embed-1 and |embed-2 as *siblings* rather than |embed-2 being a child of |embed-1 which is the default behavior. But we removed it because it didn't really work and exposed lots of cracks and gaps in the spec. Now maybe we've just made it a reality!"
- 13:56: "What the |el |{embed-1} |{embed-2}   also does is turn it from a hack (as evidenced by the interveaning ' ') and the real intent..."
- 14:02: "No-- I meant the current spec is the hack-- the tell is the space. The new clean model is :'$main' [|{embed-1}, |{embed-2}]  period -- no space, no implication of being in a text block, etc."
- 14:03: "Or, in other words,  |{element ...}  <- closing '}' essentially just supresses LF"
- The ruling (K9 §3):
  - At a clean value-expected position, a brace form self-delimits as a value and whitespace separates.
  - Mid-flow R4 stands: `:n value |{em x} :a 1` is unchanged.
  - "Inline-element *interiors* keep space-as-content (bracket mode; stated, not discovered)."
  - "Sameline material is never *content*: `|el |{a} |{b}` = two stacked `$main` values; `content` is empty".
- The fork notes flag a further flip: `|el :n ;{} :a 1` went from `n = " :a 1"` to `n = ""` with `:a` real.
- **Bears on Q3.** This is where the distinction the neutral file describes comes from: text first → one flow with pieces; brace first → separate values. Joseph's own framing is the "`}` suppresses LF" model.

### 2026-08-09 09:01–11:44 — values, keys, and "what it means to embed"

- **Source:** prompt log; `DECISIONS.md` K15, K16. **Speaker:** Joseph.
- 09:18: "the equivalence *I* stated earlier should still stand: `|el` / `:attr |{a} |{b}` should be the same as `|el` / `:attr [|{a} |{b}]` *until/unless* a second thing were stacked onto :attr in the second example."
- 09:27, a mental model explicitly marked "**NOT** a ruling": `|e :attr |{a} |{b}` ⇒ `:attr = [|{a} |{b}]`.
- 09:42:
  > "It makes it clear in the source the separation between the last attribute's value and the element's $main, which in the case of html etc. will always be interpreted as the first and sometimes only part of the inner-content."
- 11:07 (K16): "|{x} is not block-form. I don't know why you would carve out extra grammar for 'kind of almost values' in a place that was specifically meant to encapsulate a value."
- 11:28:
  > "there are / should be probably three distinct forms of many things. block/geometric, value, and embedded (or maybe it's embedded-value...) distinctly embedded in prose, where at least I have continued to loosely conflate value-form with embedded-form... (this is me thinking out loud, not necessarily asking for any resolution etc.)"
- 11:44: "we haven't fully explored exactly what it means to embed".
- **Bears on:**
  - Q3: the value-vs-flow reading of brace forms.
  - The AST placement of `$main` for HTML (`|ul |{li …}` puts the `li`s in `$main`), which interacts with question 13.

### 2026-08-10/11 — 0.10.0 text (the neutral file's cited source)

- **Source:** `spec-0.10.00/CORE.md` §2.2, §3, §5.6, §6.4, §6.6, §7.3, §8, §13.2.
- §5.6: "**Multi-line** (settled): … Continuation indentation is geometry (skipped); each content line carries its terminator; the opener line's terminator belongs to the form when its line ends inside the braces."
- §6.4: an unquoted text value runs until space + block-form marker, framed `\`, framed ` ; `, EOL, "or the context's terminator (`}` in an inline element …)".
- §6.6: inside `|{…}`, "no framed sameline comments — a bare `;` is literal".
- §8: "Inline `;{…}` framing whitespace is **preserved** on strip (… revisit with dialects)".
- §13.2: multi-line `;{…}` "deliberately **not specified**" (the ML carve-out).
- `TUTORIAL.md` still shows `|p Deploy uses |{a :href /docs/deploy the deploy guide} — read it first.` without a tree.
- **Bears on:** everything in the neutral file. See "What the neutral file misses" on the href example.

### 2026-08-11/12 — lexical-forms matrix: comments as the "accidental exemplar"

- **Source:** `theory/to-integrate/lexical-forms-discussion-2026-08.md`, `lexical-forms-matrix-2026-08-11.md`. **Speaker:** agents, from sessions with Joseph.
- > "**Comments are accidentally the design exemplar** — the only construct with a complete non-conflated form set: distinct block (geometric, line-owning!), sameline (framed), embedded (`;{}`), and a *deliberate* value-hole (`;{}` at a slot → `""`)."
- > "embedded = uniformly `{…}`-composed (`|{` `!{` `!{{` `!{:` `;{`, now `@{`)".
- **Bears on Q2:** in that analysis, `;{…}` is part of what makes the comment family complete. Dropping or reserving it removes one cell of the exemplar.

### 2026-08-27 — comments become "annotations" (0.10.1-draft)

- **Source:** prompt log (16:10, 16:36); `theory/to-integrate/lexical-forms-redux.md`; `spec-0.10.01/DELTAS.md` rows 10–13. **Speaker:** Joseph (prompts); Fable (draft).
- 16:10: "Is there a reason you don't mention annotation as one of the things (comments) … ?"
- 16:36:
  > "Yes, precisely. And for me, the other tell that this is the right model for comments in addition to the practical realities is the fact that I see from the diffs of your modifications just now that you had started smuggling in 'aside' and aside mark and and leaving channel fuzzy …  Whereas now, it's done."
- DELTAS 11 overrides 2026-07-19: "a slot with only annotation material has no value material (ordinary missing-value rule)". So `|el :n ;{}` → Error + Nil, not `""`.
- The draft also declares `;{…}` able to span lines.
- **Bears on Q2.** The model Joseph endorsed is annotation interiors as opaque. The value-slot override was agent-drafted, and the whole draft was later called a misfire (Sep 1). Whether the misfire judgment reaches the *comment model* specifically is not recorded.

### 2026-09-01 — audit of 0.10.1-draft, and the "misfire"

- **Source:** `spec-0.10.01/working-notes/AUDIT-2026-09-01.md`; `spec-0.10.01/fixtures/descriptive/gaps.yaml`; `WHERE-THINGS-STAND-2026-09-27.md` (Joseph's "I'm going to call 0.10.01 a misfire"); `JOSEPH-FOR-0.10.01-FIX.md` (agent text). **Speaker:** agents; Joseph for the misfire line.
- Audit C6:
  > "Line-initial `|{` opening an inline element "as the first segment of a flow line, participating in hierarchy at its column" (0.10.0 §2.2/§3) — dropped. Now also needed for line-initial `@{`, `!{`, and — note — `;{`, which by §8's table is a *line annotation* at a structural column, so `;{note} then prose` at line start swallows the whole line (and deeper lines)."

  Fixture `gap_D5_line_initial_semicolon_brace` gives two readings.
- D14: "`;{…` spanning lines in prose … one unclosed inline annotation holds the rest of the document as annotation body; is that intended?"
- A6: DELTAS 11 makes `|el :todo ;{fill in}` an Error.
- D10: does a framed `\` inside `|{…}` swallow the `}`?
- The FIX proposal (agent text): "In a body, markers are literal. Only `|{`, `!{`, `;{`, `@{` are live, and `\` in front of one makes it literal."
- **Bears on Q2:** line-initial and multi-line `;{` edges; the value-slot result.

### 2026-09-29 18:02 — lite

- **Source:** prompt log. **Speaker:** Joseph.
- > "|{...} inline elements are critical for one of the most obvious use-cases-- xml/html"
- **Bears on:** the settled part of the neutral file.

---

## Threads worth noticing

*My reading, not established fact.*

1. **The HTML link idiom was reversed in July 2026, without the XML/HTML case being named.**
   - In 2011, and in Dec-2025 through Jan-2026, `|{a :href URL text}` meant href = URL, content = "text". Joseph said so explicitly on 2025-12-28 ("*for inline attributes*").
   - On 2026-07-15 the sameline attribute rule changed ("bite the bullet"). On 2026-07-16, R2 carried that change into braces ("embedded is element-rooted sameline"), so `|{a :href /home :title Home here}` became title = "Home here", no content.
   - 0.10.0's K10 kept that: an unquoted value runs to `}`.
   - The 2026-07-15 rationale was least surprise for *element lines*. I found no discussion weighing it against the HTML/DocBook link shape. That shape is the densest real use of `|{…}`, and the tutorials still write it the old way.
   - Now that Joseph calls XML/HTML *the* motivating case for lite's `|{…}`, this looks like the question with the most user-visible consequences here.

2. **"Both framing spaces are kept" has thin provenance.**
   - Joseph's only recorded words (2026-01-01): "we really can go either way", leaning conceptually toward the comment "shrinking" away.
   - Mainline CORE's worked example strips to a single space ("This is some text and more text.").
   - The two-space rule is S18, an agent panel lean filed under "Overturn freely". 0.9.1 and 0.10.0 then cite it as "ruled S18".
   - The panel's argument (core must not invent or collapse bytes; collapsing is a consumer's job) is a real one. It just isn't Joseph's ruling.

3. **Several parts of `;{…}` were parked "until dialects".** Under lite's reserve-don't-ignore contract, putting `;{…}` *in* would freeze them:
   - framing whitespace (S18 "revisit with dialects");
   - the framed ` ; ` inside braces (R20 "out for now"; Joseph: "we'll probably add it back into embeds");
   - multi-line `;{…}` (0.10.0 "deliberately not specified").

   *Reserving* `;{…}` instead would refuse the one comment form Joseph designed as "the only way to do udon-level comments within prose". Every era had some embedded comment: `<(# … #)>` in 2011, `|{# }` in late 2011, `;{…}` in 2025. What differs between eras is the spelling, not the need.

4. **Q3's distinction is recent and came from Joseph's own model.** Before 2026-08-08, the space between `|{a} |{b}` was text content (Joseph 2025-12-27; CORE pin 2026-07-15). K9 redefined it with "`}` suppresses LF" and called the old reading "the hack — the tell is the space".
   - In 2011, embeds likewise "split text to left and right". Only "a newline or embedded" returns from text to structure, which is the ancestor of R4's "mid-flow, brace forms are segments".
   - The simplest alternative for lite ("running text with pieces") is roughly the 2025-12/2026-07 state. The K9 state gives cleaner siblings, at the cost of two readings of the same brace depending on what precedes it.
   - Joseph on 2026-08-09 was "thinking out loud" about three forms (block / value / embedded), and said "we haven't fully explored exactly what it means to embed."

5. **For HTML, K9 puts same-line children in `$main`, not content.** `|ul |{li one} |{li two}` yields two `$main` values and empty content. Joseph (2026-08-09): for HTML, `$main` "will always be interpreted as the first and sometimes only part of the inner-content". So whether lite's AST (question 13) presents `$main` as content decides whether the neutral file's `ul` example reads as a list with items.

6. **Q1's multi-line rule has three historical answers:**
   - 2011: newline = space, no indentation.
   - Dec 2025: "indentation inside is ignored". Joseph's open question was a continuation dedented *past the owning element* ("probably should not be allowed"), with the alternative of passing interior lines through "just like in ```".
   - 2026-07: per-line Text keeping each "\n", continuation indentation skipped as geometry.

   The fixture (evidence only) strips *all* leading whitespace of the continuation line. Nothing I found says what happens when a continuation line sits at or left of the owning element's column, or how uneven continuation indentation is treated.

7. **Brace counting is where authors fail.** The Dec-2025 corpus's top error was an extra `}`. Lite's "keep everything, warn" posture, and whether a stray `}` in text or values is literal, will decide how gracefully that common mistake degrades.

---

## What the neutral file misses

1. **The example tree `a(href "/docs"; "the docs")` doesn't follow from the rules it cites.**
   - Under 0.9 R2 (CORE: `|{a :href /home :title Home here}` → title "Home here", "NO content"; fixture `|{a :href / Home}` → href "/ Home") and under 0.10.0 §6.4/§6.6 (unquoted value ends at `}`), `|{a :href /docs the docs}` gives href = "/docs the docs" and no content.
   - The tree shown is the 2011 / Dec-2025 reading.
   - Q1's "are the rules complete" probably needs an explicit sub-question: how does an unquoted attribute value inside `|{…}` end? Space, or run to `}`? Current idioms for link text are `:href "/docs" the docs` or `:href /docs \ the docs`.

2. **Line-initial `;{`.** The file covers line-initial `|{` ("begins a text line") but not `;{`, where the specs contradict each other:
   - By the comment-position table, `;` at a structural column is a line comment that owns the whole line and deeper lines (audit C6, fixture `gap_D5`).
   - By Joseph's 2026-07-19 `*{` principle ("if encountered as the beginning of something, should start text/prose mode"), it starts a text line.
   - Joseph asked for exactly this test on 2025-12-28. The reflow hazard (2026-07-08) makes it practical, not just theoretical.

3. **`;{` in a value slot.** `|el :n ;{}` gives `""` per Joseph on 2026-07-19 (and `|el :n value ;{` → `"value "`). 0.10.1-draft changed this to Error + Nil (DELTAS 11). Under K9, `|el :n ;{} :a 1` flipped from `n = " :a 1"` to `n = ""` plus a real `:a`. Q2's option A shows only the prose case.

4. **Multi-line `;{…}`.** 0.10.0 deliberately leaves it unspecified, 0.10.1-draft declares it spanning, and the audit (D14) notes that one unclosed `;{` then swallows the rest of the document. Q1 raises multi-line only for `|{…}`.

5. **Where the "kept framing spaces" rule came from.** See Thread 2: agent panel (S18, "Overturn freely"), against Joseph's 2026-01-01 "either way / conceptually it should shrink" and mainline CORE's one-space example.

6. **Edges inside braces:**
   - the framed ` ; ` inside `|{…}` is literal (R20, "for now");
   - framed `\` inside braces versus `}` (0.10.0 left the ` ; ` case unspecified; terminator-table D-f and audit D10 ask whether `}` still closes);
   - a `}` inside a quoted string within braces (2026-01-01: it closes the element);
   - unbalanced literal `{` or `}` in interior text, and how to escape them (the listed escape is only `\|{`; `\;{` is also an escape per 0.8.0-alpha.1; `\}` is nowhere stated);
   - whitespace right after `|{` (`|{ em x}`), which Joseph in 2025-12 thought should be allowed with a warning.

7. **What nests inside `|{…}` under lite.** "Only inline forms nest inside" now needs to say which inline forms are lite-legal inside braces (`|{`, possibly `;{`) and which are recognized-and-refused there (`!{…}`, `!{{…}}`, `@{…}`). If Q2 reserves `;{…}`, it is also refused inside embeds.

8. **Q1 has a concrete prior case and alternative from Joseph.**
   - The dedent-past-owner example (2025-12-27 21:42): `|alpha |{beta one` ⏎ `two three …}}` at column 0, "probably should not be allowed".
   - His offered alternative (21:43): pass newlines and indentation through "just like in ```".
   - The 2011 rule: newline treated as a space.

9. **Q3 and the AST.** The neutral file's `ul` tree lists the `li`s as `$main`, which is correct under K9. It doesn't say that `$main` is an attribute and not content, which matters for HTML (Thread 5; question 13). It also doesn't mention that Joseph offered `:attr |{a} |{b}` ≡ `:attr [|{a} |{b}]` as his mental model (2026-08-09, "NOT a ruling").
