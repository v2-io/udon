# Hierarchy: inline nesting, siblings, dedent cascades

The stack rule is the whole story: pop while `new_column <= top.base_column`, push at the marker's actual column. Inline elements push at their real columns.

## Inline nesting ≡ vertical form

```udon
|one |two |three
```

```events
ElementStart one
  ElementStart two
    ElementStart three
    ElementEnd
  ElementEnd
ElementEnd
```

*(All three Ends flush at EOF — positional closes, silent.)*

## Sibling after inline elements

```udon
|one |two |three
  |alpha
```

```events
ElementStart one          ; col 0
  ElementStart two        ; col 5
    ElementStart three    ; col 10
    ElementEnd            ; alpha@2: 2<=10 pop
  ElementEnd              ; 2<=5 pop
  ElementStart alpha      ; 2<=0? no — child of one
  ElementEnd
ElementEnd
```

## Column alignment = sibling; one column deeper = child

```udon
|table |tr |td A1
           |td A2
       |tr |td B1
  |caption Table 1
```

```events
ElementStart table                 ; col 0
  ElementStart tr                  ; col 7
    ElementStart td                ; col 11
      Text "A1"
    ElementEnd                     ; td@11 = same col → sibling
    ElementStart td                ; col 11
      Text "A2"
    ElementEnd
  ElementEnd                       ; tr@7 same col → sibling
  ElementStart tr
    ElementStart td
      Text "B1"
    ElementEnd
  ElementEnd
  ElementStart caption             ; col 2 — child of table
    Text "Table 1"
  ElementEnd
ElementEnd
```

*(Terminator question: `A1`'s line is text-bearing, so its terminator is text — `Text "A1\n"` strictly; shown bare here and below only where the case isn't about terminators. The corpus files about text carry them exactly.)*

## Dedent cascade to column 0

```udon
|one
  |two
    |three
      |four
- this prose is sibling to |one
```

```events
ElementStart one
  ElementStart two
    ElementStart three
      ElementStart four
      ElementEnd
    ElementEnd
  ElementEnd
ElementEnd                          ; 0 <= 0 pops |one too
Text "- this prose is sibling to |one\n"
```

*(Root prose; the mid-line `|one` is past head position — literal. A `|` even at head start followed by space is literal anyway.)*

## Closed columns are dead: only the current stack matters

```udon
|one |two |three
  |alpha
     |beta
```

```events
ElementStart one
  ElementStart two
    ElementStart three
    ElementEnd
  ElementEnd
  ElementStart alpha        ; col 2 — popped two & three
    ElementStart beta       ; col 5 — child of alpha (two's old column is coincidence)
    ElementEnd
  ElementEnd
ElementEnd
```
