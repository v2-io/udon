# Decision brief — value-dialect architecture (open decision 2)

**Spike S2b** · drafted 2026-07-11 · status: **awaiting Joseph's call**
Sources verified for this brief: REVIEW-JULY-2026.md §3.1/§4-d3/§7-A/§7-F,
REBOOT-PLAN.md Phase 1, spec/TIME-SPEC.md, spec/FULL-SPEC.md §Value Types,
core/generator/values.desc, core/udon-core/tests/fixtures/temporal.yaml, and
a fresh grep of the four live consumer documents (paths below).

## The question

Freeze the core value grammar (strings / numbers / booleans / nil / lists) and
route exotic bare-pattern types through declared **value-dialects**, with
temporal (TIME-SPEC's six types: Date, YearMonth, Time, DateTime, Duration,
RelativeTime) as the first instance. Sub-questions: default-on or opt-in?
pragma shape? pragma-less semantics? interaction with the temporal-validation
defect (#3)?

## Context, compressed

- **The hazard is real but so far hypothetical.** Concern §3.1: every typed
  bare-pattern added silently retypes existing documents (`2025-12` was a
  product code; now it's a YearMonth). The live corpus already carries
  retype-bait: `PROCESS-MAP-v0.udon` has `:version 0.0.1` and
  `:status first-pass` — bare strings a future "semver" or "enum" bare-pattern
  would silently capture. Governance problem wearing syntax clothes.
- **What live documents actually use** (fresh grep, 2026-07-11): across
  `~/src/archema-io/vivarium/LEXICON.udon` (20 date attrs: `:since`,
  `:seeded`, `:restructured`), `vivarium/doc/PROCESS.udon` (1),
  `asf/msc/meta-process-review-2026-07-07/PROCESS-MAP-v0.udon` (1
  `:created`), `~/src/autopax/taxonomy.udon` (7: `:date`, `:updated`) —
  **~29 temporal values, every one a full `YYYY-MM-DD` Date, zero** durations,
  times, datetimes, relative times, or YearMonths. No document carries any
  pragma. And **no code consumes typed events yet** (vivarium has no cargo
  dependency on udon-core as of this writing). Migration cost today is
  document-meaning, not code.
- **Implementation state.** Temporal recognition is *interleaved into the
  value state machine* (values.desc: `:num_sign` branches into relative-time
  states; `+30d` vs `+30` disambiguation shares number states). Ripping it out
  of the parser is invasive; gating it is cheap. TIME-SPEC's validation layer
  (leading-zero, week-mixing, fractional-placement warnings) is entirely
  unimplemented — the 49-case audit's divergences are all there, none in
  recognition (review §4 defect 3; `temporal.yaml:565` records the deferral;
  `YearMonth` appears nowhere in values.desc — `YYYY-MM` mis-emits `Date`).

## The architectural insight the options share

Split **recognition** (surface shape, frozen, in the generated deterministic
machine) from **typing** (semantic assignment, in the tree/host projection
layer). The parser always recognizes temporal-shaped tokens and emits its
typed event; whether that event *projects* as `Date` or as plain string is the
dialect's call, made at tree-build time. This is CTQ-A's own sentence — "core
parses surfaces; dialects/hosts assign semantics" — applied to values. It
keeps one machine (generator-verified determinism intact), and it defines how
*future* value-dialects work without touching the parser at all: they
pattern-match String/BareValue events at the projection layer (a semver
dialect can retype `0.0.1` post-hoc; the surface grammar never moves again).
The freeze, precisely stated: **no new bare patterns ever enter the generated
machine; core version bump required if that rule is ever broken.**

## Options

| | A — temporal stays core | B — default-on std dialect | C — opt-in dialect |
|---|---|---|---|
| Frozen core includes | strings/numbers/bool/nil/lists **+ temporal** | strings/numbers/bool/nil/lists | same as B |
| Pragma-less doc: `2026-07-07` | Date | **Date** (std profile assumed) | string |
| Can exclude temporal? | no (quote everything) | yes: pragma opt-out | n/a (default off) |
| Live-doc migration | none | **none** | all 4 docs need a pragma line, or silently change meaning |
| Accretion valve | fiat only ("no more, we promise") | structural: temporal is *named and versioned*, the last grammar resident; future types are projection-layer | same as B |
| Defect #3 home | parser or ad-hoc layer | dialect validation module | same as B |
| Boilerplate | none | none until you need pinning | one line per doc, forever |

**A** answers the accretion concern with discipline instead of architecture —
the same discipline that produced the type-space we're worried about. It also
leaves the validation layer homeless (in-machine warnings are why it was
deferred: encoding week-mixing rules in .desc states is miserable, and the
fixture DSL has no Warning support). Weakest option.

**C** is maximally pure and maximally surprising: every live document's dates
silently become strings, TIME-SPEC's examples all break as written, every
config-shaped document pays a pragma tax, and — the sharper point — the
failure is *silent in the common direction*. An agent authoring
`:created 2026-07-11` cold from the cheatsheet gets a string and no signal.
Least-surprise cuts both ways, but the corpus says which way it cuts more:
29 real dates vs zero observed retype victims.

**B** keeps pragma-less documents meaning what their authors meant, while
giving the pragma three jobs: **pin** (`!udon :core 1 :dialects [temporal@1]`
freezes semantics against future std-profile drift), **exclude**
(`:dialects []` → strict core, `2026-07-07` is a string), **extend** (declared
schema/dialects retype at projection, per schema-exploration piece 12). The
`2025-12`-was-my-product-code author has three exits: quote it, exclude the
dialect, or let the linter flag retype-prone bare strings (a rule worth having
under every option).

## Interaction with defect #3 — why the dialect boundary makes it cheaper

The validation work is needed regardless (TIME-SPEC's host contract — "we
know it's valid" — is the promise the typed events currently break:
`Duration("P1W2D")` is emitted today). Inside a dialect boundary it becomes a
small hand-written Rust module at projection time: input = recognized event +
raw string; output = validated typed value, or downgrade-to-string + Warning.
That is (a) plain code over a validated-shape string instead of state-machine
surgery in .desc, (b) a natural home for Warning events without touching the
event-fixture DSL, (c) versioned with the dialect (`temporal@1`), and (d) the
same module is the `as_date()` coercion API's backend (CTQ-C). The YearMonth
mis-emission gets fixed here too (projection maps `Date` events of `YYYY-MM`
shape to YearMonth — no parser change). All five audit divergences land in
one module with one owner.

## Recommendation

**Option B — temporal as a default-on std value-dialect**, with the
recognition/typing split above, pragma-less = std profile.

Honest uncertainty, three items:

1. **Shorthand durations are the weakest members of the std-on set.**
   `:size 5m` (megabytes? minutes?), `:len 30s` — these collide with informal
   quantity notation in a way `2026-07-07` never will. The corpus shows zero
   live uses of them, so there's a real case for splitting std into
   `temporal` (ISO forms: Date/YearMonth/Time/DateTime/ISO-Duration) and
   `temporal-shorthand` (`30s`/`5m`/`+30d`), with only the former default-on.
   Weak lean: keep them together for config-idiom value and let the linter
   catch quantity-collisions — but this is genuinely arguable and cheap to
   split later only if it's decided *before* the dialect names ship.
2. **The frozen-core boundary needs explicit enumeration.** FULL-SPEC's value
   table already includes Rational (`1/3r`), Complex (`3+4i`, `5i`), hex/
   octal/binary — exotic bare-patterns by any honest reading (`5i` is one
   character from a duration shape). Grandfather them into frozen core, or
   give them the same dialect treatment? Lean: grandfather (they're in the
   machine, unambiguous, and cheap), but the freeze declaration should name
   the table exactly rather than gesture at "numbers."
3. **Pragma syntax needs its own small design round** — this brief assumes a
   first-line `!udon` directive (CTQ-A row 2: dialects + host-interpreter +
   reserved core-version slot), consistent with the `!dialect` sketch. Open
   questions 11–13 of design/udon-schema-exploration.md apply; the value-
   dialect answer to Q12 (scoping) should be **document-level only** — subtree
   -scoped *value typing* would make `grep`-grade tooling lie. Subtree-scoped
   *interpretation* dialects (piece 12's `archema/resource` lens) are a
   different axis and stay possible; the pragma design should name the two
   kinds apart.

Confidence: high on B-over-C (corpus + zero-code-consumers makes this nearly
free now and expensive later), high on B-over-A (validation-layer home +
structural valve), medium on sub-questions 1–2.

## Concrete next action

1. Joseph ratifies: B / C / A, and sub-calls on shorthand-split (rec: together)
   and frozen-core enumeration (rec: grandfather, name the table).
2. Then, in order: (i) minimal pragma spec — one page in spec/, `!udon` first
   line, core-version slot + `:dialects` list (unblocks decision-row "Pragma"
   in CTQ-A too); (ii) recast TIME-SPEC's header as "the `temporal@1` value-
   dialect, std profile, default-on" — content otherwise stands; (iii) U4's
   temporal-validation work lands as the projection-layer dialect module
   (closes defect #3 incl. YearMonth, adds Warning events, backs `as_date()`);
   (iv) linter rule: retype-prone bare strings + quantity-collision hints.
3. No live-document migration needed under B. If C is chosen instead, add the
   pragma line to the four live docs in the same commit that ships the default.
