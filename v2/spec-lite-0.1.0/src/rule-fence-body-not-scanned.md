---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [fence-body-indentation]
depends: [rule:fence-opens-with-backticks, rule:fence-closes-at-n-or-more]
consequences: [rule:fence-body-dedent, rule:fence-body-line-endings]
test-fixtures: []
---

# A fence body is never scanned

*Everything between a fence's opening and closing lines is body, never scanned for UDON syntax, with no escapes.*

## Statement

Everything between a fence's opening line and its closing line MUST be its body, and MUST NOT be scanned for UDON syntax, reserved spellings and escapes included.

````udon
|ex ```text
!if @{x} |not an element \|{ ;{no}
```
````
```tree
root
  |ex
    ```text "!if @{x} |not an element \\|{ ;{no}\n"
```

## Grounds

- [[decision:fence-body-indentation]]: Joseph, "fenced blocks needing to preserve everything except the fence opener and closers".
- vsect's most binding requirement (`.int/vsect-requirements-on-lite.md` item 1).

## Epistemic status

A rule, resting on the decisions in `per`. No fixtures yet.

## Working notes

- **Joseph's words** (copied with the file's bracketed corrections):

  > WRT what let's call the "needs-indented-first-line" problem. First-- to verify what I meant above-- I was acknowledging that in my example, due to fenced blocks needing to preserve everything except the fence opener and closers, my "attempted" workaround to needs-indented-first-line would pass the backslash through, unfortunately.
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 386)

- **Why it matters** (the drafter's reasoning): A fence is lite's only raw form; the spec corpus will hold UDON examples, reserved syntax included, inside fences.

- A body line starting with N or more backticks plus other text is a closer with trailing text, an error ([[rule:fence-closer-trailing-text-is-error]]), not body.
