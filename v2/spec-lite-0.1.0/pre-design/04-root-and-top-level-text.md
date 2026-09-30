# 04 — The implied root node, top-level text, and top-level `:labels`

## Settled

Every document has one implied root node, and everything starts as its children. The root may carry metadata such as the filename (Joseph, 2026-09-29).

## Two questions this raises

### Q1 — How is indentation handled for text at the top level?

For text inside an element, the first text line sets the "content base" (0.10.0 §7.2) and later lines have that many spaces stripped. The texts never state the top-level case (OPEN ROOT-BASE). The old parser silently strips all leading whitespace from top-level text lines.

```udon
  indented first line
    more indented
back to zero
```

**A — the root behaves like any element; the first text line sets the base**

```text
document
├ text "indented first line\n  more indented\n"
└ text "back to zero\n"          ; + anomaly: warning, line shallower than the base (re-base)
```

**B — the root's content base is column 0; nothing is stripped**

```text
document
└ text "  indented first line\n    more indented\nback to zero\n"
```

**C — strip all leading whitespace from each top-level text line** (the old parser's behavior)

```text
document
└ text "indented first line\nmore indented\nback to zero\n"
```

### Q2 — What is a `:label` line at the top level?

0.10.0 (L1): a top-level `:label` is a warning, and the line is kept as document-level text, colon included, because attributes belong to elements and there was no owner. With an implied root node there now is an owner.

```udon
:title My Notes
:author jw
|section Intro
```

**A — keep the 0.10.0 rule: warning + text**

```text
document
├ text ":title My Notes\n"        ; anomaly: warning, top-level attribute
├ text ":author jw\n"             ; anomaly: warning
└ element section
    $main "Intro"
```

**B — they are attributes of the root node (document metadata)**

```text
document
    title  "My Notes"
    author "jw"
└ element section
    $main "Intro"
```

Under B, a sub-question: are root attributes allowed only before the first child, or anywhere (like the late-attribute rule, with a warning)?

## Interactions

- [03](03-semicolon-in-prose.md): top-level text and ` ; `.
- [13](13-ast-shape.md): how the root node and its metadata are represented.
- 0.10.0 §2.1: text-interior exception.
