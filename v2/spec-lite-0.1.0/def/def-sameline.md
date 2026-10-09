---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: true
terms: [sameline, element-sameline, attribute-sameline]
per: []
depends: [def:element-line]
consequences: [rule:line-scan, rule:leftover-values, rule:attribute-with-no-value-takes-next-value, rule:text-value-end, rule:sameline-element-is-child, rule:lines-follow-sameline-columns, rule:framed-comments]
---

# sameline · element-sameline · attribute-sameline

*«sameline» is the rest of a line after the element or attribute that starts it. Joseph's two kinds, «element-sameline» and «attribute-sameline», are read by one rule. Only the spelling "sameline" is ruled; what the word covers and the two compounds are not.*

## Terms

- **sameline:** the material on an «element-line» or «attribute-line» after the element or attribute that starts the line. Used as an adjective ("sameline text", "sameline elements", "sameline comment") and as a noun ("on sameline", "part of sameline"). *(Working definition, not reviewed with Joseph.)*
  - *Avoid:*
    - **"same-line", "same line", "same_line", "Same-line"** as spellings of the term. Joseph, 2026-09-30: "same_line, same-line, and sameline all in the same document" (`.int/STEWARD-VERBATIM.md`); ruled one spelling 2026-10-09. The variants also appear in his own July–August prompts (see Working notes), so verbatim quotes will keep them.
    - **`same_line`** as the name of a tree flag. It was the agent's name for option B of the `$main` tree-shape question (2026-10-08), later withdrawn. Joseph's own words for the flag were "sameline=true metadata" (2026-09-30).
    - **"inline" or "inline nesting"** for elements written later on a line. Dec 2025 SPEC and Joseph's Dec-24 rules used them ("you don't 'track' columns for inline stuff"). "Inline" now means `|{…}` and the other embedded forms.
    - **"one-liner"**: 2011 udon-c `DECIDED.md`, "INLINE / ONE-LINERS".
    - **"element tail"** and **"sameline decompress"**: 0.9 CORE's names for the text after an element line's attributes, retired by 0.10.0 in favour of `$main`.
    - **"value-space"**: `v2/DECISIONS.md` K9, "Sameline is value-space" (marked jaw 2026-08-08; per pre-design 73 Joseph said of it "I like it more and more"), carried into 0.10.0 §2.2 as "every sameline position … all sameline material is an attribute value". The word states a claim, and in lite a sameline element is a child, not a value ([[rule:sameline-element-is-child]]), so read alone it now asserts something false. K9 itself was about sameline *text*, which lite keeps as `$main`.
    - **"sameline capture"**: an agent's phrase, 2026-09-29. Joseph, 2026-09-30: "So I'm really not worried about "Making sure same-line capture works" (not sure what you're quoting there)."
    - **"element's line" / "attribute's line"** when the run is meant rather than the whole line. These are the drafters' phrasings in lite's cards; see [[def:element-line]] for the line.
    - **"Line Scan", "the scan", "sameline scan", "one scan"** for reading a sameline: see *The rule-name question* below.
- **element-sameline:** a «sameline» on a line started by an element. *(Working definition; which of two readings Joseph meant is open, see Working notes.)*
- **attribute-sameline:** a «sameline» on a line started by an attribute. Joseph's name: "I'll call this "attribute-sameline"" (2026-09-29).
  - *Avoid, for both:*
    - **"element-rooted line" / "attribute-rooted sameline"**: 0.9 CORE ("element-rooted line"), and Joseph's own phrase in a Grok session, 2026-07-15 ("whether sameline is element-rooted or attribute-rooted", quoted in pre-design 01).
    - **"block attribute line"** and **"line root"**: 0.10.0 §6.5 and its GLOSSARY. Joseph, 2026-07-30, used "block-attribute lines" to mean these lines are *not* sameline (see Working notes).
    - **"single value sameline"**: Joseph, 2026-07-15, a tentative alternative name ("or otherwise known as "single value sameline..." or something...").
    - **"attribute+value block lines"** and **"sameline within attribute-block"**: Joseph, 2025-12-31.
    - **"collecting"** (an attribute that "remains the line's collector"): 0.9 CORE's ownership table.

## Invariants

- Sameline material is read by one rule whichever kind of line it is on ([[rule:line-scan]]; Joseph's "final word", 2026-10-08).
- Sameline elements sit at their own columns, so lines below see them as if each had started its own line ([[rule:lines-follow-sameline-columns]]).

## Working notes

- **Not reviewed with Joseph except the spelling.** Joseph, 2026-10-09: "I do know that I've tried in vain many times to insist on proper use of "sameline" -- which occurs with many different spellings all over." What the word covers is still his to rule; this file's definitions are the drafter's.

### Joseph's words, in date order

All from `~/.claude/history.jsonl` (his typed prompts), cited by line, unless marked otherwise.

- 2025-12-31 (line 6428): "sameline prose is treated a little differently than block prose, even-- sameline prose doesn't set the indent-column position (only the first block-level line of prose does that)". Same message: "Sameline comments should be allowed on attribute+value block lines as well".
- 2026-01-14 (line 7832): "Can anything that is represented in sameline form and inline form be implemented in pure block-like form? Or are there intrinsic differences in the underlying structure. And, if there are, *should* there be?"
- 2026-07-12 (line 15836): "When in block mode (including sameline condensed) -- the following are special starts...."
- 2026-07-15 (line 16326): "; attributes in sameline mode" against "in block mode we allow quotes to be implied", and: "With minor nuance (I hope) for sameline becoming more carefully distinct from "attribute sameline" or otherwise known as "single value sameline..." or something..."
- 2026-07-15 (line 16335): "it's the one place I wouldn't mind enforcing ' ; ' but *only* if it is sameline (including, now, attribute-sameline) AND prose / text has already started". **This is the earliest "attribute-sameline" found;** the lexicon inventory dates his coinage to 2026-09-29, when he re-coined it ("I'll call this…").
- 2026-07-28 (line 17689, quoted in pre-design 01): "just pretend the same-line part has each of its parts on consecutive new lines".
- 2026-07-30 (lines 18174–18175): "(still seems a lot cleaner to me than the double quotes, at least on same-line attributes like this)", then "oh-- my mistake-- block-attribute lines (or something) not the usual usage of "sameline"".
- 2026-08-08 (line 18835): "I almost think of it as vim-modes or grammar state, and it feels like a lot of the time in the past same-line has somewhat forgotten the ideal -- sameline has (1) certain syntax-sugaring available that isn't other places, and (2) has pseudo-line-feeds (actual original purpose LF, NOT newlines- but rather hypothetical newline but indent to the current cursor location anyway)"
- 2026-09-30T01:55Z (`.int/STEWARD-VERBATIM.md`): "it allows us to treat sameline processing exactly the same if we are *sameline on an attribute*: […] I'll call this "attribute-sameline" and conjecture that $main allows for fully consistent "sameline" behavior whether the line started with an element or an attribute."
- 2026-09-30T02:01Z (line 21322): "allow sameline=true metadata still even though it can be implied by (well) the same line, for use in generating udon via AST."
- 2026-09-30T02:26Z (line 21331): "same_line, same-line, and sameline all in the same document, and nothing about element-sameline vs attribute-sameline". The only use of "element-sameline" found.
- 2026-10-08 (`.int/STEWARD-VERBATIM.md`): "' ; ' only counts as a comment when part of sameline"; "so any on a "sameline" run except as part of the $main text or final attribute's value, would cause a fail".
- 2026-10-09 (`.int/STEWARD-VERBATIM.md`): "This is for sameline only I'm pretty sure." and "on a line that is not sameline and already has prose it is just passed through".
- He also writes plain English "on the same line" for literal position: "a ' ; ' comment after the backticks on the same line" (2026-10-08, line 21901).

### Readings of his usage (mine; flagged, not resolved)

- **The meaning moved.** Until July 2026, "sameline" meant *on the element's definition line*, set against "block" (own-line) attributes. The 07-30 correction says an attribute line on its own is "not the usual usage of "sameline"". "Attribute-sameline" (07-15, again 09-29) extends the word to lines that start with an attribute. Lite's cards use the extended sense. A reader who meets 0.9 or 0.10 text will meet the narrow sense, where "sameline" and "block" are opposites.
- **Four grammatical roles in his own text:** adjective ("sameline text", "sameline comments"); noun for a region ("part of sameline", "on sameline"); a mode ("sameline mode", "vim-modes or grammar state"); and a kind of line ("a line that is not sameline", 10-09). A definition that fixes only one role leaves the others as drift.
- **"Element-sameline vs attribute-sameline" has two possible readings.** (i) By what *starts the line*, which matches his "whether the line started with an element or an attribute". (ii) By what *currently owns* leftover values. They come apart on one line: in `|el :x |em hi :y 2`, an attribute line, everything after `|em` belongs to `em` ([[rule:element-after-attribute-with-no-value]]: "the rest of the line MUST be the element's"). Under (ii) that is element-sameline nested inside attribute-sameline. [[rule:leftover-values]] says "On an element's line … on an attribute's line", which reads like (i) but gives (ii)'s answer only if "line" quietly means "run". Which one he meant is a question for him.
- **The spelling.** His prompts in `udon` projects, counted by month: July 2026, "sameline" 32, "same-line" 19, "same line" 5; August, 24 / 13 / 2; from late September, almost only "sameline" (the September/October hyphenated hits are mostly quotations of agents or plain-English "on the same line"). Some of the spelling drift the cards inherited came from quoted Joseph text. That doesn't weaken his ruling; it is why the Avoid list names his own variants.

### The rule-name question ("line scan")

- **What it names.** The name of [[rule:line-scan]] ("One scan for element lines and attribute lines"). It is the rule Joseph calls "sameline processing" and "sameline behavior": sameline material is read the same way whichever kind of line it is on.
- **Where it came from.** "Line Scan" was coined in Grok's greenfield spec rewrite "3b" (snapshot commit `b10d16d`, 2026-07-19), which retired "head position" and "the scan" (`v2/.archived/first-pass/greenfield-3b/new-spec/DECISIONS.md` D4, "Vocabulary stabilization [ORG]"). The second-pass status file lists "Naming forks Structure Position / Line Scan" under "Own next (no steward required)" (`v2/.archived/second-pass/STATUS.md`). It became `v2/DECISIONS.md` **N-scan** (2026-07-21), then 0.9.1 and 0.10.0 GLOSSARY. On 2026-07-22 a Gemini reviewer argued it was parser jargon bleeding into the author-facing spec, against `defining-udon.md`'s isolation principle. That was logged as `v2/OPEN.md` **N-jargon**, "a steward call". No answer from Joseph is on record. On 2026-10-09 he said: "don't know what it's referring to or why it might or might not be the correct mental model."
- **Collisions.** "Scan" is Joseph's implementation word: descent's SIMD **SCAN** ("Go ahead and explore SCAN-first state mechanism", 2025-12-27, line 5934; "scan_prose - scan until \n, ;, |", line 5932). "Scanner" is the classic synonym for lexer, so "line scan" reads as a lexer pass. In graphics a "scan line" is a raster row.
- **Mental model it invites.** A procedure: a cursor moving left to right, which is how a parser reads a line. Joseph's model is declarative and geometric: sameline is the vertical form written sideways ("pseudo-line-feeds"; "pretend the same-line part has each of its parts on consecutive new lines"), plus one exception for text (`$main`). A rule named for a reading procedure frames the spec around how a parser works, not around what the line means.
- **Is a separate name needed?** If «sameline» is defined as one thing read by one rule, the rule is just "sameline" and needs no name of its own. The card could be titled in plain words: "Element-sameline and attribute-sameline are read alike".

### Other agents' leans

- 0.10.0 (agent): "Sameline / block — on the element's definition line vs on its own indented line" (GLOSSARY), the narrow sense.
- The lexicon inventory (agent, 2026-10-09) proposed "element-sameline" / "attribute-sameline" in place of "element's line" / "attribute's line".
- Pre-design 01's history agent (2026-09-29) used "sameline" for the run and "the head" for the element starting it.

### Precedents

- **Haskell layout (Haskell 2010 report, ch. 10):** "If a let, where, do, or of keyword is not followed by the lexeme {, the token {n} is inserted after the keyword", where n is the indentation of the next lexeme. A block's column can be set *mid-line* by whatever follows `do` on the same line, and the lines below align to it. This is the closest precedent to sameline elements sitting at their true columns.
- **Slim, "Inline tags":** "Sometimes you may want to be a little more compact and inline the tags." (`li.first: a href="/a" A link`). **Pug, "Block Expansion":** "To save space, Pug provides an inline syntax for nested tags." (`a: img`). Both nest whatever follows on the line, as UDON does; both call it "inline", the word lite now reserves for `|{…}`.
- **Haml:** `%p Hello` puts "text to be rendered inside the element" on the tag's line. From memory, not re-checked: Haml rejects a tag that has content both on its line and nested under it ("Illegal nesting"). Lite instead keeps both, as `$main` and children.
- **Python:** a compound statement's suite may be simple statements "on the same line as the header" (reference §8, from memory, not re-checked). Python uses the plain-English phrase, with no coined term.
- **Rebol/Red:** a block keeps a per-value "new-line marker" (`new-line`, `new-line?`), recording whether a value began a new line. This is a precedent for Joseph's "sameline=true metadata" (from memory).
- **None of these coins a closed compound.** "Sameline" being one word is what marks it as a defined term rather than English, which may be why the spelling matters to him (my reading).

### Questions about meaning, register and affordance

- **Same as what?** "Sameline" is relational. Without an anchor, a fresh reader has to work out what the line is the same *as*. "The sameline of `|el`" answers it; a bare "sameline text" relies on context.
- **Does it include the construct that starts the line?** This definition says no. Is the `|em` in `|el :x |em hi` part of the attribute-sameline, and the start of `em`'s?
- **Is a fence opener on the line sameline?** Joseph: "we need its indent (including sameline) to decide whose child it is" (2026-10-08) suggests yes.
- **Brace interiors.** 0.9 CORE: "Embedded is simply element-rooted sameline (ratified 2026-07-16)". If `|{a :href / \ Home}` reads like an element-sameline, the word stretches to something that is not a line and may span lines. Joseph: "it also might need to wait until we've settled the embed design" (2026-10-09).
- **May plain English "on the same line" still appear in spec prose?** He uses it that way himself (10-08). If it may, the rule could be: "sameline" for the defined region, ordinary English for literal position.
- **Without highlighting**, an agent reads "sameline" as one coined token. That is good for term-hood, but it gives no hint of the two-kinds distinction unless the compound is spelled out.

### My own opinion (the drafter's, Opus 5.5; not a lean of Joseph's)

- Keep «sameline» as the noun for the region and the adjective for things in it, defined by the line-starting construct (reading i). Then «element-sameline» / «attribute-sameline» are fixed per line and never change mid-line.
- State ownership separately ("leftover values go to the nearest element to their left on the line, else to the line's attribute"). Then the compounds don't have to carry an ownership claim they can't keep.
- Drop "line scan" as a term. Retitle the card in plain words.
- Not decided here. The `|el :x |em hi :y 2` example is the one to ask him with.

### Cards a rename would touch (left unedited)

- `src/rule-line-scan.md`: slug and title ("One scan…").
- `src/rule-leftover-values.md`: "line's owner", "element's line", "attribute's line".
- About 17 cards use "element's line" and about 19 use "attribute's line".
- Outside quotations, "same line" survives only as plain English ("on the same line"), in `rule:element-after-attribute-with-no-value`, `rule:attribute-after-attribute-with-no-value`, `rule:main-is-attribute` and `rule:text-value-end`. Whether those stay depends on the plain-English question above. `def/def-value.md` (another slice) quotes "same-line slot" from an older draft.
- `main.outline.md`: rows `rule:line-scan`, `rule:leftover-values`, `rule:text-value-end`.

### Coordinator's lean (Opus 5.5, 2026-10-09; my opinion for Joseph, not a lean of his)

- **Agree with the drafter on reading (i):** «sameline» is the rest of an element-line or attribute-line, and which kind it is is fixed by what starts the line. Ownership of leftover values is stated by its own rule, so the two compounds never have to carry it.
- **Drop "line scan"** and retitle `rule-line-scan` in plain words, e.g. "Sameline material is read the same way on element-lines and attribute-lines". He doesn't know the term, and it describes a parser's procedure rather than what the line means.
- **Fence lines.** Since his 2026-10-09 ruling, a fence opener is "in the same family as |;: and the reserved ones", so a fence opening on an element-line or attribute-line is sameline material. A fence opener at the start of its own line, and a closer line, are not samelines; the comment rules for them should say "after a fence's backticks" separately rather than stretch the word.
- **Plain English "on the same line"** can stay for literal position; «sameline» (one word) marks the term. That is how he writes himself.
