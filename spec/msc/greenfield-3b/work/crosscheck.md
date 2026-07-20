# Cross-check: snippets → new-spec

Non-normative audit. For each corpus/fixture theme: covered? decision?

## from-corpus

| Topic | Covered in | Notes |
|-------|------------|-------|
| 01 elements/identity | CORE §5 | sugar, partial-key, anonymous, quoted names, spaced trait=prose, `\| a \|` table safety |
| 02 hierarchy | CORE §3.2 | Nesting Rule + sameline columns |
| 03 attributes scan | CORE §6.4–6.6 | dual attrs on block line, bare boundary, flags, missing value→Nil+Error |
| 04 attribute values | CORE §6.3, §11 | kinds table |
| 05 ownership/stacking | CORE §6.5–6.7 | rows, inline-brace, empty `;{}`, stack vs list, warn-ingest, value-`\` |
| 06 node values | CORE §6.8 | one-way door, block vs brace, attr-under-attr, raw node |
| 07 prose dedent | CORE §7.2 | content base algorithm |
| 08 comments | CORE §8 | forms + geometric participation |
| 09 escape | CORE §9 | four positions |
| 10 raw/freeform | CORE §10 | Verbatim family |
| 11 dynamics/refs | CORE §12 + dialects/dynamics | syntax vs meaning split |
| 12 eof | CORE §13 | geometric silent / delimited warn / incomplete |

## from-examples (spot)

| File | Observation under new-spec |
|------|----------------------------|
| cheatsheet / minimal | Idiomatic; pedagogy tour aligns |
| comprehensive | Mixins remain Host; `<2025-12-22>` envelope OK; dynamics baseline |
| ash-like / operata | Realistic Element+Attribute+prose; no CORE holes spotted |
| schema-dsl | Suffixes as Schema meaning — correctly non-Core |

## from-fixtures v0.9 themes

| Theme | Status |
|-------|--------|
| multi-line strings/arrays | **D1** now defined multi-line (fixture “close at newline” behavior is superseded for new contract) |
| eof_* | CORE §13 |
| flags | CORE §6.2 |
| interplay | fence-as-node, comment-at-base, escape tails — covered |
| legacy_mined | treat as adversarial; no need to preserve retired syntax |
| typing_envelope | CORE §11.6 + temporal dialect |

## Invented cases worth adding to a future fixture pack

```udon
; multi-line string (D1)
|el :msg "line one
line two"

; multi-line list (D1)
|el :ports [
  8080
  8443
]

; root attribute (D3) — Error + text keep
:orphan 1

; stacking ≠ list (SEMANTICS)
|el :x 1 :x 2
|el :x [1 2]

; rational no longer bare core (D2)
|el :q 1/3r
|el :q <r:1/3>
```

## Residual risks / softer spots

1. **Float equality** in SEMANTICS is slightly hand-wavy (1.0 vs 1.00).
2. **Pragma** for dialect binding still Host-config only.
3. **Interpolation end rule** `}}` first-match — hostile JSON-looking exprs need spaces (`!{{ {"a":1} }}`) — documented in dynamics; not newly invented.
4. **Bracket mode** multi-line indent-ignore vs content-base interaction: stated as geometry skip; edge cases with mixed prose after close need future fixtures.
5. Did not re-verify every v0.8 fixture (pre-modern by README); relied on v0.9 + corpus + examples.
