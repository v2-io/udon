# The options under trial

*Four open questions in how UDON Lite values come to mean things. For each, the options are shown on the same content, in no order of preference. In every option a bare value is text, and `nil`, `true`, `false` and ordinary JSON-style numbers also get a standard reading (so `:port 8080` reads as 8080 and `:debug false` as false); the trial isn't about that.*

## Q1. Saying what a value is, on the attribute's name

```udon
; A: a dot and the kind
|sample :mass.kg 3.2 :temp.degC 21.5 :taken.datetime 2026-10-01T14:30Z
|ev :on.date 2026-10-01 :lasts.duration 90min :when.date(YY-MM-DD pivot 1950) 27-03-05

; B: the kind in parentheses, as a column header
|sample :mass(kg) 3.2 :temp(°C) 21.5 :taken(datetime) 2026-10-01T14:30Z
|ev :on(date) 2026-10-01 :lasts(duration) 90min :when(date YY-MM-DD pivot 1950) 27-03-05

; C: nothing on the name; the kind goes on the value when needed (see Q3)
|sample :mass qty(3.2 kg) :temp qty(21.5 °C) :taken datetime(2026-10-01T14:30Z)
|ev :on date(2026-10-01) :lasts duration(90min) :when date("YY-MM-DD pivot 1950" 27-03-05)
```

Notes: in A and B the reading belongs to that one occurrence (`:mass.kg 3 :mass.lb 7` are two masses). In all three, a document with a schema or vocabulary could leave the kinds off entirely (`:mass 3.2`).

## Q2. A quoted value that stands alone

A quoted value counts as a quoted value only if nothing else follows it in that value; otherwise the whole thing is text, quotes included. So `|p "Hello," she said.` is one text with its quote marks. The question is what a quoted value is when it *does* stand alone:

```udon
|p "To be, or not to be."
|el :name "8080"
```

- **A:** a string: `To be, or not to be.` and `8080`, the quotes being delimiters (the fact that it was quoted is kept as metadata).
- **B:** text that keeps its quote marks (`"To be, or not to be."`), also readable as the string inside them.

## Q3. A value that names its own notation

```udon
; A: a name with parentheses (the value must stand alone; otherwise it is text, so `printf(x) prints x` stays text)
|ev :on date(2026-10-01) :lasts duration(3mo 5d) :span interval(date(2026-01) date(2026-06))
|meta :values [date(2026-10-01) qty(3.2 kg) 42 hello]

; B: a sigil: a tilde and a name, then the value
|ev :on ~date 2026-10-01 :lasts ~duration 3mo 5d :span ~interval 2026-01/2026-06
|meta :values [~date 2026-10-01 ~qty 3.2kg 42 hello]

; C: an inline element; no new syntax
|ev :on |{date 2026-10-01} :lasts |{duration 3mo 5d} :span |{interval |{date 2026-01} |{date 2026-06}}
|meta :values [|{date 2026-10-01} |{qty 3.2 kg} 42 hello]
```

Verbatim foreign text, in every option: backticks standing alone, optionally tagged: ``:pattern re`^\d{3}-\d{4}$` :path `C:\Users\me` ``.

## Q4. Attribute names, with or without a trailing colon

```udon
; A: no colon
|server[web] :host localhost :port 8080 :debug false
  :owner nil

; B: an optional colon after the name, ignored by the parser
|server[web] :host: localhost :port: 8080 :debug: false
  :owner: nil
```

In B both spellings are allowed and mean the same thing.

## And anything else

If you'd invent something better than any of these, or something here strikes you as wrong in a way the questions don't capture, that's as welcome as an answer.
