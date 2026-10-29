# UDON brand assets

The UDON logo and its parts, cut from Joseph's `udon_logo_hiragana.svg` (2026-10-29), which is kept here whole as `udon-logo-hiragana.svg`. Every path in the part files is the original path data. Only the crop (`viewBox`) and the fills differ.

| File | What | `viewBox` (logo units) |
|---|---|---|
| `udon-logo-hiragana.svg` | the full logo on its washi ground, unchanged | `0 0 1024 1024` |
| `udon-mark.svg` | the brush mark (the bowl of four `\|` strokes), sumi ink | `304 160 414 592` |
| `udon-mark-vermilion.svg` | the brush mark in vermilion, for dark grounds | `304 160 414 592` |
| `udon-mark-currentcolor.svg` | the brush mark taking `currentColor`, for inlining | `304 160 414 592` |
| `udon-seal.svg` | the hanko seal, 丼 | `693 709 36 36` |
| `udon-wordmark.svg` | the logo's geometric UDON wordmark | `350 808 323 66` |
| `udon-hiragana.svg` | the logo's うどん | `403 894 218 66` |

## Colors

The mark has two layers: a dense core and, at 0.88 opacity, the dry-brush edge.

| | Core | Edge |
|---|---|---|
| Sumi (light grounds) | `#241F1A` | `#3A3129` |
| Vermilion (dark grounds) | `#CF5A3A` | `#DB6D49` |
| Seal | `#C03B28` | |

The original logo's mark is near-black (`#161614` and `#2A2927`). The sumi values are slightly warmer and less black, at Joseph's request (2026-10-29: "something a little "off-black" and very very slightly brown for more authenticity").

## The header lockup

Used in the `stillness.udon` specimen: the mark on the left, with "UDON" and うどん above "Universal Document Object Notation" to its right, all aligned left. Everything is measured off the brush strokes, in logo units, with the mark cropped to y 160–752:

- The subtitle's baseline and the seal's bottom both sit on the bowl's bottom (y 744).
- UDON's baseline sits at the tip of the inner right stroke (y ≈ 660).
- The seal is as tall as a capital letter in the subtitle, and stands at its place in the logo, just right of the bowl's lower curve.

Faces: Inter 400 for UDON, Inter 300 for the subtitle, and Noto Serif JP for うどん. On light grounds the mark is at 90% opacity and UDON at 88%, so a little of the paper shows through. On dark grounds the mark is vermilion, UDON is Inter 300 in `#E8DFCF` (an off-white leaning beige), and the subtitle is a dull terracotta, `#C98A69` at 72%.

## The specimen

`specimen/stillness.html` is the brand specimen: the same `stillness.udon` example in a paper editor window and a slate one, with the header lockup above each and the stones and inkwells from `props/` around them. It is a single file, the published artifact (https://claude.ai/artifact/QdtrbFRU1TfjtBuvihjKHr) with its images pointed at `../props/`. Open it in a browser. `specimen/stillness.png` is a screenshot of it (2400 px wide), shown at the top of the repository's README.

- **Embedded:** the logo parts, as inline SVG, and Victor Mono for the code (Joseph's Nerd Font Mono build, subset to the characters the page uses; SIL Open Font License).
- **From Google Fonts:** Inter, Jost and Noto Serif JP.
- **Highlighting:** done by a small script in the page from the plain source in its `<script type="text/plain" id="src">` block. Swap that block to show another example.
- **Colors:** the syntax palette (Gemini's), the paper and slate tokens, and the lockup's sizes are all at the top of its `<style>`.
- **Delimiters:** each delimiter (`|`, `[` `]`, `.`, `:`, `;`, and Markdown's marks) takes its token's color mixed halfway toward the window, so the delimiters recede and the names stand forward.

## Props

`props/` holds the stones and inkwells, each cut out of one photo with its own shadow, and the scripts that make them. Its README has the method.

