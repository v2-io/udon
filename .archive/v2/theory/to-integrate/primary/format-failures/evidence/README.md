# evidence/ — commissioned but not delivered

**State as of 2026-07-29: this directory is empty of findings.**

Six parallel evidence-gathering passes were commissioned during the format-failures research session to build the citation substrate under `../MINEFIELD-MAP.md`. **All six failed on server-side API overload (HTTP 529), repeatedly, across the whole session.** Each was retried several times; none produced a file. The failure was environmental and total, not a judgment about the passes' value.

This README exists so the work is re-runnable without being redesigned. Everything below is still wanted.

## The six passes, and the file each was to produce

| File | Territory | Why it matters |
|---|---|---|
| `xml-sgml.md` | SGML/XML lineage: minimization heritage; the XML 1.0 design goals and which were regretted; draconian error handling and the XHTML/HTML5 rupture; namespaces; DTD→XSD and RELAX NG as the road not taken; Infoset/PSVI; mixed content and whitespace; attribute-vs-element; entity expansion, XXE, signature wrapping; c14n; XSLT/XPath/XQuery; native XML databases; XML 1.1 as a versioning natural experiment; SOAP/WS-* technical post-mortems | The deepest single record, and the source of M2, M10, M12 instances |
| `semantic-web-identity.md` | RDF reification and RDF-star; blank nodes as identity failure; URIs as identifiers and httpRange-14; OWL's open world vs what validators needed, and SHACL/ShEx arriving fifteen years late; RDF/XML vs Turtle vs JSON-LD, and what JSON-LD conceded; Topic Maps; XLink/XPointer non-adoption; microformats vs RDFa vs microdata vs schema.org; triple-store scaling; link-rot measurement papers; **pre-web hypertext** (Xanadu transclusion and bidirectional links, HyperCard, NoteCards) and the dangling-link tradeoff | M9 rests almost entirely on theory + recall without this |
| `config-serialization.md` | YAML type-resolution history (1.1 vs 1.2 and why 1.2 did not land); the full footgun catalog; StrictYAML's removal list; **duplicate-key handling across real parsers**; JSON's deliberate exclusions and the JSON5/JSONC/HJSON fragmentation; TOML's limits; S-expressions; **EDN reader tags** (closest prior art to UDON's envelopes — how did they fare in data at rest?); HOCON include/substitution; JSON Schema draft turmoil; Kubernetes/Ansible-scale YAML incidents | Partially closed directly (§M1, §M10); EDN reader tags remain the most interesting unexamined item |
| `database-lineage.md` | IMS/CODASYL and Codd's data-independence argument (and how much of it applies to a *tree*); the OODB wave and its post-mortems; **XML databases**; NoSQL schemaless and the documented return of schema; the semi-structured research line (Lore/OEM, Abiteboul/Buneman/Suciu); Datomic's honest limits; XTDB and bitemporal difficulty; SQL:2011 system-versioning's thin adoption; **event sourcing's pain points, including the immutability / right-to-erasure collision**; list-CRDT/OT for ordered sequences; **git-as-database attempts** | Most directly consequential for `misc-db-theory.md`; only the git-as-database shape was reached (§3.10) |
| `markup-documents.md` | Markdown fragmentation and CommonMark at depth; **indentation-significant formats and what actually breaks in practice** (transport mangling, mixed tabs, auto-indent, diff/merge); DocBook, TEI, DITA; LaTeX's macro model as a design decision; ODF vs OOXML technical critiques; round-tripping and Pandoc's AST lossiness; XML mixed content as the thing UDON claims to solve | The indentation gap (§3.9) is the open UX-bearing question |
| `schema-evolution.md` | DTD→XSD→RELAX NG rationale and **why RELAX NG lost**; Schematron and what grammars cannot express; JSON Schema draft churn from the maintainers' own account; SHACL vs ShEx; protobuf/Thrift/Avro/Cap'n Proto evolution rules; ASN.1 extensibility markers; the **must-ignore vs must-understand** literature and the W3C TAG versioning findings; the no-version-number school; canonicalization and specified equivalence relations; SAX/DOM/StAX and formats that *lost* streamability by accretion; extension mechanisms that went wrong (namespaces, vendor prefixes, RFC 6648) | §3.7 says the schema layer is where three mines converge; this is the pass that would inform it |

## Method notes for whoever re-runs these

- The briefs asked for three things in priority order: **primary-source evidence with citations** (verbatim where a sentence is doing work), **the agent's own causal read kept visibly separate from the evidence**, and **anything that surprised them** — with the explicit note that a failure mode the brief did not list is worth more than thorough coverage of one it did.
- The governing filter, from the steward: *not* interested in marketing or mindshare, "except when that seems to be a direct result of obtuseness."
- The convention for training-derived claims: mark them *"training recall — verify before external citation."*
- Under unstable API conditions, brief the passes to **create their file before the first fetch and append as they go**. The single-flush-at-the-end pattern is what lost all six tonight.

## Already fetched directly (do not re-do)

Cited inline in `../MINEFIELD-MAP.md`: Bray's *History of XML Error Handling* (2004) and his XML 1.0 draconian annotation; RFC 6648 (BCP 178); StrictYAML's implicit-typing rationale; the CommonMark specification introduction; Kubernetes issue #14791 plus go-yaml #154 and Symfony #19526/#19529; the Sass syntax documentation; the Dolt/Noms/TerminusDB prolly-tree lineage at survey depth.
