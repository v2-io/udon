# Raw blocks, inline raw, freeform fences — one wire frame

## Block raw directive
```udon
|example
  !:elixir:
    def hello do
      |> not_udon()
    end
```

## Sameline raw body
```udon
!:sh: echo hi
```

## Inline raw: brace-counted, one separator space consumed
```udon
|p The response was !{:json: {"status": "ok"}} as expected.
```

## Freeform fence: exact capture, info string for free

## Fence in sameline scan, after attributes
```udon
|a |b :k v ```
the body
```

## Not fences: after prose, or deeper than the prose base
```udon
|a |b but now ``` is literal
```
