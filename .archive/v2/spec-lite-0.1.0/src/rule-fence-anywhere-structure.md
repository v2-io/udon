---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: text
per: []
depends: [rule:fence-opens-with-backticks, rule:nesting, rule:fence-closes-at-n-or-more]
consequences: []
---

# A fence may open wherever structure can start

*Unlike CommonMark, a fence opens at any indentation and on an element's or attribute's line; its position decides its parent.*

## Statement

1. A fence opener MAY appear at any indentation and on an element's or attribute's line, wherever structure can start; its position MUST decide its parent.

## Grounds

- "we will not want to follow markdown's standard (in some versions) of requiring that a fence be at the beginning of a line or the first non-whitespace of a line-- we need its indent (including sameline) to decide whose child it is" (Joseph, 2026-10-08): [[rule:fence-closes-at-n-or-more]].

## Epistemic status

A rule, chosen, not derived. Checkable by fixtures.

## Explanation

*(Teaching; adds nothing to the Statement.)*

````udon
|job :script ```sh
make build
```
````
```tree
root
  |job
    :script ```sh "make build\n"
```

## Working notes

- **Joseph's words:**

  > Decision A:  We should allow nested fences via backtick count >= 3 is my strong preference.  Is there a standard? I know, for example, that we will not want to follow markdown's standard (in some versions) of requiring that a fence be at the beginning of a line or the first non-whitespace of a line-- we need its indent (including sameline) to decide whose child it is.
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)

- **Reasoning:** In UDON a fence's position decides its parent, so it can't be limited to the start of a line as in Markdown.
- The spec should name this as a difference from CommonMark (Joseph's suggestion).
- On an element's or attribute's line, a space followed by a fence opener ends any unquoted text before it, like ` |name` and ` :name` (Joseph, 2026-10-09: "```(+) is in the same family as |;: and the reserved ones"); [[rule:text-value-end]].
- **Where a fence lands on an element's line** follows the element rules (Joseph, 2026-10-12): after a finished value it is a child of the element before it, as a bare `|name` is ([[rule:sameline-element-is-child]]); right after an attribute still waiting for its value it is that attribute's value ([[rule:element-after-attribute-with-no-value]]); at the start of a line it is a child by its column.

  > wrt `:attr true ```sh ...` -- you are absolutely right. We can literally go either way here-- if it was considered more like prose as if it were a heredoc marker, it would be $main which most of the time (or all of the time with these) would end up as the first child anyway. But as per the other aspects like the key/traits/attributes/comments making it much closer to an element-- we can just as easily decide to have it follow the element rules (becomes a child). Which seems right actually, because otherwise there's ambiguity about attributes after the closing backticks and/or indentation behavior etc. at the end that is already well-decided when thinking of it as a specialized element node. I was wrong in that correction and statement. I think child is the right call.
  >
  > — Joseph, 2026-10-12 (`.int/STEWARD-VERBATIM.md`)

  He had first said a fence after a finished value is the element's `$main` value; the coordinator pointed out that a bare `|name` there is a child, and he withdrew it.
