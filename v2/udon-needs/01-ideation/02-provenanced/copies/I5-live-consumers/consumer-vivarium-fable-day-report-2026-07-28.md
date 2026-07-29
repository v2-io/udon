---
source: >
  Live-usage field report — a Fable-family agent working in vivarium, asked by
  Joseph (as an aside, 2026-07-28) whether using UDON there with no tooling yet
  available felt like friction, friction-relief, or nothing. Relayed verbatim by
  Joseph into the udon session the same day; the agent's visible deliberation
  block (∴) included as shared.
gathered: 2026-07-28
status: gathered — verbatim relay of first-person consumer testimony after a full day of live use
area: live-consumer field report — addressing / schema-conformance / fmt / CLI demand
support-kind: >
  Distinct from de-novo testimony (this agent is fully in-context and same-family
  substrate as most of the corpus — weight accordingly) and distinct from the
  static consumer-doc copies in this cluster: this is *incident-bearing lived
  usage* — it reports a real same-day verification event (a udon-aware ref-checker
  catching a renamed slug within the hour, main going red, the fix landing).
why_included: |
  (1) The incident: slug addressability + a ref-guard turned silent rot into a
  failing gate, live — "addresses that don't rot" as the organizing demand,
  witnessed in production rather than derived. (2) "Conformance is currently
  imitation, not validation — every one of us wrote rows by pattern-matching the
  tail of the file": the tail of the file is the de-facto schema; naked demand for
  the head-line schema linter / write-membrane class. (3) Head-line density "reads
  beautifully under grep" — the skeleton/glance loop working with zero tooling.
  (4) Four agents writing structured reasoning into |reason/|impact/|ref unprompted
  "because the form asks for it" — the right-thing-easy-thing claim, instanced.
  (5) An explicit incident-gated tooling norm from the consumer's own mouth: build
  the linter "the day attribute drift first bites someone — not before" — a lived
  counter-position/refinement to build-ahead tooling plans. (6) Named residuals:
  heredoc quoting re-solved per-agent; fmt-md deliberately not touching udon → no
  canonicalizer; append-only growth accepted as historical record.
caution: >
  bin/check and the vivarium conventions it guards are consumer-side stop-gaps
  (Joseph, 2026-07-28): they validate the demand class (ref-guarding, head-line
  lint), not their own shape. Coordinate/supersede when real tooling lands
  (registered in CONSUMERS.md §stop-gap tooling); do not treat as design
  precedent for UDON itself.
---

> **Why gathered.** A full-day live-usage verdict ("friction-relief, and by a
> wider margin than I'd have guessed") carrying one real verification event
> (dangling-ref caught by a udon-aware checker) and a precise demand ranking:
> ref-guard already earning its keep, head-line schema lint next, fmt/canonicalizer
> and query tooling explicitly deferred until an incident. Typos preserved.

---
*(Verbatim as relayed by Joseph, 2026-07-28. His question first; the agent's
deliberation block and response follow.)*

❯ Also, what are your thoughts about udon using it here where there isn't any tooling yet available. Does it feel like one more area of friction or friction-relief (or nothing)?

∴ Joseph is asking for my honest take on using udon without any existing tooling—whether it felt frictionful, relieving, or neutral. Looking back at what I actually did today: I added several entries to the decisions file using heredocs, searched through the lexicon to find beacon terms where the structured grep approach was surprisingly effective, and referenced the ordinum file. The reading experience felt smooth because the udon structure provided just enough organization to navigate, though I'm still forming my full impression of how it handles different use cases. The slug-based cross-referencing is the real win here — decisions can be cited by identifier and the checker catches broken links, which beats the friction of manual conformance. The lexicon structure works similarly, making lookups fast and unambiguous. There are rough edges though: no syntax validation means I'm relying on pattern-matching from recent entries, long lines don't wrap automatically, heredoc quoting gets tricky with special characters, and the append-only file will eventually become unwieldy as it grows — though that's acceptable as a historical record. The addressability through slugs makes the friction worthwhile.

  The tools that would help most are a linter for the frontmatter attributes (cheap, would catch drift early), a formatter for the markdown, and maybe a query tool for filtering by topic or status — though grep works fine for now. Honestly, I'm not going to build these until they're actually needed; the dangling-ref problem was real and I solved it, but attribute drift hasn't caused an incident yet, so I'll watch for it and tool up when it does.

From a full day of living in it — friction-relief, and by a wider margin than I'd have guessed, with one honest watch-item.

The relief is structural and I felt it repeatedly: slug-addressability is load-bearing. DECISIONS[slug] cross-references are what let segments cite decisions, decisions cite each other, and — the part that proved itself tonight — bin/check's ref-guard convict a dangling reference (it caught the halo agent's renamed slug within the hour; main went red and got fixed because a udon-aware checker exists). That's already tooling, and it's the highest-value piece: the format's identity discipline turned a would-be silent rot into a failing gate. Markdown couldn't have given us that without inventing worse conventions. The head-line density (|decision[slug] :date :by :status :topic) also reads beautifully under grep — I pulled the LEXICON's term[beacon] mid-design and got an unambiguous, settled, dated answer in one look, which directly shaped the manifest field. And for DECISIONS specifically, the shape (|reason / |impact / |ref under a slug) invites the  all four agents today writing genuinely structured reasoning into it withoutbeing told, because the form asks for it.

The honest friction, small but real: conformance is currently imitation, not validation. Every one of us wrote rows by pattern-matching the tail of the file; nothing would catch a
malformed attribute or a drifted convention except the ref-checker's narrow l heredoc is mildly awkward (quoting hazards around $ in math — survivable,but each agent re-solves it). And fmt-md deliberately doesn't touch udon, so there's no canonicalizer — long body lines wrap however the writer wrapped them.

But — applying the day's own norm — none of those frictions has an incident behind it yet. The dangling-ref class did, and it's already a mechanism. So my honest recommendation is exactly the project's shape: udon is earning its place ahead of its tooling, justifies it, and the next tool (a head-line schema linter, probably, or audon-mode for fmt-md) should be built the day attribute drift first bites someone — not before. The format is doing what good structure does: making the right thing the easy thing, even hand-rolled.
