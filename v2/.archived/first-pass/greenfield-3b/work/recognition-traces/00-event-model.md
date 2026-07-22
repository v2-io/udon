# Hypothetical event model (exploratory)

**Not normative.** The greenfield suite deliberately omits wire/event design. This vocabulary exists so the traces in this directory can be *compared*. A future real stream may rename, fuse, or reorder events — the point is the **information and ownership decisions**, not the spelling.

## Design goals for this sketch

1. **Streaming-friendly:** start/end frames; no need for the whole document in hand.
2. **ADM-aligned:** a Document-layer consumer can build [MODEL.md](../../new-spec/MODEL.md) by stacking events.
3. **Anomalies inline:** warnings/errors appear when recognized, with a span hint.
4. **Sugar already expanded:** identity/traits/suffixes show up as ordinary `attr` events on `$…` keys (or we note desugar as a logical step).

## Event catalog

| Event | Fields (sketch) | Meaning |
|-------|-----------------|--------|
| `doc_start` / `doc_end` | | Document bounds |
| `elem_start` | `name?`, `col` | Open Element at Base Column |
| `elem_end` | | Close Element |
| `attr` | `key`, `value` | One AttributeAssignment (Stacking = multiple `attr` same key) |
| `attr_open` | `key` | Optional: value not finished yet (deferred / multi-line) |
| `attr_seg` | `value` | Segment under open attr (warn-ingest or deferred body) |
| `attr_close` | | Finish open attr |
| `text` | `s` | Prose / Flow text segment (post-dedent when from block prose) |
| `inline_start` / `inline_end` | `name?` | Inline Element `|{…}` as content or flow segment |
| `flow_start` / `flow_end` | | Optional brackets around a multi-segment Flow Value |
| `ref` | `name?`, `key?`, `traits[]` | Reference (inert) |
| `comment` | `form`, `body` | Comment retained |
| `interp` | `expr` | Interpolation `!{{…}}` |
| `verbatim` | `form`, `label?`, `body` | Verbatim family |
| `directive_start` / `directive_end` | `name`, `raw?` | Dynamics block |
| `warn` / `error` | `code`, `msg`, `at?` | Anomaly (does not halt) |
| `incomplete` | | Doc-level flag: delimited open at true EOF |

### Value encoding in traces

Written in a compact literal form:

| Written | Meaning |
|---------|---------|
| `Int(42)` | integer |
| `Float(3.14)` | float |
| `Bool(true)` | boolean |
| `Nil` | null/nil |
| `Str("…")` | string (shown with escapes as needed) |
| `List[…]` | list value |
| `Env(body=…)` | unresolved envelope (raw interior) |
| `Node(…)` | summarized node value (or expanded as nested elem events) |
| `Flow[…]` | flow segments |
| `Ref(…)` | reference |

Nested node values are usually shown as nested `elem_start…elem_end` *inside* the logical attribute value, or as a one-line `Node` summary when the point of the trace is ownership, not deep structure.

## Stream shape (typical element)

```text
elem_start name=el col=0
  attr key=a value=Int(1)
  text "prose"
  elem_start name=child col=2
  elem_end
elem_end
```

Indentation in traces is for humans only.

## Fidelity levels used below

| Tag | Meaning |
|-----|---------|
| **L1** | Final ADM-shaped event list (what Document layer needs) |
| **L2** | L1 + decision notes (why ownership went that way) |
| **L3** | Cursor-ish narrative (token-by-token); used sparingly |

Default for each snippet is **L2**.
