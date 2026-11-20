# Slots fork (spike a), 2026-10-22

*One fork of spike a: where a slot's type is said (DP6), the trailing colon (DP7), units (DP9), aliases and algebraic names (DP10), and what lite owes the layer that gives values meaning. Compass: `CTQ-FACTORS.md`. Per Joseph's notes, precedent is weighed against the factors, and the estate's documents are not used as evidence of how anyone writes. External standards (XML 1.0 NameChar, XSL-FO property names, UCUM) are cited as facts about the world lite must carry, recalled from memory and not re-fetched. Background assumed, not decided here: the bare-is-text lean with a typed-primitive view.*

## What I took the question to be

Where the *slot* side of Joseph's "what the slot is vs what my literal represents" lives, and what lite must do for it. The answer that came out: **for lite 0.1, nothing new in the syntax. Slot types, aliases, units and coercion all live in a reader's layer (Joseph's repurposed "dialect"). Lite owes that layer seven guarantees, most of which it already meets.**

## Branch map

| DP | Branch | State | Why | Page |
|---|---|---|---|---|
| 6 | S0: slot types outside the document; inline forms stay errors | **lean** (8.4) | zero plumbing per value; makes bare-is-text domain-forward; headroom free under the label lean | `dp6-slot-types.md` |
| 6 | S1: element traits as the dialect's lookup key | convention within S0 | | same |
| 6 | S2a: `:name:type` | **dead** | `:` is an XML NameChar inside real names (`xml:lang`, `xlink:href`, `xmlns:*`); collides with the trailing colon | same |
| 6 | S2b: `:name.type`, traits on attributes | alive for full UDON, costed (6.0) | one rule everywhere, but `.` is also a NameChar (XSL-FO `keep-with-previous.within-column`); tree change | same |
| 6 | S2c: `:name<type>` / `:name(type)` | headroom: keep an error in lite (7.0) | no NameChar collision, generics-like reading; per-value plumbing; one space from `:x <dt:…>` | same |
| 6 | S4: schema named in-document by convention | set aside | a second source needing precedence; an application convention, not a lite rule | same |
| 7 | T1: no ornament, `:` never last in a bare label | alive (7.7) | removes a silent trap in today's label lean | `dp7-trailing-colon.md` |
| 7 | T2: optional ornamental `:` | alive, **slight lean** (7.7) | gives the `$main` warning a one-character fix; costs a second spelling | same |
| 7 | T3: compulsory | **pruned** | every attribute in every card changes; a doubled role for `:`; `:host:` matches no common notation | same |
| 9 | U0: units are text | alive (7.8) | | `dp9-units.md` |
| 9 | U1: lite classifies quantities | alive, not recommended (7.2) | many edges in the spine, and meaning still needs the slot | same |
| 9 | U2: text, plus a named standard `quantity` notation outside the spine | **lean** (8.6) | readers agree; lite unchanged | same |
| 9 | U3: unit in the slot name (`:timeout-ms`) | advice for writers | | same |
| 9 | U4: unit in a typed bracket | handed to the angle-bracket fork | a bracket doesn't escape the slot either | same |
| 10 | L0: aliases and unions in the dialect | **only live branch** | | `dp10-aliases-and-reader-contract.md` |
| 10 | L1: aliases declared in the lite document | **dead for lite** | needs a declaration; `!` is refused | same |

## Findings

1. **Units dissolve.** A unit symbol is a partial claim on the literal, and the slot's dimension completes it: `:timeout 5m` vs `:length 5m`. Neither half decides alone, and together they always do. Lite owes only the spelling. That is why units felt like "both slot type and literal hint".
2. **The colon is the worst inline type separator,** and so is the dot: both are XML NameChars that real vocabularies use inside attribute names. If inline slot types ever come, a bracket directly after the name is the collision-free spelling, and the label lean already makes it an error in lite, so headroom costs nothing.
3. **The trailing colon can only be ornament**, so it can be decided now and needn't wait on types. And today's label lean (`:` allowed last) silently turns `:host: localhost` into an attribute named `host:`: whatever is chosen for the ornament, `:` should not be last in a bare label.
4. **Bare-is-text needs S0 to be domain-forward.** With a dialect, no value needs a mark. Without one, the default view covers the JSON case, and marks are needed only where union arms overlap or a host type has to be stated with no dialect present (K8). Those are the angle-bracket fork's cases.
5. **The reader contract R1–R7** (`dp10-…`) is the whole of what slot types, aliases, units and coercion need from lite. A small invariants card ("lite records, readers mean") would state it, and would answer [[obj:represent-structured-data]]'s "the same data": the same evidence, read by the same dialect.

## For the parent, outside this fork's scope

- The label lean makes `.` an error in attribute names, which costs XSL-FO's dotted names. That belongs on the label question.
- Keys and lists holding texts (an open question on [[rule:unquoted-run-is-one-value]]) is right under S0: the dialect types `$key`.

## Confidence

Scores are my hypothesis (`dp6-…` through `dp9-…` give each factor's basis). The XML and XSL-FO name facts are from memory of the specs (high confidence, not re-fetched). Nothing here was measured with panels.
