# Labels, part 2: ASCII punctuation, positions, and what a label may never hold (2026-10-20)

*The coordinator's (Opus 5.5) lean on the rest of the label-characters question, written for Joseph and the next agent. Part 1, the Unicode repertoire, is `labels-unicode-options-2026-10-20.md`; read it first. Nothing here is decided. Settled facts this rests on: an unquoted label can't begin with `.` (spaced traits, provisional, [[rule:traits-may-follow-spaces]]); quoted labels hold anything except newlines (Joseph, 2026-10-12); the suffix characters `? ! * +` lost their special status, and Joseph's recollection is that they were to become "just another allowed identity character" ([[decision:suffixes-lose-special-status]]).*

## The framing

Every ASCII punctuation character except `_` is `Pattern_Syntax` (part 1), so whatever lite admits in bare labels is a declared addition. A character can be in one of three states for a bare label:

- **allowed** (first, inner or last position);
- **ends the label** because it starts the next construct in that position (`[` a key, `.` a trait, a space the next thing);
- **an error**, with the message "quote this name". Not "ends the label": an error leaves a later version free to allow the character without changing any accepted document. The same posture as reserved spellings.

## Lean, character by character

| Character | Lean | Why |
|---|---|---|
| letters, per part 1 | first, inner, last | |
| digits `0-9` | inner and last; **not first** | XML and UAX #31 both forbid a leading digit; keeps `|2` and `:3` from reading as names where a number is meant. Cost below. |
| `_` | first, inner, last | XML allows it first; already an identifier character. |
| `-` | inner and last; **not first** | `data-id`, `my-widget`, `aria-label`. Not first, so Markdown's `|---|` and `|-|` stay text, and `-1` never reads as a name. |
| `:` | inner and last; not first | `xml:lang`, `svg:rect`, `xlink:href`. An attribute needs a space before its `:`, so `|svg:rect` is unambiguous. First-position `:` would make `::x` mean something; leave it an error. |
| `/` | inner and last | Namespacing by convention (`acme/widget`), no meaning in lite. |
| `$` | **first only**, for the designated names | `$key`, `$traits`, `$main` must be writable as attribute names. Elsewhere an error, for now. |
| `?` `*` `+` | inner and last | His "just another allowed identity character": `field?`, `items*`, `count+`. Their schema readings live in consumers. |
| `!` | **error** everywhere in a bare label | Lite reserves `!` "in all its forms"; `|a!{{x}}` would otherwise sit right next to reserved syntax. Cheap to widen later. |
| `.` | ends an element name or key (a trait follows); **error** in an attribute name | One character set for all labels (the lean from item 1); `:a.b` quoted until there's a reason. |
| `[` `]` | `[` ends an element name (a key follows); otherwise an error | |
| `@` `#` `%` `&` `=` `~` `^` `,` | **error** | No use yet; each is a likely future syntax character (`@` references; `=` assignment; `#` anchors). Quote to use them. |
| `{` `}` `<` `>` `(` `)` | error | Bracket characters stay structural. |
| `"` `'` `` ` `` `\` `;` `\|` | error inside; `"`/`'` first means a quoted label | |
| space, tab | end the label | |

## The cost of "no leading digit"

Markdown table rows with numbers at a line start (`|1|2|3|`) now open an element whose name is invalid, so the line is an **error**, under the guard-versus-validation split of part 1. Rows starting with letters (`|Name|Role|`) already open elements by Joseph's 2026-10-08 ruling, so this extends a known collision rather than creating one. The fixes are the ones lite already has: indent the table past the text's left edge, start it with `| ` (pipe-space), or escape the first `|`. If that cost is too high, the alternative is to let the guard require a letter, `_` or `$` after `|` and leave `|1|2|` as text. That ties the guard to the label rule again, which part 1's split exists to avoid.

## What a label may never hold, even quoted

Lean: no label, bare or quoted, may contain:

- a line ending (decided: "anything except newlines"), and so no `\n` escape in a quoted name either;
- a C0 or C1 control character (U+0000–U+001F, U+007F–U+009F), raw or escaped;
- the bidi controls U+200E, U+200F, U+202A–U+202E, U+2066–U+2069;
- a noncharacter or an unpaired surrogate.

Each is an error. Reasons: these make two names look identical while differing, or a name display out of order (UTS #55's spoofing cases), and a name never needs them. Strict now, widenable later. Private-use characters and the zero-width joiners are left allowed when quoted: emoji and some scripts need ZWJ.

## Three more choices the label card needs

- **Quoted equals bare.** `|'a'` is the same name as `|a`, and `:'ready?'` the same as `:ready?` (he said this for attribute names, 2026-07-16). Lean: true for every label; the quotes are spelling, kept in «meta».
- **Case.** Never folded: `|Div` and `|div` differ. Lean: obviously; it's what every XML and JSON consumer expects.
- **Normalization.** Lean: byte equality in lite, plus the default-off warning from part 1 for a label not in NFC. NFC equality would put normalization tables in every tiny parser, and the warning catches the real-world case (an editor that decomposed an accent).

---

*Addendum, 2026-10-28 (session `01Hgdj3fobqBFEmAFmJi6Zup`): the value explorations of 2026-10-22 all found that a `:` at the end of a name must never be part of the name (`:host: localhost` names `host`); the table above allows `:` last. Whether a trailing colon is consumed or an error is Joseph's open decision on the trailing colon (`spike-values-2026-10-22/ADJUDICATION-GUIDE.md`, decision 7).*
