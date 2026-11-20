# Spike a: working notes (the coordinator of this spike, Opus 5.5)

*A working file: frame, branch map, findings as they land, with labels. **checked** = I verified it against a primary in this session; **guess** = inference not verified; **taste** = my preference. The README and debrief are written from this file and the fork pages at the end.*

## Compass

Joseph, relayed mid-run: CTQ-FACTORS.md "is the guiding light and compass for this spike ... Anything older you come across (earlier spec drafts, past decisions, the old typing machine, history) is useful only inasmuch as it meets those factors, and he expects much of it doesn't. So treat precedent as evidence to weigh against the factors, never as a reason in itself."

## How I read the question (before branching)

The span asks how lite's values come to mean what they mean, with his primary concerns (slot type, literal notation hint, units, algebraic names, standard set) and his distinctions (quoted/unquoted; what the slot is vs what my literal represents; a dialect as neither; how it's written vs how it's read and processed vs how it's re-emitted; the host type).

My first reframing (to be tested, not assumed): **lite evaluates nothing, so lite never gives a value its meaning.** Lite decides three things only:
1. what *evidence* the tree records about each value (spelling, form, any classification, any annotation, where it sits);
2. which spellings lite *commits* (parses with a defined result), *carries* (accepts with no meaning: "undetermined"), or *refuses* (reserved, an error);
3. a default reading, if any, that every consumer gets without a schema.

Meaning is then assigned by a reader: the default reading (the standard set), a slot type (schema, convention, vocabulary), or a notation (dialect). The type system proper (slot types, aliases, coercion, unit semantics, canonical display, host types) is a reader's layer. The well-formed question underneath becomes: **what must the tree keep, and which spellings must lite commit, carry or refuse, so that every later reader (and every later UDON) can assign meaning without changing an accepted lite tree?** Whether that frame survives contact is part of the spike.

## Decision points (the branch map's skeleton)

- **DP1 Where the standard-set classification of a bare run lives.** (a) nowhere: bare is text, full stop (C strict); (b) an optional view (C+view, his current lean); (c) a normative classification attached to the text by the parser (C+class); (d) the class is the value's kind, with the spelling kept (B).
- **DP2 Membership of the standard set.** {nil, true, false, integer, decimal} → + bases and underscores → + quantity (number + unit suffix) → + rational/complex → + temporal shapes.
- **DP3 Identifier safety.** `:zip 01234`, `:version 1.10`, `:sha 1234567`, `:id 1e10`: does the default reading turn them into numbers?
- **DP4 What `<…>` is for.** (i) assert a standard-set value (commit or error); (ii) carry a notation lite doesn't read (dates, host types); (iii) both; (iv) neither: retire it or move notations elsewhere.
- **DP5 How a notation is named.** `<dt:…>`, `<dt …>`, KDL-style `(dt)…`, a suffix, an element `|dt …`, declared on the slot.
- **DP6 Slot types in the document.** none in lite (schema, file naming, vocabularies outside) vs inline on the attribute name.
- **DP7 The trailing `:` on attribute names** (his light lean), which DP6 and the label characters bear on.
- **DP8 nil:** `nil` bare, `<nil>`, `<>`.
- **DP9 Units:** on the literal, on the slot, or both.
- **DP10 Aliases and algebraic names** (`port` = u16 | standard-port): a reader's layer; what lite owes it.

## Checked facts so far

- **The estate's own `<…>` uses are temporal (counted, 2026-10-22; ideation only, not evidence).** A grep over `~/src/**/*.ud{,on}` for `:name <…>` finds shapes `9999-99-99` (153), `99:99` (120), `99s` (36), `9999-99-99T99:99` (16), the rest placeholders in comments. Joseph, relayed mid-run: "don't treat any "live" document in the corpus as empirical evidence of anything. All the UDON you come across, the Markdown too, and any analyses of it were written by fiat ... Use them for ideation, never as evidence of how people or agents actually write or read. Your own instincts are better empirical evidence than they are." So this count says only what he and agents chose to write; it is not demand, and a branch that makes `<2026-07-21>` an error pays no "breakage" cost for it beyond editing files. (I first wrote it up as real demand; corrected here, and the correction relayed to all six forks.)
- **Labels may hold `:` inside** in the coordinator's lean (`xml:lang`, `xlink:href`; `.int/labels-ascii-and-positions-2026-10-20.md`), and 2011's DECIDED.md allowed `:` in labels. So `:port:u16 8080` reads as an attribute named `port:u16` unless the label rule changes (checked: the lean file; not a ruling).

## Findings in progress

### F1. Streaming does not separate B from C-with-the-view (my analysis; verifying)

The objection that killed B (whole-run typing) was holdback: `4938…2412124p` forces a parser to hold an unbounded prefix before saying its kind. But C-with-the-view computes exactly the same function at exactly the same moment: a view reads a text "whose whole content is one run spelling exactly a number", which it can only know when the run ends. So whoever wants the classification waits for the run's end under both; whoever doesn't, waits for nothing under both.

What made B look worse is an assumption about the event protocol: that a value's kind must be announced *before* its characters. Under the bare-run rule the run's *extent* never depends on what it spells (it ends at the next start, a framed ` \ ` or the line end, whatever it spells). So the parser can stream the run's characters as they arrive and attach the classification *when the run closes*, as a trailer, run by a finite-state classifier beside the scan. Nothing is held. The old machine's "tag plus slice at the token's end" was this trailer, implemented by holding a slice instead of streaming.

Consequences, if it holds:
- DP1's (b), (c) and (d) cost the same in streaming. The choice between them is about who owns the classification (language or reader), what the default reading is, and stability across consumers, not about bounded streaming.
- (c) and (d) are isomorphic (both keep spelling and class); they differ in which one the spec, the transcript and the default getter treat as primary.
- Joseph's attachment principle fits (c) exactly: a classification is an attachment that changes no arity.
- Honest cost: it changes the event vocabulary (a class trailer, or a close event that carries it). The 0.9 parser decided late kinds by holding (descent's HOLD/RELEASE for `$key`/`$partial-key`), so this is an architectural choice, but it is a choice about events, not about buffering. *Checked:* the README's description of HOLD/RELEASE; *not checked:* descent's code.

### From the history fork (forks/research-internal/README.md), with my own checks

- **Checked against `~/.claude/history.jsonl` (lines 22733, 16328, 7711):** on 2026-10-21 (timestamp 1792541210130), before the holdback objection, Joseph told the previous agent its typing of `:d 3` was "completely wrong and opposed to the magic of udon values"; `:d <3>::numeric` in his sketch. On 2026-07-15 he voted that `599239492002394992929999.7e12 apples` error, because text would need "potentially unlimited lookahead" (option A). On 2026-01-10: "Without lookahead ... If the host (even Rust native) needs to do something with the values, it will do some "inner" parsing and coercion itself."
- So streaming has twice decided against whole-run typing (07-15 toward A, 10-21 toward C), each time on the cost of holding a value until it is known to be text. If F1 holds, that cost isn't paid by B, and the reason he gave up "the magic of udon values" falls away. That is his to weigh, put in his words; not the spike's to settle.
- The fork's caution, which I accept: B1 says "every construct's kind is known within a few characters". F1 needs "kind" to mean the construct (a bare run) with the classification as a later attachment. His usage treats type and kind as one word, so that reading needs his acceptance.

### From the external-precedents fork (forks/research-external/), weighed against the factors

- F1 support: conversion needs every digit whatever the protocol (jackson's 1000-digit cap, CPython's 4300-digit int cap, CVE-2020-10735), so B and C+view share the hazard and the same bound: a host-guide conversion limit, not a grammar rule. No deployed format streams a bare value then trails its class; both halves exist apart (YAML, Tcl classify after completion). The combination is new; that's a risk to name, not a refutation.
- DP3 has a cheap partial answer: JSON, TOML, EDN and YAML's JSON schema all forbid leading zeros, so a classifier on that number grammar leaves `01234` and `007` text with no new rule. Nothing protects `1.10` or `1234567` except text-by-default, or keeping an exact decimal as spelled.
- YAML's failures split in two: competing schemas (a stability failure, cured by one specified reading) and set members that collide with words (`NO`, `Null`; cured by a tiny set). `3.10` → 3.1 survives YAML 1.2.
- KDL v2 went the other way: number-looking bare words are errors (`-1em`), keywords prefixed (`#true`). Lite's A5 and C4 weights pull against that; diverge knowingly.
- RDF carries unknown datatypes as (tag, original text) identity: the precedent for "undetermined" passing B2.
- XSD already names his layers: lexical space, lexical mapping, value space, canonical mapping.

### From the wildcard fork (forks/wildcard/)

- **W1, a notation is an element (`:when |{date 2026-10-22}`), alive.** UDON's own attribute-vs-child test already separates his "what the slot is" (the attribute name, the parent's word) from "what my literal represents" (an element's own name). Parameters become attributes or traits; composites nest; it works inside prose too. Main cost, **checked against [[rule:element-after-attribute-with-no-value]]:** a block `|name` after a waiting attribute takes the rest of the line (`|el :x |em hi :y 2` gives `y` to `em`), so `:started |datetime … :timeout 30s` silently moves `timeout`. Rests on undesigned embeds. Open question for Joseph: is a date a leaf or a node?
- **W2, slot types as attribute traits (`:port.u16`), dead:** stacking gives one slot two types; a real slot type is declared once per element type, i.e. outside the document. Lite owes that layer an address per slot and the exact spelling, not syntax.
- **W3, the quote ladder, alive as a frame:** quoted = exactly these characters (closed); bare = the reader decides (open); declared = the writer says what it is. Gives the string/text split a meaning and his Lisp-quote distinction a home.
- **W4, REBOL-maximal, dead** on stability, spec clarity and host portability; residue: the shapes an agent writes unprompted are few (ISO dates/times, `30s`, `920px`, `50%`).

### From the slots fork (forks/slots/)

- Lite 0.1 needs no slot syntax: slot types, aliases, units' meaning and coercion are the reader's layer; lite owes it R1–R7 (spelling, form, slot address, order, no conversion, reserved inline-declaration spellings, one default reading). Proposed: a small invariants card, "lite records, readers mean".
- Units split cleanly: the literal's symbol is a partial claim, the slot's dimension completes it (`:timeout 5m` vs `:length 5m`). Lean U2: text, plus a named `quantity` reading outside the spine; U1 (lite classifies quantities) not recommended.
- `:name:type` dies on XML names (`xml:lang`, `xlink:href`); a bracket after the name (`:port<u16>`) collides with nothing and the label lean already errors on it, so headroom is free.
- **A trap, checked against `.int/labels-ascii-and-positions-2026-10-20.md` (`:` allowed "inner and last"):** under that lean `:host: localhost` is an attribute named `host:`. Whatever the ornament decision, `:` should not end a bare label. T1 (no ornament) and T2 (optional ornament) tie; slight lean T2; compulsory pruned.
- Keys and lists holding texts is right once slot types live outside (a dialect can type `$key`).
