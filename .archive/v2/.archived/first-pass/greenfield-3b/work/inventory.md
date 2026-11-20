# Phase 0 inventory (working notes)

Non-normative. Snapshot of the clean-room input and how it fed the rewrite.

## Input map

| Path | Role |
|------|------|
| `spec/CORE.md` (~1745 lines) | Primary behavior source — dense, mixed pillars |
| `spec/DYNAMICS.md` | Baseline `!` dialect meaning |
| `spec/TIME-SPEC.md` | Temporal value grammar (banner: out of date vs envelope) |
| `spec/MARKDOWN.md` | Four layers above parse |
| `spec/CORE-supplement.md` | Examples / comparison (thin) |
| `extracted-jargon.txt` | ~150 terms — synonym and lag map |
| `snippets/**` | Adversarial + realistic behavior samples |
| `defining-udon.md` | Three-pillar guidance |

## Concept clusters (load-bearing)

1. **Layering:** Core / Dialect / Schema / Host; menu vs knob; frozen bare scalars + envelope
2. **ADM substrate:** Element = name + ordered attrs + content; sugar → designated attrs
3. **Geometry:** columns, nest rule, structure position, line scan
4. **Ownership asymmetry:** element-rooted vs attribute-rooted lines
5. **Bare-token boundary + inline-brace principle**
6. **Stacking vs list vs multi-segment ingest**
7. **Node value one-way door; block form vs brace form**
8. **Verbatim family** (block / fence / inline)
9. **Geometric vs delimited extent; EOF; incomplete-input**
10. **Keep-everything anomaly posture**
11. **References inert; mixins experimental Host**
12. **Prose dedentation / content base**

## Open / provisional in source (handled in DECISIONS or left open)

- Multi-line span for most delimited constructs (undefined) → **decided multi-line**
- Rational / complex bare → **moved to dialect proposal**
- `$partial-key` name provisional → **kept**
- Nested envelope routing → open (dialect concern)
- Root-level attribute → undefined → **decided: Error + keep as oddity / or prose** — see DECISIONS
- Comment continuation strip column → content-base shape **affirmed**
- Mixin behavior → remains non-core
- Selector path syntax future → tuple model **kept** as current contract
- Inline control-flow → not specified
- Attribute-under-attribute kept shape → **text ingest + Error** affirmed

## Synonym retirements applied

See GLOSSARY §8: freeform, embedded, positional, blob, head position, wire, etc.

## Pillar leakage fixed in rewrite

| Old voice | New home |
|-----------|----------|
| “parser does X / pop while” | Nesting Rule + implementer notes (non-normative) |
| Pedagogy mid-rule | pedagogy/ + examples marked non-normative |
| CURRENT BEHAVIOR callouts | ignored per README-FIRST |
| Event/wire | omitted |
| Grammar-lags-spec dual names | single glossary term |
