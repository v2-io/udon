# Decision brief — fence semantics bundle (open decision 8)

*Prepared 2026-07-11 for the Phase-1 decision valve. Sources: REVIEW-JULY-2026.md
§2 genealogy / §4 defects 10–11 / §7-F item 8; FULL-SPEC.md §"Triple-Backtick
Escape (Freeform)" (~1154–1188); `core/generator/udon.desc:586–589`; CommonMark
0.31.2 §fenced-code-blocks; fresh stdin_parse probes 2026-07-11 (all behaviors
below re-verified against the current build).*

## Context

Fences (```` ``` ````) are UDON's freeform escape: content captured with exact
whitespace, no indentation rules, structural parent set by the opening fence's
indent. The spec's stated niche is **indent-uncontrolled assembly** — `!:lang:`
raw directives are the preferred form for code samples (FULL-SPEC is explicit:
"Do not use triple-backticks as the default for code samples"). The spec and
impl diverged within eight hours on Jan 1 and then froze: spec wrote the
closing rule "opening indent or less" at 11:16→18:02; the impl deliberately
chose any-line-closes at 19:14, documented in `udon.desc:589`. Sameline fences
were spec'd at the initial commit and never attempted. Info strings were an
impl innovation the frozen spec never saw. Class-B/D divergences per §2 — the
impl is the later deliberate decision on (a), the spec is unexecuted
aspiration on (b).

## (a) Closing-indent rule

**Current (verified):** any line whose first non-whitespace is ``` closes the
block — an 8-space-indented closer closes a fence opened at 4.

- **A1 — spec's "or less".** Protects a *more-indented* embedded fence from
  closing the block. But the protection is illusory: freeform content is
  indent-free, so an embedded closer at column 0 (the common case for pasted
  code) closes under either rule; and a freeform opened at column 0 makes "or
  less" ≡ any-line. Cost side: a pasted closer that drifted right never
  closes → `UnclosedFreeform` at EOF, with the error far from the cause. It
  also re-imports an indentation rule into the one construct whose purpose is
  escaping indentation.
- **A2 — any-line-closes (impl).** CommonMark-aligned: "their indentation
  need not match that of the opening fence" (0.31.2). Friendlier to markdown
  muscle-memory and sloppy pastes. Cost: cannot embed a document containing
  fence lines — but A1 can't either (see above), and `!:lang:` raw blocks
  handle that verbatim today (probe-verified: fence lines inside a raw body
  pass through untouched).

**Recommend A2.** Ratify the impl; backport to spec. CommonMark's real answer
to fence-nesting is *longer fences* (```` ```` ```` closes only with ≥4), which is
orthogonal to indent — see uncertainty §below.

## (b) Sameline fences

**Current (verified, defect 10):** the spec's own example
(`|element and here we go with ``` `) fails — backticks parse as literal text,
the element closes at EOL, the intended freeform lines dump to root as prose,
and the closer line opens a stray freeform that errors at EOF.

- **B1 — implement per spec.** Grammar cost is real: mid-line fence detection
  interacts with every inline construct, and — decisive — it collides with
  markdown-compatible prose, where a mid-line ``` is legitimately *inline
  code-span content*. Under B1 every such occurrence becomes a fence opener,
  breaking the "prefer Markdown in prose" doctrine. The assembly niche it
  serves is served ~as well by putting the fence on its own line.
- **B2 — drop from spec.** One spec edit (delete "need not be at line start"
  + both sameline examples, ~1160–1175); zero parser change; zero migration —
  nothing has ever produced a working sameline fence. Line-initial-only also
  matches CommonMark (fences are leaf blocks) and is easier for linters and
  agent tooling to detect.

**Recommend B2.** This converts defect 10 from a parser bug into a resolved
spec fix.

## (c) Info strings

**Current (verified):** ```` ```python ```` emits `Name("python")` after
`FreeformStart`; the spec is silent; `tree.rs` drops it (`Raw.lang` always
`None`, defect 4, `tree.rs:631/648`). **Also verified: everything after the
first word is silently discarded** (```` ```python highlight=3 foo ```` loses
`highlight=3 foo`) — a round-trip hole.

- **C1 — spec it, CommonMark-style.** Info string = rest of opening-fence
  line; first word is the language; whole string preserved in the event
  stream. Wire `Raw.lang` in tree.rs. This is what makes the fence-in-prose
  story (below) reconstructable.
- **C2 — drop them.** Loses reconstructability; discards a working, useful
  impl innovation for nothing.

**Recommend C1**, with one guardrail: keep the spec's "prefer `!:lang:` for
code samples" guidance verbatim. Info strings exist to *capture* markdown
input faithfully, not to make ``` the preferred authoring form.

## Meta — the markdown-fence-in-prose story

**Current (verified):** a ```` ```ruby ```` fence inside prose becomes a
structured Freeform block (`FreeformStart` + `Name("ruby")` + verbatim text),
not prose text. Recommend **ratifying this explicitly**: it is not just
defensible but forced — fence content routinely dedents below the enclosing
element's prose scope (column-0 code), which prose *cannot represent* in an
indentation-based grammar. Pass-through-as-prose would work only for
already-indented fences, i.e., a split behavior. Rule to spec: *any line whose
first non-whitespace is ``` opens a freeform block, in prose or anywhere;
serializers reconstruct the fence (with info string) on output.* Consequence
for decision 4 (markdown subset): fences are excluded from prose-markdown —
they promote. Dependency: honest round-trip requires C1 **and** the blank-line
fix below.

## Recommended bundle (one coherent position)

**A2 + B2 + C1 + ratified fence-promotion.** Everything follows one principle:
*fences are line-initial, indent-insensitive, CommonMark-shaped, and owned by
the parser.* The impl needs only the C1 changes; all other motion is spec
edits — the cheap direction, consistent with §2's class-B authority reads.

## Honest uncertainty

1. **Longer fences.** No position taken by spec or impl; probe shows
   ```` ```` ```` currently mis-parses (stray backtick `Text`). CommonMark's
   ≥-length closer rule is the principled nesting escape. Lean: *reserve* >3
   backticks in the spec now (current behavior there is degenerate, so
   reserving costs nothing), implement later if `!:lang:` proves insufficient.
2. **Blank lines inside freeform are dropped** (probe: no Text/BlankLine event
   between `line1`/`line3`) — contradicts "preserves exact whitespace" and
   blocks round-trip of any real code. Not previously in the defect table;
   should join it. Fix belongs with C1's grammar touch.
3. **Trailing content after a closer** re-parses as UDON line content plus a
   spurious "Inconsistent indentation" warning (probe: ``` ``` ; comment ```).
   The spec example implies a trailing comment is fine. Needs a one-line rule;
   lean: allow `;` comment, warn on anything else.
4. B2 removes the *only* mechanism for opening a freeform after sameline
   content. I found no use case that survives contact with the code-span
   collision, but this is judgment, not proof.

## Migration / spec-edit cost

Near-zero migration: no known corpus uses sameline fences (never worked) or
depends on "or-less" non-closing (impl never honored it). Edits:
**FULL-SPEC.md** ~1154–1188 rewrite (closing rule wording, delete sameline,
add info-string + promotion + reserved-longer-fence paragraphs — ~30 lines);
**udon.desc** freeform `:lang` state: capture full info line instead of
`->['\n']` skip, emit blank lines; **tree.rs**: wire `Raw.lang` (part of
defect-4 cleanup); **fixtures**: ~6 new cases (indented closer, info-string
round-trip, blank-line fidelity, prose promotion, trailing-closer,
four-backtick reserved). Fits the review's literate-fusion pilot suggestion
(§7 IN-item; spike 6 nominated fences as the pilot feature).

## Next action

If bundle approved: execute as the **literate-fusion pilot** — author the
fence feature once (spec prose + `.desc` rules + fixture YAML from one
source), landing the FULL-SPEC edits and the C1 grammar/tree changes together;
add the blank-line drop to §4's defect table either way.
