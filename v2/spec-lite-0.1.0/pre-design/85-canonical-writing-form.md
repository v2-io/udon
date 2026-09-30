# 85 — Does lite say how tools should *write* lite?

## The question

Lite defines how a file is read. Does it also say how a program should write one — indentation unit, where attributes go (on the element's line or below), when to quote, whether to wrap long text — or at least a default for tools that must choose?

```udon
|user[jw] :name "Joseph Wecker" :role admin
  Bio text.
```
```udon
|user[jw]
    :name Joseph Wecker
    :role admin
    Bio text.
```

Two writers, one tree? Almost: 0.10.0 §6.3 keeps a quoted string (`"Joseph Wecker"`) and an unquoted text value (`Joseph Wecker`) as different kinds of value, so even this pair differs in one detail. More write choices that change the tree are listed below.

## Why lite must decide

Lite is going to be produced by converters (XML/JSON/YAML → lite) and by agents editing files. Without any shared default, tools re-indent each other's output; with a required canonical form, every formatter becomes a de-facto spec. Several write choices also change the tree, not just the look.

## What the texts say

- **IND and IND-2** (`v2/OPEN.md`; 0.10.0 CARVEOUTS §IND): "when a tool computes insertion indentation and the destination has no siblings to read from, no ratified rule names the default unit." Cross-model review (agy, `spec-0.09.01/.reviews/`): "without one, different tools pick different defaults and thrash a file's indentation across agents"; suggested "The spec `SHOULD` define a standard default indentation (e.g., 2 spaces) for automated generation." Joseph, 2026-07-21 (STEWARD-CALLS #5): add it unless redundant; it was checked and is not redundant.
- **0.10.0 §2.1:** "A consistent sibling indent (commonly 2 spaces) is RECOMMENDED style, not a rule of the language."
- **`udon fmt` tabled** (`TODO-UTILS.md`), Joseph 2026-07-16: "needs a much bigger ux prioritization discussion"; effort there "would end up being friction for adoption when the same effort could be spent on an actually principled tool" (the agentic edit tool). Context recorded with it: "UDON mandates no canonical form, so shipping a formatter creates a de-facto one."
- **Tree-changing write choices in 0.10.0:** element-line text vs text on the next line are different trees (§6.10, "reflowing between them is a semantic edit"); `:x 1 :x 2` vs `:x [1 2]` read the same by default but are recorded differently (K15, "ornamentation … the assembler MAY annotate the flavor"); re-wrapping prose changes text content (file 80); quoting a number makes it a string (file 72).
- **2026-01-02, Joseph** (`~/.claude/history.jsonl` lines 6957, 6973, layout as typed), on converter output: "if you're doing single line for xml, do single line for the UDON-- it's just as simple." And:
  ```text
  typically udon will have a lot more sameline:
                 |li.menu-item
                   |a :href /about
                     About

  |li.menu-item |a :href /about About
  ```
- **Editor defaults** (`ux/README.md`, vim): `expandtab shiftwidth=2`; "**Do not `gq` UDON prose** — until a udon-aware fill exists … reflow can silently promote wrapped sigil-initial words to structure."
- **Converters** (`bin/xml2udon`): 2-space indent; `id`/`class` as `[key]`/`.traits`; attributes on the element's line; inline forms when an element holds only text.

## Alternatives

### A — lite says nothing about writing

### B — lite names defaults for generated output, not binding on authors

For example: 2-space indent; attributes on the element's line up to some width, then one per line below; quote only when needed; never re-wrap text; keep the author's form when editing.

### C — lite defines a canonical form, and "canonical lite" is a checkable property

### D — only the one missing fact: the default indent unit when a tool has nothing to copy

## Sub-questions under B or C

- Which of the tree-changing choices above must a converter make one particular way (for example: JSON strings with newlines → text lines under an element, or a value under an attribute — file 74)?
- Does "quote only when needed" have to know every value rule (numbers, keywords, markers — files 71, 72)?
- Is the default indent measured from the parent's `|` column (the Nesting Rule) or from the start of the line?

## Interactions

- [80](80-which-spaces-are-content.md): trimming and wrapping change content.
- [73](73-is-the-element-line-a-typed-value.md) and [13](13-ast-shape.md) Q3: element-line text vs text below.
- [86](86-mapping-to-json-xml-yaml.md): converters are the first generators.
