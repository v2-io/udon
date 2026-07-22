# Text blobs, ownership, stacking, warn-ingestion

## Ownership row 1 vs row 2 (open attr takes the tail; finished value gives it to the element)

```udon
|el :first value :another with some text
|el :first value :another "with" some text
```

```events
ElementStart el
  AttrStart first
    Scalar Str "value"
  AttrEnd
  AttrStart another
    Text "with some text\n"    ; row 1: another was open — blob is its value
  AttrEnd
ElementEnd
ElementStart el
  AttrStart first
    Scalar Str "value"
  AttrEnd
  AttrStart another
    Scalar Str "with"
  AttrEnd
  Text "some text\n"           ; row 2: value finished — tail is el's prose
ElementEnd
```

## The inline-brace principle: a brace form never finishes a value

```udon
|el :n value |{em x} :a 1
```

```events
ElementStart el
  AttrStart n
    Text "value "
    ElementStart em inline
      Text "x"
    ElementEnd
    Text " :a 1\n"             ; blob committed — the later :a is literal text
  AttrEnd
ElementEnd
```

## Blob beginning with a brace form; the empty-string idiom

```udon
|el :n |{em x}
|el :n ;{}
```

```events
ElementStart el
  AttrStart n
    ElementStart em inline     ; a blob whose first segment is an inline element
      Text "x"
    ElementEnd
    Text "\n"                  ; inline form owned the line end → terminator-only Text
  AttrEnd
ElementEnd
ElementStart el
  AttrStart n
    CommentStart inline
    CommentEnd
  AttrEnd                      ; empty bracket, only a comment frame ⇒ value ""
ElementEnd
```

## Stacking vs list values vs blob segments — three shapes, three wires

```udon
|el :x 1 :x 2
|el :x [1 2]
```

```events
ElementStart el
  AttrStart x
    Scalar Int "1"
  AttrEnd
  AttrStart x                  ; stacking = sibling brackets, same key
    Scalar Int "2"
  AttrEnd
ElementEnd
ElementStart el
  AttrStart x
    ArrayStart                 ; one value that is a list
      Scalar Int "1"
      Scalar Int "2"
    ArrayEnd
  AttrEnd
ElementEnd
```

## Warn-ingestion: trailing text after a finished block-line value

```udon
|el
  :attr "first" and here's another one
```

```events
ElementStart el
  AttrStart attr
    Scalar Str "first"
  AttrEnd
  Warning AttributeValueExtendedByTrailingText
  AttrStart attr               ; ingest = stacking: a new bracket, same key
    Text "and here's another one\n"
  AttrEnd
ElementEnd
```

## Warn-ingestion: deeper second value under a finished value

```udon
|el
  :when <7:02pm>
    extra deeper text
```

```events
ElementStart el
  AttrStart when
    Envelope "7:02pm"
  AttrEnd
  Warning AttributeSecondValue
  AttrStart when
    Text "extra deeper text\n"
  AttrEnd
ElementEnd
```

## Value-position `\` (text mode, comment affordance surrendered)

```udon
|el :count \7 apples ; not a comment
```

```events
ElementStart el
  AttrStart count
    Text "7 apples ; not a comment\n"
  AttrEnd
ElementEnd
```

## Blob value with a trailing framed comment — terminator lands after the frame

```udon
|el
  :title The full title goes here ; TODO
```

```events
ElementStart el
  AttrStart title
    Text "The full title goes here"
  AttrEnd                        ; value's last material closes the bracket
  CommentStart
    Text " TODO"
  CommentEnd
  Text "\n"                      ; text-bearing line, annotation owned its end
ElementEnd
```

*(The trailing `\n` sits at owner scope — reconstruction is global in-order concatenation, so the blob text + newline still concatenate exactly; the AST decides whether that terminator is the value's or ornamental. This is the terminator-placement rule EVENTS.md states and the greenfield CORE copy adopts. The space before ` ; ` is the comment frame — geometry.)*
