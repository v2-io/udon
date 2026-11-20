# Dialects (stubs)

**Status:** pointers only (DECISIONS P5). Not full specs.

| Dialect | Intent | Seed material |
|---------|--------|----------------|
| `temporal@1` | Temporal values only inside envelopes | greenfield-3b `dialects/temporal.md`; scrubbed TIME-SPEC grammar *inside* envelopes |
| baseline Dynamics | `!` meaning (Liquid-style baseline) | greenfield-3b `dialects/dynamics.md`; `spec/DYNAMICS.md` (companion) |
| `standard-types` (future) | rational/complex/units | OPEN / DECISIONS L5, R21 |

Core recognizes envelope and `!` **syntax**; meaning is dialect/host.
