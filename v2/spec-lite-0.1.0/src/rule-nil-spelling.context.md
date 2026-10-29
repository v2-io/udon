# Context: [[rule:nil-spelling]]

*History and provenance for the card beside it. Not spec text and not a record; nothing here binds.*

- **2026-10-09, `nil` chosen.** Earlier drafts typed both `null` and `nil`. Joseph: "let's go ahead and make 'nil' the only spelling for nil/null. I like null better semantically, but nil is less clunky lexically :-).  Now the deterministic typing just got a even tighter." A bare `null` was then an error.
- **2026-10-21, the other spelling warns instead of erroring.** Joseph: "null as text should cause a warning, not an error, IMO."
- **2026-10-28, the value trial** (`.int/trial-values-2026-10-28/RESULTS.md`): every agent working from a one-page basics sheet wrote `:owner null` untaught; the spec-primed ones wrote `nil` only because the cards said so. The coordinator, asked whether it really thought `nil` was right, leaned `null`: it's the spelling of every text data format that has one (JSON, YAML, HCL, CUE, CBOR; KDL v2 `#null`), while `nil` is the Ruby, Go, Lisp and Swift family.
- **2026-10-29, switched to `null`.** Joseph: "I'll always be comfortable changing something by fiat to fit my own preferences -- please go ahead and switch it to null if that's a bit more honest to a cold read by you-- I appreciate the unity in shared intent regardless."
- The slug still says `nil`; rename with the next vocabulary sweep.
