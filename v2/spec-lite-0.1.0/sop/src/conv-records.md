---
kind: convention
awaiting-second: true
awaiting-decision: false
needs-work: false
per: [one-record-per-file, kind-in-frontmatter, directories-organizational, templates-are-not-records]
depends: [def:record, def:record-kinds]
---

# One record per file; kind in frontmatter; directories organize

*A file holds one ⟦record⟧, of one ⟦kind⟧, with one frontmatter. The frontmatter declares the kind. Directories and slug prefixes are organizational clues and carry no meaning.*

## Statement

- **One record per file.** A file holds exactly one record, of one kind, with one frontmatter. Records are not mixed within a file.
- **The kind is declared in frontmatter** (`kind:`), using the canonical kind name. For a fixture file, the declaration is a top-level YAML key.
- **A record's ⟦identity⟧ is the pair (⟦kind⟧, ⟦slug⟧).** The slug only needs to be unique within its kind.
- **Directories are organizational only.** A record's directory implies nothing about it, and that is not enforced for now. Tooling finds the records of a kind wherever the kinds file says to look.
- **A template is not a record.** A file named `TEMPLATE.md` or `<kind>.template.md` has a kind's shape but asserts nothing. It never answers a lookup, and the kinds file excludes it ([[decision:templates-are-not-records]]). An outline may still list it as a `template` row.
- **A slug prefix or home directory is at most a clue to the kind.** Naming a record with another kind's prefix is an error wherever the file lives, e.g. a fixture file named `rule-…`.

## How a violation shows

- Two frontmatter blocks in one file.
- A missing `kind:`, or a `kind:` that isn't a declared canonical name.
- A prefix that names a different kind than the frontmatter declares.
- Two records with the same (kind, slug).

## Discussion
- Joseph: "frontmatter declares kind, and its home directory and slug prefix *can* be clues / quick indications for kind … So naming one kind of record with a prefix of another kind of record is *definitely* a problem regardless of how they're organized" (`sop/influx/jaw-proposal-and-feedback.md` §1.5).
- Also Joseph: "subdirectories are … for organizational purposes only-- I don't believe the directory that stores an atom should be used to imply or indicate anything other than that" (§1.4).
- And: "for right now we need to *not* allow mixing -- because we have no good way to have multiple frontmatters in a single markdown segment, as well as the fact that we've pretty much just landed on addressing having files as a referent" (§1.6).
- Horizon: full udon's logical stores (don) will make records addressable like a database. This is intermediate practice toward that (§1.6).

## Working notes

