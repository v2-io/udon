# Comments

## Root line comment with continuation (everything deeper is comment text)
```udon
; This would be a comment
  this is still part of the comment
  |even :this "structure"
\; But this line is output as text.
```

## Comments participate in the hierarchy
```udon
|parent
  |child
   ; inside child
  ; sibling of child
; closes everything
|sibling
```

## Sameline comment: the whitespace frame
```udon
|li Item one ; TODO expand
|li Item one ;still prose
|li ratio 1;2 done
|li trailing wins ;
```

## Comment at the prose base column vs deeper
```udon
|element
  Some prose content
  ; comment at the base — a comment
   ; deeper than base — literal prose
```
