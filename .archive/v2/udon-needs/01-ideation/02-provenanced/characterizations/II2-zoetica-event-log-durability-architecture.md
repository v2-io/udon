---
source: characterization of ~/src/_core/zoetica/docs/refs/event-log-architecture-report.md
  (902-line research report), promoted 2026-07-21 (rebasing pass) from a Part II §2
  dry/witness disposition
gathered: 2026-07-21
status: characterization (report distilled to its harness-relevant architecture, with
  load-bearing verbatim spans quoted). Supersedes the §2 disposition ("event-log
  *infrastructure*, not tool design; and the rest of zoetica/docs/refs/ duplicates the
  ennaos anchor refs"). Verified NOT a duplicate of any ennaos ref (no such file exists
  under ennaos; the ennaos refs are the agentic-coding-background set). Under the Brief's
  full-tooling-surface scope this is harness-consumer prior art on the memory &
  durable-execution axis.
paths:
  - /Users/josephwecker-v2/src/_core/zoetica/docs/refs/event-log-architecture-report.md
source_commit: 6ac3961
categories: [harness, durable-execution, event-log-replay, append-only, self-describing-format, memory-system, content-addressing, hash-chain, cross-consumer-resonance, superseded-disposition]
why_included: >
  The disposition "event-log infrastructure, not tool design" is exactly the notation-scoped
  bar the rebasing pass corrects: append-only event-log architecture IS the mechanism behind
  durable execution and agent memory/persistence — the same family as the promoted geminex
  elixir-otp durable-execution guide (append-only event-history replay as recovery). For the
  harness master thesis this is requirements-grade prior art on how an agent's causal memory
  should be stored to be verifiable, resumable, and durable. It also carries a genuine
  cross-consumer resonance with UDON: its format-selection argument is a durability case for
  human-readable, self-describing text, echoing UDON's own recent text-wire /
  pure-concatenation-reconstruction direction. Only the harness-relevant architecture is
  distilled here; the report's blockchain-anchoring / ML-DSA-signature / century-scale
  entity-continuity apparatus is program-specific (PROPRIUM/CHRONICA) and named, not mined.
---

# Zoetica event-log durability architecture — characterization

A ~902-line research report (in-file timestamps ~2025-10-16), "Storage Architecture Design for Long-Term Immutable Event Logs." Its subject is the durable storage of per-entity causally-ordered append-only event logs. Most of the report is oriented to the PROPRIUM continuity mission (blockchain anchoring, post-quantum signatures, century-scale preservation) — that apparatus is program-specific and out of this compilation's scope. But its **format + durability + verification core is directly the harness consumer's "trustworthy memory / durable execution" prior art**, and is captured below.

## The harness-relevant claims (distilled)

- **Append-only, self-describing, human-readable text is chosen for durability.** JSONL with per-block zstd compression is selected over Parquet/Avro/CBOR specifically because text-based self-describing formats "demonstrate the highest long-term stability… they require no specialized software to interpret and remain human-readable for debugging." Verbatim: *"JSONL with zstd compression emerges as the superior choice for immutable append-only logs requiring century-scale viability. The text-based, line-delimited nature provides universal parsing across any future system while maintaining perfect compatibility with append operations."* (This is the same durability-through-readable-text argument UDON's text-wire work makes — a cross-consumer convergence, single-author so coherence not corroboration.)

- **Each event is a self-contained line carrying its own provenance.** The event shape: `entity_id, sequence, timestamp, prev_hash, data, signature, sig_algorithm`. The self-describing per-event algorithm identifier is what lets the format evolve (old events keep old signatures; new events use new ones; verifiers handle both) — a concrete pattern for **forward/backward-compatible append-only records**, relevant to any agent memory or audit log.

- **Compress in blocks (daily batches), then hash the compressed block** so hash-chain verification survives compression: decompress → validate signatures + chain continuity → recompress. Zstd-9 ≈ 5-6x on structured logs, 3-7x faster decompress than gzip.

- **Per-entity independent causal chains eliminate coordination overhead and enable perfect parallelism** — no cross-writer locking; each entity appends to its own chain. (Directly parallels the multi-writer discipline in the promoted sapientia MULTI_AGENT_COORDINATION — per-agent ownership + append-only — and the zi-am-tur append-collision testimony.)

- **Volume-threshold architectural transitions are named as decision points**, not guessed: 100-500MB/file → rotation; 10-25GB/entity → add DB indexes; 50-100GB/entity → migrate to a time-series DB; frequent cross-entity queries → distributed search. A worked "when does the memory substrate need to change shape" ladder.

- **Verification workflows** (hash-chain verification, probabilistic/sampled auditing, selective disclosure) and **tiered storage** (hot recent / warm / cold archival) round out the "how do you trust and afford long-lived agent memory" surface.

## Report structure (for anyone mining the primary source deeper)

Executive Summary · Format Selection (+ Compression Strategy) · Cloud/Decentralized Storage · Volume Thresholds & Transitions · Hash Chaining & Blockchain Anchoring · Indexing & Query Performance · Audit Verification & Tamper Detection · Long-Term Durability & Preservation (media/format obsolescence, crypto-algorithm migration, geographic distribution) · an "Entity Event Log Format Specification v1.0" · a phased Implementation Roadmap · Cost Projections · "Synthesis: Sovereign Memory Architecture."

## Honest scope note

- Read in full for this characterization; the durable-log architecture is the on-target slice.
- The blockchain-anchoring / Ethereum-gas / Arweave / ML-DSA post-quantum sections are PROPRIUM continuity infrastructure, named here but not treated as agentic-tooling demand.
- Sibling `zoetica/docs/refs/gleam-pubsub-eventlog-report.md` (8.8KB) is the pub/sub delivery side of the same subsystem — more implementation-specific (Gleam pub/sub); its transferable durable-log principle is captured here, so it is re-affirmed as witness (not deep-read this pass), not separately promoted.
