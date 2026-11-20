# D7 — the trailing colon on attribute names

*Joseph, 2026-10-22: "I would like the ornamental trailing ':' on attribute names, or even making it compulsary, a light lean right now, pending a separate discussion on types and the type system." The type discussion is this spike, so here is what it gives.*

## The conflict nobody has put to him yet (*checked*)

The labels lean (`.int/labels-ascii-and-positions-2026-10-20.md`) allows `:` in a bare label **inner and last**, for `xml:lang`, `svg:rect`, `xlink:href`. Under that lean `:host:` is the attribute named `host:`, not `host` with an ornament. His ornament needs "last" dropped from `:`'s positions. Nothing XML needs a trailing colon, so dropping it costs nothing (instinct; I know of no XML/HTML name ending in `:`; XML's namespace grammar forbids it, since a QName is `Prefix ':' LocalPart` with both parts non-empty, from memory of Namespaces in XML 1.0).

## Options

| | Option | Status | Why |
|---|---|---|---|
| T1 | **Ornament:** `:host: localhost` = `:host localhost`; a bare label can't end in `:` | alive, his lean | Elixir/Ruby-keyword readability (his taste, A1). Costs two spellings of one thing (A7) and a look closer to YAML that invites the colon-*less* `host: localhost`, which [[rule:main-label-colon-warns]] already catches. |
| T2 | **Compulsory** on every attribute name | **dead** | Charges every attribute in every document one character (A9) and doubles the punctuation (`:a: 1 :b: 2`) to buy nothing the types need. As a separator for a type slot it's T3. |
| T3 | **Type slot after the colon:** `:when:dt 2026-01-10`, `:port:u16 8080` | **dead** | Collides with the namespaced names the labels lean admits: `:xml:lang en` would read as attribute `xml` with type `lang`. Rescuing it means quoting every namespaced XML/SVG attribute (`:'xml:lang' en`), a tax on C2 (weight 10) for a job M3 does with a character that's free (`.` or `<`). Tried; the reason it can't be clean is the finding. |
| T4 | **Reserve:** a bare attribute name may not end in `:`; `:host: localhost` is an error, "did you mean `:host localhost`?" | **alive, my lean for 0.1.0** | Keeps T1 available as a widening (error → accepted, no tree changes), keeps `xml:lang` intact, and spends nothing. |

## Composite E12

```udon
|server :host: localhost :port: 8080
|html :xml:lang en
|svg :xlink:href #a
```

- T4: line 1 is an error at `:host:` with the suggestion; lines 2–3 give `xml:lang ‹en›`, `xlink:href ‹#a›`.
- T1: line 1 gives `host ‹localhost›`, `port ‹8080›` (a text under the bare-run lean); lines 2–3 as T4.
- T3: line 2 gives `xml{lang} ‹en›`, a silent miss.

## Scores (hypotheses)

T1 vs T4 differ on A1 (his taste for T1; mine is neutral), A7 (T4 9, T1 7: two spellings), B4/B6 (T4 keeps the door open). No CTQ factor makes T1 *wrong*; the reason to start at T4 is that the order is one-way: T4 → T1 is free later, T1 → T4 breaks documents.
