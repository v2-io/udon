# working-notes CHANGELOG — spec-0.10.00

Append-only, informal. What changed in the suite and why, so nothing needs pick-axing out of git.

## 2026-08-10 — K15/K16 fold-in + breadcrumb strip (coordinator, per jaw)

**Fold-in (the suite now states these natively):**

- **K16** — CORE §5.3 (identity bracket = full value grammar; the brace-form carve the rewrite had leaned into is *rejected* — "a key is a value slot"; block-forms-out and bare-`@`-out held lightly, with `@{key}` the reference spelling and the longhand `:$key` route for complex keys), §6.4 (clean → **value-expected position**, everywhere — list items, key brackets, deferred first line; the per-context unruled table deleted), §6.5, §11.5 (inline-element items + host projection note + ML edge), §12.2 (`@{key}`); MODEL §4 List comment; GLOSSARY (Value-expected position entry replaces Clean value position; List entry); SEMANTICS item 5 wording. **Resolves Q2** (see UNIF-PASS-QUESTIONS marker).
- **K15** — CORE §6.7 rewritten as "a label names a collection" (jaw's worked example verbatim; default read; ornamentation/flavor rule); MODEL §3.2 default-collection-read + flavor-annotation rows; SEMANTICS §2 item 4 rewritten from prohibition ("≠, ever") to mechanism (contributions compare as written; read-coincidence is a view fact); GLOSSARY Stacking entry reframed as collection-spreading.

**Breadcrumb strip (the "cruft" pass):** all in-body `(ruled Kn/Ln/Sn/Rn)` parentheticals removed — DELTAS' K-series table is now the sole in-suite map from text to ruling IDs; DECISIONS holds the rulings. The transitional version-note + known-lag banner in CORE collapsed to four lines. Q-flags shortened to `working-notes` pointers (Q7, Q8 remain open).

**Joseph-verbatim quotes moved out of spec body** (preserved here; the spec paraphrases):

- §6.4 (K9/space-as-separator): "the current spec is the hack — the tell is the space. The new clean model is `:$main [|{embed-1}, |{embed-2}]` period — no space, no implication of being in a text block."
- §6.4 (K10): "non-quoted text values are now strictly distinct from prose and are just like quoted text except end with a space + valid block-start."
- §6.7 (K11): "no more warning now that multi-value attributes are the fresh new thing."
- §6.9 (K14): "A warning is issued, but still becomes an attribute of 'element'."
- §6.10 (host AST knob): "it's an attribute on the wire, and depends on the parser parameters to decide how you want it in the AST."
- §9 (K3): "we specifically don't want directives to do anything yet — just get emitted as-is so we can experiment."
- §6.2 (K12): the implicit-true default "wasn't/isn't worth the awkwardness."
- K16 ground: "|{x} is not block-form. I don't know why you would carve out extra grammar for 'kind of almost values' in a place that was specifically meant to encapsulate a value."

**Register notes preserved:** block-forms-out-of-brackets and bare-`@`-out/`@{key}`-only are *lightly held* ("'I'm OK with' means I am OK with it — not that I think it should be law — I'm ok going either way").

Still open in the suite text: Q7 (envelope-ladder name), Q8 (attached escape under an open value), SEMANTICS item 9's core-equivalence lean for assignment/content interleaving, the suffix-sugar keep/retire option, and the D-sheet items in ../../msc/for-joseph/.
