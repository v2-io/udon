# W2. Attribute traits as slot types (`:when.date`): dead, and why that matters

*Wildcard fork, spike a. Status: **dead**. The reason it died is the finding.*

## The idea

W1's other half. If an element name says what the value *is*, a trait on the attribute name could say what the *slot* is: `:port.u16 8080`, `:when.date 2026-07-21`, `:timeout.duration 5m`. It reuses the trait ("what kind of thing", **checked** [[def:trait]]), and it collides with nothing: the label lean makes `.` an error inside an attribute name (**checked**, `.int/labels-ascii-and-positions-2026-10-20.md`), so the spelling is free. It also avoids the `:port:u16` collision with namespaced names like `xlink:href`, which sit on the same character.

## Pushing it

```udon
|svc :port.u16 8080 :port 443
|ev :when.date 2026-07-21
  :when.datetime 2026-07-22T09:00
```

- Stacking: `:port.u16 8080 :port 443` gives one slot two occurrences, one typed and one not. Which is the slot's type?
- `:when.date` and then `:when.datetime` give one slot two types.

Once the trait is written on an *occurrence*, it says what *this value* is, not what the slot is. The slot is the same `when` in both lines; only the values differ. So a slot type written per occurrence is a literal annotation in slot clothing: everything it can say, W1 says on the value, where stacking and mixing are honest.

## The finding

**A real slot type is declared once per element type (or per document kind), never per occurrence.** In the document, that means a declaration (a header, a directive), which lite doesn't have ("no `!` directive" is Joseph's own note, in the A3 discussion in the span). Outside the document, it means a schema, a vocabulary, or a convention such as `file-name.schema-name.ud`.

So under lite, Joseph's distinction separates cleanly:

- *what my literal represents*: in the document, on the value (bare by the standard set, or an element per W1);
- *what the slot is*: never in a lite document; always outside it (a schema or a convention), or in full UDON's directives.

That also says what lite owes the slot-type layer: an address for every slot (element path plus attribute name), and the value's spelling kept exactly. It owes no syntax.

His imagined `:when:iso8601 <dt: 2026 PDT>` puts both on one occurrence. Read through this finding, the `:iso8601` there isn't a slot type: it is either the notation for writing it back (canonical display, his C) or a second literal annotation. That's a question for him, not something I can settle.

## What survives

- Reserve `.` in attribute names, as the label lean already does, so full UDON can later give per-slot declarations a spelling if it wants one. The cheapest headroom there is.
- The trailing `:` on attribute names (his light lean) should not be read as a future slot-type position, for the same reason. If it stays, it stays as ornament.

## Against the factors (brief)

A5 domain-forward and A10 self-description (deliberately weighted 5) both argue against per-value slot declarations, as Joseph said of A3: they pull toward "more and more detailed and explicit." The branch failed before scoring mattered: it can't render K7 (`port` = u16 | standard-port) as a slot declaration once, only as repeated per-value claims.
