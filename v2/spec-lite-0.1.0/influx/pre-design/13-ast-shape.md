# 13 — The shape of the lite tree

## Settled (Joseph, 2026-09-29)

- Lite is specified as the tree it produces, not as an event stream.
- There is one implied root node; everything starts as its children, and the root may carry metadata such as the filename.

This file lists the shape choices a tree spec has to make. Background: 0.10.0 `MODEL.md` (element = name + ordered attributes + ordered content; `Assignment = {label, content}`); K15 (stacking and its "default read").

## Q1 — The root node

```text
document  (meta: filename "notes.udon")
├ …
```

Is the metadata part of the tree (like attributes), or outside it (parser-supplied, not from the text)? If top-level `:label`s become root attributes ([04](04-root-and-top-level-text.md) option B), are they kept separate from parser-supplied metadata?

## Q2 — `[key]`, `.traits`, and element-line text: attributes, or dedicated fields?

```udon
|user[jw].admin Joined 2025.
```

**A — designated attributes (0.10.0: "sugar is designated attributes, never parallel fields")**

```text
element user
    $key    "jw"
    $traits "admin"
    $main   "Joined 2025."
```

**B — dedicated fields in the tree** (the `$` attributes still exist in the model, but the tree presents them as fields)

```text
element user  key="jw"  traits=["admin"]
    main "Joined 2025."
```

## Q3 — `$main`: an attribute, or the element's first text?

0.10.0: `$main` is an attribute, not text. The element's own line and a text block under it are different documents; the host decides presentation.

```udon
|p Hello there.
|p
  Hello there.
```

- **A)** Different trees: `$main "Hello there."` vs `text "Hello there.\n"`.
- **B)** The same tree: the element's-line text becomes the first text child.

## Q4 — Repeated labels (stacking)

```udon
|el :x 1 :x 2 :y [3 4]
```

- **A) Ordered list of (label, value) pairs**, as written:
  `[(x,1), (x,2), (y,[3 4])]`
- **B) Map from label to the list of its contributions:**
  `x: [1, 2]`, `y: [[3 4]]`
- **C) Map with the default read (K15):** one contribution gives the value, several give a list. So `x: [1 2]`, `y: [3 4]`.
  - Under C, `:x [1 2]` and `:x 1 :x 2` read the same.

## Q5 — Text in the tree

```udon
|p
  Line one
  line two

  New paragraph |{em here}.
```

- **A) One text node per source line**, blank lines as their own nodes:
  ```text
  element p
      ├ text "Line one\n"
      ├ text "line two\n"
      ├ blank
      └ text "New paragraph " · inline em("here") · ".\n"
  ```
- **B) Adjacent text merged into runs**, pieces inside:
  ```text
  element p
      └ text "Line one\nline two\n\nNew paragraph " · inline em("here") · ".\n"
  ```
- **C) Paragraph nodes split at blank lines.** This one goes beyond UDON, into Markdown territory.

Also: are blank lines at the edges of a block (between structure) kept or dropped? 0.10.0 calls them "ornamentation."

## Q6 — Comments in the tree

Kept as nodes (0.10.0: comments are carried, never discarded), or dropped by default?

## Interactions

Nearly every other file.
