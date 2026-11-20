---
source: nexum repo — dev design doc (feature-matrix companion to the vision)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/_core/nexum/docs/dev/agentic-toys-comparison-matrix.md
source_commit: c87c75ce20aeaad9290732e17be256601b45a338
categories: [tool-dsl, feature-matrix, framework-comparison, migration-ladder, three-pillars]
why_included: >
  2025-11-09. The "why not just X" adjudication for agent-tool frameworks: matrices comparing
  Traditional-Toys vs Agentic-Toys vs Rake/Thor/Click/Make, a Stage 0–7 incremental-migration
  ladder, per-extension breakdowns, overhead/complexity estimates, and a use-case decision matrix.
  For the harness consumer, this is the explicit case that existing CLI frameworks do not carry
  intent/preconditions/structured-output/typed-composition/context/learning — i.e. the gap an
  agent-native tool layer exists to fill.
---
# Agentic Toys: Feature Comparison Matrix

A visual guide comparing Traditional Toys, Agentic Toys, and other tooling approaches.

---

## Toys Evolution: Feature Matrix

| Feature | Traditional Toys | Agentic Toys | Benefit |
|---------|-----------------|--------------|---------|
| **Basic CLI parsing** | ✅ Excellent | ✅ Excellent | Unchanged |
| **Hierarchical tools** | ✅ Full support | ✅ Full support | Unchanged |
| **Flag/arg validation** | ✅ Type coercion | ✅✅ Semantic schemas | Richer validation |
| **Tool descriptions** | ✅ Human-readable | ✅✅ Human + Intent | Agents understand "why" |
| **Input validation** | ✅ Acceptors | ✅✅ Schemas + Preconditions | Fail-fast guarantees |
| **Output format** | 📝 Text (stdout) | 🔧 Structured + Text | Machine-parseable |
| **Error handling** | ⚠️ Manual | ✅ Postconditions | Automated verification |
| **Tool composition** | ⚠️ Runtime only | ✅ Type-checked | Compile-time safety |
| **Context awareness** | ❌ None | ✅✅ Full context | Temporal coherence |
| **Learning** | ❌ Static | ✅✅ Pattern detection | Improves over time |
| **Meta-tooling** | ⚠️ Templates only | ✅✅ Agent generation | Intelligence → intelligence |
| **Backward compat** | N/A | ✅ Mostly | Easy migration |

**Legend:**
- ✅ Supported
- ✅✅ Enhanced/Extended
- ⚠️ Limited
- ❌ Not supported
- 📝 Human-focused
- 🔧 Machine-focused

---

## Comparison with Other Tool Frameworks

| Capability | Toys | Agentic Toys | Rake | Thor | Click (Python) | Make |
|------------|------|--------------|------|------|----------------|------|
| **Hierarchical commands** | ✅ | ✅ | ⚠️ Namespaces | ✅ | ✅ | ❌ |
| **Argument parsing** | ✅ | ✅✅ | ⚠️ Clumsy | ✅ | ✅ | ❌ |
| **Help generation** | ✅ | ✅ | ⚠️ Limited | ✅ | ✅ | ⚠️ |
| **File dependencies** | ❌ | ❌ | ✅ | ❌ | ❌ | ✅✅ |
| **Intent annotations** | ❌ | ✅✅ | ❌ | ❌ | ❌ | ❌ |
| **Preconditions** | ❌ | ✅✅ | ❌ | ❌ | ❌ | ⚠️ Implicit |
| **Postconditions** | ❌ | ✅✅ | ❌ | ❌ | ❌ | ❌ |
| **Structured output** | ❌ | ✅✅ | ❌ | ❌ | ❌ | ❌ |
| **Type-checked composition** | ❌ | ✅✅ | ❌ | ❌ | ❌ | ⚠️ Via files |
| **Context awareness** | ❌ | ✅✅ | ❌ | ❌ | ❌ | ❌ |
| **Learning from usage** | ❌ | ✅✅ | ❌ | ❌ | ❌ | ❌ |
| **Agent-friendly** | ⚠️ | ✅✅ | ⚠️ | ⚠️ | ⚠️ | ⚠️ |
| **Template system** | ✅ | ✅✅ | ❌ | ✅ | ⚠️ | ❌ |
| **Mixin system** | ✅ | ✅ | ❌ | ⚠️ | ⚠️ | ❌ |
| **Testing support** | ✅ | ✅ | ✅ | ⚠️ | ✅ | ⚠️ |
| **Gem distribution** | ✅ | ✅ | ✅ | ✅ | ✅ PyPI | ❌ |
| **Best for** | Ruby projects | Agent workflows | Build pipelines | Gem CLIs | Python CLIs | Compilation |

---

## Agentic Feature Breakdown

### 1. Semantic Annotations

| Feature | Traditional | Agentic | Example |
|---------|-------------|---------|---------|
| **Tool description** | Text only | Text + Intent | `intent "Safely promote version"` |
| **Argument validation** | Type coercion | Semantic schema | `schema: { type: :enum, values: [...] }` |
| **Preconditions** | Manual checks | Declarative | `precondition "Git clean" { ... }` |
| **Postconditions** | Manual checks | Declarative | `postcondition "App healthy" { ... }` |
| **Error messages** | Generic | Semantic | "Precondition failed: Git clean" |

### 2. Context Protocol

| Context Type | Traditional | Agentic | Access Pattern |
|-------------|-------------|---------|----------------|
| **Git status** | Shell out manually | Automatic | `context.git_status.modified` |
| **Working directory** | `Dir.pwd` | Automatic | `context.working_directory` |
| **Recent tools** | None | Tracked | `context.recent_tools` |
| **Recent edits** | None | Tracked | `context.recent_edits` |
| **Temporal flow** | None | Tracked | `context.time_since("test")` |
| **Agent state** | None | Available | `context.agent_state` |

### 3. Structured I/O

| I/O Aspect | Traditional | Agentic | Agent Benefit |
|------------|-------------|---------|---------------|
| **Output format** | Free text | Typed schema | Reliable parsing |
| **Error format** | Exception text | Structured error | Programmatic handling |
| **Human fallback** | Default | Generated from schema | Dual-purpose |
| **Input validation** | Parse errors | Schema validation | Clear contracts |
| **Interaction** | `gets`/`puts` | `ask_agent(schema:)` | Typed communication |

### 4. Type System

| Aspect | Traditional | Agentic | Example |
|--------|-------------|---------|---------|
| **Tool outputs** | Untyped | Declared schema | `output_schema BuildArtifact` |
| **Tool inputs** | Untyped | Declared accepts | `accepts BuildArtifact` |
| **Composition** | Runtime hope | Compile-time check | `call_tool("build")` returns type |
| **Type errors** | Runtime | Definition-time | `toys system check-types` |
| **Type inference** | None | From schemas | Return type inferred |

### 5. Learning and Adaptation

| Learning Feature | Traditional | Agentic | How It Works |
|------------------|-------------|---------|--------------|
| **Usage tracking** | None | Automatic | `tracks_usage { ... }` |
| **Pattern detection** | None | Statistical | Correlations computed |
| **Risk warnings** | None | Proactive | "Friday deploys fail 30%" |
| **Improvement suggestions** | None | Automatic | "Add precondition: Git clean" |
| **Retention** | N/A | Configurable | `.toys/.usage_db/` |

### 6. Meta-Tooling

| Meta-Tooling | Traditional | Agentic | Capability |
|--------------|-------------|---------|------------|
| **Templates** | Static definitions | Learning templates | Analyze existing tools |
| **Tool generation** | Manual | Agent-driven | `generate_tool(spec)` |
| **Pattern extraction** | None | Automatic | Common flags, preconditions |
| **Code generation** | String templates | AST-based | Valid Ruby syntax |
| **Application** | One-time expansion | Runtime generation | Tools created on-demand |

---

## Use Case Matrix

| Use Case | Traditional Toys | Agentic Toys | Winner | Why |
|----------|-----------------|--------------|--------|-----|
| **Simple one-off script** | ✅ Good | ⚠️ Overkill | Traditional | Simplicity wins |
| **Project build pipeline** | ✅ Good | ✅✅ Better | Agentic | Preconditions, learning |
| **Agent-driven workflows** | ⚠️ Works | ✅✅ Excellent | Agentic | Structured I/O, context |
| **Complex tool composition** | ⚠️ Risky | ✅✅ Safe | Agentic | Type checking |
| **Learning from patterns** | ❌ Manual | ✅✅ Automatic | Agentic | Pattern detection |
| **File-based dependencies** | ❌ Use Rake | ❌ Use Rake | Rake | Purpose-built |
| **Interactive human tool** | ✅ Good | ✅ Good | Tie | Both work well |
| **Gem CLI distribution** | ✅ Good | ✅ Good | Tie | Both work well |
| **Rapid tool prototyping** | ⚠️ Manual | ✅✅ Generated | Agentic | Meta-tooling |

---

## Agent Workflow Comparison

### Example: Deploy Application

#### Traditional Toys (Agent Must)
1. Parse tool help text to understand arguments
2. Hope preconditions are met (no validation)
3. Parse stdout text to determine success
4. Manually check postconditions
5. Repeat mistakes (no learning)

**Pain points:**
- ❌ Text parsing is brittle
- ❌ No safety guarantees
- ❌ No learning

#### Agentic Toys (Agent Gets)
1. Read structured schema to understand arguments
2. Preconditions checked automatically
3. Parse structured JSON output reliably
4. Postconditions verified automatically
5. See warnings from learned patterns

**Benefits:**
- ✅ Structured data, no parsing
- ✅ Fail-fast safety
- ✅ Continuous improvement

---

## Migration Path

| Stage | What | Effort | Benefit |
|-------|------|--------|---------|
| **Stage 0** | Use existing Toys | None | Works today |
| **Stage 1** | Add intent annotations | Low | Better documentation |
| **Stage 2** | Add schemas to args | Low | Input validation |
| **Stage 3** | Add preconditions | Medium | Safety guarantees |
| **Stage 4** | Add structured output | Medium | Agent-parseable |
| **Stage 5** | Add type checking | Medium | Composition safety |
| **Stage 6** | Enable learning | Low | Pattern detection |
| **Stage 7** | Use meta-tooling | High | Generated tools |

**Recommendation:** Incremental adoption—start with Stage 1-2, expand as needed.

---

## Performance Comparison

| Operation | Traditional Toys | Agentic Toys | Overhead |
|-----------|-----------------|--------------|----------|
| **Tool definition** | ~1ms | ~2ms | Minimal |
| **Precondition check** | N/A | ~5ms | Worth it |
| **Schema validation** | ~1ms | ~2ms | Minimal |
| **Type checking** | N/A | ~10ms (definition) | One-time |
| **Output serialization** | N/A | ~5ms | Minimal |
| **Pattern analysis** | N/A | ~50ms (on-demand) | Acceptable |
| **Tool execution** | Baseline | +10-20ms | Negligible |

**Verdict:** Agentic features add ~10-20ms overhead per tool execution—negligible for most use cases.

---

## Complexity Comparison

| Aspect | Traditional Toys | Agentic Toys | Complexity Increase |
|--------|-----------------|--------------|---------------------|
| **Simple tool** | 10 LOC | 15 LOC | +50% (still simple) |
| **Medium tool** | 50 LOC | 60 LOC | +20% |
| **Complex tool** | 200 LOC | 210 LOC | +5% (value > cost) |
| **Learning curve** | Low | Medium | New concepts to learn |
| **Documentation needs** | Low | Medium | More to explain |

**Verdict:** Complexity increase is proportional to tool simplicity—simple tools stay simple, complex tools benefit most.

---

## The Three Pillars Applied

| Pillar | Traditional Toys | Agentic Toys | How Achieved |
|--------|-----------------|--------------|--------------|
| **Wisdom** | ⚠️ Tool author's wisdom only | ✅✅ Embedded in tooling | Intent, preconditions, learning |
| **Strength** | ⚠️ Hope it works | ✅✅ Guaranteed correctness | Type checking, validation |
| **Beauty** | ✅ Clean DSL | ✅✅ Cleaner workflows | Context removes repetition |

---

## Decision Matrix: Should I Use Agentic Toys?

### ✅ Use Agentic Toys If:
- Working with AI agents extensively
- Need safety guarantees (preconditions, postconditions)
- Complex tool composition requiring type safety
- Want tools to learn and improve over time
- Need structured, machine-parseable output
- Rapid prototyping of new tooling

### ⚠️ Consider Traditional Toys If:
- Simple one-off scripts
- No agent interaction
- Minimal complexity
- Learning curve is a concern
- Performance is critical (microseconds matter)

### ❌ Use Something Else If:
- File-based build dependencies → **Rake**
- Compilation pipeline → **Make**
- Distributed gem with complex CLI → **Thor**
- Python project → **Click**
- Human-only interactive shell → **Bash scripts**

---

## Summary Table: Key Differentiators

| Dimension | Toys | Agentic Toys |
|-----------|------|--------------|
| **Target user** | Human developers | AI agents (+ humans) |
| **I/O format** | Text streams | Structured data + text |
| **Validation** | Type coercion | Semantic schemas |
| **Safety** | Manual checks | Pre/postconditions |
| **Composition** | Runtime hope | Type-checked |
| **Context** | None | Full awareness |
| **Learning** | Static | Pattern detection |
| **Meta-capability** | Templates | Agent generation |
| **Philosophy** | "Make CLI tools easy" | "Make best practices easiest" |

---

## Conclusion

**Agentic Toys is Traditional Toys + Six Extensions:**

1. Semantic annotations (intent, schemas, conditions)
2. Context protocol (awareness of state)
3. Structured I/O (machine-parseable)
4. Type system (composition safety)
5. Learning (pattern detection)
6. Meta-tooling (agent generation)

**Trade-offs:**
- ✅ **Gain:** Safety, composability, learning, agent-friendliness
- ⚠️ **Cost:** ~20ms overhead, medium complexity increase
- ✅ **Migration:** Incremental, mostly compatible

**Verdict:** For agent-driven workflows, the benefits far outweigh the costs.

---

**See also:**
- Full vision: `vision-agentic-toys.md`
- Quick reference: `agentic-toys-quick-reference.md`
- Original Toys docs: `toys.md`
