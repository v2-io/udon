# libudon Development Plan

Parser implementation using descent (~/src/descent/).

## Architecture

descent **replaces** the old parser infrastructure entirely. The old ring-buffer,
ChunkSlice, ChunkArena, genmachine architecture is gone. descent generates clean
callback-based recursive descent parsers from `.desc` specifications.

**Key insight from implementation-phase-2.md:** The streaming event model is the
foundation, not a feature. The parser emits events as it parses—no accumulation.
The tree builder (when implemented) will be just another event consumer.

## Current Status

**Branch:** `main` (updated 2026-07-08; see `~/src/udon/REVIEW-JULY-2026.md` for current state)

### What Works

- [x] Elements with names (`|element`)
- [x] Element identity (`|element[id].class1.class2`)
- [x] Element suffixes (`?`, `!`, `*`, `+`)
- [x] Sameline attributes (`:key value`)
- [x] Block (indented) attributes
- [x] Multiple sameline attributes (`:a 1 :b 2 :c 3`)
- [x] Typed values via context-aware parsing:
  - Integer (decimal, hex 0x, octal 0o, binary 0b)
  - Float (with decimal or exponent)
  - Rational (`1/3r`, `22/7r`)
  - Complex (`3+4i`, `5i`, `3.5-2.1i`)
  - BoolTrue, BoolFalse (`true`, `false`)
  - Nil (`null`, `nil`)
  - BareValue (unquoted strings)
  - StringValue (quoted `"double"` and `'single'`)
- [x] Keywords via PHF perfect hash (`|keywords` directive)
- [x] Context-aware terminators (block/sameline/embedded/array)
- [x] Proper EOF handling via `|eof` directive
- [x] Text/prose content
- [x] Basic indentation hierarchy
- [x] Nested elements
- [x] Embedded elements (`|{name attrs content}`)
- [x] Arrays (`[a b c]`)
- [x] Comments (`;` line comments and `;{brace comments}`)
  - Comment is now BRACKET type (CommentStart/Text/CommentEnd)
  - Uses same "children loop" pattern as Element for continuation
  - Continuation lines preserve their indentation in Text content
- [x] Block-level escape prefix (`'` before `|;:!'` at line start)
- [x] Directives (`!if`, `!elif`, `!else`, `!for`, `!let`, `!include`, `!unless`)
- [x] Raw blocks (`!:lang:`) and inline raw (`!{:lang:content}`)
- [x] Interpolation (`!{{expr}}`, `!{{expr | filter}}`)
- [x] Inline element nesting (proper sibling detection on sameline)
- [x] Freeform blocks (```) inside elements
- [x] Prose content_base tracking:
  - First prose line establishes content_base
  - Extra spaces beyond content_base preserved in output
  - Warning event on inconsistent (decreased) indentation
  - content_base updated on inconsistent indent

### What Needs Work

- [ ] **Fixture coverage** - Many fixtures have empty events, need SPEC-based expectations
- [ ] **Variation test edge cases** - Some edge cases with indentation variations
- [x] **value.rs evaluation** — moot: value.rs was deleted with the Tree API commit (a6d23e7)

## Spec Alignment — catch up to CORE (2026-07-13)

CORE.md was brought current with the ratified decisions on 2026-07-13
(identity `key`/`traits`, `<…>` typing, fences, escapes, `@`-inert, etc.). The
**spec is now ahead of the parser**; these are the parser/grammar changes that
close the gap. Spec-text is done (in CORE); this is the *impl* worklist.
Defect numbers reference `~/src/udon/REVIEW-JULY-2026.md` §4.

- [ ] **Wire-names:** grammar emits `$key`/`$traits`/`$?…` (the `$id`/`$class`
      symbols in `udon.desc`), no `id`/`class` aliases.
- [ ] **`:id`/`:class` hijack** (defect #4 residual): a bare `:id foo` must be an
      ordinary attribute; `tree.rs` should intercept `$key`/`$traits`, not
      `"id"`/`"class"`, and independent of value type.
- [ ] **Typed bracket/key values** (defect #2): `[01]`→int, `["01"]`→string
      (route bracket content through the typed-value path, not raw capture).
- [ ] **`:`-attributes-before-children** enforcement (defect #9): a `:` after
      content has begun is prose, not an attribute.
- [ ] **Document-layer duplicate-`(element,key)` check** + policy enum
      (`error | allow-if-identical | first-wins | last-wins | keep-all`, +warn).
- [ ] **Head-position `!{{value}}`** wraps in a block Directive; should surface
      as prose + Interpolation.
- [ ] **Accessors** (tree / udon-utl): `attr` (scalar/last) + `attr_all` (list);
      `traits` view always a list.
- [ ] **Streaming rebuild** (defect #1): explicit-stack backend in descent-core.
- [ ] **Escape model rewrite (2026-07-14): `\` head-position force-prose.** CORE
      "Escape (`\`)" replaced the old marker-list escape with one positional rule.
      The grammar is on the *old* model and non-compliant in several ways:
      - Escape delimiter is `'` (apostrophe) via `:check_apos` (`udon.desc:98–104`),
        not `\`. `'` is now an ordinary prose char; `\` is the escape.
      - `\` at **head position** (line-start *and* the sameline scan before prose)
        is consumed and forces the rest of the line to verbatim prose. The
        dispatch has no `\` arm today (`udon.desc:73–81`), so a leading `\` is
        currently just prose.
      - The consumed `\` takes up **no column**: it anchors the prose block's
        content-base at its column (only the first line needs it) and the text
        after backs up one column. Interacts with Automatic Prose Dedentation.
      - `\` **not** at head position (prose begun, mid-value, trailing) is passed
        through literally — no `\;` escape, no `\|{` escape. Retire `check_apos`
        and all sameline/embedded `\;` handling.
      - **New Warning:** a leading `\` sitting *deeper* than an established prose
        content-base is mid-prose → passed through literally + Warning.
      See CORE "Escape (`\`)", "Literal Semicolons", "Unified Inline Syntax".
- [ ] **Reference divergences (found 2026-07-14):** (a) `@` at block-line-start
      makes a reference only on `@[` (`udon.desc:92–94`); CORE:236 also allows
      `@element[key]` / `@ident`. (b) The grammar still carries the `:[id]`
      attribute-merge (`udon.desc:497`, `attr_reference`) that CORE removed
      (merge is now a host resolution mode, "References and Mixins"). Parser lags.
- [ ] **multi-attr block-line Warning** (decided 2026-07-14: keep EOL semantics,
      warn): emit a Warning when a block value contains a stranded ` :word ` that
      looks like an intended second attribute. The value still runs to EOL; see
      CORE "Block Attribute Values".
- [ ] **Trait-suffix chars (D-TRAIT-SUFFIX)** — `*!?+` are legal *bare trait*
      characters, so `.foo?` = the trait `"foo?"` (not trait `foo` + suffix), and
      `.foo ?` (space) = trait `foo` + `$?`. Parser currently splits the suffix
      off in both cases. Maximal-munch on the trait; see CORE "Element
      Suffixes". *(Was missing from this list — found by the 2026-07-14
      examples-vs-parser audit; spec is correct, parser lags.)*
- [ ] **`0d` / `0D` explicit-decimal prefix** (ratified 2026-07-14) — add a
      `d`/`D` arm to `num_zero` in `values.desc` so `0d42` parses as the integer
      `42` (currently falls back to String). Sibling to the existing
      `0x`/`0o`/`0b` prefixes; the "natural written form" rationale is in
      CORE "Numbers". *(Rational/complex bare-vs-dialect is NOT here — it's
      an open design fork, not a parser task; see `design/composite-types.md`.)*
- [ ] **`<…>` explicit-typing envelope** — recognize `<…>` in attribute-value
      position (`>` terminates), the label ladder (`<type:…>` / `<dialect:type:…>`),
      unlabelled dialect dispatch, and route to dialects. Bare temporal → string.
      Zero fixtures today (biggest test hole). See CORE "Explicit Typing".
- [ ] **Regenerate** parser + update fixtures/tests (SPEC-based expectations,
      never traced from parser output).

**Known benign warning (2026-07-14):** `cargo build` emits two `unreachable
pattern` warnings at `parser.rs:4070` — the ISO-duration arm peels off
`b'p'|b'P'` first, then a catch-all letter alternation redundantly re-lists
them. Correctness is unaffected (`P…` routes to duration correctly). It lives in
the **bare-temporal** duration path (`values.desc`, `IsoDurStart`), which is
slated for removal when bare temporal → string / moves to a `<…>` dialect — so
gutting that path clears the warning for free; don't hand-touch the held grammar
just for this.

### Test-first worklist (from the 2026-07-14 test-suite audit)

**Fixtures to UPDATE when the parser flips** (they encode the old model — rewrite
expectations to the spec, not to parser output):
- `temporal.yaml` (~40 cases) + `canonical.rs::fuzz_temporal_values` + `elements.yaml:226` — bare temporal now emits String/`BareValue`, not Date/Time/Duration.
- `escapes.yaml`, `escape_prefix.yaml`, `literal_escape.yaml`, `spans.rs` (escaped-prefix tests) — `'`→`\`: rewrite `'|`/`':`/`';`/`''`/`'!` to `\|`/`\:`/`\;`/`\\`/`\!`; a bare `'|…` line is now prose *with* the apostrophe.
- `references.yaml` — `:[id]` merge removed; mixin fixtures are non-core now.
- The `id`/`class` → `$key`/`$traits` rename (~60 expectations across element_*/attributes/embedded/etc.) — flips with the wire-name item above.

**NEW fixtures needed** (green-field — new affordances with ~no coverage):
`<…>` typing (all forms + dispatch); attribute stacking (`:x 1 :x 2`→`[1,2]`; `:x [1 2] :x [3]`); `@`-inert (explicit form, value-position, ambiguous-key error); duplicate-definition policy enum; head-position edges (re-entry after prose, scan-through-attributes, indented-past-prose=prose); `:`-after-content=prose (defect #9); fence head/scan (sameline-after-attrs opener, after-prose=literal, deeper-than-prose=literal, any-indent closer + newline, indented-closer-whitespace-in-body); `\`-escape block forms + `\hello`=literal; multi-attr block-line Warning; array quote-ends-item + `}`-literal-in-`[…]` + UnclosedArray; typed bracket keys (`[1]`→Integer, `["01"]`→String).

## Phase 3: Build Forward (IN PROGRESS)

### 3.1 Test Infrastructure ✓

- [x] Test harness for descent event model (canonical.rs)
- [x] YAML fixture format with expected events
- [x] Variation testing (random indentation, sibling elements)
- [ ] Extract more test cases from SPEC.md examples
- [ ] Property-based testing for edge cases

### 3.2 Core Grammar - COMPLETE

All core grammar features implemented:
- [x] Quoted strings (`"double"` and `'single'`)
- [x] Arrays (`[item1 item2 item3]`)
- [x] Element suffixes (`?`, `!`, `*`, `+`)
- [x] Embedded elements (`|{name attrs content}`)
- [x] Comments (line and brace)
- [x] Block-level escapes (`'|`, `';`, etc.)

### 3.3 Directive System - COMPLETE

- [x] Block directives (`!if`, `!elif`, `!else`, `!for`, `!let`, `!unless`)
- [x] Inline directives (`!{name args}`)
- [x] Raw directives (`!:lang:` block and `!{:lang: content}` inline)
- [x] Interpolation (`!{{expr}}`, `!{{expr | filter}}`)

### 3.4 Cleanup

- [x] Removed `udon-core/src/values_parser.rs` (obsolete)
- [x] Removed `udon-core/benches/values.rs` (used values_parser.rs)
- [x] Evaluate `udon-core/src/value.rs` — moot, deleted in a6d23e7

## Fixture Status

### CRITICAL WARNING

**DO NOT fill fixture expectations by tracing parser output.**

This anti-pattern has happened multiple times and cements bugs as expected behavior.
Work will be reverted if fixtures are filled this way.

**Correct workflow:**
1. Read CORE.md for the feature
2. Write fixture expectations based on SPEC
3. Run tests - they WILL fail
4. Fix the PARSER to match SPEC
5. Tests pass

### Audited Against SPEC
- [x] **value_types.yaml** (23 tests) - All value types per SPEC
- [x] **prose_dedentation.yaml** (13 tests) - Audited, comments fixed
- [x] **literal_escape.yaml** (5 tests) - Filled per SPEC 104-130, ALL PASS
- [x] **indentation_hierarchy.yaml** (7 tests) - Filled per SPEC 543-820, ALL PASS
- [x] **inline_comments.yaml** (8 tests) - Audited, 1 bug exposed (space after comment)
- [x] **comments.yaml** (30+ tests) - Comprehensive audit, 6 bugs exposed
- [x] **references.yaml** (4 tests) - Filled per SPEC 1412-1489, ALL PASS
- [x] **indentation_edge_cases.yaml** (5 tests) - Filled per SPEC 543-639, ALL PASS
- [x] **arrays.yaml** (15 tests) - Multiline array filled per SPEC 325-329, ALL PASS
- [x] **embedded_elements.yaml** (24 tests) - Audited per SPEC 1026-1076, ALL PASS
- [x] **inline_element_nesting.yaml** (11 tests) - Audited per SPEC 543-768, ALL PASS
- [x] **comments_and_text.yaml** (7 tests) - Already complete, ALL PASS
- [x] **comments.yaml** (31+ tests) - Comprehensive, continuation normalization working

## Known Parser Bugs

Discovered while filling fixtures - need grammar fixes:

1. **Interpolation in attr values not implemented** (SPEC 904-910 notes this)
   - `|{a :href !{{url}} text}` - `!{{url}}` is not recognized as interpolation
   - Currently treated as literal text, braces get mangled

2. ~~**Text before nested embedded elements lost**~~ - FIXED
   - Text content before nested `|{...}` now captured correctly

3. **Empty Text events after nested embedded**
   - Nested embedded elements emit `Text ""` after closing
   - Not a bug per se, but could be optimized away

4. **SPEC Update:** Removed `~` as Nil synonym (only `null`/`nil` now)

5. ~~**Block prose semicolons should be LITERAL**~~ - FIXED (SPEC line 408)
   - Parser now treats `;` in block prose as literal text
   - `;` at line start is still a block comment per SPEC 459-466

6. ~~**Comment continuation not implemented**~~ - FIXED (SPEC lines 419-428)
   - Comment refactored to BRACKET type (like Element)
   - Uses same "children loop" pattern for continuation lines
   - Each continuation line is a separate Text event inside CommentStart/End
   - **Normalization**: First continuation line sets content_base (like prose)
     - Lines at content_base have no indent in output
     - Extra indent beyond content_base is preserved
     - Lines with less indent trigger warning and reset content_base

7. ~~**Space after inline comment stripped**~~ - FIXED (SPEC line 495)
   - After inline comment, now goes to `:post_sameline_inline` instead of `:pre_content`
   - Spaces after `}` are preserved in text content

8. ~~**Block-level references not implemented**~~ - FIXED (SPEC 1473-1488)
   - `@[id]` at block level emits Reference event
   - `:[id]` in attribute position emits Reference event

9. ~~**Elements after prose at content_base not recognized**~~ - FIXED
   - `:at_content_base` state had `->[' ']` which skips TO next space
   - This caused `|element` after prose to be swallowed entirely
   - Fixed by removing erroneous `->[' ']` actions

## Grammar DRY Refactoring

### Completed

- [x] `array` - unified from 3 variants, owns `[` delimiter
- [x] `prose` - unified with prepend parameter
- [x] `value` - unified with space_term and bracket parameters
- [x] Character literals instead of magic numbers
- [x] `inline_*` → `sameline_*` per SPEC vocabulary
- [x] Unicode identifier support (XID_Start/XID_Continue)

### Remaining

- [ ] `double_quoted` vs `single_quoted` - could parameterize
- [ ] values.desc number parsing - 21 nearly-identical states

## Grammar Clarity Principles

1. **Functions describe complete constructs** — `array` parses `[...]` including delimiters
2. **States have single responsibilities** — separate `:entry`, `:content`, etc.
3. **Callers dispatch, callees consume** — callers check, callees own their syntax
4. **Delegate to appropriate abstractions** — `array` calls `/value`, not quote parsing

## Phase 4: Multi-Chunk Streaming & Performance

From descent TODO - resumable state machine for true streaming:

```rust
loop {
    match parser.parse(chunk, on_event) {
        ParseResult::Complete => break,
        ParseResult::NeedMoreData => {
            chunk = get_next_chunk();
        }
    }
}
```

**Tasks:**
- [ ] Multi-chunk streaming in descent (ParseResult enum)
- [ ] Cross-boundary token handling
- [ ] Benchmark suite (criterion)
- [ ] Memory profiling on large files

## Phase 5: Tree Builder

Build arena-allocated tree from events:

- [ ] `Document` and `Node` structs with arena allocation
- [ ] Tree builder that consumes parser events
- [ ] Navigation (parent, children, siblings)
- [ ] Simple selectors
- [ ] String interning for element/attribute names

## Phase 6: Language Bindings

### Ruby (udon-ruby)
- [ ] FFI layer for streaming API
- [ ] Lazy tree projection
- [ ] Update to use callback-based parser

### Other Targets
- [ ] WASM build
- [ ] Python via PyO3
- [ ] C ABI shared library

## Key Files

| File | Purpose |
|------|---------|
| `generator/udon.desc` | Main parser grammar |
| `generator/values.desc` | Value type parsing (concatenated) |
| `udon-core/src/parser.rs` | GENERATED by descent - do not edit |
| `regenerate-parser` | Script to regenerate parser |

## Reference

- `~/src/descent/CLAUDE.md` - descent usage guide
- `~/src/udon/spec/CORE.md` - **Authoritative UDON specification**
- `~/src/udon/FULL-EBNF.md` - Extracted EBNF
- `~/src/udon/implementation-phase-2.md` - Ideal streaming architecture
- `~/src/udon/parser-strategy.md` - Multi-language strategy
