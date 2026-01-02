# UDON Full Specification Supplement

This file contains material from SPEC.md that is not included in FULL-SPEC.md.
It is preserved for completeness and reference.

---

## Element Identity Shorthands

```
|name[id].class1.class2?    ; Element with id, classes, suffix
|[id-only]                  ; Anonymous with id
|.class-only                ; Anonymous with class
```

---

## Extended Examples

### Configuration

```
|database[primary].postgres
  :host db.example.com
  :port 5432
  :pool 10

  |credentials
    :username !{{env.DB_USER}}
    :password !{{env.DB_PASS}}

|cache.redis
  :host cache.example.com
  :ttl 3600
```

### Document

```
|article[intro]
  :author Joseph Wecker
  :date 2025-12-22
  :tags [udon notation design]

  |heading UDON: A Unified Notation

  UDON treats documents and data as the same thing--because they are.
  Structure and prose coexist naturally.

  |section
    :title Why Another Format?

    Existing formats force a choice:

    - **JSON/YAML**: Data-first, prose is awkward
    - **Markdown**: Prose-first, data is awkward
    - **XML**: Verbose, closing tags everywhere

    UDON unifies both with minimal syntax.

  !:udon:
    |example
      :this works
      And so does this prose.
```

### Template

```
; Page layout with dynamics
!include partials/doctype

|html :lang !{{locale}}
  |head
    |title !{{page.title}} -- !{{site.name}}
    !for stylesheet in stylesheets
      |link :rel stylesheet :href !{{stylesheet}}

  |body
    !include partials/nav

    |main
      !if user
        Welcome back, !{{user.name | capitalize}}!
      !else
        |a :href /login Please sign in

      !{{content}}

    !include partials/footer
```

---

## Comparison

| Feature | UDON | JSON | YAML | XML | Markdown |
|---------|------|------|------|-----|----------|
| Comments | `;` | x | `#` | `<!-- -->` | N/A |
| Prose-friendly | yes | no | no | no | yes |
| Data-friendly | yes | yes | yes | yes | no |
| No closing tags | yes | N/A | yes | no | N/A |
| Streaming parse | yes | yes | yes | yes | yes |
| Typing | Syntactic | Syntactic | Sniffing | Strings | N/A |
| Templating | `!` | x | x | x | x |

---

## File Extension

`.udon`

---

## History

- 2011: Original design by Joseph Wecker
- 2012: C and Ruby implementations
- 2025: Revival with modern design decisions

