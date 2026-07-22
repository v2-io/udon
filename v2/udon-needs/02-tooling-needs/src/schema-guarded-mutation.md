---
slug: schema-guarded-mutation
type: demand
evidence: [T1, T2, T4, T5, T3-adjacent]
status: cross-tier-convergent (the report's strongest demand; 4 tiers direct, T3 via the ease-gradient account)
stage: drafted
consumers: both (udon-primary)
depends: [edit-representation-landscape, errors-that-teach]
sources:
  - ../../01-ideation/02-provenanced/syntheses/CONVERGENCES.md  # clusters 1, 9; singleton yaml-spike
  - ../../01-ideation/02-provenanced/commentary/spikes/agent-utility-NOTES.md  # §2, P-C
  - ../../01-ideation/02-provenanced/syntheses/external-landscape-2026-07.md  # findings 4, 7
  - ../../pipeline-discussion.md  # S1 context; Joseph ~L537
---

# The demand: schema-guarded structural mutation

**Claim.** The clearest single demand in the entire compilation: an edit
surface where an agent mutates a document **structurally** (span-sensitive,
addressed by path, indentation and escaping owned by the tool), with the
mutation **validated inside the write** — no change is accepted that would
make the document violate its declared schema — and refused mutations
returning law-rich, menu-shaped errors. This is precisely what no shipping
tool provides (#edit-representation-landscape: all text-level, no validity
guarantees), and every kind of evidence this report holds asks for it —
design intent, the shipping ecosystem's gap, a measured wound, the formal
theory, and (through the ease-gradient account below) agents' own
testimony.

## The demand, witness by witness

- **The design of record:** Joseph, during the deliberations that
  reoriented the v2 effort (2026-07): "a
  critical tool IMO for agents is a specialized edit tool that makes edits
  very easy without needing to worry about indent-levels for prose or raw
  code blocks, while simultaneously guaranteeing that no mutation that would
  cause the document to now violate the schema is accepted. The tool
  itself will need the machinery to do jq/yq like span-sensitive changes
  to the AST and have it checked against a static schema."
  Convergent T1 stratum: zoetica's semantic-storage design (doc-03: the
  document store validates structure at the write boundary, and its signum
  companion makes the schema declaration part of the document's own
  identity), autopax INSTRUMENTA ("make invalid states unrepresentable"),
  and the agentic-ux principles' write-path rules — validate inside the
  write, not post-hoc; one-call resolution over edit→check→revert loops;
  the file's own declared schema governs ("declared ≠ theater").
- **The shipping ecosystem (the gap, and the near-misses):** the whole
  fuzzy-ladder apparatus is compensation for unguaranteed text edits;
  qwen-code bolts on *post*-edit secret-scanning (guard-after, the weaker
  form); yq demonstrates structural path-assignment without schema guard;
  Obsidian's linter admits its rules don't compose. Nobody has the
  validated-transaction shape.
- **The empirical stress test (the autopax yaml-spike, Dec 2025):** the
  measured cost of guarantee-free mutation. Three agents, adversarial
  protocol: Agent A writes valid data, Agent B introduces a specific
  corruption, Agent C — with 100% context turnover and no human — attempts
  recovery. The six scenarios and their outcomes, absorbed whole
  (yaml-spike RECOVERY_SCENARIOS, verbatim table):

  | Corruption | Recoverable? | Method | Without backup |
  |---|---|---|---|
  | Truncated write (crash mid-write) | ✓ | restore from backup | ✗ failed |
  | Invalid YAML syntax (generation bug) | ✓ | auto-fix heuristic OR backup | ⚠ maybe |
  | Schema violation (valid YAML, wrong shape) | ✓ | backup, after a validation layer catches it | ✗ failed |
  | **Duplicate keys** | ✗ **silent failure** | none — undetectable | ✗ failed |
  | Partial update | ✓ | binary-search salvage OR backup | ⚠ maybe, loses data |
  | Circular reference (anchor misuse) | ✓ | backup, after cycle detection | ✗ failed |

  Headline numbers: **recovery drops from ~100% to 16% (1/6) without
  backup infrastructure** — and the one failure backups don't fix is the
  quiet one. **Duplicate keys parse cleanly**: the parser raises nothing,
  last-value-wins, and the earlier values are silently gone —

  ```yaml
  - id: "task-1"
    name: "Implement feature X"
    status: pending
    name: "Implement feature Y"   # parses fine; X is lost forever
  ```

  "Can agent detect this? NO — YAML parser doesn't warn about duplicates.
  Can agent recover? NO — earlier values are gone forever. Human
  intervention required: YES (to notice data inconsistency)." The spike's
  four resulting requirements are a build-list for compensating
  infrastructure — (1) backup/WAL before every write, (2) a validation
  layer after every read, (3) salvage heuristics, (4) human escalation —
  ~500 lines built around a format that did nothing to help. The demand
  stated from the wound side: every scenario a schema-checking write gate
  refuses at the door is a scenario the next agent never has to recover
  from — and the undetectable one (duplicate keys) is refusable *only*
  at the door, because after the write there is nothing left to detect.
  (UDON's stacking law is the other half of this defense: same-key
  assignments are *kept, in order*, by CORE law — silent last-wins is the
  YAML behavior UDON already refuses.)
- **Lived, adjacent:** Architectus's ease-gradient account — chaining
  unverified str_replace edits was the easiest available path and "broke
  minimal-sapientia 3 times." The tool's own audience asking for the
  verified path to be the easy path — the schema-guarded-mutation question
  in first person.
- **The theory:** schemas convert interpretive observations into pass/fail — the
  low-A move (#tools-are-observation-infrastructure); typed response/write
  boundaries are the W₂ separation mechanism; and refusal atomicity is an
  epistemic requirement (#errors-that-teach).
- **External research:** published tool-failure measurements point at the
  same absence from outside: malformed-call and fabricated-parameter
  failures are attributed to insufficient schema grounding (small models:
  ~68% omission / ~32% malformation — carried with its scope in
  #structured-output-two-mechanisms), and the largest execution-failure
  subcategory in the 2026 MCP fault-taxonomy study is schema-serialization
  mismatch. The outside world keeps rediscovering that ungrounded
  structure is where agent writes break.

## The shape the evidence pins (and what stays open)

Pinned by evidence (the design corpus's build order and its edit-tool
proposal, consistent across sources):

```text
re-resolve path against current file → mutate assembly model
→ syntax-validate → (if schema bound) conformance check
→ span-splice write   — one atomic transaction; refusal mutates nothing
```

with the staged v0 honestly available: syntax-valid + indent-correct +
atomic first, schema conformance next (the design-of-record critical path:
paths → schema → serializer/round-trip+spans → edit v0 → conformance v1).

Open, deliberately (feeds phase-3 spikes): whether the schema is static or
composable/nested — Joseph's own open questions from the source turn:
"can schemas be nested or otherwise composable?… or is the schema
static?" (pipeline-discussion, same morning list as the edit-tool quote);
the path language itself (#addressing-is-the-long-pole); the
inverse/serialization substrate (#round-trip-and-span-splice); and where
guard strictness lives — the soft/hard guarantees dial from the design
corpus (profiles *casual / careful / critical*: same notation, different
enforcement), with the agent edit tool as the **careful** gatekeeper for
writes that flow through agents.

**Who reads this and when:** UDON reads it as the flagship utility its
phase-3/4 decisions must enable (it pulls paths, schema, spans, and
round-trip all at once — which is *why* it's the long-pole customer).
The harness reads it as the write-path contract for any document-shaped
state agents maintain (memory files, tracking docs, AXIOMATA-class
artifacts) — where "schema" may be the harness's own invariants rather than
a UDON schema. Divergence to keep visible: the harness needs this for
*plain-markdown-era* artifacts too; a UDON-only tool leaves its present
corpus unguarded.
