# Working frame (spike b), first pass, 2026-10-22

*A working file, written before branching. The branch pages may revise it. Labels: **[checked]** = verified against a file or source; **[inferred]** = my reasoning, not verified; **[taste]** = my preference.*

## What I take the question to be

The span opens with Joseph reopening `<…>` wholesale and asking for a type system to be explored "over the whole range of possibilities". His primary concerns are slot type, literal-notation hint, units, algebraic names and the standard set. He also draws distinctions: quoted vs unquoted (Lisp), slot vs literal, a dialect as neither, written vs read vs re-emitted, and host type. The CTQ list is the yardstick. The question as posed: **what notation and layering should lite use for the kinds of its values?**

The question I think sits underneath it: **which layer decides a value's kind, and what does each form of a value (bare, quoted, angled) say about who decides?** The spellings follow from that.

## Three observations that reshape the question (all to be pushed in branch pages)

1. **[inferred, to verify in fork S] Bounded streaming does not separate (B) from (C).** The objection to whole-run typing (B) was buffering: "buffer essentially unlimited amount of the incoming stream before being able to output any partial text or partial node". Whether a run spells a number is decided by a finite automaton running alongside the characters. The characters can be emitted as they arrive and the kind reported *after* them (a trailer), with O(1) memory. Holdback is forced only when an event that must be emitted *before* the content depends on the later decision. So the distinction that matters is between **shape** (where a value ends, who its parent is: must be decided within a bounded distance) and **classification of a finished span** (may trail its content). The old parser decided value kinds at token end, emitting tag+slice ([checked] `old-numeric-typing.md` §4), so "knows in the first few characters" held for structure, not for values.
2. **[inferred] (C) with the view is YAML's tag-resolution architecture, minus YAML's mistakes.** In YAML, a plain scalar gets the "non-specific" tag `?` and is resolved by a schema; a quoted scalar gets `!` (a string) (to verify in fork R). YAML's failures (Norway, `0755`, sexagesimal, 1.1 vs 1.2 loaders giving different data) came from an aggressive default schema and from having more than one of them, not from the architecture. The lite lean's "view" is a **default schema**: the slot type you get when there is no slot type.
3. **[inferred] Lisp quote and slot-vs-literal can be aligned by design, while staying distinct concepts.** Joseph asked that they be kept apart in discussion. One design aligns them. A **bare** value is unquoted: its kind is *resolved against the slot* (evaluated in an environment). A **delimited** value (quoted, angled) is quoted: the *literal* decides its kind, and the slot only checks it or coerces it. Slot type S and literal type T stay separate concepts. The form of the value decides which of the two determines T.

## Decision points (the fork map)

| # | Decision | Branches |
|---|---|---|
| D1 | Which layer decides a bare value's kind? | parse-time by spelling (A first char; B whole run, late tag) · raw spelling + optional view (C, the lean) · raw spelling + **normative** default resolution in a logical tree · no primitives at all |
| D2 | What does each form commit? | bare = resolve / delimited = literal ("quote alignment") · bare = text, quoted = string, angle = typed (current cards) |
| D3 | The standard set (what default resolution recognizes) | JSON minimum · + numeric idioms (`0x` `_`) · + rational/complex · + temporal · + units |
| D4 | Literal-side notation spelling | `<…>` with a label prefix · KDL `(t)v` · suffix · sigil `~d[…]` · Unicode brackets · REBOL lexical forms |
| D5 | Where a slot type is declared | nowhere in lite (convention / external) · on the attribute name (`:port:u16`) · once per document · vocabulary |
| D6 | Unions with overlapping arms | ordered · must be disjoint · literal marks disambiguate |
| D7 | Units | slot notation · standard set · literal mark |
| D8 | `<>`, `nil` | (follows D1/D2) |
| D9 | Trailing `:` on attribute names | (interacts with D5 and XML names) |

## Composite example set (semantic content; each branch renders it)

| # | Content | Why it's here |
|---|---|---|
| E1 | server: name `web`, port 8080, host `localhost`, debug true, ratio 0.75, owner nil, tags [`a` `b`] | JSON's use (C1) |
| E2 | version "1.0" (a text), zip "01234", short sha "1e10a3f" and "1234e56" | numeric-looking text: the misclassification risk |
| E3 | width 920px, mass 3.2 kg, memory 512MB | units (C4) |
| E4 | date 2026-01-10, timestamp with zone, duration 3m5d | temporal |
| E5 | port given as `ssh` in one record and `22` in another, slot `port = u16 \| standard-port` | algebraic names, unions |
| E6 | `|li <kbd>Ctrl</kbd> to copy`, `|p "Hello," she said.`, `|li [Docs](https://x) for more` | value-initial delimiters in sameline text (C2, C3) |
| E7 | title "1984 is a novel", year 1949 | run vs value |
| E8 | nil, the empty string, empty text | `<>`, `""`, `\` |
| E9 | `4938422…2412124p` (very long) | streaming |
| E10 | colour #ff0000, mask 0xFF | lexical idioms |
| E11 | rational with complex numerator | composite literals |
| E12 | a reference kept as a reference | `@{<…>}` |
