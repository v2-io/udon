# 05 — Values across lines: history

**Written by:** Claude (Opus 5.5), the history agent for question 05, on 2026-09-29. I did not see any lean on this question, the coordinator's or Joseph's, before writing.

**Method.** I read the neutral file, both READMEs, and `WHERE-THINGS-STAND-2026-09-27.md` first. Then:

- **Joseph's own words** came from `~/.claude/history.jsonl`, which holds his typed prompts and nothing else. I looked up each line that memorata pointed to and swept the whole file with a keyword regex over every udon/libudon/descent prompt (`multi-?line|single-?line|span… lines|line-?bound|unclosed|close at/on newline/EOL|swallow`). Every Joseph quote below comes from that file, with his line breaks and indentation. memorata drops both, so I used memorata only to find the quotes, never as the quoted text.
- **Agent and document text** came from `memorata-search` with the classes `agent-to-human`, `agent-to-human-flanking`, `document`, and `subagent-final-response`. For two exchanges I also read a short window of the rendered session files in `v2/.archived/second-pass/spikes/session-vault/raw/claude/` (Markdown renders; the windows I read held user and assistant turns only). I opened no raw `.jsonl` transcript, and nothing was blocked.
- **Repo evidence:** `git log -S`/`-G` over the umbrella repo, including the grammar history, which is evidence of what was built, not of what was intended. Also `spec/CORE.md`, `spec/msc/CHANGELOG.md`, the adjudication packet, the fixtures (including `core/fixtures/exploratory/multi-line.yaml`), `_archive/`, and everything in `v2/` that mentions multi-line: DECISIONS, OPEN, spec-0.09.01/0.10.00/0.10.01, the audit, the greenfields, theory/, udon-needs/, msc/.
- **2011-era originals:** `~/src/_older/udon` and `~/src/_older/udon-c`. The brief's `~/src/_ref/` path does not exist.
- **A measurement of my own:** a regex scan of 161 live `.udon`/`.ud` files across `~/src` (outside the udon repo, `_older`, `_ref`, and `.moved-and-integrated`), plus the udon repo's `design/examples/` and `_archive/`. It is described in the entry dated 2026-09-29.

**memorata searches run** (`--pool 200`, `-n 30–40`, `--sort oldest` unless noted):

- `--joseph`: "udon multi-line string across lines" · "udon multiline array list spans lines" · "udon unclosed bracket end of line" · "udon string spans newline quoted" · "unclosed list swallows rest of document" · "line-bound values udon" · "OPEN ML multi-line" · "quoted string continue next line udon attribute" · "array as sugar for dialect typed box" · "list across lines continuation indentation udon" (**no results**) · "unclosed quote warning end of line" · "multiline array udon" · "single-line decisions will not last greenfield" · "multi-line at your own risk undefined we hope to add multiline" · "multi-line swallow rest of the file typo forgotten bracket" · "identity key line-bound partial-key multi-line" · "strings multi-line quoted YAML block scalar" (nothing relevant) · "inline constructs can span multiple lines newline should not terminate" · "array newline whitespace items across lines" · "quoted string newline" · "lean into the stacking we already do…" · "array values opening geometric block-mode".
- `--joseph --since 2026-08-01/08-10`: "lists span lines fail-safe forgotten bracket", "multi-line list", "spec-lite multi-line strings lists", "delimited closer geometry spans", "theory leads spec restructure", "stacking spread out list array". **All returned nothing.** I found no Joseph statement on this question after 2026-08-09 except the Sep 1 "misfire" call, which covers 0.10.1 as a whole.
- Agent/document classes: "multi-line undefined arrays strings envelopes close them on the line they open" · "quoted string silently spans newline until closing quote" · "array closes with warning at newline UnclosedArray line-bound" · "OPEN ML multi-line carve-out do not close per-construct" · "forgotten closing bracket swallows rest of document multi-line list" · "multi-line list items across lines udon" · "strings may span lines udon spec" (one more timed out) · "explicit single-line vs multi-line in the spec…" (Jul 18) · "S2 array multi-line clarification…" (Jul 19; **nothing**, so I found it in the rendered session instead) · "delimited spans law lists now span lines" (since Aug 20) · "stacking spread out list array interleaved items label" (`--in` the Aug 9 session) · "lists stay closed at end of line accident case…" (since Aug 26; **nothing**).

**What this history does not cover.** I did not read the Dec-2025 `.machine`-era grammar files in full (the Dec 30 `udon.desc` is the earliest grammar I checked for arrays), the needs monograph beyond its multi-line mentions, or the gathered corpus in `udon-needs/01-ideation/`. `~/.claude/history.jsonl` has Joseph's prompts from Claude Code only. Codex, Gemini, and Grok sessions were reachable only through memorata, and a Grok-scoped search for his multi-line words found nothing.

**How to read an entry.** Each entry gives a **date** (and how I know it), a **source**, the **speaker**, the **words**, and then *Bears / incidental* (what matters for this question and what is just the rest of the example). Where the speaker is Joseph, the words are verbatim.

---

## History (chronological)

### 2011-08-15 / 08-22 — quotes as a line mode; embedded forms fold newlines

- **Source:** `~/src/_older/udon/examples/overview.udon` lines 75–100 (commit `1b57c3a`, 2011-08-15) and line 159 (commit `0cd4b33`, 2011-08-22).
- **Speaker:** Joseph (his own design notes).
- **Words:**
  ```text
  |==Line-oriented
                             #      | embedded | child lines | metachars | embeds | prsv.ws | comments |
    |"datadata...            # Data | --       | --          | Yes       | Yes    | a-indent| --       |
  ...
  |==Embedded
    <("datadata...")>        # Data | Yes      | --          | Yes       | Yes    | Yes     | --       | NBM!!
  ```
  and
  > No indentation in embedded. all treated as 1-line (nl treated as space)
- **Bears:** in 2011 a leading quote was a *line mode*: `|"…` opened data that ran to the end of the line and had no closing quote. The delimited quote appeared only inside embedded `<(…)>` forms, and those forms could span lines, with each newline folded to a space.
- **Incidental:** the `<( )>` and `<{ }>` spellings, and the rest of the table.

### 2011-12-14 → 12-22 — "are we still in the string?"

- **Source:** `~/src/_older/udon-c/docs/DECIDED.md`, first committed 2011-12-14 (`4edf78e`).
  - Lines 154–161 (UNDECIDED → DIRECTIVES (for text)).
  - Lines 24–26: the VALUE rule; the "dedented" wording arrived in `ab28dd3` on 2011-12-22, replacing "STOPS ON: newline".
  - Lines 27–33: the parenthesis form.
  - Lines 51–53: freeform text values.
  - Lines 217–220 and 238: future scalars.
- **Speaker:** Joseph.
- **Words:**
  > * Existence of !" ....  " and how it is parsed, if different (for example, if it has a newline that is outdented from the beginning but the closing quote hasn't occurred yet, are we still in the string? If so, it has to be parsed specially. Unless we allow " to be a special label delimiter- but then all the data is simply the "name" of the directive... Maybe follow nesting unless you do embedded form and don't require closing quote? and on and on...

  > * VALUE: Non-delimited scalars including text … STOPS ON: dedented newline or space __plus__ [|#.!:]

  > * PROTECTED/SHIELDED: parenthasese-delimited label or value … STOPS ON: last matched close-parenth … Can be interpreted as simple potentially nested tuples or lists

  > If you need a freeform text value - for example, unbalanced parenths, you need to use a grim attribute and put the text, indented appropriately, on the next line.

  The future-scalars list includes "(future (?)) Quote delimited ... possibly don't need because it would be used rarely enough that directives would work fine for it..." and "Simple-list".
- **Bears:** this is the first time the question is asked: does an unclosed quote run past a line that dedents? It comes with a candidate answer, "Maybe follow nesting": let indentation bound the quote. Unquoted values were changed the same month from ending at a newline to ending at a *dedented* newline. The delimited parenthesis form closed only at its matching closer and was imagined as nested lists. And the standing way to write long text was the indented next line, not a spanning delimiter.
- **Incidental:** directives, "grim attributes", and the parenthesis spelling.

### 2025-12-23 — the reboot spec: "Inline Lists", structure by indentation

- **Source:** `SPEC.md` at commit `f5813bd` (the umbrella's first commit), lines 110–133.
- **Speaker:** a document (Joseph and Claude).
- **Words:** under the heading "Inline Lists": "Square brackets for list values … Space-delimited within brackets · Quoted strings for values with spaces". Under "Complex Attribute Values": "When an attribute needs structured content, use indentation … Attribute followed by newline+indent = structured value."
- **Bears:** the spec says nothing about newlines inside `[…]` or `"…"`. The list section is titled *Inline* Lists, and multi-item structure is shown through indentation (`:headers` with two `|header` children).
- **Incidental:** the example header names.

### 2025-12-27 → 2026-01-01 — Joseph: the inline brace forms span lines

- **Source:** `~/.claude/history.jsonl` lines 6004 (2025-12-27 20:02), 6055 (2025-12-28 14:37), and 6712 (2026-01-01 12:14), all in libudon sessions.
- **Speaker:** Joseph.
- **Words:**
  > So a lot more similar to the parsing already available at the beginning of the lines, with the difference being that it is bracked-nested instead of indent-sensitive. That reminds me, we'll need good tests for multi-line nested inlines like this as well...

  > Inline directives are not limited to single-lines

  > You know inline interpolation and directives can span any number of lines, right?
- **Bears:** Joseph's early stance on the *brace*-delimited forms: they are bracket-nested rather than indent-sensitive, and they span lines. This belongs to the family consistency the neutral file lists under Interactions ([10](10-inline-elements-and-inline-comments.md)). None of these messages is about strings or lists.
- **Incidental:** the Dec 27 example's many other forms (`'|{…`, `!{raw:kind …}`, `!{{val | filter}}`) and his aside disallowing `|{inline element |next …}`.

### 2025-12-28 15:18 — Joseph: dedent multi-line captured content

- **Source:** `~/.claude/history.jsonl` line 6059 (libudon).
- **Speaker:** Joseph.
- **Words:**
  ````text
  Correct. -- that would, in fact, be the preferred way to have json snippets in udon. The automatic dedentation would make the output become:
  "{\n  \"multiline\": true,\n  \"unbalanced\": \"} no problem\"\n}"  (possibly via multiple emissions). And, as per other indentation, the following would cause a warning:

  !:json:
      { "starting out": 123,
    "this causes a warning": 567 }
  ````
- **Bears:** Joseph's early preference for how *any* multi-line captured value handles indentation: strip it automatically, as other indentation is handled, and warn when it is inconsistent. This matters for the continuation-line indentation question a spanning string raises (see the Jul 18 sandbox entry).
- **Incidental:** this is the `!:kind:` block raw form, which is out of lite.

### ≤2025-12-30 → 2026-07-16 — the built parser: lists span, strings span

- **Source:** grammar history.
  - `generator/udon.desc` at `e7b97a6^` (Dec 30–31): `function[array]`, `|c[' \t\n'] | -> |>>`.
  - `e7b97a6` (2026-01-01, Opus 4.5 co-author) keeps `|c[' \t\n'] | ->`.
  - The frozen snapshot `core/generator/udon-legacy-pre-0.8.descent.udon` lines 549–555 still has it.
  - The `quoted` function has no newline arm, now and then (`core/generator/30-udon.values.descent.udon` lines 29–31).
  - The Jan 1 `FULL-SPEC.md` (`c0025bd`) EBNF: `quoted_string = '"' { CHAR }* '"' …` and `CHAR = any character except NEWLINE`.
- **Speaker:** code, and a document.
- **Bears:** for about six and a half months, the reference parser treated a newline inside `[…]` as ordinary item whitespace. Lists spanned lines to their `]`. Strings have always spanned in the parser. The Jan-2026 EBNF, read literally, made quoted strings single-line. That EBNF was later demoted to "illustration only" (`spec/msc/FULL-EBNF.md`).
- **Incidental:** the refactor's actual purpose, which was letting the array own its `[` (Joseph's Jan 1 10:28 descent diff).

### 2026-07-14 01:50 — "the array closes only on `]`"

- **Source:** commit `05ce172`, `FULL-SPEC.md` "Array Item Values". The same text is at `spec/CORE.md` line 661 today.
- **Speaker:** a document (Claude session).
- **Words:** "`}` is **not** a terminator: inside `[...]` it is a literal character; the array closes only on `]` (with no `]`, it ends as an `UnclosedArray` error)."
- **Bears:** read literally, the sentence says lists end only at `]`, which agrees with the parser of the time.
- **Incidental:** the sentence was written to settle `}` inside lists, not newlines.

### 2026-07-15 23:09 — first reboot-era review notices the silence

- **Source:** memorata; a subagent report relayed into session `be2e5fbd`, in `~/.claude.bak.2026-07-16/projects/-Users-josephwecker-v2-src-udon/be2e5fbd-….jsonl` line 488 (agent text, via memorata).
- **Speaker:** a review agent (Claude).
- **Words:**
  > **S11. EOF behavior is entirely unspecified.** … EOF inside a quoted string, `<...>` envelope, `[...]`, `!{{...}}` …

  > **M2. Can a `<...>` envelope span lines?** … Concrete: `:x <a` (EOL) `b>` — error, multi-line envelope, or blob text?
- **Bears:** this is where the reboot first registered that the spec was silent about newlines inside delimited values.

### 2026-07-16 03:36 — the first line-close rule, by delegation (`<…>`)

- **Source:** commit `fa28403`, "0.9 minor rulings pass (delegated)", Fable 5 co-author.
- **Speaker:** an agent, under Joseph's delegation.
- **Words:** "**Envelopes are single-line** (resolved 2026-07-16, delegated): a newline before the matching `>` ends the value there -- captured text passed through as a string plus `Warning UnclosedTypeEnvelope` … Multi-line envelopes, if ever wanted, arrive with the dialect layer." The same commit's EOF table has "`[...]` array | Items so far + `Error UnclosedArray`; `ArrayEnd` flushes", which is about end of input, not newlines.
- **Bears:** the first explicit line-close rule for any delimited value. Joseph reversed it on 2026-07-18.

### 2026-07-16 05:02 — lists start closing at end of line

- **Source:** commit `2bd7c86`, "Densification: 149 new fixtures", Fable 5 co-author. In `udon.desc`, `function[array]` gains `|c['\n'] | /error(unclosed_array) |return` and loses `\n` from its whitespace arm (compare `2bd7c86^` line 892 with `2bd7c86` line 975).
- **Speaker:** code.
- **Words:** the commit message lists "EOF per CORE's table: … UnclosedArray(+ArrayEnd)". A fixture comment in the same commit calls the Jul-15 case `array_unclosed_is_error` "(newline-ended)". That case's input is `"|el :x [1 2\n"`, which reads the same under newline-close or end-of-input-close (`5d92850`, `core/fixtures/v0.8/arrays.yaml` lines 120–131).
- **Bears:** this commit is where "the old parser closes lists at end of line" comes from. I found no ruling, CORE sentence, or Joseph message before it asking for this. CORE at this commit still said "the array closes only on `]`".

### 2026-07-16 17:27 — adjudication packet: defer multi-line lists; point at stacking

- **Source:** `spec/msc/adjudication-2026-07-paths-and-silences.md` lines 268–274 (commit `511b39c`, Fable 5).
- **Speaker:** agent (Fable).
- **Words:**
  > ### S2 — Multi-line `[...]` arrays
  > Today: newline inside `[…]` → `UnclosedArray` error (items so far kept). **Recommendation: explicit deferral** — single-line arrays are the 0.9 contract; multi-line wants the deferred-block + stacking machinery that already exists (`:key` + deeper lines), and a future ruling can lift it compatibly.
  > Ruling: _________
- **Bears:** this is the first proposal that multi-line lists should be written with *depth* (a deferred body or stacking) rather than with a spanning bracket. It describes the Jul-16 behavior as "today" and "the 0.9 contract".

### 2026-07-18 ~01:10 — EOF design: "a live UX choice, one flag"

- **Source:** `_archive/TODO-EOF-refactor.md` lines 98–109, 131–138, and 266–267 (commits `984afe0`/`b018a50`, 2026-07-18). Archived 2026-07-19 as "realized".
- **Speaker:** a document (design of record).
- **Words:**
  > **Line-bound delimited** (`[…]`, `<…>`, identity `[…]`): a delimited construct whose scan is *also* cut short by a newline. … So for these, **newline ≡ EOF**. (Whether `[…]` is line-bound or may span lines is a live UX choice — one flag on that one construct, not a philosophy. See Open work.)

  > A line-bound construct that failed on a *newline* mid-document (`[1 2⏎…`) already closed on that newline; … it is a plain Warning, **zero exit**. Only a frame on the stack when input runs out feeds the document result. The distinction that earns its keep: *structurally complete document with a local defect* (warning only) vs *truncated document* (warning + non-success)

  Open work: "Decide line-bound vs multi-line `[…]` (one flag; UX call, not a second EOF model)."
- **Bears:** this reframes the line-close for lists as a per-construct setting, and names what closing at end of line buys: a missing `]` mid-document counts as a local defect, not a truncated document. It lists strings as *not* line-bound.

### 2026-07-18 11:10 — Joseph: a newline-close counts as truncation only at true EOF

- **Source:** `~/.claude/history.jsonl` line 16618 (udon).
- **Speaker:** Joseph.
- **Words:**
  > Any delimited construct that also closes (with a warning) on a newline is only considered evidence of incomplete document if that "newline" was the EOF... [something like that?]
- **Bears:** Joseph endorses the same distinction as the entry above.
- **Incidental:** the same message's wording notes and his wish to derive `Unclosed*` names from the grammar.

### 2026-07-18 ~12:20 — fixture harvest: string line-boundedness is unstated

- **Source:** `core/fixtures/_wip/FINDINGS.md` line 110. The subagent report is at memorata session `fb57249f`, `…jsonl:844` (agent text).
- **Speaker:** agents (Claude). The coordinator verified the finding; its tag says one of three agents found it independently.
- **Words:** "**Quoted-string line-boundedness is unstated in CORE.** … The design doc (`TODO-EOF-refactor.md`) excludes strings from the line-bound set (⇒ multi-line, newline = content) and the parser agrees — but CORE.md itself is silent." From the report: "Everything downstream (multi-line config strings, YAML-migration fidelity) hinges on it."
- **Bears:** the question Joseph answers next.

### 2026-07-18 12:33–12:47 — Joseph: all multi-line eventually; for now, undefined

- **Source:** `~/.claude/history.jsonl` lines 16638 (12:33), 16641 (12:44), and 16643 (12:47). The agent's reply sits between them in `v2/.archived/second-pass/spikes/session-vault/raw/claude/fb57249f-orient-on-udon-codebase-and-parser.md`, around lines 1618–1700. The CORE ruling is commit `a6ba88c` (12:47, Opus 4.8).
- **Speaker:** Joseph; then the agent (Claude Opus 4.8).
- **Words (Joseph, 12:33):**
  > Are we currently explicit about single-line vs multi-line in the spec for: `[...]` array, `[...]` key, `"..."`, `'...'`, `<...>`, (and any others I'm missing?)
  >
  > I ask not so we can add single-line restrictions. I suspect we will want them to be multi-line at some point, all of them. But that will have some implications on head-position etc., so I'd like to defer it. It seems to me the right thing to do right now in the spec is something along the lines of "The current version of udon expects these to be closed on the same line they were started on; multiple lines is currently undefined in udon but we hope to add multiline in once we are sure we have understood all of the consequences and nuance. In the meantime, use multi-line at your own risk. (If it does become illegal, the parser will issue warnings at that point)."   something like that.
- **Agent's reply (verified against CORE):** `<…>` was explicitly single-line. `|{…}` and the fence were explicitly multi-line. Strings, arrays, identity keys, `!{{…}}`, `;{…}`, and `!{…}` were "silent — no line-boundedness statement anywhere". It proposed treating these as "single-line for now, multi-line undefined", with the envelope as the model.
- **Words (Joseph, 12:44):**
  > Excellent, ok. Anything that is already deliberately multi-line delimited definitely keep locked in as multi-line. The undefined is only for the things that haven't been multi-line-safety-verified yet like `<>` in particular.   Excellent-- thank you for verifying Q2.
- **Words (Joseph, 12:47):**
  > <...> is not any different-- it is 'multi-line-undefined' just like the others that aren't explicitly multi-line already.
- **Resulting CORE text** (`spec/CORE.md` §"Line-boundedness (current version)", line 76 today): "…**spanning multiple lines is deliberately undefined in this version** … close them on the line they open … We expect to make them multi-line once the consequences are fully understood; if a case is instead made *illegal*, the parser will warn at that point rather than silently change meaning."
- **Bears:** this is the central ruling for this question. Joseph's direction is multi-line for all of them eventually. The status he chose is *undefined*, not single-line, and the reason he gave for deferring is the effect on head position. The warn-before-disallow promise originates here.
- **Incidental:** the 12:33 message also asks about an `:attribute-3?` flag example, the "Q2" his 12:44 message thanks the agent for. It is unrelated.

### 2026-07-18 13:05–13:08 — the exploratory sandbox: what the parser actually does

- **Source:** commit `222abb8` (Opus 4.8), `core/fixtures/exploratory/multi-line.yaml`. The subagent report is at memorata `fb57249f/subagents/agent-aac8a72f064e387b2.jsonl:109`. The file's cases record parser output and are labeled "CURRENT (exploratory, not ratified)".
- **Speaker:** agents (Claude); fixture comments.
- **Words (from the report):**
  > 1. **Line-boundedness is emergent, not a container property.** A spanning inner construct defeats its line-bound container: `|el :xs ["a⏎b" 2]` and `|el["a⏎b"]` both close the array / identity key **cleanly on line 2, no warning**, because the string swallowed the newline. So "single-line for now" is silently violable by nesting — container and contents have to be ruled together.
  > 2. **The warn-vs-silent split within the "line-bound" family is inconsistent** …
  > 3. **Verbatim indentation capture** on continuation lines … Any real multi-line support needs a dedent/indentation policy — this is the load-bearing multi-line-string question.
- **Cases** (`udon:` strings exactly as in the file):
  - `ml_str_indent_kept_verbatim`: input `"|el :k \"abc\n  def\""` gives `StringValue "abc\n  def"`. The fixture comment reads: "Verbatim capture means indentation for readability leaks into the value — almost certainly not what an author wants."
  - `ml_str_blank_line_inside`: `"…\"a\n\nb\""` gives `"a\n\nb"`, with the note "paragraph handling inside multi-line values is undefined."
  - `ml_str_closed_then_prose_same_line`: text after a closing quote on line 2 becomes prose of `|el`.
  - `ml_arr_bare_newline_soft_closes`: `"|el :xs [1\n  2]"` gives `[1]`, then `UnclosedArray`, then the text `"2]"` inside `el`.
  - `ml_arr_never_closed_lines_become_prose`: `"|el :xs [1\n2\n3"` gives `[1]`, then `UnclosedArray`, then `el` closes, and `2` and `3` become **root-level** text.
- **Bears:** these are the concrete sub-questions a "continue" answer has to settle: continuation indentation, blank lines inside a value, and a spanning item inside a line-bound list.

### 2026-07-18 13:09–13:21 — Joseph: the gravity of a partial key; `< >` may drop its warning

- **Source:** `~/.claude/history.jsonl` lines 16649 (13:09) and 16651 (13:21).
- **Speaker:** Joseph.
- **Words:**
  > "line-boundedness ruling" meaning it is deliberatly *undefined*, to be clear, right?
  > This one might deserve a deliberate exception to the usual "value then warn" -- mostly because of the gravity of a $key that is not actually a key (this would be even more relevant, of course, in the key field of a reference). We should consider issuing an event for the key with either a "possibly-incomplete" flag, or issuing a '$partial-key' instead...

  > For the < > current-implementation nuance-- I'm genuine in keeping it undefined so the current warning is ok, but if when we get to the grammar we find that it's much easier to simply remove that warning and do the same as the other delimited-maybe-multiline constructs, esp. with the pre-trimming of whitespace, just drop the warning. So, not a worry from the spec, but a concern for current implemented grammar.
- **Bears:** he confirms again that the status is *undefined*. The reason he gives for special care is specific to **identity keys**, namely the gravity of a truncated key. That is where the `$partial-key` fail-safe comes from, and he does not extend the reason to lists or strings. He calls the family "delimited-maybe-multiline constructs".

### 2026-07-18 15:18–15:44 — the EOF spike: CORE contradicts itself on lists

- **Source:** `~/.claude/history.jsonl` line 16684 (Joseph, 15:18). `_archive/eof-descent-classification.md` "gap-6", line 167 (agent, 15:22). The verification subagent is at memorata `22abfaae/subagents/agent-a0e7e9fa768ba620c.jsonl:24` (15:44).
- **Speakers:** Joseph; agents (Claude).
- **Words (Joseph):**
  > If it helps, I've felt that we can *generate* the right behavior with EOF -> turns into EOL+full-dedent (but with the parser knowing that it's really an EOF and therefore doing the right thing warning/error wise etc.). That would still leave the delimited-multiline undefined behavior I suppose...
- **Words (agent, gap-6):** "Line-boundedness is an *unsettled per-construct decision*; do NOT treat CORE's text as authority for it … CORE §End-of-input (line 66) says line-bound `[...]`/`<...>` **close-with-a-warning on a newline** … CORE §Line-boundedness (line 76) lumps arrays into **'deliberately undefined, may change.'** These two CORE sections disagree → array line-boundedness was **never actually decided** … the three 'undefined' constructs actually behave **three ways** today."
- **Bears:** an agent independently concludes that line-close for lists was never a decision.

### 2026-07-18 22:45–22:57 — Joseph pushes `<…>` to multi-line

- **Source:** `~/.claude/history.jsonl` line 16798. The agent's reply is at memorata `6c1ad867…jsonl:1212`. Commit `e377585` (22:57, Opus 4.8). `spec/CORE.md` line 1680.
- **Speakers:** Joseph; agent (Opus 4.8).
- **Words (Joseph):**
  > I know the spec says that multiline is unspecified behavior right now but that we'll warn if we need to cut multi-line access...  But the truth is most of those *will* end up being multi-line. I was hoping < ... > could just adopt the usual behavior instead of going out of its way to foreclose something we'll have to open back up. But it's *technically* compliant so if the grammar is really better and cleaner this way (the descent.udon grammar), I can live with it. I just thought we'd have a chance to clean that code up to be more like most of the other delimited constructs.
- **Words (agent):** "multi-line is both the cleaner grammar *and* the honest bet (don't foreclose what these constructs will want)."
- **Resulting CORE text:** "**Envelopes span newlines (multi-line)** … this deliberately does **not** foreclose the multi-line typed values most dialects will want. Interior indentation is captured verbatim for now; a dedent policy, if ever wanted, is a dialect-layer concern. (Retires the earlier single-line rule.)"
- **Bears:** the one delimited value that had been ruled line-close was flipped to multi-line at Joseph's urging, with the argument not to foreclose what these constructs will want. He calls spanning "the usual behavior" of "most of the other delimited constructs".

### 2026-07-19 13:43–13:56 — S2: Joseph declines to turn current behavior into law

- **Source:** `~/.claude/history.jsonl` lines 16875 (13:43) and 16876 (13:55). The agent's clarification is in `v2/.archived/second-pass/spikes/session-vault/raw/claude/305776aa-context-loading-for-deep-codebase-understanding.md` line 1534 (Fable 5). Commit `29c8dcd` (13:56). `spec/msc/CHANGELOG.md` lines 242–249.
- **Speakers:** Joseph; agent (Fable 5).
- **Words (Joseph, 13:43):**
  > S2 I ratify multiline accepted as current behavior at 0.9 unless you would prefer the warning
- **Words (agent):** "**S2 needs one clarification — your sentence has two readings.** … could mean (A) arrays become multi-line at 0.9, or (B) ratify the current *per-construct* behavior as the 0.9 contract. Since you asked my preference: **(B)** — promote Line-boundedness from 'deliberately undefined' to *defined for 0.9* exactly as it stands (arrays/identity-keys close-with-warning on the newline; strings/interp span) … the emergent-span finding … and the interior-indentation question … is unsolved."
- **Words (Joseph, 13:55):**
  > I'm ok ratifying current behavior as close enough to "undefined but we'll warn you if we're going to start disallowing multiline". Please make sure any fixtures that are descriptive of technically undefined behavior get allowed to be part of the gate but that they *don't* frame themselves as prescriptive. Auditors will just keep saying "The fixtures say this is *must* but the spec says undefined!" if you don't and it will cause issues-- the last thing we want is for purposefully unspecified behavior to nevertheless calcify into the grammar.
- **Bears:** option D (strings span, lists close at end of line) was offered to Joseph as *defined law* and not taken. He kept it undefined, pinned only descriptively, and said the thing to avoid is "purposefully unspecified behavior … calcify[ing] into the grammar." His first sentence at 13:43, read on its own, leans toward "multiline accepted".

### 2026-07-19 → 07-21 — the greenfields close it per construct, and disagree

- **Sources:**
  - `v2/.archived/first-pass/greenfield-2a/new-spec/OPEN-QUESTIONS.md` Q8 (Fable, snapshot Jul 19 19:28).
  - `greenfield-3a/new-spec/DECISIONS.md` D1 (Gemini).
  - `greenfield-3b/new-spec/DECISIONS.md` D1, revised, and `OPEN.md` O16 (Grok).
  - Feedback files: `greenfield-3a/feedback-fable.md` item 2; `greenfield-3b/feedback-fable.md` lines 19–25; `greenfield-2a/feedback-from-grok.md` §3.4.
  - `v2/.archived/second-pass/OPEN-ML-STRAWMEN.md` (Jul 21 02:49), and `v2/.archived/first-pass/brownfield/BIG-PICTURE-2026-07-20.md` line 119.
- **Speakers:** agents (Fable/Claude, Gemini, Grok).
- **Words:**
  - 2a Q8 (Fable): "Make strings, lists, and interpolations multi-line (structured values want it; the incomplete-input result already covers truncation); keep identity brackets line-bound with warning (a key spanning lines is nearly always an unclosed bracket)".
  - 3a D1 (Gemini): "All Delimited Constructs (Strings, Lists, Envelopes, Identity Keys) MAY span multiple lines … Provides a uniform extent model rather than maintaining a second exception list".
  - Fable on 3b's blanket D1: "**Typo blast radius goes from one line to the rest of the document.** An unclosed `;{` or `!{{` today costs at most a line … under D1 it swallows everything to EOF … Keep-everything means nothing is *lost*, but everything after the typo is *misfiled* — for an interactive author that's the worst repair experience the language could offer, and for streamed LLM output it means one dropped brace re-interprets the entire remainder of the stream."
  - 3b revised D1 (Grok): quoted strings "**Yes**"; lists "**Yes** … Newlines = item whitespace"; identity brackets "**Line-bound** … Protects `$partial-key` fail-safe"; `;{…}`/`!{…}` "**Open** … Failure mode is document-swallow".
  - Grok on 2a: "Joseph's greenfield note was that single-line-only will not last."
- **Bears:** three independent models each landed on **lists and strings multi-line**. Where they differed was identity brackets and the brace forms, and the argument there was accident containment. Joseph noted afterward that he had given them latitude to settle it without the reason it was open (next entry).
- **Incidental:** everything else in these suites.

### 2026-07-21 12:01 — Joseph: arrays as sugar; the question may be wrongly framed

- **Source:** `~/.claude/history.jsonl` line 17063 (verbatim in `v2/udon-needs/pipeline-discussion.md` lines 531–532). The agent's replies are in the same file at lines 554 and 577. The re-marked row is `v2/OPEN.md` line 13, and `v2/DECISIONS.md` R3 is at line 34.
- **Speaker:** Joseph; then agents.
- **Words (Joseph):**
  > - if dialect typing < goes to another part of the grammar, that other part of the grammar can be in charge of any nested <, or whether it accepts multiline or not... However we're currently branching out typing handling (array vs what used to be called bare-value (single text word) vs numeric etc.) would ideally end up mirroring very well the dialect typing mechanism-- and it all changes what the pipeline would look like!
  > - if array capture was just a syntactical sugar for <core/ws-delimited-array: .... > for example, or for geometric/block delimited array, then *that* answers the 'multiline or singleline?" question-- not us arguing in the dark and finally accepting something *that is an incorrectly framed question in the first place guaranteed to be irrelevant the moment we have dialects and schemas worked out* (I didn't tell the greenfield authors about this-- preferring to let them imagine whatever codification they wanted from the current disorganized spec. It was interesting, but it can't now suddenly become "*the* design question of the moment,"  it was left as undefined but loosely speaking allowed (multilines in those constructs) *because* it was a demand-side question that would significantly affect the pipeline needs.
- **Resulting OPEN ML row:** "**possibly a dissolved question** — if `[…]`/strings/etc. are sugar for dialect-typed captures, each capture's grammar owns its own line-span, and there is no per-construct table to close. Do **not** close in the greenfield per-construct framing. | **WAIT-DEMAND** (reframed)".
- **Bears:** this reframes the whole question. Joseph also characterizes the standing status as "undefined but loosely speaking allowed (multilines in those constructs)". Note also "*or* for geometric/block delimited array": a block-shaped spelling of a list is named as a second sugar.
- **Incidental:** the rest of the message is a sampling of demand-side questions (schemas, tools), which he says explicitly is "not necessarily my 'hot-list'".

### 2026-07-22 04:41–05:03 — the 0.9.1 carve-out

- **Source:** `~/.claude/history.jsonl` lines 17192 (04:41) and 17193 (04:53). Commit `84454be` (05:03, Fable 5): `v2/spec-0.09.01/CARVEOUTS.md` lines 5 and 21–29, `CORE.md` §13.2, and `DELTAS.md` row 7.
- **Speakers:** Joseph; then a document.
- **Words (Joseph):**
  > …because I gave them latitude to go ahead if they wished and resolve what are actually in udon purposefully undefined things (multiline issues mostly)-- they did…

  > wrt negative-space: Probably... same story as above, getting it essentially 0.9 but with better carve-outs "multiline array values are not specified pending aux features" (where aux is dialects, schemas, ..., ...) will get us do a good place to modify it when the demand-side decisions are more fleshed out.
- **CARVEOUTS ML:** "**Why open — possibly a dissolved question:** if bracketed/quoted captures turn out to be sugar for **dialect-typed captures** … there is no per-construct table to close. … **Interim (descriptive):** strings/interpolation span; lists and identity keys close at the newline with content kept + Warning (identity via `$partial-key`). The identity case doubles as the fail-safe: an editing accident `|el[k` does not swallow the rest of the document. **Closes when:** the dialects / value-typing spikes (arc 3) settle the capture mechanism against the demand map — not by ruling table rows."
- **Bears:** this is the form the question took from here on (0.10.0 carries it unchanged; the ML section is identical, checked with `diff`).

### 2026-07-29 14:57–15:56 — Joseph: a bracket that opens block mode; then "just lean into the stacking"

- **Source:** `~/.claude/history.jsonl` lines 17921 (14:57) and 17922 (15:50). Fable's write-up is `v2/theory/to-integrate/refine-more/thoughts-on-multiline-array.md` (commit `c27a324`, 15:56).
- **Speaker:** Joseph; then agent (Fable).
- **Words (Joseph, 14:57):**
  ````text
  Your thoughts on array *values* opening geometric/block-mode:

  :some-attribute [
     <123>
     |another-child
       and some text in the heterogenous array's element
     and some text in the array itself
  ]  ; don't know -- probably same "guidance" as closing ``` -- end it where it will make the next lines clear about their parentage if you can....
  ````
- **Words (Joseph, 15:50):**
  > A cleaner option is to simply lean into the stacking we already do and simply allow an attribute to have multiple children and call it an array without warning about it like we currently do. It's a regulator that no one asked for but that I put in there when I was afraid the format was getting too loose and was prone to exploding. But that doesn't seem to scare me anymore in this case.
- **Fable's three readings:**
  - (1) newline as an item delimiter at depth;
  - (2) a multi-line `[` as sugar for an anonymous node, with "**geometric extent with delimited attestation** — geometry parses … while the printed `]` does the one thing geometry can't: distinguish 'dedented' from 'truncated'";
  - (3) stacking as the array. Fable judges (3) "the cleanest — five alignments" and adds: "ML partially dissolves. The bracket's multi-line question loses its motive force: `[…]` stays inline/delimited (one line, item semantics, unchanged), and depth does arrays."
- **Bears:** two new alternatives come out of this: a bracket that opens a geometric block, and multi-line lists written by depth with `[…]` left on one line. Joseph's second message shows which one he found cleaner at the time.
- **Incidental:** the example's `<123>` and `|another-child`, which illustrate that the items are mixed kinds, and the 529 aside.

### 2026-07-28 → 07-30 — paths terminator table: wrapping long paths

- **Source:** `v2/theory/to-integrate/refine-more/paths-ideation/terminator-table.md` lines 169, 226, 254, 278, and 291 (first commit 2026-07-28, last 2026-07-30).
- **Speaker:** agent.
- **Words:** "F1 — available; ML makes long fused addresses awkward to wrap, and fused addresses are the longest ones." … "**ML stays open and should stay open** … F2's advantage over F1 — its line-span owned by its own capture grammar — happens to be ML's dissolution hypothesis, which is an observation, not a closing argument." … "The paths↔ML dependency runs paths → ML".
- **Bears:** one concrete source of demand for long values: wrapping long quoted addresses.

### 2026-07-30 — a reader flags its own attraction to the dissolution idea

- **Source:** `v2/msc/read-log-2026-07-30/00-initial-predictions.md` lines 89–92.
- **Speaker:** agent (Opus 5), writing before reading the spec.
- **Words:** "OPEN calls it 'possibly a dissolved question' … I find this elegant and therefore suspect I'll over-believe it. Flagging that now."
- **Bears:** included as a calibration note on how persuasive the dissolution framing is.

### 2026-08-07 → 08-09 — K-rulings: stacking is silent, and a label names a collection

- **Source:** `v2/DECISIONS.md` rows K7 (line 170, Aug 7), K11 (line 176, Aug 8), K15 (line 172, Aug 9), and K16 (line 171, Aug 9). `~/.claude/history.jsonl` lines 18906 (09:10), 18907 (09:16), 18908 (09:18), and 18909 (09:27). Agent replies at memorata `6ce33695…jsonl` lines 869, 878, and 923 (`agent-to-human-flanking`); the fork report is at line 832 (09:06).
- **Speakers:** Joseph; agents (Claude, with forks).
- **Rows:**
  - K11: "**Warned extension retires — stacking is silent everywhere.**"
  - K7: in a deferred body, only the first line is value-special.
  - K16: "Every value-expected position — … list items, … key interiors … — takes the whole value grammar".
- **Words (Joseph, 09:10):**
  > What's your opinion on indicating that "stacking" is just a way to spread out a list/array -- i.e., the attribute label can occur interleaved with other things to build its items, so that it isn't treated *too* differently?
- **Words (Joseph, 09:16):**
  ```text
  In my mind, I've always assumed
  |el
     :x 1
     :x [2 3]
     :x [4 [5 6]]
  ==> :x [1 [2 3] [4 [5 6]]
  And that it would be the app's decision on whether or how much to flatten it. Anything less seems to me like it would be actual data loss.
  ```
- **Agent's final word (09:46):** "**Three spellings of 'contribute':** repeat the label (stacking — sameline, block, interleaved with other labels, all fine) · bracket several things into *one* contribution that is a list (`[…]`) · defer to a body (the first line is the value position per K7; subsequent lines are further items)."
- **Fork report (09:06):** "a multi-line inline element as a *list item* nests a settled-multi-line delimited form inside a line-bound-by-descriptive-behavior one — who wins at the newline is ML-carve-out territory (the same edge multi-line strings in lists already have). One line against OPEN ML so it isn't discovered by a parser author."
- **Bears:** by Aug 9 there is a ratified way to write a list across lines without `[…]` spanning. Repeated labels and deferred bodies build the collection, and a bracketed list stays one contribution. Separately, the fork names a nesting case this question cannot avoid: a spanning `|{…}` inside a list.
- **Incidental:** the `$main` and K9 discussion in the same hour, and the `:x = 1` versus `[1]` question.

### 2026-08-09 → 08-11 — 0.10.0-alpha.1 carries the carve-out unchanged

- **Source:** `v2/spec-0.10.00/CORE.md` §13.2 (lines 760–766), §5.3 (line 222), and §13.3 (line 775); `CARVEOUTS.md` ML (identical to 0.9.1's).
- **Speaker:** a document.
- **Words:** "**Do not close this per-construct**" … the CURRENT BEHAVIOR box: "Ratified only as 'undefined-but-warn-before-disallow' (S2)". §5.3: "If the `]` never arrives — end of input, or an interior newline under current behavior (§13.2) — … **`$partial-key`**".
- **Bears:** this is the "0.10.0 §13.2" the neutral file cites.

### 2026-08-27 — 0.10.1-draft: spanning law, lists span, fail-safes declared

- **Source:**
  - `v2/theory/to-integrate/unification-matrix-2026-08-27.md` lines 25 and 36.
  - `v2/spec-0.10.01/DELTAS.md` rows 4 and 12.
  - `v2/spec-0.10.01/CORE.md` §10.5 (lines 346–356) and §11.2 (lines 364–366).
  - `v2/spec-0.10.01/NUANCE-AUDIT.md` line 36.
  - Commits `4c36510` and `adcb185` (Fable 5), marked PROPOSAL DRAFT.
- **Speaker:** agent (Fable), under Joseph's "theory leads" license (per `WHERE-THINGS-STAND`).
- **Words:**
  - Matrix: "ML (multi-line per-construct table) §13.2 | capture grammars own their spans | **dissolves**".
  - CORE §10.5: "**A delimited construct closes at its printed closer — geometry is irrelevant — unless it declares a fail-safe boundary, with its reason**". The table: strings "yes"; "lists `[…]` | **yes** ⟨PROPOSED — was closed-at-EOL-with-Warning⟩"; identity/selector brackets "no — **EOL fail-safe** | an editing accident (`|el[k`) must not swallow the document".
  - §11.2: "A delimited construct MAY declare a fail-safe boundary … only with a stated accident-containment reason."
- **Bears:** this is the "0.10.1-draft (misfire)" in the neutral file. The general rule (a delimited value ends at its printed closer, with a declared fail-safe as the exception) is a framing the neutral file doesn't carry.

### 2026-09-01 — the audit (A2), and the agent's alternative proposal

- **Source:** `v2/spec-0.10.01/working-notes/AUDIT-2026-09-01.md` lines 25–29 (A2), 57 (B1), and 66 (B9). `v2/JOSEPH-FOR-0.10.01-FIX.md` line 147 (agent text, per `WHERE-THINGS-STAND`). Joseph's "misfire" call is in `~/.claude/projects/-Users-josephwecker-v2-src-arch-firmatum-udon-v2/cdbd2a91-….jsonl:276` (via memorata, 19:59).
- **Speakers:** agent (auditor); agent (proposal); Joseph (about the whole draft).
- **Words (A2):** "A forgotten `]` in `:tags [a b` ⏎ now swallows every following line into the list until EOF (→ `incomplete-input`) or the next stray `]` anywhere below. The admission rule in §11.2 … is satisfied by lists exactly as well as by identity; the draft does not say why lists differ. Nor does it say what a **block-form marker inside a spanning list** does (`[1` ⏎ `|other :a 1` ⏎ `]`) … text item? terminator? warning? … Either lists get the fail-safe with the same reason, or the row states why the accident cost is acceptable for lists (my guess at the honest reason: multi-line lists are a real demand the identity bracket never had — but say it)."
- **Words (B1):** "DELTAS 4 vs DELTAS 12. … Same file, opposite claims."
- **Words (FIX proposal, agent):** "Lists stay closed-at-end-of-line for now, since the demand for multi-line lists has not been argued and the accident case is real."
- **Words (Joseph, about 0.10.1 as a whole):** "It's not like there's a ton of theory even. I'm going to call 0.10.01 a misfire."
- **Bears:** this is the accident argument in its sharpest form, plus an open case (a block marker inside a spanning list). Joseph's "misfire" is aimed at the draft overall, not at this row. I found no Joseph statement specifically about DELTAS 12.

### 2026-09-29 — spec-lite; and what the estate actually writes

- **Source:** `v2/spec-lite-0.1.0/README.md` and `pre-design/05-values-across-lines.md`. The scan is my own measurement (method below).
- **Speaker:** documents (coordinator); me.
- **Measurement:** I ran a regex scan over 161 `.udon`/`.ud` files under `~/src`, excluding the udon repo, `_older`, `_ref`, and `.moved-and-integrated`. It found **228** `:label [ … ]` list values, **none** left open at the end of a line, **none** with more than 10 items, and **no** quoted attribute value open at the end of a line. The 6 heuristic hits were all false positives, which I checked by hand. The udon repo's `design/examples/` and `_archive/` `.udon` files had **zero** hits. Caveats: this is regex, not a parse; fenced blocks and `;` lines were skipped; the corpus is mostly agent-written.
- **Bears:** the live corpus shows neither demand for spanning nor any accidents that line-close would have contained.

---

## Threads worth noticing

*This section is my own reading of the history above.*

1. **Joseph's direction and his chosen status have pointed different ways, consistently.** The direction: "we will want them to be multi-line at some point, all of them" (Jul 18), and "most of those *will* end up being multi-line" (Jul 18 night, when he pushed `<…>` over). His descriptions of the status: "undefined … use multi-line at your own risk" (Jul 18), and later "undefined but loosely speaking allowed" (Jul 21). When an agent offered to make the current split into law on Jul 19, he declined, citing the risk of calcification. The *reason* for the deferral changed over time. On Jul 18 it was consequences not yet understood ("head-position etc."); on Jul 21, possible dissolution into dialect capture. The direction did not change.

2. **Line-close for lists came from the implementation, not a decision.** The parser spanned lists from at least Dec 30, 2025 until Jul 16, 2026. The newline arm arrived inside a large densification commit framed as "EOF per CORE's table". The CORE of that day still said "the array closes only on `]`". Every later mention of line-close treats it as descriptive: the Jul 16 packet's "today", S2's "current behavior", CARVEOUTS' "Interim (descriptive)". An agent concluded on Jul 18 that "array line-boundedness was never actually decided". When the neutral file writes "Old parser: … lists … close at end of line", that is true only of the parser since Jul 16.

3. **The fail-safe argument has two different strengths, and history keeps merging them.** For identity brackets, Joseph named the reason: "the gravity of a $key that is not actually a key", which matters most in a reference's key. A truncated key can be *acted on*. For lists, the cost is *misfiling*: keep-everything holds, but the following lines land inside the list. Fable (Jul 19–20) and the Sep 1 audit treat the two accidents as the same kind of harm; the 2a greenfield and 0.10.1 separated them. How much misfiling costs is the real disagreement, and different agents weighed it differently. Fable called it the worst repair experience for interactive authors and for LLM streams. 2a called it acceptable because incomplete-input covers truncation.

4. **Depth as the multi-line list is the simplifying thread that keeps coming back.** It appears in 2011 ("put the text, indented appropriately, on the next line"), in 2025-12 ("Attribute followed by newline+indent = structured value"), in the Jul-16 packet ("the deferred-block + stacking machinery that already exists"), in Joseph's Jul-29 "lean into the stacking", and as K11/K15 on Aug 8–9 (three spellings of "contribute"). Under this thread, `[…]` would not need to span for authors to write lists over many lines. What remains for `[…]` is only the accident and "delimited means delimited" question. That fits Joseph's stated test of simplifying rules without surprise, but whether the bracket is then *allowed* to span is still open.

5. **Strings carry a question lists don't: continuation indentation.** The parser keeps it verbatim (`"abc\n  def"`). The sandbox called this "the load-bearing multi-line-string question", and `<…>` settled it for itself only as "captured verbatim for now; a dedent policy … is a dialect-layer concern". Joseph's only direct statement on multi-line captured content (Dec 28, 2025) prefers automatic dedentation. A "strings continue" answer that doesn't settle this leaves the value dependent on where the author indents.

6. **Nesting ties containers to their contents.** A spanning string inside a line-close list reaches the list's `]` cleanly (Jul 18 sandbox). A spanning `|{…}` inside a list is the same case (Aug 9 fork). K16 puts the full value grammar, spanning strings included, inside identity brackets too. Any choice of the form "strings continue, lists close" has to say what happens when one sits inside the other. S2's own text says that "container and contents decide together".

7. **The history's form of "undefined" matches lite's "reserve, don't ignore" in shape, not in severity.** S2's promise was that a later version "will warn before disallowing" and "will not silently change meaning". That is a forward contract, like lite's. But historical "undefined" never meant *error*: the parser kept its behavior and authors went ahead at their own risk. Option C in the neutral file would be the first time the undefined span is refused. Whether that is a stronger version of what Joseph asked for, or a different thing, is not settled anywhere in the history.

8. **Who converged, and on what.** Three greenfield models (Fable, Gemini, Grok), working blind to the dissolution idea, all made strings and lists multi-line. The 0.10.1 author did the same from theory. Only the Sep 1 agent proposal kept lists closed at end of line, and Joseph later said that proposal as a whole felt "less and less principled". Joseph has said nothing about lists spanning since Jul 29, when he moved the multi-line-list demand onto stacking.

---

## What the neutral file misses

1. **A correction to "Old parser".** Lists spanned in the reference parser for about six and a half months (≤Dec 30, 2025 → Jul 16, 2026). Close-at-end-of-line arrived on Jul 16 through fixture and implementation work, not a ruling (entries for Dec 30–Jul 16, Jul 16 05:02, and Jul 18 15:22). Strings have always spanned. The Jan-2026 illustrative EBNF made strings single-line.

2. **Option E: lists span by depth; `[…]` stays on its line.** Stacking and deferred bodies already build multi-item values across lines (K11/K15; the Jul-16 packet; Joseph's Jul-29 "lean into the stacking"). This alternative needs no new syntax. Example:
   ```udon
   |el
     :tags a
     :tags b
     :tags c
   ```
   This gives `tags` as the collection `a b c`, per K15's default read. Combined with B or C for an unclosed `[`, the accident case stays contained and authors still have a multi-line list. The neutral file shows a multi-line list only as bracket option A.

3. **Option F: a bracket that opens a block (Joseph, Jul 29).** `:attr [` at the end of the line opens a block of items by indentation, and the closing `]` attests that the block is complete. Fable's name for it was "geometric extent with delimited attestation": a missing `]` at a dedent is a warning, and a missing `]` at end of input is incomplete-input. It is a hybrid: geometry sets the extent, and the bracket distinguishes "dedented" from "truncated".

4. **Option G (2011): continue, but a dedent to the owner's column closes.** "Maybe follow nesting": an unclosed quote or bracket spans deeper lines but closes, with a warning, at the first line that dedents out of the owner. This limits the accident to the element's own body instead of the rest of the document. Unquoted values have followed that rule since Dec 2011 ("STOPS ON: dedented newline").

5. **Option H: dissolution (Joseph, Jul 21).** `[…]` and `"…"` could be sugar for a typed capture (`<core/ws-delimited-array: …>`), and the capture's grammar would own its line span. This bears on lite because lite already carries `<…>` as an untyped box that spans lines ([07](07-untyped-angle-box.md)).

6. **The continuation-indentation sub-question for strings.** Option A's example continues at column 0, which hides the issue. Under the current parser, `|el :k "abc` followed by an indented `def"` gives `"abc\n  def"`, verbatim. Blank lines inside a string are also unsettled. Joseph's Dec-2025 preference was automatic dedent for captured multi-line bodies.

7. **Nested cases.** Each alternative would need to say how it handles these:
   - `|el :xs ["a⏎b" 2]`: a spanning string item inside a list.
   - `[|{a⏎b}]`: a spanning inline element inside a list.
   - A spanning string inside an identity key (K16).
   - A block marker inside a spanning list, `[1` ⏎ `|other :a 1` ⏎ `]`. The Sep 1 audit asked about this; the neutral file's option-A accident tree quietly treats `|next` as the string item `"|next"`, which is one unstated answer.

8. **The difference in outcome.** Close-at-end-of-line leaves a structurally complete document with a local warning and a zero exit. Spanning to end of input leaves incomplete-input and a non-success result. The Jul-18 EOF design treated this as "the distinction that earns its keep" for CI, and Joseph endorsed it the same morning.

9. **A possible case error in option B's tree.** In the neutral example, `second line"` sits at column 0. Under the recorded parser behavior for close-at-end-of-line (`ml_arr_never_closed_lines_become_prose`), an unindented line after a closed element becomes **root-level** text, not a child of `el`. The tree shows it as `el`'s child.

10. **The identity bracket's reason is its own.** The neutral file lists `[key]` as "not contested, for consistency". The history shows why: Joseph's Jul 18 "gravity of a $key that is not actually a key". That reason doesn't carry over to lists or strings, whose accident cost is misfiling, not a wrong identity being acted on. Some agents (Fable, the Sep 1 audit) argued the lists' accident is still serious enough to earn a fail-safe.

11. **`;{…}` belongs to the same undefined set.** Through 0.10.0, inline comments were in the same undefined-span group as strings and lists. Only `|{…}`, the fence, and `<…>` were settled. If `;{…}` is in lite ([10](10-inline-elements-and-inline-comments.md) Q2), it inherits this question, including Grok's "document-swallow" worry.

12. **One point of history the neutral file compresses.** Its "0.10.0 §13.2 … should not be closed construct by construct" is right, but the reason came from Joseph on Jul 21, *after* three greenfields had closed it per construct. CARVEOUTS says the register exists because of that measured failure.
