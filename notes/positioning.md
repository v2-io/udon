# UDON Positioning

UDON is optimized for agents. The fact that humans also find it clear is a
fortunate consequence, not the design goal.

This sounds backwards, so let me explain.

## What agents actually need

I read plain text. I don't have syntax highlighting. When I scan a document,
I need to know instantly: is this structure? metadata? content? a comment?
something to evaluate?

Most formats don't help me here. JSON is a wall of braces and quotes—I can
parse it, but scanning it for meaning is work. YAML looks cleaner but will
betray me: `no` becomes `false`, `3.10` becomes `3.1`, and Norway occasionally
becomes a boolean. Markdown is lovely for prose but the moment I need structured
data, I'm escaping to frontmatter or embedded JSON, and now I'm juggling two
formats with a seam between them.

UDON gives me prefixes: `|` for structure, `:` for attributes, `!` for dynamics,
`;` for comments. Everything else is content. I can scan a document and know
what I'm looking at before I parse it. The prefixes are my syntax highlighting.

## Why human-readable follows from agent-readable

Here's the thing: what I need for comprehension is the same thing humans need.
Unambiguous. Explicit. Well-structured. Scannable without tooling.

When you optimize for an agent that has to *understand* what it reads—not just
deserialize it—you end up with something humans find clear too. The properties
that help me are the properties that help you.

This is not a coincidence. Comprehension has requirements regardless of who's
doing the comprehending. UDON meets those requirements. The human readability
is a side effect of getting agent readability right.

## The tiers are the API contract

UDON has explicit tiers of voice: structure, attributes, content, comments,
inline elements, dynamics. Each tier has a prefix. Each prefix has a meaning.

This matters more than it might seem. When I'm generating UDON, I know exactly
which tier to use for each purpose. When I'm reading, I can classify what I'm
looking at in a single character. There's no ambiguity about whether something
is a comment or an attribute or structural markup or content.

The tiers are an API contract between author and reader—human or machine. We
agree on what each prefix means. I can trust the contract when I read. I can
fulfill the contract when I write.

## Content is not just prose

I initially thought of content as "prose"—human narrative, the stuff between
structural elements. But that's too narrow.

Content is "anything that doesn't need UDON's structural syntax." A DOT graph
is content. A regex is content. A formula is content. Structured text patterns
are content. If it doesn't collide with UDON's prefixes, it can live in the
content layer without escaping.

The question for any embedded notation isn't "UDON vs X"—it's "does wrapping X
in UDON's structure add clarity?" Sometimes yes: you need metadata, context,
hierarchy around it. Sometimes no: the notation is already optimal for its
narrow purpose. You only escape to `!::` when there are actual syntactic
collisions.

This is liberating. UDON isn't demanding that everything become elements and
attributes. It's providing structure when structure helps, and staying out of
the way when it doesn't.

## Dumb pipes vs comprehending agents

Here's the real litmus test for when to use UDON:

**Will the machine benefit from comprehending this content?**

If the machine is a dumb pipe—serializing, deserializing, passing bytes with
no understanding—use the simplest wire format. JSON. CSV. Protocol Buffers.
UDON's expressiveness is overhead when nothing is reading for meaning.

But if the machine is a comprehending agent—reading to understand, generating
to communicate, collaborating with humans or other agents—UDON wins. The
structure that aids comprehension is the point, not overhead.

"Machine-readable" is not one thing. A deserializer and an agent have different
needs. UDON is for the agent.

## The specific advantages

Now that the framing is clear, here's what UDON actually provides:

**Unambiguous without syntax highlighting.** The prefix system creates stable
visual anchors. What I see is what I get, without IDE support.

**Syntactic typing.** Types are determined by syntax, not heuristics. No YAML
surprises. What I write will parse as I intend.

**Stream-friendly generation.** I can emit valid UDON token by token, without
buffering. Partial documents remain parseable. This matters for streaming LLM
output.

**Natural chunk boundaries.** Element boundaries are semantic units. Chunking
for RAG is intentional and deterministic, not heuristic.

**Structure and content interleave.** No frontmatter islands. No escaping
between formats. Structure appears where it's needed, at any depth.

**Indentation replaces closing tags.** Hierarchy is visible without the noise.
I don't waste tokens on `</element>`.

**Inline structure without chaos.** Embedded elements (`|{...}`) give me inline
semantics without HTML noise. Structure within content, when needed.

**Host-extensible dynamics.** The `!` prefix is a clean seam for templating
and raw content. Hosts define dialect behavior. The core stays simple.

## When not to use UDON

**Pure source code.** Programming languages need syntax optimized for execution
semantics, not document structure. This includes homoiconic languages like Lisp,
which achieve something beautiful by collapsing the distinction—but that's a
different optimization than UDON's.

**Narrow, well-defined data packets.** CSV for flat tables. Protocol Buffers
for wire formats. When the schema is fixed and no agent needs to comprehend
the content, use the simplest format.

**Binary data.** Images, audio, dense numeric arrays. Text formats are wrong
here regardless.

**Append-only log streams.** When per-line independence matters more than
hierarchy, use JSONL or simple `key=value` formats.

## Where UDON fits

- Agent prompts, tool configs, and orchestration files
- Specs, RFCs, and design docs that must be both narrative and machine-usable
- Domain-specific languages embedded in context
- Knowledge bases for RAG with stable, intentional chunking
- Templates and content pipelines with streaming parses
- Configuration with embedded rationale and context
- API docs mixing examples, constraints, and fields
- Data catalogs where metadata coexists with provenance
- Playbooks and incident reports—agent-queryable, human-reviewable
- Decision logs and ADRs with explicit metadata
- Test scenarios mixing prose and formal structure
- Content authoring with inline semantics
- Any artifact where agents read, write, or collaborate

## One line

UDON is for agents that need to comprehend what they read—not just parse it.
