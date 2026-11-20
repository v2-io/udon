Yes. Basis: 0.10.0's surface exactly as it stands, plus your three sentences, nothing renamed. Left is UDON, right is the tree it produces. Values in quotes are strings; bare are typed.

**1. A thing, its facts, its text, its children**

```udon
|user[jw].admin :active true Joined 2025.
  :email jo@x.io
  Body text here,
    indented more.
  |child :n 1
```
```
element user
  $key    "jw"
  $traits "admin"
  active  true
  $main   "Joined 2025."
  email   "jo@x.io"
  ├ text  "Body text here,\n  indented more.\n"
  └ element child
      n 1
```
Indentation is the tree. `[k]` `.t` and sameline text are sugar for `$key` `$traits` `$main`. Same label twice = two entries, in order, never last-wins. A `:label` with no value is an error and holds nil.

**2. Sameline is one line of the tree written sideways**

```udon
|a :x 1 |b :y 2 |c
```
```
element a
  x 1
  └ element b
      y 2
      └ element c
```
Once `|b` opens, the rest of the line is b's. An unquoted value ends at the next ` :label`, ` |name`, ` @ref`, ` !name`, ` ; `, or ` \ `.

**3. The six bare types, and the box for everything else**

```udon
|v :i 42 :f 1.5 :b true :n nil :s hello :q "two words" :l [1 "b" c]
   :when <2026-07-11> :size <u64:0xff>
```
```
element v
  i 42        f 1.5      b true      n nil
  s "hello"   q "two words"   l [1 "b" "c"]
  when <2026-07-11>          size <u64: "0xff">
```
Bare typing never grows. `<…>` is carried as its text plus its tag; whoever loads a dialect decides what it means. Nobody warns that nobody has yet.

**4. Prose, comments, escapes**

```udon
|p
  Markdown *works* here, so does | and : and @ and 3:1.
  ; a maintainer note
  \| this line starts with a pipe
  See |{em this} and @{user.name}.
```
```
element p
  ├ text    "Markdown *works* here, so does | and : and @ and 3:1.\n"
  ├ comment "a maintainer note"
  ├ text    "| this line starts with a pipe\n"
  └ text    "See " · inline em["this"] · ref{user.name} · ".\n"
```
In a body, markers are literal. Only `|{`, `!{`, `;{`, `@{` are live, and `\` in front of one makes it literal. `@{…}` is your first sentence: it replaces `!{{…}}` everywhere and the parser carries it as text.

**5. Code bodies**

```udon
|ex
  !:python:
    if a > b:
      print("| not udon")
  ```sh
  make build
  ```
```
```
element ex
  ├ verbatim python  "if a > b:\n  print(\"| not udon\")\n"
  └ fence    sh      "make build\n"
```
Block verbatim dedents to its first line and closes by dedent; the fence is byte-exact and closes at ```` ``` ````. Both work as an attribute's value: `:script !:sh: make build`. This is the part 0.10.01 broke; here it is simply kept.

**6. References: point, never look up**

```udon
|book :author @person[jw]
  @licence[mit]
  |cite[@{ref.key}]
```
```
element book
  author  ref person[jw]
  ├ ref licence[mit]
  └ element cite
      $key ref{ref.key}
```
`@name[key].trait` is a selector carried as written. Inside brackets, and in prose, the brace form. The parser never resolves; that is your third sentence.

**7. Generators: a `!` line parses like a `|` line**

```udon
!for :item @posts :as post
  |card :title @{post.title}
!if @{user.admin? and n > 3}
  |admin-panel
!else
  Not an admin.
|el :script !sh make build :y 2
```
```
generator for
  item  ref posts
  as    "post"
  └ element card
      title ref{post.title}
generator if
  $main ref{user.admin? and n > 3}
  └ element admin-panel
generator else
  └ text "Not an admin.\n"
element el
  script  generator sh
            $main "make build"
            y 2
```
Your second sentence. Name, brackets, `:label`s, sameline text, body: identical to an element, with `!` saying "a dialect runs this later." Anything that is not UDON value syntax goes in `@{…}`. Note the last line: `:y 2` belongs to `sh` by the same rule as line 2 above, no special warning needed. `!else` is just the next sibling.

**8. What can go wrong, and what survives**

```udon
|el[abc
  :k
```
```
element el
  $partial-key "abc"     warning: bracket never closed
  k nil                  error: no value
```
Everything the author typed is in the tree. Warning means kept but check it. Error means a value is genuinely missing. Input ending inside a quote, `|{`, `<…>`, or fence is `incomplete`.

That is the whole proposal: eight pictures. Everything in them is 0.10.0 except `@{…}` (sentence 1), `!` lines parsed as elements (sentence 2), and the deletion of the "nothing will handle this" warnings (sentence 3). Lists stay closed-at-end-of-line for now, since the demand for multi-line lists has not been argued and the accident case is real.

Open calls I would want from you, not from theory: whether `!` on a verbatim body still reads right now that `!` means "runs later" (I lean keep it, it works and the fence is the alternative), and whether `@{…}` should accept bare expressions like line 7 or only paths.