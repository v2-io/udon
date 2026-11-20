# v2-spec fixtures (0.10 design corpus)

**Status:** authored design corpus — **no harness runs these yet**.  
**Law:** [../FIXTURES.md](../FIXTURES.md) · [../DECISIONS.md](../DECISIONS.md) **C5**/**C6**.  
**Not** the live `core/fixtures/v0.9/` gate (**C4** oracle only).  
**Index:** [INDEX.md](INDEX.md)

```text
fixtures/
├── README.md · INDEX.md
├── idiomatic/          ← gate (happy path)
├── comprehensive/      ← gate (edges, twins, closed law)
└── descriptive/        ← non-gate (OPEN holes only)
```

## Rules (short)

| Profile | Gate? | Notes |
|---------|-------|--------|
| `idiomatic` | yes | Prefer `adm`; short teaching cases |
| `comprehensive` | yes | Ownership, L0–L6, R2 twins, closed DECISIONS edges |
| `descriptive` | **no** | Must set `open:` to named hole |

- Preferred verdict field: `result: complete | incomplete-input` (**C6**, **D-pack**).
- Incomplete-input is **not** an event.
- Event / ADM spellings **provisional** until OPEN **W1e** / W2.
- `adm` = design targets from SPEC/DECISIONS — **not** parser traces.
- Do not intermingle with `core/fixtures/v0.9/`.
- Any `open: ML` (etc.) → **descriptive/** only.

## Files (post-dedup 2026-07-21)

| Path | Focus |
|------|--------|
| [idiomatic/smoke.yaml](idiomatic/smoke.yaml) | 3-case smoke (element+attr+prose, sugar, stacking) |
| [idiomatic/happy.yaml](idiomatic/happy.yaml) | Broader happy path (no sugar/stacking dups) |
| [comprehensive/ownership.yaml](comprehensive/ownership.yaml) | Tail ownership, L1/L4/L6, R4/R5, Content Phase, R16/R18 |
| [comprehensive/incomplete.yaml](comprehensive/incomplete.yaml) | Incomplete-input wire-twins (string/list/inline/interp/fence/envelope) |
| [comprehensive/closed_law.yaml](comprehensive/closed_law.yaml) | L2, S8, R13, R20, refs, structure `\` |
| [descriptive/ml-open.yaml](descriptive/ml-open.yaml) | OPEN **ML** pins only |

**Removed as redundant:** `eof_verdict.yaml`, `stacking_and_partial.yaml`, `multiline_strawman.yaml` (content folded into incomplete / ownership / ml-open).

When a harness lands: gate = idiomatic ∪ comprehensive; report descriptive separately.
