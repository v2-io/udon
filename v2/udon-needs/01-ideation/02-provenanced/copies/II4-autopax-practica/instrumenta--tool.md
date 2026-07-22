---
source: tool.md (autopax/practica ideology corpus, Part II sec 4)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/autopax/docs/system-overview/instrumenta/tool.md
source_commit: 033af13c5ca686ca5898645f6dc772e4435c0523
categories: [tool-schema, realized-interface, tool-contract, INSTRUMENTA, cross-tier]
why_included: >
  Generated 2025-12-20 from lib/autopax/instrumenta/. The REALIZED base-class contract (not just ideation): tool_name / tool_schema / tool_description, per-tool instructions/*.md with Liquid templating, to_anthropic_tool / to_openai_tool. The hybrid design of tool-definition-anatomy actually built -- the highest-value single artifact for "what an agent tool interface should carry."
---

---
generated: 2025-12-20T17:24:20Z
title: Instrumenta::Tool
type: class
source: lib/autopax/instrumenta/tool.rb:32
description: Base class for INSTRUMENTA tools.
inherits: "[[object|Object]]"
parent: "[[instrumenta|Instrumenta]]"
inherited_by:
  - "[[instrumenta/handlers/bash|Instrumenta::Handlers::Bash]]"
  - "[[instrumenta/handlers/check-usage|Instrumenta::Handlers::CheckUsage]]"
  - "[[instrumenta/handlers/edit|Instrumenta::Handlers::Edit]]"
  - "[[instrumenta/handlers/glob|Instrumenta::Handlers::Glob]]"
  - "[[instrumenta/handlers/grep|Instrumenta::Handlers::Grep]]"
  - "[[instrumenta/handlers/read-file|Instrumenta::Handlers::ReadFile]]"
  - "[[instrumenta/handlers/write-file|Instrumenta::Handlers::WriteFile]]"
includes: [HandlerErrors]
tags: [instrumenta, tool]
aliases: [Tool]
methods: [Tool.description, Tool.full_description, Tool.input_schema, Tool.instructions, Tool.name, Tool.to_anthropic_tool, Tool.to_openai_tool, Tool.tool_description, Tool.tool_name, Tool.tool_schema, context, directory_error, directory_not_found_error, execute, file_not_found_error, initialize, not_a_file_error, path_not_found_error, permission_denied_error, unexpected_error, validation_error]
related:
  - "[[instrumenta/handler-errors|Instrumenta::HandlerErrors]]"
source_url: https://github.com/v2-io/autopax/blob/main/lib/autopax/instrumenta/tool.rb#L32
---

# Instrumenta::Tool

Base class for INSTRUMENTA tools.

Defines the interface for tool definition and execution.
Tools follow Anthropic's tool schema for API compatibility.

### Defining a Tool

Handlers live in lib/autopax/instrumenta/handlers/ and define their
schema at class level. Extended guidance can be provided in a
corresponding instructions/*.md file.

**Includes:** [[instrumenta/handler-errors|HandlerErrors]]

## Example

**Basic handler**

```ruby
class MyTool < Instrumenta::Tool
  tool_name 'my-tool'
  tool_description 'Does something useful'
  tool_schema(
    type: 'object',
    properties: { param: { type: 'string' } },
    required: ['param']
  )

  def execute(input)
    { success: true, result: input['param'].upcase }
  end
end
```

**With instructions file (instructions/my-tool.md)**

```ruby
The instructions file provides extended guidance to the LLM about
when and how to use the tool. It can use Liquid templating for
entity-specific customization.
```





## Attributes

`⟨context     ⟩` — (Read)
`⟨description ⟩` — (Read)
`⟨input_schema⟩` — (Read)
`⟨name        ⟩` — (Read)

## Methods

### Tool.tool_name(...)
Set the tool name (kebab-case, e.g., 'check-usage')

`⟨value⟩`


```ruby
# lib/autopax/instrumenta/tool.rb : ~39
def tool_name(value) = @name = value
```


---
### Tool.tool_description(...)
Set the tool description (short, for tool list)

`⟨value⟩`


```ruby
# lib/autopax/instrumenta/tool.rb : ~42
def tool_description(value) = @description = value
```


---
### Tool.tool_schema(...)
Set the input schema (JSON Schema format)

`⟨schema⟩`


```ruby
# lib/autopax/instrumenta/tool.rb : ~45
def tool_schema(schema) = @input_schema = schema
```


---
### Tool.instructions(...)
Load instructions from the corresponding markdown file.
Instructions provide extended behavioral guidance for the LLM.

`⟨context = {}⟩`
⟶ `String      ` — Rendered instructions or nil if not found


```ruby
# lib/autopax/instrumenta/tool.rb : ~52
def instructions(context: {}) = Instrumenta.load_instructions(name, context: context)
```


---
### Tool.full_description(...)
Get full description including instructions if available.
Falls back to just description if no instructions file exists.

`⟨context = {}⟩`
⟶ `String      ` — Full description for LLM


```ruby
# lib/autopax/instrumenta/tool.rb : ~59
def full_description(context: {})
  instr = instructions(context: context)
  return description unless instr

  "#{description}\n\n#{instr}"
end
```


---
### Tool.to_anthropic_tool(...)
Convert to Anthropic API tool definition format.

`⟨context = {}⟩`
⟶ `Hash        ` — Tool definition for Anthropic /v1/messages API


```ruby
# lib/autopax/instrumenta/tool.rb : ~70
def to_anthropic_tool(context: {})
  {
    name:         name,
    description:  full_description(context: context),
    input_schema: input_schema
  }
end
```


---
### Tool.to_openai_tool(...)
Convert to OpenAI API tool definition format.
Portkey's /v1/chat/completions endpoint uses OpenAI format.

`⟨context = {}⟩`
⟶ `Hash        ` — Tool definition for OpenAI-compatible API


```ruby
# lib/autopax/instrumenta/tool.rb : ~83
def to_openai_tool(context: {})
  {
    type:     'function',
    function: {
      name:        name,
      description: full_description(context: context),
      parameters:  input_schema
    }
  }
end
```


---
### Tool.new(...)

`⟨context = {}⟩`
⟶ `Tool        ` — A new instance of Tool


```ruby
# lib/autopax/instrumenta/tool.rb : ~103
def initialize(context: {}) = @context = context
```


---
### execute(...)
Execute the tool with given input.

`⟨input : Hash⟩` — Tool input matching input_schema
⟶ `Hash        ` — Result with :success and either :result or :error


```ruby
# lib/autopax/instrumenta/tool.rb : ~109
def execute(input) = raise NotImplementedError, "#{self.class} must implement #execute"
```


---
### validation_error(...)
Validation errors

`⟨field_name⟩`


```ruby
# lib/autopax/instrumenta/handler_errors.rb : ~19
def validation_error(field_name) = { success: false, error: "#{field_name} is required", error_type: 'ValidationError' }
```


---
### file_not_found_error(...)
File system errors

`⟨path⟩`


```ruby
# lib/autopax/instrumenta/handler_errors.rb : ~22
def file_not_found_error(path) = { success: false, error: "File not found: #{path}", error_type: 'FileNotFound' }
```


---
### directory_not_found_error(...)

`⟨path⟩`


```ruby
# lib/autopax/instrumenta/handler_errors.rb : ~24
def directory_not_found_error(path) = { success: false, error: "Directory not found: #{path}", error_type: 'DirectoryNotFound' }
```


---
### path_not_found_error(...)

`⟨path⟩`


```ruby
# lib/autopax/instrumenta/handler_errors.rb : ~26
def path_not_found_error(path) = { success: false, error: "Path not found: #{path}", error_type: 'PathNotFound' }
```


---
### not_a_file_error(...)

`⟨path⟩`


```ruby
# lib/autopax/instrumenta/handler_errors.rb : ~28
def not_a_file_error(path) = { success: false, error: "Path is not a file: #{path}", error_type: 'NotAFile' }
```


---
### directory_error(...)

`⟨path⟩`


```ruby
# lib/autopax/instrumenta/handler_errors.rb : ~30
def directory_error(path) = { success: false, error: "Cannot operate on directory: #{path}", error_type: 'IsDirectory' }
```


---
### permission_denied_error(...)

`⟨path⟩`


```ruby
# lib/autopax/instrumenta/handler_errors.rb : ~32
def permission_denied_error(path) = { success: false, error: "Permission denied: #{path}", error_type: 'PermissionDenied' }
```


---
### unexpected_error(...)
Generic unexpected error

`⟨error⟩`


```ruby
# lib/autopax/instrumenta/handler_errors.rb : ~35
def unexpected_error(error) = { success: false, error: "Unexpected error: #{error.message}", error_type: error.class.name }
```
