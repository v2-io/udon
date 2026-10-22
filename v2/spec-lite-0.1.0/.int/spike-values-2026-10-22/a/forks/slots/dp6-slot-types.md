# DP6: where a slot's type is said

*Slots fork, spike a, 2026-10-22. Labels: **checked** (verified against a primary this session), **memory** (well-known spec fact recalled, not re-fetched), **guess**, **taste**. Scores are my hypothesis against `CTQ-FACTORS.md`, with basis and confidence. Background assumed from the sibling forks, not decided here: the 2026-10-21 lean that a bare run is a «text», with a typed-primitive view.*

## The question

Joseph's distinction: "*this is what the slot is* vs *this is what my literal represents*." A slot is a place a value goes: an attribute of an element (including `$main` and `$key`), an item of a list. This page asks where the slot's type is said: outside the document, or in it, and if in it, how it's spelled.

## What lite already carries for a slot (checked against the cards)

Without any new syntax, the tree already lets a reader find every value's slot:

- the document's schema designator, by the file-naming convention (`server.schema.ud`; `design/file-naming.md`, "application-level for now, deliberately");
- the element's name, key and traits. A trait "says what kind of thing the element is" ([[def:trait]]), which makes it the natural key for looking up a schema;
- the attribute's name, and which occurrence of it this is ([[def:stacking]]);
- the list index.

Joseph's 2026 repurposing of "dialect" says the same thing from the other side (`history.jsonl` 18789, his words): "make "dialect" be the part of schema that is just the algabraic types and so forth-- the *actual* structure -- the elements and attributes allowed and their relationships etc. … And then it also adds the types (necessary as it typechecks attributes)." So a slot's type lives in the dialect, found by the slot's address.

## Branches

### S0: slot types outside the document; lite reserves inline forms (alive; my lean)

Lite says nothing about slot types. A reader finds them in the schema (dialect) the document names by convention. The spellings a later UDON might use to declare a type inline stay errors in lite.

```udon
; file: web.server.ud   (the schema "server" is named by the file, by convention)
|server[web] :port 8080 :timeout 30s :started-at 2026-07-21T14:20
```
````tree
root
  |server
    :$key ‹web›
    :port ‹8080›
    :timeout ‹30s›
    :started-at ‹2026-07-21T14:20›
````
A reader that holds the `server` dialect reads `port` as u16 8080, `timeout` as a duration of 30 s, `started-at` as a datetime. A reader without it sees texts (plus whatever the default view gives: `8080` as a number).

**The finding that matters most here: under the bare-is-text lean, S0 is what makes the lean domain-forward rather than plumbing-heavy.** With a dialect in hand, no value in the document needs a mark; marks are needed only where there is no dialect or where a union's arms overlap. That is exactly A5's "conventions carry what would otherwise be declared on each value". It is the XML-with-XSD architecture, with the file name doing what `xsi:schemaLocation` does.

**Its honest cost:** without the dialect, the document doesn't say what its values are (A10, weighted 5 on purpose). And a schema-less consumer who wants a u64 for `0xff` (K8) has only the literal-annotation route, which is the angle-bracket fork's question.

**Headroom, for free (checked against the label lean):** in `.int/labels-ascii-and-positions-2026-10-20.md`, `<` `>` `(` `)` `[` `]` are errors inside a bare label. So `:port<u16> 8080` and `:port(u16) 8080` are already errors in lite, and a later UDON can give them meaning without changing any accepted tree. S0 needs no new rule, only a note on the label card saying why those characters stay errors.

### S1: the element's trait as the dialect key (a convention within S0)

`|server.web-server :port 8080`: a reader picks the slot types for `port` by the element's name and traits. Nothing changes in lite. Listed so that "which features of a node key the schema lookup (file designator, element name, traits, ancestor path)" is recognized as the dialect's question, not lite's.

### S2a: `:name:type value` (dies)

```udon
|server :port:u16 8080 :when:dt 2026-07-21
```
**Why it dies.** `:` is an XML NameChar, and real XML vocabularies put it inside attribute names: `xml:lang`, `xlink:href`, `xmlns:*` (memory: XML 1.0 NameStartChar includes `:`; Namespaces in XML makes it the prefix separator). The label lean already allows `:` inside labels for this reason. So `:xlink:href /x` would read as the attribute `xlink` with the type `href`, a silent misread of the most common namespaced name. Saving it would mean forbidding `:` in bare labels, so every namespaced XML attribute name has to be quoted (`:'xml:lang' en`), which costs C2 (weight 10). It also collides with the trailing-colon lean (DP7): `:port: 8080` and `:port:u16 8080` differ by one space.

What it couldn't do is the finding: **the colon is the worst character for an inline type separator, because XML spends it inside names.** Joseph's imagined `:when:iso8601 <…>` hits exactly this.

### S2b: `:name.type value`, traits on attributes (alive for full UDON, costed; not for lite)

```udon
|server :port.u16 8080 :timeout.duration 30s
```
**Its appeal (taste, M):** one rule everywhere. An element's traits say what kind of thing it is, an attribute's traits what kind of value its slot holds, and both are written `.name` after the name. A1 conceptual beauty is high.

**Its cost:** `.` is also an XML NameChar, and XSL-FO's compound properties are dotted attribute names (`keep-with-previous.within-column`, `space-before.optimum`; memory, XSL 1.1). The label lean currently makes `.` an error in attribute names, which already costs those names their bare spelling. S2b turns that error into a silent misread: `keep-with-previous` with the trait `within-column`. Also a tree change: attributes would carry `$traits` too, which the AST sketch doesn't have.

**Pushed to its end:** S2b is coherent only if XML's dotted names are always quoted. That is a C2 cost the label lean is already paying silently, and the next item makes it visible.

### S2c: `:name<type> value` or `:name(type) value` carried by lite (alive as headroom, not for lite 0.1)

```udon
|server :port<u16> 8080 :expires(dt YY-MM-DD) 05-03-27
```
Neither `<` nor `(` is an XML NameChar (memory), so no XML name collides. `:port<u16>` reads like a generic parameter (Rust, TypeScript), which helps cold comprehension (A3, guess M). Notation parameters fit naturally in parentheses: Joseph's own `dt(YY-MM-DD)`. A notation declared on the slot also commits before the value arrives, which suits streaming (the ideation notes said so).

**But it is per-value plumbing** (A5): `:port<u16> 8080 :timeout<duration> 30s` spends three annotations on three facts, every one of which a dialect would carry for free. And `:when<dt> …` beside a literal `<dt:…>` puts slot and literal annotation one space apart (`:when<dt> x` vs `:when <dt:x>`), a visual near-collision for a model reading plain text. That one is the angle-bracket fork's to weigh.

**For lite:** keep it an error (S0's headroom). For full UDON: the best inline spelling found here, if inline slot types are wanted at all.

### S4: a schema named inside the document, by convention (set aside)

A top-level `:schema server` attribute that readers honor. It adds a second source beside the file name, so a precedence rule is needed (`design/file-naming.md` already foresees one), and a `$schema` would need lite to settle hand-written `$` names (open on [[def:attribute-name]]). Nothing in lite stops anyone doing it as an application convention. Not a lite rule. *Taste.*

## Scores (my hypothesis; discriminating factors only)

| Factor (weight) | S0 | S2a | S2b | S2c (in lite) | basis / confidence |
|---|---|---|---|---|---|
| A2 generative (10) | 8 | 5 | 6 | 6 | S0 has nothing to guess; S2* must be remembered and spelled right (M) |
| A3 cold comprehension (10) | 8 | 4 | 5 | 8 | S2a/b misread XML names; `<u16>` reads as generics (M) |
| A5 domain-forward (9) | 10 | 5 | 5 | 5 | annotations per value vs none (H) |
| A6 spec clarity (9) | 9 | 6 | 7 | 7 | S0 adds no card (H) |
| A7 syntactic simplicity (8) | 10 | 5 | 6 | 7 | new syntax and tree fields (H) |
| A10 self-description (5) | 3 | 8 | 8 | 8 | the document alone doesn't say its types (H) |
| B6 headroom (7) | 10 | 4 | 5 | 5 | S0 spends nothing (H) |
| C2 XML/HTML (10) | 10 | 2 | 4 | 9 | XML NameChars `:` and `.` (H, from the XML specs) |
| C5 schemas, slot types (8) | 6 | 8 | 8 | 8 | S0 gives no in-document slot types in lite (M) |
| C9 composition (7) | 8 | 7 | 7 | 7 | file designator plus logical store (L) |
| **weighted mean** | **8.4** | 5.2 | 6.0 | 7.0 | |

Impact radius: S0 needs a sentence on the label card about why `<`, `(`, `[` stay errors after a name. S2a would touch the label rule, [[def:attribute-name]] and the trailing colon. S2b would touch the tree shape, [[def:trait]], [[def:attribute-name]] and the label rule. S2c would touch the label rule, the tree shape and the `<…>` cards.

## Outside my scope, for the parent

- **The label lean's `.` error in attribute names** costs XSL-FO's dotted names, which are real XML. It is on the label question's ledger, not this one, but S2b exposed it.
- **Keys and lists holding texts** (asked on [[rule:unquoted-run-is-one-value]]): under S0 that is just right. `|step[3]` is a text whose slot (`$key` of `step`) a dialect can type as an integer. It doesn't need to be answered in lite.
