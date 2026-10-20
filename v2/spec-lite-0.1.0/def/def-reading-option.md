---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: false
strength: provisional
terms: [reading-option]
per: [representational-options]
depends: [def:tree, def:text, rule:main-is-attribute]
consequences: [rule:tree-transcript]
---

# reading-option

*A «reading-option» is a named way of presenting the «raw-tree» to a consumer, usually applied while the consumer walks the tree. It is not language: it never changes what a «document» parses to.*

## Terms

- **reading-option** (provisional; Joseph's own word was "representational-options"): a named way of presenting the «raw-tree» to a consumer, usually applied during traversal rather than by building a second tree ([[decision:representational-options]]). Two are named so far:
  - presenting `$main` as an element's first child ([[rule:main-is-attribute]]);
  - reading a «text» whose only «piece» is one «embed», in a value slot, as that «embed». As an aspiration, this one defaults to on.

## Invariants

- A «reading-option» never changes what a «document» parses to; it changes only what a consumer is shown.
- Fixtures show the «raw-tree». A fixture that shows an option's result labels it as such ([[rule:tree-transcript]]).

## Examples

```udon
|el :author @{people/jw}
|p Intro
```
```tree
root
  |el
    :author ‹@{people/jw}›
  |p
    :$main ‹Intro›
```
```text
one-embed option on:     :author @{people/jw}
main-first option on:    |p
                           ‹Intro›
```

## Avoid

- **"representational option" / "representational-options".** Joseph's own word, from the message that named the layers (below). It collides twice: lite's objectives use "represent" for what lite can express ([[obj:represent-xml-html]]: "Lite MUST be able to represent the element structure…"), and YAML 1.2's "representation graph" is the *specified* model, the opposite end of the pipeline from a view over it.
- **"reading flag", "AST reading flag", "read-time option", "read" as the verb for applying one.** Joseph's words ("an AST reading flag", 2026-10-09; "a default read-time option to treat it as null", 2026-10-09). Three collisions:
  - 12 lite cards use "read" for *parsing*: "MUST be read as text" ([[rule:escaped-reserved-is-text]]), "MUST be read as two values" ([[rule:adjacent-quoted-strings]]), "read by the same value rules" ([[rule:key-holds-a-value]]), and [[prin:one-rule-everywhere]] ("A construct is read by the same rule wherever it appears"). A «reading-option» is the one thing that is *not* how a construct is read in that sense.
  - The SOP's ⟦reading⟧ is "one alternative tree in a ⟦descriptive⟧ case" (`sop/def/def-fixture-profiles.md`; fixture field `readings:`, keys like `04-Q2-A`). A fixture can now hold both a ⟦reading⟧ (an open question's alternative) and a «reading-option»'s result.
  - In Lisp, "the reader" is the parser and reader variables change what is parsed.
- **"host view", "view", "views"** for the concept. Mainline `spec/CORE.md` "Host Views (Recommended)" and 0.10.0 `MODEL.md` §3.2 (agents); Joseph's own "views"/projections (January 2026) and "the recommendation for the views" (July 2026). The SOP store's ⟦view⟧ is an outline's view of records (`sop/def/def-record.md`). Not ruled out as the name, but it carries those.
- **"projection"**: 0.10.0 `GLOSSARY.md`: "Projection — host turning a validated value into a native value", a different step; Joseph's "views"/projections (January 2026).
- **"knob", "menu vs knob", "host flag", "parser parameters", "`first_is_main`", "host stitching", "re-injection".** 0.10.0 (`GLOSSARY.md` "Menu vs knob"; `MODEL.md` "`main` / `first_is_main`-style knobs"; `GLOSSARY.md` "`$main` … host-presented"); Joseph, 2026-08-08: "with maybe a flag saying 'first_is_main: false' or something", "depends on the parser parameters to decide how you want it in the AST". "Parser parameter" says the parser decides, which is what lite's layering moved away from.
- **"single-piece rule"** (agent, 2026-10-09). It was proposed as language and declined: Joseph put it here instead.
- **"default read", "default collection read", "always-list accessor"** (K15, 2026-08-09; 0.10.0 `MODEL.md` §3.2). Names for particular options (below), not for the concept.
- **"parse option"**: in libraries like Nokogiri (`ParseOptions::NOBLANKS`) a parse option changes the tree that gets built, which is exactly what a «reading-option» must not do.

## Working notes

- **Not reviewed with Joseph.** "reading-option" was the original drafter's word (agent, 2026-10-09), from his "AST reading flag". «raw-tree», defined here until 2026-10-09, is now in [[def:tree]].

### Joseph's words, in date order

- 2026-01-14T03:15Z (`history.jsonl:7858`), on whitespace on a blank line: "I'm also OK preserving the spaces there and letting the AST/DOM builder decide what to do based on further context."
- 2026-01-14T05:10Z (`history.jsonl:7873`): "If someone wants to traverse the tree ignoring them, no problem, because in practice comments are only ever leaf nodes."
- 2026-01-14T14:56Z (`history.jsonl:7891`): "would you add some concrete API for bidirectionality in the AST as well as separate "views"/projections that would include mixins, element+key tuples, maybe just key lookup, and so forth?"
- 2026-07-12T04:18Z (`history.jsonl:15843`): "Is the recommendation for the views essentially something like: / - These are syntax sugar for these attributes... / - We recommend you expose (something like): / - bare_attributes (or all_attributes or full_attributes -- … / - key & traits & attributes (that has them distinct)" (line breaks shown as ` / `).
- 2026-07-12T06:37Z (`history.jsonl:15869`): "make sure traits as always-array is captured as one of the only parser-special-casing beyond the desugaring..."
- 2026-08-08T19:31Z (`history.jsonl:18835`): "As for :'$main' -- I'm sold. The costs are for the event-wire only and the AST builder can easily just decide or be configured to drop it into the first child slot instead with maybe a flag saying 'first_is_main: false' or something."
- 2026-08-09T04:39Z (`history.jsonl:18876`): "Right... it's an attribute on the wire, and depends on the parser parameters to decide how you want it in the AST."
- 2026-10-08 (`.int/STEWARD-VERBATIM.md`), fence options: "3. Like #1, but always ensure that a fenced-block has meta about [its] first line's indent level, so that the AST consumer can use a simple boolean to decide whether or not to convert verbatim -> dedented … 4. Like #3, but with the default reversed-- save indent in meta and all indent-resets if any, automatically [dedent] as per my earlier solution as usual, and toggle for AST consumer *re-prepends* all indents."
- 2026-10-08 (`.int/STEWARD-VERBATIM.md`): "While I ended up swinging back to being in favor of / reconciled with $main as long as the AST interactions can make it transparently effectively the first child if/when expected"
- 2026-10-09 (`.int/STEWARD-VERBATIM.md`): "My lean for lite-0.1.0 is an *aspiration* that a `text` construct with just one embed in a value slot ends up being *processed*/interpreted as if that embed is the value itself (so, kind of pre-emptively having an AST reading flag that defaults to reducing it, in the same category as $main<->children stuff, instead of as part of the language spec). I guess that means in reality we have  source -> wire/event (opaque in lite) -> raw AST -> AST modified by representational-options (usually part of traversal instead of predetermined, I would imagine)."
- 2026-10-09 (`.int/STEWARD-VERBATIM.md`): "(equivalent to null/nil or an explicit 'no-value' that is distinct from those in the AST if we would prefer, with a default read-time option to treat it as null)"

### Readings of his usage (mine; flagged, not resolved)

- **The concept is older than lite, under other names:** "views"/projections (January), "the views" (July), "a flag" / "parser parameters" (August), "AST interactions" (October), "AST reading flag", "representational-options" and "read-time option" (October). The idea stayed the same across all of them: the tree has one shape; consumers get conveniences over it. The names changed with whatever he was looking at.
- **"usually part of traversal instead of predetermined"** describes something applied while walking, like an accessor, rather than a setting chosen up front that produces a second tree. "Option" and "flag" fit the second picture better than the first.
- **Defaults:** the one-embed option "defaults to on" (as an aspiration), and $main-first is "if/when expected". So by default a consumer may *not* see the «raw-tree». That is why the naming of the specified tree matters ([[def:tree]]).

### Options that have been named or implied (lite names only the first two)

| Option | Source | In lite? |
|---|---|---|
| `$main` as the first child | Joseph 2026-08-08 (`first_is_main`), 2026-10-08 | named |
| a one-embed «text» read as its «embed» | Joseph 2026-10-09 | named, aspiration, default on |
| explicit no-value read as `nil` | Joseph 2026-10-09 ("a default read-time option to treat it as null") | not carded; tied to [[rule:missing-value]] |
| `$traits` always a list | Joseph 2026-07-12; mainline CORE Host Views | not discussed for lite |
| `key` / `traits` / `attributes` split vs `all_attributes` | Joseph 2026-07-12; mainline CORE Host Views | not discussed for lite |
| one stacked value reads as the value, several as a list ("default collection read"); an always-list accessor | K15, 2026-08-09 (Joseph's table, agent's names) | not discussed for lite |
| comments skipped | Joseph 2026-01-14 ("traverse the tree ignoring them") | not discussed for lite |
| fence body verbatim vs dedented ("toggle for AST consumer *re-prepends* all indents") | Joseph 2026-10-08, options 3/4 | lite chose a `-` flag instead; a toggle over «meta» is still possible |
| blank-line whitespace kept or collapsed | Joseph 2026-01-14 ("letting the AST/DOM builder decide") | lite's rules now decide |

### Other agents' leans

- Mainline `spec/CORE.md` "Host Views (Recommended)" and 0.10.0 `MODEL.md` §3.2 (agents): "views" over a "substrate"; "Round-trip and provenance-sensitive tooling MUST work from the substrate."
- The 2026-08-08 spike (`theory/to-integrate/primary/sameline-value-space-couplings-2026-08-08.md`): "the capture doc's `first_is_main: false` host flag is a *projection* … a host that re-injects $main as first child and then serializes from the AST has silently performed the exact text-migration §2's new forbidden row prohibits. The flag is fine for reading; round-trip tooling must serialize from the substrate." Options that are convenient to read can be wrong to write back from.
- AST-notation proposal A §4.2 and §5 (2026-10-09): show an option's result under a labeled `read` block, never as the fixture's tree.

### Precedents

- **Unicode normalization forms** (NFC, NFD, NFKC, NFKD): named, standardized alternative presentations of the same text, chosen by the consumer. Close to the idea of a small set of named options.
- **YAML 1.2's load stages** ("parse, compose, construct"): building native data from the representation is an application's choice. Lite's options sit where "construct" does, but YAML doesn't name its choices.
- **JSON libraries' hooks** (Python's `object_pairs_hook`, `parse_float`): conveniences at load time.
- **Nokogiri's `ParseOptions`**: options that change the tree at parse time, the thing lite avoids.
- **SQL views; functional "lenses"; the DOM's `normalize()`**: a view leaves the data alone, a lens reads (and maybe writes) through it, and `normalize()` mutates. Lite's options are views in that sense.
- **Obsidian's "Reading view" vs "Source mode"** (Joseph mentioned it 2026-07-16 for syntax highlighting): a presentation of the same file. A precedent he has met, for the "reading" family of names.

### Questions about meaning, register and affordance

- **Are the options normative?** Named by the spec with fixed names and defaults, recommended, or left to each host? ([[decision:representational-options]] leaves this open.) If named, which of the table's rows join the two?
- **Does writing back from an option's result have to be safe?** The 2026-08-08 spike says `$main`-first loses information when serialized; a name that says "view" warns of that, "option" doesn't.
- **What does "read" mean in this spec?** If parsing keeps "read" ("MUST be read as text"), the post-parse concept needs a word outside that family, or the cards' parse-verb changes.

### Candidates

| Name | For | Against |
|---|---|---|
| «reading-option» (now) | From his "AST reading flag", "read-time option" | "read" = parse in 12 cards; SOP ⟦reading⟧; Lisp reader |
| "representational option" | His word at the naming moment | obj's "represent"; YAML's representation graph |
| "view" | His earlier word ("views"/projections, "the views"); says the data is untouched; precedents | SOP ⟦view⟧ (another store); 0.10.0 "Host Views" baggage |
| "presentation" / "presentation option" | Says it's about what a consumer is shown | YAML's "presentation" is the character stream |
| "accessor" | Matches "usually part of traversal" | Names an API, not a concept |

### My own opinion (the drafter's, Opus 5.5; not a lean of Joseph's)

- I'd move off the "read" family: the clash with the cards' "MUST be read as" is in the normative sentences, where it costs the most.
- Of the rest I lean **"view"**: it is his earliest word for this exact idea, it tells an implementer the data is untouched (so the spec's tree is the one to write back from), and it pairs naturally with an unqualified "AST" ("the AST, and views of it"; [[def:tree]]). The SOP's ⟦view⟧ lives in a different store with different delimiters, which I think is tolerable; it should be named in the card's Avoid list if chosen.

### Cards a change here would touch (left unedited)

- [[decision:representational-options]] (title and outcome) and [[decision:ast-centric]] (working notes).
- [[rule:main-is-attribute]] and [[def:embed]] list `def:reading-option` in `consequences:`; [[def:text]] ("may be read as that embed is a reading option").
- [[rule:tree-transcript]] (`depends:`).

### Coordinator's lean (Opus 5.5, 2026-10-09; my opinion for Joseph, not a lean of his)

- **"view"**, his earliest word for exactly this ("views"/projections, January; "the views", July). It tells an implementer the data is untouched, so round-trip tooling writes from the specified tree, and it reads naturally beside "AST": "the AST, and views of it". "Reading option" collides with the cards' parse-verb ("MUST be read as text") in normative sentences, which is where a collision costs most.
- His 2026-10-09 name was "representational-options"; I'd ask with his own sentence ("raw AST -> AST modified by representational-options") and offer "view".
