# autocolors × udon — bridge plan

*2026-07-16. Status: proposed — nothing here is ratified; open decisions are
marked. Source substrate: `archaeology-2011/` (verbatim 2011 artifacts, see
its README) and the parser-driven highlighting landed in
`../obsidian-udon/` this week.*

## The claim

Syntax highlighting is a false "solved problem." The industry's implicit
answer — assign each of ~8 token classes a hue someone picked — was frozen by
the constraints of 2011 terminals and hand-maintained regex grammars. The
2011 autocolors NOTES contain an allocation *theory* that nobody has built in
the fifteen years since:

> Maximizing balance + interestingness + information conveyed.

- **Emphasis is a budget**, spent proportional to information: plumbing
  recedes, discriminators stand out, and every high-contrast item is balanced
  by larger fields of low contrast (composition theory, not taste).
- **Colors are relationships, not assignments**: similarity to parent,
  difference from siblings, contrast vs. ideal, coherence with neighbors
  (`archaeology-2011/fitness.md`). The 2011 generator produced schemes worth
  using for years *stochastically* because it constrained the relationships
  and randomized only within them.
- **Emphasis is contextual**: the right weights depend on the document (a
  file that is 90% attributes should not paint attributes loud) and
  eventually on the activity (understanding vs. searching vs. debugging).

Every part of that which was hard in 2011 is now cheap, and the hardest
part — exact token roles with exact spans from a real parser — is the thing
this repo just built:

| 2011 blocker | 2026 state |
|---|---|
| Perceptual color space (hand-rolled Lab in Ruby) | `oklch()` native in CSS/Chromium; Obsidian is Chromium |
| Token roles via editor-specific regex grammars | udon-core event stream → wasm, exact spans, already the plugin's sole highlighter |
| "Analyser for highlight group statistics" (2011 TODO, never built) | the same parse that highlights *is* the census — counts and span-areas per class fall out for free |
| Constraint solving / fitness optimization at generation time | trivially affordable in JS at plugin-load time |
| Contrast correctness | APCA/WCAG contrast is computable per (fg, bg) pair at generation time, not eyeballed |
| An output target someone controls end-to-end | `../obsidian-udon/` — we own parser → classes → CSS, no theme committee in the loop |

## Architecture (five layers, separable)

```
 [1] role stream      udon-core wasm events: class + span (+ depth, warnings)
 [2] mapping          role tree with inheritance & divergence marks — mapping.udon reborn
 [3] generator        personality params + monotone base + constrained hue allocation, in OKLCH
 [4] fitness          the four 2011 criteria + composition budget, as measurable functions
 [5] emission         CSS custom properties (Obsidian) | ANSI (highlight.rs) | vim | …
```

**[1] Role stream — mostly exists.** The wasm walk emits 11 classes today.
The ceiling is higher: the event stream also knows nesting depth,
element-vs-attribute edges, warning payloads, dialect/raw-block language
boundaries ("embedded languages" was a first-class NOTES layer). Widening the
class vocabulary is a `core/udon-wasm` change; the 2011 mapping tree
(`text.*`, `lit.string.char.esc.*`…) shows how deep a taxonomy can usefully
go when colors are *derived*, not hand-assigned — sub-classes are cheap when
a child's color is "parent, diverged slightly."

**[2] Mapping — mapping.udon reborn, in modern UDON.** The 2011 file is the
right *shape*: a role tree where each entry states its relationship to its
parent (`<` inherit, `'` diverge-slightly, `+/-/~` emphasis offsets), not its
color. Rewrite it as a modern `.udon` document (dogfooding: a real UDON
consumer inside the umbrella repo, likely the first `<…>`-typed config in
anger). The mapping is *language-independent* — the same tree can carry the
vim/textmate/pygments name-mappings the 2011 table already sketched.

**[3] Generator — port the model, upgrade the math.** Keep the 2011
generative structure, which is proven by use:

- three global personality parameters (contrast, chromaticity, colorfulness)
  — sampled for named-random schemes, or *fitted* (see [4]);
- the monotone-base skeleton (the light-3…dark-3 table in NOTES) anchored to
  the **actual theme background/foreground** read from Obsidian's computed
  styles, so generated schemes are native in any theme, light or dark;
- jittered-even hue spread for base groups; child hues derived from parent
  with divergence scaled by depth, sibling count, and divergence marks.

Upgrades over 2011: OKLCH instead of Lab (better hue uniformity — the NOTES'
hand-built chroma-correction table around puke-green is exactly what OKLCH
solves analytically); APCA contrast as a hard constraint per pair instead of
an intensity heuristic; deterministic seeding preserved (name = seed —
`autocolors muahaha` must survive).

**[4] Fitness — the genuinely unbuilt part; the reason to do this at all.**
Make the NOTES' composition theory *measurable*, then optimize:

- **Per-group (2011's four):** parent-similarity, sibling-difference,
  contrast-vs-ideal, neighbor-coherence — all are distances in OKLCH; write
  them as functions.
- **Global (the composition appendix):** the balance rule — total visual
  weight of high-emphasis spans vs. the low-contrast field — becomes
  computable the moment the parser reports per-class span *area* for a
  document corpus. Visual-weight heuristics (warm > cool, dark > light,
  saturated > unsaturated) are listed in NOTES with orderings; encode them.
- **Density-adaptive allocation:** fitness evaluated against *measured*
  class densities (per-document, or per-corpus with `examples/` +
  `spec/CORE.md` fences as the default corpus), so emphasis is spent where
  information actually is. This is the "possibly customized per language
  (different densities)" line from the 2011 README, finally cashable.
- Generation = sample personality → place colors under constraints →
  hill-climb the fitness (the search space is tiny; even naive optimization
  converges instantly at these dimensions).

**[5] Emission — Obsidian first, but the engine is a library.** In the
plugin: generate at load, inject CSS custom properties, done — no theme
files, adapts when the user switches themes. The same engine feeds
`highlight.rs`-style ANSI output (the terminal is *our* other surface), and
vim/textmate/pygments emission is the 2011 mapping table's other columns.
Keep the engine dependency-free JS (or Rust-in-wasm beside the parser —
open decision) so targets stay cheap.

## Phases

- **A. Palette engine spike** — OKLCH + APCA + monotone-base anchored to the
  live theme; static 2011-style mapping for the current 11 classes; a
  swatch/test page rendering `examples/cheatsheet.udon` under N generated
  schemes side-by-side (the 2011 `quicktest.html` pattern — it worked).
  *Proves: generated-at-load schemes look native and good in Obsidian.*
- **B. Mapping + generator proper** — modern `mapping.udon`; port the
  personality/divergence model; named-seed reproducibility; richer class
  vocabulary from the wasm walk (depth, warnings, embedded-language spans).
- **C. Fitness + density adaptation** — the four criteria + composition
  budget as functions; corpus census via the parser; optimization loop;
  A/B the result against phase-A output on the swatch page.
- **D. Beyond** *(each gated on appetite, not feasibility)* — contextual
  emphasis (activity modes were sketched in NOTES §CONTEXTUAL EMPHASIS);
  ANSI/vim emission; standalone library; the NOTES' own suggestion of
  empirical testing (first-time vs. accustomed viewers).

## Open decisions *(discuss w/ Joseph)*

1. **Engine language/home:** JS inside the plugin (fastest to phase A) vs.
   Rust beside the parser compiled into the same wasm (one artifact, shared
   by every target). Phase A in JS doesn't foreclose the move.
2. **Class vocabulary width for phase B** — what the wasm walk should emit
   beyond the 11 (depth? warning kinds? dialect boundaries?) is a
   `core/udon-wasm` API decision.
3. **Scope of ambition for the mapping file:** UDON-only role tree, or carry
   the 2011 cross-language columns (vim/textmate/pygments) from day one —
   i.e., is autocolors a udon-repo feature or a project that udon hosts?
4. **Where randomness lives:** per-vault stable scheme (seeded once, kept)
   vs. regenerate-on-demand (`muahaha` mode) vs. both behind a command.
