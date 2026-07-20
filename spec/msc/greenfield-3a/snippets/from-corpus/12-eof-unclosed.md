# End of input: positional silence, delimited warnings

## Positional constructs close silently — EOF is newline-equivalent
```udon
|a
  |b
    :k v
    prose tail
```

## Unclosed string: content → warning → (no bracket End of its own)
```udon
|el :name "never closed
```

## Unclosed array closes at the newline (this version)
```udon
|el :ports [8080 8443
  :next 1
```

## Unclosed identity key → $partial-key (fail-safe naming)
```udon
|user[trunc
```

## Nested unclosed delimited constructs: one warning each, innermost first
```udon
|p some |{em text with !{{interp
```

## Unclosed fence: keep everything, warn
