# Glyphs: is `<…>` the right mark?

*Joseph, 2026-10-22: "we could use different brackets/combinations, and we should visit all of that." Each candidate is judged by what it collides with **where a value starts** (the only place a mark is recognized), by what a writer's priors make it mean (instinct), and by headroom (B6). Precedents are evidence about a glyph's priors, checked where cited.*

## `<…>`: alive, the default

- **Collisions at a value start:** inline HTML (`|li <kbd>Ctrl</kbd> to copy`), Markdown autolinks (`|li <https://example.com>`), comparisons (`|li <= 5 items`). *Checked, CommonMark 0.31.2 §6.5–6.6:* an autolink is `<` followed by a scheme (an ASCII letter, then 2–32 characters) and `:`; a raw-HTML open tag is `<` followed by an ASCII letter. So `<=` and `< 5` are neither, and every HTML and autolink shape starts `<` plus a letter. Under M1 all three are errors with an escape suggestion; under M2 the autolink alone is silent (see m2).
- **Priors:** a placeholder in usage docs (`<file>`), a generic type parameter (`Vec<u8>`), an HTML tag, REBOL's `tag!` (*checked*, REBOL Core ch. 16: `<…>` is a tag, "used in HTML and other markup languages"; so the REBOL homage is to the bracket, not to REBOL's use of it). None of them is "a literal of some kind", so the meaning has to be learned. Once seen, it's one rule (A2 after exposure: fine; A3 cold: the placeholder reading is the risk, and the error catches it).
- **Headroom:** already spent by lite. Free.

## `~name[body]`, Elixir-style sigil: alive as the fallback glyph

*Checked, Elixir's sigils guide:* `~D[2026-01-10]` gives a Date, `~U[…]` a UTC DateTime, `~r/…/` a regex; custom sigils are a single lowercase letter or an uppercase letter followed by uppercase letters and digits; eight delimiter pairs are allowed. It is the closest precedent for Joseph's definition of a dialect ("a type namespace with its parser"), and "sigils" is on his own list of related concerns.

- Lite version: `~` + label + `[`, nothing else (no `/`, `|`, quote delimiters, so `~jw/src` and `~5 min` stay text). Kind is known at the `[`, a label's length in.
- **For:** frees `<` entirely, so HTML and autolinks at a value start never collide (C2/C3 up). Agents that know Elixir read it at once.
- **Against:** a second mark character and bracket for one job (A8); the primitive assertion `<8080>` has no natural sigil form (`~[8080]`?); A1 is my taste against it, since it reads as code inside a notation that otherwise reads as prose. Worth keeping because, if the `<` collision turns out to matter, this is the only candidate that removes it without a new cost elsewhere.

## Dead

| Glyph | Example | Died of |
|---|---|---|
| KDL type annotation, `(type)value` | `(u16)8080` | *Checked, KDL spec §3.8:* "a set of `(` and `)` with a single String in it", before a value or a node name; unknown annotations may be ignored. In lite, `(` at a value start is ordinary prose (`|li (optional) bring a jacket`), so the mark would capture it (C2/C3); parentheses are also likely wanted by full UDON (B6). |
| EDN tag, `#tag value` | `#inst "1985-04-12T23:20:50.52Z"` | *Checked, edn README:* unprefixed tags are reserved for built-ins; an unknown tag may be an error or go to an "unknown element" handler. In lite, `#` at a value start is a CSS id or colour (`:href #a`, `:color #ff0000`), an issue number or a hashtag, all ordinary text (C2). |
| YAML tag, `!tag value` | `!!int 3` | `!` is reserved for full UDON's directives (B6, and B2 already refuses it); a mark there spends exactly what dynamics need. |
| Prefix-quote, `name"body"` | `date"2026-01-10"` | The word before the quote is ordinary run text until the quote arrives, so the kind is known only after an unbounded word: a holdback on the slot side (B1-flavoured), and `said"hi"` changes meaning. |
| A suffix on the value | `2026-01-10:date`, `8080u16` | Kind at the end: exactly what Joseph's prefix-not-suffix preference ("decide and start parsing things sooner") rules out, and what bounded streaming (B1) penalizes. |

## Lean

`<…>`, with the M1/M2 errors as the guard; the sigil kept on file as the escape hatch if the HTML/autolink collision proves real in use. Taste plus the A8 count; low confidence on how often sameline text starts with `<` (my instinct: rarely in data, occasionally in HTML-derived list items).
