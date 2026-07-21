# Open Questions

**Normative as to scope:** each item below is *deliberately undefined* in
this draft — authors MUST NOT rely on any particular behavior, and
implementations MUST NOT treat their own behavior as settling it. The
recommendation column is the drafter's judgment, marked as such, not a
ruling.

| # | Question | Decision space | Drafter's recommendation |
|---|---|---|---|
| Q1 | Attribute at document root (`:key` with no owning element) | free-floating attribute / text / error | Text with a warning — it preserves keep-everything, and a root "attribute" has no edge to hang from; a free-floating attribute invents a phantom owner. |
| Q2 | Kept shape for attribute-under-attribute (`:key` directly under an open value) | text of the open value + error / sibling warned extension / drop | Text of the open value + error (as drafted §5.6) — closest to what the author wrote, and the error names the named-carrier idiom. |
| Q3 | Framed ` ; ` comments inside inline elements (incl. after value-`\` text) | stay literal / gain comment semantics | Stay literal. `|{…}` interiors are flow; the framed-comment carve-out exists for *line* tails, and two comment channels inside one brace form is more rule than value. |
| Q4 | Inline verbatim `!{:kind:…}` in attribute-value position | allowed (flow segment) / allowed (verbatim value) / undefined | Allowed as a flow segment — it already is one in prose; value position should not create a second reading (mirrors the inline-form principle). |
| Q5 | Reference selector model vs. a path syntax | keep `(name, key, traits)` / replace wholesale with paths | Keep the tuple until paths arrive *whole*; do not grow the tuple incrementally (each addition is future path debt). |
| Q6 | Rational (`1/3r`) and complex (`3+4i`, `5i`) literals | bare scalars / standard-types dialect `<r: …>` `<i: …>` / split (complex bare, rational dialect) | Both to the dialect. The bare set's value is that it is small and closed; "single number with a suffix" arguments will recur for every future type, and the envelope was built for exactly this. |
| Q7 | Nested-envelope routing (`<r: <i: 3 -7> 0d83.23>`) | grammar consumes and hands off / active dialect drives an implicit dialect stack | Dialect-driven: the core guarantees only the `<>`-balanced span; typing composition is meaning, and meaning is the dialect's. |
| Q8 | Multi-line span for the remaining delimited forms (strings, lists, identity brackets, interpolations, `;{…}`, `!{…}`) | each: content / close-at-terminator-with-warning / illegal-with-warning | Make strings, lists, and interpolations multi-line (structured values want it; the incomplete-input result already covers truncation); keep identity brackets line-bound with warning (a key spanning lines is nearly always an unclosed bracket); decide `;{…}`/`!{…}` with the dialect work. |
| Q9 | Line-comment continuation stripping | content-base shape (first continuation line sets strip column — as drafted §6.4) / verbatim from the comment's own column | Content-base shape, as drafted — consistent with every other geometric body in the language. |
| Q10 | Mixins (anonymous trait-only element as attribute source) | remain a consumer experiment / promote to a specified host behavior / drop | Remain a consumer experiment; the core already gives it everything it needs (anonymity + traits + a matching rule a host can define). |
| Q11 | Quoted-string interior escaping (a literal `"` inside `"…"`) | none (use the other quote kind) / doubling (`""`) / backslash escape | None. The `\`-is-positional story stays whole, doubling collides with the adjacent-quoted-items reading in lists (`["x""y"]` is two items), and the other-quote workaround covers the practical cases. If real demand appears, doubling inside strings only — never `\` — so §3.5 stays position-pure. |
