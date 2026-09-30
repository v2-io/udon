# 07 — The untyped `<…>` box: history

**Written by:** Claude (Opus 5.5), a history agent, 2026-09-29, for [`07-untyped-angle-box.md`](07-untyped-angle-box.md). History only. No leans or recommendations. Leans get added after this.

**Method.** I read the neutral file, `pre-design/README.md`, `../README.md` and `../../WHERE-THINGS-STAND-2026-09-27.md` first. Then:

- **Joseph's own typed prompts** from `~/.claude/history.jsonl`. I kept every prompt whose project or text mentions udon and whose text matches `<…>`-shaped tokens, `angle`, `envelope`, `u64`, `dialect`, `temporal`, `bare date`, `typed value`, `typing`, `ladder` or `date(s)`. That gave 209 prompts, and I read every one that touched this question. They are quoted from there, so line breaks and indentation are intact. Each is cited by its timestamp (local time).
- **memorata-search**, restricted to the non-thinking classes (`human-user`, `agent-to-human`, `document`, `subagent-final-response`), with `-n 60`, first `--pool 200` and then `--pool 100`. Queries, in the order I ran them:
  - Mixed classes: "udon angle bracket typed value", "udon type envelope <type:value>", "envelope ladder dialect type content", "label ladder angle box", "udon <…> typed literal dialect", "udon dates temporal angle brackets <2026-01-01>", "udon Norway problem bare dates string", "udon dialect typing <u64:0xff>", "angle bracket nested depth counted closing >", "empty <> nil udon", "multi-line angle bracket value unclosed", "udon < dispatches to sub-parser", "udon typed value syntax <int:5>", "temporal dialect interval duration udon", "angle brackets in prose udon HTML", "raw capture merge angle bracket code block".
  - `--joseph`: "angle brackets udon" and "typed values in udon". A longer batch was stopped at this point, when memorata was using too much RAM with twelve siblings running. After the resume: "angle brackets typed values dialect", "dates should be in brackets temporal", "<...> envelope nested multi-line", "explicit typing annotation bracketing", "what would <> mean in prose html".
  - Agent/document classes: "envelope closes at first unescaped > label identifier-led", "<>-balanced depth-counted envelope nesting matching >", "envelope multi-line newline content UnclosedTypeEnvelope single-line", "empty envelope < > nil NoDialectsLoaded", "<q: a > b> mis-captures comparison operator envelope".
- **Repo files.** In the umbrella repo: `spec/CORE.md` (Explicit Typing), `spec/TIME-SPEC.md`, `spec/msc/CHANGELOG.md`, `_archive/DECIDED.bak.md`, `_archive/decisions-superseded/explicit-typing-brief.md`, `_archive/REVIEW-JULY-2026.md`, `design/composite-types.md`, `core/generator/30-udon.values.descent.udon`, `core/generator/temporal-value.desc.setaside`, and `core/fixtures/v0.9/{typing_envelope,eof_delimited}.yaml`. Under `v2/`: `DECISIONS.md`, `OPEN.md`, `msc/for-joseph/*`, the 0.9.1, 0.10.0 and 0.10.1 suites (CORE, CARVEOUTS, DELTAS, the Sep-1 AUDIT), `JOSEPH-FOR-0.10.01-FIX.md`, `udon-needs/pipeline-discussion.md`, the dialects testimonies, `theory/to-integrate/**` (dialects-ideation, lexical-forms, unification matrix, sameline-value-space, MINEFIELD-MAP, ADJUDICATED-CLAIMS, paths terminator-table), `references/.archive/second-theory-iteration-2026-08-08/hypothetical-sketch.md`, and `.archived/` (greenfield and second-pass). Also the 2011 originals at `~/src/_older/udon` and `~/src/_older/udon-c`.
- **Git.** I used `git log -S` / `-G` on `Explicit Typing`, `NoDialectsLoaded`, `Label ladder`, `Envelopes span newlines`, `Nesting (forward note`, `Unlabelled dispatch`, `typed_value` and `D2-ET` to date each landing. The value-dialects brief was read from commit `8e0e576`.
- **A probe.** I ran four inputs through the mainline 0.9 parser (`core/target/debug/examples/stdin_parse`, repo HEAD `9f69f42`). Its output shows what was built, not what was intended.

**What I did not open.** I did not open raw `.jsonl` transcripts. I also did not open the raw session-vault rendering `v2/.archived/second-pass/spikes/session-vault/raw/claude/da5d1672-*.md` (the Jul 11–14 session where the envelope was born), because it contains model-thinking markers. Joseph's side of that session comes from `history.jsonl`. The agent's side comes from the documents it produced (the S-ET brief, DECIDED.bak, CORE, composite-types.md). Nothing was blocked by the platform.

**Nothing found.**
- The 2011 originals have no typing envelope. `<` was used there for other things (entry 1).
- No escape mechanism inside `<…>` has ever been specified or built. I grepped CORE, 0.10.0 and the grammar.
- The two label-ladder forks from 2026-07-11 ("dialect-first; parallel aliases") were never ruled. `git log -G` finds them only in the commit that raised them.

**Terms.** The same construct has been called the *explicit-typing envelope* (Jul), the *envelope* (0.9–0.10.0), the *value capture* (0.10.1-draft) and the *box* (the Sep-1 FIX text, and now lite). The `type:` / `dialect:type:` prefix has been called the *label ladder*, the *envelope ladder* and (in 0.10.1) `vocab:kind:`.

---

## History (chronological)

**1. 2011 (Aug–Dec): the originals.** *Sources:* `~/src/_older/udon/examples/overview.udon:139-146` and `latest.txt` ("2011-Aug-22 examples/overview.udon -> <( <{ stuff"); `~/src/_older/udon-c/docs/DECIDED.md:27-33, 209-245` (commits 2011-12-14 to 12-22). *Speaker:* Joseph (documents).
- In 2011, `<` meant templating and inline structure, not typing. Examples: `|h1 class:<:$itsclass:> <:$attr:>: val2<:$i:>_b <:blah:>` and `|html<(head|title Awesomeness …)>`.
- udon-c had a delimited value form with the same shape as today's box:
  > "PROTECTED/SHIELDED: parenthasese-delimited label or value — APPLIES TO: can be in place of labels or values — STOPS ON: last matched close-parenth — PROBLEM: if you want an unmatched parenth (like in quotes; ")" for example) you're out of luck in label contexts. Use freeform in value contexts … Can be interpreted as simple potentially nested tuples or lists"
- Under "Future scalars ???" the same file lists "Dates · Times · Intervals · Numbers … Regex · Bitstrings … (plugin for scalars)".
- *Bears on:* Q1. This is the earliest depth-counted ("last matched") delimited value, and its known cost (an unmatched closer) was written down in 2011. Dates and times were already imagined as pluggable scalars. *Incidental:* the `<:…:>` templating syntax is long gone.

**2. 2025-12-22 and 12-24: "dialect" first means a `!` handler.** *Source:* history.jsonl 2025-12-22 18:56 and 20:37; 12-24 07:18. *Speaker:* Joseph.
> "I love the idea that `!...` is for any dialect, depending on the host, with some basic Liquid ones built in...."

*Bears on:* only the vocabulary. The word "dialect", later used for the thing that owns `<…>` contents, started as the name for `!` blocks, following Rebol. *Incidental:* everything else in these prompts.

**3. 2026-01-01: `<>` in descent.** *Source:* history.jsonl 2026-01-01 12:33. *Speaker:* Joseph.
> "they had the wrong idea about what '<>' did (it's meant to mean null -- or do not match anything-- an empty string, for use in turning PREPEND into a no-op)"

*Bears on:* nothing directly. This `<>` is descent grammar syntax, not a UDON value. I include it only because it is Joseph reading `<>` as "null / empty" in a nearby notation, which is relevant background to Q4.

**4. 2026-01-03 to 01-14: bare temporal is built.** *Sources:* history.jsonl 2026-01-03 17:15, 01-09 17:35, 01-13 21:25; commits `3c5447d` (2026-01-09 "Add new time spec…") and `ca3ddd3` (01-13). *Speaker:* Joseph; agents built it.
> "Is there any kind of idiomatic way to define dates / datetime / time / span  attribute values?" (01-03)
>
> "I don't know that the refactor would work-- if you saw `:maybe-date 2026-03-24T03:12:4.993290109288-says-what` -- how would you know not to emit the Y/M/D events? How would you know it was even a DateStart?" (01-09)
>
> "Attribute values are the only place where we are typing the values syntactically..." (01-13)

TIME-SPEC recognized bare dates, times, durations and relative times. It also warned on near-misses, for example `:date 2025-1-3 ; WARNING: missing leading zeros -> bare string`.
*Bears on:* this is the "temporal parser already built" that Joseph now wants to reattach. It is also the origin of the lookahead worry that later motivated a delimiter.

**5. 2026-07-08: the accretion concern, and Joseph's CTQ line.** *Sources:* `_archive/REVIEW-JULY-2026.md` §3 (the concerns list, item 1) (a Claude session, at Joseph's request); history.jsonl 2026-07-08 13:40. *Speaker:* agent (review); Joseph (CTQ list).
- The review: "**Type-space accretion erodes bare strings.** Temporal types are the live demonstration: every typed bare-pattern added silently retypes existing documents (`2025-12` was somebody's product code; now it's a YearMonth)."
- Joseph's brainstormed CTQ list included:
  > "IN? Mechanism for explicit temporal typing (or explicit typing generally w/ temporal as instance) possibly as part of dialects, as alt. to eroding prose-space & to avoid violating principle of least surprise"

*Bears on:* the purpose of the box. It exists to avoid (a) eroding prose-space and (b) least-surprise retyping.

**6. 2026-07-11 (afternoon): value-dialects brief S2b.** *Source:* `decisions/value-dialects-brief.md` at commit `8e0e576` (later archived). *Speaker:* agent.
- It proposed options A, B and C: temporal stays in the core; a default-on std dialect; or an opt-in dialect.
- The key idea was splitting "**recognition** (surface shape, frozen, in the generated deterministic machine)" from "**typing** (semantic assignment, in the tree/host projection layer)."
- It counted about 29 live temporal values in the corpus, all full `YYYY-MM-DD`.

*Bears on:* the recognition/typing split, which is exactly the lite stance (carry raw text; typing comes later). *Incidental:* the pragma/profile machinery.

**7. 2026-07-11 19:43: Joseph asks for explicit typing.** *Source:* history.jsonl 2026-07-11 19:43. *Speaker:* Joseph. Verbatim:
> "Basically I wonder if it makes sense to either have:
> 1. explicit typing annotation (with the existing types allowed to be explicit also but usually implicit according to the rules already in place)
> 2. explicit bracketing or something -- <this is not text>   <u64i|0xf902> ??  (I don't know, and my udon needs refreshing to see what would unnecessarily collapse the prose capabilities etc.
> 3. reuse some existing syntax carve-outs like inline stuff or dialects to mark explicit types?
>
> This would allow for us to much more easily carve out temporal as a dialect, for example:  <P12....> (no type declared, but brackets say it's not plain text and that a dialect should be around to handle it)  <interval:....>  or <time:interval:....> (type or dialect+type prefix for more and more specificity)...  (again the <,>, are just examples-- I would be happy to entertain whatever you guys think would potentially conflict with the existing syntax and space as little as possible. One affordance we have is that we are only collapsing the space of attribute value plain-text, not the prose blocks..."

*Bears on:*
- Q3: this is where the ladder comes from. Joseph's first type example used a **pipe** separator (`<u64i|0xf902>`), while the interval examples used colons.
- Q5: "only … attribute value plain-text, not the prose blocks."
- The brackets were explicitly offered as *examples*, not a choice.

**8. 2026-07-11 (evening): spike S-ET, the explicit-typing brief.** *Source:* `_archive/decisions-superseded/explicit-typing-brief.md` (whole). *Speaker:* agent (the "Explicit-typing syntax spike"). Its "near-verbatim" restatement of Joseph normalized his `<u64i|0xf902>` to `<u64:0xf902>`.
- **Candidates.** C1 `<…>`, C2 `!{:kind: …}`, C3 backtick, C4 `~`, C5 annotation-only.
- **Collisions.** Zero bare-value collisions with `<…>` across about 35k lines. Every `<` and `>` in the corpus was in prose, comments, quotes or raw blocks.
- **Where it ends (Q1).** "Envelope closes at the **first unescaped `>`**. Interior is opaque bare text." And: "A literal `>` inside content: quote the whole value (`":op >="`) or let the dialect define an escape. Corpus need: **zero**."
- **Labels (Q3).** "Label segments are `[A-Za-z][A-Za-z0-9_-]*` **identifier-led**; label parsing stops at the first segment that isn't identifier-led. This resolves the colon-in-content wrinkle: `<time:14:30:00>` → dialect=`time`, content=`14:30:00` (because `14` is digit-led, not a label)."
- **Fork 1.** Either a flat shared namespace, or "require dialects to always be the *first* segment, so one-colon is *always* type". The brief leaned toward the second.
- **Unknown labels.** "Menu: `error | pass-through-as-typed-string | warn`. **Default: pass-through**."
- **Uncertainty ledger.** "Relational-operator *values* (`:op <=`) are the one plausible future collision for C1 … Mitigation: such a value is quoted (`:op "<="`) or the policy dialect owns `<…>`."
- **Arrays.** "the outer `]`/`}`/space terminators are suspended inside the envelope."

*Bears on:* Q1, Q3 and Q5 directly. This is the first written answer to each.

**9. 2026-07-11 20:01 and 21:33: Joseph ratifies (D2-ET, D2-ET-ext).** *Sources:* history.jsonl 2026-07-11 20:01 and 21:33; `_archive/DECIDED.bak.md:162-231`; commits `1ab46f6` and `48b21dd`. *Speaker:* Joseph; ledger by agent.
> "I don't like evicting the shorthand -- I like just bracketing them still,  <5m> (declared dialects get them in declared order; error if all declared pass on it, and still open question about whether or not temporal is an implicitely declared dialect-- I'm kind of still leaning toward 'yes' but that's an udon-core question not an udon-syntax question" (20:01)
>
> "I'm actually happy leaning even further than you: all temporal types require the brackets, including iso date forms etc., with the assumption that they otherwise end up as plain text for the most part" (21:33)

The ledger then records "Three non-sniffing ways to type a date": `<2026-07-07>`; `<date:2026-07-07>`; or a bare `:created 2026-07-07` plus a schema declaration. It also says the bare temporal recognition "relocates OUT of bare-value parsing into the `<…>` dialect processor … The recognition logic moves; it isn't lost." It leaves open "the two label-ladder forks (dialect-first; parallel aliases)", and these were never ruled later.
*Bears on:* this is why dates are boxes in lite. Typing by schema declaration is a third route that a lite user already has, with nothing in the box. *Incidental:* the "declared order" dispatch, which lite has no need for.

**10. 2026-07-13: CORE gets "Explicit Typing".** *Sources:* commit `ce44862`; `spec/CORE.md:1667-1690` (current text); history.jsonl 2026-07-13 23:48 (the TIME-SPEC banner).
- The first CORE text said "in attribute-value position, where `>` terminates the value". That wording is still at `CORE.md:1669`.
- It spelled the ladder `<type:...>` / `<dialect:type:...>`, which silently adopts S-ET's Fork-1 lean (one colon means a type).
- "Outside bare value position -- in prose, or inside quotes -- `<` has no special meaning."

*Bears on:* Q1 (first-`>` wording at birth) and Q5.

**11. 2026-07-14: nesting enters, and with it depth-counting.** *Sources:* history.jsonl 2026-07-14 02:08, 13:29, 13:55 (re-sent 14:40); `design/composite-types.md` (commit `31f1bfe`); CORE nesting note (commit `a8288e8`, `CORE.md:1684`). *Speaker:* Joseph; note by agent.
> "1. I agree with quoting <> if you want it as an attribute string/bare value instead of special type" (02:08)
>
> "it also brings up the idea of nested and composite types, which will almost certainly be a thing one way or another when we get there...    <r: <i: 3 -7> 0d83.23> ... ..." (13:29)
>
> "innevitably there will be type nesting and therefore a bracket-stack-- which we should *note* in the fullspec but not overspecify in any way right yet, because it might be the dialect that's in charge of routing inner typed values etc.-- some kind of implicit dialect stack instead of our grammar consuming and passing things off-- we'll see" (13:55)

- composite-types.md (agent): "**`<…>` must be `<>`-balanced (nesting), not "first `>` terminates".** … This is the one core refinement the direction requires." It reads Joseph's example as "the label is the type, the **space-separated body** holds the components".
- Its open sub-questions: "Positional vs. named components (`<r: 3 4>` vs. `<r: num=3 den=4>`)? Separator rules inside the body (space-only? something else)?"

*Bears on:*
- Q1: this is the origin of depth-counting. The motive was composite numerics, and routing was deferred to dialects.
- Q3: Joseph's own spelling here has a **space after the colon** (`<r: <i: 3 -7> …>`).

*Incidental:* the rational/complex status debate.

**12. 2026-07-15: interim pass-through; boxes only in the "map".** *Sources:* history.jsonl 2026-07-15 02:28, 13:25, 14:04, 14:33; CHANGELOG `0.8.0` "Added" (`spec/msc/CHANGELOG.md:432-435`); commit `7764e03` (bare temporal carved into `temporal-value.desc.setaside`). *Speaker:* Joseph.
> "I think we can, for right now, add to CORE that <...> will emit a warning that there are no loaded dialects yet, and then simply pass it through as text for right now." (02:28)
>
> "The other side of this general-data-model perspective is that right now we are only allowing <...> types in the *map* but not as array values / children...
>
> ```
> |element
>    :some-attr <u64: 0x94f>
>    Some prose
>    <symbol: 'a-literal-value'>
> ```
>
> Useful?  Hmmm... not particularly-- because then the user has to keep track of or detect which children are which type...
> Which is *why* we tend to only care about it in the attributes: Attributes keep track of the label from the parent perspective, *and* its type implicitly (or, soon, explicitly)" (13:25)
>
> "`:alpha <something-here> ; anything else other than a comment and whitespace-- anything that tries to be prose or an indented subsequent line-- ILLEGAL -- error-- alpha is just one thing per invocation.`" (14:04, inside a longer example)

At 14:33 there are comments using type-like names: `:count 4209… ; <number:...>` and `:count 32849…-to-1 ; <text:....>`.
- The set-aside temporal grammar's header says: "When temporal@1 lands, the envelope-content parser is the natural place to re-home these states; the `space_term`/`bracket` terminator plumbing will likely be replaced by a single `>` terminator."

*Bears on:*
- The warning (the neutral file doesn't raise it; see the last section).
- Q5: Joseph rejected typed boxes as children. Array items came in the same week (CHANGELOG 0.8 "`<…>` in array items").
- Q3: the space-after-colon spelling appears again (`<u64: 0x94f>`, `<symbol: '…'>`).

*Incidental:* the 14:04 "ILLEGAL" belongs to the attribute-model debate, later overturned by K9–K11 (stacking is silent). The `<something-here>` is just an example value there.

**13. 2026-07-16: delegated ruling "envelopes single-line".** *Sources:* commit `fa28403` ("0.9 minor rulings pass (delegated): EOF model, envelope single-line, and kin"); CHANGELOG `core-v0.8.0` notes (`CHANGELOG.md:364`): "`<…>` envelopes single-line (`UnclosedTypeEnvelope` warn + string pass-through)". *Speaker:* agent, under Joseph's delegation.
*Bears on:* Q2. This is the first ruling, and it was reversed two days later.

**14. 2026-07-18 (noon): multi-line "undefined like the others"; empties go to nil.** *Sources:* history.jsonl 2026-07-18 12:33, 12:44, 12:47, 13:15, 13:21; CHANGELOG `CHANGELOG.md:117-131`. *Speaker:* Joseph.
> "I ask not so we can add single-line restrictions. I suspect we will want them to be multi-line at some point, all of them. But that will have some implications on head-position etc., so I'd like to defer it." (12:33)
>
> "<...> is not any different-- it is 'multi-line-undefined' just like the others that aren't explicitly multi-line already." (12:47)
>
> "you can also bless a currently technically undefined path:  `@[     \n         \n\n  \t\n ]` (for example) -> nil  also instead of a string with whitespace. not necessarily spec level-- but for the current behavior. Same with <>, < >, <   \n\t  >, etc.  The exception to *this* is array, which gives just an empty array instead of an array with a single nil value." (13:15)
>
> "For the < > current-implementation nuance-- I'm genuine in keeping it undefined so the current warning is ok, but if when we get to the grammar we find that it's much easier to simply remove that warning and do the same as the other delimited-maybe-multiline constructs, esp. with the pre-trimming of whitespace, just drop the warning." (13:21)

- CHANGELOG, as recorded: "single-value slots — identity key `|el[ ]`, reference key `@[ ]`, envelope `< >` — → **nil**". But "**Multi-line** whitespace (with newlines, `<  ⏎  >`) stays in the deliberately-undefined multi-line space."
- The agent that session (fb57249f, a vault rendering) had read the ruling as including newlines.

*Bears on:* Q4 and Q2. Note that Joseph's 13:15 words include `<   \n\t  >` → nil, but the ledger narrowed this to single-line whitespace.

**15. 2026-07-18 (evening): the box becomes multi-line.** *Sources:* history.jsonl 2026-07-18 22:30, 22:38, 22:39, 22:45, 22:49; agent reply `6c1ad867…jsonl:1212` (memorata `agent-to-human`); commit `e377585`; `CORE.md:1680`; grammar `30-udon.values.descent.udon:51-72`; CHANGELOG `:88-93`. *Speaker:* Joseph; agent (Claude Opus 4.8).
> "getting the <...> envelope more standard and compliant (IIRC it was already doing its grammar a little bit differently than other delimited constructs for no good reason (that I know of)" (22:30)
>
> "I know the spec says that multiline is unspecified behavior right now but that we'll warn if we need to cut multi-line access...  But the truth is most of those *will* end up being multi-line. I was hoping < ... > could just adopt the usual behavior instead of going out of its way to foreclose something we'll have to open back up. But it's *technically* compliant so if the grammar is really better and cleaner this way (the descent.udon grammar), I can live with it." (22:45)
>
> "Bottom line, if not here in 0.9.0.alpha.2, very soon afterward, we'd need to make this fix anyway so that the typed-value parser always gets what's after the < until a > or EOF no matter what. So thank you." (22:49)

- The agent: "multi-line is both the cleaner grammar *and* the honest bet (don't foreclose what these constructs will want)."
- CORE: "Interior indentation is captured verbatim for now; a dedent policy, if ever wanted, is a dialect-layer concern. (Retires the earlier single-line rule.)"
- The grammar's `/envelope` counts depth (`<` +1, `>` −1). There is no escape arm, and newlines are content.

*Bears on:* Q2 (settled multi-line, indentation verbatim) and Q1 (depth-counted in code).

**16. 2026-07-19 03:44: `<>` stays a string until dialects exist.** *Sources:* history.jsonl 2026-07-19 03:44 and 03:48; vault `…/raw/claude/70172191-…md:656-686`; CHANGELOG `:292-297` (R13). *Speaker:* agent recommendation, then Joseph.
- The agent laid out the tension: the empty-bracket ruling says `<>` → nil, while the interim pass-through says `"<>"`. It recommended "treat empty→nil as **structural / now** … `NoDialectsLoaded` only makes sense when there's a value a dialect *would* have typed".
- Joseph: "Current behavior is fine for now due to no dialects"
- Four minutes later, on `:a \` (not the box):
  > "I actually think empty string no warning is exactly right here. It is even a valid user-desired behavior … To me:
  > :a nil
  > :a ""
  > :a /
  > are all actual things a user may do-- the first being nil, the second being and empty string, and the final being an empty string."

*Bears on:* Q4. The ruling was temporal ("for now … no dialects"). The second quote is about `\`, not the box, but it shows Joseph treating nil and empty-string as distinct things a user may mean.

**17. 2026-07-19 16:15: an HTML-shaped value in passing.** *Source:* history.jsonl 2026-07-19 16:15. *Speaker:* Joseph.
> "What does:  `|el :v1 <em> :v2 hey / this is child`  give on the wire?"

*Bears on:* only the case itself. The question was about wire ambiguity, but its example makes `<em>` a box. For lite's XML/HTML use case, tag-shaped values in value position are boxes, not text. *Incidental:* everything else (the wire question).

**18. 2026-07-19 to 07-20: the clean-room rewrites and the Grok skeleton converge.** *Sources:*
- `v2/.archived/first-pass/greenfield-2a/new-spec/SPEC.md` §10.4 and `OPEN-QUESTIONS.md:12-13`
- `greenfield-3b/new-spec/CORE.md:537-549` and `dialects/temporal.md:10-22`
- `greenfield-2a/feedback-from-grok.md:139`
- `v2/.archived/second-pass/RULING-SUPPLEMENT.md:310-319` and `ADM.md:172-183`

*Speakers:* several agents (the 2a/2b/3a/3b clean rooms, Grok feedback, the Grok night skeleton).
- All carried the envelope unchanged: depth-counted, multi-line, the ladder, dispatch, and the interim.
- 3b's temporal dialect lists `<14:30>` as an unlabelled Time. That is the colon-in-content case, left unaddressed.
- Grok's feedback: "envelope is recognized bare but is not a "scalar type" in the same sense".
- 2a leaned "Dialect-driven" on nested routing: "the core guarantees only the `<>`-balanced span".
- The second-pass ADM drafted `Envelope := { label: … // TODO: pin Label Ladder … body: String // raw interior; newlines allowed }`.

*Bears on:* Q3 (a label/body split was drafted as a TODO) and Q1.

**19. 2026-07-21: `<` might call a sub-parser.** *Sources:* history.jsonl 2026-07-21 12:01, recorded in `udon-needs/pipeline-discussion.md:522`; replies from Fable (`:546, :560`) and Grok (`:574`). *Speaker:* Joseph, then agents.
> "fully implemented timespec dialect -- we even already have the descent grammar... which also seems to imply that type delimiters '<' could actually invoke a specialized low-level parser in vivo potentially... same with other standard automatically included dialects"
>
> "there would be quite the overlap between !{{interpolation}} and <interpolation> ... maybe the difference is the first is guaranteed to be text-type when done - but it's all still dialect ruled..."
>
> "what is ordering for dialects? or do we just allow for mostly <namespaced/type: val> (inferred if no ambiguity) dialects"

- Fable: in-vivo sub-parsers "break stage linearity: dialect machinery participates in *recognition*". Its suggested first probe: "wire the existing descent timespec grammar in as an in-vivo `<…>` sub-parser experiment".

*Bears on:*
- Reattaching the temporal parser (Joseph's 2026-09-29 words).
- Q1: if a sub-parser runs, who decides where the box ends?
- Q3: another spelling, `<namespaced/type: val>`, with slash and space.

**20. 2026-07-22: 0.9.1 consolidation; the "always available" dialects.** *Sources:* `v2/spec-0.09.01/CORE.md` §11.6 (near-identical to 0.10.0; the ladder is still called "label ladder"); `CARVEOUTS.md` ENV-ROUTE / ENV-EMPTY; history.jsonl 2026-07-22 23:52. *Speaker:* agents (the suite); Joseph.
> "values with no <...> is a very small core subset, very well defined. Then one or two "always available" dialects (for types anyway):  <core:temporal:timespan 3m5d> which can probably be reduced to <temporal:timespan ...> or <timespan ...> as long as there is no ambiguity."

*Bears on:* Q3. Here the label is separated from the body by a **space**, not a colon (`timespan 3m5d`). There is a three-level ladder with `core:` in front, and elision "as long as there is no ambiguity."

**21. 2026-07-28 to 07-29: testimonies, paths, practice.** Sources and speakers:

- **Joseph, practice** (history.jsonl 2026-07-28 21:48): "ones that are due to recent language additions 'Use <2024-02-23> for dates and timestamps (etc. etc.) instead of plain-text'". *Bears on:* the teaching stance for dates.
- **Dialects testimonies** (`udon-needs/01-ideation/02-provenanced/copies/de-novo-testimony/`; unprimed agents, 07-28):
  - Codex (`dialects-testimony-codex-2026-07-28.md:205-240`) wanted the owner stated in the box, `<date@org.example.calendar.iso/1:2025-12-22>`, and said: "A bare unqualified envelope should either remain opaque text or be invalid in strict mode. I would not let the active plugin set decide."
  - Claude (`dialects-testimony-claude-2026-07-28.md:44-50`) proposed "envelope contents remain a small CLOSED sub-grammar at the lexical level (core still constrains characters/shape)", so a tool without the extension can tell "well-formed nonsense" from "garbage".
  - *Bears on:* Q3 (owner in the tag), and a possible lite rule on what a box may contain.
- **Paths terminator table** (`theory/to-integrate/refine-more/paths-ideation/terminator-table.md:17, 157-165`; agent):
  ```
  |el :p <path:||intent[<u64:311>]:status>     ; ✅ whole thing, one value
  |el :p <path:||intent[age>30]>               ; ❌ closes at the > in "age>30"
  ```
  "Repairs available if predicates land: spell the operator without `>` (`gt`), quote the operand, or nest (`<gt:30>`)." It also records that the comparison filter was "wanted ~4× in one scenario day". *Bears on:* Q1, with a second real customer for a bare `>`.
- **Joseph, 07-29 14:57:** a block-mode array sketch with a box as an item on its own line:
  ```
  :some-attribute [
     <123>
     |another-child
       and some text in the heterogenous array's element
     and some text in the array itself
  ]
  ```
  *Bears on:* Q5 and interaction 05.

**22. 2026-07-30: dialects ideation and format-failure research.** Sources: `theory/to-integrate/refine-more/dialects-ideation/README.md:10-60, 113-150, 255-266, 273-278`; `theory/to-integrate/primary/format-failures/MINEFIELD-MAP.md:452, 525-528`; `ADJUDICATED-CLAIMS.md:286`; `primary/DISCUSSION-THOUGHTS.udon:828`. Speakers: agents.

- **The falsifier (dialects-ideation).** "find a legitimate dialect body that `<>`-balanced-span capture mis-captures. One candidate is already in hand — the `!` baseline's expression grammar uses `<` and `>` as comparison operators, so a predicate body like `<q: a > b>` mis-captures under depth-counting."
- **Who owns capture.** Three branches: A, capture stays core-owned; B, dialects may own capture; C, "core owns *shape*, dialect owns *meaning*".
- **Two gaps.** "the label ladder `<dialect:type:content>` has no version slot". And "Same bytes: `NoDialectsLoaded` **Warning** unbound, **Error** when bound and all decline … What a *labelled* decline yields is stated nowhere."
- **EDN as prior art (MINEFIELD-MAP).** EDN's unknown-tag branches are "error, call a handler, or keep a *generic tag+value representation*". The third branch "matches UDON's keep-everything posture". Also: "**freeze the envelope's print grammar independently of any host's pretty-printer**". ADJUDICATED-CLAIMS adds "put tag version in tag name or payload".
- **Near-miss warnings.** MINEFIELD-MAP recalls TIME-SPEC's near-miss warnings as a precedent this project has already used.
- **A lapse (DISCUSSION-THOUGHTS:828).** An agent that had read the whole 0.9.1 suite "still emitted non-canonical constructs (envelope-as-body, phase violations)".

*Bears on:* Q1 (the falsifier), Q3 (tag+value representation and versioning), Q5 (envelope-as-body as a real authoring lapse), and the warning.

**23. 2026-08-06 to 08-07: `@<…>`, and a closer that allows `>` inside.** *Sources:* history.jsonl 2026-08-06 23:06, 23:39; 2026-08-07 10:58; `v2/references/.archive/second-theory-iteration-2026-08-08/hypothetical-sketch.md:17-21, 198-200`. *Speaker:* Joseph; sketch by agent.
> "the @<...> indicates this is a specific *typed* value (that is equivalent to a path or a query or a designator." (08-06 23:06)
>
> "if we treat @<...> as a type - like <2026> is a date type and like <"A string"> is a string type (although we usually don't give it the <..> and might not allow them...)" (08-06 23:39)
>
> "5. I would be perfectly happy with @<{   }> to solve the inner <  > issue and to also make nesting generally more reliable." (08-07 10:58)

- The sketch: "**Inherited cost**: an unbalanced `>` in the interior closes early". Then: "`@<{ … }>` with `}>` as closer **removes the one measured envelope cost**: unbalanced `>` (comparison predicates — `age > 30`) is now free inside."

*Bears on:* Q1. Joseph's own answer to the `>`-in-content problem was a **different closer** (`}>`), not an escape and not a first-`>` rule. There is also a reserve-contract angle (see the last section): `<{`, `@<` and `<"…">` all appear here as future value forms.

**24. 2026-08-07 to 08-09: every value slot takes a box.** *Sources:* history.jsonl 2026-08-07 21:27; 2026-08-08 12:47, 13:03, 13:31, 13:56, 23:06; `v2/DECISIONS.md` K1, K2 (`:163-165`), K7 (`:170`), K9 (`:178`), K16 (`:171`); `theory/to-integrate/primary/sameline-value-space-2026-08-08.md:74, 99`. *Speaker:* Joseph; rows by agent.
> "My vote-- tell me if this is internally coherent--  exactly like an attribute value:  [one two] -> "one two",  [[one two]] -> ["one", "two"],  [<2026>] -> <2026>." (08-07)
>
> "we *are* going to allow multiple key designators for a single record:   `|x[#x-the-letter][<uuid7:38493284298...>]`" (08-07)
>
> "```
> |element <1234>   ; no problem, it's an attribute's value
>   now we're in the body
>   <9292> <- this one was the one that is prose but that looked like a value and was difficult to understand...
> ```" (08-08 13:31)
>
> "it makes sense that we're saying  "sameline text is a scalar--- if you are just starting the body of text, do it next-line indented, especially if you want to start it with quotes or angled-brackets etc."   -- that sounds perfectly reasonable" (08-08 13:56)
>
> "NOW, we can do what is much more natural:
> ```
> |element :something something else
>   :another one  :and-another <please>
> ```" (08-08 23:06)

- K7: "Value position is a position, not a mode — deferred attributes' first body line carries it … Only the first line is ever value-special".
- K16: "Wherever a value is expected, the full value grammar applies" (sameline `$main`, attribute slots, list items, deferred-body first line, key interiors).

*Bears on:* Q5 directly. This is the full list of value positions, which includes the **deferred-body first line**. It also records Joseph's own worry that `<9292>` in a body "looked like a value and was difficult to understand".
*Incidental:* `|x[#x-the-letter]`'s `#`, `$main` stacking and late attributes are other questions.

**25. 2026-08-09: `<…>` as the native "value form".** *Sources:* `v2/theory/to-integrate/lexical-forms-discussion-2026-08.md:26-32, 64`; `lexical-forms-matrix-2026-08-11.md:18, 26`. *Speaker:* coordinator agent, "concurred-in-session as thinking material".
> "The two constructs with native value spellings — list `[…]` and envelope `<…>` — are exactly the two needing zero position machinery. Strongest structural argument for the `@<{ }>` instinct: `<…>` is where the language already mints value-ness. If three-forms ripens, the natural generator: bare sigil = geometric · `{…}`-composed = embedded · `<…>`-composed = value."

*Bears on:* the reserve contract. `<` followed by a sigil (`<{`, `|<{`, `@<{`) was floated as a family of future value forms.

**26. 2026-08-09 to 08-11: 0.10.0 §11.6 and the "envelope ladder" rename.** *Sources:* `v2/spec-0.10.00/CORE.md:679-696` (the neutral file's source); `CARVEOUTS.md:31-43`; `msc/for-joseph/UNIF-PASS-QUESTIONS.md:69-77`; `01-PLAIN-DECISIONS.md:69-72` (D8, still open). *Speaker:* agents.
- The text is unchanged from 0.9.1, apart from the rename note "*(Rename from "label ladder" provisional — UNIF-PASS-QUESTIONS Q7.)*". The rename was needed because "label" had come to mean attribute name.
- ENV-ROUTE: "The in-vivo possibility that `<` dispatches a specialized sub-parser … breaks stage-linearity assumptions — that is signal, not a problem to define away."

*Bears on:* Q3. The name of the ladder's parts is itself an open question.

**27. 2026-08-27: 0.10.1-draft merges boxes into "captures".** *Sources:* `v2/spec-0.10.01/CORE.md:311-321, 332`; `DELTAS.md` rows 3, 7, 14; `theory/to-integrate/unification-matrix-2026-08-27.md:20-21`; history.jsonl 2026-08-27 14:25. *Speaker:* agent (Fable), under "theory leads"; Joseph on `@<…>`.
- The value capture: "`<body>` · `<kind: body>` · `<vocab:kind: body>` | `<>`-depth-counted to the matching `>`; multi-line". Note the **space after the colon**, and "dialect" renamed "vocab".
- A new **block capture**: "`<kind:` at Structure Position, body deeper". Unlabelled dispatch was recast as resolution.
- Joseph: "@<...> (spelling aside) being something that distinguishes holding a reference *as the value* (i.e., the type of the value is "reference") -- vs @anything-else actually meaning the referent(s)".

*Bears on:* Q3 (space separator) and the reserve contract (`<kind:` at line start as a possible future form). Joseph called the whole draft a misfire on Sep 1 (entry 28).

**28. 2026-09-01: the audit, the "misfire", and the "box" text.** *Sources:* `v2/spec-0.10.01/working-notes/AUDIT-2026-09-01.md` A1, D1–D3, D16; `v2/JOSEPH-FOR-0.10.01-FIX.md:36-51` (committed `9f69f42`, 09-21); Joseph's words as quoted in `WHERE-THINGS-STAND-2026-09-27.md`. *Speakers:* agent (Fable audit); Joseph; agent (the FIX text, saved by Joseph).
- **A1:** "a code body that must now go through `<py: …>` closes at the first `>` in the code (`if a > b:`), and `<` `>` inside the body are depth-counted — the body of a comparison-heavy program is un-writable except via fence."
- **D1:** "`<http://x>` — kind `http`, body `//x`? The value form's kind charset is unstated …; `<2026-01-01T10:00:00>` is safe only if kind must be an identifier. Is the one-space-after-`:` separator rule of 0.10.0's inline verbatim (§10.2) now family-wide (`<u64: 5>` body `5` or ` 5`)?"
- **D2:** "`<temporal:interval:` at Structure Position — vocab+kind, or kind `temporal` with tail `interval:`?"
- **D16:** "`@<a<b>>` / `@{a{b}}` — "raw balanced head": balanced in which delimiter".
- Joseph (as quoted in WHERE-THINGS-STAND): "Ugh, so much jargon and changed terms for such a simple thing, and the one thing that's not obvious is the thing that's broken." and "I'm going to call 0.10.01 a misfire."
- The FIX text (the agent's, saved by Joseph) is where the word **box** comes from: "**3. The six bare types, and the box for everything else**". Its tree:
  ```
  when <2026-07-11>          size <u64: "0xff">
  ```
  It says: "`<…>` is carried as its text plus its tag; whoever loads a dialect decides what it means. Nobody warns that nobody has yet."

*Bears on:* Q3 (a split tag/body tree was already drawn, and the label charset question was asked outright) and the warning (the FIX drops it). Joseph later said the FIX "seemed less and less principled as he questioned it" (WHERE-THINGS-STAND), so its details carry the agent's authority only.

**29. 2026-09-29: lite.** *Source:* history.jsonl 2026-09-29 17:55 and 18:02. *Speaker:* Joseph.
> "what if any special <..> should be part of lite (we removed time-related things like dates, times, timespans, etc. from value parsing deliberately with the idea that it would be the first <...> types (with spelling for namespace or type undecided).... etc." (17:55)
>
> "w/ dates-- let's go with 2 for now. When we get to implementation we might go ahead and reattach the temporal parser already built." (18:02)

*Bears on:* everything. Note "with spelling for namespace or type undecided". Joseph himself describes the ladder spelling as open.

**30. 2026-09-29: probe of the mainline 0.9 parser.** *Source:* my own run of `core/target/debug/examples/stdin_parse` (built from HEAD `9f69f42`). This is evidence of what was built, not intent. Byte arrays are decoded below.

- `|el :x <a <b> c> :y 1` → `BareValue "<a <b> c>"`, then `NoDialectsLoaded`, then `y = 1`. The count is by depth.
- `|el :cond <x > 3> :y 1` → `BareValue "<x >"`, `NoDialectsLoaded`, then `Text "3> :y 1\n"`. The text after the early close became element text; `:y` was lost as an attribute.
- The runaway case:
  ```
  |rule :op <= :limit 5
  |p Then a -> b happens.
  |q done
  ```
  gives `op = BareValue "<= :limit 5\n|p Then a ->"`, then `Text "b happens."` under `|rule`. The whole `|p` element and the `:limit` attribute were swallowed. The box closed at the `>` of `->` in the next line's prose.
- `|el :e < >` gives `BareValue "< >"`, and `|el :e <>` gives `BareValue "<>"`. Both warn `NoDialectsLoaded`, per ruling 16. The carried value **includes** the `<` and `>` brackets.

*Bears on:* Q1, Q2 and Q4. The runaway case is what "multi-line, depth-counted, no fail-safe" does to a stray `<` in value position when the document has `>` in prose, as an HTML-ish document will.

---

## Threads worth noticing

*These are my reading of the history, marked as mine. They are not the record.*

1. **The rule for where the box ends changed once, for one reason, and its cost kept being rediscovered.**
   - The box was born with a first-`>` rule (S-ET brief and CORE, 07-11/13). It switched to depth-counting on 07-14, only to make nested composite numerics possible, while routing of the nested parts was explicitly left to dialects.
   - The cost was then found independently four times, each time from a different place:
     - `:op <=` (S-ET, 07-11)
     - `age>30` in paths (07-28)
     - `<q: a > b>` in dialects (07-30)
     - `if a > b:` in code (09-01 audit)
   - Neither depth-counting nor first-`>` helps any of them. `<x > 3>` ends at the same place either way.
   - The only answer Joseph gave to that cost was a different closer, `}>` in `@<{ … }>` (08-07). The only answer in the ledgers is quoting, and no escape was ever specified.
   - If lite never nests (no dialects yet), depth-counting in lite serves one purpose: keeping nested boxes *intact as text* for a later dialect. That still matters for the reserve contract.

2. **Multi-line was settled by grammar hygiene and future-proofing. The accident it enables was never weighed against it in the record.**
   - In one week the box went: single-line (07-16, delegated), then "multi-line-undefined" (07-18 noon), then multi-line (07-18 evening).
   - Joseph's reason: "the typed-value parser always gets what's after the < until a > or EOF no matter what".
   - The same corpus gave identity brackets a fail-safe *because* "an editing accident (`|el[k`) must not swallow the document". The Sep-1 audit (A2) pointed out that the same logic applies to anything that spans lines.
   - Nowhere I found was the stray-`<` case (entry 30) discussed for boxes. In a lite whose headline use case is XML/HTML-like documents, prose `>`s are common, so a runaway box does not run to EOF (where it would at least warn). It closes silently at some later `>` in prose.

3. **The ladder spelling has never been decided, and the record holds at least seven spellings.** Joseph himself calls it "undecided" (09-29). The spellings:
   - `<u64i|0xf902>` (Joseph 07-11)
   - `<type:body>` (S-ET and CORE)
   - `<type: body>` with a space (Joseph 07-14/15, `<r: <i: 3 -7> …>`, `<u64: 0x94f>`; also 0.10.1)
   - `<type body>` (Joseph 07-22, `<timespan 3m5d>`)
   - `<namespaced/type: val>` (Joseph 07-21)
   - `<core:temporal:timespan …>` (three levels)
   - `<date@org…/1:…>` (Codex testimony)

   Joseph's own examples mostly have a **space** after the label colon. The identifier-led rule (S-ET) was the only label/body rule ever written down, and it assumed no space. The FIX's split tree (`size <u64: "0xff">`) is an agent's drawing that Joseph later distrusted. The two forks the ratification left open (dialect-first; parallel aliases) are still open.

4. **"Untyped" carries two opposite stances on the warning.**
   - From 07-15 to 08-11 the interim emitted a warning on every box ("no loaded dialects yet"). The design promised that "when dialects land the same document retypes identically, minus the warning".
   - The Sep-1 FIX text drops the warning ("Nobody warns that nobody has yet").
   - Dialects-ideation noticed that severity depends on binding state: the same bytes are a Warning when unbound and an Error when every bound dialect declines.
   - Lite's "reserve, don't ignore" contract makes this a live question: is the box itself the stable tree, with typing always a later layer? Or is a box a promise that a future version will turn it into something else?

5. **Empty boxes: Joseph's instinct and his ruling point in different directions, and the ruling was explicitly temporary.**
   - 07-18 13:15: "<>, < >, <   \n\t  >, etc." → nil, "for the current behavior".
   - 07-19 03:44: keep `"<>"` "for now due to no dialects".
   - The agent in between argued that emptiness is visible without any dialect.
   - Lite has no dialects by definition, so "for now" may be exactly lite's permanent condition.

6. **The set of box positions only ever grew.**
   - It started as attribute values only (07-11: "only collapsing the space of attribute value plain-text").
   - Then array items (07-15), then identity keys, the sameline `$main` and the deferred first line (08-07/09).
   - Joseph pushed back twice on boxes in *body* position: on typed children, "Useful? Hmmm... not particularly" (07-15); and "<9292> … looked like a value and was difficult to understand" (08-08).
   - An agent that had read the whole spec still wrote a box as body text (07-30). The line between body (prose, `<` literal) and value position (box) is where readers and writers actually slip.

7. **The recognition/typing split (07-11) is the thread lite is standing on.** The value-dialects brief's split, S-ET's unknown-label default of "pass-through", the EDN "generic tag+value" branch, Branch C's "core owns shape, dialect owns meaning", and Codex's "remain opaque text" all point the same way: the core finds the extent, and someone else supplies the meaning. Where they differ is whether the core also parses the **tag** (Q3-B) or constrains the **interior's shape** (Claude's testimony). None of these sources decided that, and lite's untyped box is the first place it has to be decided.

---

## What the neutral file misses

*Alternatives, framings or cases the history holds that `07-untyped-angle-box.md` doesn't. These are not recommendations.*

**Q1 (where the box ends)**
- **Other closers and escapes.** Joseph proposed a brace-inner form with `}>` as the closer, `<{ … }>` (as `@<{ … }>`, 08-07), specifically "to solve the inner < > issue". S-ET mentioned "first **unescaped** `>`" and "let the dialect define an escape". Quoting the whole value (`:op "<="`) is the only workaround on the ledgers. The neutral file lists only A (depth-counted) and B (first `>`), and correctly notes that both fail on `<x > 3>`. The history's candidate answers to that failure are an alternative closer, an escape, or quoting.
- **The runaway case under A plus multi-line.** A stray `<` in value position (`:op <=`, `:cmp <`) swallows following lines up to the next `>` anywhere, including prose (entry 30). A fail-safe (close at EOL unless …), as identity brackets have, is the precedent the corpus uses for accident containment (0.10.0 CARVEOUTS; audit A2).
- **What text follows an early close.** In the mainline parser, the remainder becomes element **text** and swallows later `:attrs` on the line (`Text "3> :y 1"`). The neutral file's "` 3>` follows as text on the line" understates this: `:y 1` stops being an attribute.

**Q2 (multiple lines)**
- **Indentation already has an answer on record.** "Interior indentation is captured verbatim for now; a dedent policy, if ever wanted, is a dialect-layer concern" (CORE:1680; fixture `envelope_spans_newline`). The neutral file's "(or with the indentation stripped?)" is open there but settled in the record.
- **Accident containment for multi-line.** See Q1 and thread 2.

**Q3 (what the tree carries)**
- **Whether the raw text includes the brackets.** Mainline carries the full lexeme `"<5m>"`. Option A in the neutral file shows `box "u64:0xff"` without them. That is a real choice, and it matters for round-trip fidelity.
- **Spellings the label rules don't cover.** These appear in Joseph's own examples:
  - a space after the colon, `<u64: 0x94f>` and `<r: <i: 3 -7> 0d83.23>`. The neutral file's candidate rule "followed by `:` and no space" would reject these.
  - a space instead of a colon, `<timespan 3m5d>`
  - a slash namespace, `<namespaced/type: val>`
  - a pipe, `<u64i|0xf902>`
  - an owner and version in the tag, `<date@org…/1:…>`

  0.10.0's sister construct `!{:kind: body}` has an explicit rule: "a single space after the kind's closing `:` is a separator, not body". Audit D1 asked whether that rule should cover the whole family.
- **S-ET's exact rule and its test case.** "Label segments are … identifier-led; label parsing stops at the first segment that isn't identifier-led", with `<time:14:30:00>`.
- **One colon: type or dialect?** S-ET's Fork 1 (one colon is always a type, or a flat namespace) and "parallel aliases" were never ruled.
- **No version slot.** "the label ladder … has no version slot" (dialects-ideation). ADJUDICATED-CLAIMS says "put tag version in tag name or payload".
- **Unknown labels.** S-ET's menu was `error | pass-through | warn`, default pass-through.
- **The FIX tree.** It already drew a split, `size <u64: "0xff">`, as "text plus its tag". It is an agent's text that Joseph later questioned.

**Q4 (empty box)**
- **Joseph's two statements and the dropped part.** Joseph's 07-18 statement covers **multi-line** whitespace (`<   \n\t  >` → nil). The ledger recorded only the single-line part, and the 07-19 ruling kept `"<>"` "for now due to no dialects".
- **What "empty" means in lite.** The neutral file's options (empty string, nil, error) are missing a fourth: the recorded current behavior, where the raw lexeme `"<>"` (or `"< >"`) is carried like any other box. Whether "empty" means "the raw text is empty" or "the box has no content" depends on the Q3 choice about including brackets.

**Q5 (where a box may appear)**
- **The deferred-body first line** (K7), e.g. `:when` ⏎ `  <2026-07-11>`. It is missing from the neutral file's list (attribute values, `$main`, list items, `[key]` interiors).
- **Body position, as history saw it.** Joseph's worry about `<9292>` in a body, his "not particularly" on typed children, and the agent's envelope-as-body lapse. These make body position a least-surprise case worth a worked example.
- **Tag-shaped values in value position.** `:tag <em>` (Joseph's own 07-19 example) or `:x <br>` are boxes. For the XML/HTML use case that may surprise an author, while `|p a <b> c` stays text (fixture `angle_in_prose_not_special`).
- **Line-initial `<kind:` at a structure position** (0.10.1's proposed block capture). Lite would read it as prose. If anything like it returns, that prose would change meaning. Interaction 09 (reserved syntax) may want it.

**Not raised in the neutral file at all**
- **The warning.** Should every lite box carry an anomaly (the historical `NoDialectsLoaded`, 07-15) or not (the FIX, 09-01)? And should near-miss content warn, as TIME-SPEC's near-miss warnings did?
- **"Same tree" under the reserve contract.** Lite's contract says an accepted document "produces the same tree under every future full version". The box design since 07-11 promises that a later dialect *types* box contents ("retypes identically, minus the warning"). Whether that counts as the same tree has to be said. The history's own framing is the recognition/typing split: the box is the recognition-layer node, and typing is a later layer.
- **Future `<`-prefixed forms** that lite would accept today as ordinary boxes: `<{ … }>` (entries 23, 25), `<"A string">` (Joseph 08-06: "might not allow them"), and `<ref: …>` (0.10.1 `DELTAS.md` row 5: "Alternative: `<ref: head>`"). If any of these later gets its own meaning, a lite document containing it changes meaning. Interaction 09 may want to reserve `<{`, and possibly `<"`.
- **Box interior shape.** Claude's testimony proposed the core constraining characters and shape so that "well-formed nonsense" is distinguishable from "garbage". Branch C, "core owns shape", is the same idea. The neutral file has no option in which lite constrains what a box may contain (for example control characters, or a balanced-only interior).
- **Typing by declaration.** The "third non-sniffing way to type a date" from 07-11: a bare `:created 2026-07-07` plus a schema declaration. It means dates don't *have* to be boxes for later typing. This bears on what lite's documentation tells authors to write for dates.
