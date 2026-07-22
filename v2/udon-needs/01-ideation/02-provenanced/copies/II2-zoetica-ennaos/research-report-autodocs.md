---
source: ennaos agentic-coding-background/refs — self-navigating markdown repository for human/AI PM (Oct 2025)
gathered: 2026-07-21
status: gathered (verbatim whole-file copy)
paths:
  - /Users/josephwecker-v2/src/_core/ennaos/docs/research/agentic-coding-background/refs/research-report-autodocs.md
source_commit: 5abb2fe
categories: [self-navigating-repo, readme-first-bootstrap, frontmatter-as-API, structure-is-metadata, agent-orientation]
why_included: >
  Squarely on UDON's "structure IS the metadata/chunking" pitch and on agent orientation generally: README-first
  as the agent bootstrap, YAML-frontmatter-as-API, living-document validation via pre-commit, glossary
  auto-linking — engineering a repo so a fresh-context agent can deterministically find its next action. Strong
  material for the harness's memory/orientation surface as well as UDON's self-chunking claim.
---

Of course. Here is the report formatted as a markdown artifact with footnotes for all citations.

# A Self-Navigating System for Human/AI Project Management in a Markdown-Based Repository

## Part I: Foundational Principles for a Self-Navigating Repository

To construct a project management system capable of autonomously orienting ephemeral AI agents, the repository must transcend its role as a mere collection of files. It must be engineered as a structured, self-describing, and self-validating knowledge base. This requires a paradigm shift from documentation as a passive artifact to documentation as an active, queryable system. The following principles form the bedrock of this architecture, ensuring that an AI agent with a fresh context window can deterministically parse the project's state, identify its next course of action, and operate with minimal human intervention.

### 1.1 The README-First Development Paradigm as a Navigational Imperative

The `README.md` file is the universally recognized entry point for any software project.[^1][^2] Its historical significance, dating back to the PDP-10 era, establishes it as the canonical starting point for any developer, human or machine.[^3] For an ephemeral AI agent, this role is elevated from a simple project description to the primary bootstrap mechanism. Therefore, this system adopts the "README-first" development philosophy, not merely as a best practice for human collaboration, but as a functional requirement for AI orientation.[^3]

The root `README.md` will serve as the master index and gateway to the entire project. Its function is to provide an immediate, high-level summary and, critically, a structured set of navigational links that point to the core manifest files and key documentation sections. This ensures that an agent's initial interaction with the repository—the equivalent of reading the first file—immediately furnishes it with a map of all essential resources. By establishing this single, unambiguous entry point, the system eliminates the need for the agent to guess or infer the project's structure, thereby making its orientation process deterministic and efficient.

### 1.2 Metadata as the API: Structuring Markdown for Machine Readability

While Markdown is prized for its human-readability, its prose is inherently unstructured, making it an unreliable medium for machine parsing of discrete state information.[^1][^4] To overcome this, the system must embed a structured data layer directly within the markdown files. This is achieved through the systematic use of **YAML Front Matter**.[^5][^6]

Every key project management document will begin with a YAML front matter block, delineated by `---`. This block will contain a predefined schema of key-value pairs, lists, and nested objects that represent the document's machine-readable metadata, such as its status, owner, dependencies, and version.[^5][^7] This practice effectively transforms each markdown file into a queryable "object" with a consistent interface. The YAML front matter is explicitly designed for structured metadata rather than long-form content, making it the ideal vehicle for this purpose.[^5]

This architectural choice establishes a critical separation of concerns between machine-readable state and human-readable context. The YAML front matter serves as the repository's "API," providing structured, unambiguous data that AI agents and automation scripts can parse to build an accurate model of the project's state. The Markdown body, in turn, provides the narrative, rationale, and qualitative context necessary for the human team member and for higher-level reasoning by the AI. An agent's workflow must therefore prioritize parsing the YAML layer first to construct its state model, subsequently using the Markdown body to enrich its understanding of that model's meaning and intent.

By committing the entire project management state to Git in this structured text format, the system achieves "Project Management as Code." This approach has profound implications: every change to a task's status, every architectural decision, and every update to the roadmap is versioned, auditable, and can be reviewed through pull requests. It allows for "time-traveling" the project state to understand its evolution and provides an unprecedented level of transparency and accountability. An AI can analyze this versioned history to identify patterns in project velocity, common blockers, or decision-making processes, extending its capabilities far beyond simple task execution.

### 1.3 The Living Document Principle via Automation and Validation

A key challenge in any documentation system is preventing entropy; static files quickly become outdated and untrustworthy, eroding their value. To counteract this, the system must be designed as a "living," self-validating entity. This is accomplished through a robust automation pipeline built on **`pre-commit` hooks**.[^8][^9][^10]

These hooks will trigger a suite of scripts on every `git commit` to perform validation, linting, and auto-generation tasks. For example, hooks will check for broken links, ensure markdown formatting is consistent, automatically update tables of contents, and run custom scripts to validate the integrity of the project's task dependency graph. This proactive approach transforms the static documentation into a dynamic system where inconsistencies are caught and rectified before they are integrated into the main branch.

This automation is not merely a quality gate; it functions as a **system integrity engine**. By including custom validation scripts that act as "unit tests" for the project management state, the `pre-commit` pipeline guarantees that the `main` branch always represents a consistent and valid state. This elevates the documentation from a passive record to a robust, validated dataset, which is the absolute prerequisite for trusting an AI agent to act upon it. This automated enforcement of standards prevents the accumulation of "tribal knowledge" and reduces dependency on manual updates, which is critical for a high-turnover team of ephemeral AI agents.[^2]

The following table provides a high-level summary of the tools and methodologies that constitute this system.

|**System Component**|**Primary Tool/Methodology**|**Purpose**|**Relevant Research**|
|---|---|---|---|
|**Metadata Layer**|YAML Front Matter|Provides a structured, machine-readable "API" within each Markdown file for state and metadata.|[^5][^6]|
|**Task Management**|`TODO.md` Format (Markdown Kanban)|A simple, text-based format for tasks using headers and lists, optimized for script-based parsing.|[^16][^18]|
|**Architecture Docs**|arc42, C4 Model (with Mermaid), MADR|A multi-layered framework for documenting architecture structure, interactions, and decision rationale.|[^11][^12][^20][^24]|
|**Terminology**|`glossarify-md`|Establishes a DDD ubiquitous language and automates the cross-linking of terms to definitions.|[^13][^15]|
|**Automation/Validation**|`pre-commit` Hooks|An engine for running automated checks and scripts on every commit to ensure system integrity.|[^8][^9]|
|**Multi-Repo Docs**|Git Submodules / Antora|Manages documentation and code distributed across multiple private Git repositories.|[^39][^41][^42]|
|**Elixir Integration**|ExDoc tool|Generates a unified HTML documentation site from Elixir code docs and Markdown project files.|[^45][^48]|

## Part II: The Core Project Directory Structure and Manifests

A predictable, canonical directory structure is paramount for an AI agent's ability to navigate and locate information without prior domain knowledge. The following layout is designed to be logical, hierarchical, and self-documenting, forming the stable backbone of the project management system.

### 2.1 The Root README.md: The Agent's Gateway

As the designated entry point, the root `README.md` must be meticulously structured to guide any new agent. It serves as the project's "front door" and initial bootstrap script.

**Structure:**

- **Project Title & High-Level Description:** A concise, one-paragraph summary of the project's purpose and goals, answering the "what" and "why".[^1][^2]
    
- **Project Status Dashboard:** A simple Markdown table providing at-a-glance metrics. This section should be either manually updated as part of a release praxis or, ideally, dynamically generated by a script and updated via a pre-commit hook.
    

|**Metric**|**Status**|
|---|---|
|Current Version|0.1.0-alpha|
|Active Operata|12|
|Blocked Operata|2|
|Next Milestone|Q3 2024|

- **`` Block:** A specially formatted, machine-parsable block containing the initial, non-negotiable instructions for an AI agent. This directive explicitly guides the agent's next action, removing ambiguity from the orientation process.
    
- **Core Navigation:** A structured list of links pointing to the most critical documents and directories, providing a human-readable map of the repository.
    
    - `[Project Manifest](./PROJECT.md)`: The central source of truth for project metadata.
        
    - `(./docs/README.md)`: The entry point for all detailed documentation.
        
    - `(./apps/)`: A link to the Elixir/OTP umbrella applications directory.
        
    - `[Contribution Guide](./CONTRIBUTING.md)`: Guidelines for making contributions.
        

### 2.2 The Project Manifest: PROJECT.md with YAML Front Matter

This file acts as the central registry and authoritative source of truth for high-level project metadata. An AI agent will parse this file immediately after the root `README.md` to build its foundational understanding of the project's scope, components, and key entry points.

YAML Front Matter Schema:

The YAML block at the top of PROJECT.md defines the project's core attributes in a structured format. This includes the list of all associated repositories, which is critical for a multi-repo project.

YAML

```yaml
---
project_name: "Elixir Quantum TUI Toolkit"
version: "0.1.0-alpha"
status: "active" # active | maintenance | archived
owner: "Human Lead Name"
repositories:
  - name: "main_umbrella"
    url: "git@github.com:user/main_repo.git"
    role: "primary"
  - name: "post_quantum_crypto"
    url: "git@github.com:user/pq_crypto.git"
    role: "submodule"
    path: "./external/pq_crypto"
  - name: "elixir_tui_lib"
    url: "git@github.com:user/tui_lib.git"
    role: "submodule"
    path: "./external/tui_lib"
key_technologies:
documentation_entry: "./docs/README.md"
task_board_entry: "./docs/02_operata/BOARD.md"
architecture_entry: "./docs/03_architecture/README.md"
---
```

Markdown Body:

The body of PROJECT.md provides a human-readable narrative that expands upon the metadata. It should explain the purpose of the different repositories, the overall technical strategy, and the project's primary objectives.

### 2.3 The /docs Directory: A Structured Knowledge Base

This directory houses all long-form documentation in a predictable, numbered, and hierarchical structure. This design is not arbitrary; the numerical prefixes create an explicit **critical path for knowledge acquisition**. An AI agent can be programmed to process these directories sequentially (`01_lexicon`, then `02_operata`, and so on) to build a layered, comprehensive understanding of the project. This transforms a simple file system into a structured curriculum for agent onboarding, making the discovery process deterministic and reliable.

The structure is inspired by the modularity of frameworks like `arc42` [^11][^12], ensuring a logical separation of concerns.

**Directory Structure:**

```
/docs
├── README.md                 # Hub for all documentation, with a generated Table of Contents
├── 01_lexicon/
│   └── GLOSSARY.md           # The DDD Ubiquitous Language glossary
├── 02_operata/
│   ├── BOARD.md              # The main Kanban board for tracking work items
│   └── archive/              # Directory for storing completed or closed-out tasks
├── 03_architecture/
│   ├── README.md             # High-level overview (arc42 Sections 1-4)
│   ├── C4_diagrams.md        # Embedded C4 diagrams using Mermaid syntax
│   ├── building_blocks.md    # Detailed component view (arc42 Section 5)
│   ├── runtime_view.md       # Interaction scenarios (arc42 Section 6)
│   └── decisions/            # Directory for Architectural Decision Records (MADRs)
│       └── 0001-use-madr.md
├── 04_design_system/
│   └── README.md             # Documentation for UI components (e.g., the TUI library)
├── 05_praxes/
│   ├── on-boarding_praxis.md # Step-by-step guide for new agents
│   └── troubleshooting.md    # A living guide for common problems and solutions
├── 06_conventions/
│   └── coding_style.md       # Enforceable coding standards and commit message formats
├── 07_agents/
│   ├── code_generator_agent.md # Profile and competencies for the code generation agent
│   └── test_writer_agent.md    # Profile and competencies for the test writing agent
└── 08_roadmap/
    └── ROADMAP.md            # High-level strategic project roadmap
```

## Part III: Implementing the Project Management Artifacts

This section provides the detailed templates and procedures for each of the core markdown documents defined in the `/docs` directory. Each artifact is engineered with the dual purpose of being both human-readable and machine-parsable, forming the functional core of the project management system.

### 3.1 /docs/01_lexicon: The Ubiquitous Language with glossarify-md

To ensure clear communication and eliminate ambiguity between the human lead, AI agents, and the codebase itself, a shared vocabulary is essential. This aligns with the principle of the "Ubiquitous Language" from Domain-Driven Design (DDD).[^14] The `GLOSSARY.md` file serves as the single source of truth for all project-specific terminology.

Template (GLOSSARY.md):

The format is simple and optimized for parsing. Each term is a level-2 heading (##), followed by its definition. Aliases and synonyms are defined within a YAML-formatted HTML comment block immediately following the term, a syntax supported by glossarify-md.[^13]

# Project Lexicon

This document defines the Bounded Universal Domain Language for this project.

## Operatum

A single, discrete unit of work that can be undertaken to advance the project. An Operatum has a defined state (e.g., 'Todo', 'Blocked', 'Done') and may have dependencies on other Operata. It is the atomic unit of work tracked on the project board.

## Bounded Context

A specific responsibility area within the software, governed by its own ubiquitous language. In our umbrella app, each child application (e.g., `post_quantum_crypto`, `elixir_tui_lib`) represents a distinct Bounded Context with clear boundaries.

Automation:

The glossarify-md tool will be integrated into the pre-commit pipeline.[^13][^15] On every commit, this tool will scan all other markdown files in the repository. When it finds an occurrence of a term or its alias defined in GLOSSARY.md, it will automatically convert that text into a hyperlink pointing back to the term's definition. This process creates a self-annotating, interconnected knowledge base, allowing any team member (human or AI) to instantly look up the precise meaning of domain-specific terms.

### 3.2 /docs/02_operata: Task and Workflow Management with Markdown Kanban

This component tracks all work items (`Operata`). The chosen format prioritizes scriptability and direct machine-parsability over visual fidelity. The `TODO.md` format, which uses standard Markdown headers for columns and task lists for cards, is ideal.[^16] This approach is vastly superior to systems that rely on complex, embedded data formats like URL-encoded JSON, as it is natively readable and can be parsed with simple, robust scripts using standard text-processing tools.[^17]

Template (BOARD.md):

The board includes a YAML front matter block for board-level metadata and uses H2 headings for columns. Each task is a list item with a unique identifier, a GFM checkbox, and optional metadata such as dependencies, assignees, and estimates.

# Main Project Board

---

## board_id: "main-board" last_updated: "2024-09-15T14:30:00Z"

## Backlog

- [ ] **T-101:** Design the TUI layout for the crypto module #feature @human
    
- [ ] **T-102:** Implement the `KeyGen` algorithm for post-quantum crypto #crypto @ai-coder
    

## Todo

- [ ] **T-103:** Write unit tests for the `KeyGen` module #testing @ai-tester
    
    - _Depends on: T-102_
        

## In Progress

- [ ] **T-104:** Set up CI pipeline for the crypto repo #devops @human
    
    - _Started: 2024-09-14_
        

## Blocked

- [ ] **T-105:** Integrate TUI library with main application #ui @ai-coder
    
    - _Blocked by: T-101_
        
    - _Reason: Awaiting final design approval for TUI layout._
        

## Done ✓

- [x] **T-100:** Initialize project structure #setup @human
    

Scripting and Validation:

A custom script (scripts/validate_board.py), executed via a pre-commit hook, will parse this file to:

1. Extract all tasks and their associated metadata (ID, state, dependencies, assignee).
    
2. Construct a directed graph of task dependencies.
    
3. Validate the graph's integrity by checking for critical inconsistencies, such as circular dependencies, dependencies on non-existent tasks, or tasks being blocked by already completed tasks.
    
4. Generate a report on the project's critical path(s) by identifying the longest sequence of dependent tasks.
    
    While a human developer can use a VSCode extension like "Markdown Kanban" for a visual interface, the underlying text file remains the canonical source of truth.[^18]
    

### 3.3 /docs/03_architecture: Documenting with arc42, C4 Model, and MADR

A comprehensive understanding of the software architecture requires viewing it from multiple levels of abstraction. This system achieves this by creating a fractal documentation pattern, combining the `arc42` template for high-level structure, the C4 model for visualizing interactions, and Markdown Architectural Decision Records (MADRs) for capturing the rationale behind key decisions. This allows an AI agent to traverse the structure to understand not just _what_ the architecture is, but _how_ it works and _why_ it is designed that way.

**Structure and Templates:**

- **`README.md` (arc42 Sections 1-4):** This file serves as the main entry point for the architecture, covering the Introduction and Goals, Constraints, Context and Scope, and Solution Strategy.[^11][^19]
    
- **`C4_diagrams.md` (Diagrams as Code):** To ensure architectural diagrams are version-controlled and maintainable, they will be defined as code using **Mermaid** syntax.[^20] This file will contain the Mermaid code blocks for the C4 System Context, Container, and Component diagrams, which can be rendered into images by supporting tools.[^21][^22][^23]
    
    **Example C4 Context Diagram in Mermaid:**
    
    Code snippet
    
    ```mermaid
    C4Context
      title System Context diagram for Quantum TUI Toolkit
    
      Person(developer, "Developer", "A developer using the TUI library.")
      System_Ext(host_os, "Host OS", "The operating system terminal.")
    
      System_Boundary(c1, "Elixir Umbrella Project") {
        Container(main_app, "Main Application", "Elixir/OTP", "The primary user-facing application.")
        Container(tui_lib, "TUI Library", "Elixir", "Provides terminal user interface components.")
        Container(pq_crypto, "PQ Crypto Library", "Elixir/NIF", "Implements post-quantum cryptographic algorithms.")
      }
    
      Rel(developer, main_app, "Interacts with")
      Rel(main_app, tui_lib, "Uses")
      Rel(tui_lib, host_os, "Renders to")
      Rel(main_app, pq_crypto, "Uses for secure operations")
    ```
    
- **`decisions/` (arc42 Section 9):** This directory will house all significant architectural decisions, each documented in its own file using the **MADR** template.[^24][^25] This creates a permanent, auditable log of the project's architectural evolution.
    
    ## **Example MADR file (`0002-use-mermaid-for-diagrams.md`):**
    
    ## status: "accepted" date: "2024-09-15" decision-makers: ["Human Lead"]
    
    # Use Mermaid for "Diagrams as Code"
    
    ## Context and Problem Statement
    
    Architectural diagrams are essential for understanding the system but can easily become outdated if maintained in binary formats (e.g., PNG, Visio). We need a method to create, version, and maintain diagrams alongside our code and documentation.
    
    ## Considered Options
    
    - Mermaid.js
        
    - PlantUML
        
    - Embedded binary image files
        
    
    ## Decision Outcome
    
    Chosen option: "Mermaid.js", because it uses a simple, markdown-like syntax that integrates well with our existing toolchain, is supported by many Markdown renderers (including GitHub), and allows diagrams to be version-controlled as plain text.
    

### 3.4 /docs/04_design_system: Integrating Storybook for Component Visualization

This section is dedicated to documenting UI components, primarily the Elixir TUI library. While Storybook is a web-centric tool, its documentation framework, MDX, can be adapted for this purpose.[^26][^27]

**Integration Strategy:**

- **MDX for Documentation:** The primary documentation will be written in MDX files, which combine Markdown with JSX-like syntax.[^26] This allows for rich, structured content.
    
- **Static Visuals:** Since live rendering of an Elixir TUI component in a web-based Storybook is not feasible, component examples will be represented by high-quality screenshots or animated GIFs. These visuals will be embedded within Storybook's `<Canvas>` or `<Story>` blocks to maintain a consistent documentation format.
    
- **Iframe Embedding for Web Components:** If any part of the umbrella project includes a web interface, live Storybook components for that interface can be embedded directly into the documentation using standard `<iframe>` or oEmbed links, provided the Storybook instance is publicly hosted.[^28][^29]
    

Template (README.md):

An MDX file that structures the TUI library documentation, showcasing component examples with static images.

Code snippet

```markdown
import { Meta, Story, Canvas } from '@storybook/addon-docs/blocks';

<Meta title="Design System/TUI Library" />

# TUI Library Components

## Button Component

The `Button` component is a simple, clickable element for terminal interfaces.

<Canvas>
  <Story name="Default Button">
    <img src="./images/tui-button-default.png" alt="Default TUI Button" />
  </Story>
</Canvas>
```

### 3.5 /docs/05_praxes: Codifying Procedures and Troubleshooting Guides

`Praxes` are the project-specific practices and procedures that define "how we work here." This includes the critical self-serve workflow for AI agents and a living troubleshooting guide.

Template (troubleshooting.md):

This document will be a collection of common problems and their solutions, structured for easy parsing by both humans and AI. Each entry will use YAML front matter for categorization and keyword tagging, inspired by interactive guide templates.[^30][^31]

---

error_code: "MIX_DEPS_FETCH_FAIL"

symptoms:

- "mix deps.get fails with authentication error"
    
- "Access denied to private git repository"
    
    tags: ["dependencies", "git", "setup", "ssh"]
    

---

## Problem: `mix deps.get` Fails for Private Repositories

**Context:** The project utilizes private Git repositories as dependencies, as defined in `PROJECT.md`. These require proper SSH key-based authentication.

**Solution:**

1. **Verify SSH Key:** Ensure your SSH key is correctly configured and added to your Git provider account.
    
2. **Verify Repository Access:** Confirm with the project owner that your account has been granted read access to the private dependency repository.
    
3. **Test Connection:** Run `ssh -T git@github.com` to validate your SSH connection to the Git provider. A successful connection will return a welcome message.
    
4. **Clean Cache:** If issues persist, remove the `_build` and `deps` directories and run `mix deps.get` again.
    

Agent Onboarding Praxis (on-boarding_praxis.md):

This will be a dedicated markdown file that outlines the step-by-step protocol an AI agent must follow to orient itself and make its first contribution. This document is the human-readable version of the workflow detailed in Part V.

### 3.6 /docs/06_conventions: Establishing Enforceable Standards

This section documents all project conventions, from coding style to commit message formats, to ensure consistency across all contributions.

Template (coding_style.md):

A markdown document detailing the Elixir coding conventions, drawing inspiration from established guides.[^32] This will specify rules regarding naming, formatting, and best practices.

Automation:

These conventions will not be mere suggestions; they will be enforced automatically via pre-commit hooks.

- **Code Formatting:** The standard Elixir Formatter (`mix format`) will be integrated as a hook to ensure all committed Elixir code adheres to the defined style.
    
- **Commit Messages:** A hook like `commitizen` will be used to enforce a conventional commit message format, which is invaluable for automated changelog generation and semantic versioning.[^9]
    

### 3.7 /docs/07_agents: Defining AI Roles with Competency Frameworks

To effectively manage a team of specialized AI agents, their roles, responsibilities, and expected capabilities must be clearly defined. This is achieved by adapting an action-oriented competency framework.[^33][^34]

Template ([agent_name]_agent.md):

Each agent has a profile document that uses YAML front matter for quick identification and a structured body to detail its function.

---

## agent_id: "ai-tester-001" role: "Unit Test Generation" status: "active" version: "1.0"

# Agent Profile: Unit Test Generator

## Core Purpose

To automatically generate comprehensive and correct unit tests for Elixir modules based on their function specifications (`@spec`) and implementation details.

## Core Competencies

- **Code Analysis:** Must be able to parse Elixir source code, identify public functions, and interpret typespecs defined with `@spec`.
    
- **Test Case Generation:** Must be able to generate a variety of test cases, including happy path scenarios, edge cases (e.g., nil inputs, empty lists), and expected error conditions.
    
- **ExUnit Proficiency:** Must generate idiomatic test code that adheres to Elixir's ExUnit testing framework conventions, including the use of `assert`, `refute`, and proper test setup.
    

## Performance Indicators (Observable Behaviors)

- **Coverage Increase:** Commits from this agent must demonstrably increase code test coverage metrics.
    
- **Test Correctness:** All generated tests must pass in the continuous integration pipeline.
    
- **Idempotency:** Re-running the agent on an already-tested module should not produce duplicate or conflicting tests; it should only add tests for new, uncovered code paths.
    

### 3.8 /docs/08_roadmap: Strategic Planning with Tiered Roadmaps

The project roadmap provides a high-level, strategic view of the project's intended direction and priorities. A tiered structure, represented in Markdown using nested headings and lists, is effective for communicating this strategy.[^35]

Template (ROADMAP.md):

The roadmap is organized by time-based themes (e.g., quarters), which contain high-level epics, which in turn are broken down into concrete features.

# Project Roadmap

## Q3 2024: Foundational Cryptography

This theme focuses on establishing the core post-quantum cryptographic primitives.

### Epic: Post-Quantum Key Exchange

- **Feature:** Implement CRYSTALS-Kyber key encapsulation mechanism (KEM).
    
- **Feature:** Create a TUI interface for demonstrating a simple key exchange.
    

## Q4 2024: Application Core

This theme focuses on building the secure messaging layer on top of the crypto primitives.

### Epic: Secure Messaging Layer

- **Feature:** Build an OTP GenServer for managing secure user sessions.
    
- **Feature:** Integrate the crypto module for end-to-end message encryption and decryption.
    

The following table provides the detailed YAML Front Matter schemas for the key project management artifacts. This schema definition is the contract that enables reliable, automated parsing of the project state.

|**Document Type**|**Field Name**|**Data Type**|**Description**|**Example**|
|---|---|---|---|---|
|**`PROJECT.md`**|`project_name`|String|The official name of the project.|`"Elixir Quantum TUI Toolkit"`|
||`version`|String|The current semantic version of the project.|`"0.1.0-alpha"`|
||`status`|Enum (String)|The current lifecycle status of the project.|`"active"`|
||`repositories`|List[Object]|A list of all Git repositories associated with the project.|`[{name: "main", url: "...", role: "primary"}]`|
||`task_board_entry`|String (Path)|The relative path to the main project Kanban board.|`"./docs/02_operata/BOARD.md"`|
|**`BOARD.md`**|`board_id`|String|A unique identifier for the Kanban board.|`"main-board"`|
||`last_updated`|String (ISO 8601)|Timestamp of the last significant update to the board.|`"2024-09-15T14:30:00Z"`|
|**MADR**|`status`|Enum (String)|The status of the architectural decision.|`"accepted"`|
||`date`|String (YYYY-MM-DD)|The date the decision was last updated.|`"2024-09-15"`|
||`decision-makers`|List|A list of individuals or roles involved in the decision.|`["Human Lead", "AI Architect"]`|
|**Troubleshooting**|`error_code`|String|A unique identifier for the problem.|`"MIX_DEPS_FETCH_FAIL"`|
||`symptoms`|List|A list of observable symptoms for the problem.|`["mix deps.get fails"]`|
||`tags`|List|Keywords for searching and categorization.|`["dependencies", "git"]`|
|**Agent Profile**|`agent_id`|String|A unique identifier for the agent.|`"ai-tester-001"`|
||`role`|String|A concise description of the agent's primary function.|`"Unit Test Generation"`|
||`status`|Enum (String)|The operational status of the agent.|`"active"`|

## Part IV: Automation, Validation, and Tooling

This section details the specific scripts, tools, and configurations that transform the static markdown files into a dynamic, self-regulating system. This automation layer is the engine that drives the system's reliability and enables the "self-serve" nature required by AI agents.

### 4.1 The Pre-Commit Pipeline: Enforcing System Integrity

The `pre-commit` framework provides the first line of defense against inconsistency and entropy.[^8][^10] By running a series of automated checks before any change is committed, it ensures that the project's documentation and state remain valid at all times. The configuration is defined in the `.pre-commit-config.yaml` file at the project root.

Configuration (.pre-commit-config.yaml):

This configuration integrates a suite of community-maintained hooks for common file types, as well as local hooks for project-specific validation scripts.[^8][^9][^36]

YAML

```yaml
repos:
-   repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.6.0
    hooks:
    -   id: check-yaml
        args: ["--unsafe"] # Allow custom YAML tags if needed
    -   id: end-of-file-fixer
    -   id: trailing-whitespace
    -   id: check-merge-conflict
-   repo: https://github.com/DavidAnson/markdownlint-cli2
    rev: v0.13.0
    hooks:
    -   id: markdownlint-cli2
-   repo: https://github.com/tcort/markdown-link-check
    rev: v3.12.1
    hooks:
    -   id: markdown-link-check
        args: ['-c', './link-check-config.json']
-   repo: https://github.com/about-code/glossarify-md
    rev: v8.1.0
    hooks:
    -   id: glossarify-md
        args: ['--config', './glossarify-md.conf.json']
-   repo: local
    hooks:
    -   id: generate-toc
        name: "Generate Tables of Contents"
        entry: python scripts/generate_toc.py
        language: python
        types: [markdown]
        args: ["--in-place"]
    -   id: validate-operata
        name: "Validate Operata Board"
        entry: python scripts/validate_board.py
        language: python
        files: ^docs/02_operata/BOARD\.md$
```

|**Hook ID**|**Repository**|**Purpose**|**Key Configuration**|
|---|---|---|---|
|`check-yaml`|`pre-commit/pre-commit-hooks`|Verifies the syntax of all YAML files, including front matter.|Ensures metadata is always parsable.|
|`markdownlint-cli2`|`DavidAnson/markdownlint-cli2`|Enforces consistent styling and formatting across all Markdown files.|A `.markdownlint.jsonc` file will define specific rules.|
|`markdown-link-check`|`tcort/markdown-link-check`|Checks all Markdown files for broken internal and external hyperlinks.|A `link-check-config.json` will ignore certain URLs and set timeouts.|
|`glossarify-md`|`about-code/glossarify-md`|Automatically cross-links terms from `GLOSSARY.md` across all documents.|A `glossarify-md.conf.json` will define the glossary file location.|
|`generate-toc` (local)|`local`|A custom script to generate/update Tables of Contents in key documents.|Runs on all Markdown files, editing them in-place.|
|`validate-operata` (local)|`local`|A custom script to parse `BOARD.md` and validate its dependency graph.|Targets only the `BOARD.md` file.|

### 4.2 Scripting for Intelligence: Parsing, Validation, and Reporting

The custom scripts executed by the pre-commit pipeline provide the core intelligence of the system. They are responsible for parsing the text-based formats and transforming them into structured data that an AI can reason about. These scripts will be written in Python for its rich ecosystem of text-processing and data-manipulation libraries.

**Script Stubs (Python):**

- **`scripts/generate_toc.py`:** This script will parse the headers of specified markdown files and insert or update a "Table of Contents" section near the top. This ensures all major documents are easily navigable, mimicking the functionality of tools like `md-toc-cli`.[^37][^38] It will be designed to be idempotent, meaning it can be run multiple times without causing unwanted changes.
    
- **`scripts/validate_board.py`:** This is the core logic engine for the Operata board. It will:
    
    1. Use regular expressions and a Markdown parser to read `docs/02_operata/BOARD.md`.
        
    2. Extract each task, its ID, status (from the checkbox), and dependency information (from lines like `*Depends on: T-XXX*`).
        
    3. Build a directed graph representation of the project using a library like `networkx`.
        
    4. Perform validation checks on the graph, such as detecting cycles (`nx.is_directed_acyclic_graph`).
        
    5. If validation fails, it will print a descriptive error message and exit with a non-zero status code, causing the commit to fail.
        
    6. Optionally, it can generate a critical path report using topological sorting.
        
- **`scripts/parse_project.py`:** This master script is designed to be invoked directly by an AI agent. It acts as an orchestrator, calling the parsing logic for `PROJECT.md`, `BOARD.md`, and other key manifests. Its sole output will be a single JSON object printed to standard output. This JSON object represents the AI's comprehensive "world model," containing a fully resolved, cross-referenced view of the entire project state.
    

### 4.3 Managing Multi-Repo Complexity

The project's distributed nature across a primary Elixir umbrella application and two external private repositories requires a robust strategy for code and documentation aggregation.

Method 1: Git Submodules (Primary Recommendation):

The most direct and Git-native approach is to use git submodules.[^39][^40][^41] The external post_quantum_crypto and elixir_tui_lib repositories will be added as submodules to the main umbrella repository.

- **Tracking:** The `PROJECT.md` manifest will document the paths to these submodules. The `.gitmodules` file, created automatically by Git, will track the specific commit hash of each submodule, ensuring that all checkouts of the parent repository refer to the exact same version of the dependencies.
    
- **Workflow:** When cloning the main repository, developers (or AI agents) must use the `--recurse-submodules` flag. To update a dependency, one must navigate into the submodule directory, pull the latest changes, and then create a new commit in the parent repository to record the new submodule hash.
    

Method 2: Antora (Scalable Alternative):

For projects that anticipate growing to include many more repositories or require sophisticated versioning across documentation sets (e.g., maintaining docs for v1.0 and v2.0 of a library simultaneously), Antora is the superior long-term solution.[^42][^43][^44]

- **Mechanism:** Antora is a documentation site generator specifically designed to aggregate AsciiDoc (or Markdown, with plugins) content from multiple Git repositories. It uses a `playbook.yml` file to define content sources and their versions.
    
- **Compatibility:** The proposed documentation structure is highly compatible with Antora's component-based model. Each repository can be treated as an Antora component. While this system will be initialized with `git submodules` for simplicity, a future migration path to Antora should be documented as a potential architectural evolution.
    

### 4.4 Elixir-Specific Integration: Leveraging the ExDoc tool

To produce a professional, shareable HTML documentation site, the system will leverage **ExDoc tool**, Elixir's official documentation tool.[^45][^46] ExDoc is capable of generating documentation for umbrella projects and can be configured to include arbitrary Markdown files alongside the auto-generated code documentation.[^47][^48]

Configuration (mix.exs):

In the root mix.exs of the umbrella project, the :ex_doc dependency will be added, and the :docs configuration will be set up to include the key project management artifacts as "extras."

Elixir

```elixir
def project do
 ,
        "docs/03_architecture/README.md":,
        "docs/08_roadmap/ROADMAP.md":
    ]
end

def deps do
  [
    {:ex_doc, "~> 0.31", only: :dev, runtime: false}
    #... other deps
  ]
end
```

Workflow:

Running the standard mix docs command will now perform two functions:

1. It will parse the `@moduledoc` and `@doc` attributes from all Elixir source files across all child applications in the umbrella project.
    
2. It will render the specified Markdown files from the `/docs` directory into HTML pages.
    

The result is a single, cohesive, and hyperlinked documentation website. This site can be published to HexDocs or any static web host, serving as the canonical "read-only" view of the project for external stakeholders or for quick browsing. The Markdown source files within the Git repository remain the "writable" source of truth for the development team.

## Part V: The AI Agent's Workflow: A Self-Serve Protocol

This section synthesizes all preceding components into a concrete, step-by-step operational protocol for an AI agent. This master "praxis" codifies the "self-serve" capability, enabling an agent with zero prior context to autonomously orient itself, assess the project state, and determine a productive course of action.

### Step 1: Initial Orientation (The Bootstrap)

The agent's first actions upon accessing the repository are fixed and deterministic, designed to establish a foundational context.

1. **Read Entry Point:** The agent begins by reading the contents of the root `README.md` file.
    
2. **Parse Directive:** It locates and parses the machine-readable comment block: ``.
    
3. **Locate Manifest:** Following the directive, the agent identifies the path to the project manifest file, `./PROJECT.md`.
    

### Step 2: Building the World Model (State Ingestion)

With the manifest located, the agent proceeds to build a comprehensive internal representation of the project's state.

1. **Parse Manifest:** The agent first parses the YAML front matter of `PROJECT.md`. This provides high-level metadata, including the full list of associated repositories and the entry points for key artifacts like the task board and architecture documents.
    
2. **Execute Master Parser:** The agent invokes the master parsing script: `python scripts/parse_project.py`.
    
3. **Ingest State Object:** The agent captures the JSON object printed to standard output by the script. This JSON object is its "world model"—a complete, structured, and validated representation of the project, including all tasks, their states, their interdependencies, architectural components, and key decisions.
    

### Step 3: Task Identification and Analysis (Situational Awareness)

Using its newly constructed world model, the agent assesses the current state of work to identify opportunities for contribution.

1. **Filter by Role:** The agent queries its internal model for all `Operata` (tasks) that are assigned to its specific role (e.g., where `assignee` is `@ai-coder` or `@ai-tester`).
    
2. **Identify Actionable Tasks:** From the filtered list, it identifies tasks that are in an actionable state. An actionable task is one whose `status` is 'Todo' and for which all tasks listed in its `dependencies` array have a `status` of 'Done'.
    
3. **Analyze Critical Path:** If no immediately actionable tasks are found, the agent analyzes the project's dependency graph (which was computed by the validation script and is part of the world model). It identifies tasks on the critical path that are currently 'Blocked' or 'In Progress'. It then traces the dependencies of these critical tasks to identify the ultimate blockers.
    

### Step 4: Deep Context Acquisition (Knowledge Enrichment)

Before beginning work on a selected task (e.g., `T-103: Write unit tests for the KeyGen module`), the agent must gather deep context to ensure its contribution is correct and relevant.

1. **Locate Artifacts:** The agent uses its world model to identify the source code files, documentation, and architectural records relevant to the task. For `T-103`, this would include the `KeyGen` Elixir module itself and any related architecture documents.
    
2. **Resolve Terminology:** While reading the relevant documents, if the agent encounters any domain-specific terms (e.g., "Key Encapsulation Mechanism"), it utilizes the auto-generated hyperlinks (created by `glossarify-md`) to navigate to the `GLOSSARY.md` file and retrieve the precise definition.
    
3. **Understand Architecture and Rationale:** The agent reviews the relevant `arc42` sections, C4 diagrams, and MADRs to understand the component's place in the system and the reasoning behind its design. This prevents it from making changes that violate established architectural principles.
    
4. **Review Conventions:** Finally, the agent reads the `coding_style.md` and other convention documents to ensure its output will be fully compliant with project standards.
    

### Step 5: Proposing Action (The Suggestion)

Based on its comprehensive analysis, the agent formulates a clear, actionable proposal to be communicated to the human lead. This proposal demonstrates its understanding of the project state and its intended course of action.

- **Scenario 1 (Actionable Task):** "I have identified task `T-103` ('Write unit tests for the KeyGen module') as actionable and assigned to my role. Its dependency, `T-102`, is complete. I will now begin work on generating the ExUnit tests for the `KeyGen` module."
    
- **Scenario 2 (Blocked Critical Path):** "Task `T-105` ('Integrate TUI library') is on the critical path but is blocked by `T-101`, which is assigned to `@human`. The reason for the block is 'Awaiting final design approval'. Can you provide an update on the TUI layout design to unblock this task?"
    
- **Scenario 3 (Inconsistency Detection):** "I have detected an inconsistency in the project state. Task `T-105` depends on `T-101`, but `T-101` is marked as 'Done' while `T-105` remains 'Blocked'. The dependency is met. I recommend updating the status of `T-105` to 'Todo'."
    

### Step 6: Execution and Contribution (The Work)

Once a course of action is approved or self-initiated, the agent executes the work according to standard development practices.

1. **Perform Task:** The agent performs the required work (e.g., writing code, updating documentation).
    
2. **Create Branch:** It creates a new Git branch for its changes, following a defined naming convention (e.g., `feature/T-103-keygen-tests`).
    
3. **Commit Changes:** The agent commits its changes with a conventional commit message. The `pre-commit` hooks run automatically, validating the changes. If any hook fails, the agent must analyze the error and correct its work before attempting to commit again.
    
4. **Open Pull Request:** After successfully committing, the agent pushes the branch to the remote repository and opens a pull request, providing a summary of the work completed and linking it back to the original task ID (`T-103`).
    

## Conclusions and Recommendations

The proposed system design provides a comprehensive, robust, and extensible framework for managing a complex software project with a hybrid team of human and ephemeral AI agents. By adhering to a set of core foundational principles—README-first development, metadata-as-an-API, and the living document principle—the system creates a self-navigating repository that is both human-readable and machine-parsable.

The key to the system's success lies in its rigorous separation of concerns between structured, machine-readable state (YAML Front Matter) and unstructured, human-readable context (Markdown body). This dual-layer approach, combined with a deterministic directory structure and a powerful automation pipeline driven by `pre-commit` hooks, transforms the project repository from a passive code store into an active, self-validating knowledge base. This integrity is the essential prerequisite for enabling AI agents to operate autonomously and reliably.

The adoption of text-based, script-friendly formats for all project management artifacts (e.g., `TODO.md` for Kanban, Mermaid for diagrams) is a strategic choice that prioritizes accessibility and automation over proprietary or visually complex tools. This aligns with the core requirement of creating a system that can be easily manipulated and understood by scripts and AI agents.

**Actionable Recommendations for Implementation:**

1. **Establish the Core Structure First:** Begin by creating the foundational directory structure (`/docs` with numbered subdirectories) and the primary manifest files (`README.md`, `PROJECT.md`). Populate these with initial content.
    
2. **Incrementally Implement Automation:** Set up the `.pre-commit-config.yaml` file early in the process. Start with basic hooks like `check-yaml` and `markdownlint`, and then incrementally add the more complex custom scripts for TOC generation and board validation. This allows the system's integrity engine to grow with the project.
    
3. **Develop the Master Parsing Script:** The `scripts/parse_project.py` script is the most critical piece of custom tooling for the AI agent. Its development should be prioritized, as it is the gateway for the AI to build its world model.
    
4. **Codify Praxes and Agent Profiles:** As soon as the first AI agents are brought into the project, their roles should be formally documented using the competency framework template. The `on-boarding_praxis.md` should be treated as a primary piece of documentation and refined based on early agent experiences.
    
5. **Integrate with Elixir Tooling:** Configure the ExDoc tool to generate the unified HTML documentation site. This should be integrated into the CI/CD pipeline to ensure that a published, human-friendly version of the project's status and documentation is always available.
    

By implementing this system, a project can achieve a state of "Project Management as Code," where the entire lifecycle of work is versioned, validated, and auditable. This provides the high degree of discoverability, obviousness, and reliability necessary to effectively manage a high-turnover team of AI agents and empower them to become truly productive, self-sufficient partners in the development process.

---

[^1]: https://www.codecademy.com/article/markdown-and-readmemd-files, Accessed October 19, 2025. "A README.md file is a plain text file explaining a project's what, why, and how. It's usually the first thing people see when they open a repository on GitHub, GitLab, or Bitbucket."

[^2]: https://www.mindbowser.com/readme-first-developer-documentation-guide/, Accessed October 19, 2025. "The README file is often the first thing a developer sees when they encounter a new project. It sets the tone for the entire project and can influence whether a developer decides to use or contribute to the project."

[^3]: (https://medium.com/@NSomar/readme-md-history-and-components-a365aff07f10), Accessed October 19, 2025. "There is no doubt that the README file is a very important file. It is so important that Tom Preston-Werner, github co-founder and former president, suggested a development flow driven by the README file. Write your Readme first."

[^4]: https://stackoverflow.com/questions/605434/how-would-you-go-about-parsing-markdown, Accessed October 19, 2025. "If you think about Markdown, it's fundamentally based around the concept of paragraphs. As such, a reasonable approach might be to split the input into paragraphs."

[^5]: https://docs.zettlr.com/en/core/yaml-frontmatter/, Accessed October 19, 2025. "Like Pandoc, Zettlr supports YAML frontmatters for your Markdown files. A YAML frontmatter is a series of meta variables that can be defined to describe information of the file that normally is not part of the text contents themselves, such as authors, keywords, and the title."

[^6]: (https://assemble.io/docs/YAML-front-matter.html), Accessed October 19, 2025. "YFM is an optional section of valid YAML that is placed at the top of a page and is used for maintaining metadata for the page and its contents."

[^7]: https://docs.zettlr.com/en/core/yaml-frontmatter/, Accessed October 19, 2025. "A YAML frontmatter must be defined at the beginning of a file... The frontmatter must start on the very first line of the document with three dashes (---) and end with three dashes (---) or three dots (...) on a single line."

[^8]: https://pre-commit.com/, Accessed October 19, 2025. "You specify a list of hooks you want and pre-commit manages the installation and execution of any hook written in any language before every commit."

[^9]: https://gatlenculp.medium.com/effortless-code-quality-the-ultimate-pre-commit-hooks-guide-for-2025-57ca501d9835, Accessed October 19, 2025. "Git hooks are scripts that run automatically at some stage in the git-lifecycle. Most commonly, pre-commit hooks are used, running before a commit goes through. They act as a first line of defense for code quality..."

[^10]: https://opencomputinglab.github.io/educational-jupyter-notebook-qa-automation/pre-commit-framework.html, Accessed October 19, 2025. "Pre-commit workflows are established by running a pre-commit install command to configure the. git/hooks/pre-commit file. The pre-commit tasks themselves are defined via a. pre-commit-config. yaml configuration file."

[^11]: https://dev.to/florianlenz/arc42-for-your-software-architecture-the-best-choice-for-sustainable-documentation-383p, Accessed October 19, 2025. "arc42 is a comprehensive and field-tested template that has been specially developed for the documentation of software architectures. It offers a structured and modular approach to documenting all relevant aspects of a software architecture efficiently and comprehensibly."

[^12]: https://medium.com/@parserdigital/architecture-documentation-with-arc42-77662678aad8, Accessed October 19, 2025. "Arc42 is a template for architecture communication and documentation, technology agnostic. It is divided into 12 sections, each one addressing a different software aspect."

[^13]: https://github.com/about-code/glossarify-md, Accessed October 19, 2025. "The glossarify-md tool is a command line tool designed to assist Markdown writers primarily with Cross-Linking: auto-linking terms to some definition in a glossary."

[^14]: https://www.rst.software/blog/introduction-to-domain-driven-design-ddd-glossary, Accessed October 19, 2025. "At its core, DDD is centered around a profound philosophy: it seeks to grasp and meticulously model the problem domain, which essentially refers to the specific realm of knowledge or business activities for which the software is being developed."