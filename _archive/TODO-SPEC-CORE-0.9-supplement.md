# TODO-SPEC-CORE 0.9 supplement — attribute-model nail-downs

Rulings ledger + residual opens for the 0.9 attribute-model promotion.
Everything ruled below is **in CORE** (each with its date inline there); this
list exists so nobody re-opens settled questions. Sweep the residual opens
when the 0.9.0-alpha.1 text is essentially finished (revisit item in
`TODO-SPEC-CORE.md`).

## Ruled (in CORE — do not re-open)

**2026-07-15 (Joseph):** bare-token boundary rule (scan provisionally open at
a bare token's boundary; marker → single-token value, text → blob to
ownership); no keyword carve-out (`:alpha true story` → `"true story"`);
`@` guard + `.` and `@` equal-footing with `|` in the sameline scan;
embedded framed ` ; ` out for now (bare `;` literal; revisit with dialects);
`\`-forced text = line-verbatim but inline forms fire, framed ` ; ` literal
(P3-3); spaced-trait form dropped (identity contiguous except trailing
spaced suffix); sameline tail enters children phase; anomaly-posture ladder
(warn-and-keep (a) wherever coherent; errors non-halting; drop/halt/reject =
AST/app config).

**2026-07-16 (Joseph):** R2 embedded = element-rooted sameline (+`}`), with
the `\`-boundary content idiom and unspecified-in-0.9 framed-`;`-after-`\`;
`MissingAttributeValue` = error event **+ synthesized `Nil`** (stream never
carries less shape than the source suggested); R3 ownership never changes at
a `\` (block-line trailing = warn+stack, uniformly: **two values on one
attribute always warn and stack — never error, never drop**); R4 flag
semantics follow the NAME (quoted ≡ bare; `$?` aligns by construction); R5
flat stacking wire (every `Attr` carries one value; all multiplicity =
re-emitted `Attr`; no AttrStart/AttrEnd; only literal `[…]` arrays on the
wire).

**2026-07-16 (delegated to Claude, per-item calls recorded in CORE):**
EOF = universal implicit closer with per-construct `Unclosed*` table
(CORE "End of input"); flag + deeper block = `AttributeSecondValue`
warn+stack (flag rule item 4); mid-token typed-path failure = ordinary bare
token, boundary rule at its end (CORE "The Scan"); raw block usable as node
value sameline too, ordinary raw-base rules (CORE "Inline Raw Content"
tail note); `<…>` envelopes single-line (`UnclosedTypeEnvelope` warn +
string pass-through); interpolation ends at first `}}`; tabs illegal in
indentation only (content tabs pass through); plus editorial: warning-table
reword (`CommentMissingFollowingSpace`, `InconsistentIndentation`),
wire-vs-view round-trip caution (Host Views), node-value one-way-door
caution (Node Values), prose-base exception cross-ref (Hierarchy),
Document-layer mini-definition, `\` added to the head row, Positional
Contexts examples moved out of table cells (formatter-stability).

## Open

- [x] ~~`AttributeUnderAttribute` recovery shape~~ **Settled in the grammar
      iteration 2026-07-16** (delegated posture): the open attr gets its
      `Nil` (shape preserved), the error explains it, the offending line's
      bytes are kept as element prose. Fixture pins it.
- [ ] **Reconsider the "guard" framing / Marker Recognition section**
      (Joseph, 2026-07-15): reads as lexical-implementation detail, partially
      redundant with each marker's own section. Options: fold each guard into
      its marker's section; demote to a non-normative recognition summary; or
      keep but tighten. Deferred until the 0.9 model text fully settles (an
      editorial restructure, not a ruling).
- [ ] **Bare-pipe table fragility** — bare `|` inside table-cell code spans
      (ruled for legibility 2026-07-16) is corrupted *in source* if a table
      formatter re-parses the cells (it split the Positional Contexts table
      once). Positional Contexts is now pipe-free; the remaining bare-pipe
      tables (Prefixes, desugar, Value Kinds, Comments, terminators, inline
      syntax, naming) are fine until a formatter sweeps them. If that
      happens: de-pipe those cells the same way (examples into udon blocks),
      or configure the formatter to skip CORE.md.
- [x] ~~Substrate/proposal text alignment~~ **Done 2026-07-16**: substrate
      §S5 rewritten to the boundary rule (wrong "NOT" example corrected,
      "letter-first" framing retired); §S15 and proposal-3 §6 wire sketches
      marked superseded-by-flat-wire (kept as archaeology). Proposal-3 §4/§10
      example outcomes match the ratified rules as written.
