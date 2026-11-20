---
source: _ref/udon (original 2011 UDON repo) — three small demand-bearing asciidocs
gathered: 2026-07-21
status: gathered — verbatim copies of three tiny files, bundled (each ≤37 lines)
paths:
  - /Users/josephwecker-v2/src/_ref/udon/doc/features.asciidoc:1-13
  - /Users/josephwecker-v2/src/_ref/udon/doc/compare-to.asciidoc:1-37
  - /Users/josephwecker-v2/src/_ref/udon/doc/TODO.asciidoc:1-17
source_commit: 1be87d5d4a51332387b81bbb4c34e0bc0e655db7
categories: [demand-statement, wishlist, competitive-frame, historical-2011, converter-ambition, relational-data, binary-transport]
why_included: >
  The 2011 wishlist + competitive frame + build-TODO, verbatim. Companion to
  the objectives priority-matrix (same era, same commit). These are demand
  statements, not syntax law: what UDON was reaching to become (relational,
  binary-transport, schema, transforms), which formats it measured itself
  against, and what "done" looked like (a converter suite: udon2xml/xml2udon,
  udon2json/json2udon). Small enough to travel whole rather than characterize.
---

Three small verbatim copies, delimited. Editorial in the frontmatter and the
I7 witness note — the copies below are unaltered.

## 1. `doc/features.asciidoc` (the 2011 wishlist)

```asciidoc
== wishlist

 * Can be data-centric or freetext-centric
 * Easily relational instead of just hierarchical
 * Libraries (defined where? environment? sender? receiver?)

 * Good compression, binary representation for transport
 * Schema
 * Easy transformations
```

## 2. `doc/compare-to.asciidoc` (the 2011 competitive frame)

```asciidoc
| udon  |

| protocol buffers |
| apache thrift    |
| messagepack      |
| ASN.1            |
| xml   |
| sgml  |
| html  |
| xhtml |
| bson  |
| json  |
| haml  |
| sass  |
| scss  |
| laTex |
| zml   |
| yaml  |
| sdl   |
| curl  |
| slim  | http://slim-lang.com/


comparison:
* Example documents
* History / decisions

* Benchmarks (for implementations)
  * Size (lines / bytes)
  * Parse speed
  * Generate speed
```

## 3. `doc/TODO.asciidoc` (the 2011 build/launch TODO — converter ambition)

```asciidoc
|===========================================================================
|  | bare minimum static site
|  | site deploying to heroku correctly http://mwhuss.com/2009/12/13/static-sites-on-heroku-in-two-lines
|  | dns entry
|  | finalize syntax
|  | simple regex parser via strscan and possibly statemachine
|  | syntax highlighter
|  | main introduction on static site including status
|  | historical blog entry
|  | LAUNCH
|  | bare-bones ruby-gem
|  | ragel-based parser
|  | udon2xml + xml2udon
|  | udon2json + json2udon
|===========================================================================
http://www.slideshare.net/douglascrockford/jsonsag
http://json.org/example.html  <<--- use these examples
```
