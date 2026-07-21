# Node values

## Sameline node value — the node's scan owns its interior (one-way door)

```udon
|api :headers |header :name Content-Type :value application/json
```

```events
ElementStart api
  AttrStart headers
    ElementStart header          ; inside the bracket: headers IS this node
      AttrStart name
        Scalar Str "Content-Type"
      AttrEnd
      AttrStart value
        Scalar Str "application/json"
      AttrEnd
    ElementEnd
  AttrEnd
ElementEnd
```

## The one-way door, illustrated

```udon
|api :headers |header :k v :timeout 30
```

```events
ElementStart api
  AttrStart headers
    ElementStart header
      AttrStart k
        Scalar Str "v"
      AttrEnd
      AttrStart timeout          ; the HEADER's timeout — not api's
        Scalar Int "30"
      AttrEnd
    ElementEnd
  AttrEnd
ElementEnd
```

## Deferred node value

```udon
|el
  :beta
    |veni-vidi-vici :working 1234
```

```events
ElementStart el
  AttrStart beta
    ElementStart veni-vidi-vici
      AttrStart working
        Scalar Int "1234"
      AttrEnd
    ElementEnd
  AttrEnd
ElementEnd
```

## Node value with trailing prose — the prose is the node's

```udon
|el :a |the-node :k "v" more
```

```events
ElementStart el
  AttrStart a
    ElementStart the-node
      AttrStart k
        Scalar Str "v"
      AttrEnd
      Text "more\n"
    ElementEnd
  AttrEnd
ElementEnd
```

## Brace form is text, block form is a node — the teachable pair

```udon
|el :x |em hi
|el :x |{em hi}
```

```events
ElementStart el
  AttrStart x
    ElementStart em              ; node value
      Text "hi\n"
    ElementEnd
  AttrEnd
ElementEnd
ElementStart el
  AttrStart x
    ElementStart em inline       ; blob value whose sole segment is an inline element
      Text "hi"
    ElementEnd
    Text "\n"
  AttrEnd
ElementEnd
```

*(Same tree-ish shape, different meaning — the `inline` flag and the trailing
terminator-only Text are the wire's tells. A host reading `x` gets a node in
case 1 and a text value containing markup in case 2.)*

## Attribute-under-attribute is an error; the named-carrier idiom

```udon
|el
  :theta
    :first 1
```

```events
ElementStart el
  AttrStart theta
    Error AttributeUnderAttribute
    Text ":first 1\n"            ; keep-everything: the line is kept as value text
  AttrEnd
ElementEnd
```

*(CORE names the error but not the kept shape; keep-everything plus "a `:` that
fails its guard falls back to prose intact" argues for ingesting the line as
the open value's text. The greenfield CORE copy says this explicitly — flagged
as a derived interpretation, not a ruling.)*

## Raw block as node value

```udon
|el :script !:sh: make build
```

```events
ElementStart el
  AttrStart script
    VerbatimStart block "sh"
      Text "make build\n"
    VerbatimEnd
  AttrEnd
ElementEnd
```
