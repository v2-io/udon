# 88 — Where may `:label` lines sit under an element, and what ends the "attributes first" stretch?

## The question

Attributes can go on their own lines under an element. Several placements are not pinned down:

```udon
|el
      :a 1          ; much deeper than needed
  :b 2              ; shallower than :a, still deeper than |el
  ; a comment
  :c 3              ; after a comment
  |child
  :d 4              ; after a child element (a "late" attribute, file 12 Q3)
```

- Do `:a` and `:b` at different columns both belong to `el`? Is the column difference an anomaly?
- Which things, when they come between attribute lines, count as "content has started" (so a following attribute is late): a comment? a blank line? a child element? a text line? a line with only `$main`-style text?

## Why lite must decide

Late attributes carry a warning in 0.10.0 (file 12 Q3), so what counts as "content started" decides where warnings appear — and, if lite treats warnings as not-valid-lite, which documents are valid.

## What the texts say

- **2011, `udon-c/docs/DECIDED.md` (undecided):** "Allow attributes of a node to continue to be scattered all over the place?"; "Class assignments on their own line?"
- **Dec 2025, 0.7-draft** ("Attributes Before Children"): "Attributes must precede child content. No scattered attributes."
- **K14** (2026-08-09): a `:label` line at the element's attribute column after block content is a real attribute with a warning. **K9:** element-line text does not start content.
- **0.9.1 primer, appendix note 1:** "Which node kinds begin content phase is unstated … Read literally, §6.9 says a **reference** child … closes the attribute window … a comment or blank line surely must *not*. The spec never enumerates."
- **D9 item 3 / UNIF-PASS Q5** (`msc/for-joseph/`): "content phase" retired as a concept after K14; the late-attribute *warning* still needs a trigger.
- **D11** (`msc/for-joseph/01-PLAIN-DECISIONS.md`): is an attribute written after content the same, for sameness of documents, as one written before? Open lean "not significant".
- **0.10.0 §6.9** speaks of "the element's attribute column"; nothing says whether attribute lines of one element must share a column.

## Alternatives

### Columns

**A — any column deeper than the element; no anomaly for mixed columns.** **B — all attribute lines of an element must share the first one's column** (else warning). **C — attribute lines must sit at the same column as the element's content** (children, text).

### What starts content (for the late-attribute warning)

**A — child elements and text lines only.** **B — anything that is not an attribute line** (comments and blank lines included). **C — no warning at all in lite; late attributes are ordinary.** **D — late attributes are reserved in lite** (error, bytes kept).

```udon
|el
  :a 1
  ; note
  :b 2
```
```text
A:  element el  (a 1, b 2)  ├ comment "note"          ; no anomaly
B:  element el  (a 1, b 2)  ├ comment "note"          ; anomaly: warning, late attribute b
```

## Interactions

- [12](12-missing-values-and-what-counts-as-valid.md) Q3, [78](78-what-a-comment-owns.md), [13](13-ast-shape.md) (does the tree keep where an attribute was written?).
