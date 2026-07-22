---
source: ~/src/_ref/_arch/sar3/lsp_chunking_concept.md — the aspirational design for semantically-enriched code chunks (the "what a rich chunk could carry" vision behind the AST post-mortem)
gathered: 2026-07-21
status: gathered (verbatim whole copy)
paths:
  - /Users/josephwecker-v2/src/_ref/_arch/sar3/lsp_chunking_concept.md
source_commit: (non-git) source_mtime 2025-11-16
categories: [self-chunking, rag-embeddings, chunk-metadata-payload, agent-memory-context, tier2-shipped-practice]
why_included: >
  Witness: the design-of-record for WHY a retrieval chunk wants more than its raw
  text — cross-file context, inferred types, extracted docs, caller/callee usage,
  call hierarchy — each with a concrete before/after chunk example and a claimed
  "20-40% better retrieval accuracy" (stated as estimate, not measured here — the
  measurement is in sar3-lsp-enrichment-measured.md). Read as the aspiration paired
  with its own honest reality-check (sar3-AST_VS_LSP_REALITY.md). Maps directly onto
  UDON's README "embedding-granularity" table (elements = discrete semantic units,
  attributes = property assertions): this is the same argument that structure-carried
  metadata enriches an embedding, made by a builder one substrate over. For the
  harness consumer: a spec for what a self-describing unit of context should carry
  so retrieval finds it by meaning, not just by name.
---

# LSP-Based Intelligent Code Chunking

## Why LSP > AST for Chunking

### AST Limitations
- **Single file only** - can't see cross-file dependencies
- **Syntax only** - no semantic understanding
- **No type info** - especially in dynamic languages like Ruby
- **Missing usage patterns** - don't know how code is called
- **Manual doc parsing** - have to parse RDoc/YARD yourself

### LSP Superpowers

#### 1. Cross-File Context
```ruby
# app/models/user.rb
class User < ApplicationRecord
  def authenticate(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end
end
```

**LSP knows:**
- `User` inherits from `ApplicationRecord` (different file)
- Uses `BCrypt::Password` (gem dependency)
- `password_digest` comes from database column
- This method is called from `SessionsController#create`

**Chunk becomes:**
```
File: app/models/user.rb
Class: User < ApplicationRecord (Active Record model)
Method: authenticate(password) -> Boolean
Dependencies: BCrypt (gem), password_digest (database column)
Called by: SessionsController#create, AuthenticationService#verify
Calls: BCrypt::Password.new, is_password?

def authenticate(password)
  BCrypt::Password.new(password_digest).is_password?(password)
end
```

#### 2. Type Inference (Even Without Type Annotations!)

```ruby
def process_order(items)
  items.map { |item| item.price * item.quantity }
       .sum
end
```

**LSP infers:**
- `items`: Array-like (responds to `map`)
- Each `item`: Object with `price` and `quantity` methods
- Return type: Numeric (from `sum`)

**Chunk context:**
```
Method: process_order
Inferred signature: (Array<Item>) -> Numeric
Where Item responds to: :price, :quantity
```

#### 3. Documentation Extraction

```ruby
# @param username [String] the user's login name
# @param email [String] the user's email address
# @return [User, nil] created user or nil on failure
def create_user(username, email)
  # ...
end
```

**LSP parses YARD/RDoc automatically:**
- Parameter types
- Return types
- Descriptions
- Examples

#### 4. Usage Context

```ruby
def send_notification(user, message)
  # LSP knows this is called from:
  # - OrderMailer#order_confirmed
  # - UserMailer#welcome_email
  # - NotificationWorker#perform
end
```

**Chunk includes usage patterns:**
```
Called by:
- OrderMailer#order_confirmed (order notifications)
- UserMailer#welcome_email (user onboarding)
- NotificationWorker#perform (async notifications)

Common patterns:
- Usually called with User model instance
- Message is typically a String or Hash
- Often called from background jobs
```

#### 5. Call Hierarchy

```ruby
def checkout_order
  validate_cart    # -> calls multiple validators
  calculate_total  # -> calls pricing engine
  process_payment  # -> calls payment gateway
  send_confirmation # -> calls notification system
end
```

**LSP provides full call graph:**
```
checkout_order calls:
├── validate_cart
│   ├── check_inventory
│   └── validate_address
├── calculate_total
│   ├── apply_discounts
│   └── calculate_tax
├── process_payment
│   └── PaymentGateway.charge
└── send_confirmation
    └── NotificationService.send
```

## Ruby LSP Options

### 1. Solargraph (Most Popular)
```bash
gem install solargraph
```

Provides:
- Type inference via YARD docs
- Completion, definitions, references
- Documentation on hover
- Signature help

### 2. Ruby LSP (Shopify - Official)
```bash
gem install ruby-lsp
```

Newer, faster, better Rails support:
- Semantic highlighting
- Code lens (shows references inline)
- Fast indexing
- Great Rails integration

### 3. Steep (Type Checking)
```bash
gem install steep
```

For projects using RBS (Ruby signatures):
- Full type checking
- Type inference
- Better for statically-typed Ruby

## Implementation Strategy

### Architecture

```
┌─────────────────┐
│  LSP Server     │ (Solargraph/Ruby LSP)
│  (ruby process) │
└────────┬────────┘
         │ JSON-RPC
         ↓
┌─────────────────┐
│ Python Client   │ (pygls or manual JSON-RPC)
│                 │
├─────────────────┤
│ Chunking Logic  │
│ - Get symbols   │
│ - Get types     │
│ - Get refs      │
│ - Build context │
└─────────────────┘
         ↓
┌─────────────────┐
│  Embeddings     │ (SFR-Code-2B_R)
└─────────────────┘
```

### Key LSP Methods to Use

#### Document Symbols
```python
symbols = lsp.text_document_document_symbol(uri)
# Returns hierarchy: modules, classes, methods with locations
```

#### Hover (Documentation)
```python
hover = lsp.text_document_hover(uri, line, char)
# Returns: signature, docs, type info
```

#### Definition
```python
definition = lsp.text_document_definition(uri, line, char)
# Returns: where something is defined
```

#### References
```python
references = lsp.text_document_references(uri, line, char)
# Returns: all places this is used
```

#### Type Definition
```python
type_def = lsp.text_document_type_definition(uri, line, char)
# Returns: type information
```

#### Call Hierarchy
```python
calls = lsp.call_hierarchy_incoming_calls(symbol)
outgoing = lsp.call_hierarchy_outgoing_calls(symbol)
# Returns: what calls this, what this calls
```

## Example Chunking Algorithm

```python
def chunk_with_lsp(file_path, lsp_client):
    """Create semantically-rich chunks using LSP."""

    # 1. Get all symbols in file
    symbols = lsp_client.get_document_symbols(file_path)

    chunks = []
    for symbol in symbols:
        # 2. Get symbol details
        hover = lsp_client.hover(symbol.location)
        signature = extract_signature(hover)
        docs = extract_documentation(hover)

        # 3. Get usage context
        references = lsp_client.find_references(symbol.location)
        callers = group_by_file(references)

        # 4. Get call hierarchy
        outgoing = lsp_client.outgoing_calls(symbol)
        dependencies = [call.name for call in outgoing]

        # 5. Get type information
        type_info = lsp_client.type_definition(symbol.location)

        # 6. Extract source code
        code = extract_source(file_path, symbol.range)

        # 7. Build rich context
        context = f"""
File: {file_path}
{symbol.kind}: {symbol.name}
Signature: {signature}
{docs}

Type information:
{format_type_info(type_info)}

Called by ({len(callers)} locations):
{format_callers(callers[:5])}  # Top 5

Calls:
{format_dependencies(dependencies)}

Related symbols:
{find_related_symbols(symbol, symbols)}
"""

        chunk = CodeChunk(
            content=code,
            context=context,
            metadata={
                'file': file_path,
                'symbol': symbol.name,
                'type': symbol.kind,
                'callers': callers,
                'dependencies': dependencies,
            }
        )
        chunks.append(chunk)

    return chunks
```

## Concrete Benefits for Embeddings

### Before (AST-only):
```
File: app/services/payment_processor.rb
Method: process_payment

def process_payment(order_id, amount)
  order = Order.find(order_id)
  gateway.charge(amount, order.payment_method)
end
```

### After (LSP-enriched):
```
File: app/services/payment_processor.rb
Class: PaymentProcessor (Service Object pattern)
Method: process_payment(order_id: Integer, amount: Money) -> PaymentResult

Description: Processes payment for an order through configured payment gateway

Dependencies:
- Order (ActiveRecord model) - finds order by ID
- gateway: PaymentGateway - injected dependency
- Money gem - amount handling

Called by:
- OrdersController#checkout (web flow)
- SubscriptionWorker#process_renewal (background job)
- RefundService#process_refund (admin action)

Calls:
- Order.find (ActiveRecord)
- gateway.charge (PaymentGateway API)

Common usage pattern:
  processor = PaymentProcessor.new(gateway: StripeGateway.new)
  result = processor.process_payment(123, Money.new(5000, 'USD'))

def process_payment(order_id, amount)
  order = Order.find(order_id)
  gateway.charge(amount, order.payment_method)
end
```

**Embedding quality improvement:** This rich context means when you search for:
- "payment processing" → finds this
- "stripe integration" → finds this (via gateway type)
- "background job payment" → finds this (via callers)
- "order checkout" → finds this (via callers)
- "refund logic" → finds this (via callers)

## For Ruby Specifically

### Rails Magic Resolution

LSP can resolve Rails magic:

```ruby
class User < ApplicationRecord
  has_many :posts
  validates :email, presence: true
end
```

LSP knows:
- `has_many :posts` creates methods: `posts`, `posts=`, `posts<<`, etc.
- `validates` is a class macro
- `ApplicationRecord` location
- Database schema (if available)

### Gems/Dependencies

LSP indexes installed gems:

```ruby
require 'stripe'

Stripe::Charge.create(...)
```

LSP knows:
- `Stripe::Charge` is from stripe gem
- Method signatures from gem
- Documentation from gem

## Implementation Proof of Concept

Want me to create a working prototype that:
1. Starts a Ruby LSP server (Solargraph)
2. Queries it for symbols, types, references
3. Builds rich chunks
4. Embeds with SFR-Code-2B_R
5. Shows the quality improvement?

## Challenges & Solutions

### Challenge 1: LSP Server Overhead
Starting LSP for every chunking run is slow.

**Solution:** Keep LSP server running, use incremental updates
```python
class LSPChunker:
    def __init__(self):
        self.lsp = start_lsp_server()  # Once

    def chunk_project(self, paths):
        for path in paths:
            self.lsp.did_open(path)  # Incremental
            yield self.chunk_file(path)
```

### Challenge 2: Large Codebases
Indexing 100K+ files takes time.

**Solution:** Chunk incrementally, cache results
```python
cache = ChunkCache('~/.code-chunks')
if cache.is_stale(file_path):
    chunks = chunk_with_lsp(file_path)
    cache.save(file_path, chunks)
```

### Challenge 3: LSP Accuracy
Type inference not perfect in dynamic Ruby.

**Solution:** Combine LSP + static analysis + heuristics
```python
type_info = (
    lsp.type_definition(symbol) or      # Try LSP first
    yard_parser.infer_type(symbol) or    # Try YARD docs
    heuristic_type(symbol)               # Fallback to patterns
)
```

## ROI Estimate

**Effort:**
- Basic LSP integration: 2-3 days
- Production-ready: 1-2 weeks
- With caching/optimization: 2-3 weeks

**Benefit:**
- 20-40% better retrieval accuracy (estimate based on context richness)
- Cross-file queries work ("what calls this?")
- Type-aware search ("functions returning User")
- Usage-aware search ("code used in background jobs")

## Next Steps

Should I build a prototype showing:
1. LSP client in Python connecting to Solargraph
2. Extracting rich semantic info
3. Building contextualized chunks
4. Comparing embedding quality vs AST-only?
