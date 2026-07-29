# type-algebra — an algebraic type system over UDON's data model

**Status: spike, 2026-07-29.** Commissioned by Joseph in-session: take the underlying model seriously — `|elements[keys].traits`, attributes as an ordered-stacking hash whose values may themselves be nodes, children as an ordered heterogeneous array — and drive toward an algebraic type system supporting a schema shorthand ("one of these elements, keyed, with at least this attribute, holding any of these children"), with $\{n,m\}$ arities, landing firm no-gos wherever UDON's honest nuances make the algebra break. Register: **derived-here** claims are marked as such and use only standard machinery, at argument grade unless stated; **cited-known** results are external theory, all *training recall — verify before external citation*; **measured** claims ran through the current parser this session (PINS CURRENT PARSER). Deaths stay visible per spike register. Nothing here closes any carve-out; the shorthand is a dialect candidate, and every spelling in it parses under today's grammar unchanged.

---

## 0. Conclusions

1. **The algebra exists, and UDON's model is unusually good at hosting one.** The type system is a two-sorted regular system — content types are regular hedge languages (the XDuce/RELAX NG lineage), attribute types are **row types whose fields are per-key stack languages** — and subtyping is decidable across the whole shorthand fragment (§5, R2). The two sorts *are* the whose-name-is-it test, typed: rows type edges, hedges type nodes.
2. **Joseph's "ordered-stacking-hash" is a precise algebraic object**: the attribute section quotiented by cross-key commutation is exactly the **free partially commutative (trace) monoid** whose independence relation is "different key," which — because the dependence classes are the per-key cliques — is isomorphic to the **direct product of per-key free monoids**. The stacking-hash is that product's normal form; per-key order survives the quotient, cross-key interleaving is exactly what dies (§2, R1, derived-here from standard trace-monoid facts).
3. **The shorthand works and costs zero grammar change** (measured): element suffixes `! ? * +` carry their CORE §5.4-intended Kleene readings as arities, `{n,m}` rides as tail text, `[key!]` as identity value, `.open`/`.closed` as the row tail. The exemplar (`decision-record.schema.udon`) parses today with the envelope interim warning as its only anomaly.
4. **One spelling is foreclosed, and the collision is load-bearing, not stylistic** (measured): `?` cannot mark optional *attributes* because core flag semantics re-owns the would-be type token into **content**, silently ending the attribute phase and poisoning every later attribute with `AttributeAfterChildren`. An O14-class instance — a core-layer decision constraining the dialect's spelling space — but this one is a real semantic collision, not spelling incumbency; the dialect must route around it (unmarked = optional). §7.
5. **Three no-gos landed, each with its reason on the page** (§6): **N1** — no canonical schema is extractable from a corpus: the least generalization is the corpus itself, and every *proper* generalization requires a bias choice with incomparable alternatives (Gold's theorem gives the hard floor). This converts the fiat strata's P1 from principle to theorem-backed. **N2** — interleaving *ordered sub-patterns* with numeric constraints hits the known complexity cliff (EXPSPACE-hard inclusion); the tractable fence is Parikh-style counting over child *types*, which is all the asked-for shorthand needs. **N3** — *mixed* cross-key order sensitivity (some key pairs ordered, others not) lands in general trace-language territory; decidable but heavy, and no simple shorthand survives there. The principled fence: rows are order-blind across keys by default, `ordered` opt-in flips the whole row, nothing in between.
6. **The fiat strata land as exactly three seats the algebra forces** (§8): the row tail (`.open` observed-complete vs `.closed` declared-closed), the generalization bias in extraction (N1), and the order election (strict vs commuted). The algebra cannot fill any of the three from data — a formal restatement of "observation predicts, only fiat commits."
7. **Difference types give the migration machinery for free** (§8): O4's coexistence window is the union type $\tau_{\text{new}} \cup \tau_{\text{old}}$; O7's census is counting inhabitants of $\tau_{\text{old}} \setminus \tau_{\text{new}}$; both are first-class citizens because the algebra is boolean-closed.

---

## 1. The substrate, restated as algebra

From MODEL.md (normative), with sugar already desugared — identity, traits, and flag suffixes are ordinary assignments to designated keys, so the model is *only* this:

$$\mathsf{El} \;=\; \mathsf{Name}_\bot \times \mathsf{Assign}^{*} \times \mathsf{Node}^{*} \qquad \mathsf{Assign} \;=\; K \times \mathsf{Val}$$

$$\mathsf{Val} \;=\; \mathsf{Scalar} \;\cup\; \mathsf{Ref} \;\cup\; \mathsf{Interp} \;\cup\; \underbrace{(\mathsf{El} \cup \mathsf{Verbatim})}_{\text{node values}} \;\cup\; \mathsf{Flow}$$

$$\mathsf{Node} \;=\; \mathsf{El} \cup \mathsf{Text} \cup \mathsf{Comment} \cup \mathsf{Verbatim} \cup \mathsf{Directive} \cup \mathsf{Ref} \cup \mathsf{Blank}$$

Two facts govern everything downstream. **(a)** Both an element's attribute section and its content are *sequences* — but the model semantics the estate actually relies on treats them differently: content order is content (SEMANTICS §2.8), while cross-key assignment order is "preserved; rarely semantic" (README, whose-name table) and the one measured order-signature in the wild was adjudicated almost-certainly-incidental (extraction probe, 91/121). **(b)** The sorts are mutually recursive through *two* doors: elements appear in content (children) and in values (node-valued attributes). Any type system here is a two-sorted $\mu$-regular system or it is not faithful.

## 2. The attribute half: the trace quotient and row types

**R1 (derived-here; the machinery is standard trace-monoid theory — cited-known, Mazurkiewicz/Diekert, training recall).** Let the attribute alphabet be $\Sigma_A = K \times \mathsf{Val}$ and impose the independence relation $I = \{((k,v),(k',v')) \mid k \neq k'\}$. The quotient $\mathbb{M}(\Sigma_A, I)$ is the free partially commutative monoid in which same-key letters never commute and different-key letters always do. Because the dependence classes are exactly the per-key cliques, this monoid is isomorphic to the direct product of per-key free monoids:

$$\mathbb{M}(\Sigma_A, I) \;\cong\; \prod_{k \in K} \mathsf{Val}^{*}$$

The right-hand side *is* the ordered-stacking-hash: a map from keys to ordered stacks. The quotient map from source order forgets cross-key interleaving and **nothing else** — per-key order (the stack) survives intact. So the informal object the estate has been calling "attributes are an ordered-stacking hash" is the normal form of a named algebraic construction, and the two candidate semantics for attribute typing are the two sides of this quotient:

- **strict** (word semantics): types denote subsets of $\Sigma_A^{*}$ — cross-key order is typed;
- **commuted** (trace semantics, *the proposed default*): types denote subsets of $\prod_k \mathsf{Val}^{*}$ — cross-key order is conformance-invisible.

Choosing commuted-by-default does **not** touch SEMANTICS §2.8 (reordering stays core-inequivalent; no document is rewritten): a schema is a judge, and a judge may be coarser than identity. It chooses which differences the *verdict* is sensitive to — menu, not knob.

**Row types.** The natural type former over the commuted side is a row (cited-known lineage: Wand/Rémy row polymorphism, training recall) whose fields are *stack types*:

$$R \;::=\; \{\, k_1 : \sigma_1,\; \ldots,\; k_n : \sigma_n \;;\; \varrho \,\} \qquad \varrho \in \{\mathbf{open}, \mathbf{closed}\}$$

where each $\sigma_i$ is a regular expression over value types describing that key's stack, with the arity shorthand $\tau\{n,m\}$ ($n$ to $m$ stacked assignments of type $\tau$; $\tau\{n,{*}\}$ unbounded above). Denotation: $\hat w \models R$ iff every declared key's stack is in its $\sigma_i$, and — if closed — every undeclared key's stack is empty. Notes that fall out for free:

- **Absent ≠ nil** stays typed apart with no machinery: absence is the empty stack; nil is a letter. CORE §11.4's four states are the algebra's four denotationally distinct cases.
- **Stacking ≠ list** is preserved by construction: `:x 1 :x 2` inhabits $\{x : \mathrm{int}\{2,2\}\}$; `:x [1 2]` inhabits $\{x : [\mathrm{int}^{*}]\{1,1\}\}$. Their denotations are disjoint. Any algebra defined over the *ergonomic view* (which collapses them) is unsound as a schema semantics — the view is an abstraction; judgments must run on the substrate (this is SEMANTICS §3's serializer rule, arriving as a soundness condition).
- **Designated keys are just fields**: keyed-ness is $\{\$key : v\{1,1\}\}$; the `$partial-key` fail-safe composes as a row constraint ($\$partial\text{-}key : \bot\{0,0\}$ in keyed types — a partial-keyed record simply fails to inhabit, it is not "rejected"); trait-possession ("has `.canon`") is the regular containment $\Sigma^{*}\,\mathrm{canon}\,\Sigma^{*}$ on the `$traits` stack — still regular, no special trait machinery needed.

## 3. The content half: hedges, Parikh, and what "any of these children" means

Content is a word over node types. Erase `Comment` and `Blank` first via the ornamentation projection (they are carried, never typed — CORE §7.4 already defines this layer); `Text` is **not** erased — prose is content. Two content-type formers cover the demand:

- **Ordered**: a regular expression over $\{\tau_1, \ldots, \mathrm{TEXT}, \mathrm{VERBATIM}, \ldots\}$ — the RELAX NG/XDuce hedge-language half (cited-known, training recall). Mixed prose is the standard idiom $(\mathrm{TEXT} \mid \tau)^{*}$.
- **Unordered-with-arity** — Joseph's "can hold any of these children": $\&\{\tau_1\{n_1,m_1\}, \ldots, \tau_j\{n_j,m_j\}\}$, whose semantics is deliberately **Parikh-level**: a constraint on the *count vector* of child types (a Presburger-definable set), order-free. This is where the tractable fence goes — see N2 for why it must not be "shuffle of ordered sub-patterns."

The recursion (children contain elements; values contain elements) closes as a two-sorted system of $\mu$-equations; documents are finite trees, so inductive semantics suffices and regularity is preserved (cited-known: multi-sorted regular tree languages, training recall; the closest single prior art for *this exact* ordered+counting combination is Dal Zilio–Lugiez's sheaves automata for XML, training recall).

## 4. The type language, assembled

$$\tau \;::=\; \mathsf{el}\big(\eta,\; R,\; C\big) \qquad \eta \subseteq \mathsf{Name} \cup \{\bot_{\text{anon}}\} \;\text{ or } \top$$

$$\sigma \;::=\; \text{regexp over } v \qquad v \;::=\; \mathrm{str} \mid \mathrm{int} \mid \mathrm{float} \mid \mathrm{bool} \mid \mathrm{nil} \mid [\,c^{*}\,] \mid \langle d{:}t \rangle \mid \tau \mid \mathrm{ref}(\eta?, v?, T) \mid \mathrm{flow}\langle S \rangle \mid \mathrm{interp}$$

$$C \;::=\; \text{regexp over node types} \;\mid\; \&\{\tau_i\{n_i,m_i\}\} \;\mid\; C \cup C \;\mid\; C \cap C$$

with element types usable as value types (node values), $\mathrm{flow}\langle S \rangle$ constraining at most the *alphabet* of inline forms permitted in prose (see N4), envelopes typed by their label ladder with opaque bodies, references typed as inert selector shapes (resolution-aware typing is corpus-layer, deliberately out — same layering as CORE §12.3), and interpolations as typed holes (see the boundary note in §6).

**Subtyping** is semantic inclusion of denotations. Types are closed under union, intersection, and — on the regular halves — complement, so **difference types exist**: $\tau \setminus \tau'$ is a type. The lattice is distributive with $\bot$/$\top$.

## 5. Results

- **R1** (§2): the stacking-hash is the trace-monoid quotient $\cong$ product of per-key free monoids. *Derived-here on standard machinery; I'd call it exact at the level of "this is that object."*
- **R2 — decidability of subtyping for the shorthand fragment** (derived-here, argument grade): per-key stack inclusion is regular-language inclusion; row subtyping is the standard width/depth discipline plus $\{n,m\} \sqsubseteq \{n',m'\} \iff n' \leq n \wedge m \leq m'$; ordered-content inclusion is hedge-language inclusion; Parikh-content inclusion is Presburger entailment. For the *shorthand fragment* — conjunctions of per-key constraints, no unions across row fields — checking is componentwise. For full boolean combinations, componentwise fails ($\{a{:}\mathrm{int}, b{:}\mathrm{str}\} \cup \{a{:}\mathrm{str}, b{:}\mathrm{int}\}$ is strictly below $\{a{:}\mathrm{int}{\cup}\mathrm{str}, b{:}\mathrm{str}{\cup}\mathrm{int}\}$), but decidability survives via a **normal-form encoding**: stably sort the assignment word by key (stability preserves per-key order — exactly the information the quotient keeps) and the commuted row problem becomes an ordinary regular hedge problem. One fence around the encoding: it is the *checker's internal* form; a serializer that emitted it would violate SEMANTICS §3 (never reorder). The checker may commute in its head; nobody may commute the document.
- **R3 — verdicts compose with keep-everything** (derived-here, easy but worth stating): because recognition is total and anomalies never suppress content, the judge always receives a model; a warned extension is just a longer stack and types under the same row; the natural verdict is the pair (membership, anomaly-set) — the non-invasive-judge position acquires its algebra, and "conformant modulo anomalies" is expressible rather than hand-waved.
- **R4 — the four-bounds unification reaches its fourth site** (observation): $\{1,1\}/\{0,1\}/\{0,{*}\}/\{1,{*}\}$ as `! ? * +` here are the same axis already living in the suffix sugar's designed readings (CORE §5.4), the paths arity bounds (synopsis §3), and schema cardinality — now also as the exponents of the type algebra. One axis, four sites, and this site is the one that makes the other three *compose* (bounds multiply through nesting; the weaker bound wins through composition, as the paths section conjectured).

## 6. No-gos and boundaries, deaths visible

**N1 — No canonical extracted schema (the Gold floor).** *Derived-here framing; the underlying theorem cited-known (Gold 1967, training recall).* Within this algebra, a corpus's *least* type always exists — it is the corpus's own finite language, the type that has learned nothing. Every properly general schema requires choosing a generalization operator, and the choices are incomparable: from stacks observed $(a)$ and $(a\,b)$, the arity-hull gives $\mathrm{str}\{1,2\}$, the value-exact closure gives $\{a,\; a\,b\}$, a prefix-bias gives $a\,b?$ — none is least among the proper generalizations, and Gold's theorem guarantees no positive-example procedure identifies the "true" regular language in general. **Consequence:** extraction can emit observed-complete rows and observed hulls only; the bias *is* the fiat, and the fiat strata's P1 ("observation can predict closure; only fiat commits it") is now theorem-backed rather than principled. An honest extractor should *name its bias* in its output.

**N2 — The interleave cliff.** Shuffle of *ordered sub-patterns* with numeric constraints — "children match $(\tau_1 \tau_2)\{2,3\}$ interleaved with $\tau_3^{*}$" — has EXPSPACE-hard inclusion (cited-known: Mayer–Stockmeyer on interleaving, training recall) and is the documented reason XML Schema shackled `xs:all` and RELAX NG restricted `interleave` (training recall). The fence that keeps everything above decidable-and-cheap: unordered content constraints are **Parikh only** — counts over child types, no ordered sub-patterns inside an interleave. The asked-for shorthand ("any of these children, with arities") lives entirely inside the fence. Crossing it is not impossible; it is a priced door with the field's two warning signs nailed to it.

**N3 — Mixed cross-key order sensitivity.** A row where *some* key pairs are order-relevant and others are not leaves the product-of-free-monoids world for general trace languages, where recognizability requires genuinely heavy machinery (cited-known: Zielonka's asynchronous automata, training recall) and no shorthand-sized subtyping story survives. The principled fence: order sensitivity is a **whole-row election** — commuted by default, `ordered` opt-in for the rare genuinely-sequential attribute section — never per-key-pair. (This is also the P4-honest choice: the one measured cross-key order signature in the estate was incidental-become-conventional; making per-pair order cheap to declare would invite typing the incidental.)

**N4 — Prose order is not typeable, by the format's own law.** A schema constraining the *order* of segments inside flow would be typing text, and text is opaque to the core (CORE §7.1); the algebra's honest reach into flow is alphabet restriction and counts ($\mathrm{flow}\langle S \rangle$, Parikh at most). This is a no-go by design intent rather than mathematics, and it should stay one — it is the type-level face of the text law.

**N5 — Dynamics punch typed holes (boundary, not no-go).** An interpolation in value or identity position (`|div[!{{id}}]`, ruled S5) makes membership in a keyed type **host-relative**: static recognition-layer typing cannot decide it. The honest structure is stratified verdicts — recognition-typed (static, with interp-holes marked) vs post-evaluation-typed — and the hole is itself informative (it is where the expectation register's "expected type" annotation naturally rides). Not a defect of the algebra; a true fact about a language with a dynamics tier.

**The measured collision (N6, small but real).** `?` on attribute keys is core flag semantics; used as an optionality marker it doesn't just misparse — it *re-owns the type token into content*, ends the attribute phase, and every subsequent attribute of that element draws `AttributeAfterChildren` (measured this session; the exemplar's comment block preserves the trace). O14's category, with teeth: here the incumbent grammar decision genuinely forecloses a spelling, and the dialect routes around it (unmarked = optional) rather than asking core to move — because the flag rule is load-bearing for real flags, not spelling incumbency.

## 7. The shorthand (measured; PINS CURRENT PARSER, 2026-07-29)

See [`decision-record.schema.udon`](decision-record.schema.udon) — parses today, sole anomaly the expected `NoDialectsLoaded` on the envelope. The spelling table, every row checked:

| Schema meaning | Spelling | What core parses it as (today) |
|---|---|---|
| arity on child type | `\|ref{0,7}` | element `ref`, tail text `{0,7}` — dialect reads the tail |
| required / optional / star / plus | `\|reason!` `\|impact?` `\|ref*` `\|step+` | `$!`/`$?`/`$*`/`$+` = true — the §5.4-intended Kleene readings, live |
| keyed, required | `\|decision+[key!]` | `$key` = string `"key!"` |
| row tail | `.open` / `.closed` | `$traits` entry; `.closed` should carry `:reason` (the fiat seat) |
| required attribute | `:date! <temporal>` | ordinary key named `date!` — `!` is dialect-free real estate on keys |
| optional attribute | `:confidence float` | unmarked = $\{0,1\}$ (the N6 collision forces this default) |
| stack arity | `:supersedes str{0,2}` | value = bare string `str{0,2}` — dialect splits token/arity |

Zero grammar change, which is the P2–P4 pattern from the evening's synthesis holding at the type layer: the *format* already carries the spellings; the type system is a consumer.

## 8. Where fiat enters, and what the algebra buys the schema program

The algebra localizes exactly three places data cannot fill — the fiat strata, formally seated: **(1) the row tail** — extraction can only ever emit `.open` (observed-complete); `.closed` is an act, and the shorthand gives it a seat that carries its reason; **(2) the generalization bias** (N1) — every extractor output is corpus + bias, and the bias is a declaration; **(3) the order election** (N3) — commuted vs `ordered` is a judgment about which differences matter, unrecoverable from any corpus that happens to be consistently ordered (P4's incidental-order lesson is the *reason* the default is commuted).

And boolean closure buys the governance machinery directly: **migration** is the union type $\tau_{\text{new}} \cup \tau_{\text{old}}$ (O4's coexistence window as a type, not a convention); **census** is counting inhabitants of the difference type $\tau_{\text{old}} \setminus \tau_{\text{new}}$ (O7's burn-down as model-checking); **anomaly classes** are types too, so "what conforms to nothing declared" is a computable set rather than a vibe. The judge, the census, and the migration window are one algebra wearing three verbs.

## Prior art (all training recall — verify against primaries before any external citation)

Regular expression types / hedge automata: Hosoya–Pierce (XDuce), Benzaken–Castagna–Frisch (CDuce), RELAX NG (Clark–Murata). Ordered+counting combination: Dal Zilio–Lugiez, sheaves automata (RTA 2003). Rows: Wand 1987, Rémy 1989. Trace monoids: Mazurkiewicz; Diekert–Rozenberg (Book of Traces); Zielonka's asynchronous automata. Interleave complexity: Mayer–Stockmeyer 1994. Inference floor: Gold 1967 (identification in the limit). Parikh/semilinear: Parikh 1966. The XSD `xs:all` and RELAX NG interleave restrictions as field precedent for N2's fence.

## Working Notes

*(X4 sidecar.)* Three things I would push next, none done here: (a) a tiny reference checker over the shorthand fragment (the algebra says it is a few hundred lines: per-key regex + count vectors + name dispatch), run against vivarium's ledger as its first live corpus — this would also produce the O12 register schema's substrate; (b) the `ordered` row election needs one real customer before it earns its spelling — I could not name a genuinely order-across-keys attribute section in the estate; if none exists, ship commuted-only and let demand reopen it; (c) subtyping between `ref` selector types and the future path language (contravariance questions) was deliberately left atomic here — it belongs to the paths design, and typing it now would be exactly the tuple-growth S14 froze. One honest deflation: nothing in §2–§5 is mathematically deep — the contribution, if any, is the *fit* (which objects, which quotient, which fences) and the three fiat seats falling out where the estate's own strata predicted them. The convergence pleased me, which is precisely why it deserves a hostile second reader (single-author caution: the strata and this algebra now share an author).
