# Impact radius of each DP1 branch

*Classification fork, spike a, 2026-10-22. Firmness is from each card's own text (checked by reading it this session). "Unchanged in effect" means the card's Statement still holds as written; its examples or notes may need a line.*

| Card (firmness) | C0 | Cv (as carded) | Cc + S-JSON | B + S-JSON |
|---|---|---|---|---|
| [[rule:unquoted-run-is-one-value]] (lean) | Implications drop the view | as is | Statement 2 kept; add the class clause; the view becomes the class plus the data reading | Statement 2 reversed ("whatever it spells" no longer holds) |
| [[rule:nil-spelling]] (decided) | **changes**: nil is `<nil>`/`<>`; the warning points there | default-dependent | unchanged in effect | unchanged |
| [[rule:missing-value]] (decided) | **message changes** | default-dependent | unchanged | unchanged |
| [[rule:key-holds-a-value]] (decided) | unchanged; `[3]` a text | default-dependent | unchanged; add that identity is by spelling | needs numeric equality for keys |
| [[rule:list-items-whitespace-separated]] | unchanged; items texts | default-dependent | unchanged; items classified | items numbers |
| [[rule:inline-comments]] (decided) gotcha | `:height 7 ; px` is text too | as carded | as carded (`#integer` vs no class) | as carded |
| [[rule:leftover-values]] (decided) | unchanged | unchanged | unchanged | unchanged |
| [[rule:value-line-escapes]] (proposed) | loses its "escape a leading digit" reason | same | same (quote instead) | keeps it |
| [[rule:opaque-span-raw-text]] (provisional) | `<…>` must carry every primitive | `<…>` optional for primitives | `<…>` optional for primitives (the `<…>` fork decides its role) | same |
| [[rule:tree-transcript]] (proposed) | texts only | must show raw tree vs view | shows the class as an attachment | shows kind with spelling |
| [[def:text]], [[def:typed-value]], [[def:value]], [[def:reading-option]] (all provisional, unreviewed) | typed-value's "implicit" set empties | reading-option keeps the view | typed-value's "implicit" becomes "a text with a class"; reading-option loses the view | def:text must exclude classified runs |
| `rule:bare-typing` (gap) | becomes "what `<…>` may hold" | same | becomes "what a bare run may be classified as": S-JSON and its edges | the bare set |
| `rule:repeated-attributes` (gap) | spelling identity | spelling identity | spelling identity | value identity, to define |
| [[obj:represent-structured-data]] (objective, no force) | Statement 2 strains ("kind decided by how it is written" only inside `<…>`) | depends | holds | holds |
| [[expl:data-mappings]] (companion, unwritten) | maps texts to strings | must name the view | **gets the data reading and the byte-for-byte number copy** | maps kinds |

**Totals:** C0 changes two decided cards; Cc changes no decided card's Statement and one lean card by a clause; B reverses a lean card's Statement and needs a numeric-equality rule nobody has written. Cv changes nothing now and leaves every "default-dependent" cell open.
