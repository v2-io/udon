# spec-lite-0.1.0 — the basic UDON subset

**Status: pre-design (started 2026-09-29).** Nothing here is a spec yet. The open questions live in [`pre-design/`](pre-design/), one per file.

**Input from lite's first customer:** [`vsect-requirements-on-lite.md`](vsect-requirements-on-lite.md) lists what vsect needs from lite, mapped to the pre-design questions. The most binding items are robust fences (question 11) and source spans in the tree (questions 60 and 13).

## What "lite" is for

The corpus already needs a basic, stable UDON *now*, for data and document layout: an XML/HTML, YAML, or JSON alternative. The parts of the language that point elsewhere or run later (`!`, `@`, interpolation) are still being designed. Lite is the subset that can be used today without waiting for them.

## The one contract

**Reserve, don't ignore.** A lite parser recognizes future syntax just well enough to refuse it: it keeps the bytes and reports "reserved: not in lite." It never quietly reads future syntax as ordinary text. So:

> Any document a lite parser accepts produces the same tree under every future full version of UDON.

Authors can't accidentally write something that changes meaning later.

## Decided so far (Joseph, 2026-09-29)

- **Reserve, not ignore** — the contract above.
- **`|{…}` inline elements are in.** They are essential for the XML/HTML use case.
- **`<…>` (an explicit typed value) is in.** Lite finds where it ends and carries its text and optional type label, attaching no meaning. Dates, times, and durations are not typed in lite; the existing temporal parser may be reattached at implementation time.
- **Suffixes (`? ! * +`) lose their special status.** The intent, Joseph recalls, was to make them ordinary identity characters (to be confirmed — see pre-design).
- **Tables:** undecided, left for later.
- **AST-centric.** Lite is specified as the tree it produces, not as an event stream.
- **Implied root node.** Every document has one root node; everything starts as its children. The root may carry metadata such as the filename.
- **Terminology:** lite uses the addressing theory's vocabulary (`../references/def/`) wherever it applies — lite has no addressing, so only part of it does. Lite's own definitions will live in `lexicon.md` (not yet written). The lite term for an `<…>` or bare value is `typed value` (explicit / implicit).
- **No bespoke lite parser needed.** The mainline recursive-descent grammar (descent) is the implementation route; earlier throwaway Python parsers couldn't track the nuance.

Out of lite (reserved): `!` in all its forms (including `!:kind:` code blocks), `@` references, and `!{{…}}` interpolation.

## Writing convention

Terms defined in `lexicon.md` (not yet written) are written in backticks when used as the defined term (`typed value`, `element`), so they read as terms rather than as general words.

## Sources

The basic language is stable across `../spec-0.09.01/`, `../spec-0.10.00/`, and `../JOSEPH-FOR-0.10.01-FIX.md`. `../WHERE-THINGS-STAND-2026-09-27.md` has the history.
