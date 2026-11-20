---
source: 2025-11-15-ruby-cli-modern-practices-report.md (autopax/practica ideology corpus, Part II sec 4)
gathered: 2026-07-21
status: gathered (partial excerpt -- full file ~2020 lines; Ruby-stack specifics omitted, agent-facing payload kept)
paths:
  - /Users/josephwecker-v2/src/autopax/docs/exp/2025-11-15-ruby-cli-modern-practices-report.md:1-4,1469-1665,1916-1937
source_commit: 033af13c5ca686ca5898645f6dc772e4435c0523
categories: [cli-ergonomics, agent-first-cli, json-output, exit-codes, AGENTS.md, non-interactive]
why_included: >
  Nov 14-15 2025 (~2020-line report; excerpted to the agent-facing payload). Modern CLI design with an explicit "agent-first fundamentals" thesis: CLI outputs as versioned API contracts, JSON output modes, deterministic exit codes, non-interactive flags, NO_COLOR, the AGENTS.md onboarding standard, agent-annotated TODO comments, and "integrated tooling creates feedback loops." Excerpt = the abstract thesis + the AGENTS.md/agent-onboarding section + the feedback-loops conclusion; the Ruby-library specifics (Dry::CLI/Thor/Toys/mise/Zeitwerk/RBS) are omitted as out-of-scope plumbing. "CLI tools must serve two audiences -- human-friendly defaults with machine escape hatches" is the through-line demand.
---

<!-- excerpt: source lines 1-4 -->
# Modern Ruby CLI Development: Agent-First Design and Contemporary Tooling

Ruby command-line development in 2024-2025 has evolved beyond traditional human-centric design to embrace **AI agents as first-class users**[^1]. The most significant shift is treating CLI outputs as versioned API contracts with machine-readable formats (JSON), deterministic exit codes, and explicit non-interactive modes. For frameworks, **Dry::CLI leads in clean architecture**[^2] with plain Ruby classes ideal for testing, while **Thor dominates production use** (Rails, Bundler)[^3] and **Toys excels for project automation**[^4]. Modern tooling includes **mise for unified version management**[^5], **Zeitwerk for zero-config autoloading**[^6], and **RBS+Steep for gradual typing**[^7]. Testing relies heavily on **Aruba for integration**[^8] with in-process modes delivering 10-50x speed improvements. The emerging **AGENTS.md standard**[^9] (adopted by OpenAI, Sourcegraph, Google Jules, Cursor) provides structured onboarding instructions, while **XDG Base Directory** patterns[^10] replace legacy dotfiles for configuration. Modern projects target Ruby 3.2+ minimum, leverage pattern matching and other Ruby 3+ idioms, and use pessimistic versioning (~>). The core insight: CLI tools must now serve two audiences—providing human-friendly defaults while exposing machine escape hatches through flags like `--no-interactive`, `--output json`, and respecting `NO_COLOR` environment variables.


<!-- excerpt: source lines 1469-1665 -->
## Repository structure enables rapid agent onboarding

The emergence of **AGENTS.md as a standard**[^39] (adopted July 2025 by OpenAI, Sourcegraph, Google Jules, Cursor, and Factory) marks a fundamental shift in repository documentation. This Markdown file provides machine-readable instructions specifically for AI coding agents, supplementing traditional README.md with actionable commands, project structure explanations, and troubleshooting guidance.

**AGENTS.md structure**[^40] follows a consistent format across the industry. The file opens with development environment tips—how to locate packages in monorepos, install dependencies, and navigate project structure. Testing instructions specify where to find CI configuration, how to run the full suite, and crucially, how to focus on single tests for faster iteration. Code standards section lists automated tools and when to run them. PR instructions detail commit message formats, required checks, and how to link issues. Security notes highlight what never to commit and what tools verify security properties.

```markdown
# AGENTS.md

## Development environment tips

This is a Ruby CLI application using Bundler, Dry::CLI, and RSpec.

- Ruby version managed by mise (see `.mise.toml`)
- Run `mise install` to install correct Ruby version
- Run `bundle install` to install dependencies
- Main executable is `exe/myapp`
- Source code in `lib/myapp/` with Zeitwerk autoloading
- Tests use RSpec in `spec/` with Aruba for CLI integration

## Testing instructions

Find full CI configuration in `.github/workflows/ci.yml`

Run tests:
```bash
# All tests
bundle exec rspec

# Specific file
bundle exec rspec spec/myapp/cli_spec.rb

# Focus on line number
bundle exec rspec spec/myapp/cli_spec.rb:42

# With coverage
COVERAGE=true bundle exec rspec
```

## Code standards

Before committing, always run:
```bash
# Auto-format code
bin/format

# Run linter
bundle exec rubocop

# Type check (if using RBS)
bundle exec steep check

# Run tests with coverage
COVERAGE=true bin/test
```

We use RuboCop with standard configuration. All code must:
- Follow Ruby Style Guide
- Maintain 80%+ test coverage
- Pass all RuboCop cops
- Use Ruby 3.2+ idioms (pattern matching, etc.)

## PR instructions

- Title format: `[type] Brief description` (e.g., `[feat] Add JSON output mode`)
- Types: feat, fix, docs, test, refactor, chore
- Run full test suite before submitting: `bin/pre-commit`
- Link related issues with `Closes #123`
- All PRs require passing CI and one approval

## Security notes

- Never commit API keys or credentials
- Use ENV variables for secrets
- All credentials in `.env.example` (values redacted)
- Run `bundle exec brakeman` for security scanning

## Architecture decisions

Commands use Dry::CLI for clean OOP architecture. Each command is a plain Ruby class in `lib/myapp/commands/`.

Business logic lives in `lib/myapp/` domain classes. Commands orchestrate but don't implement logic.

Configuration uses XDG Base Directory pattern with `xdg` gem.

Zeitwerk handles autoloading - no manual `require` calls needed for app code.
```

**README.md patterns for agents** emphasize executable examples and command reference. The traditional README structure—purpose, installation, usage, contributing—remains valid, but modern versions front-load the Quick Start section with copy-pasteable commands and expected outputs. Architecture sections explain design decisions relevant to code changes. The common tasks section becomes a command reference for development operations.

```markdown
# MyApp

One-line value proposition: Automated code quality checker for Ruby projects.

## Quick Start

```bash
# Install mise and Ruby
curl https://mise.run | sh
mise install

# Install dependencies
bundle install

# Run in current directory
exe/myapp check

# Auto-fix issues
exe/myapp fix

# Output JSON for parsing
exe/myapp check --output json
```

## Development

### Setup
```bash
git clone https://github.com/you/myapp.git
cd myapp
mise install          # Install Ruby version
bundle install        # Install dependencies
bin/setup            # Additional setup if needed
```

### Common commands

| Command | Purpose |
|---------|---------|
| `bin/format` | Auto-format all Ruby files |
| `bin/test` | Run test suite |
| `bin/test spec/file_spec.rb` | Run specific test |
| `bin/lint` | Check code style |
| `bin/typecheck` | Run Steep type checker |
| `bin/pre-commit` | Run all checks before pushing |
| `exe/myapp` | Run CLI locally |
| `mise run <task>` | Run mise task (see mise.toml) |
| `toys <command>` | Run development tool |

### Project structure

```
lib/
  myapp.rb           # Main entry, sets up Zeitwerk
  myapp/
    cli.rb           # CLI interface (Dry::CLI)
    commands/        # Command implementations
    processors/      # Business logic
    config.rb        # Configuration management
    version.rb       # VERSION constant
sig/
  myapp.rbs          # Type signatures (if using RBS)
```

Commands are thin wrappers. Business logic lives in domain classes under `lib/myapp/`. Zeitwerk handles autoloading based on file structure.

## Testing

We use RSpec with Aruba for CLI testing. Tests run in-process for speed.

```bash
# All tests
bundle exec rspec

# With coverage report
COVERAGE=true bundle exec rspec

# Focus on failures
bundle exec rspec --only-failures

# Type checking
bundle exec steep check
```

Maintain 80%+ coverage. Test business logic with unit tests, CLI integration with Aruba.
```

**CONTRIBUTING.md provides workflow details** often too granular for README but essential for agents making changes. Specify the exact commit message format including type prefixes. Detail the PR process step-by-step. List all checks that must pass and how to run them locally. Provide troubleshooting for common setup issues. Link to code style guides and architectural decision records.

**Self-discovery mechanisms** help agents identify work without human direction. Structured TODO comments include metadata like priority, type, and assignee. Issues labeled "agent-friendly" or "good-first-issue" signal automation candidates. Task lists in issues provide clear acceptance criteria and specify files to modify. Git-based discovery finds unfinished branches, WIP commits, or uncommitted changes needing attention.

```ruby
# TODO(priority:high, type:bug, agent:safe): Fix N+1 query in User#posts
# Optimize by adding eager loading:
#   User.includes(:posts).where(...)

# TODO(issue:#247, est:30min): Extract validation to separate class
# This method does too much. Create ValidatorService and move logic there.

# TODO(@agent, type:optimization): Consider caching this calculation
# Profile first to ensure it's actually a bottleneck
```

**Cleanup and reset patterns** ensure agents leave repositories in pristine state for the next developer or agent. Provide `bin/reset` that performs comprehensive cleanup: discard uncommitted changes (`git reset --hard && git clean -fd`), update dependencies (`bundle install`), clear caches, and run tests to verify clean state. Make reset idempotent and safe to run repeatedly.

```bash

<!-- excerpt: source lines 1916-1937 -->
## Integrated tooling creates feedback loops and consistency

The complete picture of modern Ruby CLI development integrates framework selection, testing strategy, agent-friendly design, repository organization, and project structure into coherent patterns optimized for both human developers and AI agents.

**Start with Dry::CLI for user-facing commands** where clean architecture and testability matter most. Its plain Ruby classes make every command a simple object you can instantiate and test without framework ceremony. **Add Toys for development automation** replacing Rake with better CLI ergonomics and rich built-in mixins. **Use mise for version management** and environment configuration, replacing rbenv/RVM with a modern, unified tool. **Adopt Zeitwerk for autoloading** to eliminate manual require statements and provide consistent file-to-constant mapping. **Consider RBS+Steep for type checking** on core business logic where type signatures serve as executable documentation.

**Structure tests with Aruba in-process mode** for 10-50x faster integration testing than subprocess execution. Separate business logic into plain Ruby objects tested with fast unit tests, keeping the CLI layer thin and tested through integration tests. Configure RSpec or Minitest based on team preference—RSpec for powerful matchers and rich metadata, Minitest for simplicity and speed. Use WebMock to stub HTTP requests and VCR to record real interactions, ensuring deterministic test runs critical for agent-driven development.

**Design every command with agent usage in mind** from the start. Support `--output json` for machine-readable output with stable schemas validated in CI. Document exit codes following POSIX and sysexits.h conventions, maintaining stability across minor versions. Provide `--no-interactive` flags for every prompt, failing clearly when required input is missing rather than hanging. Respect `NO_COLOR` and TTY detection for color output. Send data to stdout and logs to stderr.

**Organize repositories following XDG standards** for configuration in `~/.config/`, placing executables in `exe/` and development scripts in `bin/`, structuring tests to mirror source code, and providing standardized development commands (`bin/format`, `bin/test`, `bin/lint`, `bin/pre-commit`). **Create AGENTS.md** alongside README.md with explicit commands for common tasks, testing procedures, code standards, and security considerations.

**Modern Ruby CLI projects** targeting Ruby 3.2+ leverage recent language improvements (pattern matching, endless methods, numbered parameters, better error messages, argument forwarding) while maintaining clean architecture. Use pessimistic version constraints (`~>`) for dependencies to allow updates without breaking changes. Validate output schemas in CI to prevent accidental breaking changes to machine-readable formats. Configure parallel RuboCop and RSpec execution for faster feedback loops.

**The integration point** is recognizing that these practices reinforce each other. Clean architecture with Dry::CLI makes testing straightforward. Fast tests with Aruba in-process mode enable TDD workflows. Agent-friendly output formats make CLI tools composable in scripts and automation. XDG-compliant configuration simplifies testing with isolated config files. Standardized bin/ scripts provide consistent interfaces for both human developers and agents. AGENTS.md documentation creates an entry point for agents to discover these patterns without extensive code exploration. Zeitwerk's autoloading provides mechanical file-to-constant mapping that agents can reason about. RBS type signatures serve as machine-verified documentation. Mise unifies version and environment management. Ruby 3+ idioms make code more expressive and easier to understand.

The future direction emphasizes **Model Context Protocol (MCP)** for runtime capability discovery, allowing agents to query available commands and their schemas without training data. The **AGENTS.md standard** continues evolving with community input, likely expanding to include performance expectations, rate limits, and idempotency guarantees. CLI tools increasingly serve as **interfaces between AI agents and external systems**, requiring the same care in API design, versioning, and documentation that REST APIs receive.

For teams adopting these practices, start with the agent-friendly fundamentals: JSON output modes, documented exit codes, and non-interactive flags. These changes benefit human users too—JSON output helps with scripting, clear exit codes enable better error handling, and non-interactive modes support automation. Layer in the testing infrastructure with Aruba and separation of concerns. Add AGENTS.md as repositories mature and patterns emerge. Adopt mise for version management and Zeitwerk for autoloading. Consider RBS+Steep for critical business logic. Leverage Ruby 3+ idioms in new code. The result: CLI tools that serve both human developers and AI agents as first-class citizens, positioned for the AI-augmented development era already unfolding in 2024-2025.

---


