# TODO-MSC: lite's open work in one place

*Started 2026-10-20 at Joseph's request: "we should start a distinct TODO-MSC.md in v2/*lite*/ that collects it all into one place potentially-- or at least captures all the ones not part of the working notes and notes the priority of the working notes etc....." For whoever works lite with him next: what is open, roughly in the order to take it. It holds open items only; a closed item is deleted (git and the card keep what was decided). An item's detail lives in the card named, if any; an item with no card is written out here. Ordering and priorities are the coordinator's judgment unless marked as Joseph's.*

## Top priority: the definitions

Joseph, 2026-10-20: the shared vocabulary "is at least as important to adjudicate and settle as the "rules", from a spec readability, execution, adoption, and inculcation perspective." **None of the definition cards marked `strength: provisional` has been discussed with Joseph or accepted by him.** They are agents' drafts, with research and leans in their working notes. The only definition he has accepted is [[def:delimited-string]] (tacitly, 2026-10-20). Joseph, 2026-10-20: "In my mind that's pretty much top priority (hence labels / strings / text ...)". He expects these to come early: "body/string/text/prose/delimited-string/string-value/raw/label etc. will all be early parts of the definitions that need to be nailed down." Suggested order, each put to him as "what do you call this piece?" with a UDON example:

0. **«string» and «delimited-string»** (Joseph, 2026-10-20: "put it on the todo list to discuss-- we'll pull up all the mentions that need to read delimited-string instead and fix them and then see what's left and whether it needs its own definition"). Then the rest of his early set: [[def:body]], [[def:text]], [[def:prose]], "string-value", "raw" (the raw tree vs the opaque spans' raw text), [[def:label]].
1. With the labels: [[def:label]], [[def:element-name]], [[def:attribute-name]], [[def:trait]], [[def:quoted-name]].
2. [[def:sameline]], [[def:element-line]], and retiring "line scan".
3. [[def:tree]] (AST? drop "raw"?), [[def:reading-option]] ("view"?).
4. [[def:value]], [[def:typed-value]] (which sense of "typed value").
5. [[def:text]] (pieces and runs), [[def:prose]] (if not already taken up under 0).
6. [[def:meta]] vs ornament (also decides [[rule:edge-blank-lines]]).
7. [[def:block-form]], [[def:embed]], [[def:marker]], [[def:head-position]].
8. [[def:framed]], [[def:text-terminator]].
9. [[def:root]] ("root"?), [[def:transcript]] ("notation"?), [[def:anomaly]] ("errors and warnings"?).
10. [[def:comment]], [[def:body]], [[def:column]], [[def:left-edge]], [[def:fence]], [[def:blank-line]], [[def:document]], [[def:opaque-span]], [[def:reserved]].
11. Confirm the ones that look settled: [[def:key]], [[def:main]], [[def:stacking]], [[def:node]] (element / attribute).

## Also in discussion now

0. **The tree's shape, then its notation** (Joseph, 2026-10-20: "higher priority than just about everything else"). Settle the AST first: root as an element with column −1 (his lean, 2026-10-21); uniform vectors with cardinality enforced by strict getters (2026-10-21); attachments (comments, meta) that change no arity; a «text» as an iolist of string-reducible pieces; every value with kind and form. Then a printing of it that is udon-like but never conflates udon forms with AST primitives. Grounding: `.int/ast-sketch-2026-10-20.rs`; constraints on [[rule:tree-transcript]].
1. **Label characters.** The options are in `.int/labels-unicode-options-2026-10-20.md`, and the coordinator's lean on the rest in `.int/labels-ascii-and-positions-2026-10-20.md` ([[def:label]]). In order:
   - the Unicode repertoire for bare labels (default identifiers, immutable identifiers, XML's fixed ranges, ASCII only, KDL-style), and separating "does this open an element?" from "is this a valid name?";
   - ASCII punctuation in bare labels, every character of which is `Pattern_Syntax`: `-` `_` `:` `/` `$` `?` `!` `*` `+` `@` …; one character set for every label or a wider one for attribute names; first, inner and last positions;
   - what a label may never hold, even quoted: controls, bidi and other default-ignorable characters, noncharacters, private use, unpaired surrogates via `\u`;
   - whether a quoted label is always the same as its bare spelling (Joseph said yes for attribute names, 2026-07-16; element names and traits are open);
   - case (lite never folds?) and normalization (when two names are the same, for stacking and for keys);
   - what a failed guard does: does ` :-)` in sameline text open an attribute or stay text?
2. **The sameline escape set** ([[rule:value-line-escapes]]). It waits on 1; `.` joins it if spaced traits stay ([[rule:traits-may-follow-spaces]]).

## Exploration before `<…>` is settled

- **The spikes have landed; Joseph's review is next** (2026-10-22). Three spikes and their forks designed lite's value notation against [`CTQ-FACTORS.md`](CTQ-FACTORS.md); their work is in `.int/spike-values-2026-10-22/` (start with each `final-thoughts.md`; `adjudication.md` is an earlier, partly superseded synthesis). Where they ended up, together: bare values stay text, with nil/true/false/JSON numbers given a standard reading; a reading on the attribute name (`:mass.kg 3.2`, `:when.date(YY-MM-DD) 27-03-05`; spike c prefers `:mass(kg)`); constructor values standing alone (`date(2026-10-01)`); spike b's rule that a delimited value counts only if it stands alone, else the run is text; tagged backticks for foreign text; `<…>` possibly leaving values altogether. **No card has been changed from them yet**; that waits on his decisions:
  - Is adding a reading later a change (reserve-don't-ignore)? Every notation design assumes not.
  - `.kind` or `(kind)` on attribute names, and whether `.`/`(` may appear in bare labels.
  - The body of `name(…)`: read as list items, or kept verbatim.
  - Unprefixed notation names for the standard set only, every other name prefixed (spike b, after EDN).
  - A bad notation body (`date(2026-13-45)`): an error at parse time or only when read.
  - The stand-alone rule against his one-value lean (2026-10-21).
  - CTQ: "visible in the text" under A5 (spike c); B1's wording (kind of the construct vs a value's classification).
  - A bare URL ending at its first space (`|a :href https://x Click here`, spike a).
  - Whether `<…>` stays for values, and as what.
- **A type system and its notation, explored from the whole range of possibilities** (Joseph, 2026-10-22: "we could have a much more complete type-system in place, and we could use different brackets/combinations, and we should visit all of that in conjunction with or before "nailing down" '<...>' vs implicit angled brackets etc."). Pure ideation first; branches are scored against [`CTQ-FACTORS.md`](CTQ-FACTORS.md). What waits on it: every `<…>` question ([[rule:opaque-span-raw-text]]); `<>` as nil; how a value of another kind is written under the bare-run lean ([[rule:unquoted-run-is-one-value]]); the trailing `:` on attribute names ([[def:attribute-name]]); the `rule:bare-typing` gap; `@{<…>}`.

## Next: to settle (items with no card of their own, or spanning several)

- **How a bare value gets its kind: Joseph's lean, 2026-10-21, is (C) with a view.** A bare run is always a «text»; every other kind is written in `<…>`, which commits at its first character and errors on a mismatch; a typed-primitive view may read a text spelling exactly a number, `true`, `false` or `nil` as that value ([[rule:unquoted-run-is-one-value]], with A and B and why they lost in its context file). Questions this opens, each on its card: the spelling of nil and the `null` warning ([[rule:nil-spelling]]); the missing-value message ([[rule:missing-value]]); whether a non-primitive `<…>` interior such as `<2026-10-01>` is raw text or an error ([[rule:opaque-span-raw-text]]); keys and lists holding texts (`|step[1]`, `:tags [1 2]`); whether the view is on by default; whether a bare run with no embed is a «text» or a string of form bare. Also to carry: trailing whitespace of any kind is ornament unless kept with ` \ ` or quoted (his 2026-10-21 words; two cards disagree today).
- **`<>` is nil** (Joseph's lean, 2026-10-22, a new feature, orthogonal to the `nil`/`<nil>` question): `<>` empty is `<nil>` (or nil, if bare `nil` stays nil); distinct from the empty strings `""`, `<"">`, `''`, `<''>`, and from `<false>`. On [[rule:opaque-span-raw-text]]; to card with the `<…>` interior rules.
- **Suffix colons on a sameline** (Joseph's ideation, 2026-10-22, not a lean): `|element first: 1 second: 2` beside `:some-more: hey there`; a trailing `:` after an attribute name always consumed (`|el :attr: hi`); the suffix form only for simple names, perhaps with a length limit on names. Set aside 2026-10-22 ("OK, I'm convinced, with some caveats"); what came of it: [[rule:main-label-colon-warns]], [[rule:anomalies-suggest-a-fix]], and his light lean on an ornamental trailing `:` ([[def:attribute-name]]).
- **Multiple attribute values on a line, and what `\` closes** (Joseph, 2026-10-21: "something missed in the overall discussion about multiple attribute values"). `|el :c 1 z`: the block grammar (`.int/peg-2026-10-21.md`) stacks `z` on `c`; [[rule:leftover-values]] gives it to `$main`. And `|el :attribute some stuff \ and now $main` followed by a deeper line: does `\` end the text, the attribute's part of the line, or the attribute's block? Readings R1–R4 in the verbatim record (2026-10-21); his lean (2026-10-21, "perfectly fine … I think", the full conversation still to have): a sameline attribute closes after its first value, so `z` is `$main` and the framed backslash only ends a text; further values go on the lines below (the `rule:attribute-bodies` gap). Encoded in `.int/peg-2026-10-21.md`. Touches [[rule:leftover-values]], [[rule:text-value-end]], [[rule:framed-backslash-frame]], the `rule:attribute-bodies` gap.
- **`<…>` reopened** (Joseph, 2026-10-20): inside `<…>`, `nil`, `true`, `false`, a number or a delimited string would be a value of that kind, and anything else raw ([[rule:opaque-span-raw-text]], now provisional and awaiting decision). With it: the name for those kinds («primitive typed values»?), and the spelling of namespaces or type labels.
- **The value model** (Joseph's 2026-10-20 sketch, ideation; [[def:value]] working notes): every value has a kind and a form; whether bare `hello` and `"hello"` are both strings; whether a stack of occurrences and a list are one tree; comments as members of an attribute's values (pushed back); unlabeled `<…>` as a bare string (pushed back); a kind/form ontology for the tree and its «meta».
- **Named characters** ([[def:characters]], drafted 2026-10-20 from Joseph's «BACKTICK» idea): which names, upper case or not, and the named character sets that build on them.
- **A grammar notation** for the lexical layer (Joseph, 2026-10-20: "It probably wouldn't hurt to consider formulating some of the definitions at least and maybe even rules in terms of an EBNF or PEG grammar"): which notation, how indentation is handled, and which definitions get productions first.

- **Embeds inside other forms:** whether embeds are recognized, and how backslash escapes them, inside keys (`|x[a |{em b}]`), list items, and `|{…}` interiors. Joseph, 2026-10-20: "the not settled needs some settling". Settled so far: inside quoted strings an embed is just characters ([[rule:strings-like-ruby]]); inside `<…>`, `@{…}`, `;{…}` nothing is recognized.
- **Embeds as a whole** (Joseph: "we haven't correctly designed embeds yet"): where left-over text goes inside `|{…}`; whether `$main` applies in braces; multi-line `|{…}`; nested embeds; `;{…}` inside braces; his 2026-10-20 rewording, "embeds resolve to text (including empty string in the case of comments in most cases)", with target-dependent resolution (XML vs Markdown).
- **`@{<…>}`**, the reference embedded instead of the referent: whether the tree marks it ([[rule:opaque-span-raw-text]], working notes).
- **`~~~` fences:** Joseph leans to accepting both ```` ``` ```` and `~~~`, maybe recommending `~~~` ([[rule:fence-opens-with-backticks]]). Still to card: nesting and closing by tilde count, and whether backtick lines inside a tilde fence are body.
- **Every existing warning marked default-on or default-off** ([[rule:warnings-can-be-toggled]]), with the anomaly view ([[view:anomalies]]) collecting them.
- **Framed at end of line:** is `|li Item ;` an empty comment, and `|el :a x \` the text `x`? ([[def:framed]]; the cards disagree.)
- **Comments:** where a framed comment sits in the tree; whether a comment's text keeps the space after `;`; whether a line starting `;{` is a comment block or text opening with an inline comment.
- **The tree notation** ([[rule:tree-transcript]], which is the notation card). Joseph's 2026-10-20 constraints are on it: `‹…›` and `<…>` look alike; `<…>` must not mean "raw"; lesser-used single-width brackets welcome; an AST list must never be confused with a UDON list value. The coordinator's glyph proposal is in its working notes.
- **What a fence handler is in the spec**: who supplies one, how it is picked, whether its error stops parsing ([[rule:fence-default-handler]]). Joseph allows `awaiting-implementers` past his lean.
- **Kinds of node:** is an attribute a node; is the root an element ([[def:tree]], [[def:root]]).
- **His string/text worry** ([[def:string]]).
- **Purpose layer:** `force` on the four objectives, and adopting the two principles ([[obj:represent-xml-html]], [[obj:represent-structured-data]], [[obj:markdown-text-passes-through]], [[obj:reserve-dont-ignore]], [[prin:one-rule-everywhere]], [[prin:simplest-grammar-without-surprise]]).
- **The parser route** ([[decision:no-bespoke-parser]]): what "descent" means there, and whether the tiny-parser request still stands.

## The gap cards (rows in `main.outline.md` with no card)

Joseph, 2026-10-20: "I suspect we could get through the missing cards pretty quickly if we fire them off one at a time". Suggested order, spine first:

1. [[rule:nesting]]: deeper is a child, the same column a sibling, shallower closes.
2. [[rule:markers]]: what opens what where structure can start, and each marker's guard (follows the label work).
3. [[rule:element-names]] and [[rule:keys-and-traits]]: after the labels; includes one key or several, and whether `$traits` is always a list.
4. [[rule:bare-typing]]: the frozen set by spelling, every edge spelling.
5. [[rule:repeated-attributes]]: what a repeated attribute gives; duplicate keys.
6. [[rule:attribute-bodies]]: values written on the lines under an attribute (his "values as indented child blocks of an attribute").
7. [[rule:late-attributes]]: an attribute line after content has begun.
8. [[rule:source-lines]]: UTF-8, line endings (incl. the Unicode line terminators), BOM, final newline, how a column counts after non-ASCII characters.
9. [[rule:documents-and-files]]: one document per file; whether a file says it is lite.

## Cleanup

- **`nil` → `null` sweep** (Joseph's fiat, 2026-10-29; [[rule:nil-spelling]] and [[rule:missing-value]] done): the cards and definitions that still say `nil` as lite's null, as found that day: [[def:value]], [[def:typed-value]], [[def:string]], [[def:anomaly]], [[def:element-name]], [[def:reading-option]], [[rule:anomalies-suggest-a-fix]], [[rule:backslash-empty-text]], [[rule:opaque-span-raw-text]], [[rule:reserved-spellings]], [[rule:unquoted-run-is-one-value]] and its context, [[decision:errors-stop-parsing]], and two `main.outline.md` rows. Quotes of Joseph keep `nil` as written.

- **Defunct citations.** Cards cite 0.10.x (33 rule cards and 37 def cards on 2026-10-20), and also 0.9 drafts, pre-design numbers and retired records. Joseph, 2026-10-20: strip them from any card opened for editing; a settled card carries no working notes; history goes to a sidecar `<card-file>.context.md`. Done so far: [[rule:strings-like-ruby]].
- **The new card shape** (history sidecars, `context:` and `strength:` frontmatter, one-line Grounds, Implications, Decisions carried, dropping Epistemic status, the `awaiting-implementers` tag) is proposed to the SOP store in `sop/influx/udon-team-notes.md`; the `strength:` values (`forced`, `decided`, `lean`, `provisional`) Joseph approved on 2026-10-20 ("love your strength values-- yes"); recording them in the SOP store is what remains. `.vsect/kinds.yaml` already excludes `*.context.md` from resolving.
- **Declared forms on every def card** (`terms:` as a mapping to `pos` and `pl`, as in [[def:delimited-string]]), each card as it is reviewed; then cards write «texts» instead of «text»s. On 2026-10-20, 44 uses still put the ending outside the delimiters for undeclared terms.
- **Renames:** `def:node` → `def:element` (14 links); slugs still saying "label" (`rule-fence-label-no-backtick`); `rule-line-scan`.
- **Stale text:** `.int/README.md` (reserved spellings "keep the bytes"; "the same tree"); the `def:document` row in `main.outline.md`; `dat/implied-root.yaml` in the pre-design tree notation; `sop/src/conv-decisions.md` and `sop/adr/record-to-decision-links-for-now.md` should say cards are the decisions.

## Card working notes, by priority

*Open points that live in a card's working notes. High: blocks other work or is under discussion. Medium: needs a decision soon. Low: an edge or a wording question.*

| Card | Open | Priority |
|---|---|---|
| [[rule:value-line-escapes]] | the escape set and the strict rule (awaiting Joseph) | high |
| [[rule:traits-may-follow-spaces]] | provisional; the history search on hold; scope (only before the first attribute?); spaces before a key | high |
| [[rule:unclosed-delimiter-is-error]] | "by the end of its line" overreaches for `\|{…}` until embeds are designed | high |
| [[rule:reserved-spellings]] | the list is incomplete; past floated spellings | high |
| [[rule:fence-default-handler]] | what a handler is in the spec | medium |
| [[rule:fence-opener-line]] | whether a fence is an element of a special kind; how it prints | medium (`awaiting-implementers`) |
| [[rule:tree-transcript]] | which notation; final newline; numbers vs spellings; positions | medium |
| [[rule:inline-element-value-end]] | everything under embeds | medium |
| [[rule:list-items-whitespace-separated]] | unquoted item extent, `[]` vs `[ ]`, nesting, commas, backslashes, embeds as items | medium |
| [[rule:key-holds-a-value]] | where unquoted key text ends; an element as a key | medium |
| [[rule:opaque-span-raw-text]] | empty `<>` and `@{}`; `@{<…>}` | medium |
| [[rule:comment-blocks]], [[rule:comment-block-owns-deeper-lines]], [[rule:framed-comment-owns-deeper-lines]] | the space after `;`; tree order of attributes and comments; how continuation lines are stripped | medium |
| [[rule:deeper-marker-lines-are-text]] | does it hold for every marker, not only `\|` | medium |
| [[rule:adjacent-quoted-strings]], [[rule:strings-like-ruby]] | `"abc"def` | low |
| [[rule:blank-line-sets-no-indent]], [[rule:blank-line-whitespace-in-text]], [[rule:column-shifting-whitespace-error]] | which Unicode whitespace counts; tabs past the left edge; blank lines before a fence body's edge | low |
| [[rule:nested-attributes]] | flagged `needs-work`, but its notes say nothing is open: likely a stale flag | low |
| [[rule:no-break-space-counts-as-space]] | a no-break space where it sets no column (plain content?) | low |
| [[rule:warnings-can-be-toggled]] | how toggles are exposed (`awaiting-implementers`); warning-as-error; whether off warnings are carried at all | low |
| [[rule:fence-body-line-endings]] | "confirm with a second reader" | low |
