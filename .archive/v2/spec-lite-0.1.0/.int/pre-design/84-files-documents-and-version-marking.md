# 84 — Files and documents: one document per file? How does a file say it is lite?

## The question

1. **How many documents in one file?** Always one (with the implied root), or can a file hold several (like YAML's `---` or JSON Lines)?
2. **Kinds of file.** Joseph has distinguished files that are one record, files that are many records, and snippets meant to be pulled into something else. Does lite need to know which kind it is reading?
3. **Marking.** Does a lite document (or its filename) say "this is lite 0.1," and does a parser need to know?

## Why lite must decide

The lite contract — "a document a lite parser accepts means the same under every future version" — holds only for spellings lite reserves. A future version may give meaning to something lite reads as plain text today (for instance `@name` in prose, file 09 Q1). A marker would let a future parser read an old lite file by lite's rules; no marker means lite must reserve everything that could ever change. Tools that glob and sort files also need to know what a file is.

## What the texts say, in date order

- **2011, `udon-c/docs/DECIDED.md` §"ROOT" NODE:** "Implied · ID is file path if applicable · name is basename of path if applicable · several `:__` attributes for metadata — file access time, etc. · stuff isn't, by convention, output during conversions."
- **Dec 2025, 0.7-draft:** file extension `.udon`; no version marker.
- **Jan 2026, `design/udon-ast.md`:** "No implicit root wrapper. This enables: Streaming · Fragments: same type as full documents (useful for includes/templates) · Multi-root."
- **2026-07-11, `design/file-naming.md`** (Joseph, adopted): `<name>.<schema/type>.udon` (e.g. `udon.desc.udon`); "application-level for now, deliberately"; whether it binds to a future declaration "is an open decision we are intentionally not taking today"; "dotted basenames can false-read as designators (`notes.2026.udon`)."
- **Vivarium consumer** (`udon-needs/01-ideation/02-provenanced/copies/I5-live-consumers/consumer-vivarium-tabularium-README.md`): "Filename = `<name>.<root-element-type>.udon`. The root element type is the schema"; "Version lives in `:version`, not the filename."
- **PRAGMA / S15** (`v2/DECISIONS.md`, 0.10.0 CARVEOUTS): how a document declares its dialects, schema and version is an open stub.
- **2026-07-29, Joseph** (memorata, `history.jsonl:17797`): "Would it make sense, for example, to as a first effort, clearly distinguish between files that are (a) atomic (meant to be a single record in a table effectively, or a few with 1-1 mappings), (b) multi-document (ala yaml although I don't know that anyone ever used that feature, or like jsonl), (c) snippet — something that's meant to be pulled into something else — could, for example, have :attributes at the topmost level before normal children in the document...."
- **2026-09-29, Joseph** (`spec-lite-0.1.0/README.md`): one implied root node; "the root may carry metadata such as the filename."
- **2026-08-30, `v2/INBOX-REQUESTS.md`:** tiny parsers "would need to warn when there are constructs … that it encounters that it won't parse."

## Alternatives

### Q1 — documents per file

**A — one file, one document (the implied root).** **B — a separator line starts a new document** (spelling to choose; `---` is ordinary text in UDON today). **C — several top-level elements are several documents** (no separator; each top-level element is one record, JSON-Lines style).

```udon
|person :name Ann
|person :name Bo
```
```text
A:  document
    ├ element person …
    └ element person …
C:  document 1: element person (Ann)
    document 2: element person (Bo)
```

### Q2 — kinds of file

**A — lite doesn't distinguish; kinds are an application convention.** **B — a kind is declared** (in the file or its name) and changes what is allowed (e.g. top-level `:label`s only in snippets). **C — the kind follows from the shape** (one top-level element = a record; several = many records; top-level attributes = snippet).

### Q3 — marking a file as lite

**A — no marker; the lite contract carries it** (lite must then reserve everything that could ever change meaning). **B — an optional first-line marker** (for example a comment, or a root attribute like `:udon lite-0.1`; the spelling is itself a question). **C — the filename** (`notes.lite.udon`, colliding with the schema designator convention). **D — a marker is required for a file to count as lite.**

### Q4 — root metadata supplied by the parser (filename, path)

Is it part of the tree (like attributes), kept apart from anything written in the file, or not lite's business at all? (Overlaps file 13 Q1.)

## Interactions

- [04](04-root-and-top-level-text.md): top-level `:label`s and the implied root.
- [09](09-reserved-syntax.md): how much must be reserved if there is no marker.
- [12](12-missing-values-and-what-counts-as-valid.md): what "valid lite" means.
- [13](13-ast-shape.md) Q1: the root node's metadata.
