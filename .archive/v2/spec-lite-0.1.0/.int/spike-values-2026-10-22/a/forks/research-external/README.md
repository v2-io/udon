# How other notations give values meaning: what bears on lite

*Research fork of spike a, 2026-10-22. The details, with quotes and sources, are in [`precedents.md`](precedents.md). Each precedent there is weighed against CTQ-FACTORS. None is offered as a reason in itself. The estate's own UDON is not used as evidence.*

## Takeaways, by decision point

**Joseph's map has standard names (C4, C5, A6).** XSD Datatypes calls his spelling R, notation N, represented type T and canonical spelling C the *lexical representation*, *lexical mapping*, *value space* and *canonical mapping*. A schema declares the slot S, and `xsi:type` overrides it on one instance. So the R/N/T/S/C split is the shape a mature type system arrived at, not a new invention. His `port = u16 | standard-port` is an XSD union and a CUE disjunction. XSD settles overlapping arms by declared order, with a per-value override. That is the one place a mark on the literal earns its keep.

**DP1, where the classification of a bare value lives.** YAML is already "C with the view". The parser reports a plain scalar with the non-specific tag `?`, and a schema classifies it from its finished content and path. Its failures have two separable causes:
- **Several schemas** (failsafe, JSON, core; 1.1 vs 1.2; PyYAML on 1.1). This is a B3 stability failure. Lite fixes it by specifying one small, normative reading.
- **The set's members** colliding with ordinary words and identifiers (`NO`, `Null`, `3.10` read as 3.1). This is a silent A3 failure. Lite fixes it only for words, by keeping the set small. Numbers like `3.10` collide in every number grammar.

StrictYAML and NestedText chose "text always, meaning from a schema" (C strict). That cures YAML's silent misses at the cost of C1. Tcl's string-primary values with a cached internal form are the existence proof for C with the classification attached.

**DP3, identifiers that spell numbers.** JSON, TOML, EDN and YAML's JSON schema all forbid a leading zero in a decimal number. If lite's classifier uses that number grammar, `01234` and `007` stay text for free. Nothing in any grammar keeps `1.10`, `3.10` or `1234567` from being numbers. Only text-by-default, or an exact decimal kept as spelled with conversion left to the slot, protects them.

**DP2, how big the standard set is.** The documented damage grows with the set:
- REBOL's huge lexical set (time, date, money, tuple for versions, pair, email, URL, tag) is the extreme.
- Excel's date-guessing renamed 27 human genes (SEPT1 → SEPTIN1, 2020) and corrupted about a fifth of the supplementary spreadsheets of some 3,600 genetics papers. It was unrecoverable because the spelling was discarded.

Both support keeping temporal shapes out of bare position, and keeping the spelling primary whatever is classified.

**DP9, units.** The CSS tokenizer is the clean precedent:
- `920px` is a dimension token (value, integer/number flag, unit), and `50%` a percentage, classified by shape alone.
- `e` starts an exponent only when a digit follows, so `2em` is (2, em) and `1e3` is a number.
- *From memory:* which units are valid is the property's (the slot's) business.

UCUM (`m` meter, `min` minute, `mo` month) against the old shorthand (`5m` minutes) shows that the same suffix means different things in different unit vocabularies. So the literal can carry "5 of `m`", but its meaning needs a vocabulary named by convention or slot (K6). F# writes units in angle brackets on literals, `1.0<cm>`: a meaning agents may bring to `<…>` beside a number.

**DP4 and DP5, what `<…>` is for and how a notation is named.** Prefix tags are the norm: EDN `#inst "…"`, KDL `(date)"…"`, SQL `DATE '…'`, Elixir `~D[2019-10-31]`. A prefix favors B1 and B5, since the parser knows the notation before the body. Unknown tags are handled three ways:
- **Ignorable:** KDL ("free to ignore them").
- **Accepted and carried:** RDF accepts ill-typed literals and does not reject unknown datatypes.
- **Reader's choice:** EDN offers error, handler or generic tag+value.

RDF is the evidence that carrying a tagged literal unvalidated can be forward-stable. Its identity is the pair (tag, lexical form), so a processor that later learns the type derives a value without changing the graph. That is how Joseph's "undetermined" value can meet B2 (reserve-don't-ignore) rather than violate it, provided lite's tree keeps the tag and the body whole.

**KDL v2 is the nearest relative, and it went the other way.** It has bare identifier strings and bare numbers. It made number-looking identifiers syntax errors (`-1em` and `1.0v2`, i.e. option A) and gave its keywords a sigil (`#true`, `#null`). That is evidence a modern notation weighed B3/B4 above units in bare position. Lite's CTQ weighs A5 (9) and C4 (8), so lite can diverge, knowing that it does.

**Slot typing at scale (DP6).** In ProtoJSON, int64 slots are emitted as strings and parsers accept `1` or `"1"`. Timestamps and durations are strings with a canonical normalized output owned by the slot type. Under a slot type the literal's own kind stops mattering, so DP1's classification only matters to schema-less readers (C1's JSON case). YAML allows tag resolution to depend on the path, so slot-aware resolution has precedent there too. NestedText's `officers.addr.nt` mirrors UDON's `name.schema.udon` convention.

**F1, streaming.** JSON knows a number's kind at its first character, and still:
- jackson-core needed a `maxNumberLength` limit (default 1000) against denial of service;
- CPython capped int-from-string conversion at 4300 digits (CVE-2020-10735, quadratic conversion).

The hazard sits in **conversion**, needs the whole digit run however early the kind was announced, and is bounded everywhere by a consumer-side length limit. YAML and Tcl classify at the end. This supports F1: B and C-with-the-view carry the same hazard and take the same bound. That bound belongs in the host mapping guide, not the grammar. What I didn't find is a deployed format that streams a bare value's characters and then trails its class. XML SAX does the first half, and YAML and Tcl the second.

## For the sibling forks, in a sentence each

- **Angle brackets:** F# `<unit>`, REBOL's `<tag>` and Elixir's `~X<…>` are three different prior meanings of `<…>` an agent may bring.
- **Classification:** use the JSON number grammar (no leading zero, digit-led), and look at KDL's sigiled keywords next to `<nil>`.
- **Slots:** XSD's union order and `xsi:type`, ProtoJSON's accept-either, CUE disjunctions, and YAML's path-dependent resolution.
