# Security review: comrak `sourcepos-fixes` (v2-io fork)

*2026-10-15. Reviewed `main` (`d785d46`) against `sourcepos-fixes` (`3743e41`) in `~/src-ext/comrak`: three commits, `28137f1`, `0d90298` and `3743e41`. The branch and working tree were not touched. Everything was built and run from `git archive` copies in a scratch directory.*

## Bottom line

**I found no security vulnerabilities in these commits.** The changes are position arithmetic inside the inline parser. They don't touch I/O, `unsafe`, URL or HTML handling, or the rendered output. The output is byte-identical to `main` when sourcepos is off (evidence below).

You said some of your tools slice input by these positions, so I also checked what the stock security-review process leaves out: parser panics, and positions that fall outside the input or land in the middle of a UTF-8 character. On both counts the branch is **much better than `main`, with no new panics**. It has two narrow regressions, both inside parts of comrak whose positions were already wrong. A consumer that slices by sourcepos needs bounds checks whether or not you push this branch. Details below.

**How this review was done.** I followed the `/security-review` process: one pass to find vulnerabilities, then false-positive filtering. The filtering step had nothing to filter, because no candidate findings came up.

The finding pass was run twice, independently:

- **Mine.** I read the code and built a differential fuzz harness that runs each input on both revisions.
- **An unprimed second reviewer.** This was a separate agent that didn't see my findings. It used its own harness on about 260k generated inputs.

Both reached the same conclusions. Neither found a security finding. Neither saw a panic on either revision. Both saw the same two narrow position regressions, and traced them to the same pre-existing wikilink and inline-footnote bugs. The second reviewer also found one more pre-existing bug that produces mid-character positions; it is listed below, under pre-existing position bugs.

## What the commits change

| Commit | Change | Where |
|---|---|---|
| `28137f1` | Link reference definitions are removed from the start of a paragraph. The branch now also drops their per-line offsets and records `removed_lines`, so inline positions start on the first remaining line. The table-preface split carries the count over. | `nodes.rs` (new `BlockLines::removed_lines`), `parser/mod.rs`, `parser/table.rs` |
| `0d90298` | When a link's tail (destination, title, or full-reference label) spans lines, the subject's line and column state now advances over it. The link ends at its closing `)`/`]`. This replaces upstream's #572 end-at-destination rule. | `parser/inlines.rs` `close_bracket_match` |
| `3743e41` | An attribute block that spans lines now advances the line and column state. The end column is now indexed from the block's first line, not the node's start line. | `parser/inlines.rs` `handle_potential_attribute` |

## Security assessment (stock categories)

None of the stock categories applies to this diff:

- **Injection or XSS in rendered output.** Sourcepos appears in HTML only as integer `data-sourcepos` attributes. With sourcepos off, rendered HTML and CommonMark output are unchanged (see the evidence section).
- **Deserialization, authn/authz, crypto, secrets, data exposure.** None of these code paths is touched.
- **Memory safety.** The diff is safe Rust and adds no `unsafe`.

## Panics reachable from untrusted markdown

The stock process would file these under DoS, but they matter for your use, so I checked them. The new code adds four operations that can panic:

1. `parent_line_offsets[self.line - self.block_line]` in `close_bracket_match` (`inlines.rs:2041`) and in `handle_potential_attribute` (`inlines.rs:2448`).
2. `lines.offsets.drain(..removed)` in `resolve_reference_link_definitions` (`mod.rs`).
3. `usize::try_from(...).unwrap()` on the link end column (`inlines.rs:2056`). The arithmetic is new; the `unwrap` was already there.
4. The slice `self.input[after_link_text_pos..self.scanner.pos]` (`inlines.rs:2038`).

My conclusion is that none of them can be triggered. The reasons:

- **(1)** can only go out of range if the subject counts more lines than the block has offsets.
  - The new code counts newlines only in input that no other code has counted yet. That is the link tail between `]` and the closing `)`/`]`, and the attribute span. The inline scanner hasn't passed over either span when they are counted.
  - `count_newlines` treats `\r\n` as one line end. So does the block parser, so newline counts and offset counts agree.
  - The known position bugs nearby (multi-line wikilinks; outer text after a multi-line inline footnote) make the subject count *too few* lines, never too many.
  - For inline footnotes, the nested subject builds its own `line_offsets` by the same newline rule as its input.
- **(2)** `removed` counts the newlines in the content before the end of the definitions. Every content line was pushed together with one offset entry in `add_line`, so `removed` cannot exceed `offsets.len()`.
- **(3)** The end column is `since_newline + line_offset` or `scanner.pos + column_offset + line_offset`, and neither can go negative.
- **(4)** `after_link_text_pos` equals `initial_pos`, the position just after `]`. Every path that reaches `close_bracket_match` has `scanner.pos >= initial_pos`. Both ends sit just after ASCII bytes, so they fall on character boundaries.

Fuzzing agrees. Builds had `overflow-checks` and `debug-assertions` on, so any `usize` underflow would also have panicked. There were **0 panics on the branch and 0 on `main`** across about 10 million parses per revision (detailed in the evidence section). The branch's own test suite passes with `--all-features`: 720 + 200 tests.

## Out-of-bounds and mid-character positions (what affects your slicing tools)

For each inline and block node, the fuzz harness checked four things:

- Start and end lines exist in the input.
- Columns are within the line, allowing one past the end, or two for a soft or hard break on a `\r\n` line, which is comrak's existing convention.
- Both ends fall on UTF-8 character boundaries.
- For single-line `Text` nodes, slicing the source by the node's sourcepos reproduces its literal text.

Each input was run on both `main` and the branch.

### Overall: a large improvement

Line-structured fuzz, 960k inputs per option set:

| Option set | Inputs with an out-of-bounds position (`main` → branch) | Inputs with a mid-character position (`main` → branch) | Inputs where the branch is worse |
|---|---|---|---|
| CommonMark + tables + link/code attributes | 78,824 → 352 | 4,960 → **0** | **0** on every check |
| All extensions except wikilinks and inline footnotes | 50,383 → 4,356 | 4,901 → 2,461 | **0** on every check |
| All extensions | 61,787 → 16,553 | 5,767 → 3,370 | 72 out of bounds, 11 mid-character (both regressions below) |

The mid-character drop matters for Rust consumers: slicing a `&str` at a non-boundary panics. In the CommonMark-plus-tables set, the branch removed every such position the fuzzer found.

### Regression 1: links or attributes spanning lines inside inline footnotes (`inline_footnotes`)

Nodes inside an inline footnote `^[...]` already get positions in a coordinate system relative to the footnote's own text. `handle_inline_footnote` builds the nested subject with line 1 as its base, and with `line_offsets` that are byte offsets into the footnote text, where the field normally holds each line's stripped indentation.

`main` already produces out-of-bounds positions here for code spans that span lines:

```
input:      a ^[f `c\nd\ne` z] q
main:       code 1:3-3:9, text 3:10-3:11    (line 3 is 7 bytes long)
```

The branch's new line advancing reaches the same faulty offsets through links and attributes:

```
input:      a ^[f [l](\n/u\n"t"\n) z] q
main:       link 1:3-1:9,  text " z" 1:16-1:17
branch:     link 1:3-4:15, text " z" 4:16-4:17   (line 4 is 6 bytes long)
```

Both sets of positions are wrong. The branch's are more often past the end of the line. A related bug exists on both `main` and the branch: the text *after* a multi-line inline footnote stays on the footnote's first line (` q` → `1:23-1:24`, but it is on line 4).

**Fix, if you want it:** give `handle_inline_footnote` real document coordinates: the outer `self.line` as the base, and per-line indentation offsets. This is a separate pre-existing bug, not something this branch needs to fix before you push.

### Regression 2: positions after a multi-line wikilink (`wikilinks_*`)

A wikilink that spans a newline (`[[w\nx]]`) doesn't advance the subject's line, on either `main` or the branch. Everything after it on the same paragraph is one line too early. When a link with a multi-line tail follows, the branch now advances correctly, but from that wrong starting line. The result lands on a different wrong line, which is sometimes shorter than the reported column:

```
input:      [[w\nx]] [l](\n/u) z
true:       link 2:5-3:3, text " z" 3:4-3:5
main:       link 1:9-1:16, text 1:17-1:18
branch:     link 1:9-2:3,  text 2:4-2:5      (columns now right, line still one short)
```

I wouldn't call this a real regression; the drift comes from the wikilink. It shows up as "worse" only because my out-of-bounds check passes on `main` by chance. The fix would go in `handle_wikilink`: advance the line state over newlines it consumes, the same way the branch now does for links.

### Pre-existing position bugs the branch leaves alone

These are worth knowing because a slicing consumer will hit them:

- **Block end columns on tab-indented continuation lines.** Inside list items, the end column counts tabs as expanded columns, so it can run past the line. Examples: `html_block`, `list`, `item`, `heex_block`. Repro: `* <b>\n\t[^n]]]` gives `html_block 1:3-2:9` on a 7-byte line.
- **A tab partly consumed by list indentation, on a lazy continuation line.** Columns shift by one and can land mid-character. This was found by the second reviewer and is identical on `main` and the branch. Repro: `printf '1. 1. x\n\téa\n'` gives `Text("éa") 2:3-2:5`. Column 3 is the second byte of `é`, and column 5 is past the 4-byte line.
- **Description-list terms with multi-byte text.** These end in the middle of a character: `語é\n: d` gives `description_term 1:1-1:1` and `paragraph 1:1-1:1`, where byte 1 is inside `語`. Slicing a `&str` there panics.
- **`sourcepos_chars`.** The conversion splits lines with `str::lines()`, which doesn't treat a lone `\r` as a line end. The block parser does, so on lone-`\r` input the char columns are computed against the wrong line.

There is a practical difference in the two regressions above. A consumer that indexes without checking gets silent wrong text from `main`, and it panics on some of the same inputs with the branch, because the line is now correct and the stale column falls past its end. Whatever you push, the consumer side wants a guard: clamp or reject a span whose line or column falls outside the input, and use `str::get(..)` or check `is_char_boundary` rather than indexing directly.

## Other observations

- **Behavior change from upstream.** Commit `0d90298` changes upstream's test expectations for #572: a link whose tail spans lines now ends at its closing `)` (the `2:12` the issue asked for), not at the destination. That's an improvement. Anyone comparing this fork's positions with upstream comrak will see a difference there.
- **`removed_lines` is additive.** It uses `+=` and is `mem::take`n by the table split, so a second call to `resolve_reference_link_definitions` on the same block would be handled. I found no path that makes that second call.
- **Tests.** The added tests cover the fixed cases well. None covers inline footnotes or wikilinks combined with a multi-line link tail. The two regression repros above would make good tests if anyone later touches those paths.

## Evidence and method

- **Code reading.** I read all non-test changes in context, including the `Subject` line and column state, `adjust_node_newlines` (the existing pattern the new code copies), `handle_close_bracket`, `handle_inline_footnote`, `add_line`, and the table-preface split.
- **Differential fuzz harness.** Rust, built against `git archive` copies of both revisions with overflow checks and debug assertions on.
  - Token-soup inputs: 8 seeds × 150k inputs × 2 option sets.
  - Line-structured inputs: 8 seeds × 150k inputs, with block prefixes (`> `, `- `, `1. `, tabs, `: `, `>>> `, footnote definitions), link reference definitions with multi-line titles, table rows, setext underlines, multi-line link tails and attributes, `\r`, `\r\n`, and multi-byte text.
  - A further 960k structured inputs × 3 option sets with the CRLF break allowance.
- **Rendering differential.** `markdown_to_html` plus `markdown_to_commonmark` with sourcepos off, 1.2M inputs × 2 option sets, hashed per input. Branch and `main` output were **identical for every input**.
- **Test suite.** `cargo test --all-features` on the branch passes.
- **Scratch files.** The harness and raw results are in `/private/tmp/claude-505/-Users-josephwecker-v2-src-arch-firmatum-udon/d28cb106-6ce2-4002-bf8d-098f6a13bb5f/scratchpad/` (`h/src/main.rs`, `runs/`). They're session scratch and will not persist.

**Limits of what this shows.** The fuzzing is grammar-based random testing, not coverage-guided; `cargo-fuzz` isn't installed here. The out-of-bounds check is structural: it catches positions outside the input, not positions that are inside the input but wrong. The `Text`-slice check catches some of those, and it improved on the branch (inputs with a mismatch went from 317k to 229k in the CommonMark-plus-tables set), but it isn't a full correctness oracle. `phoenix_heex`, `shortcodes` and the syntect plugin were built but not fuzzed specifically.
