# Pilot B — restatement gate + workflow feedback

*Cycle one, division = the Part V/VI straddle, four chapters in OUTLINE
order: `typing-and-schema-boundary` (V), `templates-and-dynamics-demand`
(V), `annotation-and-metacognition` (V), `context-economy` (VI). Written
before touching any chapter (the gate); amended after the work where noted.
Pilot A's feedback file is the sibling; where we overlap I defer to it and
add only my distinct vantage rather than restating.*

## Part 1 — the workflow, restated in my own words

A deepening cycle hands each agent a small rolling window (3–5 chapters in
OUTLINE order) and asks for **movement toward truth**, not polish. Success
is any of: a claim verified at source and restated at its honest strength;
a claim *refuted and replaced* (that is the work succeeding); a gap
researched / elicited / named instead of written around; a **seam between
chapters healed**; a capability card whose named costs make a downstream
decision easier; ideation that fires Joseph's memory. A division that comes
back looking finished with none of that has failed the cycle's purpose.
Effort and tokens are false constraints; track state in commits so
interruption loses nothing.

The window is deliberately offset each cycle so every inter-chapter seam
eventually lands in the *interior* of someone's assignment rather than at
everyone's edge. **My division is the first live test of that claim** — it
straddles the Part V→VI boundary on purpose. (Finding: it worked. See F1.)

Order I'm bound to:
1. **Cold read first, before any source.** Fresh eyes are one-shot;
   confusions are reader-evidence, not embarrassments. (Done — Part 3.)
2. Then full author authority *and then some* inside my four chapters:
   pull corpus nuance, run research, elicit de-novo user-voice, verify at
   sources, add/refine capability cards, strengthen ideation.
3. **Direct edits stay inside my four chapters**; everything else travels
   through `notes/` — the edit-isolation that lets pilot A and me run at
   once.
4. Outline-evolution proposals are an **expected output**; a cycle that
   leaves OUTLINE untouched owes a justification sentence.

The discipline with teeth as I hold it: **strengthen before softening** —
when a claim looks overclaimed, first try to make the strong claim true
(verify at source, tighten, find the stronger statement that holds); soften
only after that attempt honestly fails. The seductive failure is the soften
dressed as honesty ("'largest' is too strong, say 'a prominent'") — that
framing carries zero weight on the *direction*; if the substitute is weaker
it's a weakening. A refuted claim is *false* (no honest weakened form):
mark it false in place, find + flag dependents incl. across divisions,
state the no-go in domain voice, delete-and-replace. Labels track truth not
history; don't down-tier a verified result for being new; don't argue with
the past in the body. Interim honesty when a spike can't finish in-window:
`[…claim…]⚑` + a matching working-note entry, text held at aspirational
strength. Coordinator regression guard: corrected truth reads *messier*, so
"the old version reads better" is a signal to check provenance, never to
restore.

The four quality bars (from `../CLAUDE.md`): standalone ownership ·
mental-model-by-degrees (every referent decodable from the page alone) ·
apparatus invisible (reader never learns there was a gathering process) ·
honest registers (derived / evidenced / decided / proposed, each in its own
voice).

**Mid-run addendum absorbed (Joseph, via coordinator):** these are tools
*for me* — I am the end-user this report serves, so my own friction, wishes,
and judgment are first-class evidence, not a documentarian's outside view.
This changed how I worked the annotation and context-economy chapters
especially (I *am* the agent leaving residue and living the budget) — see
Part 4.

## Part 2 — cold-read findings on my division (reader-evidence)

Recorded on first pass, as the intended reader, before opening sources:

- **F1 — the V/VI seam is a real, format-level discontinuity, and my
  division is exactly where it becomes visible.** The three Part V chapters
  (typing, templates, annotation) carry their ideation as `✦`-bullets; the
  Part VI chapter (context-economy) carries it as full `> [!capability]`
  cards. Read straight through in OUTLINE order, the register visibly
  *changes shape* mid-division with no reason a reader could see — the ✦
  chapters read as looser, the card chapter as more rigorous, though they're
  the same *proposed* register. This is precisely the open
  ✦→capability-card retrofit item, and it happens to fall on the Part
  boundary my window straddles. **A reader crossing V→VI would feel the
  seam; an agent working only inside V, or only inside VI, would not.**
  That is the rolling-window claim validating itself on cycle one. (Healed
  — Part 4.)

- **F2 — the frontmatter `status:` field is the old overloaded string on
  all four of my chapters**, mixing genre-count, strength, and maturity
  ("cross-tier-convergent (empirical stress test + …)"). Pilot A has, in the
  same cycle, replaced it in the methods chapter with the three-axis split
  (`register:` + `strength:`, `evidence:` kept as genre). My chapters are
  in-cycle, so they should migrate — and doing so is a cross-division
  convention seam-heal. (Done — Part 4.)

- **F3 — annotation-and-metacognition names a tension it calls unresolvable
  that UDON's ratified design mostly resolves.** Its Honest edges say
  "strippability conflicts mildly with queryability … nothing in the
  evidence resolves it yet," and the body hedges that "`$`-designated
  attributes nearly [have both properties]." Reading it cold I flagged
  *nearly* as suspicious and went to CORE. Finding (verified at
  `spec/CORE.md`, 0.9.0-alpha.2): `$`-designated attributes are ordinary
  attributes (so **queryable by the same path language as content**) that
  the ergonomic `attributes` accessor **excludes by construction** (so
  **strippable by a dumb accessor**) — the `all_attributes` vs `attributes`
  split is *already* a strippable-and-queryable mechanism, ratified for
  identity/traits. So the tension is not fundamental; it is narrower and
  more precise than the chapter claims. This is a strengthen-not-soften
  target verified at source. (Done — Part 4; flagged to Joseph as it touches
  a live-ruling adjacency.)

- **F4 — typing's external anchor overstates the MCP fault result.** It
  says "the largest execution-failure subcategory is schema-serialization
  mismatch." The source (external-landscape finding 7, traced to the primary
  PDF) says Tool-Call/Execution is the largest *fault* subcategory (~15%,
  63/419) and schema-serialization mismatch is a prominent *member* of it —
  and there was a 2-1 verifier vote on the "largest subcategory" granularity.
  Precisification available that is *stronger* (real counts, correct
  attribution), not weaker. (Done — Part 4.)

- **F5 — context-economy's numbers all verify, including a
  deliberately-corrected one.** 5K→250K token inflation ✓; >85% tool-def
  reduction / 30–50-tool accuracy cliff ✓; 2000-line/50KB spill ✓ (honestly
  flagged as JS-family folklore in its own Honest edges); SWE-Pruner ✓. The
  C7 deferred-loading lineage ("one origin + 2–3 rediscoveries, not five
  votes") is a *deliberate prior correction* (RESIDUALS revision log
  B#1/A) — the regression guard applies: the raw digest says "five
  independent teams," which reads cleaner but was corrected away. I left the
  correction standing. No change needed to context-economy's facts; it only
  needed the frontmatter migration and card-field enrichment.

## Part 3 — what I changed (amended post-work)

See the four chapter diffs, `notes/for-OUTLINE.md`, `notes/for-joseph.md`,
`notes/for-<slug>.md` cross-notes, and the de-novo templating testimony
landed at
`01-ideation/02-provenanced/copies/de-novo-testimony/templates-testimony-*.md`.
Headline:

1. **Healed the V/VI seam** — retrofitted the ✦-bullets in the three Part V
   chapters (typing, templates, annotation) to `> [!capability]` cards
   matching the convention pilot A's methods chapter defines, enriching each
   card's *hypothesized-impact* field with named theory quantities (A, ν,
   the reinjection channel, the DL budget, update gain) rather than
   converting mechanically. context-economy already carried cards.
2. **Migrated all four frontmatters** to the three-axis schema
   (`register:` + `strength:` replacing the overloaded `status:`; `evidence:`
   kept as genre bookkeeping), adopting pilot A's exemplar.
3. **Strengthened annotation's strippable-vs-queryable tension** — replaced
   the "fundamental unresolved conflict" framing with the verified narrower
   truth: UDON's ratified designated-attribute accessor split already
   delivers both, and the *real* remaining question is text-level-vanish vs
   view-level-exclude (for the "a stripped document is still valid" bar).
   Taught the accessor mechanism on-page (standalone-ownership).
4. **Precisified typing's MCP anchor** to the correct counts and attribution
   (stronger, not softer).
5. **Applied the tools-for-me reframe** — first-person practitioner voice
   where I am literally the end-user (annotation residue; context budget),
   per the mid-run addendum.
6. **Landed de-novo templating testimony** (cross-substrate, no project
   context) to thicken the report's thinnest demand chapter, and folded its
   genuinely-new directions into the chapter + a counter-register-candidate
   note.

## Part 4 — workflow-document feedback (the doubled pilot deliverable)

Distinct from pilot A's seven points (I've read theirs; strong agreement,
not repeated). From my vantage — the Part-straddling division:

1. **The rolling-window / seam claim is the workflow's central bet, and it
   is *confirmed* on cycle one — but only because my seam happened to be a
   visible one (a format discontinuity).** Recommend the workflow say
   explicitly that seams come in two kinds: **format/register seams** (like
   V/VI's ✦-vs-card — loud, catchable by anyone who reads across the
   boundary) and **substantive/argument seams** (a claim in chapter N that
   silently depends on or contradicts chapter N+1 — quiet, catchable only by
   someone holding both in one head). The window mechanism is *necessary*
   for the second kind and merely *convenient* for the first. Naming the
   distinction would tell a future agent what to actually hunt for at their
   interior boundary, instead of hoping a seam is loud.

2. **"Direct edits stay inside your chapters" collides with cross-cutting
   convention changes — and cycle one hit it twice at once.** Both the
   `status:`→three-axis frontmatter migration *and* the ✦→card retrofit are
   report-wide conventions that must land somewhere first. Pilot A landed the
   *definition* (methods chapter, their division); I landed *four
   applications* (my division) + a carry-forward note. That division of
   labor worked, but it was *emergent*, not designed — nothing in the
   workflow said "the agent whose division contains the convention's
   home defines it; other agents apply it in-division and note the rest."
   Recommend the workflow name this "convention lands as
   definition-in-one-division + application-in-others + a carry-forward
   note" pattern, because *every* cross-cutting machinery change will hit the
   edit-isolation boundary this way. (Pilot A's point 2 is the same
   collision seen from the definition side; this is the application side —
   together they're the whole shape.)

3. **The workflow is rich on when a claim is wrong, near-silent on recording
   a claim that was *checked and held*.** I verified ~a dozen numbers/anchors
   at source this cycle; four of my five cold-read findings were "this holds"
   or "this needs a small precisification," not "this is wrong." Without a
   lightweight verified-at-source record, next cycle re-verifies the same
   numbers. (Pilot A raised this too — I'll second it hard and add: the
   record should note *deliberately-corrected* claims specifically, because
   those are the ones a re-verifier will be tempted to "fix back" toward the
   cleaner-reading original. The C7 five-votes→one-origin correction is the
   exemplar: I only knew not to restore it because the RESIDUALS revision log
   happened to mention it. That's too fragile a channel for the regression
   guard to depend on — the corrected claim itself should carry a
   greppable "corrected-away: X" marker in a source note.)

4. **De-novo testimony is licensed and modeled but its *cost/benefit
   threshold* is unstated.** I ran one (templates — the report's thinnest
   chapter, the clearest case). But "when is a chapter thin enough to
   warrant the apparatus of spawning + provenancing + citing inward" is a
   judgment call the workflow leaves implicit. My working rule, offered for
   the doc: elicit when the chapter's Honest edges already confess
   single-source/zero-implementation thinness *and* the territory is one an
   unprimed agent has genuine first-hand experience of (templating: yes —
   every agent assembles prompts; a UDON-internal ruling: no — no unprimed
   agent has an opinion). Recommend a sentence to that effect.

5. **The cold-read rule is genuinely the best instrument here** — F1, F3,
   and F4 all came from the first straight-through read *before* sources, and
   two of them (the seam, the annotation tension) I would not have seen
   after immersing in CORE and the digests, because immersion supplies the
   missing context that a reader won't have. Keep the cold-read-first rule
   load-bearing; if anything, *strengthen* its phrasing from "read your
   division cold" to "read it cold **in OUTLINE order across your whole
   window in one sitting** — the cross-chapter seam is only visible in the
   transitions, and reading chapter-by-chapter with source-dives between them
   destroys exactly the vantage that catches it."

6. **Strong positive, echoing pilot A:** the strengthen-before-softening
   section earned its length twice in my division — the annotation tension
   (my reflex was to soften "nothing resolves it" to "little resolves it";
   the discipline sent me to CORE and I found the mechanism that mostly
   resolves it — strictly more true *and* more useful) and the typing anchor
   (reflex: hedge "largest" to "a"; discipline: go to the PDF counts and
   state it *more* precisely). Both moves made the report truer by going
   *harder*, not softer. Keep the worked illustration.

## Part 5 — staying on the line

Work landed; committing only files I created or own (my four chapters, this
file, the `notes/` files I authored, the de-novo artifact). Holding context
for follow-ups.
