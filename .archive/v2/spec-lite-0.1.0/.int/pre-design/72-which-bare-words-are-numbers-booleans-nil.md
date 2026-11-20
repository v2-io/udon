# 72 — Which unquoted words become numbers, booleans, or nil — and exactly which spellings

## The question

`:port 8080` — is `8080` the number 8080 or the text "8080"? If lite types bare words at all, which spellings count, and what happens at the edges (`5.`, `.5`, `0755`, `1__0`, `TRUE`, `yes`)?

## Why lite must decide

Lite is meant to stand in for JSON and YAML, which type values, and for XML/HTML, whose attribute values are all text. A lite parser in Python, Rust or Ruby has to produce the same typed value for the same bytes, and the contract says a lite document can never change meaning later — so every spelling on the edge has to be either typed, text, or refused, in lite, now.

## What the texts say

- **2011** (`~/src/_older/udon/examples/overview.udon`, planning list): considered URLs, null/nil, ints in four bases, floats, "infinity/neg-infinity/NaN (?)", "boolean (true,t,y,Yes,on,FALSE,...)", dates, times, intervals. `udon/.attic/syntax2.udon` also listed "color" and "number with unit (e.g., 18px)".
- **Dec 2025, 0.7-draft** (`_archive/SPEC.md` §Value Types): "syntactic typing — the syntax determines the type, not value sniffing"; integers incl. `0x` `0o` `0b` `0d`, `_` separators; floats; rational `1/3r`; complex `3+4i`; lowercase `true`/`false` only; nil spelled `null`, `nil`, or `~`; "Plain `0755` is decimal `755` (leading zeros stripped, no implicit octal)."
- **2026-01-01, Joseph** (memorata, libudon session `31853cab…jsonl:8447`): chose to remove `~` as a nil spelling rather than fix the parser ("#2").
- **Jul 2026, 0.8.0-alpha.1** (CHANGELOG): "bare recognition frozen to integer + float only"; all dates/times need the `<…>` box; a bare `2026-07-11` is a string.
- **L5 / R21** (`v2/DECISIONS.md`): rational and complex are not bare; `1/3r` is ordinary text.
- **2026-07-15 ruling** (CHANGELOG 0.9.0-alpha.1): "no keyword carve-out (`:alpha true story` → `"true story"`)" — a keyword is typed only when it stands alone.
- **0.10.0 §11** (`v2/spec-0.10.00/CORE.md`): the "bare scalar set is closed forever: string, integer, float, boolean, nil, list"; `TRUE`, `True` are strings; `null` ≡ `nil`; floats need a fractional part (`.` + digits) or an exponent; "a committed token that goes wrong mid-way (`12ab`) falls through … to an ordinary text token."
- **S17** (DECISIONS): float equality is a host matter, not core law.
- **2026-07-14 comparison against Ruby literals** (memorata, udon session `da5d1672…jsonl:4595`): the parser accepts trailing-dot floats `5.`; both reject `.5`; "underscore placement is unenforced in UDON" (Ruby rejects `_1`, `1_`, `1__0`, `0x_FF`, `1_.5`, `1e_5`).
- **0.10.1 audit, gap D12** (`spec-0.10.01/working-notes/AUDIT-2026-09-01.md`): the text doesn't settle `1_000.5`, `.5`, `1.`, `1e5` vs `1E5`, `0x` alone, `1__0`.
- **Old parser (evidence only):** `5.` → Float; `.5` → text; `1__0` → Integer; `0755` → Integer; `-0` → Integer; `+5` → Integer.
- **XML use:** `bin/xml2udon` writes XML attribute values unquoted unless they contain spaces or marker characters, so `width="100"` becomes `:width 100` — an integer in UDON, a string in the XML it came from.
- **Keys are typed too** (`design/examples/practices-gotchas.udon` "ids-are-typed"): `|step[1]` is integer 1, `|step["01"]` is the string "01".

## Alternatives

### A — the 0.10.0 set: string, integer, float, boolean, nil, list

```udon
|cfg :port 8080 :ratio 0.75 :debug false :owner nil :tags [a 2 true] :v 1.2.3 :zip 02134
```
```text
document
└ element cfg
    port  8080
    ratio 0.75
    debug false
    owner nil
    tags  ["a" 2 true]
    v     "1.2.3"
    zip   2134              ; leading zero is decimal — or should it be text?
```

### B — no typing in lite: every unquoted value is text; types come later

```text
document
└ element cfg
    port  "8080"
    ratio "0.75"
    debug "false"
    owner "nil"
    tags  ["a" "2" "true"]
    v     "1.2.3"
    zip   "02134"
```

Forward-contract note: if the full language types `8080`, a lite tree of `"8080"` would change meaning later. B is only contract-safe if lite **refuses** (or marks as reserved) bare words that the full language would type, which is close to C.

### C — lite types a small, strictly-spelled set and refuses the doubtful edges

For example: decimal integers and simple decimals are typed; `true`/`false`/`nil`/`null` are typed; hex, octal, binary, `_`, exponents, `5.`, `+5`, leading zeros are **reserved** (error, bytes kept) until the full language settles them.

```udon
|el :a 0x1F :b 1_000 :c 02134 :d 5.
```
```text
document
└ element el
    a reserved "0x1F"
    b reserved "1_000"
    c reserved "02134"
    d reserved "5."            ; anomaly: error ×4, not-in-lite spelling
```

### D — A, plus the edges each pinned now (one lite answer for every spelling)

A table like the one below, each row filled in as typed / text / refused:

| Spelling | 0.10.0 text | Old parser | Needs a lite answer |
|---|---|---|---|
| `5.` | not a float (needs digits after `.`) → text | Float | yes |
| `.5` | text | text | yes |
| `+5`, `-0` | integer | integer | sign rules |
| `0755` | decimal 755 | integer | or text (ZIP codes) |
| `1__0`, `_1`, `1_` | unstated | integer | yes |
| `1e5`, `1E5`, `1.5e-3` | float | — | case |
| `0x`, `0xg` | unstated | — | yes |
| `inf`, `NaN` | text | — | yes |
| `TRUE`, `yes`, `on` | text | — | settled as text |
| `true story` | text (keyword not alone) | — | settled |
| `12ab` | text | — | settled |
| huge integers | unstated | — | size limit or bignum |

## Where typing happens

Separately from which spellings count, lite must say **where** bare words are typed: attribute values, list items, `[key]` interiors, the first line under an open attribute ([74](74-attribute-values-on-following-lines.md)), the element's own line ([73](73-is-the-element-line-a-typed-value.md)). Text lines are never typed in any version seen.

## Interactions

- [07](07-untyped-angle-box.md): the `<…>` box is where every other type lives; it only works as a "future home" if bare typing never grows.
- [77](77-identity-keys-and-traits.md): typed keys (`[1]` vs `["01"]`).
- [86](86-mapping-to-json-xml-yaml.md): XML attributes are all strings; JSON distinguishes `1` from `"1"`.
- [79](79-line-endings-encoding-and-columns.md): a Windows line ending turns `true` into `"true\r"` in the old parser.
