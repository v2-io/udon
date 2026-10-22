# Critical-to-quality factors for lite

*Status: steward-supported (Joseph, 2026-10-22); still subject to revision.*

*Joseph's 2011 table of UDON's concerns, updated for what has become more and less important since, with notes on how each factor can be measured or judged. First used to score branches of the type-and-notation exploration (`.int/types-ideation-2026-10-22.md`).*

## What has moved since 2011

- **Agents are the principal readers and writers.** Reading without highlighting, by a model, matters far more; human reading somewhat less; human *typing* much less (characters hard to type are no longer a cost in themselves).
- **Prose is core.** Markdown in prose was a side use; it is now one of lite's four objectives.
- **Streaming is a law, not a speed.** Every construct's kind is known within a few characters.
- **Errors over guesses,** and errors that teach: an agent fixes what a message tells it.
- **Values and their types are central.**
- **Lite evaluates nothing:** templating, algorithmic declaration and relational data belong to full UDON.

**How a branch is scored.** A **veto** is pass/fail; a branch that fails one stops. The rest are weighted 0–10. A branch's **impact radius** is a cost, not a quality: the cards it changes, adds or deletes, weighted by each card's `strength` (forced > decided > lean > provisional), plus whatever it reopens. A branch is pruned when it fails a veto or can no longer render the composite example set honestly.

## A. Beauty, visual and conceptual (highest)

Beauty is judged directly (A1), and also through contributors (A2 on), which are hypotheses about what tends to make a notation beautiful, not a definition of it.[^beauty]

| | Factor | Weight |
|---|---|---|
| A1 | **Agent-subjective**: a judge's open-ended, reasoned sense of which is more beautiful[^a1] | 9 |
| A2 | **Least surprise**[^a2] | 10 |
| A3 | **Agentic readability**[^a3] | 10 |
| A4 | **Domain-forward**[^a4] | 9 |
| A5 | **Spec clarity**[^a5] | 9 |
| A6 | **Syntactic simplicity**[^a6] | 8 |
| A7 | **Parsimony**: a small, well-chosen set of special characters[^a7] | 8 |
| A8 | **Conciseness**, in tokens | 6 |
| A9 | **Self-description**[^a9] | 5 |
| A10 | **Human readability** | 5 |
| A11 | **Human writability** (typing) | 2 |

Not goals: homoiconicity (it doesn't make lite more beautiful), algorithmic declaration, Turing completeness.

## B. Performance and robustness (very high)

| | Factor | Weight |
|---|---|---|
| B1 | **Bounded streaming**[^b1] | veto |
| B2 | **Reserve, don't ignore**: lite refuses what a later UDON may define | veto |
| B3 | **Stability**: one tree per document in every parser; errors, not guesses[^b3] | 10 |
| B4 | **Errors that teach**: each error and warning says what was probably meant | 8 |
| B5 | **Parse speed** (throughput)[^b5] | 9 |
| B6 | **Document size**, in bytes | 3 |

Dropped: transportation speed.

## C. Utility (very high)

| | Factor | Weight |
|---|---|---|
| C1 | **Structured data**, as JSON and YAML are used[^c1] | 10 |
| C2 | **XML/HTML**, mixed content included | 10 |
| C3 | **Markdown in prose stays Markdown** | 9 |
| C4 | **Types, notations and units** for values beyond the core[^c4] | 8 |
| C5 | **Schemas and slot types**, in-document and external, with aliases and domain vocabularies | 8 |
| C6 | **Extensibility**: dialects, generic and host-specific | 8 |
| C7 | **A predictable tree and API**[^c7] | 8 |
| C8 | **Other languages, exactly** (fences) | 8 |
| C9 | **Document composition**: partials, records, the logical store | 7 |
| C10 | **Round-trip fidelity**: content, meta, ornament | 7 |

Full UDON, not lite: universal templating, relational data. Folded in elsewhere: online processing (B1); global and specialized serialization, document universality and namespaced type mixing (C1, C4–C6).

## D. Support (medium)

| | Factor | Weight |
|---|---|---|
| D1 | **Agent tooling**: an edit tool, linters, conversions | 8 |
| D2 | **Language and framework integration**, portability[^d2] | 7 |
| D3 | **Editor integration** (highlighting for people) | 5 |

Folded in elsewhere: documentation (A5), "chic" (A). Settled: the license (MIT). Not scored: community, standardization, commercial support.

## Open

- What 2011's "in-document API usage" means now (C7).

[^beauty]: Beauty is left to each judge's own sense, on purpose. Aspects Joseph has named, as examples: the domain's model showing rather than the plumbing; ornament such as alignment and blank lines; a small, well-chosen set of special characters; constraints such as meaningful indentation, which restrict layout freedom in a way that is more conceptually beautiful.
[^a1]: Judged by asking agents (other model families included) which of two renderings of the same content seems more beautiful, and why. A reason like "this seems more beautiful to me, I think because it's less ambiguous about which value belongs to which name" counts even when no other contributor covers it, and may point to a missing one.
[^a2]: Having seen a few idiomatic forms and a few rarer ones, an agent correctly guesses the rest. Measured by exposure curves: fresh panels read held-out UDON into trees and write UDON from trees given as JSON, at several exposure levels. Silent misreads weigh more than errors.
[^a3]: Read by a model in plain text: no highlighting, no position made ambiguous (tabs), structure visible from the shape of the lines, alignment where it helps. Measured by panel accuracy and effort on unhighlighted documents.
[^a4]: The domain's model shows, not the plumbing between the domain and the machine; conventions (file and schema naming, the logical store, slot vocabularies) carry what would otherwise be declared on each value. Measured as plumbing per domain fact in the composite set.
[^a5]: The spec's spine is short, coherent and easy to apply. Measured by a fresh agent given only the spine answering held-out questions.
[^a6]: Few rules, one reading per construct. Measured from the grammar: size, choice points, exceptions; checked by an interpreter that reads the grammar text.
[^a7]: Each special character has one role, and there are few of them. Measured by counting characters and the roles each carries.
[^a9]: Weighted low on purpose: weighted high, it pulls toward explicit declaration over convention, which doesn't compose into higher levels of abstraction.
[^b1]: No construct holds an unbounded stretch before its kind is known; lite documents parse the same under a streaming full parser. Measured as the longest holdback per construct, from the grammar.
[^b3]: A weight, not a veto: bounded streaming can always be met by setting a bound, but some rare contexts may unavoidably need different trees (Joseph, 2026-10-22).
[^b5]: Bounded streaming (B1) says nothing is held without limit; it doesn't say parsing is fast. Speed matters to adoption and lets implementers weigh costs. Joseph: "order-of-magnitude speed/performance differentials tend to qualitatively change how humans and agents alike think of a tool. Every 10x increase in speed opens up the imagination to how small or elemental of an operation it is-- the mind starts using it in composition with a bunch of other things, instead of costing out the cost of 'normal usage' like before" (`git checkout` feels atomic). "Udon that parses as fast and conveniently as TOML will simply get used in significantly more scenarios than one that feels like choosing a markdown parsing engine." Measured against JSON and TOML parsers on the same content, in orders of magnitude.
[^c1]: The portable core (nil, booleans, strings, numbers) parses "without extra effort" into every host; a host mapping guide covers the edges (integers past 2^53, NaN, nil versus absent). Measured by converting real JSON and YAML.
[^c4]: The territory of the type exploration. Measured by how much of the composite set a branch renders, and with how much plumbing (A4).
[^c7]: Cardinality by strict getters; attachments (comments, meta) change no arity.
[^d2]: Through the host mapping guide (C1).

---

*Sources: Joseph's 2011 table, `~/src/_older/udon/doc/objectives.asciidoc`; lite's objectives, `obj/`. Drafted with Joseph in session `017CGtyMCtyw6NYVNMD12Y2s`, 2026-10-22; the discussion is in `.int/STEWARD-VERBATIM.md`.*
