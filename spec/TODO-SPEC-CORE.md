# TODO-SPEC-CORE — open edits to the core spec (`CORE.md`)

**Scope: only edits to `CORE.md` itself.** Event-parser / grammar work lives in
`../core/TODO-CORE-PARSING.md`; companion & dialect spec work in
`TODO-SPEC-OTHER.md`.

> *Discipline (META-1): read the CORE section before editing or advising on
> it, and re-grep line numbers — they drift.*

---

## Open

- [ ] **Adjudicate `FULL-EBNF.md`'s fate** (raised 2026-07-14). It is a derived,
      perpetually-lagging illustrative grammar; a second grammar artifact
      undercuts CORE-as-sole-source-of-truth and it has already caused confusion
      (cited as if corroborating CORE). Decide: delete / reduce to a pointer /
      keep. Deferred by Joseph for a deliberate call.
- [ ] **Silences found while authoring the v0.8 fixtures (2026-07-15).** Each
      is encoded in `core/fixtures/v0.8/` under one stated reading, flagged
      with a `⚠` comment at the case; CORE should either ratify that reading
      or correct it (then the fixture follows CORE). *(discuss w/ Joseph)*
      - **`<…>` interim behavior** — RATIFIED (Joseph, 2026-07-15) and now
        in CORE "Explicit Typing": until dialects exist, the envelope is
        recognized (`<>`-balanced, terminates the value) but emits
        `Warning "No dialects loaded"` and passes through as the plain
        string `"<…>"`. The dialect-era event shape is decided when
        dialects land (`typing_envelope.yaml` follows the interim).
      - **`<…>` in array items** — "attribute-value position": does an array
        item count? Fixtures + grammar say yes (uniform value rules);
        ratify in CORE's wording.
      - **RATIFIED (Joseph, 2026-07-15): references are selector tuples**
        `(element, key, traits)` — provisional until a path syntax replaces
        the whole thing wholesale. `@[mit]` → `(null, 'mit', [])`;
        `@licence` → `('licence', null, [])`; `@licence[mit]` →
        `('licence', 'mit', [])`; `@.realized` → `(null, null,
        ['realized'])`. Traits are SELECTION criteria, not augmentation —
        "not augmentable" survives with sharpened meaning; matching
        multiplicity is consumer-side; inertness untouched. Notably absent
        by design: suffixes, attributes, predicates, nesting.
        **Supersedes** the raw-string payload convention currently
        implemented AND the `@[mit].trait`-is-prose fixture reading (that
        form is now a legal selector). **Execution deferred**; proposed
        event encoding when taken: reuse the element-identity machinery —
        `ReferenceStart` / `Name` / `Attr "$key"`+value / `Attr
        "$traits"`+value / `ReferenceEnd` — giving typed keys, quoted
        names/traits, and trait stacking for free, symmetric with
        definition-side identity. Fixtures to update: `references.yaml`
        (all payloads), `markers.yaml::at_bracket_is_reference`,
        `values.desc`/`udon.desc` reference functions, tree.rs
        `NodeKind::Reference` → structured fields.
      - **Structured attribute values** — event shape for "attribute +
        newline + indent = structured value" (fixtures: `Attr` with no value
        event, children follow — indistinguishable from element children in
        the flat stream; `attributes.yaml::structured_attribute_value`).
      - **Raw-block dedent rule** — "relative to the directive's indent
        level" is not an exact stripping rule; fixtures use
        first-content-line base, relative indent kept.
      - **Multiline embedded `|{…}` content delivery** — per-line Text vs
        joined; fixtures encode per-line.
      - **Prose between embedded siblings** — a single space between two
        `|{…}` forms: fixtures keep it as `Text " "` (round-trip fidelity);
        the legacy parser consumed it.
      - **RATIFIED (Joseph, 2026-07-15): warnings get working CODES, not
        ratified strings.** CORE gains a table of warning codes with
        descriptions — e.g. `warn:InconsistentIndentation`,
        `warn:NoDialects` — and states that the actual warning TEXT, and
        whether a given warning is emitted in given circumstances, is a
        parser/host decision (menu-vs-knob: spec fixes the code
        vocabulary; hosts pick voice and verbosity). **Naming convention
        (Claude's pick, per Joseph 2026-07-15 — his examples were
        illustrative)**: PascalCase condition-names mirroring
        `ParseErrorCode` exactly, so the Rust side is one `WarningCode`
        enum with no translation layer; the spec table lists Code /
        Description / typical layer (non-normative, from the
        warning-placement guideline) — emission circumstances always
        host's. Execution deferred: the CORE table; Warning events carry
        codes (harness/fixtures match codes, ending string-brittleness).
        Initial inventory: `InconsistentIndentation`; `NoDialectsLoaded`;
        `EscapeOutsideHeadPosition` (AST layer — see below);
        `CommentMissingFollowingSpace` (optional advisory, `;`-framing
        ruling); attribute-model advisories when that model lands:
        `UnmarkedBooleanFlag`, `ValuedBooleanKey`, `MarkerInTextValue`,
        `DistantAttributeBlock`. The stranded-attr warning died with the
        attribute model; ordering-vs-value-event questions get specified
        per-code in the table only where a code survives that cares.
      - **RATIFIED (Joseph, 2026-07-15): past-base `\` warning is
        AST-layer.** The event parser's inner loop exists to pull bytes
        without inspecting them (SCAN/memchr); a per-line
        leading-whitespace peek for a rare stylistic slip doesn't belong
        there. The literal-passthrough BEHAVIOR stays event-level (already
        conformant); `EscapeOutsideHeadPosition` moves to the AST warning
        ledger. Execution: drop the Warning from
        `escape.yaml::escape_past_base_is_literal_with_warning` (flips
        RED→GREEN), close the CORE-PARSING item into the ledger, add one
        CORE sentence when the warning table is written.
      - **Inline raw `!{:kind: …}` details** — deferred by Joseph
        (2026-07-15); discuss later.
      - **RATIFIED (Joseph, 2026-07-15): comment continuation is uniform.**
        Everything deeper than the comment's column is comment TEXT (inert,
        never parsed) until a line at or dedented from it — the prefix
        exclusion was unfounded overspecification; block-comment-out is a
        primary use case. In CORE Comments; grammar simplified; fixtures pin
        the composite and the block-comment-out case.
      - **RATIFIED (Joseph, 2026-07-15): `;` framing by context.** The
        both-sides ' ; ' frame is enforced ONLY where it earns its keep:
        sameline (including attribute-rooted lines) AND unquoted prose/text
        already started — i.e., exactly the emoticon territory. Everywhere
        else in scan position (post-value, post-attr, pre-prose) the
        ordinary space-preceded `;` opens a comment, no following-space
        requirement (precedent: YAML and POSIX shell force preceding-only;
        only MySQL's `--` forces following; nobody forces both). Matches
        current parser behavior — execution is CORE wording only. A
        missing-following-space advisory may exist as a warn-code per the
        warning-code ruling below; emission is host's choice.
      - **RATIFIED (Joseph, 2026-07-15): sameline `;` vs prose-commit.** "Head
        Position" says that once a line commits to prose, *any* later marker
        character on it is literal; the Comments table (and the
        `|li Item one ; TODO` example) says ` ;` in sameline prose starts a
        comment. RESOLVED: the carve-out was a forgotten practical decision;
        now a named lexeme — *sameline comments*, whitespace-framed (space
        before; space or EOL after) — written into CORE Head Position +
        Comments. Grammar + fixtures follow.
      - **Text granularity** — RATIFIED (Joseph, 2026-07-15): a Text event
        carries NO guarantee of being a complete text run; escapes and
        (later) chunk boundaries may split one line's prose into several
        Texts, and consumers concatenate. **Remaining: write this into
        CORE's parser-behavior notes.** The fixture harness now collapses
        same-line adjacent Texts (span-gap contains no newline) so fixtures
        are rhythm-independent (`harness.rs::collapse_adjacent_text`).
      - **Comment-past-prose-base — internal contradiction.** "Comments and
        Indentation" shows `;` one column past the prose base parsing as a
        comment inside the element; "Head Position" says a line deeper than
        the prose base is inside the prose, markers literal. Fixtures encode
        the uniform Head-Position reading (deeper = prose;
        `comments.yaml::comment_deeper_than_prose_base_is_prose`); the
        Comments example needs updating or an exception carved.
      - *(the deferred inline-raw item above carries the details: space
        after the label's closing `:` — separator or content; whether the
        inline form carries the block form's `Raw` marker event. Fixtures
        currently encode: separator; yes.)*
- [ ] **Filename-designator ↔ pragma binding** — when the schema layer lands,
      bind a document's filename designator to its pragma (its dialects + schema).
      *(discuss w/ Joseph)*

---

## Design notes feeding future rulings

- **[The Attribute Model — hash & array, edges & nodes](../design/attribute-model-2026-07.md)**
  *(2026-07-15, provisional — converged brainstorm, Joseph + Claude).* The
  full reconception of attribute values: one value per declaration (scalar,
  node — no anonymous wrapper — or greedy text block); first-character
  typing commitment; uniform line scan (supersedes stranded-attr Warning +
  run-to-EOL when ratified); the `?` flag convention; identifier charset
  expansion (`/`, `?!*+` in keys); the map-side rationale for `<…>`; the
  warning-placement guideline. Open forks are collected in its §13, with
  *(Joseph- please look at this)* markers inline. **Ratify from that
  document; do not re-derive here.**

*(Otherwise CORE is current with all ratified decisions as of 2026-07-14.
History lives in git; decisions in `_archive/DECIDED.bak.md`.)*
