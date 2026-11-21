# Scratch: incoherences / revisits noticed while reading spec-lite whole (2026-11-07)

Format: where — what — why it matters. "Revisit" = reopens something Joseph already decided; "Conflict" = two cards disagree; "Drift" = card no longer matches his latest words.

## From the rule cards (src/)

- rule-unquoted-run-is-one-value (lean 10-21) vs rule-leftover-values / rule-adjacent-quoted-strings (decided): the run card says "the attribute that took it has nothing further on that line" — but leftover-values stacks a second value on an attribute line (`:x "one" two`). Only coherent if the second value is a *delimited* one after a delimited first; a bare run can never be "left over". Card should say so explicitly; today it reads as two rules.
- rule-unquoted-run-is-one-value Explanation: `|q "hello," she said` drawn as `$main "hello,"` + `$main ‹she said›` — consistent with leftover-values. Guide D2 / recommendation rule 2 (stand-alone) would reverse it; Joseph rejected stand-alone 11-07. Nothing to change; note that the recommendation's rule 2 is dead.
- rule-nil-spelling: Statement still "nil only, bare null warns" (decided); working notes carry 10-21 lean question (is it `<nil>` now?) and 10-29 "null under discussion". Three states on one card. Fine as marked, but TODO-MSC and the card should agree once decided.
- rule-missing-value message names `nil`, `''`, `\` — under the bare-text lean `nil` bare is text-with-view. Card itself flags it. Unresolved.
- rule-main-label-colon-warns: default-on/off not stated by Joseph; agent proposes off. The guide's recommendation 2 adds *another* default-on warning (quoted value followed by text) — not carded, and now moot.
- rule-space-before-text-end vs rule-whitespace-after-last-marker: disagree on trailing TAB/U+00A0 after the last marker (content vs ornament). Joseph 10-21: all trailing ws is ornament unless ` \ ` or quoted. Card flags; not fixed.
- rule-space-before-text-end: Joseph 10-09 ("stops the text (including '\') → delimiter+ornamental") vs 10-21 ("backslash keeps the ending ws"). Direct contradiction on `:a x   \`. Card flags; needs his answer.
- rule-text-value-end: `|a |b but not ```this one` — July example deliberately reversed 10-09 (fence opener ends text). OK, recorded as reversal. But: a sameline text mentioning ``` after a space now opens a fence; escape set (rule-value-line-escapes) still proposed, so today there's no way to write ``` in sameline text except quoting (→ string, not text).
- rule-framed-comments Explanation draws `|el :a 1 ; note` comment as child of element; Joseph 10-20 says it attaches to the nearest attribute. Card flags "needs redrawing". Drift.
- rule-fence-line-comments example draws both comments as children of the enclosing element; rule-fence-opener-line (Joseph 10-20 lean) makes them children of the fence. Conflict between two cards' drawings.
- rule-comment-blocks: `;{` at line start — comment block or inline comment opener? Open; both readings carded implicitly.
- rule-deeper-marker-lines-are-text: discussed only for `|`; holds for `:`, `;`, fences? Open.
- rule-inline-element-value-end: `$main` inside braces withdrawn (Joseph 10-09 "stop assuming"); yet rule-framed-backslash-frame's tree shows `|{a :href ‹/docs› ‹the docs}` with the leftover placed as a bare piece — consistent-ish (unplaced). Embeds undesigned; every typing proposal that leans on `|{name …}` (incl. my own 11-06 suggestion and the recommendation's rule 3) rests on this.
- rule-element-values + rule-element-after-attribute-with-no-value: `:due |date 2026-10-30 :renew 30d` gives `renew` to the date element. Known trap, not carded as a caution anywhere I saw.
- rule-key-holds-a-value: `|step[1]` → `$key 1` (number) in Explanation; under the 10-21 bare-text lean it's text. Card's own tree is stale vs the lean. (Also: `|step["01"]` → string.)
- rule-list-items-whitespace-separated: `[a "b c" 3]` → `3` drawn as number; same staleness vs lean.
- rule-line-scan Explanation: `:another <34>` — uses `<…>` for a number, i.e. the C-with-view world. Consistent with lean but will churn if `<…>` is retired.
- rule-opaque-span-raw-text: strength provisional, awaiting-decision; carries FOUR layers (10-08 raw text ruling; 10-20 reopen; 10-21 C-with-view; 10-22 `<>`=nil; 10-29 "don't reserve" lean). Most-loaded card in the store. Anything about `<…>` must start here.
- rule-opaque-span-escapes: `<re:\\d+>` example — regex in `<…>` as "typed value" with a label `re:` — presumes labeled `<name: …>` which was never ruled (spikes b/c made it an error). Example overreaches the Statement.
- rule-reserved-spellings: `@` row appears twice (rows 3 and 6) with overlapping "where" — sloppy table. `null` row removed 10-21. Also `@<…>` listed reserved while Joseph 10-20 floats `@{<…>}` as wanted — different spellings, fine, but worth one line.
- rule-prose-line-start-reserved: `![img](src)` at line start is an error (Joseph 10-21) — a real Markdown cost (images at line start are common). Recorded; flag as something to feel again.
- rule-fence-opens-with-backticks: `~~~` lean (10-20) uncarded.
- rule-fence-default-handler / rule-fence-opener-line: "fence is a specialized element node" — but def:node lists fences as a separate node kind, and rule-fence-exact-trait's tree draws `:$traits exact` under the fence like an element. Consistent in spirit; notation unsettled.
- rule-sameline-element-is-child "Costs accepted": `|card |title Hello` + block `:id 7` → late-attribute warning. rule:late-attributes is still a GAP card — the warning is referenced but nowhere defined.
- rule-one-root-node Discussion: streaming / host API / duplicate-key-scope objections to implied root "never answered on the record". Flagged by the card itself.
- Cards citing 0.10.0 as grounds (attribute-with-no-value, several Discussion sections): the TODO cleanup item; Joseph 10-20 wants them stripped.

## Things already talked about that the typing work re-raised (so I don't re-raise them)

- Streaming/lookahead: Joseph 10-21 (`4938…p`): no unbounded holdback; kind within a character or two. Spikes claimed "streaming doesn't separate" because the *old* parser held tokens — Joseph: old parser is not evidence. => His constraint stands; my 11-06/07 "whole run decides" proposals violated it. Dead.
- Stand-alone rule (spike b): dead 11-07 (Joseph: quoted text with escapes must stay; convoluted).
- `name(…)` on values: Joseph's canary was `(…)` *after an element or attribute name* (11-07 clarification), not on values.
- Suffix colons `first: 1`: set aside 10-22 ("OK, I'm convinced, with some caveats"); light lean on optional consumed trailing `:` remains.
- `<>` == nil: lean 10-22, orthogonal to nil/`<nil>`.
- Trailing-whitespace: 10-21 words supersede 10-09 on `\` keeping ws? needs his answer (see above).

## From the definition cards (def/) and decision records (adr/)

- def-typed-value / def-value / adr-term-typed-value: "typed value" has 3–4 live senses (any value — his 09-30 lexicon edit; `<…>` only — his 10-08 usage; `|el <42>` vs `|el 42` — his scratch list; the card's own). «implicit-typed-value» is drafted to include "an unquoted word", which the 10-21 lean makes a «text». The card's own invariant ("`:name web :port "8080"`, both values are strings") contradicts def-string/def-text (web is a text). Stale on its face.
- def-value Examples: `:c 3` drawn as an integer, `|step[1]` as integer in def-key — all pre-lean; under C-with-view these are texts. Several def cards still draw the pre-10-21 world.
- def-value working notes: Joseph's 10-20 sketch has bare `hello` as `string.bare`; his words since say «text». Open: is a bare run with no embed a text or a bare-form string? (Also flagged on rule-unquoted-run.) Decides the string/text worry.
- def-string: his "I do worry about string being its own type from text :-)" never answered; cards built the split anyway. Worth one direct question.
- def-text: «piece»/«run» drafted; he flagged "piece" as poor; "run" he later accepted for the sameline accumulation (10-21), which is the *other* sense from the card's. Two senses of «run» now live.
- def-prose: splits prose (lines below) from sameline text; he has written "sameline prose"/"$main prose" repeatedly. Agents' split, not his; needs the `|q "Hi," she said / and then left.` question.
- def-meta vs rule-edge-blank-lines: edge blank lines "MAY be kept in meta" vs his "layout (== ornamental)" and "content < content+meta < content+meta+ornament". Ornament is its own layer by his words; card mixes layers. Also fence-dedent MUST-be-in-meta vs "meta free to evolve".
- def-root: his 10-21 lean = root is an element at column −1 with `$`-attributes for parser facts; def-meta sense A (filename etc.) then moves into root attributes. Several cards still say «meta» for that.
- def-framed: END-OF-LINE as right frame — rule-framed-comments says "space on each side" (so `|li Item ;` is text) while rule-backslash-empty-text treats `:a \` at EOL as framed. Direct card conflict; the August K13 ledger counted EOL. Needs him: `|li Item ;` and `|el :a x \`.
- def-head-position: "head position" is his July term; agents renamed it "Structure Position" (never put to him); lite paraphrases. Restore or rename — his call.
- def-sameline: element-sameline/attribute-sameline — two readings (by line start vs by current owner); come apart on `|el :x |em hi :y 2`. rule-leftover-values reads like (i) but gives (ii)'s answer. "line scan" is agent jargon he doesn't recognize ("don't know what it's referring to").
- def-reading-option vs rule cards: "read" means *parse* in ~12 normative sentences and *view* in this term. Coordinator leans "view" (his January word); his 10-09 word was "representational-options". Unsettled.
- def-tree: his word is "AST" (83 prompts vs handful of "tree"); cards say «tree»/«raw-tree». His own sentence puts plain "AST" *after* options ("raw AST -> AST modified by representational-options"). Naming the specified thing "AST" would invert that. Ask with one example.
- def-node slug defines «element»/«attribute» while «node» lives in def-tree — 14 links land on the wrong card.
- def-fence-tag: "resolved 10-12" (fence word is an element name/label) but the card body still argues word-vs-line and names; rule-fence-body-dedent + outline still say "unless its label ends in `-`" (the `-` flag was replaced by `.exact` 10-12). Stale text in 3 places.
- def-body: "body" used for fence bodies (his), attribute's indented lines (agents'; his word was "child blocks"), and comment deeper lines. rule:attribute-bodies is still a gap; the gap card's slug presumes the word.
- def-anomaly: "anomaly" is not his word (umbrella from 0.9/0.10 agents); "valid lite" collides with XML's schema-valid. Coordinator leans drop «anomaly».
- def-key: "one key or several?" (he: surrogate + natural key, 07-16) — undecided, but every card says "the key".
- def-label: one character rule or a family (0.10 had three sets; K12 widened attribute names). He said 10-12 "I've lost most of my reasons for being so restrictive"; options file exists (labels-unicode-options); undecided. Everything label-ish waits on it: traits-after-spaces, `.` first char, `(`/`[`/`<` in names (bears directly on `:mass(kg)`).
- def-reserved: two senses (future syntax with known direction vs "undefined for now"); his noun is "construction", cards say "spelling". rule-reserved-spellings table has positional rows that aren't spellings.
- def-marker: embed openers `|{` `@{` `;{` are not markers → `|p a⇥b |{em x}` fine; rule-whitespace-after-last-marker leaves it unstated.
- def-document: «document» = source (his since Sept); his August `$DOCUMENT` sketch made it the root. Parser API result type must not be `Document`.
- adr-decision-authority / decided-for-this-version / leans-are-working-spec: three overlapping process records; `decided-by` values pending his sustained/ratified definitions since 10-01. Process debt, not spec.
- adr-reserve-not-ignore: the "same tree" promise was agent wording; downgraded to aspiration 10-08. **Relevant to typing:** the recommendation's rule 8 ("text may never gain meaning") is stronger than the actual decided posture (aspiration + reserve-is-error). c's B2 sentence was never put to him as law; it's the recommendation's, not a decision.
- adr-forward-compat-aspiration: "Opaque spans will be their own branch in the AST later" (Joseph 10-08) — i.e. he expected `<…>` to persist into full UDON as a branch; 10-29 lean makes it plain text. A real reversal of his own 10-08 picture, not just of agents' cards. Worth surfacing when `<…>` is settled.
- adr-term-typed-value: he chose «typed value» (explicit/implicit) over "typed literal" 09-29. The 10-21 lean empties the implicit set of unquoted values. Term needs re-grounding or retiring.
- adr-no-bespoke-parser: "descent" = toolchain or the 0.9 grammar? Open question for him since 09-30, never answered.
- obj cards: force fields all empty; principles unratified and he's "not convinced they are principled" (10-22). rule cards cite prin:simplest-grammar as Grounds (e.g. rule-anomalies-suggest-a-fix) — citing an unratified principle as grounds.
- obj-represent-structured-data: "lossless for JSON or fit-for-purpose?" — never asked; decides several value rules (and the whole typing question's stakes).
- obj-markdown-text-passes-through vs obj-reserve-dont-ignore: `@alice`/`!important`/`![img]` at prose line start are errors — the sharp conflict between two objectives; decided 10-08 (strict), but obj-markdown should name them as collisions and doesn't fully.

## Standing observations for the typing discussion (so I don't re-raise settled things)

- Streaming law: kind within a character or two; no unbounded holdback. His C-with-view (10-21) is the only bare-value model that satisfies it without errors on `920px`. Any proposal classifying at run end is dead (mine included).
- Quoted strings commit at the opening quote, keep escapes. Stand-alone rule dead (11-07).
- His canary = `(…)` after an element/attribute name; secondarily numeric+text = number + unit-text reading. Both kind-first / first-char-decidable.
- `<…>`: strong lean retire from values; lean not reserve (plain text). Conflicts with his own 10-08 "own branch in the AST later" and with `<>`=nil lean (10-22). Three of his own leans about `<…>` from three dates; needs one consolidation pass with him.
- `nil`/`null`: his 10-09 ruling nil; recommendation null; 10-29 "comfortable changing by fiat" but did not. Still his.
- Trailing colon: light lean, persuadable; 8/8 trial against; RST field-list `:Author: x` is an actual precedent for the look (not raised by anyone).
- Label characters undecided → `:mass(kg)` depends on it: `(` must not be a label char; label options file exists.
