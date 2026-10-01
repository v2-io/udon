# Joseph's words bearing on lite's decisions, verbatim

*A kept copy of Joseph's typed words (and, where a decision rests on them, the agent text he was answering), so that decision records in `adr/` can quote a file in this corpus rather than a session transcript under `~/.claude/projects/`. Chronological. Nothing here is an interpretation: each entry is copied exactly, typos included, with its timestamp (UTC) and source. Agent text is labeled as such. Collected by the udon-team agent (Opus 5.5), 2026-09-30 Mountain time.*

*Sources:*
- *`5930da5d` = `~/.claude/projects/-Users-josephwecker-v2-src-arch-firmatum-udon/5930da5d-2aed-49ea-ac8b-ed619c1d6a0d.jsonl` (the 2026-09-29 evening session that started lite).*
- *`fdcff70f` = the udon-team session of 2026-09-30 evening (`…/fdcff70f-22de-418e-9f25-42ac5adc94ae.jsonl`).*

## 2026-09-29 evening (Mountain), session `5930da5d`

### 2026-09-29T23:55:23Z — Joseph

> OK-- I'm back-- decided to proceed by continuing with you if that's ok :-)  You're at 61% context usage but the 49 remaining should be more than sufficient for this and the context you have is just right anyway. If you are interested and willing (you may genuinely decline or recommend I use a fresh agent etc.) -- I would like you to attempt a spec-lite-0.1.0/ which would specifically *disallow* any grammar that is going to be used in the future (!,@,etc.)-- the basic subset. It seems to me there are still some (*possibly*) still open things to look into, like better markdown-like tables, or making sure that sameline capture works, or what if any special <..> should be part of lite (we removed time-related things like dates, times, timespans, etc. from value parsing deliberately with the idea that it would be the first <...> types (with spelling for namespace or type undecided).... etc.  Thoughts?

### 2026-09-29T23:56:21Z — the agent's reply (agent text, excerpts; "…" marks where text is left out)

> **"Disallow" should mean *reserve*, not *ignore*.** If a lite parser treated `@author` or `!if` as ordinary text, a document that's valid lite today would quietly mean something different once full UDON arrives. That's the same silent-retyping problem the frozen bare types exist to prevent.
>
> So the contract I'd write is: **any document a lite parser accepts produces exactly the same tree under every future full version.** To get that, a lite parser recognizes the future syntax just well enough to refuse it. It keeps the bytes and reports "reserved: not in lite." That also gives your tiny parsers their "aware of what it can't do" behavior for free.

> **Undecided, and I'd like your call on each:**
> - **`<…>`** (below).
> - **`|{…}` inline elements inside prose.** They're plain structure, not future syntax, but they add a lot of parser work. My lean is to include them.
> - **Suffixes (`|el?`).** My lean is to leave them out of lite, since you'd left retiring them open.

> ## `<…>` and dates
>
> I see three options:
> 1. **Reserve `<` entirely.** Simplest, but lite gets no dates.
> 2. **Carry `<…>` as an untyped box:** lite parses where it ends and hands over the raw text, with no meaning attached. This is forward-safe, because `<…>` always meant "someone else decides what this is."
> 3. **Option 2, plus a short fixed list of recognized contents in unlabelled boxes:** ISO dates, times, datetimes and durations, such as `<2026-07-11>` or `<PT5M>`.
>
> My lean is option 2 for the core, with option 3 as an optional extra lite parsers may offer. Option 3 needs no decision about how namespaces or type names are spelled, because it only covers boxes with no label. Anything labelled, like `<temporal:…>`, stays an untyped box.

> **In** (all stable across 0.9.1, 0.10.0 and the Sep-1 proposal):
> - `|elements`, nested by indentation, including same-line chains (`|a |b`)
> - `[key]`, `.trait`, and loose same-line text becoming `$main`
> - `:label value` attributes, with repeats stacking
> - Text blocks
> - `;` comments
> - `\` escapes
> - The plain values: strings, numbers, `true`/`false`/`nil`, one-line lists
> - ```` ``` ```` fences for code (these use no reserved character)
>
> **Reserved** (refused, bytes kept):
> - `!` in all its forms. That includes `!:kind:` code blocks, which leaves fences as lite's only code form.
> - `@` references, both `@name` and `@{…}`
> - `!{{…}}` interpolation

> ## Tables
>
> In current UDON, `| ` (pipe followed by a space) is literal text, so Markdown tables already pass through untouched as prose. A *structured* table is new design, not a subset of anything, so I'd keep it out of lite 0.1.0 and look at it as a separate question. Unless you meant something narrower?

### 2026-09-30T00:02:26Z — Joseph

> 100% agreed on reserve, not ignore. That's definitely what I meant by deliberately disallowing it. In the corpus right now we have a ton of need for this lite parser and tooling-- and I absolutely don't want them accidentally putting in essentially reserved syntax that would change the documents' behavior later unexpectedly.
>
> |{...} inline elements are critical for one of the most obvious use-cases-- xml/html
>
> suffixes I wanted to retire their *special status* -- I am *pretty sure* (we'll need to look into it) that the intent was to make it just another allowed identity character.
>
> w/ dates-- let's go with 2 for now. When we get to implementation we might go ahead and reattach the temporal parser already built.
>
> I'm ok leaving that decision for tables for now. What about `|---|---....` ?
>
> Create a directory for this, then, on each of the open questions

### 2026-09-30T00:18:03Z — Joseph (the same message resent and extended; the added parts, "…" marking text left out)

> This "lite" is very, very similar to the actual mainline udon that we are replacing here in v2-- and which already has a lightning fast recursive descent declarative grammar definition-- there have been a handful of agents that have built tiny bespoke python parsers that got thrown away because they couldn't reliably follow the changes and the nuance very easily compared to the descent grammar. So I'm really not worried about "Making sure same-line capture works" (not sure what you're quoting there).

> … Ideas and comments and decisions by me need to be in those files but they don't necessarily have special status over ideas and discussion and pushback from any agents (other than if I don't see them but vaguely recall having discussions about that aspect I will definitely lose confidence). …

> I reserve the right to change my mind about anything and everything in the past :-)  I will be very persuaded by things that simplify the grammar or rules without violating the principle of least surprise. There used to be a lot of discussion about wire vs ast -- because the core parser is streaming/event of course. Lite can be specified as AST-centric for simplicity. We can also settle (unless someone feels we need to adjudicate it still) on the document being parsed has an implied root node -- so everything starts as children of that node, which might also have metadata like filename etc...

### 2026-09-30T00:50:22Z — the agent, relaying a history result (agent text, excerpt)

> - The "no implicit root" position came in Jan–Jul 2026 from other writers. Its reasons (streaming, fragments, host APIs, duplicate-key scope) were never answered on the record.
> - … Your own words were "Mark root level :x as undefined" (Jul 18). On Aug 7 you said "a pseudo root element solves the open 'what to do with attributes at top-level' question."

### 2026-09-30T01:01:23Z — Joseph

> Excellent progress. Thank you for launching the sonnets. I recognize, by the way, that there has been a lot of churn and equivocation on the syntax-- that's what led to v2 and so forth and, for the record, after trying out lots of stuff, the decisions *have* gotten more principled and useful (e.g., doc root). One reason I gave that "older isn't priveleged over newer, provenance isn't priveleged" note was because I've found that otherwise the agents will get too caught up on trying to decide what I said when, which is really irrelevant as far as authority or prominence-- we just need to know what has been tried, what the reasoning was, why it did or didn't end up working etc. And with a lot of these I'll be able to fill in the blank of why I did or didn't decide something etc.  I suspect we'll want to do some serious grouping of the general search aspects.

### 2026-09-30T02:04:15Z — Joseph

> Ahhhh, right. Let's decide right now to adopt (and extend if we need to) what little we have in v2/references/def/** -- which should be our core terminology for identity, referents, etc.

### 2026-09-30T02:07:45Z — Joseph

> what about 'typed-value' instead of box?

### 2026-09-30T02:08:00Z — the agent (agent text, excerpt)

> Two options:
>
> - **"Explicit typed value"**: your own scratch-list wording. It's clear, just long.
> - **"Typed literal"**: an established term with an exact precedent. … That's precisely lite's `<…>` behavior: carry the text and the optional type label, attach no meaning. …
>
> My recommendation is "typed literal." … If you prefer "typed value," I'd make it "explicit typed value" to avoid the collision.

### 2026-09-30T02:12:55Z — Joseph

> OK-- let's not necessarily add to addressing theory's def/ directory-- but let's start a spec-lite-0.1.0/lexicon.md and get our definitions nailed down nicely. So, from addressing theory first-- I think you meant 'designator' instead of name for what we've been calling key -- correct me if I'm wrong. and add entries (just one line for each of these right now please) for "(implicit/explicit) typed value", along with the ones that are somewhat ubiquitous already-- node, attribute, etc. -- Let's put reserved ones in their own file and not explain them other than what characters or constructions are reserved.

### 2026-09-30T02:13:19Z — the agent (agent text, excerpt)

> You're right to check, but under def/ as written, the key is the **name**, not the designator: …
> K1 did call keys "key designators," but that followed the second addressing-theory edition, where designator was the name side. The third edition moved it. So the lexicon says the key is a name, and the reference that uses it is a designator.

### 2026-09-30T02:14:02Z — Joseph

> Remove from lexicon entries that are not applicable to lite- like dangle

### 2026-09-30T02:14:18Z — the agent (agent text, excerpt)

> I've removed the five entries that don't apply to lite: dangle, reference, referent, designator and generator. The last four are reserved syntax, so they only show up in `reserved.md`. …
> What's left from the addressing theory: name, binding, mint, maintainer, collide, scope, containment, root-scope and location.

### 2026-09-30T02:17:03Z — Joseph

> I may have been rash emphasizing addressing theory terms, as lite is very specifically and conspicuously missing addressing. But with the possible exception of containment we will still want the rest. (are you *sure* root-scope is the same as the root node?)

### 2026-09-30T02:19:08Z — Joseph

> hmmmmm..... I'm not sure if **scope** is defined correctly-- it hasn't been decided I don't believe. I've added ID scoping to my short-list.

### 2026-09-30T02:21:07Z — Joseph

> I fixed "value" which is an ambiguous term we're not using -> typed value like I suggested, to emphasize and clarify it vs the general term, since all values have types in udon.

### 2026-09-30T02:21:57Z — Joseph

> When we are referring to lexicon-defined terms, let's put them in backticks-- so that `typed value` is clearly a term and not just gloss.

### 2026-09-30T02:26:26Z — Joseph

> I'm sorry, but this is really sloppy. same_line, same-line, and sameline all in the same document, and nothing about element-sameline vs attribute-sameline, and lots of cruft and not even in order etc... let's delete it and wait for a more fresh agent who is willing to do it a bit more carefully.

## 2026-09-30 evening (Mountain), session `fdcff70f`

### 2026-09-30T16:47:07Z — Joseph (excerpts from one message)

> FYI there was an attempt at a lexicon but it was... well, it was lazy and sloppy so I had the agent delete it so it could get done with a little more thoughtfulness and rigor.


> I think that instead of getting bogged down in the "undecided issues" -- that we visit them as they come up logically as the spec is actually assembled.

### 2026-10-01T02:34:28Z — Joseph (one message, three parts; it answers whether lite should adopt the split proposed in `sop/influx/proposed-decision-authority.md`, whether converting the seeded decisions is the first work, and the plan for the outline and purpose layer)

> I will support (officially) your decision on decision authority :-)  Please note with the decisioin that it (and any other decision) is not set in stone, that's part of why this process exists, so that we can see what assumptions went into some decision and know when it's appropriate to revisit for the sake of the real goals instead of momentum/inertia and appeals-to-authority.

> 2. That's your first set of work, yes. Feel free to delegate as you go and check on results.

> 3. Perfect. I'm mostly interested initially in your skeleton/outline for the spec and then primary objectives, principles, requirements, and critical-to-quality (all of the obj/ stuff-- or at least a bunch of them. You may want to launch an agent to look for underlying principles that you can consider throughout udon/v2, udon/ and even estate-wide via memorata-search -- although a lot of the good stuff will be in arch/firmatum/principles (they are a little more concrete and implementation-centric than the higher level UX/AX principles that udon cares about) and udon/v2/udon-needs/** etc.   I wouldn't expect it to be more than a handful -- feel free to create an obj.future/ or something to accumulate things that we might care about more in a non-lite or later lite version of udon etc.

### 2026-10-01T02:42:08Z — the agent's question (agent text, excerpt)

> **Three quick calls for you:**
> 1. Three of the records are you agreeing to an agent's proposal, and nobody asked at the time which kind of agreement it was:
>    - reserve, not ignore ("100% agreed… That's definitely what I meant");
>    - inline elements are in;
>    - `<…>` option 2.
>
>    They're recorded as `supported` for now. Should any of them be `ratified`, meaning you thought it through and want to hear if someone disagrees?

### 2026-10-01T02:45:43Z — Joseph

> reserve- not ignore: it was a restatement of my very original explanation for what lite needed to be- so it was essentially the first thing decided by me that was communicated to an agent.
> inline elements are in: yes-- reasoning / principle / objective ---   being able to represent xml/html is a critical objective.
> not sure what "option 2" is referring to.

### 2026-10-01, about 03:00Z — Joseph (sent mid-turn)

> My understanding of "sustained" vs "ratified" -- sustained means I fully endorse and "decide" based on someone else's proposed "lean" (for lack of a better word at the moment), whereas ratify means I endorse an already decided item after the fact. Are my definitions wrong?  When an agent asked if inline elements were part of my vision for udon-light-- and I answered "yes-- that is because of html/xml" (to that agent a while ago, not you), I would expect that to be proposed by "us" and sustained or decided by steward with agent support-- however that ended up being shown. If an agent or council decided it on their own in order to move the project forward, and then asked me about it later and I fully approve/decide with them-- that would be ratified. No?

## Elsewhere

### 2026-08-07T17:29Z — Joseph (`~/.claude/history.jsonl`, project udon; excerpt)

> … having all udon documents with a pseudo root element solves the open "what to do with attributes at top-level" question in the spec, as well as "what's the difference between an udon doc meant to be a partial vs whole-record vs store of records..." etc. (just depends on what you decide to do with that root element).

### 2026-09-30T16:02:55Z — Joseph (`~/.claude/history.jsonl`, project aat-refactored; excerpt)

> Essentially over in udon right now we are working on v2/spec-lite-0.1.0/ -- a new spec for "core" udon -- the non-dynamic subset that excludes all generators and references (! and @ constructs, among other things). It will *reserve* those other constructs so that the parser errors so that it is not used on documents whose behaviors or parsing result changes when run through a more full udon parser in the future.

### 2026-08-30 — Joseph (`v2/INBOX-REQUESTS.md`, committed 2026-09-21; excerpt)

> Basically, with 0.10.01, a set of tiny, dependency free "simplified udon" parsers written in the host languages: … It would need to warn when there are constructs (like references or directives or unknown data types etc.) that it encounters that it won't parse.
>
> The actual subset that they all (or each independently) will "parse" is up for debate, as long as the result is small enough that it's convenient to just pop in place for simple udon usage for now, dependency free, (e.g., for udon used as a simple predictable data layout / xml equivalent / yaml-or-json alternative), and aware of what it (or each one) can't do.

### 2026-10-01, about 03:15Z — Joseph (sent mid-turn; answering what "option 2" was, `lite-lexicon-form`, and committing)

> Correct, I decided option 2 for now, but specifically decided we would stay open to doing a quick subset of core types potentially, depending on need (I kind of suspect that will be a 0.1.1 feature or something).
> - yes, the guillamets were my decision for defined terms, and lexicon being generated by a script that looks at the definitions in the def/** files was my lean but I am happy to be persuaded otherwise by you if you like.
> - Commit as you see fit! :-)

### 2026-10-01, about 03:30Z — Joseph (on warn versus refuse for reserved syntax)

> I forgot I even *had* a discussion about udon-lite in August. I was wrong about warn. It should error. There is still some flexibility on whether or not we want "error" to be as drastic as in normal udon or streaming etc. But I think we basically halt parsing at that point with all the info and assume an AST only if the udon is compliant.
