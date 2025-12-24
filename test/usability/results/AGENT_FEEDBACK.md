# Agent Feedback on UDON

Aggregated feedback from test agents evaluating UDON syntax.
These insights come from agents asked to interpret or produce UDON.


---

**ID:** udon-invention-20251223-175942-47de4d03
**Task:** Invent notation: all constraints
**Model:** claude-haiku-4-5-20251001
**Time:** 2025-12-24T00:59:42Z

**FEEDBACK:**
# What I like about this approach:

1. **Indentation feels natural** for both data and documents. Python-like syntax
   is familiar to developers; non-developers find it readable.

2. **Mixed content works naturally** because `|` prose blocks can sit alongside
   structured elements. No awkward frontmatter separation. The document reads
   coherently.

3. **Attributes in parens** are lighter than angle brackets, reducing punctuation
   noise while remaining visually distinct from element names.

4. **No closing tags** but indentation makes nesting unambiguous—solves XML's
   verbosity without YAML's ambiguity at scale.

# Concerns & tradeoffs:

1. **Ambiguity with unquoted values**: How do you distinguish between
   `name=foo` (the symbol "foo") vs. `name="foo"` (the string "foo")?
   I punted by saying "alphanumeric = symbol" but this needs stricter rules.

2. **Attribute syntax proliferation**: I used both `()` for attributes and
   `[]` for ID/class. This mirrors HTML but feels inconsistent—should attributes
   and ID/class use the same delimiter?

3. **Lists are awkward**: I showed `{1.2, 0.43}` but indented children work
   better for readability. Should there be one canonical list syntax or both?

4. **Whitespace fragility**: Indentation-based parsing is brittle with copy-paste
   and display contexts (emails, forums, converted docs). YAML has this problem;
   did you solve it in UDON?

5. **Comments only at line level**: I disallowed inline comments (`//` mid-line)
   to simplify parsing. Is that acceptable, or do you need inline comments?

6. **Element names**: Should they be keywords (predefined) or user-definable?
   I treated them as user-definable, but real parsers might want a schema.

# Questions for UDON:

- How does UDON handle **mixed content** at the character level? (My `|` prefix
  feels ad-hoc.)
- Does UDON have a **schema layer**, or is it schema-free like JSON?
- How are **numeric types** (int vs. float vs. decimal) distinguished?
- Can attributes themselves contain structured data (nested objects), or only scalars?
```

---

**ID:** udon-enablement-20251223-180230-6187510c
**Task:** Enablement ideation
**Model:** claude-sonnet-4-20250514
**Time:** 2025-12-24T01:02:30Z

**FEEDBACK:**
I'm genuinely intrigued by the mixed content concept, but I worry about the complexity-to-benefit ratio. The examples shown are compelling, but real-world parsing edge cases could be brutal. I'd be curious to see how UDON handles deeply nested mixed content, attribute escaping, and error recovery. The success might depend heavily on having exceptional tooling from day one—syntax highlighting, validation, transformation tools, etc. Without that, even compelling use cases might founder on adoption friction.

Also wondering about performance characteristics—mixed parsing typically has higher overhead than pure structured formats. For high-volume agent-to-agent communication, this could matter.

---

**ID:** udon-invention-20251223-180316-65ddb409
**Task:** Invent notation: all constraints
**Model:** claude-haiku-4-5-20251001
**Time:** 2025-12-24T01:03:16Z

**FEEDBACK:**
# Observations

**Potential issues I'd flag:**

1. **Ambiguity risk**: If I write a bare word on a line, is it an element or a malformed attribute? Parser needs clear rules. Does `foo` without `:` or content declare an empty element, or is it an error?

2. **Attributes vs. elements**: In my example, `title: "Why Notation Matters"` looks like an attribute, but `section` looks like an element. They're syntactically identical (indented children). The distinction feels implicit rather than explicit. Is that acceptable? It might be—readers infer from context—but it's worth questioning.

3. **Text node priority**: I put prose first in some elements, attributes below. But could you mix them freely?
   ```
   review
     | Some text
     rating: 5
     | More text
     pros: [...]
   ```
   This looks like it should work but might confuse parsing. Need clear rules on ordering.

4. **Whitespace sensitivity**: Like Python/YAML, this is indentation-dependent. Copy-paste errors become syntax errors. Worth the cost for readability? Probably, but flag it.

5. **Missing: escaping and edge cases**. How do you represent a literal pipe `|` at the start of a line? How do you nest quotes? I didn't sketch this.

6. **List syntax**: Using `[item, item]` feels JSON-like. Given the rest is indent-based, should lists also be indent-based?
   ```
   pros:
     - lightweight
     - intuitive
   ```
   This might feel more consistent.

# Broader thoughts

- **The mixed content problem is real and underexplored.** Most notation designs punt on it. YAML has the `|` literal scalar, but it's clunky for interleaving prose and structure. HTML's approach (mixed content model) works but requires closing tags. Your design space here is genuinely interesting.

- **Unified notation is harder than it looks.** There are real tensions: configuration usually has shallow, wide structures; documents are deep and varied; data needs type clarity but documents care more about readability. No single syntax will feel equally natural for all three. Trade-offs are inevitable.

- **Identity/classification (@ and .) is well-chosen.** These are common needs and deserve first-class syntax.

- **I'd want to see how this handles:**
  - Deeply nested data structures (deeply nested objects/arrays)
  - Large prose passages
  - Edge cases (empty elements, null values, numeric keys)
  - Error messages (is the syntax forgiving or strict?)

---

I'm curious whether your UDON design converges on similar choices or diverges. The pipe-for-prose idea feels like a natural solution, but there might be better alternatives I haven't considered.

---

**ID:** udon-invention-20251223-180339-16e37a26
**Task:** Invent notation: all constraints
**Model:** claude-haiku-4-5-20251001
**Time:** 2025-12-24T01:03:39Z

**FEEDBACK:**
# Key Observations

**1. Mixed content is genuinely hard.** The moment you want prose + structure, traditional notations (JSON, YAML, XML) all struggle. Your goal #5 is the real constraint that shapes everything else. Most notation designs nail data OR documents, but not both. This suggests that if UDON solves this well, it's genuinely novel.

**2. Indentation-based structure has real costs.** It's easy to read but fragile to write and parse. Invisible whitespace bugs are severe. Consider: does UDON have explicit error messages for indentation mismatches, or do they silently create wrong structure? This is more critical than it seems.

**3. Attributes syntax is underspecified in my sketch.** I used `[key=value]` but didn't think through:
   - Quoted strings in attributes: `[title="My \"Book\""]`?
   - Complex values: `[config={nested: true}]`?
   - Ordering: does order matter? Should it?

   These details matter more than they look.

**4. The "identifier is optional" problem.** In `meta` and `article`, I'm assuming those are tag names. But in pure data context, is `{key: value}` represented as `key value`? Or `object [key=value]`? The notation needs to handle data without forcing semantic element names.

**5. Mixed content changes parsing priority.** In XML/HTML, everything is recursively structured. In my sketch, prose is "ambient"—it exists unless explicitly marked. This flips the parsing model. UDON would need clear rules: "Anything not recognized as an element name/syntax is prose by default"? Or "Prose is explicit and marked somehow"? The choice cascades through design.

**6. Lists need rethinking.** Inline lists `[a, b, c]` are easy. Hierarchical lists (like in my example) have unclear syntax. Are items just indented children? Named `item` children? Unnamed? If unnamed, how do you distinguish "arbitrary indented content" from "list items"?

# Questions for UDON Designers

- How do you handle **deeply nested attributes**? E.g., `function [params={x: int, y: int}, returns=bool]`?
- Does **prose have access to interpolation/templating**? (I used `{author}`, `{published}` in my footer—is that in scope?)
- How do you **visually distinguish** an element with no children from prose that happens to be a single word?
- What's the **error handling story**? Indentation is fragile; how do parsers report problems helpfully?

These aren't criticisms—just boundaries that clarify the design space.

---

**ID:** udon-invention-20251223-180357-240768e6
**Task:** Invent notation: all constraints
**Model:** claude-haiku-4-5-20251001
**Time:** 2025-12-24T01:03:57Z

**FEEDBACK:**
# Observations

1. **The core tension**: Indentation-based hierarchy is elegant but fragile at scale. Python solved this with code (where nesting is limited); documents can nest arbitrarily. I worried about:
   - Mixing indentation for prose vs. structure
   - Copy-paste errors with whitespace
   - Editor ambiguity (when should indent increase?)

2. **Attributes are awkward**: My `[id=... class=...]` syntax borrows HTML brackets but feels clunky. The colon-based key-value pairs are cleaner. I'd want to see how UDON handles this—there might be a more elegant approach.

3. **Mixed content is genuinely hard**: I added the `|` prefix for prose because without it, the parser can't tell if:
   ```
   This is text:
     or a key-value pair?
   ```
   Some marker felt necessary, but it adds visual noise. Did UDON solve this differently?

4. **Type inference trade-offs**: I made types implicit (unquoted numbers, bareword booleans) but this creates ambiguity. `key: true` vs `key: "true"` vs `key: true:` (value of true pointing to nested structure?) gets murky fast.

5. **Closing tag removal is deceptive**: No closing tags helps readability, but you pay for it with indentation-dependent parsing. It's a choice, not a free lunch—real question is whether the tradeoff is worth it for your use case.

6. **Comments are underdeveloped**: I put them at line level (`#`), but structured documents often need inline or block-level comments. Config files especially need "comment above the thing being configured."

# Questions I'd want to explore with UDON:

- How do you handle mixed prose/structure without a prefix marker?
- What's your rule for when something is prose vs. a key?
- Can you nest lists inside prose paragraphs, or do they require their own blocks?
- How do you disambiguate `key: value` (data) from `key: Prose text here`?
- Did you choose a different way to express attributes/metadata?

---

**ID:** udon-invention-20251223-180516-b1c94c10
**Task:** Invent notation: all constraints
**Model:** claude-opus-4-5-20251101
**Time:** 2025-12-24T01:05:16Z

**FEEDBACK:**
The hardest tension I encountered: making prose "natural" while keeping
structure unambiguous. My `>` marker feels slightly noisy but necessary—
without it, you can't tell if `@em important` means "em element with
attribute 'important'" or "em element containing text 'important'".

I'm skeptical that any notation fully solves mixed content elegantly.
The fundamental problem: you need *some* way to distinguish "this is
structure" from "this is text", and every choice has costs.

Alternative I considered: treating unrecognized words as text by default,
only `@known-elements` as structure. But this requires a schema, which
breaks the goal of general-purpose notation.

I'd be curious whether your UDON solution found a cleaner answer to the
prose/structure boundary problem.
```

---

**ID:** udon-invention-20251223-180621-0e596513
**Task:** Invent notation: all constraints
**Model:** claude-sonnet-4-5-20250929
**Time:** 2025-12-24T01:06:21Z

**FEEDBACK:**
This exercise immediately revealed the central tension: making prose
feel natural while keeping structure unambiguous. My instinct was to
make prose quoted, but that feels backward for a document-first format.

Alternative I considered: Make UNQUOTED text the default (prose), and
require some sigil for structural elements (maybe `:element-name` or
`@element`?). This would read better for document-heavy content but
worse for data-heavy content.

The "mixed content" requirement is genuinely hard. HTML solves it by
making everything an element (<p>, <em>, etc.), but that violates the
"no closing tags" requirement. YAML/JSON punt on it entirely.

I'm curious whether your UDON solution uses:
- A sigil to distinguish elements from prose
- A context-dependent parser (prose mode vs structure mode)
- Some kind of explicit mode switching
- Or something else entirely

The design space feels constrained enough that there might only be
2-3 viable approaches. Looking forward to seeing what you chose.

---

**ID:** udon-topic_enablement-20251223-191006-d1802bd1
**Task:** Topic enablement: Cognitive load
**Model:** claude-sonnet-4-5-20250929
**Time:** 2025-12-24T02:10:06Z

**FEEDBACK:**
# What I Appreciate:
- The **mixed content model** is genuinely thoughtful. Documents *are* often hybrid.
- **Inline elements** `|{em like this}` are more readable than XML/HTML for prose-heavy content.
- The **progressive disclosure** of complexity in the spec itself (flags, mixins, references) shows careful design.

# Skepticisms:

1. **Adoption barrier is brutal.** Every format needs tooling (editors, linters, renderers). UDON's complexity means significant investment before payoff. Markdown won, despite limitations, because it's trivial to parse and render.

2. **The "everything format" trap.** Trying to be good at data, documents, AND configuration means compromising on all three. JSON is simpler for data. Markdown is simpler for docs. TOML/YAML are simpler for config. The unified syntax advantage needs to be *much* stronger to justify the learning curve.

3. **Inline syntax ambiguity.** Consider: `|p See |{a :href /docs the docs} for details.` vs regular prose: "See the docs for details." The cognitive overhead of parsing `|{...}` syntax while reading is non-trivial.
