# Fixture design notes (0.10 / v2-spec)

**Status:** design notes only — **no harness yet**, no compliance gate.  
**Law:** [DECISIONS.md](DECISIONS.md) **C5**, **C6**, **D-pack**, **W0**, **R1**, **R2**.  
**Product shapes:** [ADM.md](ADM.md) §1 · [WIRE.md](WIRE.md) §2–3 · [SEMANTICS.md](SEMANTICS.md).  
**Not law:** invented event spellings below; OPEN **W1e** owns Attr encoding.

These notes exist so the suite can assert **sufficiency** (events + verdict →
assembly) before any new Rust harness lands. Old `core/fixtures/v0.9/` is a
**mining source and differential oracle** (**C4**), not the 0.10 contract.

---

## 1. Why fixtures are the operational contract

When a suite ships for a claimed version, **passing it is the operational
definition of compliance** ([SPEC.md](SPEC.md) §1.1). Prose without fixtures is
an unfinished contract; fixtures without profiles re-create the 0.9 failure
modes:

| Failure mode | How it showed up | Guard |
|--------------|------------------|--------|
| Stream-looks-right | Event lists green while fold needed source | Assert **assembly/ADM** where useful (**C5**) |
| Harness compensator | Span-gap fold masked newline-drop wire | Recovery = pure function of **(events, verdict)** only (**W0**) |
| Incomplete-input invisible | Interior close vs EOF open wire-identical | **`result` / verdict field** on the case (**C6**) |
| Descriptive pins as law | Undefined multi-line pinned as compliance | Explicit **profile** tags |

---

## 2. Profiles (**C5**)

Every case carries a **profile**. Profiles are not severity of the *input* —
they are the **assertion contract** the harness (and humans) apply.

| Profile | Asserts | Normative for compliance? | Typical use |
|---------|---------|---------------------------|-------------|
| **idiomatic** | Happy-path ADM (and events when cheap) for usual authoring | **Yes** — core gate material | Cheatsheet shapes, designated sugar, simple attrs |
| **comprehensive** | Edges: ownership, stacking, unclosed, root oddities, phase doors | **Yes** — denser gate material | Ownership tables, L0/L1/L4/L6, R2 twins |
| **descriptive** | Current / provisional product for **undefined or OPEN** space | **No** — diagnostic / regression pin only | OPEN **ML** strawmen, exploratory spans |

### 2.1 Profile rules

1. **Gate sets** load only `idiomatic` + `comprehensive`. Descriptive never
   flips a version gate red/green by itself.
2. A **descriptive** case MUST name the open hole it pins (`open: ML`,
   `open: W1e`, …) so a future close can reclassify or delete without drama.
3. **Idiomatic** cases SHOULD be readable as teaching material (short `udon`,
   one idea). Dense combinatorics belong in **comprehensive**.
4. The same surface string MAY appear under two profiles only if the
   *assertion slice* differs (e.g. events-only descriptive twin of an ADM
   comprehensive case). Prefer one case with dual assertion when both are
   normative.

### 2.2 What each profile asserts (minimum)

| Profile | MUST have | MAY have | MUST NOT require |
|---------|-----------|----------|------------------|
| idiomatic | `adm` (or equiv recoverable model slice) **or** events that uniquely determine ADM under the suite’s reference assembly | events, anomalies | Source reachback; host projection |
| comprehensive | Same as idiomatic **plus** `result` when the case can differ from a wire twin; anomalies codes/shapes where law names them | partial event lists; open-stack notes | Hidden harness policy outside W0 |
| descriptive | At least one of: events, adm, anomalies, notes | `result` | Claiming the pin is 0.10 law |

**Reference assembly** (harness-internal): the pure audited events→ADM step
used for W0/C5 — not “the fold” as an architecture noun for hosts. Hosts may
assemble however they like if information-equivalent.

---

## 3. Recognition-verdict field (**C6**, **D-pack**, **R2**)

### 3.1 Field name

Suite cases use:

```yaml
result: complete            # default if omitted on idiomatic/comprehensive
# or
result: incomplete-input
```

Alias allowed in authoring notes: `verdict: incomplete-input` (same fact as
WIRE `RecognitionProduct.verdict` / ADM `Document.result`). The **preferred
fixture spelling** is `result:` so case files align with **D-pack**.

### 3.2 When to set incomplete-input

`result: incomplete-input` **iff** at true EOF at least one **delimited**
extent is still open (string/quote, brace forms that require a closer,
unclosed type envelope, etc. — whatever SPEC marks delimited). Geometric
constructs closing at EOF do **not** flip the verdict (**R2**).

Warnings and errors alone do **not** flip `result`.

### 3.3 The wire-twin pattern (load-bearing)

Interior-newline closes can be **event-identical** to at-EOF unclosed twins
yet differ in document result. That distinction is **untestable** without a
verdict field (0.9 infrastructure flag in `eof_delimited.yaml`). Every such
pair MUST be authored as twins:

```text
case A  — interior close path → result: complete   (+ maybe Warning)
case B  — same openers at true EOF → result: incomplete-input (+ Warning)
```

If events match and `result` is not asserted, the suite cannot enforce R2.

### 3.4 Incomplete-input is not an event

Do **not** invent `IncompleteInput` (or similar) as a stream event that
assembly might miss. Anomalies for unclosed constructs remain per-construct
Warnings; the document-level fact is only `result`.

---

## 4. Case shape (authoring sketch)

Not a frozen schema — a **working** YAML shape the future harness can grow
into. Fields marked † are profile-conditional.

```yaml
- id: own_element_tail_is_content          # stable id; snake_case
  profile: comprehensive                  # idiomatic | comprehensive | descriptive
  desc: finished attr on element-rooted line → tail is element content
  udon: |
    |el :a 1 rest
  result: complete                        # † required when non-default or twin
  # open: ML                              # † descriptive only — named hole
  # root_only: true                       # when wrap/indent mutations would lie
  events:                                 # optional under C5; preferred when
    # … provisional spellings OK until W1e freezes Attr region …
  adm:                                    # preferred product assertion
    content:
      - element:
          name: el
          attrs:
            - { key: a, value: 1 }        # illustration only
          content:
            - text: "rest"
  anomalies: []                           # or list of { severity, code, … }
```

### 4.1 Field discipline

| Field | Rule |
|-------|------|
| `id` | Unique within the 0.10 group; never reuse for a different law claim |
| `profile` | Required once harness lands; notes authors should set it now |
| `udon` | Exact bytes under test (prefer final newline discipline explicit) |
| `result` | Omit only when `complete` is obvious **and** no wire-twin exists |
| `events` | Ordered; **provisional names** until W1e / W2 vocab freeze |
| `adm` | Information slice only — not a host AST dump |
| `anomalies` | Codes from SPEC vocabulary when known (**W4**); severity per **L0** |
| `root_only` | True when document-root or EOF truncation must not be re-wrapped |
| `open` | Descriptive only: OPEN id or short hole name |

### 4.2 What assertions must never do

- Consult **source bytes** after recognition to decide ownership or text.
- “Fix up” expected events with span gaps, EOF newline invention, or indent
  re-analysis (the old compensator class).
- Treat **descriptive** pins as version-gate failures.
- Encode incomplete-input only as a Warning event and call R2 covered.

### 4.3 Dual assertion (events + ADM)

**C5** prefers both when useful:

- **Events** catch wire honesty (self-delimiting values **W1d**, order **R12**,
  text concat **R1**, unclosed order).
- **ADM** catches assembly meaning (ownership, stacking multiplicity,
  `$partial-key` vs `$key`, Content Phase).

If only one is affordable for a case, prefer **ADM for idiomatic** and
**events (+ result) for incomplete / unclosed comprehensive** pairs — agents
and tools bind to different stage products (agent-utility P-A / P-B).

---

## 5. Suite layout (**landed**, post-dedup)

```text
v2-spec/fixtures/           # authoring home until cutover (P1); not cargo gate yet
  README.md · INDEX.md
  idiomatic/{smoke,happy}.yaml
  comprehensive/{ownership,incomplete,closed_law}.yaml
  descriptive/ml-open.yaml
```

Live gate remains `core/fixtures/v0.9/` (**C4**). Do not intermingle. At
cutover, promote or re-home as `core/fixtures/v0.10/` under the same profiles.
Full index: [fixtures/INDEX.md](fixtures/INDEX.md).

Versioning: a conformance claim names the version whose fixture group it
passes ([SPEC.md](SPEC.md) §1.2).

**Law check (2026-07-21):** unclosed identity `[` → `$partial-key` + Warning,
`result: **complete**` (geometric/sugar close under **R2**/**R5**), unless OPEN
**ML** later reclassifies identity brackets as delimited. Interior-newline list
close is **descriptive / open: ML**, never comprehensive gate material.

**Dedup:** removed `eof_verdict`, `stacking_and_partial`, `multiline_strawman`
(content folded). Added `closed_law.yaml` for L2/S8/R13/R20/refs.

---

## 6. Probe catalog — ownership & deferred-value edges

**YAML is source of truth** under [fixtures/](fixtures/). Narrative sketches
below remain for reading; prefer the files when asserting.

Invented mini-cases. **Expected shapes are design targets from SPEC/DECISIONS**,
not parser traces. Event names provisional.

### 6.1 Element-rooted vs Attribute-rooted tail (**SPEC** §6.5)

```yaml
- id: own_el_finished_attr_tail_content
  profile: comprehensive
  desc: element-rooted line; finished :a; "rest" is element content
  udon: "|el :a 1 rest\n"
  result: complete
  # adm: element el, attr a=1, content text "rest"

- id: own_attr_rooted_warned_extension
  profile: comprehensive
  desc: attribute-rooted finished value; further material stacks + Warning
  udon: |
    |el
      :a 1 more
  result: complete
  # adm: two assignments under a (1 then "more") + Warning (warned extension)
```

### 6.2 Root-level `:key` (**L1**)

```yaml
- id: root_attr_is_document_text
  profile: comprehensive
  desc: no owning element — Warning + document Text including ':'
  udon: ":orphan v\n"
  result: complete
  root_only: true
  # adm: no Attribute node; content has Text ":orphan v\n" (or equiv)
  # anomalies: [{ severity: warning, code: …RootLevelAttribute… }]
```

### 6.3 Attr-under-attr (**L6**)

```yaml
- id: attr_under_attr_is_text_of_open_value
  profile: comprehensive
  desc: deeper :k under open attr → Error; line is Text of open value
  udon: |
    |el
      :outer
        :inner x
  result: complete
  # adm: outer's value includes text of ":inner x" line; Error anomaly
```

### 6.4 Deferred value body

```yaml
- id: deferred_value_deeper_prose
  profile: idiomatic
  desc: key alone on line; deeper lines form value body
  udon: |
    |el
      :note
        first line
        second line
  result: complete
  # adm: note value is flow/text spanning the deeper lines (ML policy may
  #      refine line-bound constructs later — this shape is the deferred path)
```

### 6.5 Unclosed identity (**R5**)

```yaml
- id: unclosed_key_partial
  profile: comprehensive
  desc: missing ]; $partial-key not $key
  udon: "|el[abc\n"
  result: complete   # geometric/identity open — not delimited string; R2 geometric close
  # Note: if unclosed [ is later classified delimited under ML, re-check result.
  # adm: assignment $partial-key = "abc" (or captured form) + Warning
```

### 6.6 Wire-twin incomplete-input (**R2**, **C6**)

```yaml
- id: str_unclosed_eof_incomplete
  profile: comprehensive
  desc: quote opened, true EOF — keep + Warning + incomplete-input
  udon: '|el :k "abc'
  result: incomplete-input
  root_only: true
  # events: … StringValue "abc", Unclosed*, ElementEnd …
  # NO IncompleteInput event

- id: str_closed_complete
  profile: idiomatic
  desc: closed string control for the twin
  udon: "|el :k \"abc\"\n"
  result: complete
```

*(Interior-newline twin for string multi-line stays **descriptive** /
`open: ML` until OPEN ML closes — do not promote as comprehensive law.)*

### 6.7 Tab in indentation (**L4**, **L0**)

```yaml
- id: tab_indent_kept_warning
  profile: comprehensive
  desc: tab in indent kept as text of owner; Warning; not line-lost
  udon: "|el\n\tprose\n"
  result: complete
  # NOT the live CORE "line lost" behavior — see ORACLE-DELTAS
```

### 6.8 Plain missing value (**R6**, **L0**)

```yaml
- id: plain_key_missing_value_nil_error
  profile: comprehensive
  desc: plain :key with no value → Nil + Error (absent intended value)
  udon: "|el :k\n"
  result: complete
  # adm: assignment k = Nil; Error (not mere Warning)
```

### 6.9 Inline-brace never boundary (**R4**)

```yaml
- id: bare_then_inline_el_is_flow
  profile: comprehensive
  desc: after bare token, |{ is Flow segment not new attr boundary
  udon: "|el :n value |{em x} :a 1\n"
  result: complete
  # adm: single flow value for n containing text + inline em + text ":a 1"
```

### 6.10 Flag re-own (**SPEC** §6.3)

```yaml
- id: flag_true_reown_tail
  profile: idiomatic
  desc: :ready? alone → true; material after re-owned by continuing scan
  udon: "|el :ready? yes\n"
  result: complete
  # adm: ready? = true; "yes" continues as element content (or next attr
  #      per scan) — not warned extension of the flag value
```

---

## 7. Mapping from 0.9 corpus (oracle only)

When mining `core/fixtures/v0.9/`:

| 0.9 pattern | 0.10 treatment |
|-------------|----------------|
| Pure happy events | Likely **idiomatic** + add `adm` when cheap |
| EOF / Unclosed* densification | **comprehensive** + add `result` twins |
| `PINS CURRENT BEHAVIOR (descriptive)` | **descriptive** + `open: ML` (or named hole) |
| `events: []` probes | Either drop or rewrite from SPEC (never promote empty as green) |
| Flat Attr wire expectations | **Rewrite** under **W1d**; do not carry inference-extent pins |
| Live CORE “line lost” tab | Expect **ORACLE-DELTAS** divergence under **L4** |

Differential runs (old parser vs new) belong in tooling notes, not as
authority for expected ADM.

---

## 8. Harness constraints (when implemented)

1. **No source after recognition** for expected-product comparison (**W0**).
2. Text fold / adjacent-Text collapse only if **associative concat** preserves
   **R1** and is applied symmetrically to actual and expected.
3. Variations (wrap/indent) MUST NOT run on `root_only` or truncated-EOF cases.
4. Gate = idiomatic ∪ comprehensive; descriptive reported separately.
5. Empty `events` + empty `adm` is not a pass — it is a skip or a fail.
6. Warning codes: suite vocabulary must agree with generator derivation
   (**W4**); until registry freezes, assert severity + stable local name.

---

## 9. Relationship to spikes / OPEN

| Source | How it affects fixtures |
|--------|-------------------------|
| agent-utility **P-B** | Verdict channel for partial generation — already **C6** |
| agent-utility **P-A** | Dual stage products → dual assertion (events + ADM) |
| paths **D*** | Do not invent path fixtures as Core law; host/tool suites later |
| OPEN **ML** | All multi-line span pins stay **descriptive** until demand harvest |
| OPEN **W1e** | Event spellings for Attr regions stay provisional in comprehensive notes |
| OPEN **S3** | Multiple-keys cases are not Core gate material yet |

No harvest from paths/agent-utility is promoted here — only fixture *shape*
pressure already closed as C5/C6.

---

## 10. Next concrete steps (no steward)

1. ~~Promote §6 probes into YAML~~ → [fixtures/](fixtures/) (file-only corpus).
2. Densify wire-twin pairs (interp `!{{`, fence, more envelope edges).
3. Add SPEC annex or pedagogy cross-links to 2–3 idiomatic cases as “worked
   recognition product” once spellings stabilize.
4. Keep descriptive ML corpus in sync with [OPEN-ML-STRAWMEN.md](OPEN-ML-STRAWMEN.md).
5. When harness starts: loader for `profile` + `result` + `adm`; never load
   descriptive into the version gate.

---

## Pointers

| Doc | Role |
|-----|------|
| [DECISIONS.md](DECISIONS.md) | C5, C6, D-pack, W0, L0–L1, L4, L6, R1–R2, R5–R6 |
| [WIRE.md](WIRE.md) §8 | Profile pointer + verdict channel |
| [ADM.md](ADM.md) §1 | Document packaging |
| [ORACLE-DELTAS.md](ORACLE-DELTAS.md) | Intentional 0.10 vs live parser |
| [STATUS.md](STATUS.md) | Queue |
| `../core/fixtures/README.md` | 0.9 harness archaeology (not 0.10 law) |
