# UDON Full Specification

**Universal Document & Object Notation**
*Version 0.7-draft -- December 2025*

This document merges and supersedes:
- SPEC.md
- SPEC-INDENTS.md
- SPEC-UPDATE.md

It is intended to be the single comprehensive, authoritative spec.

---

## Overview

UDON is a unified notation for data, documents, and configuration. It combines
structured elements with natural prose, optimized for both human readability and
machine parsing.

Key properties:
- Indentation-based hierarchy (no closing tags)
- Markdown-compatible prose within elements
- Streamable, incremental parsing
- Syntactic typing (not sniffing)

**Parser behavior note:** Comments are emitted as events by the main parser.
What consumers do with them (AST inclusion, filtering, etc.) is up to the host.

---

## Positional Contexts (Vocabulary)

The parser operates in different contexts that affect parsing behavior:

| Term | Meaning | Example |
|------|---------|---------|
| **block** | On its own indented line | `:key value` as child of element |
| **sameline** | On the element definition line | `|el :key value Content` |
| **inline** | Embedded in prose/text flow | `|{em text}`, `;{comment}`, `!{dir}` |
| **embedded** | Inside `|{...}` delimiters | Synonym for inline element context |

### Block vs Sameline

```udon
|article
  :author Alice                    ; block attribute
  :date 2024-12-31                 ; block attribute

|section :id intro :class lead     ; sameline attributes
  This is block prose that can span
  multiple lines with consistent indentation.

|p Sameline prose here |{em with inline element} and more
```

**Block context:**
- Attributes on their own indented lines
- Prose that sets the indent-column for continuation
- Values can contain spaces without quoting

**Sameline context:**
- Attributes/content on the element definition line
- Prose that does NOT set indent-column
- Values are space-delimited (quote for spaces)

### Inline Elements (Context Reminder)

Inline elements use `|{...}` syntax and appear within prose:

```udon
|p Click |{a :href /home here} to continue.
```

Inside `|{...}`:
- Element identity follows same rules
- Sameline attributes work the same way
- Content terminates at `}` (brace-balanced)
- Nested `|{...}` allowed (not `|name` block form)

---

## Core Syntax

### Prefixes

Four special characters at line start (after indentation):

| Prefix | Domain | Purpose |
|--------|--------|---------|
| `|` | Structure | Elements and nodes |
| `:` | Attributes | Key-value metadata |
| `!` | Dynamics | Evaluation, control flow, interpolation |
| `;` | Comments | Comment lines / inline comments |

**One escape prefix:**

| Prefix | Purpose |
|--------|---------|
| `'` | Literal -- prevents interpretation of a *block-level* marker |

Anything else is **prose content** belonging to the parent element.

### Block-Level Escape (`'`)

At block level (line start after indentation), apostrophe followed by a
block-marker character (`|`, `;`, `:`, `!`, or `'`) **always** triggers an
escape. The apostrophe is consumed and the following character is output
literally (not parsed as a marker).

**Simple rule:** `'` + one of `|;:!'` -> escape, always. No further lookahead.

```
'|element    ->  "|element"     ; escaped pipe, output as prose
';comment    ->  ";comment"     ; escaped semicolon
':attr       ->  ":attr"        ; escaped colon
'!directive  ->  "!directive"   ; escaped bang
''more       ->  "'more"        ; escaped apostrophe

'hello       ->  "'hello"       ; NOT an escape (h is not a marker)
```

If `'` is followed by a non-marker character, it is **not** an escape--the
apostrophe is preserved as normal prose content.

**Alternate:** Backslash (`\`) also works as a block-level escape before the
same marker characters. However, apostrophe is the *preferred* and *documented*
form for block-level escapes. Backslash is supported for consistency with
sameline/embedded contexts but should not be promoted in tutorials or examples.

### Sameline/Embedded Escape (`\`)

Backslash escapes a literal semicolon in **sameline** or **embedded** contexts
(where `;` would otherwise start a comment):

```
|el :key value\;more text ; this part is a comment
|{em text\;more}
```

Block prose does not need escapes for `;` (semicolons are literal there).

**Note:** Inside quoted strings (`"..."` or `'...'`), escape prefixes have no
special meaning--quoted strings handle their own escaping per their delimiter
rules.

---

## Elements

Elements are the structural backbone:

```
|element-name
```

**Element recognition rule:** `|` is only an element marker when followed by
one of: a letter, `[`, `.`, `{`, or `'`. Otherwise `|` is treated as prose
(preserves Markdown table compatibility).

### Identity and Classification

```
|element[id].class1.class2
```

- `[id]` -- Singular identity; referenceable, unique within scope
- `.class` -- Classification/traits; multiple allowed, stackable

The `[id]` syntax is shorthand for an attribute:

```
|element[my-id]     ->  |element :'$id' my-id
|step[1]            ->  |step :'$id' 1
|item[abc-123]      ->  |item :'$id' abc-123
```

The value inside brackets follows attribute value rules--all the same types are
available (integers, strings, etc.).

These are fundamental patterns:
- **Identity**: What makes this thing THIS thing (singular)
- **Classification**: What kinds of thing this is (plural, aspects)

### Element Suffixes

Elements can have suffix modifiers (`?`, `!`, `*`, `+`) that expand to attributes:

```
|field[name]?      ->  |field[name] :'?' true
|field[name]!      ->  |field[name] :'!' true
|field[name]*      ->  |field[name] :'*' true
|field[name]+      ->  |field[name] :'+' true
```

UDON performs the expansion; the meaning is DSL-defined:
- Schema DSL might interpret `?` as optional, `!` as required
- Grammar DSL might interpret `?` as 0-or-1, `*` as 0+, `+` as 1+

**Allowed positions** (suffix attaches to element identity):

```
|name?                   ; After element name
|name?[id]               ; After name, before id
|name?[id].class         ; After name, before id and classes
|name[id]?               ; After id
|name[id]? .class        ; After id, space before classes
|name[id].class ?        ; Space-separated at end
```

**Reserved** (suffix on class -- for future use):

```
|name[id].class?         ; NOT allowed -- reserved for class-level modifiers
|name[id].class!         ; NOT allowed
```

---

## Attributes

Attributes are key-value pairs:

```
|element :key value :another-key another value
```

Attributes can appear in two contexts:
- **Sameline**: on the element definition line
- **Block**: on their own indented line

Attribute values are context-sensitive:
- **Block** values run to end of line; ` ;` starts a comment
- **Sameline** values are space-delimited; quote for spaces
- **Embedded** values are space-delimited; `}` also terminates the value

When an attribute has no value (followed immediately by `:`, newline, or a
context terminator), it is treated as boolean true.

**Empty/missing values:** The parser emits `BoolTrue` for attributes without a
value:

```udon
|button :disabled :type submit
; disabled -> BoolTrue, type -> "submit"
```

### Inline Lists

Square brackets for list values:

```
|server :ports [8080 8443 9000] :tags [api public]
```

- Space-delimited within brackets
- Quoted strings for values with spaces: `["hello world" foo bar]`

### Complex Attribute Values

When an attribute needs structured content, use indentation:

```
|api-endpoint
  :method POST
  :headers
    |header :name Content-Type :value application/json
    |header :name Authorization :value Bearer token
```

Attribute followed by newline+indent = structured value.

### Value Terminator Rules

Different contexts have different terminator sets for **unquoted values**.

#### Block Attribute Values

```udon
|el
  :key value with spaces allowed here
  :url https://example.com/path?q=1;s=2
  :note this has a semicolon too ; but THIS is a comment
```

Terminators: `\n` or ` ;` (space followed by semicolon)

- Values extend to end of line
- Spaces allowed without quoting
- `;` preceded by space starts comment
- `;` without preceding space is part of value

#### Sameline Attribute Values

```udon
|el :key1 value1 :key2 value2 ; comment
|el :url https://x.com :class foo
```

Terminators: `\n` or `SPACE`

- Space delimits values
- Use quotes for values with spaces: `:key "hello world"`
- `;` after values starts comment (child of element)
- `:` after space starts next attribute

#### Embedded Attribute Values

```udon
|p Click |{a :href /home :class link here} now.
```

Terminators: `\n`, `SPACE`, or `}`

- Same as sameline, plus `}` closes the embedded element
- `}` is NOT consumed (returned for proper bracket matching)

#### Array Item Values

```udon
:tags [one two three]
:coords [1.5 2.3 4.1]
```

Terminators: `\n`, `SPACE`, or `]`

- Space separates array items
- `]` closes array (not consumed)
- Context (block vs embedded) doesn't affect array terminators
- `}` before `]` is malformed (unspecified behavior)

### Bare String Terminators (Summary)

These rules apply to **unquoted values** (bare strings, numbers, booleans, nil).

| Context | Terminators | Space? | Notes |
|---------|-------------|--------|-------|
| Block attr | `\n`, ` ;` | In value | Comment needs ` ;` |
| Sameline attr | `\n`, `SPACE` | Terminates | Quote for spaces |
| Embedded attr | `\n`, `SPACE`, `}` | Terminates | Don't consume `}` |
| Array item | `\n`, `SPACE`, `]` | Terminates | Don't consume `]` |

---

## Prose Content

Any line not starting with a prefix is prose belonging to the parent:

```
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

**Block prose** sets an indent-column for continuation and preserves literal
semicolons. **Sameline prose** does not set an indent-column and treats `;` as a
comment start.

Since `;` is the comment delimiter, `#` has no special meaning in prose.
Markdown flows naturally.

**Prefer Markdown over inline UDON in prose.** When both could work, use Markdown:

```
; Preferred -- familiar, readable
This has `inline code` and **bold** text.

; Avoid -- over-engineered for simple formatting
This has |{code inline code} and |{strong bold} text.
```

Reserve `|{...}` inline elements for cases where you need attributes or
semantic structure that Markdown cannot express.

Embedded elements can appear within prose using `|{...}`:

```
|article
  :author Joseph

  This paragraph contains |{em emphasized text} and
  |{a :href /reference a reference link} inline with the prose.
```

---

## Comments

Semicolon starts a comment depending on context:

| Context | `;` Behavior | Example |
|---------|--------------|---------|
| Document root | Line comment | `; file header comment` |
| Block prose | **Literal** (not comment) | `use x; do y` |
| Sameline prose | Line comment | `|p text ; comment` |
| Block attr line | Line comment (after values) | `:key value ; comment` |
| Sameline attrs | Line comment (after values) | `|el :k v ; comment` |
| Inline/embedded | `;{...}` only | `|{em text ;{note}}` |

**Parser behavior:** Comments are emitted as events, not discarded. The
consuming layer decides whether to keep or strip them.
This enables use cases like documentation extraction, TODO tracking, or
comment-aware transformations.

Line comments may be continued by indentation: if a line comment is followed by
a more-indented line that does not start with a prefix, that line is treated as
comment content until dedent.

```
; This would be a comment
  this is still part of the comment
'; But this is output as text.
\; This could output as text too.
```

### Why Block Prose Differs

Block prose sets an indent-column and captures literal content including
semicolons. This allows code examples, prose with semicolons, etc.

```udon
|pre
  function foo() {
    return x; // semicolon is literal
  }
```

Sameline prose is brief (single line) and commonly followed by comments:

```udon
|li Item one ; TODO: expand this
|li Item two
```

For inline comments within prose, use `;{...}`:

```
|p This has ;{TODO: fix wording} some text that continues.
```

Inline comments use brace-counting to find their end--nested `{}` pairs are
allowed as long as they are balanced. For comments with unbalanced braces, use
line-comment form instead.

### Comments and Indentation

Comments participate in the indent/dedent hierarchy, even though they produce
no structural output beyond comment events.

#### Block Comments

A line starting with `;` is a block comment. It **triggers indent/dedent
behavior**:

```udon
|parent
  |child
   ; this comment is INSIDE |child (one space further right)
  ; this comment is SIBLING of |child (same column = sibling!)
    |grandchild
; this comment closes |grandchild, |child, AND |parent (column 0)
|sibling
```

The comment at column 0 causes three ElementEnd events before `|sibling` is
parsed.

```udon
|element
  Some prose content
   ; comment inside |element - one column past the prose base
  More prose content
```

#### Inline Comments

`;{...}` is an inline comment--the only way to comment within prose:

```udon
|p This is some text ;{TODO: improve this} and more text.
```

If a consumer strips comments, the output text would be:
`This is some text and more text.`

#### Escaping Semicolons

To output a literal `;` at line start, use the escape prefix:

```udon
'; This line starts with a semicolon in the output
```

Output: `; This line starts with a semicolon in the output`

---

## Semicolon Escapes (Sameline / Embedded)

Different contexts use different escape mechanisms for literal `;`:

| Context | Escape Method | Example |
|---------|---------------|---------|
| Block prose | N/A (`;` is literal) | `code; more code` |
| Block attr value | Quote the value | `:sql 'SELECT *; DROP'` |
| Sameline attr/prose | Backslash | `|el :k val\;ue ; comment` |
| Embedded | Backslash | `|{em text\;more}` |

Rationale:
- Block prose preserves literal content (code, etc.) - no escape needed
- Block attr values support quoting naturally (same as spaces)
- Sameline/embedded use backslash (consistent with other escapes)

Backslash escapes are supported but discouraged for general authoring; prefer
block prose or quoted values when possible.

Examples:

```
|el :key and-this\;-is-ok this is prose ; and this is a comment
  this is also prose ; but this is not a comment

!:c:
  // And obviously semicolons anywhere here are ok...
```

---

## Hierarchy (Indentation and Columns)

Indentation determines parent-child relationships. UDON's hierarchy works like
Python's, with an important twist: **inline elements on a single line are
nested just as if they were on separate lines at their column positions.**

### Parser Rule (Authoritative)

The parser uses the following rule for nesting:

**pop while new_column <= stack_top.base_column**

### Style Recommendation (Non-Authoritative)

A consistent indent increment (typically 2 spaces) is recommended for readability,
but is not a parser rule.

Once you choose an indent level for siblings, maintain it:

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

Both positions are technically valid siblings of `|two`, but mixing them is
confusing.

### The Column Rules

1. **Greater column = child** (push onto stack)
2. **Same column = sibling** (pop current, push as child of parent)
3. **Lesser column = dedent** (pop until column > top's base_column)

**To be INSIDE an element, you must be at column > element's column.**
**Same column == sibling instead of child.**

### The Rule Visualized

This is a commonly misunderstood aspect of UDON indentation. The next line
gets to choose how far to indent. From an indent of one space vs the parent,
through to (but including) the pipe for the next nested one.

```
|alpha |beta |theta
                    ;<- where to put |gamma depends on who you want it to be siblings with
                    ;   these comments are in fact children of |theta
 ^     ^^    ^
 |     ||    |
 +--+--++----+ sibling of theta
    |         (because indented from beta now instead of just alpha)
sibling of beta
```

```
|parent
  |child        <- column 2
  |sibling      <- column 2: SAME column = SIBLING of child, not inside it!
   |inside      <- column 3: ONE MORE column = INSIDE sibling
```

### Inline Nesting

```
|one |two |three  ; three is child of two, two is child of one
```

Equivalent to:

```
|one
     |two
          |three
```

### Column-Aligned Siblings

When a subsequent line places an element at the same column as a previous inline
element, they become siblings (children of the same parent):

```
|table |tr |td A1
           |td A2       ; same column as |td A1 -> sibling (both children of |tr)
       |tr |td B1       ; same column as first |tr -> sibling (both children of |table)
           |td B2
  |caption Table 1      ; indented from |table -> child of |table
```

The column position determines ancestry: an element becomes a child of whichever
element "owns" that column based on the nesting established above it.

### Sibling After Inline Elements

```
|one |two |three
  |alpha          ; sibling of |two -- child of |one
```

Here `|alpha` at column 2:
- Stack has: `[one@0, two@5, three@10]`
- 2 <= 10? Yes, pop three
- 2 <= 5? Yes, pop two
- 2 <= 0? No, stop
- Push alpha as child of one

### Column Alignment = Sibling

```
|one |two |three
     |alpha       ; same as above -- sibling of |two, child of |one
```

`|alpha` at column 5 (same as `|two`):
- 5 <= 10? Pop three
- 5 <= 5? Pop two (same column = sibling)
- 5 <= 0? No, stop
- Push alpha as child of one

### The Python Perspective

Inline elements are exactly as if they were on separate lines at those columns.

```
|alpha |beta |c |d
```

Equivalent to:

```
|alpha
       |beta
             |c
                |d
```

Now placing `|e` on line 2 is just normal Python-style indent reasoning:
- Same column as `|beta` -> sibling of `|beta`
- Between `|beta` and `|c` -> child of `|beta`, sibling of `|c`
- Same column as `|c` -> sibling of `|c`
- And so on...

The inline notation is just a compact way to write the vertical form. The
column positions are real and determine hierarchy exactly as if each element
had its own line.

### Child of Inline Element (Special Case)

```
|one |two |three
        |alpha   ; child of |two (sibling of |three)
```

```
|one |two |three
          |alpha  ; same -- child of |two, sibling of |three
```

### Multi-line Progression

```
|one |two |three
       |alpha     ; child of |two
     |beta        ; sibling of |two (child of |one)
```

### The Critical Insight

**You only care about the previous line's stack state.**

```
|one |two |three
  |alpha
     |beta      ; child of |alpha, NOT related to |two at all
```

From `|beta`'s perspective, the world looks like:
```
|alpha
   |beta
```

When `|alpha` appeared, it popped `|two` and `|three` off the stack. They're
closed; later column positions that coincide with their old columns are
coincidental.

The stack naturally handles everything. No special inline column tracking is
needed because inline elements are pushed with their actual columns, just as if
they were on separate lines.

### Complex Example: Many Inline Elements

```
|a |b |c |d |e |f |g
         |child-of-c
   |child-of-a
```

Stack after first line: `[a@0, b@3, c@6, d@9, e@12, f@15, g@18]`

For `|child-of-c` at column 9:
- 9 <= 18 (g)? Pop
- 9 <= 15 (f)? Pop
- 9 <= 12 (e)? Pop
- 9 <= 9 (d)? Pop (same column!)
- 9 <= 6 (c)? No, stop
- Push as child of c

Stack now: `[a@0, b@3, c@6, child-of-c@9]`

For `|child-of-a` at column 3:
- 3 <= 9? Pop child-of-c
- 3 <= 6? Pop c
- 3 <= 3? Pop b (same column!)
- 3 <= 0? No, stop
- Push child-of-a as child of a

### Closing Multiple Levels

```
|one
  |two
    |three
      |four
- this prose is sibling to |one
```

The prose at column 0 triggers:
- 0 <= four's column? Pop four
- 0 <= three's column? Pop three
- 0 <= two's column? Pop two
- 0 <= one (0)? Pop one

Three or four ElementEnd events fire in sequence.

---

## Implementation (Non-Normative)

The stack entry needs only:
```rust
struct StackEntry {
    base_column: u16,  // Column where element started (where | was)
    span_start: u32,   // For ElementEnd event
}
```

The algorithm:
```rust
fn handle_new_element(&mut self, column: u16) {
    // Pop while new column <= top's base column
    while let Some(entry) = self.stack.last() {
        if column <= entry.base_column {
            self.emit(Event::ElementEnd { ... });
            self.stack.pop();
        } else {
            break;
        }
    }
    // Push new element as child of current top
    self.stack.push(StackEntry { base_column: column, ... });
    self.emit(Event::ElementStart { ... });
}
```

No special cases. No inline column tracking arrays. The stack handles everything
naturally because inline elements are pushed with their actual column positions.

---

## Automatic Prose Dedentation

UDON automatically strips leading whitespace from prose content based on its
context within elements. This enables readable source formatting while
producing clean output.

### The Rule

1. **Inline content** (same line as element) does NOT establish content_base
2. **First indented line** (line 2) establishes `content_base_column` - user chooses
3. **Subsequent lines at >= content_base**: no warning, extra spaces preserved in output
4. **Subsequent lines at < content_base** (but still within element):
   - Emit warning about inconsistent indentation
   - Update content_base to this new (lesser) column
   - Continue as content of same element

**Valid range for indented content:** between parent's `|`+1 (exclusive) and
any inline child's `|` (inclusive).

### Inline Content Freedom

The user chooses how to indent line 2. All of these are valid with no warnings:

```udon
|element-bigger Here is the first line of stuff
  and here is the second
  and third
 this would warn                                  ; col 1 < col 2, WARNING
and this would be a sibling of |element instead.  ; col 0 = element's col, DEDENT
```

```udon
|element-bigger Here's the first line
                and here's an equally acceptable form
```

```udon
|element-bigger Here's another first line
       This is also just as acceptable
```

### With Nested Inline Elements

```udon
|element-bigger Here's some child text |another-element
                                       |child-of-bigger
               ; ^ sibling to another-element, child of element-bigger
             |also-child-of-bigger     ; WARNING - less indent than line 2
```

```udon
|element-bigger and some child text |and-another inner text here
                              This is also a direct child of element-bigger,
                                  just in a very unconventional spot.
                              ; ^ no warning, but extra leading spaces in output for this line
```

### Basic Example

```udon
|section **The great indent**
  This content is all inner-content of |section,
  and will continue to be inner-content of |section
  until the parser detects a dedent.
```

**Output text:**
```
**The great indent**
This content is all inner-content of |section,
and will continue to be inner-content of |section
until the parser detects a dedent.
```

The inline content (`**The great indent**`) has no leading space. The indented
lines have their 2-space indent stripped.

### Inline Content with Continuation

```udon
|later-part This stuff is inner to |later-part
            and, with a slightly different formatting
            preference-- is indented quite a ways.
```

**Output text:**
```
This stuff is inner to |later-part
and, with a slightly different formatting
preference-- is indented quite a ways.
```

The continuation lines are aligned with "This" (column 12). All 12 leading
spaces are stripped.

### Valid Indentation Range

For prose after inline elements, valid columns are between the parent's `|`
(exclusive) and the inline child's `|` (inclusive):

```udon
|the-parent |on-line-child
            |sibling    ; column 12, same as on-line-child = sibling
                        ; one more column right = child of on-line-child

|the-parent |on-line-child
     |sibling           ; column 5, unorthodox but same semantic as above
```

### Inconsistent Indentation (Warnings)

```udon
|the-parent |on-line-child
      first-line-of-prose...   ; col 6, establishes content_base = 6
   but what about this???      ; col 3 < 6, WARNING, content_base = 3
   ^ this is the new reference ; col 3, no warning
   also not a new warning      ; col 3, no warning
       four extra spaces       ; col 7 > 3, no warning, OUTPUT: "    four extra spaces"
  new warning here             ; col 2 < 3, WARNING, content_base = 2
```

**Output text:**
```
first-line-of-prose...
but what about this???
^ this is the new reference
also not a new warning
    four extra spaces
new warning here
```

The first line was stripped of 6 spaces. When content_base dropped to 3,
subsequent lines were stripped of only 3 spaces. The "four extra spaces" line
preserves 4 spaces because 7 - 3 = 4.

### Streaming Behavior

Prose dedentation happens per-line as content is parsed:
- Each line is stripped of `content_base_column` spaces and emitted immediately
- If a line has fewer leading spaces than content_base, warn and update content_base
- Earlier lines may have been "over-stripped" compared to later lines
- This is intentional: the warning signals the inconsistency to the user

### Exception: Freeform Blocks

Triple-backtick (freeform) blocks preserve exact whitespace - no automatic
dedentation:

```udon
|code
  ```
  def foo():
      return 1
  ```
```

The content inside the backticks is preserved exactly as written.

### Implementation

The stack entry expands to:
```rust
struct StackEntry {
    base_column: u16,           // Column where | was (for hierarchy)
    content_base_column: u16,   // Column where indented prose starts (for dedenting)
    content_base_set: bool,     // Whether content_base has been established (by line 2+)
    span_start: u32,            // For ElementEnd event
}
```

**Inline content** (same line as element) is emitted directly without setting
content_base:
```rust
fn emit_inline_content(&mut self, content: &[u8]) {
    // Inline content doesn't establish content_base
    // Just emit it directly
    self.emit(Event::Text { content, ... });
}
```

**Indented prose** (line 2+) establishes and uses content_base:
```rust
fn emit_indented_prose(&mut self, line: &[u8], line_column: u16) {
    let entry = self.stack.last_mut().unwrap();

    if !entry.content_base_set {
        // First indented line establishes the base (user's choice)
        entry.content_base_column = line_column;
        entry.content_base_set = true;
    } else if line_column < entry.content_base_column {
        // Line 3+: inconsistent dedent - warn and update
        self.warn("Inconsistent indentation");
        entry.content_base_column = line_column;
    }

    // Strip content_base_column spaces from line
    let stripped = &line[entry.content_base_column as usize..];
    self.emit(Event::Text { content: stripped, ... });
}
```

---

## Inline and Embedded Elements

For inline elements within prose, use the embedded form `|{...}`:

```
|p This paragraph has |{em emphasized text} and |{a :href /foo a link} inline.
```

The embedded element:
- Starts with `|{`
- Contains element name, optional id/classes, optional attributes, and content
- Content terminates at `}` (brace-balanced)
- Becomes a child of the containing element (sibling to surrounding text)

Inline elements are embedded elements; this spec uses "inline" for prose
placement and "embedded" for the `|{...}` form.

Multiple embedded elements are siblings:

```
|nav |{a :href / Home} |{a :href /about About} |{a :href /contact Contact}
```

Embedded elements can be nested:

```
|p See |{a :href /doc the |{em official} documentation} for details.
```

### Bracket Mode Rules

**Once in bracket mode, stay in bracket mode.** Inside `|{...}`, you cannot use
inline element syntax (`|element`). All nested elements must also use embedded
form:

```
; Correct -- nested embedded elements
|ul |{li |{a Home} | }|{li |{a About}}

; INVALID -- mixing inline and embedded
|ul |{li |a Home}     ; can't use |a inside |{...}
```

Embedded elements can span multiple lines--indentation inside is ignored, and the
closing `}` ends the element:

```
|p This has |{a :href /docs
   a link that spans
   multiple lines} and continues.
```

---

## Unified Inline Syntax

All prefix characters support a bracket-delimited inline form:

| Syntax | Description |
|--------|-------------|
| `|{element ...}` | Embedded element |
| `!{{expr}}` | Interpolation (double-brace) |
| `!{directive ...}` | Inline directive |
| `;{comment}` | Inline comment |
| `'|{...}` or `\|{...}` | Escaped (literal text) |

The character immediately after the prefix determines the parse mode with no
lookahead.

**Note:** Apostrophe escaping applies to block-level markers (line start after
indentation). Within prose/sameline contexts, backslash escapes are supported
for literal semicolons and `\|{...}` literals, but are discouraged for general
use.

---

## Code and Raw Content

### Raw Directives (Block)

Use `!:lang:` for code samples and raw (non-UDON) content:

```
|example
  !:elixir:
    def hello do
      IO.puts("world")
      |> this_pipe_is_elixir_not_udon()
    end
```

The `!:label:` syntax (colon-wrapped label) signals that the body is **not
UDON**--it is captured verbatim. The label (e.g., `elixir`, `sql`, `json`) is
passed to the host for syntax highlighting, execution, or other processing.

The content follows normal indentation rules:
- Indented under the directive
- Not parsed as UDON (no `|`, `:`, `!`, `;` interpretation)
- Dedented on output relative to the directive's indent level

### Inline Raw Content

For inline raw content, use `!{:kind: ...}`:

```
|p The response was !{:json: {"status": "ok", "count": 42}} as expected.
```

Inline raw uses brace-counting. The parser finds the closing `}` by counting
brace depth. Nested `{}` pairs are fine as long as they're balanced.

Examples:

```
; Works -- braces are balanced (even nested)
!{:json: {"key": "value"}}
!{:regex: [a-z]{3,5}}

; Fails -- unbalanced brace
!{:text: missing close {}

; Solution -- use block form for unbalanced braces
!:text:
  missing close {here
```

Raw content cannot be an attribute value directly--attributes are typed scalars.

### Triple-Backtick Escape (Freeform)

Triple-backticks break out of indentation sensitivity entirely.

**Opening backticks:**
- The indentation of ``` determines the block's structural parent
- Need not be at line start -- can follow other content
- Content after ``` on the same line is part of the freeform block

```
|element and here we go with ```
freestyling it!
no indent rules in here
```

|parent
  |child
    some content then ``` and now we're free
anything goes
back at column 0
    ``` ; closing ideally matches but not required
```

**Closing backticks:**
- Should match opening indent (preferred)
- Not strictly required -- first ``` at opening indent or less closes the block

Use this **only** when:
- Assembling files from multiple sources without indent control
- Working with broken tooling that can't maintain indentation
- The rare case where absolute positioning matters

Do not use triple-backticks as the default for code samples. Use `!:lang:`
for raw code blocks.

---

## Dynamics Extension

The `!` prefix enables evaluation and control flow. The specific dialect depends
on the host environment, with Liquid-style primitives as a common baseline.

### Inline Forms

All dynamic inline forms use `!{...}` with immediate disambiguation:

| Syntax | Form | Description |
|--------|------|-------------|
| `!{{expr}}` | Interpolation | Double-brace for value interpolation |
| `!{:kind: ...}` | Raw directive | Content is opaque, brace-counted |
| `!{directive ...}` | Directive | Content is parsed as UDON (can contain `|{...}`, `;{...}`) |

The second character after `!{` determines the form:
- `{` -> interpolation (`!{{...}}`)
- `:` -> raw directive with colon-wrapped label
- Otherwise -> directive with UDON parsing inside

Non-raw inline directives support nested UDON:
```
!{include |{em emphasized} content}
```

Note: This may change in future to prefer filter-based includes like
`!{{'file.un' | include}}` instead.

### Interpolation

```
|greeting
  Hello, !{{user.name}}!

|link :href !{{base_url}}/users/!{{user.id}}
```

Empty interpolation (`!{{}}`) is valid--the parser emits an Interpolation event
with empty expression content. The host decides how to handle it.

### Filters

```
!{{value | filter1 | filter2 arg}}

!{{name | capitalize}}
!{{date | format "%Y-%m-%d"}}
!{{items | first}}
!{{price | currency "USD"}}
```

### Interpolation in Typed Contexts (Implementation Notes)

**Implementation Status:** Interpolation in attribute values and element IDs is
not yet implemented in the parser. Currently, `!{{...}}` syntax in these
contexts is passed through as literal string content. This section describes
intended behavior.

When an attribute value is entirely an interpolation, the parser emits it as an
interpolation event. The resulting type is **unparsed**--the host must evaluate
it to determine actual type:

```
|div[!{{dynamic_id}}]
|link :href !{{computed_url}}
```

When interpolation is mixed with literal content, the value becomes a
multi-part string. All non-interpolation parts are treated as string segments,
even if they started parsing as numbers:

```
|div[prefix_!{{id}}_suffix]
|link :path !{{base}}/.config
|item[283!{{more}}]
```

**Parser implementation note:** Multi-part values emit as a sequence:
`ArrayStart`, then alternating `StringValue`/`Interpolation` events, then
`ArrayEnd`. If parsing began as a numeric type and hits interpolation, emit
accumulated content as `StringValue` instead.

### Expression Grammar

UDON adopts Liquid's intentionally simple expression grammar.

#### Operators

| Category | Operators | Notes |
|----------|-----------|-------|
| Comparison | `==` `!=` `<>` `<` `>` `<=` `>=` | `<>` is synonym for `!=` |
| Logical | `and` `or` | Right-to-left evaluation |
| Membership | `contains` | Substring or collection membership |

```
!if age >= 18
!if user.verified and user.subscribed
!if tags contains "featured"
```

#### What Expressions Cannot Do

- No parentheses
- No arithmetic (use filters)
- No ternary operator
- No negation operator (use `== false` or `!unless`)

#### Evaluation Order

Logical operators evaluate **right-to-left** with no precedence.

This differs from standard precedence (where `and` typically binds tighter than
`or`). The difference only affects expressions mixing both operators:

| Expression | Right-to-left (Liquid) | Standard precedence |
|------------|------------------------|---------------------|
| `false and true or true` | `false and (true or true)` -> **false** | `(false and true) or true` -> true |
| `true and false or true` | `true and (false or true)` -> **true** | `(true and false) or true` -> true |
| `false or true and false` | `false or (true and false)` -> **false** | `false or (true and false)` -> false |
| `true or false and false` | `true or (false and false)` -> **true** | `true or (false and false)` -> true |

To express `(a or b) and c`, use nested conditionals:

```
!if c
  !if a or b
    Content here
```

#### Truthiness

Only two values are falsy:
- `false`
- `nil` / `null`

| Value | Truthy? |
|-------|---------|
| `false` | No |
| `nil` / `null` | No |
| `\"\"` (empty string) | **Yes** |
| `0` | **Yes** |
| `[]` (empty list) | **Yes** |
| Everything else | **Yes** |

To test for empty values, use explicit comparison:

```
!if title != \"\"           ; Check non-empty string
!if items != empty        ; Check non-empty collection
!if value != blank        ; Check defined and non-empty
```

The `empty` keyword tests if a defined value is empty. The `blank` keyword
tests if a value is undefined OR empty.

### Control Flow

```
!if condition
  Content when true
!elif other_condition
  Alternative
!else
  Fallback

!unless condition
  Content when false

!for item in collection
  |card
    :title !{{item.name}}
    !{{item.description}}

!let local_var = expression
  Content using local_var

!include partials/header
```

**Parser implementation note:** Block directives use the same `raw` flag as
inline directives. The parser does not enumerate directive names--any name is
accepted. The only distinction is colon-wrapped syntax:
- `!:lang:` -> Raw block (raw=true)
- `!if`, `!for`, etc. -> Normal block (raw=false)

### Inline Control Flow

UDON does not currently support inline forms of control flow directives
(`!if`, `!for`, etc.). These remain block-level only, using indentation to
delimit scope.

Syntax for inline control flow (e.g., `!if{cond}{then}{else}`) is under
investigation but not yet specified.

### Key Insight: Indentation Eliminates Closing Tags

```
; UDON -- no closing tags needed
!if logged_in
  |greeting Welcome back!
!else
  |greeting Hello, guest!

; vs Liquid -- closing tags required
{% if logged_in %}
  <div class=\"greeting\">Welcome back!</div>
{% else %}
  <div class=\"greeting\">Hello, guest!</div>
{% endif %}
```

### Host-Specific Dialects

The `!` prefix is intentionally extensible. Hosts may provide:

- **Elixir**: `!{{@assigns.user}}`, EEx-style
- **Python**: `!{{context['user']}}`, Jinja-style
- **JavaScript**: `!{{props.user}}`, JSX-style

---

## Implicit References

### Class as Mixin

A class-only element (no element name) defines inheritable traits:

```
|.defaults
  :adapter postgres
  :host localhost
  :pool 5

|database[production].defaults
  :database prod_db
  :pool 20  ; Override
```

Classes also serve as lightweight classification even when no mixin is defined.

**Note:** The precise behavior for inheriting child elements and prose content
from mixins is not yet fully defined. Attribute inheritance (with override) is
clear; subtree inheritance semantics are still being refined.

### Multiple Inheritance

```
|.logging
  :log-level info

|.caching
  :cache-ttl 3600

|service[api].defaults.logging.caching
  :name api-server
```

Left-to-right application; later values override earlier (CSS cascade).

### ID Reference

Reference elements by identity:

```
|license[mit]
  MIT License
  Copyright 2025...

|project
  :name MyProject
  :license @[mit]    ; Reference by ID
```

**Two forms:**

`@[id]` -- Insert the entire element (structure and content):

```
|template[header]
  |nav
    |a :href / Home
    |a :href /about About

|page
  @[header]          ; Inserts the full |nav structure here
  |main ...
```

`:[id]` -- Merge only attributes from that element:

```
|.db-defaults[base-db]
  :adapter postgres
  :host localhost
  :pool 5

|database :[base-db] :database myapp_prod :pool 20
; Equivalent to: |database :adapter postgres :host localhost :pool 5 :database myapp_prod :pool 20
```

---

## Value Types

UDON uses **syntactic typing** -- the syntax determines the type, not value
sniffing.

### Type Table

| Syntax | Type | Examples |
|--------|------|---------|
| `"..."` or `'...'` | String | `"hello"`, `'world'` |
| Integer patterns | Integer | `42`, `1_000_000`, `0xFF`, `0o755`, `0b1010` |
| Decimal patterns | Float | `3.14`, `1_000.5`, `1.5e-3` |
| Rational pattern | Rational | `1/3r`, `22/7r` |
| Complex pattern | Complex | `3+4i`, `5i` |
| `true`, `false` | Boolean | (lowercase only) |
| `null`, `nil` | Nil | (both equivalent) |
| `[...]` | List | `[1 2 3]`, `[a b c]` |
| `:key` (no value) | Boolean `true` | Flag/presence semantics |
| Anything else | String | Unquoted text |

### Numbers

Numeric literals follow Ruby conventions: integers, floats, scientific notation
(`1e10`), hex (`0x`), octal (`0o`), binary (`0b`), explicit decimal (`0d`),
rationals (`1/3r`), and complex (`3+4i`). Underscores allowed for readability
(`1_000_000`).

```
42          1_000_000       ; Integers
3.14        1.5e-3          ; Floats
0xFF        0o755   0b1010  ; Hex, octal, binary
1/3r        3+4i            ; Rational, complex
```

**Note:** Plain `0755` is decimal `755` (leading zeros stripped, no implicit
octal). Use `0o755` for octal.

### Booleans

```
:enabled true     ; Boolean true
:debug false      ; Boolean false
:flag             ; Boolean true (missing value = true)
```

Lowercase only. `TRUE`, `True`, `FALSE` are strings.

### Nil

Two equivalent spellings:

```
:value null
:value nil
```

### Strings

```
:name "quoted string"       ; Explicit string
:name 'single quotes'       ; Also string
:desc unquoted text here    ; String (fallback)
:truthy "true"              ; String "true", not boolean
:number "42"                ; String "42", not integer
```

### Lists

```
:ports [8080 8443 9000]
:tags [api public internal]
:mixed [1 two 3.0 true]
:quoted ["hello world" foo bar]
:empty []
```

Each element is typed independently by the same rules.

### Absent vs Nil vs False

```
|config
  :debug              ; debug = true (flag present)
  :verbose false      ; verbose = false (explicit)
  :deprecated null    ; deprecated = nil (explicitly unset)
  ; timeout is absent (key doesn't exist)
```

These are distinct:
- **Absent**: Key not present at all
- **Nil**: Key present, value explicitly "no value"
- **False**: Key present, value is boolean false
- **True**: Key present with no value (flag) or explicit `true`

---

## Design Principles

### Attributes Before Children

```
|element[id].class :attr1 value1 :attr2 value2
  children here
```

Attributes must precede child content. No scattered attributes.

### Strict Whitespace

- Spaces only, no tabs
- Error on mixed indentation

### Streaming Parse

Support callback/event mode for incremental processing:
- Parse as data arrives (LLM streaming)
- Emit complete subtrees as they close
- Pause/resume with state preservation

---

## Examples

For additional authoring guidance, see `examples/practices-gotchas.udon` (in review).

### Configuration

```
|database[primary].postgres
  :host db.example.com
  :port 5432
  :pool 10
```

---

## Parser Naming Convention (Non-Normative)

Parser functions should use this terminology consistently:

| Old Name | New Name | Purpose |
|----------|----------|---------|
| `inline_attr` | `sameline_attr` | Attr on element line |
| `block_attr` | `block_attr` | Attr on own line (unchanged) |
| `bare_string` | `bare_string_block` | Block attr values |
| `bare_string_inline` | `bare_string_sameline` | Sameline attr values |
| (new) | `bare_string_embedded` | Embedded attr values |
| (new) | `bare_string_array` | Array item values |
| `inline_text` | `sameline_text` | Text on element line |
| `embedded` | `embedded` | `|{...}` (unchanged) |

---

## Test Cases (Non-Normative)

The examples in this document should be converted to unit tests. Key scenarios:

1. **Hierarchy tests** (from \"Hierarchy\" section):
   - Inline nesting equivalence
   - Sibling after inline elements
   - Column alignment = sibling
   - Child of inline element
   - Multi-line progression
   - Complex many-inline-elements
   - Closing multiple levels

2. **Prose dedentation tests** (from \"Automatic Prose Dedentation\" section):
   - Inline content freedom (multiple valid indent choices)
   - Nested inline elements with indented siblings
   - Inconsistent indentation warnings
   - Extra spaces preserved in output
   - Blank lines passed through
   - Freeform blocks preserve whitespace

3. **Comment tests** (from \"Comments and Indentation\" section):
   - Block comments trigger indent/dedent
   - Block comment at column 0 closes nested elements
   - Block comment within element stays within element
   - Inline comments `;{...}` stripped from output
   - Escaped semicolon `';` outputs literal semicolon

---

## Open Questions

1. **Quoted strings in arrays:** Do they follow the same rules as other typed
   values? Currently: quotes handled before bare_string dispatch.

---

## Implementation Notes (Non-Normative)

- Interpolation in attribute values and element IDs is not yet implemented in
  the parser; intended behavior is described in the Dynamics section.
- Raw directives and freeform blocks are parsed as specified, but host behavior
  (highlighting, execution, etc.) is host-defined.
