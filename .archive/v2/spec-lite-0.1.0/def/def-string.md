---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: false
strength: provisional
terms: [string]
per: []
depends: [rule:embeds-in-text, rule:strings-like-ruby]
consequences: [def:text, def:value, rule:key-holds-a-value, rule:list-items-whitespace-separated, rule:strings-like-ruby]
---

# string

*A «string» is a value written in quotes: one piece, never broken up by embedded forms.*

## Terms

- **string:** a value written `"…"` or `'…'`, following Ruby's quoting with lite's escape list ([[rule:strings-like-ruby]]). It holds characters only: an embedded form inside quotes is just characters.
  - *Avoid:*
    - **"string" for an unquoted word.** In 0.9.1 and 0.10.0 "an unquoted token that is nothing else is a string" (the bare fallback), and the 2026-09-29 lite lexicon's implicit typed values included a "single-word string". In lite, `:a hello` gives a «text» ([[def:text]]).
    - **"text/string"** as one thing. Joseph's 2026-10-08 "quote/delimiter free text/string values" and "embedded in text/string" were written before the two were split.
    - **"quoted string"** as a separate term: the 2026-09-29 lexicon's name, and the slug of `rule:adjacent-quoted-strings`. In lite every «string» is quoted, so "quoted" adds nothing. As plain English it's harmless.
    - **"literal string"** for `'…'`. TOML uses exactly that name for its single-quoted strings, which have *no* escapes; lite's `'…'` take `\'` and `\\` ([[rule:single-quote-escapes]]).
    - **"string literal"** for the value. It's the source spelling; the «string» is what the tree holds.
    - **"blank string"** for `''`. Joseph's own phrase ("'' for blank string", 2026-10-09). "Empty string" is the usual term, and "blank" is used by [[def:blank-line]] to mean whitespace-only.

## Invariants

- A «string» and a «text» are different kinds of value, even when they hold the same characters: `:a "hello"` gives a «string», `:a hello` a «text».
- Which quote was used is not part of the value.

## Examples

```udon
|v :a "say \"hi\"" :b 'C:\dir' :c "|{em x}"
```
```tree
root
  |v
    :a "say \"hi\""
    :b "C:\\dir"
    :c "|{em x}"
```

## Working notes

- **Not reviewed with Joseph.** Joseph, 2026-10-09: "I haven't looked at any or been asked about any of those things … but the idea that they can just kind of organically be whatever would cause serious trouble really soon if allowed to continue." Every term here is provisional until he rules on it; `.int/lexicon-inventory-2026-10-09.md` lists where each came from.

- **Joseph's words:**
  > I think "..." and '...' should essentially be just like ruby strings (including escape sequences in "" but not in '', and including within the special constructs for labels, e.g. `|'something "hey"\'' weird node name`), different than our "general matching + escaping" for arrays, typed values, keys, and embeds.
  >
  > — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`)

  > I do worry about "string" being its own distinct type from "text" :-)
  >
  > — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`), agreeing that a key's interior is read as a value

  > … explicitly use nil, '' for blank string, or \ (for empty text)...
  >
  > — Joseph, 2026-10-09T16:39Z (`history.jsonl` line 22033), wording for the missing-value error

  > (which is probably the difference between text and a string-- text has any number of pieces some of which are not strings)
  >
  > — Joseph, 2026-10-08T22:48Z (`history.jsonl` line 21915)

  > Also, does it seem to you settled that we have pretty clear definitions at this point for the spec for string vs text vs prose ?
  >
  > — Joseph, 2026-10-09T16:39Z (`history.jsonl` line 22033). He later listed "clean definition and distinction for "string", "text", and "prose"" among lite's defining changes.

- **Readings of his usage, flagged as readings.**
  - "I do worry … :-)" can be read two ways: as a concern that two string-like types will trouble consumers (the cards' reading so far, answered by a reading option), or as a wry acknowledgement that the distinction is real and now has to be held. The smiley and "I do worry" fit either. Asking would settle it.
  - "'' for blank string, or \ (for empty text)" uses the split exactly as these cards do, a day after the worry. So in practice he already speaks of an empty «string» and an empty «text» as different things.
  - "text has any number of pieces some of which are not strings" treats the stretches of plain characters inside a «text» as strings. Under these cards they are «run»s ([[def:text]]), not «string»s. That's a third sense of "string" (a stretch of characters, as in most programming languages), and the most natural one to a programmer.

- **Precedents:**
  - **YAML** has exactly lite's two spellings, and treats them the opposite way. A plain (unquoted) scalar and a quoted scalar are both *scalars*. The quoting is a presentation "style", not part of the data, except that plain scalars go through tag resolution (so `true` and `8080` get types) while quoted ones resolve to strings. Lite instead makes quoted and unquoted different *kinds* in the tree. This is the strongest precedent for Joseph's worry: YAML users expect `name: web` and `name: "web"` to be the same string.
  - **KDL v2** has three string spellings (identifier strings, quoted strings, raw strings); all are the same value type, "String".
  - **TOML:** "basic string" (`"…"`, escapes) and "literal string" (`'…'`, no escapes); both are strings.
  - **JSON:** "string" is always quoted; there's no unquoted text at all.
  - **Ruby, Python:** a "string literal" is the source spelling; a String/str is the value; interpolated literals produce strings too. "string" there means *any* character sequence, which is closer to lite's «run» than to lite's «string».
  - **XML:** attribute values are always strings (`AttValue`); element text is "character data".

- **Affordances.** To nearly every reader, programmer or agent, "string" means "a sequence of characters", with no implication about quoting. Lite's «string» means "a quoted value". An agent told "`:a hello` is a text, not a string" will find that surprising, because in every language it knows, hello is a string. That's a real cost of the name, separate from whether the split itself is right. In the tree notation, `"…"` vs `‹…›` makes the split visible, which helps.

- **Candidates** (for the quoted kind, if the name changes):
  - «string»: the most familiar word, but in its narrow, quoted-only sense.
  - "quoted string" / "quoted value": names the spelling and says what makes it different; longer.
  - "literal": the lexer word for a spelled value; collides with TOML's "literal string" and with the literal/value distinction.

- **My own lean (the vocabulary agent for values and text, Opus 5.5; an opinion):** keep «string», and state in [[def:text]] and here, in one sentence each, that a «text» is not a «string» even when it has no embeds. The split is what lite's string/text/prose change is about, and "string" for the quoted kind matches JSON, which is the data audience lite most wants. What I'd watch is "string" used loosely in rule cards for "a run of characters"; that use should become «run» or plain "characters".

- Whether a reading option may present a «text» without embeds as a «string» is in [[def:reading-option]], not here.
- Trees use the notation of `.int/ast-notation-proposal-a.md`, provisionally.

### Coordinator's lean (Opus 5.5, 2026-10-09; my opinion for Joseph, not a lean of his)

- Agree: keep «string» for the quoted kind only, with one sentence here and in [[def:text]] that a «text» with no embeds is still not a «string». The affordance cost the drafter names is real (to most programmers `hello` *is* a string); the defining sentence and the tree notation's `"…"` vs `‹…›` are what pay it.
- His "I do worry about 'string' being its own distinct type" is worth one direct question, since a day later he used the split himself ("'' for blank string, or \ for empty text").
