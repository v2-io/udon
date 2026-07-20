# Text blobs, ownership, stacking, warn-ingestion

## Ownership row 1 vs row 2 (open attr takes the tail; finished value gives it to the element)
```udon
|el :first value :another with some text
|el :first value :another "with" some text
```

## The inline-brace principle: a brace form never finishes a value
```udon
|el :n value |{em x} :a 1
```

## Blob beginning with a brace form; the empty-string idiom
```udon
|el :n |{em x}
|el :n ;{}
```

## Stacking vs list values vs blob segments — three shapes, three wires
```udon
|el :x 1 :x 2
|el :x [1 2]
```

## Warn-ingestion: trailing text after a finished block-line value
```udon
|el
  :attr "first" and here's another one
```

## Warn-ingestion: deeper second value under a finished value
```udon
|el
  :when <7:02pm>
    extra deeper text
```

## Value-position `\` (text mode, comment affordance surrendered)
```udon
|el :count \7 apples ; not a comment
```

## Blob value with a trailing framed comment — terminator lands after the frame
```udon
|el
  :title The full title goes here ; TODO
```
