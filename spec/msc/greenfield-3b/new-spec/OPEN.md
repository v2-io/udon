# Open items (after greenfield-3b)

Not blocking for the suite as a language contract draft. Each is intentionally
unfinished rather than silently fixed.

| ID | Topic | Notes |
|----|-------|-------|
| O1 | Layer-1 Markdown subset | layers/markdown.md — enumerate blessed constructs |
| O2 | `doc` Schema vocabulary | Layer 2 element/attr set + versioning |
| O3 | Markdown conversion degradation | Layer 3 policy for non-doc structure |
| O4 | Document pragma syntax | Bind dialects/schema/host-version in-document |
| O5 | Nested envelope routing | Which Dialect evaluates inner `<…>` |
| O6 | `standard-types` Dialect | Rationals, complex, units — spelling inside envelopes |
| O7 | Reference path syntax | Successor to selector tuples |
| O8 | Inline control-flow Dynamics | Not in baseline |
| O9 | Formal grammar | Deferred; Nesting Rule + Guards are prose-precise for now |
| O10 | Conformance fixture suite | Tied to this contract version; multi-line cases per D1 |
| O11 | Float semantic equality | Bit vs decimal spelling — Host profile? |
| O12 | Comment whitespace around `;{…}` | Preserve vs collapse framing spaces |
| O13 | Mixins | Remain experimental Host behavior |
| O14 | Intervals / RRULE / IANA in temporal@1 | temporal.md §10 |

When an open item is closed, record the decision in DECISIONS.md (or a
changelog) and delete or shrink the row here.
