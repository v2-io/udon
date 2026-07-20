# Dynamics and references

## Block directive with UDON body; the head-line remainder is an unparsed arg

```udon
!if user.verified and user.subscribed
  |greeting Welcome back!
!else
  |greeting Hello, guest!
```

```events
DirectiveStart if "user.verified and user.subscribed"
  ElementStart greeting
    Text "Welcome back!\n"
  ElementEnd
DirectiveEnd                       ; !else at the same column closes !if
DirectiveStart else
  ElementStart greeting
    Text "Hello, guest!\n"
  ElementEnd
DirectiveEnd
```

*(The core does not know `else` pairs with `if` — dialect's job; on the wire
they are siblings, exactly like same-column elements.)*

## Interpolation in prose and in values

```udon
|greeting
  Hello, !{{user.name | capitalize}}!
|link :href !{{base_url}}/users/!{{user.id}}
```

```events
ElementStart greeting
  Text "Hello, "
  Interpolation "user.name | capitalize"
  Text "!\n"
ElementEnd
ElementStart link
  AttrStart href
    Interpolation "base_url"
    Text "/users/"
    Interpolation "user.id"
    Text "\n"                      ; inline form owned the line's end
  AttrEnd
ElementEnd
```

*(Second case: a mixed blob — segments inside one bracket. Terminator note:
the line's last non-geometry is the interpolation; the terminator-only Text
follows it inside the still-open bracket.)*

## Empty interpolation is valid

```udon
|p !{{}}
```

```events
ElementStart p
  Interpolation ""
  Text "\n"
ElementEnd
```

## Inline directive with UDON-parsed body

```udon
|p Before !{include |{em emphasized} content} after.
```

```events
ElementStart p
  Text "Before "
  DirectiveStart include inline
    ElementStart em inline
      Text "emphasized"
    ElementEnd
    Text " content"
  DirectiveEnd
  Text " after.\n"
ElementEnd
```

*(Open question flagged in the greenfield copy: does the inline directive's
name-adjacent material split into arg vs body? CORE/DYNAMICS say only "content
is parsed as UDON"; shown here as body-only, no arg.)*

## References: the selector ladder, one structured event

```udon
|project
  :license @[mit]
  :owner @person[jw].admin
  @footer
```

```events
ElementStart project
  AttrStart license
    Reference key="mit"
  AttrEnd
  AttrStart owner
    Reference name="person" key="jw" traits=["admin"]
  AttrEnd
  Reference name="footer"            ; block line → reference child
ElementEnd
```

## Directive as sibling structure, closed by dedent

```udon
|body
  !for item in items
    |card :title !{{item.name}}
  |after
```

```events
ElementStart body
  DirectiveStart for "item in items"
    ElementStart card
      AttrStart title
        Interpolation "item.name"
      AttrEnd
    ElementEnd
  DirectiveEnd                     ; |after at the !for's column pops it
  ElementStart after
  ElementEnd
ElementEnd
```
