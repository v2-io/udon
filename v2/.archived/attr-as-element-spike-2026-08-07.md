# Spike — attribute-as-simplified-element (2c), directive placement, identity-interior grammar

**Date:** 2026-08-07 · **For:** tonight's adjudication (Joseph + coordinating agent) · **Basis:** full reads of CORE.md, MODEL.md, SEMANTICS.md; CARVEOUTS + DECISIONS (incl. K1 and the same-day pending notes) in hand. Shaped for ruling: what breaks, what simplifies, which forks need Joseph's call. Incumbency of 0.9.1 text carries no weight below; coherence with keep-everything / text-law / one-value-grammar does.

**Verdict in one paragraph.** 2c is real and mostly good — but it is a **model change wearing a grammar-simplification costume**. The surface grammar barely changes (the sameline scan must keep working exactly as it does, or `|el :a 1 :b 2` dies); what changes is MODEL §3's `Assignment = {key, value}` invariant, and through it the warned-extension machinery, the missing-value Error, the four-state Nil model, and one leg of SEMANTICS' non-collapse law. Each of those is a deliberate sub-ruling, not a free consequence. The attribute-namespace fork should be **rejected in its recursive form** and satisfied instead by either the existing `/`-key convention or a group-sugar that desugars to flat keys — the recursive form reifies edges-of-edges, which the language's own "whose name is it?" test (CORE §6.1) argues against. Directive placement and the identity-interior vote are both coherent, each with one sharp edge (directive head-swallow; `["one" two]`, where K1 supplies a better answer than a descriptive pin).

---

## 1. What 2c actually is

Today: `Assignment = { key, value }`, exactly one Value, where Value ∈ Scalar | Reference | Interpolation | NodeValue | FlowValue (MODEL §4). Multiplicity is expressed only *across* assignments (stacking) or *inside* a scalar (list). Everything plural arriving under one declaration is anomaly machinery: warned extension (§6.7), attribute-under-attribute Error (§6.8/L6).

2c: `Assignment = { key, content: [Item] }` — an attribute is an element minus name, identity, traits, and (absent the namespace fork) minus attributes. "One value" becomes the common case of a one-item content list, exactly as an element with one child is unremarkable.

**The model gets simpler.** NodeValue and FlowValue stop being distinct Value kinds — a node value is just a one-node content; a flow value is just flow content, same as element prose. The Value taxonomy collapses to:

```
Assignment = { key, content: [Item] }
Item = Scalar | Reference | Interpolation | Node     ; Node as in MODEL §2
```

That is a genuine unification: three homes of flow (CORE §7.1) already share one rule set; 2c makes attributes and elements share one *content* model too. The residual asymmetry — worth naming in the spec if 2c lands — is that **element content still cannot hold a typed Scalar** (a deeper `42` under `|el` is Text; a sameline `42` after `:x` is Integer). Types stay "on the map side" only in *value position on the line*; see §1.3 below.

**The grammar barely changes.** Every sameline behavior must survive untouched:

- `|el :a 1 :b 2` — a finished self-announcing value returns control to the Line Scan. If an attribute behaved like an element on the same line (owning everything rightward, as `|a |b` nests), multi-attribute lines die. So the attribute is *not* element-like on the sameline axis; the one-value scan discipline stays.
- The sameline decompress (§6.5 row 2 — element takes the tail) stays: `|el :a "x" some text` still gives the tail to `el`.

So 2c's entire operative surface is the **block/deferred context**: what deeper lines under a key mean. Today: one deferred value, then anomalies. Under 2c: the key's content, plural, heterogeneous — Joseph's example parses with zero anomaly machinery:

```udon
|element :attribute one
  :another some prose
    |zee-ozzer-element ...
    and here is some more
    ; comment preserved as a content item — coherent with MODEL §5
```

`:another`'s content = [Text "some prose\n", Element zee-ozzer, Text "and here is some more\n", Comment]. This is well-defined by ordinary column rules with no new geometry. **This part I'd ratify without hesitation** — it deletes the AttributeSecondValue warning, the "one node per declaration, stack for more" special case (§6.8), and the multi-segment prohibition (MODEL §3), replacing all three with the rule everyone already knows from elements.

### 1.1 The sub-rulings 2c forces (each needs an explicit call)

| # | Question | Options | My read |
|---|---|---|---|
| a | **Does warned extension survive as a warning?** §6.7's warning marks a real refactoring hazard: joining a block line onto the element line changes ownership (row 2). 2c makes the shape *legal*, but the hazard is unchanged — and now silent. | (i) extension items become ordinary content, no anomaly; (ii) keep a Warning (or host advisory) on the *same-line trailing text on a block attribute line* case only | (ii)-lean: the deeper-lines case is clearly intentional authoring (indented under the key); the same-line trailing case is exactly the join hazard and stays worth marking. Distinguishing them costs one sentence. |
| b | **Does `MissingAttributeValue` (Error) survive?** If attributes have children-plural "even if empty," a bare plain `:key` is an empty attribute, peer to an empty `\|el` — no Error, no Nil. | (i) empty content, silent; (ii) keep Error+Nil | (i) is the principled consequence of 2c, and "value required" moves to schema where constraint belongs. But it **dissolves the four-state model** (§11.4): Nil then means only *explicit* `:key nil`, and "key present, no value" becomes a fifth state (Empty) — or replaces Nil-by-error. Appendix C vignette 3 and R6 both need rewrites. This is the biggest semantic ripple in 2c; rule it consciously, not as fallout. |
| c | **Stacking vs children — a third plurality.** SEMANTICS §2.4 holds `:x 1 :x 2` ≠ `:x [1 2]`, ever. 2c adds a third non-equivalent plural: `:x` + children `1`-ish, `2`-ish. | Accept three shapes (with the note below); or normalize one pair | Accept — but note the sharp edge: children arriving as *deferred lines* are **Text, not typed scalars** (see 1.3), so the third shape is not actually a scalar-plurality competitor; it's the heterogeneous-content shape. Saying that in SEMANTICS keeps the three from being confused. |
| d | **Do flags get content?** Today deeper material under a finished flag is warned extension; flag rule 2 re-owns sameline material to the scan. | (i) flags are leaf-only (content always empty; deeper lines = anomaly or element text); (ii) flags take content like any key | (ii) for uniformity — "prematurely limiting for no gain" is 2c's own motivation — with flag rule 1–2 (sameline) untouched. A boolean edge with annotation-children is odd but harmless and schema-constrainable. |
| e | **Does K1/identity inherit 2c?** If `$key` is an ordinary attribute and attributes now hold content, `\|el[k]` + deeper lines could feed `$key` content. | Identity brackets stay a *sameline value-grammar* surface (§3 below); `$key` assignments produced by sugar are one-item, closed | Close it: sugar produces finished assignments; deeper lines never attach to sugar-produced keys. One sentence prevents a weird door. |

### 1.2 What 2c deletes vs what it keeps (net grammar accounting)

Deleted: AttributeSecondValue (Warning), the §6.8 one-node/stack-for-more rule, MODEL §3's "never a nested multi-segment value kind," and (per b(i)) MissingAttributeValue (Error). Possibly AttributeValueExtendedByTrailingText (per a).

Kept unchanged: the Line Scan, bare-token boundary, inline-brace principle, flag rules 1–2, sameline ownership rows, one-way door for sameline node values, stacking, content phase for *elements* (§6.9).

Changed status: **attribute-under-attribute** — see §2. Note the Error-inventory consequence: under b(i) + fork-A §2, *the language may end with zero core Errors* — every anomaly becomes a Warning under L0, since nothing is lost and no intended value is "genuinely absent" anymore. That's philosophically tidy (Error=loss, and keep-everything means never losing) but worth saying out loud: "fail on error" CI semantics would then mean only truncation (`incomplete-input`).

### 1.3 A seam 2c exposes (pre-existing, worth fixing regardless)

CORE §6.5 says a deferred body is "a multi-line flow value, or a node." It never says whether a lone deferred token types: does

```udon
|el
  :port
    5432
```

give Integer 5432 or Text "5432\n"? By the flow-value reading it's text; by author expectation it's a number. Under 2c the answer defaults to Text (attribute content ≡ element-content rules, which never type scalars). **Either answer is fine; the spec currently gives neither.** If 2c lands with the Text answer, one loud sentence — "typed values are sameline (or list items); deferred lines are content" — prevents a thousand bug reports.

---

## 2. The namespace-hierarchy fork (`:illegal`, `:system-`)

Two separable demands are tangled here:

**(A) Grouping/namespacing of keys** — the `:system-` gesture: author wants `errors`, `advantages`, `recovery-modes` visually grouped under `system` without a node carrier.

**(B) Attributes-on-attributes** — the `:illegal` line: edges that themselves have labeled edges.

### Against (B), the recursive form

- **The language's own design test kills it.** §6.1: an attribute is *the parent's relationship-label*. An attribute of an attribute is a label on a relationship — RDF reification territory. UDON already has the honest spelling for "this edge terminates at something with its own structure": a node value (`:third |wonderful :attribute-of-wonderful 123` — which works *today*, and appears in Joseph's own example doing exactly the job).
- **It recursively imports the element machinery 2c was shedding**: attributes would need their own attribute-vs-content phase (§6.9 recursion), their own sugar story (can `:key` take `[identity]`? traits?), and a second answer to flags — element flags desugar to `$?` attributes *because elements have attributes*; attribute flag-`?` lives in the name *because they don't*. Grant (B) and the two flag mechanisms sit side by side with no principle picking between them.
- **It creates a second tree.** Every consumer (paths especially — the long pole) would need to address two nested hierarchies. The frozen selector tuple and the coming path design (CARVEOUTS §PATHS) get strictly harder.

**Keep L6's Error → but under 2c it likely demotes to a Warning.** With fork A, a `:key` line directly inside an open attribute's content still isn't a nested attribute. But note the severity interaction: L0 says Error requires loss or a genuinely absent intended value. Today L6 justifies Error as "the intended nested-attribute structure is absent." Under 2c-with-A that justification *weakens* — the line can be kept as an ordinary Text content item (bytes kept, structure position never promised nested attributes because the language doesn't have them) — so the honest severity is arguably Warning ("text that looks like an attribute," same family as late-`:` §6.9). Either keep Error with the L6 justification restated, or demote with the L0 rationale; don't leave the old wording, which will read as pre-2c residue.

### For (A), two designs that don't need (B)

1. **Do nothing.** `/` is already a bare key-continue character with blessed namespacing convention: `:system/errors [404 405 509]`. Zero new grammar. The only demand it doesn't meet is *visual grouping under indentation*.
2. **Group sugar desugaring to flat keys** — if the visual demand is real:

   ```udon
   :system/          ; group opener: key ending in the namespace char, no value material
     :errors [404 405 509]
     :advantages [cuteness tenacity]
   ```

   desugars to `:system/errors …`, `:system/advantages …` — flat assignments, ordinary stacking, no model change, paths untouched, SEMANTICS equivalence with the longhand for free. This is the same move as identity sugar: surface convenience, designated flat substrate.

   **On the `:system-` spelling specifically: hazard.** `-` is a key-continue character, so `system-` is a *legal bare key today*; a trailing-dash group marker retypes existing keys (semi-frozen makes this legal, but it should be chosen, not inherited from an example's spelling). Trailing `/` has the same formal problem (`/` is also key-continue) but reads as "namespace with nothing after it," is far less likely in the wild, and rhymes with the convention it extends. If group sugar is wanted, `:system/` + no-value + deeper-`:`-lines is the guarded spelling I'd propose. Note the guard must also disambiguate against 2c itself: under 2c, `:system` (no slash) + deeper `:errors` lines is *exactly the (B)-shaped input* — so the group-opener spelling is also what keeps (A) and the kept-error/warning for (B) distinguishable.

**If (B) is nonetheless wanted someday**, it should arrive as what it is — a reification mechanism, probably via a designated carrier (an anonymous node value is already the community trick Joseph cites: `:attr |‹anon› :meta 1 real content`) — not as core grammar. The trick costs one `|` and keeps one tree.

---

## 3. Identity-bracket interior = attribute-value grammar

**Verdict: internally coherent, with three named restrictions and one better-than-descriptive answer for the ambiguous case.**

The vote works because the interior can be specified as **a value context in §6.6's table** — one value grammar, one more row:

| Context | Bare-token terminators | Tail after a finished value |
|---|---|---|
| Identity/selector bracket | space, EOL†, `]` (consumed) | **see below** |

- `[one two]` → bare token `one`, next material is plain text, ordinary §6.4 flow-commit → flow value `"one two"` → string. Falls out of the existing rule; nothing new.
- `[[one two]]` → first char `[` self-announces a list → `["one","two"]`. Consistent.
- `[<2026>]` → envelope. Consistent (and unresolved-envelope-as-key inherits the §11.6 interim: lexical string + NoDialectsLoaded — fine, keyable).
- `[ ]` → nil (R16, unchanged). `[nil]` → Nil key — two spellings of nil key, harmless.
- †EOL: unchanged — `$partial-key` fail-safe / descriptive current behavior (ML carve-out). The vote doesn't disturb it.

**Restrictions to state (else "exactly like an attribute value" proves too much):**

1. **No node values.** `[|em hi]` must not put an Element in `$key` — block-form `|` `@` `!` are not live inside the bracket (they'd also wreck the fail-safe: an unclosed bracket swallowing structure is what `$partial-key` exists to prevent). Say: *the interior is the value grammar's scalar/reference/interpolation subset; block forms do not open there.*
2. **Reference-as-key** — the value grammar allows `@…`; `[@mit]` would make `$key` a selector. Identity-by-reference is a paths-era question (CARVEOUTS §PATHS); I'd exclude `@` from the interior now (it's incoherent with §12.2's "references never decorate," and K1 already covers the real demand — multiple literal keys).
3. **Inline brace forms / framed ` ; `** — the inline-brace principle would let `[a |{em b}]` commit a flow value with a structural segment as the key, and a framed ` ; ` would open a comment inside identity. Interpolation-as-whole-key is already ruled (S5); I'd pin: interior flow is *text-only* flow (inline forms literal or excluded), no framed comments — mirroring the list-item posture ("no flow values inside a list") rather than the element-line posture.

**The ambiguous case `["one" two]` — K1 gives a principled answer; take it instead of a descriptive pin.** After `"one"` closes, `two` is post-finished-value material. The contexts' tail column answers: element line → element's tail (inapplicable); block attr line → further stacked assignment. With K1 ruled — multiple `$key`s stack like any attribute — the bracket-interior tail rule can be *the same rule*: **further material after a finished value in the bracket is a further `$key` assignment** (with or without the §6.7-style Warning; I'd keep the Warning since interior multiplicity, unlike K1's explicit `][`, is likely accidental). `["one" two]` ≡ `|x["one"][two]` + Warning. That's one rule reused, K1-consistent, and strictly better than pinning parser accident. (If Joseph prefers maximal caution: descriptive-pin now, but *word the pin* so this K1-shaped resolution stays available.)

**Interaction with 2c:** if 2c reshapes attribute values into content sequences, the identity vote should be pinned to the **sameline single-value grammar**, not to "whatever an attribute takes" — otherwise 2c silently drags multi-item content semantics into brackets. Rule them in either order, but with that one cross-reference.

---

## 4. Directives sit anywhere an element can

The pragmatic 0.9.1 wording is fine; the precise edit is small and mostly already latent:

- §6.4's boundary list **already** includes `!name` as a guard-confirmed block-form marker — so `|el :x one !if c` already terminates the token (`x="one"`) and the directive lands as `el`'s child. The undecidable case my audit flagged is only **value-expected position**: `:x !if cond`. The ruling closes it: directive = node value. Mechanically: §6.3 NodeValue row and MODEL §4 `NodeValue = Element | Verbatim` gain `| Directive` (or, under 2c, Directive is just an Item — the ruling becomes one sentence). Unresolved-when-no-dialect is already the directive posture (§9); an unresolved directive as a value is coherent with unresolved envelopes — the model "never holds a half-typed value," and a Directive node carrying head+content *is* the full lexical form.
- **The footgun to name in the spec: head-swallow.** A directive's head-line remainder is carried **unparsed** (§9, MODEL §4). So `|el :x !if cond :y 2` does not give `el` a `:y` — `":y 2"` vanishes into the head string. This is *worse* than the element one-way door (§6.8), where trailing attributes at least parse and land somewhere visible. Same remedy as §6.8's, one sentence: put the outer element's attributes first, or defer the directive to a block line. (Fixing it "properly" — parsing directive heads — is a dialect-era question; don't open it for 0.9.1.)
- **`!else`/`!elif` chains don't survive value position.** Chain semantics are "dialect semantics over *adjacent* directives" (§9). A directive as `:x`'s value has no adjacency slot: a following `!else` at the attribute's column is a fresh attribute-column line (under 2c, more content of `:x` — which *would* restore adjacency inside the attribute's content; a small argument *for* 2c). Without 2c, an `!if`-valued attribute simply can't chain — say so, or leave it to the dialect doc, but don't let anyone discover it in production.
- **Flag interplay:** flag rule 2's re-own list (`|node`, `:next`, …) should name `!name` explicitly: `:a? !if c` → `a?=true`, directive is the element's child. Consistent with the existing rule; zero new machinery.
- "Anywhere an element can" does **not** include list items or bracket interiors (elements can't be there either) — worth one clarifying clause so the phrase isn't read as more than the two real additions (value position; already-legal content/root/attribute-body positions).

---

## 5. Sideways findings (holistic sweep)

1. **§6.7/§6.8 seam, pre-existing:** a line that is itself `:key`, deeper under a *finished* value (Joseph's `:illegal` sits geometrically here — deeper than `:third`, left of `|wonderful`'s interior). §6.8's Error is scoped to "directly under an **open** attribute value"; §6.7's warned extension covers "deeper second value … under a finished key" but its examples are text/nodes, never a `:`-line. Which rule owns `:x <finished value>` ⏎ deeper `:y 1` is genuinely unspecified in 0.9.1 as written. 2c dissolves the seam (it's all content); if 2c doesn't land, this needs one sentence either way.
2. **Deferred single-token typing** (§1.3 above) — unspecified today, independent of 2c.
3. **§6.3's Scalar row omits the bare single-token string** (it lists "quoted string, number, …" while §11.1 makes a lone bare token a String). Cosmetic, but this table is exactly where the directive row is about to be edited — fix both in one touch.
4. **K1 × references:** with stacked `$key`s legal, what does `@x[k]` match — any-of the stack? The selector is frozen (S14) so nothing to design now, but the paths spike should inherit "multi-key elements exist" as an input; a one-line note in CARVEOUTS §PATHS would keep it from being rediscovered.
5. **Brief-framing check (asked for):** the brief called 2c "attribute-as-simplified-element"; the analysis says the honest name is **attribute-content unification** — the *element-ness* (owning rightward on a line, phases, sugar) is exactly what attributes must *not* acquire. Naming it that way in the ruling will prevent the next agent from "simplifying" the sameline scan into the element rule and breaking `:a 1 :b 2`.

---

## 6. Recommended ruling set (if 2c is wanted — my lean: yes, fork A)

1. **K2 (2c core):** Assignment carries ordered heterogeneous content; sameline scan and one-value-per-sameline-declaration discipline unchanged; deferred lines under a key are its content by ordinary column rules. NodeValue/FlowValue collapse into content in MODEL.
2. **K3:** No attributes-on-attributes (fork B rejected); the `:key`-inside-open-content line keeps its anomaly — severity re-justified (Error via restated L6, or demoted to Warning via L0). Named-carrier / anonymous-node idiom remains the reification spelling.
3. **K4:** Namespace grouping, if demanded, is group sugar `:ns/` + deeper keys → flat `/`-joined assignments; not `-`; not (B).
4. **K5:** Plain `:key` with no material = empty content, no Error; four-state table rewritten (Absent / Empty / Nil-explicit / False / True); "required" is schema's.
5. **K6:** Same-line trailing text on a block attribute line keeps a Warning (join hazard); deeper content is warning-free.
6. **K7 (directives):** Directive joins node-value position (`| Directive`, or "Item" under K2); head-swallow and chain caveats stated; flag rule 2 names `!name`.
7. **K8 (identity interior):** the sameline value grammar, restricted to scalar/interpolation (no block forms, no `@`, text-only flow, no framed comments); post-finished-value material = further stacked `$key` (Warning), per K1; EOL behavior unchanged (`$partial-key`).
8. Independent of all the above: close the §6.7/§6.8 seam and the deferred-token-typing sentence (findings 1–2).

*Staying on the line for follow-ups — Joseph's "more thoughts on 3+" welcome while this is all loaded.*

---

# Addendum (same day, post-adjudication) — the Nil model and ATTR-ITEMS

Two follow-ups from Joseph after K2–K5 landed. Read next by Joseph deciding ATTR-ITEMS (and re-settling the Nil question my K5 proposal disturbed).

## A. Absent/Nil/False/True — keep it; and I retract half of K5

**Joseph's grammar worry about implicit-nil is essentially unfounded — but his instinct to keep the model is right anyway, and on reflection I now agree against my own K5.**

*Grammar first.* Implicit-nil creates **no new grammar**. The decision point already exists: §6.2's "nothing indented under it" clause means today's recognizer already waits one line to distinguish `:key`⏎(dedent) from `:key`⏎(deeper body) — the Error fires at exactly the geometry where implicit-nil would emit Nil. Deferred bodies still open identically (they must, or deferred content is unwritable). Streaming, lookahead, the scan: all unchanged. Whatever difficulty implicit-nil has, it isn't grammatical.

*Where implicit-nil actually costs* is semantic, and it's the **sameline mid-scan case**: `|el :a :b 1`. Today `a` gets Error+Nil — which is almost always right, because that input is almost always a deletion or a forgotten value (`:a x :b 1` minus the `x`). Implicit-nil silences exactly the anomaly that catches it: `a=nil, b=1`, no signal, and truncation-shaped edits (a line ending after `:key`) likewise stop announcing themselves. The Error is doing detection work the Warning ladder can't replace.

*And the principled ground for keeping the asymmetry* — this is where my K5 argument was weaker than it looked. K5 reasoned "empty attribute, peer to empty `|el`." But the unification K2 ratified is a **content** unification, not an ontology unification: an element is a *node* — a thing that exists, contentful or not; an attribute is an *edge* — and an edge with no terminus isn't a smaller edge, it's a malformed one. `nil` is the language's explicit "this edge terminates at nothing." So "attributes require a value — write `nil` when you mean nothing" is not premature limiting of the kind 2c cleared out; it's the node/edge distinction doing its job. The differences-from-elements list stays honest and short: *no name/identity/traits, no attributes, and a value is required.*

**Coexistence with K2, stated as model law (one sentence each):**

- **Absent** = no assignment with that key. **Nil** = an assignment whose content is `[Nil]` — written `:key nil`, or produced by the Error path. **Empty content `[]` never legitimately exists**; the bare-`:key` Error case is represented as `[Nil]` + Error (R6's "shape never carries less than the source suggested," unchanged), so no consumer ever meets a third empty-vs-nil state.
- Deferred spelling works for free: `:key` ⏎ deeper `nil` alone → content `[Nil]`, silent — the explicit-nil idiom survives unification untouched (and see §B: this falls out of the first-line rule rather than needing its own clause).
- Flags are untouched and the table gains symmetry rather than losing it: `:a?` bare → true; `:a` bare → Error+Nil; `:a nil` → Nil. Four states, one Error, exactly as before K2.

**Recommendation: require-explicit-nil (keep R6's Error), reject implicit-nil** — not because the grammar can't do it, but because the Error is load-bearing for detection and the edge/node asymmetry justifies the "one more rule."

## B. ATTR-ITEMS — per-item typing without content-sniffing: value position is a *position*, not a per-line mode

Joseph's framing — "attributes are assumed typed scalar until proven otherwise; element bodies assumed prose unless proven otherwise" — is right, but taken as a per-*line* rule it re-imports the exact thing §11.1 exists to forbid: **whether a line types would depend on what it happens to contain.** A prose paragraph whose line `2026` stands alone silently forks an item boundary; re-wrapping prose (any md-press-shaped tool) changes which line stands alone and therefore *retypes the document under whitespace edits*. That is the Norway problem wearing geometry. The coordinator's `\`-opt-out point is real but asymmetric: `\` rescues the author who *notices*; per-line typing injures the author who doesn't — and the injured line contributes no Text, so the damage is also invisible to text-law reconstruction (the value exits the text stream exactly as sameline scalars do, but here from the middle of what the author believed was prose).

**The resolution that needs no sniffing:** the attribute grants exactly **one value-expected position** — its first content token — and that position is *positional*, the same one that already exists sameline. Deferred, it lands on the **first line of the deferred body**, where the ordinary §6.4/§6.5 machinery applies verbatim:

- first line is one self-announcing token alone (`1234`, `"x"`, `[…]`, `<…>`, `!{{…}}`, `true`/`nil` alone) → that token is a **typed first item**; the content base is then established and every subsequent line is ordinary element-style content (prose, structure, comments);
- first line is a bare token followed by more material → **flow commits**, exactly as sameline — the whole body is prose from its first character;
- first line is a block form (`|name`, `!name`, `!:lang:`, fence) → node item, as K2/K7 already give;
- `\` at the first line's start → forced text, the existing opt-out.

Joseph's worked example under this rule: `[1234, "and here is\n  a bunch of prose...\nso what do we do?\n"]` — his reading (a), but **only the first line is ever special**, and it's special for the same reason `:x 1234` sameline is: it sits in value position. A later lone `5678` or `<2026>` line is prose, full stop; an author wanting several typed items uses the existing idioms (stack the key — now warning-free per K3 — or a list). Line re-ordering, re-wrapping, and insertion are all typing-stable everywhere except the one position that was already type-bearing.

**Residual hazard, named honestly:** a genuine prose body whose *first* line is a lone number still types it. This is the same hazard `:x 1234` has carried sameline forever — nobody minds it there because value position is *expected* to type — and the rule's whole content is that deferred bodies inherit that one expectation at that one position. Escape hatches: `\1234`, or quoting, or starting the prose on the key's own line. I would not add a Warning (consistent with the K3 no-warning-for-stacking temperament); a host style advisory is available if evidence of real stumbles arrives.

**The conservative fallback**, if even one positional type-site in deferred bodies feels like too much: rule "typed values are sameline or list items; deferred bodies are content" (my §1.3 Text answer — Joseph's reading (b)). It is simpler to state and maximally sniff-proof, at the cost of the `:port`⏎`5432` surprise and of making `nil`-deferred impossible (which would couple this ruling to §A — a reason to prefer the first-line rule, which keeps A and B independent and both clean).

**Recommendation: the first-line-value-position rule.** It is Joseph's asymmetry made precise — the assumed-scalar posture lives at the attribute's single value position; the assumed-prose posture governs everything after — with zero per-line sniffing and one already-familiar hazard rather than a new class of them.

*(Still on the line.)*
