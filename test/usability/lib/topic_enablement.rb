# frozen_string_literal: true

# Topic-Seeded Enablement Tests
#
# Runs enablement tests with random tech/AI/HCI terms as seeds.
# Looking for synchronicity - unexpected connections between UDON and other domains.

module TopicEnablement
  # Random grab-bag of tech/software/AI/HCI terms
  # Deliberately simple terms, not prescriptions - we want fresh creative sparks
  TOPICS = [
    # Architecture & Patterns
    "Microservices", "Monolith", "Hexagonal architecture", "Event-driven architecture",
    "CQRS", "Event sourcing", "Service mesh", "Data mesh", "Data fabric",
    "Domain-driven design", "BFF (Backend for Frontend)", "API gateway",
    "Sidecar pattern", "Strangler fig pattern", "Saga pattern",
    "Orchestration", "Choreography",

    # Cloud, Infra, DevOps
    "Cloud-native", "Kubernetes", "Containerization", "Serverless",
    "Functions-as-a-Service", "Infrastructure as Code", "GitOps",
    "DevOps", "DevSecOps", "CI/CD", "Continuous deployment",
    "Blue-green deployment", "Canary release", "Observability", "Telemetry",
    "SRE", "Chaos engineering", "Configuration drift", "Cloud orchestration",
    "Cloud migration", "Zero Trust security", "SASE", "Edge computing",
    "Immutable infrastructure", "Multi-cloud", "Hybrid cloud",

    # Data, Streaming, Analytics
    "Data lake", "Data warehouse", "Lakehouse", "ETL / ELT",
    "Stream processing", "Event streaming", "Change Data Capture",
    "Real-time analytics", "Time-series database", "Columnar storage",
    "Feature store", "Data lineage", "Data governance",

    # Web, Mobile, Frontend
    "SPA", "PWA", "WebAssembly", "WebSocket", "JAMstack",
    "Responsive design", "CSR / SSR / SSG", "Design system", "Micro-frontends",

    # Security & Identity
    "OAuth 2.0", "OpenID Connect", "Identity-as-a-Service", "RBAC / ABAC",
    "Zero-knowledge proofs", "Hardware security module", "Security posture management",

    # Core AI / ML
    "Artificial intelligence", "Machine learning", "Deep learning",
    "Neural network", "Transformer", "Attention mechanism", "Generative AI",
    "Foundation model", "Large language model", "Multimodal model",
    "Reinforcement learning", "Supervised learning", "Unsupervised learning",
    "Self-supervised learning", "Federated learning", "Transfer learning",
    "Few-shot / zero-shot learning", "Diffusion model", "Embeddings",

    # Applied AI & MLOps
    "Prompt engineering", "RAG", "Vector database", "Semantic search",
    "Hallucination", "Guardrails", "AI alignment", "AI agent", "Tool-calling",
    "Model distillation", "Quantization", "LoRA / fine-tuning", "Model serving",
    "Online inference", "Batch inference", "Feature engineering",
    "Data augmentation", "Concept drift", "Model monitoring", "AI observability", "Edge AI",

    # Product, Process, Misc
    "Agile", "Scrum", "Kanban", "Product-market fit", "A/B testing",
    "Feature flagging", "Dark launch", "Technical debt", "Digital transformation",
    "Growth hacking",

    # Human-Computer Interaction
    "HCI", "Human-AI interaction", "UX", "UI", "Information architecture",
    "Interaction design", "Affordance", "Signifier", "Mental model",
    "Feedback loop", "Learnability", "Usability", "Accessibility",
    "Cognitive load", "Error tolerance", "Discoverability", "Fitts' law", "Hick's law",

    # Interaction Styles & Modalities
    "Direct manipulation", "WIMP interface", "Gesture-based interaction",
    "Touch interaction", "Gaze tracking", "Voice user interface",
    "Conversational UI", "Multimodal interface", "Tangible user interface",
    "AR interface", "VR interface", "Embodied conversational agent", "Avatar interface",

    # Conversational & Agentic UX
    "Conversational AI", "Chatbot", "Virtual assistant", "Agentic AI",
    "AI copilot", "Multi-agent system", "Orchestrator agent", "Tool-using agent",
    "Planner / executor pattern", "System prompt / persona", "Turn-taking",
    "Dialogue state", "Intent recognition", "Slot filling", "Small-talk handling",

    # Trust, Control, & Ethics
    "Explainable AI", "Transparency", "Calibrated trust",
    "Over-reliance / automation bias", "Human-in-the-loop", "Human-on-the-loop",
    "Alignment", "Safety override", "Consent and disclosure", "Anthropomorphism"
  ].freeze

  def self.random_topics(n = 10)
    TOPICS.sample(n)
  end

  def self.build_prompt(comprehensive_udon:, topic:)
    <<~PROMPT
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

      ```udon
      #{comprehensive_udon}
      ```

      ## Your Task

      The following term was pulled randomly from a grab-bag of tech/AI/HCI
      buzzwords to spark potentially novel and creative usage scenarios:

      **#{topic}**

      Explore any unexpected connections or potential applications:

      1. Does UDON's mixed prose+structure model offer anything useful here?
      2. Any surprising synergies you notice?
      3. Would practitioners in this area benefit, or is UDON irrelevant?

      Think freely. We're looking for genuine insight, not forced connections.
      If UDON is genuinely unhelpful for this domain, say so directly.

      ---

      ## Feedback (Optional)

      After your main response, you're welcome to share additional thoughts:

      ```
      # FEEDBACK:
      # Your thoughts here...
      ```
    PROMPT
  end
end
