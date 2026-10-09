---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: false
terms: []
per: []
depends: [def:label, rule:fence-opens-with-backticks, rule:fence-label-no-backtick, rule:fence-verbatim-label, rule:fence-line-comments]
consequences: []
---

# What follows a fence's opening backticks (term undecided)

*The text after a fence's opening backticks, minus a trailing `-` flag and any framed comment: `sh` in ```` ```sh ````. It is the author's note about the body, usually a language, and lite attaches no meaning to it. The cards call it "the fence's label". What to call it, and whether it is a «label», are both open.*

*The slug `fence-tag` is a placeholder. "Tag" is one candidate among several and isn't preferred by being the slug.*

## Terms

*(No term yet. `terms:` is empty until Joseph names it.)*

What the term will name, as lite's cards now describe it: the rest of a fence's opening line after the backticks ([[rule:fence-label-no-backtick]]). A framed ` ; ` ends it ([[rule:fence-line-comments]]), a trailing `-` is a separate flag and not part of it ([[rule:fence-verbatim-label]]), and it may not contain a backtick. Lite carries it in the «tree» beside the body and gives it no meaning.

## Examples

- ```` ```sh ````: `sh`.
- ```` ```diff- ````: `diff`, plus the verbatim flag.
- ```` ```- ````: none, plus the verbatim flag.
- ```` ```rust ignore ````: `rust ignore` under the current card text. That has a space in it, so it isn't label-shaped (Working notes).

## Avoid

*Every name the tag has had. Since no term is chosen yet, one of these may come back as the choice; until then, none should be written as if settled.*


- **"label"**, **"the fence's label"**: lite's fence cards since 2026-10-08 (`rule-fence-label-no-backtick`, `rule-fence-verbatim-label`, the "Bodies" chapter rows). It came in through an agent's 2026-10-08 message (summarized in `.int/STEWARD-VERBATIM.md` as "the opener's remainder as a separate raw label"), and Joseph answered in the same word ("Agree no backticks on the fence's label"). 0.9.1 used it before that (§10.3 "an info label for free"; GLOSSARY "**Label** — a verbatim form's optional tag"). Since 2026-10-09 "label" is his word for the spelling rules names share ([[def:label]]), and calling the tag a label answers this card's second question by default.
- **"kind"**: 0.10.0 (§10, "one family carrying a `form` and optional `kind`"; GLOSSARY "**Kind** — a verbatim form's optional tag"; the retired-terms table: "label (verbatim/fence tag) → kind"); lite's pre-design 11 ("The text after the backticks is its kind"); Joseph's `!{raw:kind}` (2025-12-28), then `!:kind:` and `!{:kind:…}` in the spec's own spellings. In this corpus "kind" is also the trait gloss ("what *kinds* of thing it is"), the SOP's frontmatter `kind:`, and 0.10.0's "value kinds" and "extent kind".
- **"info string"**: CommonMark's term (0.31.2, "Fenced code blocks"), used in 0.9 CORE ("an info string (`rust`, `rust ignore`) comes for free -- no separate info-string rule") and the fixture `freeform_info_string_is_body` (`core/fixtures/v0.9/freeform.yaml`). In lite "string" is a defined term ([[def:string]], a quoted value), so the phrase would put the wrong term inside it.
- **"lang"**, **"language"**: Joseph's `!raw:lang` (2025-12-24) and `!:lang:` (0.9 CORE); `analysis.md` (2025-12-23) `|code-block :lang elixir`. See Working notes; it is also a live candidate.
- **"label/namespace"**: Joseph, 2025-12-28, for the `json` in `!:json:` ("which would emit the raw label/namespace").
- **"type"**, **"dialect"**: words for typed values (`<u64:…>`, `<temporal:…>`, 0.10.0's "dialect"). Using them here would blur two features that both carry an uninterpreted name.
- **"part of the body"**: the 0.9 reference parser's behavior (the tag was emitted as the first line of body text, pre-design 11's T5). In lite it is separate: Joseph, 2026-10-09, on the `-`: "in the AST, no, it would be its own flag" (*reading:* if the flag is its own field, the tag is one too).

## Working notes

- **Not reviewed with Joseph.** Two questions, best asked in this order:
  1. **Is it a word or a line?** As the cards stand it is the rest of the opening line, so `rust ignore` would be one tag with a space in it. CommonMark allows that and leaves the meaning to the renderer ("The first word of the info string is typically used to specify the language", spec line 1965). If lite instead says the tag is one «label» (by the label rules), then `rust ignore` needs another reading: an error, or a tag plus something else. This decides whether it is a «label», and it constrains the trailing `-`: if `-` is a label character, as in kebab-case names, then `diff-` must be read as `diff` + flag, never as the label `diff-`.
  2. **What is it called?**

- **His words, oldest first** (`history.jsonl` unless noted).
  - 2011 (`udon/.attic/syntax2.udon`, quoted in pre-design 11 H1): "fence == filter == encoders/decoders ~= heredoc ~= processing-instruction"; "FENCED data (like heredoc that declares processor)". In 2011 a fence was a delimiter that *names its processor*.
  - 2025-12-24 (L5566): "a simple "Use `!raw:lang` for non-UDON content:" is more readable".
  - 2025-12-28 (L6039): "As for !{{}} and !{raw:kind} Ideally they just output the usual events…"; L6058: "`!:label` is what I was thinking initially, but I think I'm going to land on `!:json: …` … (which would emit the raw label/namespace)".
  - 2026-07-11 (L15834): "followed by whatever on that same line being captured and sent to the parser as part of the body-- so language name works etc."
  - 2026-10-08: "Agree no backticks on the fence's label"; "'-' suffix for verbatim".
  - 2026-10-09: "15. "stay in the label" -- in the AST, no, it would be its own flag. bare ```- should be very obviously a fenced block preserved verbatim." ("stay in the label" quotes the agent's question.)

  *Reading:* when he says what it's *for*, he says language ("language name", `lang`). When he names the slot, he takes whatever word the current spec or agent used (`kind` in December 2025, "label" in October 2026). I found no place where he chose a word for it deliberately.

- **Agents' words.** `analysis.md` (2025-12-23): `:lang`. 0.9 CORE: "info string", "freeform" for the fence itself. 0.9.1: "info label", "Label". 0.10.0: "kind". Lite pre-design 11 (2026-09-29): "kind". Lite cards (2026-10-08): "label".

- **Candidates and what each invites.**

  | Candidate | For | Against |
  |---|---|---|
  | **language** / **language name** | His own word for its purpose (2026-07-11); GitHub's docs and AsciiDoc (`[source,ruby]`) say "language"; any reader knows what goes there | Too narrow for `text`, `diff`, `csv`, `udon`, `mermaid`, which are formats more than languages (though GitHub calls them all languages) |
  | **info** | CommonMark's exact idea without "string"; says only "information the author gives about the body", which is what lite promises | Vague; no one says "the fence's info" yet |
  | **kind** | 0.10.0's choice; matches `!:kind:` | Taken in this corpus by the trait gloss, SOP frontmatter, value kinds and extent kinds |
  | **label** | 0.9.1's and today's cards'; short | Collides with his lexical sense, especially if the tag may hold spaces |
  | **tag** | Short; the word for an annotation that names a type (YAML `!!str`, EDN `#inst`) | That sense is the typed value's `u64` (C's slice); he found "tags" "so generic it gives the impression of noise" (2026-01-14); in HTML a tag is `<p>` |
  | **format**, **syntax** | Cover languages and data formats alike | No precedent for a fence; "syntax" suggests lite checks it |
  | **filter**, **processor** | His 2011 framing; Haml filters `:markdown`; Pug filters | Suggest lite runs something; lite only carries the word |
  | **annotation** | KDL's "type annotation" `(u8)` | 0.10.1 renamed comments to "annotations" |

- **Other precedents.**
  - reStructuredText: `.. code-block:: python`, where the language is the directive's argument. Org-mode: `#+BEGIN_SRC python :results output`, a language then header arguments (the `rust ignore` shape). Pandoc: ```` ```{.python .numberLines} ````, where the tag is turned into classes.
  - Heredocs: Ruby's `<<~SQL` names the language by convention, and editors highlight from it. Jupyter's `%%bash` cell magic.
  - CommonMark's HTML rendering puts the first word into `class="language-…"`. In UDON terms the tag becomes a «trait» of the `code` element, which suggests that, at least in HTML, it is label-shaped.

- **A forward question.** Full UDON may keep other forms that hold an uninterpreted body behind a name (`!:kind:` blocks; 0.10.1's `<kind:` captures, "a held span for a named vocabulary"). If the same word should cover all of them later, a word that fits only fences ("info", or anything defined by CommonMark) will need a sibling. *Possible future syntax, not a lite concern;* noted because the word chosen now will be what agents reach for then.

- **My own opinion** (the drafting agent's): settle "word or line" first. If it is a word, "language" is the most honest name for its purpose and the one he reaches for, and saying it is a «label» lexically is then true. If it is a line, "info" keeps CommonMark's meaning without "string". Either way, avoid "label" for the slot and "kind" for anything new.

- **Overlap with E's slice.** E writes [[def:fence]]; whatever word lands here should appear there as the fence's part, and the four fence cards that say "label" will need the new word (listed in the coordinator report, not changed here).
