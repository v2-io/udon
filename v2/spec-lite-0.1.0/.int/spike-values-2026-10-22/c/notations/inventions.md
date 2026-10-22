# Inventions: notation values, made beautiful first

*Spike c, round two, by the spike agent, written after Joseph's note ("not a single mention of "what if we used elixir-like sigils, but made more beautiful?""). Invent first, judge after. Each idea below is rendered on the same five lines, with what I find beautiful in it and why, before any weighing. Some are strange and some are unfinished, and they are kept anyway. The weighing, Beauty first, is at the end.*

## The five lines every invention renders

Intent, in words:

1. An event on **2026-10-01**, at the instant **2026-01-10T14:30Z** held in **America/Denver**, lasting **90 minutes**.
2. A box **920px** wide, **5 metres** tall, **50%** full, at **37.5 °C**, costing **9.99 USD**.
3. A season spanning **2026-01 to 2026-06**; holidays **2026-01-01, 2026-07-04, 2026-12-25**.
4. A pattern `\d+-\w+`; a home page **https://example.com**.
5. Prose: "Meet on **Oct 1st**", where Oct 1st is machine-readable as 2026-10-01.

---

## α. Scheme values: every typed value is a URI

**The idea.** A notation value is `<scheme:body>`, with no space. The **scheme is the notation**. This is exactly the shape CommonMark gives an autolink, `<https://example.com>`, and the shape of every URI: `mailto:`, `tel:`, `geo:37.78,-122.41` (RFC 5870), `urn:isbn:…`, `data:…`. So a URL in angle brackets stops being a collision and becomes the first notation value. `date:`, `qty:` and `re:` are private schemes of the same shape. And in prose, a **Markdown link already pairs display text with a URI**, so `[Oct 1st](date:2026-10-01)` is a typed value in prose that lite passes through untouched and a reader can read.

```udon
|event :on <date:2026-10-01> :at <instant:2026-01-10T14:30Z[America/Denver]> :lasts <qty:90 min>
|box :width <css:920px> :height <qty:5 m> :fill <qty:50 %> :temp <qty:37.5 Cel> :price <money:9.99 USD>
|season :span <interval:2026-01/2026-06> :holidays [<date:2026-01-01> <date:2026-07-04> <date:2026-12-25>]
|ok :pattern <re:\d+-\w+> :home <https://example.com>
|p Meet on [Oct 1st](date:2026-10-01).
```
````tree
  |event  :on (date "2026-10-01")  :at (instant "2026-01-10T14:30Z[America/Denver]")  :lasts (qty "90 min")
  |ok     :pattern (re "\d+-\w+")  :home (https "//example.com")
  |p      :$main ‹Meet on [Oct 1st](date:2026-10-01).›      ← text; a Markdown-aware reader sees a dated link
````

**Beautiful, to me:**
- **It's one idea that three worlds already agree on.** URIs say "scheme, colon, the thing". CommonMark autolinks put that in angle brackets. Markdown links pair human words with it. Lite would join an agreement instead of inventing one. The collision the mark fork found (an autolink silently becoming a notation) turns out not to be a collision: the autolink *was* a value all along.
- **Namespaces are already solved:** private-use schemes in reverse-DNS form (`com.example.sku:AB-12`, the shape RFC 8252 recommends for app schemes, from memory) are globally unique without a registry.
- **The prose case is solved for free:** Markdown's link *is* ruby text for machines.

**Unfinished:**
- A scheme can't hold `/`, so `css/length` becomes `css.length`.
- `<rust:i64:0x73DDF>` is the scheme `rust` with the body `i64:0x73DDF`, which is fine.
- `<qty:90 min>` has a space in its body; a URI wouldn't, but these aren't URIs, only URI-shaped.
- An HTML tag (`<kbd>`) has no colon, so it is still an error that says what to do.

## β. The sigil, made beautiful: constructor values

**Start from Elixir's `~D[2026-10-01]`.** What makes it ugly is a tilde, a lone capital and a bracket chosen for the parser's convenience; what makes it right is a name plus a body read by that name. **The most beautiful widely-known form of "name, then its body" is the constructor or function call, as CSS does it:** `url(…)`, `rgb(1 2 3)`, `rotate(45deg)`, `calc(100% - 2em)`. CSS is the most successful notation there is for typed values with units, and agents write it without thinking.

```udon
|event :on date(2026-10-01) :at instant(2026-01-10T14:30Z[America/Denver]) :lasts duration(90 min)
|box :width 920px :height qty(5 m) :fill 50% :temp qty(37.5 °C) :price money(9.99 USD)
|season :span interval(2026-01 – 2026-06) :holidays dates(2026-01-01 2026-07-04 2026-12-25)
|ok :pattern re(\d+-\w+) :home url(https://example.com)
|p Meet on |{time Oct 1st :datetime date(2026-10-01)}.
```

The rule: **a value that begins with a label immediately followed by `(` is a constructor value**, and the body runs to the matching `)`. The kind is known at the `(`, after a label's length.

**Two variants, because the ASCII one has a real cost:**
- **β-ascii** `date(…)`: guessable at once (A2). It collides with code in sameline text: `|li printf(x) prints x` becomes a constructor `printf`, silently.
- **β-white** `date⦅2026-10-01⦆`, with U+2985/2986 WHITE PARENTHESIS: the same shape, in a bracket that never appears in prose or code, so nothing collides. Joseph has taken typing cost off the table ("I wouldn't be afraid to use unicode characters that are difficult to type"). It reads as "date of 2026-10-01", the double stroke marking "this is a reading, not a call".

**Beautiful, to me:** it reads as what it is, *date of …*, and it nests the way people already nest functions (`interval(date(2026-01) date(2026-06))`). `dates(…)`, a plural constructor for a list of one notation, is a small delight.

## γ. Typeset values: the shape names the kind

**Make the inside of the mark look like a typeset spec sheet**, following SI and typographic conventions that agents have read a million times:
- a number, a space, a unit (`5 m`, `90 min`);
- symbol units glued on (`50 %`, `37.5 °C`, `45°`);
- currency the way it's printed (`9.99 USD`, `$9.99`);
- the en dash for ranges (`2026-01 – 2026-06`);
- superscripts in units (`9.81 m/s²`);
- ISO 8601 dates as they are.

The interior's *shape* says its kind, so most values need no name at all. That is the `std` design, beautified.

```udon
|event :on <2026-10-01> :at <2026-01-10T14:30Z[America/Denver]> :lasts <90 min>
|box :width <920 px> :height <5 m> :fill <50 %> :temp <37.5 °C> :price <9.99 USD>
|season :span <2026-01 – 2026-06> :holidays [<2026-01-01> <2026-07-04> <2026-12-25>]
|ok :pattern <re: \d+-\w+> :home <https://example.com>
|p Meet on Oct 1st.        ← γ has nothing to say in prose; see ζ
```

**And a bolder step: symbol units bare.** Letter units collide with words (`1st`, `4K`, `401k`), but symbols don't. `50%`, `37.5°C`, `45°`, `$9.99`, `€12`, `3′ 4″` could be classified bare, safely, because no word is spelled that way. A run that is a number glued to a unit *symbol* is a quantity.

**Beautiful, to me:** the document reads like the domain's printed page. Nothing is plumbing; the value is the plumbing. The en-dash range, unlike `..`, `/` or `to`, is how a typesetter would write it. The split between letters and symbols is a real principle and not a list: **symbols are unambiguous in a way letters can never be.**

## δ. Bra-ket: ⟨reader|spelling⟩

**Joseph twice reached for a pipe**: `<u64i|0xf902>` (2026-07-11) and `<uint32|0x992BC>` (2026-10-21). In Dirac's notation, ⟨a|b⟩ pairs a functional with a vector, so the left side is applied to the right. That is *exactly* the reader model: a notation (the bra) applied to a spelling (the ket) gives a value. Spelled with the mathematical angle brackets U+27E8/27E9, it never touches HTML's `<` at all:

```udon
|event :on ⟨date|2026-10-01⟩ :at ⟨instant|2026-01-10T14:30Z[America/Denver]⟩ :lasts ⟨90 min⟩
|box :width ⟨css|920px⟩ :height ⟨5 m⟩ :fill ⟨50 %⟩ :temp ⟨37.5 °C⟩ :price ⟨9.99 USD⟩
|season :span ⟨2026-01 – 2026-06⟩ :holidays ⟨date| 2026-01-01 2026-07-04 2026-12-25⟩
|ok :pattern ⟨re|\d+-\w+⟩ :home ⟨https://example.com⟩
|p Meet on |{time Oct 1st :at ⟨2026-10-01⟩}.
```

- **The bra is optional.** `⟨2026-10-01⟩` is read by shape (γ inside). `⟨date|…⟩` names the reader.
- **A bra followed by several kets reads each one:** `⟨date| a b c⟩` is three dates. That is the clef (ε), with no new rule.
- **ASCII `<` goes back to HTML and Markdown entirely:** `|li <kbd>Ctrl</kbd>` and `|li <https://…>` are just text again. That removes the escaping lite needs today.

**Beautiful, to me:** the bracket says *value* and the bar says *read as*. It's a pun that happens to be true. The page looks mathematical in a calm way.

**Unfinished:**
- `⟨` and `<` are close at a glance for people (A11, weight 5; for agents they are different code points, A4).
- A union inside a bra (`⟨u16|ssh-ports|…⟩`) is ambiguous; unions belong in vocabularies anyway.

## ε. Clef: declare the reading once, then just write

**From music:** a clef at the start of a staff says how every following note is read, until another clef appears. Notation values have the same need: a list of dates, an attribute body of dates, a table column of prices. Per-value names are noise there. So:

```udon
|season :holidays [<date> 2026-01-01 2026-07-04 2026-12-25]
|prices :each <money>
  9.99 USD
  12.50 USD
|event :on <date> 2026-10-01   ; a clef before a single value: type ascription
```

**The rule:** a bodiless notation (`<date>`, `<money>`) is never a value. It is a **clef** for the values after it in the same list, the same body, or the same slot. Today `<date>` alone is the mark fork's error "a notation name with no body". The clef gives that shape a meaning instead.

**Beautiful, to me:** it is the single most domain-forward move here (A5). The values stay in their own spelling, unmarked, and one quiet sign at the front tells you how to read them. It also covers the slot fork's one real gap, a list that needs its kind stated in place.

## ζ. Ruby: the words and the value, together

**From East Asian typography** (ruby text set beside base text) and HTML's `<time datetime="2026-10-01">Oct 1st</time>`: in prose a value often has *two* spellings, one for people and one for machines. The pairing is the value.

- Under α it's free: `[Oct 1st](date:2026-10-01)`.
- Under δ: `⟨date|2026-10-01 ‹Oct 1st›⟩`? I'm not sure.
- As an element: `|{time Oct 1st :at <2026-10-01>}`.

I think α's Markdown-link form is the most beautiful of these, because it is already how people write a linked phrase.

## η. Pictographs (strange; kept for honesty)

`⟨📅 2026-10-01⟩`, `⟨⏱ 90 min⟩`, `⟨💲 9.99⟩`. Single-glyph notation names that read at a glance. **Not beautiful to me:** emoji meaning drifts across platforms and contexts, and it reads as decoration more than notation. It dies on my own A1, and I say so plainly rather than weighing it.

---

## Weighing: Beauty first

*My scores, as one agent's judgment. Under Beauty, A1 is my own sense of it, with reasons; A2/A3 are the contributors CTQ names. Then the factors where these differ most.*

| | A1 beauty (9) | A2 guess (10) | A3 cold (10) | A5 domain (9) | A8 parsimony (8) | C2/C3 HTML+MD (10/9) | B1/B2 vetoes | One line on why |
|---|---|---|---|---|---|---|---|---|
| **α scheme values** | 9 | 8 | 8 | 7 | 9 | 9 | pass / pass (with "read above the tree") | one shape that URIs, autolinks and Markdown links already share |
| **β-ascii constructors** | 7 | 9 | 9 | 7 | 8 | 5 | pass (label holdback) / pass | instantly written; collides with code in text |
| **β-white constructors** | 7 | 6 | 7 | 7 | 7 | 9 | pass / pass | the same shape, collision-free; an odd glyph |
| **γ typeset interiors** | 9 | 8 | 9 | 9 | 8 | 7 | pass / pass (closed set, grows into errors) | the page reads like the domain's printed page |
| **γ+ symbol units bare** | 8 | 8 | 8 | 10 | 9 | 8 | pass / pass | a principle, symbols vs letters, not a list |
| **δ bra-ket** | 8 | 5 | 6 | 8 | 7 | 10 | pass / pass | true and calm; frees `<`; few will guess it |
| **ε clef** | 9 | 7 | 8 | 10 | 9 | 9 | pass / pass | declare once, then just write |
| **ζ ruby via Markdown link** | 8 | 8 | 8 | 8 | 10 | 10 | pass / pass | already how people write |
| η pictographs | 3 | 4 | 4 | 6 | 5 | 8 | pass / pass | decoration, not notation |

**What I'd build from these, as one design (taste, then reasons):** **γ + α + ε**, with δ's Unicode bracket kept as the alternative if `<` turns out too contested.

- **Inside `<…>`:** the shape names the kind for the standard set (γ: dates, times, quantities with SI spacing and symbol units, money, en-dash ranges, primitives). Anything else is `scheme:body` (α), which makes autolinks and URIs values and gives every other notation a URI-shaped name.
- **A bodiless `<name>` is a clef** (ε) for a list, a body or the value after it.
- **In prose,** a Markdown link with a notation URI carries a typed value (ζ via α).
- **Symbol units bare** (γ+), as a standard reading rather than grammar, if Joseph wants the boldest version.

I find it beautiful because every piece is borrowed from somewhere people already read fluently: typography, URIs, Markdown, music. They fit together without a new concept for a writer to learn, except that `<…>` means *a value, read for what it is*.
