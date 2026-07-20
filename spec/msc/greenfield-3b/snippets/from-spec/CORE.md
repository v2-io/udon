# udon snippets lifted from CORE.md (scrubbed spec)

## Positional Contexts (Vocabulary)

```udon
|el :key value Content            ; sameline: attrs + content on the definition line
|el
  :key value                      ; block: its own indented line
  prose with |{em inline} content ; inline within prose flow
```

## Block vs Sameline

```udon
|article
  :author Alice                    ; block attribute
  :date 2024-12-31                 ; block attr (bare = string; temporal is moving to a `<…>` dialect)

|section :name intro :role lead    ; sameline attributes
  This is block prose that can span
  multiple lines with consistent indentation.

|p Sameline prose here |{em with inline element} and more
```

## Inline Elements (Context Reminder)

```udon
|p Click |{a :href /home here} to continue.
```

## Escape (`\`) -- Forcing Prose

```udon
\|element            ->  |element            ; would-be element -> prose
\:not-an-attr        ->  :not-an-attr        ; would-be attribute -> prose
\@name see this      ->  @name see this      ; would-be reference -> prose
\```not a fence      ->  ```not a fence      ; would-be fence -> prose
\![img](pic.jpg)     ->  ![img](pic.jpg)     ; never special -- harmless
\\path\to            ->  \path\to            ; literal leading backslash (below)
```

## Escape (`\`) -- Forcing Prose

```udon
|element |another :val [234 19] \ how wonderful ; it is
```

## Escape (`\`) -- Forcing Prose

```udon
|p see \|{em x}     ->  literal "|{em x}", prose continues
|p price \!{cost}   ->  literal "!{cost}" (not a directive/interpolation)
|p wink \;{x}       ->  literal ";{x}" (not an inline comment)
```

## Escape (`\`) -- Forcing Prose

```udon
|p Windows path C:\Users\me    ->  prose "Windows path C:\Users\me"  ; \U \m untouched
|p wrap this line \            ->  prose "wrap this line \"          ; trailing \ to host
|a hello \world                ->  "hello" begins prose, "\world"    ; literal
```

## Escape (`\`) -- Forcing Prose

```udon
|the-element |another
   \     Here all of this is output with the lines indented,
         even though this more-indented line needs no marker -- cleaner --
      here too, with a smaller indent (still past the base column);
  this line dedents past the base: a warning fires
  and the base resets to it.
```

## Escape (`\`) -- Forcing Prose

```udon
|element
  \  start some prose      ->  "  start some prose"    ; \ at head pos -> forces prose
    \some more prose        ->  "  \some more prose"    ; \ past the base -> literal
```

## Elements

```udon
|element-name
```

## Identity (Keys) and Classification (Traits)

```udon
|element[key].trait1.trait2
```

## Flag Suffixes

```udon
|field[name]?      ->  |field[name] :'$?' true
|field[name]!      ->  |field[name] :'$!' true
|field[name]*      ->  |field[name] :'$*' true
|field[name]+      ->  |field[name] :'$+' true
```

## Flag Suffixes

```udon
|name?                   ; after the name
|name?[key]              ; after name, before key
|name?[key].trait        ; after name, before key and traits
|name[key]?              ; after key
|name[key].trait ?       ; space-separated at the end
```

## Flag Suffixes

```udon
|el.bar?         ; traits: ["bar?"]
|el.bar ?        ; traits: ["bar"], $? = true
|el?.bar         ; $? = true, traits: ["bar"]
```

## Anonymous Elements

```udon
|[k]                      ; anonymous, key k
|.some-trait              ; anonymous, trait "some-trait"
|.some-trait :adapter pg  ; ...and carrying attributes
|?                        ; anonymous, just a flag suffix
```

## Attributes Are Labeled Edges

```udon
|element :key value :another-key "another value"
```

## Attribute Keys and Flags

```udon
|button :disabled? :type submit    ; disabled? = true, type = "submit"
|el :ready? false                  ; ready? = false (explicit)
```

## Attribute Keys and Flags

```udon
|el :a?                       ; a? = true
|el :a? false                 ; a? = false
|el :a? |beta                 ; a? = true; |beta is a child of |el
|el :a? well it sure is true  ; a? = true; el prose "well it sure is true"
```

## Value Kinds

```udon
|el :ref @[asdf].hey        ; el's attribute ref = the reference (value position)
  @another[xyz]             ; a reference CHILD of |el, like a |node line would be
  That there is a reference child, just like el.ref's value is a reference.
```

## The Scan and the Bare-Token Boundary

```udon
|el
  :a 1 :b 2      ; a = 1, b = 2  (two attributes)
```

## The Scan and the Bare-Token Boundary

```udon
|el :first value :another x        ; "value" then ':' -> single-token value
|el :first value with spaces :another x
                                   ; "value" then 'w' -> flow value:
                                   ; first = "value with spaces :another x"
                                   ; (the later : is inside the flow value -- just text)
; next: "something" then '\' -> alpha = "something"; the rest of the line
; (including any would-be ' ; ') is |el's prose -- so no annotation can
; ride on it (see Escape):
|el :alpha something \ el's text and this ; is prose too
|el :alpha something ; a comment   ; framed ' ; ' at the boundary -> comment
|el :url https://x.com :role foo   ; url = "https://x.com" (boundary is ':')
; next: an inline brace form at the boundary commits the flow value (it is NOT a
; boundary marker) -- n = "value " + |{em x} + " :a 1" (all one flow value);
; there is no separate :a attribute:
|el :n value |{em x} :a 1
```

## The Scan and the Bare-Token Boundary

```udon
|el :alpha true            ; alpha = boolean true
|el :alpha true story      ; alpha = "true story"  (flow value)
; next: alpha = boolean true; el prose " story" (annotation must sit up
; here -- after the \ everything, comments included, is prose):
|el :alpha true \ story
```

## Whose Text Is This? (Ownership)

```udon
|el :first value :another with some text
; first = "value"; another = "with some text"        (row 1 -- open attr)

|el :first value :another "with" some text
; first = "value"; another = "with"; el prose "some text"   (row 2 -- value done)

|el
  :title The full title goes here ; TODO
; open attr on a block line -> the text is the value; the comment is a comment
```

## Multi-Line Values (Deferred Block)

```udon
|el
  :body
    line one

    line two with |{em emphasis}
```

## Multi-Line Values (Deferred Block)

```udon
|api-endpoint
  :method POST
  :headers
    |header :name Content-Type :value application/json
```

## Value-Position `\`

```udon
|el :count \7 apples     ; count = "7 apples"  (text, not the integer 7)
```

## Node Values

```udon
|api :headers |header :name Content-Type :value application/json
; headers IS the |header node (sameline binding -- no block-deeper requirement)

|el
  :beta
    |veni-vidi-vici :working 1234
; beta IS a veni-vidi-vici
```

## Multi-Segment Values and Stacking

```udon
|el :x 1 :x 2        ; x = [1, 2]  (both kept, in order)
```

## Multi-Segment Values and Stacking

```udon
|el :x [1 2] :x [3]   ; x = [[1, 2], [3]]
```

## Multi-Segment Values and Stacking

```udon
|el
  :attr "first" and here's another one
; WARN -- trailing text extends the finished value
; attr ~= ["first", "and here's another one"]

|el
  :when <7:02pm>
    extra deeper text
; WARN -- a second value arrives under the finished key
; when ~= [<7:02pm>, "extra deeper text"]  -- same for a second sibling node
```

## Inline Lists

```udon
|server :ports [8080 8443 9000] :tags [api public]
```

## Phase Change and Late `:`

```udon
|element[key].trait :attr1 value1 :attr2 value2
  children here
```

## Phase Change and Late `:`

```udon
|el :a 1 and a tail
  :b 2
; a = 1; "and a tail" is el prose and forecloses el's attributes;
; ":b 2" is el prose too, with a warning
; (prose that looks like an attribute)
```

## Prose Content

```udon
|article
  :author Joseph

  This is prose content. It can span multiple lines and
  include **Markdown formatting** since we're not using
  `#` for comments anymore.

  - Markdown lists work naturally
  - So do numbered lists:

  1. First item
  2. Second item

  |blockquote
    Nested elements interrupt prose and resume structure.

  Back to prose in the article.
```

## Prose Content

```udon
; Preferred -- familiar, readable
This has `inline code` and **bold** text.

; Avoid -- over-engineered for simple formatting
This has |{code inline code} and |{strong bold} text.
```

## Prose Content

```udon
|article
  :author Joseph

  This paragraph contains |{em emphasized text} and
  |{a :href /reference a reference link} inline with the prose.
```

## Comments

```udon
; This would be a comment
  this is still part of the comment
\; But this line is output as text (leading \ forces prose).
```

## Sameline Comments

```udon
|li Item one ; TODO expand    ; " ; " framed both sides -> comment
|li Item one ;still prose     ; no space after -> the ";still" is literal
|li ratio 1;2 done            ; no space before -> literal
|li trailing wins ;           ; EOL is a valid after-boundary -> empty comment
```

## Why Block Prose Differs

```udon
|pre
  function foo() {
    return x; // semicolon is literal
  }
```

## Why Block Prose Differs

```udon
|li Item one ; TODO: expand this
|li Item two
```

## Why Block Prose Differs

```udon
|p This has ;{TODO: fix wording} some text that continues.
```

## Block Comments

```udon
|parent
  |child
   ; this comment is INSIDE |child (one space further right)
  ; this comment is SIBLING of |child (same column = sibling!)
    |grandchild
; this comment closes |grandchild, |child, AND |parent (column 0)
|sibling
```

## Block Comments

```udon
|element
  Some prose content
  ; comment inside |element - AT the prose base (head position)
  More prose content
```

## Inline Comments

```udon
|p This is some text ;{TODO: improve this} and more text.
```

## Escaping Semicolons

```udon
\; This line starts with a semicolon in the output
```

## Literal Semicolons

```udon
|el :key and-this;-is-ok now part of the value ; and this is a comment
  this is prose of |el ; but this is not a comment

!:c:
  // And obviously semicolons anywhere here are ok...
```

## Style Recommendation (Non-Authoritative)

```udon
; Good - consistent alignment
|one |two |three
     |better
     |better

; Good - consistent alignment
|one |two |three
  |also-good
  |also-good

; Poor form - inconsistent (warn or error)
|one |two |three
     |alpha       ; chose column 5
  |beta           ; but then used column 2
```

## The Rule Visualized

```udon
|alpha |beta |theta
                    ;<- where to put |gamma depends on who you want it to be siblings with
                    ;   these comments are in fact children of |theta
 ^     ^^    ^
 |     ||    |
 +--+--++----+ sibling of theta
    |         (because indented from beta now instead of just alpha)
sibling of beta
```

## The Rule Visualized

```udon
|parent
  |child        <- column 2
  |sibling      <- column 2: SAME column = SIBLING of child, not inside it!
   |inside      <- column 3: ONE MORE column = INSIDE sibling
```

## Inline Nesting

```udon
|one |two |three  ; three is child of two, two is child of one
```

## Inline Nesting

```udon
|one
     |two
          |three
```

## Column-Aligned Siblings

```udon
|table |tr |td A1
           |td A2       ; same column as |td A1 -> sibling (both children of |tr)
       |tr |td B1       ; same column as first |tr -> sibling (both children of |table)
           |td B2
  |caption Table 1      ; indented from |table -> child of |table
```

## Sibling After Inline Elements

```udon
|one |two |three
  |alpha          ; sibling of |two -- child of |one
```

## Column Alignment = Sibling

```udon
|one |two |three
     |alpha       ; same as above -- sibling of |two, child of |one
```

## The Python Perspective

```udon
|alpha |beta |c |d
```

## The Python Perspective

```udon
|alpha
       |beta
             |c
                |d
```

## Child of Inline Element (Special Case)

```udon
|one |two |three
        |alpha   ; child of |two (sibling of |three)
```

## Child of Inline Element (Special Case)

```udon
|one |two |three
          |alpha  ; same -- child of |two, sibling of |three
```

## Multi-line Progression

```udon
|one |two |three
       |alpha     ; child of |two
     |beta        ; sibling of |two (child of |one)
```

## The Critical Insight

```udon
|one |two |three
  |alpha
     |beta      ; child of |alpha, NOT related to |two at all
```

## The Critical Insight

```udon
|alpha
   |beta
```

## Complex Example: Many Inline Elements

```udon
|a |b |c |d |e |f |g
         |child-of-c
   |child-of-a
```

## Closing Multiple Levels

```udon
|one
  |two
    |three
      |four
- this prose is sibling to |one
```

## Inline Content Freedom

```udon
|element-bigger Here is the first line of stuff
  and here is the second
  and third
 this would warn                                  ; col 1 < col 2, WARNING
and this would be a sibling of |element instead.  ; col 0 = element's col, DEDENT
```

## Inline Content Freedom

```udon
|element-bigger Here's the first line
                and here's an equally acceptable form
```

## Inline Content Freedom

```udon
|element-bigger Here's another first line
       This is also just as acceptable
```

## With Nested Inline Elements

```udon
|element-bigger Here's some child text |another-element
                                       |child-of-bigger
               ; ^ sibling to another-element, child of element-bigger
             |also-child-of-bigger     ; WARNING - less indent than line 2
```

## With Nested Inline Elements

```udon
|element-bigger and some child text |and-another inner text here
                              This is also a direct child of element-bigger,
                                  just in a very unconventional spot.
                              ; ^ no warning, but extra leading spaces in output for this line
```

## Basic Example

```udon
|section **The great indent**
  This content is all inner-content of |section,
  and will continue to be inner-content of |section
  until the parser detects a dedent.
```

## Inline Content with Continuation

```udon
|later-part This stuff is inner to |later-part
            and, with a slightly different formatting
            preference-- is indented quite a ways.
```

## Valid Indentation Range

```udon
|the-parent |on-line-child
            |sibling    ; column 12, same as on-line-child = sibling
                        ; one more column right = child of on-line-child

|the-parent |on-line-child
     |sibling           ; column 5, unorthodox but same semantic as above
```

## Inconsistent Indentation (Warnings)

```udon
|the-parent |on-line-child
      first-line-of-prose...   ; col 6, establishes content_base = 6
   but what about this???      ; col 3 < 6, WARNING, content_base = 3
   ^ this is the new reference ; col 3, no warning
   also not a new warning      ; col 3, no warning
       four extra spaces       ; col 7 > 3, no warning, OUTPUT: "    four extra spaces"
  new warning here             ; col 2 < 3, WARNING, content_base = 2
```

## Exception: Fences

```udon
|code
  ```
  def foo():
      return 1
  ```
```

## Inline Elements (`|{…}`)

```udon
|p This paragraph has |{em emphasized text} and |{a :href /foo a link} inline.
```

## Inline Elements (`|{…}`)

```udon
|nav |{a :href / Home} |{a :href /about About} |{a :href /contact Contact}
```

## Inline Elements (`|{…}`)

```udon
|p See |{a :href /doc the |{em official} documentation} for details.
```

## Bracket Mode Rules

```udon
; Correct -- nested inline elements
|ul |{li |{a Home}}|{li |{a About}}

; INVALID -- mixing block and brace forms
|ul |{li |a Home}     ; can't use |a inside |{...}
```

## Bracket Mode Rules

```udon
|p This has |{a :href /docs
   a link that spans
   multiple lines} and continues.
```

## Raw Directives (the block form, `!:lang:`)

```udon
|example
  !:elixir:
    def hello do
      IO.puts("world")
      |> this_pipe_is_elixir_not_udon()
    end
```

## Inline Raw Content

```udon
|p The response was !{:json: {"status": "ok", "count": 42}} as expected.
```

## Inline Raw Content

```udon
; Works -- braces are balanced (even nested)
!{:json: {"key": "value"}}
!{:regex: [a-z]{3,5}}

; Fails -- unbalanced brace
!{:text: missing close {}

; Solution -- use block form for unbalanced braces
!:text:
  missing close {here
```

## Triple-Backtick Fence

```udon
|a
  here is prose
  |b a child element
  and more prose
  ```text and the fence begins
  still inside the fence
  ``` ; fence ends
```

## References (`@`)

```udon
|license[mit]
  MIT License
  Copyright 2025...

|project
  :name MyProject
  :license @[mit]    ; (null, 'mit', [])
```

## Mixins (experimental -- a parser/host behavior, not core)

```udon
|.defaults
  :adapter postgres
  :host localhost

|database[prod].defaults
  :database prod_db     ; a mixin-aware host also gives it adapter, host
```

## Explicit Typing (`<...>`)

```udon
:when  <2026-07-11>            ; a date -- temporal dialect, not bare
:dur   <5m>                    ; a duration; shorthand stays writable in-envelope
:size  <u64:0xf902>            ; type-labelled
:span  <temporal:interval:...> ; dialect + type
```

## Numbers

```udon
42          1_000_000   0d42   ; Integers (decimal, incl. explicit 0d)
0xFF        0o755       0b1010 ; Hex, octal, binary
3.14        1e10        1.5e-3 ; Floats
```

## Booleans

```udon
:enabled true     ; Boolean true
:debug false      ; Boolean false
:flag?            ; Boolean true (flag key -- see Attributes, "Keys and Flags")
```

## Nil

```udon
:value null
:value nil
```

## Strings

```udon
:name "quoted string"       ; Explicit string
:name 'single quotes'       ; Also string
:desc unquoted text here    ; String (fallback)
:truthy "true"              ; String "true", not boolean
:number "42"                ; String "42", not integer
```

## Lists

```udon
:ports [8080 8443 9000]
:tags [api public internal]
:mixed [1 two 3.0 true]
:quoted ["hello world" foo bar]
:empty []
```

## Absent vs Nil vs False

```udon
|config
  :debug?             ; debug? = true (flag present)
  :verbose false      ; verbose = false (explicit)
  :deprecated null    ; deprecated = nil (explicitly unset)
  ; timeout is absent (key doesn't exist)
```

## Configuration

```udon
|database[primary].postgres
  :host db.example.com
  :port 5432
  :pool 10
```
