# Where the v2 branch stands, 2026-11-27

*To whoever picks this up next with Joseph, me after a break included, who will not have the conversation this came from. Written by the Claude Fable 5.2 session that has worked on this branch since 2026-11-20, when Joseph asked for anything worth keeping to be moved out of scratch and into the repo. It says what is live, what is a side version, and what is waiting on him. `DECISIONS.kdl` has his words for every lean named here; this file does not repeat them.*

## What the branch is

A rewrite of UDON from a clean slate. Everything earlier is under `.archive/`. The README carries the one line Joseph asked to have recorded: UDON is "a prose-first notation for typed knowledge."

The specification is kept as an outline of small segments, by hand, after the verisectorium model (`~/src/verisectorium/msc/notes/30-…` and its addendum).

## There are three versions of Part 1, and they do not agree

Read this before touching any of them.

1. **The canonical outline and its definitions.** `spec/canonical.outline.md` and `spec/def/{AST,element,attribute,root}.md`. The outline has had six parts since 2026-11-24 (core, kernel, syntax, schema, usage, dev). Its Part 1 rows and the four definition files are older than the day's later turns: they do not have attributes that can have attributes, complex nodes, or the partial as a type. `AST.md` has a block of OCaml types ending in `type ast = node list`; the other three have blocks of OCaml function signatures. Their thirteen examples are checked by `msc/spikes/2026-11-23-ocaml/thread2-verify/`, into which they were copied by hand.
2. **The Alloy shadow.** `spec/alloy.outline.md`, `spec/alloy-def/core.md`, `spec/alloy-def/root.md`, and `spec/alloy-def/verify.rb`. This is the most current statement of the structure: simple and complex nodes; partial, element and attribute as the three kinds of complex node; an attribute's name as the name its parent holds it under. `ruby spec/alloy-def/verify.rb` runs it (13 commands, no failures on 2026-11-24). Another agent wrote the first version; this session revised it.
3. **Two standalone sketches**, both superseded by the shadow: `msc/spikes/2026-11-24-alloy/udon_core.als` and `msc/spikes/2026-11-24-ocaml-types/subattribute_types.ml`. The second is kept for its `merge` function.

Joseph has not said which notation the spec will use, or whether Part 1 is to be one segment (as in the shadow) or one file per term (as in `spec/def/`). Until he does, the canonical Part 1 is stale and the shadow is unratified.

## Waiting on Joseph

- **Reading.** He has not read the Definition sections of `spec/def/` (waiting since 2026-11-20), nor the shadow's two files, nor the paragraphs for Parts 4 to 6 in the canonical outline.
- **Whether an attribute may have nothing in it.** `.archive/empty-attributes-chronology-2026-11-24.md` is the history, by an Opus agent, with this session's addendum. He leans toward allowing it and has not adjudicated.
- **What the top of a parse is.** His latest thinking, 2026-11-27, not yet answered in any file: "Initially I was thinking that a `partial` was just a convenience for parts of the AST-- but I think it is genuinely useful as *the* root node (for example, an element of |$partial kind) for udon that is being parsed from text input generally... I wonder if logical partials or search results would end up having a different kind of root element... or would it make more sense to have it always be `|$root` with `.file` or `.partial` or `.logical` or `.result`... etc..." If the top is always an element, the partial stops being a third kind of complex node.
- **One segment or one file per term** for Part 1, and **Alloy or OCaml types** in the spec's text.
- **Words for the text itself in Part 3.** The canonical outline calls complete source text a «partial», which now means what that text gives.
- **How the result of a parse is written down.** He has said twice that the notation is undiscussed. The kernel (Part 2), a subset of UDON with no shorthand, is the candidate.

## What 2026-11-23 showed

That day Joseph and a Gemini session read Liskov and Guttag, drafted `spec/PRAXIS.md`, and ran three spikes of UDON with OCaml (`msc/spikes/2026-11-23-ocaml/`). This session's reading of it, which he asked to keep:

- **A compiler can be the filter.** In the second spike a verisectorium store written in UDON failed to build when a draft was put in a settled slot, with no checker written for it. The estate's scarce thing is checking, and that makes checking free for a class of error.
- **Three projects are one design.** Verisectorium's ontology and a UDON schema are the same object, and the address theory's bindings and references are what keys and references did in the spike.
- **UDON is for nouns.** All three spikes found it better than raw OCaml for schemas, records, data and prose with checked references, and worse for dense expressions.
- **The schema is the larger half.** Without one, UDON lowers only to a generic tree.
- **Use found what consistency checks had not.** An agent writing 526 lines of real UDON was tripped three times by sameline rules.

One reservation recorded at the time: the store in the second spike is invented, with checks and acceptances that never happened. Loading the real `DECISIONS.kdl` and the real outline into that schema would be the honest next test.

## Working lessons from this stretch, each learned by getting it wrong

- A word with an ordinary meaning keeps it. "AST means AST."
- Shown UDON source, do not list its constructs or offer "choices" about settled ground. What is open is in `.archive/v2/spec-lite-0.1.0/TODO-MSC.md`. Doing this cost the chance to write the spec's own files in UDON now; they stay markdown and KDL.
- Asked what you think, read the largest new thing whole first, give the higher-order picture, then lead through one thread at a time.
- A lean is recorded as a lean, in his words, as the least they support.

## What I would do next

1. Get Joseph's answer on the top of a parse, since it decides whether there are two or three kinds of complex node.
2. On his word, rewrite the canonical Part 1 to the shadow's structure and retire whichever of the two forms he does not choose.
3. Have a cheaper agent bring the examples over and make their checking a script, as the shadow's verifier already is.
4. Then «text» and the other simple nodes, and the kernel form.
