# UDON in twenty minutes — a provisional baseline tutorial

**Non-normative; provisional.** This teaches only the **settled core** —
nothing here touches an open carve-out, and if it disagrees with CORE.md,
CORE wins. It exists so a fresh reader (human or agent) doesn't have to
learn UDON from a legal contract. Idiom calls follow PEDAGOGY's one-way
list and may be revised when the demand-side work settles house style.

---

## 1. It's Markdown that holds together

Plain prose is valid UDON. Write text; it belongs to the document:

```udon
Just some notes from Tuesday's meeting.

- decided to ship early
- **bold** and `code` work — # isn't special, tables survive
```

Nothing above is "markup" to UDON — it's text, kept exactly. UDON adds
structure *when you ask for it*, and only then.

## 2. Name things

`|element` makes structure. Indentation nests it — no closing tags, ever:

```udon
|meeting
  |topic Shipping schedule
    We agreed to move the date up.
  |topic Hiring
    Two candidates in final round.
```

`:key value` states a fact *about* a thing:

```udon
|meeting :date 2026-07-22 :room B4
  |topic Shipping schedule
```

**The one test to internalize — whose name is it?** If the label describes
the *relationship to the parent* (`my date`, `my room`), it's an
`:attribute`. If the name describes *what the thing is* (a topic, a
person), it's a `|child`. That's the whole rule; "metadata vs content"
folklore from XML is not needed.

Attributes come before a thing's content — once prose or children start,
that element's attribute section is over.

## 3. The second big idea: a line starts open, then commits

At the start of every line (and while you're still writing `|elements` and
`:attributes` on it), the marker characters `| : ! ; @` and ``` are live.
The moment ordinary prose begins, the line **commits**: everything after is
just text.

```udon
|note The ratio was 3:1 — and :1 here is plain text, already committed.
```

One deliberate exception survives commitment — a semicolon **framed by
spaces** is a trailing comment:

```udon
|li Buy milk ; TODO check brand
|li Ratio 3;1 stays literal — no space before the ;
```

These two ideas — *whose name is it* and *open→commit* — predict almost
everything else in the language.

## 4. Columns are the syntax

Deeper column = child. Same column = sibling. Shallower = you've closed
things. Elements written on one line sit at their real columns, exactly as
if written vertically:

```udon
|table |tr |td A1
           |td A2      ; same column as the first |td → its sibling
       |tr |td B1      ; same column as the first |tr → new row
```

When in doubt, expand to the vertical form — that's the idiom, not clever
column alignment.

## 5. Identity, kinds, flags

```udon
|user[jw].admin.founder :active?
```

- `[jw]` — **identity**: what makes this element *this one*; `@[jw]`
  elsewhere points at it.
- `.admin.founder` — **traits**: what kinds of thing it is; stack freely.
- `:active?` — a **flag**: present means true. (`:active? false` says no.)

These are conveniences, not separate machinery — under the hood they're
ordinary attributes with reserved-by-convention names (`$key`, `$traits`),
which is why dumb generators can produce them too.

## 6. Values

```udon
|server
  :host db.example.com      ; bare single token → string
  :port 5432                ; digits → integer
  :ratio 2.5                ; float
  :live? true               ; boolean (lowercase only)
  :note null                ; explicitly no value (nil ≡ null)
  :tags [api public]        ; list — items typed one by one
  :motto "quoted when it matters"
```

Three things worth knowing early:

- **Types come from syntax, never guessing.** `:date 2026-07-11` is a
  *string* — anything smarter than the boring core scalars goes in an
  envelope: `:date <2026-07-11>`, which a dialect (like `temporal@1`)
  types. Your Norwegian country code will never become `false`.
- **Repeating a key means saying it twice.** `:tag a :tag b` keeps both,
  in order. UDON never overwrites.
- **Multi-word values just flow.** `:title The Long Goodbye` — the whole
  tail is the value. If another attribute must follow a multi-word value,
  quote the value: `:title "The Long Goodbye" :year 1973`.

## 7. Escapes: one character, one slogan

`\` means **"the rest is text."** At a line's start it makes the whole line
prose (`\|not-an-element`); right before a value it makes the value text
(`:count \7 apples` → the string `"7 apples"`). A backslash anywhere else —
`C:\Users\me` — is just a backslash. There is no escape table to memorize.

## 8. Structure inside sentences, code inside documents

When Markdown can't say it, inline elements can — but prefer Markdown for
plain emphasis:

```udon
|p Deploy uses |{a :href /docs/deploy the deploy guide} — read it first.
```

Braces vs no braces is the one teachable pair: **braces = inline text**
(`:x |{em hi}` puts formatted text in the value); **no braces = the node
itself** (`:x |em hi` makes the `em` element *be* the value).

Code blocks: `!:lang:` is the default —

```udon
|example
  !:python:
    print("| is not udon here")
```

## 9. Nothing is ever thrown away

Malformed input doesn't destroy content. A warning marks the spot; the
bytes are all still in the parse. An unclosed `[key` becomes a specially
named partial key so nothing downstream mistakes it for a real identity;
trailing text after a finished value is kept (with a warning) rather than
dropped. If a tool built on UDON loses your bytes, the tool is wrong.

## Where to next

- **The annotated one-screen map:** CORE.md Appendix A.
- **The rules behind each section here:** CORE.md (the contract).
- **What's deliberately undefined and why:** CARVEOUTS.md — read before
  relying on anything this tutorial didn't cover (multi-line strings and
  lists live there, for instance).
