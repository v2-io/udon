# Pipeline — stages (seed)

**Status:** provisional seed (2026-07-21). Stage **names + no-reachback** are stable enough to use; stage **payloads** stay demand-shaped until spikes pull them.  
**Deliberation record:** [pipeline-discussion.md](pipeline-discussion.md).  
**Not law for event spellings** — see DECISIONS W0/W1d and OPEN W1e/ML.

---

## One picture

```text
bytes
  → recognition engines [pushdown | RD]   # same event vocabulary (+ recognition-verdict)
  → event stream
  → assembly → resolution → evaluation    # stages, not a second wire
  → products (document model, resolved model, host artifacts, …)
```

- **One wire vocabulary** for recognition output (no raw-vs-cooked event streams).  
- **Two engines** may emit it; pairing with downstream modes is free.  
- **Fold** is not an architecture noun — at most a harness/reference reconstruction for sufficiency tests.

---

## Stages (names)

| Stage | Rough job | Scope habit |
|-------|-----------|-------------|
| **Recognition** | bytes → events (+ recognition-verdict) | Bounded lookahead; self-delimiting constructs |
| **Assembly** | events → document model (ADM) | Extent/phase-local: text runs, stacking close, ornamental disposition, W1 value extent |
| **Resolution** | document → resolved model | Document-wide or streaming-with-obligations: keys, refs, mixins, dialect *check*, schema verdict |
| **Evaluation** | resolved → host artifacts | Context object, native types, liquid *run*, etc. |

Dialects often split **check** (assembly/resolution, no host context) vs **evaluate** (evaluation).

---

## Products (boundaries)

| Product | After | Holds (sketch) |
|---------|--------|----------------|
| Event stream + recognition-verdict | Recognition | Structure/text/anomaly events; incomplete-input as **verdict**, not event |
| **ADM** (document model) | Assembly | Tree, closed assignments, text runs, anomalies journal |
| Resolved model | Resolution | Policies applied (dup keys, refs, dialects loaded, …) |
| Host artifacts | Evaluation | Native values, rendered templates, … |

**ADM ≠ AST:** ADM is the language contract product; AST is a host encoding. Streaming vs one-shot is **assembly scheduling**, not a different meaning model.

---

## Sufficiency (W0)

At every stage boundary: **no reachback** to an earlier product to decide ownership, values, or text.  
If assembly needs source bytes or re-runs indent analysis, recognition failed sufficiency.

Harness “reference reconstruction” is a tiny audited implementation of recognition→assembly sufficiency — a **test artifact**, not the whole pipeline.

---

## Verdict vs anomaly

| Term | Use |
|------|-----|
| **Anomaly** | Per-construct journal (warning/error records) |
| **Verdict** | Stage-level outcome (e.g. incomplete-input, schema compliance) |

Do not call incomplete-input a wire event (R2/C6).

---

## Ornamental (criterion, not instance list)

**Ornamental** = discretionary geometry/trivia that a double round-trip can drop without changing the model:

```text
strip ornamental → model → emit house-style
  must be model-invariant and idempotent on (model, house-style bytes)
```

- Comments are **not** ornamental (they are model nodes).  
- Column *relationships* (child/sibling/dedent) are mandatory; *how many* spaces beyond minimum step may be ornamental.  
- S6/S9/S18 are instances of this criterion, not a closed taxonomy.

SEMANTICS equivalence layers (byte / recognition / core semantic / host) should eventually align with this; full SEMANTICS doc still to draft.

---

## Demand-shaped payloads

Boundary **contents** (what each product must carry) are filled by callers:

- paths, dialects (selection / value types / directives / embeds), schema, agent utilities, fmt  

Spikes propose **demands**; only DECISIONS move shared contracts. See [PROCESS.md](PROCESS.md).

---

## Related

| Doc | Role |
|-----|------|
| DECISIONS W0, W1d, C5, C6 | What is pinned |
| OPEN ML, W1e, L0 | What waits |
| spikes/paths, spikes/agent-utility | Demand probes |
