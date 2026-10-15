# Reference links in comrak: what survives parsing, and how to get it back

*2026-10-15, comrak 0.54.0, read from its source in `~/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/comrak-0.54.0/`. Written for whoever needs Markdown to round-trip through comrak.*

## What comrak keeps and what it drops

- **The link keeps only its target.** When `[text][label]`, `[text][]` or `[text]` resolves, `src/parser/inlines.rs` looks the label up and builds a `Link` holding only `url` and `title` (`NodeLink` has no other fields). The label, and which of the three forms was written, are discarded.
- **Definitions leave no node.** `resolve_reference_link_definitions` in `src/parser/mod.rs` strips definitions from the start of a paragraph's text before its inlines are parsed. A paragraph made only of definitions disappears from the tree. The table of definitions (`RefMap`) is private to the parser.
- **The one hook is for missing labels.** `parse.broken_link_callback` is called only when a label has no definition, so it can't report the ones that resolved.
- **comrak's own Markdown output doesn't round-trip links.** `format_link` in `src/cm.rs` writes every link inline, so reference links come back as `[text](url "title")` and all definitions are gone, including unused ones. Two more rewrites, both tested:
  - an inline link whose text equals its URL, `[https://y.org](https://y.org)`, comes back as `<https://y.org>` (`is_autolink`);
  - a bare `www.example.com` comes back as `[www.example.com](http://www.example.com)`.

## Getting the form back without changing comrak

Every `Link` and `Image` keeps a source position (`sourcepos`), and the source text at that position shows which form was written. `comrak-ast --links FILE` (in `comrak-ast/`) does this. For each link it prints the true line and column, the form, the target and the source text:

```
1:26 link reference-full label="Lab"  url="/target"  source="[b][Lab]"
1:46 link reference-collapsed  url="/target"  source="[lab][]"
2:10 link reference-shortcut  url="/target"  source="[lab]"
3:6 link autolink-angle  url="https://x.org"  source="<https://x.org>"
12:37 link reference-shortcut  url="/def-before"  source="[only]"  (lines corrected by +1)
8 definition  source="[lab]: /target \"Title\""
```

The forms are `inline`, `reference-full` (with the label as written), `reference-collapsed`, `reference-shortcut`, `autolink-angle` and `autolink-bare`. It finds where the link text's `]` falls from the end of the link's last child, then reads what follows that bracket: nothing, `[]`, `[label]` or `(`. That also gets one case right that a pattern match on the source would get wrong: `[lab](not a url)`, where the inline form fails and the `[lab]` before it resolves as a shortcut reference.

It then lists the definitions: source lines that no leaf block accounts for and that read `[label]: …`, plus a title written on the next line. With these and the links, the table of definitions can be rebuilt, unused ones and their placement included.

Two position bugs in comrak 0.54 had to be worked around, and both would affect anything that uses inline positions:

1. **When a paragraph starts with reference definitions, every inline position in it is too early by the number of definition lines.** comrak removes the definitions first, then counts lines in the shortened text. The tool tries line shifts from 0 up and keeps the first one under which the paragraph's first text and all its links read back. A search of comrak's issue tracker on 2026-10-15 found no issue for this.
2. **When a link has a line break between its destination and its title or `)`, positions after it on the next line keep the earlier line number, and their columns count on through the line break.** Issue #572 (closed) fixed where such a link ends: it now ends at its destination. The positions after it still drift. Outside containers, converting line and column to a byte offset (line start + column − 1) still lands on the right byte, so the tool doesn't correct for this one. Inside a block quote or list item it misses by the width of the stripped prefix: in `> See [c](/u2` followed by `> "t") then [d](/x).`, stock comrak puts `[d]` two bytes early.

Both bugs are fixed, along with a third of the same kind in the attributes extension, on branch `sourcepos-fixes` of the v2-io fork (`~/src-ext/comrak`, remote `fork` = https://github.com/v2-io/comrak). Its commit messages explain the root causes. With that build, `--links` needs neither workaround: its line-shift search settles on 0, and it gives the same links and definitions as on stock 0.54 (tested on the files above). comrak-ast itself still builds against crates.io 0.54, the version md-press uses. To build it against the fork, point its `comrak` dependency at the clone and drop its `tagfilter` lines; that option is no longer on `Extension` in 0.56.

A security review of the branch found no vulnerabilities: `comrak-sourcepos-security-review.md`. The branch is pushed as `sourcepos-fixes` on the fork.

**Limits:**
- Columns are byte columns. This breaks if `parse.sourcepos_chars` is on.
- Tested on small documents only (block quotes, list items, multi-line link text, images, a code block that holds a `[x]: y` line). Not tested on tabs inside containers, or on links inside tables and footnotes.
- Labels come back as written. CommonMark matches labels after case folding and collapsing whitespace, so `[Lab]` and `[lab]` are the same reference. Grouping them is left to the caller.
- Definition detection is a line heuristic. A definition that continues past a title line, or whose label spans lines, would be missed.

## If round-trip matters enough to change comrak

The smallest real fix has two parts, and either would make a reasonable upstream proposal behind a parse option:

- **Record the form on the link:** in the reference branch of `inlines.rs`, store the label and the form on the node. `NodeLink` is a public struct with public fields, so adding a field breaks downstream code that builds `NodeLink` literals. An optional field on `Ast` (as the attribute extensions use `attrs`) avoids that.
- **Keep definitions as nodes:** a new `NodeValue` variant created where `resolve_reference_link_definitions` now drops them. `cm.rs` would then write `[text][label]` and the definitions back.

The search turned up no upstream issue for preserving reference links either: "reference link", "link reference definition", "round-trip" and "refmap" on kivikakk/comrak, 2026-10-15.
