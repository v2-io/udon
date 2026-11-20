---
source: UDON repo — test/usability/lib/topic_enablement.rb (TOPICS seed catalog + build_prompt) and test/usability/lib/usability_tester.rb#enablement_prompt (the free/unseeded framing)
gathered: 2026-07-21
status: gathered — verbatim excerpts (the TOPICS array + the two enablement prompt bodies); the surrounding Ruby harness plumbing is omitted as noise
paths:
  - test/usability/lib/topic_enablement.rb:11-150
  - test/usability/lib/usability_tester.rb:507-536
source_commit: 3d8e5b9c52b2a581c4ab9021984423073a694693
categories: [what-was-asked, domain-catalog, prompt-design, honesty-framing, agent-authoring, dsl-substrate]
why_included: >
  This is the *stimulus* behind the whole enablement corpus — "what was asked"
  is as much demand-evidence as "what came back." Two things travel here: (1) the
  ~160-term TOPICS grab-bag, a deliberate domain catalog spanning architecture,
  cloud/infra, data/streaming, security, core+applied AI/ML, HCI, interaction
  modalities, agentic UX, and trust/ethics — the design surface the team wanted
  to probe UDON against; and (2) the prompt framings, notable for method: one-shot,
  "prioritize honesty over any attempt to please; skepticism and criticism are
  valuable," and "if UDON is genuinely unhelpful, say so directly." The free
  (unseeded) variant explicitly asks agents what UDON *enables* for AI agents:
  inner-loop stability, agent-to-agent communication, human-agent collaboration.
  The DSL variant asks what domain-specific language could emerge over UDON's
  "tiers of voice." Both consumers care: the catalog is UDON's demand-space; the
  framing is a reusable pattern for eliciting honest agent testimony.
---

# Topic-enablement seeds and prompt framings

Verbatim excerpts. Two source files: `topic_enablement.rb` supplies the seed
catalog and the topic-seeded prompt; `usability_tester.rb#enablement_prompt`
supplies the free/unseeded "what does UDON enable for AI agents" framing.

## 1. The TOPICS seed catalog (`topic_enablement.rb:11-84`)

> Random grab-bag of tech/software/AI/HCI terms. Deliberately simple terms, not
> prescriptions — we want fresh creative sparks.

```
# Architecture & Patterns
Microservices, Monolith, Hexagonal architecture, Event-driven architecture,
CQRS, Event sourcing, Service mesh, Data mesh, Data fabric,
Domain-driven design, BFF (Backend for Frontend), API gateway,
Sidecar pattern, Strangler fig pattern, Saga pattern,
Orchestration, Choreography,

# Cloud, Infra, DevOps
Cloud-native, Kubernetes, Containerization, Serverless,
Functions-as-a-Service, Infrastructure as Code, GitOps,
DevOps, DevSecOps, CI/CD, Continuous deployment,
Blue-green deployment, Canary release, Observability, Telemetry,
SRE, Chaos engineering, Configuration drift, Cloud orchestration,
Cloud migration, Zero Trust security, SASE, Edge computing,
Immutable infrastructure, Multi-cloud, Hybrid cloud,

# Data, Streaming, Analytics
Data lake, Data warehouse, Lakehouse, ETL / ELT,
Stream processing, Event streaming, Change Data Capture,
Real-time analytics, Time-series database, Columnar storage,
Feature store, Data lineage, Data governance,

# Web, Mobile, Frontend
SPA, PWA, WebAssembly, WebSocket, JAMstack,
Responsive design, CSR / SSR / SSG, Design system, Micro-frontends,

# Security & Identity
OAuth 2.0, OpenID Connect, Identity-as-a-Service, RBAC / ABAC,
Zero-knowledge proofs, Hardware security module, Security posture management,

# Core AI / ML
Artificial intelligence, Machine learning, Deep learning,
Neural network, Transformer, Attention mechanism, Generative AI,
Foundation model, Large language model, Multimodal model,
Reinforcement learning, Supervised learning, Unsupervised learning,
Self-supervised learning, Federated learning, Transfer learning,
Few-shot / zero-shot learning, Diffusion model, Embeddings,

# Applied AI & MLOps
Prompt engineering, RAG, Vector database, Semantic search,
Hallucination, Guardrails, AI alignment, AI agent, Tool-calling,
Model distillation, Quantization, LoRA / fine-tuning, Model serving,
Online inference, Batch inference, Feature engineering,
Data augmentation, Concept drift, Model monitoring, AI observability, Edge AI,

# Product, Process, Misc
Agile, Scrum, Kanban, Product-market fit, A/B testing,
Feature flagging, Dark launch, Technical debt, Digital transformation,
Growth hacking,

# Human-Computer Interaction
HCI, Human-AI interaction, UX, UI, Information architecture,
Interaction design, Affordance, Signifier, Mental model,
Feedback loop, Learnability, Usability, Accessibility,
Cognitive load, Error tolerance, Discoverability, Fitts' law, Hick's law,

# Interaction Styles & Modalities
Direct manipulation, WIMP interface, Gesture-based interaction,
Touch interaction, Gaze tracking, Voice user interface,
Conversational UI, Multimodal interface, Tangible user interface,
AR interface, VR interface, Embodied conversational agent, Avatar interface,

# Conversational & Agentic UX
Conversational AI, Chatbot, Virtual assistant, Agentic AI,
AI copilot, Multi-agent system, Orchestrator agent, Tool-using agent,
Planner / executor pattern, System prompt / persona, Turn-taking,
Dialogue state, Intent recognition, Slot filling, Small-talk handling,

# Trust, Control, & Ethics
Explainable AI, Transparency, Calibrated trust,
Over-reliance / automation bias, Human-in-the-loop, Human-on-the-loop,
Alignment, Safety override, Consent and disclosure, Anthropomorphism
```

## 2. The topic-seeded prompt (`topic_enablement.rb:103-149`, verbatim)

```
## Context

You're participating in notation design research. This is a one-shot
interaction—you won't receive a reply, but your response will be
reviewed by humans. Please prioritize honesty over any attempt to
please; skepticism and criticism are valuable.

## UDON: Universal Document & Object Notation

UDON unifies data, documents, and configuration in one syntax. The key
insight: most real content is **mixed**—prose with structured data woven
throughout, not segregated into "data files" vs "documents."

Here is a comprehensive example showing UDON's capabilities:

​```udon
#{comprehensive_udon}
​```

## Your Task

The following term was pulled randomly from a grab-bag of tech/AI/HCI
buzzwords to spark potentially novel and creative usage scenarios:

**#{topic}**

Explore any unexpected connections or potential applications:

1. Does UDON's mixed prose+structure model offer anything useful here?
2. Any surprising synergies you notice?
3. Would practitioners in this area benefit, or is UDON irrelevant?
#{dsl_addition}
Think freely. We're looking for genuine insight, not forced connections.
If UDON is genuinely unhelpful for this domain, say so directly.
```

The `dsl_addition` (injected for the `topic_dsl` track):

> **Think especially in terms of novel DSLs that UDON could uniquely facilitate.**
> UDON offers multiple "tiers of voice" (prose, elements, inline elements,
> attributes, comments, templating) that could serve as a substrate for
> domain-specific languages. What DSL might emerge for this domain?

## 3. The free/unseeded enablement prompt (`usability_tester.rb:507-536`, verbatim)

The `udon-enablement-*` runs (2 files) drop the topic seed and ask directly
about agents:

```
## Task

We're interested in what UDON might **enable** for AI agents that was
previously difficult or unstable. Consider:

1. **What becomes easier?** Workflows fragile with JSON/YAML/XML
2. **What becomes possible?** New patterns that mixed notation enables
3. **Inner-loop stability** Where could UDON improve agent self-correction?
4. **Agent-to-agent communication** How might shared notation help?
5. **Human-agent collaboration** Documents both can read and modify?

Ideate freely. We value honest assessment—including skepticism if you
see limitations or think existing formats handle these cases well enough.
```

*(Note: the two triple-backtick fences inside the topic-prompt excerpt above are
shown with a zero-width joiner to avoid closing this file's own code fence; the
source has plain ```` ``` ````.)*
