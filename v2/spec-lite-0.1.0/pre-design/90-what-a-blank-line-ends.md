# 90 — Does a blank line end anything?

## The question

Indentation decides nesting, so a blank line normally ends nothing. But several constructs open on one line and continue on deeper lines. Does an empty line in between break them?

```udon
|el

  |child              ; still el's child after a blank line?
|task :note

    the value         ; still :note's value after a blank line?
; a comment

  continued?          ; still the comment after a blank line?
|p
  para one

  para two            ; same text, with a blank line inside
```

And where does a blank line **sit** in the tree when it falls between two structures (`|a`'s last line, blank, then `|b`)?

## Why lite must decide

Authors put blank lines between groups for readability. If any construct is broken by one, a harmless-looking blank line changes the tree.

## What the texts say

- **0.9 CORE** (`spec/CORE.md` "Multi-Line Values"): "blank lines behave exactly as they do in prose, no special policy." 0.10.0 §6.5 describes attribute bodies "under ordinary column and content-base rules".
- **0.10.0 §7.4 / S6:** interior blank lines in text are newlines; leading/trailing blank lines at structure boundaries are "ornamentation" or kept as nodes.
- **S9** (`v2/DECISIONS.md`; `.archived/second-pass/RULING-SUPPLEMENT.md` §S9): whether a blank line before a dedent sits inside the still-open element or after it — "Pure stream-ordering/ornamentation choice", deferred.
- **2026-01-13 parser session** (memorata, libudon `4974eeaf…jsonl:1516`): a blank line between child elements emits a blank-line event; "whitespace-only lines … do NOT trigger indentation warnings; do NOT affect content base."
- **Nothing found** stating whether a blank line may separate a comment from its continuation, or a label from its value below. (Searched: memorata "udon blank lines ornamentation between elements"; grep "blank" in `v2/spec-0.10.00/CORE.md` §6.5, §8.)

## Alternatives

**A — blank lines never end anything; only columns do** (the 0.9/0.10.0 direction for text and attribute bodies, applied everywhere). **B — a blank line ends a comment's continuation** (so commenting out one line can't swallow a later indented block — see file 78). **C — a blank line ends an attribute's value below it** (the value must start on the next line). **D — B and C.**

### Placement between structures

```udon
|a
  |x

|b
```
```text
A:  element a (└ element x, └ blank)   ├ element b
B:  element a (└ element x)  ├ blank  ├ element b
C:  element a (└ element x)  ├ element b         ; blank dropped as layout
```

## Interactions

- [13](13-ast-shape.md) Q5, [74](74-attribute-values-on-following-lines.md), [78](78-what-a-comment-owns.md), [80](80-which-spaces-are-content.md) (whitespace-only lines).
