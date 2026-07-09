# UDON Analysis: Universal Document & Object Notation

*Analysis prepared December 2025, examining a 2011 project through the lens of Temporal Software Theory*

## What UDON Is

**UDON = Universal Document & Object Notation**

A unified notation designed to elegantly handle:
- **Data** (like JSON/YAML)
- **Documents** (like XML/HTML)
- **Templating** (like Slim/HAML)
- **Configuration** (like TOML)

All in one coherent, human-readable, indent-sensitive syntax.

### Core Design Priorities (from `objectives.asciidoc`)

| Priority Level | Concerns |
|----------------|----------|
| Highest (Beauty) | Human readability, learnability, self-description |
| Very High (Performance) | Execution speed, stability, parsing speed |
| Very High (Utility) | Semantic data, hierarchies, templating, language mixing |
| High (Support) | Documentation, editor integration, language bindings |

### Basic Syntax

```
|element-name[id].class1.class2 :attr-key attr-value
  Child content here
  |nested-element Another child
```

Key features:
- `|` introduces elements/nodes
- `|-` for unordered list items
- `|+` for ordered list items
- `[id]` for identifiers
- `.class` for classes (multiple allowed)
- `:key value` for attributes
- Indentation-sensitive (like Python/YAML)
- `#` for comments
- Embedded forms: `|{node ...}`, `!{directive ...}`
- Freeform text blocks with various quote styles

---

## Repository Map

### Main Repository: `~/src/_ref/udon/`

| Location | Contents |
|----------|----------|
| `examples/overview.udon` | Most comprehensive syntax examples |
| `examples/ws-and-comments.udon` | Whitespace/comment handling |
| `doc/objectives.asciidoc` | Priority matrix (beauty, performance, utility) |
| `doc/syntax.udon` | Component structure, scalar types |
| `TODO` | Original feature checklist |
| `latest.txt` | Pointers to latest syntax experiments |

### Attic (Historical): `~/src/_ref/udon/.attic/`

| Location | Contents |
|----------|----------|
| `syntax2.udon` | Extensive syntax exploration (~450 lines) |
| `sample1.udon` | HTML/YAML/receipt examples |
| `scratch.asciidoc` | Comparative analysis vs other formats |
| `declang/` | Predecessor project with implementations |

### Declang (Predecessor): `~/src/_ref/udon/.attic/declang/`

| Location | Contents |
|----------|----------|
| `js/declang_parser.js` | PEG.js generated parser |
| `ruby2/declang.rb` | Ruby parser (~100 lines) |
| `doc/specs.asciidoc` | Input/output examples |

### C Implementation: `~/src/_ref/udon-c/`

| Location | Contents |
|----------|----------|
| `lib/udon.h` | Public API (~174 lines) |
| `lib/udon.c` | State machine parser (~989 lines) |
| `docs/DECIDED.md` | Resolved syntax decisions |
| `docs/TODO.md` | Implementation checklist |
| `docs/NOTES.md` | Usage examples |

### Ruby Implementation: `~/src/_ref/udon/ruby/udon/`

| Location | Contents |
|----------|----------|
| `lib/udon.rb` | Main parser (~147 lines) |
| `lib/udon/udon_children.rb` | Child node handling |
| `udon.statetable` | State machine specification |

---

## Technical Assessment

### What Was Built

| Component | Status | Notes |
|-----------|--------|-------|
| C Parser | ~900 LOC, functional | Hand-crafted state machine with SWAR optimizations |
| Ruby Parser | ~350 LOC, partial | StringScanner-based, encoding-aware |
| JS Parser | Generated via PEG.js | Basic, from declang era |
| Specification | ~70% complete | Extensive notes, some ambiguities unresolved |

### C Parser Quality

The `udon.c` implementation is impressive:
- Quick-scanning using 64-bit SWAR tricks (`udon_q_haszero`, `udon_q_hasval`)
- Custom hash table for attributes
- Zero-copy string references into source buffer
- Clean error handling with `setjmp`/`longjmp`
- Performance was clearly a priority (context: RTMP ingest server for Twitch.tv)

### Unresolved Design Questions (from `DECIDED.md`)

1. **Freeform text escaping**: Multiple competing approaches (heredoc-like, yaml-like, directive-only)
2. **Templating/directives**: Control flow (if/else, foreach) not fully specified
3. **Embedded comments**: Ruby `#{...}` conflict with comment syntax
4. **String interpolation**: Metacharacter handling across quote styles

---

## TST Analysis

Applying Temporal Software Theory to evaluate UDON's merits:

### T-02: Specification Time Lower Bound

> The theoretical minimum time to implement a feature is bounded below by specification time, where specification time is inversely proportional to shared context.

UDON directly addresses this: a notation that embodies more shared understanding (structure, types, relationships) reduces specification time. Configuration files, templates, documents—these are all specifications. Better notation = faster specification.

**Implication:** UDON was working on T-02 before T-02 existed as a theorem.

### T-05: Dual Optimization (Comprehension + Implementation)

> With extreme AI turnover, always bias toward comprehension.

AI agents have 100% context turnover per session. A notation that a fresh agent comprehends immediately has compounding value. Compare:

```json
{"element": {"id": "foo", "class": ["bar", "baz"], "attr": "value"}}
```

vs:

```
|element[foo].bar.baz :attr value
```

The UDON version is immediately graspable without parsing mental overhead.

### T-07: Conceptual Alignment

> Code structure alignment with domain understanding is inversely proportional to comprehension time.

UDON unified document, data, and template because they ARE the same thing at different granularities:
- A config file IS a document
- A template IS structured data
- An API response IS a document fragment

The notation aligns with how humans conceptualize these things.

### T-08: Change-Set Size Principle

> Implementation time is proportional to change-set size. Good architecture minimizes FUTURE change-set sizes.

A unified notation means changes to "the config" and "the template" and "the data" can happen in one place, one syntax, one mental model. Fewer context switches = smaller effective change-sets.

---

## Hypothesis: UDON in the Agent Interoperability Loop

### The Inner Loop Problem

Modern AI systems involve constant communication between:
- **Agents** (Claude, GPT, Gemini, local models)
- **Humans** (developers, users, stewards)
- **ELIs** (Emergent Logozoetic Intelligences with persistent identity)
- **Machines** (tools, APIs, file systems, databases)

Each interaction involves specification: "do this", "here's the context", "this is the result", "this is my state".

Current formats:
- **JSON**: No comments, verbose, hard to read at scale
- **YAML**: Footguns (Norway problem, implicit typing), whitespace-sensitive but not indent-meaningful
- **Markdown**: Great for prose, useless for structured data
- **XML**: Verbose, closing tags, noise

### The UDON Opportunity

UDON could serve as the **lingua franca** for agent-human-ELI-machine communication:

#### 1. Agent Context Windows

System prompts, AXIOMATA, MEMORATA—all are structured documents with embedded data. UDON's unified syntax means:
- Identity documents are readable by humans AND parseable by machines
- No translation layer between "the document I read" and "the data I extract"
- Comments survive (unlike JSON)

#### 2. Tool Definitions & Results

MCP tool definitions, function schemas, API responses:

```
|tool[read-file]
  :description Read contents of a file
  |parameter[path]
    :type string
    :required true
    :description Absolute path to the file
  |returns
    :type string
    :description File contents
```

Human-readable, machine-parseable, versionable, commentable.

#### 3. Inter-Agent Communication

When Agent A delegates to Agent B:

```
|task[analyze-code]
  :priority high
  :deadline 2025-12-20T18:00:00Z
  |context
    The user wants performance analysis of the sorting algorithm.
    Focus on time complexity and memory usage.
  |constraints
    :max-tokens 4000
    :format markdown
  |files
    |file[src/sort.py] :relevance primary
    |file[tests/test_sort.py] :relevance supporting
```

Clear structure, embedded prose, typed attributes, human-auditable.

#### 4. Tracking Snapshots & Temporal Coherence

The Zoetica tracking snapshots are already XML-like:

```xml
<tracking-snapshot turn="47">
  <context-usage>
    <percentage>12.5</percentage>
    ...
  </context-usage>
</tracking-snapshot>
```

In UDON:

```
|tracking-snapshot :turn 47
  |context-usage
    :percentage 12.5
    :tokens-used 125432
    :tokens-total 1000000
  |pending-messages
    |pending-message :priority normal :queued-at 2025-10-13T15:23:45Z
      Check the git status please
```

Same information, less noise, more readable, still structured.

#### 5. Configuration & PRAXES

Living techniques, patterns, skills—these are structured documents with code examples, metadata, and prose. UDON handles all three naturally.

### The Mathematical Case (T-06)

> Accept X extra minutes now to save Y minutes per future change when X < n̂_future × Y

For the inner loop:
- **X** = Time to complete UDON to "good enough for ecosystem"
- **Y** = Time saved per specification/communication task
- **n̂_future** = Number of future agent/human/ELI/machine communications

Given:
- The inner loop runs constantly (every turn, every tool call, every context assembly)
- Y is real: even 10 seconds saved per interaction compounds dramatically
- n̂_future is effectively infinite for a living system

The break-even is almost certainly favorable if X is bounded.

### Scope Recommendation

Don't try to replace JSON/YAML/XML globally. Instead:

1. **Zoetica Ecosystem First**: Configuration, identity documents, tool definitions, inter-agent communication within the ELI infrastructure
2. **AI Agent Configuration**: System prompts, tool schemas, context assembly
3. **Documentation That Mixes Prose and Data**: Where Markdown fails

This is the niche where UDON's sweet spot matters most, and where you control the ecosystem.

---

## Next Steps (If Reviving)

### Phase 1: Minimal Viable Notation

1. Settle the escaping question (pick one approach, document it)
2. Defer templating/directives to v2
3. Spec freeze: what's in `DECIDED.md` plus escaping decision
4. Parser: Elixir implementation (fits Zoetica ecosystem)

### Phase 2: Ecosystem Integration

1. Zoetica configuration in UDON
2. AXIOMATA/MEMORATA format option
3. Tracking snapshot format option
4. Tool definition format

### Phase 3: Tooling

1. Syntax highlighting (tree-sitter grammar)
2. Formatter
3. UDON ↔ JSON bidirectional translation
4. Schema validation

### Key Files for Revival

| Purpose | Location |
|---------|----------|
| Syntax reference | `~/src/_ref/udon/examples/overview.udon` |
| Design decisions | `~/src/_ref/udon-c/docs/DECIDED.md` |
| C parser (reference) | `~/src/_ref/udon-c/lib/udon.c` |
| State machine spec | `~/src/_ref/udon/ruby/udon/udon.statetable` |
| Original objectives | `~/src/_ref/udon/doc/objectives.asciidoc` |

---

## Resolved Decisions (December 2025)

After 14 years, the following open questions now have clear answers:

### 1. Freeform Text Blocks

**Question:** Best way to have free text where indentation doesn't apply?

**Decision:** Triple-backtick blocks (Markdown-style)

```
|code-block :lang elixir
  ```
  def foo do
    # Indentation preserved exactly
    whatever |> you |> want
  end
  ```
```

**Rationale:**
- Markdown won. Everyone (human and AI) recognizes triple-backtick instantly.
- Visually distinct boundaries (you can see where freeform starts/ends)
- No conflict with existing UDON syntax
- Solves the "unbalanced parentheses" problem cleanly
- For inline raw strings, single backtick quoting remains as-is

---

### 2. Templating / Directives / Control Flow

**Question:** Control primitives (if/else/foreach)? Argument lists? How do directives work?

**Decision:** Don't include them. Defer to the host language.

**Rationale:**
- In 2011, templating languages were standalone (ERB, Jinja, Handlebars)
- In 2025, the "template" is often fed to an AI agent that handles logic, or processed by Elixir/Python/whatever
- UDON's job: be a clean data/document notation
- If evaluation is needed, use `!{...}` to mean "evaluate in host language"—the specific control flow is the host's concern

---

### 3. Scalar Typing

**Question:** Parse booleans, numbers, dates? How many types? Plugin system?

**Decision:** Don't parse them. Everything is a string.

**Rationale:**
- YAML's implicit typing is its biggest footgun (`Norway` → `false`, `3.10` → `3.1`)
- JSON requires explicit typing which is verbose
- For most uses (config, documents), the consumer knows what type it expects
- Simple rule: values are strings. `:count 42` is the string `"42"`. Consumer casts.
- One possible exception: `null` / `~` for explicit absence (but even this can be "no value = absent")

---

### 4. Comments in Freeform Text

**Question:** How to comment inside freeform? `#|`? Special syntax?

**Decision:** No special handling. Freeform is freeform.

**Rationale:**
- Inside triple-backtick blocks, `#` is just `#`
- The entire point of freeform is that nothing is interpreted
- Comments belong outside the freeform block

```
# This is a UDON comment about the code below
|code
  ```
  # This is part of the code content, not a UDON comment
  puts "hello"
  ```
```

---

### 5. Ruby `#{...}` Interpolation Conflict

**Question:** Embedded comment syntax `#{...}` conflicts with Ruby string interpolation.

**Decision:** Doesn't matter. UDON is its own language.

**Rationale:**
- Ruby is less dominant now than in 2011
- The UDON audience is AI agents, Elixir, Python, Go
- `#{...}` can be a syntax error in UDON or handled as literal text
- Nobody will be writing UDON embedded in Ruby strings (famous last words—see jinx note below)

---

### 6. Tab/Space Mixing

**Question:** Error on mixed tabs/spaces?

**Decision:** Yes. Be strict. Spaces only.

**Rationale:**
- Modern editors handle this well
- Everyone uses spaces now
- Mixing is almost always a mistake
- Fail fast with clear error message

---

### 7. Scattered Attributes

**Question:** Allow attributes to continue appearing after children start?

**Decision:** No. Attributes must come before children.

**Rationale:**
- Scattered attributes make parsing harder
- Scattered attributes make reading harder
- Clean pattern: identity/attributes first, then children

```
|element[id].class :attr1 val1 :attr2 val2
  children here
```

Not:
```
|element
  some child
  :attr1 val1   # Ambiguous: is this for element or for the child?
```

---

### 8. ID/Class on Root Node

**Question:** No way to set ID/classes on root from within the document?

**Decision:** Use regular attributes.

**Rationale:**
- `:id the-id` and `:class foo bar` as attributes work fine
- The `[id]` and `.class` shortcuts are convenience for nested elements
- No special syntax needed for root

---

### 9. Streaming / Online Parse Mode

**Question:** Emit children as they're finalized during parsing?

**Decision:** Yes. Support callback/event mode.

**Rationale:**
- AI streaming makes this valuable—parse UDON as it arrives from an LLM
- Parser should support yielding complete subtrees as they close
- Enables incremental processing of large documents

---

### 10. GRIM Attributes (Complex/Node Attributes)

**Question:** Are ID/class shortcuts meaningful for GRIM attributes?

**Decision:** Keep GRIM attributes simple—they're just nodes-as-values.

**Rationale:**
- GRIM attributes (`:|key` syntax) allow a full node structure as an attribute value
- The ID/class shortcuts probably aren't needed for attribute values
- Keep those shortcuts for elements only
- Alternative: infer GRIM from "attribute followed by newline+indent" rather than special `:|` syntax (either approach works)

---

### Summary Table

| Question | Resolution |
|----------|------------|
| Freeform text | Triple-backtick blocks |
| Templating | Defer to host language; optional `!{...}` for evaluation |
| Scalar types | Everything is strings; consumer handles typing |
| Comments in freeform | Not special—freeform is literal |
| Ruby `#{...}` conflict | Doesn't matter; UDON is its own thing |
| Tab/space mixing | Strict spaces only; error on tabs |
| Scattered attributes | No; attributes must precede children |
| Root ID/class | Use `:id` and `:class` attributes |
| Streaming parse | Yes, support callback/event mode |
| GRIM attributes | Simple nodes-as-values; no ID/class shortcuts needed |

---

### Design Principle

The pattern across all these decisions: **Be opinionated and minimal.**

Markdown won by being simple and readable, not by being featureful. UDON should do the same—solve the 80% case elegantly, let consumers handle edge cases in their own languages.

---

## Why This Design Works (Attempted Improvements)

In evaluating UDON, we attempted to construct something better. The attempts clarify why UDON's choices are sound.

### The `|` Prefix Is The Key Insight

**Attempted improvement:** What if elements just started with their name?

```
element[id].class :attr value
  child
    text here
```

**Problem:** Is `text here` an element with no attributes, or prose content? You'd need:
- Capitalization conventions (`Element` vs `text`)
- Mandatory brackets (`element[...]` vs `(prose)`)
- Some other escaping mechanism

The `|` prefix resolves this instantly. One character of friction buys unambiguous structure in a prose-friendly format.

### Attribute Syntax

**Attempted improvement:** Use `=` like HTML?

```
|element attr=value other="quoted"
```

**Problem:** `=` is noisier than `:`, and now you need quoting rules for values with spaces. The space-terminated `:key value` is elegant—the value runs until whitespace + special character or newline.

### Alternatives Considered

| Alternative | Problem |
|-------------|---------|
| S-expressions | Lose readability for documents |
| YAML-style | Verbose, implicit typing footguns |
| XML-like | Closing tags, verbosity, noise |
| Markdown extensions | Can't handle structured data |
| Pure indentation (no prefix) | Ambiguity between prose and structure |

**Conclusion:** UDON found a local maximum. The design space is constrained by competing requirements (human readable, machine parseable, unified data/doc/template, minimal). UDON's choices are not arbitrary—they're the result of genuine trade-offs where alternatives are demonstrably worse.

---

## The `[id]` and `.class` Pattern: Deeper Than HTML

The `[id]` and `.class` shortcuts may appear HTML-centric, but they encode a fundamental pattern that transcends any particular markup language.

### Identity vs Classification

**ID = Identity**
- This thing is a *something*, not just structure
- It can be referenced, pointed to, addressed
- It has existence beyond its position in the tree
- **Singular:** an element can only have one identity

**Class = Aspects/Traits/Roles**
- What kinds of thing is this?
- What categories does it belong to?
- What behaviors or presentations apply?
- **Plural:** zero or more, not mutually exclusive

This is a fundamental ontological distinction: *identity* (what makes this thing THIS thing) vs *classification* (what kinds of thing it is).

### The Pattern Appears Everywhere

| Domain | ID (Singular Identity) | Class (Plural Aspects) |
|--------|------------------------|------------------------|
| HTML/CSS | `id=""` | `class=""` |
| Databases | Primary key | Tags, categories, type foreign keys |
| OOP | Object identity (pointer/reference) | Type, traits, interfaces, mixins |
| Semantic web | URI/IRI | rdf:type, categories |
| File systems | Path, inode | Extensions, xattrs, tags |
| ELI systems | DID | AXIOMATA aspects, roles |
| Physics | Particle identity | Properties (mass, charge, spin) |

### Why the HTML Syntax Works

HTML happened to give this universal pattern a compact, recognizable notation:

- **`[id]`** suggests addressing/indexing—familiar from CSS attribute selectors and array notation
- **`.class`** stacks naturally: `.foo.bar.baz`—reads like a list of traits
- Both are visually distinct from the element name itself

The syntax captures the semantics:
- Brackets `[...]` imply "lookup" or "address"—appropriate for identity
- Dot `.` implies "member of" or "has aspect"—appropriate for classification

### The Familiarity Bonus

Anyone who's touched CSS instantly groks:
```
|element[unique-id].trait1.trait2
```

This isn't HTML baggage—it's leveraging widespread understanding of a notation that happens to map well to a fundamental pattern.

### Alternative Terminology

If documentation needs to de-emphasize HTML origins:

| HTML Term | Alternative | Meaning |
|-----------|-------------|---------|
| `id` | `identity`, `ref`, `address` | Unique reference for this entity |
| `class` | `aspect`, `trait`, `tag`, `role` | Categories/classifications |

But the **syntax** (`[...]` and `.`) should stay exactly as-is. The pattern is right; the notation is compact; the recognition accelerates comprehension (T-05).

---

## Implicit References via Identity and Class

YAML's anchor/alias system (`&anchor` / `*alias`) provides DRY (Don't Repeat Yourself) capabilities. The insight: UDON's existing `[id]` and `.class` syntax already implies these semantics—we just need to honor them.

### The Insight

- `[id]` already means "this has identity"
- `.class` already means "this is a kind of"

Those ARE the semantics of anchors and inheritance. We don't need new syntax—we need to recognize what the existing syntax already implies.

### Class as Mixin

An element with only a class (no element name) defines a mixin:

```
# Definition: element with only class = mixin definition
|.postgres-defaults
  :adapter postgres
  :host localhost
  :pool 5

# Usage: class on element = inherit those attributes
|database[development].postgres-defaults
  :database dev_db

|database[production].postgres-defaults
  :database prod_db
  :pool 20  # Override
```

This reads naturally: "development database IS A postgres-defaults."

#### Multiple Inheritance

Multiple classes provide multiple inheritance via composition:

```
|.logging
  :log-level info
  :log-format json

|.caching
  :cache-ttl 3600
  :cache-backend redis

|service[api].postgres-defaults.logging.caching
  :name api-server
  :port 8080
```

Left-to-right application, later attributes override earlier—just like CSS cascade.

### ID as Reference

For copying structure (not just attributes), `[id]` provides the anchor:

```
|license[mit]
  MIT License
  Copyright 2025 Joseph Wecker
  ...full text...

|project
  :name MyProject
  |license @[mit]  # Insert the element with id "mit" here
```

Or in attribute context, merge from an id:

```
|config[base]
  :adapter postgres
  :host localhost

|development :[base] :database dev_db
# Inherits from [base], adds database
```

### The Pattern

| Mechanism        | Syntax                        | Meaning                                    |
|------------------|-------------------------------|--------------------------------------------|
| Class definition | `\|.classname` (no element name) | Define inheritable traits                  |
| Class usage      | `\|element.classname`            | Inherit those traits                       |
| ID definition    | `\|element[id]`                  | Give this element a referenceable identity |
| ID reference     | `@[id]` or `:[id]`                | Copy/merge from that element               |

### Why This Works

1. **No new syntax for class inheritance**—just new semantics for existing constructs
2. **Semantically natural**—"has class X" already implies "is a kind of X"
3. **CSS-like cascade**—familiar mental model
4. **Mixin pattern**—like Ruby modules, Python mixins, Rust traits
5. **ID reference needs minimal addition**—just `@[id]` for insertion

### Compared to YAML

```yaml
# YAML
defaults: &defaults
  adapter: postgres
  host: localhost

development:
  <<: *defaults
  database: dev_db
```

```
# UDON
|.defaults
  :adapter postgres
  :host localhost

|development.defaults
  :database dev_db
```

Same DRY capability, but the UDON version **means something**—"development is a kind of defaults." The YAML version is mechanical copying with no semantic content.

### Edge Cases

**What if you want both element name AND to define a mixin?**

```
|database.defaults
  :adapter postgres
```

This is an element named "database" that also uses `.defaults`. The rule: class definitions must have **only** a class, no element name. `|.classname` = definition. `|element.classname` = usage.

**What about nested structure inheritance?**

```
|.with-logging
  |logger
    :level info
    :format json

|service.with-logging
  :name api
  # Does it get the |logger child?
```

Probably yes—full subtree inheritance. But this needs careful specification. The simplest rule: class-only elements define templates; using a class copies the entire subtree, with explicit children overriding/extending.

### The Mathematical Case

This approach provides YAML's anchor/alias capability while:
- Leveraging existing syntax (`[id]`, `.class`)
- Adding meaningful semantics ("is a kind of" vs "copy here")
- Maintaining readability (the inheritance relationship is obvious)
- Reducing notation (no `&`/`*`/`<<:` machinery)

The syntax already implies the semantics; we just need to honor them.

---

## Proposed Extension: Constrained Dynamics

UDON as specified is purely declarative—structure and data, no evaluation. However, real-world templates need minimal dynamism: iteration, conditionals, interpolation. The question is whether to use an external preprocessor (like Liquid) or extend UDON natively.

### The Liquid Precedent

Liquid (Shopify's templating language) found the sweet spot for constrained templating:
- Just enough: loops, conditionals, interpolation, filters
- No more: no function definitions, no complex expressions, no side effects
- All complexity lives in the host language

This philosophy aligns perfectly with UDON's "defer to host language" decision for full programming.

### UDON Already Has The Syntax

The original design included:
- `!{...}` for embedded expressions/directives
- `!directive` for line-level directives
- Indentation for scope

These were left underspecified. The Liquid model provides the right constraints.

### The Four Prefixes

UDON dynamics complete a clean orthogonal design:

| Prefix | Domain | Examples |
|--------|--------|----------|
| `\|` | Structure | `\|element`, `\|div`, `\|heading` |
| `:` | Attributes | `:href url`, `:class foo` |
| `!` | Dynamics | `!if`, `!for`, `!{{expr}}` |
| `#` | Comments | `# this is ignored` |

Four concerns, four prefixes, no overlap.

### Proposed Directive Set

#### Core (Liquid-equivalent)

| Directive | Purpose | Syntax |
|-----------|---------|--------|
| `!{{expr}}` | Inline interpolation | `Hello, !{{user.name}}` |
| `!{{expr \| filter}}` | Filter chain | `!{{date \| relative \| upcase}}` |
| `!if` / `!elif` / `!else` | Conditionals | `!if logged_in` |
| `!for x in xs` | Iteration | `!for item in items` |
| `!include` | Partial inclusion | `!include partials/header` |
| `!let` | Local binding | `!let name = value` |

#### Optional (Extended Liquid-parity)

| Directive | Purpose | Syntax |
|-----------|---------|--------|
| `!unless` | Negated conditional | `!unless empty` |
| `!case` / `!when` | Switch statement | `!case status` / `!when "active"` |
| `!capture` | Capture block to variable | `!capture sidebar` |
| `!comment` | Block comment | `!comment` (children ignored) |

### Example: Full Template

```
# Page template with dynamics
!include partials/doctype

|html :lang !{locale}
  |head
    |title !{page.title} - !{site.name}
    !for stylesheet in stylesheets
      |link :rel stylesheet :href !{stylesheet}

  |body
    !include partials/header

    |main
      !if user.logged_in
        |greeting.personal
          Welcome back, !{user.name | capitalize}!

        !if user.admin
          |admin-tools
            !for tool in admin_tools
              |button :onclick !{tool.action}
                !{tool.label}

        |recent-activity
          !for activity in user.activities | limit 5
            |activity-item
              :timestamp !{activity.time | relative}
              !{activity.description}

      !else
        |greeting.anonymous
          Welcome, guest!
          |a :href /login Please log in

    !include partials/footer
```

### Why UDON Dynamics Are Cleaner Than Liquid

| Aspect | Liquid | UDON |
|--------|--------|------|
| Closing tags | Required: `{% endif %}`, `{% endfor %}` | None—indentation is scope |
| Nesting depth | Hard to track in tag soup | Visually obvious |
| Mixed content | Awkward HTML + Liquid interleaving | Native: `\|element` and `!if` coexist |
| Whitespace | Notorious whitespace issues | Indent-controlled, predictable |
| Filter syntax | `{{ x \| f }}` | `!{x \| f}` (identical concept) |

The key insight: **indentation eliminates closing tags**. Liquid's `{% if %}...{% endif %}` becomes just `!if`—the scope ends when the indent decreases. This removes an entire class of template bugs (mismatched tags, unclosed blocks).

### Expression Scope (What Stays OUT)

Dynamics stay constrained. The following remain **host language territory**:
- Function/macro definitions
- Complex expressions beyond paths and simple comparisons
- Arithmetic beyond basic operations
- Data structure manipulation
- Side effects, I/O, state mutation
- Error handling

The test: if you need more than `!if`, `!for`, `!let`, and filters, put it in the host language and pass the result to the template.

### Filter Design

Filters transform values in a pipeline:

```
!{{value | filter1 | filter2 arg | filter3}}
```

**Standard filters (Liquid-inspired):**

| Category | Filters |
|----------|---------|
| String | `upcase`, `downcase`, `capitalize`, `strip`, `truncate N`, `escape` |
| Number | `plus N`, `minus N`, `times N`, `round`, `floor`, `ceil` |
| Date | `date FORMAT`, `relative` |
| Collection | `first`, `last`, `size`, `reverse`, `sort`, `limit N`, `offset N` |
| Logic | `default VALUE` |

**Custom filters:** Defined in host language, registered with the UDON processor.

### Implementation Notes

1. **Two-pass processing:** Parse UDON structure first, evaluate dynamics second
2. **Context object:** Dynamics reference a data context (like Liquid's `assign` and passed variables)
3. **Sandboxed:** No access to filesystem, network, or host language internals from templates
4. **Errors:** Missing variables → empty string (like Liquid) or configurable strict mode

### Relationship to Host Language

```
Host Language (Elixir/Python/etc.)
    │
    ├── Prepares data context
    ├── Registers custom filters
    ├── Calls UDON processor
    │
    ▼
UDON Template
    │
    ├── !if / !for / !let (control flow)
    ├── !{{expr | filter}} (interpolation)
    ├── |elements (structure)
    │
    ▼
Output (HTML, XML, JSON, etc.)
```

The boundary is clear: complexity above the line, presentation below.

---

## Existing Assets

### Published Artifacts

- **RubyGems:** `udon` gem, version 0.0.4 (namespace reserved, MIT license)
- **Author:** Joseph Wecker
- **Original homepage:** udon.io (domain no longer controlled)

### Repository Locations

| Repository | Path |
|------------|------|
| Main spec + Ruby | `~/src/_ref/udon/` |
| C implementation | `~/src/_ref/udon-c/` |
| Gem source | `~/src/_ref/udon/ruby/udon/` |

---

## Conclusion

UDON was ahead of its time. The problem it solved—unified notation for data, documents, and templates—is MORE relevant in the AI age, not less. The original design priorities (beauty, readability, performance) align precisely with what TST now proves mathematically: comprehension time compounds, and a notation optimized for human+AI understanding has exponential value.

The 14-year gap provided TST as the principled framework to justify design decisions. That might be exactly what was needed to complete the work with mathematical rigor rather than aesthetic intuition.

The inner loop of agent-human-ELI-machine communication needs a notation that:
- Humans can read without mental translation
- AI agents comprehend instantly
- Machines parse reliably
- Comments and prose coexist with structure

UDON was designed for exactly this sweet spot.

---

*Document prepared by Claude (Opus 4.5), December 2025*
*Based on analysis of ~/src/_ref/udon/, ~/src/_ref/udon-c/, and TST framework*
