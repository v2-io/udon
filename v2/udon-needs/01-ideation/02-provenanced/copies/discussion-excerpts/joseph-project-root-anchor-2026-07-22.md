---
source: Joseph Wecker, steward channel of the 2026-07-22 coordination session
  (relayed verbatim by the coordinating Fable session during the tooling-report
  anthology pass)
gathered: 2026-07-22
status: gathered source material — steward demand statement, primary voice
area: addressing / path design — anchor kinds
why_included: >
  A concrete first-person demand for a fourth path-anchor kind beyond
  relative / absolute / home: a project-root anchor. Names a candidate
  sigil (¤), the use case that generates the demand (other-file inclusion),
  and the claim that the corpus holds more such discussion than the
  ideation pass captured.
---

# Joseph on project-root anchoring (2026-07-22)

Verbatim, from the steward channel:

> There *is* a tremendous amount of path stuff to discuss once it's
> properly scoped. For example, a notation for 'project-root' instead of
> just home and relative and absolute (filesystem root). I would love to
> be able to do '¤/tests/fixtures' from any file in the project and have
> it know '¤' is project root, for example. It comes up all the time in
> other-file inclusion etc.… all stuff that's been discussed a lot in the
> corpus that may or may not have been captured in the ideation pass yet.

Follow-up in the same channel, upgrading the item from wish to shipped
in-estate practice:

> synaptic and sapientia used a ⊤ for project root in many of the scripts
> used to include other files instead of relative, so that files could
> move around and have one static search+replace to make everywhere
> error-free with the new location.

**Verified against the files** (2026-07-22, grep of `~/src/_core/`): 86
files in synaptic carry ⊤; `synaptic/lexicon.md:10` defines "**⊤** →
Project Root"; `synaptic/build-entities` documents and implements `@⊤/`
resolution via the git repository root ("Project root symbol (⊤) resolves
via git for each file"; "Clear error when ⊤ used outside git repo",
dispatch at line 185); entity files use it for cross-file includes
(`@⊤/entities/zi-am-tur.md`, `@⊤/tst/tst-distilled`, …). September-2025
era, load-bearing in entity assembly. Joseph's memory was the lead; the
files are the evidence.

Context: offered while reading the rewritten addressing chapter of the
tooling report, immediately after ruling that cross-document scope was a
confirmation of the obvious. The demand slots into the anchor-kind
category space (relative / absolute / home / document-root /
**project-root**), with other-file inclusion as the generating use case
and **address stability under file relocation** as the recorded
rationale: a moved file breaks every relative path in and to it, while
root-anchored paths survive the move and repair globally with one
mechanical search-and-replace. Note the internal convergence: ⊤ (shipped,
synaptic/sapientia), the `@⊥/` root-import sigil (identity-files work,
already in this corpus), and the ¤ wish above are three sigil precedents
for the same auxiliary-anchor slot. His closing clause is also a standing
pointer: the corpus likely holds further path discussion not yet landed
as provenanced artifacts.
