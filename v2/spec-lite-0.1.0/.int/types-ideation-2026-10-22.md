# Types and notations: ideation, 2026-10-22

*Running notes from the session `017CGtyM` brainstorm with Joseph. Pure ideation: nothing here is a lean, a decision or a proposed spelling unless it says so, and every spelling below is illustrative. Joseph's words are quoted; everything else is the agent's. His whole messages are in `STEWARD-VERBATIM.md`. Background: `old-numeric-typing.md` (the old line's standard set).*

## His scope, as stated

> **Primary concerns**: slot-type, literal-notation-hint, units (= seem to be a bit of both slot-type & literal-hint & coercion), algebraic-names (domain-centric slot-type mapping), "standard set" (described below).
>
> **Potentially related / overlapping concerns**: extensions (including type extensions (including both generic and host-specific)), namespacing/hierarchy, stackable traits, cardinality/ordinality/arity..., schemas, enforcement, coercion, sigils, (obviously other udon conventions/spellings-- block-level vs embed, etc.)

"Algebraic names", in his words: "designating `port` as one of u16 | standard-ports, with standard-ports designated as {'smtp','ssh','http',...} (not proposing a spelling-- just the concept I had in mind). At the very least, type aliases."

## Distinctions to keep apart (his)

1. **Quoted vs unquoted** (Lisp's quote): keep a reference or a value as itself, or resolve it.
2. **"*this is what the slot is* vs *this is what my literal represents*."**
3. **A dialect is neither of those.** "<dt:...> glosses over it historically when discussing because it's... well, neither-- it's a dialect-- a type namespace with its parser-- in this case with the actual literal notation mapping to a given type (timestamp, timestamp-w-zip, datespan, ...)."
4. **"how it's literally written here" vs "how it's read and what processing is available to the API ingesting & processing it automatically without extra work"**, and "possibly also implying a "normalized/unified way of reading it when re-emitted"".

His imaginings: `:when:iso8601 <dt: 2026 PDT>`, `:when:dt(YY-MM-DD)<27-03-05>`.

## The agent's map so far

Per value, five things that can each be stated or left unstated:

| | Question | Example |
|---|---|---|
| R | the spelling, as written | `27-03-05` |
| N | the notation that reads it (dialect, format, parameters) | `dt`, `YY-MM-DD` |
| T | what the literal represents | a date, 2027-03-05 |
| S | what the slot accepts | `port` = u16 \| standard-port |
| C | how it is written back, canonically | `2027-03-05` |
| H | the host (storage) type a parser gives it, unique to each host language; in UDON itself it is always a span of characters | Rust `chrono::NaiveDate`, Ruby `Date`, JS `Temporal.PlainDate` |

N maps R to T; T must fit S (or be coerced to it); C is N's canonical spelling of T. Where N and S are declared is its own axis: on the literal, on the slot (the attribute name), in a document header, in an external schema; most specific wins, as locales and CSS cascade.

**H added by Joseph (2026-10-22)**, "since otherwise it will keep getting implied and conflated": "*storage*/host-type, with the caveat being that it will be parser-host-language-unique a lot of the time, and with the caveat that, by definition, the Udon "stores" it as a span of characters within the udon file :-)". His four questions, the same map from another side:

> "what does the domain expect here that is meaningful?", "what notations can it be understood in and checked against?", "what host-language stuff can be done with it when parsed?", and "what should it normally be displayed like if different from what is accepted?"

The agent's reading: domain = S and T; notations = N (several accepted, each a check); host = H; display = C. Two of the four are portable across consumers (domain, notation) and two belong to the consumer (host; and display, at least where it is locale or audience). Names like `u16` straddle the line: a domain range (0–65535) and a storage type at once.

**Host types are not simply per host (Joseph, 2026-10-22):** "not directly, but for most elementary constructs there is a type equivalence and sometimes even binary/stored-to-memory equivalence, right? (nil, boolean, strings, etc. for example)-- or "via ducktyping" *shrug*? I bring it up because it was the implicit driver of the stuff that "just gets parsed correctly without extra effort" -- json or yaml style--- numbers, floats, boolean, ... because they have obvious representations in any host language. Exactly what you were getting at with "exact numeric" or arbitrary precision etc. in an internal mapping guide for parser implementations... because those sorts of concerns bridge the whole set of questions--- domain<->...<->storage(where the domain automation stuff gets to use it)."

- **His earlier, naive dialect model:** `<rust:i64: 0x73DDF>`, "the model might shrink back down to something like that, don't know yet."
- **His mode, stated:** "my brain is still exploring the space and hasn't started the "consolidating / recollapsing" principled resimplification with decisions part of the creative process yet-- it's still on the "allowing it to fully expand" mode :-)"
- **The agent's lean on storage hints (recorded at his invitation, not his):** keep host storage types (u16, i64, f32) out of documents and vocabularies; give the domain layer ranges, exactness and units, so each host can derive its storage type. Held loosely, for when consolidation starts.
- **A hypothesis (the agent's), for expansion, not decision:** a kind belongs in the "just parses correctly" core exactly when every plausible host has an obvious, near-lossless equivalent: nil, boolean, string, integer, float. By that test temporal kinds fail (host date types disagree about zones, precision and calendars), and so do rationals and complex numbers (no JS equivalent), which may be why temporal kept surprising and was partitioned off, and why rationals and complex stayed "provisional". Even the core needs a mapping guide at its edges: JSON's grammar allows any number, and RFC 8259 §6 then warns that hosts use IEEE binary64, so integers past 2^53 lose precision in JavaScript.

## A method for the exploration (Joseph, 2026-10-22)

> I feel like there's a useful heuristic waiting for us. In some ways the most useful thing to do would to have a forking/branching exploration of various alternatives that keep branching and forking at decision-points and that all try to end at the full implications for all of the other rules etc. (impact radius) as well as the more important factors -- the 2011 list merged with the good parts of objectives-- kind of   "principle of least surprise" x "impact radius" x "grammar simplicity" x "other-ctqs-e.g.,streaming"(weighted by 2011 numbers but adjusted a little like the markdown one you mentioned and interpreting the others in terms of agentic factors/training priors...)  x "spec-'time-to-comprehension'" (i.e., how concise and coherent and easily applied the spec's spine is-- correlated with grammar simplicity & principle of least surprise but not the same)... I imagine many lines kind of petering out early as "this is getting so messy that it's not worth continuing to branch and push to the conclusion..."

The agent's notes on making it runnable are in the verbatim record (2026-10-22): a shared instrument (one composite example set every branch must render), a dossier per branch, measurements per factor (fresh unprimed agents predicting trees for least surprise and for time-to-comprehension; the grammar's own size and holdback for simplicity and streaming; cards touched for impact radius), and Joseph's judgment as the final comparison.

**Least surprise is generalization, not recognition (Joseph, 2026-10-22):** "least surprise is a bit more than recognition -- it needs to be "having x-level of exposure, correctly guesses how to do 'y'" (especially, having seen a few idiomatic and normal things with just a few "rarer" notational things, it correctly or nearly correctly guesses a lot more of the rarer things. related would be giving them the AST in json or something and having them guess an appropriate udon notation, given x-exposure...)"

The agent's shape for it: one semantic content set, rendered in each branch's spelling; a fixed exposure set (mostly idiomatic, a few rarer forms) and a fixed held-out set of rarer forms, the same content for every branch; both directions (read: UDON → tree; write: tree as JSON → UDON); scored at several exposure levels, so each branch gets a curve, not a point; misses sorted into those the parser would catch (an error) and those that silently give a different tree, the second weighing more.

The factors and their measures are now [`CTQ-FACTORS.md`](../CTQ-FACTORS.md) (steward-supported, 2026-10-22).

## How to run the exploration (Joseph, 2026-10-22)

A single spike agent from the spike template, with agent-decided forking: it forks at each distinct decision point, pushes branches toward their implications, prunes with reasons, and scores by its own best hypothesis against [`CTQ-FACTORS.md`](../CTQ-FACTORS.md). Joseph: "I don't have the resources / usage tokens available to run the full panel protocols and to empirically calculate any of the ctq metrics. I'll be happy with a single agent's best hypothesis on scores... forking whenever it comes to a distinct decision-point?" An earlier, heavier proposal (niches, panels, rounds) was set aside as likely to "explode into lots and lots of data and content and buried signal".
