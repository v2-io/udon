# Warning / error code vocabulary (sketch)

**Status:** authoring sketch for **W4** (SPEC lists vocabulary; generator derives and must agree).  
**Not** a frozen registry. Codes below are **working names** for fixtures until descent + SPEC lock.

| Working code | Severity (L0) | Situation |
|--------------|---------------|-----------|
| `UnclosedString` | Warning | Delimited quote open at EOF / early close |
| `UnclosedArray` | Warning | `[` open without `]` |
| `UnclosedEmbedded` / `UnclosedInlineElement` | Warning | `\|{` unclosed |
| `UnclosedInterpolation` | Warning | `!{{` unclosed |
| `UnclosedFreeform` / `UnclosedFence` | Warning | Fence unclosed |
| `UnclosedTypeEnvelope` | Warning | `<` unclosed |
| `UnclosedIdentityKey` | Warning | Identity `[` → `$partial-key` (**R5**) |
| `UnclosedInlineDirective` | Warning | `!{name` form unclosed (**R13**) |
| `UnclosedInlineRaw` | Warning | `!{:kind:` unclosed (**R13**) |
| `RootLevelAttribute` | Warning | Line-initial `:key` no owner (**L1**) |
| `WarnedExtension` | Warning | Material after finished attr on attr-rooted line |
| `LateAttribute` / `ContentPhaseAttribute` | Warning | `:` after content began |
| `AttrUnderAttr` | Error | `:key` under open value (**L6**) — value absent as structure; text keep |
| `MissingAttributeValue` | Error | Plain `:key` no value → Nil (**R6**) |
| `TabInIndentation` | Warning | Tab in indent; content kept (**L4**) |
| `InconsistentIndentation` | Warning | Prose re-base (**S4** open if prose-only) |
| `NoDialectsLoaded` | Warning | Envelope with no dialect (**R13** interim) |

**Derivation rule (W4):** generator SHOULD derive `Unclosed<Construct>` from grammar construct names; SPEC table is the human-facing vocabulary; drift is a bug in one of the two.

Fixtures may use `note:` until codes lock.
