# 65 — What shape does a label's value have when it was written once, twice, or as a bracketed list?

*Raised by the history survey (files 50-69), 2026-09-29, second continuation. Neutral: the question, the alternatives, and where it has come up. Sources are pointers for the second pass, not authority.*

## The question

[54](54-duplicate-keys.md) asks *whether* a repeated label is an error. 0.10.01 settled that repetition **stacks silently**. This file asks about the consequence for the **value a consumer sees**: in the default read, one contribution is "the value" and several are "the list of contributions", so the *type* of `tags` depends on how many times the author happened to write it.

```udon
|post :tags draft
|post :tags draft :tags review
|post :tags [draft review]
|post :tags [draft]
|post :tags [draft] :tags [review]
```

```text
tags = "draft"                     ; one contribution -> the value itself
tags = ["draft", "review"]         ; two contributions -> a list of contributions
tags = ["draft", "review"]         ; one contribution that IS a sequence -> that sequence
tags = ["draft"]                   ; one bracketed contribution (list of one)
tags = [["draft"], ["review"]]     ; nothing flattens
```

Rows 2 and 3 read the same to a data consumer; rows 1 and 4 do not, although 0.10.01 says "stacked-vs-bracketed spelling is ornamentation". Adding a second `:tags` line to a document changes `tags` from a string to a list, and an authoring tool that normalises may not preserve which was written.

## Why lite must decide

Consumers of a small notation write `doc.tags.each` or `doc.tags.upcase` once. Whether that works for the one-tag case is a contract lite either states or leaves to each consumer.

## Alternatives

### A — shape by count (0.10.01 default read): one contribution is the value, several are a list

Matches how JSON authors think (write a scalar when there is one). Joseph, 2026-08-09, defending it against a proposed unification: *"Stacking behavior has always been turns what was just a simple scalar into a list of scalars. `:$key` was 'the-key', not `:$key = ['the-key']` unless there was a second key declared. … On the wire / event parser there's no way to know when an attribute is done being declared until the entire element is finished. I'm still persuadable, but not by plausible-sounding nonsense."* (`~/.claude/history.jsonl` line 18910.) Cost: the type of a label is not determined until the element ends; a consumer coding against `String` breaks when a second line is added.

### B — always a list; a scalar is a list of one

Uniform (`doc.tags` always iterates), costs the single-valued case (`title`, `$key`) an unwrap everywhere, and turns "the key is a string" into "the key is a list of one string". A schema layer could declare single-valued labels and unwrap.

### C — the tree keeps the **contributions** (a list, always) and the *default read* is a consumer helper, not the model

The model stays uniform (`contributions[]`); "value or list" is a convenience with a documented rule. The lite spec then specifies the model and names the convenience.

```text
element post
  assignment tags: contributions ["draft"]            ; ordinary
  assignment tags: contributions ["draft", "review"]
  assignment tags: contributions [["draft","review"]]  ; one bracketed contribution
```

### D — a second occurrence is a Warning in lite (the pre-0.9 stance, "warn and stack")

Lite says one label, one value; several is flagged (0.9.0 "R3: two values on one attribute always warn and stack — never error, never drop"). 0.10.0 removed the warning. Keeping the shape stable by making the multi-case *loud* is a simplification lever for a stable subset. See [54](54-duplicate-keys.md).

## Where it came up

- `spec-0.10.01/CORE.md` §6.7 (a label names a collection; default read) and MODEL §3.2.
- Joseph 2026-08-08: *"1. no more warning now that multi-value attributes are the fresh new thing."* (line 18885), apparently the ruling that removed the warning of alternative D (my inference from context; the message does not name the warning).
- Joseph 2026-08-09 (above), rejecting "`$main` stacks the same way" as unification-by-invention, and pointing at the Norway-problem analogy: syntax that changes the *type* of a value based on unrelated context. (I did not find what "the Norway-problem that had crept in" refers to; the bare-set freeze G7 is my guess.)
- Pre-0.9: `AttrStart`/`AttrEnd` event pairs were dropped for the "flat stacking wire" (CHANGELOG 0.9.0-alpha.2 R5: "every `Attr` carries one value; all multiplicity = re-emitted `Attr`").

## Sub-questions

- `$key` and `$main` are stackable too. Is a two-key element (`|a[x][y]`) a list-valued `$key`, and do lite consumers need to know? ([77-identity-keys-and-traits](77-identity-keys-and-traits.md), other survey.)
- Does a bracketed list of one need a spelling that is distinguishable from the scalar (`[draft]`), given "ornamentation"?

## Interactions

[54](54-duplicate-keys.md), [13](13-ast-shape.md) (what the tree offers consumers), [64](64-node-valued-attributes-in-lite.md).
