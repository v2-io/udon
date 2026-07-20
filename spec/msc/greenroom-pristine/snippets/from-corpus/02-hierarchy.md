# Hierarchy: inline nesting, siblings, dedent cascades

## Inline nesting ≡ vertical form
```udon
|one |two |three
```

## Sibling after inline elements
```udon
|one |two |three
  |alpha
```

## Column alignment = sibling; one column deeper = child
```udon
|table |tr |td A1
           |td A2
       |tr |td B1
  |caption Table 1
```

## Dedent cascade to column 0
```udon
|one
  |two
    |three
      |four
- this prose is sibling to |one
```

## Closed columns are dead: only the current stack matters
```udon
|one |two |three
  |alpha
     |beta
```
