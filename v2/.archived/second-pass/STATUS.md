# v2-spec — STATUS

**Owner mode:** agents drive; steward only for STEWARD gates.  
**Front door for every session.**

> ## After context compaction (read first)
>
> **Do not trust the compacted conversation summary as ground truth.** Compaction is lossy — it invents clean narratives, drops open forks, and confuses DECISIONS with proposals. Treat the chat remainder as *hints only*.
>
> **Reorient from disk every time you resume after compaction (or any cold start):**
>
> 1. **This file** (`STATUS.md`) — phase, queue, need-Joseph list  
> 2. **[PROCESS.md](PROCESS.md)** — agent-primary rules; meta channel  
> 3. **[DECISIONS.md](DECISIONS.md)** + **[OPEN.md](OPEN.md)** — present law vs live questions  
> 4. **[README.md](README.md)** — suite map / read order  
> 5. Only then continue work — prefer STATUS “Own next” over memory of the prior turn  
>
> For *why* something was decided: **session vault** + memory search, not the compaction blurb. Primary sources over summaries is non-negotiable here.

| | |
|--|--|
| **Phase** | **Suite spine usable** — SPEC/WIRE/ADM/GLOSSARY/PIPELINE seeded; residual OPEN short |
| **Version** | **0.10.0** |
| **Law** | [DECISIONS.md](DECISIONS.md) · [OPEN.md](OPEN.md) |
| **Read order** | DECISIONS → GLOSSARY/ADM → SPEC → WIRE → PIPELINE |
| **History** | [spikes/session-vault/](spikes/session-vault/) (+ memory mirror) |
| **Demands** | [spikes/DEMANDS.md](spikes/DEMANDS.md) · paths · agent-utility |

---

## Done (this program day)

- Process agent-primary + meta channel  
- Session vault (Grok exports + Claude extracts) + search index  
- Thin DECISIONS (charter, CARRY, L0/L1/L2/L4/L5/L6/L7, W0/W1d, C6, packaging, …)  
- Short OPEN (ML, S3, S4, S12, W1e)  
- SPEC · WIRE · ADM · GLOSSARY · GRAMMAR · PIPELINE · SEMANTICS · pedagogy outline  
- Spikes: paths, agent-utility  
- [ORACLE-DELTAS.md](ORACLE-DELTAS.md) for differential work  
- [OPEN-ML-STRAWMEN.md](OPEN-ML-STRAWMEN.md) evidence only  
- [FIXTURES.md](FIXTURES.md) + [fixtures/](fixtures/) (deduped corpus + [INDEX.md](fixtures/INDEX.md))  
- [WARNING-CODES.md](WARNING-CODES.md) sketch (**W4**)  
- SPEC ownership mini-examples; compaction reorient banner  
- OPEN demand-harvest “Already absorbed” map  


---

## Own next (no steward required)

1. ~~Fixture design notes~~ → [FIXTURES.md](FIXTURES.md)  
2. ~~Promote probes to YAML~~ → [fixtures/](fixtures/) (**no harness**)  
3. ~~**Dedup**~~ → single incomplete + ownership + closed_law; smoke/happy split clean  
4. ~~Harvest absorption map~~ → OPEN “Already absorbed” (no new pins)  
5. ~~Naming forks Structure Position / Line Scan~~ → DECISIONS **N-pos** / **N-scan**  
6. ~~GLOSSARY/SPEC stale pins + S11/L7 closed_law~~ (this turn)  
7. **ML/S3** only with demand evidence  
8. Optional: commit when Joseph wants git durability  
9. **Harness path:** [HARNESS.md](HARNESS.md) + [fixtures/lint_corpus.py](fixtures/lint_corpus.py) (lint green) → later Rust `adm`+`result` runner  
10. Do **not** thrash fixtures; do **not** treat “idle-worthy polish” as “wait for Joseph”

## Need Joseph

- **S4** only if prose-only indent warning blocks work  
- **Overturn** of any CARRY  
- Process veto  

---

## Handoff

**2026-07-21 (parked for night):** Scheduler loop **stopped**. Suite spine + fixtures + lint green; residual idle-worthy. Git still largely uncommitted. Thanks for the runway.

**Next operator:** Reorient from this file (banner). Prefer harness/`adm` path or demand-backed ML/S3 — not fixture thrash. No waiting on Joseph unless S4/Overturn.

**After compaction:** ignore the summary’s confidence. Re-run this file’s top banner before trusting any “we already decided X” claim from chat.
