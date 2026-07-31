# 03 — what I believe about UDON from the primer alone, before opening CORE

*Opus 5 (session `udon`), 2026-07-30. Written after reading `udon-0.9.1-primer.md` whole and
**before** opening any file in `current-0.9.1-spec/`. Purpose (Joseph's, this session): my
surprisal on reading the real spec is data for refining the primer — and an unattributed
surprise is useless for that, so this file exists to make attribution possible.*

## The attribution scheme I'll score against

Every surprise on reading CORE gets exactly one tag:

- **(A) PRIMER-GAP** — the primer never mentions it, and an agent working from the primer would
  not know to look. *Actionable for primer work.*
- **(B) PRIMER-WRONG** — the primer states it and the spec disagrees. *Actionable, and urgent.*
- **(C) MY-MISREAD** — the primer says it plainly and I took it wrongly. *Not a primer defect,
  though a pattern of these may indicate a clarity problem.*
- **(D) MY-EXTRAPOLATION** — the primer is accurate and silent, and I invented a consequence.
  *Mine. But a cluster here marks where the primer invites confident filling-in, which is a real
  design property of a primer.*

The distinction I care most about is **(A) vs (D)**, because they feel identical from inside and
have opposite remedies.

## The standing hypothesis this session tests

**The primer is optimized for a comparative reader and an agent primer has a different job.** Its
own stated scope is "compare UDON honestly against SGML/XML/JSON/YAML/RDF *without first learning
to write UDON*" — comparison, explicitly not generation. An agent primer's job is the opposite:
emit conformant UDON and edit it without breaking it.

**Prediction H1:** the surprises will cluster in *generation-critical* detail rather than in model
or philosophy — indentation and column mechanics, phase gating, the sameline tail, escaping,
where markers are and aren't live. The primer's §3 claims "two ideas predict most of it," and I
predict that is true **for reading** and materially insufficient **for writing**.

*Falsifier:* if my CORE surprises are mostly conceptual (model shape, layering, semantics) rather
than mechanical, H1 is wrong and the primer's compression is losing something other than
generation detail.

This matters beyond primer work: the primer's own §8 records that agents who read the entire
suite the same day still emitted plausible-but-wrong UDON. If reading *everything* doesn't buy
generation, the gap isn't compression — it's that the suite is organized for specification rather
than for production, and a generation-shaped artifact is a different document, not a longer one.

## What I now believe, stated so it can be scored

### Model (high confidence — the primer is a distillation of MODEL.md)

1. `Document = { content: [Node], anomalies: [Anomaly], result: complete | incomplete-input }`.
2. Seven node kinds: Element, Text, Comment, Verbatim, Directive, Reference, BlankLine.
3. No implicit root; top-level nodes are a sequence of true siblings.
4. `Element = { name?, attributes: [Assignment], content: [Node] }` — attributes an **ordered
   sequence**, all preceding content; anonymous elements ordinary.
5. `Assignment = { key, value }`, exactly one value each. `:x 1 :x 2` ≠ `:x [1 2]` at any layer.
6. An attribute's value may be a node, with no wrapper (`NodeValue = Element | Verbatim`).
7. Text is opaque: no Markdown interpretation, `#`/`<`/pipe-space inert inside it.
8. Comments and BlankLines are *in* the model, carried, never interpreted.
9. Text law: pure in-order concatenation reconstructs text material; terminators are part of
   Text; dedent-stripped indentation is geometry not text; inline comments contribute no text
   but their framing whitespace does; verbatim bodies are exact bytes.
10. Anomaly severity **defined by loss**: Warning = everything kept; Error = something lost or an
    author-intended value genuinely absent. Errors never halt. Halting/rejecting is consumer policy.
11. `incomplete-input` is a document-level fact, not an event or an anomaly.

### Surface (medium confidence — the primer says it's giving "just enough to read an example")

12. `|name`, `[key]`, `.trait`, trailing `? ! * +`, `:key value`, `:key?`, `@name[key].trait`,
    `;`, `!name`, `!:lang:`, `!{{expr}}`, triple-backtick fence, `|{…}` `;{…}` `!{…}`, `\`, `<…>`.
13. Markers live only at **Structure Position**; the first ordinary prose word commits the line to
    text and from there markers are literal. **Exactly one** carve-out survives commitment:
    whitespace-framed ` ; `.
14. Columns are the syntax: `pop while new_column <= stack_top.base_column`, then push. A one-line
    form `|a |b |c` is identical to the vertical nesting.
15. Strings: `"…"`/`'…'`, **no in-string escapes at all**; embed the other quote kind.
16. Integers with `_` separators and `0x`/`0o`/`0b`/`0d` bases; floats; `true`/`false`/`null`/`nil`
    lowercase and *alone at their boundary*; `[space delimited lists]`; `<envelopes>`.
17. An unquoted token that is nothing else is a **string**; a multi-word tail is a **flow value**.
18. Sugar desugars to designated `$` keys *before the model is complete*: `|el[k]` ≡
    `:'$key' k`; `|el.a.b` ≡ two `:'$traits'` assignments; `|el?` ≡ `:'$?' true`. `$` keys are
    **designated, not reserved** — any `$` key is legal; the defense is that `$` isn't a bare-key
    character so longhand needs quoting. Convention, not law.
19. The one-way door: once a node value opens it owns the rest of the line
    (`|api :headers |header :k v :timeout 30` → `timeout` belongs to `header`).
20. Extents are **geometric** (line/dedent/EOF) or **delimited** (printed end-sequence), and every
    construct declares one — which makes EOF behavior derivable. Geometric closes silently
    (EOF ≡ eol + full dedent; missing final newline never an anomaly); delimited keeps what it has,
    warns citing its opener, sets `incomplete-input`.
21. Fail-safe: unclosed `[` on identity or reference selector → **`$partial-key`**, never `$key`;
    the two are never semantically equivalent.
22. **Bounded lookahead is language law** — every guard resolves in a few characters, single level,
    no unbounded backtracking; a proposal needing more is *ill-formed*. Consequence: identical
    parse whole or byte-at-a-time; a chunk boundary is never EOF.
23. References are inert: selector `(name?, key?, traits)`, frozen at three fields, never resolved
    by the core, traits are selection criteria not decoration.
24. Type is syntactic, never sniffed. Bare scalar set **closed forever**: string, integer, float,
    boolean, nil, list. Everything else inside `<…>`, typed by a dialect. Bare `2026-07-11` is the
    string. With no dialect loaded, the envelope's extent still parses, value carried as full
    lexical form with a warning, retypes identically later.
25. Layer split: recognition = core (sole conformance target) · meaning/typing = dialect · allowed
    /required = schema · projection = host · resolution, duplicates, mixins = consumer choosing
    from a fixed **menu**. Three keepers: dialects≠schemas, menu-not-knob, additivity.

### Things I expect CORE to contain that the primer did **not** give me

Listing these so that finding them scores as **(A) PRIMER-GAP** honestly rather than as
retroactive "I knew that." I predict CORE has substantive material on:

- **What a "structural column" actually is** — §3's rule references `stack_top.base_column`, but
  I cannot compute a base column from the primer. This is the single biggest hole for generation.
- **The sameline tail** — mentioned once in the primer via §6.9's phrase "a child, text, or a
  sameline tail," never defined. I don't know what it is.
- **Content base** — the term appears in OPEN's ROOT-BASE row citing `CORE §7.2`, and *not* in the
  primer. I have the text law without the geometry that decides which text belongs to whom.
- **Phase gating specifics** — "attributes precede content" is stated; which node kinds *end* the
  attribute window is flagged as unstated even in the primer's own appendix.
- **The `\` escape's exact positional table** — "meaning fixed by position alone" tells me the
  principle and none of the positions.
- **Escaping generally** — memory records a known CORE inconsistency (`@` and triple-backtick
  marked special in one list, omitted from the escaping list). Primer is silent.
- **Anomaly code inventory** — CARVEOUTS reportedly holds code spellings as open; I expect a
  partial list plus a provisionality banner.
- **Interpolation and directive detail** — `!{{expr}}` vs `!{…}` vs `!name` are three things in one
  table row and I can't distinguish their rules.
- **Envelope extent and nesting** — nested-envelope routing is an OPEN row (S12); I expect CORE to
  state the single-level case and be silent on nesting.
- **A designated-key inventory** — I know four (`$key`, `$traits`, `$?`, `$partial-key`) and expect
  CORE to enumerate.
- **Appendix C's three worked vignettes** — whole input → whole Document. Predicted to be the most
  generation-useful pages in the suite, and entirely absent from the primer.

### Specific falsifiable guesses about CORE's text

- **G1:** "content base" is defined for *an element* and the document-root case is genuinely
  absent (not merely ambiguous) — matching OPEN's ROOT-BASE framing. 
- **G2:** CORE contains at least one internal disagreement of the kind memory records — a list of
  special characters in one section not matching a list in another.
- **G3:** at least one place where severity is assigned on a taste basis ("illegal geometry")
  rather than by the L0 loss test, because L0 was ruled 2026-07-21, later than most surrounding
  text.
- **G4:** the primer's §4.5 sugar table is *complete for what it shows* but CORE designates more
  `$` keys than four.
- **G5:** CORE explicitly states that `#` has no meaning, because both the README and the primer
  bother to say so — which usually means someone kept asking.

## Wandering

The thing I want to watch for while reading CORE is a specific illusion I can already feel
forming: I have a *fluent* model of UDON now, and fluency is exactly what the primer is designed
to produce for a comparative reader. It would let me write a confident paragraph about the
language right now. It would not let me write four correct lines of it. That gap — fluent about
versus competent in — is I think the real subject of Joseph's primer-optimization project, and
it's a sharper way to state the §8 hazard than the primer itself manages: the failure isn't that
agents skim, it's that comprehension and generation are *different competencies* and prose
delivers the first while quietly implying the second. If that's right, the empirical test for an
agent primer isn't "did the agent understand" — that always comes back yes — but "did the agent
emit conformant UDON on a task it hadn't seen," which is a generation test, and which the
December usability harness (per the OUTLINE's `meas-checker-tempo-delta` row) may already be
shaped to run.

Second: I notice the primer's most useful pages for *me* were the ones stating what UDON decided
*against* and why (§4). Not the model, not the syntax table — the commitments with their
defeated alternatives. My guess at the mechanism is that a decision-with-its-alternative is
self-checking in a way a bare rule isn't: if I misremember "stacking," I might reconstruct
last-wins as a plausible default, but if I remember "stacking, because last-wins silently
destroys data on the happy path and that contradicts keep-everything on the sad path," the wrong
reconstruction doesn't fit the reason. Rules degrade into plausible neighbors under recall;
rules-with-reasons don't, because the reason is a constraint the neighbor violates. That would
predict something concrete and testable for primer design — **carry the defeated alternative with
every rule** — and it's cheap enough to try that I'd want it tested rather than believed.

Third, and least defended: I keep wanting to know what UDON's unification *costs*, and the primer
answers this once, plainly, and I nearly missed it — "the cost is visible syntax on every
non-core value, paid deliberately." That's an honest price tag on the typing decision. But I
don't see the corresponding price on the two commitments that seem structurally larger:
keep-everything (what does never-rejecting cost a consumer that would rather fail fast?) and no
implicit root (what does giving up the single-root guarantee cost tools that assume one?). Both
are probably answered somewhere in RATIONALE. I want to notice whether they're answered as
*prices* or as *benefits*, because a design document that lists only the benefits of its hard
choices is one I'd trust less, and this one has so far been unusually willing to name costs.
