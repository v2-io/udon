# Dialects

Dialects give **meaning** to syntax Core already recognizes:

| Dialect | File | Core hook |
|---------|------|-----------|
| Baseline Dynamics | [dynamics.md](dynamics.md) | `!` forms |
| `temporal@1` | [temporal.md](temporal.md) | `<…>` Envelope bodies |

**Future candidates (not specified here):**

- `standard-types` — rationals, complex, units, …
- Host-specific expression languages replacing baseline Dynamics

Pragma syntax to declare active Dialects per document is anticipated by Core
architecture but not fixed in this greenfield suite (Host configuration binds
Dialects until then).
