---
source: ennaos docs/research/mutable-code-comprehension/README.md — Joseph's framing of tool failure-honesty (~Nov 2025)
gathered: 2026-07-21
status: gathered (verbatim whole-file copy)
paths:
  - /Users/josephwecker-v2/src/_core/ennaos/docs/research/mutable-code-comprehension/README.md
source_commit: 5abb2fe
categories: [primary-ideation-jaw, failure-honesty-ladder, silent-failure-worst, intent-delivery, error-implies-fix]
why_included: >
  Joseph's own framing, directly resonant with UDON/harness edit-tool error-message design. The failure-mode
  quality ladder: tools must be honest about whether they delivered the intent (silent failure = worst, it injects
  guaranteed latency into the feedback loop) -> know it failed -> categorize it -> the error IMPLIES the fix ->
  the tool can "mkdir -p"-style just complete the intent ("describe the intended result" vs "try this thing next")
  — and this holds "at every level of abstraction," including feature-implementation, not just file ops.
---

This research area is looking into the following problem domain:

When a tool that attempts any level of side-effects 'fails' to create an
effective part of the atomic changeset -- what does it reveal (by failing, or
through the error message, through more verbose feedback, etc.) that wasn't
already known about the code-domain? Why wasn't it known yet? Should it have
been? If so, how? Tools should be honest about whether or not they succeeded in
delivering the intent above all (silent failure is least functional-- guaranteed
latency in feedback loop-- that includes at higher abstraction levels like
implementing features which, unless they are A/B tested, essentially are able to
silently and invisibly and utterly fail at delivering the intended user
alignment. But it's just as true for `mkdir asdf` -- a version that silently
fails wouldn't be very useful.) Better if we know it fails. Better still if we
have a category of the failure mode. Better still if the failure mode or error
essentially implies the correct fix a lot of the time. Better still if it is
*sure* what the steps are that would have allowed it. Better still if it, for
some subset or all failure modes, is allowed at the option of the invocation
agent, to *do* what other things it needs to (e.g., `mkdir -p ./asdf/abc/def`
which is more of a "describe the intended result" instead of "try to do this
thing next"). But, to be clear, this needs to be happening at every level of
abstraction (because the tools are all along that spectrum).

But this research topic is specifically about the "what about the *code-base* in
particular can be comprehended earlier and faster" and "what kinds of immediate
feedback can the codebase give that very quickly establishes alignment and
intent or very quickly enhances the agent's mental model of the true nature of
the code and system and effects of the intended change (which we can then ask,
"how could it have known earlier?").

What are the possible approaches to represent an elixir/otp umbrella app in
such a way (we'll term it the "alt-state" or an intermediate state or
representation of the codebase here generically) that ideally satisfies the
following objectives-- (1) **VERY FAST TIME TO (AGENTIC) COMPREHENSION** -- and
(2) VERY TIGHT FEEDBACK LOOPS ON effects proposed modifications (correctness,
completeness, all intended and unintended behavior, etc.). The former could be
given a more formal measurement ala TST such as mean time-delta from
feature-understanding to first permanent change, etc.

1. The Alt-state represents enough of the code-base to generate a functionally
identical system. (Existing intermediate states etc. have this by design
especially if they are critical links in the build toolchain).

2. The speed of transformation from repository directories and files to
alt-state happens very quickly-- sub-second for most projects up to a certain
size. Sub-3-seconds on current consumer hardware for even many of the very
largest monoliths and umbrella applications. Distinct boundary caching etc.
would make it scale-invariant so we're primarily interested in the sub-1-second
for a small-medium sized project.

3. Ideal system would probably be able to output "compliant" "source"
representation from just the alt-state representation. It does not have to have
perfect mirror accuracy-- especially in matters of whitespace and AST
equivalence (with comments and typespecs etc. preserved). It does not
necessarily have to re-dehydrate macro invocations. It can change names of
inconsequential intermediate elements and may change ordering in certain areas
where the ordering is irrelevant to the generated AST.

4. The ideal system could *start* in the alt-state and generate a compiled
representation (inc. via generating source). That is, it doesn't have explicit
or implicit dependency on original filename/line/col metadata.

5. Ideally though it *would* retain that original source meta-data for tracing
when it did get generated from an earlier "source," (although, due to #4,
without it becoming an implicit requirement)

6. Same speed constraint of sub-1s on outputting a file-based ("source")
representation based on having just the alt-state.

7. It supports static type checking, including inference and the evolving
notational forms, with as much completeness as possible. (Need to turn this one
into an actual set of necessary capabilities / catches it automatically
detects). The result is to make certain kinds of errors and failure cases
impossible.

8. Ideally it would support some level of dataflow analysis with BEAM/OTP
concurrency and actor model as a first-class citizen.

9. Ideally it could be used as or allow for the generating of very actionable
and useful documentation.

10. Lend itself to property testing and related tools

11. BUT-- much more importantly-- this intermediate alt-state WOULD BE
MODIFIABLE with tight feedback loops with fast-fail error/impossible-state
rejection and acceptance and verification of functional objectives.


... Probably more...


I would like to explore things similar to this paper but for elixir/otp apps in
particular: "Neural Code Comprehension: A Learnable Representation of Code
Semantics" (1806.07336v3.pdf  2018). Which is to say, it's not all just about static analysis / proofs, etc.-- it's about everything that could give us a better representation of the code ready for an agent, auxilia, or ELI.
