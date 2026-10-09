---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: false
terms: [transcript]
per: [ast-centric, representational-options]
depends: [def:tree]
consequences: [rule:tree-transcript]
---

# transcript (and a note on "fixture")

*A «transcript» is a «tree» written out as text in one canonical form, so that a fixture can state the «raw-tree» it expects and a harness can compare a parser's «tree» with it byte for byte. Which notation, and whether "transcript" is the word, are open.*

## Terms

- **transcript** (provisional; an agent's word, and one Joseph uses for something else): a «tree» printed as text in the one canonical form [[rule:tree-transcript]] will define, so that two «tree»s are the same exactly when their «transcript»s are the same bytes. Fixtures store expected «transcript»s; a parser's harness prints its own «tree» and compares.

This card does not define **fixture**. The SOP store already does (⟦fixture⟧, a record kind: `sop/def/def-record-kinds.md`, `sop/src/conv-fixtures.md`), and the spec store uses that word. See Working notes for whether lite needs its own.

## Examples

```udon
|card :title "Hi" Intro
  Body text.
```
```tree
root
  |card
    :title "Hi"
    :$main ‹Intro›
    ‹Body text.›
```

The second block is a «transcript» in proposal A's notation (`.int/ast-notation-proposal-a.md`). Read as text, it is what a fixture's `tree:` field would hold.

## Avoid

**For the transcript:**

- **"transcript" itself, possibly.** It came from agents: pre-design 86 (2026-09-29: "The tree written as JSON (a transcript of the lite tree; nothing lost)") and AST-notation proposal B (2026-10-09: "an indented, line-per-item "transcript" of the tree"). In Joseph's typed prompts in udon projects, "transcript" appears 12 times, every time meaning a session transcript ("someone can look at the actual session transcript if they need to know what you corrected", 2026-10-08). This corpus cites session transcripts constantly (`.int/STEWARD-VERBATIM.md`: "the session transcript has the original").
- **"the pre-design text notation"**: `document` as the top line, box-drawing branches (`├ element person`), `"…"` for both text and strings. Superseded; still in `dat/implied-root.yaml` and [[def:document]]'s old example.
- **"tree-as-JSON", "JSON transcript", "machine transcript"** (pre-design 86 option B; `sop/def/def-fixture-profiles.md` working notes: "until a machine transcript is decided").
- **"S-expressions"** (tree-sitter's test format). Joseph: "I'd prefer that over "json s-expressions" or something verbose and jarring like that" (2026-10-09).
- **"golden file", "snapshot", "baseline", "expect test", "approval test".** Test-suite words for the *stored expectation* and how it is updated (Go's `.golden` files with `-update`, Jest and Rust `insta` snapshots, the TypeScript compiler's "baselines", `expect-test`). They name the file and its workflow, not the notation. Snapshot workflows also regenerate expectations from current output, which is what lite's fixtures must not do (Joseph, 2026-07-19: "agents writing the fixtures don't simply write them to pass what they see the grammar already outputting").
- **"dump"** (clang's `-ast-dump`, Python's `ast.dump`): a debugging print, with no promise of one canonical form.
- **"canonical transcript"** as a fixed phrase. "Canonical" is also a fixture profile (⟦canonical⟧, `sop/def/def-fixture-profiles.md`), so "the canonical transcript of a canonical case" says two things with one word.
- **"```` ```tree ````"** as the name of the notation. It is the fence label the cards use for printed trees (70 files), and it ties the notation's name to whatever «tree» ends up being called ([[def:tree]]).

**For fixture** (if lite keeps using the SOP's word):

- **"fixture" in the xUnit / pytest / Rails sense**: a test's fixed setup (xUnit), a setup function (pytest), sample database rows (Rails). An agent from those worlds reads "fixture" as setup, not as input-plus-expected-output.
- **"test vector", "spec example", "test case"** as synonyms. A "case" is one entry in a fixture file (`sop/src/conv-fixtures.md`: "a list of cases each with a stable `id`").
- **"compliance group", "compliance-fixture group"**: mainline's word for a frozen set of fixtures per spec version (`README.md`: "each version has a frozen **compliance-fixture group**"). A set, not one fixture.
- **"pseudo-fixtures"** (Joseph, 2026-07-19, for a greenfield agent's spec-derived snippets).

## Working notes

- **Not reviewed with Joseph.**

### Joseph's words, in date order

- 2026-01-01T01:40Z (`history.jsonl:6519`): "you *could* prefill the yaml with current output events if you are sure to just use the canonical and if you don't use that prefill for running tests- but just as a "before" snapshot to help get started."
- 2026-07-14T23:45Z (`history.jsonl:16238`): "the AST and streaming AST will need spec-version compliance fixtures as well, and some things might be much easier to test at the AST level than comprehensively at the event level anyway..."
- 2026-07-19T00:38Z (`history.jsonl:16728`): "there is a standing rule that agents writing the fixtures don't simply write them to pass what they see the grammar already outputting-- or else they just do that instead of writing them against the spec."
- 2026-07-19T02:46Z (`history.jsonl:16773`): "a slightly sandboxed set of fixtures that are meant to be run as exploratory instead of as gates."
- 2026-07-19T19:55Z (`history.jsonl:16876`): "Please make sure any fixtures that are descriptive of technically undefined behavior get allowed to be part of the gate but that they *don't* frame themselves as prescriptive."
- 2026-07-19T20:21Z (`history.jsonl:16885`), about mainline CORE: "(there shouldn't be *anything* in the spec about fixtures. Only that text may fire events at any number of possible splits-- that a text event is not the full complete text)"
- 2026-10-09 (`.int/STEWARD-VERBATIM.md`): "would you propose or have an agent look at everything and propose a quick syntax/notation for expressing the AST here in chat and in the spec and in the fixtures (all the same ideally if it's elegant enough, but with big or minor differences acceptable if necessary)."
- 2026-10-09: "(also tell the agents they are welcome to use indentation and unicode in their proposals if it makes things more readable etc. I'd prefer that over "json s-expressions" or something verbose and jarring like that)"
- 2026-10-09, on the coordinator's lean for proposal A: "4. Pondering... I agree with your lean but there are still some remaining issues to consider..."

### Readings of his usage (mine; flagged, not resolved)

- **His word for the thing is "notation"** ("syntax/notation for expressing the AST"). He asked for one notation in three places (chat, spec, fixtures), "with big or minor differences acceptable". So "the notation" may be more than the one canonical spelling a harness compares; the word may need to cover the chat and spec latitudes too.
- **"fixture" is his settled word**, used since December 2025 (94 prompts in udon and descent projects contain it), always in the sense of an input with its expected output, grouped by spec version, with "gates" vs "exploratory" and "prescriptive" vs "descriptive". I found no competing word of his.
- **"there shouldn't be *anything* in the spec about fixtures"** was said about mainline CORE, where fixture-harness details had leaked into the language spec. [[rule:tree-transcript]] is a card in the spec about how harnesses compare fixtures. Whether his remark extends to it is a reading I can't settle; lite's spec is organized as a store that holds both rules and fixtures, which mainline's CORE.md was not.

### Two things the word currently covers

1. **A notation**: a small language for writing trees, with latitude in chat (`←` remarks, one-line forms) and in the spec (`#` meta). Proposal A §6: "one notation, three latitudes".
2. **A canonical printing**: exactly one spelling per «tree», defined by rules (proposal A §5, about eight), which is what fixtures store and harnesses compare.

They may want two names: Joseph's "notation" for (1), and something for (2).

### Other agents' leans

- Pre-design 86 (agent, 2026-09-29): "transcript", for a JSON form.
- Proposal A (agent, 2026-10-09): "notation", "canonical form", "printing rules"; a printer per implementation, no notation parser needed.
- Proposal B (agent, 2026-10-09): "transcript", "canonical printing", `transcript(tree, meta=false)` as the implementation's function.
- The coordinator's lean (as recorded in [[rule:tree-transcript]]): proposal A, one transcript line per source line for multi-line text.

### Precedents

- **html5lib tree-construction tests** (from memory; not re-checked today): each test has `#data`, `#errors`, and a `#document` section that prints the tree one node per line, prefixed `| `, indented two spaces per level: `<element>`, `attr="value"`, `"text"`, `<!-- comment -->`; fragment tests add `#document-fragment` with the context element. Close to proposal A's idea, and the nearest precedent for a canonical printed tree compared as text.
- **yaml-test-suite** `test.event`: a printed event stream (`+STR`, `+DOC`, `=VAL`…) per test. **toml-test**: expected output as JSON with tagged types. **JSONTestSuite**: file-name prefixes `y_`/`n_`/`i_` (must accept / must reject / either), the same idea as fixture profiles.
- **CommonMark's spec examples**: each example is input plus expected HTML, embedded in the spec itself and extracted by a script.
- **tree-sitter's test corpus**: input plus an expected S-expression.
- **Lisp**: "printed representation", and print-read consistency (printing then reading gives back an equal object). The idea proposal A's §5 tool relies on, in reverse.

### Questions about meaning, register and affordance

- **"transcript" next to "session transcript".** In this corpus a reader meets "transcript" most often as a session record. "Check the transcript" would be ambiguous in a working note.
- **Does the printed form get a name at all?** If the canonical printing is only ever mentioned inside [[rule:tree-transcript]], a phrase may do ("the tree's canonical printing"). It needs a "term" only if other cards refer to it.
- **Does lite need "fixture"?** The SOP's ⟦fixture⟧ is a record kind: one file of cases. `main.outline.md` says "A **fixture** (`dat/`) is a specific input and its tree or error", i.e. one case. Those disagree on grain (file vs case). If lite's own text needs the word, it should mean what the SOP means, and the outline sentence should say "a fixture case".

### My own opinion (the drafter's, Opus 5.5; not a lean of Joseph's)

- I'd drop "transcript": the collision with session transcripts is daily in this corpus, and the word isn't his.
- I'd use his **"notation"** for the language (the tree notation, or AST notation, following [[def:tree]]), and a plain phrase, **"printed form"** or **"canonical print"**, for the one spelling fixtures compare, promoting it to a "term" only if cards besides [[rule:tree-transcript]] need it.
- I'd not define "fixture" in lite: use the SOP's word in its sense (a file of cases), and fix the outline sentence's grain.

### Cards a change here would touch (left unedited)

- [[rule:tree-transcript]] (title, slug, statement).
- [[rule:fence-verbatim-label]], [[rule:prose-passes-through]], [[rule:prose-escaped-embeds]], [[decision:ast-centric]] ("its written transcript"): "transcript" in prose.
- `main.outline.md`, the paragraph defining card/fixture/companion ("A **fixture** (`dat/`) is a specific input and its tree or error"): fixture grain.
- `sop/def/def-fixture-profiles.md` working notes ("until a machine transcript is decided"): the SOP store's, not lite's.
