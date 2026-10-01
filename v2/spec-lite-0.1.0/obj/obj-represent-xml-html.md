---
kind: objective
awaiting-second: true
awaiting-decision: true
needs-work: false
force:
per: [inline-elements-in]
depends: []
---

# Lite can represent XML and HTML

*An XML or HTML document can be written in lite without losing its structure: its elements, their attributes, and text with elements mixed into it, in order.*

## Statement

1. Lite MUST be able to represent the element structure of an XML or HTML document: each element's name, its attributes and their values, and its children in order.
2. Lite MUST be able to represent mixed content: text with elements inside it, in order, as in `<p>See <a href="/x">the docs</a>.</p>`.

## Grounds

- "|{...} inline elements are critical for one of the most obvious use-cases-- xml/html" (Joseph, 2026-09-29), and on 2026-10-01: "being able to represent xml/html is a critical objective" (`.int/STEWARD-VERBATIM.md`).
- The 2026-08-30 tiny-parser request names the same use: "udon used as a simple predictable data layout / xml equivalent / yaml-or-json alternative" (`v2/INBOX-REQUESTS.md`).
- **Decision:** [[decision:inline-elements-in]] rests on this objective.

## What discharges it

- the inline-element rule ([[rule:inline-elements]]), for mixed content;
- the element-name and attribute rules ([[rule:element-names]], [[rule:unquoted-values]], [[rule:quoted-strings]]), for names and values XML and HTML actually use;
- a correspondence between lite trees and XML, with what it loses stated ([[expl:data-mappings]]), and idiomatic fixtures converted from real XML and HTML.

## Epistemic status

Chosen, not derived. Whether the rules meet it is checkable case by case: take an XML or HTML document, write it in lite, and see whether anything has no spelling.

## Discussion

- **Known places where it bites** (from the pre-design files, unresolved):
  - names: XML allows `_` first and `:` and `.` inside names, and HTML has `data-*`, `aria-*` and framework attributes like `@click`; lite's name rules may not spell them all without quotes (76, 69);
  - an inline element's attribute value versus its text: under the 0.10.0 value rule, `|{a :href /docs the docs}` makes "the docs" part of `href`, so the most common HTML link shape doesn't come out as a link with text (50);
  - several siblings on one line, like `<li>` items or table cells (51);
  - a value containing both quote kinds, which an HTML attribute can hold (75).
- **What "represent" doesn't settle:** comments, processing instructions, namespaces, entities and CDATA. Whether lite must carry them, or only the element tree and text, is open.
- **A tension with node-valued attributes.** Joseph's 2026-01-13 "udon-xml" flavor was "limited to forms that can be expressed in XML naturally-- e.g., no complex elements as an attribute's value". Lite can represent XML and still allow more than XML can (64), but the direction from lite to XML then loses something, which [[expl:data-mappings]] must say.

## Working notes

- **⟦force⟧ is empty: Joseph's call.** He said "a critical objective"; whether he means force `critical` (critical to quality: expected to have an outsized impact on lite's success) or the everyday word is his to say. The udon team's lean is `critical`.
