# UDON Agent Tools — Brainstorm

*Tooling ideas for UDON as an agent-native format*

---

## UDON's Unique Properties

What makes UDON interesting for agents specifically:

- **Mixed prose + structure** — Not just data (JSON) or just text (Markdown), but both interleaved
- **Tiers of voice** — Prose, comments, elements, inline elements, attributes, dynamics — each semantically distinct
- **Streaming-friendly** — Indent-based nesting means you know structure as you go
- **AI-agent readable/writable** — Clean syntax, no escaping hell, semantic clarity

This isn't just "another config format." It's potentially a native medium for agent thought and communication.

---

## Tier 1: Essential Infrastructure

### 1. Streaming Parser with Partial Tree Access

This is the killer feature. Current streaming is token-level — you get characters as they come but no semantic understanding until the document is complete.

UDON's structure enables *semantic streaming*:

```
Agent is writing...
  |article[foo]
    :status dr█  ← cursor here

Partial tree available NOW:
{
  open_elements: [
    { tag: "article", id: "foo", complete: false, line: 1 }
  ],
  current_attribute: {
    name: "status",
    partial_value: "dr",
    complete: false
  },
  closed_elements: []
}
```

**What this enables:**

- **Incremental validation**: `:status` expects `[draft|published|archived]` — "dr" is prefix of "draft" (valid so far)
- **Early error detection**: If agent writes `:status 42`, catch it immediately, not after 500 more tokens
- **Progress tracking**: "Document is 3 elements deep, 2 complete, 1 in progress"
- **Interrupt/resume**: If generation stops, partial tree tells next agent exactly where things stand
- **Guided generation**: Constraints can influence what tokens are likely/allowed next

This is the agent equivalent of syntax highlighting while you type — immediate semantic feedback during generation.

**API shape:**

```ruby
parser = UdonStreaming.new(schema: article_schema)

parser.feed("|article[foo]\n")
# => { event: :element_open, tag: "article", id: "foo" }

parser.feed("  :status ")
# => { event: :attribute_start, name: "status" }

parser.feed("dra")
# => { event: :attribute_partial, name: "status", value: "dra",
#      validation: :valid_prefix, candidates: ["draft"] }

parser.feed("ft\n")
# => { event: :attribute_complete, name: "status", value: "draft",
#      validation: :valid }

parser.state
# => { open: [article[foo]], complete: [], depth: 1,
#      current_element_attrs: { status: "draft" } }
```

### 2. Semantic Diff

Not "lines 3-7 changed" but "what's semantically different":

```
UDON DIFF: v1 → v2

ELEMENTS:
  + |error[409] added (new element)
  ~ |endpoint[create-user] modified:
      :auth: optional → required
      :rate-limit: 10 → 100

PROSE:
  ~ |description: minor wording change (73% similar)

STRUCTURE:
  ⟳ |response-codes reordered children (no semantic change)
```

Agents understand *what changed*, not just *where bytes differ*.

**Inverse: "What Changed" Narrator**

Given diff, produce prose:

```
"The create-user endpoint now requires authentication (was optional).
Rate limit increased from 10 to 100 requests. A new 409 Conflict
error response was documented for duplicate usernames."
```

This is agent→human communication. The agent has the structured diff; the narrator renders it for humans.

### 3. Semantic Merge

When two agents modify the same UDON doc:

```
Base:
  |config
    :timeout 30
    :retries 3

Agent A:                    Agent B:
  |config                     |config
    :timeout 60  ← changed      :timeout 30
    :retries 3                  :retries 5  ← changed
                                :new-field true  ← added
```

Merge result:
```
|config
  :timeout 60      ; from A (conflict: B had 30, A had 60)
  :retries 5       ; from B
  :new-field true  ; from B (addition, no conflict)

  |{@ :merge-conflict :attr timeout
     A set 60, B kept 30. Resolved to A's value.}
```

**Merge strategies:**
- **Attributes**: Last-write-wins, or flag conflicts via annotations
- **Prose**: Paragraph-level merge (like Google Docs)
- **Structure**: Element-aware conflict detection
- **Annotations**: Accumulate (both agents' notes preserved)

---

## Tier 2: Agent-Native Tools

### 4. Inline Annotation Layer

Agents add metacognition *in* the document without modifying content:

```udon
|config
  :timeout 30  |{@ :confidence 0.6 Seems low for batch job described above}
  :retries 5   |{@ :source inferred :basis "similar configs use 3-5"}

|endpoint[create-user]
  :auth required  |{@ :decision "Changed from optional per security review"}
  :rate-limit 100
    |{@ :uncertainty :options [50 100 200]
       Not sure what's appropriate. 100 is middle ground.}
```

The `|{@ ...}` annotation element is:
- **Semantically distinct** — Strippable before execution/rendering
- **Structured** — Not just prose comments, has queryable attributes
- **Machine-readable** — Other agents can find and process them
- **Preserves reasoning** — Why was this decision made? What's uncertain?

**Annotation attributes:**
- `:confidence` — How sure is the agent (0.0-1.0)
- `:source` — Where did this come from (inferred, stated, copied, etc.)
- `:decision` — Why this choice was made
- `:uncertainty` — What alternatives were considered
- `:agent` — Which agent wrote this
- `:timestamp` — When
- `:references` — Links to other elements or external sources

**Stripping annotations:**
```ruby
doc.strip_annotations                    # Remove all
doc.strip_annotations(below: 0.8)        # Remove low-confidence
doc.strip_annotations(agent: "claude")   # Remove from specific agent
doc.annotations_only                     # Extract just annotations
```

### 5. Context Handoff Generator

The 100% context turnover problem: how does one agent pass working state to another?

```ruby
handoff = UdonHandoff.new(current_doc)
  .preserve_structure           # Keep all |elements (skeleton)
  .summarize_prose(max: 500)    # Compress narrative content
  .keep_elements(".decision")   # Preserve elements with .decision class
  .keep_annotations(:high)      # Keep high-confidence annotations only
  .drop_annotations(:wip)       # Remove work-in-progress notes
  .add_continuation_note(
    "Stopped after schema validation. See |error[validation-failed].
     Next: fix the :auth attribute type mismatch."
  )

handoff.to_udon
# => Compressed UDON document ready for next agent
```

**What gets preserved:**
- Structure (element tree, ids, relationships)
- Critical decisions (marked as such)
- High-confidence assertions
- Explicit continuation point

**What gets compressed/dropped:**
- Verbose prose (summarized)
- Low-confidence speculation
- Working notes
- Redundant context

The result: next agent gets a minimal but complete context to continue work.

### 6. Query Language

XPath/JQ for UDON:

```
//|endpoint                           # All endpoint elements
//|endpoint[@method='POST']           # POST endpoints
//|endpoint[@method='POST']/|response # Responses under POST endpoints
//*[@.auth]                           # Anything with .auth class
//|{@ :confidence < 0.5}              # Low-confidence annotations
//|error[*]                           # All error elements (any id)
...|{field :required}                 # Inline fields with :required
```

**Query API:**
```ruby
doc.query("//|endpoint[@method='POST']")
# => [Element, Element, ...]

doc.query("//|{@ :agent 'claude'}").map(&:parent)
# => Elements that have Claude annotations

doc.query_one("/|config/:timeout")
# => 30 (attribute value)
```

**Query in annotations:**
```udon
|{@ :see //|endpoint[create-user]/:auth
   This relates to the auth decision there.}
```

Cross-references within the document using query syntax.

---

## Tier 3: DSL Enablement

### 7. DSL Definition Format

UDON as a meta-language for defining domain-specific vocabularies:

```udon
|!dsl[api-spec]
  :version 1.0

  |vocabulary
    |element[endpoint] :required true
      :attrs [method path auth rate-limit]
      :children [request response error]

    |element[response]
      :attrs [status content-type]
      :children [body example]

    |inline[field]
      :attrs [name type required default]

  |constraints
    |rule "|endpoint requires at least one |response child"
    |rule ":method must be one of [GET POST PUT DELETE PATCH]"
    |rule ":status must be integer 100-599"

  |defaults
    :method GET
    :content-type application/json
```

From this definition, generate:
- **Validator** — Check documents conform to DSL
- **TypeScript types** — For tooling integration
- **Schema** — JSON Schema or similar for external tools
- **Documentation** — Human-readable DSL reference
- **Completion hints** — What elements/attributes are valid here?

### 8. DSL Linter / Language Server

Real-time feedback while writing:

```
|endpoint[create-user]
  :method POTS
         ^^^^ Error: expected one of [GET POST PUT DELETE PATCH]

  |response :status OK
                    ^^ Error: :status expects integer, got string

  |reponse :status 200
   ^^^^^^^ Warning: Unknown element 'reponse'. Did you mean 'response'?
```

For agents, this is pre-generation validation:
- "You're about to write `:method POTS` — that's invalid"
- "In this context, valid children are: |request, |response, |error"
- "The :auth attribute expects a boolean or 'required'/'optional'"

### 9. DSL Scaffold Generator

Bootstrap a new DSL:

```bash
$ udon-dsl init "experiment-narrative"

Generated:
  experiment-narrative/
    dsl.udon           # DSL definition
    examples/
      basic.udon       # Example document
    validators/
      validator.rb     # Generated validator
    types/
      types.ts         # TypeScript definitions
    docs/
      reference.md     # Generated documentation
```

The `dsl.udon` starts with suggested vocabulary based on the name:
```udon
|!dsl[experiment-narrative]
  |vocabulary
    |element[experiment] :root true
    |element[hypothesis]
    |element[method]
    |element[observation]
    |element[result]
    |inline[measurement] :attrs [value unit confidence]
    |inline[reference] :attrs [source page]
```

---

## Tier 4: Interop & Conversion

### 10. UDON ↔ JSON/YAML

Round-trip conversion (with prose preserved):

```udon
|config
  :timeout 30
  :retries 5
  This is a configuration for the batch processor.
  It handles overnight jobs.
```

→ JSON:
```json
{
  "_element": "config",
  "timeout": 30,
  "retries": 5,
  "_prose": "This is a configuration for the batch processor.\nIt handles overnight jobs."
}
```

→ Back to UDON: identical

**Lossy but cleaner option:**
```json
{
  "config": {
    "timeout": 30,
    "retries": 5
  }
}
```
(Prose stored in `_meta` or dropped with warning)

### 11. UDON → Markdown

Render for humans:

```udon
|doc
  :title API Reference

  |endpoint[create-user]
    :method POST
    :path /users
    Creates a new user in the system.

    |response :status 201
      Returns the created user object.
```

→ Markdown:
```markdown
# API Reference

## create-user

**POST** `/users`

Creates a new user in the system.

### Response: 201

Returns the created user object.
```

### 12. Markdown → UDON (Structurizer)

Parse existing docs, infer structure:

```markdown
# Configuration

Set the timeout to 30 seconds for batch jobs.

## Options

- **timeout**: Number of seconds (default: 30)
- **retries**: How many times to retry (default: 3)
```

→ UDON (inferred):
```udon
|section[configuration]
  Set the timeout to 30 seconds for batch jobs.

  |section[options]
    |list
      |item |{strong timeout}: Number of seconds (default: 30)
      |item |{strong retries}: How many times to retry (default: 3)
```

Or with more aggressive structuring:
```udon
|configuration
  Set the timeout to 30 seconds for batch jobs.

  |options
    |option[timeout] :type number :default 30
      Number of seconds
    |option[retries] :type number :default 3
      How many times to retry
```

Agent can choose inference level.

---

## Meta-Tools

### 13. UDON Trace

For debugging agent work: what was read/written when?

```ruby
trace = UdonTrace.new(doc)

trace.record(:read, "//|endpoint[create-user]", agent: "claude")
trace.record(:modify, "//|endpoint[create-user]/:auth",
             old: "optional", new: "required", agent: "claude")
trace.record(:add, "//|error[409]", agent: "claude")

trace.summary
# => "claude read create-user endpoint, changed auth optional→required, added error 409"

trace.as_udon  # Trace itself as UDON document
```

### 14. UDON Explain

Take a UDON document, produce prose explanation:

```ruby
explainer = UdonExplain.new(doc, audience: :developer)
explainer.explain("//|endpoint[create-user]")

# => "The create-user endpoint accepts POST requests to /users.
#     It requires authentication (auth: required) and is rate-limited
#     to 100 requests per window. On success, it returns a 201 with
#     the created user. It may return 409 Conflict if the username
#     already exists."
```

Different audiences get different explanations:
- `:developer` — Technical, includes all attributes
- `:user` — High-level, focuses on what it does
- `:auditor` — Security-focused, highlights auth/permissions

### 15. UDON Context Window

For LLM context management — extract/summarize to fit window:

```ruby
compactor = UdonContextWindow.new(doc, max_tokens: 4000)

compactor.strategy(:preserve_structure)    # Keep element tree, compress prose
compactor.strategy(:preserve_decisions)    # Keep .decision elements verbatim
compactor.strategy(:summarize_examples)    # Collapse example blocks
compactor.strategy(:drop_annotations, below: 0.7)  # Drop low-confidence notes

result = compactor.compact
# => UDON document that fits in 4000 tokens
# => Includes metadata about what was dropped/compressed
```

---

## Wild Ideas

**UDON as Agent Memory Format**

Agents maintain persistent memory as UDON documents:
```udon
|memory[project-x]
  :last-touched 2024-12-25
  :agent claude

  |context
    Working on API documentation for Project X.
    User prefers explicit error handling.

  |decisions
    |decision[auth-required]
      :date 2024-12-24
      :confidence 0.9
      Made auth required after security review discussion.

  |uncertainties
    |uncertainty[rate-limits]
      Not sure what rate limits are appropriate.
      User said "reasonable" but didn't specify.

  |todos
    |todo :status pending
      Document the 409 error response
    |todo :status done
      Add authentication requirement
```

Next session: agent loads memory, has full context.

**UDON as Agent Protocol**

Agents communicate via UDON messages:
```udon
|message
  :from agent-1
  :to agent-2
  :type handoff

  |context
    Completed schema validation.
    Found 3 issues (see |issues below).

  |issues
    |issue :severity error :location //|endpoint[create-user]/:auth
      Type mismatch: expected boolean, got string "required"

  |request
    Please fix the type issues and re-validate.

  |attachments
    @[current-doc]  ; Reference to document being worked on
```

**UDON as Test Specification**

```udon
|test[create-user-success]
  :endpoint @[create-user]

  |given
    |request
      :method POST
      :body |{json {"name": "Alice", "email": "alice@example.com"}}

  |expect
    |response :status 201
      |body :has name :eq "Alice"
      |body :has id :type integer

  |{@ :generated true :from-example @[create-user]/|example[basic]}
```

---

## Implementation Priority

If building this incrementally:

**Phase 1: Foundation**
1. Streaming parser with partial tree access
2. Basic query language
3. JSON round-trip

**Phase 2: Agent Features**
4. Annotation layer support
5. Semantic diff
6. Context handoff generator

**Phase 3: DSL Support**
7. DSL definition format
8. Validator generation
9. DSL linter

**Phase 4: Ecosystem**
10. Markdown conversion (both directions)
11. Trace/debugging tools
12. Memory/protocol experiments

---

*These tools assume UDON becomes a native format for agent work — not just something agents read, but something they think in, communicate with, and persist through. The format's properties (mixed prose+structure, streaming-friendly, semantic clarity) make this plausible in a way that JSON or Markdown alone couldn't support.*
