# 80 — Which spaces and line breaks are part of the content?

## The question

Where exactly do spaces and newlines belong to a value or a text, and where are they just layout?

```udon
|el :a hello   world   :b 1   
|el    Some title
|p
  A paragraph that the author
  wrapped by hand.   
  
  Second paragraph.
```

- Is `a` `"hello   world"`, `"hello world"`, or `"hello   world   "`?
- Is the element-line text `"Some title"` or `"   Some title"`?
- Is the paragraph `"A paragraph that the author\nwrapped by hand.   \n"` — newline and trailing spaces kept — or is the hand-wrap a soft break, as in Markdown and HTML?
- Is the line holding only spaces a blank line or a line of text?

## Why lite must decide

JSON and YAML users expect values without stray spaces; XML/HTML users expect text whitespace to be kept exactly (XML) or collapsed (HTML rendering). Two lite parsers that trim differently produce different trees from the same file, and editors routinely strip trailing spaces — which would then change a lite document's content.

## What the texts say

- **Text law** (0.10.0 MODEL §6; ruled 2026-07-19, CHANGELOG TEXT-WIRE): "document text reconstructs by pure in-order concatenation"; "each text line's terminator is part of its text; stripped indentation is geometry." So line breaks inside prose are content, not soft wraps.
- **0.10.0 §7.4:** a whitespace-only line that does not reach past the text's indentation is a **blank line**; whitespace "protruding past the base is text content." Leading/trailing blank lines at structure boundaries are "ornamentation … or kept as literal blank-line nodes for reversibility." "Final-terminator disposition": the last newline of a run is ornamental unless written as a trailing `\`.
- **2026-01-13 parser session** (memorata, libudon `4974eeaf…jsonl:1516`): "Whitespace-only lines … treated identically to blank lines (emit BlankLine); do NOT trigger indentation warnings." **`spec/TODO-SPEC-CORE.md`** (Jul 2026) still lists "whitespace-only lines in prose" as an unruled silence: the parser emitted blank for empty lines but a residual-whitespace text for spaces-only lines — "consumers treating Text as 'has content' will trip."
- **0.10.0 §5.6:** inside `|{…}` "intervening text between nested inline forms — including a single space — is interior content"; at a value slot, "whitespace between values is a separator."
- **0.10.0 §8, S18:** the spaces around an inline comment `;{…}` are kept as text.
- **Nothing found** in 0.9, 0.9.1 or 0.10.0 about: trailing spaces at the end of an unquoted value or a text line; runs of spaces inside an unquoted value; spaces between a value and the next ` :label` or ` ; `; spaces between an element's name and its line text. (Searched: `grep -n -i 'trailing space\|trailing whitespace\|trim\|internal space\|single space\|whitespace'` over `v2/spec-0.10.00/{CORE,MODEL,SEMANTICS}.md`; memorata "udon trailing whitespace at end of line".)
- **2026-07-29 md-press probe** (memorata, udon `fc191a72…jsonl:721`): newlines in UDON text are "literal content, not collapsible whitespace like in Markdown. So even pure prose-paragraph joining … silently edits the reconstructed document value in UDON."
- **Converter practice** (`bin/xml2udon`): collapses runs of whitespace to one space (`gsub(/\s+/, ' ')`) and strips unless `--preserve-whitespace`.
- **Old parser (evidence only):** `|el :a hello   world   :b 1   ` → one text value `"hello   world   :b 1   "` (runs and trailing spaces kept); a prose line's trailing spaces kept.

## Alternatives

### Unquoted values

**A — exact:** every byte between the value's start and its terminator. **B — trim the ends, keep inner runs.** **C — trim the ends and collapse inner runs to one space.**

```udon
|el :a hello   world   :b 1
```
```text
A:  a "hello   world  "        ; up to the space before :b (or including it?)
B:  a "hello   world"
C:  a "hello world"
```

### Text lines (block prose)

**A — exact, including trailing spaces and each newline** (text law). **B — trailing spaces on each line dropped; newlines kept.** **C — newlines inside a paragraph are soft (become spaces); blank lines separate paragraphs** (Markdown/HTML).

```udon
|p
  wrapped by   
  hand.
```
```text
A:  text "wrapped by   \nhand.\n"
B:  text "wrapped by\nhand.\n"
C:  text "wrapped by hand."
```

### Element-line text

```udon
|el    Some title   
```
**A — `"Some title   "`**, **B — `"Some title"`**, **C — `"   Some title   "`**.

### Whitespace-only lines

**A — blank line (0.10.0, when not past the text's indentation).** **B — always blank.** **C — text of that whitespace.**

## Interactions

- [71](71-how-far-an-unquoted-value-runs.md): where a value ends decides which spaces are "inside" it.
- [13](13-ast-shape.md) Q5: text nodes and blank lines in the tree.
- [79](79-line-endings-encoding-and-columns.md): `\r` before `\n`.
- [85](85-canonical-writing-form.md): a formatter that trims trailing spaces changes content under "exact".
- [10](10-inline-elements-and-inline-comments.md): spaces between inline elements.
