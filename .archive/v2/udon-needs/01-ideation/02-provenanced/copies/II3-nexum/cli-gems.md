---
source: nexum repo — research doc (Ruby CLI-parsing gem comparison)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/_core/nexum/docs/research/cli-gems.md
source_commit: c87c75ce20aeaad9290732e17be256601b45a338
categories: [framework-comparison, ruby-cli, tooling-substrate, reference]
why_included: >
  2025-11-06. Comparison of ~14 Ruby CLI-parsing gems (thor, gli, dry-cli, tty-option, toys-core, …)
  by subcommands/config/env-vars/validation/maintenance, with the rationale for choosing toys-core (the
  substrate the vision-agentic-toys DSL extends). Mostly reference/substrate-selection, but it grounds
  WHY Toys was the chosen foundation; relevant to UDON only if its utility CLIs are Ruby, otherwise
  contextual for the harness lineage.
---
# Ruby CLI Gems Comparison

Comprehensive comparison of Ruby command-line interface parsing gems, ranked by popularity and actual usage.

**Source:** Data from Ruby Toolbox (January 2025) and GitHub

---

## Feature Comparison Matrix

| Gem | Downloads | Stars | Subcommands | Config Files | Env Vars | Help Gen | Validation | Dependencies | Maintained | Primary Use Case |
|-----|-----------|-------|-------------|--------------|----------|----------|------------|--------------|-----------|------------------|
| **highline** | 291M | 335 | ❌ | ❌ | ❌ | ⚠️ Limited | ❌ | 0 (stdlib) | ✅ Active | Interactive prompts, terminal I/O |
| **slop** | 149M | 1.1k | ⚠️ Basic | ❌ | ❌ | ✅ Auto | ✅ Custom | 0 | ✅ Active | Simple, minimal option parsing |
| **optimist** | 121M | 257 | ⚠️ Basic | ❌ | ❌ | ✅ Auto | ✅ Type-based | 0 (single file) | ✅ Active | Trollop successor, zero-deps |
| **commander** | 117M | 1.2k | ✅ Full | ❌ | ❌ | ✅ Auto | ⚠️ Basic | 1 (highline) | ⚠️ Moderate | Full-featured CLI suite |
| **gli** | 94M | 1.3k | ✅ Full | ⚠️ Via plugin | ❌ | ✅ Auto | ✅ Custom | 0 | ✅ Active | Git-like interface, scaffolding |
| **mixlib-cli** | 69M | 124 | ❌ | ❌ | ❌ | ⚠️ Basic | ❌ | 0 | ✅ Active (Chef) | Chef ecosystem, mixin pattern |
| **clamp** | 66M | 410 | ✅ Full | ❌ | ⚠️ Manual | ✅ Auto | ✅ Custom | 0 | ✅ Active | Class-based, object model |
| **dry-cli** | 47M | 147 | ✅ Full | Via dry-configurable | Via dry-configurable | ✅ Auto | ✅ Via dry-validation | Modular (dry-rb) | ✅ Active | Modular, dry-rb ecosystem |
| **cri** | 41M | 121 | ✅ Full | ❌ | ❌ | ✅ Auto | ❌ | 1 | ✅ Active (Nanoc) | Nanoc, command tree structure |
| **thor** | ~200M* | 5.1k | ✅ Full | ❌ | ❌ | ✅ Auto | ✅ Type-based | 0 | ✅ Active | Rails/Bundler, task automation |
| **docopt** | 29M | 143 | ✅ Via docstring | ❌ | ❌ | ✅ Via docstring | ⚠️ Limited | 0 | ⚠️ Low activity | Help-first design, docstring parsing |
| **methadone** | 16M | 237 | ✅ Full | ❌ | ❌ | ✅ Auto | ❌ | 0 | ⚠️ Low activity | Bootstrapping, generator included |
| **cmdparse** | 10M | 62 | ✅ Full | ❌ | ❌ | ✅ Auto | ❌ | 0 | ⚠️ Low activity | Command tree, hierarchical |
| **tty-option** | 1.7M | 56 | ⚠️ Limited | ❌ | ✅ First-class | ✅ Auto | ✅ Custom | Part of TTY | ✅ Active | TTY toolkit, declarative DSL |
| **OptionParser** | stdlib | N/A | ⚠️ Manual | ❌ | ❌ | ⚠️ Manual | ❌ | 0 (stdlib) | ✅ Core | Maximum control, zero deps |

**Legend:**
- ✅ Full/Excellent support
- ⚠️ Partial/Basic support
- ❌ Not supported or requires manual implementation
- *Thor downloads estimated (not in Ruby Toolbox snapshot)

---

## Detailed Gem Profiles

### 1. highline (291M downloads, 335 stars)
**Package:** `gem install highline`
**GitHub:** https://github.com/JEG2/highline

**NOT a CLI parser** - Actually a terminal I/O library for interactive prompts, menus, and user input.

**Why it's #1 by downloads:** Used as a dependency by many CLI tools (Commander, etc.) for interactive features.

**Key Features:**
- Interactive menus and prompts
- Color output
- Input validation and masking (passwords)
- Terminal detection

**Use in Nexum:** Could complement CLI parser for interactive confirmation dialogs.

---

### 2. slop (149M downloads, 1.1k stars)
**Package:** `gem install slop`
**GitHub:** https://github.com/leejarvis/slop

**Philosophy:** "Simple Lightweight Option Parsing" - minimal DSL, stays out of your way.

**Strengths:**
- Very clean, minimal API
- Auto-generated help
- Support for flags, options, arrays
- Zero dependencies
- Easy to remember syntax

**Weaknesses:**
- Limited subcommand support (basic, not git-style)
- No config file or env var support
- No built-in validation framework

**Example:**
```ruby
opts = Slop.parse do |o|
  o.string '-m', '--model', 'model to use', default: 'sonnet'
  o.bool '--thinking', 'enable thinking', default: true
  o.on '--help' do
    puts o
    exit
  end
end
opts[:model] # => 'sonnet'
```

**Best for:** Simple CLIs without subcommands, minimal dependencies, quick scripts.

---

### 3. optimist (121M downloads, 257 stars)
**Package:** `gem install optimist`
**GitHub:** https://github.com/ManageIQ/optimist

**History:** Successor to Trollop (renamed in 2018). Maintained by ManageIQ.

**Philosophy:** Single-file, zero dependencies, "just gets out of your way."

**Strengths:**
- **Zero dependencies** (single file)
- Auto-generated help with minimal code
- Type coercion (string, integer, float, array, etc.)
- Constraints (required, conflicts, depends)
- Very simple API

**Weaknesses:**
- No built-in subcommand support
- No config files
- No environment variables
- Basic validation only

**Example:**
```ruby
require 'optimist'
opts = Optimist::options do
  opt :model, "Model to use", type: :string, default: "sonnet"
  opt :thinking, "Enable thinking", default: true
  opt :temperature, "Sampling temperature", type: :float, default: 1.0
end
```

**Best for:** Single-command tools, minimal dependencies, quick prototypes.

---

### 4. commander (117M downloads, 1.2k stars)
**Package:** `gem install commander`
**GitHub:** https://github.com/commander-rb/commander

**Philosophy:** Full-featured CLI framework with git-style subcommands.

**Strengths:**
- Full subcommand support
- DSL-based command definition
- Auto-generated help
- Interactive prompts via highline
- Robust error handling

**Weaknesses:**
- Depends on highline
- DSL can feel limiting for complex scenarios
- Less active than Thor or GLI

**Example:**
```ruby
program :name, 'nexum'
program :version, '0.1.0'
program :description, 'AI conversation tool'

command :chat do |c|
  c.syntax = 'nexum chat [options]'
  c.option '--model STRING', String, 'Model to use'
  c.action do |args, options|
    # implementation
  end
end
```

**Best for:** Full-featured CLI apps with subcommands, when you want a DSL approach.

---

### 5. gli (94M downloads, 1.3k stars)
**Package:** `gem install gli`
**GitHub:** https://github.com/davetron5000/gli

**Philosophy:** "Git-Like Interface" - make CLI apps like git with commands and subcommands.

**Strengths:**
- **Excellent subcommand support** (primary focus)
- Scaffolding/generator included (`gli init`)
- Auto-generated help and documentation
- Wraps OptionParser with simpler API
- Config file support via plugins

**Weaknesses:**
- No built-in env var support
- No built-in config (requires plugin)
- More boilerplate than simpler parsers

**Example:**
```ruby
desc 'Start interactive chat'
arg_name 'prompt'
command :chat do |c|
  c.flag [:m, :model], desc: 'Model to use'
  c.switch [:thinking], default_value: true

  c.action do |global, options, args|
    # implementation
  end
end
```

**Best for:** Git-style CLI apps, when you want scaffolding and generators.

---

### 6. mixlib-cli (69M downloads, 124 stars)
**Package:** `gem install mixlib-cli`
**GitHub:** https://github.com/chef/mixlib-cli

**Philosophy:** Mixin pattern for adding CLI parsing to classes. Used extensively in Chef.

**Strengths:**
- Battle-tested in Chef ecosystem
- Clean mixin pattern
- Zero dependencies

**Weaknesses:**
- No subcommand support
- No config files
- No env vars
- Basic help generation
- Very Chef-centric design

**Example:**
```ruby
class MyCLI
  include Mixlib::CLI

  option :model,
    short: '-m MODEL',
    long: '--model MODEL',
    description: 'Model to use',
    default: 'sonnet'
end

cli = MyCLI.new
cli.parse_options
cli.config[:model]
```

**Best for:** Chef-related tools, mixin pattern enthusiasts.

---

### 7. clamp (66M downloads, 410 stars)
**Package:** `gem install clamp`
**GitHub:** https://github.com/mdub/clamp

**Philosophy:** Command as a Ruby class, execution as an instance. Object-oriented approach.

**Strengths:**
- Clean class-based model
- Full subcommand support
- Good help generation
- Custom validation via methods
- Zero dependencies

**Weaknesses:**
- More verbose than DSL approaches
- No config file support
- Manual env var handling

**Example:**
```ruby
class ChatCommand < Clamp::Command
  option ["-m", "--model"], "MODEL", "model to use", default: "sonnet"
  option "--[no-]thinking", :flag, "enable thinking", default: true

  def execute
    # implementation
  end
end
```

**Best for:** When you want object-oriented command modeling, inheritance patterns.

---

### 8. dry-cli (47M downloads, 147 stars)
**Package:** `gem install dry-cli`
**GitHub:** https://github.com/dry-rb/dry-cli

**Philosophy:** Modular CLI framework from dry-rb ecosystem. Separation of concerns.

**Strengths:**
- Excellent subcommand support
- Clean class-based structure
- Part of dry-rb ecosystem
- Pairs with dry-configurable for config
- Good separation of concerns

**Weaknesses:**
- Requires learning dry-rb patterns
- More boilerplate
- Config/env vars via separate gem

**Example:**
```ruby
module Nexum
  module CLI
    class Chat < Dry::CLI::Command
      desc "Start interactive chat"
      option :model, desc: "Model to use"

      def call(model: nil, **)
        # implementation
      end
    end
  end
end
```

**Best for:** dry-rb projects, modular architectures, strict separation of concerns.

---

### 9. cri (41M downloads, 121 stars)
**Package:** `gem install cri`
**GitHub:** https://github.com/denisdefreyne/cri

**Philosophy:** Tool for building command-line applications. Used by Nanoc.

**Strengths:**
- Full subcommand support
- Command tree structure
- Good help generation
- Battle-tested (Nanoc)

**Weaknesses:**
- Less documentation than alternatives
- Smaller community
- No config/env var support

**Best for:** Command tree structures, Nanoc-related tools.

---

### 10. thor (est. 200M+ downloads, 5.1k stars)
**Package:** `gem install thor`
**GitHub:** https://github.com/rails/thor

**Philosophy:** Powerful toolkit for building CLIs. Used by Rails, Bundler, Vagrant.

**Strengths:**
- **Most popular by stars** (5.1k)
- Used by major projects (Rails, Bundler)
- Excellent subcommand support
- Auto-generated help
- Task automation features
- Large community

**Weaknesses:**
- Known help system quirks (fixable)
- Heavier than alternatives
- Opinionated design choices

**Example:**
```ruby
class Nexum < Thor
  desc "chat", "Start interactive chat"
  option :model, type: :string, default: "sonnet"
  option :thinking, type: :boolean, default: true

  def chat
    # implementation
  end
end
```

**Best for:** Full-featured apps, task automation, when you want battle-tested tooling.

---

### 11. tty-option (1.7M downloads, 56 stars)
**Package:** `gem install tty-option`
**GitHub:** https://github.com/piotrmurach/tty-option

**Philosophy:** Declarative DSL for command-line arguments. Part of TTY toolkit.

**Strengths:**
- **First-class env var support** (unique)
- Declarative parameter DSL
- Auto-generated help
- Custom validation
- Type conversion
- Part of TTY ecosystem (already using tty-reader)

**Weaknesses:**
- Lower download count (newer)
- Limited subcommand support
- No config file support

**Example:**
```ruby
class ChatCmd
  include TTY::Option

  option :model do
    short '-m'
    long '--model string'
    desc 'Model to use'
    default 'sonnet'
  end

  flag :thinking do
    long '--thinking'
    desc 'Enable thinking'
    default true
  end

  environment :model do
    var 'NEXUM_MODEL'
  end
end
```

**Best for:** Apps needing strong env var support, TTY ecosystem users.

---

### 12. OptionParser (Ruby stdlib)
**Package:** Built-in (no install required)
**Docs:** https://ruby-doc.org/stdlib/libdoc/optparse/rdoc/OptionParser.html

**Philosophy:** Standard library option parser. Maximum control, zero dependencies.

**Strengths:**
- **Zero dependencies** (stdlib)
- No version management needed
- Full control over parsing
- Well-documented
- `order!` method enables subcommand dispatch

**Weaknesses:**
- Manual help generation
- Manual subcommand routing
- More boilerplate
- No built-in validation

**Example:**
```ruby
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: nexum [options]"

  opts.on("-m", "--model MODEL", "Model to use") do |m|
    options[:model] = m
  end

  opts.on("--[no-]thinking", "Enable thinking") do |t|
    options[:thinking] = t
  end
end.parse!
```

**Best for:** Zero-dependency projects, maximum control, stdlib-only constraints.

---

## Configuration Management Gems (Companion to CLI Parsers)

These gems complement CLI parsers by providing hierarchical configuration:

### anyway_config (148M downloads)
**Package:** `gem install anyway_config`
**GitHub:** https://github.com/palkan/anyway_config

**Features:**
- YAML files → Rails credentials → ENV vars → CLI flags
- Nested env vars via double-underscore
- Type coercion and validation
- Source tracing
- RBS type hints

**Pairs well with:** Any CLI parser for hierarchical config needs

**Example:**
```ruby
class NexumConfig < Anyway::Config
  attr_config :model, :thinking, :temperature

  required :model

  on_load do
    config.temperature ||= 1.0
  end
end

config = NexumConfig.new
config.model # => from NEXUM_MODEL env, YAML, or default
```

---

### dry-configurable (148M downloads)
**Package:** `gem install dry-configurable`
**GitHub:** https://github.com/dry-rb/dry-configurable

**Features:**
- Mixin for adding configuration
- Type checking
- Validation
- Part of dry-rb ecosystem

**Pairs well with:** dry-cli, other dry-rb gems

---

## Recommendations by Use Case

### For Nexum Specifically

**If prioritizing subcommands + config:**
- **Primary:** `gli` or `thor` (git-style subcommands)
- **Config:** `anyway_config` (hierarchical config, env vars)
- **Rationale:** Mature subcommand support + strong config hierarchy

**If prioritizing env vars + TTY ecosystem:**
- **Primary:** `tty-option` (already using tty-reader)
- **Subcommands:** Build manually with OptionParser `order!`
- **Config:** `anyway_config`
- **Rationale:** Consistency with existing TTY usage

**If prioritizing zero dependencies:**
- **Primary:** `optimist` (single file, zero deps) or OptionParser (stdlib)
- **Subcommands:** OptionParser `order!` method
- **Rationale:** No external dependencies, full control

**If prioritizing dry-rb ecosystem:**
- **Primary:** `dry-cli` + `dry-configurable`
- **Rationale:** Modular, principled design, separation of concerns

---

### General Use Cases

**Simple single-command tool:**
- **slop** or **optimist** - minimal, clean, auto-help

**Git-style subcommands (like git, docker):**
- **gli**, **thor**, or **commander** - purpose-built for this

**Task automation / generators:**
- **thor** - proven by Rails, Bundler

**Interactive CLI:**
- **highline** + any parser - menus, prompts, color

**Chef ecosystem:**
- **mixlib-cli** - mixin pattern, Chef-standard

**Object-oriented design:**
- **clamp** - command as class pattern

**Zero dependencies:**
- **OptionParser** (stdlib) or **optimist** (single file)

**Environment variable heavy:**
- **tty-option** (first-class env support) + **anyway_config**

**Modular/dry-rb:**
- **dry-cli** + **dry-configurable**

---

## Feature Support Quick Reference

### Subcommand Support
**Excellent:** thor, gli, commander, dry-cli, clamp, cri, methadone, cmdparse
**Basic:** slop, optimist, tty-option
**Manual:** OptionParser (via `order!`)
**None:** highline, mixlib-cli

### Config File Support
**Via companion gem:** anyway_config, dry-configurable (work with any parser)
**Via plugin:** gli
**None built-in:** Most parsers (use companion gem)

### Environment Variable Support
**First-class:** tty-option, anyway_config
**Via companion:** dry-configurable
**Manual:** All others

### Help Generation
**Auto from definitions:** slop, optimist, thor, gli, commander, dry-cli, clamp, cri, tty-option, methadone
**Via docstring:** docopt
**Manual:** OptionParser, mixlib-cli

### Validation
**Custom validators:** slop, clamp, dry-cli (via dry-validation), tty-option
**Type-based:** optimist, thor
**Via companion:** anyway_config, dry-configurable
**None:** OptionParser, mixlib-cli, cri, methadone

---

## Migration Notes

If migrating from minimal-sapientia's OptionParser to a gem:

**Keep similar feel:** optimist (closest to OptionParser simplicity)
**Add subcommands:** gli or thor
**Add config hierarchy:** anyway_config (works with any parser)
**Add env vars:** tty-option or anyway_config
