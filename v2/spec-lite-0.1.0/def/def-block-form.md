---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: true
strength: provisional
terms: [block-form]
per: []
depends: [def:marker, def:head-position, def:text, def:embed]
consequences: [rule:text-value-end, rule:embeds-in-text, rule:element-values]
---

# block-form

*A «block-form» is the spelling of a construct that begins at a «head-position» with its bare «marker» (`|name`, `:name`, a framed ` ; `). On a «sameline» it ends running text. Its counterpart is the «embed» (`|{…}`, `@{…}`, `;{…}`; [[def:embed]]), which sits inside text as a piece of it. "Block" has carried at least four other contrasts in UDON's history, so the word is heavily loaded.*

## Terms

- **block-form:** the spelling of an element, attribute or comment that begins with its bare «marker» at a «head-position», as opposed to the braced embedded spelling of the same kind of thing. Joseph, 2026-10-08: sameline text "ends with a *block* form of ;, |, or : -- whereas embedded forms just stay part of the text". *(Working definition, not reviewed with Joseph. Whether a fence is a block form is open; see below.)*
  - *Avoid:*
    - **"block-form marker"** / **"guard-confirmed block-form marker"**: 0.9 CORE and 0.10.0 §6.4. This merges the form and the «marker».
    - **"block-level", "block-level element", "block mode"**: Joseph's words (below). Each also means *not prose* or *own-line*, not *not braced*.
    - **"block" for "on its own line"**: "block attribute", "block-attribute lines", "in block form under the attribute" ([[rule:element-values]] uses this sense today). See [[def:element-line]].
    - **"positional construct"**: Joseph's own coinage, 2026-07-18, for what closes by geometry (line end, dedent, end of input). Agents renamed it "geometric extent" in 0.10.0, which "retired" "positional (extent)". This is a different axis: how a construct *ends*, not how it is *spelled*.
    - **"inline form"** for the braced counterpart: 0.10.0 §7.3. Lite says "embedded form" (about 10 cards) and "embed" ([[def:embed]], which proposes dropping "embedded form"), Joseph's word ("unclosed embedded |,;,@ nodes", "embeds"). 0.10.0 had *retired* "embedded (element)" in favour of "inline element", and lite has restored it.
    - **"brace form" / "inline brace form"**: 0.9 CORE's "inline-brace principle" and 0.10.0 §6.4. Descriptive, but it names the punctuation, not the role.

## Working notes

- **Not reviewed with Joseph.** It has nevertheless been in his mouth since December 2025, in more than one sense.

### Joseph's senses of "block", with his words

All from `~/.claude/history.jsonl` unless marked otherwise.

1. **Block, as against braced or inline** (the sense lite's cards use for "block form"):
   - 2025-12-24 (line 5589): "In liquid everything is effectively inline-- that's why they have the {% endif %}. What they don't have is block-level..."
   - 2025-12-28 (line 6006): "if they expect to have unbalanced curly braces inside-- just use the block form instead of inline."
   - 2026-01-14 (line 7870): "The big difference being that block form doesn't need the !endif because it's implied by indentation."
   - 2026-08-09 (line 18920): "I'm OK with (again) block-forms staying out. |{x} is not block-form."
   - 2026-10-08/09: "ends with a *block* form of ;, |, or :"; "hitting a new |... ;... or :... (block) construct".
2. **Block, as against sameline (own line):** 2025-12-31 (line 6428), "sameline prose is treated a little differently than block prose"; 2026-07-15 (line 16326), "in block mode we allow quotes to be implied"; 2026-07-30, "block-attribute lines".
3. **Block, as against prose:** 2026-07-12 (line 15836), "When in block mode (including sameline condensed) -- the following are special starts"; 2026-07-14 (line 16202), "an *actual* block-level/head-level element"; 2026-10-08, "any tab characters found in block mode". That last one is the phrase [[decision:errors-stop-parsing]] still lists as open ("what "any tab characters found in block mode" covers").
4. **Block, as against delimited:** 2026-09-02 (line 20782), "was the agent confused about delimited forms vs geometric/block forms?"
5. **Block as an indented region:** 2026-10-08, comments "available as their own block, which also comments everything in that block that is indented further as per the usual with blocks"; "fenced block"; "text block". Slice E owns these.
6. **Three forms, side by side:** 2026-01-14 (line 7832), "Can anything that is represented in sameline form and inline form be implemented in pure block-like form?" Here "block" is the vertical, own-line spelling (sense 2), set against *both* sameline and inline.

*Reading (mine):* the senses agree on the prototype, `|name` alone on an indented line, and pull apart everywhere else. Under sense 1, `|b` in `|a |b` is a block form; under senses 2 and 6 it is not (it's sameline). In lite's cards, [[rule:text-value-end]] uses sense 1 and [[rule:element-values]] ("Only in block form under the attribute") uses sense 2.

### Is a fence a block form?

- *For:* it begins at a head position, never inside text, and is not braced. 0.10.0 §6.4 listed "a fence" among the "guard-confirmed block-form marker[s]" that end a text value.
- *Against:* it closes by a printed delimiter, the backtick run, so it is a "delimited form" in his sense 4. And lite's [[rule:text-value-end]] does not list it as ending sameline text ([[def:head-position]], *What changed under lite*).
- The definition should say which, and the text-end rule should agree with it.

### Precedents

- **YAML 1.2 §3.2.3.1:** "Block styles use indentation to denote structure. In contrast, flow styles rely on explicit indicators." This is the same contrast as sense 1. YAML names the braced side "flow", a word 0.10.0 used for prose.
- **CommonMark:** blocks vs inlines; "container blocks, which can contain other blocks, and leaf blocks, which cannot". **HTML/CSS:** block-level vs inline elements, a display property. A reader from HTML will hear "block" as *renders on its own line* (close to sense 2).
- **Pug:** "Block Expansion" (`a: img`) is Pug's name for the *sameline* nesting of tags (from [[def:sameline]]). It is the opposite of sense 2 and close to sense 1.
- **Liquid:** `{% if %}…{% endif %}`, braced and closed explicitly; Joseph's own foil for "block-level" (2025-12-24).

### Questions about meaning, register and affordance

- **Pair it with its counterpart.** "Block form" means something only against "embedded form". A card that says "block form" with no counterpart in sight will be read in whatever sense the reader brings (HTML readers: own line; YAML readers: indentation-delimited).
- **Without highlighting**, `|em` and `|{em` differ by one character, and the term is what tells a reader which rule applies. "Bare form" / "braced form" would name the visible difference directly. That is an agent idea, not his; it gives up the word he uses.
- **Collision with body/block vocabulary** (slice E: comment blocks, text blocks, blank lines). If "block" also names indented regions, "block form" and "comment block" put one word in two roles, in neighbouring cards.

### My own opinion (the drafter's; not a lean of Joseph's)

- Keep «block-form» in sense 1, because it is his current word and his October sentence defines it by contrast with embedded forms.
- Always write it next to its counterpart, «embed» ([[def:embed]]). If "embedded form" survives at all, it should be a plain-English gloss of «embed», not a second term.
- Then stop using "block" for senses 2–4 in lite's text: "on its own line" for 2, "not prose" for 3, "geometric" for 4.
- The fence question has to be ruled with the text-end rule.

### Cards a change would touch (left unedited)

- `src/rule-text-value-end.md` (title, Grounds).
- `src/rule-element-values.md:50` ("Only in block form under the attribute", sense 2).
- `adr/errors-stop-parsing.md` ("tab characters found in block mode", a quotation; its open note).
- About 10 cards that say "embedded form": they would gain the counterpart, not lose it.

### Coordinator's lean (Opus 5.5, 2026-10-09; my opinion for Joseph, not a lean of his)

- **Keep «block-form» in his sense 1,** always paired with «embed»: `|em` vs `|{em …}`. His 2026-10-08 sentence defines it exactly that way. Stop using "block" for "on its own line" (say that in plain words; [[rule:element-values]] needs the change) and for "not prose".
- **A fence is a block form.** His 2026-10-09 ruling: "```(+) is in the same family as |;: and the reserved ones". The drafter's "against" (fences close by a printed delimiter) is about how a fence *ends*, which is a different axis from how it *begins*.
