# 0.10 fixture harness design (not implemented)

**Status:** design only — no Rust yet. Live gate remains `core/fixtures/v0.9/` (**C4**).  
**Law:** [FIXTURES.md](FIXTURES.md), [DECISIONS.md](DECISIONS.md) **C5**/**C6**/**D-pack**/**W0**.

---

## Goal

Run `v2-spec/fixtures/{idiomatic,comprehensive}/**/*.yaml` and assert:

1. **`result`** (recognition-verdict) when present  
2. **`adm`** slice when present (preferred for idiomatic/comprehensive meaning)  
3. **`anomalies`** severity (+ codes when locked)  
4. Optionally **`events`** when present — provisional names until **W1e**

**Never:** consult source bytes after parse to “fix” ownership or text (**W0**).

`descriptive/` is **not** in the gate set.

---

## Placement options

| Option | Pros | Cons |
|--------|------|------|
| **A.** New test crate / binary under `v2-spec/` or `core/` that only loads 0.10 YAML | Clean separation from v0.9 gate | Needs ADM builder from events (or dual-path) |
| **B.** Extend `udon-core` loader with `ACTIVE_GROUP=v0.10` when ready | Reuses machinery | Risk of intermingling; only after suite + event encoding stable |
| **C.** Python/YAML structural checker first (no parser) | Validates corpus shape now | Does not prove parser compliance |

**Recommended sequence:** **C → A → B**.

1. **Corpus lint** (schema of fields, profile rules, no descriptive in gate)  
2. **Reference assembly** pure function over (events, verdict) once a 0.10-ish event producer exists  
3. Wire into cargo when intentional deltas (**ORACLE-DELTAS.md**) are accepted  

---

## Minimal case schema (lint target)

```yaml
- id: string              # required, unique across corpus
  profile: idiomatic | comprehensive | descriptive  # required
  desc: string            # required
  udon: string            # required
  result: complete | incomplete-input   # default complete for gate profiles
  root_only: bool         # optional
  open: string            # required if profile=descriptive
  adm: object             # preferred
  events: list            # optional, provisional
  anomalies: list         # optional
  notes: string           # optional
```

---

## Reference assembly (sketch)

```text
parse(udon) → (events, verdict)
assert verdict == case.result (if present)
if case.adm:
    recovered = assemble(events)   # pure; no source
    assert recovered matches case.adm (normalized)
if case.anomalies:
    assert severity multiset / codes as specified
```

`assemble` is the audited ~W0 check, not a host AST product requirement.

Until **W1e** freezes Attr bracketing, event-only cases may skip ADM or mark
`adm` as design-target with `notes: design-target-not-oracle`.

---

## What not to do

- Point the live `compliance_gate` at `v2-spec/fixtures` while event law is open  
- Copy expectations from current parser for 0.10 intentional deltas  
- Gate on descriptive/ML strawmen  

---

## Immediate implementable step

A small **lint script** under `v2-spec/fixtures/lint_corpus.py`:

- load all YAML  
- enforce profile/open rules  
- unique ids  
- report counts  

No parser dependency. Lands before any Rust harness.
