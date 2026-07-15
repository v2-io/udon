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
      - **Reference event payload** — proposed: the raw text after `@`
        (`@[mit]` → `"[mit]"`, `@license[mit]` → `"license[mit]"`); legacy
        stripped brackets from the shorthand (`references.yaml`).
      - **`@[mit].trait` parse behavior** — CORE forbids augmentation but not
        what a written tail parses as; fixtures encode prose-continuation.
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
      - **Warning payloads** — the harness exact-matches Warning content;
        fixtures reuse legacy `"Inconsistent indentation"` and coin
        `"Escape not at head position"` / `"Possible second attribute in
        block value"` — strings need ratifying (or Warning codes).
      - **Warning ordering** — whether a block-value Warning precedes or
        follows the value event (`attributes.yaml::block_line_holds_one_attribute`).
      - **Sameline `;` vs prose-commit — internal contradiction.** "Head
        Position" says that once a line commits to prose, *any* later marker
        character on it is literal; the Comments table (and the
        `|li Item one ; TODO` example) says ` ;` in sameline prose starts a
        comment. Both can't hold. Fixtures encode the Comments-table reading
        (`comments.yaml::sameline_prose_comment`); "Head Position" likely
        needs an "except ` ;`" carve-out or the table needs changing.
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
      - **Inline raw `!{:kind: …}` details** — whether the single space after
        the label's closing `:` is separator or content, and whether the
        inline form carries the same `Raw` marker event as the block form
        (fixtures: separator; yes).
- [ ] **Filename-designator ↔ pragma binding** — when the schema layer lands,
      bind a document's filename designator to its pragma (its dialects + schema).
      *(discuss w/ Joseph)*

*(Otherwise CORE is current with all ratified decisions as of 2026-07-14.
History lives in git; decisions in `_archive/DECIDED.bak.md`.)*
