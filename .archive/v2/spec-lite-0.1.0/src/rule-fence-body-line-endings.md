---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: [rule:fence-body-not-scanned, rule:fence-body-dedent]
consequences: []
test-fixtures: []
---

# Fence body lines keep their line endings

*Every fence body line keeps its line ending, the last included.*

## Statement

Every fence body line MUST keep its line ending, the last line's included.

````udon
|job ```sh
make build
make test
```
````
```tree
root
  |job
    ```sh "make build\nmake test\n"
```

## Grounds

- [[rule:fence-body-dedent]]'s own example (`" context line\n-removed\n"`); 0.10.0 §10.3, every body line keeps its terminator.

## Epistemic status

A rule resting on a decision's example rather than a stated clause.

## Working notes

- **Joseph's words** (copied with the file's bracketed corrections):

  > WRT what let's call the "needs-indented-first-line" problem. First-- to verify what I meant above-- I was acknowledging that in my example, due to fenced blocks needing to preserve everything except the fence opener and closers, my "attempted" workaround to needs-indented-first-line would pass the backslash through, unfortunately.
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 386)

- **Why it matters** (the drafter's reasoning): A fence is the form for exact text, where every line ending counts.

- Not stated by Joseph in so many words; confirm with a second reader.
- A blank first body line is body ([[rule:fence-body-dedent]]).
