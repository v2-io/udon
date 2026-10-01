---
kind: definition
awaiting-second: true
awaiting-decision: false
needs-work: false
terms: [kind, objective, requirement, non-objective, principle, fitness, definition, rule, property, fixture, question, explanation]
per: [kind-in-frontmatter, directories-organizational, fixtures-are-records, kind-change-is-dissolution, proxy-before-threshold, force-levels-four, force-critical-is-ctq]
depends: [def:record]
---

# kind · objective · requirement · non-objective · principle · fitness · definition · rule · property · fixture · question · explanation

*A ⟦record⟧'s ⟦kind⟧ is what it does, and kinds are told apart by how they fail and what repairs them. This entry defines the spec store's kinds; the SOP store's own kinds are in [[def:sop-kinds]], and ⟦decision⟧, a kind in both stores, is in [[def:decision]].*

## Terms

- **kind:** what a ⟦record⟧ does, individuated by how it fails and what repairs it. It is declared in frontmatter (`kind:`). The slug prefix and the home directory are clues only.
- **objective** (usually kept in `obj/`): a decided property lite must have. It is either met or not, and it carries a ⟦force⟧. It fails when the ⟦rule⟧s don't meet it, when it conflicts with another objective, or when it stops being wanted. It is repaired by fixing the rules, or by Joseph revising the objective, which re-examines everything citing it.
- **requirement:** an ⟦objective⟧ with ⟦force⟧ `required` or `critical`. This is the only spelling; there is no `req` alias.
- **non-objective:** an ⟦objective⟧ with ⟦force⟧ `non`: something lite deliberately does not try to do. It fails when the excluded thing creeps back in. It is repaired by removing that thing again, or by revising the non-objective.
- **principle** (usually kept in `obj/`): a direction, and the tie-breaker a ⟦decision⟧ cites when several alternatives all meet the ⟦objective⟧s. It fails when ignored, when applied inconsistently, or when the choices it favors keep needing reversal. It is repaired by revision.
- **fitness** (usually `obj/`; *possible, not yet admitted*): a scalar that is optimized rather than met, measured through a concrete proxy, in service of a ⟦principle⟧ (⟦serves⟧).
  - It fails when the proxy stops tracking what it stands for. That is Goodhart's law: once the measure becomes a target, the number can move without the thing moving.
  - It also fails when the measure becomes unavailable, or when its era changes.
  - It is repaired by validating the proxy against cases whose answer is known, by re-measuring in the new era, or by replacing the proxy.
  - It carries a truth-apt claim of its own, "this measure tracks this principle", and that claim needs evidence.
  - How it combines with a principle and an ⟦objective⟧, and the two guards that apply to it, are in [[conv:purpose-layer]].
- **definition** (usually `def/`): a term-group. It fails by being ill-defined for some input, by being used inconsistently, or by colliding with an existing term. It is repaired by restating it, fixing the uses, or citing the existing term instead.
- **rule** (usually `src/`): normative text in RFC 2119 language. It fails by being ambiguous, by leaving a case unsettled, by contradicting another rule, or by breaking an ⟦objective⟧. It is repaired by amending the text (with a new ⟦decision⟧ if the choice itself changes) and by adding the case that pins it.
- **property** (usually `src/`): a derived claim about the rule set, such as determinacy, forward-stability, or which spellings are equivalent. It fails by counterexample or by a broken derivation. It is repaired by narrowing the claim or fixing the ⟦rule⟧. If the claim falls, a no-go replaces it.
- **fixture** (usually `dat/`): a file of cases, each an input with its expected tree and anomalies, at file grain. No ⟦outline⟧ lists fixtures. ⟦rule⟧s cite them through ⟦test-fixtures⟧, and prose can transclude single cases. A fixture fails by disagreeing with the rules, by going stale when a ⟦decision⟧ flips, or by disagreeing with a parser. It is repaired by re-deriving it from the rule, or by fixing whichever side is wrong.
- **question** (*possible, not yet admitted*; the pre-design questions are in `.int/pre-design/` meanwhile): an open design question with its alternatives. It fails by being lost, by being re-asked after it was answered, or by being routed to the wrong ⟦closer⟧. It is repaired by routing it and closing it.
- **explanation** (usually `src/`, or a marked section inside a ⟦rule⟧): teaching prose. It fails by mis-teaching, by saying more than the rule it describes, or by going stale. It is repaired by a reader test and a check against the rule.

## Invariants

- Two things are separate ⟦kind⟧s exactly when they go wrong differently and are fixed differently. A new kind is admitted only by exhibiting a thing that fails and is repaired differently from every kind already declared.
- The kinds that exist in a store are the ones its `.vsect/kinds.yaml` declares. The kinds map, not any ⟦outline⟧, is what says what the corpus is.
- Only ⟦rule⟧s and ⟦objective⟧s carry RFC 2119 normative words in the spec store; the capitals appear nowhere else there. That is separate from the ⟦force⟧ field, which objective-level kinds carry: objectives always, principles and fitness where they have one ([[decision:force-critical-is-ctq]]).
- A ⟦decision⟧ never makes a ⟦property⟧ true, and a good ⟦explanation⟧ is never evidence for a rule.
- A ⟦record⟧'s kind never changes. What looks like a change of kind is a dissolution of the old record and the emergence of a new one (see [[conv:kind-change]]).
- ⟦force⟧ is a field, not a set of kinds. Objectives, ⟦requirement⟧s, and ⟦non-objective⟧s fail and are repaired the same way, so separate kinds would fuse kind with severity.

## Discussion
- The admission rule comes from verisectorium RC1 `01-SPINE` and `02-RECORD-OBJECT-MODEL`.
- Considered as kinds, and folded into existing ones because they fail and are repaired the same way:
  - a *lean* is a ⟦decision⟧ with ⟦status⟧ `proposed`;
  - a *grammar production* is the formal statement inside a ⟦rule⟧;
  - an *anomaly* is a rule in the anomaly ⟦layer⟧.

## Working notes

- These kinds are this corpus's first cut (proposed 2026-09-30) and have not yet been tested against many ⟦record⟧s.
- The weakest admission is ⟦principle⟧ vs ⟦objective⟧. If principles keep reading as objectives, merge them.
- **An open-question kind is the udon team's to decide.** Joseph expects them to want one, and intends to vote for a `wut/` directory (`sop/influx/jaw-proposal-and-feedback.md` §1.10). Until they decide, ⟦question⟧ stays unadmitted, and the spec store's kinds file does not declare it.
