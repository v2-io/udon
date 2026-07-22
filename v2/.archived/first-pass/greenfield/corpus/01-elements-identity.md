# Elements, identity, traits, suffixes

Notation: indentation in `events` blocks is presentational (frame depth). `Scalar` payloads are `kind "source-text"`. Terminators appear as `\n` only where the reconstruction contract makes them text.

## Bare element, no content — pure structure line, no terminator event

```udon
|element-name
```

```events
ElementStart element-name
ElementEnd
```

## Full identity: key, traits, suffix — all desugar to $-attributes

```udon
|el[k].a.b?
```

```events
ElementStart el
  AttrStart $key
    Scalar Str "k"
  AttrEnd
  AttrStart $traits
    Scalar Str "a"
  AttrEnd
  AttrStart $traits
    Scalar Str "b?"      ; suffix chars are trait chars — "b?" is the trait
  AttrEnd
ElementEnd
```

*(Per CORE "Suffix characters inside a trait are part of the trait": `.b?` is trait `b?`, not trait `b` + suffix. Compare next case.)*

## Suffix before traits, and the space-separated suffix

```udon
|el?.bar
|el.bar ?
```

```events
ElementStart el
  AttrStart $?
    Scalar Bool "true"
  AttrEnd
  AttrStart $traits
    Scalar Str "bar"
  AttrEnd
ElementEnd
ElementStart el
  AttrStart $traits
    Scalar Str "bar"
  AttrEnd
  AttrStart $?
    Scalar Bool "true"
  AttrEnd
ElementEnd
```

## Keys are typed by the normal value rules

```udon
|a[1]
|b["01"]
|c[abc-123]
```

```events
ElementStart a
  AttrStart $key
    Scalar Int "1"
  AttrEnd
ElementEnd
ElementStart b
  AttrStart $key
    Scalar Str "01"
  AttrEnd
ElementEnd
ElementStart c
  AttrStart $key
    Scalar Str "abc-123"
  AttrEnd
ElementEnd
```

## Anonymous elements

```udon
|[k]
|.some-trait :adapter pg
|?
```

```events
ElementStart (anonymous)
  AttrStart $key
    Scalar Str "k"
  AttrEnd
ElementEnd
ElementStart (anonymous)
  AttrStart $traits
    Scalar Str "some-trait"
  AttrEnd
  AttrStart adapter
    Scalar Str "pg"
  AttrEnd
ElementEnd
ElementStart (anonymous)
  AttrStart $?
    Scalar Bool "true"
  AttrEnd
ElementEnd
```

## Quoted names and traits

```udon
|'weird name'.'ns.kind'
```

```events
ElementStart weird name
  AttrStart $traits
    Scalar Str "ns.kind"
  AttrEnd
ElementEnd
```

## Spaced trait is prose (ruled 2026-07-15)

```udon
|p .gitignore is a file
```

```events
ElementStart p
  Text ".gitignore is a file\n"
ElementEnd
```

## Non-element pipes stay prose (Markdown table safety)

```udon
| a | b |
```

```events
Text "| a | b |\n"
```

*(Root-level prose; `| ` pipe-space is always literal.)*
