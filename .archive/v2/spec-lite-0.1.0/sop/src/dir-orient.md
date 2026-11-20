---
kind: directive
awaiting-second: true
awaiting-decision: false
needs-work: false
when: "on arrival in spec-lite-0.1.0/, before any substantive work; again after any context compaction"
per: [sop-own-vsect-and-decisions, main-outline-name]
depends: [def:record, def:sop-kinds, dir:scope]
---

# Orient before working

*Read what the corpus already knows, then how work happens here, then declare yourself. Being fluent in this corpus's forms doesn't mean you know its content.*

## Statement

Orientation is three things, in order.

**1. Doctrina: know what the corpus already knows.** Read these whole, in this order:

1. `.int/README.md`: what lite is for, and what has been decided so far.
2. `main.outline.md`, including its working notes: the spec store's primary ⟦view⟧.
3. `.vsect/kinds.yaml`: the spec store's kinds, and where each is found. The kinds map, not any outline, says what the corpus is.
4. The spec store's drafted records, whole, rows whose ⟦row-type⟧ is `landed` first. A row-type says what a row claims, not whether its document exists; follow the row's link to find out.
5. `ls .int/pre-design/`, so you know which questions are open. Read one whole when your work touches it.

**2. Praxes: know how work happens here.** Read:

1. `sop/main.outline.md`, and every drafted `sop/src/` record it lists, whole.
2. `sop/.vsect/kinds.yaml`: this store's kinds, and where each is found.
3. `sop/def/`: the terms written `⟦…⟧` throughout.
4. `sop/adr/`: the process decisions those records cite in ⟦per⟧.
5. `ls sop/influx/`, to see what is waiting to be carried into records.

**3. Professio: declare yourself.** Before substantive work, write a few sentences in your own words: what you understand the purpose here to be, and which practice above you expect to find hardest to keep under pressure. Write them in your session, and in your first commit message if the work is significant. It is voluntary, owned, revisable, and scoped to your session. Skipping it honestly is better than performing it.

**Feedback channel.** If anything here confused you, fought the reality in front of you, or proved wrong, record it in `sop/influx/`. If it is urgent, raise it with the steward. Confusion at the front line is the signal to re-check what the corpus says, not noise.

## Discussion

- It fires again after a context compaction because a compacted summary feels like knowledge you have, and isn't.
- The pattern and the failure it answers are verisectorium's `dir-orient` and `form-orientation-triple`. An agent can imitate a corpus's forms long before it knows what the corpus has settled. The theory's own first founding attempt failed exactly that way.
- The read order puts content first (doctrina), because this store's conventions only make sense once you know what they are conventions *for*.
- The steward's standing preference, carried from verisectorium: whole reads over sampling, and asking over inferring when someone's meaning is unclear.

## Working notes

