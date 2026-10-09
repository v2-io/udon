---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: true
terms: [framed, frame]
per: []
depends: [def:sameline, def:marker, def:comment]
consequences: [rule:framed-comments, rule:framed-backslash-frame, rule:framed-comment-owns-deeper-lines, rule:fence-line-comments, rule:fence-closer-trailing-text-is-error, rule:space-before-text-end, rule:backslash-empty-text, rule:text-value-end]
---

# framed · frame

*A `;` or `\` on a «sameline» is «framed» when it has a space before it and a space after it. The spaces are its «frame»: they decide that it is a comment or a text end rather than text or an escape, and they are not content. Joseph accepted the word ("when you say "framed" you mean at least one space on either side … right?") but has not ruled on it. Whether end of line counts as the right-hand frame is unsettled, and the cards disagree.*

## Terms

- **framed:** said of a `;` or `\` on a «sameline» that has at least one space before it and at least one space after it. A framed ` ; ` starts a comment ([[rule:framed-comments]]); a framed ` \ ` ends the running text ([[rule:text-value-end]]). *(Working definition, not reviewed with Joseph; the end-of-line question is open.)*
- **frame:** the spaces on either side of a «framed» character. They are not part of any text ([[rule:framed-backslash-frame]], [[rule:space-before-text-end]]).
  - *Avoid:*
    - **"whitespace-framed"**: 0.9 (commit `74fee71`, 2026-07-15, "Ratify sameline comments as a whitespace-framed lexeme"). "Whitespace" admits tabs; lite's frame is spaces.
    - **"frame-required positions" / "no-frame positions"**: 0.9 CORE's comment table.
    - **"framed" for a space-before-only marker**: 0.10.0 §6.4's example comment calls ` :second` "a framed guard-confirmed marker". In lite, ` |name` and ` :name` need only a space *before*; "framed" is kept for `;` and `\`.
    - **"commit to text mode" / "text mode"**: 0.10.0's meaning of a framed ` \ ` ("the rest of the physical line is text"). In lite a framed ` \ ` *ends* text; Joseph: "That is *different* (maybe significantly) than the previous iterations that treated [\] as the *beginning* of text" (2026-10-09).
    - **"framing whitespace"** for the spaces around an inline `;{…}`: `v2/DECISIONS.md` S18. That is a different construct.
    - **"attached"** as the opposite of framed: 0.10.0 §4 ("attached `\X`"). Lite's [[rule:value-line-escapes]] still uses "attached `\X`". It is a fine counterpart if «framed» is kept, but it's undefined.

## Working notes

- **Not reviewed with Joseph.** The word is agent vocabulary from July 2026; he has checked its meaning once and supported "frame" for the spaces once.

### Joseph's words

From `~/.claude/history.jsonl` unless marked otherwise.

- 2026-07-15 (line 16319): "we can call it its own specific lexical thing--- "sameline comments" which are allowed to be after prose and are conditioned on a space before and a space after the ';'... Does that work?"
- 2026-08-28 (line 20555): "just to be sure: when you say "framed" you mean at least one space on either side of the thing that is framed, right?"
- 2026-10-08 (`.int/STEWARD-VERBATIM.md`): "' ; ' only counts as a comment when part of sameline and with at least one space on each side."
- 2026-10-09: "wrt " \ " spaces around it as frame-- I support that."
- 2026-10-09: "from a scanning perspective, as text components accumulate, whitespace is considered ornamental but turns into content if the next thing continues as part of the text. If the next thing instead stops the text (including '\'), it was just delimiter+ornamental."
- *Reading (mine):* every statement in his own typing says "a space" on *each* side, and none says "or end of line". But the August ledger row K13, ruled with him, does count end of line ("EOL is the trailing frame"). So his typed words and his ruled ledger differ, and nobody has asked him which he meant.

### The end-of-line question (a real disagreement in the cards)

- **`v2/DECISIONS.md` K13** (marked "jaw 2026-08-09", the "`\` frame split"; the row text is an agent's rendering of a ruling with him) defines "framed `\`" as "whitespace before, whitespace-or-EOL after", and adds: "`:a \` ≡ `""` stands: EOL is the trailing frame, empty text."
- **0.9 and 0.10.0** let end of line stand for the right-hand frame. 0.9: "a space before it, and a space *or end-of-line* after it" (an agent, quoted in `.int/history-semicolon-in-text-2026-10-08.md`). 0.10.0 §4: "whitespace before, whitespace or end-of-line after".
- **Lite's [[rule:framed-comments]]** says "at least one space on each side". Read literally, `|li Item ;` gives `$main` the text `Item ;`, with no comment.
- **Lite's [[rule:backslash-empty-text]]** treats `:a \` with nothing after it as "a framed backslash".
- So one card counts end of line as a frame and another doesn't. A ruling on «framed» settles both. The examples to ask with: `|li Item ;` (an empty trailing comment, or text?), `:a \` (already a lean: empty text), and `|el :a x \` (text `x` then nothing, or text `x \`?).

### Other edges the definition has to cover

- **Tabs.** A tab before a framed `;` shifts its column, and its column now matters ([[rule:framed-comment-owns-deeper-lines]] measures from it), so that tab is an error ([[rule:column-shifting-whitespace-error]]). A tab *after* it, as in `|el x ;⇥note`: is the `;` framed (tab as frame) or not (text `x ;⇥note`)? "At least one space" says not.
- **Line start.** A `\` first on a line is a separate rule ([[rule:line-start-escape]]), not a framed backslash, even if spaces follow. A `;` first on a line is a comment block (slice E). So «framed» applies only after the line's first construct, which is why it belongs to «sameline».
- **Fence lines.** Slice E's [[def:comment]] raises the same scope question for its «framed-comment» (and leans "sameline comment" if fence lines count as samelines, else "trailing comment"). The fence cards ([[rule:fence-line-comments]], [[rule:fence-closer-trailing-text-is-error]]) use "framed ` ; `" after a fence's label or backticks, which are not a sameline in [[def:sameline]]'s sense unless fence lines count as structure lines. The definition should say "on a sameline or a fence line", or fence lines should be shown to be samelines.

### Precedents

- **CommonMark** names whitespace-sensitivity for `*` and `_` as *flanking*: "A left-flanking delimiter run is a delimiter run that is (1) not followed by Unicode whitespace…". A run with whitespace on both sides, as in `abc *** def`, is "Neither left nor right-flanking" and so is literal. That is the opposite polarity: in UDON whitespace on both sides makes `;` and `\` *special*.
- **YAML**, from memory: a `#` comment must be separated from other tokens by whitespace (so `a#b` is not a comment), and `:` is a mapping indicator only when followed by a space. That is the same idea as lite's frame, applied one side at a time.
- **Swift**, from memory: whether an operator is prefix, postfix or infix depends on whitespace on each side. **Ruby** warns on `foo -1` ("ambiguous first argument").

### Questions about meaning, register and affordance

- **Register collision.** In this corpus "frame" and "framing" mostly mean a conceptual frame ("Excellent framing", "frame of mind", AGENTIC-DELEGATION's "framing"). Joseph uses it that way dozens of times. A reader without the definition may take "the framed backslash" figuratively.
- **Visual affordance.** Without highlighting, ` ; ` and ` \ ` are visible as space-character-space, which is what "framed" names. That is a strength: the term describes exactly what the eye checks.
- **Does lite need the adjective at all?** Each card could say "a `;` with a space on each side". The term earns its keep only if several cards share one definition, which they do (about 18 card and record files use "framed"), and if the EOL question is answered once, in one place.

### My own opinion (the drafter's; not a lean of Joseph's)

Keep «framed» and «frame». They are short, they describe what the eye checks, and he has accepted both. The definition needs the end-of-line ruling and the fence-line scope. My lean is to count end of line as a right-hand frame: it keeps `:a \` and `|li Item ;` alike, and matches 0.9 and his August K13. But his October words say "at least one space on each side", so which one he meant is a question for him, not something for us to settle.

### Cards a ruling would touch (left unedited)

- `src/rule-framed-comments.md` (Statement: "at least one space on each side").
- `src/rule-backslash-empty-text.md` ("framed backslash" with end of line after).
- `src/rule-fence-line-comments.md`, `src/rule-fence-closer-trailing-text-is-error.md` (scope).
- `src/rule-value-line-escapes.md` ("attached `\X`", the undefined counterpart).

### Coordinator's lean (Opus 5.5, 2026-10-09; my opinion for Joseph, not a lean of his)

- **Keep «framed» / «frame»**; he accepted both, and they name what the eye checks.
- **End of line:** I lean that end of line **counts** as the right frame. Reasons: it makes `:a \` (already a lean: empty text) and `|li Item ;` (an empty trailing comment) behave alike; `|li Item ;` giving the text `Item ;` would surprise anyone; and it matches the August K13 row ruled with him. Against it: every one of his own typed sentences says "a space on each side". So this is a question for him, with `|li Item ;` as the example.
- **Tab after:** a tab is not a frame (frames are spaces), so `|el x ;⇥note` is text `x ;⇥note` under the current wording. I'd leave that and let it surface if it bites.
