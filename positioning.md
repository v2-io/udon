# UDON Positioning

UDON is a document-and-data notation optimized for AI agents. It treats structure
and content as peers, staying unambiguous in plain text without syntax
highlighting—because agents don't have syntax highlighting in their read
workflow. The fact that humans also find it clear is a fortunate consequence,
not the design goal.

## Why agents need this

Agents read and write configuration, documentation, prompts, and structured
artifacts constantly. Existing formats force tradeoffs:

- **JSON/YAML**: Machine-first, but humans (and agents reading without tooling)
  struggle with noise, nesting, and in YAML's case, value sniffing surprises.
- **Markdown**: Prose-first, but structured data requires frontmatter islands
  or escaping to other formats.
- **XML**: Verbose closing tags obscure structure; scanning is slow.

UDON resolves this by making structure visually obvious through prefixes and
indentation, so agents can parse documents correctly on first read—and generate
them correctly on first write.

## Why human-readable is a consequence, not the goal

Agents need unambiguous, explicit, well-structured text. It turns out that's
also what humans find clear. The design choices that help agents—prefix-based
tiers, syntactic typing, indentation hierarchy, explicit boundaries—happen to
produce documents that humans can scan without syntax highlighting.

This is not a coincidence: comprehension requires the same properties whether
the reader is human or machine. UDON optimizes for agent comprehension and gets
human readability as a side effect.

## Unique strengths

### 1) Unambiguous without syntax highlighting

Agents read plain text. UDON's prefix system (`|` structure, `:` attributes,
`!` dynamics, `;` comments) creates stable visual anchors that distinguish
content types without IDE support. What agents see is what agents get.

### 2) Explicit tiers of voice

UDON distinguishes content, comments, elements, attributes, inline elements, and
dynamics with clear prefixes. This isn't just syntax—it's a layered model where
each tier has distinct semantics.

This is particularly valuable for agents: when generating, they know exactly
which tier to use for each purpose. When reading, they can instantly classify
what they're looking at. No ambiguity about whether something is a comment, an
attribute, structural markup, or content. The tiers are the API contract between
author and reader—human or machine.

### 3) Structure and content interleave at any depth

Most formats force a split: data in one file, prose in another, or frontmatter
glued to the top. UDON lets structure and content flow together at any depth,
which is critical for specs, runbooks, policies, and templates.

### 4) Content is not just prose

The content layer is "anything that doesn't need UDON's structural syntax"—not
just human narrative. A DOT graph, a regex, a formula, structured text patterns:
these can live in the content layer without escaping to `!raw:` as long as there
are no syntactic collisions.

The question for any embedded notation isn't "UDON vs X" but "does wrapping X
in UDON's structural layer add clarity?" Sometimes yes—when you need metadata,
context, or hierarchy around it. Sometimes no—when the notation is already
optimal for its narrow purpose. You only escape to `!raw:` when you'd have
actual syntactic collisions with UDON's prefixes.

### 5) Syntactic typing (no value sniffing)

Types are determined by syntax, not parser heuristics. This avoids the YAML
class of surprises (`no`, `on`, `Norway` → boolean). Agents can trust that
what they write will parse as intended.

### 6) Stream-friendly generation

The grammar is line- and indent-driven. Agents can emit valid UDON token by
token without buffering—critical for streaming LLM output. Partial documents
remain parseable.

### 7) Natural chunk boundaries for RAG

UDON's structural elements are explicit semantic units. Chunking is intentional
and deterministic rather than heuristic, improving retrieval quality when agents
search knowledge bases.

### 8) Indentation replaces closing tags

Hierarchy is visible without closing-tag noise. This preserves scanning ease
while retaining structural precision—agents don't waste tokens on `</element>`.

### 9) Inline structure without inline chaos

Embedded elements (`|{...}`) allow structured semantics inside content without
breaking flow. Agents get inline meaning when needed, plain text otherwise.
This provides inline semantics without HTML noise—critical for content authoring
systems and anywhere structured annotations must live within running text.

### 10) Host-extensible dynamics

The `!` prefix provides a clean seam for templating (`!if`, `!for`) and raw
content (`!raw:sql`, `!raw:json`). Hosts define dialect behavior; the core
parser stays simple.

## Technical advantages

These emerge from UDON's syntax and model:

- **Reduced mode switching**: Structure, content, comments, and dynamics share
  one surface. Agents move between them without context jumps.
- **Lower cognitive load**: Prefixes create stable visual anchors in plain text,
  so scanning works even without syntax highlighting. This benefits agents (who
  never have highlighting) and humans (who sometimes don't).
- **Deterministic typing**: Syntax defines types, making diffs and validations
  reliable.
- **Event-friendly parsing**: Line- and indent-driven structure enables
  streaming parsers, incremental output, and partial subtree emission.
- **Clear edit boundaries**: Attributes are grouped; structure is explicit.
  This improves merge behavior in collaborative (human+agent) editing.
- **Stable generation**: Explicit tiers and syntactic typing reduce ambiguity
  in agent-generated edits. Agents don't accidentally create YAML bombs.
- **Natural retrieval units**: Element boundaries map to semantic chunks,
  improving indexing and retrieval without heuristics.
- **Polyglot friendly**: A single UDON document can include host-specific
  `!raw:lang` blocks that other hosts ignore, enabling cross-language domain
  models without forking the source of truth.

## When not to use UDON

The deciding question: **Will an agent benefit from comprehending this content?**

If the machine is a *dumb pipe*—serializing, deserializing, passing bytes with
no understanding—use the simplest wire format. JSON, CSV, Protocol Buffers.
The overhead of UDON's expressiveness provides no value when nothing is reading
for meaning.

If the machine is a *comprehending agent*—reading to understand, generating to
communicate, collaborating with humans or other agents—UDON wins. The structure
that aids comprehension is the point, not overhead.

UDON is not optimal for:

- **Pure source code**: Programming languages (including homoiconic ones like
  Lisp) need syntax optimized for execution semantics, not document structure.
- **Narrow, well-defined data packets**: CSV for flat tables, Protocol Buffers
  for wire formats—when the schema is fixed and no agent needs to comprehend
  the content, use the simplest format.
- **Binary data**: Images, audio, dense numeric arrays—text formats are wrong
  here regardless.
- **Append-only log streams**: When per-line independence matters more than
  hierarchy, use JSONL or simple `key=value` formats.

## Best-fit use cases

- Agent prompts, tool configs, and orchestration files
- Specs, RFCs, and design docs that must be both narrative and machine-usable
- Domain-specific languages embedded in context (BDD, experiments, policies, audits)
- Knowledge bases for RAG with stable, intentional chunking
- Templates and content pipelines that benefit from streaming parses and incremental rendering
- Configuration with embedded rationale, runbook steps, and on-call context
- API docs and interface specs mixing examples, constraints, and fields
- Data catalogs and dataset cards where metadata must coexist with narrative provenance
- Playbooks and incident reports—agent-queryable, human-reviewable
- Structured meeting notes, decision logs, and ADRs with explicit metadata and links
- Test scenarios and acceptance criteria mixing prose and formal structure
- Content authoring systems that need inline semantics without HTML noise
- Any artifact where agents read, write, or collaborate with humans

## One-line positioning

UDON is the notation for agents that need to comprehend what they read and
write—not just serialize it.
