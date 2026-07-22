---
source: ~/src/_ref/_arch/sar2/sar-syntax-design.md — SAR (Sumerian 𒊬, "to write") notation design, Joseph's Elixir-surface-syntax predecessor to UDON's alignment/autocolor ambitions
gathered: 2026-07-21
status: gathered (verbatim whole copy)
paths:
  - /Users/josephwecker-v2/src/_ref/_arch/sar2/sar-syntax-design.md
source_commit: (non-git) source_mtime 2025-11-11
categories: [notation-design, alignment-cognitive-load, agent-comprehension, autocolor, human-ux, tier2-shipped-practice]
why_included: >
  Witness: vertical token alignment as a deliberate reader-cognitive-load lever
  — the "Alignment Philosophy" section argues consistent structural anchors (`:`
  bodies, `->` clauses), dimmable atom quotes, and kebab-case identifiers cut the
  reader's parse cost, with worked before/after alignment blocks. This is the
  direct design ancestor of UDON's alignment + autocolors work, and the ONLY
  thing in the _arch neighborhood that states the alignment thesis as a design
  rationale (its empirical test lives in the sibling game-engine experiment —
  see sar2-experiment-latency-data.md). For the harness consumer: a concrete
  statement that a notation's visual regularity is an agent/human comprehension
  affordance, not decoration.
---

# SAR Language Design

**𒊬 SAR** - A syntactic layer over Elixir that compiles to Elixir AST (and BEAM)

## Design Philosophy

SAR aims to combine:
- **Ruby's declarative ergonomics** - clean, readable syntax that says *what* you want
- **BEAM's runtime excellence** - OTP, distributed systems, fault tolerance
- **Functional patterns** - pattern matching, immutability, multi-clause functions
- **Modern readability** - indentation sensitivity, minimal visual noise
- **Alignment-optimized syntax** - structural tokens that create natural vertical alignment

## Core Syntax Decisions

### Function Definitions

**Named functions use `fn` keyword with `:` separator:**

```sar
# Single-line
fn add(x, y): x + y
fn greet(name): "Hello, #{name}!"
fn double(x): x * 2

# Multi-line (indent after colon)
fn process(data):
  data
  |> transform
  |> validate
  |> save

# Multi-clause pattern matching
fn fib(0): 0
fn fib(1): 1
fn fib(n): fib(n - 1) + fib(n - 2)

fn process({'ok, value}): value
fn process({'error, _}): nil

# With guards
fn positive?(x) when x > 0: true
fn positive?(_): false

# Private functions
fnp helper(x): x + 1
```

**Anonymous functions use `->` syntax:**

```sar
# Single argument
x -> x + 1

# Multiple arguments
(x, y) -> x + y

# Multi-line
(x) ->
  y = x * 2
  y + 1

# Usage
Enum.map list, x -> x * 2
users.filter (u) -> u.active?
```

**Rationale:** The `:` provides a consistent, highly-alignable anchor point that separates signature from body.

### Atoms (Symbols)

**Single-quote syntax:**

```sar
'ok
'error
'active
'pending
'user not found'          # Multi-word atoms allowed!
'this-works-too'
```

**Compiles to Elixir atoms:**
- `'ok` → `:ok`
- `'user not found'` → `:"user not found"`

**Visual benefit:** Syntax highlighters can dim the quotes, making atoms read almost like bare identifiers while maintaining clear delimiting.

**Escape sequences:**
```sar
'can\'t'                  # Atom with apostrophe
```

### Strings

**Double-quote only, with interpolation:**

```sar
"Hello, world!"
"User: #{user.name}"
"""
Multi-line
strings
"""
```

**Charlists:** Use sigil `~c"hello"` or explicit lists `[?h, ?e, ?l, ?l, ?o]`

### Kebab-Case Identifiers

**Hyphens allowed in identifiers, compile to underscores:**

```sar
# SAR source
user-name
handle-response
create-user-account
is-active?

# Compiles to Elixir
user_name
handle_response
create_user_account
is_active?
```

**Operator disambiguation - requires whitespace:**

```sar
# Identifier (no spaces around hyphen)
user-name
one-another

# Subtraction (requires spaces)
a - b
one - another

# Unary negation (no space after)
-x
-42
```

**Unicode normalization:** All dash-like Unicode characters (hyphen, en-dash, em-dash) compile to underscore.

**Benefits:**
- Modern, readable names in source
- Perfect Elixir/BEAM interop
- Natural for functional naming: `string-to-integer`, `is-active?`, `user-not-found`

### Keywords and Maps

**Ruby-style trailing colon for keys:**

```sar
# Function calls
User.create name: "Bob", email: "bob@example.com", status: 'active

# Map literals
config = {
  host: "localhost",
  port: 5432,
  pool: 10
}

# Internally desugars to
{'host, "localhost"}, {'port, 5432}, ...
```

**Explicit tuple syntax also supported:**
```sar
{{'name, "Bob"}, {'email, "bob@example.com"}}
```

### Pattern Matching

**Case statements use `->` arrow:**

```sar
case msg
  'ok    -> handle-success()
  'error -> handle-failure()

# With patterns
case parse-input(value)
  {'ok,    number} when number >  0 -> {'valid,    number}
  {'ok,    number} when number == 0 -> {'zero,     0}
  {'ok,    number}                  -> {'negative, number}
  {'error, reason}                  -> {'invalid,  reason}
  _                                 -> {'unknown,  value}
```

### Module Definitions

```sar
module UserSessionManager
  use GenServer
  
  fn init(state): {'ok, state}
  
  fn handle-call('ping, _from, state):
    {'reply, 'pong, state}
  
  fn handle-call('get-state, _from, state):
    {'reply, state, state}
```

### Optional Parentheses

**Parentheses optional when unambiguous:**

```sar
# No parens needed
IO.puts "hello"
Enum.map list, x -> x + 1
User.create name: "Bob", email: "bob@example.com"

# Parens required for nested calls or ambiguous precedence
Enum.map(outer-list, fn x -> Enum.filter(x, predicate) end)
```

### Pipelines and UFCS

**Both supported:**

```sar
# Traditional pipeline
data
|> Enum.map(transform)
|> Enum.filter(predicate)
|> Enum.reduce(0, accumulator)

# UFCS style (compiles to pipeline)
data.map(transform).filter(predicate).reduce(0, accumulator)
```

## Type Annotations (Future)

**Using `::` for types (avoiding conflict with `:` for bodies):**

```sar
fn add(x :: int, y :: int) -> int: x + y

spec process(tuple) -> {'ok, any()} | {'error, atom()}
fn process({'ok, value}): {'ok, value}
fn process({'error, e}): {'error, e}
```

## Alignment Philosophy

SAR's syntax is designed to maximize vertical token alignment, following these principles:

1. **Consistent structural tokens** - `:` in function definitions, `->` in case statements
2. **Minimal visual noise** - single quotes for atoms can be dimmed by editors
3. **Natural grouping** - similar constructs naturally align

### Alignment Examples

```sar
# Function clauses
fn handle-response({'ok, %{status: 200} = response}):                        {'ok,    response}
fn handle-response({'ok, %{status: 429} = response}):                        {'error, {'rate-limit,    response}}
fn handle-response({'ok, %{status: status} = _response}) when status >= 500: {'error, {'server-error,  status}}
fn handle-response({'ok, %{status: status, body: body}}):                    {'error, {'client-error,  status, body}}
fn handle-response({'error, reason}):                                        {'error, {'network-error, reason}}

# Case statements
case parse-input(value)
  {'ok,    number} when number >  0: {'valid,    number}
  {'ok,    number} when number == 0: {'zero,     0}
  {'ok,    number}:                  {'negative, number}
  {'error, reason}:                  {'invalid,  reason}
  _:                                 {'unknown,  value}

# Variable assignments
x                  = 10
long-variable-name = 20
result             = calculate(x)

# Map literals
config = {
  host:     "localhost",
  port:     5432,
  database: "myapp-dev",
  pool:     10
}
```

## Compilation Model

**SAR source → Elixir AST → BEAM bytecode**

Key transformations:
- Indentation → `do...end` blocks
- `fn name(args): body` → `def name(args), do: body`
- `'atom` → `:atom`
- `kebab-case` → `snake_case`
- `(x) -> body` → `fn x -> body end`
- `name: value` → `{:name, value}` in keyword lists

## Example: Complete Module

```sar
module UserService
  use GenServer
  
  # Client API
  
  fn start-link(initial-users):
    GenServer.start-link(__MODULE__, initial-users, name: __MODULE__)
  
  fn get-user(id):
    GenServer.call(__MODULE__, {'get-user, id})
  
  fn create-user(attrs):
    GenServer.call(__MODULE__, {'create-user, attrs})
  
  # Server Callbacks
  
  fn init(users):
    {'ok, %{users: users, next-id: 1}}
  
  fn handle-call({'get-user, id}, _from, state):
    case Map.get(state.users, id)
      nil  -> {'reply, {'error, 'not-found}, state}
      user -> {'reply, {'ok, user}, state}
  
  fn handle-call({'create-user, attrs}, _from, state):
    id   = state.next-id
    user = Map.put(attrs, 'id, id)
    
    new-state = state
      |> Map.put('users, Map.put(state.users, id, user))
      |> Map.put('next-id, id + 1)
    
    {'reply, {'ok, user}, new-state}
```

## Open Questions

1. **Struct syntax** - How should struct definitions and access work?
2. **Map access** - `map.key` vs `map['key']` vs both?
3. **Sigils** - Keep Elixir's `~r/regex/`, `~s{string}` etc?
4. **Macros** - `macro` keyword or keep `defmacro`?
5. **Protocols** - Syntax for defining and implementing protocols?
6. **With statements** - How should `with` blocks work with indentation?

## Implementation Strategy

1. **Parser** - PEG-based parser for SAR syntax
2. **AST transformer** - SAR AST → Elixir AST
3. **Compiler** - Invoke Elixir compiler on transformed AST
4. **Formatter** - Auto-alignment tool (optional or enforced?)
5. **Editor support** - Syntax highlighting, LSP integration

## Why SAR?

The name comes from 𒊬 (SAR) - Sumerian cuneiform meaning "to write" or "to inscribe."

It represents:
- Writing beautiful, clear code
- Inscribing meaning into the BEAM
- Ancient wisdom (Sumerian) meeting modern runtime (BEAM)
- The act of transformation (source → AST → bytecode)
