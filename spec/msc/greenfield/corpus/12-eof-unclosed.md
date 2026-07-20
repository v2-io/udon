# End of input: positional silence, delimited warnings

## Positional constructs close silently — EOF is newline-equivalent

```udon
|a
  |b
    :k v
    prose tail
```

*(no trailing newline in the source)*

```events
ElementStart a
  ElementStart b
    AttrStart k
      Scalar Str "v"
    AttrEnd
    Text "prose tail"      ; no terminator — none existed; nothing synthesized
  ElementEnd
ElementEnd
```

## Unclosed string: content → warning → (no bracket End of its own)

```udon
|el :name "never closed
```

```events
ElementStart el
  AttrStart name
    Scalar Str "never closed"
    Warning UnclosedStringValue
  AttrEnd
ElementEnd
```

*(Emission order per CORE: content first, then the `Unclosed*`, then any
bracket End. A string has no Start/End frame of its own, so the warning rides
between the scalar and `AttrEnd`. Line-boundedness: whether the newline or EOF
closed it is deliberately version-varying; the warning cites the opener.)*

## Unclosed array closes at the newline (this version)

```udon
|el :ports [8080 8443
  :next 1
```

```events
ElementStart el
  AttrStart ports
    ArrayStart
      Scalar Int "8080"
      Scalar Int "8443"
      Warning UnclosedArray
    ArrayEnd
  AttrEnd
  AttrStart next
    Scalar Int "1"
  AttrEnd
ElementEnd
```

## Unclosed identity key → $partial-key (fail-safe naming)

```udon
|user[trunc
```

```events
ElementStart user
  AttrStart $partial-key
    Scalar Str "trunc"
    Warning UnclosedIdentityKey
  AttrEnd
ElementEnd
```

*(The `AttrStart` name is decided by the close — this is the one place the
bracket wire holds an emission; see EVENTS.md.)*

## Nested unclosed delimited constructs: one warning each, innermost first

```udon
|p some |{em text with !{{interp
```

```events
ElementStart p
  Text "some "
  ElementStart em inline
    Text "text with "
    Interpolation "interp"
    Warning UnclosedInterpolation
    Warning UnclosedEmbedded
  ElementEnd
ElementEnd
```

*(Each answers against its own entry site; the unwind is innermost-first, so
the interpolation's warning precedes the embed's, and both precede the embed's
`ElementEnd`. Document-level: two delimited constructs open at true EOF ⇒ the
consuming layer reports the incomplete-input result — a result, not an event.)*

## Unclosed fence: keep everything, warn

````udon
|code
  ```
  body line
````

```events
ElementStart code
  VerbatimStart fence ""
    Text "body line\n"
    Warning UnclosedFreeform
  VerbatimEnd
ElementEnd
```
