# The three value spikes, by decision point, against CTQ-FACTORS

*The coordinator's synthesis of spikes a, b and c. Every score in the spikes is one agent's hypothesis against [`CTQ-FACTORS.md`](../../CTQ-FACTORS.md), and their scales differ, so this page compares rankings and names the factors that decided them, not totals. "All three" means the spikes reached it independently (none read another's directory). Factor IDs are CTQ-FACTORS': A = beauty, B = robustness, C = utility.*

## 1. How a bare value gets its kind

```udon
|srv :port 8080 :debug false :zip 01234 :size 920px :version 1.10
```

| Proposal | Fate | Deciding factors |
|---|---|---|
| The first character commits (`920px` an error) | dead, all three | A3 cold comprehension, A2 guessability: units are everywhere in notation |
| The old rich set by spelling (hex, `1_000`, rationals, durations, dates) | dead as a default, all three | B3 stability: each extra spelling is a new silent misread (`30seconds`, `1.0` vs `0.7.0`) |
| Bare is text, and any typed reading is optional per consumer | dead in a and b; c keeps a variant | B3, C7: two consumers disagree about `:debug false`, which is a truthy string to a schema-less reader |
| **Bare is text in the tree, plus one fixed, standard reading: `nil`, `true`, `false`, and JSON's number grammar** | **the lead, all three** | B3 (one answer everywhere), C1 (lite → JSON copies the number byte for byte), A2/A3 (what agents expect), A10 kept low (no declarations needed) |

Under the lead, `8080` reads as 8080 and `false` as false; `01234`, `920px` and `1.10`… stay text only if the spelling falls outside JSON's grammar: `01234` and `920px` do, `1.10` does not (it reads as a number, and only a slot type or quotes protect it).

**Where the three differ inside the lead** (one decision for Joseph):
- a: the parser attaches the class to the text in the tree (a value is its spelling plus a class);
- b: a normative default reading, on, the tree all text;
- c: the reading is a schema or typed read (`int(:port)`), on by default in generic converters (to JSON).

## 2. What `<…>` is

```udon
|srv :port <8080> :p <920px> :n <> :when <date: 2026-10-01>
```

| Proposal | Fate | Deciding factors |
|---|---|---|
| Carry any interior raw (today's provisional card) | dead, all three | B2 veto: can't refuse what a later UDON may define; can't reject `<920px>` |
| Unlabeled `<…>` asserts one standard value or is an error with "did you mean"; `<>` is nil | **the lead, all three** | B4 errors that teach, B2, A8 parsimony (one job per mark) |
| Labeled `<name: body>`, body carried for whatever reads `name` | a: proposed a design (ANG-4c), allowed now if adding a reading later isn't a change; b and c: deferred it ("reserved in 0.1, later") instead of designing it, which leaves this decision point undone (Joseph, 2026-10-22: deferral restates the premise the spikes were meant to resolve) | B6 headroom, C4 types and notations; B2 depending on the question below |
| KDL `(t)v`, EDN `#t`, YAML `!!t`, suffix tags, Unicode brackets | dead, all three | A3/A4: silent collisions with text; A8 |

`<8080>` gives the same tree as bare `8080` (a's reconciliation): the angle form is «meta» plus an assertion that held.

## 3. Slot types, aliases, domain names

| Proposal | Fate | Deciding factors |
|---|---|---|
| On the attribute name, `:port:u16` | dead, all three | C2: collides with XML names (`xml:lang`, `xlink:href`) |
| As a trait, `:port.u16` | dead (a, c) | A3/B3: stacking gives one slot two types |
| **In vocabularies and schemas outside the value (which can be lite documents), with typed getters (`get_int(:port)`)** | **the lead, all three** | A5 domain-forward, C5, B6 headroom (no syntax spent); the getters mirror Joseph's strict getters for cardinality |
| `:port<u16>` | stays an error, kept free (a, c) | B6 |

## 4. Units

| Proposal | Fate | Deciding factors |
|---|---|---|
| A quantity class (`920px` as number + unit) | dead, all three | B3: captures `10am`, `3rd`, `1080p`, `401k`; `5m` still ambiguous |
| **Units are text; the slot's dimension gives them meaning (`:timeout 5m` minutes, `:length 5m` metres)** | **the lead, all three** | A5, C11, B3 |

## 5. The trailing colon

| Proposal | Fate | Deciding factors |
|---|---|---|
| Compulsory | dead (a, c) | A2, A12: every attribute changes, no common precedent |
| As a type slot (`:when:dt`) | dead (a, c) | `:xml:lang` misreads silently |
| **A bare label never ends in `:`** (so `:host: localhost` can't become a name `host:`) | **the lead, all three** | B3; conflicts with the current labels lean, which allows `:` last |
| The ornament itself (`:attr: hi` = `:attr hi`) | open, beauty only (a ties optional and absent; b open; c: reserve now, allow later) | A1 |

## 6. A delimited value inside running text (spike b only)

```udon
|p "Hello," she said.
|li [Docs](https://x.org) for more
```

Under today's cards, the first is the string `Hello,` then the text `she said.` (the quotes vanish), and the second a list then text. Spike b's proposal: a quoted, bracketed or angled value counts only if it stands alone; otherwise the whole run is text. Factors: C2, C3 (prose and Markdown), A3. It conflicts with Joseph's 2026-10-21 one-value lean.

## What only Joseph can decide

1. **Inside the lead for §1:** class attached in the tree (a), a normative reading (b), or a schema-style read on by default in converters (c).
2. **Is adding information later a change?** If a later version may attach a class or read a carried notation body without that counting as changing an accepted tree, labeled `<name: body>` can come now and the §1 set can grow; if not, both are frozen for 0.1. Lite already treats fences this way: a later handler reads a body lite carried.
3. **CTQ B1's wording:** "every construct's kind is known within a few characters". All three spikes read it as the construct's kind (a bare run, known at once), with a value's classification allowed to arrive at its end. If it means the classification too, §1's lead fails it.
4. **A date: a leaf value (`<date: …>` or bare text a slot reads) or a node (`|{date …}`)?** (spike a)
5. **§6's stand-alone rule vs the one-value lean.**
6. **The labels lean**, if "a bare label never ends in `:`" is accepted.
