---
source: built-in.md (autopax/practica ideology corpus, Part II sec 4)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/autopax/docs/system-overview/instrumenta/built-in.md
source_commit: 033af13c5ca686ca5898645f6dc772e4435c0523
categories: [realized-interface, INSTRUMENTA, tool-suite]
why_included: >
  Generated 2025-12-20. Companion to instrumenta--tool.md -- the built-in tools shipped in the realized subsystem.
---

---
generated: 2025-12-20T17:24:20Z
title: Instrumenta::BuiltIn
type: module
source: lib/autopax/instrumenta.rb:77
description: DEPRECATED: Built-in namespace kept for backward compatibility
Use Instrumenta::Handlers instead
parent: "[[instrumenta|Instrumenta]]"
tags: [instrumenta, built-in]
aliases: [BuiltIn]
methods: [BuiltIn.const_missing]
source_url: https://github.com/v2-io/autopax/blob/main/lib/autopax/instrumenta.rb#L77
---

# Instrumenta::BuiltIn

DEPRECATED: Built-in namespace kept for backward compatibility
Use Instrumenta::Handlers instead







## Methods

### BuiltIn.const_missing(...)

`⟨name⟩`


```ruby
# lib/autopax/instrumenta.rb : ~78
def self.const_missing(name)
  if Instrumenta::Handlers.const_defined?(name)
    warn "Instrumenta::BuiltIn::#{name} is deprecated, " \
         "use Instrumenta::Handlers::#{name} instead"
    Instrumenta::Handlers.const_get(name)
  else
    super
  end
end
```
