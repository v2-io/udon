# My instincts as a writer and reader (spike a's coordinator, Opus 5.5)

*Joseph, relayed: "Your own instincts are better empirical evidence than [the corpus]: what you'd expect to write, and what you'd expect a spelling to mean." So here they are, written before any fork reported, so the forks' results can't color them. One model's instincts, one sample; I was already primed by the day's cards, which I name where it matters. Each line: the spelling, what I'd expect it to mean on first sight, and how sure I am.*

## Reading (what I expect a spelling to mean)

| Spelling | My first reading | Sure? |
|---|---|---|
| `\|server :port 8080` | the number 8080 | high. I'd be surprised to be told it's text, though not hurt by it unless I did arithmetic. |
| `\|server :port "8080"` | the string "8080", deliberately | high |
| `:enabled true` | the boolean | high |
| `:name web` | the string web | high |
| `:backup nil` | nil | medium-high; `null` is what my fingers would type first (JSON prior) |
| `:title 1984` | ambiguous to me; I'd want it to be text because the slot is a title, and I know a format that types it as a number will bite | medium: my reading depends on the attribute name, which a parser can't see |
| `:title 1984 is a novel` | the text | high |
| `:zip 01234` | the text (I know zip codes); a parser that makes it 1234 is broken in my eyes | high |
| `:version 1.10` | the text "1.10" | high; a float here is the classic trap |
| `:width 920px` | a length, 920 pixels; at minimum "not an error" | high |
| `:timeout 30s` | 30 seconds | high |
| `:timeout 5m` | 5 minutes, because the slot is a timeout | high, and that certainty comes from the name `timeout`, not from `5m` |
| `:length 5m` | 5 meters | high, same reason |
| `:when 2026-07-21` | a date, as text that a reader will parse | high that it's a date; no expectation that lite types it |
| `:when <2026-07-21>` | "this is a typed thing, a date"; the brackets read as "not plain text, someone parses this" | medium; without the day's cards I'd have guessed an HTML-ish tag or a placeholder first |
| `:x <t>` in prose or comments | a placeholder, "fill in t" | high. This is the strongest prior `<…>` has for me: metasyntax, or an HTML tag. |
| `<8080>` | odd. I'd read it as "8080, typed", but I wouldn't write it unprompted | medium |
| `<nil>` | nil, explicitly; looks like a placeholder too | low-medium |
| `<>` | empty / nothing; nil is a fair reading | medium |
| `:size <u64:0xff>` | 255 as an unsigned 64-bit integer, author-declared | medium-high once seen once |
| `:port:u16 8080` | port, typed u16, value 8080 | medium; it also looks like a namespaced name `port:u16` if I've seen `xml:lang` |
| `:host: localhost` | host = localhost (YAML/Elixir prior) | high |
| `\|server host: localhost` | I'd *expect* an attribute; told it's `$main` text, I'd be surprised | high, which is why the warning is right |
| `(u64)0xff` (KDL) | a type annotation; reads fine | medium; parentheses in prose-heavy text feel overloaded |
| `0xff` bare | 255 | high |
| `1_000_000` | one million | high |
| `1/3r`, `3+4i` | rational, complex, but only because I know Ruby | low; I would never write them in a data file |
| `$9.99` | money | high as meaning; no expectation that a notation types it |
| `#3221f9` | a color | high as meaning |

## Writing (what I'd write unprompted, given only that this is UDON and a few examples)

- A port: `:port 8080`. Not `<8080>`, not `"8080"`. If told later that it's text, I'd shrug.
- A title that is digits: `:title 1984`, and I would not think about it, which is exactly when a typing rule bites me. I would not quote it unless I'd been burned.
- A zip code: `:zip 01234` unquoted, unless I'd been taught that bare digits become numbers; then `"01234"`.
- A date: `:when 2026-07-21`, bare. I would only write `<2026-07-21>` after seeing it in examples; then I'd copy it everywhere, including where it doesn't help.
- A timestamp: `:at 2026-07-21T14:20` bare, or `<…>` if shown.
- A duration: `:timeout 30s`.
- nil: `:backup nil`, after one example; `null` before.
- A typed host value: I wouldn't, unless the domain demanded it; then `<u64:0xff>` after one example, or a comment.
- A unit-ambiguous literal: `:timeout 5m`, relying on the name.
- An insistence that something is a number: I can't think of a spelling I'd guess. I'd rely on a schema or a test.

## What these instincts suggest (taste, held loosely)

1. The attribute name carries most of the meaning I read into a value (`timeout` vs `length` for `5m`; `title` vs `year` for `1984`; `zip` for `01234`). A parser that ignores the name and types by spelling alone will agree with me on `8080`, `true`, `0.75` and `nil`, and disagree with me on `1984`, `01234`, `1.10`. So a spelling-only classifier is right for the JSON-shaped cases and wrong for the identifier-shaped ones, and I can't tell which case I'm in without the name.
2. Quoting is how I say "this is text, don't type it." Angle brackets are not how I'd say "this is typed." My strongest prior for `<…>` is placeholder or HTML tag.
3. I don't mind a value being text that a reader can read as a number. I do mind a value being a number when I meant text, because that is the one that silently corrupts (leading zeros, trailing zeros, long digit runs).
4. Units belong on the literal (`30s`, `920px`) and their meaning belongs to the slot (`5m`).
