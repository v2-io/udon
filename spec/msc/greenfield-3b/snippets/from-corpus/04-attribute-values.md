# Value kinds: scalars, arrays, envelopes, references, interpolation

## The scalar zoo
```udon
|el :i 42 :h 0xFF :f 1.5e-3 :s "quoted" :s2 'single' :n null :b false
```

## Arrays: items typed independently, full value rules
```udon
|server :ports [8080 8443] :mixed [1 two "three three" [4] @[k] !{{x}}]
```

## Quoted-item nuance: the closing quote ends the item
```udon
|el :x ["a"b]
```

## The typing envelope (greenfield wire; see EVENTS.md for the interim form)
```udon
|el :when <2026-07-11> :size <u64:0xf902>
```

## Reference as value vs reference as child
```udon
|el :ref @[asdf].hey
  @another[xyz]
```

## Whole-value interpolation, and the mixed blob
```udon
|link :href !{{computed_url}}
|link :path !{{base}}/x
```

## Multi-line value (deferred block) with a blank line
```udon
|el
  :body
    line one

    line two
```
