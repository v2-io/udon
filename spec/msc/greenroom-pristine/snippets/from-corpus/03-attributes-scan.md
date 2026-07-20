# Attributes: the scan, the bare-token boundary, flags

## Two attributes on a block line (0.9 uniform scan)
```udon
|el
  :a 1 :b 2
```

## Bare token finished by a marker vs committed to a blob
```udon
|el :first value :another x
|el :first value with spaces :another x
```

## A failed number falls through to bare token, boundary rule applies
```udon
|el :x 12ab :y 3
|el :x 12ab more
```

## Keywords type only when alone at the boundary
```udon
|el :alpha true
|el :alpha true story
|el :alpha true \ story
```

## Flags
```udon
|el :a?
|el :a? false
|el :a? |beta
|el :a? well it sure is true
```

## Missing value: error + Nil, shape preserved
```udon
|button :disabled :type submit
```

## The framed sameline comment at a value boundary
```udon
|el :alpha something ; a comment
```
