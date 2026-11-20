# autocolors — 2011 archaeology (verbatim copies)

Copied 2026-07-16 from `~/src/_ref/autocolors/` (last touched Oct 2011; the
gem generated working gvim colorschemes that Joseph used for years). These are
**frozen source material** for `../PLAN.md` — do not modernize in place.

| File | What it is |
|---|---|
| `NOTES.md` | The design substrate: goals (balance + interestingness + information), theme-element inventory, composition theory, the highlight-group taxonomy (plumbing / discriminators / origin groups / contextual emphasis), monotone-base table, hand-built hue table with chroma corrections. |
| `fitness.md` | The four per-group fitness criteria: similarity to parent, difference from siblings, contrast vs. ideal, coherence with common neighbors. |
| `TODO.md` | Where 2011 stopped: statistics analyser, fitness criteria, constraint solving — the parts that were hard then and are cheap now. |
| `mapping.udon` | **Ancient UDON** (2011 dialect!) — the allocation DSL: group tree with `<` parent-inheritance, `'` primes ("diverge slightly"), `+/-/~` intensity & saturation offsets, per-target output-name mappings (vim / textmate / pygments / emacs). Autocolors was a UDON consumer fifteen years before this repo's reboot. |
| `colorscheme.rb` | The generator: Lab color space; three sampled global "personality" params (contrast, chromacity, colorfulness); jittered-even base-hue spread (`rand_seq`); child hues derived from parent with divergence scaled by depth, sibling count, and prime level; schemes seeded by a random dictionary word (name = seed = reproducible). |
| `color.rb`, `mapping.rb` | Lab conversions + the mapping-table parser. |

Not copied: the multi-MB `quicktest*.html` swatch outputs and `.attic/`
(earlier iterations) — see the source repo if needed.
