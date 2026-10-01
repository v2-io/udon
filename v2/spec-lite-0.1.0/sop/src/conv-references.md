---
kind: convention
awaiting-second: true
awaiting-decision: false
needs-work: false
per: [kind-slug-references, kinds-yaml-resolution, typed-reference-fields, cross-store-links, links-to-unwritten-records, templates-are-not-records]
depends: [def:record, conv:records]
---

# References are `[[kind:slug]]`

*Every link names both the kind and the slug, and the store when it is another one. A bare `[[slug]]` does not resolve. Each store's `.vsect/kinds.yaml` says where its kinds are found.*

## Statement

- **Every reference in prose or a table is `[[kind:slug]]`.** The kind may be written as the canonical name or any alias: `[[conv:row-type]]` and `[[convention:row-type]]` resolve to the same record.
- **A bare `[[slug]]` is underspecified and does not resolve.** The linter reports it and names the candidate kinds. It never guesses.
- **Frontmatter fields that point at a single kind take bare slugs** ([[decision:typed-reference-fields]]): `per:` holds decision slugs, `test-fixtures:` holds fixture slugs, and a fixture case's `exercises:` holds rule slugs. Each such field's kind is declared in the store's kinds file (`fields:`). `depends:` can point at rules, definitions, and more, so it takes `kind:slug`, as all prose links do.
- **A reference into another store is `[[store/kind:slug]]`** ([[decision:cross-store-links]]): `[[sop/conv:outline]]` from the spec store, `[[spec/rule:implied-root]]` from this one, `[[references/def:binding]]` for the addressing theory. Each store names the stores it may reference in its kinds file (`stores:`), and the target store's own kinds file resolves the `kind:slug`. Non-record files (influx documents, READMEs, outlines) are still linked by relative path.
- **A link to a record that isn't written yet** resolves to the outline row of its store that names the same `kind:slug`, and is reported as *unwritten*: information, not an error ([[decision:links-to-unwritten-records]]). With no such row either, it is a dangle.
- **Templates are not records.** `TEMPLATE.md` and `<kind>.template.md` files never answer a lookup; each kinds file lists them under `exclude:` ([[decision:templates-are-not-records]]).
- **Cases inside a fixture record** are referenced by path and anchor, e.g. `![[dat/implied-root.yaml#root_two_top_level_elements]]`. A missing file or case id is a dangle, the same as a `kind:slug` that doesn't resolve.
- **Resolution is set per store in `.vsect/kinds.yaml`** (`sop/.vsect/kinds.yaml` for the SOP store):
  - step 1: explicit bindings;
  - then each kind's `find` globs in order, where `<kind>` expands to the canonical name and each alias, and `<slug>` to the slug, over an explicit list of directories (no `**/`);
  - the first existing file whose frontmatter kind matches wins.
- **Paths not listed** (`.old/`, the integration surfaces) never answer live lookups.

## How a violation shows

A bare `[[slug]]`; a `kind:slug` that no step resolves and no outline row names (a dangle); two files that both resolve one `kind:slug` (a collide); a match whose frontmatter kind disagrees with the link; a `kind:` prefix in a single-kind field, or a bare slug in `depends:`; a cross-store link naming an undeclared store.

## Why

- Joseph: "I agree [[kind:slug]] everywhere-- [[slug]] on its own we will consider underspecified and not resolvable" (`sop/influx/jaw-proposal-and-feedback.md` §1.6).
- On the kinds file: "a list of globs with <kind> and <slug> replacement tags, first match w/ correct frontmatter marker wins" (§1.7 item 4); and "Another option is to merge the two and have each kind declare its alias(es) *and* the glob for where they're found" (§1.8).
- "No need to worry about obsidian anymore": limen and vsect resolve links under these rules (§1.6).

## Working notes

- **Notes for the future linter, not rules now** (§3.11):
  - When linting, check every step rather than stopping at the first hit, so collisions show up.
  - Write each checked resolution back into `bindings`, so a moved file shows as a dangle instead of a silent miss.
- **Fixture-case transclusion stays a path** (`![[dat/implied-root.yaml#id]]`), Joseph's own form in §1.6. Whether it should become `![[fixture:implied-root#id]]`, like other references, is not decided.
- **`exercises:` is declared in the spec store's `fields:`** (as `rule`), though it is a field on fixture cases rather than on frontmatter, and [[decision:typed-reference-fields]] names only `per` and `test-fixtures`. Declared on the reading that a linter will check case-level fields too; that reading is the coordinator's lean, not yet a decision.
