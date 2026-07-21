# Raw blocks, inline raw, freeform fences — one wire frame

## Block raw directive

```udon
|example
  !:elixir:
    def hello do
      |> not_udon()
    end
```

```events
ElementStart example
  VerbatimStart block "elixir"
    Text "def hello do\n"        ; raw base = first content line's column
    Text "  |> not_udon()\n"     ; deeper indent kept as content
    Text "end\n"
  VerbatimEnd
ElementEnd
```

## Sameline raw body

```udon
!:sh: echo hi
```

```events
VerbatimStart block "sh"
  Text "echo hi\n"
VerbatimEnd
```

## Inline raw: brace-counted, one separator space consumed

```udon
|p The response was !{:json: {"status": "ok"}} as expected.
```

```events
ElementStart p
  Text "The response was "
  VerbatimStart inline "json"
    Text "{\"status\": \"ok\"}"
  VerbatimEnd
  Text " as expected.\n"
ElementEnd
```

## Freeform fence: exact capture, info string for free

````udon
|code
  ```rust ignore
  fn main() {
      indented_exactly();
  }

  ```
````

```events
ElementStart code
  VerbatimStart fence "rust ignore"
    Text "  fn main() {\n"       ; exact mode: NO dedent — full leading
    Text "      indented_exactly();\n"   ;   whitespace is body content
    Text "  }\n"
    Text "\n"                    ; blank body line is content, not BlankLine
  VerbatimEnd
ElementEnd
```

*(Freeform is the exact mode: byte-for-byte body, so unlike `!:lang:` there is
no base-column strip and blank lines are `Text "\n"`, not `BlankLine`.
Concatenating the Texts reproduces the body exactly.)*

## Fence in sameline scan, after attributes

```udon
|a |b :k v ```
the body
```
```

```events
ElementStart a
  ElementStart b
    AttrStart k
      Scalar Str "v"
    AttrEnd
    VerbatimStart fence ""
      Text "the body\n"
    VerbatimEnd
  ElementEnd
ElementEnd
```

## Not fences: after prose, or deeper than the prose base

```udon
|a |b but now ``` is literal
```

```events
ElementStart a
  ElementStart b
    Text "but now ``` is literal\n"
  ElementEnd
ElementEnd
```
