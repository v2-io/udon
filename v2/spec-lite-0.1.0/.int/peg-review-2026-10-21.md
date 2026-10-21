# Review of the tentative PEG (`peg-2026-10-21.md`) against the cards

*By a review agent (Opus 5.5) launched from session `014uHM6yNW767ksMmVtWt7Sn`, 2026-10-21, at Joseph's request: "look over it and compare to the cards and discussion items etc. and give any feedback / validations / verifications / suggestions / questions etc. so far". I read only the lite store. Nothing here is a ruling or a card edit. Where I say a grammar does something, I either ran it (marked **ran**) or read it production by production (marked **read**). Where I'm inferring rather than checking, I say so.*

## In one paragraph

The block shape Joseph drew is a good spine. Each construct runs from its start to its end. Prose is whatever is left. His start-versus-embed lookahead settles `;{`, `|{` and `@{` at a line start in the same way the embed cards already treat them mid-text. The string productions match the decided escape cards exactly. Most of the disagreements with the cards come from three local mechanics, not from the design:

1. A value is allowed to begin at a start.
2. There is no slot for the space before a block that begins mid-line.
3. Joseph's `!"{"` lookahead has been used as the whole guard for each start.

When I ran the grammar as written on one-line examples taken from the cards, every mid-line attribute, fence and reserved spelling became `$main` text, and every sameline element became a `$main` value. With about ten local repairs, the same examples come out the way the cards draw them. What's left after that is genuinely open: `|el :c 1 z`, end of line as a frame, number boundaries, and list items.

The deeper point is about architecture. The claim that "the lexer, not the PEG, owns the columns" doesn't transfer from Python. Lite's EOB depends on decisions the parser makes. It can be made to work, and the cheapest way ties directly to the open labels question (§4).

## 1. What I ran

I transcribed the PEG block, production by production, into a small Python PEG interpreter. I then fed it one-line inputs taken from the cards' own examples.

The modeling choices are the ones the PEG leaves to the lexer or marks OPEN:
- WS is spaces.
- EOB is generous: it succeeds where only a line ending is left.
- LABEL is `[A-Za-z_$][A-Za-z0-9_$-]*`.
- `number` is a decimal placeholder.
- `"[set]"` is taken literally.

A second file applies minimal repairs, each numbered to match a finding below. Both are in the session scratchpad, `/private/tmp/claude-505/-Users-josephwecker-v2-src-arch-firmatum-udon/17de2677-ec9c-48c6-b6b3-9f07c964306b/scratchpad/peg-review/` (`peg_as_written.py`, `peg_repaired.py`, `cases.txt`). If they're worth keeping in the store, they could sit next to this file. The PEG file itself still parses under mermaid 12.2 (**ran**, with the existing `check.mjs`).

| Input (from the card) | The card says | The PEG as written gives (**ran**) |
|---|---|---|
| `\|el :a 1 :b "two"` ([[rule:attribute-with-no-value-takes-next-value]]) | `:a 1`, `:b "two"` | `$main` texts `‹:a 1›`, `‹:b "two"›` |
| `\|element[k] :attr this value :another <34>` ([[rule:line-scan]]) | key `k`, two attributes | element `element`, then a **prose child** `[k] :attr this value …` |
| `\|nav :aria-label Site \|a :href / \ Home` ([[rule:framed-backslash-frame]]) | `aria-label ‹Site›`; `a` with `href ‹/›`, `$main ‹Home›` | `$main ‹:aria-label Site›`; `a` with `$main ‹:href /›`, `‹\ Home›` |
| `\|el :a \ :b ''` ([[rule:backslash-empty-text]]) | `:a ‹›`, `:b ""` | `$main ‹:a›`, `‹\›`, `‹:b ''›` |
| `\|li Item ; TODO` ([[rule:framed-comments]]) | `$main ‹Item›`, comment | `$main ‹Item›`, `$main ‹; TODO›` |
| `\|el text ;note` ([[rule:framed-comments]]: needs a space each side) | `$main ‹text ;note›` | text, then `‹;note›` (the repaired grammar gives the card's answer) |
| `\|p this \| that` (Joseph 2026-10-08: "a space after the first pipe" is not an element) | `$main ‹this \| that›` | `$main ‹this›`, then an **anonymous child element** with `$main ‹that›` |
| `\|p see @alice now` ([[rule:reserved-spellings]]) | error | `$main ‹see›`, `‹@alice now›` (no error) |
| `\|job :script ```sh` ([[rule:fence-anywhere-structure]]) | the fence is `script`'s value | `$main ‹:script›`, `‹```sh›` |
| `\|x[a]` ([[rule:key-holds-a-value]]) | `$key ‹a›` | a prose child `[a]` |
| `\|cfg :tags [a "b c" 3]` ([[rule:list-items-whitespace-separated]]) | a list of three | one text |
| `\|el :a "unfinished` ([[rule:unclosed-delimiter-is-error]]) | error | text `‹:a "unfinished›` |
| `\|q "hello," she said` ([[rule:leftover-values]]) | `$main "hello,"`, `$main ‹she said›` | **agrees** |
| `\|nav \|{a …} \|{a …}` ([[rule:space-between-embeds]]) | one text: embed, `" "`, embed | **agrees** |
| `\|a \|b \|c` ([[rule:sameline-element-is-child]]) | `b` a child of `a`, `c` of `b` | nested, but captured inside `main`: `b` is `a`'s **`$main` value**, the reading that card rejected (finding 3) |

Every element's own line ending also comes out as an empty prose child (finding 12).

With the repairs, all of the rows above come out as the cards draw them. These are what remain, and they are the honest open questions:
- `|el :a "x""y"`: needs the adjacency rule.
- `|el :tags [a\]b c]`: list escapes are undecided.
- `|el :a true story` and `|el :count 7 apples`: these depend on a boundary I had to choose.
- `|el :c 1 z` and `:x one \ two`: these depend on which reading is chosen.

## 2. Where the grammar and the cards disagree

Most consequential first. "Repair" is my suggestion for what would bring the grammar in line with the card. It is not a proposal to change the card.

**1. A value may begin at a start (ran).** `value` ends in `text`, and `text <- piece+ &text-end` never checks where it begins. Since `main <- (WS value)*` is tried before `block`, ` :a 1` is read as one text, and so are ` |b`, ` ```sh` and ` @alice`. This is what turns every sameline item into `$main`. It also makes the `reserved` alternative in `value` dead code, because `text` comes before it. Repair: `text <- !start piece+ &text-end`.

**2. No slot for the space before a mid-line block, and BS-SEP takes the space the next value needs (read; ran in the repaired version).**
- In `(main block)*`, `block` has no leading `WS`, and none of its alternatives starts with one. A mid-line `:b` can be reached only by consuming the space somewhere that isn't written.
- `attribute` ends only at `BS-SEP / EOB`. So `|el :a 1 :b 2` can't end `a` before `:b`, because `:b` is on the same line and EOB fires only at a later line.
- `BS-SEP` consumes `WS "\" WS`, so the `main <- (WS value)*` after it fails on `Home` in `|a :href / \ Home`.

Repair: one item loop, `line-rest <- ((BS-SEP / WS) item)* framed-comment?`. An attribute ends at `&(BS-SEP / WS start / EOL)`.

**3. Elements in value positions (ran and read).**
- `main <- (WS value)*`, and `value` includes `element`. So a sameline element is captured as a `$main` value of the element before it (**ran**: `|a |b |c` gives `b` inside `a`'s `main`). That is the 0.10.0 value reading that [[rule:sameline-element-is-child]] rejected ("one of udon's most notable [elegances]").
- `attribute <- … (WS element / (WS value framed-comment?)+)` has the same problem. Because `value` includes `element`, `|el :a 1 |b` makes `|b` a second value of `a` (**read**). The PEG's own note ("an element only as the first value") and [[rule:sameline-element-is-child]] say it is a child of `el`.
- The fence is missing from both places. [[rule:fence-anywhere-structure]] makes a fence right after a waiting attribute that attribute's value (`|job :script ```sh`), and a fence after a finished value a child (Joseph, 2026-10-12: "I think child is the right call").

Repair: `element` and `fence` come out of `value`. They appear only as items of the line (children) and as an attribute's first-value branch, `WS (element / fence)`.

**4. Guards: Joseph's lookahead used as the whole guard (ran).** His `('|' / ':' / ';' / '@' / '!' / '```') !'{'` answers *start or embed*. The cards and his own words also decide *start or text*. The railroad file had those guards, marked OPEN, and the PEG dropped them.
- `|`: `| ` is text. Joseph, 2026-10-08: "(e) parsed as a node unless indented further than that in prose that has already started or escaped with \ or a space after the first pipe". [[rule:text-value-end]] lists "a space followed by `|name`". Whether `|` followed by a non-label character is an error or text is the labels question.
- `:`: [[rule:text-value-end]] says `:name`. What ` :-)` does is open in TODO-MSC. Joseph's 2026-08-09 frequency argument ("'emoticons in the $main attribute text and forgetting to escape' -- pretty unlikely … so unlikely compared to how often we'll want multiple attributes on the same line", quoted in [[prin:simplest-grammar-without-surprise]]) is relevant data for that question, but it isn't an answer to it.
- `;`: on a sameline, a comment needs a space on each side ([[rule:framed-comments]]; Joseph 2026-10-21: the space condition is "only for sameline"). The PEG's `start` makes ` ;note` mid-line a comment block.
- `@` and `!`: [[rule:reserved-spellings]] reserves `@` followed by a name, `[`, `.` or `<`, and `!` followed by a name or `:`. The PEG's `reserved` makes `! not a directive` at a prose line start an error (ran), which [[rule:prose-line-start-reserved]] doesn't ("`!` followed by a word").

Repair: give each start its own guard, as the railroad's section 2 did, and use `start` for both `text-end` and the item loop.

**5. Contexts with their own terminators (ran).**
- In `key <- "[" value "]"`, the key's text doesn't stop at `]`, so `|x[a]` fails and falls through to prose. Joseph, 2026-10-12, on `jw`: "parsed like any other value after ':attribute ', for example, but with distinct closing delimeter-- might need some rework".
- List items don't stop at whitespace or `]`.
- `|{…}` interiors stop at `}` ([[rule:inline-element-value-end]]).

One `text` production can't serve all four places. Repair: a `text` per context (line, key, list item, brace interior), or a parameter written out as separate rules.

**6. Keywords and numbers need a boundary (read).** `"nil"` matches the start of `nilly`, and `"true"` the start of `trueish`. What follows a number is the bare-typing gap. See question 4 below.

**7. The framed comment's position in `element` (read).** `element <- … (main block)* main framed-comment? EOB` puts the framed comment after every block. So in `|el ; note` followed by an indented `|child`, the child can't parse: the comment's EOB fires at the child's line, and then nothing lets a block follow. Under Joseph's 2026-10-20 reading (on an element, a framed comment is "just the next child"), it is one of the items, so it can sit anywhere in the item sequence.

The closer's comment has also been lost. The railroad had `fence-closer <- … (SPACE+ framed-comment)? EOL`. The PEG's lexer table folds the closer's framed comment into the `EOFB` token, which under the capture convention is disposable. That contradicts [[rule:comments-in-tree]] and the AST sketch's `closer_comment`.

**8. End of line as a frame is answered both ways inside the PEG (ran).** `framed-comment` accepts `&EOL` as the right-hand frame, so `|li Item ;` is an empty comment. `BS-SEP` is `WS "\" WS`, so `:a \` at the end of a line is the text `\`. [[rule:backslash-empty-text]]'s Statement ("`:name \` with nothing else MUST give the attribute an empty text") needs end of line to count. [[def:framed]] records this as open and the cards as disagreeing. The PEG should take one answer, or mark both places OPEN.

**9. Unknown escapes are silently literal (ran).** `bare-string <- (escape / !(embed / text-end) .)+` lets an unlisted `\X` through as characters, and the note says it "would be an error". Repair: `escape <- "\\" [set] / "\\" ⇒ error`. That is the shape the coordinator drafted in [[def:delimited-string]]'s notes for `"…"`.

**10. Ordered choice turns errors into text (ran).**
- An unclosed `"…"` or `<…>` fails and falls through to `text`, so `|el :a "unfinished` gives a text.
- At line level, a malformed structure line falls through to `prose`, as `|element[k] …` did above.

[[decision:errors-stop-parsing]] and [[rule:unclosed-delimiter-is-error]] want these to be errors. PEG needs commit points to say so: once `"`, `'`, `<`, `[`, `@{`, `;{`, `|{` or a guarded start has matched, failing is an error, never a backtrack. Labeled-failure PEGs and the cut operator are the precedents (from memory). A simple notation for the file would be a `%% commit` note on each such rule, or an `^`-style marker if mermaid accepts one.

**11. `"x""y"` (ran).** The PEG requires `WS` between values, so the whole line fails. [[rule:adjacent-quoted-strings]] (a lean) wants two values with a warning. `"abc"def` has the same shape and is open on [[rule:strings-like-ruby]].

**12. Prose against the text cards (read).**
- `prose <- prose-line+ EOB` has no blank lines inside it, and `BLANK` is a sibling block. So a blank line between two paragraphs makes two texts, where [[rule:blank-lines-inside-text]] makes one. Edge blank lines ([[rule:edge-blank-lines]]) need trailing `BLANK`s kept outside.
- The note "shallower is EOB" contradicts [[rule:text-shallower-line]]: a shallower line still inside its owner is text, with a warning, and the left edge moves.
- Prose doesn't end by column the way an element does. It ends at a start or a comment line at its edge, or at its owner's EOB. EOB is overloaded here.
- Nothing consumes an element's or attribute's own line ending, so the only production that can eat it is an empty `prose-line`. In the run, every element got an empty prose child.

**13. Rule names against the vocabulary (read).** Under the capture convention, rule names become AST names, so they pre-decide terms.
- `string <- double-quoted / single-quoted` renames the one definition Joseph has accepted: [[def:delimited-string]] («delimited-string», «double-quoted-string», «single-quoted-string»). The railroad used those names.
- `document` as the captured top is what [[def:document]]'s Avoid list warns against: the document is the source, and the root is something else, an element at column −1 under Joseph's 2026-10-21 lean.
- `prose` captured names an AST node that the cards say is a «text» ([[def:prose]]).
- `comment` names what [[def:comment]] calls «comment-block».

## 3. What the PEG gets right, checked

- The double- and single-quoted productions match [[rule:double-quote-escapes]] and [[rule:single-quote-escapes]] clause for clause: `\x[0-7]HEX`, `\0` not before a digit, `u{` tried before `u`, single spaces inside `\u{…}`.
- The `;{` decision at a line start follows from Joseph's lookahead. So does `|{` at a line start, which [[def:element-line]] lists as "Not decided". Both are now settled by his 2026-10-21 "That's what the lookahead was for", but the cards don't say so yet (see §7).
- Prose recognizes embeds and escaped embeds, and nothing else, which is [[rule:prose-passes-through]]. Mid-line `@name`, `!word` and ` ; ` in prose stay text.
- Root at −1, the fence body as raw text up to `EOFB`, and a comment block with no space required are all consistent with the cards and with Joseph's words today.
- `|q "hello," she said` and embed spacing come out right as written. With the repairs, so do sameline chains and `$main`-as-attribute.

## 4. The lexer/parser split (Joseph's "I'm fuzzy on whether…")

Python can produce INDENT and DEDENT before parsing for two reasons. Indentation is measured only at the start of a logical line. And the one thing about context it needs (inside brackets, so no NEWLINE) it tracks itself by counting brackets (from memory).

Lite's EOB, as the table defines it, needs more than that:
- the columns of blocks that begin mid-line, which means knowing which mid-line characters are starts;
- so it has to know which quotes, `<…>`, `[…]` and braces are open;
- so it has to apply the guards;
- it has to know the mode (value or prose), which depends on what kind of block encloses the line;
- it has to know the established left edge, which the first prose line sets.

That's the line grammar again. As the PEG is written, the grammar also backtracks. A failed `attribute` falls back to `prose`, which would make a start the lexer has already given a column stop being a start. The Haskell 2010 layout algorithm, with its `parse-error(t)` clause (from memory), is the cautionary precedent for a layout pass that has to ask the parser.

There are two clean ways out.
- **Make every decision the layout pass needs a lexical one.** That means guards decided by looking at a character or two, and an error, never a fallback to text, once a start has passed its guard. Then a lexer with its own stack (block kinds and columns, plus bracket and quote tracking on the line) really can emit EOB, and the PEG over its tokens is honest. This is the coordinator's labels lean: separate "does `|` open an element?" from "is this a valid name?", and make an invalid name an error, not text. That lean is what keeps the layout pass independent of the parser. The labels decision and the grammar's architecture are one decision.
- **Or let the column stack belong to the parser.** EOB becomes a predicate on the parser's open blocks, not a token. That is how descent works (from Joseph's description), and how indentation-sensitive PEG work does it, for example Adams 2013 (from memory). The spec would then state nesting as a short algorithm (the `rule:nesting` gap) and keep the PEG for what a line holds. That is roughly what the railroad's preface proposed.

My lean is the first. It costs nothing the cards haven't already leaned toward, it keeps "PEG over tokens" true, and it makes a parser for lite much easier to write. Agents and other bespoke implementations would struggle most with the parser-state version.

## 5. `|el :c 1 z`, and which items carry a column

The PEG's note says: "A value written after a block begun on the same line belongs to that block." Joseph, today: "It would be appropriate from a pure linefeed perspective as if `:c 1 z` [were] on its own line."

I tested that principle against what is already decided. On a sameline, only these items are drawn as owning what comes after them by column:
- elements ([[rule:sameline-element-is-child]]; [[rule:lines-follow-sameline-columns]] says "as if each of those **elements** had begun its own line at its column");
- fences;
- framed comments, measured from the `;` column ([[rule:framed-comment-owns-deeper-lines]]).

Attributes never are. Read the pure-linefeed way, `:a 1` then `|b` (or `:attr true` then ` ```sh `) puts the later item deeper than the attribute, so inside it. The cards and Joseph's 2026-10-12 correction put it on the element instead ("otherwise there's ambiguity about attributes after the closing backticks and/or indentation behavior etc. at the end").

So the linefeed reading has already been set aside for elements and fences that follow an attribute. Applying it only to values would make values the one kind of item that reads vertically after an attribute. Under the line-owner reading, `|el :c 1 z` gives `z` to `$main`, as [[rule:leftover-values]] says, and `:x "one" two` on an attribute's own line stacks, also as it says. The repaired run does exactly this.

There are two separable questions, and the PEG's one column rule merges them:
- **(a)** Does a mid-line attribute own later *items on its own line*? The rulings point to no.
- **(b)** Does it own deeper *lines*? This is the `rule:attribute-bodies` gap, and it is where R2 and R3 differ for his `|el :attribute some stuff \ and now $main` / `some more stuff`.

Answering (a) "no" leaves (b) fully open. It also changes how R1 looks. Today R1 ("the backslash ends only the text") was set aside because it seemed to contradict `|a :href / \ Home`. It contradicts that only if `href` keeps owning later values on the line. Under (a) = no, R1 gives `$main ‹Home›`, as [[rule:framed-backslash-frame]] draws it, and the framed ` \ ` needs no ownership role of its own.

## 6. The capture convention

Today's two-way split doesn't cover the PEG's own rules:
- `blocks`, `block`, `start`, `head`, `piece`, `text-end`, `prose-line`, `dq-char` and `hex-run` are lowercase, so they would be captured as AST fields, which surely isn't meant.
- `RAW` is uppercase and so disposable, but a comment's text, a reference's text and `<…>`'s text are exactly what the tree keeps.
- `reserved` and `reserved-embed` are lowercase, so they read as node kinds when they are errors.

What would fix it is three kinds of rule. **UPPERCASE** for named characters and character sets ([[def:characters]]) and for layout tokens. **`_lowercase`** for structure that is inlined and not captured. **lowercase** for what is captured, whose value is its captured children or, if it has none, its matched characters. Errors would be named as errors (`ERROR-reserved`, or a `%% error` note as the railroad did).

This is close to Lark's convention (from memory). I checked what mermaid 12.2's `railroad-peg-beta` accepts: `_rule` names parse, `#` comments parse, and labeled captures (`name:LABEL`, `@name`) do not. So Joseph's `':' LABEL:name …` would need a different spelling, such as the rule name carrying the field name (`attribute-name <- LABEL`), if it is to render.

## 7. Card-side follow-ups the PEG work implies (not made)

- [[rule:comment-blocks]]: the Statement still says "first non-space character is `;`". Joseph's lookahead ("That's what the lookahead was for", 2026-10-21) adds "not followed by `{`". The card's working note already predicts that wording.
- [[def:element-line]]: "Not decided: a line whose first content is `|{…}`" is now answered by the same lookahead. It is a prose line opening with an inline element.
- [[rule:prose-escaped-embeds]] lists `\|{ \@{ \;{`. The PEG adds `\!{`, which follows from [[rule:escaped-reserved-is-text]]. The card should say so, or the PEG should drop it.
- TODO-MSC's labels item "what a failed guard does" could mention that the grammar's architecture depends on the answer (§4).

## 8. Things the PEG decides without saying

- `|el [k]`: a spaced key isn't a key, so it becomes a `$main` list. This is the opposite of the provisional rule for traits ([[rule:traits-may-follow-spaces]], "spaces before a key" not discussed).
- `|Name|Role|` at a prose line start: blocks need no space before them, so it parses as `Name` with child `Role` and then an anonymous element. [[rule:prose-line-start-reserved]] says what this becomes "is not yet stated".
- Bare `hello` comes out as `text(bare-string)`, which is the cards' reading. The note marks this OPEN, but the productions choose it.
- `!{` inside `<…>`, `@{…}` and `;{…}` interiors is just characters, which is consistent with the cards.
- The fence opener's FENCE token disqualifies itself if any later backtick appears on the line, including one inside a later quoted string on that line (`|el ```sh :t "a`b"`). [[rule:fence-label-no-backtick]] read literally agrees, but nobody has looked at that case.

## 9. Questions for Joseph, as examples (with my leans)

1. **Guards.** How should this line read?
   ```udon
   |p this | that :-) ok ;not a comment ! wow
   ```
   With the card guards, it is `$main ‹this | that :-) ok ;not a comment ! wow›`. With the bare lookahead as written, it is an anonymous child element, an attribute error, a comment block and a reserved error. My lean is the card guards, plus an error (not text) when a guard passes and the name then fails. That is what §4 needs.

2. **Do mid-line attributes own later items on their own line?**
   ````udon
   |el :c 1 z :d |em hi ```sh
     body
   ```
   ````
   - Line-owner reading: `c 1`, `$main ‹z›`, `d` = `em` (with `$main ‹hi›`), and the fence a child of `em`.
   - PEG reading: `c` = [1, ‹z›], and the rest the same.

   My lean is the line-owner reading (§5), with attribute bodies left as their own question.

3. **End of line as the right frame.** `|li Item ;` and `|el :a \`: is it an empty comment and an empty text, or the text `Item ;` and the text `\`? My lean is that it counts for both (the coordinator's lean in [[def:framed]]). Either way, one answer for both.

4. **Boundaries after typed spellings.** How should this line read?
   ```udon
   |el :a true story :n 7 apples :m 7apples :k nilly
   ```
   Your 2026-10-09 words ("escaping what would otherwise be a type differentiator (number, quote, <, etc.)") read as: the first character commits the kind. If so, `:n 7 apples` is `7` then `$main ‹apples›`, and `7apples` is an error, not a text. My lean is to commit on the first character, with whitespace or the line end as the only boundary, and an error otherwise. I'm less sure about `true story`.

5. **Is EOB a lexer token or the parser's state?** My lean is a lexer token, made possible by lexical guards (§4).

## 10. What I read, and what I didn't

**Read whole:**
- every rule card in `src/`;
- the def cards for anomaly, attribute-name, blank-line, block-form, body, characters, column, comment, delimited-string, document, element-line, element-name, embed, fence-tag, fence, framed, head-position, key, left-edge, main, marker, prose, sameline, stacking, string, text-terminator, text, typed-value and value;
- `adr/no-bespoke-parser.md`, `adr/errors-stop-parsing.md` and both principles;
- `STEWARD-VERBATIM.md`, `HANDOFF-2026-10-20.md`, `TODO-MSC.md`, `main.outline.md` and `vsect-requirements-on-lite.md`;
- the railroad file, including its uncommitted working-copy block;
- the AST sketch.

**Partly read:** def cards for label, meta, node, opaque-span, quoted-name, reading-option, reserved, root, trait, transcript and tree.

**Not read:** `.int/pre-design/`, the other `.int` reports, `sop/`, and everything outside the lite store.

Multi-line behavior (EOB, prose and the fence body) was checked by reading, not by running. So treat findings 7 and 12 and §4 as careful readings, not as executions. Treat this report's list of findings, not its silence, as its content.
