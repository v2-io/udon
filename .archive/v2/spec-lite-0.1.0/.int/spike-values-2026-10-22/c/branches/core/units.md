# D5: units

*Spike c, branch family "core". Joseph: "units (= seem to be a bit of both slot-type & literal-hint & coercion)"; "in notation there are units all the time-- 920px 920MB, etc."*

## Four branches

### U1. A unit is text; the slot gives it meaning. *(survives; my lean)*

`:width 920px` is the text `920px`. A consumer that knows `width` is a CSS length parses it; one that doesn't hands on `"920px"`, which is exactly what JSON, YAML and TOML carry today (in those formats, units in data are strings or live in the name). `:timeout 5m` and `:length 5m` are both the text `5m`; the slots resolve them to 300 seconds and 5 metres.

- **Why it holds up.** Splitting `920` from `px` is the easy part. The meaning of the unit needs a dictionary (which `m`? CSS `px` or print?), and a dictionary is a parameter, so by test 1 (`kinds-and-test.md`) it comes from the slot or a named notation. `5m` is the decisive example: **no literal-side design disambiguates minutes from metres without a dictionary, and the slot disambiguates it for free.** That is the strongest single argument in this territory for slot-first meaning (A5, domain-forward, 9).
- **Costs.** A schema-less consumer sees text. A writer who wants a quantity checked at parse time can't get it in lite 0.1.0.

### U2. A bare number followed by letters is a quantity literal. *(dies)*

`920px` → quantity(920, `px`), decided at the run's end. Tried in earnest, because it is the most domain-forward-looking spelling: the writer writes what the domain writes. It dies on test 3, twice over:

- Ordinary text that spells number-plus-letters: `:rank 1st`, `:model 4K`, `:res 1080p`, `:plan 401k`, `:arch 64bit`, `:at 3am`, `:gauge 9mm`, `:net 5G`, `:pub 3M`. Each becomes a quantity with a nonsense unit. That is the Norway problem with a larger alphabet: the more spellings a classifier claims, the more ordinary text it captures.
- Even when it is right, it delivers little: quantity(5, `m`) still doesn't say minutes or metres, so the consumer needs the slot anyway, and then the slot could have parsed the text itself.

The argument above stands on the examples alone (my own reading of what those spellings mean, scored by A3 and B3). The old line's `30seconds` → Duration `30s` + text `econds` (`.int/old-numeric-typing.md` §5 item 1) illustrates the same failure; it is ideation material, not the ground.

### U3. A quantity inside a mark. *(viable later; not 0.1.0)*

`<920 px>` or `<920px>` → quantity with an uninterpreted unit label. Explicit, so test 3 doesn't apply. But the label is still uninterpreted (`<5m>` is no clearer than `5m`), so its value over U1 is only "this is a number plus a label", checked at parse time. Where it earns its keep is with a **named notation that owns a unit dictionary**: `<si: 5 m>`, `<css: 920px>`, `<dur: 5m>`. That is the mark branch's territory (naming notations), and it composes with U1: a slot that says "duration" and a literal that says `<dur: 5m>` agree, and either alone suffices.

Under the lean's interior rule (primitives only inside `<…>`, anything else an error), `<920px>` is an error, as Joseph said he expects ("<920px> error I can understand"). U3 would later turn some of those errors into values, which is forward-compatible: lite refuses today what a later version defines (B2).

### U4. The unit in the name. *(a writing convention, not syntax)*

`:width-px 920`, `:timeout-s 30`, `:size-gb 1.5`. Every format that has no unit syntax ends up here; the number stays a core number and the unit is in the slot. It needs nothing from lite. Worth a line in the writing advice ([[expl:writing-lite]]): when the domain fixes the unit, name it in the attribute; when it varies per value, write it in the value and let the slot parse it.

## Percent

`50%` is U1 text. Note for the escape and run rules: `%` has no role in lite, so nothing collides. A `<50%>` under the primitives-only interior is an error; whether a named notation ever owns `%` is open.

## Verdict

**Lite 0.1.0 has no unit syntax.** `920px`, `5m`, `50%`, `1.5GB` are texts; units mean something only through a slot (schema, vocabulary, strict getter) or, later, a named notation inside a mark. Reserve nothing new for units: the space they would want (a mark interior) is already refused by the primitives-only interior rule, so headroom (B6) costs nothing here.

| Factor (weight) | U1 | U2 | U3 (later) | Basis, confidence |
|---|---|---|---|---|
| A2 guessability (10) | 8 | 6 | 5 | Agents write `920px` unmarked and expect text-or-unit; U2's ordinals and resolutions break silently. Moderate. |
| A3 cold comprehension (10) | 8 | 4 | 7 | A reader of `:rank 1st` doesn't expect a quantity. Moderate. |
| A5 domain-forward (9) | 9 | 7 | 6 | U1 lets the slot carry meaning; U2 looks domain-forward but can't say which `m`. Moderate-high. |
| A7 simplicity (8) | 10 | 4 | 7 | U1 adds no rule. High. |
| B3 stability (10) | 10 | 5 | 9 | U2's boundary (`30seconds`) is where the old line split values. High. |
| C4 units (8) | 5 | 4 | 8 | U1 delivers units only via slots; U3 with a dictionary delivers them checked. Moderate. |
