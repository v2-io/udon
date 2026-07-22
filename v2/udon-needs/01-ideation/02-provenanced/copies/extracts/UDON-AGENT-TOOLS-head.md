---
source: design/UDON-AGENT-TOOLS.md (head; Dec-2025 brainstorm, partially superseded)
gathered: 2026-07-21
status: gathered partial extract — residue still cited by TODO-AGENT-UX
paths:
  - design/UDON-AGENT-TOOLS.md
source_commit: 3d8e5b9c52b2a581c4ab9021984423073a694693  # verified byte-current 2026-07-21
categories:
  - semantic-merge
  - streaming
  - annotations
  - wishlist-stale-syntax
why_included: |
  Older brainstorm that still owns semantic merge, streaming partial-tree, annotation layer. Syntax stale; needs live. Complements newer principles doc.
---

> **Why gathered:** Older brainstorm that still owns semantic merge, streaming partial-tree, annotation layer. Syntax stale; needs live. Complements newer principles doc.

# UDON Agent Tools — Brainstorm

> **Status (2026-07-16).** Dec-2025, substantially superseded: the Tier-2/3
> tool ideas were absorbed and developed in `udon-agentic.md` (Jan 2026 —
> glance/focus/propose/apply/session/trace/infer/validate/search + the
> annotate/extract/diff/timeline/template/audit set), and the Tier-1
> streaming substrate landed in `core/` 2026-07-15 (`TreeStream` /
> `PushdownParser`). All syntax here predates 0.8/0.9 (`.class` is now
> `.trait`; `|{@ ...}` is not valid — inline elements take a name, `@` is a
> reference; the attribute model changed wholesale) — `spec/CORE.md` is the
> authority. Still-live residue is tracked in `../ux/TODO-AGENT-UX.md`:
> semantic merge, mid-generation partial-tree feedback, the annotation
> layer, handoff/compaction/memory, plus JSON/YAML round-trip (§Tier 4,
> UTILS-lane material).

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
