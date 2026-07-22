---
source: ~/vaults/gemini/CLAUDE.md — top-level orchestration/handover doc for the built 7-agent "Principled Researcher" Claude Code system (Aug 2025)
gathered: 2026-07-21
status: gathered — verbatim whole-file copy
paths:
  - ~/vaults/gemini/CLAUDE.md
source_commit: git f8a6ec99a9749f3fce763c6bdb9cb95a75ca8496 (repo ~/vaults/gemini)
categories: [tier2-shipped-practice, orchestration, multi-agent-architecture, output-contract, quality-gate, honest-deprecation, handover-doc]
why_included: >
  The system-level view behind the two agent-def copies: the roster (7 agents,
  each pinned to a model tier — sonnet coordinator, haiku workers, opus for
  formalization), the workflow, and the QUALITY GATES that bind agent output to
  a machine-checkable contract ("All analyses must pass linter validation …
  All linter warnings must be reviewed"). Two harness-relevant witnesses stand
  out: (1) the file names itself a handover artifact — "allow for seamless
  handover between agents and human operators" — documents-as-shared-context,
  UDON's other thesis; (2) an HONEST DEPRECATION at the very end, line 138:
  "Agents not working great and currently can't invoke other agents well at all.
  Need to fix it." — a lived friction signal (subagent-invocation reliability)
  from the tool's actual operator, the kind of admitted-gap the brief prizes.
---

# Principled Researcher Agent Instructions

This file documents the process and standards being followed by the Principled Researcher multi-agent system. It serves as a reference to ensure consistency and allow for seamless handover between agents and human operators.

## Multi-Agent System Architecture

### Specialized Agents (7 Total) - Enhanced with Complete Foundation Integration
- **research-coordinator** (Sonnet 4): Orchestrates FP-v2.0 workflow with strategic framework integration
- **content-extractor** (Haiku 3.5): EPUB processing and content extraction with boundary condition identification
- **claim-analyzer** (Sonnet 4): Structures claims using FP-v2.0 methodology with embedded examples, adversarial verification, anti-bias measures
- **fp-grounding-agent** (Opus 4.1): Mathematical formalization with exact FP-001 through FP-013 expressions, hallucination prevention
- **citation-researcher** (Haiku 3.5): Temporal arbitrage research with research frontier strategy, systematic serendipity mechanisms
- **quality-validator** (Haiku 3.5): Ruby linter validation with pattern recognition for excellence vs. failure modes
- **output-formatter** (Haiku 3.5): Final template compliance and formatting with quality standard enforcement

### System Monitoring & Visibility
- **Monitoring Dashboard**: http://localhost:5173/ (when active)
- **Centralized Logging**: All activity → `.agent-log`
- **Hook Configuration**: Use `/hooks` command for interactive setup
- **Troubleshooting**: Complete guide in `AGENT_VISIBILITY_GUIDE.md`
- **Web Research**: Handles 303 redirects via search workarounds (documented in citation-researcher)
- **Multi-Claim Processing**: Each chapter analyzed as individual claims with parallel processing
- **Quality Assurance**: Principle hallucination detection in `methodology/analysis_linter.rb`

## Current Task

**Long Term Objective**: Build "Current Principled Best AI+Human Practices for Elixir+OTP Systems - 2025" using systematic knowledge arbitrage and strategic research frontier mining.

### Research Strategy (Updated from Foundation Analysis)

**Phase 0 - Research Frontier Implementation** (NEW):
- Implement systematic knowledge arbitrage per `foundation/research_frontier_synthesis.md`
- Deploy Human-as-RAG workflow: AI-guided discovery → targeted extraction → synthesis
- Apply Research Portfolio approach: Core (20%) + Growth (60%) + Venture (20%)
- Focus on cross-domain synthesis and temporal arbitrage (2024-2025+ sources)

**Phase 1 - General Works** (pragprog, etc.): Analyze broader practices with strategic focus:
   - Knowledge gaps not well-represented in LLM training data
   - Cross-domain synthesis opportunities (Christopher Alexander → AI alignment patterns)
   - Methodological innovations for analysis capability development
   - Defensible knowledge advantages vs. keeping up with mainstream

**Phase 2 - Elixir-Specific Works**: Deep analysis with A²O² strategic cycle:
   - **Alignment**: Establish strategic intent for BEAM ecosystem optimization
   - **Action**: Systematic analysis using FP-v2.0 methodology
   - **Observation**: Track discovery → application conversion rates
   - **Orientation**: Adapt methodology based on empirical results

**Phase 3 - Synthesis**: Strategic knowledge capability development:
   - Validated FP-ALIGNED practices with quantified time optimization
   - ANTI-PRINCIPLED practices with harm confidence assessment
   - AI+Human collaboration patterns optimized for competitive advantage
   - Meta-insights on "how to know" rather than just "what to know"

### Success Criteria (Updated with Strategic Framework)
- Each practice classified as FP-ALIGNED/NEUTRAL/ANTI-PRINCIPLED with confidence intervals
- Quantified time optimization benefits for BEAM-specific patterns  
- **Knowledge Arbitrage ROI**: Measure conversion from frontier discoveries to actionable insights
- **Cross-Domain Synthesis**: Identify novel connections between domains (e.g., Erlang supervision trees ↔ organizational resilience patterns)
- **Temporal Advantage**: Leverage 2024-2025+ sources for competitive knowledge gaps
- **Capability Development**: Build "how to know" rather than just "what to know" advantages

## Analysis Standards

**IMPORTANT**: Full methodology is documented in `methodology/` directory, which synthesizes:

1. **13 Formal First Principles** (FP-001 through FP-013) with mathematical expressions from `foundation/__software-first-principles.md`
2. **Strategic Research Frontier Framework** from `foundation/research_frontier_synthesis.md` 
3. **A²O² Strategic Execution Cycle** from `foundation/strategy-A2O2.md`
4. **Empirical Validation Requirements** based on large-scale repository analysis framework from `foundation/empirical/`
5. **Epistemological Architecture** incorporating adversarial verification and institutional wisdom analysis from `foundation/epistemological/`

**All analysis must follow the comprehensive framework documented in `methodology/ANALYSIS_OUTPUT_TEMPLATE.md` using FP-v2.0 methodology.**

Key requirements (now embedded directly in agent instructions):

1. **Framework Version**: FP-v2.0 with references to foundation documents
2. **Knowledge Arbitrage Assessment**: LLM gaps, cross-domain synthesis, temporal arbitrage, portfolio classification  
3. **Strategic Context Analysis**: A²O² cycle implementation with alignment/action/observation/orientation
4. **First Principles Grounding**: Must connect to specific FP-001 through FP-013 with exact mathematical expressions (embedded in agents with hallucination prevention)
5. **Dynamic Capabilities Evaluation**: Sensing/seizing/transforming organizational adaptation analysis
6. **Empirical Validation**: Required sources from 2024-2025+ using Tier 1-4 classification system with temporal arbitrage focus
7. **Bayesian-Conformal Confidence**: Hybrid analysis with prior/likelihood/posterior + conformal prediction
8. **Time Optimization Focus**: All claims analyzed through measurable time dimensions (implementation, comprehension, change-set size, proximity, discontinuities)
9. **Adversarial Verification**: Mandatory inclusion of conflicting evidence per epistemological architecture (integrated in agents)
10. **Human-as-RAG Integration**: Discovery triggers, extraction priorities, synthesis opportunities

### Agent Enhancement Summary (August 2025)
**All agents now contain embedded:**
- Complete formal FP-001 through FP-013 definitions with exact mathematical expressions
- Strategic research frontier methodology from `foundation/research_frontier_synthesis.md`
- A²O² strategic execution cycle from `foundation/strategy-A2O2.md` 
- Epistemological architecture with adversarial verification from `foundation/epistemological/`
- Empirical validation framework with Tier 1-4 classification from `foundation/empirical/`
- Critical analysis patterns from `methodology/examples/` including excellence markers and failure modes
- Anti-bias measures, quality gates, and pattern recognition capabilities

**Template Structure**: XML boundaries with Markdown content, including:
- `<claim_extraction>` with epistemic/normative/mixed classification
- `<first_principles_grounding>` with exact FP mathematical formulations
- `<empirical_validation>` with multi-tier evidence classification
- `<confidence_assessment>` with Bayesian-conformal hybrid methodology
- `<elixir_otp_applicability>` with time optimization analysis
- `<ai_agent_practicability>` with FP-guided automation strategy

## File Structure
- **Analysis**: `analysis/<book_title>/<chapter_title>.md`
- **TODO List**: `TODO.md`
- **STATUS**: `STATUS.md` (project overview and current state)
- **Methodology**: `methodology/` (templates, examples, linter, version history)
- **Foundation**: `foundation/` (first principles, empirical framework, epistemological architecture)

**⚠️ IMPORTANT**: Keep STATUS.md and CLAUDE.md synchronized - changes to one should be reflected in the other for coherent project documentation.

## Analysis Workflow

### For Each Work (Strategic Research Approach):
1. **Knowledge Gap Assessment**: Identify knowledge not well-represented in LLM training data
2. **Cross-Domain Opportunity Mapping**: Look for synthesis opportunities across disciplines
3. **Temporal Arbitrage Evaluation**: Prioritize recent insights (2024-2025+) for competitive advantage
4. **Claim Extraction**: Use `methodology/ANALYSIS_OUTPUT_TEMPLATE.md` structure
5. **FP Grounding**: Connect claims to specific FP-001 through FP-013 mathematical expressions
6. **Adversarial Research**: Find conflicting evidence using web search and domain expertise
7. **Confidence Assessment**: Apply Bayesian-conformal hybrid methodology with bias detection
8. **Strategic Classification**: Determine FP-ALIGNED/NEUTRAL/ANTI-PRINCIPLED with knowledge arbitrage value
9. **Validation**: Run `methodology/analysis_linter.rb` before finalizing
10. **Network Integration**: Build defensible knowledge advantages through systematic cross-referencing

### Quality Gates:
- All analyses must pass linter validation (no hard rejections)
- **All linter warnings must be reviewed and corrections attempted** by research agent
- Minimum 3 external citations from current period (2024-2025+)
- Mathematical formalization using exact FP expressions from foundation document
- Adversarial verification with contrary evidence included
- Quantified predictions with confidence intervals and boundary conditions
- older attempts etc. are in the backup folder so they can be scrutinized for any insights
- we are using rvm in this project -- execute ruby commands etc. accordingly
- Agents not working great and currently can't invoke other agents well at all. Need to fix it.