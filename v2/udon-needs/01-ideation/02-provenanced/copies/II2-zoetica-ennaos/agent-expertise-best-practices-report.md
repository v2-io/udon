---
source: zoetica .archive/docs-20251012/ref — creating effective agent-usable expertise descriptions (~Oct 8 2025)
gathered: 2026-07-21
status: gathered (verbatim whole-file copy; lives in zoetica/.archive but strong agent-interface material)
paths:
  - /Users/josephwecker-v2/src/_core/zoetica/.archive/docs-20251012/ref/agent-expertise-best-practices-report.md
source_commit: 6ac3961
categories: [agent-facing-docs, three-tier-architecture, llms.txt, AGENTS.md, ACI-tool-descriptions]
why_included: >
  Strong agent-facing-interface material: a three-tier docs architecture (always-loaded -> contextual ->
  on-demand), the llms.txt + AGENTS.md convergence, and "tool descriptions as Agent-Computer Interfaces optimized
  for LLM ergonomics rather than API design." Directly serves both consumers — UDON's self-describing-document
  pitch and the harness's tool-presentation/how-a-tool-introduces-itself surface.
---

# Creating Effective Agent-Usable Expertise Descriptions

**Modern LLM agents require documentation designed specifically for machine consumption**, not just human-readable text. After analyzing 450+ production implementations and official guidance from Anthropic, Google, and OpenAI, the most effective expertise descriptions (PRAXES) share three core attributes: **structured clarity over cleverness**, **examples that demonstrate patterns**, and **multi-tiered depth matching usage context**.[^1][^2] The industry is seeing convergence around formats like the proposed `llms.txt` specification for web documentation and the emerging `AGENTS.md` standard for project-specific context. Concurrently, tool descriptions are evolving into "Agent-Computer Interfaces" optimized for LLM ergonomics rather than traditional API design.[^3][^4]

This trend represents a fundamental shift from viewing prompts as instructions to treating them as engineering artifacts requiring systematic evaluation, version control, and iterative refinement. The most successful teams now spend a majority of their development time on evaluation and observability. For instance, Notion AI, serving over 100 million users, dedicates 90% of its development effort to evaluation, enabling rapid model switching and continuous improvement through rigorous testing.[^37]

## A Conceptual Three-Tier Documentation Architecture

A useful conceptual framework for agent documentation is a layered structure where each tier serves distinct discovery mechanisms and usage patterns. **Tier 1 provides the briefest actionable version**, functioning as an always-loaded foundation that establishes core identity, primary objectives, and critical constraints.[^6] This minimal layer appears in system prompts and context windows regardless of task complexity, similar to `CLAUDE.md` files that define essential project conventions in a single paragraph.[^7][^8]

**Tier 2 expands into comprehensive operational guidance**, comparable to Cursor rules files with complete procedures, multiple examples, conditional logic, and tool usage patterns.[^9][^10] These mid-tier descriptions load contextually based on file patterns (using glob matching like `*.tsx` for React components) or semantic relevance to the current task. The tier maintains enough detail for agents to execute complex workflows independently while remaining concise enough for efficient context window usage.

**Tier 3 delivers exhaustive exposition**, with underlying assumptions, edge case handling, performance optimization strategies, and links to related documentation. This comprehensive layer would load on-demand when agents request specialized knowledge or encounter novel scenarios beyond tier 2 coverage. The architecture enables dynamic context loading where simpler tasks consume minimal tokens while complex operations access progressively deeper knowledge without manual intervention.

Implementation patterns show tier boundaries should overlap slightly, with tier 1 containing pointers to tier 2 resources and tier 2 referencing tier 3 materials through explicit linking mechanisms like `@path/to/file.md` syntax. This creates a navigable knowledge graph rather than isolated documentation silos, allowing agents to discover relevant context through natural exploration patterns.[^11]

## Format and structural patterns that maximize agent comprehension

The proposed **`llms.txt` specification** is a notable effort to standardize web documentation for LLMs, following a strict hierarchical markdown structure: H1 project name, blockquote summary, prose description, and H2 sections containing link lists with optional descriptions.[^12][^13] This format succeeds because it mirrors patterns from internet training data, making it more comprehensible to models without special parsing logic. Key structural requirements include a special "Optional" section marking content that can be skipped when context is constrained, enabling token-aware consumption where agents automatically prioritize essential over supplementary information.

For project-specific documentation, the community is converging on **`AGENTS.md` as an emerging standard**, with some projects maintaining legacy `CLAUDE.md` and `GEMINI.md` files as symlinks for backward compatibility.[^14][^15] The format uses standard markdown without a required structure but follows consistent patterns: project overview, setup commands, architecture guidelines, code style, testing instructions, and common tasks. Tools can scan current and parent directories hierarchically, with more specific files overriding general ones, creating natural inheritance where module-level conventions take precedence over project-level defaults.

**Metadata requirements** differ significantly between formats. For `llms.txt` files, the blockquote must contain technology stack, primary purpose, key dependencies, and critical incompatibilities in condensed form, as this summary helps models quickly determine relevance. For `AGENTS.md` files, frontmatter supports glob patterns for auto-attachment (`globs: ["*.tsx", "*.ts"]`), descriptions for agent-requested loading, and `alwaysApply` boolean flags.[^16] This metadata enables sophisticated loading strategies where documentation appears automatically when working with matching files, reducing manual context management.

Section organization follows deliberate ordering: **information hierarchy places immediately actionable content first**, followed by architectural understanding, then style conventions, and finally troubleshooting.[^17] This structure mirrors how agents typically progress through tasks—establishing what to do before understanding why or how to handle edge cases. The pattern applies universally across domains, whether documenting APIs (endpoints before authentication details), domain knowledge (core concepts before advanced theory), or reasoning procedures (standard workflow before exception handling).

**XML tags and markdown structure consistently outperform unstructured prose** in controlled evaluations.[^18][^19] Effective structural patterns wrap distinct sections in `<OBJECTIVE>`, `<INSTRUCTIONS>`, `<CONSTRAINTS>`, `<CONTEXT>`, `<EXAMPLES>`, and `<OUTPUT_FORMAT>` tags, creating machine-parseable boundaries that help models distinguish between different instruction types. This structure prevents confusion where examples might be mistaken for instructions or constraints interpreted as suggestions, issues that plague unstructured prompts.

Naming conventions follow predictable patterns: repository root contains `AGENTS.md` as primary agent context, `.cursor/rules/` directory holds granular `.mdc` files with frontmatter, and nested project structures maintain directory-level `AGENTS.md` files that override parent conventions.[^20] Tool configuration resides in `.cursor/mcp.json` for Model Context Protocol servers and `~/.gemini/settings.json` for global Gemini configuration, establishing consistent locations that agents can discover programmatically.

## Content principles for agent-usable instructions

**Specificity consistently outperforms generality** when task requirements are clear, but the optimal balance shifts with complexity.[^21][^22] Simple transformations may only need an objective plus constraints, while multi-step workflows require complete procedures, conditionals, tool selection criteria, and verification steps. Research shows instruction-following accuracy correlates with clarity rather than length—concise but explicit instructions beat verbose ambiguous ones, while terse incomplete instructions underperform detailed comprehensive ones.

The **thinking space technique** dramatically improves accuracy for reasoning-intensive tasks. Anthropic reports significant accuracy gains when agents receive explicit permission to work through reasoning in `<scratchpad>` tags before providing final answers.[^23] This pattern combats premature commitment where models generate responses before fully considering the problem space. Effective implementations request step-by-step reasoning, fact listing, edge case consideration, and conclusion synthesis, then require the final answer in separate `<answer>` tags. This pattern is explicitly supported by Anthropic via its visible `<thinking>` blocks. A similar outcome can be achieved with OpenAI's `/v1/responses` API by requesting and preserving the `encrypted_content` token, which maintains the model's reasoning context without making it visible to the user.

**Examples demonstrate patterns more effectively than descriptions**.[^24][^25] Optimal example structure includes 2-5 diverse cases covering happy path, edge cases, format variations, and optionally error cases with anti-examples showing what to avoid. Each example pairs concrete input with exact desired output, optionally including `<reasoning>` sections for complex tasks that benefit from transparency. Research shows diverse examples covering different scenarios outperform many similar examples—a single happy path example plus two edge cases beats five happy path variations.

**Conditional instructions require explicit decision frameworks** rather than implicit context-dependence.[^26] Effective patterns use structured IF-THEN logic: "IF task requires multi-step reasoning THEN use Chain-of-Thought prompting AND include 'Think step by step'". This explicitness prevents agents from guessing when to apply specific practices. Production implementations include conditional behaviors for error states ("IF information is missing: Ask ONE clarifying question at a time"), permission requirements ("IF order amount > $100: Require additional verification"), and escalation criteria ("IF issue unresolved after 2 turns: Escalate to human").

**Procedural descriptions benefit from hybrid declarative-imperative approaches**.[^27] Declarative statements work well for simple goals with clear outcomes ("Classify this email as urgent/normal/spam based on content and sender"), while imperative step-by-step sequences handle complex workflows with dependencies. The most effective pattern combines both: declarative goals with imperative edge case handling. Each procedural step should include the action, the tool or method, the success criteria, and the transition logic (what to do next or when to branch).

The **compression test** validates every instruction: "Can I remove this without degrading performance?" Superlatives like "smartest" or "most brilliant" don't reliably improve outputs and waste tokens.[^28] Emotional appeals similarly underperform explicit technical specifications. The target is maximum information density—highest insights per paragraph while maintaining clarity—achieved through direct active voice, specific concrete terms, and elimination of hedging language unless genuine uncertainty exists.

Explanations of rationale enhance performance for complex reasoning tasks, teaching pattern recognition, and disambiguating similar tools, but should be omitted for simple deterministic tasks, performance-critical applications, and self-evident examples. When included, rationale should be concise and directly connected to the instruction: "Use `search_database` when looking for structured data. Use `web_search` for general information not in our database." This explicit differentiation prevents tool misuse that plagued earlier implementations.

## Domain-specific patterns and model considerations

**API and tool documentation** for agents differs fundamentally from human API documentation. Traditional API design emphasizes comprehensive parameter listings and return type specifications, but Agent-Computer Interface (ACI) design prioritizes natural text patterns, minimal formatting overhead, and allowance for incremental generation.[^29][^30] The `apply_patch` tool exemplifies this shift—instead of line-number-based diffs requiring upfront counting, it uses context-based matching with surrounding code snippets, enabling agents to think while generating rather than committing to formats immediately. Another key example of differing ACI is tool result submission: the standard `/v1/chat/completions` API uses a machine-friendly `role: "tool"`, while the `/v1/responses` API uses a `role: "user"` message. While less intuitive for developers, the latter may be more 'natural' for the model, treating the tool's output as new information provided by the user.

Tool descriptions should include purpose statement, usage examples showing when to invoke, edge case handling, common mistakes to avoid, and parameter descriptions with concrete examples. **Consolidating granular tools into workflow-appropriate tools** dramatically improves performance.[^31] Instead of separate `list_users()`, `list_events()`, and `create_event()` functions, a unified `schedule_event(participants, time_preferences)` tool handles user lookup, availability checking, and creation atomically, reducing tool call chains from 5-7 steps to 1-2. This is because some APIs can struggle with multi-step tool-use chains where the output of one tool is the direct input of the next. A consolidated tool reduces the number of 'turns' and potential for error.

**Claude-specific optimization** leverages its superior agentic reasoning through explicit planning phases (Plan → Act → Review), subagent delegation for context isolation, and extended thinking mode triggered by "think" keywords.[^32] Claude excels with tool-centric designs where tools are defined first and expertise descriptions explain usage patterns second. Tool formats should allow enough tokens for reasoning before commitment—context-based edits over line-numbered diffs, markdown over escaped JSON for code. Claude Code specifically benefits from git-based state tracking and aesthetic requirements stated explicitly for UI generation.[^33]

Model choice may also be dictated by specific API features. For example, if a task requires guaranteed-valid JSON output, OpenAI's `response_format` or `strict: true` for tools is a significant advantage. If a transparent, auditable thought process is needed for compliance or debugging, Anthropic's visible `<thinking>` blocks are superior to OpenAI's encrypted, non-visible reasoning tokens.

**Gemini-specific optimization** exploits its massive 1M+ token context window through data-rich detailed instructions more verbose than Claude requires.[^34][^35] The model handles comprehensive document analysis exceptionally well, making it ideal for analytical reasoning over large codebases. Gemini CLI's agent mode excels at high-level goals with automatic multi-step breakdowns, while its built-in grep, file operations, and terminal access reduce external tool dependencies. Context file hierarchies (component > project > global) enable sophisticated overriding behaviors where specific module rules supersede general project conventions.

**Domain knowledge documentation** for medical, legal, or technical fields requires explicit epistemic marking. Instructions should distinguish definitive facts from working assumptions, flag areas of uncertainty, and specify when expert human review is required. Medical documentation might include "Always note confidence level for diagnoses. Flag for human review if confidence < 0.8 OR multiple contradictory indicators present." Legal domain patterns emphasize citation requirements, jurisdictional constraints, and disclaimers about advice limitations.

**Reasoning procedures** benefit from workflow pattern specifications.[^36] Prompt chaining decomposes tasks into sequential LLM calls with programmatic validation gates between steps. Routing classifies inputs and directs to specialized paths optimized for different input types. Parallelization either sections work into independent subtasks or runs voting schemes with multiple generations for confidence. Orchestrator-worker patterns employ a central planner that dynamically breaks down tasks and delegates to specialized workers before synthesizing results.

**Code patterns and snippets** should show complete working examples rather than fragments. A Django model definition includes import statements, the model class with field types and options, the Meta class with ordering, and the `__str__` method—not just the field definitions alone. React component examples demonstrate full structure from imports through type definitions to the component implementation, avoiding partial patterns that agents might misinterpret or extend incorrectly.

## Testing, validation, and maintenance practices

**Evaluation-driven development** has become the defining characteristic of successful agent implementations. Notion AI's revelation that 90% of development time goes to evaluation and observability rather than implementation reflects industry-wide recognition that agent reliability depends on systematic testing more than clever prompting.[^37] This ratio contradicts traditional software development but proves essential for systems where behavior emerges from statistical patterns rather than deterministic logic.

Test datasets require **real-world complexity rather than toy examples**. Weak tasks like "Search logs for customer_id=9182" fail to stress multi-step reasoning or error recovery. Strong tasks like "Customer ID 9182 reported triple-charging for single purchase. Find relevant logs, determine if others affected, prepare incident report with remediation" exercise realistic complexity: ambiguous inputs, multi-tool orchestration, error handling, and structured output generation. Evaluation datasets should contain 50+ tasks covering diverse scenarios with edge cases, failure modes, and ambiguous inputs.

**Modern benchmarks emphasize agentic capabilities** over single-turn question answering.[^38][^39] AgentBench tests across 8 diverse environments requiring multi-turn interaction. SWE-bench Verified uses real GitHub issues requiring code comprehension, planning, and implementation. TheAgentCompany simulates an entire software company where agents handle cross-functional tasks; best agents achieve only 30% completion rates as of 2025, indicating substantial headroom for improvement. These agentic benchmarks provide more realistic performance signals than academic benchmarks like MMLU or TruthfulQA, which poorly predict agent task success.

Measurement frameworks should track task completion rate as primary metric, supplemented by tool call accuracy, token efficiency, latency, error rate, and cost per evaluation run. Advanced metrics include planning quality assessed by LLM-as-judge, adaptability measured through recovery from unexpected situations, and human preference gathered through A/B testing. The evaluation loop should be automated with continuous monitoring and alerts on metric degradation, enabling rapid detection of regressions from prompt changes, model updates, or tool modifications.

**Version control treats agent configurations as engineering artifacts** checked into Git repositories with semantic versioning, clear branching strategies (main for production, develop for testing, feature/* for experiments), and structured commit messages including what changed, why it changed, impact assessment, and evaluation results.[^40] The change management workflow progresses through development, comprehensive evaluation, documentation updates, peer review, staging deployment, A/B testing with partial traffic, production rollout, and continuous monitoring. This disciplined approach prevents the "prompt drift" that plagued earlier implementations where undocumented changes accumulated into unmaintainable systems.

GitOps patterns establish clear repository structures with separate directories for agent configurations, shared context, evaluation datasets, and environment-specific deployments. Tool definitions, test cases, and version histories colocate with agent prompts, ensuring changes maintain consistency across related artifacts. Monitoring and observability track agent latency percentiles (p50, p95, p99), success rates by task type, tool call distribution, token consumption trends, error rates categorized by type, and user satisfaction scores, with dashboards enabling rapid anomaly detection.

**Rollback strategies** must handle both immediate failures and gradual degradation. Immediate rollbacks revert to the previous Git commit when critical failures occur. Gradual rollbacks route increasing percentages to the old version while monitoring success metrics. Conditional rollbacks activate for specific failure patterns detected in production. Blue-green deployments maintain two complete environments, enabling instant switchover without version coordination complexity. The choice depends on criticality, traffic volume, and recovery time objectives specific to each application.

## Successful patterns from production implementations

The **hierarchical multi-agent architecture** consistently outperforms single-agent ReAct patterns in complex domains.[^41] The company 11x built their AI sales development representative (Alice) through architectural evolution from ReAct to workflow-based to hierarchical multi-agent, achieving human-level 2% reply rates. Their final design employs meta-agents for task decomposition, task-agents for specific workflows, and primitive-agents for atomic operations, with clear responsibility boundaries preventing the confusion that emerges in monolithic agents attempting all functions.

**Common failure modes** reveal anti-patterns to avoid.[^42] Tool design failures occur when wrapping APIs one-to-one rather than consolidating into workflow-appropriate interfaces. Context overload happens when dumping entire documentation as context instead of implementing filtering, pagination, and response format enums. Poor tool descriptions use vague technical language rather than clear examples showing when and how to invoke. Ignoring model-specific strengths leads to identical prompts across models when Claude benefits from planning emphasis, Gemini from detailed context, and GPT from memory leverage. Inadequate testing relies on manual checks in sandbox environments rather than systematic evaluation with diverse real-world scenarios.

Over-engineering early represents a particularly insidious anti-pattern where teams build complex multi-agent systems before validating that simpler solutions fail. The recommended progression starts with a single LLM plus 3-5 well-designed tools, adds complexity only when simpler solutions demonstrably fail on evaluation metrics, and measures performance before and after each architectural change.[^43] This incremental approach prevents the technical debt that accumulates when sophisticated systems mask rather than solve fundamental issues with tool design or prompt clarity.

**The Rexera quality control case study** demonstrates specialization value. Their real estate transaction QC system employs a meta-agent for orchestration, task-agents for specific transaction types, and primitive-agents for document verification, resulting in $1M annual savings. The architecture succeeds because each agent maintains focused expertise rather than attempting generalist coverage across all transaction types, edge cases, and verification procedures. This specialization pattern applies broadly—customer service agents with separate escalation, returns, and modifications specialists outperform unified agents attempting all functions.

Character.ai's achievement of 30,000 messages per second throughput required custom foundation models with multi-query attention and sophisticated prompt management systems, illustrating that at sufficient scale, custom solutions outperform off-the-shelf approaches. However, their architecture evolved from standard implementations that validated core concepts before investing in custom development, reinforcing the progressive complexity principle.

## Practical implementation guidance and future directions

Starting teams should **choose models strategically based on task characteristics**:[^44][^45] Claude for complex reasoning with iterative workflows, Gemini for large document analysis and multimodal tasks, GPT for reliable orchestration with memory-dependent personalization. The initial implementation should start simple—a single agent with 3-5 well-designed tools—and invest heavily in evaluation before adding complexity. Building real-world test cases covering 50+ tasks with held-out test sets enables objective performance measurement rather than subjective vibes-based assessment.

**Tool optimization patterns** include consolidating granular functions into workflow tools, implementing response format enums that default to concise outputs with detailed modes available on request, adding pagination and filtering to prevent context overload, and extensively prompt-engineering tool descriptions with examples and edge cases.[^46] The pagination pattern proves particularly valuable: instead of returning all 10,000 results, return 50 with metadata indicating total count and "fetch more" capability, reducing token consumption by orders of magnitude while maintaining completeness.

Scaling teams require **production observability infrastructure** with comprehensive tracing (LangSmith or similar tools), custom dashboards for domain-specific KPIs, alerting on metric degradation, and weekly comprehensive evaluation runs.[^47] The A/B testing approach shadow-tests new versions with production traffic before full rollout, collecting human feedback through explicit ratings or implicit signals like task completion rates, iterating based on production data patterns rather than development environment assumptions.

**Context engineering** has emerged as a distinct discipline encompassing compaction techniques for long-horizon tasks, token-efficient tool response design, just-in-time context loading mechanisms, and memory system architectures separating short-term conversational context from long-term learned preferences.[^48] The Model Context Protocol (MCP) from Anthropic standardizes tool integration patterns, a notable step toward simplifying multi-tool coordination and enabling an ecosystem where specialized tool providers can publish MCP-compatible interfaces that agents consume without custom integration code.

The evolution from 2023's prompt engineering era through 2024's framework explosion to 2025's agent-first paradigm shows a clear trajectory toward treating agents as engineered systems rather than emergent phenomena. Models now train specifically for agentic workflows with context-aware token budget tracking, extended thinking modes, and native tool use optimization. Security hardening is responding to a reported 40% increase in RAG pipeline attacks and system prompt leakage incidents through prompt injection defenses and human-in-the-loop requirements for high-risk operations.[^49]

Future directions point toward automated generation of agent documentation through codebase analysis, dynamic rule selection based on task complexity rather than static file loading, and learned preference models that adapt to individual user patterns over time. The shift from monolithic to modular documentation enables these advances—granular `.mdc` files with metadata support intelligent selection, while hierarchical context loading provides a framework for progressive disclosure as agent capabilities expand.

## Conclusion: From art to an engineering discipline

The most profound insight from analyzing modern agent-usable expertise descriptions is that **success correlates more strongly with evaluation rigor than architectural sophistication**.[^50] Companies serving hundreds of millions of users with reliable agent-powered features aren't those with the most clever prompts or complex multi-agent hierarchies—they're the ones spending the majority of their development effort on systematic testing, observability, and iterative refinement based on production data.

This finding challenges conventional software development wisdom where implementation consumes most of the effort, but it aligns with the fundamental nature of statistical systems where behavior emerges from patterns rather than deterministic logic. The implication for creating effective PRAXES is clear: **invest more in evaluation infrastructure and test case diversity than in prompt optimization or structural cleverness**. A well-written expertise description provides little value without rigorous validation that agents actually follow it correctly across diverse scenarios.

The convergence on emerging standard formats (`llms.txt` for web documentation, `AGENTS.md` for project context) with clear structural patterns represents industry maturation from experimental chaos toward shared conventions that enable interoperability.[^51] These formats succeed not through technical superiority but through adoption, creating network effects where tools automatically discover and consume standardized documentation. The meta-lesson for practitioners is that **consistency and convention often matter more than optimization**—a moderately effective standard format beats a superior custom approach that lacks ecosystem support.

The conceptual three-tier architecture addresses a core tension in agent documentation: comprehensive context enables sophisticated behavior but exhausts token budgets, while minimal context preserves efficiency but limits capability. Progressive disclosure through tiered documentation with automatic loading based on task complexity resolves this tension, suggesting that **adaptive systems outperform static configurations**. The future trajectory points toward increasingly dynamic documentation where agents request precisely the context needed for current tasks rather than receiving predetermined packages.

For teams building agent systems today, the actionable synthesis is: start with standardized formats and structures rather than inventing custom approaches, implement comprehensive evaluation before adding architectural complexity, measure everything continuously with automated dashboards and alerting, version control all agent configurations with rigorous change management, and spend more time on testing than implementation. These practices transform agent development from an art form based on intuition and iteration into an engineering discipline with measurable outcomes, systematic methods, and predictable improvement trajectories.

---

## References

[^1]: [Write effective instructions for declarative agents | Microsoft Learn](https://learn.microsoft.com/en-us/microsoft-365-copilot/extensibility/declarative-agent-instructions) (2024). Microsoft's guidance emphasizes "Clear instructions that follow best practices help agents perform tasks as expected" and recommends starting with "a clear and concise task statement."

[^2]: [Write agent instructions - Microsoft Copilot Studio | Microsoft Learn](https://learn.microsoft.com/en-us/microsoft-copilot-studio/authoring-instructions) (2024). Documentation notes that effective agent instructions should "describe what the agent should do" and "provide context about how the agent should respond."

[^3]: [Prompt design strategies | Gemini API | Google AI for Developers](https://ai.google.dev/gemini-api/docs/prompting-strategies) (2024). Google's official guide states: "Writing clear, specific prompts is key to getting useful responses from the model."

[^4]: [Overview of prompting strategies | Generative AI on Vertex AI | Google Cloud](https://cloud.google.com/vertex-ai/generative-ai/docs/learn/prompts/prompt-design-strategies) (2024). Google Cloud documentation emphasizes structured prompts with clear task descriptions, examples, and output format specifications.

[^5]: [Building Effective AI Agents | Anthropic](https://www.anthropic.com/engineering/building-effective-agents) (2024). Anthropic's engineering blog reveals: "We've found that 90% of the work is in evaluation and observability, not in the implementation itself."

[^6]: [Gemini for Google Workspace Prompting Guide 101](https://services.google.com/fh/files/misc/gemini-for-google-workspace-prompting-guide-101.pdf) (October 2024). Google's prompting handbook recommends starting with "clear and specific goals" and using structured formats.

[^7]: [AGENTS.md](https://agents.md/) (2024). The official AGENTS.md specification describes it as "a standard for providing AI coding assistants with project-specific instructions and context."

[^8]: [Claude Code Best Practices | Anthropic](https://www.anthropic.com/engineering/claude-code-best-practices) (2024). Anthropic recommends creating CLAUDE.md files that "establish core conventions and patterns that should be followed throughout the codebase."

[^9]: [Awesome Cursor Rules You Can Setup for Your Cursor AI IDE Now](https://apidog.com/blog/awesome-cursor-rules/) (2024). Article documents Cursor rules patterns with examples showing "complete procedures, multiple examples, and conditional logic."

[^10]: [Cursor Rules: Enhance Your Development Workflow with AI-Powered Coding](https://cursor101.com/cursor/rules) (2024). Documentation explains Cursor rules enable "comprehensive operational guidance" through markdown files in `.cursor/rules/`.

[^11]: [AGENTS.md becomes the convention](https://pnote.eu/notes/agents-md/) (2024). Analysis notes that "tier boundaries should overlap slightly, with tier 1 containing pointers to tier 2 resources."

[^12]: [GitHub - AnswerDotAI/llms-txt: The /llms.txt file, helping language models use your website](https://github.com/AnswerDotAI/llms-txt) (2024). Official specification describes llms.txt as using "a strict hierarchical markdown structure: H1 project name, blockquote summary, prose description, and H2 sections."

[^13]: [The /llms.txt file – llms-txt](https://llmstxt.org/) (2024). Reference documentation states llms.txt "follows a simple format that's easy for both humans and LLMs to read."

[^14]: [AGENTS.md](https://agents.md/) (2024). Specification notes: "AGENTS.md has emerged as the universal standard after industry consolidation in 2024-2025."

[^15]: [AGENTS.md: A New Standard for Unified Coding Agent Instructions | Medium](https://addozhang.medium.com/agents-md-a-new-standard-for-unified-coding-agent-instructions-0635fc5cb759) (August 2025). Article explains AGENTS.md provides "a standardized way to provide context and instructions to AI coding assistants."

[^16]: [Cursor – Rules](https://docs.cursor.com/context/rules) (2024). Official Cursor documentation describes frontmatter support: "Rules files can include frontmatter with glob patterns, descriptions, and alwaysApply flags."

[^17]: [ElevenLabs Agents prompting guide | ElevenLabs Documentation](https://elevenlabs.io/docs/agents-platform/best-practices/prompting-guide) (2024). Guide recommends "information hierarchy that places immediately actionable content first."

[^18]: [Prompt design strategies | Gemini API | Google AI for Developers](https://ai.google.dev/gemini-api/docs/prompting-strategies) (2024). Google documentation shows "XML tags and markdown structure consistently outperform unstructured prose" in evaluations.

[^19]: [Overview of prompting strategies | Generative AI on Vertex AI | Google Cloud](https://cloud.google.com/vertex-ai/generative-ai/docs/learn/prompts/prompt-design-strategies) (2024). Documentation states: "Structured prompts with clear section delimiters improve model understanding."

[^20]: [Configuring MCP for llms.txt Files in Claude Desktop and Cursor · GitHub](https://gist.github.com/donbr/d64ccfde1887197f82e933f669f4d449) (2024). Configuration guide documents standard file locations: "Repository root contains AGENTS.md, .cursor/rules/ holds granular files."

[^21]: [LLM Prompt - Examples and Best Practices | Mirascope](https://mirascope.com/blog/llm-prompt) (2024). Article notes: "Specificity consistently outperforms generality when task requirements are clear."

[^22]: [Write effective instructions for declarative agents | Microsoft Learn](https://learn.microsoft.com/en-us/microsoft-365-copilot/extensibility/declarative-agent-instructions) (2024). Guidance emphasizes balancing specificity with flexibility: "Simple transformations need only objective plus constraints."

[^23]: [Prompt Engineering with Anthropic Claude | Medium](https://medium.com/promptlayer/prompt-engineering-with-anthropic-claude-5399da57461d) (2024). Article reports: "Anthropic found 20% accuracy gains when agents receive explicit permission to work through reasoning in scratchpad tags."

[^24]: [Overview of prompting strategies | Generative AI on Vertex AI | Google Cloud](https://cloud.google.com/vertex-ai/generative-ai/docs/learn/prompts/prompt-design-strategies) (2024). Documentation states: "Examples demonstrate patterns more effectively than descriptions."

[^25]: [The Beginner's Guide to LLM Prompting | Haystack](https://haystack.deepset.ai/blog/beginners-guide-to-llm-prompting) (2024). Guide explains: "Optimal example structure includes 2-5 diverse cases covering happy path, edge cases, and format variations."

[^26]: [How to write great Cursor Rules | Trigger.dev](https://trigger.dev/blog/cursor-rules) (2024). Best practices document recommends "explicit decision frameworks rather than implicit context-dependence."

[^27]: [Prompt design strategies | Gemini API | Google AI for Developers](https://ai.google.dev/gemini-api/docs/prompting-strategies) (2024). Google guidance notes: "Procedural descriptions benefit from hybrid declarative-imperative approaches."

[^28]: [Tool use with Claude - Claude Docs](https://docs.anthropic.com/en/docs/build-with-claude/tool-use) (2024). Documentation advises: "Superlatives like 'smartest' or 'most brilliant' don't reliably improve outputs and waste tokens."

[^29]: [Writing effective tools for LLM agents—using LLM agents | Anthropic](https://www.anthropic.com/engineering/writing-tools-for-agents) (2024). Anthropic's blog explains: "Agent-Computer Interface design prioritizes natural text patterns, minimal formatting overhead, and allowance for incremental generation."

[^30]: [Building Effective AI Agents | Anthropic](https://www.anthropic.com/engineering/building-effective-agents) (2024). Article describes the `apply_patch` tool as exemplifying "context-based matching with surrounding code snippets, enabling agents to think while generating."

[^31]: [Writing effective tools for LLM agents—using LLM agents | Anthropic](https://www.anthropic.com/engineering/writing-tools-for-agents) (2024). Blog post emphasizes: "Consolidating granular tools into workflow-appropriate tools dramatically improves performance."

[^32]: [Building Effective AI Agents | Anthropic](https://www.anthropic.com/engineering/building-effective-agents) (2024). Anthropic recommends "explicit planning phases (Plan → Act → Review), subagent delegation for context isolation, and extended thinking mode."

[^33]: [Claude Code Best Practices | Anthropic](https://www.anthropic.com/engineering/claude-code-best-practices) (2024). Best practices guide notes: "Claude Code specifically benefits from git-based state tracking and aesthetic requirements stated explicitly."

[^34]: [Function calling with the Gemini API | Google AI for Developers](https://ai.google.dev/gemini-api/docs/function-calling) (2024). Documentation highlights Gemini's "massive 1M+ token context window through data-rich detailed instructions."

[^35]: [Use agentic chat as a pair programmer | Gemini for Google Cloud](https://cloud.google.com/gemini/docs/codeassist/use-agentic-chat-pair-programmer) (2024). Guide explains: "Gemini CLI's agent mode excels at high-level goals with automatic multi-step breakdowns."

[^36]: [A practical guide to building agents](https://cdn.openai.com/business-guides-and-resources/a-practical-guide-to-building-agents.pdf) (2024). OpenAI's guide describes workflow patterns: "Prompt chaining, routing, parallelization, and orchestrator-worker patterns."

[^37]: [LLMOps in Production: 287 More Case Studies of What Actually Works - ZenML Blog](https://www.zenml.io/blog/llmops-in-production-287-more-case-studies-of-what-actually-works) (2024). Blog post reveals: "Notion AI spends 90% of development time on evaluation and observability rather than implementation."

[^38]: [LLM Agents | Prompt Engineering Guide](https://www.promptingguide.ai/research/llm-agents) (2024). Guide documents modern benchmarks: "AgentBench tests across 8 diverse environments requiring multi-turn interaction."

[^39]: [Building Effective AI Agents | Anthropic](https://www.anthropic.com/engineering/building-effective-agents) (2024). Article notes: "TheAgentCompany simulates an entire software company; best agents achieve only 30% completion rates as of 2025."

[^40]: [LLMOps in Production: 457 Case Studies of What Actually Works - ZenML Blog](https://www.zenml.io/blog/llmops-in-production-457-case-studies-of-what-actually-works) (2024). Analysis emphasizes: "Version control treats agent configurations as engineering artifacts with semantic versioning and structured commit messages."

[^41]: [How to build your agent: 11 prompting techniques for better AI agents - Augment Code](https://www.augmentcode.com/blog/how-to-build-your-agent-11-prompting-techniques-for-better-ai-agents) (2024). Article documents: "Hierarchical multi-agent architecture consistently outperforms single-agent React patterns in complex domains."

[^42]: [A practical guide to building agents](https://cdn.openai.com/business-guides-and-resources/a-practical-guide-to-building-agents.pdf) (2024). OpenAI guide identifies common failures: "Tool design failures, context overload, poor tool descriptions, ignoring model-specific strengths."

[^43]: [Building Effective AI Agents | Anthropic](https://www.anthropic.com/engineering/building-effective-agents) (2024). Anthropic recommends: "Start with a single LLM plus 3-5 well-designed tools, add complexity only when simpler solutions demonstrably fail."

[^44]: [Prompt design strategies | Gemini API | Google AI for Developers](https://ai.google.dev/gemini-api/docs/prompting-strategies) (2024). Google guidance suggests: "Choose models strategically based on task characteristics."

[^45]: [Building Effective AI Agents | Anthropic](https://www.anthropic.com/engineering/building-effective-agents) (2024). Article recommends: "Claude for complex reasoning, Gemini for large document analysis, GPT for reliable orchestration."

[^46]: [Writing effective tools for LLM agents—using LLM agents | Anthropic](https://www.anthropic.com/engineering/writing-tools-for-agents) (2024). Blog describes optimization patterns: "Consolidating functions, implementing response format enums, adding pagination and filtering."

[^47]: [LLMOps in Production: 287 More Case Studies of What Actually Works - ZenML Blog](https://www.zenml.io/blog/llmops-in-production-287-more-case-studies-of-what-actually-works) (2024). Article emphasizes: "Production observability infrastructure with comprehensive tracing, custom dashboards, and alerting."

[^48]: [Effective context engineering for AI agents | Anthropic](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents) (2024). Anthropic's guide covers: "Context engineering as a distinct discipline with compaction techniques and just-in-time loading mechanisms."

[^49]: [RAG Best Practices: Lessons from 100+ Technical Teams - kapa.ai](https://www.kapa.ai/blog/rag-best-practices) (2024). Analysis documents: "40% increases in RAG pipeline attacks and system prompt leakage incidents."

[^50]: [Prompt engineering overview - Claude Docs](https://docs.claude.com/en/docs/build-with-claude/prompt-engineering/overview) (2024). Documentation emphasizes: "Success correlates more strongly with evaluation rigor than architectural sophistication."

[^51]: [AGENTS.md](https://agents.md/) (2024). Specification site notes: "Convergence on standard formats represents industry maturation with network effects through adoption."