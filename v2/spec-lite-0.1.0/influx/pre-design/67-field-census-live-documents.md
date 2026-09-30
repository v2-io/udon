# 67 — What real UDON documents actually contain: a small census, and the collisions it shows

*Raised by the history survey (files 50-69), 2026-09-29, second continuation. Neutral: the question, the alternatives, and where it has come up. Sources are pointers for the second pass, not authority. The counts below are mine, from rough regexes over the files on disk on 2026-09-29; they show shapes, not exact totals.*

## The question

Almost every lite question is decided in the abstract (what could go wrong), and the historical chats mostly use small illustrative examples. The only body of *unprompted* UDON is the handful of live consumer documents (`CONSUMERS.md`, scan 2026-07-16). What do they use, what do they never use, and where does a candidate lite rule collide with prose that real authors actually wrote?

## What the live documents use (rough census)

Documents: `arch/vivarium/DECISIONS.decision-log.udon` (~1700 lines), `LEXICON.udon` (~690), `terrestris.ordinum.udon` (~450), `autopax/taxonomy.udon` (~370), `vivarium/doc/PROCESS.udon` (~240), ASF `PROCESS-MAP-v0.udon` (~490).

- **Element line, keyed identity, then attributes**, `|decision[tile-as-honest-flat-artifact] :date 2026-07-12 :by us :status decided :topic naming`: about 160 such lines in DECISIONS alone; `[key]` on ~160 element lines there, 125 in LEXICON (`CONSUMERS.md`: 394 `[key]` sites in total). Bare dates as plain strings (111 date-valued attributes).
- **Element line with long unquoted sameline prose**: DECISIONS has ~245 element lines whose text after the name is prose, 224 of them over 80 characters (`|reason  Joseph, 2026-07-12: "tie the atmosphere reservoir back to ante-mundane…"`, `|ref  commit e13907c · crates/vivarium-world/src/uplift.rs · TODO §thermal-spine`). LEXICON ~85 (48 over 80 chars). The other documents use it lightly (9 to 20 lines).
- **Prose blocks under an element** (`|term[phase] :status carved` then a paragraph, then `|rel …` children), `;` comment lines (113 in DECISIONS, 48 in LEXICON, 27 in terrestris), blank lines between blocks.
- **Never or barely used** (`CONSUMERS.md` 2026-07-16): `@` references, inline `|{…}` elements, freeform fences, `<…>` value envelopes, `:key?` flags; my count also finds zero framed ` \ `, zero trailing-` ; ` comments on element lines in DECISIONS, and only a handful of `!` or `@` lines (mostly prose *about* UDON). Traits appear in terrestris (32) and taxonomy (4); node-valued attributes did not appear in my count.

## Where a candidate rule would land on real prose

For sameline text on element lines (what [01](01-sameline-element-child-or-value.md), [03](03-semicolon-in-prose.md), [53](53-element-line-text-continuing-below.md) argue over), I looked for framed marker shapes inside the text. Of ~365 such lines across the six documents:

| Shape inside sameline prose | Lines | Example (from DECISIONS) |
|---|---|---|
| framed ` :x` (a space then colon then non-space) | 6 | `…erosion.rs:371 (accumulate_drainage), :346, :390 · msc/…` and `(… charge[emergent-land] :tag gate …)` |
| framed ` \|x` (a space, pipe, name start) | 6 | `.archive/SUPERSEDED.md · LEXICON.udon \|meta[entry-schema]`, `ASF.md · ETHICS.md · LEXICON.udon \|note[aat-handshake] (was "ARCHIVED …")` |
| framed ` ; ` | 0 | (the LEXICON comment style is whole-line `;`) |
| a colon-space inside the text (`Joseph, 2026-07-12: "…"`) | ~94 | ordinary punctuation |
| double quotes, braces, brackets | ~81 / ~22 / ~61 | prose quoting and code names |
| `<…>` | 3 | `` `VIVARIUM_EROSION=<i>` `` |

Under 0.10.0/0.10.01's K10 ("an unquoted text value runs until a framed block-form marker…"), the first two rows are exactly the lines whose text would be cut at the marker: ` :346` starts an attribute `346`, and ` |meta[entry-schema]` starts a child/valued element. The authors of those lines wrote them as ordinary prose that mentions a file, a line number or another element by its UDON name. All of them are `|ref`-style pointer lists.

## Alternatives (what the census can inform, not decide)

1. **Framed markers end sameline prose** (K10): correct for `|a :x 1 :y 2`, splits the pointer-list lines above. Authors must escape or quote.
2. **Sameline prose is quoted or ends at the first attribute-shaped token only when the line began attribute-first**: the line `|decision[k] :date … :topic naming` is attribute-led; the `|ref  …` lines are text-led. The census shows the two styles almost never mix on one line (DECISIONS: 245 text-led, 160 attribute-led, counting only one style per line).
3. **A framed-marker rule that requires more than a space** (attached forms, guard letters), so `:346` and `|meta[…]` cannot be mistaken: ties to [06](06-suffix-characters.md) and to how tight the guard on ` :` is.
4. **Text-led lines are text to end of line, always; attribute-led lines are attributes to end of line** (mixed lines are the two-line form): the census suggests real documents already write it that way. See [53](53-element-line-text-continuing-below.md) and [73-is-the-element-line-a-typed-value](73-is-the-element-line-a-typed-value.md) (other survey, unread).

## Other data points worth having in the same place

- `CONSUMERS.md`: `|entry :date 2025-09-28 :authors Joseph, Architectus` was truncated to `authors = "Joseph,"` under 0.8 (the whitespace-terminated bare-token rule) and reads as author intent under 0.9's greedy text value. Real authors expect an unquoted multi-word value to run.
- `CONSUMERS.md`: under 0.8 a framed ` ; ` after a `:files […]` array value closed the element early and orphaned the norm's prose; fixed under 0.9.
- `vivarium/doc/PROCESS.udon` `[udon-safe-subset]` norm (a live consumer's own hand-written safe subset, 2026-07-11): "bracket ids unquoted; attributes always before prose/children; raw blocks via `!:lang:` never triple-backtick fences; no @-references; never start a prose line with a bare colon; treat temporal-looking bare values as unvalidated strings; QUOTE list items containing dots." Note it *avoids* fences and `@`, where lite is planning to *include* fences and reserve `@`.
- Reflow hazard, the field instance in that same norm (a re-wrapped sentence put `!:lang:` at line start and it parsed as a directive) is covered in [09 discussion](09-reserved-syntax.discussion.md).

## Sub-questions

- Should lite's authors treat "what the live documents do" as a usability floor (lite must read all of them without change), and is there a fixture set drawn from them?
- The census is of two authors' styles (Joseph's agents in vivarium and asf). Is a non-Joseph corpus needed before calling the pattern general?

## Interactions

[01](01-sameline-element-child-or-value.md), [03](03-semicolon-in-prose.md), [53](53-element-line-text-continuing-below.md), [10](10-inline-elements-and-inline-comments.md), [11](11-code-blocks.md).
