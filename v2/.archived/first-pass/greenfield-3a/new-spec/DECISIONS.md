# Greenfield Decisions

This file catalogs the deliberate choices made during the greenfield rewrite of the UDON specification, specifically where the original source left behaviors open, provisional, or undefined.

## D1 — Multi-line Delimited Constructs
**Source:** The original spec left most delimited constructs undefined across newlines.  
**Decision:** All Delimited Constructs (Strings, Lists, Envelopes, Identity Keys) MAY span multiple lines. Interior newlines are treated as content.   
**Reasoning:** Provides a uniform extent model rather than maintaining a second exception list for which constructs can span lines.

## D2 — Root-level Attributes
**Source:** Undefined (parser free-floating attribute).  
**Decision:** Error. The line is kept as document-level text (including the `:`).  
**Reasoning:** Attributes are strictly edges of Elements. A root edge without a node cannot exist in the Abstract Document Model (ADM).

## D3 — Rational and Complex Numbers
**Source:** Provisional candidates for a dialect in the original frozen core set.  
**Decision:** Removed from the Frozen Core Scalars. They belong to a future `standard-types` Dialect via the `<...>` Envelope.  
**Reasoning:** Bare recognition is a one-way door. Compositional numbers fit the Envelope pattern better than eternal bare growth.

## D4 — Comment Continuation by Indent
**Source:** "content-base shape vs verbatim from comment column — needs ruling."  
**Decision:** The first continuation line establishes the strip column, identical to the prose Content Base shape.

## D5 — Attribute-Under-Attribute
**Source:** Needs ruling for nested maps.  
**Decision:** Writing a deeper `:key` directly under an attribute without a named Node carrier is an Error. The offending line is ingested as text of the open value to satisfy the Keep-Everything posture.

## D6 — Document Root is a Forest
**Source:** Implicit root element was implied but muddy.  
**Decision:** The ADM is a forest of TopLevelItems (Elements, Directives, Comments, Prose), not a single implicit root element.  
**Reasoning:** An implicit root changes duplicate-key scoping narratives and Host APIs. Multiple top-level elements are true siblings.
