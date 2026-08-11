# Plain decisions — snippet first, no jargon (2026-08-09)

*Each decision: what you'd write, what it does under each option, my recommendation. Rule in any order; one word each suffices.*

---

## D1 — §0: now the "guiding model," revised per your critique (2026-08-11) — your direct pass invited

Your three objections landed as: **items are not axioms** → §0 is retitled **"The guiding model"** with an intro stating it is orientation, not law (sections govern; the model may lag; deliberately not axioms) — the old scope-guard folded in. **A1** → **G1 "Indentation is the hierarchy"** (the "columns are *the* syntax / only structural operator" overclaim deleted — it contradicted A5's printed closers). **A2** → **G2 "Why sameline works"**, your pseudo-reduction in two sentences (blocks+indent → nothing needs a closing tag → sameline structure at true columns; block-form markers double as value terminators) — the virtual-line/dual-operator promotion is deleted outright (not moved to RATIONALE), and §5.6's dangling "see RATIONALE" pointer with it. **A7** → **G7** with "loss" rephrased to "something the author wrote for is genuinely absent" and the sole-Error fact marked as current inventory.

**Jump there to adjust directly:** [[spec-0.10.00/CORE#0. The guiding model|CORE §0 — the guiding model]]

## D2 — RULED → K16 (2026-08-09, in chat)

**A key is a value slot, not a different syntax.** Full value grammar in every value-expected position including identity/selector bracket interiors — the fork-concurred brace carve was *rejected* (my "keys are for matching" rationale was an invented essence; jaw caught it live). Block forms out of bracket sugar: held lightly, "OK for right now," not law — the longhand `:$key` form covers complex keys. Matching semantics stay paths-era, default inert. Original presentation kept below for the record:

## ~~D2 — Where does "brace form = its own value" work?~~ *(superseded by K16 above)*

Your intuition: `:attr |{a} |{b}` ≈ `:attr [|{a} |{b}]` "generally." Resolution, unanimously concurred after both forks tried to refute it (each retracted its own contrary lean with reasons; pass 2 showed its axiom A3 *derives* this, and that R17 had already conceded the list case): **wherever a value is expected, the full value grammar applies** — plus one labeled carve: identity/selector brackets stay non-structural until paths (written as explicit subtraction *with its reason*, covering `@[…]` too, so incorporation-by-reference can't leak it). "Generally the same" lands as view-level: same items through a values-view, ordinary stacked-vs-list in the model. Two one-liners ride along: a host projection-policy note for structured list items, and an OPEN-ML line for the unclosed-`|{`-item edge. Pass 1's fork left a seven-point landing checklist (its final message) so the fold-in is mechanical once you say yes.

```udon
|el |{a} |{b}          ; two stacked $main values (ruled)
:attr
  |{em hi}             ; the em IS attr's value (deferred value position)
:tags [|{a} |{b}]      ; list of two inline elements — YES under the proposal
|el[|{x}]              ; still no — the labeled paths-era carve
```

Stacked vs bracketed stays the same distinction it is everywhere (`:x 1 :x 2` vs `:x [1 2]`): same items, different packaging.

## D3 — Attached escape while a value is open (Q8)

```udon
|element :attribute hello \:-) how are you?
```

**Option A (drafted, K13-consistent):** the escaped `:-)` joins the still-open value → `attribute = "hello :-) how are you?"`, no `$main`. Break out with the framed form: `hello \ :-) how…` → `attribute="hello"`, `$main=":-) how are you?"`.  
**Option B (your original pre-K13 annotation):** any escape after a value starts element text → `attribute="hello"`, `$main=":-) how are you?"` either way.  
**Recommendation: A** — one rule ("escape = make one character literal, change nothing else"), and the framed/attached distinction stays meaningful.

## D4 — Bare `:done?` now that flags are retired

```udon
|task :done? :assignee sam
```

**Option A (drafted):** `done?` is an ordinary label missing its value → Error + Nil (the deletion-detector working); write `:done? true`.  
**Option B:** some gentler landing for bare `?`-labels specifically.  
**Recommendation: A** — carving `?`-labels back out re-imports half the flag machinery you just deleted.

## D5 — Does a framed ` ; ` still end an open value?

```udon
|el :note call Sam tomorrow ; remind him about the demo
; note = "call Sam tomorrow", comment = "remind him about the demo"
```

**Drafted: yes** (it was a value-ender before; K10 kept it in the terminator set). Confirm or veto. **Recommendation: yes.**

## D6 — Rename the late-attribute warning?

The accept-and-warn warning (K14) is still named `AttributeAfterChildren` — a name that sounds like the *old* it's-just-text rule. Candidate: `LateAttribute`. Names aren't contract yet (W4), so this is cheap now.  
**Recommendation: rename to `LateAttribute`.**

## D7 — Late identity, one consumer sentence

Since attributes may now come late, `:$key` can too — so a streaming consumer can't trust an element's identity until the element closes. Drafted as a consumer note, no grammar change. **Confirm the note is enough** (vs carving `$`-labels out of late acceptance). **Recommendation: note is enough;** document-layer duplicate checks already work whole-element.

## D8 — The envelope's parts were also called "labels"

`<temporal:interval:2026-01/2026-06>` — the `temporal:interval:` part was the "label ladder." With *label* now meaning attribute-name, the draft renamed it **"envelope ladder."** Fine, or prefer another word ("tag"?).  
**Recommendation: envelope ladder (as drafted).**

## D9 — Small keep/retires

1. **Element suffix sugar** `|el?` → `:$? true` — now the only bare `?` with built-in meaning anywhere. Keep (harmless, schema-facing, and your CHEATSHEET arity convention uses the suffix position) or retire.  
   **Recommendation: keep.**
2. **`EscapeOutsideHeadPosition` advisory code** — describes nothing after K13. **Recommendation: retire at fixture time.**
3. **"Content phase"** as a concept — already retired in the draft (the *behavior* — the late-attribute Warning trigger — remains). FYI only, flag if the phrase was doing work for you elsewhere.

## D10 — Housekeeping (whenever; refreshed 2026-08-10)

- ~~Merge~~ done (suites separated: `spec-0.09.01/` + `spec-0.10.00/`).
- ~~Directory rename~~ resolved by your v2-root cleanup.
- **`.un` extension** — intentional convention? One line somewhere if so.
- **REF-SLASH / REF-BRACKET** (old OPEN rows) — soonest-relevant of the old steward calls, since the paths corpus is live. (The other old rows — S4, N-jargon, IND/IND-2, FIX-FRAME — are wait-whenever by your own 07-28 note.)

## D11 — Assignment/content interleaving at core equivalence (surfaced by pass 1's SEMANTICS; was missing from this sheet)

```udon
|el :a 1          |      |el :a 1 :late 2
  content            vs    content
  :late 2
```

Both have the same assignments and content; they differ in *where* `:late` sat relative to content. Recognition identity keeps the difference (source order). The open lean: at **core semantic equivalence** the position is NOT significant — the late-attribute Warning already marks it, and data-equality shouldn't fork on placement. **Recommendation: adopt the lean** (SEMANTICS item 9 already carries it as a flag; one word makes it law).
