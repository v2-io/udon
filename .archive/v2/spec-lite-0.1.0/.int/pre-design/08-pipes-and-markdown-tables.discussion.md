# 08 — Pipes in text, and Markdown tables: history

**Written by:** Claude (Opus 5.5), a history sub-agent, on 2026-09-29. I read the neutral file [08](08-pipes-and-markdown-tables.md), [`README.md`](README.md), and `../README.md` first. I did not see any lean, and this file adds none.

**Scope.** This file covers `|` in text and how Markdown tables survive. It also covers every *table construct* idea I found, because Joseph listed "better markdown-like tables" as possibly still open (2026-09-29).

**Method.** I read the primary sources wherever they could be reached. Joseph's typed words come from `~/.claude/history.jsonl`, where layout is intact; each is cited as `history L<line>` with its timestamp. Agent replies come from memorata results in the non-thinking classes only (`human-user agent-to-human subagent-final-response document`), and from the thinking-free session extracts in `v2/.archived/second-pass/spikes/session-vault/raw/claude/`. I checked that extractor's source: `extract_claude_jsonl.py` skips thinking blocks. I opened no raw `.jsonl` transcript.

**Gaps you should know about:**

- The December 2025 udon sessions are **not in the memorata index**. I checked sessions `38b75c32` (Dec 24), `6e3818d1` (Dec 23) and `9c70d20c` (Dec 22); `--scope-debug` returned 0 indexed records for each. So the agent replies to Joseph's Dec 22–24 table and pipe messages were **not retrieved**. Only Joseph's side and the resulting commits are below.
- `_archive/feedback.md` contains model thinking text. I quote only its response text.

**Searches run.** Any "nothing found" in this file refers to these searches.

- **memorata** (via a helper using `-n 150 --pool 400 --json` unless noted):
  - `"markdown table pipe udon"`, 4 classes → 44 results
  - `"pipe only an element when followed by letter markdown table compatibility"`, `--until 2026-01-10` → 5
  - `--joseph` queries (`--joseph` with date filters returns nothing, so none were date-filtered):
    - `"udon tables markdown-like tables"` → 2
    - `"pipe followed by space is text so markdown tables work"` → 2
    - `"|---|--- table divider row"` → 1
    - `"tabular data in udon grid rows columns"` → 8
    - `"better markdown-like tables"` → 4
    - `"table element tr td udon"` → 5
    - `"pipe character in prose udon"` → 3
    - `"markdown compatibility udon prose"` → 3
  - `"markdown table single-liner statements"` `--in` session fc191a72 → 1
  - `"pipe space with no element name as delimiter so markdown tables become valid udon"` (agent/document classes, `--pool 200`) → 14
  - `"udon markdown conflicts comments tables frontmatter …"` (agent-to-human, `--pool 300`) → nothing from Dec 2025
  - `"native udon table syntax rows columns cells element"` (`--pool 250`) → 3 relevant
- **history.jsonl** (Python scans):
  - phrases: "markdown table", "markdown-like table", "tables", "|---|---", "td's inside td's", "bit lookup tables", "| a | b | c--1", "sigil guard stuff", "single-liner statements", "instead of a markdown table" (projects matching udon/arch/archema)
  - regex `\|[a-z]+\||pipe|non-conflict|commonmark|gfm` over 2026 udon prompts
  - a full dump of 2025-12-23 17:00 → 2025-12-25 06:00
- **Repo:**
  - `grep -rIl -i "markdown.?table|pipe.?space|tight.?table|table.?row|table construct|tabular"` → 142 files; the ~70 `test/usability/results/*.yaml` hits were not read individually
  - `git log --all -S` for "Markdown table", "markdown table", "pipe-space", "Markdown tables", "table compatibility", "|table |tr |td A1", "Current limits by tier", "| Tier       | Requests/min", "|config|database[primary]:host"
  - greps of `core/generator/*.descent.udon`, `core/fixtures/`, `spec/`, `design/`, `_archive/`, and all of `v2/`
- **2011 originals:** `grep table|pipe` over `~/src/_older/udon` and `~/src/_older/udon-c`, dated with `git log -S`.
- **Live corpus:** greps over `~/src/arch` `*.udon/*.ud/*.un/*.desc` for tight `^\s*\|word\|` row starts (**0 hits**) and spaced `^\s*\| …\|$` rows (13 files).

---

## History (chronological)

Each entry gives the date and how it is known, the source, the speaker, the words, and a line on **what bears on this question**. Several entries are about something else and touch pipes only incidentally; those are marked as such.

### 2011-08-15 — pipe-space as a text/list marker; tight pipes chain; tables as chained elements
- **Source:** `~/src/_older/udon/examples/overview.udon`, L65–70, L78, L149–153. Introduced in commit `1b57c3a` (2011-08-15, "Another try at consolidating what I know…"). Speaker: Joseph (sole author of that repo).
- **Words:**
  - L65–70: "The \` | text\` form for text allows you to create lists like: … \`|list | one | two | three\` automatic awesome looking lists!"
  - L78: `| datadata...` is listed as a line-oriented "Data" form.
  - L149–150: `|table |tr |td hello |td you` / `|tr |td crazy |td world  # Each line starts over as child of table`
  - L153: `|html|body|.main|{head}`
- **Bears on this:** in 2011, pipe-space was a *marker* (a text/data line, and an item delimiter in `|list | one | two | three`), not literal text. Tight `|a|b` was a chain of nested elements. The first table spelling was chained sameline elements.

### 2011-12-14 — DECIDED.md: `|one|two|three` nests; `| ` introduces a simple value
- **Source:** `~/src/_older/udon-c/docs/DECIDED.md`, L25, L64, L76–84, L95–99. Commit `4edf78e`, 2011-12-14. Speaker: Joseph.
- **Words:**
  - L64: "`|one|two|three    ==>    |{one |{two |{three}}}`"
  - L76–77: "If a '|' is followed by a space, It no longer deliniates a node, but instead deliniates a SIMPLE VALUE"
  - L82: "'|| some data' (probably the more clear alternative)" (anonymous node plus data)
  - L95–96: "Once data text has started on a line, pipes etc. are all treated literally like any other text."
  - L98: "Markdown-like languages easily implemented with tags, for example, named '==='"
- **Bears on this:** the oldest explicit ruling on a tight `|a|b|c` row: nested elements. It is also the oldest statement that pipes are literal once text has started on a line. Pipe-space was still a marker then (it opened a value).

### 2025-12-22 14:28 — Joseph asks what conflicts with Markdown
- **Source:** history L5394 (session `9c70d20c`, project `~/src`). Speaker: Joseph.
- **Words:** "Are comments and possibly tables the only things that would potentially conflict with markdown? (e.g., if the document were primarily markdown but had some udon sections like the frontmatter)"
- **Bears on this:** the first revival-era mention of tables as a Markdown-conflict risk. The agent's reply was not retrieved (session not indexed).

### 2025-12-23 13:52 — Joseph: ` | ` as a delimiter so Markdown tables become valid UDON
- **Source:** history L5466 (session `6e3818d1`, `~/src/udon`). Speaker: Joseph.
- **Words:** "…would you then look at the older ~/src/_ref/udon and ~/src/_ref/udon-c projects and look for notes on the one-line issue and also potential notations for inline (like |{...} or I like the idea of \` | \` with no element-name being a potential delimiter. I was considering that already anyway to make markdown table so that they would be potentially made into valid udon..."
- **Incidental in the same message:** the main topic is `|a |b |c` nesting ("currently `|a |b |c` is treated like c is a child of b … instead of b and c being siblings") and one-liners.
- **Bears on this:** a **table-construct idea**. Pipe-space would work as a *delimiter* with meaning, so that a Markdown table row becomes real UDON structure rather than opaque text. This is the opposite of the "pipe-space is literal" rule adopted the next day.

### 2025-12-23 (commit d82af7a) — the column-aligned `|table |tr |td` idiom enters the spec
- **Source:** commit `d82af7a` (2025-12-23, "Update spec with inline usage…"). It is still present in `spec/CORE.md` L1008–1018 ("Column-Aligned Siblings") and in `v2/spec-0.09.01/TUTORIAL.md` §4, L63–67. Speaker: an agent-drafted spec, committed by Joseph.
- **Words** (CORE L1014–1016): `|table |tr |td A1` / `           |td A2       ; same column as |td A1 -> sibling` / `       |tr |td B1`
- **Bears on this:** the existing UDON-native table spelling: chained sameline elements, with continuation lines aligned to columns.

### 2025-12-23 18:13–18:14 — the chained table goes wrong; Joseph: "absolutely incorrect UDON"
- **Source:** commit `bd22435` (18:13:53) added this to `examples/comprehensive.udon`: `|table[rate-limits] |tr |th Tier |th Requests/min |th Burst` / `|tr |td Free |td |{n 60} …`. The commit message says "Table using column-aligned siblings syntax". Speaker: agent. Joseph replied at history L5490 (18:14).
- **Words (Joseph):** "That is absolutely incorrect UDON... but it's an example that keeps reappearing!  (it has td's inside td's)"
- **Bears on this:** under the nesting rule, same-line `|td` after `|td` is a *child*, so cells nest. Joseph notes this as a mistake agents keep making. It is the first recorded failure of the chained-element table construct.

### 2025-12-23 by 18:57 — the tier table becomes a Markdown table with inline elements in its cells
- **Source:** commit `b96cad0` (18:57), `examples/comprehensive.udon`. It replaced the `|table |tr` form with escaped Markdown rows:
  ```
  '| Tier       | Requests/min | Burst    |
  '|------------|--------------|----------|
  '| Free       | |{n 60}      | |{n 10}  |  ; It is assumed that inlines like |{..} are
  '| Pro        | |{n 600}     | |{n 100} |  ;   processed before any markdown rendering/processing
  ```
  Speaker: agent in Joseph's session, right after his remark. The `'` was the escape of the time. It was later removed; see 2026-07-19 below.
- **Bears on this:** the first "Markdown table as prose, with UDON inline elements in its cells" pattern. It depends on the rows being text, so that `|{…}` fires as inline structure inside them.
- **Also that session:** a second table in the same file, `|table[format-comparison]   ; Obviously this could just be a markdown table instead, but demoing more structure` with `|tr |{th Format} |{th Prose} …` (now `design/examples/comprehensive.udon` L107–113). This is a third spelling: one row element with inline-element cells.

### 2025-12-23 21:45 — Joseph: "Markdown *is* correct UDON" (with a table)
- **Source:** history L5527. Speaker: Joseph.
- **Words:** "This problem doesn't make sense to me. Markdown *is* correct UDON:" (followed by a Markdown doc including `| Tier | Requests/min |` / `|------|--------------|` / `| Free | 60 |` / `| Pro | 600 |`) "That is correct UDON from the beginning."
- **Bears on this:** the intent that a spaced Markdown table is simply valid UDON text.

### 2025-12-24 08:09 — Joseph: prefer Markdown in prose; maybe Markdown parsing is core
- **Source:** history L5567 (session `ef2ca566`). Speaker: Joseph.
- **Words:** "In fact... maybe in SPEC we should specify that Udon should generally prefer markdown in prose rather than inline-udon equivalents. And, unlike liquid... we may need to consider markdown parsing as part of the core parsing... A note for SPEC and parser-strategy for now."
- **Bears on this (partly incidental):** it frames Markdown, tables included, as the preferred prose layer. The "Markdown parsing as core" thought later went the other way: text is opaque to the core (0.9.1 and 0.10.0 §7.1).

### 2025-12-24 16:29 and 16:38 — Joseph proposes the pipe rule, then its inverse
- **Source:** history L5594 (16:29) and L5595 (16:38), session `38b75c32`. Speaker: Joseph.
- **Words (16:29):** "The final open question is anonymous elements: \` | <- nothing touching it\` as well as this: \` |---|:---...\` -- I propose we very specifically say that a pipe followed by whitespace, dash, or another pipe, in addition to a pipe preceded with a single-quote, all get preserved as-is. This ensures no collisions with markdown tables. Do you see any issues with that or other ideas?"
- **Words (16:38):** "I already covered the colon in my pattern but forgot to spell it out. If we do the inverse and just distinguish on 'identity' -- that might be the best way to cover unnoticed other uses of pipe, but it will need to be a little more involved. … So parsing cares about \`'|\` (removes escape single-quote and passes pipe through), or '|' followed by /[\p{L}[.{']/  (note for SPEC / parser-- unicode alphabet, not just ascii [a-zA-Z_] etc.)"
- **Bears on this:** this is **the origin of the current guard**:
  - The first proposal was a *blacklist*: `| ` `|-` `||` (and `|:`, per 16:38) stay text.
  - Joseph then switched to the *whitelist*, "distinguish on identity", "to cover unnoticed other uses of pipe".
  - The divider row `|---|:---` was named explicitly. Tight header rows were not discussed.
  - The agent's reply in between (it apparently raised `|:`) was not retrieved.

### 2025-12-24 16:47 — the rule lands in SPEC
- **Source:** commit `38a2231`. Its message: "Add element recognition rule: | is only an element when followed by Unicode letter, [, ., {, or ' (preserves Markdown table compat)". Grammar comment added: `; Otherwise "|" is prose (preserves Markdown table compatibility)`. Speaker: agent, committed by Joseph.
- **Bears on this:** the whitelist version is ratified in the spec text. From here on, "pipe-space is literal because Markdown tables" is the stated reason.

### 2025-12-27 / 12-28 — the parser lags the rule (Codex review)
- **Source:** commit `822160f` (2025-12-27, "Fix pipe-as-text handling…"). On 2025-12-28 18:04 Joseph pasted a Codex review into a libudon session (memorata: `~/.claude.bak.2026-01-26/projects/-Users-josephwecker-v2-src-libudon/7947ca84….jsonl:6066`, human-user). Speaker: Codex (quoted by Joseph).
- **Words:** "Pipe-as-text isn't enforced in prose. SProse always treats any | as an element and parse_element defaults to an anonymous element on invalid starters, which breaks Markdown table pipes and violates SPEC's '| only starts element when followed by …'."
- **Bears on this:** implementation lag only. The intent stands.

### 2025-12-30 / 12-31 — "'| ' doesn't get consumed"
- **Source:**
  - A subagent summary on 2025-12-30 (memorata: libudon `agent-a46f3b3.jsonl:45`, subagent-final-response): "Pipes not followed by valid element starters are treated as literal text: `|p This is a | (pipe character), not an element.` This maintains **Markdown table compatibility**…"
  - Joseph, history L6592 (2025-12-31 23:45, session `31853cab`).
- **Words (Joseph):** "No-- the expectation is wrong. Think markdown tables passing through. '| ' doesn't get consumed-- it's just part of the prose."
- **Agent reply** (memorata, agent-to-human, `31853cab….jsonl:5666`): "Understood - the parser is correct. The pipe is prose content (like markdown tables)."
- **Bears on this:** makes explicit what changed from 2011. Pipe-space is not consumed; the pipe itself is text.

### 2026-01-03 — fresh-model review: "native UDON tables might be cleaner"
- **Source:** `_archive/feedback.md` L127 and L235 (response text only). Opus 4.5 first-contact review, originally `~/src/udon/feedback.md`, memorata-dated 2026-01-03.
- **Words:**
  - "**Tables**: The spec doesn't address tables. Markdown tables (via GFM compatibility) work, but native UDON tables might be cleaner."
  - Later, on the prose subset: "Omit from base spec: tables (use UDON elements), footnotes (host-defined)…"
- **Bears on this:** the first agent pushback asking for a native table construct. The same review also argued for leaving tables out of the Markdown subset and using elements.

### 2026-01-14 — tight `|a|b` as *path* syntax
- **Source:**
  - Joseph, history L7893 (08:09): "is there a more 'Udonic' path syntax? Naively considering, for example '|element|child @el[id] ...' ?"
  - Same day, commit `e8b82f7` added `design/udon-paths.md` with `|config|database[primary]:host` and "Double-pipe `||` means 'at any depth'" (L48, L76–124).
- **Bears on this (incidental to documents):** a tight `|a|b` has carried a third meaning, "child of" in the path language, besides nesting (2011) and text (current parser). This matters if lite reserves `|word|`, or if paths ever appear in document text.

### 2026-01-14 12:08 — Joseph: "more in the spirit of a markdown table"
- **Source:** history L7903 (session `145408e9`). Speaker: Joseph.
- **Words:** "It is very easy in udon to visibly represent data in a way that illuminates the data -- that is more in the spirit of a markdown table (and might include markdown tables) than xml or csv or json -- but that allows for commentary and different layering of voice/perspective for different needs."
- **Bears on this:** the Markdown table is named as the *aesthetic target* for UDON data presentation, and literal Markdown tables are expected to live inside UDON.

### 2026-07-08 — estate review: `| healing` rows; column alignment demoted
- **Source:** `_archive/REVIEW-JULY-2026.md` L212–241 and L271–285 (agent-written; the re-ranking is "Joseph's calibration").
- **Words:**
  - Concern 4: "the ASF process map's own conventions block parses as an interleaving of comment-continuation lines and prose lines (the `| healing` rows survive only via the Markdown-table-pipe rule)."
  - Concern 7: "Column alignment is an edit hazard in exactly one style *(demoted from #1; calibration Joseph's…)*… Block-style documents … are exactly as robust as Python".
- **Bears on this:** the first recorded real-document reliance on the pipe-space rule outside tables. It also rates the column-aligned style that the `|table |tr |td` idiom depends on.

### 2026-07-11 — prose-collision measurement: table `:---` and math `|E|`
- **Source:** `_archive/spikes/prose-collision-2026-07.md` (spike S3, header dated 2026-07-11; the old parser at `eb9aca1`), L142–144 and L174–180. Speaker: agent.
- **Words:**
  - Table: "colon-eaten (silent) | … `:--`/`:---` (table alignment) …"
  - Table: "pipe→Element | `\|[id]`, `\|figure?` … (UDON doc tokens); `\|E\|)$`, `\|V\|)$.`, `\|Delta-H\|`, `\|delta\|` (math) | … **set-cardinality/absolute-value notation in math prose**"
  - Text: "**The `|`+space guard already carries the pipe load.** Every observed markdown-table row token was bare `|` (guarded). What remains is `|letter`/`|[` — … (b) **math notation `|E|`, `|delta|`** … No cheap guard distinguishes `|E|` from `|em phasis`".
- **Bears on this:**
  - The line-initial `|word|` shape occurs in real prose as math. This matters for any rule that treats `|word|` specially (neutral file alternatives B and D).
  - Table alignment colons were being eaten when they landed at line start. That was a parser defect then.

### 2026-07-11 — Joseph restates the guard (ledger)
- **Source:** `_archive/DECIDED.bak.md` L327–333: "Refinement 2 (Joseph, 2026-07-11) — recognition is a per-marker predicate". Agent-written ledger recording Joseph.
- **Words:** "`|` is a marker only if followed by a letter / `[` / `.` / `{` / `'` — `|` + space is prose (the established pipe guard; Markdown-table safe)."
- **Same day**, Joseph asked "OK, what's the sigil guard stuff talking about?" (history L15848, 22:40). The agent answered (vault `da5d1672…md` L3566): "`| col | col |` (a Markdown table) and `| maybe tomorrow` (prose) stay prose. Without that guard, every Markdown table row would parse as nested elements."
- **Bears on this:** reaffirms the guard. The agent's "every row would parse as nested elements" assumes the *spaced* style.

### 2026-07-11 15:39–15:47 — .desc as lookup tables; column-aligned continuation rows
- **Source:** history L15770 and L15772 (session `da5d1672`). Speaker: Joseph.
- **Words (15:39):** "I always loved that .desc files essentially read (to me) like bit lookup tables (and literally render in markdown as tables w/ the right help) -- it made it very easy for *me* to reason about the actual steady advance of the cursor … BUT, there are limits where suddenly the per-line lexing of the ruby and it's assumptions were dictating desc syntax more than the principles…"
- **Words (15:47):** "desc … forced things like: `| a | b | c--1 |` / `|   |   | c--2 |` Which can now be (without sacrificing readability and in fact improving it: `| a | b | c--1 |` / `        | c--2 |`"
- **Recorded as a principle** in `design/desc-design-principles.md` L20–29: "the table-scan property … they must not dissolve the table".
- **Same day, the udon-reader spike** (`tools/descent/rust/spikes/udon-reader/NOTES.md` L90–102; `tools/descent/rust/PROGRESS.md` L119–121, agent) found that in UDON's own grammar files "`|return` (pipe+name-char) becomes a child *element*; `| ->` (pipe+space) becomes *text*. Reader must normalize both to parts." It also found that empty placeholder cells were a "lexer artifact".
- **Bears on this:** this is the one in-house table-shaped UDON dialect. It shows the same split the neutral file describes: a pipe followed by a name is structure, while pipe-space is text. It also carries Joseph's idea that column position can stand in for empty cells.

### 2026-07-12 15:23 — tables inside element prose, by convention
- **Source:** history L15899 (archema-io). Speaker: Joseph, on the vivarium decision-log format.
- **Words:** "|decision  The decision written out -- feel free to do linebreaks for markdown etc. (lists, tables), but no manual linebreaks based on column width."
- **Bears on this:** Markdown tables are an expected part of block prose inside UDON elements.

### 2026-07-13 — a live consumer wraps tables in `!:md:`
- **Source:** `~/src/arch/vivarium/LEXICON.udon` L19, added in vivarium commit `013cc5b` (2026-07-13). Author: an agent in the vivarium estate.
- **Words:** "Markdown tables live in !:md: blocks (a bare table row would parse as an element)."
- **In practice**, `vivarium/DECISIONS.decision-log.udon` uses both: an `!:md:` table at L594–597, and a bare spaced table inside a `|reason` body at L807–814.
- **Bears on this:** at least one author believed bare rows are unsafe. That is true only of the tight style. Lite reserves `!`, so `!:md:` is not available in lite.

### 2026-07-13 — MARKDOWN.md: which parts of Markdown's range (tables?) the `doc` schema covers is open
- **Source:** `spec/MARKDOWN.md` L55–56 (agent draft, "unratified by Joseph").
- **Words:** "**Open (D4b):** the `doc` element set, attribute conventions, versioning, and how much of Markdown's range it covers (tables? footnotes? task lists?)."
- **Bears on this:** an element-vocabulary table (Layer 2) is named as open, owned by the schema layer rather than core syntax.

### 2026-07-14/15 — suffix characters in the guard and Markdown safety
- **Source:** vault `da5d1672…md` L7717 and L7960 (agent), plus L4299.
- **Words:**
  - First: "So `|?` (and `|!`, `|*`, `|+`) can't be both. Either the follow-set needs the suffix chars added, or … There's a real Markdown-safety tension in adding them (`|` in tables)".
  - Then, after checking the grammar: "the **parser already accepts `|?`** … add `? ! * +` to the documented `|` follow-set. (Markdown tables aren't threatened; the parser has been doing this all along.)"
  - L4299: "Recognition follow-set … excludes digits and `_`: `|1foo` and `|_foo` are prose … Intended (Markdown-table/list compat), I assume — but it's unstated *why*".
- **Bears on this:** how `? ! * +` entered the guard. The "not threatened" judgment was about spaced tables. A tight cell starting with `*` (bold, `|**Name**|`) passes the guard (see gaps below). This connects to [06](06-suffix-characters.md).

### 2026-07-15 21:19 — Joseph: a framed ` | ` as sameline separator; agent pushes back on table grounds
- **Source:** history L16354 (session `be2e5fbd`). Agent reply: vault `be2e5fbd…md` L358.
- **Words (Joseph):** "But the truth is I would also not mind `|el :alpha something | and this is the text child of |el`... but it would be creating a whole new bag of problems... but it *looks* so good!"
- **Words (agent):** "On the `|` version — I'd let that one go … `| ` (pipe-space) is precisely the pattern the `|` guard *protects as literal* for Markdown tables. `|el :note the ratio | a | b |` — if bare pipe-space became a content separator, every table row in sameline text shatters. The `\` form gives you the identical visual break … with zero collisions."
- **Bears on this:** the second time (after 2025-12-23) Joseph wanted ` | ` to *mean* something. It was checked by the table rule, and the framed `\` became the breakout (later K10).

### 2026-07-15 — fixtures pin the spaced cases
- **Source:**
  - `core/fixtures/v0.9/markers.yaml` L33–55: `pipe_dash_is_prose` ("markdown table delimiter row is prose"), `pipe_space_is_prose` (`| a | b |`), `bare_pipe_is_prose`, `pipe_equals_is_prose`
  - L232–238: `prose_commit_markers_literal`, `|p a | b :-) ! \`\`\` all literal`
  - `core/fixtures/legacy-pre-0.8/element_recognition.yaml` L52–76: `pipe_in_markdown_table_is_prose`, `pipe_followed_by_hyphen_is_prose` (`|- list item`), `pipe_followed_by_number_is_prose`
- **Bears on this:** evidence of what was built and pinned. No fixture pins a tight row (`|a|b|`).

### 2026-07-16 — incidental: pipes in the *spec's own* Markdown tables
- **Source:**
  - Joseph, history L16370 and L16376: "just trying to see if there was a way to do the pipes that would make the spec easy to read without an over-abundance of pipe-escaping" and "Go ahead and remove the \ before the pipe when within \`...\` -- even in the tables."
  - `spec/TODO-SPEC-CORE.md` L99–106, "Bare-pipe table fragility".
- **Bears on this:** incidental. It concerns Markdown documents *about* UDON, not UDON grammar. It does show `|` in table cells causing friction in both directions.

### 2026-07-19 — clean-room rewrites all keep the guard
- **Source:**
  - `v2/.archived/first-pass/greenfield-2a/snippets/from-corpus/01-elements-identity.md` L43–53 ("Non-element pipes stay prose (Markdown table safety)": `| a | b |` → `Text "| a | b |\n"`)
  - `greenfield-3b/new-spec/GRAMMAR.md` L53
  - `greenfield-2a/new-spec/RATIONALE.md` L11
  - Commit `926d786` (2026-07-19, "examples: modernize…") removed the `'` from the comprehensive tier table. Its comment now reads (`design/examples/comprehensive.udon` L459–461): "A leading '| ' is already always literal prose (pipe-space preserves Markdown table compatibility), so no leading apostrophe is needed…"
- **Bears on this:** independent agents reproduced the guard unchanged. No new table idea appears.

### 2026-07-22 — 0.9.1 consolidated suite
- **Source:**
  - `v2/spec-0.09.01/CORE.md` L102: "**Committing to prose.** The first content word ends Structure Position for that physical line: from there to end of line, marker characters are literal … This one state plus that one carve-out is what keeps Markdown tables, `:-)`, a mid-prose `!`, and after-prose backticks literal"
  - L114: the guard
  - `RATIONALE.md` L11
  - `TUTORIAL.md` L15 ("tables survive") and §4 L63–67 (the `|table |tr |td` idiom)
- **Bears on this:** this is the baseline lite cites. Two of its table protections are *separate*: the guard (line-initial) and commit-to-prose (mid-line).

### 2026-07-28 — measured: the non-conflict claim covers `| a | b |`, not `|a|b|`
- **Source:**
  - `v2/theory/to-integrate/refine-more/markdown/commonmark-non-conflict-table.md` L31–34, L44, L94, L212 (agent; commit `1e75f3f`, "Measured probes")
  - `thoughts-on-scope.md` L169 and L218
  - Probe inputs `g01`/`g02`/`g03`/`h07`/`h08` in `v2/spikes/markdown-probe/out/glyph-cases.frame` and `glyph2-cases.frame`. The event outputs were not saved in the repo.
- **Words:**
  - "The pipe-space 'preserves markdown tables' claim wants narrowing: it covers `| a | b |`, not `|a|b|`."
  - "**The corpus has no GFM** — no tables…"
  - N2: "**Tight GFM table** `\|a\|b\|` | `\|a` passes the element guard → element named `a`. It fails *partially*: the delimiter row `\|-\|-\|` and data row `\|1\|2\|` survive as text (`-` and digits fail the guard), so only the header row becomes structure."
- **Bears on this:** the first (and, as far as I found, only) measurement of the tight style. It is recorded as a "narrowing" of the existing rule, not as an open question. **Nothing I found shows Joseph responding to it.**

### 2026-07-29 16:48 — Joseph: single-line UDON rows can look like a Markdown table
- **Source:** history L17931–17932 (session `fc191a72`). This was about the theory OUTLINE written as UDON (now `v2/theory/OUTLINE-possibilities.outline.udon`). Speaker: Joseph.
- **Words:** "I wouldn't be so sure... I'll bet you can stick mostly to single-liner statements and make it look pretty close to a nice markdown table." / "(to your note that it might not read nicely)"
- **Bears on this:** a **table construct by convention**: one-line records (`|segment?[slug].T :max S`) that read as table rows.

### 2026-07-30 — type-algebra: pipe-space incumbency "carries genuine weight"
- **Source:** `v2/theory/to-integrate/primary/type-algebra.md` L136 (agent).
- **Words:** "`| `-as-literal protects every Markdown table in every prose block, a consumer population that is real and load-bearing, so the incumbency here carries genuine weight … (a bare-`|`-before-EOL guard extension wouldn't touch `| ` tables — priced, not proposed)."
- **Bears on this:** it weighs the pipe-space rule against wanting a spelling for a bare anonymous element. It also names the one guard extension that would not touch tables: `|` followed by end of line.

### 2026-08-07 11:29 — Joseph: records instead of a Markdown table when cells are big
- **Source:** history L18732 (session `5e114944`). Speaker: Joseph.
- **Words:** "In my mind I'm imagining a table with 5 columns-- \| theory features \| example usecase \| … \| (it probably will need to be a set of udon records instead of a markdown table since most of these will need lots of \`<br>\`s otherwise, but by way of illustration...)"
- **Bears on this:** Joseph states when a Markdown table stops fitting (multi-line cells) and records take over.

### 2026-08-08 — K10: sameline text is no longer committed prose
- **Source:** `v2/DECISIONS.md` L177 (K10, "jaw 2026-08-08").
- **Words:** "…an unquoted text value … ends at a space + guard-confirmed block-form marker (`:key`, `\|name`, …) … §2.2's commit-to-prose is rescoped to block text (sameline never commits to prose); guards still protect `3:1`, `:-)`, pipe-space tables, all unframed/unguarded text."
- **Bears on this:** in *sameline* text, a framed ` |word` now terminates the value and opens a child element. 0.9.1's commit-to-prose used to make it literal. Spaced tables are unaffected. See gap 9 below.

### 2026-08-09/10 — 0.10.0
- **Source:** `v2/spec-0.10.00/CORE.md`:
  - §3 L133: the guard, unchanged: "`| ` (pipe-space) is always literal, which preserves Markdown tables"
  - §6.4 L349: "A marker that **fails its guard** is not a terminator — it is ordinary content of the open value (… `| ` pipe-space …)"
  - §7.1 L482: "`#`, `<`, and pipe-space have no meaning there"
  - §6.2: labels may contain `|`, `:`, `-` (K12)
- **Bears on this:** this is the rule the neutral file cites.

### 2026-08-27 — 0.10.1-draft: "convention, kept"; pipe-space as a free-text idiom
- **Source:**
  - `v2/spec-0.10.01/CORE.md` L76
  - `NUANCE-AUDIT.md` L12: "`\| ` pipe-space always literal (Markdown tables) | **convention, kept** | frequency-weighted guard choice; surface, not theory"
  - `working-notes/spelling-grid.md` L23: "**The free text idiom.** Line-initial `| ` (pipe-space) *fails the element guard* — kept so Markdown tables survive — so `| like this` is already a text line, pipe included, no escape needed."
  - Agent-written. The draft was judged a misfire by Joseph on Sep 1.
- **Bears on this:** the rule is classed as convention rather than theory. Its second job, a line of text that begins with a visible pipe, is noted.

### 2026-09-01 — 0.10.1 fixture and the "0.10.0 + three changes" note
- **Source:**
  - `v2/spec-0.10.01/fixtures/comprehensive/material.yaml` L78–91 (`guard_pipe_space_literal`: `| a | b |` / `|---|---|` → one text)
  - `v2/JOSEPH-FOR-0.10.01-FIX.md` L57–66, which is **an agent's text** saved by Joseph: "Markdown *works* here, so does | and : and @ and 3:1." and `\| this line starts with a pipe` → `text "| this line starts with a pipe\n"`
- **Bears on this:** restates the spaced case and the `\|` escape. Nothing on tight rows.

### 2026-09-29 17:55 and 18:18 — Joseph: tables possibly open; "What about `|---|---....`?"
- **Source:** history L21297 and L21299 (this effort's session). Speaker: Joseph.
- **Words (17:55):** "It seems to me there are still some (*possibly*) still open things to look into, like better markdown-like tables, or making sure that sameline capture works…"
- **Words (18:18):** "I'm ok leaving that decision for tables for now. What about \`|---|---....\` ?"
- **Bears on this:** "better markdown-like tables" is deferred. The divider row is asked about by itself. I found no earlier message where Joseph discussed `|---` alone, except the 2025-12-24 proposal that listed ` |---|:---...`.

---

## Threads worth noticing

*My reading of the history, not a lean.*

1. **Pipe-space went from "marker" to "always literal", and the wish for it to be a marker keeps coming back.** In 2011, ` | ` marked text or data and delimited list items (`|list | one | two | three`). On 2025-12-23 Joseph wanted ` | ` as a delimiter "to make markdown table so that they would be potentially made into valid udon". The next day the rule became "pipe-space is literal, *because* of Markdown tables". On 2026-07-15 he wanted a framed ` | ` as a sameline separator, and the table rule was the reason given against it. The two uses compete for the same two characters. "Better markdown-like tables" in the delimiter sense would give pipe-space meaning inside some region, which is exactly what "always literal" currently rules out.

2. **The guard was designed against the spaced style; the tight style was never put to Joseph.** The Dec 24 decision named `| `, `|-`, `||`, `|:` and `'|`, and nothing about `|a|b|`. The whitelist replaced the blacklist "to cover unnoticed other uses of pipe". A tight header row is exactly such an unnoticed use, and it goes the other way: it *is* matched. The gap was first measured by an agent on 2026-07-28 and filed as a "narrowing". The neutral file is the first place it is posed as a question.

3. **Three meanings have been proposed for an adjacent `|a|b`:**
   - nesting (2011 DECIDED `|one|two|three ==> |{one |{two |{three}}}`)
   - path child (`|config|database`, 2026-01-14)
   - an element followed by text (what the old parser does; see gap 13)

   None of the current spec texts settles it (see the reading in the next section).

4. **There have been three families of "table construct", and Markdown is only one of them:**
   - **(a) Chained sameline elements** (`|table |tr |td …`, 2011 → mainline CORE → 0.9.1 TUTORIAL). It has a repeated real failure: cells nest (Joseph 2025-12-23, "td's inside td's").
   - **(b) One row element per line with inline-element cells** (`|tr |{td …} |{td …}`, comprehensive.udon), or single-line records that *look* tabular (Joseph 2026-07-29 and 2026-08-07, when cells are big).
   - **(c) Markdown tables as prose**, with `|{…}` inline elements still live in the cells (comprehensive.udon tier table, 2025-12-23 → now).

   Joseph's later remarks lean on (b) for data and (c) for presentation. That is an observation from the record, not a lean.

5. **The .desc grammar format is the one in-house table-shaped dialect, and it already has the neutral file's split:** `|name` becomes an element while `| ->` becomes text. Joseph's "table-scan property" and his column-aligned-continuation idea (`| a | b | c--1 |` / `        | c--2 |`) are the richest table-construct thinking I found. They sit in the descent context, not the core-grammar context.

6. **In practice, real tables in the corpus are spaced.** My grep of `~/src/arch`:
   - 0 tight `|word|` row starts in 268 `.udon` files, plus `.ud`, `.un` and `.desc`
   - 13 files with spaced rows (vivarium LEXICON and DECISIONS, theory segments, comprehensive examples)
   - `!:md:` wrappers are used in vivarium by at least one author who believed any bare row was unsafe

   The only real line-initial `|word|` shape I found in the record is math (`|E|`, `|delta|`), in the prose-collision study.

7. **Two different protections are both called "Markdown tables survive."** One is the line-initial guard. The other was 0.9.1's mid-line commit-to-prose, which K10 removed from *sameline* text. The history mostly treats them as one guarantee. K10 kept the first and narrowed the second.

---

## What the neutral file misses

*My additions, each with its source. "Reading" means my interpretation of the spec text.*

### 1. How the tight row `|Name|Role|` reads under the texts (the gap the neutral file left open)
- **What all texts agree on:**
  - `|N` passes the guard.
  - The bare name is `Name` and ends at `|`. 0.10.0 §5.2: "Any other character ends the bare name"; the same in 0.9.1 §5.2 and mainline CORE L308.
  - The trailing `|`, followed by end of line, fails the guard, so it is text.
  - The next row `|jw|dev|` begins at the same column, so it is a **sibling** of `Name`, not a child (Nesting Rule, 0.10.0 §2.1).
  - Divider and digit rows (`|---|`, `|:--|`, `|1|2|`) are text lines of the enclosing element.
- **What no text says** is what happens when a guard-passing `|` sits *immediately* after an element head with no space. Every sameline example in every suite is spaced (`|a |b |c`, `|element "here we go!" |child`). Three readings are available:
  - **Reading A — `$main` text: `element Name, $main "|Role|"`.**
    - 0.10.0 §6.10 / K9 make the sameline slot a typed value position. K9's list of values that announce themselves there (`"…" <…> […]` numbers `!{{…}}`) does **not** include `|name`.
    - §6.4 terminates an unquoted text value only at "a *space* followed by a guard-confirmed block-form marker".
    - So `|Role|` would be one unquoted text value.
    - This matches the old parser (evidence only): `core/generator/10-udon.elements.descent.udon` `:post_identity`, where any character other than space, newline or `\` goes to `/sameline_text`. It also matches the probe's "element named `a`".
  - **Reading B — sameline child: `element Name └ element Role, $main "|"`.**
    - 0.10.0 §2.2 puts Structure Position "along the Line Scan wherever the scan sits between values". Right after the head, no value has started.
    - §2.1: "Elements introduced later on the same line occupy their true columns."
    - 0.9.1 §2.2 likewise: the Line Scan runs "through elements and attributes … before any prose begins", and `|Role` is not a prose word.
    - This matches 2011 DECIDED (`|one|two|three` nests).
  - **Reading C — node value: `Name` with a `$main` whose value is the node `Role`.**
    - From 0.10.0 §6.4's general list ("block-form `|name` → node").
    - This is the least supported reading: K9 left `|name` off the sameline slot's list, and §2.1 calls sameline `|b` a child.
- **Whichever reading applies,** a tight table turns into alternating structure and text: the header and any letter-initial data rows become elements, while the divider and digit rows stay text. **Under reading B each row is also a chain of nested elements**, one per cell, exactly as Joseph complained about on 2025-12-23.

### 2. Tight cells that start with guard characters other than letters
These all pass the current `|` guard:
- `*` — `|**Name**|` (Markdown bold)
- `[` — `|[link](u)|`
- `.` — `|.5|`
- `'` — `|'quoted'|`
- `{` — `|{x}|`
- `!` — `|!x|`
- `?` and `+`

Which of these stay in the guard depends on [06](06-suffix-characters.md): if `? ! * +` stop being special, are they still guard characters? It also depends on [09](09-reserved-syntax.md), since `|!` sits next to reserved `!`. Bold header cells are common in tight GFM tables.

### 3. GFM tables without leading pipes
GFM allows `Name | Role` / `:--- | ---:`. Under **0.10.0**, a line-initial `:---|---:` passes the `:` guard: "followed by a non-space character — the label runs to the next space" (§3). Labels may contain `-`, `|` and `:` (§6.2). So it opens an attribute with no value, which is an Error with value Nil. Under **0.9.1** it is text: a key must start with `XID_Start` (§6.2). The neutral file only looks at pipe-led rows. The same `:---` shape was measured being "colon-eaten" by the old parser on 2026-07-11.

### 4. Tables deeper than the content base are already literal
0.10.0 §2.1 ("Exception — text interior") and §7.2 rule 5: "A line deeper than an established base is *inside the text*: markers there are literal." So

```udon
|doc
  Intro.
    |a|b|
```

makes `|a|b|` text with no new rule, at the cost of extra indentation that becomes part of the text. This is an existing escape the neutral file doesn't list next to `\|`.

### 5. Escapes, then and now
- A line-initial attached `\|a|b|` makes the line text (0.10.0 §4, "Attached `\X`"). Only the letter-initial rows need it.
- The December 2025 `'|` escape was used for exactly this (comprehensive.udon, commit `b96cad0`).

### 6. Inline elements inside table cells
The tier table (`| Free | |{n 60} |`) relies on rows being text, so that `|{…}` is still recognized as an inline element in the cells. Alternative **C** (fence or box) would make those cells verbatim and lose that. The only existing box spelling in live use, `!:md:`, is reserved in lite. So C in lite means a triple-backtick fence (see [11](11-code-blocks.md)).

### 7. Sameline pipes changed with K10
In *sameline* text a framed ` |word` now terminates the value and opens a child element:
- `|p the set |E| is finite` reads as `$main "the set"` + child `E`, …
- `|note see | a | b |` is still fine (pipe-space).

Under 0.9.1 the first sameline word committed the line to prose and the pipes were literal. The neutral file's "`a|b` mid-token in prose is text" doesn't cover this case.

### 8. Cost of alternative D (reserve `|word|`)
Line-initial math `|E|`, `|delta|` (prose-collision study) would become "reserved: not in lite" refusals, as would `|config|database`-style paths quoted in text. 2011's `|one|two|three` shows the shape once had a structural meaning. The type-algebra note (2026-07-30) names a *different* guard extension that leaves tables alone: `|` before end of line.

### 9. Alternative B and the lookahead law
0.10.0 §2.3: "Every guard resolves within a few characters, single-level, with no unbounded backtracking … new syntax MUST stay inside the bound." A first-and-last-character-is-`|` test needs the end of the line. The 2011 rule ("Once data text has started on a line, pipes … literal") and 0.9.1's commit-to-prose were both states that move forward only. Neither needed lookahead to the end of the line.

### 10. Table-construct candidates the history holds, which the neutral file's "left for later" line doesn't list
- ` | ` as a real delimiter (2011; Joseph 2025-12-23)
- column-aligned chained elements (`|table |tr |td`, still taught in the TUTORIAL and in mainline CORE)
- row elements with inline cells
- single-line records that read as a table (Joseph 2026-07-29, 2026-08-07)
- column-position continuation rows (Joseph 2026-07-11, `.desc`)
- a Layer-2 `doc`-schema table vocabulary (MARKDOWN.md D4b)

The neutral file is right that none is decided.

### 11. Pipe-space has a second job
`| like this` is a text line that shows its leading pipe (0.10.01 spelling-grid note 2). The 2026-07-08 review also found real `| healing` rows relying on it in the ASF process map. Any change to pipe-space affects more than tables.

### 12. Joseph's `|---|---....` question
The only earlier Joseph message that singles out divider rows is the 2025-12-24 proposal (` |---|:---...` preserved as-is). Under every spec text since then, `|-` and `|:` fail the guard, so divider rows are text. What his 2026-09-29 question is asking beyond that isn't in the record I searched: whether the divider row is safe, or whether it could *signal* a table.

### 13. Evidence only: the old parser
Per its grammar (`:post_identity` → `/sameline_text`), the old parser gives `|a|b|` → element `a` with sameline text `|b|`. This is consistent with the 2026-07-28 probe. It is never an oracle of intent.
