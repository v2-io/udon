# Elements, identity, traits, suffixes

## Bare element, no content — pure structure line, no terminator event
```udon
|element-name
```

## Full identity: key, traits, suffix — all desugar to $-attributes
```udon
|el[k].a.b?
```

## Suffix before traits, and the space-separated suffix
```udon
|el?.bar
|el.bar ?
```

## Keys are typed by the normal value rules
```udon
|a[1]
|b["01"]
|c[abc-123]
```

## Anonymous elements
```udon
|[k]
|.some-trait :adapter pg
|?
```

## Quoted names and traits
```udon
|'weird name'.'ns.kind'
```

## Spaced trait is prose (ruled 2026-07-15)
```udon
|p .gitignore is a file
```

## Non-element pipes stay prose (Markdown table safety)
```udon
| a | b |
```
