# A term definition written in UDON: Joseph's refinements (2026-11-23)

*Set aside for when term definitions are actually written in UDON. Joseph's reaction to the «element» entry in the second OCaml spike's data file (`msc/spikes/2026-11-23-ocaml/spike-2-udon-ddd-adts/data/udon_part1.ud`), shown to him by a Claude Fable 5.2 session. His words and his example are verbatim. Nothing here has been applied to the spike, to `spec/.kinds/term.kdl` or to any definition.*

## What he was shown

```udon
|term[element].accepted.foundation.has-file A node with at most one element-name, unordered attributes, and ordered child nodes.
  :kind    full-term
  :pos     noun
  :pl      -s
  :backing @v:p-element-def
  |avoid :word "tag" \ in HTML and XML a tag is the delimiter in source, not the thing it makes
  |rel :verb "has"       :to @[attribute] :card {0,N} :note "unordered across distinct names"
  |rel :verb "has-child" :to @[node]      :card {0,N} :note "strictly ordered"
  |invariant A parser never reorders an element's child nodes.
  |invariant Two elements differing only in distinct-attribute order are the same element.
  |example A user element with $key, $traits, role, and one text child.
  Everything else written on an @{element} ($key, $traits, $main) is an @{attribute}, not a separate AST part.
```

## His version

"Seems like it could be cleaned up a touch:"

```udon
|full-term[element].draft    A node with at most one element-name, unordered attributes, and ordered child nodes.
  :alt             elements element's elements'  ; Easier to do a few of these than to build machinery around '-s' etc.
  :backing         @v:p-element-def  ; Not sure yet what this is-- I mean, notation is fine-- but semantically- the schema?
  |avoid[tag]      In HTML and XML a tag is the delimiter in source, not the thing it makes
  |rel             :is-a       @[node]       ; or something else to show subset relationship?
  |rel[attributes] :has        @[attribute]  :card {0,N}  :note unordered across distinct names
  |rel[children]   :has-child  @[node]       :card {0,N}  :note strictly ordered
  |invariant       A parser never reorders....
  ; ....
```

"Very interesting that the @[...] and @{...} got resurrected a bit here."

## His list

- "I worry about puting '.foundation' trait here-- feels like a segment pointing to a part of an outline that shouldn't be its concern."
- "has-file is discoverable and/or implied by full-term"
- "`|term :kind full-term` is silly when you can say `|full-term`"
- "simplify alternative spellings for grammatical reasons"
- "give relationships a name"
- "other relationship simplifications"
- "set membership / subtypes"
- "name the term to avoid"

## What each would touch (the recording session's notes, not his)

- `:alt` listing the forms outright replaces deriving them from `pos` and `pl`, which is how `spec/.kinds/term.kdl` and address-theory's `declared-inflections` decision do it now.
- `|full-term` as the element's name: the outline's kind column currently says ‹definition› and ‹inline·def› for the same two things.
- `|rel[attributes] :has @[attribute]` makes the relation's verb an attribute name, so a schema for `|rel` has to allow attribute names it has not listed.
- `:alt elements element's elements'` and `:note unordered across distinct names` each rely on how unquoted words on a line are read: the first as three values, the second as one text.
- `:backing`: in the spike it points at a record in the other store (a verisectorium "piece") that tracks this definition's author, version and what has been done to it. It is not the schema.
- The spike wrote references as `@[key]` and `@{term}`, the spec-lite forms, where this branch's prose writes «term».
