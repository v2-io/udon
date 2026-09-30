# 54 — Two elements with the same `[key]`: does lite say anything?

*Raised by the history survey (files 50–69), 2026-09-29. Neutral: the question, the alternatives, and where it has come up. Sources are pointers for the second pass, not authority.*

## The question

```udon
|user[jw] :name Joseph
|user[jw] :email jw@example.com
```

Is this a valid lite document? If yes, is it two elements, or a warning, or something a consumer must reject by default?

## Why lite has to answer it

Lite has no `@` references, so nothing *points* at keys. But the forward contract says a lite-accepted document means the same under every future version. 0.10.0 already names a default for this case — **error** — at a layer above the parser. If lite says nothing, a lite tool and a later full tool could disagree on whether the document is acceptable.

## Where it has come up (chronological)

- **2011 (`_older/udon-c/docs/DECIDED.md`)**: the root node's ID is the file path; "ID isn't taken into account" for grim attributes. No uniqueness rule.
- **Joseph, 2026-01-14**: *"do we say an [id] is always unique per document like html (IIRC), or do we say |element[id] is unique universally where possible, or within the domain-- but that a different element may have the same [id] because it's coupled with the element (more like |table[primary-key-id] ) or do we not attempt to do anything with it semantically yet? I feel like we might have a real nice opportunity though to immediately do something better than xml again..."* The same session renamed id/class to **key/traits**.
- **Joseph, 2026-07-11**, ratifying `@` as an inert typed pointer: *"one thing that IIRC is still ambiguous or maybe underdefined is an id's scope. I like that the new syntax scopes it to per element, which is best because it can be used for database pk ids for example without any conflict. But we need to make sure we explicitly say whether or not the parser is going to complain when it sees more than one same id in the same kind of element in the same document/stream, even without a @ referencing it..."* Same session, listing parser/host decisions: *"duplicate element+key handling (? recommendation ?)"* and *"duplicate element+key handling when the node's bodies are equivalent"* — which became the R14 menu (*"collapse to something like ('error' | 'allow-if-identical' | 'first-wins' | 'last-wins' | 'keep-all') and maybe an orthogonal 'warn' option"*). He placed the choice across *"[forced-by-spec, parser/parser-type, host-lang, schema, dialects]"*.
- **DECISIONS R14 (from greenfield convergence, 2026-07)** and **0.10.0 §12.3**: two elements with the same *name and key* are a "duplicate definition," never a merge. It is a document-layer concern (the streaming recognizer doesn't check it). Menu: `error | allow-if-identical | first-wins | last-wins | keep-all`, default **error**. Different names with the same key are not duplicates.
- **K1 (2026-08-07)**: an element may carry several keys (`|x[a][b]`), which stack. How uniqueness applies to a multi-key element is left to paths work (OPEN **S3**; CARVEOUTS).

## Alternatives

### A — lite adopts 0.10.0: same name + same key = duplicate; default error at the document layer

The parser still produces both elements; a validating consumer rejects by default.

```text
document
├ element user  ($key "jw", name "Joseph")
└ element user  ($key "jw", email "jw@example.com")
anomaly: error (document layer), duplicate definition user[jw]
```

### B — lite says keys carry no uniqueness meaning yet; both elements, no anomaly

Forward risk: a later version that makes duplicates an error would reject documents lite accepted.

### C — lite reserves the question: the tree is two elements, and a duplicate is marked "not-valid-lite" (see [12](12-missing-values-and-what-counts-as-valid.md))

## Sub-questions

- Scope of uniqueness: per parent, per document, or per (name, key) across the document?
- Multi-key elements (`|x[a][b]` and `|x[b]`): duplicate or not?
- Keys that are not strings (`[1]` vs `["1"]` — K2 makes these different values): same key or different?

## Interactions

- [12](12-missing-values-and-what-counts-as-valid.md), [13](13-ast-shape.md) Q2.
