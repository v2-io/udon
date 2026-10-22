# M2 — M1, plus named notation literals `<name:body>`

*Sub-branch of the mark family. Alive, on one condition (below).*

## The rule, as it would be carded

1. Everything in M1 holds for an interior with no name: it is one portable primitive, or an error.
2. An interior that begins with a «label» immediately followed by `:` is a **notation literal**. The label is the **notation name**; the rest of the interior, up to the matching `>`, is its **body**, carried raw (escapes and matched pairs as [[rule:opaque-span-raw-text]] has them today). The name is split at the **first** `:`, so `<rust:i64:0x73DDF>` is the notation `rust` with the body `i64:0x73DDF`; what a notation does with its own colons is its business.
3. Lite attaches no meaning to a notation literal. The tree holds `lit(name, body)`, with the form `angle`.
4. **The condition.** In every UDON, a notation is read *above* the tree: a dialect turns `lit(date, "2026-01-10")` into a date at the logical layer and never changes the raw tree. Because a reader above the tree can't add nodes, the structural interiors (`<{…}>` first, and any interior starting with `(`, `[`, `<`, `|`, `@` or `!`) stay reserved.

Without the condition, M2 fails the B2 veto: a later UDON that parsed `<date:…>` differently in its raw tree would change what lite documents parse to. With it, M2 passes, and the condition is a design commitment for all of UDON, not a lite detail.

## What it asserts

"This value is written in notation *name*; read it with that notation." Lite doesn't check the body, so the assertion is passed along, not verified. Joseph's distinction "this is what my literal represents" is exactly this. "What the slot is" sits elsewhere (M3, or an external schema).

## Composite set: only the rows that differ from M1

```udon
|t :when <date:2026-01-10> :at <instant:2026-01-10T14:30Z> :timeout <duration:30s>
  :span <duration:P1Y2M>
  :born <date(YY-MM-DD):27-03-05>
|u :width <css:920px> :timeout <duration:5m> :length <length:5m> :share <percent:50>
  :size <bytes:1.5GB>
|x :addr <rust:i64: 0x73DDF>
|li <https://example.com>
```
````tree
root
  |t  :when lit(date, "2026-01-10")   :at lit(instant, "2026-01-10T14:30Z")   :timeout lit(duration, "30s")
      :span lit(duration, "P1Y2M")
      :born → error: `date(YY-MM-DD)` is not a label (see "Parameters")
  |u  :width lit(css, "920px")   :timeout lit(duration, "5m")   :length lit(length, "5m")
      :share lit(percent, "50")   :size lit(bytes, "1.5GB")
  |x  :addr lit(rust, "i64: 0x73DDF")
  |li :$main lit(https, "//example.com")     ← silent: a Markdown autolink became a notation literal
````

| Item | Verdict |
|---|---|
| E6 | renders, with one name per value. The name is domain vocabulary (`date`, `duration`), which is the better kind of plumbing (A5). `5m` minutes and `5m` metres are now told apart, by the notation. |
| E6 `27-03-05` as YY-MM-DD | **can't render without a parameter syntax.** Options: a body convention the `date` notation owns (`<date:YY-MM-DD 27-03-05>`, my lean, since parameters are the notation's business and lite then needs nothing new), or a label that admits parentheses (new label syntax; no). Joseph's `:when:dt(YY-MM-DD)<27-03-05>` put the parameter on the slot; see M3. |
| E7 | renders; whether units live in the notation (`<length:5m>`) or as their own literal (`<5 m>`) is the core fork's D5. |
| E9 | renders; Joseph's naive model `<rust:i64: 0x73DDF>` is expressible. I'd score it low on A5 (plumbing between domain and machine, exactly what A5 says shouldn't show) and leave it possible rather than encouraged. |
| E10 | **silent near-miss**: `|li <https://example.com>` is the notation `https` with the body `//example.com`. The tree keeps the spelling, so Markdown re-emission can recover it. But a consumer reading `$main` as text gets a literal instead, and nothing warns. Fix options: a default-on warning "a notation literal whose body starts with `//` looks like a URL; did you mean the text `\<https://…>`?" (specific, cheap), or accept it (a URL *is* a notation; REBOL types `http://…` as `url!`, *checked*: REBOL Core ch. 16). I lean to the warning. |

## Separator: why `:` and not a space or a pipe

- **Space** (`<dt 2026-01-10>`, Joseph's 2026-07-22 form). *Dead.* With unlabeled interiors held to primitives, a space after a word would have to mean "name follows", so `<true story>` would read as the notation `true` with the body `story`. Keywords and names would collide in the most common spellings.
- **Pipe** (`<u32|0xff>`, Joseph 2026-07-11 and 2026-10-21). *Dead against the colon, not on its own.* It dodges the URL collision (`<https://…>` has no `|`), which is its one real advantage. But Joseph's own algebraic-name example uses `|` for a union ("u16 | standard-ports"), and `<u16|8080>` then reads as "u16 or 8080" (instinct; a cold reader's A3 cost). It also puts lite's element marker inside a value, where it means something else.
- **Colon** (`<dt:…>`, `<namespaced/type: val>`, `<rust:i64: …>`, the forms Joseph has written most). URI schemes (`data:`, `mailto:`) and XML's `ns:name` are the priors an agent brings, and both read "prefix: what kind; rest: the thing" (instinct, A2/A3). Its cost is the URL collision above, which a warning can address.

## Parameters and units: what M2 leaves to the notation

Lite splits off exactly one label. Parameters (`YY-MM-DD`), units and sub-types live in the body and belong to the notation, so lite never grows a parameter syntax. Taste: this is the parsimony move (A8). The cost is that every notation invents its own parameter convention. That cost belongs to full UDON's dialect design, and lite inherits none of it.

## Joseph's future forms

- `<{…}>`, "embedded value": reserved. Under the condition it can't be a notation: it carries structure.
- `@<…>`, "reference to a value" (already reserved in [[rule:reserved-spellings]]): *guess, for him to judge.* If `<…>` means "a literal, not to be interpreted as UDON", then `@<x>` reads naturally as a reference **kept as a literal**, never resolved. That is his Lisp-quote distinction ("quoted vs unquoted"), with `<…>` as the quote. It would also give "reference kept as a reference, not resolved in place", which he called "already a little unprincipled" when spelled `@{<…>}`, one principled home: `@{x}` resolves, `@<x>` is kept. One rule, not two.

## Implications

Everything in M1's list, plus: [[def:typed-value]]'s «type-label» comes back as «notation-name»; [[rule:opaque-span-raw-text]] keeps `<…>` for the body only; [[rule:reserved-spellings]] lists the structural interiors; a new card states the above-the-tree law, or it goes in [[decision:forward-compat-aspiration]].

## Scores and basis (hypotheses)

- **A2 7, A3 8.** Instinct: `<date:2026-01-10>` is what I'd write if told "dates go in angle brackets with their kind first", and I'd read it correctly cold.
- **A5 6.** The names are domain words, but each value still carries one.
- **B6 7.** It spends the `<label:` shape. That is the shape full UDON was going to want for dialects anyway, so the cost is a commitment, not a loss.
- **C2/C3 6.** The silent autolink, if not warned.
- **C4 8, C6 8.** Every notation in the composite set renders except the parameterized date, which renders once a body convention is chosen.

Confidence: low to medium.
