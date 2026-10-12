---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: true
terms: [fence, fence-opener, fence-closer, verbatim-flag]
per: []
depends: [def:body, def:fence-tag, rule:fence-opens-with-backticks, rule:fence-closes-at-n-or-more, rule:fence-closer-is-a-line, rule:fence-body-not-scanned, rule:fence-body-dedent, rule:fence-exact-trait, rule:fence-line-comments]
consequences: [def:node]
---

# fence · fence-opener · fence-closer · verbatim-flag

*A «fence» is the node made by a run of three or more backticks: its «body» is every line up to a «fence-closer», kept and never scanned. Since 2026-10-12 the rest of the opening line reads like an element's line (a name, keys, traits, attributes), and the trait `exact` replaces the `-` «verbatim-flag».*

## Terms

- **fence:** the node a «fence-opener» starts. It holds what its opening line gives, read as an element's line (a name, keys, traits, attributes, `$main`: [[rule:fence-opener-line]]), and its «body», which lite never scans for UDON syntax ([[rule:fence-body-not-scanned]]).
- **fence-opener:** the run of N ≥ 3 backticks that starts a «fence», wherever structure can start ([[rule:fence-opens-with-backticks]]). N is the fence's length. The rest of its line holds the tag, the «verbatim-flag» and an optional «framed-comment»; the cards sometimes include that rest in "opener" (open: see Working notes).
- **fence-closer:** the run of N or more backticks that is the first non-space content of a later line, ending the «fence» at the first such line ([[rule:fence-closes-at-n-or-more]]); the cards also use it for that whole line. It is not part of the «body»; its column then takes part in nesting like any line's ([[rule:fence-closer-is-a-line]]).
- **verbatim-flag** *(retired 2026-10-12; replaced by the trait `exact`, [[rule:fence-exact-trait]])*: a `-` ending the «fence-opener»'s tag (or standing alone after the backticks: ```` ```- ````). It is not part of the tag, and the «body» then keeps every byte, indentation included ([[rule:fence-exact-trait]]).

## Invariants

- Nothing between the «fence-opener» line and the «fence-closer» is scanned, escapes included.
- A «fence» without the «verbatim-flag» has its «body» dedented by its first non-blank line ([[rule:fence-body-dedent]]); with it, nothing is removed.
- Whether a line is the «fence-closer» depends only on its backticks; its column doesn't matter.

## Examples

`````udon
|job :script ```sh ; run in CI
make build
``` ; end
|patch
  ```diff-
 context line
-removed
  ```
`````

- Line 1, from the backticks on, is a «fence-opener» (length 3, tag `sh`), with a «framed-comment».
- Line 3 is the «fence-closer».
- Line 5 is a «fence-opener» with the «verbatim-flag»; its «body» is `" context line\n-removed\n"`, exactly as written.

## Avoid

"Joseph" marks his own words; everything else is an agent's or a spec draft's.

**For «fence»:**
- **freeform** (also **freeform block**, `UnclosedFreeform`, `FreeformStart`) — the 0.9 spec heading "Triple-Backtick Escape (Freeform)", the 0.9 parser's events and warning code. Joseph used it himself in January ("Freeform blocks are triple-backtick, right?", 2026-01-02, `history.jsonl` L6786; "column shouldn't matter for freeform", L6797), then on 2026-07-18: "(oh, maybe ``` is freeform? I always call it fence but can change my mental vocabulary :-) )" (L16640). In 2011 "freeform" meant ordinary prose on its own line ("FREEFORM: any time text starts its own line", `udon-c/docs/DECIDED.md`), the opposite sense. 0.10.0's glossary retired it.
- **raw, raw block, raw node** — Joseph: "A raw node, or code-fence (if we continue supporting both)" (2026-01-14, L7874), "raw triple-backtick mode" (L7854). "Raw" was the `!raw:`/`!:lang:` directive family, which lite reserves. In lite, "raw" now names other things: the «raw-tree» ([[def:reading-option]]) and the opaque spans' "raw text" ([[rule:opaque-span-raw-text]]).
- **verbatim (as the family name)** — 0.10.0 §10: "Verbatim is content never parsed as UDON: one family (block `!:kind:`, fence, inline `!{:kind:…}`)". In lite, "verbatim" means one thing: the «verbatim-flag»'s exact indentation. Under the 0.10.0 sense, every lite fence would be "verbatim" and the flag would mean nothing.
- **byte-exact (as what a fence is)** — 0.9–0.10.0 §10.3 ("The body is captured byte-exactly: no dedentation"). Lite fences dedent unless flagged.
- **capture, held bytes** — 0.10.1 draft (the "capture" family; "fences as their own material kind ('held bytes')", NUANCE-AUDIT §2).
- **triple-backtick block / escape** — 0.9 CORE; lite fences are N ≥ 3 backticks, not exactly three.
- **blob** — retired in 0.10.0 for text; never a lite word.
- **heredoc** — Joseph's 2011 analogy: "fence == filter == encoders/decoders ~= heredoc ~= processing-instruction" (`_older/udon/doc/syntax2.udon`). An analogy only; then "fence" meant a delimiter naming a processor (`<uuu<`).
- **`~~~` fence** — CommonMark allows tildes; lite doesn't (not taken in [[rule:fence-closes-at-n-or-more]]).

**For «fence-opener» and «fence-closer»:**
- **opening/closing code fence** — CommonMark's phrasing. There the "code fence" is the backtick run itself, not the block (see Working notes).
- **fence delimiter** — Joseph, 2026-10-08: "the indent level of the fence delimiter itself".
- **closing fence, fence-closing line, code-fence finisher** — Joseph (2026-07-12, L15862; 2026-10-08; 2026-10-08 "the code-fence finisher").
- **opening line / closing line** — the cards' current phrasing for the lines.
- **the closer is invisible to nesting / "disappears as if it was a blank line"** — Joseph's option (a), 2026-10-08, and 0.10.0 ("doesn't affect the indent/dedent stack at all", Joseph 2026-01-01). Lite chose (b): the closer's column takes part in nesting.
- **the closer's leading whitespace is part of the body** — Joseph's 2026-07-12 ruling for byte-exact fences ("those whitespaces are part of the fenced text that gets output", L15862). Lite: the closer is "*transparent to fence body* (i.e., comes *after* the end of the fenced body)" (Joseph, 2026-10-08).

**For «verbatim-flag»:**
- **verbatim label** — the slug of [[rule:fence-exact-trait]], from before Joseph said the `-` is not part of the tag: "in the AST, no, it would be its own flag" (2026-10-09).
- **`-` suffix** — Joseph: "'-' suffix for verbatim" (2026-10-08). "Suffix" is loaded in UDON: element suffixes (`?!*+`) are the retired "suffix characters" ([[decision:suffixes-lose-special-status]]).
- **trailing dash / final dash** — Joseph, 2026-10-08: "Final dash interpreted as "verbatim"".
- **verbatim fence** — the cards' and the tree notation's phrasing; fine as a description, not a separate term.

## Working notes

- **Not reviewed with Joseph.** Joseph, 2026-10-09: "I haven't looked at any or been asked about any of those things … but the idea that they can just kind of organically be whatever would cause serious trouble really soon if allowed to continue." Every term here is provisional until he rules on it; `.int/lexicon-inventory-2026-10-09.md` lists where each came from.
- **Left out on purpose:** what to call the tag after the backticks (`sh`) is slice A's question ([[def:fence-tag]]). This card says "tag" as a placeholder only.
- **Card wording to align:** [[rule:fence-body-dedent]] and main.outline say "Unless its label ends in `-`", which treats the `-` as part of the tag. That contradicts Joseph's "its own flag".

### fence

- **Joseph's habitual word:** "I always call it fence" (2026-07-18). Also "code fence"/"code-fence" (2026-01-14, 2026-07-08, 2026-07-12), "fenced block" (2026-07-12 "which element parent the fenced block is child to", L15834; 2026-10-09 "bare ```- should be very obviously a fenced block preserved verbatim"), "nested fences" (2026-10-08). *Reading:* he uses "fence" for the whole construct and "fenced block" when he means its extent. Both are his.
- **The CommonMark collision.** CommonMark 0.31.2: "A code fence is a sequence of at least three consecutive backtick characters (`` ` ``) or tildes (`~`)", and "A fenced code block begins with a code fence". So in CommonMark the *fence* is the delimiter and the *fenced code block* is the whole. Lite uses "fence" for the whole node. A reader who knows CommonMark well may hear "a fence closes at N or more backticks" as being about the delimiter. That's harmless there, but "the fence's body" reads oddly to them. Joseph asked for the spec to name its differences from CommonMark (2026-10-08); this is a vocabulary difference worth naming there too.
- **Is "fence" too narrow for what it does in lite?** With `!:kind:` reserved, the fence is lite's only form for content that isn't parsed. "Code" (in "code fence") narrows it to code, while the spec corpus will put UDON examples, quotes and diffs in fences. Plain "fence" doesn't narrow it.
- **Precedents for the delimiter-length rule:** CommonMark (backticks or tildes, closing "at least as long"); C# 11 raw string literals ("A raw string literal starts and ends with a minimum of three double quote (`"`) characters", with more quotes when the content contains three); Rust raw strings (`r#"…"#`, with more `#`); Lua long brackets (`[==[ … ]==]`). The CommonMark-family name is "fence"; the C# and Rust name is "raw string literal".
- **My lean (this agent's):** keep «fence» for the node (his word, and short), with a Caution about CommonMark's narrower meaning; avoid "raw", "freeform" and "verbatim" as names for it.

### fence-opener / fence-closer

- **What's ambiguous: the backtick run, or the whole line?**
  - Joseph uses both senses: "the fence opener and closer" (2026-07-12, L15860); "the fence-opener's line's left-most position" (2026-10-08), where the opener is something that *has* a line, so the run; "And for the closer-- *transparent to fence body* … indent level sets new current indent level" (2026-10-08), where the closer has an indent level, so the line.
  - The cards use "opener" for the run plus what follows ("a fence opener's label"), and "closing line" for the closer.
  - In lite the difference matters at two points: the opener can sit mid-line (`|job :script ```sh`), so "the opener's column" is the backticks' column, not the line's; and the closer's column sets nesting.
- **Candidates:** opener / closer (Joseph's nouns); opening fence / closing fence (CommonMark-ish, and Joseph's "closing fence"); opening line / closing line (the cards); fence delimiter (Joseph, for the run). Swift and Java text blocks say "opening/closing delimiter"; C# "opening/closing quotes".
- **The "length" of a fence.** The cards say "a fence of length N"; Joseph said "backtick count >= 3"; CommonMark "at least as long as the opening code fence". Is length a term? It probably needs no definition, but «meta» records it (`#ticks 4` in the notation proposal).
- **My lean (this agent's):** «fence-opener» and «fence-closer» name the backtick runs; "the opener's line" and "the closer's line" are said in plain words where the line matters ([[rule:fence-closer-is-a-line]] would then read "the closer's line takes part in nesting"). Naming the runs keeps "the opener's column" exact on a sameline.

### verbatim-flag

- **Joseph's words:** "Notation-- (kind of like `|:--|---|` table notation, or mustache/liquid whitespace handling) -- "```udon-\n" <- Final dash interpreted as "verbatim", allowing for the first line's indent to be preserved" (2026-10-08, option 2); "'-' suffix for verbatim & all dent changes in meta" (2026-10-08); "in the AST, no, it would be its own flag. bare ```- should be very obviously a fenced block preserved verbatim" (2026-10-09).
- **What "verbatim" means here, and what it invites.** In lite it means one thing: *no indentation is removed*. Every fence is already unscanned and unescaped. A reader from 0.10.0 or from general usage ("verbatim" = taken literally, not interpreted) may think an unflagged fence *is* interpreted somehow. Candidate words that name only the indentation: "keep-indent", "no-dedent", "exact", "as-written". None is Joseph's; "verbatim" is.
- **An adjacent observation about the spelling (not the term, and the spelling is ruled).** In the precedents Joseph named, and in others, `-` means *strip*: Liquid/Jinja `{%-` / `-%}` trim whitespace; YAML's `|-` chomping indicator strips the final line breaks (YAML 1.2.2 calls it `STRIP`, "remove all trailing newlines"); bash `<<-EOF` strips leading tabs from the heredoc body. In lite, `-` means "strip nothing". An agent fluent in YAML or Jinja reading ```` ```diff- ```` without highlighting may guess the opposite. The name can push back on that: "verbatim" or "keep-indent" says what it does; "dash" or "suffix" doesn't. Raised for the coordinator's judgment, not as a proposal to respell.
- **"Flag".** Joseph's own word ("its own flag"). UDON's retired boolean "flag attributes" (`:done?`, K12) used the same word, but they are gone from lite, so the collision is mostly with history.
- **My lean (this agent's):** «verbatim-flag», defined narrowly as "keeps the «body»'s indentation exactly", plus an Avoid on "verbatim" as the family name. If the YAML/Jinja reading of `-` worries the coordinator, that's a spelling question for Joseph, separate from this name.

### Coordinator's lean (Opus 5.5, 2026-10-09; my opinion for Joseph, not a lean of his)

- Agree: «fence» for the node (his "I always call it fence"), «fence-opener» and «fence-closer» for the backtick runs (so "the opener's column" is exact mid-line), «verbatim-flag» for the `-`.
- [[rule:fence-body-dedent]] and the outline still say "unless its label ends in `-`"; that contradicts his "its own flag" and gets fixed with the tag's name ([[def:fence-tag]]).
- The YAML/Jinja reading of `-` as *strip* is worth one sentence in the flag's card. The spelling is his ruling.
