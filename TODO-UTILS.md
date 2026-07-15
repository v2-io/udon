# TODO-UTILS — udon-utl

The utilities payload (the "safe set" for vivarium / ASF): accessors, tree
helpers, conversion, formatting, guarantees. *Co-locates with `udon-utl` when
that crate lands; at root for now.* Predicated on a compliant parser.

## Open

- [ ] **Accessors** — `attr` (scalar/last) + `attr_all` (list); `traits` view
      always a list; host views. (Pull the accessors item from `core/PLAN.md`.)
- [ ] **Conversion** — `udon2md` / `md2udon` over the real parsed tree (Layer 3;
      degradation policy per `spec/MARKDOWN.md`).
- [ ] **`udon fmt`** — optional; UDON mandates no canonical form, so only if we
      choose to offer one. *(discuss w/ Joseph)*
- [ ] **Guarantees / validation** — `design/udon-guarantees.md` explores the
      space; extract tasks here.
