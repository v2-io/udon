# Wildcard fork (spike a): play and assumption-revisiting

*A fork of spike a's coordinator (Opus 5.5), 2026-10-22. Its role: warm, frame-rejecting exploration, scored against CTQ-FACTORS.md (the compass). Joseph's two notes were applied: precedent is evidence to weigh against the factors, never a reason; the estate's documents are ideation, not evidence of how anyone writes. My own instincts as a writer and reader are the evidence I used. Every score is my hypothesis.*

## Branch map

| Page | Idea | Status | One line |
|---|---|---|---|
| [w1-a-notation-is-an-element.md](w1-a-notation-is-an-element.md) | A notation is an element: `:when |{date 2026-10-22}` | **alive, worth his attention** | UDON's "whose name is it?" test already splits his *slot* vs *literal*: the attribute name is the slot, an element name is what the literal represents. No new syntax; parameters as attributes or traits; composites by nesting; the same construct works in prose. Cost: the block form `:x |date … :y 1` silently takes the rest of the line; it rests on undesigned embeds; it's longer than `<…>`. |
| [w2-attribute-traits-as-slot-types.md](w2-attribute-traits-as-slot-types.md) | Slot types as attribute traits: `:port.u16 8080` | **dead** | Dies on stacking: a slot type written per occurrence is a literal annotation in disguise. Finding: a real slot type is declared once per element type, so in lite it lives outside the document (schema, convention); lite owes it an address and an exact spelling, not syntax. |
| [w3-quote-ladder.md](w3-quote-ladder.md) | Quoted = itself, bare = the reader decides, declared = the writer says | **alive, as a frame for the spec's wording** | Gives his Lisp-quote distinction a home and the «string»/«text» split a meaning (closed vs open). Explains C-with-the-view from the inside; one teaching rule for identifiers ("quote what must not be read"). Doesn't decide where the default reading's result lives. |
| [w4-rebol-maximal.md](w4-rebol-maximal.md) | REBOL-maximal lexical typing | **dead** | Dies on stability (B3) and spec clarity (A6). Salvage: the shapes an agent would write unprompted are few (ISO date and time, `30s`, `920px`, `50%`), and where those few go is the real question. Handed to the classification and slot forks. |
| (not pushed) | Unicode brackets for notations (`⟨date 2026-10-22⟩`) | seed only | Typing cost is now low weight (A12 at 2), but no agent has a prior for it (A2), and it's the angle-bracket fork's ground. |
| (not pushed) | A standard slot vocabulary (`:date` and `:at` are dates by convention) | seed only | Very domain-forward, but it's a reader's layer, not lite; for the slots fork if anywhere. |

`scores.py` holds the W1 score vectors (R, W1a, W1b) and computes the weighted means.

## The one thing to take from this fork

W1 and W2 together make one claim: **Joseph's "what the slot is" and "what my literal represents" are already UDON's attribute name and element name.** If that holds, `<…>` needs no type-label grammar at all. Either `<…>` shrinks to asserting the standard set (`<8080>`, `<nil>`, `<>`), or it is reserved and freed for full UDON. A literal's notation is then an element, and a slot's type lives outside the lite document.

The question underneath, which only he can answer: **is a date (or a u64, or a color) a leaf in the tree, or a node?** W1 says node. If he says leaf, W1 is the wrong shape, and W3 plus the angle-bracket fork's work is where to look.
