# WIRE — recognition event stream (0.10 / v2-spec)

**Status:** **provisional skeleton** — not full suite prose; not a frozen event enum.  
**Role:** Normative *contract* for consumers of the recognition product: the event stream plus recognition-verdict under **sufficiency / no-reachback**.  
Implementation-facing (engines, harness, fixtures, tools) but **normative** for any consumer of that stream.  
**Not this document:** surface syntax → SPEC (when authored); document shape → [ADM.md](ADM.md); stage names → [PIPELINE.md](PIPELINE.md); equivalence layers → [SEMANTICS.md](SEMANTICS.md).  
**Authority:** [DECISIONS.md](DECISIONS.md) **W0**, **W1d**, **W2**–**W5**,  
**C5**, **C6**, **R1**, **R8**, **R12** (and related CARRY). Encoding detail still open → [OPEN.md](OPEN.md) **W1e**, **ML**.  
**How to read:** Law sentences are load-bearing. Working spellings (e.g. `AttrValueEnd`) are *illustrations*, not final vocabulary. **TODO** / OPEN markers are honest holes — do not invent event names to fill them.

Requirement words MUST / SHOULD / MAY follow RFC 2119 when used below.

---

## 0. Place in the pipeline

```text
bytes
  → recognition engines [pushdown | RD]   # same event vocabulary
  → event stream + recognition-verdict    # ← this contract
  → assembly → resolution → evaluation
  → products (ADM, resolved model, host artifacts, …)
```

- **One wire vocabulary** for recognition output. Two engines MAY emit it; pairing with downstream modes is free ([PIPELINE.md](PIPELINE.md)).
- **Fold** is not an architecture noun. A harness “reference reconstruction” (pure walk of the stream into an ADM slice) is a **test artifact** for sufficiency — not a second product channel and not a second event stream.
- Assembly, resolution, and evaluation are **stages**, not additional wires.

---

## 1. Sufficiency / no-reachback (**W0**)

### 1.1 Normative sentence

**At every stage boundary, the product of a stage MUST suffice for the next stage without reachback into earlier products.**

For recognition → assembly (the first and hardest instance of this law):

> **The event stream plus recognition-verdict MUST make recoverable, by pure recovery over that product alone, every ADM distinction assembly needs — ownership, attribute values and their extents, text, anomalies, and incomplete-input status — without consulting source bytes, re-deriving indent or attr-vs-child geometry, or consulting spans as a correctness channel.**

If assembly (or a harness reconstruction used as the sufficiency test) must re-run indent analysis, re-consult source to decide who owns a text run, or infer a value’s end from the *absence* of a later event, recognition has failed sufficiency.

### 1.2 Partial instance and exhibit

| Instance | What it pins |
|----------|----------------|
| **Text-wire (**R1**)** | Partial instance of W0 for *text*: pure in-order concat of text-bearing events reconstructs document text; no source, no fabricated joiners. |
| **Flat Attr wire deratification (**R8**)** | Exhibit of *failure*: value extent inferred from absence of re-emitted `Attr` / BareValue-vs-Text ownership cues. Consumers had to re-derive logic the recognizer already ran. See CHANGELOG DERATIFIED 2026-07-19. |

Stage *payloads* (exactly which fields each product carries for paths, dialects, schema, fmt, …) remain demand-shaped until spikes promote them ([PIPELINE.md](PIPELINE.md); OPEN / spikes). W0 constrains *whether* a distinction is recoverable from the product, not the full field list of every future product.

### 1.3 What “pure recovery” means

- Recovery is a function of **(event stream, recognition-verdict)** only.
- Spans / source maps MAY exist for Host tooling (editors, diagnostics). They MUST NOT be required to recover ADM *model* distinctions.
- Ornamental geometry disposition (PIPELINE ornamental criterion) MAY be left to assembly / SEMANTICS where it does not change ownership, values, or text content — see §5.

---

## 2. Recognition product shape

```
RecognitionProduct := {
  events:   [Event]                 // ordered; vocabulary not frozen here
  verdict:  complete | incomplete-input
  // anomalies: either as events in-stream, or carried with the assembly product
  //             — packaging TODO with C5 fixtures; both must be recoverable
}
```

Packaging with ADM’s preferred `Document.result` field ([ADM.md](ADM.md) §1.1) MUST remain information-equivalent: incomplete-input is the same fact whether surfaced as `verdict` on the stream product or `result` on the assembled Document.

---

## 3. Recognition-verdict channel (**C6**, **R2**)

| Term | Use on the wire |
|------|-----------------|
| **Anomaly** | Per-construct record (warning / error): content kept or something lost. |
| **Verdict** | Stage-level outcome. For recognition: **`complete`** or **`incomplete-input`**. |

**Incomplete-input is not an event.** Fixtures that need it carry a **recognition-verdict** field (e.g. `result: incomplete` / `verdict: incomplete-input`). Do not encode incomplete-input as a stream event that a fold might “miss.”

Rules carried for the verdict (**R2**):

- `incomplete-input` iff at least one **delimited** extent is still open at *true* end of input.
- Geometric (positional) constructs close silently at EOF; they do not by themselves flip the verdict.
- Warnings and errors do **not** flip the verdict by themselves.
- Unclosed delimited constructs: keep content + anomaly; emission order (**R12**): content → unclosed-marker → end (working names provisional).

Halt / reject after anomalies remains **Consumer menu** (**R11**), never encoded as “the stream stopped being a document.”

---

## 4. Self-delimiting attribute values (**W1d**, **R8**)

### 4.1 Requirement (law)

**Attribute values on the wire are self-delimiting:** the extent of a value is explicit in the stream. A consumer MUST be able to determine where a value ends without inference from what follows (no “value continues until the next Attr / until BareValue becomes Text / until indent suggests child content”).

Inference-only extent remains **void** (**R8**). The deratified flat Attr encoding (one value per `Attr`, multiplicity via re-emitted `Attr`, end inferred by absence) MUST NOT be reintroduced as law.

### 4.2 Working illustration (not final spelling)

Exact event names and bracketing scheme are **OPEN W1e** (WAIT-DEMAND). Until that closes, the following is a **working illustration** of the *shape* the law forces — example spelling only:

```text
… Attr  <value events…>  AttrValueEnd  …
```

- An attribute open is followed by **exactly its value** as an explicitly bounded region.
- The value’s end is a **printed** (or otherwise explicit) extent marker in the stream — not the silence after the last value-ish event.
- Multiplicity remains **stacked Assignments** in the ADM sense (further Attr regions under the same key), not multi-segment values glued by re-emit inference.
- Mixed interpolation inside a value (e.g. flow with `!{{…}}`) is a *value* under the bracket; flat-wire “re-emitted Attr segments” encoding of that case is void with R8.

Symmetric `AttrStart` / `AttrValueEnd` (or other explicit pairs) are equally fine as spellings once W1e lands. **Do not treat `AttrValueEnd` as ratified vocabulary.**

### 4.3 Phasing (**W2**)

Wire refresh is **phased**:

1. **First:** value-extent fix (this section) — unblocks attribute-layer grammar work.
2. **Backlog (named, not frozen here):** broader Text-role / event-vocab refresh; typed-value surface cleanup; formalism notes. Prefer **one Text**
   + enclosing brackets for role (**W5**); escalate to distinct text roles only if assembly still cannot classify after brackets exist.

---

## 5. What the wire MUST make recoverable vs MAY leave to assembly

### 5.1 MUST be recoverable from (events, verdict) alone

These are ADM distinctions assembly needs without source reachback:

| Distinction | Notes / cite |
|-------------|--------------|
| **Element / attribute ownership** | Who owns a value or text run (attr value vs element content). Forced by W0 + W1d; flat-wire failure mode is the exhibit (**R8**). |
| **Attribute value extent and content** | Self-delimiting region; stacked Assignments preserved as separate extents. |
| **Text content** | Per **R1** (§6); prose vs geometry split recoverable. |
| **Structure open/close and nesting** | Enough to build the forest / tree without re-indent analysis. |
| **Anomalies** | Severity + enough identity to journal (codes: **W4** — SPEC vocabulary + generator derivation; must agree). |
| **Incomplete-input** | Via **verdict**, not event (**C6**). |
| **Unclosed disposition** | Content kept; order content → unclosed → end (**R12**); names provisional. |
| **Designated-sugar outcomes needed for model** | e.g. unclosed identity → `$partial-key` not `$key` (**R5**) as model fact — whether as structured events or equivalent recoverable form. |
| **Reference payload (interim)** | Enough to assemble ADM Reference shape; **interim raw** after `@` is allowed for first gate (**W3**). |

### 5.2 MAY be left to assembly (or later stages)

| Concern | Where it lives |
|---------|----------------|
| **Ornamental disposition** | Blanks / extra indent steps that a double round-trip may drop without changing the model (PIPELINE ornamental criterion). Placement of BlankLine vs dedent (**S9**) — consumers follow SEMANTICS / ornamentation, not stream order alone. |
| **Stacking close / phase-local glue** | Combining adjacent pure Text; closing attribute phase → content phase as model phase (extent-local assembly job per PIPELINE). |
| **Document-wide policies** | Duplicate definitions (**R14**), ref resolution menus, dialect load — **resolution**, not wire. |
| **Host projection** | Native types, liquid run, etc. — **evaluation**. |
| **Source maps / columns for every byte** | Host tooling; not required for model recovery. |
| **Sugar vs longhand presentation** | Model carries Assignments; faithful vs data serializers are SEMANTICS layers. |

Assembly MUST NOT need source to decide anything in §5.1. Assembly MAY apply policy that is explicitly out of the recognition product (ornament, document menus) without violating W0.

---

## 6. Text reconstruction contract (**R1**) — for wire consumers

Restated for consumers of the event stream (ADM §5.1 is the model-side twin):

> **Document text reconstructs by pure in-order concatenation of the stream’s text-bearing events. No spans. No source. No fabricated join characters.**

- A blank/newline-only unit on the wire that is defined as text-bearing (working name `BlankLine` in CARRY) contributes exactly `"\n"` (**R1**).
- Line terminators that are part of prose / verbatim body ride as text; indentation stripped by dedentation and pure structure markers are **geometry**, not text.
- Inline comments contribute no text; comment content does not carry its enclosing line’s terminator as text (CHANGELOG TEXT-WIRE).
- Adjacent pure Text segments MAY be flattened by assembly; concatenation is associative.
- Freeform / fence bodies remain exact bytes (each body line keeps its terminator) when carried as text-bearing content.

A wire encoding is adequate for text only if this invariant is recoverable from the stream alone — the text half of **W0**.

---

## 7. Explicitly out of scope (this skeleton)

| Out | Why / where instead |
|-----|---------------------|
| **Full event enum freeze** | Not day-one law. W2 phases vocab; OPEN **W1e** owns Attr encoding; do not invent a closed table here. |
| **Reference structured encoding details** | **W3**: interim **raw** after `@` for first gate; structured form when shared identity machinery makes it cheap. Paths spike may demand more — promote via PROCESS, not silent WIRE growth. |
| **Per-construct multi-line policy** | OPEN **ML** (WAIT-DEMAND). Wire must eventually carry whatever extents SPEC defines; it does not invent them. |
| **Warning code registry text** | **W4** direction (SPEC vocab + generator derivation); concrete table not this skeleton. |
| **Surface syntax / scan / guards** | SPEC. |
| **ADM field packaging choices** | ADM + C5 fixtures (e.g. `result` on Document vs triple). |
| **Old flat Attr wire** | Deratified (**R8**); historical only (`spec/msc/CHANGELOG.md`). |

Working event names from 0.9 CARRY (`Unclosed*`, `BlankLine`, `Text`, …) remain **provisional spellings** until a vocab pass under W2/W1e. Implement toward behavior; do not cement spellings as the 0.10 contract without an explicit close.

---

## 8. Fixture profiles (**C5**) + verdict (**C6**)

Fixtures assert **events and/or assembly (ADM) product** where useful, with profiles:

| Profile | Asserts | Normative? |
|---------|---------|------------|
| **idiomatic** | Typical happy-path product | normative intent for “usual” docs |
| **comprehensive** | Broader edge coverage of product + events | normative coverage |
| **descriptive** | Raw or partial events / diagnostics | **non-normative** / diagnostic |

Recognition-verdict fields pair with these profiles under **C6** (preferred fixture field: `result: complete | incomplete-input`). Assertions target the recognition product under **W0**, not source-consulting compensators.

**Design notes (case shape, wire-twin pattern, ownership probes, harness constraints):** [FIXTURES.md](FIXTURES.md). That file is authoring design — not a second wire law.

---

## 9. Open holes (do not silent-fill)

| ID / hole | Status |
|-----------|--------|
| **W1e** — exact Attr value event encoding / token names | WAIT-DEMAND |
| **ML** — multi-line / line-bound policy per construct | WAIT-DEMAND |
| Full event vocabulary + Text-role refresh | W2 backlog |
| **W3** structured refs (beyond interim raw) | when identity machinery shared / paths demand |
| **W4** concrete warning-code table | SPEC + generator |
| Anomaly packaging (in-stream vs side channel vs both) | align with C5 / FIXTURES |
| BlankLine vs dedent placement | **S9** deferred |
| Document packaging (`result` vs triple) | **D-pack** preferred; equiv APIs OK |

---

## Pointers

| Doc | Role |
|-----|------|
| [DECISIONS.md](DECISIONS.md) | W0, W1d, W2–W5, C5, C6, R1, R8, R12 |
| [OPEN.md](OPEN.md) | W1e, ML, residual |
| [PIPELINE.md](PIPELINE.md) | Stages, sufficiency sketch, ornamental criterion |
| [ADM.md](ADM.md) | Model distinctions the wire must support |
| [SEMANTICS.md](SEMANTICS.md) | Equivalence layers (recognition identity includes events + verdict) |
| [GLOSSARY.md](GLOSSARY.md) | Suite nouns; wire names not smuggled as Core language nouns |
| `../spec/msc/CHANGELOG.md` | DERATIFIED flat Attr exhibit; TEXT-WIRE R1 |
