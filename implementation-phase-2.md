# UDON Implementation Phase 2: Toward the Ideal

## Critical Architecture Insight (Added After Multiple Agent Sessions)

**The streaming event model is the foundation, not a feature.**

Previous agents repeatedly fell into a trap: treating genmachine as a state machine that accumulates data, then emits bundled events. This is backwards. The correct mental model:

### What genmachine Actually Is

Genmachine is a **recursive descent parser expressed in tabular form**. Each "function" is a grammar rule. States within the function handle cases. Function calls (`/element(...)`) are recursion. It's the same parsing approach used in production at massive scale (e.g., RTMP ingest at Twitch).

**The state machine emits events as it parses. There is no accumulation.**

### The Helper Function Anti-Pattern

When agents don't think naturally in recursive-descent-table terms, they instinctively create "helper functions" like:
- `parse_element_identity()` - accumulates name, id, classes, suffix, then emits one big ElementStart
- `parse_indented_attribute()` - accumulates key/value, then emits

This defeats the entire architecture:
1. It moves logic outside the state machine (harder to maintain, verify, optimize)
2. It accumulates state that should be streamed
3. It prevents true streaming (can't emit until accumulation is done)
4. It makes the ring buffer architecture impossible

**Every piece of UDON syntax can be expressed in the state machine DSL.** If you think you need a helper function, you haven't understood the grammar or the DSL well enough yet.

### Grammar Serves Streaming, Not Vice Versa

This approach evolved from earlier work with PEG grammars for streaming protocols (like RTMP). PEGs are powerful at lookahead, but that lookahead has a cost. The realization: with careful grammar design, you can eliminate the need for lookahead entirely and gain orders of magnitude in speed.

**If parsing some construct seems to require accumulation or lookahead, that's a red flag that the grammar needs adjustment, not the parser.**

When you encounter:
- "I need to collect N tokens before I know what to emit"
- "The meaning of X depends on seeing Y later"
- "I can't emit until the closing delimiter because..."

STOP. Bring it up for discussion. The grammar may need tweaking. UDON's syntax was designed to flow through a streaming parser—if it's not flowing, either the grammar has a flaw or we're misunderstanding something.

### The Correct Event Model (SAX-style)

For array values like `[a b c]`:
```
ArrayStart
StringValue("a")
StringValue("b")
StringValue("c")
ArrayEnd
```

For element identity like `|foo[myid].bar.baz?`:
```
ElementStart { name: "foo" }
Attribute { key: "$id", value: ... }  ; from [myid]
Attribute { key: "$class", value: "bar" }
Attribute { key: "$class", value: "baz" }
Attribute { key: "?", value: true }
```

Each syntactic piece emits immediately. No accumulation. The consumer (tree builder or user code) handles grouping.

### Correct Priority Order

The document below has the phases in the wrong order. The correct order is:

1. **Fix genmachine and event model** - streaming events as the primitive
2. **Express full grammar in DSL** - no helper functions
3. **Add ring buffer infrastructure** - true streaming
4. **Test streaming API** - Ruby gem consuming events
5. **Build tree layer ON TOP of events** - tree builder is an event consumer
6. **Lazy Ruby projection** - only then

Building a tree first and then "streaming" from it is backwards. You can't stream from something you've already accumulated.

---

## Current State (Honest Assessment)

We have the **worst of three worlds**:
1. All parsing upfront (no streaming)
2. All Ruby object creation upfront (no lazy conversion)
3. No tree structure (just a simulated event stream)

The "streaming" API is a lie—it's batch parsing with iteration. The "native extension" creates Ruby Hashes for every event immediately, which is the expensive part we were trying to avoid.

Performance claims are unverified. ~30% of SPEC.md is implemented. The ring buffer architecture was planned but never built.

## Phase 2 Goals

### Rust/C-ABI Layer
1. **True streaming parser** with ring buffer—events emitted as they're parsed
2. **Full tree parser** that builds a complete AST in Rust memory
3. **World-class error messages** matching Rust ecosystem expectations (context, suggestions, recovery)

### Ruby Layer
4. **Streaming API** faster than any Ruby streaming parser
5. **Tree API with lazy creation**—nodes become Ruby objects only when accessed
6. **Tree API with full traversal**—faster than Nokogiri even when walking entire tree
7. **World-class error messages** matching Ruby ecosystem expectations (did_you_mean integration, helpful suggestions)

### Design Principles
- **No hedging.** Build the ideal, not the expedient.
- **No backwards compatibility concerns.** Current API is unreleased; break it freely.
- **Measure everything.** Unverified claims are worthless.
- **Steal from the best.** Study Nokogiri, tree-sitter, pulldown-cmark, nom for patterns.

---

## Part 1: The Ideal Streaming Architecture

### Why Streaming Matters

Streaming enables:
- Parsing multi-gigabyte files without memory explosion
- Real-time parsing of agent output (critical for agentic use)
- Backpressure when consumer is slow
- Early termination (stop parsing when you find what you need)
- Parallel processing of event batches

### Current Problem

```rust
// Current: parse everything, return everything
pub fn parse(&mut self) -> Vec<Event<'a>> {
    // ... parses entire input ...
    std::mem::take(&mut self.events)
}
```

This is fundamentally batch, not streaming.

### Ideal Design: Ring Buffer + Incremental Parsing

```
┌─────────────────────────────────────────────────────────────┐
│                     Input Stream                             │
│  ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐              │
│  │Chunk1│→│Chunk2│→│Chunk3│→│Chunk4│→│Chunk5│→ ...         │
│  └──────┘ └──────┘ └──────┘ └──────┘ └──────┘              │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                  Incremental Parser                          │
│                                                              │
│  ┌─────────────────────────────────────┐                    │
│  │ Partial Token Buffer                 │ ← Holds incomplete │
│  │ (e.g., element name split mid-chunk) │   tokens across    │
│  └─────────────────────────────────────┘   chunk boundaries  │
│                                                              │
│  ┌─────────────────────────────────────┐                    │
│  │ Parser State Machine                 │                    │
│  │ - Current state (in element, attr?) │                    │
│  │ - Element stack (indent tracking)    │                    │
│  │ - Position within current line       │                    │
│  └─────────────────────────────────────┘                    │
│                                                              │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                     Ring Buffer                              │
│                                                              │
│  ┌─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐         │
│  │ E1  │ E2  │ E3  │ E4  │ E5  │ ... │     │     │         │
│  └─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┘         │
│    ↑                       ↑                                 │
│    └── read_pos            └── write_pos                     │
│                                                              │
│  - Fixed size (e.g., 1024 events)                           │
│  - Producer (parser) writes, consumer reads                  │
│  - Backpressure when buffer full                            │
│  - Zero-copy: events reference input chunks                  │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                      Consumer                                │
│                                                              │
│  - Reads events from ring buffer                            │
│  - Can process while parsing continues                       │
│  - Acknowledges consumed events (advances read_pos)          │
└─────────────────────────────────────────────────────────────┘
```

### API Design

```rust
/// Streaming parser with ring buffer
pub struct StreamingParser {
    /// Parser state (survives across chunks)
    state: ParserState,

    /// Ring buffer for events
    ring: RingBuffer<Event<'static>>,

    /// Partial token buffer (for tokens split across chunks)
    partial: Vec<u8>,

    /// Owned chunks (events reference these)
    chunks: ChunkList,
}

impl StreamingParser {
    /// Create parser with specified ring buffer capacity
    pub fn new(capacity: usize) -> Self;

    /// Feed a chunk of input. Returns number of events now available.
    /// May block if ring buffer is full (backpressure).
    pub fn feed(&mut self, chunk: &[u8]) -> Result<usize, ParseError>;

    /// Signal end of input. Flushes any pending partial tokens.
    pub fn finish(&mut self) -> Result<usize, ParseError>;

    /// Read next event from ring buffer. Returns None if empty.
    /// Event is valid until next call to read() or drop of parser.
    pub fn read(&mut self) -> Option<&Event<'_>>;

    /// Read batch of events (more efficient for bulk processing)
    pub fn read_batch(&mut self, max: usize) -> &[Event<'_>];

    /// Number of events available to read
    pub fn available(&self) -> usize;

    /// Check if parser has finished (finish() called and buffer drained)
    pub fn is_done(&self) -> bool;
}
```

### Chunk Memory Management

The tricky part: events contain `&[u8]` slices into input. With streaming, we can't hold all input forever.

**Solution: Reference-counted chunk list**

```rust
struct ChunkList {
    chunks: Vec<Arc<Vec<u8>>>,
    /// Minimum chunk index still referenced by unconsumed events
    min_referenced: usize,
}

impl ChunkList {
    /// Add new chunk, return its index
    fn push(&mut self, chunk: Vec<u8>) -> usize;

    /// Mark events up to index as consumed, allowing chunk cleanup
    fn advance_consumed(&mut self, event_index: usize);

    /// Get slice from chunk
    fn slice(&self, chunk_idx: usize, start: usize, end: usize) -> &[u8];
}
```

Events store `(chunk_idx, start, end)` instead of raw slices. When events are consumed, we can drop old chunks.

### Handling Token Boundaries

When a chunk ends mid-token (e.g., element name split):

```
Chunk 1: "|elemen"
Chunk 2: "t-name Hello\n"
```

The parser must:
1. Recognize incomplete token at end of Chunk 1
2. Buffer the partial bytes
3. When Chunk 2 arrives, prepend buffered bytes
4. Continue parsing seamlessly

```rust
enum PartialState {
    None,
    InElementName { start: usize, buffered: Vec<u8> },
    InAttributeKey { start: usize, buffered: Vec<u8> },
    InQuotedString { quote: u8, buffered: Vec<u8> },
    // ... other partial states
}
```

---

## Part 2: The Ideal Tree Architecture

### Why Trees Matter

Trees enable:
- XPath/CSS-style queries (`doc.select("article > p.intro")`)
- Parent/sibling navigation
- Modification and serialization
- Familiar API for users coming from Nokogiri/DOM

### Current Problem

We return flat events. Users must build their own tree:

```ruby
events = Udon.parse(input)
# Now what? User has to manually track stack, build tree...
```

### Ideal Design: Rust-Owned Tree with Lazy Ruby Projection

```
┌─────────────────────────────────────────────────────────────┐
│                    Rust Memory                               │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐    │
│  │                    UdonTree                          │    │
│  │                                                      │    │
│  │  ┌──────────────────────────────────────────────┐   │    │
│  │  │ Node Arena (flat Vec<Node>)                   │   │    │
│  │  │                                               │   │    │
│  │  │  [0]: Root { children: [1, 5, 9] }           │   │    │
│  │  │  [1]: Element { name: "div", ... }           │   │    │
│  │  │  [2]: Text { content: "Hello" }              │   │    │
│  │  │  [3]: Attr { key: "class", value: "foo" }    │   │    │
│  │  │  ...                                          │   │    │
│  │  └──────────────────────────────────────────────┘   │    │
│  │                                                      │    │
│  │  ┌──────────────────────────────────────────────┐   │    │
│  │  │ String Interner (deduplicates names)          │   │    │
│  │  │ "div" → 0, "span" → 1, "class" → 2, ...      │   │    │
│  │  └──────────────────────────────────────────────┘   │    │
│  │                                                      │    │
│  │  ┌──────────────────────────────────────────────┐   │    │
│  │  │ Source Text (zero-copy references)            │   │    │
│  │  └──────────────────────────────────────────────┘   │    │
│  │                                                      │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               │ Opaque handle (pointer)
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                    Ruby Memory                               │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐    │
│  │ Udon::Document (wraps pointer to UdonTree)           │    │
│  │                                                      │    │
│  │ def root                                            │    │
│  │   # Lazily creates Ruby Node object                 │    │
│  │   @root ||= Udon::Node.new(@ptr, 0)                │    │
│  │ end                                                 │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐    │
│  │ Udon::Node (wraps pointer + node index)             │    │
│  │                                                      │    │
│  │ def name                                            │    │
│  │   # FFI call to get name, creates String lazily    │    │
│  │   UdonNative.node_name(@doc_ptr, @index)           │    │
│  │ end                                                 │    │
│  │                                                      │    │
│  │ def children                                        │    │
│  │   # Returns lazy enumerator, not Array             │    │
│  │   Udon::NodeList.new(@doc_ptr, @index)             │    │
│  │ end                                                 │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Key Insight: Arena Allocation

Instead of heap-allocating each node separately:

```rust
// BAD: Millions of small allocations
struct Node {
    children: Vec<Box<Node>>,
}

// GOOD: Single arena, indices for relationships
struct Tree {
    nodes: Vec<Node>,  // Arena
}

struct Node {
    kind: NodeKind,
    parent: u32,         // Index into arena
    first_child: u32,    // Index into arena
    next_sibling: u32,   // Index into arena
    span: Span,
}
```

Benefits:
- Cache-friendly traversal (nodes are contiguous)
- No pointer chasing
- Trivial serialization
- Single allocation for entire tree

### Rust Tree API

```rust
/// Immutable tree built from parsing
pub struct Document {
    /// Arena of nodes
    nodes: Vec<Node>,

    /// Interned strings (element names, attribute keys)
    strings: StringInterner,

    /// Original source (for zero-copy content access)
    source: Arc<[u8]>,
}

impl Document {
    /// Parse input and build tree
    pub fn parse(input: &[u8]) -> Result<Document, ParseError>;

    /// Get root node
    pub fn root(&self) -> NodeRef<'_>;

    /// Iterate all nodes in document order
    pub fn iter(&self) -> impl Iterator<Item = NodeRef<'_>>;

    /// Find nodes matching a simple selector
    pub fn select(&self, selector: &str) -> impl Iterator<Item = NodeRef<'_>>;
}

/// Reference to a node (doesn't own anything)
#[derive(Copy, Clone)]
pub struct NodeRef<'a> {
    doc: &'a Document,
    index: u32,
}

impl<'a> NodeRef<'a> {
    pub fn kind(&self) -> NodeKind;
    pub fn name(&self) -> Option<&'a str>;
    pub fn id(&self) -> Option<&'a str>;
    pub fn classes(&self) -> impl Iterator<Item = &'a str>;
    pub fn attributes(&self) -> impl Iterator<Item = (&'a str, &'a str)>;
    pub fn text_content(&self) -> &'a str;

    pub fn parent(&self) -> Option<NodeRef<'a>>;
    pub fn children(&self) -> impl Iterator<Item = NodeRef<'a>>;
    pub fn next_sibling(&self) -> Option<NodeRef<'a>>;
    pub fn prev_sibling(&self) -> Option<NodeRef<'a>>;

    pub fn span(&self) -> Span;
}
```

### Ruby Lazy Projection

The magic: Ruby objects created **only when accessed**.

```ruby
# Parse returns immediately (just builds Rust tree)
doc = Udon::Document.parse(huge_file)  # Fast! No Ruby objects yet.

# Accessing root creates ONE Ruby object
root = doc.root  # Creates Udon::Node wrapper

# Iterating children creates objects lazily
root.children.each do |child|
  # Each child is created just-in-time
  puts child.name  # FFI call, creates Ruby String
end

# If you only access 10 nodes, only 10 Ruby objects created
# vs current: ALL events become Ruby Hashes immediately
```

### FFI Design for Lazy Access

```rust
// In udon-ffi or udon-ruby extension

#[no_mangle]
pub extern "C" fn udon_document_parse(
    input: *const u8,
    len: usize
) -> *mut Document;

#[no_mangle]
pub extern "C" fn udon_document_free(doc: *mut Document);

#[no_mangle]
pub extern "C" fn udon_document_root(doc: *const Document) -> u32;

#[no_mangle]
pub extern "C" fn udon_node_kind(doc: *const Document, index: u32) -> u8;

#[no_mangle]
pub extern "C" fn udon_node_name(
    doc: *const Document,
    index: u32,
    out_ptr: *mut *const u8,
    out_len: *mut usize
) -> bool;

#[no_mangle]
pub extern "C" fn udon_node_first_child(doc: *const Document, index: u32) -> i32;
// Returns -1 if no child, else child index

#[no_mangle]
pub extern "C" fn udon_node_next_sibling(doc: *const Document, index: u32) -> i32;
// Returns -1 if no sibling, else sibling index
```

Ruby extension wraps these with nice objects:

```ruby
class Udon::Document
  def initialize(ptr)
    @ptr = ptr
    ObjectSpace.define_finalizer(self, ->(id) { UdonNative.document_free(@ptr) })
  end

  def root
    @root ||= Node.new(@ptr, UdonNative.document_root(@ptr))
  end
end

class Udon::Node
  def initialize(doc_ptr, index)
    @doc_ptr = doc_ptr
    @index = index
  end

  def name
    @name ||= UdonNative.node_name(@doc_ptr, @index)
  end

  def children
    NodeChildIterator.new(@doc_ptr, @index)
  end

  # Enumerable-style iteration without Array allocation
  def each_child(&block)
    child_idx = UdonNative.node_first_child(@doc_ptr, @index)
    while child_idx >= 0
      yield Node.new(@doc_ptr, child_idx)
      child_idx = UdonNative.node_next_sibling(@doc_ptr, child_idx)
    end
  end
end
```

---

## Part 3: The Ideal Error System

### What "World-Class" Means

**Rust ecosystem expectations** (see rustc, cargo, ripgrep):
```
error[E0001]: unclosed bracket in element identity
  --> input.udon:15:7
   |
15 |   |div[my-id
   |       ^----- opening bracket here
   |
   = help: add closing `]` after the id
   = note: element identities use [id] syntax
```

**Ruby ecosystem expectations** (see did_you_mean, Rails):
```
Udon::ParseError: Unknown element suffix '~' at line 15, column 12

  |article~
          ^ unknown suffix

Did you mean one of: ? (optional), ! (required), * (zero-or-more), + (one-or-more)

Possible fix:
  |article?    # optional element
```

### Error Architecture

```rust
/// Rich error with full context
pub struct ParseError {
    /// Error code (for programmatic handling)
    pub code: ErrorCode,

    /// Human-readable message
    pub message: String,

    /// Primary span (where the error is)
    pub span: Span,

    /// Secondary spans (related locations)
    pub related: Vec<(Span, String)>,

    /// Suggested fixes
    pub suggestions: Vec<Suggestion>,

    /// Additional notes
    pub notes: Vec<String>,

    /// Severity
    pub severity: Severity,
}

pub enum Severity {
    Error,    // Cannot continue, must fix
    Warning,  // Suspicious but valid
    Hint,     // Style suggestion
}

pub struct Suggestion {
    pub message: String,
    pub span: Span,
    pub replacement: String,
}

/// Format error for terminal display
impl ParseError {
    pub fn render(&self, source: &str, colors: bool) -> String;
    pub fn render_json(&self) -> String;  // For tooling
}
```

### Error Recovery

The parser should find **multiple errors** per parse, not stop at first:

```rust
impl Parser {
    pub fn parse_recovering(&mut self) -> (Document, Vec<ParseError>) {
        // Continue parsing after errors
        // Return partial tree + all errors found
    }
}
```

Recovery strategies:
1. **Skip to next line** on malformed element
2. **Insert synthetic close** on unclosed bracket
3. **Treat as text** when element syntax is ambiguous
4. **Pop stack** on dedent past known element

### did_you_mean Integration (Ruby)

```ruby
module Udon
  class ParseError < StandardError
    attr_reader :code, :span, :suggestions

    def message
      msg = super
      if suggestions.any?
        msg += "\n\nDid you mean?\n"
        suggestions.each { |s| msg += "  #{s}\n" }
      end
      msg
    end
  end
end
```

For unknown element names, attribute keys, directive names—suggest similar valid ones.

---

## Part 4: Implementation Roadmap

### ⚠️ CORRECTED ORDER (See "Critical Architecture Insight" above)

The phases below were written in the wrong order. The streaming event model must come FIRST because it's the foundation. Here's the corrected sequence:

### Phase 2.0: Fix Event Model and Parser Generator (FIRST)

**Goal:** Establish streaming events as the primitive. Remove accumulation anti-patterns.

1. **Redesign Event enum for SAX-style streaming:**
   - `ElementStart { name }` — just the name, span
   - `ElementEnd`
   - `AttributeKey { key }` — followed by value event(s)
   - `ArrayStart` / `ArrayEnd`
   - Scalar values: `StringValue`, `IntValue`, `BoolValue`, etc.
   - No `Vec<>` or accumulated fields in any event

2. **Remove helper functions from parser template:**
   - Delete `parse_element_identity()` — express in DSL
   - Delete `parse_indented_attribute()` — express in DSL
   - Delete `parse_list_value()` — express in DSL
   - Keep only truly generic utilities (unicode XID checking)

3. **Express element identity in genmachine DSL:**
   - See `|` → enter element function
   - See letter → scan label, emit `ElementStart { name }`
   - See `[` → enter id-value parsing, emit `Attribute { key: "$id" }` + value events
   - See `.` → scan label, emit `Attribute { key: "$class", value }`
   - See `?!*+` → emit `Attribute { key: "<char>", value: true }`
   - Each piece emits immediately, no accumulation

4. **Express value parsing in genmachine DSL:**
   - `[` → emit `ArrayStart`, enter array-value state
   - Scan values, emit each immediately
   - `]` → emit `ArrayEnd`, return
   - Strings, integers, etc. all emit immediately

5. **Update tests to expect streaming event sequence**

**Deliverable:** Parser emits streaming events. No accumulation in parser. All logic in DSL.

### Phase 2.1: Core Parser Completion (AFTER 2.0)

**Goal:** Implement ALL features from SPEC.md using the corrected streaming architecture.

**Note:** `udon.machine` is from the old C implementation and may not match current SPEC.md. Use SPEC.md as the authoritative source, not the .machine file.

#### Elements & Identity (SPEC lines 43-105)
1. **Element suffixes** (`?`, `!`, `*`, `+`) — expand to `:'?' true` etc.
2. **Suffix positioning** — after name, after id, space-separated at end
3. **Anonymous elements** — `|[id]` or `|.class` with no name

#### Attributes (SPEC lines 107-143)
4. **Indented attributes** — `:key value` on indented line after element
5. **Complex attribute values** — attribute followed by newline+indent = structured value
6. **Inline lists** — `[a b c]`, `["quoted" items]`
7. **Value type parsing** — integers, floats, rationals, complex, booleans, nil (SPEC lines 726-821)

#### Hierarchy (SPEC lines 145-211)
8. **Inline children** — `|a |b |c` nests rightward
9. **Column-aligned siblings** — subsequent line at same column = sibling
10. **Embedded elements** — `|{name attrs content}` for inline in prose

#### Escape & Raw (SPEC lines 277-387)
11. **Escape prefix** — `'` prevents interpretation of next char
12. **Raw directives** — `!raw:lang` block form, `!raw:lang{content}` inline
13. **Freeform blocks** — triple-backtick for indent-insensitive content

#### Dynamics (SPEC lines 389-549)
14. **Interpolation** — `!{expr}`, `!{expr | filter1 | filter2}`
15. **Block directives** — `!if`, `!elif`, `!else`, `!unless`, `!for`, `!let`, `!include`
16. **Inline directives** — `!name{content}` with balanced braces

#### References (SPEC lines 551-633)
17. **Class mixins** — `|.defaults` defines, `|element.defaults` inherits
18. **ID references** — `@[id]` inserts element, `:[id]` merges attributes

#### Other
19. **Comments** — `;` at line start or inline
20. **Prose content** — anything not prefixed belongs to parent

**Deliverable:** All SPEC.md examples parse correctly. Comprehensive test suite.

### Phase 2.2: Tree Builder (1 week)

**Goal:** Build arena-allocated tree from events.

1. Design `Document` and `Node` structs
2. Implement tree builder that consumes events
3. Implement navigation (parent, children, siblings)
4. Implement simple selectors
5. Benchmark: tree building overhead

**Deliverable:** `Document::parse()` works, tree is navigable.

### Phase 2.3: Streaming Infrastructure (1-2 weeks)

**Goal:** True incremental parsing with ring buffer.

1. Design `StreamingParser` struct
2. Implement ring buffer
3. Implement chunk boundary handling
4. Implement backpressure
5. Benchmark: memory usage on large files

**Deliverable:** Can parse 1GB file with <10MB memory.

### Phase 2.4: Ruby Lazy Tree API (1 week)

**Goal:** Ruby Document/Node with lazy projection.

1. FFI bindings for tree access
2. Ruby wrapper classes
3. Lazy attribute/content access
4. Enumerable integration (no Array allocation for children)
5. Benchmark: compare to Nokogiri

**Deliverable:** `Udon::Document.parse()` faster than Nokogiri.

### Phase 2.5: Ruby Streaming API (1 week)

**Goal:** Ruby streaming parser.

1. FFI bindings for streaming
2. Ruby `Udon::StreamingParser` class
3. Enumerator integration (`parser.each_event`)
4. Benchmark: throughput on large files

**Deliverable:** Stream parsing available in Ruby.

### Phase 2.6: Error Message Polish (1 week)

**Goal:** World-class errors in both Rust and Ruby.

1. Design error code system
2. Implement rich error formatting
3. Add suggestions/did_you_mean
4. Recovery mode (multiple errors per parse)
5. Benchmark: error path overhead

**Deliverable:** Errors that make users smile.

### Phase 2.7: Benchmarking & Optimization (1 week)

**Goal:** Verify performance claims, optimize hot paths.

1. Comprehensive benchmark suite
2. Profile with flamegraph
3. Optimize identified bottlenecks
4. A/B comparison with Nokogiri, YAML, JSON
5. Document performance characteristics

**Deliverable:** Published benchmarks, optimization guide.

### Phase 2.8: WASM Bindings (1 week)

**Goal:** Browser and edge runtime support via WebAssembly.

WASM forces clean memory semantics—no GC, no refcounting, just arenas and handles.
This validates that our architecture generalizes beyond Ruby's runtime model.

1. **wasm-bindgen integration** in new `udon-wasm` crate
2. **Same APIs as Ruby:**
   - `Udon.parse(input)` → tree with lazy access
   - `Udon.parseStreaming(input)` → event iterator
3. **Memory management:**
   - Arena-allocated tree lives in WASM linear memory
   - JavaScript receives handles, not copies
   - Explicit `document.free()` to release memory
4. **Test suite via Node.js:**
   - `wasm-pack test --node`
   - Same test cases as Ruby
5. **Browser bundle:**
   - `wasm-pack build --target web`
   - ESM module for `<script type="module">`

**Deliverable:** `@anthropic/udon` npm package (or similar), works in Node.js and browsers.

### Phase 2.9: Python Bindings via PyO3 (1 week)

**Goal:** Python bindings mirroring the Ruby gem API.

Python's refcounting and GIL present different challenges than Ruby's GC.
This validates our FFI layer works across multiple managed runtimes.

1. **New `udon-python` repo** with PyO3 structure:
   ```
   udon-python/
   ├── src/lib.rs        # PyO3 bindings
   ├── udon/__init__.py  # Python interface
   ├── pyproject.toml    # maturin build config
   └── tests/
   ```

2. **Same APIs as Ruby:**
   ```python
   import udon

   # Tree API with lazy access
   doc = udon.parse(input)
   for child in doc.root.children:
       print(child.name, child.text_content)

   # Streaming API
   for event in udon.parse_streaming(input):
       if event.type == "element_start":
           print(event.name)
   ```

3. **PyO3 patterns:**
   - `#[pyclass]` for Document, Node
   - `#[pymethods]` for lazy property access
   - GIL-aware memory management

4. **Build via maturin:**
   ```bash
   maturin develop  # Dev install
   maturin build    # Wheel
   ```

5. **pytest test suite** — same test cases as Ruby

**Deliverable:** `udon` package on PyPI, works with Python 3.9+.

---

## Part 5: What We're NOT Doing in Phase 2

These are deferred to Phase 3:

1. ~~**Generator/genmachine polish** — Works well enough for now~~ **CORRECTION:** Genmachine fixes ARE Phase 2.0. The generator must produce a proper streaming parser. This is foundational, not polish.
2. **Markdown parsing** — Needs spec decisions first
3. **Liquid directives** — Needs design work
4. **Dialects** — Needs spec work
5. **Go/Swift/Java bindings** — After Python proves the pattern

---

## Part 6: Success Criteria

### Performance Targets

**Note on metrics:** MB/s is misleading when comparing formats with different verbosity (XML is ~50% larger than UDON for same content). Use **nodes/second** or **time to parse equivalent content** for fair comparisons.

| Metric | Target | Stretch |
|--------|--------|---------|
| Streaming (Rust) | 2M nodes/sec | 5M nodes/sec |
| Tree parse (Rust) | 1M nodes/sec | 2M nodes/sec |
| Tree parse (Ruby, lazy access) | 500K nodes/sec | 1M nodes/sec |
| Tree parse (Ruby, full traversal) | 200K nodes/sec | 500K nodes/sec |
| Memory (streaming, 1GB file) | <10 MB | <5 MB |
| Memory (tree, 100MB file) | <300 MB | <200 MB |

### Comparison Targets

Benchmarks must use **semantically equivalent documents** and measure **time to parse + traverse same content**.

| Parser | Our Target |
|--------|------------|
| Nokogiri (XML) | 2x faster on tree traversal |
| YAML (Psych) | 5x faster |
| JSON (Oj) | Match or beat |
| tree-sitter | Match streaming throughput |

**Benchmark methodology:**
- Generate equivalent content in UDON, XML, YAML, JSON
- Parse + traverse entire structure (count nodes, sum text bytes)
- Report: time (µs), nodes/second, memory peak
- Do NOT report MB/s (penalizes concise formats)

### Quality Targets

- Zero `unsafe` outside FFI boundary (or justified/audited)
- 100% SPEC.md coverage in tests
- Error messages reviewed by humans for clarity
- Documentation for all public APIs
- Benchmark results published and reproducible

---

## Part 7: Open Questions to Resolve

1. **Should streaming and tree share the same core parser?**
   - Option A: Single parser, two consumers (event sink vs tree builder)
   - Option B: Separate optimized paths
   - **RESOLVED: Option A.** The streaming parser is the foundation. The tree builder is just an event consumer. This is not a choice—it's the architecture. You cannot build a tree first and then "stream" from it.

2. **Should Ruby tree nodes cache FFI results?**
   - Option A: Always call FFI (simpler, less memory)
   - Option B: Cache on first access (faster repeated access)
   - Leaning: Option B with weak references

3. **How to handle errors in streaming mode?**
   - Option A: Error event in stream
   - Option B: Separate error channel
   - Option C: Both
   - Leaning: Option A (simpler)

4. **Should we support incremental re-parsing (like tree-sitter)?**
   - This would be amazing but complex
   - Defer to Phase 4 unless it falls out naturally

---

## Appendix: Reference Implementations to Study

### Nokogiri (Ruby XML)
- C extension with libxml2
- Lazy node creation
- Ruby objects wrap C pointers
- Study: FFI patterns, memory management

### tree-sitter (Universal parser)
- Incremental parsing
- Arena allocation
- Zero-copy syntax trees
- Study: Tree representation, streaming

### pulldown-cmark (Rust Markdown)
- Event-based streaming
- Zero allocations in hot path
- Study: Event design, performance tricks

### serde_json (Rust JSON)
- Zero-copy deserialization
- Streaming tokenizer
- Study: Memory efficiency

### Oj (Ruby JSON)
- C extension, very fast
- Multiple parsing modes
- Study: Why it beats stdlib by 10x

---

## Conclusion

Phase 2 is about building the **ideal** UDON parsing infrastructure—not just something that works, but something that's genuinely best-in-class. We have good foundations (clean event types, Rust core, FFI bridge) but the architecture is wrong (batch masquerading as streaming, eager Ruby object creation).

The path forward:
1. Complete the parser (all SPEC.md features)
2. Add proper tree structure
3. Add proper streaming
4. Add lazy Ruby projection
5. Add world-class errors
6. Measure and optimize

This is 6-8 weeks of focused work. At the end, UDON will have a parser that's faster than Nokogiri, streams like tree-sitter, and has errors as good as Rust's.

Worth it.
