---
slug: schema-guarded-mutation
type: demand
evidence: [T1, T2, T4, T5, T3-adjacent]
status: cross-tier-convergent (the report's strongest demand; 4 tiers direct, T3 via the ease-gradient account)
stage: drafted
consumers: both (udon-primary)
depends: [edit-representation-landscape, errors-that-teach]
sources:
  - ../01-ideation/02-provenanced/syntheses/CONVERGENCES.md  # clusters 1, 9; singleton yaml-spike
  - ../01-ideation/02-provenanced/commentary/spikes/agent-utility-NOTES.md  # §2, P-C
  - ../01-ideation/02-provenanced/syntheses/external-landscape-2026-07.md  # findings 4, 7
  - ../01-ideation/pipeline-discussion.md context (S1; Joseph ~L537)
---

# The demand: schema-guarded structural mutation

**Claim.** The clearest single demand in the entire compilation: an edit
surface where an agent mutates a document **structurally** (span-sensitive,
addressed by path, indentation and escaping owned by the tool), with the
mutation **validated inside the write** — no change is accepted that would
make the document violate its declared schema — and refused mutations
returning law-rich, menu-shaped errors. This is precisely what no shipping
tool provides (#edit-representation-landscape: all text-level, no validity
guarantees), and four tiers ask for it directly — with the lived-testimony
tier asking for it *by name* through the ease-gradient account below.

## The demand, tier by tier

- **T1 (design of record):** Joseph, pipeline-discussion (~L537): "a
  critical tool IMO for agents is a specialized edit tool that makes edits
  very easy without needing to worry about indent-levels for prose or raw
  code blocks, while simultaneously guaranteeing that no mutation that would
  cause the document to now violate the schema is accepted… jq/yq-like
  span-sensitive changes to the AST checked against a static schema."
  Convergent T1 stratum: zoetica doc-03/signum, autopax INSTRUMENTA ("make
  invalid states unrepresentable"), the agentic-ux principles (validate
  inside the write, not post-hoc; one-call resolution over
  edit→check→revert loops).
- **T2 (the gap + the near-misses):** the shipping ecosystem's whole
  fuzzy-ladder apparatus is compensation for unguaranteed text edits;
  qwen-code bolts on *post*-edit secret-scanning (guard-after, the weaker
  form); yq demonstrates structural path-assignment without schema guard;
  Obsidian's linter admits its rules don't compose. Nobody has the
  validated-transaction shape.
- **T2 (empirical stress test — the autopax yaml-spike, Dec 2025):** the
  measured cost of guarantee-free mutation. Three agents, adversarial
  protocol: Agent A writes valid data, Agent B introduces a specific
  corruption, Agent C — with 100% context turnover and no human — attempts
  recovery. Across six corruption scenarios, recovery was **100% with
  backup infrastructure and 16% (1/6) without**. The worst case wasn't the
  loud one: **duplicate keys parse cleanly**, the YAML parser raises
  nothing, and the earlier values are silently gone —

  ```yaml
  - id: "task-1"
    name: "Implement feature X"
    status: pending
    name: "Implement feature Y"   # parses fine; X is lost forever
  ```

  — unrecoverable *and undetectable* by the next agent ("file looks valid,
  no errors, but data is wrong"). The spike's own conclusion is this
  segment's demand stated from the wound side: the format did nothing, so
  ~500 lines of backup/validation/salvage infrastructure had to be built
  around it — and the one failure that infrastructure still can't catch is
  exactly the one a schema-checking write gate refuses at the door.
- **T3 (lived, adjacent):** Architectus's ease-gradient account — chaining
  unverified str_replace edits was the easiest available path and "broke
  minimal-sapientia 3 times." The tool's own audience asking for the
  verified path to be the easy path — the schema-guarded-mutation question
  in first person.
- **T4:** schemas convert interpretive observations into pass/fail — the
  low-A move (#tools-are-observation-infrastructure); typed response/write
  boundaries are the W₂ separation mechanism; and refusal atomicity is an
  epistemic requirement (#errors-that-teach).
- **T5:** malformed-call and fabricated-parameter failures are attributed to
  insufficient schema grounding; the MCP fault taxonomy's largest execution
  subcategory is schema-serialization mismatch. External practice is
  discovering the same absence.

## The shape the evidence pins (and what stays open)

Pinned by evidence (T1 build-order + agent-utility P-C, consistent across
sources):

```text
re-resolve path against current file → mutate assembly model
→ syntax-validate → (if schema bound) conformance check
→ span-splice write   — one atomic transaction; refusal mutates nothing
```

with the staged v0 honestly available: syntax-valid + indent-correct +
atomic first, schema conformance next (the T1 critical path: paths → schema
→ serializer/round-trip+spans → edit v0 → conformance v1).

Open, deliberately (feeds phase-3 spikes): whether the schema is static or
composable/nested (S8); the path language itself
(#addressing-is-the-long-pole); the inverse/serialization substrate
(#round-trip-and-span-splice); and where guard strictness lives (the
soft/hard casual/careful/critical dial — same notation, different
enforcement — with the agent edit tool as the *careful* gatekeeper).

**Who reads this and when:** UDON reads it as the flagship utility its
phase-3/4 decisions must enable (it pulls paths, schema, spans, and
round-trip all at once — which is *why* it's the long-pole customer).
The harness reads it as the write-path contract for any document-shaped
state agents maintain (memory files, tracking docs, AXIOMATA-class
artifacts) — where "schema" may be the harness's own invariants rather than
a UDON schema. Divergence to keep visible: the harness needs this for
*plain-markdown-era* artifacts too; a UDON-only tool leaves its present
corpus unguarded.
