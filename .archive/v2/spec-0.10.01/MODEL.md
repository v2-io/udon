# The UDON Document Model (ADM) — 0.10.1-draft

**Status: PROPOSAL DRAFT** (suite banner in [CORE.md](CORE.md) governs). What recognition produces. Unchanged from 0.10.0 MODEL except where the deferred unification reaches; unchanged sections are carried by condensed restatement — 0.10.0 MODEL remains the nuance-carrier until ratification.

## 1. Document *(carry)*

`Document = { content: [Node], anomalies: [Anomaly], result: complete | incomplete-input }` — unchanged.

## 2. Nodes

```
Node = Element | Text | Annotation | Capture | Generator
     | Reference | BlankLine
```

- **Annotation** replaces the Comment kind by rename only (form/body structure carried; attached-vs-positional both representable as today).
- **Generator** replaces Directive: `{ name, assignments, content }` — *an element shape plus the species mark*; there is no separate head string (DELTAS 2).
- **Capture** replaces Verbatim and absorbs the unresolved Envelope: `{ geometry: value|block|fence|inflow, vocab: String?, kind: String?, body: String }` — the body always lexical (recognition never construes).
- Interpolation is gone as a kind (DELTAS 1).

## 3. Element and Assignment *(carry)*

`Element = { name?, assignments, content }`; `Assignment = { label, content: [Item] }`; stacking is the model; designated attributes; sugar-born-finished; `$partial-key`; recommended host views; the default collection read — all carry unchanged from 0.10.0 MODEL §3.

## 4. Values

```
Value  = Scalar | Reference | HeldReference | Generator | Capture
       | NodeValue | TextValue
Scalar = String | Integer | Float | Boolean | Nil | List
Reference     = { head: Head, cardinality: {min,max}, partial: Boolean }
HeldReference = { reference: Reference }        ; the value IS the artifact (DELTAS 5)
Head          = the recognized selector subset, or a delimited raw head
                carried whole for the addressing-theory grammar (CORE §9.1)
TextValue     = [Segment]
Segment       = Text | InlineElement | Reference | InlineGenerator | Capture
```

- `cardinality` defaults to `{1,1}`; recognition records it and never enforces it (DELTAS 6).
- A `partial` reference (truncated head) MUST be excluded from determination by every consumer — the `$partial-key` discipline generalized.
- The model never holds a determined value: no resolution results, no evaluation output, no construed capture. Those exist only in consumer space, each carried with its resolution path there (def-resolution) — the model's adequacy test is that a consumer *could* determine from what it carries.

## 5. Annotation *(carry, renamed)*

Carried, never interpreted; interior opaque (the spelling of anything); stripping is a view. Structure as in 0.10.0 MODEL §5.

## 6. Text and the text law *(carry)*

Pure in-order concatenation; assignments (`$main` included) are not text material; dedentation is geometry; blank-line and final-terminator rules — all carry unchanged. Segment inventory per §4 (embedded references contribute no text until determined; a held span contributes no text — it is a value/segment, not prose).

## 7. Anomalies *(carry, minus resolution-side rows)*

Two severities by loss; sole core Error = missing required value; resolution-side conditions are not anomalies (DELTAS 8). Code spellings remain working names.

## 8. What the model deliberately excludes *(carry, extended)*

Wire/event encoding; resolution and evaluation results; construal; constraint; Markdown; per-byte spans — and now explicitly: **origins, moments, and schedules** (properties of uses, not of the artifact — CORE §9.4).
