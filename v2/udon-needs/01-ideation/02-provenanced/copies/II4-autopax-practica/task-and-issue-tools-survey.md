---
source: task-and-issue-tools-survey.md (autopax/practica ideology corpus, Part II sec 4)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/practica/ref/task-and-issue-tools-survey.md
source_commit: 938fb79ed9bd58b34374eb1122d86bb95fd817e8
categories: [landscape-scan, cli-task-tools, mcp-servers, agentic-orchestration]
why_included: >
  2026. Survey of CLI-native task tools (Taskwarrior, ...) + MCP-first servers for agents + agentic-orchestration best-practices, framed around the CLI-tool/AI-agent bifurcation over 2024-2026. A ready-made landscape scan of the exact tooling category this compilation is about -- useful prior-art context for the harness programme.
---

# Task & Issue Management CLI Tools, MCP Servers, and Agentic Best Practices for High-Velocity Development

## Executive Summary

The landscape of developer-facing task and issue management tooling has bifurcated sharply over 2024–2026 into two converging tracks: *CLI-native tools* designed for terminal-first humans, and *MCP-first servers* designed for AI agents to manipulate work items programmatically. A third emergent layer — agentic orchestration practices from both industry and academic literature — governs how these tools are composed into high-velocity autonomous pipelines. For teams running macOS and Linux with an emphasis on open-source and self-hosted deployments, the available options are richer than ever and the ergonomic gaps have largely closed.

***

## Part I: CLI Task & Issue Management Tools

### 1. Taskwarrior

**Best in class: Local, terminal-native, offline, scripting-first personal task management.**

Taskwarrior is the canonical open-source CLI task manager, maintained by the Gothenburg Bit Factory under the MIT license. It stores data as SQLite databases (as of v3) and exports to JSON, giving you complete portability — your data is never held captive. The fundamental model is a list processor: tasks have rich metadata including priorities, due dates, projects, sub-projects, tags, dependencies, urgency scores, and custom user-defined attributes (UDAs).[^1][^2][^3][^4]

**Key features:**
- Expressively filtered queries and custom reports via a declarative filter syntax (`task project:foo and due:today`)
- Recurrence rules, urgency scoring (weighted formula combining priority, due, age, tags)
- Hook scripts (Python/shell) that fire on task add, modify, or sync — enabling powerful automation without requiring a new process model
- TaskServer (`taskd`) or Taskchampion sync backend for multi-device/multi-agent sync
- VIT: a curses-based TUI layer built on Taskwarrior for those who want visual navigation
- `task export` / `task import` for JSON round-trips, enabling easy scripting

**Storage:** Local SQLite + JSON. No cloud requirement. Fully air-gapped.[^3]

**macOS/Linux install:** `brew install task` (macOS), `apt install taskwarrior` (Ubuntu), available on all major distros.

**Best for:** Personal backlog management, offline/air-gapped environments, power scripting, hooking into CI pipelines via shell.

***

### 2. BugWarrior

**Best in class: Bidirectional sync between local Taskwarrior and remote issue trackers.**

BugWarrior is the missing bridge layer for Taskwarrior, pulling issues from remote forges into your local task list. It supports an extraordinary range of backends: GitHub, GitLab, Jira, Bitbucket, Bugzilla, Linear, Azure DevOps, Gerrit, Redmine, Trac, Trello, Phabricator, YouTrack, Kanboard, ClickUp, Nextcloud Deck, Logseq, and more. This makes it uniquely powerful as an aggregation layer: you can pull tickets from every system your team uses into a single local Taskwarrior database, prioritize them uniformly, and work offline.[^5][^6]

**Key features:**
- Configurable via an INI-style config file specifying which remotes to pull from and how to tag/annotate imported tasks
- Respects existing Taskwarrior UDAs to store remote IDs, URLs, and status
- One-command sync: `bugwarrior-pull`
- GPL-3.0 license, Python-based, pip-installable

**Storage:** Inherits Taskwarrior's local SQLite + JSON.[^5]

**Best for:** Developers who use Taskwarrior but also need to stay in sync with team-level issue trackers without leaving the terminal.

***

### 3. todo.txt CLI

**Best in class: Maximum portability, zero lock-in, infinite longevity.**

The todo.txt format, created by Gina Trapani in 2006, codifies a single plain-text file format for tasks — one task per line, with optional priority markers, creation/completion dates, +project tags, and @context tags. The official `todo.sh` is a POSIX shell script requiring no runtime. The format is documented as an open specification on GitHub.[^7][^8][^9]

**Key features:**
- Truly future-proof: any text editor or `grep` is sufficient to read/modify
- Sync via any file sync tool (rsync, Syncthing, Dropbox, git)
- Extensible via add-on scripts (dozens of community add-ons for time tracking, due dates, review flows, etc.)
- Tab completion for priorities and contexts in bash/zsh
- `todo.sh archive` moves completed tasks to `done.txt`

**Storage:** Flat text file. No database, no binary formats, no migrations.[^8][^9]

**Best for:** Maximum simplicity, teams that want tasks version-controlled in the same git repo as code, or as a lightweight portable layer on top of any sync substrate.

***

### 4. git-bug

**Best in class: Distributed, embedded bug tracking with zero external dependencies.**

`git-bug` embeds a full issue tracker as git objects inside a repository — bugs are stored in git's object store, *not* as files in the working tree, so they do not pollute commits or diffs. This makes the issue tracker fully distributed: you push and pull bugs with the same `git push` / `git pull` commands you already use, and you can create, read, and comment on issues completely offline.[^10][^11][^12]

**Key features:**
- CLI, TUI (interactive terminal), and web UI interfaces
- Bidirectional bridges to GitHub Issues, GitLab Issues, and Jira — enabling use as an offline-capable local proxy for remote trackers[^13]
- GraphQL API for programmatic access
- Native git storage means zero vendor lock-in and automatic backup via existing git remotes
- Issues, comments, labels, and status — a full issue lifecycle without any server

**Storage:** Git object store (entirely within the `.git` directory). No external DB.[^11][^12]

**macOS install:** `brew install git-bug`. Linux: pre-compiled binaries or distro packages.[^11]

**Best for:** Distributed teams, offline-first workflows, teams that want issue history and code history in the same immutable object store, and scenarios where GitHub/GitLab may be unavailable.

***

### 5. GitHub CLI (`gh`)

**Best in class: Full GitHub issue/PR lifecycle from the terminal, official and free.**

The official GitHub CLI is open-source (MIT) and brings the full GitHub issue and PR workflow to the terminal. It supports creating, editing, listing, filtering, assigning, labeling, and transitioning issues. The `gh search issues` command supports GitHub's full search syntax. It integrates with GitHub Projects via `--add-project` flags.[^14][^15][^16]

**Key features:**
- `gh issue list`, `gh issue create`, `gh issue edit`, `gh issue close`, `gh issue comment`
- `gh pr create`, `gh pr checks`, `gh pr merge` — full PR lifecycle
- `gh search issues --search "<query>"` using GitHub's search API syntax[^14]
- Extensible via `gh extension` — community extensions like `gh-dash` add a terminal dashboard
- Scripting-friendly: JSON output via `--json` flag and `--jq` for inline processing
- `gh alias set` for custom command shortcuts
- Works with GitHub Enterprise Server

**Storage:** Remote (GitHub API). No local storage of issues.[^15]

**macOS/Linux install:** `brew install gh`.

**Best for:** Teams already on GitHub, CI/CD automation scripts, agents that interact with GitHub Issues and PRs as their coordination layer.

***

### 6. Gitea `tea` CLI

**Best in class: Self-hosted GitHub-like issue management, fully under your control.**

`tea` is the official CLI for Gitea, the lightweight self-hosted git forge. Gitea supports issues, labels, milestones, projects, and pull requests with an API surface similar to GitHub. `tea` provides terminal access to all of these, plus repository management, releases, and user management.[^17][^18]

**Key features:**
- `tea issue list --state all`, `tea issue create`, `tea pr`, `tea pr merge`
- Multiple login profiles for multiple Gitea instances
- Supports Forgejo (Gitea's community fork) as well
- JSON output options for scripting
- `tea repo info`, `tea release list`

**Storage:** Remote (Gitea server API). Self-hostable: SQLite, PostgreSQL, or MySQL.[^18][^17]

**macOS/Linux install:** `brew install tea`.

**Best for:** Teams that self-host their git infrastructure (common in regulated industries, air-gapped environments, or teams avoiding GitHub/GitLab vendor lock-in).

***

### 7. `gcli` (Multi-Forge CLI)

**Best in class: Single CLI for GitHub, GitLab, Gitea/Forgejo, and Bugzilla.**

`gcli` is a portable CLI written in C that provides a unified interface for GitHub, GitLab, Gitea, Forgejo, and Bugzilla from a single binary. The official GitHub CLI only supports GitHub; `gcli` fills the gap for polyglot forge environments.[^19]

**Key features:**
- Unified commands across all supported forge backends
- Issue CRUD, PR management, comment operations
- Small binary with minimal dependencies (written in C)
- Active development with regular releases

**Best for:** Teams using multiple forges simultaneously, or those on Bugzilla/self-hosted systems not covered by `gh`.

***

### 8. Atlassian ACLI (Jira CLI)

**Best in class: Native Jira Cloud terminal automation, officially supported.**

Atlassian released the official ACLI (Atlassian Command Line Interface) for all Jira Cloud plans in May 2025. This is separate from the community Appfire CLI (also called ACLI, formerly Bob Swift's tool). The official Atlassian ACLI provides atomic, JSON-output commands for Jira work items, projects, users, dashboards, and filters from the terminal.[^20][^21]

**Key features:**
- Create, clone, update, archive, delete work items
- Search with JQL (Jira Query Language)
- Bulk operations and parallel execution
- JSON output for scripting and pipeline integration
- Authentication/user management across multiple Jira sites
- Engineered with performance optimization and error handling built in[^21]

The Appfire/Bobswift ACLI (marketplace product) adds broader Atlassian ecosystem coverage including Confluence, Bamboo, and Bitbucket, plus CSV/database run actions.[^22]

**Storage:** Remote (Jira Cloud API). No self-hosted option for official ACLI.

**Best for:** Enterprise teams on Jira Cloud who need scripted automation and bulk operations without writing API code.

***

### 9. Linear CLI Tools

Linear's issue tracker has attracted several community CLI implementations. Two stand out:

**`linear-cli` (joa23/linear-cli):** Written in Go, installable via Homebrew (`brew tap joa23/linear-cli && brew install linear-cli`). It is explicitly designed for agentic/AI coding workflows: agents read and update Linear issues as they work, maintaining shared state across the team. Outputs JSON for machine parsing. Supports teams, projects, cycles, labels, assignees, and comments.[^23]

**`linear-cli` (anoncam):** TypeScript/Node.js implementation with cross-team reporting, AI-assisted label management, and GraphQL API integration. The LobeHub skill description for this tool emphasizes that "all output is JSON for reliable parsing by agents and scripts".[^24][^25]

**Storage:** Remote (Linear API). Linear stores data in its own cloud backend.

**Best for:** High-velocity product teams that use Linear as their source of truth and need programmatic access for agents or automation scripts.

***

### 10. Plane (`prime-cli`)

**Best in class: Open-source, self-hosted, full-featured project management with native MCP and AI agent support.**

Plane is an open-source (Apache 2.0) project management platform that has grown to over 100,000 users and 30,000+ GitHub stars. It is directly Jira-compatible in feature scope but self-hostable via Docker or Kubernetes. The `prime-cli` is a Go-based terminal tool for managing self-hosted Plane instances (install, configure, upgrade, backup, monitor, scale).[^26][^27][^28]

**Key features:**
- Projects, Epics, Issues, Cycles (sprints), Modules, Initiatives
- Board, Spreadsheet, List, and Gantt views
- Native MCP server (open-source, on GitHub)[^29][^30]
- REST API with OAuth 2.0, HMAC-signed webhooks, typed Node.js and Python SDKs
- "Plane Compose for Projects-as-Code": define projects in YAML, version in git, deploy from terminal[^26]
- AI agent framework with @mention support and full Agent Run lifecycle tracking[^26]
- SOC 2, ISO 27001, GDPR, CCPA compliance; SSO, SAML, LDAP[^26]
- Air-gapped deployment option

**Storage:** Self-hosted: PostgreSQL (primary), Redis (cache), S3-compatible (attachments).[^31]

**macOS/Linux install:** Docker Compose or Kubernetes/Helm.[^31]

**Best for:** Teams that want a Jira-equivalent feature set without vendor lock-in, combined with first-class AI agent and MCP integration in a self-hostable package.

***

## Part II: MCP Servers for Task & Issue Management

The Model Context Protocol (MCP), introduced by Anthropic in late 2024, standardizes how AI agents connect to external tools and data sources through a JSON-RPC 2.0 client-server architecture. By May 2026, the MCP ecosystem has grown to over 4,000 registered servers. The following are the most important MCP servers for task and issue management in developer workflows.[^32][^33][^34]

### 1. GitHub MCP Server (Official)

**Best in class: GitHub workflow automation for AI agents — the most widely deployed issue-management MCP.**

GitHub rewrote the reference Anthropic MCP server in Go with Anthropic's collaboration and released it as open-source in public preview in April 2025. It has since become the most widely used project management MCP server and is natively supported in VS Code, Claude Code, Cursor, Windsurf, and other editors.[^35][^36]

**Toolsets available (as of October 2025 update):**[^37]
- **Default toolsets:** `context`, `repos`, `issues`, `pull_requests`, `users`
- **Optional toolsets:** `projects` (GitHub Projects management), `labels`, `code_scanning`, `security_alerts`, `discussions`, `notifications`, `actions`

**Issue management tools:**
- `issue_read` (get details, sub-issues, comments, labels)
- `list_issues` (filter by state, labels, date)
- `search_issues` (GitHub search syntax)
- `projects_list`, `projects_get`, `projects_write` (project automation)
- Write operations (create, update, comment, close) use `gh api` REST calls[^38]

**Token efficiency:** Compact format option provides 80-97% smaller responses for list/status operations.[^39]

**Storage:** Remote (GitHub API). Authentication via fine-grained PAT or GitHub App.[^40][^37]

**Install for Claude Code:** `claude mcp add github -- docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN ghcr.io/github/github-mcp-server`

***

### 2. Task Master AI (claude-task-master)

**Best in class: AI-native PRD-to-task decomposition with dependency tracking and multi-model support.**

Task Master (25,300+ GitHub stars, 2,400+ forks as of early 2026) is the leading open-source MCP server specifically designed for AI-driven development workflows. It transforms a Product Requirements Document (PRD) into a structured task graph with dependencies, priorities, complexity scores, and implementation guidance — then serves those tasks to AI agents one at a time in dependency order.[^41]

**Key features:**
- `parse-prd`: Parse a PRD document into structured tasks with IDs, titles, descriptions, dependencies, priorities, and test strategies[^42]
- `analyze-complexity`: AI-scores each task 1-10 and recommends subtask count[^42]
- `next`: Returns the next unblocked, highest-priority task
- `expand_task`: Breaks a task into detailed subtasks using AI
- `research`: Perplexity-powered fresh research with project context
- Multi-model support: Claude, GPT, Gemini, Mistral, xAI, OpenRouter, Ollama; configurable main/research/fallback model[^43]
- Selective tool loading to control context window usage: `core` (7 tools, ~5k tokens), `standard` (15 tools, ~10k tokens), `all` (36 tools, ~21k tokens)[^41]
- Task tags for cross-tag movement (backlog → in-progress → done)

**Storage:** Local JSON files in `.taskmaster/` directory. Git-friendly; committable alongside code.[^42]

**License:** MIT with Commons Clause (use freely, cannot resell as a service).[^41]

**Install:** `npx task-master init` or `claude mcp add taskmaster-ai -- npx -y task-master-ai`.[^41]

**Best for:** Spec-driven agentic development workflows where an LLM coding agent (Claude Code, Cursor, Windsurf, Roo) needs a structured task queue to work through a PRD systematically.

***

### 3. Agentic Control Framework (ACF)

**Best in class: All-in-one agentic orchestration platform with 83+ tools spanning tasks, filesystem, terminal, and browser.**

ACF is a free, open-source (MIT) framework that goes far beyond issue management: it provides a complete autonomous agent toolkit including filesystem operations, terminal execution, browser automation (via Playwright), AppleScript integration (macOS), and a sophisticated numerical priority system (1-1000 scale).[^44][^45][^46]

**Core task management tools (33 tools):**
- `listTasks`, `addTask`, `addSubtask`, `updateStatus`, `getNextTask`
- `parsePrd`: Parse PRD files to auto-generate tasks
- `expandTask`: AI-powered task breakdown with dependency analysis
- `reviseTasks`: AI-powered replanning when requirements change
- `recalculatePriorities`: Intelligent priority recalculation with critical path analysis, time decay, and dependency boosts
- `getDependencyAnalysis`: Critical path detection, blocking task identification

**Priority system:** A fine-grained 1-1000 numerical scale (vs. traditional High/Medium/Low), with automatic uniqueness enforcement, dependency-based boosts, and distribution optimization preventing priority clustering.[^44]

**Additional tool categories:**
- 13 filesystem tools (read, write, copy, move, search, tree)
- 6 terminal tools (execute_command, process management)
- 25 browser automation tools (Playwright: navigate, click, type, screenshot, PDF)
- 1 AppleScript integration tool (macOS)
- `search_code` with ripgrep, `edit_block` for surgical edits

**Storage:** Local JSON task database (`tasks.json`) + markdown files. Optional cloud deployment to GCP, Railway, or Fly.io via mcp-proxy.[^47][^44]

**Modes:** CLI (direct commands), Local MCP (IDE integration), Cloud MCP (HTTP/SSE via mcp-proxy).[^44]

**Best for:** Developers who want a single unified MCP server that handles both task orchestration and all the agent's operational needs (file editing, terminal, browser testing) in one framework.

***

### 4. Plane MCP Server

**Best in class: Self-hosted project management with native MCP for AI agents in regulated environments.**

Plane provides an official open-source MCP server (GitHub: makeplane/plane-mcp-server) supporting multiple transport methods: HTTP with OAuth (cloud), HTTP with PAT (CI/CD), local Stdio (self-hosted), and SSE (legacy).[^30][^29]

**Capabilities:**
- Create and manage projects, issues (work items), labels, modules, cycles
- Update issue states, assignees, and properties
- Add comments and track progress programmatically
- Analyze team work data across projects
- Full CRUD on the complete Plane data model

**Storage:** Self-hosted PostgreSQL + Redis + S3, or Plane Cloud.[^29][^30]

**Best for:** Teams that self-host Plane and want AI agents to read/write project management data directly, especially in regulated or air-gapped environments.

***

### 5. Linear MCP Server

Linear has an official MCP server that enables AI agents to manage Linear issues, projects, teams, cycles, and priorities through the Linear API. It is listed in the Cursor official MCP registry alongside GitHub and GitLab.[^48][^35]

**Capabilities:**
- Full issue lifecycle (create, update, assign, transition status)
- Team, project, and cycle management
- Label and user management
- Cross-team reporting and search

**Best for:** Product teams on Linear who want Claude Code, Cursor, or other agents to read/write issues as part of their development loop.

***

### 6. Atlassian MCP Server

The Cursor official MCP registry includes an Atlassian MCP server covering both Jira and Confluence. MCP Jetpack also includes Atlassian as one of its 17 supported services.[^49][^35]

**Capabilities:**
- Access and manage Jira data through MCP (issues, projects, sprints, users)
- Search with JQL
- Comment, transition, and update work items

**Best for:** Enterprise teams on Jira Cloud who want AI agents to interact with their backlog.

***

### 7. SystemPrompt MCP TaskChecker

An enterprise-grade MCP server specifically for task evaluation and session-based workflow tracking — designed to add structured evaluation metrics, real-time progress monitoring, and session context to AI assistant workflows. Published on npm as `@systemprompt/mcp-taskchecker`.[^50][^51]

**Key distinction:** Focus on *evaluation scoring* and *quality gates* on top of task execution, rather than just task CRUD. Useful when you need agents to self-assess completion quality.

***

### 8. GitHub Project Manager MCP (kunwarVivek)

A community MCP server (GitHub: kunwarVivek/mcp-github-project-manager) providing 40+ GitHub project management tools plus 8 AI task management tools including PRD-to-issue generation, requirements traceability, and IEEE 830–compliant requirements documentation.[^52]

**Key features:**
- AI-powered PRD → project breakdown via GitHub's GraphQL API
- End-to-end requirements traceability: business requirements → features → use cases → tasks
- AI complexity analysis and effort estimation
- Complete CRUD on projects, milestones, issues, sprints, labels

**Best for:** Teams that use GitHub Projects as their PM layer and want PRD-to-issue automation with full traceability.

***

## Part III: Feature & Storage Comparison Matrix

| Tool | Type | License | Storage | macOS/Linux | Best Strength |
|------|------|---------|---------|-------------|---------------|
| **Taskwarrior** | CLI | MIT | Local SQLite/JSON | ✅ Homebrew/APT | Offline, scripting, urgency scoring |
| **BugWarrior** | CLI sync | GPL-3 | Inherits Taskwarrior | ✅ pip | Multi-tracker aggregation |
| **todo.txt CLI** | CLI | GPL-3 | Flat text file | ✅ Everywhere | Zero dependencies, infinite longevity |
| **git-bug** | CLI/TUI/Web | Apache 2 | Git objects | ✅ Homebrew | Distributed, offline, embedded in git |
| **gh (GitHub CLI)** | CLI | MIT | Remote (GitHub) | ✅ Homebrew | GitHub-native, extensible |
| **tea (Gitea CLI)** | CLI | MIT | Remote (Gitea, self-hosted) | ✅ Homebrew | Self-hosted git forge |
| **gcli** | CLI | BSD | Remote (multi-forge) | ✅ Binary | GitHub+GitLab+Gitea+Bugzilla unified |
| **Atlassian ACLI** | CLI | Proprietary | Remote (Jira Cloud) | ✅ Installer | Jira bulk ops, JQL scripting |
| **Linear CLI** | CLI | MIT | Remote (Linear) | ✅ Homebrew/npm | Linear + agentic JSON output |
| **Plane** | Self-hosted PM | Apache 2 | PostgreSQL+Redis+S3 | ✅ Docker/K8s | Full Jira-equivalent, self-hosted MCP |
| **GitHub MCP Server** | MCP | MIT | Remote (GitHub) | ✅ Docker/npx | AI GitHub automation, most widely used |
| **Task Master AI** | MCP+CLI | MIT+CC | Local JSON | ✅ npx | PRD→task decomposition, multi-model |
| **ACF** | MCP+CLI | MIT | Local JSON | ✅ npm | All-in-one: tasks + FS + terminal + browser |
| **Plane MCP** | MCP | Apache 2 | Self-hosted PostgreSQL | ✅ npx | Self-hosted AI project management |
| **Linear MCP** | MCP | Proprietary | Remote (Linear) | ✅ npx | Linear issue management for agents |
| **Atlassian MCP** | MCP | Proprietary | Remote (Jira Cloud) | ✅ npx | Jira for AI agents |

***

## Part IV: Agentic Best Practices

### Academic Foundations

Research on agentic task management has coalesced around several empirically validated principles.

**Task decomposition and dependency graphs.** Work from NeurIPS 2024 demonstrates that asynchronous, dynamic task graph decomposition significantly improves system responsiveness and scalability compared to monolithic prompt architectures. Structural Similarity Index (SSI) is the strongest predictor of performance in sequential tasks; Tool F1 Score dominates in parallel tasks. The AutoScrum paper (2023) formalizes an LLM-driven workflow of requirements gathering → user story mapping → feature identification → task decomposition → domain-specific information retrieval.[^53][^54]

**Multi-agent specialization and file ownership.** Research and practitioner consensus (2025–2026) align on a key insight: *file-based jurisdictions outperform domain-based jurisdictions* for multi-agent systems. When multiple agents compete for write access to the same files, coordination failures are most common; assigning file ownership per agent (rather than per capability domain) resolves the majority of conflicts. Focused subagents with narrow scopes outperform "bloated all-purpose ones" in both context preservation and behavioral predictability.[^55][^56]

**Staged workflows.** Anthropic's own best-practices documentation (and derivative practitioner guides) converge on a four-phase model: Explore → Plan → Implement → Verify. Collapsing these phases into a single prompt systematically degrades output quality. Claude Code's Plan Mode (`Shift+Tab`) enforces the plan/implement split at the UX level.[^57][^55]

**Context-Aware MCP (CA-MCP).** Academic work (arXiv, Jan 2026) proposes offloading execution logic to specialized MCP servers that read/write a Shared Context Store, enabling autonomous coordination without repeated prompting. This reduces LLM calls for complex tasks and decreases response failures — a meaningful finding for multi-step agentic workflows.[^58]

**Spec-Driven Development (SDD).** Emerging as the dominant practitioner pattern for AI-assisted development, SDD establishes specifications (not conversations) as the primary artifact of development. The workflow: write a `CLAUDE.md` project constitution → write a spec document → have agents implement the spec → verify against acceptance criteria. The spec file becomes the single source of truth; if requirements change, the spec changes, not the chat history.[^59][^60][^61]

***

### CLAUDE.md as Project Constitution

The `CLAUDE.md` file (or equivalent `AGENTS.md` for other agent frameworks) serves as persistent, always-loaded context for an agent's entire engagement with a codebase. Best-practice structure includes:[^62]

- Project purpose and architecture constraints
- Technology stack and coding conventions
- File jurisdiction map (which agent/human owns which directories)
- Task management system in use (e.g., "check `.taskmaster/tasks.json` for current tasks")
- Explicit out-of-scope guardrails
- Testing and verification requirements[^60][^59]

Critically: `CLAUDE.md` files cascade (project-level overrides user-level), enabling per-project specialization while maintaining global defaults.[^55]

***

### MCP Scope and Tool Management

MCP tools consume context window tokens. The GitHub MCP server alone adds 74 tools in its default configuration, and Cursor warns of performance degradation beyond 50 tools. Best practices for managing tool proliferation:[^49]

1. **Use selective toolsets.** Task Master supports `core`/`standard`/`all`/`custom` loading modes, cutting context consumption by up to 76%. The GitHub MCP server introduced a reduced default configuration in Oct 2025.[^37][^41]

2. **Scope MCP deliberately.** Claude Code supports three MCP scopes: `local` (one project or sensitive configs), `project` (team-shared via `.mcp.json` in the repo), `user` (personal utilities across repos). This prevents "giant uncontrolled tool list" scenarios.[^55]

3. **MCP Jetpack pattern.** Tools like MCP Jetpack consolidate 17 services (GitHub, Atlassian, Linear, Notion, Sentry, etc.) behind two meta-tools (`FindTool` and `ExecTool`), respecting the 50-tool limit while providing broad service coverage.[^49]

4. **Hierarchical lazy loading.** A proposal in the MCP spec community (Aug 2025) calls for category-based discovery and lazy loading of tool schemas — load only when needed for the current task. Tools like ACF already partially implement this via mode selection.[^63]

***

### Multi-Agent Coordination Patterns

The MAGIS framework (2024) demonstrated that multi-agent GitHub issue resolution — splitting work across Manager, Repository Custodian, Developer, and QA Engineer agents — achieves 13.94% issue resolution on SWE-Bench, significantly outperforming single-agent GPT-4 baselines. The same paper and subsequent practitioner work establish that:[^64]

- **Orchestrator/subagent hierarchy** is more reliable than flat peer-agent systems[^65][^55]
- **Parallel research subagents** (each reading a different codebase subsystem) keep the main agent's context clean[^59][^60]
- **Atomic commits per task** (each subagent commits one task's work before the next begins) enables clean rollback and audit trails[^60]
- **Status-driven re-reduction**: treat parameter/requirement changes as first-class events that trigger replanning, not just re-prompting[^66]

For task tracking in multi-agent systems, Linear (with its linear-cli JSON output) and Task Master (with its JSON `.taskmaster/tasks.json`) are both designed to serve as the shared coordination layer across agents.[^67][^23][^41]

***

### Security Considerations for MCP in Production

Multiple academic papers in 2025 identified serious security risks in MCP deployments, including prompt injection via malicious tool descriptions, privilege escalation in multi-agent workflows, and supply-chain attacks via unvetted community servers. For internal high-velocity development:[^68][^69][^70]

- Prefer containerized MCP servers (Docker) for isolation[^71]
- Use fine-grained PATs scoped to minimum required permissions[^40]
- Consider per-user authentication with scoped authorization in shared deployments[^69]
- Audit third-party MCP servers before deployment; prefer official servers (GitHub, Atlassian, Linear) or well-maintained open-source tools with active maintenance[^69]
- For self-hosted Plane: local Stdio transport with environment variable authentication avoids network exposure entirely[^30]

***

## Part V: Recommended Stacks by Use Case

### Pure Local / Air-Gapped
**Taskwarrior + git-bug + todo.txt**
All data stays on your machine or in your git repo. BugWarrior can sync from GitHub/Jira when connectivity is available. No cloud dependency for any operation.

### Open-Source Self-Hosted Team
**Plane (self-hosted) + Plane MCP + Gitea + tea CLI**
Plane gives you full Jira-equivalent PM on your own PostgreSQL, with native MCP for AI agents. Gitea gives you self-hosted git forge with issue tracking. `tea` provides terminal access.

### GitHub-Native + Agentic AI
**gh + GitHub MCP Server + Task Master AI**
Use `gh` for human terminal work, the official GitHub MCP Server for AI agent issue management, and Task Master to decompose PRDs into a structured task queue for Claude Code or Cursor.

### Maximum Agentic Capability (macOS/Linux)
**Task Master AI (MCP) + ACF (MCP) + GitHub MCP Server + linear-cli**
Task Master handles PRD-to-task decomposition and tracks progress. ACF provides the full operational toolkit (filesystem, terminal, browser). GitHub MCP Server manages GitHub Issues. linear-cli provides JSON-output Linear integration for agents reading the team backlog.

### Linear-Based Product Teams
**Linear + linear-cli (joa23) + Linear MCP Server + Task Master AI**
Linear as the source of truth. `linear-cli` for terminal scripting and CI integration. Linear MCP for AI agent reads/writes. Task Master for breaking down individual Linear issues into implementation subtasks.

***

## Conclusion

The tooling ecosystem has reached a point of remarkable maturity. For terminal-first developers, Taskwarrior remains the most powerful local task engine with its hook system, BugWarrior bridges it to every major tracker, and git-bug provides a uniquely self-sufficient distributed bug tracker. For team-level coordination, Plane offers the only truly open-source, self-hostable full-feature PM platform with native MCP and AI agent support. For agentic workflows, Task Master AI is the clear community leader for PRD-driven decomposition, while ACF offers the broadest operational toolkit. The GitHub MCP Server is the de facto standard for GitHub-integrated AI agents. The most important architectural insight from both academic literature and practitioner consensus is that *task structure precedes agent execution*: investing in a well-formed CLAUDE.md, a clean task graph with dependency metadata, and correctly scoped MCP toolsets consistently outperforms throwing more model capability at a poorly structured workflow.

---

## References

1. [Taskwarrior Review 2025 - Features, Pricing, Hacks and Tips](https://productivity.directory/taskwarrior) - Command line Task Management. Find Best Features, Reviews, Pricing and Productivity tips & hacks to ...

2. [task(1) — taskwarrior - testing](https://manpages.debian.org/testing/taskwarrior/task.1.en.html)

3. [Taskwarrior - What's next?](https://taskwarrior.org/docs/start/)

4. [Taskwarrior - Command line Task Management](https://github.com/GothenburgBitFactory/taskwarrior) - Taskwarrior - Command line Task Management. Contribute to GothenburgBitFactory/taskwarrior developme...

5. [GitHub - GothenburgBitFactory/bugwarrior: Pull github, bitbucket, and trac issues into taskwarrior](https://github.com/GothenburgBitFactory/bugwarrior) - Pull github, bitbucket, and trac issues into taskwarrior - GothenburgBitFactory/bugwarrior

6. [bugwarrior/bugwarrior/README.rst at develop · GothenburgBitFactory/bugwarrior](https://github.com/GothenburgBitFactory/bugwarrior/blob/develop/bugwarrior/README.rst) - Pull github, bitbucket, and trac issues into taskwarrior - GothenburgBitFactory/bugwarrior

7. [Todo.txt Syntax Overview - SwiftoDo](https://swiftodoapp.com/todotxt-syntax/syntax-overview/) - SwiftoDo allows you to view your task list in a few different simplified, organized formats, which m...

8. [Todo.txt: Future-proof task tracking in a file you control](http://todotxt.org) - Todo.txt apps are minimal, todo.txt-focused editors which help you manage your tasks with as few key...

9. [Todo.txt format - GitHub](https://github.com/todotxt/todo.txt) - todo.txt format rules · The file contents should be human-readable without requiring any tools other...

10. [git-bug man | Linux Command Library](https://linuxcommandlibrary.com/man/git-bug) - git-bug linux command man page: Distributed bug tracker embedded in git

11. [git-bug command - github.com/MichaelMure/git-bug - Go Packages](https://pkg.go.dev/github.com/MichaelMure/git-bug)

12. [Distributed, offline-first bug tracker embedded in git - GitHub](https://github.com/git-bug/git-bug) - Distributed, offline-first bug tracker embedded in git - git-bug/git-bug

13. [git-bug/doc/howto-github.md at master · git-bug/git-bug](https://github.com/git-bug/git-bug/blob/master/doc/howto-github.md) - Distributed, offline-first bug tracker embedded in git, with bridges - git-bug/git-bug

14. [Github issue search in command line](https://stackoverflow.com/questions/42337066/github-issue-search-in-command-line/63945790) - I am trying to search for issues with keywords in github. I want to achieve this from command line. ...

15. [GitHub CLI](https://cli.github.com) - Take GitHub to the command line

16. [gh issue edit - GitHub CLI](https://cli.github.com/manual/gh_issue_edit) - Take GitHub to the command line

17. [tea - Code - Gitea](https://code.gitea.io/tea/) - Tea - CLI tool for Gitea. A command line tool to interact with Gitea server. Copyright © 2023 The Gi...

18. [Gitea Tea CLI: List, Create, Merge and Close Pull Requests with CLI](https://forum.threefold.io/t/gitea-tea-cli-list-create-merge-and-close-pull-requests-with-cli/4432) - We show how to use Gitea's CLI tool called Tea. We show basic commands that complement the Git CLI. ...

19. [herrhotzenplotz/gcli: Portable Git(hub|lab|tea)/Forgejo/Bugzilla CLI tool](https://github.com/herrhotzenplotz/gcli) - Portable CLI tool for interacting with Git(Hub|Lab|Tea), Forgejo and Bugzilla from the command line....

20. [Atlassian Command-Line Interface (ACLI) - Jira](https://community.atlassian.com/forums/Jira-articles/Atlassian-Command-Line-Interface-ACLI-for-Jira-is-now-generally/ba-p/3028362) - ACLI is a command-line tool that enables admins and technical users to complete work in Jira by exec...

21. [Introducing the Atlassian Command Line Interface (ACLI) for Jira](https://www.atlassian.com/blog/jira/atlassian-command-line-interface) - ACLI is a powerful command-line tool that enables admins and technical users to manage Jira tasks by...

22. [Jira Command Line Interface (CLI) - Atlassian](https://appfire.atlassian.net/wiki/spaces/JCLI/overview) - The Jira command line interface (CLI) add-on allows for: Examples are build and test automation or o...

23. [linear-cli](https://pkg.go.dev/github.com/joa23/linear-cli@v1.4.7-0.20260129011826-a4d354540f26)

24. [@anoncam/linear-cli](https://www.npmjs.com/package/@anoncam/linear-cli) - Command-line interface for Linear API with cross-team reporting and AI-assisted label management. La...

25. [linear | Skills Marketplace - LobeHub](https://lobehub.com/skills/hmps-linear-cli-linear)

26. [Plane: AI-native project management](https://plane.so) - Project management for teams and AI agents. Plan, track, and ship with Projects, Wiki, and AI. Avail...

27. [Simplifying Self-Hosting Workflows with a Go based CLI at plane.so](https://fossunited.org/c/hyderabad/2025-jan/cfp/jm1de4a0ds) - Simplifying Self-Hosting Workflows with a Go based CLI at plane.so is a Talk proposal for FOSS Meetu...

28. [Prime CLI - Command line tools - Plane Developer Documentation](https://developers.plane.so/self-hosting/manage/prime-cli) - Use Plane Prime CLI for managing your self-hosted instance. Commands for setup, configuration, upgra...

29. [GitHub - makeplane/plane-mcp-server: Plane's Official Model Context Protocol Server 🔌 ⌨️ 🔥](https://github.com/makeplane/plane-mcp-server) - Plane's Official Model Context Protocol Server 🔌 ⌨️ 🔥 - makeplane/plane-mcp-server

30. [MCP server - Plane Developer Documentation](https://developers.plane.so/dev-tools/mcp-server) - The Plane MCP Server aims to provide a stable implementation for developers to build robust AI-power...

31. [Deploy Plane on your infrastructure - Plane Developer Documentation](https://developers.plane.so/self-hosting/overview) - Deploy Plane on your own infrastructure with Docker, Kubernetes, or Podman. Complete self-hosting gu...

32. [Model Context Protocol – Agentic Path in Software Testing](https://www.ijsrp.org/research-paper-0725.php?rp=P16313881) - - The rise of large language models (LLMs) and “agentic” AI is reshaping software testing. Tradition...

33. [MCPToolBench++: A Large Scale AI Agent Model Context Protocol MCP Tool Use Benchmark](https://arxiv.org/abs/2508.07575) - LLMs'capabilities are enhanced by using function calls to integrate various data sources or API resu...

34. [Advancing Agentic AI through Communication Protocols](https://ijsrst.com/index.php/home/article/view/IJSRST25125127) - Autonomous agents powered by Large Language Models (LLMs) require reliable and standardized framewor...

35. [cursor/mcp-servers](https://github.com/cursor/mcp-servers) - A list of MCP (Model Context Protocol) servers for developer tools and services - cursor/mcp-servers

36. [github-mcp-server is now available in public preview](https://github.blog/changelog/2025-04-04-github-mcp-server-public-preview/) - Today we’re releasing a new open source, official, local GitHub MCP Server. We’ve worked with Anthro...

37. [GitHub MCP Server now supports GitHub Projects and more](https://github.blog/changelog/2025-10-14-github-mcp-server-now-supports-github-projects-and-more/) - You can now manage your projects and their items using the GitHub MCP Server to automate project wor...

38. [github-issues | Agent Skills Library - Awesome MCP Servers](https://mcpservers.org/agent-skills/github/github-issues) - Create, update, and manage GitHub issues with full workflow support including types, labels, assigne...

39. [GitHub MCP Server](https://www.mcp-gallery.jp/mcp/github/crypto-ninja/mcp-server-for-github) - Enables comprehensive GitHub workflow automation including Actions monitoring, PR management, code s...

40. [Week 17: How to Use the GitHub MCP Server in VS Code and What ...](https://www.linkedin.com/posts/jimmy-dave_github-mcp-server-automate-github-with-model-activity-7403659628271841280-gFAQ) - What You Get Out of the Box Issue Management Create issues, update issues, add comments, and search ...

41. [GitHub - eyaltoledano/claude-task-master](https://github.com/eyaltoledano/claude-task-master) - Optimizing MCP Tool Loading. Task Master's MCP server supports selective tool loading to reduce cont...

42. [claude-task-master/docs/task-structure.md at main - GitHub](https://github.com/eyaltoledano/claude-task-master/blob/main/docs/task-structure.md) - Analyze task complexity: Use the complexity analysis feature to identify which tasks should be broke...

43. [claude-task-master.md - DavidWells/stars - GitHub](https://github.com/DavidWells/stars/blob/master/stars/eyaltoledano/claude-task-master.md) - MCP (Model Control Protocol) provides the easiest way to get started with Task Master directly in yo...

44. [GitHub - FutureAtoms/agentic-control-framework: A powerful CLI and MCP-based task management system for agentic workflows.](https://github.com/FutureAtoms/agentic-control-framework) - A powerful CLI and MCP-based task management system for agentic workflows. - FutureAtoms/agentic-con...

45. [Agentic Control Framework – README | MCP Marketplace](https://ubos.tech/mcp/agentic-control-framework/) - It offers: CLI-based task management: Create, update, and track tasks using simple commands; MCP int...

46. [Agentic Control Framework (ACF) - FutureAtoms](https://futureatoms.com/agentic) - Agentic Control Framework (ACF) is a free, open-source orchestration layer for general-purpose devel...

47. [README.md - MCP Client Configurations for ACF - GitHub](https://github.com/FutureAtoms/agentic-control-framework/blob/main/config/client-configurations/README.md) - This guide shows how to configure different MCP clients to work with your ACF server via mcp-proxy. ...

48. [Linear MCP Server – Facilitates project management with ... - Reddit](https://www.reddit.com/r/mcp/comments/1iq5ttv/linear_mcp_server_facilitates_project_management/) - JIRA MCP Server – Provides an interface to access and manage JIRA data through the Model Context Pro...

49. [MCP Jetpack – The easiest way to get started with MCP in Cursor](https://news.ycombinator.com/item?id=44637165) - It's an MCP server that automatically finds and executes the right tools needed to accomplish your t...

50. [SystemPrompt TaskChecker](https://ubos.tech/mcp/systemprompt-taskchecker/) - Revolutionize Your Software Engineering with UBOS - The Future of Application Development

51. [GitHub - Ejb503/systemprompt-mcp-taskchecker: Model Context Protocol (MCP) server for intelligent task management, evaluation scoring, and session-based workflow tracking. Seamlessly integrates with AI assistants to provide structured task orchestration, real-time progress monitoring, and comprehensive evaluation metrics.](https://github.com/Ejb503/systemprompt-mcp-taskchecker) - Model Context Protocol (MCP) server for intelligent task management, evaluation scoring, and session...

52. [kunwarVivek/mcp-github-project-manager](https://github.com/kunwarVivek/mcp-github-project-manager) - ✓ 40+ GitHub Project Management Tools - Complete CRUD operations for projects, milestones, issues, s...

53. [AutoScrum: Automating Project Planning Using Large Language Models](https://arxiv.org/pdf/2306.03197.pdf) - ...a
scrum based approach and a shortcut plan approach. The scrum based approach
executes an automat...

54. [Advancing Agentic Systems: Dynamic Task Decomposition, Tool ...](https://neurips.cc/virtual/2024/100915) - - We propose an advanced agentic framework designed to autonomously process multi-hop user queries b...

55. [Claude Code Best Practices in 2026: What Actually Holds Up](https://www.remoteopenclaw.com/blog/claude-code-best-practices) - Anthropic's own Claude Code docs make the best practices pretty clear. Here are the ones that actual...

56. [Best practices for structuring specialized agents in agentic ... - Reddit](https://www.reddit.com/r/ClaudeCode/comments/1robhv1/best_practices_for_structuring_specialized_agents/) - 1. How granular should specialized agents be?For example: · 2. How does the orchestrator decide wher...

57. [Make A Comprehensive Claude...](https://matsen.fhcrc.org/general/2025/10/30/agentic-coding-principles.html) - An understanding of how coding agents work can guide us about how best to use them.

58. [Enhancing Model Context Protocol (MCP) with Context-Aware Server Collaboration](https://arxiv.org/abs/2601.11595) - The Model Context Protocol (MCP) (MCP Community, 2025) has emerged as a widely used framework for en...

59. [Claude.Md: Less Is More](https://gahmed.com/blog/spec-driven-development-claude-code/) - My workflow for turning Claude Code from a vibe-coding machine into a disciplined engineering partne...

60. [Chapter 16: Spec-Driven Development with Claude Code | The AI ...](https://agentfactory.panaversity.org/docs/General-Agents-Foundations/spec-driven-development) - Spec-Driven Development (SDD) represents a paradigm shift in how software is created with AI assista...

61. [Claude Code for Spec-Driven Development: Capabilities and Limits](https://www.augmentcode.com/guides/claude-code-spec-driven-development) - Spec-driven development with Claude Code uses structured markdown files, primarily CLAUDE.md, to def...

62. [Anthropic's Guide to Claude Code: Best Practices for Agentic Coding](https://www.reddit.com/r/ClaudeAI/comments/1k5slll/anthropics_guide_to_claude_code_best_practices/) - Setting up a CLAUDE.md to guide Claude's behavior within your repo. How Claude uses your codebase + ...

63. [[Enhancement] Hierarchical Tool Management for MCP - GitHub](https://github.com/orgs/modelcontextprotocol/discussions/532) - This proposal extends MCP to support hierarchical tool organization and lazy loading, addressing the...

64. [MAGIS: LLM-Based Multi-Agent Framework for GitHub Issue Resolution](https://arxiv.org/html/2403.17927v1) - ...Quality Assurance Engineer agents. This
framework leverages the collaboration of various agents i...

65. [Magentic-One: A Generalist Multi-Agent System for Solving Complex Tasks](http://arxiv.org/pdf/2411.04468v1.pdf) - ...system for solving such tasks. Magentic-One uses a
multi-agent architecture where a lead agent, t...

66. [EQSANS-CLI: A natural-language, agent-ready command-line tool for small-angle neutron scattering data reduction at EQ-SANS](https://www.semanticscholar.org/paper/dc10e0466cfe0f99d296c4a481045cdc35b96531) - Small-angle neutron scattering (SANS) data reduction at user facilities follows a largely repetitive...

67. [Task Master Claude Code Skill | AI Workflow Management](https://mcpmarket.com/tools/skills/task-master) - Task Master transforms how developers manage complex projects by integrating structured task managem...

68. [MCP Safety Audit: LLMs with the Model Context Protocol Allow Major
  Security Exploits](https://arxiv.org/html/2504.03767v2) - ... on those samples; and (c) generate a security report
detailing all findings. Our work highlights...

69. [Securing the Model Context Protocol (MCP): Risks, Controls, and Governance](https://arxiv.org/abs/2511.20920) - The Model Context Protocol (MCP) replaces static, developer-controlled API integrations with more dy...

70. [When MCP Servers Attack: Taxonomy, Feasibility, and Mitigation](https://arxiv.org/abs/2509.24272) - Model Context Protocol (MCP) servers enable AI applications to connect to external systems in a plug...

71. [The observability agent Sep 2025 • Claude Agent SDK ... - Agent Daily](https://agentdaily.dev/content/7a1bf2f9-43ee-4928-b1bd-e551e198eb6e) - This cookbook demonstrates how to connect Claude agents to external systems using MCP (Model Context...

