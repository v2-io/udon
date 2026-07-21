# Intentional deltas vs live oracle (0.10 suite)

**Status:** working list for differential-oracle work (**C4**).  
**Not** a claim that the live parser is wrong on every row — some rows are
*suite evolution*; some are *live CORE debt the suite refuses*.

When a new recognizer is built: every disagreement with `core/` on these points
should match a DECISIONS ID or be filed as a bug in one side.

| Area | Live `spec/` / parser (rough) | 0.10 suite | Cite |
|------|-------------------------------|------------|------|
| Flat Attr wire / inferred value extent | Still transitional / deratified in prose | **Forbidden** as law; self-delimiting required | **R8**, **W1d** |
| Severity of kept anomalies | Mixed Error vs Warning (taste / geometry) | **Error = loss only** (+ named Nil Errors) | **L0**, **R6** |
| Tab in indent | Error + **line lost** (live CORE) | **Keep** + Warning | **L4**, **L0** |
| Root-level `:key` | Undefined / free-float do-not-rely | **Warning** + document Text | **L1** |
| Bare rational/complex | Hedge / grammar remnants | **Out of bare**; dialect later | **R21**, **L5** |
| In-string `\` escapes | Mixed / open | **None** in Core | **L2** |
| Attr-under-attr keep shape | Needs ruling / varies | Text of open value + Error | **L6** |
| Comment continuation strip | Live CORE still “needs ruling” prose | **Content-base shape** (first cont. line) | **L7** |
| Inline raw in value position | May vary / node-shaped readings | **Flow segment** (inline-brace) | **S11**, **R4** |
| Multi-line delimited | Mostly undefined 0.9 | **Still open** (WAIT-DEMAND) | **R3**, **ML** |
| Incomplete-input | Result channel exists | Explicit fixture field | **C6**, **R2** |
| Document packaging | Implicit / dual | `{content, anomalies, result}` | **D-pack** |
| Suite home | `spec/CORE.md` | Author under `v2-spec/` until cutover | **P1**, **C0** |

**Not oracle targets:** greenfield multi-line strawmen until **ML** closes; OPEN **W1e** event spellings; descriptive-profile YAML.

**How to use:** When a new recognizer disagrees with live `core/` on a row above, treat the red as **intentional-delta** only if it matches the suite column + cite. Otherwise file a bug in the new side or re-open DECISIONS (Overturn) — never “fix” live CORE silently to match suite, and never treat live behavior as law over DECISIONS.
