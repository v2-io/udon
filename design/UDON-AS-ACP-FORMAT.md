# UDON as ACP's Native Format

*The convergence of Agent Context Protocol and UDON*

---

## The Realization

While brainstorming ACP (Agent Context Protocol), we kept inventing response structures:

```json
{
  "content": { ... },
  "structure": { "scope_chain": [...], "boundaries": {...} },
  "semantics": { "types": [...], "signature": {...} },
  "references": { "calls_out": [...], "called_by": [...] },
  "hazards": [ { "type": "...", "message": "..." } ],
  "confidence": { ... },
  "anchors": { ... }
}
```

And then inventing ways to enrich those structures, annotate them, query them, diff them, hand them off...

Meanwhile, UDON already provides:
- Mixed structure + prose
- Semantic nesting
- Attribute system
- Inline elements for annotations
- IDs for stable references
- Streaming-friendly parsing

**The convergence: ACP responses could *be* UDON documents.**

---

## What This Looks Like

### Current approach (JSON-ish)

```json
{
  "method": "context.read",
  "result": {
    "content": "pub fn parse_element(...) { ... }",
    "structure": {
      "scope_chain": [
        { "kind": "file", "name": "parser.rs" },
        { "kind": "impl", "name": "Parser" },
        { "kind": "function", "name": "parse_element" }
      ]
    },
    "hazards": [
      { "type": "public_api", "message": "Changes break consumers" }
    ]
  }
}
```

### UDON approach

```udon
|context.read
  :anchor @parser.rs::Parser::parse_element
  :intent editing

  |content
    pub fn parse_element(&mut self) -> Result<Element> {
        let token = self.peek()?;
        ...
    }

  |structure
    |scope :kind file :name parser.rs :line 1
    |scope :kind impl :name Parser :line 23
    |scope :kind function :name parse_element :line 67
    |boundary :start 67 :end 96
    |sibling :next @...::parse_attribute :line 98

  |semantics
    |signature
      :visibility public
      :params [self: "&mut Self"]
      :returns Result<Element>
    |complexity :cyclomatic 5 :cognitive 8

  |references
    |calls-out
      |ref :target @...::peek :line 68 :count 3
      |ref :target @...::advance :line 71
    |called-by
      |ref :source @...::parse_document :count 3
    |tested-by
      |ref :test test_parse_element_basic :file tests/parser_test.rs

  |hazards
    |hazard[public-api] :severity warning
      Signature changes would break external consumers.
    |hazard[ambiguous] :pattern "self.emit("
      Appears 7 times in file. Include more context for edits.

  |{@ :freshness now :confidence high :computed-by rust-analyzer}
```

---

## Why This Works

### 1. Self-Describing Responses

The response format documents itself. You can query it:
```
//|hazard[@severity='error']     # Find all error-level hazards
//|ref[@source]                  # Find all incoming references
//|{@}                           # Find all annotations
```

### 2. Responses Can Be Annotated

Agent receives response, adds its own notes:
```udon
  |hazards
    |hazard[public-api] :severity warning
      Signature changes would break external consumers.
      |{@ :agent claude :note "User said this is internal-only, may be safe to change"}
```

The annotation travels with the response through the agent's reasoning.

### 3. Responses Can Be Diffed

Agent makes a change, gets a new context read. Semantic diff:
```
DIFF: context.read v1 → v2

  |references
    |calls-out
+     |ref :target @...::validate :line 72  # NEW call added
    |called-by
~     :count 3 → 4  # One more caller

  |hazards
-   |hazard[ambiguous]  # REMOVED (pattern no longer ambiguous)
```

### 4. Responses Can Be Handed Off

Next agent needs context from previous agent's work:
```ruby
handoff = previous_response
  .keep("//|structure")           # Preserve structure understanding
  .keep("//|hazards")             # Preserve warnings
  .summarize("//|content", 100)   # Compress the actual code
  .keep("//|{@}")                 # Keep all annotations
```

### 5. Responses Are Streamable

Server streams response as it computes:
```
|context.read                    # Header immediately
  :anchor ...
  :status computing

  |structure                     # Structure available first (fast)
    |scope ...

  |content                       # Content as retrieved
    ...

  |references                    # References computed (slower)
    |computing...
    ...

  |semantics                     # Type info last (slowest)
    |computing...
    ...
```

Agent can start processing structure while semantics still computing.

---

## The Bidirectional Flow

**Agent → Server (requests):**
```udon
|request
  :method context.read
  :anchor @parser.rs::Parser::parse_element
  :intent editing
  :layers [structure semantics references]
  :max-depth 2
```

**Server → Agent (responses):**
```udon
|response
  :request-id abc123
  :status complete

  |context.read
    ...
```

**Agent → Agent (handoff):**
```udon
|handoff
  :from agent-1
  :to agent-2
  :timestamp 2024-12-25T10:30:00Z

  |context
    Working on adding parameter validation to parse_element.
    |{@ :confidence 0.9 Have a clear plan, just need to implement}

  |state
    |completed
      |step Identified all call sites (15 total)
      |step Drafted new signature
    |pending
      |step Update call sites with default value
      |step Add tests for new validation

  |artifacts
    |response @[ctx-read-abc123]  # Reference to the context read
    |proposed-change              # The change being developed
      ...
```

**Agent → Human (explanation):**
```udon
|explanation
  :for @[ctx-read-abc123]
  :audience developer

  |summary
    The parse_element function is the core element parser,
    called from 3 places during document parsing.

  |warnings
    This is a public API function. Any signature changes
    would require updating 15 call sites across 4 files.

  |recommendation
    Consider adding the new parameter with a default value
    to maintain backward compatibility.
```

Everything is UDON. The format is the protocol.

---

## What This Enables

### Unified Tooling

One parser, one query language, one diff tool, one formatter — works for:
- ACP responses
- Agent handoffs
- Configuration
- Documentation
- Test specifications
- Memory/state

### Composable Context

Agent accumulates context by merging UDON documents:
```ruby
full_context = UdonMerge.new
  .add(file_context)        # From file read
  .add(previous_handoff)    # From previous agent
  .add(user_instructions)   # From task description
  .add(schema_definition)   # From DSL spec
  .resolve_references       # @[...] references connected
  .dedupe                   # Remove redundant info
  .to_udon
```

### Traceable Reasoning

Everything the agent reads, thinks, decides — captured in UDON with annotations:
```udon
|reasoning-trace
  |step[1]
    |read @[file-parser.rs]
    |noticed
      Function has 15 call sites.
      |{@ :source //|references/|called-by :confidence high}

  |step[2]
    |considered
      Option A: Add required parameter (breaking change)
      Option B: Add optional parameter with default (safe)
      |{@ :chose B :reason "User didn't say breaking changes OK"}

  |step[3]
    |proposed
      @[change-proposal-xyz]
      |{@ :confidence 0.8 :uncertainty "Not sure about default value"}
```

### Semantic Validation Throughout

DSL validation applies to everything:
```udon
|!dsl[acp-response]
  |vocabulary
    |element[context.read]
      :children [content structure semantics references hazards]
    |element[hazard]
      :attrs [severity type]
      :severity-values [info warning error]
```

Malformed responses caught immediately.

---

## The Meta-Level

There's something elegant here: **the protocol for helping agents work with structured documents is itself a structured document in the same format.**

UDON describes how to read code → response is UDON
UDON describes how to edit code → change proposal is UDON
UDON describes how to hand off state → handoff is UDON
UDON describes itself → DSL definition is UDON

It's turtles all the way down, but in a good way.

---

## Open Questions

- **Performance**: Is UDON parsing fast enough for high-frequency tool responses?
- **Verbosity**: Is UDON more verbose than JSON for pure-data responses?
- **Familiarity**: Agents trained on JSON — does UDON require relearning?
- **Partial adoption**: Can UDON responses coexist with JSON in same protocol?

---

## Possible Evolution Path

1. **ACP v1**: JSON-based, conventional
2. **ACP v1.1**: UDON-based responses as optional format
3. **ACP v2**: UDON-native, JSON as legacy compatibility
4. **Eventually**: "ACP" becomes "UDON Protocol" — the format *is* the protocol

---

*This convergence wasn't planned — it emerged from noticing that every feature we wanted in ACP (annotations, queries, diffs, streaming, handoffs) was something UDON already supported or could naturally support. The format's properties make it a natural fit for agent-to-agent and agent-to-tool communication.*
