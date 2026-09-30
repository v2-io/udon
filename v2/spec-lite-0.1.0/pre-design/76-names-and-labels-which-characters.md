# 76 — Element names and attribute labels: which characters are allowed

## The question

Which characters may appear in an element name (`|name`) and in an attribute label (`:label`) without quotes? In particular, can lite spell the names that XML, HTML and JSON documents actually use?

```udon
|svg:rect :xlink:href #a :xml:lang en
|my-widget :data-id 7 :aria-label Close :@click go :v-on:click go
|_private :_id 1 :2fa true
```

## Why lite must decide

Lite is meant to be an XML/HTML/JSON alternative. JSON keys can be any string; XML names allow `_` at the start, `.`, `-`, and `:` for namespaces; HTML has `data-*`, `aria-*`, and framework attributes like `@click`, `:value`, `v-on:click`. Every lite parser must agree on where a name ends — and a name that ends early silently turns its remainder into something else (an attribute, text).

## What the texts say, in date order

- **2011, `udon-c/docs/DECIDED.md`:** labels (element names, class names, attribute keys) stop "on whitespace or `[|\[.!]`" and "allow, incidentally, embedded `[#:]`"; "':' allowed in labels (so allowed in attribute keys and node names, etc.)"; "To have a key start w/ colon just double it up".
- **2011, `udon/examples/overview.udon`:** "Colons not allowed in key except as first character unless key is quoted"; namespaces written `|ns/element`, `html/href: …`. **`udon/.attic/syntax2.udon`:** `|namespace:type[id]` with a namespace part before the name.
- **Jul 2026, 0.8.0-alpha.1** (CHANGELOG): "bare-name char class fixed to Unicode `XID_Start` / `XID_Continue` + `-`".
- **0.10.0 §5.2** (`v2/spec-0.10.00/CORE.md`): element name = first character `XID_Start` ("letters — not digits, `_`, or `-`"), then `XID_Continue` or `-` or `/`. `/` is "conventional namespacing with **zero** core semantics". Anything else ends the name; other names take single quotes (`|'weird name'`). The suffix characters `? ! * +` are not name characters (file 06).
- **0.10.0 §6.2 / K12** (2026-08-08/09): a bare label is "a contiguous run of non-space characters following the `:`", and "may contain — in any position — `*` `$` `#` `!` `?` `^` `.` `,` `-` `+` `_` `=` `~` `/` `:` `;` `|`, and interior `'` or `"`." Joseph: "my gut is telling me it's going to be another instance of limiting an important use-case because of an unimportant failure mode." Consequence stated there: emoticons like ` :-)` open attributes.
- **UNI** (0.10.0 CARVEOUTS §UNI): which Unicode version defines `XID_*` is unpinned; "non-ASCII identifiers are **not portable** across implementations declaring different versions (ASCII names are stable everywhere)."
- **2026-07 analysis** (memorata, `session-vault/raw/claude/da5d1672…md` ~L6752): "start: `A–Z a–z` — *not* digits, *not* `_`, *not* `-`"; "because the definition delegates to 'whatever Unicode says,' it's **version-dependent**" — flagged as a genuine open decision.
- **REF-SLASH** (`v2/OPEN.md`): the reference name class omits `/` while element names include it (references are out of lite, but a future `@name` must be able to point at every lite name).
- **Old parser (evidence only):** treats any non-ASCII lead byte as a name start; `|→arrow` opens an element, while CORE says `→` is not a name start (`core/fixtures/v0.9/pending-unicode.yaml.disabled`).

## The gaps, concretely

| Written | 0.10.0 reading | Notes |
|---|---|---|
| `\|svg:rect` | name `svg`, then `:rect`? | no space before `:`; K12's label rule assumes a space-framed `:` |
| `\|_private` | `_` fails the guard → the line is text | XML allows `_` first |
| `\|2col` | text | digits can't start names |
| `\|my.widget` | name `my`, trait `widget` | `.` starts a trait |
| `:xml:lang en` | label `xml:lang` | allowed by K12 |
| `:@click go`, `:(x) 1`, `:<b> 1` | unstated | `@ ( ) < > [ ] & %` are not in K12's list |
| `:data[1] x` | unstated | `[` not in the list |
| `\|Div` vs `\|div` | unstated | case sensitivity never written down |
| `\|café`, `\|名前` | legal, version-dependent | UNI |

## When are two labels the same label?

Stacking (`:x 1 :x 2`) needs a rule for "same label": is `:a` the same as `:'a'` (0.9 ruled flag meaning "follows the NAME (quoted ≡ bare)", CHANGELOG 2026-07-16 R4)? Is `:Name` the same as `:name`? Are two labels that look identical but use different Unicode encodings of `é` the same? None of this is written down for lite.

## Alternatives

### A — 0.10.0 as it stands (narrow element names, wide labels, quotes for the rest)

```udon
|'svg:rect' :xlink:href #a
|'_private' :_id 1
```
```text
document
├ element "svg:rect"
│   xlink:href "#a"
└ element "_private"
    _id 1
```

### B — widen element names to XML's rules (allow `_` first; allow `.` and `:` inside)

```udon
|svg:rect :xlink:href #a
```
```text
document
└ element "svg:rect"
    xlink:href "#a"
```

Cost: `.` inside a name conflicts with traits (`|p.note`), `:` with attributes written without a space.

### C — one character rule for both names and labels (the narrower or the wider one)

### D — ASCII-only names in lite; non-ASCII names reserved until the Unicode version is pinned

```udon
|café :x 1        ; anomaly: error, reserved (non-ASCII name); bytes kept
```

### E — any label a JSON key can be, via quoting: `:'any string at all'`, with names the same way

(Already legal in 0.10.0; the question is whether lite also needs the bare forms above.)

## Interactions

- [06](06-suffix-characters.md): whether `? ! * +` join element names.
- [77](77-identity-keys-and-traits.md): trait names and `.` in names.
- [08](08-pipes-and-markdown-tables.md): which characters after `|` open an element.
- [71](71-how-far-an-unquoted-value-runs.md): wide labels are why ` :-)` and ` :foo` end values.
- [86](86-mapping-to-json-xml-yaml.md): names that must survive conversion.
