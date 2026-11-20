---
source: handler-errors.md (autopax/practica ideology corpus, Part II sec 4)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/autopax/docs/system-overview/instrumenta/handler-errors.md
source_commit: 033af13c5ca686ca5898645f6dc772e4435c0523
categories: [realized-interface, INSTRUMENTA, error-model, machine-readable-errors]
why_included: >
  Generated 2025-12-20. Companion to instrumenta--tool.md -- the error model of the realized tool subsystem; bears on machine-readable tool errors that teach rather than just report.
---

---
generated: 2025-12-20T17:24:20Z
title: Instrumenta::HandlerErrors
type: module
source: lib/autopax/instrumenta/handler_errors.rb:17
description: Common error response patterns for INSTRUMENTA handlers.
parent: "[[instrumenta|Instrumenta]]"
tags: [instrumenta, handler-errors]
aliases: [HandlerErrors]
methods: [directory_error, directory_not_found_error, file_not_found_error, not_a_file_error, path_not_found_error, permission_denied_error, unexpected_error, validation_error]
source_url: https://github.com/v2-io/autopax/blob/main/lib/autopax/instrumenta/handler_errors.rb#L17
---

# Instrumenta::HandlerErrors

Common error response patterns for INSTRUMENTA handlers.

This module provides standardized error responses for file system and
validation errors. By extracting these into a shared module, we:
- Reduce code duplication across handlers
- Ensure consistent error formats
- Keep handler classes focused on their core logic

### Error Format

All errors return a hash with:
- success: false
- error: Human-readable message
- error_type: Machine-readable error category
- Additional context as needed







## Methods

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
