# UDON Grammar (The Parser's Domain)

**Universal Document & Object Notation** *Version 0.9.0-alpha.2 (Draft)*

This document specifies the mechanical parsing rules for UDON: how a stream of bytes is analyzed, how boundaries are determined, and how the document hierarchy is constructed via indentation. For the semantic meaning of the resulting structures, see [2-SPECIFICATION.md](2-SPECIFICATION.md).

---

## 1. Character Set and Core Lexer

UDON documents MUST be encoded in UTF-8. 

### 1.1 Structural Markers and Bounded Lookahead

The parser looks for specific marker characters that denote structure. UDON is designed for streamability; therefore, **Bounded Lookahead** is a language law. Each marker is recognized by a guard requiring only a few characters of lookahead.

At the **start of a line** (after indentation) or within the **sameline scan** (before prose begins), the parser operates in **head position**, where these markers are active:

- `|` : Element definition. (MUST be followed by an identifier character, `[`, `.`, `{`, `'`, or suffix `? ! * +`).
- `:` : Attribute assignment.
- `!` : Dynamics prefix. (MUST be followed by an identifier character or `:`).
- `;` : Comment prefix.
- `@` : Reference prefix. (MUST be followed by `[`, `.`, or an identifier).
- ``` : Triple-backtick fence.
- `\` : Prose escape (consumes itself and forces the rest of the line to be evaluated as prose).

If a marker character appears but fails its short lookahead guard (e.g., `| ` followed by a space), it is treated as ordinary prose text. 

**Phase-Restriction on `:`**  The attribute marker `:` is phase-restricted. It is only valid while the element has no child content yet. Once any text or child element has appeared for an element, that element enters its **content phase**. A subsequent line-initial `:` at an ancestor's column is parsed as Prose Content and emits a Warning.

### 1.2 The Bare-Token Boundary Rule

When parsing an unquoted value (a "bare token"), the parser must determine where the token ends. The boundary rule is:

1. A bare value token holds the scan open provisionally.
2. The parser looks at the *first non-space character* following the token.
3. If the character is a **block-form marker** (a new attribute `:`, a force-prose escape `\`, a fence ```, a block-form element `|name`, a block-form reference `@name`, a block-form dynamic `!name`, or a framed ` ; ` comment), the preceding token is closed as a **single-value token**, and parsing continues.
4. If the character is **anything else** (plain text or an inline brace form like `|{...}`), the line commits to being a **Prose Content sequence** that begins with the bare token and runs to the end of the line.

**The Inline-Brace Principle:** Inline brace forms (`|{...}`, `!{{...}}`, `;{...}`) are prose-level constructs. Encountering an inline brace at a bare-token boundary does *not* close the value token; it forces the value into a Prose Content sequence containing the brace form.

**Failed Numbers & Keywords at the Boundary:**
- If a token looks like a number but contains invalid characters (e.g., `12ab`), it falls through to being a normal bare token, and the boundary rule applies exactly as above.
- Keywords (`true`, `false`, `null`, `nil`) are only typed if the token finishes *alone* (followed by a block marker or EOF). If plain text follows, the keyword is simply the first word of a flow value (e.g., `:val true story` evaluates to the string `"true story"`).

### 1.3 Escapes and Semicolons

**The Escape (`\`) rules are strictly positional:**
- **At Head Position:** Consumes the `\` and forces the rest of the line to Prose Content. No markers (not even a framed sameline comment) are active on this line.
- **In Value-Expected Position:** Consumes the `\` and forces the value into a text flow (prose content), suppressing the framed sameline comment.
- **Before an Inline Opener:** Inside prose, a `\` immediately preceding `|{`, `!{`, or `;{` makes the opener literal.
- **Anywhere else:** The `\` is literal (e.g., in `C:\path`).

**Semicolons (`;`) and Comments:**
- **Line Comment:** At the Document Root, or after attribute values, opens a line comment.
- **Block Comment Continuation:** A block comment swallows structure until a dedent occurs. The first continuation line establishes the strip column, identical to the prose Content Base shape.
- **Sameline Comment:** A `;` framed by spaces on both sides (` ; `) after sameline prose opens a comment. If unspaced, it is literal text.
- **Inline Comment:** `;{...}` is the only comment form allowed *within* a text flow, requiring balanced braces. A bare `;` inside `|{...}` is literal.

---

## 2. Indentation and Hierarchy

UDON uses whitespace indentation to define parent-child relationships, mimicking a stack-based hierarchy.

### 2.1 The Column Rules

When a new structural element is encountered on a line, its leading indentation column determines its place in the hierarchy based on the rule:  **pop while new_column <= stack_top.base_column**

1. **Push (Child):** If `new_column > stack_top.column`, the element becomes a child of the current stack top, and is pushed onto the stack.
2. **Sibling (Same Level):** If `new_column == stack_top.column`, the current stack top is popped, and the new element is pushed as a sibling.
3. **Dedent (Pop):** If `new_column < stack_top.column`, the parser MUST repeatedly pop the stack while `new_column <= stack_top.column`, then push the new element as a child of the resulting stack top.

**Strict Whitespace:** Indentation MUST consist entirely of space characters. The presence of a tab (`\t`) character within leading indentation is an Error.

### 2.2 Inline Nesting Equivalence

Inline elements specified on a single line (e.g., `|parent |child |grandchild`) behave exactly as if they were written on separate lines at their respective columns. The stack accounts for their actual column positions. When a subsequent line begins, it evaluates its column against the stack precisely as if the inline elements had spanned multiple lines vertically.

---

## 3. Prose and Dedentation

Any line that does not start with a valid structural marker is treated as **Prose Content** belonging to the parent element.

### 3.1 Automatic Prose Dedentation

To allow readable formatting in the source without polluting the output text, UDON automatically strips leading whitespace from block prose.

1. The first indented line of a prose block establishes the `content_base_column`.
2. For all subsequent lines in that prose block, the parser MUST strip exactly `content_base_column` spaces from the beginning of the line.
3. If a subsequent line has *fewer* leading spaces than the `content_base_column` (but is still greater than the parent element's column), the parser MUST emit a Warning, update the `content_base_column` to this new lesser value, and continue parsing the line as prose.

*(Note: Material deeper than the `content_base_column` is in the prose interior. Markers encountered here are not at head position and are treated as literal text).*

---

## 4. Anomaly Posture

UDON employs a strict **keep-everything** philosophy. 

### 4.1 Warnings vs. Errors

- **Warnings:** Issued when the parser encounters malformed or surprising syntax, but can still confidently capture the bytes into the ADM. No data is lost.
- **Errors:** Issued when the parser encounters unrecoverable syntax violations (e.g., tabs in indentation). The parser emits the error but MUST continue parsing the remainder of the document; it does not halt.

### 4.2 End of Input (EOF) and Multi-Line Delimited Constructs

**Delimited Constructs MAY span multiple lines.** Interior newlines are treated as content for strings, lists, envelopes, and identity keys.

When the parser reaches the End of Input (EOF):
1. All **geometric constructs** (blocks, prose sequences bounded by indent) close silently.
2. Any **delimited construct** (strings, `<...>`, `[...]`, `|{...}`, `[...]` identity keys) that remains open MUST be forcibly closed. The parser MUST retain all captured content up to that point, and MUST emit a Warning indicating an unclosed construct. 

If a delimited construct was left open at EOF, the Host application MAY treat the resulting Document as "Incomplete."
