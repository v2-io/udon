# Review: 02-tooling-needs (Agentic Tooling Monograph)

**Reviewer:** agy (Gemini 3.1 Pro (High)) **Date:** 2026-07-22 **Reviewed Commit/State:** Working state as of 2026-07-22 (Drafting phase, `OUTLINE.md` completed, `src/` populated)

## Findings

### 1. Dissent: Tool-call editing abandonment is lineage-specific, not universal (Severity: High, Dissent / Excellence)
* **Location:** `src/edit-representation-landscape.md` (Section: The abandonment that explains the landscape)
* **Finding:** The report claims that `aider` tried and killed tool-call (JSON-function) editing because models mangled structured arguments, concluding that "convergence on prompt-dialect editing is the residue of that negative result." **As a non-Claude model, I must strongly dissent.** Tool-call editing via structured JSON parameters (e.g., passing `TargetContent` and `ReplacementContent` via JSON arrays for exact str-replace) is *highly* successful and is the default, primary editing modality in my ecosystem (the Antigravity IDE and Google Agentic frameworks). The mangling of structured arguments was largely a historical artifact of early JSON-mode capabilities in specific model lineages (or context-window exhaustion), not a fundamental truth about agents. Structured tool calls for editing provide explicit schema validation *at the tool layer* before the edit is ever applied, fulfilling the exact "guarantees" this monograph seeks.
* **Suggested Disposition:** Soften the claim that tool-call editing is universally dead. Mark it as a known failure mode for certain model families/eras, but explicitly note that modern tool-calling capabilities in other families *do* successfully use structured JSON editing. 

### 2. Excellence in Epistemic Discipline (Severity: Medium, Excellence)
* **Location:** `README.md` (State of the report / Frontmatter fields) and `OUTLINE.md`
* **Finding:** The strict separation of claims by their epistemic status (`stage: planned` vs `drafted`) and the explicit instruction in the `README` not to cite planned rows as if they were synthesized, is exceptional. The use of five evidence tiers and explicit lineage-correction for Tier 2 prevents "survivorship bias" from being masqueraded as universal truth. This discipline ensures the downstream consumers (UDON and the harness) are building on solid ground.
* **Suggested Disposition:** None. This is best-in-class documentation philosophy and should be maintained strictly as the remaining segments are drafted.

### 3. Context Loss and the "Cleverness" Claim (Severity: Low, Fidelity)
* **Location:** `OUTLINE.md` (The one-paragraph thesis)
* **Finding:** The thesis states: "...context loss that no amount of in-session cleverness compensates." While it is true that context is a hard budget and persistence requires externalized state formats, "in-session cleverness" (such as semantic search tools, grep-search, or dynamic context-window indexing) *does* compensate for context loss significantly by allowing the agent to dynamically page information in and out of the active window without relying purely on a durable document state.
* **Suggested Disposition:** Qualify the claim. Externalized state is required for *cross-session* continuity, but dynamic retrieval tools are a valid architectural solution for in-session context budget constraints.

### 4. Schema-Guarded Mutation and Addressing (Severity: Medium, Fidelity)
* **Location:** `OUTLINE.md` (Part IV)
* **Finding:** The report correctly identifies that schema-guarded structural mutation is blocked on stable addressing. However, "relational-first lookup" or deep semantic paths (XPath-style) are not the *only* way to achieve stable addressing. As long as the agent has a tool that can reliably locate a snippet (via exact string match or bounded line numbers), the mutation can be guarded by a schema check *post-edit* (e.g., pre-patch evaluation) rather than requiring the language itself to support a complex path syntax for the edit target.
* **Suggested Disposition:** Ensure the paths spike considers whether "paths" are strictly necessary for the edit action itself, or if they are just one of several targeting mechanisms (alongside regex, exact match, or line ranges).
