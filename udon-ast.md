# UDON Parsed AST

**The structure produced by parsing a UDON document.**

This describes the "DOM" or "AST" that consumers work with after parsing. It is
intentionally simple—a unified tree that works for all UDON flavors (data,
documents, templates, AI reasoning, etc.).

---

## Document

A document is a list of nodes:

```ruby
Document = [Node]
```

No implicit root wrapper. This enables:
- **Streaming**: Append nodes as they complete
- **Fragments**: Same type as full documents (useful for includes/templates)
- **Multi-root**: Valid UDON can have multiple top-level elements

```ruby
doc = Udon.parse(source)   # => [Node, ...]
doc.first                  # => first node
doc/:article               # => path navigation
```

---

## Node Types

```ruby
Node = Element | Text | Comment | Directive | Interpolation | Reference | Raw
```

### Container Nodes (have children)

| Type | Description |
|------|-------------|
| **Element** | Structural container (`\|name`) |
| **Directive** | Control flow (`!if`, `!for`, `!{if ...}...!{endif}`) |

### Leaf Nodes (no children)

| Type | Description |
|------|-------------|
| **Text** | Prose content (untyped) |
| **Comment** | Block (`;`) or inline (`;{...}`) |
| **Interpolation** | Value interpolation (`!{{expr}}`) |
| **Reference** | Element (`@element[key]` or `@[key]`) or attribute merge (`:[key]`) |
| **Raw** | Code/raw content (`!:lang:` or triple-backtick) |

---

## Element

The primary structural node:

```ruby
Element:
  name: String?              # nil for anonymous (class-only) elements
  key: Value?                # from [key] syntax — the primary key for this element
  traits: [String]           # from .class syntax — what kinds of thing this is
  attrs: [Attribute]         # ordered, keyed by name
  children: [Node]           # content nodes

# Aliases for familiarity:
#   key:    also accessible as `id`, `identity`
#   traits: also accessible as `class`, `classes`
```

### Key and Traits (not just HTML)

The `[key]` and `.class` syntax may look like HTML shortcuts, but they encode a
fundamental ontological distinction:

**Key (`[key]`)** — The primary key for this element:
- This element can be addressed, pointed to, referenced
- It has existence beyond its position in the tree
- An element *without* a key is a value-object (anonymous, structural)
- An element *with* a key is a named entity (often UUIDs, primary keys, slugs)
- One key per element (singular)

**Traits (`.class`)** — Plural aspects, roles, classifications:
- What kinds of thing is this?
- What categories does it belong to?
- Zero or more, not mutually exclusive (always an array)

This pattern appears everywhere:

| Domain | Key (singular) | Traits (plural) |
|--------|----------------|-----------------|
| HTML/CSS | `id` | `class` |
| Databases | Primary key | Tags, categories |
| OOP | Object reference | Types, traits, interfaces |
| File systems | Path, inode | Extensions, tags |

The syntax captures the semantics:
- Brackets `[...]` imply addressing/lookup — like array indexing or SQL WHERE
- Dot `.` implies membership/aspect — appropriate for classification

### Type-Scoped Uniqueness

Unlike HTML (where `id` must be globally unique), UDON uses **type-scoped keys**:

The compound key `(element-name, key)` must be unique — like a database primary
key is unique *per table*, not globally.

```udon
|user[1]
  :name Alice

|user[2]
  :name Bob

|order[1]                    ; OK: different element type
  :customer @user[1]         ; typed reference
  :total 99.99

|order[2]
  :customer @user[2]
  :total 45.00

|user[1]                     ; ERROR: duplicate (user, 1)
  :name Charlie
```

This matches how people naturally model data:
- `|user[42]` is like `users.find(42)`
- `|order[42]` is like `orders.find(42)`
- No conflict — different "tables"

### References

References use `@element[key]` syntax:

```udon
|team[engineering]
  :lead @user[1]             ; explicit: element type + key
  :members [@user[1] @user[2]]

|note[readme]
  See @section[intro] for details.
```

**Shorthand `@[key]`** is allowed when unambiguous within the document:

```udon
; If only one element type uses key "header"...
|template
  @[header]                  ; OK if unambiguous
  |main ...
  @[footer]

; If ambiguous (multiple element types have same key), error:
|div[main] ...
|section[main] ...
|page
  @[main]                    ; ERROR: ambiguous — use @div[main] or @section[main]
```

The shorthand is convenient for HTML-like documents where element types rarely
share keys, but explicit `@element[key]` is preferred for data documents.

**Invariants:**
- Attributes are defined before children (strict ordering)
- `[key]` expands to `:key` (or `:'$key'` — undecided whether `$` prefix is used)
- `.class1.class2` expands to `:class [class1 class2]` (or `:'$class'` — undecided)
- The `class`/traits attribute is **always an array**, even with one item
  (`.foo` → `[foo]`) or zero items
- Suffixes (`?`, `!`, `*`, `+`) expand to attributes: `|field?` → `:'?' true`
  (suffix attribute naming also undecided: `?` vs `$?`)

---

## Attribute

Attributes are containers that hold values:

```ruby
Attribute:
  name: String
  value: AttrValue

AttrValue = Scalar | [AttrValue] | Node
```

**Attribute values are the only place with syntactic typing.** The parser
determines type from syntax:

```ruby
Scalar = String       # "quoted" or bare fallback
       | Integer      # 42, 0xFF, 0o755, 0b1010
       | Float        # 3.14, 1.5e-3
       | Rational     # 1/3r
       | Complex      # 3+4i
       | Bool         # true, false (lowercase only)
       | Nil          # null, nil
       | Date         # 2025-01-03
       | YearMonth    # 2025-01
       | Time         # 14:30:00, 14:30:00.123456
       | DateTime     # 2025-01-03T14:30:00Z, with optional offset
       | Duration     # P1DT2H30M (ISO 8601) or 30s, 5m, 2h, 90d, 1mo, 2y (shorthand)
       | RelativeTime # +30d, -1h (offset from reference point, typically "now")
```

See [TIME-SPEC.md](TIME-SPEC.md) for full temporal value syntax and recognition
rules.

**Complex attribute values** can be full subtrees:

```udon
|api
  :headers
    |header :name Content-Type :value application/json
    |header :name Authorization :value Bearer token
```

Here `:headers` has a value that is an Element with its own children.

---

## Text

Prose content. Untyped—just characters.

```udon
|p Some text with 42 in it
```

The `42` in prose is text, not an integer. Syntactic typing only applies to
attribute values.

Text nodes may be adjacent to inline elements, interpolations, and comments:

```udon
|p Hello !{{name}}, welcome to |{em UDON}!
```

Produces children: `[Text, Interpolation, Text, Element, Text]`

---

## Comment

A tier of voice, not noise to be stripped.

```udon
; Block comment
|element ;{inline comment} content
```

Comments are first-class nodes because they may carry semantic meaning:
- Documentation
- AI reasoning traces
- Confidence annotations
- TODOs and maintainer notes

Comments are always **leaf nodes** (no children), making them trivial to skip
during traversal when not needed:

```ruby
node.children                    # all nodes including comments
node.children.grep_v(Comment)    # skip comments
```

---

## Source Metadata

The core tree is simple and unified. Source details live in a parallel metadata
layer, available when needed but not cluttering traversal:

```ruby
SourceInfo:
  span: Range           # byte offsets in source
  line: Integer
  column: Integer
  form: :block | :sameline | :embedded
  original_whitespace: String?   # for round-tripping
  attr_order: [String]?          # original attribute order
```

**Use cases for metadata:**
- Round-trip emission (preserve original style)
- Linting (detect inconsistent formatting)
- Error messages (source locations)
- Comment attachment (which node a comment relates to)

**Access pattern:**

```ruby
node.name              # core tree - always clean
node.children          # core tree - always clean
node.source            # metadata - when available
node.source.form       # => :embedded
node.source.span       # => 42..87
```

---

## Bidirectional Navigation

Nodes know their context, not just their children.

```ruby
Node:
  parent: Node?              # nil for root-level nodes
  document: Document         # the containing document
  path: Path                 # path from root to this node
  depth: Integer             # nesting level (0 for root)
  index: Integer             # position among siblings

Element:
  # ... existing fields ...
  parent: Element?           # parent element (skips non-element ancestors)
  ancestors: [Element]       # chain to root
  siblings: [Node]           # other children of parent
  prev_sibling: Node?
  next_sibling: Node?
```

**Breadcrumb generation:**

```ruby
node.path                    # => Path(|config|database[primary])
node.path.to_s               # => "|config|database[primary]"
node.ancestors.map(&:name)   # => ["config", "database"]
```

**Upward navigation:**

```ruby
node.parent                  # immediate parent
node.ancestor(:config)       # first ancestor named "config"
node.ancestors               # all ancestors to root
node.root                    # document root (first top-level node)
```

---

## Document Views & Indexes

The Document provides computed views for efficient lookup.

```ruby
Document:
  nodes: [Node]              # the raw node list (primary data)

  # === Computed Views ===

  mixins: {String => Element}
    # Class-only elements (traits definitions)
    # Key: trait name, Value: the |.trait element
    # Example: doc.mixins["postgres"] => |.postgres element

  by_type: {String => [Element]}
    # Elements grouped by name
    # Example: doc.by_type["user"] => [|user[1], |user[2], ...]

  by_key: {[String, Value] => Element}
    # Compound key lookup (element_name, key)
    # Example: doc.by_key[["user", 1]] => |user[1]
    # This enforces type-scoped uniqueness

  by_key_only: {Value => [Element]}
    # Key-only lookup (for @[key] shorthand resolution)
    # Example: doc.by_key_only["header"] => [|div[header]] or error if ambiguous

  references: ReferenceIndex
    # Bidirectional reference tracking

  traits_index: {String => [Element]}
    # Elements by trait
    # Example: doc.traits_index["deprecated"] => all .deprecated elements
```

### Reference Index

Tracks what references what, bidirectionally.

```ruby
ReferenceIndex:
  # Forward: what does this element reference?
  outbound: {Element => [Reference]}

  # Reverse: what references this element?
  inbound: {Element => [Reference]}

  # Lookup methods
  def references_to(element)
    # All Reference nodes pointing to this element
  end

  def references_from(element)
    # All Reference nodes within this element's subtree
  end

  def resolve(reference)
    # Reference -> target Element (or error if unresolved)
  end

  def unresolved
    # All Reference nodes that don't resolve
  end

Reference:
  target_type: String?       # element name (nil for @[key] shorthand)
  target_key: Value          # the key
  kind: :element | :merge    # @[...] vs :[...]
  resolved: Element?         # cached resolution (lazy)
```

**Usage:**

```ruby
# Find what references @user[1]
user = doc.by_key[["user", 1]]
doc.references.references_to(user)
# => [Reference in |order[1]:customer, Reference in |team[dev]:lead, ...]

# Find what |order[1] references
order = doc.by_key[["order", 1]]
doc.references.references_from(order)
# => [Reference(@user[1]), Reference(@product[sku-123]), ...]

# Check for broken references
doc.references.unresolved
# => [Reference(@user[999]), ...] — referenced but not defined
```

---

## Traversal

### Path Navigation

```ruby
doc.at("|article|section")           # dig by element name
doc.at("|article:author")            # attribute access
doc.all("|article|section[*]")       # all sections
element.children                     # all child nodes
element.elements                     # child elements only
element.text                         # concatenated text content
```

### Filtering

```ruby
# Skip comments
element.children.grep_v(Comment)

# Just elements
element.children.grep(Element)

# By name
element.children.select { |n| n.is_a?(Element) && n.name == "section" }
```

### Indexed Lookup

```ruby
# By compound key (always unambiguous)
doc.by_key[["user", 42]]           # => |user[42] or nil

# By key only (may be ambiguous)
doc.by_key_only["main"]            # => Element or raises AmbiguousKey

# By type
doc.by_type["endpoint"]            # => [all |endpoint elements]

# By trait
doc.traits_index["deprecated"]     # => [all .deprecated elements]

# Mixins
doc.mixins["postgres"]             # => |.postgres definition
```

### Path Skeleton

Generate a navigable map of all paths in the document. Every line is a valid,
copy-pasteable path.

```ruby
doc.skeleton                       # => String (the skeleton view)
doc.skeleton(depth: 2)             # limit depth
doc.skeleton(show_attrs: true)     # include attribute names
doc.skeleton(show_traits: true)    # include .traits
doc.skeleton(show_counts: true)    # include line/child counts
```

**Example output:**

```
|article[welcome-guide]                    # 156 lines
├─ :author :date :tags :status            # attrs
├─ |h1
├─ |table[format-comparison]               # 8 lines
│  └─ |tr[*]                              # 6 rows
├─ |blockquote
├─ |section[getting-started]               # 45 lines
│  ├─ :level
│  ├─ |example[*]                         # 3
│  └─ (prose 28 lines)
└─ |section[advanced-topics]               # 62 lines
   ├─ :level
   └─ (prose 41 lines)
```

**Features:**
- **Every path is valid**: Copy `|section[getting-started]|example[*]` and use it
- **`[*]` for multiples**: Shows when multiple instances exist with different keys
- **Attrs listed**: `:author :date` shows what attributes are available
- **Counts**: Line counts, child counts for orientation
- **Prose indicator**: `(prose N lines)` shows text content presence
- **Traits optional**: `.section[intro].collapsible` when `show_traits: true`

**Compact mode** (for quick orientation):

```ruby
doc.skeleton(compact: true)
```

```
|article[welcome-guide]
  |h1 |table[format-comparison] |blockquote
  |section[getting-started] |section[advanced-topics]
```

**JSON mode** (for programmatic use):

```ruby
doc.skeleton(format: :json)
```

```json
{
  "paths": [
    "|article[welcome-guide]",
    "|article[welcome-guide]|h1",
    "|article[welcome-guide]|table[format-comparison]",
    "|article[welcome-guide]|section[getting-started]",
    ...
  ],
  "attrs": {
    "|article[welcome-guide]": ["author", "date", "tags", "status"],
    ...
  }
}
```

---

## Equivalence

Different syntactic forms produce the same tree structure:

```udon
; Sameline
|p |em text

; Block
|p
  |em
    text

; Both produce:
; Element(p) -> Element(em) -> Text("text")
```

The only differences are:
1. **Whitespace in text content** (space vs. no space between text nodes)
2. **Source metadata** (form: :sameline vs :block vs :embedded)

Consumers decide whitespace normalization policy based on their needs.

---

## Path Object

Paths are first-class objects for navigation and serialization. The path syntax
reuses UDON's prefix symbols, so paths read like flattened UDON documents.

See [udon-paths.md](udon-paths.md) for full specification.

```ruby
Path:
  segments: [PathSegment]

PathSegment = Element(name, key?, traits?) | Attr(name) | Ref(type?, key) | Descent

# Construction
Path.parse("|config|database[primary]")
Path.parse("|users[*]")              # wildcard
Path.parse("|items[0]")              # by index

# Operations
path.resolve(doc)                    # => Node or [Node] for wildcards
path.parent                          # => Path without last segment
path + segment                       # => extended Path
path.relative_to(other)              # => relative Path

# Serialization
path.to_s                            # => "|config|database[primary]"
```

**Syntax summary:**

| Pattern | Meaning |
|---------|---------|
| `\|element` | Child element by name |
| `[key]` | Element by key |
| `[0]` | Child by index |
| `.trait` | Filter by trait |
| `:attr` | Attribute access |
| `@type[key]` | Reference resolution |
| `*` | Wildcard (any element) |
| `\|\|` | Recursive descent |

---

## Template Mode (Separate Concern)

Directives (`!if`, `!for`, `!include`) and Interpolations (`!{{expr}}`) are
parsed into the AST as nodes, but **evaluation is a separate concern**.

```ruby
# The AST captures structure, not evaluation
Directive:
  name: String               # "if", "for", "include", "let", etc.
  expression: String         # the raw expression text
  children: [Node]           # body of the directive

Interpolation:
  expression: String         # the raw expression text
```

**Template evaluation** is:
- Host-language dependent (Ruby, JavaScript, etc.)
- Optional (many UDON documents have no directives)
- Separate from parsing (parse once, evaluate with different contexts)

```ruby
# Parse preserves directives as-is
doc = Udon.parse(source)
doc.nodes.grep(Directive)    # => [Directive(!if), Directive(!for), ...]

# Evaluation is separate
template = Udon::Template.new(doc)
output = template.render(context: { user: current_user, posts: posts })
```

Documents without directives are "static" — the AST is the final form.
Documents with directives are "templates" — they need evaluation to produce
final output.

---

## Semantic Views (Future)

Computed views that require deeper analysis.

### Vector Embeddings

For semantic search and similarity across documents.

```ruby
Document:
  embeddings: EmbeddingIndex?    # optional, computed on demand

EmbeddingIndex:
  # Element-level embeddings
  def embedding_for(element)
    # => Vector (e.g., from element's text + structure)
  end

  # Similarity search
  def similar_to(element, limit: 10)
    # => [Element] ordered by similarity
  end

  def search(query_text, limit: 10)
    # => [Element] matching semantic query
  end

  # Cross-document
  def similar_across(documents, element)
    # => [(Document, Element, score)]
  end
```

**Use cases:**
- "Find elements similar to this one"
- "Search for concepts, not just keywords"
- "Cluster related elements across documents"

*Note: Embedding generation is model-dependent and configuration-dependent.
The AST provides hooks; implementation details TBD.*

### Inferred Schema

Schema inferred from document structure.

```ruby
Document:
  inferred_schema: Schema?       # computed from structure

Schema:
  element_types: {String => ElementSchema}

ElementSchema:
  name: String
  required_attrs: [AttrSchema]
  optional_attrs: [AttrSchema]
  allowed_children: [String]     # element names
  traits: [String]               # common traits
  cardinality: :one | :many

AttrSchema:
  name: String
  value_type: Class              # Integer, String, Date, etc.
  examples: [Value]
```

**Use cases:**
- "What attributes does |endpoint usually have?"
- "Generate a schema from existing documents"
- "Validate new content against inferred patterns"

---

## Summary

| Concept | Description |
|---------|-------------|
| Document | `[Node]` - streamable, no wrapper |
| Node | Element, Text, Comment, Directive, Interpolation, Reference, Raw |
| Element | name, key, traits, attrs, children |
| Attribute | name, value (scalar, list, or subtree) |
| Typing | Only in attribute values, syntactic not sniffing |
| Comments | First-class leaf nodes (tier of voice) |
| Metadata | Parallel layer for source info, round-tripping |
| Navigation | Bidirectional (parent, ancestors, siblings) |
| Indexes | by_key, by_type, traits_index, mixins, references |
| Templates | Directives/Interpolations parsed but evaluated separately |

The tree is unified across all UDON flavors. Consumers interpret based on
context—whitespace normalization, comment handling, and tier significance are
consumer decisions, not parser decisions.
