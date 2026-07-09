# UDON Path Syntax

**A path language that reuses UDON's own prefix system.**

The key insight: UDON already has a consistent prefix system (`|` elements, `:`
attributes, `.` traits, `[key]` keys, `@` references). The path syntax reuses
these same symbols, making paths read like flattened UDON documents.

---

## Design Principles

### 1. No New Symbols

Every symbol in path syntax is already meaningful in UDON:
- `|` — element (structure)
- `:` — attribute (metadata)
- `.` — trait (classification)
- `[key]` — key (identity)
- `@` — reference (indirection)
- `*` — wildcard (already familiar)

### 2. Paths Look Like UDON

A path is essentially a compressed, linear UDON document:

```udon
; Full UDON
|config
  |database[primary]
    :host db.example.com

; Path to that host attribute
|config|database[primary]:host
```

Copy any path, and it visually resembles the UDON it came from.

### 3. Zero Cognitive Overhead

If you know UDON, you know the path syntax. No XPath to learn, no JSONPath
quirks, no CSS selector edge cases.

---

## Path Syntax

### Basic Navigation

| Path | Meaning |
|------|---------|
| `\|element` | Child element by name |
| `\|parent\|child` | Nested elements |
| `\|element[key]` | Element with specific key |
| `\|element:attr` | Attribute of element |
| `\|element.trait` | Element with trait |

### Examples

```
|config                              # element named "config"
|config|database                     # database child of config
|config|database[primary]            # database with key "primary"
|config|database[primary]:host       # the :host attribute
|config|database[primary]:host:value # attribute value (for complex attrs)
|article|section.intro               # section with .intro trait
|user[alice].admin                   # user[alice] that has .admin trait
```

---

## Wildcards

| Pattern | Meaning |
|---------|---------|
| `\|element[*]` | All elements of this name (any key) |
| `\|*` | Any element (one level) |
| `\|*[key]` | Any element with this key |
| `\|*.trait` | Any element with this trait |
| `\|element:*` | All attributes of element |

### Examples

```
|user[*]                             # all |user elements
|user[*]:email                       # email attr of all users
|*[footer]                           # any element with key "footer"
|*.deprecated                        # any element with .deprecated trait
|config|*                            # all direct children of config
|form|field[*]:value                 # value attr of all fields
```

---

## Recursive Descent

Double-pipe `||` means "at any depth" (like XPath's `//`):

| Pattern | Meaning |
|---------|---------|
| `\|\|element` | Element anywhere in document |
| `\|root\|\|element` | Element anywhere under root |
| `\|\|[key]` | Any element with this key, anywhere |
| `\|\|.trait` | Any element with trait, anywhere |

### Examples

```
||error                              # all |error elements, any depth
|article||code                       # all |code anywhere in article
||[primary]                          # anything with key "primary"
||.deprecated                        # all deprecated elements
||:author                            # all :author attrs anywhere
```

---

## Reference Resolution

The `@` prefix resolves references:

| Pattern | Meaning |
|---------|---------|
| `@element[key]` | Resolve typed reference |
| `@[key]` | Resolve untyped reference (must be unambiguous) |

### Examples

```
@user[alice]                         # resolve to |user[alice]
@user[alice]:email                   # then get :email attr
|order[123]:customer@                # follow the reference in :customer
|order[123]:customer@:email          # follow ref, get email
```

The `@` can appear:
- At the start: `@user[alice]` — direct lookup
- After an attr: `:customer@` — follow the reference stored in that attr

---

## Traits as Filters

Traits filter elements by classification:

```
|section.collapsible                 # sections with .collapsible
|field.required                      # required fields
|*.deprecated                        # anything deprecated
|endpoint[*].public.stable           # public AND stable endpoints
```

Multiple traits are AND-ed: `|element.trait1.trait2` means "has both traits."

---

## Index Access

Numeric indices in brackets access by position:

| Pattern | Meaning |
|---------|---------|
| `\|element[0]` | First child element of this name |
| `\|element[-1]` | Last child element |
| `\|parent\|*[0]` | First child of any type |

### Examples

```
|items|item[0]                       # first item
|table|tr[-1]                        # last row
|list|*[0]                           # first child (any element)
```

**Note:** Numeric indices are positional, string keys are identity-based.
`|user[0]` = first user, `|user[alice]` = user with key "alice".

---

## Attribute Paths

The `:` prefix accesses attributes:

```
|element:attr                        # simple attribute
|element:attr:nested                 # nested attr (when attr value is element)
|element:*                           # all attributes
```

For complex attribute values (subtrees):

```udon
|api
  :headers
    |header[content-type] :value application/json
    |header[auth] :value Bearer token
```

```
|api:headers                         # the headers subtree
|api:headers|header[content-type]    # specific header element
|api:headers|header[*]:value         # all header values
```

---

## Grammar

Formal grammar in pseudo-BNF:

```
path          := segment+
segment       := element_seg | attr_seg | ref_seg | descent_seg

element_seg   := '|' name? key? traits?
name          := identifier | '*'
key           := '[' (value | '*' | integer) ']'
traits        := ('.' identifier)+

attr_seg      := ':' (identifier | '*')

ref_seg       := '@' name? key?
              |  '@'                    ; follow reference in preceding attr

descent_seg   := '||'                   ; recursive descent

identifier    := [a-zA-Z_][a-zA-Z0-9_-]*
value         := identifier | quoted_string | integer
integer       := '-'? [0-9]+
quoted_string := '"' [^"]* '"' | "'" [^']* "'"
```

---

## Ruby API

### Path Construction

```ruby
# String parsing
path = Udon::Path.parse("|config|database[primary]:host")

# Programmatic construction
path = Udon::Path.new
  .element(:config)
  .element(:database, key: "primary")
  .attr(:host)

# Operator syntax (DSL)
path = |config |database["primary"] :host
```

### Path Resolution

```ruby
doc = Udon.parse(source)

# Single result
doc.at("|config|database[primary]:host")    # => "db.example.com"

# Multiple results (wildcards)
doc.all("|user[*]:email")                   # => ["alice@...", "bob@..."]

# With block
doc.each("|section[*]") { |section| ... }
```

### Path Object Methods

```ruby
path = Udon::Path.parse("|config|database[primary]")

path.to_s                    # => "|config|database[primary]"
path.segments                # => [Element(:config), Element(:database, "primary")]
path.parent                  # => Path("|config")
path.depth                   # => 2
path.leaf                    # => Element(:database, "primary")

# Extending paths
path + ":host"               # => Path("|config|database[primary]:host")
path / |credentials          # => Path("|config|database[primary]|credentials")

# Relative paths
child.relative_to(parent)    # => Path("|database[primary]")
```

### Pattern Matching

```ruby
path = Udon::Path.parse("|user[*].admin")

path.matches?("|user[alice].admin")     # => true
path.matches?("|user[bob]")             # => false (no .admin)

# Extract wildcards
pattern = Udon::Path.parse("|user[*]:email")
pattern.extract("|user[alice]:email")   # => { 0 => "alice" }
```

---

## Skeleton Output

The path skeleton uses this syntax directly:

```
|article[welcome-guide]
├─ :author :date :tags :status
├─ |h1
├─ |table[format-comparison]
│  └─ |tr[*]                              # 6 instances
├─ |blockquote
├─ |section[getting-started]
│  ├─ :level
│  ├─ |example[*]                         # 3 instances
│  └─ (prose 28 lines)
└─ |section[advanced-topics]
   ├─ :level
   └─ (prose 41 lines)
```

Every path in the skeleton is directly usable:
- Copy `|article[welcome-guide]|section[getting-started]|example[*]`
- Use it in queries, navigation, or modifications

---

## Comparison to Other Systems

| Concept | XPath | JSONPath | jq | CSS | UDON Path |
|---------|-------|----------|-----|-----|-----------|
| Child | `/child` | `.child` | `.child` | `> child` | `\|child` |
| Descendant | `//desc` | `..desc` | `.. \| .desc` | `desc` | `\|\|desc` |
| By ID/key | `[@id='x']` | `['x']` | `.x` | `#x` | `[x]` |
| By class | N/A | N/A | N/A | `.class` | `.class` |
| Attribute | `/@attr` | N/A | `.attr` | `[attr]` | `:attr` |
| Wildcard | `*` | `[*]` | `.[]` | `*` | `*` |
| Index | `[1]` | `[0]` | `.[0]` | `:nth-child` | `[0]` |
| Filter | `[pred]` | `[?(...)]` | `select()` | `:filter` | `.trait` |

**UDON Path advantages:**
- Uses symbols you already know from UDON
- Visually resembles the documents it navigates
- Traits as first-class filters (not just attributes)
- Type-scoped keys built in (`|user[1]` ≠ `|order[1]`)
- No escaping hell (XPath), no `$` prefix (JSONPath), no pipe chains (jq)

---

## Use Cases

### Querying

```ruby
# Find all deprecated endpoints
doc.all("||endpoint.deprecated")

# Get all user emails
doc.all("|user[*]:email")

# Find orphan references
doc.all("||@*").select { |ref| !ref.resolved? }
```

### Modification

```ruby
# Update a specific value
doc.set("|config|database[primary]:pool", 20)

# Add to a collection
doc.insert("|config|features", new_feature)

# Remove deprecated elements
doc.remove("||*.deprecated")
```

### Validation

```ruby
# Schema rule: all endpoints must have :auth
doc.all("||endpoint").each do |endpoint|
  raise "Missing :auth" unless doc.at("#{endpoint.path}:auth")
end
```

### Skeleton Navigation

```ruby
# Show available paths
puts doc.skeleton

# Interactive exploration
path = "|config"
loop do
  puts doc.skeleton(root: path, depth: 1)
  input = gets.chomp
  path = path + input
end
```

---

## Summary

| Symbol | Meaning | Example |
|--------|---------|---------|
| `\|` | Element | `\|config` |
| `[key]` | Key | `\|user[alice]` |
| `[n]` | Index | `\|item[0]` |
| `[*]` | Any key | `\|user[*]` |
| `.trait` | Trait filter | `\|field.required` |
| `:attr` | Attribute | `\|user:email` |
| `@` | Reference | `@user[alice]` |
| `*` | Any element | `\|config\|*` |
| `\|\|` | Recursive descent | `\|\|error` |

**The path syntax is UDON, linearized.** No new language to learn.
