# TODO-SPEC-CORE 0.9 supplement — attribute-model nail-downs

Small rulings and collateral edits the 0.9 attribute-model promotion
(proposal-3 + substrate-3 → CORE) forces. Each gets decided either at its
natural spot while writing the spec (with a recommendation surfaced to
Joseph there), or in the sweep-up pass when the 0.9.0-alpha.1 spec text is
essentially finished (see the revisit item in `TODO-SPEC-CORE.md`).

**Context — ruled 2026-07-15, carried here so the items below make sense:**
the sameline scan stays *provisionally open* at a bare value token's
boundary; the next non-space character decides — a head-position marker
(`:` next attr, `\` force-prose, guarded `|`, guarded `@`, framed ` ; `,
fence, guarded `!`) means the token finished as a single-token value and the
scan continues; plain text commits the rest of the line as a text blob owned
per binding priority (open attr first). `|el :alpha true story` →
`alpha="true story"` (no keyword carve-out; flags cover keyword-then-prose).
Version plan: v0.8 frozen + tagged; the model is landing as **0.9.0-alpha.1**
with the `core/fixtures/v0.9/` group.

**Ruled 2026-07-15 (review pass, now in CORE — listed so nobody re-opens
them):** `@` guard extended to `.` (`@.trait-only` parses) and `@` has equal
footing with `|` in the sameline scan; embedded `|{…}` framed ` ; ` comments
ruled OUT for now (bare `;` literal, `;{…}` only — revisit with dialects);
`\`-forced text (head- or value-position) is line-verbatim but inline forms
still fire, and framed ` ; ` is literal there; spaced-trait identity form
(`|name[key]? .trait`) dropped — identity is contiguous except the trailing
spaced suffix; sameline tail prose DOES enter children phase (later block
`:key` = prose + `AttributeAfterChildren`); anomaly posture = warn-and-keep
(a) wherever coherent, errors are non-halting events, drop/halt/reject are
AST/app-layer config (CORE "Anomaly posture").

## Open

**Status 2026-07-15: the 0.9 CORE Attributes text is DRAFTED and
review-passed once** (fresh-eyes agent; blockers + significant findings
fixed). Items marked *drafted (R#)* are resolved in the draft by an explicit
recommendation — open until Joseph confirms each.

### Draft rulings awaiting confirmation

- [ ] **Embedded context (`|{…}`) under the new model** — *drafted (R2)*:
      embedded = element-rooted sameline with `}` as an extra terminator.
      Consequences drafted explicitly: `|{input :required}` errors (write
      `:required?`); an open bare attr's trailing tail is the attr's blob, so
      `|{a :href /home :title Home here}` gives `title="Home here"` and NO
      embedded content — this **changes a long-standing canonical example**;
      confirm deliberately. Fixture updates follow
      (`attributes.yaml::embedded_flag_attr_before_brace` and kin).
      *(discuss w/ Joseph)*
- [ ] **Block-line `\` at the boundary** — *drafted (R3)*: value closes; the
      rest of the line is the element's prose. CORE "Value-Position `\`".
- [ ] **Quoted keys never flag** — *drafted (R4)*: terminal-`?` flag
      semantics apply to **bare** keys only; a quoted key (`:'$?'`,
      `:'key?'`) is always a plain attribute. Keeps the suffix-sugar target
      `:'$?' true` plain. CORE "Attribute Keys and Flags".
- [ ] **Event vocabulary for multi-segment / node values** — *drafted (R5)*:
      single scalar/reference/interpolation keeps `Attr` + one value event
      (0.8 wire, low churn); node / text-blob / multi-segment values bracket
      with `AttrStart` … `AttrEnd` around ordinary events. Names working
      until the fixture group lands. `tree.rs` + harness follow. *(discuss
      w/ Joseph)*
- [ ] **Warning-code names (P3-7)** — *drafted as working names* in the CORE
      warning-codes table: `AttributeValueExtendedByTrailingText`,
      `AttributeSecondValue`, `AttributeAfterChildren`; errors
      `MissingAttributeValue`, `AttributeUnderAttribute`. Dead forecast codes
      pruned. Finalize strings at fixture landing.

### From the 2026-07-15 fresh-eyes review — needing rulings

- [ ] **EOF behavior (review S11).** Unspecified everywhere: EOF inside
      `|{…}` (indentation-immune, only `}` closes — what if it never comes?),
      inside a freeform fence (closer "must be followed by a newline" — file
      ends without one?), inside quoted strings / `<…>` envelopes / `[…]` /
      `!{{…}}` / an open deferred attribute value; whether pending
      ElementEnds flush. Matters doubly for streaming. The anomaly-posture
      (a) instinct suggests: close everything implicitly at EOF, warn/error
      per construct — needs a per-construct table. *(discuss w/ Joseph)*
- [ ] **Flag key alone on a block line with deeper material (review M3).**
      `:a?` on its own line, deeper indented lines follow. Flag finishes
      `true` at EOL, so is the deeper text `AttributeSecondValue` ingest,
      element prose, or error? Recommendation: `AttributeSecondValue`
      warn+ingest, for uniformity with finished values. *(discuss w/ Joseph)*
- [ ] **Mid-token typed-path failure → single token or blob (review M5).**
      Recommendation: after fall-through, the token is an ordinary bare
      token and the boundary rule applies at its end. So `:x 12ab :y 3` →
      `x="12ab"`, `y=3` (boundary is `:`), while `:x 12ab more` → blob
      `x="12ab more"` (boundary is text). One sentence in CORE "The Scan"
      settles it. *(discuss w/ Joseph)*
- [ ] **Raw block as sameline node value (review M4).** `|el :script !:sh:`
      + deeper lines — allowed? Where does the raw body indent from?
      Currently only the block-line-initial form is illustrated. *(discuss
      w/ Joseph)*
- [ ] **`<…>` envelope across newlines (review M2).** `:x <a` EOL `b>` —
      error, multi-line envelope, or blob text? Recommendation: envelope is
      single-line at 0.9 (newline before `>` = unclosed → warn + pass
      through as text); revisit with dialects. *(discuss w/ Joseph)*
- [ ] **Interpolation terminator (review M1).** `!{{ {"a":1} }}` — first
      `}}` or brace-counting? Core lexing question even though the language
      inside is DYNAMICS. *(discuss w/ Joseph)*
- [ ] **Tabs scope (review M6).** Tab in indentation is `NoTabs` — but tab
      *inside* prose or a value? Tabs-only unmixed indent? One sentence.
- [ ] **Reconsider the "guard" framing / Marker Recognition section**
      (Joseph, 2026-07-15): reads as lexical-implementation detail,
      partially redundant with each marker's own section (it was written
      pre-spec-read by an earlier agent). Options: fold each guard into its
      marker's section; demote to a non-normative recognition summary; or
      keep but tighten. Do this together with the hard-wrap removal pass,
      after the model text settles.

### Editorial / smaller (review minors)

- [ ] `CommentMissingFollowingSpace` description self-undermines (M9) — only
      coherent for no-frame contexts; reword.
- [ ] `InconsistentIndentation` description's comment-continuation clause
      (M10) — a dedented continuation line ends the comment; state which
      case actually warns.
- [ ] Stack-vs-list host-view collapse (M7) — `:x 1 :x 2` vs `:x [1 2]`
      read identically through the ergonomic view; add a wire-vs-view note
      in Host Views.
- [ ] Node-value one-way door (M14) — `|api :headers |header :k v :timeout 30`
      silently gives `timeout` to the header; true by rule, add a called-out
      trap note in Node Values.
- [ ] Prose-deeper-than-base swallows structure (M15) — cross-reference the
      Head Position prose exception from the Hierarchy chapter.
- [ ] Undefined forward terms (M13) — "content-base" used before defined;
      "Document layer/builder" never defined; "pragma" load-bearing for
      unlabelled `<…>` dispatch but undeclarable; `\` missing from the
      "head" row of the Positional Contexts table.

### Carried from before

- [ ] **Substrate/proposal text alignment with the boundary ruling.** Update
      `design/attribute-model-proposal-3-substrate.md` §S5 (replace the
      mid-line/end-of-line wording with the boundary rule; correct the
      "NOT" example — `|el :first value with spaces :another x` →
      `first="value with spaces :another x"`; drop the "letter-first bare
      value" framing; drop the spaced-trait form if mentioned) and §S8 (add
      the boundary-`\` case); touch the matching proposal-3 §4/§10 examples.
