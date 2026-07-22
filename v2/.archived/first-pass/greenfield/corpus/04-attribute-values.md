# Value kinds: scalars, arrays, envelopes, references, interpolation

## The scalar zoo

```udon
|el :i 42 :h 0xFF :f 1.5e-3 :s "quoted" :s2 'single' :n null :b false
```

```events
ElementStart el
  AttrStart i
    Scalar Int "42"
  AttrEnd
  AttrStart h
    Scalar Int "0xFF"      ; source form preserved; projection is the host's
  AttrEnd
  AttrStart f
    Scalar Float "1.5e-3"
  AttrEnd
  AttrStart s
    Scalar Str "quoted"
  AttrEnd
  AttrStart s2
    Scalar Str "single"
  AttrEnd
  AttrStart n
    Scalar Null "null"
  AttrEnd
  AttrStart b
    Scalar Bool "false"
  AttrEnd
ElementEnd
```

## Arrays: items typed independently, full value rules

```udon
|server :ports [8080 8443] :mixed [1 two "three three" [4] @[k] !{{x}}]
```

```events
ElementStart server
  AttrStart ports
    ArrayStart
      Scalar Int "8080"
      Scalar Int "8443"
    ArrayEnd
  AttrEnd
  AttrStart mixed
    ArrayStart
      Scalar Int "1"
      Scalar Str "two"
      Scalar Str "three three"
      ArrayStart
        Scalar Int "4"
      ArrayEnd
      Reference key="k"
      Interpolation "x"
    ArrayEnd
  AttrEnd
ElementEnd
```

## Quoted-item nuance: the closing quote ends the item

```udon
|el :x ["a"b]
```

```events
ElementStart el
  AttrStart x
    ArrayStart
      Scalar Str "a"
      Scalar Str "b"
    ArrayEnd
  AttrEnd
ElementEnd
```

## The typing envelope (greenfield wire; see EVENTS.md for the interim form)

```udon
|el :when <2026-07-11> :size <u64:0xf902>
```

```events
ElementStart el
  AttrStart when
    Envelope "2026-07-11"
  AttrEnd
  AttrStart size
    Envelope "u64:0xf902"
  AttrEnd
ElementEnd
```

*(Interim ratified alternative: `Warning NoDialectsLoaded` + `Scalar Str "<2026-07-11>"` per envelope. Envelopes are multi-line: a newline inside `<…>` is content.)*

## Reference as value vs reference as child

```udon
|el :ref @[asdf].hey
  @another[xyz]
```

```events
ElementStart el
  AttrStart ref
    Reference key="asdf" traits=["hey"]
  AttrEnd
  Reference name="another" key="xyz"     ; block line → el's reference CHILD
ElementEnd
```

## Whole-value interpolation, and the mixed blob

```udon
|link :href !{{computed_url}}
|link :path !{{base}}/x
```

```events
ElementStart link
  AttrStart href
    Interpolation "computed_url"
  AttrEnd
ElementEnd
ElementStart link
  AttrStart path
    Interpolation "base"
    Text "/x\n"            ; mixed literal+interp = a blob; segments in one bracket
  AttrEnd
ElementEnd
```

*(The bracket makes the leaky edge CORE's deratification note complains about — `/x` silently becoming element content — impossible to mis-read: the segments are inside the value.)*

## Multi-line value (deferred block) with a blank line

```udon
|el
  :body
    line one

    line two
```

```events
ElementStart el
  AttrStart body
    Text "line one\n"
    BlankLine
    Text "line two\n"
  AttrEnd                  ; fires at the dedent (here: EOF unwind)
ElementEnd
```

*(`AttrEnd` placement means trailing BlankLines before a dedent land inside the bracket; whether they are value text or ornamentation is the AST's whole-stream call, exactly as for element prose.)*
