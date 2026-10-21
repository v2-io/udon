# Tools kept with the lite store's research notes

- `mermaid-check.mjs FILE`: runs every ```` ```mermaid ```` block in FILE through `mermaid.parse` and prints ok/FAIL per block with the parser's message. Needs node, and `mermaid` (12.2 was used, 2026-10-21) plus `jsdom` installed in the directory you run it from (`npm i mermaid jsdom`). Added because mermaid's `railroad-peg-beta` lexer reads `"\"` as an escaped quote; the fix is `"\\"`.
- `mermaid-probe.mjs`: thirty one-rule probes of what the `railroad-peg-beta` parser accepts (lookahead, `.`, punctuation in terminals, `_rule` names, `%%` comments). All passed on 2026-10-21.
- For running the PEG itself on inputs, see `../peg-audit-2026-10-21/` (`pegi.py` reads the grammar text from a file; `summ.py` prints a tree; `runall.py` runs the case files). That interpreter, not a hand transcription, is the gate for grammar changes.
