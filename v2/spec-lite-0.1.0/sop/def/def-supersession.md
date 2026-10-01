---
kind: definition
awaiting-second: true
awaiting-decision: false
needs-work: false
terms: [supersedes, superseded-by, revised, invalidated, alternate, whole, partial]
per: [sop-decisions-follow-template]
depends: [def:decision]
---

# supersedes · superseded-by · revised · invalidated · alternate · whole · partial

*When a ⟦decision⟧ is reopened and settled differently, a new decision ⟦supersedes⟧ the old one, which is marked ⟦superseded-by⟧ it. Each supersession has a type, ⟦revised⟧, ⟦invalidated⟧ or ⟦alternate⟧, and a scope, ⟦whole⟧ or ⟦partial⟧.*

## Terms

- **supersedes:** on the newer ⟦decision⟧, a list of `{adr: slug, how: …, scope: …}` naming the decisions it replaces. `how:` is the supersession's type (why the old decision stopped answering), and `scope:` is how much of it stopped.
- **superseded-by:** on the older ⟦decision⟧, the same shape, pointing forward.
- **revised:** the same decision, updated. The question and intent are unchanged; the answer moved.
- **invalidated:** the old decision stopped being right, because an ⟦assumption⟧ broke or it was shown wrong.
- **alternate:** a sibling choice held alongside the old one, for example a different choice per profile. Neither replaces the other everywhere.
- **whole:** all of the old decision is superseded.
- **partial:** only named parts of the old decision are superseded. A partial supersession names which parts.

## Invariants

- The old decision's outcome is never edited.
- Only chains of ⟦revised⟧ resolve to a single current decision. ⟦invalidated⟧ and ⟦alternate⟧ do not chain.
- The superseding decision carries what changed. It is never argued from the old decision's authority.
- Every ⟦supersedes⟧ entry has a matching ⟦superseded-by⟧ entry on the other record. A pair that doesn't match is a finding.

## Examples

- An ADR ruling that `<…>` ends at the first `>` is later replaced by one ruling that it ends at the matching `>`, because nested boxes turned out to be needed: ⟦revised⟧, ⟦whole⟧.
- An ADR whose recorded assumption ("no lite document needs `>` inside `<…>`") broke: ⟦invalidated⟧.

## Working notes

- Source: verisectorium RC1 `06-EDGES` (supersedes, typed as revised-by / invalidated-by / alternate-of, whole or partial, and which types chain), itself adopted from provenance-standards practice. It is carried here in plainer spelling.
- The examples are illustrative only. Neither reflects a decision anyone has made.
- **Basis.** The fields come from the decision template Joseph asked for ("supersedes, superseded by, etc.", when he supplied the MADR template), adopted for both decision sets by [[decision:sop-decisions-follow-template]]. This entry used to cite [[decision:kind-change-is-dissolution]], which uses the `invalidated` type but does not define supersession, so it is no longer in `per`. No decision adopts RC1's typing itself; that is still open.
- **Scope is open.** These terms are defined for ⟦decision⟧s, but [[conv:kind-change]] applies `invalidated` to records of any kind (`was:` as provenance). Either this entry widens to records, or kind-change names its relation differently.
