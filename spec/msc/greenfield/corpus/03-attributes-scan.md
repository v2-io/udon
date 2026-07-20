# Attributes: the scan, the bare-token boundary, flags

## Two attributes on a block line (0.9 uniform scan)

```udon
|el
  :a 1 :b 2
```

```events
ElementStart el
  AttrStart a
    Scalar Int "1"
  AttrEnd
  AttrStart b
    Scalar Int "2"
  AttrEnd
ElementEnd
```

*(Pure-structure lines: no terminator events.)*

## Bare token finished by a marker vs committed to a blob

```udon
|el :first value :another x
|el :first value with spaces :another x
```

```events
ElementStart el
  AttrStart first
    Scalar Str "value"
  AttrEnd
  AttrStart another
    Scalar Str "x"
  AttrEnd
ElementEnd
ElementStart el
  AttrStart first
    Text "value with spaces :another x\n"
  AttrEnd
ElementEnd
```

*(Row 1 of ownership: `first` was still collecting, so the blob — including the
literal `:another x` — is its value. Text-bearing line ⇒ terminator inside the
blob's last Text, inside the bracket.)*

## A failed number falls through to bare token, boundary rule applies

```udon
|el :x 12ab :y 3
|el :x 12ab more
```

```events
ElementStart el
  AttrStart x
    Scalar Str "12ab"
  AttrEnd
  AttrStart y
    Scalar Int "3"
  AttrEnd
ElementEnd
ElementStart el
  AttrStart x
    Text "12ab more\n"
  AttrEnd
ElementEnd
```

## Keywords type only when alone at the boundary

```udon
|el :alpha true
|el :alpha true story
|el :alpha true \ story
```

```events
ElementStart el
  AttrStart alpha
    Scalar Bool "true"
  AttrEnd
ElementEnd
ElementStart el
  AttrStart alpha
    Text "true story\n"
  AttrEnd
ElementEnd
ElementStart el
  AttrStart alpha
    Scalar Bool "true"
  AttrEnd
  Text " story\n"         ; boundary-\ forces the tail to el's prose; \ consumed
ElementEnd
```

## Flags

```udon
|el :a?
|el :a? false
|el :a? |beta
|el :a? well it sure is true
```

```events
ElementStart el
  AttrStart a?
    Scalar Bool "true"
  AttrEnd
ElementEnd
ElementStart el
  AttrStart a?
    Scalar Bool "false"
  AttrEnd
ElementEnd
ElementStart el
  AttrStart a?
    Scalar Bool "true"
  AttrEnd
  ElementStart beta       ; flag snapped true; node re-owned by the scan → child
  ElementEnd
ElementEnd
ElementStart el
  AttrStart a?
    Scalar Bool "true"
  AttrEnd
  Text "well it sure is true\n"
ElementEnd
```

## Missing value: error + Nil, shape preserved

```udon
|button :disabled :type submit
```

```events
ElementStart button
  AttrStart disabled
    Error MissingAttributeValue
    Scalar Null "nil"
  AttrEnd
  AttrStart type
    Scalar Str "submit"
  AttrEnd
ElementEnd
```

*(Wait — `:disabled` is followed by `:type`, a marker, so `disabled` has no
value material: the error fires at the boundary and the scan continues. The
`Scalar Null` is synthesized; its `text` payload is empty/synthetic, shown as
`"nil"` for legibility only.)*

## The framed sameline comment at a value boundary

```udon
|el :alpha something ; a comment
```

```events
ElementStart el
  AttrStart alpha
    Scalar Str "something"
  AttrEnd
  CommentStart
    Text " a comment"
  CommentEnd
ElementEnd
```

*(No terminator event: `something` is a scalar and comment content is not text
material, so the line bears no text — its terminator is geometry. The
contract's "terminator-only `Text "\n"` when an annotation owns the line's end"
clause applies to **text-bearing** lines, e.g. a blob value followed by a
comment — see 05. The greenfield CORE copy states this scoping explicitly;
current CORE leaves it implicit.)*
