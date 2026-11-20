---
source: origin conversation — Joseph proposing UDON as archema/rowan's resource+schema DSL (Claude Code session, ~/src/archema, 2026-01-05)
gathered: 2026-07-21
status: gathered (excerpt — Joseph's verbatim user turns only, from a 25-message session; assistant turns summarized, not copied)
paths:
  - ~/.claude.bak.2026-01-26/projects/-Users-josephwecker-v2-src-archema/49e83cdf-d736-4601-a505-644ecae6f4f1.jsonl (user turns: msg#1,10,14,18,22)
source_mtime: 2026-01-05 (file mtime; session date)
categories: [ideology-origin, udon-as-schema-dsl, cardinality-syntax, language-agnostic-schema, cross-tier, verbatim-joseph]
why_included: >
  CROSS-TIER ORIGIN. This is where UDON-as-schema-DSL for rowan begins, in Joseph's own words — the
  first-principles ideology tier meeting the schema-versioning family. Also the actual provenance of the
  RelaxNG-compact cardinality idea (?/*/+/! for elements + attributes) that TARGET-FILES misattributes to
  rowan's feedback.md and that UDON's design/udon-schema-exploration.md carries as "Puzzle Piece 1". The
  demand articulated: resource definitions that "feel like real declarative evolving resource definitions —
  a step cleaner and also richer than ruby dsl", as accessible to humans as agents, and language-agnostic
  (not Ruby-coupled), with an inline host-code escape hatch (!:ruby:) for the complex tail.
---

> **Editorial banner.** Verbatim user (Joseph) turns from a Jan-5-2026 Claude Code session in
> `~/src/archema` (now rowan). The task opened by asking the agent to read UDON's README + FULL-SPEC,
> then posing "the primary question": UDON's applicability as a resource DSL / schema definition
> language, and whether it could be language-agnostic rather than Ruby-coupled. Assistant turns
> (enthusiastic analysis + one self-correction Joseph accepts in msg#22) are not reproduced. The inline
> UDON sketches are Joseph's, typos included.

## msg#1 — opening
> Would you please read ~/src/udon/README.md and ~/src/udon/FULL-SPEC.md and then I have some questions for us to consider wrt udon in archema

## msg#10 — the primary question
> Many of the infrastructure aspects will almost certainly end up being UDON, but I'll bet you've guessed at the primary question I would like to pose and analyze this morning: it's applicability as a resource dsl / schema definition for UDON-- and the possibility of it even being somewhat language agnostic-- or at least not as tightly coupled to ruby idioms...

## msg#14 — Ruby-first acceptable; UDON extends itself; cardinality sigils
> 1. Ruby-first is definitely acceptable. Liquid templates and other things prove though that we can end up getting pretty far along in the end before getting into complex ruby.
> 2. Possibly. I mean UDON naturally extends itself:
> ```
>    |action[archive]
>      For records that we no longer need-- they still need to be available for the auditors.
>      !:ruby:
>        fields = TheResource.fields.map{|f| f.to_s}
>        # ...
> ```
> 3. I actually feel udon will be more accessible to humans as well as agents. It will be a very slight learning curve for rubyists-- but no more than the DSL is already. And ruby was the genesis for ancestors of udon like haml and liquid, less and slim. So it's definitely well within the culture.
> 4. I don't mind them coexisting, but it seems like a bit of an extra layer potentially. There's no need for conversion because archema hasn't been released yet and we are the only ones that have written resources-- mostly experimenting.
>
> ```
> |field[tags-by-category]? |{map :string [:integer]}  ; ? (or *,+,!) are available for elements and can indicate cardinality if we want
> ```

## msg#18 — the demand, stated
> I'm not sure yet on all of those (except #3 probably yes, and #2 still optional-by-default- use ! for required).
> But even just the range of syntaxes available (including plain text if we really wanted: `|field[name] string not null`) and your enthusiasm (which may just be a function of mirroring and task-completion gravity, both totally appropriate here) feels like a validation of what I've been feeling for a while-- a desire to make the resource-definitions feel like real declarative evolving resource definitions-- a step cleaner and also richer than ruby dsl-- more equivalent to what you'd get when you ask a random AI agent "Explain to me what [ash|archema] resources you plan on putting together for such-and-such project..." in a conversation.

## msg#22 — "what would make it even more appealing to agents?"
> Very well put-- and I appreciate the correction; I wasn't giving your enthusiasm enough credit. You've read the README and full-spec already. Can you think of anything that would make the format even *more* appealing to agents?
