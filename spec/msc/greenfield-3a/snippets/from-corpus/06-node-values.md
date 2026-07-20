# Node values

## Sameline node value — the node's scan owns its interior (one-way door)
```udon
|api :headers |header :name Content-Type :value application/json
```

## The one-way door, illustrated
```udon
|api :headers |header :k v :timeout 30
```

## Deferred node value
```udon
|el
  :beta
    |veni-vidi-vici :working 1234
```

## Node value with trailing prose — the prose is the node's
```udon
|el :a |the-node :k "v" more
```

## Brace form is text, block form is a node — the teachable pair
```udon
|el :x |em hi
|el :x |{em hi}
```

## Attribute-under-attribute is an error; the named-carrier idiom
```udon
|el
  :theta
    :first 1
```

## Raw block as node value
```udon
|el :script !:sh: make build
```
