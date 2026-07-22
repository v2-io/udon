---
source: registry.md (autopax/practica ideology corpus, Part II sec 4)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/autopax/docs/system-overview/instrumenta/registry.md
source_commit: 033af13c5ca686ca5898645f6dc772e4435c0523
categories: [realized-interface, INSTRUMENTA, tool-dispatch]
why_included: >
  Generated 2025-12-20. Companion to instrumenta--tool.md -- registration/dispatch of the realized tool subsystem.
---

---
generated: 2025-12-20T17:24:20Z
title: Instrumenta::Registry
type: class
source: lib/autopax/instrumenta/registry.rb:10
description: Registry for INSTRUMENTA tools.
inherits: "[[object|Object]]"
parent: "[[instrumenta|Instrumenta]]"
tags: [instrumenta, registry]
aliases: [Registry]
methods: ['Registry.reset!', Registry.default, anthropic_tool_definitions, find, initialize, register, register_built_in_tools, register_handlers, tool_definitions, tool_names]
source_url: https://github.com/v2-io/autopax/blob/main/lib/autopax/instrumenta/registry.rb#L10
---

# Instrumenta::Registry

Registry for INSTRUMENTA tools.

Manages tool lookup and provides the tool definitions for API requests.

### Tool Registration

Handlers are registered automatically from lib/autopax/instrumenta/handlers/.
Card-level tools (future) will be registered per-session.







## Methods

### Registry.default
Get default registry with built-in handlers

```ruby
# lib/autopax/instrumenta/registry.rb : ~13
def default = @default ||= new.tap(&:register_handlers)
```


---
### Registry.reset!
Reset default registry (for testing)

```ruby
# lib/autopax/instrumenta/registry.rb : ~16
def reset! = @default = nil
```


---
### Registry.new

⟶ `Registry` — A new instance of Registry


```ruby
# lib/autopax/instrumenta/registry.rb : ~19
def initialize = @tools = {}
```


---
### register(...)
Register a tool class.

`⟨tool_class : Class⟩` — Tool class (subclass of Tool)


```ruby
# lib/autopax/instrumenta/registry.rb : ~24
def register(tool_class) = @tools[tool_class.name] = tool_class
```


---
### find(...)
Find a tool by name.

`⟨name : String⟩` — Tool name
⟶ `Class        ` — Tool class or nil if not found


```ruby
# lib/autopax/instrumenta/registry.rb : ~30
def find(name) = @tools[name]
```


---
### tool_definitions
Get all tool definitions for API request (OpenAI format).
Portkey's /v1/chat/completions uses OpenAI-compatible format.

⟶ `Array[Hash]` — Tool definitions in OpenAI format


```ruby
# lib/autopax/instrumenta/registry.rb : ~36
def tool_definitions = @tools.values.map(&:to_openai_tool)
```


---
### anthropic_tool_definitions
Get all tool definitions in Anthropic format.
For direct Anthropic /v1/messages API calls (future use).

⟶ `Array[Hash]` — Tool definitions in Anthropic format


```ruby
# lib/autopax/instrumenta/registry.rb : ~42
def anthropic_tool_definitions = @tools.values.map(&:to_anthropic_tool)
```


---
### tool_names
List registered tool names.

⟶ `Array[String]`


```ruby
# lib/autopax/instrumenta/registry.rb : ~47
def tool_names = @tools.keys
```


---
### register_handlers
Register all handlers from the handlers directory.
Each handler class in Instrumenta::Handlers is registered.

```ruby
# lib/autopax/instrumenta/registry.rb : ~51
def register_handlers
  register(Instrumenta::Handlers::CheckUsage)
  register(Instrumenta::Handlers::ReadFile)
  register(Instrumenta::Handlers::WriteFile)
  register(Instrumenta::Handlers::Edit)
  register(Instrumenta::Handlers::Bash)
  register(Instrumenta::Handlers::Glob)
  register(Instrumenta::Handlers::Grep)
end
```


---
### register_built_in_tools
Register all handlers from the handlers directory.
Each handler class in Instrumenta::Handlers is registered.
Backward compatibility alias

```ruby
# lib/autopax/instrumenta/registry.rb : ~62
def register_handlers
  register(Instrumenta::Handlers::CheckUsage)
  register(Instrumenta::Handlers::ReadFile)
  register(Instrumenta::Handlers::WriteFile)
  register(Instrumenta::Handlers::Edit)
  register(Instrumenta::Handlers::Bash)
  register(Instrumenta::Handlers::Glob)
  register(Instrumenta::Handlers::Grep)
end
```
