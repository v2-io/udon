# Spike b: how lite's values come to mean what they mean

*Opus 5.5, 2026-10-22, from the brief in `../BRIEF.md`, in three rounds:*
1. *the first pass (pages 00–40, three forks);*
2. *after Joseph said that "reserved for now" restated our premise, the notation values designed (page 50);*
3. *after his note on creativity, an inventive pass, invent first and judge after (page 60).*

*A fourth round, after reading spikes a and c: **`final-thoughts.md`**. Its proposal, K, combines my label traits with Joseph's parenthesis canary (`date(2026-10-01)`), which my stand-alone rule makes safe in ASCII. With K, `<…>` retires from values. Where K differs from rounds 1–3, K is the newer word.*

*Nothing here is committed by me, and no card was edited; proposed card changes are named on each page. Joseph's mid-run notes (CTQ-FACTORS is the compass; the corpus is ideation, never evidence) were carried into every page and passed to all three forks.*

## The question as I took it

Underneath "explore type systems and notations": **which layer decides a value's kind, and what does each form of a value (bare, quoted, angled, labelled) say about who decides?** Once that is settled, most spellings follow.

## Headline findings

1. **Streaming does not decide between whole-run typing (B) and "bare is text" (C).** Fork S *ran* the 0.9 parser: it holds every run to its end before emitting anything. The B1 wording that says "kind known within a few characters" is stricter than Joseph's concern; a rewording is proposed. → `fork-S-streaming.md`, `10` §1.
2. **`:debug false` decides the open bit.** With no default reading it is the truthy string `"false"` (run in four languages). So: the tree stays all text, as in (C), and a **normative default reading** applies JSON's number grammar plus `true`/`false`/`nil`. The rich set (`0xFF`, `1_000`) lives in `<…>`, checked strictly. → `10`.
3. **Labels wear the reading (the main invention).** `:mass.kg 3.2`, `:on.date 2026-10-01`, `:port.u16 8080`, `:pattern.re `\d+``: lite's trait mark `.`, "what kind of thing", is put on attribute names. The value stays bare domain data, the kind is known before the value's first character, and it turns the universal `timeout_ms` naming habit into meaning. The spelling is already held open: the label lean makes `.` in an attribute name an error now. With:
   - a **`$sig` key signature**, a container saying once how its descendants' values read, overridden per occurrence like an accidental in music;
   - **backtick raw values** (one or two backticks standing alone; three or more is the fence that already exists), so regexes and paths never escape;
   - a **hinged literal** `<date: 2026-10-01>` for slots with no fixed kind and for nesting (`<rational: <complex: 3 -7> 2>`).

   This system leads every alternative by about 100 of 1520 weighted points, from the Beauty group. → `60`.
4. **How meaning attaches:** four layers over one unchanging raw tree. In precedence order: the occurrence's trait, the signature, the vocabulary, then the default reading. A reader without a notation gets `unresolved(name, items)`; the tree never differs. That is how reserve-don't-ignore holds without reserving: the items are readable by lite's own rules (EDN's principle). → `50` §2, `60` §4.
5. **Slot types need no syntax:** vocabularies are lite documents addressed by element and attribute names (Joseph's "algebraic names"), and typed getters are the twin of his strict getters for cardinality. → `20`.
6. **A delimited value must stand alone, or the run is text.** This fixes `|p "Hello," she said.` (its quote marks are lost today) and `|li [Docs](…) for more` (its link becomes a list), and it dissolves most `<` collisions with HTML. → `30`.
7. **Precedent, weighed:** YAML's `?`/`!` tags already resolve bare values by path. XSD, JSON-LD and YAML converged on spelling / slot-declared-once / override-on-value. → `fork-R-precedents.md`.

## Branch map

| Decision | Branch | Fate | Why | Page |
|---|---|---|---|---|
| D1 who reads a bare run | β1 first character commits | dead | `920px` an error | 10 |
| | β2 the old rich set by default | dead as a default | silent misreads; it lives on inside `<…>` | 10 |
| | **β3 text tree + normative JSON-grammar reading** | **recommended** | A2, A3, B3, C1 | 10 |
| | β3b canonical-only | pruned | too clever, inconsistent | 10 |
| | β4 no default reading | pruned after three attempts | `:debug false` truthy | 10 |
| | β5 view optional per consumer | pruned | it is β3 or β4 per consumer | 10 |
| | β6 no primitives | dead | C1 | 10 |
| | β7 kind by strict getter | kept, inside β3 | lightest slot type | 10, 20 |
| D2 what a delimiter commits | δ1 commit and stack (today) | incumbent | loses quotes and links | 30 |
| | **δ3 must stand alone** | **recommended** | C2, C3, A3 | 30 |
| | δ2, δ4 | pruned | sameness; errors on ordinary prose | 30 |
| D4/J2 notation values | **LW: labels wear the reading** (`:mass.kg 3.2`, `$sig`, backtick raw, `<kind: …>`) | **recommended** | 1234 / 1520; Beauty, A5, A2 | 60 |
| | NB elements as notation values (`|{date …}`) | runner-up | parsimony; silent typos; flips an embed decision | 50, 60 |
| | BK bra-ket `<date|2026-10-01>` | recorded | lovely, but `|` would get a second meaning | 60 |
| | NA `<date 2026-10-01>` | absorbed into LW as the hinged form | reads like an HTML tag without the hinge | 50 |
| | NA+E unlabelled `<2026-10-01>` | not adopted | two spellings per date | 50 |
| | NC attached tag `date"…"` | dominated by NA | needs a tag-length bound | 50, P |
| | ND slot-only | kept as a layer, not the answer | fails generic slots | 50 |
| | I5 the tie `3.2‿kg` | alive, for taste | per-item units; strange and unfinished | 60 |
| | I6 emoji sigils, I7 superscripts | dead | variation selectors and widths; NFKC folding | 60 |
| | "reserved for lite 0.1" | **withdrawn** | it was the premise restated | 40 |
| | KDL `(t)v`, EDN `#t`, REBOL bare forms, `<…>` carried raw | dead | silent prose collisions | P |
| J3 composites | nesting inside `<kind: …>` | designed | | 50, 60 |
| J4 quote | `<ref: path>`, and `@{…}` stays the referent | designed | Lisp quote | 50 |
| D5 where slot types live | **σ1 vocabularies as data + getters** | **recommended** | | 20 |
| | σ2 per-occurrence *slot* types | dead as slot types; its spelling revived as LW traits | | 20, 60 |
| D6 overlapping unions | disjointness checked when the vocabulary loads; error at read | recommended | | 20 |
| D7 units | the unit on the label (`.kg`) or in a slot notation; `<qty: …>` in generic slots | recommended | | 20, 60 |
| keys | no default reading; identity by spelling | designed | | 50 |
| D9 trailing `:` | Joseph's taste; coupled with the hinge `<date: …>` | open | | 20, 50 |

## Files

- `debrief.md`: to Joseph, in examples and trees. **Start here.**
- `final-thoughts.md`: after reading a and c: the K design, flaws in mine and theirs, questions none of us asked.
- `60-inventions.md`: the inventive pass and the recommended system (LW).
- `50-notation-values.md`: the cold pass on notation values: the registry, the reading layers, NA/NB/NC/ND scored.
- `10-who-decides-kind.md`: D1–D3: the bit, the set, the branches.
- `20-slot-side.md`: D5–D7, D9.
- `30-delimiter-must-stand-alone.md`: D2 on the `$main` side.
- `40-literal-side.md`: first-round D4 (its "reserved" landing withdrawn).
- `00-working-frame.md`: the first framing and the composite example set.
- `fork-S-streaming.md`, `fork-R-precedents.md`, `fork-P-literal-notation.md`: the three forks.

**Corrections made along the way:** my hand-added score totals on pages 10, 20 and 30 were wrong and have been recomputed by script; no ranking changed. Labels that said "checked from memory" were either verified at the source (RFC 8259, Namespaces in XML, RFC 9557, YAML 1.2.2) or relabeled.

## On the forking experiment (Joseph asked)

Three `fork` agents (full inherited context), launched in parallel at the first decision map, with one-paragraph briefs. The harness allowed it, and the forks resumed cleanly when the relayed notes arrived. What it bought: one real measurement (S), an independent arrival at the same text collision (P), and a primary-source check I leaned on (R). What it didn't buy: variety of frame. Forks inherit the parent's framing, so they push hard inside it. The inventive round showed the same limit in me: my first two rounds surveyed and adjudicated, because the brief and my habits pointed backward. For warm variation, a fresh agent briefed only "invent" would likely do better than a fork.
