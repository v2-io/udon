# 51 — Can two sibling elements be written on one line?

*Raised by the history survey (files 50–69), 2026-09-29. Neutral: the question, the alternatives, and where it has come up. Sources are pointers for the second pass, not authority.*

## The question

Table rows (`|tr |td A |td B`), short lists (`|ul |li one |li two`), and nav bars want several **siblings** on one line. Under the column rule, a later `|name` on a line sits at a deeper column than the one before it, so it is a **child** (or a `$main` value — see [01](01-sameline-element-child-or-value.md)), never a sibling. Does lite have a same-line sibling form, and if not, is that stated as a deliberate gap?

## Where it has come up (chronological)

- **2011 (`_older/udon/examples/overview.udon`)** shows `|table |tr |td hello |td you` and `|tr |td First stuff <|td Second stuff`, apparently meant as sibling cells, alongside the rule `|one|two|three ==> |{one |{two |{three}}}` (strict nesting) in `_older/udon-c/docs/DECIDED.md`. The 2011 notes also float `|list | one | two | three` ("automatic awesome looking lists") using a pipe-space text marker — `| ` is now plain text to protect Markdown tables ([08](08-pipes-and-markdown-tables.md)).
- **2025-12-23, Joseph** (correcting a table example): *"What I'm now realizing, though, is that embedding blocks in text doesn't necessarily give us a syntax (yet) for same-line-siblings..."*
- **2025-12-24, Joseph**, on placing later lines: *"You *only* care about the previous line … you don't 'track' columns for inline stuff except for knowing what the very next line is child of."*
- **Dec 2025 → Jul 2026 specs and tutorials** settle on: siblings come from the *next* line at the same column (`|tr |td A1` then `|td A2` aligned under the first `|td`), with the idiom "when in doubt, expand to the vertical form."
- **K9 (2026-08-08)**: `|ul |{li one} |{li two}` gives two stacked `$main` values. That is a same-line way to write several nodes, but they are values of the parent, not children, so they are not the same tree as the vertical form.

## Alternatives

### A — no same-line sibling form; say so

```udon
|ul |li one
    |li two
```
```text
document
└ element ul
    ├ element li  ($main "one")
    └ element li  ($main "two")
```

Column alignment is the only way to get siblings; one-line forms produce nesting or values.

### B — inline elements at the element's value slot count as children (not `$main` values)

```udon
|ul |{li one} |{li two}
```
```text
document
└ element ul
    ├ element li ($main "one")
    └ element li ($main "two")
```

This conflicts with K9's `$main` stacking and with [13](13-ast-shape.md) Q3; listed because it is what the one-line form looks like it means to an HTML author.

### C — reserve a sibling spelling for later

Lite refuses something (for example a tight `|a|b` form, [08](08-pipes-and-markdown-tables.md) alternative D) so a future sibling syntax stays possible.

## Interactions

- [01](01-sameline-element-child-or-value.md): child vs value on the line.
- [08](08-pipes-and-markdown-tables.md): tight `|a|b|` forms.
- [13](13-ast-shape.md) Q3: whether `$main` values and children are presented differently.
