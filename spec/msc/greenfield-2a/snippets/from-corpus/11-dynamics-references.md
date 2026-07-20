# Dynamics and references

## Block directive with UDON body; the head-line remainder is an unparsed arg
```udon
!if user.verified and user.subscribed
  |greeting Welcome back!
!else
  |greeting Hello, guest!
```

## Interpolation in prose and in values
```udon
|greeting
  Hello, !{{user.name | capitalize}}!
|link :href !{{base_url}}/users/!{{user.id}}
```

## Empty interpolation is valid
```udon
|p !{{}}
```

## Inline directive with UDON-parsed body
```udon
|p Before !{include |{em emphasized} content} after.
```

## References: the selector ladder, one structured event
```udon
|project
  :license @[mit]
  :owner @person[jw].admin
  @footer
```

## Directive as sibling structure, closed by dedent
```udon
|body
  !for item in items
    |card :title !{{item.name}}
  |after
```
