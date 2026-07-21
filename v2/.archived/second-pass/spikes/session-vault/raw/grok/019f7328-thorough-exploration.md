## User

Hello there-- Would you thoroughly explore udon here and give your thoughts?

## Assistant

I'll explore the UDON repo systematically — layout, spec, core implementation, and the work lanes — then give a grounded read rather than a surface summary.

## Tools

- ListDir: .
- Read: /Users/josephwecker-v2/src/udon/README.md (1-200)
- ListDir: spec
- ListDir: core

## Assistant

Next I'll dig into CORE, the work lanes, positioning, and a few real documents so the assessment is grounded rather than brochure-level.

## Tools

- Read: /Users/josephwecker-v2/src/udon/README.md (201-284)
- Read: /Users/josephwecker-v2/src/udon/spec/CORE.md (1-150)
- Read: /Users/josephwecker-v2/src/udon/design/positioning.md (1-120)
- Read: /Users/josephwecker-v2/src/udon/TODO-META.md (1-50)
- Read: /Users/josephwecker-v2/src/udon/CONSUMERS.md (1-100)
- Execute: wc -l spec/CORE.md core/TODO-CORE-PARSING.md spec/TODO-SPEC-CORE.md core/udon-core/src/parser.rs core/udon-core/src/tree.rs core/udon-core/src/lib.rs design/examples/*.udon 2>/dev/null; head -5 spec/CORE-VERSION; echo "---"; ls core/fixtures/v0.9/ | wc -l; ls core/fixtures/v0.8/ | wc -l; find core/fixtures/v0.9 -name '*.yaml' | head -3 | xargs wc -l 2>/dev/null; rg -c "name:|description:|input:" core/fixtures/v0.9/*.yaml 2>/dev/null | head -30 (Count sizes and fixture inventory)
- Read: /Users/josephwecker-v2/src/udon/design/examples/cheatsheet.udon
- Read: /Users/josephwecker-v2/src/udon/core/udon-core/src/lib.rs
- Read: /Users/josephwecker-v2/src/udon/core/TODO-CORE-PARSING.md (1-80)
- Read: /Users/josephwecker-v2/src/udon/spec/TODO-SPEC-CORE.md (1-80)
- Read: /Users/josephwecker-v2/src/udon/design/udon-agentic.md (1-100)
- Read: /Users/josephwecker-v2/src/udon/core/udon-core/src/tree.rs (1-100)
- Execute: cd /Users/josephwecker-v2/src/udon/core && cargo test -p udon-core --test canonical compliance_gate -- --nocapture 2>&1 | tail -40 (Run compliance gate to see current state)
- Read: /Users/josephwecker-v2/src/udon/design/examples/operata-intent-graph.udon (1-80)
- Read: /Users/josephwecker-v2/src/udon/core/generator/00-udon.core.descent.udon (1-80)
- Read: /Users/josephwecker-v2/src/udon/ux/TODO-AGENT-UX.md (1-60)
- Read: /Users/josephwecker-v2/src/udon/_archive/REVIEW-JULY-2026.md (1-100)
- Read: /Users/josephwecker-v2/src/udon/design/udon-guarantees.md (1-80)
- Execute: cd /Users/josephwecker-v2/src/udon && git log --oneline -20 && echo "---" && git log --oneline --since="2026-07-01" | wc -l && echo "commits since July 1" && git tag -l 'core-*' && ls -la design/examples/ | head -20 && head -60 design/examples/schema-dsl.udon 2>/dev/null; echo "===="; head -80 design/examples/archema-operata.udon 2>/dev/null (Git history, tags, sample design docs)
- Read: /Users/josephwecker-v2/src/udon/core/udon-core/src/parser_pd.rs (1-60)
- Read: /Users/josephwecker-v2/src/udon/design/agentic-ux-principles.md (1-70)
- Read: /Users/josephwecker-v2/src/udon/spec/msc/CHANGELOG.md (1-80)
- Execute: cd /Users/josephwecker-v2/src/udon/core && cargo test -p udon-core --workspace -- --skip compliance_gate 2>&1 | tail -30; echo "===="; wc -l core/fixtures/v0.9/*.yaml | tail -5; rg -c "^- name:" core/fixtures/v0.9/*.yaml 2>/dev/null | sort -t: -k2 -n | tail -25; echo "==== total cases:"; rg -c "^- name:" core/fixtures/v0.9/*.yaml 2>/dev/null | awk -F: '{s+=$2} END {print s}' (Non-compliance tests and fixture case counts)

## Assistant

# Thoughts on UDON

I spent a real pass through the estate: README/status spine, CORE (including the 0.9 attribute model and anomaly posture), the open lanes, the descent grammar, `udon-core` (event parser + pushdown + arena tree), fixtures, consumers, design examples, positioning/agentic docs, and a live compliance run. Below is judgment, not a tour.

---

## What it actually is

UDON is a **unified structure+prose notation** with a small, explicit tier contract:

| Prefix | Role |
|--------|------|
| `\|` | structure |
| `:` | attributes (edges) |
| `;` | comments |
| `!` | dynamics / raw |
| everything else | content |

That is not a minor syntax choice. It is the product thesis: **comprehension without tooling**, for an author who is often a model streaming into a terminal. The July reboot’s reframe — *the marginal author is a model* — is the right bet. The 2011 “better unified markup for humans” bet is the graveyard bet; this one is not.

---

## What is genuinely strong

### 1. The problem cut is real

Agents need:

- unambiguous structure without highlighting  
- no YAML-style type sniffing  
- streamable generation  
- structure and narrative in one document  
- comments as a first-class voice tier  

UDON’s design answers those directly. Positioning’s “dumb pipe vs comprehending agent” litmus is sharp: use JSON when nothing is reading for meaning; use UDON when something is. That is better product framing than most format projects ever achieve.

### 2. Spec architecture has real taste

Several separations are load-bearing and well chosen:

- **Menu vs knob** — core fixes the option *space*; hosts pick within it  
- **Dialect ≠ schema** — typing/meaning vs allowance  
- **Anomaly posture ladder** — event parser commits to *warn-and-keep* wherever coherent; drop/halt/reject stay at app/AST  
- **EOF as universal closer** with per-construct `Unclosed*` rather than silent discard  

That is unusually mature for a pre-1.0 format. Most competitors either hard-fail or silently coerce. UDON’s default is closer to how agents actually author: messy streams that should stay recoverable.

### 3. The 0.9 attribute model is a real reconception

Attributes as edges that may terminate at **leaves or nodes**, flags as `:key?`, flat stacking on the wire, uniform scan replacing run-to-EOL — this fixes a class of “structure must be a child” pressure that would have permanently crippled DSL use. The Ash-like / Operata / schema-DSL examples become much more natural under that model.

### 4. Engineering discipline is unusually high

What stands out relative to most notation projects:

- **Compliance is measured** by versioned fixture groups, not tracked as vibes  
- **RED is allowed and intentional** when the spec is ahead  
- **Three-way divergence reporting** (CORE / grammar / parser) with no silent verdicts  
- **Rulings ledger** so decisions don’t reopen by drift  
- **Consumer differential re-scans** with event-stream diffs  
- **Open-only co-located TODO lanes** with layer prerequisites  
- Grammar generates **both** recursive and **pushdown/streaming** backends from one source  

The densification work (478 canonical+variation checks across 22 v0.9 files) is the right kind of honesty: it found real silences (EOF composition, sameline `!` guard, unclosed embed in attr phase) and pinned them rather than papering them over.

### 5. Dogfood is already paying rent

Six live external docs (~3k lines) in ASF / vivarium / autopax, clean under 0.9, with two meaning-changes that moved *toward* author intent. That is small but high-signal: the format is already carrying process maps, decision logs, lexicons, taxonomies — exactly the soft/hard interleaved documents the guarantees essay describes.

---

## Where it is fragile

### 1. “Core is small” architecturally; CORE.md is not small experientially

`CORE.md` is ~1,840 lines of dense, careful law. The *architecture* is small (sigils, head position, scalars, events). The *surface* that a human or model must hold — identity, traits, flags, embedded, freeform, references, typing envelopes, raw blocks, scan boundaries, prose dedentation, anomaly codes — is large.

That is not a design failure. It is the cost of closing footguns properly. But it is the main strategic risk: **YAML’s problem was surprise; UDON’s risk is completeness-tax.** Live consumers still use a thin subset (`[key]`, attributes, bare dates as strings). Everything else is real implementation and mental cost with near-zero adoption so far. Protect the thin path.

### 2. Spec/parser depth has outrun product

| Layer | State |
|-------|--------|
| CORE + event parser | Deep, largely real; 0.8 frozen, 0.9 alpha implemented |
| Arena tree / streaming tree | Present; not the product surface yet |
| Paths, schema, patch | Design / TODO-AUX |
| Utils (fmt, convert, accessors) | Not yet |
| Agentic edit tool | Design + principles; Joseph’s stated priority; blocked on path/schema/round-trip |
| Human UX (Obsidian, tree-sitter, vim) | Pre-0.8 |
| Dynamics / temporal / markdown dialects | Companion specs; not productized |

The stack is inverted relative to a typical open-source format launch (ship utils and editors early). Here the **contract and reference parser are ahead**, and the **things that make adoption sticky lag**. That is defensible given the audience (agents in Joseph’s own stack first), but it means external gravity is still weak.

### 3. Status truth has a slight lag

README says the 0.9 compliance gate is GREEN. A live run today fails **9 of 478** checks — exactly the two densification-honest REDs tracked in `TODO-CORE-PARSING` (`flag_then_raw_block_is_child`, `eof_unclosed_embedded_with_open_attr`). That is good process (fixtures pin the bug), but it means “implemented + gate green” was true at a snapshot and is no longer the full story. Minor, but it matches a recurring format-project failure mode: narrative state drifts from measured state.

### 4. Trading-places is not dead yet

The July review’s diagnosis — authority trading among design docs / CORE / grammar / generated parser / fixtures — is the project’s historical disease. The cure is correctly named (literate fusion: one source → prose + grammar + fixtures). It is still “later,” gated on grammar congealment. Until that lands, every densification pass will keep discovering “three-way, no verdict” items. That is healthy short-term and expensive long-term.

### 5. The agentic product is the real product — and still mostly design

`udon-agentic.md` + `agentic-ux-principles.md` are among the best design material in the repo. The principles document is especially strong: it grounds fail-on-ambiguity edit tools in lived corpus pain *and* ASF/AAT framing, not vibes.

But the thing Joseph most wants — **principled atomic, indent-correct, syntax-validating edit** — correctly depends on path syntax → schema → serializer/spans. Without that, UDON remains a notation agents *write by hand* (or emit), not a substrate that *makes agent editing safe*. The format alone does not complete the agent thesis.

---

## Fresh-eyes judgments (the harder ones)

**On the bet itself:** Strong. Better than JSON-with-comments, better than Markdown+YAML frontmatter, better than “just use XML” for agent-authored structured knowledge. The prefix contract is the durable insight. If this fails, it will not be because the idea is wrong; it will be because the completeness tax outran the thin-path ergonomics, or because tools never made editing cheap.

**On the reboot quality:** High. The July estate review → reboot plan → drained lanes → 0.8 freeze → 0.9 attribute model in about a week of intense work is unusually coherent. The discipline around “don’t invent syntax; discuss silences” is working — the open three-ways prove it.

**On what to protect:**

1. **The thin path** — elements, attrs, prose, comments, `[key]`, simple nesting. Make that *effortless* for models.  
2. **Warn-and-keep** — do not let edge-case lawyering erode the anomaly posture.  
3. **Measured compliance** — keep RED honest; never edit fixtures toward the parser.  
4. **The edit-tool critical path** — paths + schema + round-trip are not “aux”; they are the product for the stated audience.

**On what I would not do next:**

- More companion-spec surface (markdown layers, full dynamics language, temporal dialect) before utils and the edit path  
- Publishing theater (crates.io name reservation is fine; marketing a full stack that isn’t there isn’t)  
- Dogfooding TODOs-as-UDON before the thin path is boringly reliable  

**On what I would do next** (ordered by leverage, not completeness):

1. Close the two honest REDs + the EOF-composition silence Joseph needs to rule — get a real `core-v0.9.0` tag.  
2. Land the minimum path + serializer substrate for a **syntax-validating atomic edit v0** (schema can wait one notch).  
3. Rebuild one agent cheat-sheet and re-run a small usability harness against *current* models — empirical, not design.  
4. Keep consumer re-scans; grow the vivarium/ASF corpus deliberately as the only real adoption metric that matters this year.

---

## Bottom line

UDON is not a cute markup experiment. It is a **serious attempt at a notation for agent-comprehensible structured documents**, with a parser and spec discipline that most format projects never achieve, dogfooded in the places that already need it.

The intellectual core is sound. The engineering culture is unusually honest. The gap is **product completion of the agent loop** (path/schema/edit) relative to **spec completeness**, and the long-term risk is **feature surface growing faster than the thin path’s memorability**.

If the next phase is “nail 0.9, ship the edit substrate, measure agents writing/editing real docs,” this becomes infrastructure. If the next phase is more design exploration at the edges of CORE, it risks becoming a beautiful, well-documented format that only its authors fully hold in working memory.

I’m happy to go deeper on any slice — CORE edge cases, the attribute model, the parser/grammar three-ways, agent tooling path, or consumer migration — or to help prioritize/execute a specific next move.

## User

Make sure you have the full spec/ files (don't worry about spec/msc/) and the full *descent.udon grammar files first so you don't accidentally fabricate anything about the current state by assumption.

Then I'd like your help either on taking a broader sweep of the adjacent projects and the notes etc. to give your thoughts on potential schema languages, or give your thoughts on a more unified and principled EOF handling solution...

## Assistant

I'll load the full `spec/` tree (excluding `msc/`) and every `*.descent.udon` grammar unit first, then decide whether the schema-language sweep or the EOF model is the better place to land judgment.

## Tools

- ListDir: spec
- ListDir: core/generator
- Execute: wc -l /Users/josephwecker-v2/src/udon/spec/*.md /Users/josephwecker-v2/src/udon/spec/CORE-VERSION /Users/josephwecker-v2/src/udon/core/generator/*.descent.udon 2>/dev/null; ls -la /Users/josephwecker-v2/src/udon/spec/ (Inventory sizes of spec and grammar files)

## Assistant

Reading CORE and the grammar units in full, in parallel chunks.

## Tools

- Read: /Users/josephwecker-v2/src/udon/spec/CORE.md (2-501)
- Read: /Users/josephwecker-v2/src/udon/spec/CORE.md (502-1001)
- Read: /Users/josephwecker-v2/src/udon/spec/CORE.md (1002-1501)
- Read: /Users/josephwecker-v2/src/udon/spec/CORE.md (1502-1840)
- Read: /Users/josephwecker-v2/src/udon/core/generator/00-udon.core.descent.udon
- Read: /Users/josephwecker-v2/src/udon/core/generator/10-udon.elements.descent.udon
- Read: /Users/josephwecker-v2/src/udon/core/generator/20-udon.attributes.descent.udon

## Assistant

Continuing with the remaining grammar units and companion specs, then the EOF and schema design material.

## Tools

- Read: /Users/josephwecker-v2/src/udon/core/generator/30-udon.values.descent.udon
- Read: /Users/josephwecker-v2/src/udon/core/generator/40-udon.prose.descent.udon
- Read: /Users/josephwecker-v2/src/udon/core/generator/50-udon.comments.descent.udon
- Read: /Users/josephwecker-v2/src/udon/core/generator/60-udon.embedded.descent.udon
- Read: /Users/josephwecker-v2/src/udon/core/generator/70-udon.dynamics.descent.udon
- Read: /Users/josephwecker-v2/src/udon/core/generator/80-udon.freeform.descent.udon
- Read: /Users/josephwecker-v2/src/udon/core/generator/90-udon.references.descent.udon
- Read: /Users/josephwecker-v2/src/udon/spec/TODO-SPEC-CORE.md
- Read: /Users/josephwecker-v2/src/udon/spec/TODO-AUX.md
- Read: /Users/josephwecker-v2/src/udon/design/eof-model-proposal-2026-07.md

## Assistant

Grounded in CORE and the full active grammar. Next I'll sweep schema-adjacent material (workbench, design notes, rowan) so both tracks rest on primary sources.

## Tools

- Read: /Users/josephwecker-v2/src/udon/design/schema-workbench-2026-07.md (1-200)
- Read: /Users/josephwecker-v2/src/udon/design/udon-schema-exploration.md (1-120)
- Read: /Users/josephwecker-v2/src/udon/spec/CORE-supplement.md
- Read: /Users/josephwecker-v2/src/udon/spec/DYNAMICS.md (1-80)
- Read: /Users/josephwecker-v2/src/udon/spec/TODO-SPEC-OTHER.md
- Execute: ls ~/src/rowan 2>/dev/null | head -40; ls ~/src/rowan/lib 2>/dev/null | head -30; find ~/src/rowan -name '*.rb' -path '*schema*' 2>/dev/null | head -20; find ~/src/rowan -name '*constraint*' -o -name '*identity*' -o -name '*version*' 2>/dev/null | head -30; ls /Users/josephwecker-v2/src/udon/design/ | rg -i 'schema|attribute|guarantee|composite|ast' (Locate rowan and schema-adjacent design files)

## Assistant

Grounding complete: full `CORE.md`, companions + TODOs (not `msc/`), and every active `*.descent.udon` unit end-to-end. Below is judgment from those sources—not assumed state. I’ll give **both** tracks, since the EOF material is already decided enough to be concrete, and schema needs a broader sweep.

---

# Track A — Unified, principled EOF

## What CORE actually commits to

From CORE “End of input” + anomaly posture, the ratified core is already almost a principle:

1. **EOF is a universal implicit closer** — pending `End`s flush innermost-first, “exactly as a full dedent would.”
2. **Two classes of open construct**
   - **Indentation-scoped** (elements, directives, comments, deferred attr values) → **silent** close.
   - **Delimiter-scoped** (quotes, arrays, embeds, inline comments, interpolations, envelopes, freeform) → **content kept + `Unclosed*` anomaly**.
3. **Nothing is discarded at EOF.**
4. **Missing final newline is never, by itself, an anomaly** — EOF is newline-equivalent where a rule says “followed by a newline.”
5. **Errors are events; parse continues** (ladder (a) where coherent; non-halting error events where not).

What CORE is **silent** on (and densification correctly flagged):

- **Composition** when several constructs are open at once.
- **Unclosed identity bracket** `|el[unclosed` — not in the EOF table.
- Severity split **principle** (why freeform/`UnclosedTypeEnvelope` are warnings while string/array/embed are errors) is only per-row, not derived.

## What the grammar actually does

Verified against the units:

| Construct | Where EOF is handled | Matches CORE row? |
|-----------|----------------------|-------------------|
| Quoted string | `30-…quoted` explicit `|eof` → emit + `UnclosedStringValue` | yes |
| Array | `30-…array` `|eof` → `unclosed_array` | yes |
| Interpolation | `70-…interpolation` `|eof` → emit + `UnclosedInterpolation` | yes |
| Envelope | `30-…envelope` `|eof` / `\n` → `UnclosedTypeEnvelope` + BareValue | yes |
| Freeform | `80-…freeform` top-level `|eof` → `UnterminatedFreeform` | yes |
| Inline comment | `50-…comment_text_braced` `|eof` → `unclosed_inline_comment` | yes |
| Embed **content** | `60-…embed_content:main` `|eof` → Text + `unclosed_embedded` | yes |
| Embed **identity / attr phase** | `embedded` `:post_identity` / `:pre_content` / `:check_attr` — **no `|eof`** | **NO** — silent `EmbeddedEnd` only |
| Elements / directives / deferred attrs | return → BRACKET auto-`End` | silent close (by type system) |
| Bare pending guard (`\|`, `@`, `!`, `:`) | several paths consume marker then hit EOF with **no emit** | **violates** “nothing discarded” + newline-equivalence |

So the construction complaint in `design/eof-model-proposal-2026-07.md` is accurate: **EOF is hand-written per state**, and the failures live where someone forgot an arm. Behaviorally, most of the table is already correct; the weak spots are real and narrow.

Also confirmed: **`flag_then_raw_block_is_child` is not an EOF bug.**  
`10-…:check_sameline_bang` only arms `{`;  
`30-…:kwb_bang` / `:strb_bang` arm `<XLBL_START ':' '{'>`.  
That is **coverage**, not end-of-input.

## A principled model that fits CORE (without inventing a new wire)

The EOF proposal’s two-fact split is the right abstraction, and both independent reviews correctly killed the aggregate `[unexpected-eof]` vehicle.

### Fact (a) — pending **decision**, not unclosed construct

A guard has consumed bytes and not decided (or a “followed by newline” rule is pending).

**Resolution:** treat EOF as a member of the **terminator class** for that state — same body as `\n` (and often `:bracket`, framed `;`, etc.).

Consequence:

- `|` at EOF → `Text "|"` (same as `|` + `\n`) — **no anomaly**
- `@` / `!` / `:` at EOF → same ordinary resolution
- Never a special “rest of buffer” event (that would make “no trailing newline” anomalous, contradicting CORE)

This is already half-true in places: `:kw_boundary` / `:str_boundary` list `|eof`, `\n`, `:bracket`, `<';`' BS>` as **parallel arms with the same body**. The bug is that some states omit the eof twin of their newline arm.

### Fact (b) — construct **opened**, delimiter never arrived

Property of a **frame**, not of a state:

> If this frame’s closer is a delimiter (not indentation), and that delimiter never arrived, emit that frame’s `Unclosed*` **with span = opener..EOF**, then flush `End`.

Consequences:

- Composition falls out: **innermost-first**, each frame its own anomaly where due — exactly the densification one-liner, now as a derivation rather than a fixture “reading.”
- `|p |{a :href x` fails **regardless of phase** — the embed frame is still open; you do not need an `|eof` arm on every attr state.
- Streaming order stays correct: anomaly **before** `End` (AST still has the node open).
- No new event types; no end-of-stream summary.

### Composition sentence to add to CORE (0.9-appropriate)

The densification proposal is sufficient and I would ratify it nearly as written:

> When several constructs are open at EOF, each closes innermost-first. A construct whose closer is a delimiter carries its own `Unclosed*` (or warning) as its frame unwinds; indentation-scoped constructs close silently. Nothing is discarded.

That single sentence:

- turns the four ⚠ composition fixtures into derivations  
- makes the embed-attr-phase drop a **plain bug**  
- leaves severity table rows as they are (do not “export” severity to hosts — the fence-is-coherent vs string-is-error judgment is core’s job, even if today’s split is a bit uneven)

### What **not** to do in 0.9

Joseph’s scoping ruling is right: **full group vocabulary waits on the dialect boundary.**

Reasons grounded in CORE + grammar:

- Interpolation content, `<…>` envelopes, and eventually embed interiors are dialect-adjacent; “coherent content” (fact (b)’s soft vs hard) can depend on who owns the interior.
- Descent-generated EOF (terminator class + per-frame property) is the right **construction** fix, but it is a **descent feature**, not a CORE rewrite.
- Severity unification (“everything Warning if capture is coherent”) is tempting but would **export an existing incoherence** rather than resolve it — settle principle later.

### 0.9 action set (principled, minimal)

1. **CORE:** add the composition sentence; optionally list unclosed identity bracket if you want parity (`|el[unclosed` — grammar’s `bracket_close` currently returns without anomaly).
2. **Grammar bugs from ratified text only:**
   - Embed: fact-(b) at the **Embedded frame** (any phase), not only `embed_content`.
   - Bare-marker discard: eof ≡ newline on pending guards (document + sameline + value-boundary paths).
3. **Separate (not EOF):** complete `:check_sameline_bang` to match `:kwb_bang`.
4. **Fixtures:** bare-marker family; `|p |{a :href x` ≢ closed form; keep composition cases as non-⚠ once CORE text lands.
5. **Defer:** descent-generated terminator classes / frame properties → `TODO-DESCENT`, after dialect boundary is clearer.

### One principle for severity (later, but hold it)

A clean rule that matches most of the current table:

| | Content already a well-formed value without the closer | Needs the closer to even be a token |
|--|--|--|
| **Warn** | freeform body; single-line envelope pass-through | — |
| **Error** | — | unclosed quote, array, embed, interpolation, inline comment |

Today’s freeform Warning and string Error fit this. Nested array + open string composition stays Error on both frames. If something fails this table, the bug is the table row, not the host.

---

# Track B — Schema language (broader sweep)

## Constraints already fixed by CORE (do not re-litigate)

From CORE “The Core, and What It Leaves Open” + 0.9 attributes:

| Layer | Job |
|-------|-----|
| **Core** | syntax, wire, stacking, identity desugar, anomaly posture |
| **Dialect** | what a value *means/types* (`<…>`, temporal, dynamics language) |
| **Schema** | what is *allowed* (cardinality, uniqueness, vocabularies, structure) |
| **Host / document** | projection, duplicate-definition policy, reference resolution modes |

Also already ratified and schema-relevant:

- **Suffixes** `? ! * +` desugar to `$?` etc.; *meaning* is schema/dialect  
- **Stacking is universal**; “one key” / multi-key uniqueness is **schema**, not core  
- **`$key` multi-value** already allowed on the wire; host views already say “value(s)”  
- **Type-as-trait** is CORE language: classification as lightweight typing  
- **Soft vs hard** is not a core parse concern — core always keep-everything

So the schema language’s job is **loud failure for valid-but-wrong-shape documents**, especially re-parented structure under indentation. That is Joseph’s correct load-bearing reason (worse than Python: silent re-parent, not crash).

## What the adjacent material actually offers

**In-repo (primary):**

1. **December hand DSLs** (`design/examples/ash-like-*.udon`, `archema-operata.udon`, `schema-dsl.udon`) — strongest author signal: type as **trait**, constraints as **attrs**, layers as **named blocks**.
2. **`udon-schema-exploration.md`** — 13 puzzle pieces; still the agenda; Piece 1’s `:author! string` **value grammar is dead under 0.9** (plain attrs need values; flags are `:key?`).
3. **`udon-guarantees.md`** — guarantee ladder + Casual/Careful/Critical profiles + gatekeeper problem + append-only `|change` sketch (patch ancestor).
4. **`schema-workbench-2026-07.md`** — correctly demoted “rowan↔udon convergence” to single-author consistency; still useful as source index.

**Rowan (`~/src/rowan`):** waiting **customer**, not independent evidence. Real vocabulary already built: attributes, constraints, identities, relationships, evolution/history, codegen, migrations. Acceptance test from TODO-AUX is exact: *can that vocabulary be written in UDON better than the Ruby DSL?*

**External families (survey axes, not recommendations):**

| Family | What it optimizes | Fit for UDON |
|--------|-------------------|--------------|
| JSON Schema / OpenAPI | tree of typed values, composition keywords | good for hard maps; weak on soft prose regions & identity |
| RELAX NG / XSD | ordered content models, element grammar | closest to document structure; XML-shaped |
| Protobuf / Avro / Cap’n Proto | closed records, codegen | wrong: no soft regions, no interleaved prose |
| Cue / KCL / Dhall | constraint + merge + config | strong for constraints/merging; different authoring culture |
| Cedar / Rego | policy, not shape | host layer, not schema core |
| Ash / Ecto / ActiveModel | resources, actions, identities | **rowan’s layer** — behavior + storage, not pure schema |

## Forming position (pre-design, as the workbench asks)

I would **not** invent a fourth paradigm. I would **split three surfaces that people keep conflating**:

### 1. Core schema (constrain structure) — UDON-native, small

Purpose: restore loud failure for documents that *parse* but *mis-structure*.

Minimum coherent core:

- **Element content models** — child names + cardinality (`? ! * +` on the schema side, already in the notation’s DNA)
- **Attribute requirements** — required / optional / forbidden; scalar vs node vs stack; max multiplicity
- **Identity rules** — uniqueness of `$key` (and later multi-key / tuple, once CORE sugar exists)
- **Reference shape** — “this attr is a reference selector,” not “belongs_to with inverse” (that’s rowan)
- **Soft regions** — where prose/comments are allowed without being “unknown children”

The December trait style is the right spelling substrate:

```udon
|attr[slug].string :allow-nil false
|attr[status].atom :one-of [projected active realized]
|identity[unique-slug] :keys [slug]
```

vs the dead Piece 1 form:

```udon
:author! string    ; 0.9: plain :author needs a value; 'string' would be blob
```

**Soft regions** are the one thing almost no competitor has and UDON *must* have. My lean (same as workbench’s Option D): **absence = soft** — if the schema doesn’t name a child slot, prose is free; only *declared* structure is constrained. That matches “prose is the default voice” and avoids annotating every narrative hole.

### 2. Dialects (type meaning) — not schema

`.uuid8` / `.string` / `<temporal:…>` / number formats should resolve through **dialects + traits**, not a parallel `|type[email] :base string` mini-language *unless* that type registry is itself a dialect document.

Piece 2’s custom types are fine as **named dialect constructors**, not as schema’s job. Schema says “this attr must be claimable as email”; dialect says what email *is*.

### 3. Resource / behavior layer (rowan) — dialect or companion, not core schema

`|actions`, `|policies`, `|storage`, graph queries — legitimately live in the **same file** as schema blocks (December examples already do), but they are **not** the schema layer CORE leaves open. Treat them as:

- a **rowan dialect** over UDON, or  
- a **resource document schema** that *includes* a core-schema section  

If you fold actions into “schema,” you re-create the Ruby DSL fatigue under a new name.

## Design pressures unique to UDON (acceptance criteria)

Any candidate syntax should be scored on:

1. **Indent hazard** — does invalid nesting fail loudly under Careful/Critical?
2. **Soft/hard fractal** — can one document mix narrative and strict records without two formats?
3. **0.9 wire fidelity** — stacking vs list values vs node values vs flags; no collapsed round-trip lies
4. **Identity** — `$key`, traits, future multi-key/tuple; uniqueness as first-class
5. **Pragma binding** — document ↔ schema ↔ dialects without magical global state
6. **Agent edit path** — path + schema + apply: schema must be path-addressable and partial-checkable
7. **Rowan port** — operata/ash-like examples rewrite without loss vs Ruby
8. **Gradualism** — Casual (advise) / Careful (warn-as-error on hard) / Critical (reject); schema-by-exemplar and aspirational `name.schema.udon` designators

## What I would *not* do

- **JSON Schema as the authoring surface** — fine as an *export*, terrible as the thing agents/humans write for soft/hard docs  
- **One mega-DSL** that is schema + Ash + policies + migrations  
- **Treating rowan shape as external proof** — same author; use it as **requirements**, not corroboration  
- **Reviving Piece 1 syntax** without a 0.9 resyntax  
- **Blocking schema on full dialect architecture** — core schema can land with “types = trait names + core scalars + opaque `<…>` until dialects claim them”

## Suggested next design move (when you want to open that session)

Write one short design note (attribute-model register) that freezes only:

1. **Three surfaces** (core-schema / dialect-types / resource-behavior)  
2. **Soft-by-default content model**  
3. **December trait+attr spelling as the base orthography**  
4. **Enforcement profiles** (Casual/Careful/Critical)  
5. **Acceptance corpus:** rewrite `ash-like-billing.udon` + one vivarium document’s *expected* constraints  

Defer: evolution ops, codegen targets, merge/patch, schema-by-exemplar (name them as open, not design them yet).

---

# Which track to push first?

| | EOF | Schema |
|--|-----|--------|
| **Blocked on Joseph?** | Mostly composition + severity principle; bugs fixable from ratified text | Yes — orthography and soft-default are real design choices |
| **Unblocks** | honest `core-v0.9.0` gate, densification REDs, bare-marker data loss | edit tool, rowan, loud indent failures, pragma |
| **Risk of wrong freeze** | Low if you stay minimal | High if you over-unify with rowan |

My recommendation:

1. **This week:** composition sentence + the two ratified-text EOF bugs + sameline `!` coverage (Track A 0.9 set).  
2. **Next design session:** schema design note from the five freezes above (Track B), with rowan vocabulary as the acceptance test—not as architecture copy-paste.

---

I can next either (a) draft the exact CORE composition paragraph + grammar fix plan for the embed/bare-marker bugs, or (b) draft the schema design note skeleton against the December examples and rowan’s actual constraint/identity modules—say which you want.

## User

Let's focus on the EOF first. Tell me where this mental model is overly simplistic:

[unexpected-at-eof]
   -> (1) [undifferentiated buffer characters] (usually just a few since we don't need much lookahead in udon)
   -> (2) [stack of unclosed groups] (a few (maybe?) that close with a newline, but most needing a closing bracket of some sort)
          OR [unmet expectations] (actual characters that it expects in order to close them in stack order)
[expected-at-eof]
   -> (3) [stack of unclosed block-level elements]  (closed by dedents == newlines/eof)


What I was thinking is that we remove the almost 100 manual EOFs in the descent grammar and replace it with a more general mechanism except for a few places that need to manually specify something else. That manual EOF handling has been a weakness of descent for a long time. I was thinking (1) gets output as an unexpected-eof event's text payload, (2) is a set of warnings as they unwind, and (3) is absolutely fine. I keep getting confused at how complicated the tentative solutions are-- what am I missing?

## Assistant

Your model is mostly right about the *problem shape*. The complexity is not because EOF is mysterious — it is because a few clean-looking compressions fight things CORE has already ratified. Here is where the model is too simple, and what a still-simple version can be.

## What is already right

| Piece | Verdict |
|-------|---------|
| Split **unexpected** vs **expected** at EOF | Correct instinct |
| **(3)** indentation-scoped things close at EOF like a full dedent | Correct — CORE already says this |
| Manual per-state `|eof` is a long-standing descent weakness | Correct as *construction* |
| Want a general mechanism + few overrides | Right direction |
| Unclosed delimiter groups should surface **as they unwind** | Right (innermost-first) |

The reviews did not reject “EOF should be generated.” They rejected particular **vehicles** for (1) and (2).

---

## Where (1) is too simple

### “Undifferentiated buffer → unexpected-eof text payload”

That collapses two different situations into one bad event.

**A. Pending *decision* (guard / terminator class)**  
Bytes were consumed, no construct has opened yet, or a token is mid-resolve:

```text
|          at EOF
@          at EOF
!          at EOF
:          at EOF
|el :x 12  at EOF mid-token / at boundary
```

CORE already decides these:

- *Nothing is discarded at EOF*
- *Missing final newline is never, by itself, an anomaly*
- *EOF is newline-equivalent everywhere a rule says “followed by a newline”*

So `|` + EOF must behave like `|` + `\n` → ordinary `Text "|"`.  
**Not** an anomaly. **Not** “undifferentiated.”

If (1) always becomes `unexpected-eof` + residual text:

1. Every “no trailing newline” document with a pending guard becomes anomalous — contradicts CORE.
2. You throw away **typing**. Today’s ~50 emit-and-return `|eof` arms are not the same boilerplate 50 times; they emit ~12 constructors (`Text`, `Integer`, `BareValue`, `StringValue`, `Reference`, …). A single residual blob is a typing regression.
3. “Usually a few lookahead bytes” is true for *guards*, false for *open captures* (quoted string body, freeform body, prose MARK). Those are not “undifferentiated leftovers”; they are **already-classified content waiting to TERM**.

**B. Open capture that *has* a type**  
`"hello` at EOF is not “buffer junk.” It is a partial `StringValue` plus `UnclosedStringValue`. The content is differentiated; only the closer is missing.

So (1) should not be an event shape. It should be:

> **Resolve the current state as if EOF were a normal terminator in that state’s terminator class** (usually ≡ newline). Emit the ordinary typed events. No special umbrella.

That is fact (a) from the proposal — generation, not a payload.

---

## Where (2) is too simple

### “Stack of unclosed groups → warnings as they unwind”

Three compressions hide real distinctions.

### 1. Not everything open is a “group awaiting a bracket”

At EOF the stack (conceptual, not only BRACKET frames) can hold:

| Open thing | Closer | CORE behavior today |
|------------|--------|---------------------|
| Element / directive / comment / deferred text attr | indent / EOF | **silent** End — your (3) |
| Embed / array / quote / `;{` / `!{{` / freeform / `<…>` | delimiter | content + **Unclosed\*** |
| Plain attr still OPEN (no value material) | “a value” | **`MissingAttributeValue` + synthesized `Nil`** — not Unclosed\* |
| Flag / finished attr collecting nothing special | — | nothing |

`|p |{a :href` is **two** facts at once: embed frame open *and* attr incomplete. Your (2) alone does not say whether you emit only `UnclosedEmbedded`, only `MissingAttributeValue`+`Nil`, or both. CORE’s table is per-construct and silent on composition; the densification reading (both, innermost-first) is a *ruling*, not free.

### 2. Severity is not “all warnings”

CORE’s ladder and table fix **code vocabulary** (Warning vs Error). Hosts choose *reaction* (drop / halt / reject). Today:

| | Code |
|--|------|
| Unclosed string, array, embed, inline comment, interpolation | **Error** |
| Unclosed type envelope, unterminated freeform | **Warning** |

Collapsing (2) to “warnings as they unwind” is a **semantic change**, not a simplification of the mechanism. You can still *implement* unwind uniformly; you must not flatten severity without a new principle.

(The unevenness is real — freeform body is “coherent” so Warning; `"a` is also coherent content but Error. That is a later principle question. Exporting “all Warning” exports the mess.)

### 3. “Unmet expectations = characters it expects”

That is compiler/PEG recovery language. UDON’s recovery is already simpler:

- emit content so far  
- emit the frame’s **known** anomaly code  
- flush End  

The closer is determined by **frame type** (`}`, `]`, `"`, `` ``` ``, …), not by a dynamic expected-set. Listing expected characters adds complexity and invites wrong multi-choice messages (`expected } or ]`) that the language does not use.

Also: for indentation-scoped frames there is **no** expected character — EOF *is* the closer. Those must not appear in (2).

---

## Where (3) is almost right but slightly narrow

“Stack of unclosed **block-level elements** closed by dedent” understates what silently closes:

- elements  
- directives  
- line comments (continuation)  
- deferred attribute bodies in BODY/DONE modes (content already coherent)

And one non-silent relative of (3):

- deferred attr still **OPEN** → error + `Nil`, not silent End of a group

So: **indentation-scoped / “no delimiter required” → expected at EOF** is the right cut — not “elements only.”

---

## Why the wire shape got complicated (what you were missing)

You sketched an aggregate:

```text
[unexpected-at-eof]
  - undifferentiated buffer
  - unclosed groups (with open sites)
```

That *feels* simple. It fights three **already-landed** constraints:

1. **Streaming** — today `Error UnclosedEmbedded` arrives **before** `EmbeddedEnd`. An AST builder sees the anomaly with the node still open. A closing summary forces every consumer to commit, then retro-patch by span. That is strictly harder than in-place unwind.

2. **Flat wire (0.9)** — “no new nested event types; multiplicity = re-emission.” A nested group list under one EOF event is a second composition model on the wire.

3. **EOF is not special on the wire** — CORE’s sentence is that Ends flush *exactly as a full dedent would*. Special-casing EOF as one mega-event makes EOF *more* special, while the grammar goal is to make it *less* special (same as newline / frame exit).

So the “complicated” alternatives were mostly people trying to keep your *insight* (buffer leftovers + open groups + open sites) while **not** shipping that aggregate vehicle. The simpler vehicle is:

| Insight | Simple mechanism |
|---------|------------------|
| Leftover decision/capture | resolve as normal terminator (type-preserving) |
| Open delimiter frame | per-frame anomaly **before** End, span = opener..EOF |
| Open indent frame | silent End |
| Incomplete plain attr | existing `MissingAttributeValue`+`Nil` on that frame |

No new event type. Same stream order. Both backends identical.

---

## The other big missing piece: construction vs semantics

Two different jobs got fused in the “~100 EOFs” story.

| Job | What “general mechanism” means |
|-----|--------------------------------|
| **Descent construction** | Stop hand-writing `|eof` on every state; synthesize from terminator class + frame property |
| **CORE / wire semantics** | What events and codes the consumer sees |

Your mental model is almost entirely about **semantics**. The weakness you feel is almost entirely **construction**.

They couple, but they are not the same fix:

- **Semantics** can stay almost as CORE already has them (plus one composition sentence).  
- **Construction** is: eof ∈ terminator class of the state; BRACKET/type property `awaits_delimiter → Unclosed*`; specials override.

Also: one of the two live REDs (`flag_then_raw_block_is_child`) is **not EOF at all** — incomplete sameline `!` guard vs the value-boundary `!` guard. Generating EOF would not fix it. That false pairing is what made “EOF generalization” feel like it had to explain too much.

---

## A model that stays simple (and matches CORE)

Rewrite your diagram slightly:

```text
At EOF, for each open frame / pending state (innermost first):

  PENDING DECISION or OPEN CAPTURE (not a frame closer)
    → treat EOF as a normal terminator for that state
    → emit ordinary typed events (Text / Integer / StringValue / …)
    → NO unexpected-eof umbrella
    → anomaly only if this state is already "unclosed delimiter content"
       (e.g. quoted: emit StringValue + UnclosedStringValue)

  DELIMITER-SCOPED FRAME (embed, array, quote, ;{, !{{, freeform, <…>)
    → emit that frame's Unclosed* (Error or Warning per CORE table)
    → span = opener..EOF
    → then End

  INDENT-SCOPED FRAME (element, directive, comment, deferred attr body)
    → silent End   ← your (3)

  ATTR OPEN WITH NO VALUE
    → MissingAttributeValue + Nil   (existing rule; not "unclosed group")
```

That is your (1)/(2)/(3) with three corrections:

1. **(1) is not an event** — it is terminator-class resolution (usually newline-equivalent).  
2. **(2) is per-frame codes on unwind**, not one bag of warnings and not expected-character sets.  
3. **(3) is “no delimiter required,”** not only elements — plus the OPEN-attr special case.

---

## What you are not missing (reassurance)

You are not missing a deep theory that requires a nested EOF report.  
You *were* missing that:

1. **“Undifferentiated” would destroy typing and invent anomalies CORE forbids.**  
2. **Severity and MissingAttributeValue are not Unclosed\*.**  
3. **The aggregate event fights streaming + flat wire + “EOF ≡ dedent.”**  
4. **~89 arms look like duplication but many encode the emit type** — generation must know capture type, not emit a Rest blob.  
5. **Dialect ownership of interiors** is why freezing the full “group vocabulary” early is risky — not why *today’s* two bugs need a mega-model.

---

## Practical target (still the simple story)

- **User-facing mental model:**  
  *(a) finish the current token as if newline; (b) close delimiter frames with their Unclosed\*; (c) silent-close indent frames.*

- **Implementation mental model:**  
  *EOF joins terminator classes; frames declare `awaits_delimiter`; generator synthesizes; few overrides.*

- **Not the model:**  
  *one unexpected-eof event holding residual text + a list of groups.*

That is why tentative solutions looked complicated: they kept trying to reify (1) and (2) as a **single structured event**, which is the overcomplicated part. The right generalization is **mechanical** (descent stops asking every state to invent EOF) while the **wire stays boring** (same events you already have, in stack order).

If useful next step: I can map this three-way table onto concrete descent hooks (`terminator class`, `frame property`, `override list`) using only the current type system (BRACKET / CONTENT / INTERNAL) so the “almost 100 arms” claim becomes a deletion plan with an explicit exception list — still without changing CORE’s codes.

## User

You are conflating those constructs that *expect a closing set of characters* with the ones that do not.

## Assistant

You’re right — I blurred that cut.

## The cut you mean

Two kinds of open construct at EOF:

| | Expects a **closing sequence of characters** | Does **not** |
|--|-----------------------------------------------|--------------|
| Examples | `"…"`, `[…]`, `|{…}`, `;{…}`, `!{{…}}`, `` ```…``` ``, `<…>` | elements, directives, line-comments, deferred indent bodies |
| At EOF | something is still **owed** (a closer) | EOF **is** a normal end (same family as full dedent) |
| Your bucket | unexpected → **(2)** | expected → **(3)** |

That binary is the load-bearing one. I mixed other distinctions into it and made the picture look harder than it is.

## Where I conflated

1. **Open capture vs “expects a closer.”**  
   An open string’s body is typed content, but the *construct* still expects `"`. That stays in (2). Treating it as a special “partial value” path beside unclosed groups was re-splitting (2) for no structural reason.

2. **Newline-as-terminator / guard resolution with (2).**  
   Pending `|` / `@` / mid-guard is **not** “expects a closing bracket.” It isn’t an open group. I parked it next to unclosed groups under a shared “fact (a)/(b)” story and smuggled terminator-class machinery into the same mental model as (2).

3. **`MissingAttributeValue` into the closer story.**  
   An open plain attr wants a *value*, not a closing character sequence. That’s a different obligation. Folding it under “unclosed groups” was wrong relative to your cut.

4. **Severity (Warning vs Error), flat wire, dialects.**  
   Those are orthogonal. They don’t redefine which constructs expect closers. I let them crowd the classification.

5. **“Delimiter-scoped” as a fuzzy bag.**  
   Once I said “delimiter” broadly enough to include newline/indent/EOF behaviors, I had already mixed the two columns above.

So: you were holding **expects closing characters / does not**. I kept answering as if the hard part were event shape, severity, and typing — and in doing so I treated the two columns as if they needed the same machinery.

## Restated in your terms only

- **(3)** Open things that do **not** expect a closing character sequence → EOF is fine; unwind silently (dedent family).  
- **(2)** Open things that **do** expect a closing character sequence → still open at EOF; report as they unwind (your stack of unclosed groups / unmet closer expectations).  
- **(1)** Leftover buffer that is **not** explained by an open closer-expecting group — separate residual, usually small.

I should not have merged (1) or attr-OPEN or “newline ≡ EOF for guards” into (2)’s category. Those may still need *implementation* rules, but they are not the same cut as “expects a closer.”

Thanks for the correction — the model is simpler than the way I was answering it.

## User

To be clear-- *when there is a missing expected end-sequence it it is the *only* time we know definitively that it is in fact an "unexpected EOF"*  You're right that the (1) in my original sketch actually usually ends up in bucket (3) already-- just falls through as part of the default construct. That makes it **simpler** than my original mental model-- not more complicated.

## Assistant

Yes. That sharpening is the whole simplification.

**Unexpected EOF** is only known when a construct still **owes a closing sequence** and input ended. That is the only definitive “EOF was wrong for this open thing.”

Everything else at EOF is **expected enough to finish by the ordinary rules**:

- indent-scoped frames → silent close (your (3))
- pending token / guard / small residual → same path the construct already uses for end-of-line / end-of-capture — not a special “unexpected” report

So the original (1) is not a third kind of surprise. It usually **never becomes an unexpected-EOF story**; it just finishes inside the open construct’s default end behavior, which for most frames is the (3) family (or ordinary typed TERM, which is the same idea: EOF is a normal closer for that state).

**Reduced model:**

| At EOF | Meaning |
|--------|---------|
| Open construct **expects** `}` / `]` / `"` / `` ``` `` / … | **Unexpected EOF** — report that missing closer (as frames unwind) |
| Anything else still open | **Expected** — finish by existing rules (dedent family / default construct end) |

No residual-buffer umbrella. No second anomaly class for “stuff left in the buffer.” Unexpected is narrow and mechanical: **missing expected end-sequence, and only then.**

That is simpler than both the original three-bucket sketch and the overbuilt alternatives.

## User

OK, so even my mental model was over-complicating it, it turns out. Under the assumption that cleaning up the grammar / descent's model will *also* help normalize various inconsistencies in the core spec, both already 'canonized' and implicit or current-gaps,  can you see a unifying simplifying solution that simplifies the grammar and the spec?

## Assistant

Yes. Under the cut you just made, there is a unifying simplification — and it is smaller than the earlier proposals.

## The single rule

**A construct is either closer-expecting or not.**

| Kind | Obligation | At EOF |
|------|------------|--------|
| **Closer-expecting** | still owes a fixed end-sequence (`"`, `]`, `}`, `` ``` ``, `}}`, `>`) | **unexpected EOF** — content kept + that construct’s `Unclosed*` + End |
| **Not** | no end-sequence owed | **expected** — finish by the construct’s ordinary end rules (dedent / newline family / TERM). No unexpected-EOF story |

That is the whole semantic model. Everything else is registration of which constructs are which, plus composition = innermost-first (the call stack).

Your refined insight fits exactly: **“unexpected EOF” is only licensed when a closer is still owed.** Residual buffer, open elements, open deferred text, mid-token, pending guard — none of those are unexpected-EOF by themselves; they finish inside the open construct’s default end.

---

## What that unifies in the **spec**

CORE’s EOF section can shrink from a behavior table to:

1. **One normative sentence**  
   *At end of input, every open construct finishes. If it still owes a closer, that is unexpected EOF for that construct (anomaly + content + End). Otherwise EOF is a normal end (same family as full dedent / ordinary termination).*

2. **One registry** (the collapsed table)  
   Not “what happens at EOF” per row — only **closer + anomaly code (+ severity)** for closer-expecting constructs:

| Construct | Closer | Code | Severity *(today)* |
|-----------|--------|------|---------------------|
| quoted string | `"` / `'` | `UnclosedStringValue` | Error |
| array | `]` | `UnclosedArray` | Error |
| embed | `}` | `UnclosedEmbedded` | Error |
| inline comment | `}` | `UnclosedInlineComment` | Error |
| interpolation | `}}` | `UnclosedInterpolation` | Error |
| type envelope | `>` | `UnclosedTypeEnvelope` | Warning |
| freeform | `` ``` `` | `UnterminatedFreeform` | Warning |

Optional second flag, still not a second EOF model: **line-bound** (newline before closer = same premature-end family). That is how envelopes (and today’s arrays) differ from multi-line strings/embeds without a second philosophy.

3. **Everything not in that registry** is explicitly **EOF-ok**  
   Elements, directives, line comments, deferred attr bodies, prose, bare tokens mid-finish — all “expected at EOF.” No rows, no special cases.

4. **Composition** becomes a derivation, not a silence  
   Several open → each frame answers the same question independently, innermost first. No separate composition essay.

5. **Gaps that stop being special** under the same rule  

| Gap / inconsistency | Under this rule |
|---------------------|-----------------|
| Embed open in attr phase, silent today | Embed is closer-expecting → always `UnclosedEmbedded` if no `}` — phase irrelevant |
| Bare `\|` / `@` / `!` discarded | Not closer-expecting → default end ≡ newline → ordinary Text; **not** unexpected EOF |
| Unclosed identity `[` | Closer-expecting → anomaly (currently silent; rule forces a decision) |
| Arrays vs multi-line | Decide **line-bound?** once; EOF and newline then share one premature-end path |
| Envelope anomaly-before-value | Generation from one frame property → same order as other Unclosed* |
| Severity freeform vs string | Stays a **registry field**, not a second EOF mechanism |
| `MissingAttributeValue` | **Not** unexpected EOF (owes a *value*, not a closer) — keep as its own rule; fires at EOF *or* dedent the same way |

So the spec does not grow a mega-EOF chapter. It **deletes** most EOF prose and **reuses** one obligation model. Canonized rows that already match this stay; implicit gaps either become derivations or one registry decision.

---

## What that unifies in the **grammar / descent**

Today: ~89 hand `|eof` arms — mix of “finish like newline,” “emit Unclosed*,” “do nothing” (bugs), and bookkeeping.

Under this model, descent only needs two generated behaviors:

### A. Default end (almost all states)

EOF is a **normal terminator** for the current state — same class as whatever already ends that state (often newline, bracket, space, …).  
Emit whatever that state already emits. **No** unexpected-EOF event.  
This deletes the bulk of the “emit content and return” arms *and* the empty discard arms (bugs become “forgot to put EOF in the terminator class”).

### B. Closer-expecting frame exit

On the **function/type** that opened a closer-expecting construct (BRACKET with a declared closer, or equivalent):

- if exit is because the closer was seen → normal End  
- if exit is because input ended (or, if line-bound, newline) → synthesize Unclosed* then End  

That is the **only** place unexpected-EOF is produced. One mechanism, stack order free from recursion, both backends identical.

Manual `|eof` remains only for true overrides (hopefully near zero once terminator classes are real). Descent’s long-standing weakness becomes: *EOF is not special; closers are.*

Sketch of the declaration surface (illustrative, not a design freeze):

```text
|type[Embedded] BRACKET closer='}' anomaly=UnclosedEmbedded severity=error
|type[Array]    BRACKET closer=']' anomaly=UnclosedArray    severity=error line-bound?
|type[Freeform] BRACKET closer=``` anomaly=UnterminatedFreeform severity=warning
|type[Element]  BRACKET   ; no closer → EOF-ok
```

CONTENT functions do not declare closers; they only declare terminators, and EOF joins that set.

---

## What you deliberately do **not** unify

Keep these *out* of the unexpected-EOF story so the model stays small:

| Concern | Why separate |
|---------|----------------|
| Incomplete plain attribute | Owes value, not closer → existing error+Nil |
| Duplicate keys, schema, dialects | Document/host layers |
| Severity Warning vs Error | Property of the construct in the registry; not a second unwind algorithm |
| Aggregate “unexpected-eof” event with residual + group list | Fights streaming + flat wire; **unnecessary** once only missing-closer is unexpected |

---

## Why this simplifies **both** at once

| Today | After |
|-------|--------|
| Spec: per-construct EOF *behaviors* | Spec: one rule + closer registry |
| Grammar: per-state EOF *arms* | Grammar: terminator membership + frame closer property |
| Bugs: missing arms / wrong phase | Same root: obligation not declared on the frame |
| Composition, identity `[`, bare markers | Same question: “closer still owed?” |
| “EOF is newline-equivalent” vs Unclosed* | Compatible: newline-equivalence for **EOF-ok** and for **state terminators**; Unclosed* only for **closer still owed** |

The old tension was treating EOF as a global special event. The unified view: **EOF is almost never special; only an unpaid closer is.**

---

## Concrete simplification target (spec + grammar together)

1. **CORE** — Replace the EOF table’s *narrative* with the one rule + the closer registry (codes/severities can stay as today’s names). Add one composition sentence (innermost-first). State that non-registered constructs are EOF-ok.  
2. **CORE** — Explicitly: bare incomplete markers and open indent constructs are **not** unexpected EOF.  
3. **Descent** — Generate (A) and (B); delete redundant `|eof`.  
4. **Udon grammar** — Declare closers on the seven (or so) constructs; delete hand EOF; fix embed/bare-marker as automatic consequences.  
5. **Fixtures** — Unexpected-EOF cases = only missing closers; everything else = “finishes like trailing newline / full dedent.”

---

## Bottom line

Yes: under the assumption that cleaning descent’s model and CORE should move together, the unifying simplification is:

> **Unexpected EOF ⇔ open closer-expecting construct.  
> Everything else finishes by ordinary end rules.  
> Spec lists closers; grammar declares closers; neither hand-writes EOF behavior per state.**

That is simpler than your original three-bucket sketch, simpler than the aggregate-event proposal, and tight enough to normalize both the hand-EOF mess and the EOF-related silences/inconsistencies in CORE without inventing a new wire shape.

If you want a next step, the highest-leverage artifact is a one-page “Closer registry + descent inference” design note that freezes only that rule and the construct list — no event redesign — then a deletion map of the 89 arms against (A)/(B).

## User

And since the grammar already captures whatever sequence is needed to exit from that function, we don't have to respecify it or simplify anywhere (escaped vs valid etc.)-- the parser just has to know "I have now entered a function that *is* or *is not* able to close with a newline/EOF- and I entered that state on character '['(etc.) on line N, col M"  And the parser can say "unclosed '[' started on ....." or something.


## Assistant

Yes. That is the further cut that makes the closer-registry idea mostly unnecessary.

## What the grammar already owns

Once you are inside `/embedded`, `/quoted`, `/array`, `/freeform`, … the **exit conditions are already written**: which byte ends the construct, brace depth, escaped vs real closer, `` ``` `` only at line start, first `}}`, and so on.

You must **not** re-specify that for EOF. Re-specifying is how you get a second, drifting “closer table” that disagrees with the grammar on escapes and edge cases.

## What the parser only needs to remember

On **entry** to a function activation:

1. **EOF/newline-closable?** — may this activation finish because of newline or EOF, without taking its structural closer path?  
   - **yes** → element, directive, line-comment, ordinary prose/token finish, …  
   - **no** → quote, array, embed, `;{…}`, `!{{…}}`, freeform, `<…>`, …

2. **Entry site** — opener character (or construct) and span: line N, col M (and the byte that opened it, e.g. `[`, `|{`, `"`).

Nothing about the full closer sequence. Nothing about valid vs escaped close. The grammar still owns exit when a closer *is* seen.

## At EOF

```text
while frames remain (innermost first):
  if this activation is newline/EOF-closable:
    finish by existing end rules   // expected
  else:
    // unexpected EOF — the only definitive case
    emit anomaly, citing entry site
    force-complete / End
```

Diagnostic shape (voice flexible):

> unclosed `'['` started at 12:8  
> unclosed `|{` started at 3:4  

The **obligation** is boolean + origin. The **closer language** stays in the grammar.

## Spec consequence

CORE does not need a column of closers. It needs roughly:

- Unexpected EOF **iff** still inside a non–newline/EOF-closable activation.  
- Report against **where that activation began**.  
- Otherwise EOF is a normal end.  
- Composition = stack order (already true of the call/frame stack).

Anomaly **codes** (`UnclosedEmbedded`, …) can remain as stable host vocabulary keyed off **which function/type** was entered — still not a second closer grammar. Message text can be opener+span even when the code is typed.

## Grammar / descent consequence

| Declare | Do not declare |
|---------|----------------|
| function/type: **closable by newline/EOF?** | the end-sequence |
| record entry span (+ opener) on enter | escape rules, depth, fence line-start, … |

Generated EOF behavior:

- **closable** → same as today’s default end (no special unexpected path)  
- **not** → anomaly from entry site + unwind  

Almost all hand `|eof` arms go away because they were re-encoding “finish content” or forgetting “not closable → anomaly regardless of phase.”

## Why this matches the mental model you ended on

- Missing expected end-sequence is known **because you are still in a non–newline/EOF-closable function**, not because a parallel closer string failed to match at EOF.  
- Residual / mid-token / open element → usually already inside a **closable** activation → falls out as normal end, not unexpected EOF.  
- Embed open in attr phase → still the same non-closable activation that started at `|{` → same unexpected EOF, no phase special case.

So yes: **boolean + entry site**, grammar keeps the exit language, unexpected EOF only when that boolean is false and input ended. That is simpler than a closer registry and aligned with how descent already structures work.

## User

What's a good name for "EOL/EOF" constructs vs ones that create character expectations?  soft-closable vs hard-closable?  open vs pent? ...

## Assistant

Good instincts on the *shape* of the pair. A few names, ranked by how well they fit this project.

## Best fit: **soft-close** / **hard-close**

(or **soft-closable** / **hard-closable** if you want the boolean to read as a property)

| Term | Means |
|------|--------|
| **soft-close** | May finish on EOL/EOF (and the rest of that family: dedent, ordinary TERM). No character closer owed. |
| **hard-close** | Only finishes by taking its structural closer path (whatever the grammar already encodes). EOL/EOF while still inside ⇒ unexpected EOF. |

Why it works:

- Names the **boolean you actually store** (can this activation end on EOL/EOF?).
- Matches the diagnostic story: hard-close left open → “unclosed … started at …”.
- Short enough for descent annotations and CORE prose.
- “Soft/hard” here means *kind of closer signal*, not severity.

Main caveat: **soft/hard** is already load-bearing in schema/guarantees (“soft regions”). In pure parser/CORE voice it is fine; if the same words will bleed into schema docs, prefer the collision-safe pair below.

**Soft-closable / hard-closable** is slightly clearer as a flag; **soft-close / hard-close** is better as a construct class name (“hard-close constructs”).

---

## Collision-safe alternative: **context-close** / **delimiter-close**

| Term | Means |
|------|--------|
| **context-close** | Closed by parse context (EOL, EOF, dedent, …). |
| **delimiter-close** | Closed only by the grammar’s delimiter path. |

More pedantic, zero clash with soft regions, a bit colder in prose. Good if you want CORE to stay vocabulary-clean across layers.

---

## Weaker options

| Pair | Issue |
|------|--------|
| **open / pent** | “Open” is already overloaded (OPEN attr, open frame). “Pent” is clever and opaque; every reader relearns it. |
| **implicit / explicit** | Clear-ish, but “explicitly closed” sounds like *the author closed it*, not *requires an explicit closer*. |
| **EOF-ok / closer-expecting** | Accurate, ugly, asymmetric; fine for internal notes, not for the type system. |
| **lax / strict** | Overloaded in parser-land; “strict” sounds like error policy. |

---

## Recommendation

Use **soft-close / hard-close** (with **soft-closable** as the boolean if you need one word on a frame).

Examples of voice:

- “`Embedded` is **hard-close**; entry site recorded at `|{`.”
- “`Element` is **soft-close**; EOF finishes like a full dedent.”
- “Unexpected EOF only for still-open **hard-close** activations.”

If schema-doc collision bothers you later, rename to **context-close / delimiter-close** without changing the model—the boolean is the same.

I would not use **open / pent**.

## User

I like soft and hard close pretty well but I'd really like something that doesn't center on "close"-- that's our current perspective but they are really transparent-bracketted vs printable-character-bracketed ...    open-framed and contained?  open and fenced?   ah, soft & walled?  unbound vs delimited? ungated and gated? (Don't worry, I won't fixate on it *too* much longer... worth getting right now if you want to send someone off to search the web for similar concepts and existing phraseology...

## Assistant

Searching parser and PL literature for established pairs that match this cut without centering on “close.”

## Tools

- WebSearch: parser terminology delimited constructs vs indentation sensitive regions
- WebSearch: "delimited" "indentation" grammar construct terminology programming language
- WebSearch: PEG parser "bracketed" "self-delimiting" vs context terminated
- WebSearch: off-side rule free-form delimited blocks terminology
- WebSearch: Haskell layout rule vs explicit braces curly delimited
- WebSearch: "free-form" vs "delimited" syntax blocks programming language design
- WebSearch: self-delimiting tokens nested brackets parsing terminology

## Assistant

Existing phraseology is uneven: one side of the cut already has a standard word; the other mostly doesn’t. That asymmetry is useful.

## What the literature actually says

The hard side is settled vocabulary:

| Term | Where it shows up |
|------|-------------------|
| **delimited** | Default word for regions bounded by open/close *tokens* (parens, braces, quotes, `/*`…`*/`) |
| **bracket delimiters** | Wikipedia-style: start/end text that marks a span |
| **explicit braces / curly-delimited** | Haskell contrast to *layout* |

The soft side is talked about as a *language mode*, not a construct property:

| Term | Where |
|------|--------|
| **indentation-sensitive / layout** | Adams, PEGs-with-indent, Langium (`INDENT`/`DEDENT`) |
| **off-side rule** | Landin / Python-family (whole-language framing) |
| **whitespace-sensitive** vs **whitespace-insensitive (delimited) regions** | Recent work: indent structure *or* paren-delimited “mode” |

There is **no** widely shared short pair that means exactly *your* boolean (“this activation may finish on EOL/EOF” vs “this activation owes a printed end-sequence”). Closest established *contrast* is Haskell’s **layout vs explicit braces**, and the arXiv framing of **indentation-based** vs **delimited by opening/closing tokens**.

**False friend:** *free-form* usually means “whitespace never matters” (C-style), not soft-close. Avoid as the soft side.

**UDON-specific landmine:** **fenced** already means freeform `` ``` ``. Don’t use it for the hard class.

---

## Your candidates, scored

| Pair | Soft side | Hard side | Verdict |
|------|-----------|-----------|---------|
| **unbound / delimited** | not bound by a printed end-token | standard term | **Strongest** — hard side is already the word people search |
| **ungated / gated** | may leave freely | expects a gate token | Fresh, clear; no soft-region clash; slightly novel |
| **open / contained** | open to context end | contained by markers | “Open” overloaded (OPEN attr, open frame) |
| **open / fenced** | — | — | **Avoid** — fence = freeform here |
| **soft / walled** | soft signals | walls = printable brackets | Nice metaphor; “soft” still schema-adjacent |
| **transparent-bracketed / printable-bracketed** | invisible brackets (EOL/EOF) | visible brackets | Best *explanation*; too long for annotations |
| **layout / delimited** | Adams/Haskell flavor | standard | Accurate for elements; weaker for “bare token at EOF” (not really layout) |
| **context-bound / delimiter-bound** | pedantic precision | pedantic precision | Safe, cold, long |

---

## Recommendation

**Primary: `unbound` / `delimited`**

- Centers on **what bounds the span**, not on “closing.”
- Hard side matches the web and textbooks: *delimited construct*.
- Soft side is honest: not bound by a character sequence; context (EOL/EOF/dedent/ordinary TERM) is enough.
- Annotation-friendly: `|type[Embedded] delimited`, `|type[Element] unbound`.
- Diagnostic: “unclosed delimited region started at …” still works; soft side never says “unclosed” for EOF.

**Runner-up if you want a fresher, less “grammar textbook” pair: `ungated` / `gated`**

- Same boolean, more physical metaphor (gate = expected character path).
- No collision with soft regions, freeform fences, or “open.”
- Slightly less searchable; fine if you define once in CORE.

**Keep as gloss, not names:**  
*transparent brackets* vs *printable brackets* — excellent teaching phrase under whichever pair you pick.

---

## What I would not pick

- Anything with **fence** in this repo  
- **open / *** as the soft default (too many “open”s already)  
- **pent** (cute, dead on arrival for agents and new readers)  
- **free-form** (wrong established meaning)  
- **soft-close / hard-close** if you want to leave “close” behind — the *idea* was right; the *root* wasn’t

---

## Minimal CORE voice if you freeze `unbound` / `delimited`

> A construct is **delimited** if entering it creates an expectation of a printed end-sequence (owned by the grammar). It is **unbound** if it may finish under ordinary EOL/EOF/context rules. Unexpected EOF is only possible for still-open **delimited** activations; report against the entry site.

That keeps the model you already have and drops “close” from the center of the name.

## User

ooh, what about   positional / delimited ?

## Assistant

**Positional / delimited** is a strong candidate — maybe the best pair so far on *meaning*. One UDON-specific collision is the only real brake.

## Why it fits

| | Positional | Delimited |
|--|------------|-----------|
| **What ends it** | *Where* you are (column, indent, line end, EOF) | A *printed* end-sequence |
| **Examples** | element, directive, line-comment, ordinary token finish | `"…"`, `[…]`, `|{…}`, `;{…}`, freeform, `<…>` |
| **Unexpected EOF?** | no | only while still open |
| **Centers on** | space/position in the document | character boundaries |

That matches the model cleanly and does not revolve around “close.”  
**Delimited** stays the standard hard-side word.  
**Positional** is more accurate than *unbound* for UDON specifically — hierarchy *is* column geometry.

Annotation-friendly:

```text
|type[Element]  positional
|type[Embedded] delimited
```

## The collision

CORE already has **Positional Contexts** as a major vocabulary block: block / sameline / inline / head.

Those are *modes of the scan*, not *kinds of construct*. If you also say “positional constructs,” many readers (and agents) will fuse:

- “positional context” (where am I parsing?)  
- “positional construct” (how does this span end?)

That is a real cost in *this* repo. Outside UDON, *positional / delimited* would be excellent with almost no baggage.

## Mitigations if you still want it

1. **Keep both, disambiguate once**  
   “Positional *constructs* (not to be confused with positional *contexts*)…” — works, slightly clumsy forever.

2. **Rename the soft side slightly**  
   **position-bounded / delimited** or **layout-positional / delimited** — uglier, less clash.

3. **Use positional only in descent/internal**, keep CORE teaching gloss as “transparent vs printable brackets.”

## Vs the other finalists

| Pair | Edge |
|------|------|
| **positional / delimited** | Best semantic fit for UDON’s indent world; clashes with Positional Contexts |
| **unbound / delimited** | Safer vocabulary; soft side a bit vaguer |
| **ungated / gated** | Zero clash, fresher, less “textbook” |

## Verdict

I’d take **positional / delimited** *if* you are willing either to live with a careful disambiguation next to Positional Contexts, or to eventually rename that section to something like **scan contexts** / **parse contexts** (bigger edit, cleaner long-term).

If you want zero collision and no glossary tax: **unbound / delimited** still wins.

If you like the geometry of “positional” but hate the clash: **layout / delimited** is the Adams/Haskell cousin — same idea, less overlap with CORE’s “positional.”

My lean for *this* codebase: either commit to **positional / delimited** *and* plan a one-word disambiguation strategy for “contexts,” or pick **unbound / delimited** and keep “positional” for the scan vocabulary only. Both are good; the choice is mostly whether the Positional Contexts name is sacred.

## User

Yes-- but look at all of the usages of positional in the spec--- I believe they are probably positional in this sense already! (i.e., a distinction without a difference)

## Assistant

Checking how CORE actually uses "positional" — whether it already means the same cut.

## Tools

- Search: [Pp]ositional|position
- Search: [Pp]ositional

## Assistant

You’re right about the *ethos*. The formal term is not quite the same cut — and CORE itself shows the seam.

## What “positional” actually does in CORE

There are a few related uses, all under one design thesis: **geometry (column / line / locus) is authoritative**.

### 1. Positional Contexts (the section)

The table is **where the scan is**, not **how a span ends**:

| Term | What it names |
|------|----------------|
| block | own indented line |
| sameline | on the element line |
| inline | in prose flow |
| **embedded** | *inside* `|{…}` |
| head | structural column / pre-prose scan |

That is **recognition locus**: same byte, different meaning by place.

### 2. “Position alone disambiguates” (esp. `\`)

Head / mid-prose / value-expected / elsewhere — still **locus → meaning**, not span class.

### 3. Children are “positional”

Array order vs labeled attrs — a third, classical sense (sequence).

### 4. Hierarchy chapter

Column stack, “pop while new_column ≤ …”, inline as vertical form — **extent by geometry**. This is the soft-close / “positional construct” sense almost verbatim.

So the language is already *positional-first*. Your proposed pair is not a foreign category.

## Where it is *not* a distinction without a difference

The counterexample is in the same table:

> **embedded** — Inside the braced-element delimiters

**Embedded is a Positional Context *and* a delimited construct.**  
You are in a “positional context” named `embedded` while the **activation is hard/delimited** (`}` still owed; EOL/EOF do not finish it).

So:

| | Positional *context* | Positional *construct* (your pair) |
|--|----------------------|-------------------------------------|
| Element children | block / head / … | yes — extent by indent/EOF |
| Inside `|{…}` | **embedded** (still a “context”) | **no** — extent by delimiter |
| Inside `"…"` | (value / content locus) | **no** — delimited |

Contexts and construct-kinds **nest**: a delimited region still has internal positional rules (sameline attrs inside `|{…}`, value-position `\`, etc.). That is why the section can honestly list `embedded` as a context without meaning “soft-close.”

## The accurate unification

Not “one term, one cut,” but:

> **UDON is positional by default; delimited regions are the explicit exceptions.**  
> Positional *contexts* are the fine-grained loci *inside* that world (including inside delimited islands).  
> Positional *constructs* are activations whose **extent** is positional (EOL/EOF/indent).  
> Delimited *constructs* suspend extent-by-geometry until the grammar’s closer path runs.

That is why your collision worry is *almost* a distinction without a difference: same design principle, two layers (locus vs extent). The only place they come apart is exactly the hard cases we care about for unexpected EOF.

## For the name `positional / delimited`

I’d treat that as **evidence for the name**, not a problem:

- CORE has already trained “positional” as the native authority language.
- **Delimited** names the minority that create character expectations.
- Unexpected EOF = still inside a **delimited** activation.
- You do **not** need a new soft word that fights the hierarchy chapter.

Optional precision in one sentence of CORE (when you write it):

> *Positional contexts* describe recognition locus; a construct may still be *delimited* (e.g. embedded) while positional rules apply *inside* it.

That is a clarification, not a new dichotomy.

**Bottom line:** Your instinct is right that existing “positional” usage is the same family. It is not identical to the construct boolean — `embedded` proves the nest — but elevating **positional / delimited** as the span pair is a *crystallization* of the spec’s existing thesis, not a second competing vocabulary.

## User

The text block is positional, the embed itself is delimited.

## Assistant

Yes — that’s the clean split.

| | Kind | Ends by |
|--|------|---------|
| **Text block** (prose / indent-scoped content) | **positional** | column, line, EOF |
| **Embed** (`\|{…}` as an activation) | **delimited** | the grammar’s closer path (`}`) |

Same for the other islands: the **string / array / freeform / …** is delimited; any text running *under ordinary line geometry* is positional.

So “embedded” in Positional Contexts is **locus** (you’re inside an embed’s interior). The **embed itself** is still a delimited construct. No conflict — two layers:

- **where** am I interpreting? (context)  
- **what kind of span** did I enter? (positional vs delimited)

Unexpected EOF only for the second layer when that span is **delimited** and still open.

## User

So we get to clean up the EOF behavior AND get unity and greater specificity and tidiness on our use of "positional" and "delimited"... It seems again that what looked like it could be pretty complicated and nuanced is actually something that *can* easily be helped and put into the cleaner framing. Am I missing anything?

## Assistant

You’re not missing a hidden third theory. The framing is doing real work: one cut, two cleanups, less special-case EOF.

What remains is **residue**, not a competing model.

## What the framing actually buys

| Area | Effect |
|------|--------|
| **EOF** | Unexpected only for open **delimited** activations; **positional** finishes by ordinary end rules |
| **Vocabulary** | “Positional” = extent-by-geometry (and the loci that live there); “delimited” = printed end-sequence owed |
| **Grammar** | Boolean + entry site; grammar already owns closer language |
| **Spec** | One rule + which constructs are which; composition = stack order |
| **Bugs** | Embed mid-attr silent close, bare-marker discard = wrong classification / missing default end — not deep mystery |

That *is* simpler than it looked.

## What you are not missing (but should not pretend vanishes)

These stay real; they just **don’t reopen the EOF philosophy**:

1. **`MissingAttributeValue`** — owes a *value*, not a delimiter. Same rule at dedent or EOF; not “unexpected EOF.”

2. **Severity (Error vs Warning)** — freeform vs quote still need a code/severity per construct (or a later principle). Mechanism is one; vocabulary of codes can stay.

3. **Line-bound delimited** — array/envelope treating newline as premature end is already *in the grammar*. Same family as hard end; not a second EOF model.

4. **Engineering** — deleting ~89 hand `|eof` arms and teaching descent “positional vs delimited + entry span” is still work. The *design* is small; the *edit* is not free.

5. **One editorial sentence** — when you rewrite CORE: *positional contexts* = loci; *positional constructs* = span kind; embedded *context* can sit inside a *delimited* embed. Prevents agents from re-colliding the layers.

6. **Third “positional”** — children as array order (“positional, heterogeneous”). Different sense; leave it or eventually say “ordered” if it ever confuses. Not load-bearing for EOF.

7. **Unrelated RED** — sameline `!` guard coverage is still not EOF.

8. **Dialect interiors (later)** — who owns “coherent inside `|{…}`” can wait; core only needs “delimited activation still open.”

## Short answer

No — you’re not missing a complication that undoes the simplification.  
You’re holding a **unifying cut** that makes EOF, naming, and a pile of edge cases **instances** of one rule.

Ship the framing; treat the list above as implementation and glossary residue, not as reasons the model is wrong.

## User

Excellent-- can you turn our final form and thoughts here into spec/TODO-EOF-refactor.md and point to it from core's TODO?

## Assistant

I'll capture the settled framing in `spec/TODO-EOF-refactor.md` and link it from the core TODO lanes.

## Tools

- Read: /Users/josephwecker-v2/src/udon/core/TODO-CORE-PARSING.md (1-100)
- Search: EOF|eof|Unclosed
- Read: /Users/josephwecker-v2/src/udon/spec/TODO-SPEC-CORE.md (46-85)
- Read: /Users/josephwecker-v2/src/udon/design/eof-model-proposal-2026-07.md (1-40)
- Read: /Users/josephwecker-v2/src/udon/core/TODO-CORE-PARSING.md (101-244)
- Read: /Users/josephwecker-v2/src/udon/tools/descent/TODO-DESCENT.md (1-50)
- Read: /Users/josephwecker-v2/src/udon/spec/TODO-SPEC-CORE.md (1-20)

## Assistant

Writing the settled framing and wiring pointers from the core and related TODO lanes.

## Tools

- Edit: /Users/josephwecker-v2/src/udon/spec/TODO-EOF-refactor.md
- Edit: /Users/josephwecker-v2/src/udon/core/TODO-CORE-PARSING.md
- Edit: /Users/josephwecker-v2/src/udon/core/TODO-CORE-PARSING.md
- Edit: /Users/josephwecker-v2/src/udon/core/TODO-CORE-PARSING.md
- Edit: /Users/josephwecker-v2/src/udon/spec/TODO-SPEC-CORE.md
- Edit: /Users/josephwecker-v2/src/udon/spec/TODO-SPEC-CORE.md
- Edit: /Users/josephwecker-v2/src/udon/design/eof-model-proposal-2026-07.md
- Edit: /Users/josephwecker-v2/src/udon/tools/descent/TODO-DESCENT.md
- Read: /Users/josephwecker-v2/src/udon/core/TODO-CORE-PARSING.md (1-120)

## Assistant

Done. Settled framing is landed and linked.

### Created
- [`spec/TODO-EOF-refactor.md`](spec/TODO-EOF-refactor.md) — design of record: positional / delimited cut, what grammar owns, CORE + descent consequences, rejected vehicles, open work, short form for agents

### Pointed from
- **`core/TODO-CORE-PARSING.md`** — header pointer + both EOF bug items rewritten as instances of the framing + descent “generated EOF” bullet updated
- **`spec/TODO-SPEC-CORE.md`** — header pointer + EOF composition item → section rewrite against the framing
- **`design/eof-model-proposal-2026-07.md`** — marked historical / superseded
- **`tools/descent/TODO-DESCENT.md`** — new open item for the generator property (so the ask isn’t only on the udon side)

No CORE or grammar implementation yet — tracking only, as requested.

## User

And then, one more task, a more difficult one: Can you see how you might *automatically detect* delimited constructs as we've defined them? Rearranging some things in the grammar or a slight difference or unification on how things nest or something would be appropriate-- but the main idea is can we get the grammar to do the right thing with non-closed areas without even needing to add that boolean or capture clause? (the naive first pass would probably be something like a construct anywhere that says "expect xyz" (where xyz is a label, not the characters), and somewhere else that says "satisfy xyz" (matching the expect label so we know which one it's fulfilling). But I'm hoping you see a way to do this through the shape of the grammar itself instead of via explicit construct...

## Assistant

Checking how construct exits actually appear in the grammar so the detection idea stays grounded in real shapes.

## Tools

- Search: \|return|^\s*\|eof|BRACKET|function\[
- Read: /Users/josephwecker-v2/src/udon/tools/descent/SYNTAX.md (1-80)
- Search: infer|EOF|terminator|BRACKET|exit
- Read: /Users/josephwecker-v2/src/udon/tools/descent/implementation-spec.md (191-240)
- Read: /Users/josephwecker-v2/src/udon/tools/descent/implementation-spec.md (371-440)

## Assistant

Yes — and descent has already half-named the mechanism. You can get this from **grammar shape**, without a hand boolean, if “delimited” is defined as a property of **exit structure**.

---

## Definition that is checkable

Classify every **function-exit** edge (paths that leave the function, not internal `|>>`):

| Exit kind | Trigger | Example |
|-----------|---------|---------|
| **Soft success** | EOF / newline / dedent / column predicate, **no** anomaly | `element` `col <= elem_col` → return; prose TERM on `\n` |
| **Hard success** | Consumed a non-soft character (sequence), then return | `}` / `]` / `:q` / `` ``` ``+`\n` / `}}` / `>` |
| **Soft failure** | Soft trigger **with** anomaly, then return | quoted `|eof` + `UnclosedStringValue`; freeform `|eof` + `UnterminatedFreeform` |

Then:

| Inferred kind | Structural condition |
|---------------|----------------------|
| **Delimited** | There is at least one **hard success**, and **no soft success** (soft exits, if any, are only soft *failure*) |
| **Positional** | There is at least one **soft success** |

That is exactly your boolean, derived from the machine — no separate “this is delimited” flag.

Unexpected EOF for a still-open activation becomes:

> If the current function (or its BRACKET root) is **delimited-inferred**, and input ends before a hard success → synthesize soft failure (content kept + anomaly + return/End), citing **entry site**.

Positional: soft success is normal; generator only needs “EOF ∈ terminator class of soft success,” same as newline/dedent.

---

## This is already sketched in descent

`tools/descent/implementation-spec.md` § *Inferred EXPECTS*:

- State with self-looping default + **exactly one** single-char exit → `EXPECTS(that_char)`
- Function where all terminal paths require the same delimiter → function EXPECTS that delimiter
- Nested depth (`{`/`}` with depth==0) → EXPECTS(`}`)

**Delimited ≈ “function EXPECTS something.”**  
**Positional ≈ “function does not EXPECT a character; soft exit is accepting.”**

Your expect/satisfy labels are the *explicit* form of the same idea. Inference is: **satisfy is already the hard-success edge; expect is inferred from “only way out.”**

So the naive labels are not wrong — they are the IR. The hope is that the DSL rarely needs to write them because the state graph already encodes them.

---

## Pure shape (no labels) — when it works cleanly

### Easy cases (already true in udon grammar)

| Function | Hard success | Soft success? | Inference |
|----------|--------------|---------------|-----------|
| `quoted` | `:q` | only soft *failure* | **delimited** |
| `array` | `]` | only soft failure (`\n`/eof error) | **delimited** |
| `interpolation` | `}}` | only soft failure | **delimited** |
| `brace_comment` / balanced `}` | `}` @ depth 0 | only soft failure | **delimited** |
| `element` children | — | dedent / eof return | **positional** |
| `line_comment` | — | dedent | **positional** |
| `prose` / `sameline_text` | — | `\n` / eof TERM | **positional** |
| `flag_value` bare eof | — | BoolTrue | **positional** |

### The bug class becomes a **static check**, not a design debate

`embedded` has hard success on `}` and also soft exits that return **without** anomaly (identity/attr phase, missing `|eof`). Under the definition:

- Hard success exists → candidate **delimited**
- Soft success without anomaly → **inconsistent machine**

Generator policy (pick one):

1. **Reject** at generate time: “delimited function has soft success without anomaly,” or  
2. **Rewrite**: any soft exit on a delimited-inferred function becomes soft failure (entry-site Unclosed\*).

That is how you get “the right thing with non-closed areas” without an author boolean: **the presence of a hard closer defines the obligation; soft exit without closer is illegal or auto-anomalous.**

---

## Grammar rearrangement that makes inference boring

You do not need a new conceptual layer if you **write two body shapes** and stop mixing them inside one function:

### 1. Layout body (positional by construction)

```text
loop:
  soft end (dedent / eof) → return success
  else → child / prose / …
```

Only soft-success exits. Inference: **positional**.  
Today: `element` `:children`, `line_comment` `:children`, directive children.

### 2. Matched body (delimited by construction)

```text
loop:
  hard closer path → return success
  soft (eof / maybe \n) → return failure (or omit; generator fills)
  else → content
```

Only hard-success + soft-failure. Inference: **delimited**.  
Today: `quoted`, `array` items, `embed_content`, freeform, interpolation, envelope.

**Rule of arrangement:** a BRACKET’s *extent* is either layout or matched — not “layout until we forget eof.”  
`embedded` should be: identity/attrs as *prefix states that cannot soft-return*, then one matched body (`embed_content`). Soft-return from prefix is a shape error.

Helpers already point this way:

- `skip_brace_balanced` — matched primitive  
- `skip_single_quoted` — matched primitive  
- column loops — layout primitive  

If matched spans are *always* entered via a matched primitive (or a function whose only success exit is that primitive’s closer), inference never needs a boolean.

That is stronger than expect/satisfy labels: **the combinator is the kind.**

---

## What about expect/satisfy labels?

Useful as **IR**, optional as **surface**:

```text
; IR (generated or inferred)
EXPECTS '}'   ; delimited
; soft exit → Unclosed* + End
```

Surface DSL can stay as today *if* analysis works. Explicit `|expects '}'` only when inference is ambiguous (multi-closer, multi-success).

Descent’s draft multi-state fence (`` ``` ``) and depth-balanced `}` are exactly the cases for extending inference beyond “one char exit.”

---

## Hard cases (honest limits)

| Case | Issue | Handling |
|------|--------|----------|
| **Parameterized closer** (`quoted :q`, identity `:close`) | Closer is a param, not a literal | Infer EXPECTS(:param); still delimited |
| **Multi-step closer** (freeform `` ``` ``) | Exit is a path, not one char | Function-level: all success paths share a “closer chain”; soft without completing chain = failure |
| **Both soft success and hard success** | e.g. “optional braces” | Rare in UDON; if real, **must** annotate or split into two functions — inference correctly refuses |
| **CONTENT vs BRACKET** | Quote is CONTENT but delimited | Kind is from exits, not BRACKET alone |
| **Return codes** (`block_attr` → OPEN/NODE) | Exit is soft but “unfinished obligation” is on *caller* | Delimitedness is on the **value frame**, not the attr scanner; OPEN attr is value-obligation, not unexpected-EOF |
| **Who is the “activation”?** | Closer consumed in callee, BRACKET on caller | Analyze **BRACKET entry → return**; callees that only return on closer count as hard success of the root if they don’t soft-return themselves |

None of these force a manual boolean for the common path; they bound how smart inference must be.

---

## Recommended synthesis (no boolean on the author)

1. **Define delimited/positional as exit-structure properties** (above).  
2. **Infer EXPECTS / delimited** in descent IR (extend the existing *Inferred EXPECTS* sketch to multi-step + soft-failure).  
3. **Default codegen:**  
   - positional → inject soft terminator class (eof ≡ other soft success) where missing  
   - delimited → inject soft failure (anomaly + entry span + return) where soft is missing or bare  
4. **Static reject** soft success + hard success in the same function (or require an explicit override — the only remaining annotation, rare).  
5. **Udon grammar tidy:** make `embedded` (and any sibling) a pure prefix + matched body so phase bugs cannot reappear as “forgot `|eof`.”  
6. **Optional later:** layout vs matched as first-class body forms in the DSL so the shape is obvious to humans, not only to the analyzer.

---

## Bottom line

You are not missing a reason this *must* be a manual flag.

**Delimited means: the grammar’s only successful way out is a hard closer path.**  
That is visible in the state machine. Descent already called it EXPECTS. Unexpected EOF is “soft exit while EXPECTS is unpaid.” Positional is “soft exit is success.”

The expect/satisfy labels are the right *semantics*; the win is to **read them off the graph** (and arrange the grammar so the graph is unambiguous), not to re-type them on every construct.

If you want this captured next to the EOF framing, it slots into `spec/TODO-EOF-refactor.md` + the descent generated-EOF item as “infer positional/delimited from exit structure; boolean is IR-only.” I can add that section if you want it durable.

## User

Go ahead and put it as an addendum to TODO-EOF-refactor.md as you've already pointed the right files to it. And it looks like you're touching on all of the right areas, including leaning into cleaning up how the grammar is more clearly specified even when it would technically do the same things... Excellent. Let me know when it's all written up and I'll have another agent red-team it a bit to find any gaps we missed or simplifications we missed.

## Tools

- Read: /Users/josephwecker-v2/src/udon/spec/TODO-EOF-refactor.md
- Edit: /Users/josephwecker-v2/src/udon/spec/TODO-EOF-refactor.md
- Edit: /Users/josephwecker-v2/src/udon/spec/TODO-EOF-refactor.md
- Edit: /Users/josephwecker-v2/src/udon/spec/TODO-EOF-refactor.md
- Edit: /Users/josephwecker-v2/src/udon/spec/TODO-EOF-refactor.md
- Edit: /Users/josephwecker-v2/src/udon/tools/descent/TODO-DESCENT.md
- Edit: /Users/josephwecker-v2/src/udon/core/TODO-CORE-PARSING.md
- Edit: /Users/josephwecker-v2/src/udon/spec/TODO-SPEC-CORE.md

## Assistant

All written up and ready for a red-team pass.

### Design of record
**[`spec/TODO-EOF-refactor.md`](spec/TODO-EOF-refactor.md)**

- Main body: positional / delimited framing, CORE + runtime consequences, rejected vehicles, open work  
- **Addendum A** — infer kind from grammar shape:
  - soft success / hard success / soft failure exit classification  
  - checkable definition of positional vs delimited  
  - link to descent’s *Inferred EXPECTS*  
  - easy cases in the current grammar  
  - bugs as static checks  
  - layout vs matched body arrangement (embed tidy)  
  - codegen defaults  
  - hard cases / limits  
  - what not to put on the authoring surface  
  - suggested implementation order  
  - short form for inference  

Status banner notes the doc is meant for an independent gap/simplification pass.

### Pointers updated
- `core/TODO-CORE-PARSING.md` — points at Addendum A  
- `spec/TODO-SPEC-CORE.md` — same  
- `tools/descent/TODO-DESCENT.md` — generated-EOF item rewritten as **infer from exits**, not hand boolean  

A red-team agent can start from `spec/TODO-EOF-refactor.md` alone; the other lanes only route there.

## User

Your writeup was very, very useful. I've replaced it with the next version. Would you mind giving it a look and telling me what you think?

## Tools

- Read: /Users/josephwecker-v2/src/udon/spec/TODO-EOF-refactor.md

## Assistant

This is a **clear upgrade** over the previous version. Tighter, better-ordered, and more implementable. A few reactions — strengths first, then residual nits a red-team might still poke.

## What got better

**1. The “why this was confusing” section is the real win.**  
Lexical / syntactic / semantic + “fusion erased the labels” is the right diagnosis. It explains *why* agents kept inventing obligation-theories without re-deriving the whole densification archaeology. That paragraph alone will save future sessions.

**2. The litmus test is load-bearing and correctly placed.**  
“Characters and cursor geometry only” is a sharper boundary than my softer “residue list.” Putting `MissingAttributeValue` *outside* by principle (not as a special case) is the right move.

**3. Soft/hard vocabulary is cleaner.**  
`closer-accept` / `geometric-accept` / `failure` beats soft-success / hard-success / soft-failure for this audience — less overloaded with “soft regions,” more about *what the machine does*.

**4. Failure exits are generated, not authored.**  
That single sentence is the right descent design: authors write two accept shapes; the generator invents unpaid-closer failure. That is what deletes the 89 arms without a parallel closer table.

**5. Line-bound symmetry is excellent.**  
> for positional, EOF ≡ newline+dedent; for line-bound delimited, newline ≡ EOF  

That collapses two families of hand arms into one story. Worth protecting in the CORE rewrite.

**6. Severity bar (“user-facing reason, not precedent”).**  
The freeform-vs-quote example is honest and actionable. Pre-1.0 as non-precedent is the right epistemic stance.

**7. Kind-nesting non-invariant.**  
Explicitly killing “delimited always outside positional” before someone proves a false theorem is good hygiene. Cascades-as-correct is right.

**8. Pushdown/entry-site as frame state.**  
You added the streaming requirement I only implied. Good.

**9. Length.**  
~240 lines of one coherent document vs a long main body + addendum. Easier for a red-team to attack as a unit.

## Judgments I’d keep

- Short form still accurate and complete enough to be the only thing some agents read.  
- Rejected list still kills the right zombies.  
- Vocabulary three-way split on “positional” is still needed; the nest line (text block positional, embed delimited) is clear.  
- Implementation order (static classify → arrange → codegen → fixtures → CORE last) is still right.

## Residual gaps / soft spots (for red-team or you)

None of these undermine the model; they are places the next pass might tighten or where implementers will ask.

**1. Deferred attribute bodies as “positional.”**  
Listed under positional examples. Under the litmus: the *body’s extent* is geometric (yes). `MissingAttributeValue` on OPEN mode is semantic-at-close (correctly out). Worth one half-sentence so no one re-classifies OPEN attr as “delimited because unpaid obligation.” You almost have this in the litmus; an explicit “OPEN attr is positional close + local semantic check” would lock it.

**2. Parameterized / multi-step closers.**  
You dropped the hard-cases table (params like `:q`, freeform `` ``` `` path, closer in callee / BRACKET on caller). Inference still needs those as analyzer specs. Not wrong for a design-of-record doc — but descent implementers will re-ask. A short “Inference must handle: param closers, multi-byte closer paths, BRACKET root vs closer-in-callee” bullet under the grammar/descent direction would keep it from being re-invented.

**3. “Scan for and finds” wording.**  
Short form says delimited constructs close when the parser *scans for and finds* the end-sequence. True for simple cases; brace-depth and fence line-start are *rules*, not raw find. The body already says “printed end-sequence” and “grammar owns exit.” Fine if short form is allowed to be slightly idealizing; a pedant red-team might flag it.

**4. Severity for freeform.**  
You correctly refuse to inherit today’s split. You don’t propose a replacement axis beyond “blast-radius / recovery-ambiguity or uniform.” That’s honest for open work — just know CORE rewrite is blocked on a Joseph call here if freeform is in the first CORE pass.

**5. Identity `[` as delimited.**  
Still right. Unclosed identity is a *new* anomaly surface for consumers who never saw it; worth a fixture note when it lands (you have the open item).

**6. Static reject vs rewrite.**  
You keep both options for inconsistent machines. Prefer picking one default for implementers (I’d lean **reject in descent, rewrite only with explicit override** — quieter for udon grammar cleanup). Minor.

**7. No pointer to probe fixtures / RED names in open work.**  
Fine for design purity; core TODO still has the fixture names. Optional cross-link if someone starts from this file only.

## Tone / process

The bar “where this contradicts current 0.9, change the spec” is strong and correct for pre-1.0, and it matches Joseph’s strengthen-before-soften posture. A red-team should stress-test that bar against live consumers (CONSUMERS.md differential was clean under 0.9; identity-unclosed and freeform severity changes are the only places that might bite *display*, not parse).

## Bottom line

This is the version I’d want an implementer and a red-team to attack. The previous writeup was a good working notes → design; this is **design of record**: principle first, cut second, inference third, rejects and open work last.

I don’t see a hole that reopens the mega-EOF model or forces obligations back in. The main things not fully pinned are **inference edge cases** (params / multi-step / call nesting) and **freeform severity** — both already marked as implementer/Joseph territory rather than model failures.

Ship it as-is for red-team; only add a short inference-edges bullet if you want to pre-empt the first “but freeform?” question from descent.

## User

Great! thank you. Can you read the latest?

## Tools

- Read: /Users/josephwecker-v2/src/udon/spec/TODO-EOF-refactor.md

## Assistant

Read the full current file. This pass lands the pieces that were still open last time — and does it cleanly.

## What changed (and holds)

**1. Two-level severity is the real completion of the model.**  
`Warning` = content kept; document non-success = input incomplete. That is a better principle than Error/Warning as “how bad the syntax feels,” and it matches keep-everything without lying to CI.

The mid-document vs true-EOF distinction is especially good:

- `[1 2` + newline mid-file → frame already closed → Warning, **zero exit**  
- same missing `]` still on the stack at EOF → Warning **+** incomplete result  

Same missing closer, two different situations; CI can tell them apart. That earns its keep.

**2. Document result is not an event.**  
Explicitly not the aggregate-`unexpected-eof` zombie. One bit after unwind (“any delimited frame still open?”) is cheap and correct for both recursive and pushdown.

**3. Prior nits addressed without bloat.**  
- OPEN attr spelled under the litmus  
- Inference edges (params, multi-byte, closer-in-callee) in one bullet  
- Reject-by-default for mixed machines  
- “matches” instead of “scans for and finds”  
- Anomaly posture ladder called out for CORE reconciliation  

**4. Short form still works** as the only thing some agents will read — including the new Warning + non-success bits.

## Small residual checks (not blockers)

**API shape of “non-success.”**  
The doc says `Result::Err` / non-zero CLI exit. Today’s event parser is often callback-based and may not have a single `Result`. Implementers need a concrete host-facing story: e.g. `parse` returns `Ok(events)` vs `Err(IncompleteInput { warnings already in stream })`, or a status flag on the driver after `finish()`. Worth one sentence when CORE/API is rewritten so people don’t invent a wire event.

**Line-bound mid-doc Warning codes.**  
Still `Unclosed*` for newline-cut arrays — same codes, Warning, success result. Confirm fixtures/hosts that currently treat any `Unclosed*` as hard fail get a migration note (code same, severity + exit policy change).

**Cascade + document result.**  
Three nested unclosed at EOF → three Warnings + one incomplete result. Correct; just make sure the “one terminal message” is host/CLI voice, not a fourth stream event.

**Positional-only incomplete files.**  
File ends mid-element without delimited open → silent close, **success** under this model. That is intentional (EOF ≡ dedent). Worth not re-opening: truncated *structure* without a missing *character* is not “unexpected EOF.” If product later wants “truncated stream” detection for pure positional cuts, that is a different mechanism (byte-count / producer signal), not this.

## Verdict

This is **implementation-ready design of record**. The severity ruling resolves the freeform/quote mess without reintroducing obligations or an aggregate EOF event. Layer-recovery story, litmus, cut, inference, rejects, and open work all align.

Nothing here wants another conceptual rewrite before a red-team or a static-classification pass. The only follow-through I’d watch is naming the **host result type** so “non-success” doesn’t get reified as a stream event by accident.

## User

Great work. Would you like to take a shot at going over all of the schema stuff now and writing up your notes or even a proposal?

## Assistant

I'll re-ground in the schema sources and adjacent material, then write a clear notes/proposal document with an honest epistemic status.

## Tools

- Read: /Users/josephwecker-v2/src/udon/design/schema-workbench-2026-07.md (181-430)
- Read: /Users/josephwecker-v2/src/udon/spec/TODO-AUX.md
- Read: /Users/josephwecker-v2/src/udon/design/examples/schema-dsl.udon
- Read: /Users/josephwecker-v2/src/udon/design/examples/ash-like-billing.udon
- Read: /Users/josephwecker-v2/src/udon/design/udon-guarantees.md (81-230)
- Read: /Users/josephwecker-v2/src/udon/design/schema-workbench-2026-07.md (427-706)
- Execute: head -100 /Users/josephwecker-v2/src/udon/test/scenarios/corpus/operata.domain.udon 2>/dev/null; ls /Users/josephwecker-v2/src/udon/test/scenarios/corpus/ 2>/dev/null; ls /Users/josephwecker-v2/src/rowan/lib/archema/resource/ 2>/dev/null | head -30 (Sample operata corpus and rowan resource modules)
- Read: /Users/josephwecker-v2/src/udon/design/file-naming.md (1-30)

## Assistant

Writing a forming-position design note from the sources, then linking it from the schema lane.

## Tools

- Edit: /Users/josephwecker-v2/src/udon/design/schema-notes-2026-07.md
- Edit: /Users/josephwecker-v2/src/udon/spec/TODO-AUX.md
- Edit: /Users/josephwecker-v2/src/udon/design/schema-workbench-2026-07.md

## Assistant

Done. Forming notes/proposal (not ratified) at:

**[`design/schema-notes-2026-07.md`](design/schema-notes-2026-07.md)**

Linked from `spec/TODO-AUX.md` and the top of `design/schema-workbench-2026-07.md` (workbench stays archaeology; notes are the position to argue with).

### What it tries to do

Same job the EOF doc did for EOF, but with **honest pre-ratification status**: freeze candidates + open forks, not “this is law.”

| Section | Content |
|---------|---------|
| **Why** | Indent hazard + rowan-as-customer |
| **Three surfaces** | A core-schema · B dialect typing · C resource/behavior (rowan) |
| **Soft/hard** | Open-world default; absence = soft; comment-locus parallel, not primary |
| **Orthography** | Prefer December trait+attr; Piece 1 dead under 0.9; compact `|str[x]!` as second sugar |
| **Presence ≠ nullability** | Two axes, CORE-aligned |
| **`:one-of` vs `\|one-of`** | Enum vs XOR — different spellings |
| **v0 set** | Content model, attrs, identity, ref shape, open/closed, composition, binding |
| **Profiles** | Casual / Careful / Critical |
| **Binding** | pragma > filename > host; aspirational designator |
| **P1–P10** | Freeze candidates |
| **F1–F7** | Forks that need you |
| **Acceptance** | operata corpus + ash-like + reverse-test |

### Strongest judgments in it (for you to push on)

1. **Schema stays small** — actions/policies are Surface C, same file OK, not core-schema.  
2. **`.string` is a type claim into dialect space**, not a mini type system inside schema (with a lean that core scalars can be named without a dialect).  
3. **Soft-by-default open world** — the mixed-content feature almost nobody else owns.  
4. **Dual orthography allowed** (December resource style + compact data-shape style), one meta-model.  
5. **Parse never schema-aware** — apply/guard/CI is the enforcement locus.

### What I deliberately did *not* do

- Pick a single locus winner  
- Design full evolution/upcast  
- Spec the pragma syntax  
- Pretend rowan↔udon agreement is independent evidence  

When you want to go next: ratify/cut P1–P10 and F1–F7, or red-team the notes the way you did the EOF doc.

## User

Thank you! We're going to leave these as notes for now as we continue working through all of the EOF stuff. Would you mind committing?

## Tools

- Execute: cd /Users/josephwecker-v2/src/udon && git status && echo '====' && git diff --stat && echo '====' && git log -5 --oneline && echo '====' && git diff --stat HEAD && git status -u --short (Git status, diff stats, recent commits)
- Execute: cd /Users/josephwecker-v2/src/udon && ls -la spec/TODO-EOF-refactor.md 2>/dev/null; git log -1 --oneline -- spec/TODO-EOF-refactor.md design/schema-notes-2026-07.md 2>/dev/null; git status --short (Check EOF doc and remaining uncommitted files)
- Execute: cd /Users/josephwecker-v2/src/udon && git add design/schema-notes-2026-07.md design/schema-workbench-2026-07.md spec/TODO-AUX.md && git commit -m "$(cat <<'EOF'
Schema notes: forming design note for the constraint layer

Capture a Joseph-facing position on core-schema vs dialects vs resource
behavior, December orthography, open-world soft default, and v0 freezes.
Leave unratified; link from the workbench and TODO-AUX while EOF work
continues.
EOF
)" && git status && git log -1 --format=full (Stage schema notes and commit)

## Assistant

Committed as `d0711fc`:

**Schema notes: forming design note for the constraint layer**

- `design/schema-notes-2026-07.md` (new)
- `design/schema-workbench-2026-07.md` (pointer)
- `spec/TODO-AUX.md` (pointer)

Working tree is clean. EOF material was already on `main` (e.g. `d5fa03a`); this commit is only the schema notes side. Branch is 11 commits ahead of `origin/main` (not pushed).