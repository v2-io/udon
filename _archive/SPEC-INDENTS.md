# UDON Indentation and Hierarchy

This document clarifies how UDON determines parent-child relationships through indentation, including the handling of inline elements.

## Core Principle

UDON's indentation works like Python's: column position determines hierarchy. The critical insight is that **inline elements on a single line are nested just as if they were on separate lines**, and the stack naturally tracks everything.

## Basic Rules

1. **Greater column = child** (push onto stack)
2. **Same column = sibling** (pop current, push as child of parent)
3. **Lesser column = dedent** (pop until column > top's base_column)

**The one rule:** `pop while new_column <= stack_top.base_column`

### ⚠️ THE RULE VISUALIZED ⚠️

This is a commonly misunderstood aspect of UDON indentation. The next line (the
one that indents) gets to choose how far to indent. From an indent of one space
vs the parent, through to (but including) the pipe for the next nested one.

```
|alpha |beta |theta
                    ;<- where to put |gamma depends on who you want it to be siblings with
                    ;   these comments are in fact children of |theta
 ▲     ▲▲    ▲ 
 │     │└──┬─┘ 
 └──┬──┘  sibling of theta
    │     (because indented from beta now instead of just alpha)
sibling of beta
```


```
|parent
  |child        ← column 2
  |sibling      ← column 2: SAME column = SIBLING of child, not inside it!
   |inside      ← column 3: ONE MORE column = INSIDE sibling
```

### The Python Perspective

If you understand Python's indentation, think of it this way: inline elements are
exactly as if they were on separate lines at those same columns.

```
|alpha |beta |c |d
```

Is exactly equivalent to:

```
|alpha
       |beta
             |c
                |d
```

Now placing `|e` on line 2 is just normal Python-style indent reasoning:
- Same column as `|beta` → sibling of `|beta`
- Between `|beta` and `|c` → child of `|beta`, sibling of `|c`
- Same column as `|c` → sibling of `|c`
- And so on...

The inline notation is just a compact way to write the vertical form. The column
positions are real and determine hierarchy exactly as if each element had its own line.

**To be INSIDE an element, you must be at column > element's column.**
**Same column == sibling instead of child**

---

## Examples

### Inline Nesting

```udon
|one |two |three  ; three is child of two, two is child of one
```

This is exactly equivalent to:
```udon
|one
     |two
          |three
```

Which is equivalent to:
```
|one
  |two
    |three
```

### Sibling After Inline Elements

```udon
|one |two |three
  |alpha          ; sibling of |two -- child of |one
```

Here `|alpha` at column 2:
- Stack has: `[one@0, two@5, three@10]`
- 2 ≤ 10? Yes, pop three
- 2 ≤ 5? Yes, pop two
- 2 ≤ 0? No, stop
- Push alpha as child of one

### Column Alignment = Sibling

```udon
|one |two |three
     |alpha       ; same as above -- sibling of |two, child of |one
```

`|alpha` at column 5 (same as `|two`):
- 5 ≤ 10? Pop three
- 5 ≤ 5? Pop two (same column = sibling!)
- 5 ≤ 0? No, stop
- Push alpha as child of one

### Child of Inline Element (Special Case)

```udon
|one |two |three
        |alpha   ; child of |two (sibling of |three)
```

`|alpha` at column 8 (between two and three, or at three's column):
- 8 ≤ 10? Pop three
- 8 ≤ 5? No, stop
- Push alpha as child of two

```udon
|one |two |three
          |alpha  ; same -- child of |two, sibling of |three
```

### Multi-line Progression

```udon
|one |two |three
       |alpha     ; child of |two
     |beta        ; sibling of |two (child of |one)
```

For `|alpha` at column 7:
- Pop three (7 ≤ 10)
- Stop at two (7 > 5)
- Push alpha as child of two

For `|beta` at column 5:
- Pop alpha (5 ≤ 7)
- Pop two (5 ≤ 5, same column = sibling)
- Stop at one (5 > 0)
- Push beta as child of one

---

## The Critical Insight

**You only care about the previous line's stack state.**

```udon
|one |two |three
  |alpha
     |beta      ; child of |alpha, NOT related to |two at all
```

From `|beta`'s perspective, the world looks like:
```udon
|alpha
   |beta
```

When `|alpha` appeared at column 2, it popped `|two` and `|three` off the stack. They're gone. The fact that `|beta` happens to align with where `|two` was is pure coincidence -- `|two` is long closed.

**The stack naturally handles everything.** No special "inline column tracking" is needed because inline elements are pushed with their actual columns, just as if they were on separate lines.

---

## Complex Example: Many Inline Elements

```udon
|a |b |c |d |e |f |g
         |child-of-c
   |child-of-a
```

Stack after first line: `[a@0, b@3, c@6, d@9, e@12, f@15, g@18]`

For `|child-of-c` at column 9:
- 9 ≤ 18 (g)? Pop
- 9 ≤ 15 (f)? Pop
- 9 ≤ 12 (e)? Pop
- 9 ≤ 9 (d)? Pop (same column!)
- 9 ≤ 6 (c)? No, stop
- Push as child of c

Stack now: `[a@0, b@3, c@6, child-of-c@9]`

For `|child-of-a` at column 3:
- 3 ≤ 9? Pop child-of-c
- 3 ≤ 6? Pop c
- 3 ≤ 3? Pop b (same column!)
- 3 ≤ 0? No, stop
- Push as child of a

This is exactly equivalent to:
```udon
|a
   |b
      |c
         |d
            |e
               |f
                  |g
         |child-of-c
   |child-of-a
```

---

## Closing Multiple Levels

```udon
|one
  |two
    |three
      |four
- this prose is sibling to |one
```

The prose at column 0 triggers:
- 0 ≤ (four's column)? Pop four
- 0 ≤ (three's column)? Pop three
- 0 ≤ (two's column)? Pop two
- 0 ≤ 0 (one)? Pop one
- Stop (stack empty or at root)

Three or four ElementEnd events fire in sequence.

---

## Style Recommendations

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

Both positions are technically valid siblings of `|two`, but mixing them is confusing.

---

## Implementation

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

No special cases. No inline column tracking arrays. The stack handles everything naturally because inline elements are pushed with their actual column positions.

---

## Automatic Prose Dedentation

UDON automatically strips leading whitespace from prose content based on its context within elements. This enables readable source formatting while producing clean output.

### The Rule

1. **Inline content** (same line as element) does NOT establish content_base
2. **First indented line** (line 2) establishes `content_base_column` - user chooses
3. **Subsequent lines at >= content_base**: no warning, extra spaces preserved in output
4. **Subsequent lines at < content_base** (but still within element):
   - Emit warning about inconsistent indentation
   - Update content_base to this new (lesser) column
   - Continue as content of same element

**Valid range for indented content:** between parent's `|`+1 (exclusive) and any inline child's `|` (inclusive).

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

The inline content (`**The great indent**`) has no leading space. The indented lines have their 2-space indent stripped.

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

The continuation lines are aligned with "This" (column 12). All 12 leading spaces are stripped.

### Valid Indentation Range

For prose after inline elements, valid columns are between the parent's `|` (exclusive) and the inline child's `|` (inclusive):

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

The first line was stripped of 6 spaces. When content_base dropped to 3, subsequent lines were stripped of only 3 spaces. The "four extra spaces" line preserves 4 spaces because 7 - 3 = 4.

### Streaming Behavior

Prose dedentation happens per-line as content is parsed:
- Each line is stripped of `content_base_column` spaces and emitted immediately
- If a line has fewer leading spaces than content_base, warn and update content_base
- Earlier lines may have been "over-stripped" compared to later lines
- **This is intentional**: the warning signals the inconsistency to the user

### Exception: Freeform Blocks

Triple-backtick (freeform) blocks preserve exact whitespace - no automatic dedentation:

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

**Inline content** (same line as element) is emitted directly without setting content_base:
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

## Comments and Indentation

Comments participate in the indent/dedent hierarchy, even though they produce no output.

### Block Comments

A line starting with `;` is a block comment. It **triggers indent/dedent behavior**:

```udon
|parent
  |child
   ; this comment is INSIDE |child (one space further right)
  ; this comment is SIBLING of |child (same column = sibling!)
    |grandchild
; this comment closes |grandchild, |child, AND |parent (column 0)
|sibling
```

The comment at column 0 causes three ElementEnd events before `|sibling` is parsed.

```udon
|element
  Some prose content
   ; comment inside |element - one column past the prose base
  More prose content
```

### Inline Comments

`;{...}` is an inline comment - the only way to comment within prose:

```udon
|p This is some text ;{TODO: improve this} and more text.
```

Output: `This is some text and more text.`

The inline comment is stripped from output but doesn't affect structure.

### Escaping Semicolons

To output a literal `;` at line start, use the escape prefix:

```udon
'; This line starts with a semicolon in the output
```

Output: `; This line starts with a semicolon in the output`

---

## Test Cases

The examples in this document should be converted to unit tests. Key scenarios:

1. **Hierarchy tests** (from "Examples" section):
   - Inline nesting equivalence
   - Sibling after inline elements
   - Column alignment = sibling
   - Child of inline element
   - Multi-line progression
   - Complex many-inline-elements
   - Closing multiple levels

2. **Prose dedentation tests** (from "Automatic Prose Dedentation" section):
   - Inline content freedom (multiple valid indent choices)
   - Nested inline elements with indented siblings
   - Inconsistent indentation warnings
   - Extra spaces preserved in output
   - Blank lines passed through
   - Freeform blocks preserve whitespace

3. **Comment tests** (from "Comments and Indentation" section):
   - Block comments trigger indent/dedent
   - Block comment at column 0 closes nested elements
   - Block comment within element stays within element
   - Inline comments `;{...}` stripped from output
   - Escaped semicolon `';` outputs literal semicolon
