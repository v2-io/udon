---
slug: addressing-is-the-long-pole
type: demand
evidence: [T1, T2, T3]
status: cross-tier-convergent (demand); all syntax questions deliberately open
stage: drafted
consumers: both (udon-primary; feeds the phase-3 paths spike directly)
depends: [schema-guarded-mutation, freshness-and-atomicity]
sources:
  - ../../01-ideation/02-provenanced/commentary/spikes/paths-NOTES.md  # quoted throughout; §§1–4, 8 (D1–D9), 9 (dead ends), 10 (open questions)
  - ../../01-ideation/02-provenanced/commentary/spikes/agent-utility-NOTES.md  # §3 "Addressing is load-bearing", §9 harvest list
  - ../../01-ideation/02-provenanced/syntheses/tier2-invivo-digest.md  # yq match() singleton
  - ../../01-ideation/02-provenanced/copies/I2-scenarios/  # scenario journeys (spelling provisional)
  - ../../../DECISIONS.md  # PATH-1, S14; ../../OPEN.md S3
---

# Addressing is the long pole

**Claim.** Almost every agentic affordance in this report bottoms out on
**stable structural addressing**. The agent-utility spike states the
dependency as a list ([agent-utility-NOTES §3](../../01-ideation/02-provenanced/commentary/spikes/agent-utility-NOTES.md)):

> Almost every agentic affordance bottoms out on **paths**: `at` / `all`
> (exactly one or error vs explicit plural); type-scoped uniqueness
> `(element-name, key)`; references as subset of path syntax; skeleton
> lines that are valid paths; error-as-menu of paths; span-splicing edits
> without canonicalizing whole files. … **agent-utility is blocked on
> paths the way edit is.**

The paths spike, reading the same estate independently the same night,
drew the same consumer map (paths-NOTES §2): in-document `@` references,
schema selectors, skeletons, `at`/`all`/`each` query, the edit tool's
`patch`/`set`/`require`/`move`, cross-file tracing, possibly dialect
envelopes and stream addressability — eight distinct mouths pulling on one
design. A ninth arrived in the pipeline discussion itself: Joseph's
template realization that the natural scope-context for udon templates is
udon documents, "so a lot of the liquid-like directives end up having
path-like syntaxes" — dynamics pulling on paths from a direction nobody
had listed (pipeline-discussion, Joseph's morning turn). Paths were named
the long pole twice independently before that third pull arrived. This
segment carries the demand shape the evidence pins; it deliberately
designs no syntax — that is the phase-3 spike's job, now with an informed
floor.

## What the evidence pins

**1. Relational-first is the observed mental model.** The scenarios
corpus's one-day sample surprised the paths spike (paths-NOTES §1):

> Almost every real query starts with `||` (any depth). Structural
> root-to-leaf navigation is the *secondary* mode. Agents address
> *relationally* — `||element[key]` as type-scoped primary-key lookup —
> with the tree as storage/rendering.

The spike's own caveat travels with it: "That is not a decree; it is a
one-day sample. Worth stress-testing with append-only logs and
prose-heavy docs where keys are unnatural." But it inverts the
XPath-shaped default (root-to-leaf as primary), and a path design that
treats any-depth keyed lookup as an afterthought would be fighting the
observed usage, not serving it.

**2. `at` vs `all` as distinct verbs, with loud failure.** The paths
spike's provisional-demand table closes with its highest-confidence row
(paths-NOTES §8, row D9): *"`at` = exactly one match or error; `all` =
explicit plural — do not overload one API"* — confidence marked "high as
*convention*," meaning the spike considers the two-verb split
convention-grade demand across every query surface, while the exact verb
names stay open. Its dead-ends list independently records the failure
mode a single overloaded verb produces (paths-NOTES §9, dead end 7):

> **Silent empty on miss** — agent tools need loud failure; JSONPath-ish
> empty sets teach the wrong habit for contested claims / CAS.

The connection to the theory segments is direct: a query that returns an
empty set where the agent expected one match is a high-ambiguity
observation (#tools-are-observation-infrastructure) — the agent cannot
distinguish "not present" from "my path is wrong" from "my model of the
document is stale." An error naming which of those happened is the low-A
form of the same information.

**3. Failure vocabulary is part of the language.** Three different
multiplicities can go wrong at an address, and the spike insists they not
share a name (paths-NOTES §3.3):

> Plural-path vs plural-value vs plural-reference want **distinct**
> failure names if the edit tool is to be teachable (scenario draft
> vocabulary: `PathNotUnique` / `PathNotFound` / `ReferencePlural` / …).

Concretely: `at("||user[alice]")` matching two elements
(`PathNotUnique`) is a different bug — with a different repair — from
`:x 1 :x 2` giving a stacked attribute two values under one key (value
multiplicity, legal by CORE's stacking law), which is different again
from a followed reference resolving to several definitions
(`ReferencePlural`). Add staleness (#freshness-and-atomicity) and the
failure vocabulary has four members. Merging any two is the anti-collapse
failure: one error name routing to two different repairs. D5 in the
spike's demand table makes this a Resolution-stage demand at "high"
confidence, sourced from the scenarios: "Fail-loud on unresolvable follow
(`:attr@`); distinguish PathNotFound / PathNotUnique / ReferencePlural."

**4. Embeddability is the binding constraint.** Today, every scenario
path is written as a **quoted string**, because a bare leading `|` or `@`
in value position is a node or reference value, not text (paths-NOTES
§4). The spike sketches three futures — stay quoted forever; a dialect
envelope `<path:||intent[311]:status>` (self-delimiting, aligned with the
W1d self-delimiting lean); or growing bare multi-segment `@`/`|` in value
position with an explicit terminator grammar — and starts, but does not
finish, the hand-table of sameline-scan stress cases that the third
option would have to survive (`:db @config|database[primary] :host x` —
where does the reference end? is `:host` the owner's next attribute or
part of the path?). Its named trap: "inventing a second quoting regime
just for paths … while dialects already own envelopes." The load-bearing
open question is the subset one (paths-NOTES §10, Q2): *what is the
smallest in-document reference subset that is still a true subset of the
tool path language* — because a subset grown by special cases forks
addressing into two dialects, which is the named dead end (§9, dead end
2: growing the selector tuple field-by-field "creates path debt without a
language").

**5. Position-as-data prior art.** The one Tier-2 addressing artifact
that treats *source position* as first-class queryable data: yq's
`match()` returns `{string, offset, length, captures}` and pairs with
line/column operators (tier2-invivo-digest, yq singleton). That is a
query language answering "where, exactly, in bytes?" — the shape the
span-splice edit substrate (#round-trip-and-span-splice) needs from
whatever the paths spike produces. No shipping harness tool otherwise
exposes position as data rather than as error-message prose.

**6. Ruled and standing.** Three ledger facts bound the spike's freedom:
cross-document addressing is **in scope** for path design — Joseph:
"documents in path are definitely in scope" (DECISIONS PATH-1,
overruling the scenarios corpus's document-scope lean, so no tool should
build workflows assuming document-scope is permanent); the reference
selector tuple stays frozen at `(name, key, traits)` with **no
incremental growth** until a path language replaces it wholesale
(DECISIONS S14); and the multiple-keys question (`|phase[9][scribal]` —
does uniqueness become `(type, key-tuple)`? does `@phase[9]` still
match?) is open as OPEN S3 and interacts with typed-key equality, which
the scenarios already exercised (`||intent[42]` ≠ `||intent["0042"]` —
integer and string keys are different keys, used deliberately).

## The spike's demand table, carried whole

The paths spike closed with nine provisional boundary demands ("proposals
only — not decisions… wrong is fine"), here absorbed as the demand floor
(paths-NOTES §8, stage vocabulary theirs — read "Assembly/Resolution" as
product boundaries per the archived-pipeline note in DECISIONS):

| # | Layer | Demand | Who pulls it | Spike's confidence |
|---|-------|--------|--------------|--------------------|
| D1 | Recognition | In-doc `@` stays self-delimiting one-segment until multi-segment embeddability is proven | live consumers, parsers | high as *interim* |
| D2 | Recognition | If multi-segment ever embeds bare, the terminator table must be explicit (value boundary, arrays, brace forms) | path-in-document authors | medium |
| D3 | Assembly | Type-scoped key index suffices for `\|type[key]` / `@type[key]`; order-preserving child lists for structural paths | `at`/`all`, skeleton | high |
| D4 | Assembly | Stacked-attribute access exposes the *assignment list*, not only a host scalar-last view | edit tool, `all(:attr)` | medium |
| D5 | Resolution | Fail-loud on unresolvable follow; distinguish PathNotFound / PathNotUnique / ReferencePlural | agent edit tool | high (from scenarios) |
| D6 | Resolution | Patch paths evaluate against the **pre-patch** tree (CAS composition — one consistent addressing frame per batch) | multi-agent scenarios | high as *tool* law |
| D7 | Wire | Keep the raw-`@` payload until multi-segment or typed structure forces events (aligns ledger W3) | wire suite | medium |
| D8 | Host/tool | Prose/comment/raw-body addressing may stay API-positional in v1 (no path segment for a paragraph) | edit tool | medium |
| D9 | Host/tool | `at` = exactly one match or error; `all` = explicit plural — never one overloaded API | all query surfaces | high as *convention* |

And the embeddability stress cases the spike started (its §4 hand-table,
"incomplete" by its own label) — the concrete shapes any bare multi-segment
future must answer before it exists:

| Written | The question it forces |
|---------|------------------------|
| `:db @config\|database[primary]` | does `\|` end the reference and start a sibling element? |
| `:db @config\|database[primary] :host x` | where does the ref end — is `:host` the owner's next attribute or the path's? |
| `:xs [@a\|b, @c]` | array item boundaries vs path `\|` |
| prose, then `@x\|y` mid-line | reference guards fire only at structure/value sites — never after prose commits |
| `:p "\|config\|db"` | a quoted string is fine today — but it is text, not a structured path on the wire |

## Open questions the spike inherits (the informed floor)

The paths spike's own closing list (paths-NOTES §10 — "the win condition
for this spike is a better question set, not an answer set") is the best
current floor. In brief, with the spike's numbering: (1) is relational
`||type[key]` the primary mental model or an artifact of the one-day
sample; (2) the smallest true-subset question above; (3) where a
multi-segment path terminates in every CORE value context — "needs a
forced table or tiny grammar probe"; (4) whether positional addressing is
ever syntax or stays host-side indexing over ordered `all()` results
(the scenarios never wanted positional access once, and the
positional-vs-identity bracket collision of §3.1 — `[1]` is an *integer
key* by CORE law, which the stale design doc read as positional — is the
sharpest trap in the estate); (5) multi-bracket keys (OPEN S3); (6)
attr-value predicates — host-only forever, or second-class filter syntax
once frequency data exists (the scenario day wanted an attr-value filter
~4 times); (7) suffix flags on path segments ("every `?`-marked process"
has no path today); (8) whether path-*write* sugar (setting `$traits`
should re-emit as `.trait`) belongs in core equivalence, a fmt profile,
or only the edit tool; (9) cross-file paths in-syntax (`file#||x`) vs
out-of-band (`:file` on the operation, as the scenarios do) — now read
under PATH-1's cross-document ruling; (10) when the wire's raw-`@`
interim (DECISIONS W3) must yield to structured reference events — the
spike's counterpressure: "keep tool paths *outside* the recognition
stream … so core wire stays simple until demand is undeniable."

Also inherited: the deliberate-absences table (paths-NOTES §3.6) — no
parent-step `..`, no predicates beyond traits+keys, no globs, no
prose/comment addressing (so no `set` on a paragraph; the spike's D8 row
holds prose addressing API-positional in v1), no suffix-flag filters —
each with the place where edit-tool pressure is expected to return, so
the spike revisits them under pressure rather than re-deriving them as
oversights.

**Who reads this and when:** the phase-3 paths spike takes this segment
plus paths-NOTES whole as its brief-context (the NOTES' §11 pointers —
re-read the adjudication day-in-the-life before inventing syntax;
scenario spellings are provisional, their value is the journeys — stand).
The harness reads pins 2–3 as requirements on any tool that reports
locations to agents, regardless of notation: two verbs, loud failure,
four-way failure vocabulary.

## Honest edges

Everything here except PATH-1/S14 (ruled) rests on a one-day scenario
sample plus design-corpus convergence that shares an author — the
relational-first inversion especially is evidence from a single sitting.
The spike exists precisely because this is a demand map, not a validated
design; frequency claims (the ~4× attr-value-filter count) are one day's
tally, not measurement. The embeddability stress-table is explicitly
unfinished ("without it, subset claims are soft" — paths-NOTES §4), and
this segment inherits that softness wherever it leans on the subset
question.
