# 09 — Reserved syntax: history

**Who wrote this:** Claude (Opus 5.5), a history agent for question [09](09-reserved-syntax.md), 2026-09-29. It covers history only; leans get added later by others.

**Method.** I read the primary sources wherever I could reach them. Joseph's typed words come from his prompt history, which keeps the original layout. Agents' words come from files in the repo, plus memorata excerpts where no file existed. I did not open raw `.jsonl` transcripts, because they contain model thinking. Wherever a line reads as my interpretation rather than what a source says, I mark it **(my reading)**.

**Dates.** Git dates are commit dates. For Joseph's prompts I converted the `history.jsonl` timestamps to local time (America/Denver). This matters around midnight, because several UTC dates fall on the next day. Memorata dates are the ones memorata reports, and some of those are only file-origin dates.

**Sources searched, so that any "nothing found" can be checked:**

- **Joseph's typed prompts.** I merged `~/.claude/history.jsonl` and all 25 `~/.claude.bak.*/history.jsonl` backups and removed duplicates. I kept prompts whose project path contains `udon` or `descent`, or whose text mentions udon: 3,546 prompts, 2025-12-21 → 2026-09-29. I filtered those with the regex `@\[ | @\{ | @< | (^|\s)@[a-z] | !\{ | !if | !: | [Dd]irective | reserv | inert | interpolat | warn.before | spec.lite | simplified | safe subset | forward.compat`, and then again for `disallow|reserved|undefined|warn` and for the dates 2026-08-27 → 09-29. I read all 191 prompts that matched in full. This prompt history starts in late September 2025. The only record of anything Joseph said before that is the 2011 git history.
- **memorata-search.** Every query used the classes `human-user agent-to-human document subagent-final-response` unless noted:
  - `"udon directive bang reserved"` (probe)
  - `"udon directives bang reserved future syntax" --joseph -n 40 --pool 200` → 1 hit, noise
  - `"directive ! syntax udon" -n 60 --pool 300`
  - `"@ reference in prose email mention literal udon" --joseph -n 40 --pool 300`
  - `"reserved syntax lite parser future udon refuse" --joseph -n 30 --pool 300`
  - `"I feel like the @[id] introduction of '@' is potentially overkill |[id]" --joseph -l`
  - `"directives inert carried as-is experiment" --joseph -n 30 --pool 200` → noise (ASF and AISI material)
  - `"line-initial @ or ! in prose promotes to structure hazard" -c agent-to-human subagent-final-response document --in <udon paths> -n 25 --pool 80`
  - **Queued but never run:** eight more queries (warn-before-disallow; bang guard; `@{` replacing `!{{`; tiny/simplified parser; forward-compatible subset; directive body/children; reference syntax; the `!{{` decision). They were cut off when memorata was paused for memory. I covered those topics with the history-file filters above instead, so there is no memorata pass over agent-side chat for those topics.
- **Git.** `git log -G` in the umbrella repo for `!\{\{`, `!raw`, `!:[a-z]+:`, `!\{:`, `!\{-`, `@\{`, `@\(`, `@<`, `@\.`, `@@`, `@[a-z]+\[`, `@\[`, `:\[[a-z]`, `warn-before-disallow`, `[Rr]eserved`, `[Ii]nert`, `!\{[a-z]`. In `~/src/_older/udon` (2011): `git log -p` filtered for `!` and `@` syntax lines.
- **Read in full:**
  - The question file, both READMEs, and siblings 06 and 12
  - `WHERE-THINGS-STAND-2026-09-27.md`, `JOSEPH-FOR-0.10.01-FIX.md`, `DECISIONS.md`, `INBOX-REQUESTS.md`
  - `spec/DYNAMICS.md`
  - `lexical-forms-discussion-2026-08.md`, `lexical-forms-matrix-2026-08-11.md`, `lexical-forms-redux.md`
  - 0.10.01 `DELTAS.md` and `working-notes/spelling-grid.md`
  - `_archive/spikes/prose-collision-2026-07.md`
  - udon-c `docs/DECIDED.md` (2011)
- **Read in part:**
  - `spec/CORE.md`: Core/Open, positional contexts, prefixes, marker recognition, the scan, raw, dynamics, references
  - `spec/msc/CHANGELOG.md`: sections touching `!` and `@`
  - 0.9.1 CORE §§2–4, 9–12
  - 0.10.0 CORE §2.2, §3, §6.4, §7.3, §9, §12.2
  - 0.10.01 CORE §2.3, §3, §4, §9
  - `AUDIT-2026-09-01.md` (grepped)
  - The unification matrix (grepped), `terminator-table.md` (§1 plus grep), `design/udon-paths.md` (grepped), `design/UDON-AGENT-TOOLS.md`
  - REVIEW-JULY-2026 §3.6 and §7.9, `CONSUMERS.md`
  - vivarium `doc/PROCESS.udon` (the `udon-safe-subset` norm), the descent grammar's `!` and `@` guards
  - `references/` (grep for `@` spellings), the archived `hypothetical-sketch.md` (§1 plus grep)
  - The first Dec-2025 SPEC.md and the commits that changed its `!` spellings
  - The 2011 `misc/udon.vim`
- **Corpus scan.** All `.udon`/`.ud` files under `~/src` except this repo, `_older`, and `_ref` (161 files), grepped for each `!` and `@` family.
- **Not searched:**
  - The needs corpus (`udon-needs/`)
  - The greenfield specs, beyond one memorata sighting
  - Any fixtures (core or 0.10.01)
  - `design/examples/` in full, `_archive/analysis.md`, and the intermediate SPEC.md revisions between Dec 2025 and July 2026

---

## History (chronological)

Each entry gives the date and how I know it, the source, the speaker, the words, and a **Bears/Incidental** line. Joseph's prompts are quoted verbatim, typos included, and trimmed only where marked with `…`.

### 2011

**2011-07-19 → 2011-08-25 — `~/src/_older/udon/misc/udon.vim` (git, commits 9342239 → 9850a3c). Speaker: Joseph (his vim syntax file).**
The syntax file treats a line starting with `!` as a structural block, exactly like `|`: `syn region udonStructBlock start="^\z(\s*\)[|!]" end="^\%(\z1 \| *$\)\@!"`. It highlights `!name` as a type, with the keywords `if elsif else`, `for`, and `def`. On 2011-08-25 it adds `syn match udonLocation /@\S\+/` (later `/@[^ \r\n()]\+/`), matched inside blocks.
*Bears:* this is the earliest evidence of `!` at line start opening a block that owns the indented lines under it, the same as an element. It is also the earliest `@`: `@` plus any run of non-space characters was a "location". *Incidental:* `#` comments, `{…}` bound blocks.

**2011-08-15 — `.attic/syntax.udon` and `.attic/scratch.asciidoc` (commit dd667d3, "random scratchings"). Speaker: Joseph.**
Lines include:
- `!element         # directive (position independent)`
- `{@@element}` and `{@id}`
- `!uuuu # EXPRESSION` and `<{!uuuu}> # embedded EXPRESSION (can be embedded many more places than elements)`
- `!urlencode !urlencode !urlencode a+b  # --> a%25252Bb`
- `{!' '!}`, `!%!blah`
- The lexical notes: *"Text that has one of ! or | after a newline+\s* needs to be escaped"*, and an escape list that includes `{!` and `!} (if within an embedded expression)`.

*Bears:* from the start, a line-initial `!` inside text is structural and needs an escape. `@` appears inside braces as a reference. *Incidental:* `{|…|}` and `:if` experiments.

**2011-12-08 → 12-22 — `~/src/_older/udon-c/docs/DECIDED.md` (git). Speaker: Joseph.**
> ```
> !{directive ...}    # Results injected
> !{-directive ...}   # Run, but nothing injected
> !{'...'}            # (instance of directive for specialized text processing...
> ```

Labels "STOPS ON: whitespace or `[|\[.!]`". Values stop on "dedented newline or space __plus__ `[|#.!:]`". Also:
> *"## DIRECTIVES — not much decided yet (see below), but indentation-rules etc. will very likely be exactly the same as nodes."*
> *"Unknown: directives treated like nodes? Probably."*

The undecided section asks about `!" ....  "` strings. The file contains no `@`. The 2012 C parser (`lib/udon.c`) also ends labels at `!`.
*Bears:* `!{…}` inline forms, including a "run but inject nothing" variant, date from 2011. Directives were expected to follow node indentation rules. **Note:** the 2026-08-09 lexical-forms appendix says *"The 2011 `~/src/_ref/udon` originals predate `!` dynamics entirely — nothing there."* The three entries above contradict that.

### December 2025 — the rewrite

**2025-12-21 16:52 — Joseph (prompt history, project `src`).**
> "Actually-- slightly different tack: One of the other innovations in the last many years has been (in my opinion)-- the highly-constrained templating paradigm-- e.g., Liquid templates-- … there are some simple directives for (essentially) enumeration, template-values, filters, and conditionals... We could always just *use Liquid* directly as a preprocess for udon-- but can you imagine an extension of Udon (or repurposing some of what it already has) for a set of dynamics roughly in the same order as Liquid?"

*Bears:* the origin of the Liquid-style `!` dynamics as an *extension*.

**2025-12-23 — `SPEC.md` first commit, f5813bd (git). Speaker: document (Joseph + agent).**
- `!` is one of "Four special characters at line start" (Dynamics: evaluation, control flow, interpolation).
- `!{expr}` is interpolation, with filters.
- Block directives: `!if / !elif / !else / !unless / !for item in collection / !let / !include partials/header`.
- `!code :elixir` for code.
- Grammar: `dynamic = "!" ( directive | interpolation )`, `directive = LABEL { CHAR }*`.
- Host examples: `!{@assigns.user}` (an `@` inside an expression).
- References: `:license @[mit]` in a value slot, and `@[header]` at line start: *"Insert the entire element"*. `:[id]` merges attributes.

*Bears:* `!` line-start directives, `!{…}` in text and values, `@[id]` at line start and in values. *Incidental:* suffixes, rationals, the `'` escape.

**2025-12-23 14:20 and 21:25 — Joseph (project `udon`).**
> "Yes, it does, and I agree. The symmetry with !{...} is the most compelling for me. So we need the inline form |{...}…"

At 21:25 he gives an example in passing: `Along with some content including |{em inline} elements` / `as well as !{context.template_value}...`
*Bears:* the brace-family symmetry (`|{`, `!{`) is Joseph's stated reason for the inline forms.

**2025-12-24 — `!raw` spellings (git abf273b, 38a2231) and Joseph's comments.**
- abf273b: `!code :elixir` becomes `!raw:elixir`, and inline raw becomes `!{raw:json {…}}`.
- 38a2231 briefly spells inline forms `!raw:json{{…}}` and `!name{content}`, and adds *"Syntax for inline control flow (e.g., `!if{cond}{then}{else}`) is under investigation but not yet specified."*

Joseph:
> 07:45 "Ah, great question... `!raw:json {"hello": 42}` -- probably just fully replaces it. Now it's up to the host to decide what it wants to do with raws in the various places, and up to the host to provide whatever dialects. But the truth is... in many cases I think the non-raw non-liquid directives can just be passed through to the consumer/renderer/etc..."
> 07:58 "Inline raw would be like this:  `|config !{raw:json {"status": "OK", "count": 42}}` and cannot be an attribute value-- those are typed."
> 16:01 "Anything non-raw is by definition meant to allow udon syntax structurally inside. Whether or not there is any indent sensitivity within an inline directive is still an open question though... The above notation allows for this now as well though:  `There !if{...}{...else-block?? or is that too much now...`"
> 16:29 "For number four there, indicate that we don't *currently* support inline liquid control directives, but that syntax to do so is still an open investigation."

*Bears:* the passing-through posture for directives, the sketch of inline control forms, and that non-raw means a UDON body.

**2025-12-25 — Joseph 14:40 (project `udon`), and the brainstorm docs (git a8365a6).**
> "references-- especially if we need forward referencing (currently undefined-- especially for streaming) might need to be punted on right now indefinitely until I spec them better. Same with mixins."

The brainstorms (`design/UDON-AGENT-TOOLS.md`, `UDON-AS-ACP-FORMAT.md`) use:
- `|{@ :confidence 0.6 …}` for annotations
- `@.auth`
- XPath-like `//|endpoint[@method='POST']` and `//*[@.auth]`

*Bears:* more `@` spellings (inside inline elements, trait-only, inside path predicates). The 0.9 status banner later ruled `|{@ …}` invalid.

**2025-12-27 → 28 — Joseph settles the inline family (project `libudon`; git d974fa7, 2fe2fdb).**
> 12-27 19:31 "Does the spec only have this form for directives?   `!something{...}` and not `|element{...}` ?"
> 12-27 19:37 "…I realized that it's a lexical form that would require accumulation in the parser in a way that will slow it down-- because the parser won't know if it was all part of a directive or not until it hits the '{' --
> !some-really-really-really-really-really-really-long-directive is really just prose
> but here !some-really-really-really-really-really-really-long-directive{is an actual directive}
> … So now I'm reconsidering the !\w+{...} syntax altogether..."
> 12-27 20:02 "What about...
> |{element ....}
> !{{val | filter}}
> ;{inline comment}
> …
> !{raw:kind .... any \} must be escaped}
> !{not-raw within this we still have |{inline blocks} and ;{comments} etc.} ; dialects...
> … The main new addition is the specialized liquid-like syntax sugar: !{{...}} which for now we can issue events as !{raw:liquid-i11n ...} or something..."

Commit d974fa7 (12-27) adopts these: `!{{expr}}` for interpolation, `!{directive …}`, `!{raw:kind …}`, and *"The second character after `!{` determines the form."*
*Bears:* the `!{`-family spellings and the reason for them: bounded lookahead, with the form known by the character after `!{`.

**2025-12-28 — Joseph on directive bodies and raw spelling (project `libudon`).**
> 13:16 "The block directives just need to distinguish one thing: whether or not they start with `raw:`. If they start with raw:, the parser treats the content as similar to prose (doesn't look for inner elements or anything-- just assumes it's all prose, uncluding output dedent, until the correct dedent happens to finish that block). If it does not start with raw, the rest of the line is considered the "statement" for the directive, and then normal children udon content for the next indented lines until it's closed by dedent. We don't have to do things like only allow if/for/let/unless/include -- we can, for now, allow *any* directive…
> For all inline directives, the same thing. !{raw:...  brace counting only ...}   For !{non-raw  |{el can have nested udon}}"
> 13:24 "…do we have a good tests for *starting* lines with embedded syntax?
>    |like this:
>      !{{'the-issue' | embed}}
>    ;{and this, as an edge case}"
> 14:22 "Keep in mind that it is a later pass's responsibility to decide if !else or any directive is in the right spot or whether or not it needs a statement etc. At your stage you get to treat them all uniformly"
> 14:32 "correct-- at least a non-raw directive should work exactly like element, and raw directive should act exactly like a block comment."
> 14:37 "Inline directives are not limited to single-lines"
> 14:50 "Also, except on column 0, a block level directive must be *preceded* by a space"
> 15:12 "`!:label` is what I was thinking initially, but I think I'm going to land on `!:json: {"abc": 123, "def": "block level so } can be unbalanced"}` and `!{:json:{"abc",123}}` -- basically you start the "inner language" immediately after the second ':'…"
> 17:54 "The new syntax: !:...: and !{:...: ...} is authoritative-- I just forgot to have the agent update the SPEC* files…"

Commit 2fe2fdb (12-28) makes `!raw:lang` → `!:lang:` and `!{raw:kind …}` → `!{:kind: …}`.
*Bears:* **the content under a directive line**: the rest of the head line is a "statement", the indented lines are ordinary UDON children, and dedent closes. A raw body is taken verbatim, "like a block comment". Any directive name is accepted, and inline forms may span lines.

**2026-01-01 — Joseph (project `libudon`).**
> 09:25 (on the old `'` escape) "'| asdf   ->  "'| asdf" <- Normal prose since that '|' is not the beginning of a block (applies to [!:] also but not [;] …"
> 12:14 "You know inline interpolation and directives can span any number of lines, right?"
> 14:53 "…I have no problem letting us specify in the spec that if an inline ! turns out to be interpolation, we can say we have started prose."

*Bears:* whether inline forms may span lines (relevant to how far a reserved span extends), and that `!{{` at line start begins prose.

### January 2026

**2026-01-03 16:41 — Joseph (project `udon`; memorata also finds it in `~/.claude/history.jsonl:7020`).**
> "I feel like the @[id] -- or rather the introduction of '@' -- is potentially overkill, when instead we could say |[id] -- which would also allow for inline element references: |{[id]} but then we lose the potential semantics of '@'."

*Bears:* whether `@` should exist at all was open in January 2026 (`feedback.md` proposed `|[id]`). *Incidental:* the escaping and hard-return ideas in the same prompt.

**2026-01-05 — Joseph (project `archema`).** In passing, an example of the raw block in use: `!:ruby:` under `|action[archive]`.

**2026-01-13 19:13 → 2026-01-14 17:08 — Joseph (project `udon`).**
> 01-13 19:13 "Imagine for a moment we have the following subsets or flavors of udon (examples-- not really MECE):
> - udon-xml -- limited to forms that can be expressed in XML naturally…
> - udon-md -- subset of udon where all prose (except as specifically typed as a different language in a directice) is assumed to be markdown…
> - udon-template -- the subset that uses the liquid-like directives and a host-language …"
> 01-13 21:21 "…`And some inner prose etc. !{if true}yup!{endif}`" and at 21:25 "I believe it's already supported, yeah. The big difference being that block form doesn't need the !endif because it's implied by indentation.  raw directives are supported inline as well."
> 01-14 07:07 "I love it, and love the @element[id] . I agree it feels like the sweet spot. I suppose we could still offer @[id] and error if it turns out to be ambiguous within the document…"
> 01-14 07:56 "As for ancillary systems-- I feel like we can separate all templating directives into a "template mode" or something that is somewhat host-dependent and that isn't needed by many (most probably) udon documents."
> 01-14 17:08 "…the syntactical lineage begs for a "dialect" -- e.g., "This is Archema dialect of udon ->  !dialect Archema ....""

On the same day `design/udon-paths.md` (git e8b82f7) adds `@user[alice]:email` and `|order[123]:customer@` (a trailing `@` meaning "follow the reference in this attribute").
*Bears:* the earliest idea of **subsets of UDON**, with templating/directives as an optional layer that most documents don't need. More spellings: `!{if …}…!{endif}`, `!dialect`, `@element[key]`, and `@` at the end of a path.

### July 2026 — the reboot

**2026-07-08 — `_archive/REVIEW-JULY-2026.md` §3.6 and §7 decision 9 (git c553b73). Speaker: agent (estate review), citing Joseph's framing.**
> "a wrap that lands a sigil-initial token at line start *promotes it to structure* — `:attr syntax` became a live attribute, `;-)` became a comment…, `!important` became a directive."
> Decision 9: "`|`'s guard (pipe + space = prose) is the existence proof that promotion hazards are grammar problems, not user problems (Joseph's framing, verified). Decide tightened guards for `:` …, `;`, and `!`."

*Bears:* a line-initial `!` or `@` in prose is the measured hazard class.

**2026-07-11 — `_archive/spikes/prose-collision-2026-07.md` (spike S3). Speaker: agent.**
It probed the parser at the time, line-initial only:
- `!` + letter → a named Directive
- `!` + anything else → a phantom empty Directive, with the `!` eaten
- `@[` → Reference

Measured results:
- In the CommonMark corpus, all 21 markdown-image lines (`![alt](url)`) were promoted. A real `!` letter-guard moves survival from 89.7% to 93.0%.
- In 10.6 MB of reflowed estate prose: *"Residual after guard: letter-initial directives in prose (`!important`-class; here `!directive),`) — accept, linter's job."*
- `@[` promoting in prose occurred zero times in either corpus: *"noting for completeness since the identity-syntax decision … may move this sigil anyway."*

*Bears:* the origin of the `!` guard (identifier or `:`), and the measured frequency of line-initial `!`/`@` in real prose.

**2026-07-11 — vivarium `doc/PROCESS.udon`, norm `[udon-safe-subset]` (vivarium git 5b92773). Speaker: document (vivarium steward).**
> "Until the udon reboot lands its decision valve + udon-cli (fmt/lint), author within the verified safe subset (recon 2026-07-11): bracket ids unquoted; attributes always before prose/children; raw blocks via !:lang: never triple-backtick fences; no @-references; never start a prose line with a bare colon; …"

*Bears:* a **safe subset that came before lite** and excluded `@`. The same norm *required* `!:lang:` for code, the opposite of what lite plans. (The reflow in that norm itself placed `!:lang:` at the start of a line, where it parses as a real raw block. `CONSUMERS.md`, 2026-07-16, calls that a field instance of the promotion hazard.)

**2026-07-11 — Joseph (project `udon`).**
> 17:57 "1st. `@` survives with exactly one meaning: **inert typed pointer** — `@element[key]` explicit, `@[key]` shorthand that *errors* when ambiguous — Accepted and ratified. …"
> 22:27 ""the non-reserved ones" -- I would be careful about calling them reserved instead of specially-designated ones or something..." (about `$`-keys)
> 23:16 "Right, head-position structural directives... Since they're also dialect-defined and we were separating the template stuff to a dialect I forgot about that-- yeah, we definitely still need that syntax.  OK, I'm on board with it having essentially the same behavior as '|'. … ; :one for the ages is just normal text. Nothing to worry about.  Same with ! *if* it's indented further than the "Hello" (in this example)..."
> 23:19 "Some nuance, I should add--- ! is a directive if followed by an identifier-character *OR* a ':' (for code blocks, IIRC)"
> 23:21 "Ah, but let me continue-- the following *does* indicate a true directive or head position:
> ```
> |p
>   good
>   !if beastlike == true
>     enough
>   !else um, ok
>   enough for now...
> ```"
> 23:23 "To be clear---  !{...} is interpolation within text/prose mode-- not structure level. It can be the very first thing in some prose..."

*Bears:* the `!` guard in Joseph's words. A `!name` at the prose base column is a real directive, even between prose lines. A `!` deeper than the prose base is text. `!else um, ok` shows a same-line body. A line-initial `!{…}` begins prose. Also Joseph's care with the word "reserved" (it was about `$`-keys, not this question).

**2026-07-13 → 07-16 — `@` becomes inert; the `@` guard widens (Joseph; CHANGELOG 0.8.0-alpha.1 and 0.9.0-alpha.1).**
> 07-13 19:53 "First of all, we can officially sunset the attribute-merge syntax, replaced by parser-defined reference behavior @[some-key]"
> 07-14 16:28 "inline directives that we support right now absolutely need to be able to be escaped."
> 07-15 15:05 "we almost certainly want *references* to be a valid type for an attribute. … `|element` / `@other[123]  ; we allow...` … `:two @other[xyz]` … `:three !:normal: ...   ; valid` / `:four ```also-valid`"
> 07-15 15:39 "I vote (element, key, traits) tuple, until we tie down a path syntax that might drop in and replace the whole thing wholesale. @[mit] -> (null, 'mit', []) … @.realized -> (null, null, ['realized'])"
> 07-15 16:09 "#3 (inline raw) can actually be deferred completely for 0.8…"
> 07-15 23:28 "B3-- extend the guard to '.'.   I am still a little unsure about even using the word "guard" and that section... it seems redundant and more of a lexical implementation thing than something that should be part of the core spec. … S7. @ has equal footing with |. … `|el :ref @[asdf].hey` / `@another[xyz]` / `That there is a reference, just like el.ref's value`"
> 07-16 16:02 "I think we can consider !:lang:...the-body-has-already-started...\n not getting picked up just a plain ol' bug."

CHANGELOG: *"References `@` are inert at the core level; the `:[id]` attribute-merge syntax removed"* (0.8.0-alpha.1, 07-14). *"`@` guard extended to `.` … and `@` given equal footing with `|` in the sameline scan — a reference can be an attribute's value, a boundary-following sibling, or a block-line child"* (07-15).

An interim ruling in 0.8.0 (07-15) is a close precedent in shape: *"until the dialect layer exists, a conformant parser recognizes the envelope … but emits a Warning that no dialects are loaded and passes the value through as the plain string `"<…>"` — nothing lost, nothing silently retyped."*
*Bears:* where `@` is recognized (line start, sameline, value slot), the inert posture, the escape requirement for inline `!` forms, and a precedent for "recognize, warn, keep the bytes".

**2026-07-16 — `CONSUMERS.md` (git). Speaker: agent.**
> "Nobody uses `@` references, inline `|{…}` elements, freeform fences, `<…>` value envelopes, or `:key?` flags yet."

*Bears:* the corpus as it stood in mid-July (see the corpus entry for 2026-09-29 below).

**2026-07-18 → 07-19 — EOF, lines, and the brace principle (CHANGELOG, Joseph).**
Rulings in the CHANGELOG:
- A nameless `!{` at end of input is the prose text `"!{"`.
- New `UnclosedInlineDirective` and `UnclosedInlineRaw` codes.
- Interpolation and references are valid **array items**.
- S5: `|div[!{{id}}]`, interpolation as a whole element key.
- `@[ ]` → nil.

Joseph:
> 07-18 22:45 "I know the spec says that multiline is unspecified behavior right now but that we'll warn if we need to cut multi-line access...  But the truth is most of those *will* end up being multi-line."
> 07-19 11:29 "(I think with the exception being where !{ needs a little more before it knows if it's an actual embed or what directive to dispatch to and therefore we're saying it can just emit !{ if cut off there as text, which is fine, right?)"
> 07-19 11:36 "BTW... a symmetry question (probably a 0.10 question) -- would it make things more symmetrical to have a @{...} embed as well?"
> 07-19 13:55 "I'm ok ratifying current behavior as close enough to "undefined but we'll warn you if we're going to start disallowing multiline". Please make sure any fixtures that are descriptive of technically undefined behavior get allowed to be part of the gate but that they *don't* frame themselves as prescriptive. … the last thing we want is for purposefully unspecified behavior to nevertheless calcify into the grammar."
> 07-19 15:48 "correct -- brace-form are embeds, and are always meant to be reduced to or surrounded by text"

CORE ("The inline-brace principle") then lists *"the `!{…}` family … and the anticipated `@{…}` inline reference form"* as prose-level forms.
*Bears:*
- The first `@{…}` I found is Joseph's question on 07-19.
- "Warn-before-disallow" originated here, as Joseph's phrase about multi-line behavior. It pairs with his concern that deliberately unspecified behavior not "calcify".
- Array items and key brackets became positions where `!{{…}}` and `@…` can appear.
- Whether the inline `!{…}` forms span lines was left undefined for 0.9. Joseph expected most of them to become multi-line.

**2026-07-22 — the 0.9.1 consolidation (`spec-0.09.01/CORE.md`). Speaker: document.**
- §3 guards: `!` + identifier or `:`; `@` + `[`, `.`, or `XID_Start`.
- §9 lists five `!` forms: `!name …`, `!:label:`, `!{{expr}}`, `!{name …}`, `!{:kind: …}`.
- §12.2 gives the selector table.
- "Committing to prose" keeps *"a mid-prose `!`"* literal.

*Bears:* the settled 0.9 set of positions and spellings.

**2026-07-23 → 07-28 — Joseph's paths musings (project `udon`).**
> 07-23 13:52 (pseudo-UDON, marked "not the point I'm making") `|db[discussion-docs] @{dir[asf]}/01-aat-core/src/disc-*`
> 07-28 18:50 "…the basic idea was that the main primitive was some sort of `@include` directive that CLAUDE.md (for example) already supports..."
> 07-28 18:57 "…something "lower-level" that must resolve to an udon ast -- like `@[core://components/another.udon # main-findings]` or something (just throwing out a random syntax without any lean…)"
> 07-28 21:11 "The answer should be as simple as "|company-primary-url !{was: site}" or something to that effect."
> 07-28 21:48 "…emergent ones, like 'Prefer @element-kind[id] instead of just [id]'…"
> 07-28 21:54 "Yes, I loved your !:quote: usage-- a very good candidate for "best practices" one day…"

*Bears:* spellings that were proposed but never ruled on: `@{…}` glued to text, `@include`, `@[scheme://… # frag]`, and `!{was: …}`. Joseph also used `!:quote:` approvingly. *Incidental:* the include and lineage purposes behind them.

**2026-07-29 — `v2/spikes/extraction-probe/README.md` §3.2 (memorata; git). Speaker: agent.**
> "an assessment prose line began with `@element[key]:attribute …` at column start → the parser read a **Reference plus a stray attribute** … The hazard class — line-initial `@`/`!` in prose silently promoting to structure — now has three field instances…"

*Bears:* a third field instance, this time `@` at the start of a prose line.

**By 2026-07-30 — `theory/to-integrate/refine-more/paths-ideation/terminator-table.md` (git 579ac29, a relocation; created earlier). Speaker: agent.**
- `@acme/widget` is a reference `acme` plus the text `/widget` in the grammar, but one reference by CORE's name rule (open item REF-SLASH).
- `@[core://… # frag]` parses as one reference only because of the interim raw wire (REF-BRACKET).
- The `@` guard has no `'` (so `@'quoted name'` cannot be written).
- `@@` was probed as a "free starter" (guard fails, so it is text).

*Bears:* spellings at the edge of the `@` guard.

### August 2026

**2026-08-06 23:06 → 08-07 10:58 — Joseph (project `udon`), and the archived `references/.archive/second-theory-iteration-2026-08-08/hypothetical-sketch.md` (agent, 08-07).**
> 08-06 23:06 "`|element` / `!if directive` / `; A comment` / `  :a-path @< descriptor / descriptor / descriptor >` — Here the a-path is unresolved… the @<...> indicates this is a specific *typed* value… The idea is that this: @element[designator]  becomes syntax sugar for essentially: `!resolve-and-insert @<|element/[designator]/{1}>`   ; directive-name also up for grabs"
> 08-06 23:34 "…so the only "objects" that the foreach would work on would be something like  !{let a | @<....>} ...  !{foreach a as el} Hello !{{el:name}}! How are you?!{end-foreach} (I don't actually remember what the directives are provisionally)..."
> 08-07 10:58 "…@<mystuff/h?/**/p> -> any |p anywhere within any of |h1 |h2 |h3... (and use desugared @<mystuff/h:'$?' true/**/p>…)"

The sketch (agent) says of `@<…>`:
> "**Free real estate, verifiably.** The `@` guard admits only `[`, `.`, identifier-start. `<` fails it, so `@<` is plain text in every existing document — extending the guard is additive; nothing retypes."

It also has `@[uuid]?`, `@*.header`, `@h4+` (cardinality), `@<{…}>`, and `@{element[39902]}` as the inline form.
*Bears:* **the reasoning that picked `@<` as a future spelling was that it is plain text today.** A future spelling minted this way is exactly the kind of meaning change that "reserve, not ignore" exists to prevent. *Incidental:* the path semantics.

**2026-08-07 21:27 and 21:53 — Joseph; K3 (DECISIONS).**
> 21:27 "1. Directives are kind of 'pseudo'-defined in this version, yes?  Generally it would be validated to resolve to something like this: `|el :x !if cond` / `<2026>` / `!else` / `|super-date ...` — But for 0.9.1 I think we might just need to say that directives for 0.9.1 can sit anywhere an element can."
> 21:53 "…essentially right now we need a better parser than the old 0.8 one-- but we need it in order to do the work we need to do on the directives etc.-- which means we specifically don't want directives to do anything yet-- just get emitted as is so we can experiment with things."

K3 records: *"Directives … sit anywhere an element can, and are inert — recognized, carried verbatim (head unparsed), never resolved."* 0.9.1 and 0.10.0 §9 add a warning: *"The head swallows the rest of the line … in `|el :x !if cond :y 2`, the `:y 2` is part of the head string."*
*Bears:* directives in the value position. The directive's head takes the rest of the line. Carrying directives inert is itself a "keep the bytes, do nothing" posture.

**2026-08-08 — K10 (DECISIONS). Speaker: coordinating agent's record of Joseph's ruling.**
> Unquoted values end at "a space + guard-confirmed block-form marker (`:key`, `|name`, `@ref`, `!name`, `!:…:`, fence, `\`)… Hazard, named: a sameline value *mentioning* a framed guard-passing token (` @alice`, ` !important`, ` :status`) terminates early — quote it or `\`-force…"

*Bears:* inside sameline values, a space followed by `@name` or `!name` is a live marker, not text.

**2026-08-09 — K16, the three-forms idea (Joseph; DECISIONS; lexical-forms-discussion).**
> 11:10 "I am NOT at all ok with carving out some different syntax within a key vs normal attribute values. And @[...] is still just a key…"
> 11:12 "I'm ok with only allowing |el[@{key}]  -- same carve out as before."
> 11:28 "So, there is actually an open debate right now-- or rather unsettled design question. We're considering potentially something like this: @<{   }>  for the value form. I guess that starts to help crystalize me that there are / should be probably three distinct forms of many things. block/geometric, value, and embedded…(this is me thinking out loud, not necessarily asking for any resolution etc.)"
> 11:44 "…because we couldn't nail down the directives and haven't the references yet … we haven't fully explored exactly what it means to embed (even interpolation is a hack at the moment…"

*Bears:* `@{key}` inside key brackets, with bare `@x` kept out of brackets but held "lightly". The `@<{…}>` value form. Joseph's own description of `!` and `@` as not yet nailed down.

**2026-08-09 → 08-11 — `spec-0.10.00/CORE.md`. Speaker: document.**
- §2.2 splits **value-space** (sameline: markers live between values) from **text-space** (block prose: markers literal, except that line starts at a structural column are Structure Position).
- §6.4: `!{{` announces its own value, and ` @ref` / ` !name` end an unquoted value.
- §7.3 lists the inline forms.
- §9 lists five `!` forms and says they are inert "in this version".
- §12.2: `|el[@{key}]`, *"The `@{…}` inline reference form is thereby demanded; its full grammar is paths-era work."*
- CARVEOUTS: whether `!{{…}}` and `!{…}` may span lines is open.

*Bears:* the fullest statement of which positions recognize which spellings, which is the baseline question 09's table uses.

**2026-08-09 onward — the `.ud` definition files (git, `v2/references/def/`).** These files use `@{term}` in live prose as their term-link form: about 116 occurrences in v2 `references/def/`. The idiom has spread outside the repo: 13 files in `~/src/ai-risk-model/influx/model-beta/terms/` and `verisectorium/…/rc1-in-udon.ud`, about 78 lines in all. The last of these also writes value slots like `:strength !strongest-line @record[rule-nesting]` and `:as-of !now`.
*Bears:* real documents already put `@{…}` in prose and bare `!name` / `@name[key]` in value slots, for the future meaning.

**2026-08-27 — Joseph, and the redux and unification matrix (project `udon`).**
> 14:05 "…(I think part of it, for example, would be retiring the interpolation syntax for something more directly a directive, or something...)"
> 14:25 "…@<...> (spelling aside) being something that distinguishes holding a reference *as the value* (i.e., the type of the value is "reference") -- vs @anything-else  actually meaning the referent(s) -- when exactly that lookup happens still not fully defined…"
> 15:50 "…references themselves (from outer-path/logical-path --> inner-selection etc.-- the entire reference including filters etc.) ARE the only thing we need to have everywhere…"
> 16:28 "…I *am* sold based on your pre-edit comment that yes, Directives are deferred generators of the atomic parts, often using resolved referents as their primary prerequisite."

The unification matrix (agent) classifies:
- `!{{expr}}` "collapses → reference"
- `!include` "collapses → reference"
- `!name` "collapses → element grammar + species mark"
- `!:kind:`, fences, and `!{:kind:}` "collapse → hold + vocabulary tag"

*Bears:* the direction that later became the `@{…}` spelling and element-shaped generators.

**2026-08-27 → 08-28 — the 0.10.1 draft (`spec-0.10.01/`, single-author, PROPOSAL DRAFT; judged a misfire on 09-01). Speaker: agent (Fable), in the session Joseph licensed.**
- §3 guards: `@` + `[`, `.`, `{`, `<`, or `XID_Start`. `!` + identifier or `{` (no longer `:`).
- §9.1: `@head`, `@{head}` (replaces `!{{expr}}`), `@<head>` (a held reference, alternative `<ref: head>`), cardinality suffixes `@reviewer?` `@tags*` `@authors+`, `pre@{x}post`, and the escape `\@`.
- §9.2: generators "parse exactly as an element does".
- §9.3: the block capture `<kind:` at Structure Position replaces `!:kind:`, and `!{:kind:…}` is dropped.
- DELTAS' breaking note: *"under this draft's §3 guard, `!{{expr}}` is an inline generator named nothing."*
- Spelling-grid note 7: *"Text-space markers are literal — bare `@`, `!`, `:`, emoticons, `3:1`, `email me @joseph` all pass through untouched. The only live openers in flow are the brace-composed forms (`|{` `!{` `;{` `@{`)."*

Joseph, 08-28 08:15:
> "…the `:a \7 hundred` vs `:a \ 7 hundred` ambiguity worries me on the second and third column, and the fourth column worries me if you mean that those sigils have to be escaped no matter where they appear in text..."

*Bears:* the newest proposed spellings, and a guard change (`!:` would become text). Joseph was concerned about having to escape markers inside text.

**2026-08-30 — `v2/INBOX-REQUESTS.md` (git, committed 09-21). Speaker: Joseph.**
> "…a set of tiny, dependency free "simplified udon" parsers … It would need to warn when there are constructs (like references or directives or unknown data types etc.) that it encounters that it won't parse. The actual subset that they all (or each independently) will "parse" is up for debate, as long as the result is small enough that it's convenient to just pop in place for simple udon usage for now, dependency free, (e.g., for udon used as a simple predictable data layout / xml equivalent / yaml-or-json alternative), and aware of what it (or each one) can't do."

*Bears:* the direct predecessor of lite: *warn* on references and directives.

**2026-09-01 19:19 → 19:59 — Joseph's audit session on 0.10.01 (project `v2`), `AUDIT-2026-09-01.md`, and `JOSEPH-FOR-0.10.01-FIX.md`.**
> 19:46 "I see; renamed directives -> generators and gave them the same basic parts as a node. OK."
> 19:51 "So... seems like 0.10.01 mostly renames the parser to recognizer, says it doesn't do things *on purpose* instead of warning that nothing will handle it, and viola. Except it doesn't seem to work well for the verbatim capture you say?"
> 19:55 "All three things were my suggestions early on before any of the theory."
> 19:59 "It's not like there's a ton of theory even. I'm going to call 0.10.01 a misfire. … Do you have a clean proposal that you can explain to me in udon -> ast  (to skip the exponentially exploding jargon)?"

The audit (agent) raises:
- **B4:** under the draft's `!` guard, `!:sh:` is text, so the promised alias can't exist.
- **C6/D5:** a line-initial `@{`, `!{`, or `;{` is now live at block level, and it is unclear whether `!{}` is valid.
- **D6:** what does `|el[@x]` produce?
- **A3:** `@user.admin?` has two readings (trait `admin?`, or trait `admin` with cardinality `{0,1}`).

The FIX proposal (**agent text**, not Joseph's) is 0.10.0 plus three changes:
1. `@{…}` replaces `!{{…}}` "everywhere and the parser carries it as text".
2. "A `!` line parses like a `|` line" (`!for :item @posts :as post`, `|el :script !sh make build :y 2` with `:y 2` belonging to `sh`).
3. The "nothing will handle this" warnings are removed.

Its unquoted-value terminators include ` @ref` and ` !name`. It says *"In a body, markers are literal. Only `|{`, `!{`, `;{`, `@{` are live."* The FIX calls the three changes "your three sentences". I could not verify which of Joseph's statements it meant, since the session's non-Joseph turns were not read. Joseph on 09-27, per WHERE-THINGS-STAND: it "seemed less and less principled as he questioned it."
*Bears:* the most recent full proposal for `!`/`@`, and the contrast between warning and silence. Joseph's 19:51 wording describes 0.10.01 dropping the "nothing will handle it" warnings. Whether he approved of that change is not clear from the text.

**2026-09-29 17:55 and 18:02 — Joseph (project `udon`), starting spec-lite.**
> 17:55 "…I would like you to attempt a spec-lite-0.1.0/ which would specifically *disallow* any grammar that is going to be used in the future (!,@,etc.)-- the basic subset. …"
> 18:02 "100% agreed on reserve, not ignore. That's definitely what I meant by deliberately disallowing it. In the corpus right now we have a ton of need for this lite parser and tooling-- and I absolutely don't want them accidentally putting in essentially reserved syntax that would change the documents' behavior later unexpectedly."

*Bears:* the settled part of question 09. Note the "etc." after `!,@`.

**2026-09-29 — the corpus as it stands (my scan of 161 `.udon`/`.ud` files under `~/src`, outside this repo).**
- `!:kind:` block verbatim: 7 lines in 4 live documents (`vivarium/DECISIONS.decision-log.udon` `!:md:`, `vivarium/LEXICON.udon` 3× `!:md:`, `vivarium/doc/PROCESS.udon` `!:sh:` plus the accidental `!:lang:`, `asf/…/PROCESS-MAP-v0.udon` `!:text:`).
- `@{…}`: about 78 lines in 14 `.ud` files.
- `!name` / `@name[key]` in value slots: 1 file (`rc1-in-udon.ud`).
- No line-initial `!name` directives. No `!{{`, no `!{name`, no `@<`.

*Bears:* which existing documents would stop being valid lite under a given reserve list.

---

## Every spelling ever proposed

Status key: **live-0.10.0** = recognized by 0.10.0-alpha.1, the latest suite that was not judged a misfire. **0.10.01⟨P⟩** = proposed in the misfire draft. **FIX** = in the 09-01 agent proposal. **retired** = replaced, date given. **sketch** = floated, never ruled.

Position key:
- **L** = line start at a structural column (including between prose lines at the prose base)
- **S** = sameline scan / value-space
- **V** = value slot (attribute, `$main`, deferred first line)
- **A** = array item
- **K** = inside `[key]` / `@[…]` brackets
- **P** = mid-prose (text-space flow)
- **I** = inside `|{…}`

### `!` family

| Spelling | Position | First seen | Status then → now |
|---|---|---|---|
| `!name …` (block directive; head + indented body) | L | 2011-07 vim syntax (`!if`/`elsif`/`else`/`for`/`def`) | Dec-2025 SPEC → 0.9/0.9.1/0.10.0 live, inert, head unparsed → 0.10.01⟨P⟩/FIX: parsed like an element |
| `!element` "position independent" | L | 2011-08-15 scratch | sketch |
| `!name` as a node value (`:x !if cond …`) | S, V | Joseph 2026-08-07; K3 | live-0.10.0 (head swallows rest of line); FIX: rest of line is the generator's |
| ` !name` as an unquoted-value terminator | S | K10, 2026-08-08 | live-0.10.0; FIX |
| `!else um, ok` (same-line body) | L | Joseph 2026-07-11 | exemplar; 0.10.0 carries it as unparsed head; FIX parses it as `$main` |
| `!code :elixir` | L | SPEC 2025-12-23 | retired 12-24 |
| `!raw:lang` | L | 2025-12-24 | retired 12-28 |
| `!:lang:` (block verbatim; body by dedent) | L | Joseph 2025-12-28 (`!:label` considered first) | live-0.10.0; FIX keeps; 0.10.01⟨P⟩ → `<kind:` (alias optional; the guard as written makes `!:` text) |
| `!:lang: tail` (same-line body) | L, S | ruled 2026-07-16 | live-0.10.0 |
| `:script !:sh: make build` (verbatim as node value) | V | 2026-07-15/16 | live-0.10.0; FIX |
| `!{expr}` (interpolation) | P, V | SPEC 2025-12-23 | retired 12-27 (the spelling became the inline directive) |
| `!{raw:json …}` / `!raw:json{…}` / `!name{content}` | P | 2025-12-24 | retired 12-27/28 |
| `!{{expr}}` (interpolation, closes at first `}}`) | P, V, A, K (whole key, S5), L-as-prose | Joseph 2025-12-27 | live-0.10.0 → 0.10.01⟨P⟩/FIX: replaced by `@{…}`; under the 0.10.01 guard `!{{x}}` reads as "an inline generator named nothing" |
| `!{{'file.un' \| include}}` | P | DYNAMICS (Dec 2025) | sketch |
| `!{name …}` (inline directive, UDON body) | P, V | Joseph 2025-12-27 (`!{not-raw …}`) | live-0.10.0; 0.10.01 keeps |
| `!{:kind: …}` (inline verbatim) | P, V | Joseph 2025-12-28 | live-0.10.0; 0.10.01⟨P⟩ drops it |
| `!{:json:{…}}` (no separator space) | P | Joseph 2025-12-28 | variant; separator later ruled |
| `!{` nameless at EOF → text `"!{"` | P | 2026-07-18/19 | live-0.10.0 |
| `!{}` (empty) | P | AUDIT D5, 2026-09-01 | open |
| `!{` at line start | L | Joseph 2026-07-11: prose-level | live-0.10.0 (begins prose); 0.10.01 makes it block-live (AUDIT C6) |
| `!{-directive …}` "run, nothing injected" | P | 2011-12 DECIDED | sketch |
| `!{'…'}`, `!" … "` | P | 2011-12 DECIDED | sketch / undecided |
| `<{!uuuu}>`, `{!' '!}`, `!%!blah`, `!urlencode !urlencode a+b` | P | 2011-08-15 scratch | sketch |
| `!if{cond}{then}{else}` | P, V | 2025-12-24 | parked "under investigation" |
| `!{if true}yup!{endif}` | P | Joseph 2026-01-13 | sketch |
| `!dialect Archema` | L | Joseph 2026-01-14 | sketch |
| `!resolve-and-insert @<…>` | L | Joseph 2026-08-06 | sketch |
| `!{let a \| @<…>}` · `!{foreach a as el}…{end-foreach}` | P | Joseph 2026-08-06 | sketch |
| `\|company-primary-url !{was: site}` | S | Joseph 2026-07-28 | sketch (OPEN LINEAGE) |
| `!for :item @posts :as post` (generator with attributes) | L | 0.10.01 / FIX | ⟨P⟩ |
| `![img](x)`, `!=`, `!(`, bare `!` | L, P | guard ruled 2026-07-11 | literal in 0.9+ (before the July fix, a phantom directive ate the `!`) |
| `!important`, `!directive),` at line start | L | measured 2026-07-08/11 | passes the guard → directive; "accept, linter's job" |
| `!` mid-prose | P | — | literal in every version since Dec 2025 |
| `\|field!` (element suffix) | element name | SPEC 2025-12-23 | see [06](06-suffix-characters.md) |
| `:done!` (inside a label), `.foo!` (inside a trait) | label, trait | K12 2026-08-08; 0.9.1 trait continue | ordinary characters |
| `\!…`, `\!{` (escapes) | L, P | 2026-07-14 (`\` before `!{`) | live |

### `@` family

| Spelling | Position | First seen | Status then → now |
|---|---|---|---|
| `@location` (`@` + non-space) | in blocks | 2011-08-25 vim | sketch |
| `{@id}`, `{@@element}` | P (braced) | 2011-08-15 | sketch |
| `@[id]` (transclusion, later inert selector) | L, V | SPEC 2025-12-23 | live-0.10.0 (inert) |
| `:[id]` (attribute merge) | S | SPEC 2025-12-23 | removed 2026-07-14 |
| `\|[id]`, `\|{[id]}` instead of `@` | L, P | Joseph 2026-01-03 | not adopted (ruled out 07-11) |
| `@element[key]` | L, S, V | Joseph 2026-01-14 | live-0.10.0 |
| `@user[alice]:email`, `\|order[123]:customer@` | path | udon-paths 2026-01-14 | stale |
| `@.trait` (`@.auth`) | L, S, V | Dec-2025 brainstorm; guard widened 2026-07-15 | live-0.10.0 |
| `@name`, `@name[key].trait` | L, S, V | 2026-07-15 selector table | live-0.10.0 |
| `[@method='POST']`, `//*[@.auth]` | path predicate | Dec-2025 brainstorm | stale |
| `\|{@ :confidence …}` | I | Dec-2025 brainstorm | ruled invalid in 0.9 |
| ` @ref` as an unquoted-value terminator | S | K10 2026-08-08 | live-0.10.0; FIX |
| `@…` as an array item | A | 2026-07-18 | live-0.10.0 |
| `@[ ]` → nil | V | 2026-07-18 | live |
| `@{…}` (embedded reference) | P, I | Joseph 2026-07-19 (question) | CORE "anticipated" → 0.10.0 "demanded, undefined" → 0.10.01⟨P⟩/FIX: replaces `!{{…}}` |
| `\|el[@{key}]` | K | K16 2026-08-09 | live-0.10.0 (held lightly) |
| `\|el[@x]` (bare in brackets) | K | K16 addendum | held out of the sugar; outcome open (AUDIT D6) |
| `pre@{x}post`, `@{dir[asf]}/01-aat-core/…` | P, V glued | Joseph 07-23 pseudo; 0.10.01 | ⟨P⟩ |
| `@<…>` (held reference / typed reference-act) | V | Joseph 2026-08-06 ("`@< descriptor / … >`") | sketch → 0.10.01⟨P⟩ (alternative `<ref: head>`) |
| `@<{…}>` | V | sketch 2026-08-07; Joseph 2026-08-09 | open debate |
| `@<mystuff/h?/**/p>` | V | Joseph 2026-08-07 | sketch |
| `@[uuid]?`, `@*.header`, `@h4+` | V | sketch 2026-08-07 | → 0.10.01⟨P⟩ `@reviewer?` `@tags*` `@authors+` `@{posts*}` |
| `@acme/widget` | S, V | terminator table (REF-SLASH) | open: CORE and the grammar disagree |
| `@[core://components/another.udon # main-findings]` | V | Joseph 2026-07-28 ("random syntax") | parses only via the interim raw wire (REF-BRACKET) |
| `@include` | L | Joseph 2026-07-28 (CLAUDE.md-style) | sketch |
| `@'quoted name'` | L, S | terminator table D-c | not reachable (the guard has no `'`) |
| `@@…`, `@<`, `@` + digit, `@` + space | L, S, P | probed 07-30; "free real estate" 08-07 | literal today (guard fails) |
| `jo@x.io`, `a@b` (mid-token) | any | — | literal in every version |
| `email me @joseph` mid-prose | P | 0.10.01 grid note 7 | literal in text-space; at line start or as a sameline terminator it is live |
| `!{{@assigns.user}}` (`@` inside an expression) | inside `!{{…}}` | SPEC 2025-12-23 | host expression content |
| `\@` (escape) | P | 0.10.01 | ⟨P⟩ (`\` before inline openers is live since 0.8) |

### Adjacent future syntax that is neither `!` nor `@`

| Spelling | Position | First seen | Note |
|---|---|---|---|
| `<kind:` + indented body (block capture) | L | 0.10.01⟨P⟩ 2026-08-27 | Would make a line-initial `<ident:` live, which collides with lite's untyped box ([07](07-untyped-angle-box.md)) |
| `<ref: head>`, `<path:…>`, `<include:…>` | V | 0.10.01 / terminator table | Future *typed* boxes; lite plans to carry these as untyped text |

---

## Threads worth noticing (my reading)

Everything in this section is my interpretation of the history above, not a finding any source states.

1. **Future spellings have repeatedly been chosen *because* they are plain text today.** The `@<…>` sketch says so directly: "`<` fails it, so `@<` is plain text in every existing document — extending the guard is additive; nothing retypes." The same pattern shows up three more times:
   - `@{` was literal text in prose before 0.10.01 made it live.
   - A line-initial `!{` began prose until 0.10.01 made it a block generator.
   - `!{{x}}` would have turned into "an inline generator named nothing".

   Under "reserve, not ignore", this habit points the other way. Anything lite passes through as text is exactly where a later version might plant new syntax, and doing so would change a lite document's meaning. So the reserve list probably can't be read off "what 0.10.0 recognizes". Either the reserve is drawn as a whole character family (for example `!` or `@` followed by *any* non-space character, in the positions where markers are live), or future design commits not to mint spellings from text that lite accepts. Both `@<` and `@{` went through exactly this change during v2.

2. **"Content under a directive line" means two different things, and history has always kept them apart.**
   - For `!name` (a UDON body), every version since 2011 agrees on one thing: indentation owns the lines below and dedent ends the block.
     - Joseph, 2025-12-28: "a non-raw directive should work exactly like element". The 2011 DECIDED: "indentation-rules … exactly the same as nodes".
     - The versions disagree only about the **head line**: carried unparsed in 0.9 and 0.10.0, parsed like an element in 0.10.01 and FIX.
     - They **all** agree that the rest of a sameline `!name` line is not the enclosing element's: in `|el :x !if cond :y 2`, `:y 2` belongs to the directive's head in 0.10.0 and to the generator in FIX, never to `el`.
   - For `!:kind:` (a verbatim body), the body is never UDON. Joseph: "raw directive should act exactly like a block comment."

   Question 09's Q3 option A (children of the reserved node) would parse a reserved `!:python:` body as UDON. Code lines starting with `|>`, `;`, or `:` would then become elements, comments, and attributes. Q3 option C (parse normally) contradicts what every version means by `!if` and `!for` bodies (conditional or repeated content). The one thing all versions agree on is the *extent* of the held span: to the dedent.

3. **Line-initial versus mid-line is the axis the history actually measured.** Every version treats a mid-prose `!` or `@` as literal. The hazard is a line-initial `!important`, `@element[key]…`, or `!:lang:` produced by reflow. There are three field instances, and the July spike put the rate at 0.3–1.2 per 10k wrapped lines in the estate's own prose. The neutral table's rows "`@` + name inside prose" and "`!` in prose" don't separate the two positions. At line start (a structural column) both pass today's guards.

4. **Value-space is where `@mention` and `!important` bite hardest.** Under K10 and FIX, a space followed by `@name` or `!name` inside a sameline value is a live marker: `:note ping @joseph today` ends `note` at `ping`. K10 named this hazard in advance. In lite, the same text would be reserved, so an author writing an ordinary mention in a sameline value gets flagged. Whether that surprise is acceptable is a least-surprise question the history raised but never priced.

5. **Joseph has placed directives in an optional layer from early on.**
   - The Jan-13 "udon-template -- the subset that uses the liquid-like directives".
   - Jan-14 "a "template mode" … that isn't needed by many (most probably) udon documents".
   - Jul-11 "we were separating the template stuff to a dialect".
   - Aug-30 "simplified udon" parsers that "warn when there are constructs (like references or directives …)".

   Lite reads to me as the first time that layer boundary has been drawn in the grammar itself.

6. **The nearest precedents for "reserve" are warn-and-keep, not silence.**
   - 0.8's `<…>` interim: "recognizes the envelope … emits a Warning that no dialects are loaded and passes the value through as the plain string" — "nothing lost, nothing silently retyped".
   - The 07-19 posture: "undefined but we'll warn you if we're going to start disallowing multiline" … "the last thing we want is for purposefully unspecified behavior to nevertheless calcify into the grammar."
   - The Aug-30 inbox asked for warnings.
   - 0.10.01 and FIX went the other way and removed the "nothing will handle this" warnings. Joseph's 09-01 wording ("says it doesn't do things *on purpose* instead of warning that nothing will handle it") describes that change; to me it does not clearly endorse it.

   Separately, on 07-11 Joseph was careful about the word "reserved" itself ("I would be careful about calling them reserved instead of specially-designated"), though that was about `$`-keys.

7. **The guards have moved four times.**
   - 2011: any `!name`, and `@` + any non-space.
   - Dec 2025: effectively no `!` guard (a phantom directive ate the `!`).
   - July 2026: `!` needs an identifier character or `:`; `@` needs `[`, `.`, or an identifier start (widened to `.` on 07-15).
   - 0.10.01: `!` needs an identifier character or `{` (dropping `:`); `@` adds `{` and `<`.

   A lite reserve keyed to one version's guard would mismatch the next. For example, `!:sh:` is reserved under 0.10.0's guard but would be text under 0.10.01's.

8. **The corpus already uses future syntax for its intended meaning.**
   - Live vivarium and ASF documents use `!:md:`, `!:sh:`, and `!:text:`. The pre-lite safe-subset norm *required* `!:lang:` over fences and excluded only `@`.
   - The `.ud` definition files use `@{term}` in prose about 190 times, both in the repo and outside it.

   If `!:kind:` and `@{…}` are reserved, those documents are not valid lite until they are rewritten. For code, the rewrite is to fences. What happens to `@{term}` links, I don't know.

9. **The extent of a reserved inline form is itself unsettled.** To keep the bytes of a refused `!{…}` or `@{…}`, lite has to know where the form ends. Joseph, 2025-12-28 and 2026-01-01: inline directives and interpolation "can span any number of lines". 0.9 and 0.10.0 left that undefined. 0.10.01 made delimited forms span lines. `!{{` closes at the first `}}`, while the other brace forms balance braces.

10. **The lexical-forms appendix is wrong about 2011.** It says the 2011 originals "predate `!` dynamics entirely". The 2011 vim syntax, scratch notes, and udon-c DECIDED all have `!` directives and `!{…}` inline forms. That appendix is the most-cited quick reference for "what directive forms exist", so the error may have spread.

---

## What the neutral file misses

1. **Positions.** The Q1 table has no rows for:
   - array items (`[… @x !{{y}}]`, ruled 2026-07-18)
   - `!{{…}}` as a whole key (`|div[!{{id}}]`, S5)
   - bare `@x` inside key brackets (open, AUDIT D6)
   - the interior of `|{…}` (flow rules)
   - the first line of a deferred body (K7)
   - **sameline unquoted-value terminators** (` @ref`, ` !name`, K10)

   It also doesn't split prose into **line-initial** (a Structure Position, where `!important` and `@joseph` pass the guard) versus **mid-line** (literal everywhere). The row "`!` in prose … literal (fails guard / text-space)" is true mid-line, but not for `!word` at the start of a line.

2. **Spellings.** Missing from the table:
   - `@<…>`, `@<{…}>`, and the cardinality suffixes (`@x?` `@x*` `@x+`, `@{x*}`), all in the misfire draft or sketches
   - `@name/…` (REF-SLASH)
   - `@[scheme://… # frag]`, `@include`
   - `!:lang: tail` and `:script !:sh: …` (verbatim as a node value)
   - the line-initial `!{…}` / `@{…}` cases (prose in 0.10.0, block-live in 0.10.01)
   - Joseph's unruled sketches: `!if{…}{…}`, `!{if}…!{endif}`, `!dialect`, `!{was: …}`, `!{let …}` / `!{foreach …}`

   Also missing is the non-`!` future spelling `<kind:` (block capture at Structure Position). If it ever lands, a line-initial `<ident:` in a lite document would change meaning. That touches [07](07-untyped-angle-box.md).

3. **Q3 treats `!name` and `!:kind:` bodies as one question.** A verbatim body can't be kept as UDON children. See thread 2.

4. **The head-line question is missing.** In `|el :x !if cond :y 2`, every version agrees `:y 2` is not `el`'s attribute. A lite rule that parsed `:y 2` as `el`'s attribute would contradict all of them.

5. **Escapes.** Q1's "reserve more versus less" trade-off leaves out the escape hatch that already exists: `\` at line start, and `\` before inline openers, ruled 2026-07-14, with Joseph insisting "inline directives … absolutely need to be able to be escaped". It also leaves out the measured frequencies (thread 3). Both change what reserving `@name` or `!name` in prose would cost. Joseph's 08-28 worry about sigils needing escapes "no matter where they appear in text" is relevant here too.

6. **The corpus consequence.** Existing live documents use `!:md:`, `!:sh:`, `!:text:`, and `@{term}` (thread 8). Question 11 covers code blocks, but no file names this migration cost.

7. **The warn-versus-error precedent.** Q2 option C (warning) has direct history the file doesn't cite: 0.8's `NoDialectsLoaded` interim, the 07-19 warn-before-disallow posture, and the 08-30 inbox request (thread 6).

8. **The Q2 example's reference value.** `:author @person[jw]` is a reference *value* in every version from 0.9 through FIX. Under option A it would become the string `"@person[jw]"`, which a consumer reading only the tree could mistake for data unless the anomaly travels with it. This connects to [12](12-missing-values-and-what-counts-as-valid.md) and [13](13-ast-shape.md).
