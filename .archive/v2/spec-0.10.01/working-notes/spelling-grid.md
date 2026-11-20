# The 0.10.1-draft spelling grid (working note, 2026-08-28)

Constructs × positions, at the draft's spellings. ⟨P⟩ = proposed this draft, unratified. — = deliberately no form (see Notes: some empty cells are claims, not gaps). Superscripts go to the Notes below the table.

| Construct | Block (own line) | Sameline (in the scan) | Value (in a slot) | Embedded (in prose) |
|---|---|---|---|---|
| **Element** | `\|el` | `\|a \|b \|c` (true columns) | `:x \|em hi` *or* `:x \|{em hi}` ¹ | `\|{em hi}` |
| **Assignment** | `:a 1` | `:a 1` mid-scan | — (no assignments-of-assignments) | — (` :a` literal) |
| **Text** | block prose · `\| starts with a pipe` ² | `\|el some title` (→ `$main`) | `bare-token` · `unquoted text run` · `"quoted"` | it *is* the prose |
| **Annotation** | `; note` (owns deeper lines) | `\|li Item ; TODO` (framed ³) | — (contributes no value) ⁴ | `;{a note}` |
| **Reference** | `@user[jw]` | `@user[jw]` (equal footing with `\|`) | `@user[jw]` · in brackets `[@{key}]` | `@{user.name}` ⟨P⟩ |
| **· cardinality** ⟨P⟩ | `@reviewers*` | `@reviewer?` | `@authors+` | `@{tags*}` |
| **Held reference** ⟨P⟩ | — | `:cite @<user[jw]>` | `@<user[jw]>` (type: reference) | — (open) |
| **Generator** | `!if @{cond}` + body | `!for :item @{xs*} :as x` | `:script !sh …` (node value) · `!{name …}` | `!{name …}` |
| **Capture** | `<python:` + deeper body ⟨P⟩ | `:when <2026-07-11>` | `<kind: body>` · `<vocab:kind: body>` | — (dropped ⟨P⟩) ⁵ |
| **Fence** | ` ``` ` (byte-exact) | openable mid-scan | node value | — |
| **List** | — | — | `[1 "two" <2026> @{k}]` | — (literal chars) |
| **Hold, source level** | `\\|element` (whole line held) | `:count \7 apples` ⁶ | `:a \` (kept empty string) | `\@{` `\\|{` — brace-openers only ⁷ |

## Notes

1. **The one still-borrowed value spelling.** Elements (and generators) as values use their block or brace spellings, ruled model-equivalent at a value slot. Deliberate convention — a third minted spelling would serve nobody.
2. **The free text idiom.** Line-initial `| ` (pipe-space) *fails the element guard* — kept so Markdown tables survive — so `| like this` is already a text line, pipe included, no escape needed. The `\|` hold is only needed when the pipe would otherwise parse (`\|element`).
3. **"Framed"** = whitespace on both sides, where end-of-line counts as the trailing side. ` ; ` comments; `1;2` and `x ;c` don't; trailing `x ;` is an empty annotation.
4. **Empty-by-claim.** An annotation contributes nothing to the document's assertion, so there is nothing to put in a value slot — a slot containing only `;{…}` has no value material and the ordinary missing-value rule applies (DELTAS 11; overrides 0.10.0's `""` fabrication). If this cell ever hurts in practice, that is evidence against the frame.
5. **Empty-by-claim.** Prose is already opaque — code and data ride in it as plain text (or Markdown spans) — so an in-prose capture bought nothing; dropped pending demand (DELTAS 14). Same falsifiability note as ⁴.
6. **The one-space distinction.** `:a \7 hundred` (attached: hold one character; scan stays live afterward) vs `:a \ 7 hundred` (framed: hold the rest of the line; nothing after it is scanned). With the slot open both give `a = "7 hundred"`; they diverge only when more material follows — `:a \7 hundred :b 2` → `a="7 hundred", b=2`; `:a \ 7 hundred :b 2` → `a="7 hundred :b 2"`. A real visual hazard, mitigated by highlighting and by both forms keeping every byte; under discussion.
7. **Prose needs almost no escapes.** Text-space markers are literal — bare `@`, `!`, `:`, emoticons, `3:1`, `email me @joseph` all pass through untouched. The only live openers in flow are the brace-composed forms (`|{` `!{` `;{` `@{`), so the only things ever held in prose are *literal* spellings of those two-character openers. (An earlier chat version of this grid wrongly showed `\:-)` in this column — emoticon escaping is a **sameline/value-space** concern only, the least-surprise collateral of the `:` guard.)
