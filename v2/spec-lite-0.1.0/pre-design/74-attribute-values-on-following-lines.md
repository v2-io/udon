# 74 — Attribute values written on the lines below the label, and elements as attribute values

## The question

Can an attribute's value be written on the indented lines under it, and can that value be (or contain) elements?

```udon
|book
  :summary
    A long description that
    runs over several lines.
  :author
    |person :name "Jane Doe"
  :tags
    alpha
    beta
```

If yes: what is `summary` (one text? text with a final newline?), what is `author` (the `person` element itself?), and what is `tags` (one text "alpha\nbeta\n", or two values)?

## Why lite must decide

This is lite's main way to write multi-line text values (YAML's `|` block scalars) and nested records (JSON objects inside objects). 05 covers quoted strings and `[…]` lists continuing across lines; this is the other, indentation-based route. It also decides whether lite trees can have element-valued attributes at all, which XML cannot express (Joseph, 2026-01-13, imagining a "udon-xml" flavor: "limited to forms that can be expressed in XML naturally — e.g., no complex elements as an attribute's value").

## What the texts say, in date order

- **2011, `udon-c/docs/DECIDED.md`:** "GRIM ATTRIBUTES — act just like nodes except what would be the 'node-name' isn't a child of the parent but a unique, unordered attribute of the parent." And: "If you need a freeform text value — for example, unbalanced parenths, you need to use a grim attribute and put the text, indented appropriately, on the next line."
- **Dec 2025, 0.7-draft** (`_archive/SPEC.md` §Complex Attribute Values): "Attribute followed by newline+indent = structured value", example `:headers` with two indented `|header` elements.
- **2026-07-15, 0.9** (`design/attribute-model-proposal-3*.md`; CHANGELOG 0.9.0-alpha.1): "Attribute values may be nodes, text blobs, or segment arrays — edges may terminate at nodes; 'attributes are typed scalars' is retired." "Deferred block": if the label's line has no finished value, the deeper lines are the value. At that time `:headers` with two `|header` lines got **one** node plus a warning for the second (CORE 0.9 "…though note `:headers` here gets exactly **one** node").
- **2026-07-20, archived night session** (`.archived/second-pass/spikes/session-vault/raw/grok/019f67df-orientation.md` L1674–1706), Joseph, verbatim with the file's indentation ("I'm still undecided"):
  ```udon
  |e :attr v |child
               :another-attr?

               :and-another-one [1 <u64:123>] :this-one-is-ok-too because this text clearly is the value for the attribute ; and this is a comment

               :also this one
                  this form is just as good and should be allowed under the
                  premise that multiple sequential texts are equivalent to their concatenation

               :but-this-one <7:02pm>
                 should throw an error because this text is trying to bind to the attribute that already has a value

               :this-one-though <1M> and here is some dangling text ; I vote error because it's unambiguous to the parser but likely ambiguous to user
                                                                    ; and because conceptually it's equivalend to the one right above
               This text is unambiguously a child of child.
     :this will get a warning but is normal text because additional attributes for |e were foreclosed when |child changed the phase to children...
  ```
  "So the ':but-this-one' is unambiguously an error." Two ideas here that later rulings changed: a value **started** on the label's line may **continue** on deeper lines (`:also this one` …), and deeper text after a finished value is an error.
- **2026-07-29** (`theory/to-integrate/refine-more/thoughts-on-multiline-array.md`), Joseph: "A cleaner option is to simply lean into the stacking we already do and simply allow an attribute to have multiple children and call it an array without warning about it like we currently do. It's a regulator that no one asked for but that I put in there when I was afraid the format was getting too loose and was prone to exploding. But that doesn't seem to scare me anymore in this case."
- **2026-08-07, K4–K7** (`v2/DECISIONS.md`): K5 "attribute-content unification … block-context only"; K4 no attributes of attributes (a `:label` line directly under an open attribute is warned text — K8); K6 a `:label` with nothing on its line **and nothing indented under it** is the missing-value error; K7 "value position is a position, not a mode — deferred attributes' first body line carries it": `:port` + deeper `5432` → integer; later lone tokens are text ("re-wrapping prose must never retype a document"). Joseph's worked example → `[1234, "and here is\n  a bunch of prose...\nso what do we do?\n"]`.
- **0.10.0 §6.5, §6.8** carry all of this; sameline `:x |em hi` also makes `em` the value, and "the one-way door" gives the rest of that line to `em`.
- **Maps of maps** (0.10.0 §6.8): "take a named node carrier: `:theta` + deeper `|config :first 1 :second 2`."

## Alternatives

### A — no values on following lines in lite; values are single-line only

```udon
|book :summary "A long description that runs over several lines."
```

Multi-line text goes in the element's text; records nest as child elements, not as attribute values. `:summary` alone at end of line is the missing-value case (file 12).

### B — following lines hold **one text value** only (YAML block scalar)

```text
document
└ element book
    summary "A long description that\nruns over several lines.\n"
    author  "|person :name \"Jane Doe\"\n"   ; or: refused — structure not allowed here
    tags    "alpha\nbeta\n"
```

### C — following lines hold one value, which may be one element (0.9)

```text
document
└ element book
    summary "A long description that\nruns over several lines.\n"
    author  element person
              name "Jane Doe"
    tags    "alpha\nbeta\n"
```

A second element under `:author` would be a warning (0.9) or an error.

### D — following lines are the attribute's content, like an element's content: any mix of text, elements, and a typed first line (K5/K7, 0.10.0)

```text
document
└ element book
    summary "A long description that\nruns over several lines.\n"
    author  element person
              name "Jane Doe"
    tags    "alpha\nbeta\n"          ; one text run (only the first line is typed)
```

and

```udon
|el
  :recipe
    1234
    and here is prose
    |step :n 1
```
```text
document
└ element el
    recipe [1234, "and here is prose\n", element step (n 1)]
```

### E — as D, but each following line is its own value (lines become list items)

```text
    tags ["alpha" "beta"]
```

### F — a value started on the label's line may continue on the deeper lines (Joseph, 2026-07-20)

```udon
|el
  :note this starts on the label's line
    and continues here
```
```text
document
└ element el
    note "this starts on the label's line\nand continues here\n"   ; joined by a newline? a space?
```

Under 0.10.0 the words on the label's line are a finished value, so the deeper line is something else (see the first edge case below).

## Edge cases any alternative has to state

```udon
|a
  :x 1
    more            ; finished value on the label's line, then deeper text: error? text of a? more of x?
|b
  :x
    :y 1            ; label-shaped line under an open attribute: text of x (0.10.0, warned)? error?
|c
  :x                ; label line, then blank line, then deeper text — does the blank break it?

    later
|d :note ; a comment
    body            ; does the comment own this line, or does :note? (see 78)
|e :x |em hi :y 2   ; the one-way door: y belongs to em
```

## Interactions

- [05](05-values-across-lines.md): the delimited route to multi-line values.
- [12](12-missing-values-and-what-counts-as-valid.md): `:label` alone is the missing-value error only when nothing is indented under it.
- [01](01-sameline-element-child-or-value.md): the one-way door.
- [72](72-which-bare-words-are-numbers-booleans-nil.md): first-line typing.
- [78](78-what-a-comment-owns.md): a trailing comment on the label's line.
- [86](86-mapping-to-json-xml-yaml.md): element-valued attributes have no XML spelling.
