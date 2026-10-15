# How familiar current LLMs are with each markdown dialect

*Researcher notes, 2026-10-14. Probes were run on this machine on the same day. Raw prompts, every model output, and reference renderings are in [`llm_familiarity_probes/`](llm_familiarity_probes/). Links below of the form `probes/…` point into that directory.*

## Q0. How were the probes run, and how far can they be trusted?

### Takeaway
Four probe prompts went to Claude Haiku, Sonnet and Opus, Grok 4.7, and gpt-oss-120b. Each ran once (n=1 per model per prompt), with no tools and with personal context removed. Gemini and current GPT models could not be reached today, so the "frontier" sample is Anthropic plus xAI, with gpt-oss-120b as an open-weights stand-in for OpenAI. I graded against primary sources, and for Djot by actually rendering the models' output.

### Cited Findings
- **Prompts.** A asks the model to *write* distinctive constructs in each dialect and answer spec-fact questions, then rate its own confidence from 1 to 5 — [probes/promptA.txt](llm_familiarity_probes/promptA.txt). B gives nine unlabeled snippets and asks the model to *name* the dialect of each — [probes/promptB.txt](llm_familiarity_probes/promptB.txt). C asks for a short note with a callout, footnote, definition, table, highlight and an internal link, with *no dialect named* — [probes/promptC.txt](llm_familiarity_probes/promptC.txt). D gives ten snippets whose meaning depends on the dialect and asks for the *single most likely* rendering. D was Joseph's idea, built from the syntax researcher's collision list — [probes/promptD.txt](llm_familiarity_probes/promptD.txt), [comparison.md Q3 inferences](comparison.md).
- **Claude isolation.** I ran `claude -p --model {haiku,sonnet,opus} --tools "" --setting-sources "" --system-prompt "You are a helpful assistant."` from a scratch directory. In a check run, Haiku reported no CLAUDE.md or memory content in its context. The only leaks it reported were the cwd path (which contains "udon") and the user's email — [probes/outputs/](llm_familiarity_probes/outputs/).
- **Grok contamination, found and fixed.** The first Grok runs used `--system-prompt-override`, but the session record shows Grok *also* injected `~/.claude/Claude.md`, the global CLAUDE.md, as a system-reminder message. That file uses wikilinks and `> [!note]` callouts throughout (`~/.grok/sessions/…/prompt_context.json`, `agents_md_files` field). I re-ran every Grok probe with `HOME` pointed at an isolated directory holding only Grok's auth file, and a context check then came back clean. The contaminated outputs are kept, labeled `CONTAMINATED-*` — [probes/outputs/](llm_familiarity_probes/outputs/).
- **What a clean context changes.** On prompt C, the contaminated Grok picked Obsidian-flavored Markdown with `[[wikilinks]]`. The clean Grok picked **AsciiDoc** — [CONTAMINATED-grok-C](llm_familiarity_probes/outputs/CONTAMINATED-grok-C.txt) vs [grokclean-C](llm_familiarity_probes/outputs/grokclean-C.txt). This is n=1 and could be sampling variance, but the difference runs in the direction the injected wikilinks and callouts would push. Clean and contaminated Grok made the same Djot errors on prompt A.
- **Unavailable models.** `agy` (Antigravity) returned "Individual quota reached… Resets in 46h49m" for every Gemini 3.8 Flash variant. The `gemini` CLI returned "This client is no longer supported for Gemini Code Assist for individuals." Codex (gpt-5.6-terra) returned "You've hit your usage limit… try again at Nov 2nd, 2026." The local ollama models fail because their blob files are missing — [probes/outputs/FAILED-*](llm_familiarity_probes/outputs/).
- **Ground truth.** Djot answers were rendered with the reference implementation djot.js 0.3.2. CommonMark answers were checked with commonmark.js 0.31.2. Prompt D snippets were rendered by commonmark.js, `pandoc -f gfm`, `pandoc -f markdown` (pandoc 3.11) and djot.js — [probes/reference_renderings/](llm_familiarity_probes/reference_renderings/), [djot syntax reference](https://github.com/jgm/djot/blob/main/doc/syntax.md), [CommonMark spec](https://spec.commonmark.org/).

### Inferences
- These probes test recall of distinctive constructs and spec facts. They do not test fluency over long documents or holding to a minority dialect across many turns, which is where "dialect bleed" would most likely show up. Treat the results as a lower bound on errors, not a measurement of them.
- Any harness that reads `~/.claude/` (Grok does, through its CLAUDE.md compatibility) will color dialect answers on this machine. Future probes here need the `HOME` isolation or something equivalent.

### Gaps
- No Gemini or current GPT model was probed. The Gemini quota resets in about 47 hours (around 2026-10-16), and Codex on 2026-11-02. gpt-oss-120b is an open-weights model, not OpenAI's frontier.
- One sample per cell. I did not control temperature, so I could not measure run-to-run variance.

## Q1. How well do current frontier LLMs know each dialect?

### Takeaway
The Claude models and Grok know **all six dialects well enough to write and recognize their distinctive constructs**, including Djot, and Djot is the dialect where they separate. Sonnet and Opus wrote a Djot document in which all 16 requested features render correctly in djot.js. Haiku got 15 of 16. Grok got about 11 of 16, and every miss was a Pandoc construct carried into Djot. gpt-oss-120b essentially does not know Djot but rated itself 4 of 5. By name, all of them handled CommonMark, GFM, Obsidian, Pandoc, MDX, MyST and AsciiDoc mostly correctly, with gpt-oss as the main exception.

### Cited Findings
**Djot, writing (prompt A, 16 features rendered through djot.js)**
- **Claude Sonnet and Opus: 16/16** — emphasis, strong, highlight, insert, delete, superscript, subscript, span `.kbd`, div `warning`, footnote, inline math, definition list, table with caption, hard break, heading id set with a `{#id}` block attribute, and raw HTML block. Both converted `**bold** and *italic* and ~~gone~~` correctly to `*bold* and _italic_ and {-gone-}` — [claude-sonnet-A](llm_familiarity_probes/outputs/claude-sonnet-A.txt), [claude-opus-A](llm_familiarity_probes/outputs/claude-opus-A.txt), [renderings](llm_familiarity_probes/reference_renderings/).
- **Claude Haiku: 15/16.** The only miss was putting the `^ caption` line *before* the table, where the spec requires it after ("The caption can come directly after the table") — [claude-haiku-A](llm_familiarity_probes/outputs/claude-haiku-A.txt), [djot syntax §Pipe table](https://github.com/jgm/djot/blob/main/doc/syntax.md).
- **Grok 4.7, clean run: about 11/16. Every miss is a Pandoc construct inside Djot:** `# Heading {#id}` (djot.js: "Ignoring unattached attribute"), `$x^2$` instead of `` $`x^2` ``, Pandoc-style `udon` / `: a noodle` definition list, `::: {.warning}` (a Djot div takes only a bare class name), and `Table: caption`. It flagged the caption as unsure. Its conversion answer was correct — [grokclean-A](llm_familiarity_probes/outputs/grokclean-A.txt), [djot syntax §Div, §Math, §Definition list item](https://github.com/jgm/djot/blob/main/doc/syntax.md).
- **gpt-oss-120b: about 5/16, confidently wrong.** It claimed "Djot uses the same syntax" as CommonMark for `**bold** *italic* ~~gone~~`. It wrote `*emphasis*` (strong in Djot), `==highlight==` and `++inserted++`, named a Rust implementation as "primary", and invented version numbers (0.2.1 / 0.2.0). It rated its Djot confidence 4/5 — [agy-gptoss120b-A](llm_familiarity_probes/outputs/agy-gptoss120b-A.txt).
- **Djot implementation facts.** The repo lists seven implementations: djot.js (JS/TS), djot.lua (the original reference implementation, which may fall behind), jotdown (Rust), djoths (Haskell) and others. The latest npm release is `@djot/djot` 0.3.2 (2024-12-19). All three Claude models named djot.js and djot.lua correctly and put the version around 0.3.x. Clean Grok said pandoc uses djot.lua; pandoc's changelog shows it depends on the Haskell `djot` package — [djot README §Implementations](https://github.com/jgm/djot#implementations), [npm @djot/djot](https://registry.npmjs.org/@djot/djot), [pandoc changelog](https://github.com/jgm/pandoc/blob/main/changelog.md).

**Djot, recognition (prompt B, snippets 1 and 8)**
- All three Claude models and Grok named both Djot snippets correctly and explained `{=x=}`, `[..]{.kbd}`, `::: warning`, `: Term` definitions, `` $`…` `` math and `{+ +}`/`{- -}`. Opus also noted that GitLab Flavored Markdown shares the math and `{+ +}`/`{- -}` forms but lacks `: Term` definition lists. gpt-oss called snippet 1 "Pandoc‑flavored Markdown" and snippet 8 "GitHub‑flavored Markdown" — [probes/outputs/*-B.txt](llm_familiarity_probes/outputs/).

**Obsidian**
- All three Claude models and Grok wrote everything correctly: `[[Alpha|first]]`, `[[Alpha#Setup]]`, `[[Alpha#^abc123]]` with a trailing ` ^abc123` declaration, `![[Alpha]]`, `![[img.png|300]]`, `> [!warning]- Careful` (the `-` means folded), `==x==`, `%%x%%`, `#parent/child`, and YAML `aliases`/`tags`. gpt-oss wrote `> [!WARNING]+`, which means expanded, the opposite of what was asked, and put the title on a separate line — [probes/outputs/*-A.txt](llm_familiarity_probes/outputs/).
- In recognition, all models including gpt-oss identified the Obsidian snippet — [probes/outputs/*-B.txt](llm_familiarity_probes/outputs/).

**GFM**
- Every model listed the spec's extensions (tables, task lists, strikethrough, extended autolinks, disallowed raw HTML) and all five alert types. Every model also said footnotes and math are github.com features outside the spec. GitHub's docs confirm the five types ("Five types of alerts are available": NOTE, TIP, IMPORTANT, WARNING, CAUTION) — [GitHub Docs, basic writing and formatting syntax §Alerts](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax#alerts).

**CommonMark**
- All three Claude models and Grok answered every spec-fact question correctly: 0.31.2 from January 2024 (the spec page lists 2024-01-28); seven kinds of HTML block; an ordered list interrupts a paragraph only if it starts at 1; `foo_bar_baz` is not emphasized; `*foo**bar**baz*` gives `<em>foo<strong>bar</strong>baz</em>`. I verified the last three with commonmark.js. gpt-oss got the date wrong (2024-03-13), garbled the list of HTML block kinds, and got the interruption rule wrong — [CommonMark spec index](https://spec.commonmark.org/), [reference check](llm_familiarity_probes/reference_renderings/promptD-reference.txt).

**Pandoc Markdown**
- All three Claude models and Grok wrote correct citations (`[@k, p. 33]`, `@k [p. 33]`, `[-@k]`), inline notes, fenced divs, spans, line blocks, `(@)` example lists, raw LaTeX and `%` title blocks. They named the four table types and the `+ext`/`-ext` syntax. gpt-oss got the suppress-author citation (`[@doe2020, -@doe2020]`), the author-in-text form, example lists (it used a fenced div) and the div id (written as `.my-id`) wrong, and labeled the `%` title block "YAML metadata" — [probes/outputs/*-A.txt](llm_familiarity_probes/outputs/).

**MDX**
- All three Claude models and Grok said MDX 3 is the latest major. MDX 3.0.0 was released 2023-10-24 (current release 3.1.1, 2025-08-29). Sonnet and Opus gave October 2023; Haiku and Grok said "2024" or "late 2023 or early 2024". Between them they listed the CommonMark breakages that MDX documents (indented code, autolinks, HTML comments replaced by `{/* */}`, unescaped `<` and `{`), though Haiku left out indented code and Grok was unsure about autolinks. All four said frontmatter needs `remark-frontmatter`. MDX's docs say nonstandard features "such as GFM, frontmatter, math" are enabled with plugins — [mdx releases](https://github.com/mdx-js/mdx/releases), [What is MDX](https://mdxjs.com/docs/what-is-mdx/).
- gpt-oss said the latest major is "MDX 2", that HTML comments are "stripped" (MDX does not support them), and that `// comment` works, which is wrong — [agy-gptoss120b-A](llm_familiarity_probes/outputs/agy-gptoss120b-A.txt).

**Others (MyST, Markdoc, AsciiDoc, Quarto)**
- Claude and Grok wrote valid MyST directives and roles and valid Markdoc `{% tag attr="…" %}…{% /tag %}`, and all said Quarto uses Pandoc Markdown. On recognition, Haiku answered "Unsure" for the Markdoc snippet ("probably a custom shortcode"). Sonnet, Opus and Grok named Markdoc. gpt-oss called it "Hugo short‑code Markdown" and called MyST a "fenced‑info‑string". Every model recognized AsciiDoc — [probes/outputs/*-B.txt](llm_familiarity_probes/outputs/).

### Inferences
- For Claude-class and Grok-class models, knowing a dialect is no longer the bottleneck, even for small dialects like Djot (about 8K `.dj` files on GitHub; see Q4). The bottleneck is **interference from a larger neighbor**: Grok's Djot errors are all Pandoc forms, and Pandoc's surface overlaps Djot's in exactly those places (divs, spans, attributes, math, definition lists). A dialect is safest for LLM authoring when its constructs don't *look like* a bigger dialect's constructs for something else.
- Smaller or older models fall back to "it's just Markdown". gpt-oss turned Djot into CommonMark and Obsidian's fold marker into its opposite. Any design that relies on models knowing a non-CommonMark dialect should expect the less capable models in a pipeline to normalize toward CommonMark/GFM.

### Gaps
- No Gemini or current GPT data (see Q0). The gpt-oss results should not be read as "OpenAI frontier".
- Djot recall was tested once, on a feature-list prompt that named Djot's author. That cue may help. A cold "write me a Djot document" might do worse.

## Q2. What do models default to when the dialect is unspecified or ambiguous?

### Takeaway
No model has a single-dialect default. Given ambiguous snippets, every model fell back to a **union of the most popular readings**: CommonMark for the core (emphasis, lists, raw HTML), GFM for autolinks and strikethrough, Pandoc for sub/superscript, inline footnotes and definition lists, and Obsidian for wikilinks and `==highlight==`. No model ever chose the Djot reading. Asked to pick a format freely for a notes-style document, Claude and the contaminated Grok picked Obsidian-flavored Markdown or a hybrid; clean Grok picked AsciiDoc.

### Cited Findings
- **Prompt D, ten ambiguous snippets: first-choice readings** — [probes/outputs/*-D.txt](llm_familiarity_probes/outputs/); reference renderings in [promptD-reference.txt](llm_familiarity_probes/reference_renderings/promptD-reference.txt):
  - `H~2~O and ~~gone~~`: Haiku, Sonnet, Opus and Grok gave `H<sub>2</sub>O … <del>gone</del>`, the **Pandoc** reading. Haiku, Sonnet and Opus noted that GFM reads single `~` as strikethrough. Grok said GFM leaves `~2~` literal, which matches pandoc's gfm reader; the syntax notes cite the live GFM spec as striking single tildes, so the references disagree here. gpt-oss chose GFM. Reference: pandoc markdown gives sub plus del; djot.js gives sub plus nested subscripts for `~~gone~~`; `pandoc -f gfm` leaves `~2~` literal.
  - `[[Setup|install guide]]`: every model read target-then-label (Obsidian/MediaWiki order). Opus and Grok noted that Gollum and TiddlyWiki reverse it. CommonMark, GFM, pandoc markdown and djot.js all leave it literal.
  - `{% this is important %}`: Haiku, Opus, Grok and gpt-oss left it literal. Sonnet removed it as a template directive. **No model mentioned that Djot treats it as a comment** (djot.js renders `Note  here.`).
  - `*x*` and `_y_`: every model gave `<em>`/`<em>`, the **CommonMark** reading. None mentioned that Djot makes `*x*` strong, though Opus and Grok volunteered the AsciiDoc and Org readings.
  - `<div>` / `**x**` / `</div>`: Claude and Grok chose **CommonMark**, where the asterisks stay literal in the HTML block, and noted that Pandoc would bold them. gpt-oss bolded it. Reference: commonmark.js and pandoc gfm leave it literal; pandoc markdown gives `<strong>`.
  - `x^2^ and a note^[like this]`: Claude and Grok chose **Pandoc** (sup plus footnote). gpt-oss made the note a second superscript. djot.js renders `x<sup>2</sup>` and leaves `^[like this]` literal.
  - `==marked== and {+added+}`: Haiku, Sonnet, Opus and gpt-oss rendered both as `<mark>`/`<ins>`. Haiku attributed `{+ +}` to CriticMarkup, and Sonnet called it a "loose variant" of CriticMarkup's `{++ ++}`. Opus attributed it to GitLab inline diff. Grok rendered `<mark>` and left `{+added+}` as text. **No model named Djot for `{+ +}`.** djot.js gives `==marked==` literal and `<ins>added</ins>`.
  - `Groceries:` then `- milk`: every model chose **CommonMark** (the list interrupts the paragraph). Opus correctly noted that Pandoc needs a blank line; pandoc markdown and djot.js both give one paragraph.
  - `Visit https://example.com`: every model that answered chose the **GFM** autolink. gpt-oss's output stops partway through item 9.
  - `term` / `: its definition`: Claude and Grok chose a definition list (**Pandoc** / PHP Markdown Extra). CommonMark and djot.js give a paragraph.
- **Prompt C, free choice.** Haiku and Opus chose "Obsidian-flavored Markdown" (`> [!warning] Title`, `==x==`, `[[wikilink]]`). Sonnet mixed a GitHub alert, `==highlight==`, a Pandoc/Extra `: definition`, and a relative `.md` link, and called the result "Markdown". gpt-oss called its output GFM "because it natively supports … inline highlights", but GFM has no highlight syntax. Clean Grok chose AsciiDoc (`WARNING:`, `footnote:[]`, `term::`, `#highlight#`, `xref:`). No model chose Djot or Pandoc Markdown, even though both support every requested feature — [probes/outputs/*-C.txt](llm_familiarity_probes/outputs/).
- **Prompt C was biased:** it asked for a link to a document "in the same notes collection", which points toward Obsidian. That bias is mine, and it likely inflates the Obsidian picks.
- **Independent evidence of the GFM-centered default:** LangChain's frontend guide recommends enabling GFM because its features "are commonly used by LLMs". It also recommends `breaks: true` because "LLMs often use single newlines for visual separation" — [LangChain docs, markdown messages](https://docs.langchain.com/oss/javascript/langchain/frontend/markdown-messages).

### Inferences
- The effective default dialect of current LLMs is **an unnamed "maximal Markdown"**: CommonMark/GFM where they define a reading, plus the most popular extension reading for everything else. That is close to what Sonnet produced in prompt C: valid in no single dialect, readable in all of them. For a format that wants LLM writers, this is the prior any design works against or with.
- Djot's readings never win a tie. Where Djot gives a glyph a different meaning (`*x*` as strong, `{% %}` as a comment, `^` for superscript but not footnotes), the models' first reading is the non-Djot one, even though they know Djot when it is named. So a dialect being **named in context** (file extension, header, system prompt) matters a lot, and its *collisions* with Markdown will be misread whenever that signal is missing.
- `{+ +}` being misattributed to CriticMarkup shows the models link that glyph family to "markup for edits" without fixing it to a dialect, another sign of shallow, glyph-level association for minority syntax.

### Gaps
- No Gemini or GPT-frontier default readings.
- I did not test whether a file extension alone (`.dj` vs `.md`) is enough to switch a model into the right dialect. That is the cheapest next probe and probably the most decision-relevant one.

## Q3. Are the models' self-assessments calibrated?

### Takeaway
Calibration varies by model: the Claude models underrate themselves on Djot, gpt-oss overrates itself badly, and Grok's self-ratings roughly match its results. A model's own confidence report is not a usable proxy for dialect competence.

### Cited Findings
- **Djot self-ratings vs results:** Haiku 3 vs 15/16. Sonnet 3 vs 16/16. Opus 3 vs 16/16 ("syntax mostly solid; version details weak"). Grok 3 vs about 11/16. gpt-oss 4 vs about 5/16 with false claims — [probes/outputs/*-A.txt](llm_familiarity_probes/outputs/).
- **Other notable ratings:** Sonnet gave 5 to Obsidian, GFM, CommonMark and Pandoc, and 4 to Typst. Haiku gave Typst 2. gpt-oss gave 5 to Obsidian, GFM, CommonMark and Pandoc while making errors in each — [probes/outputs/*-A.txt](llm_familiarity_probes/outputs/).
- Claude's and Grok's "unsure" marks clustered where they really were weak: Djot caption syntax and version, MDX release dates, and Grok on MDX autolinks. But Haiku's one Djot error, caption placement, was *not* flagged. gpt-oss answered "unsure" only about version recency — [probes/outputs/*-A.txt](llm_familiarity_probes/outputs/).

### Inferences
- When a model hedges with "unsure" on a specific construct, that is informative (Claude and Grok mostly hedged where they were weak), but the absence of a hedge is not a guarantee. Its 1–5 dialect-level rating is not informative.

### Gaps
- No self-ratings for Typst, AsciiDoc, rST or Org were checked against actual performance. Those dialects were rated but not tested.

## Q4. What published or online evidence exists on LLM familiarity with markdown dialects?

### Takeaway
I found **no published benchmark that measures LLM competence per markdown dialect**. The adjacent work treats "Markdown" as a single format. The best available proxy for training exposure is file counts: GitHub code search puts `.md` at roughly 250M files against about 8K `.dj` files. Practitioners still find it worth teaching agents Obsidian syntax explicitly: Steph Ango's (kepano's) Obsidian agent-skills repo has about 49.5K stars.

### Cited Findings
- **MDEval** (WWW 2025) measures "Markdown Awareness" generically over 20K instances in English and Chinese and names no dialect. It reports that fine-tuning open models brings them to GPT‑4o level — [arXiv 2501.15000](https://arxiv.org/abs/2501.15000).
- **StructEval** (TMLR 01/2026) covers 18–21 structured formats (JSON, YAML, CSV, HTML, React, SVG, TOML…). It reports o1-mini averaging 75.58, with open models about 10 points behind. It does not break markdown down by dialect — [arXiv 2505.20139](https://arxiv.org/abs/2505.20139).
- **"The Last Fingerprint"** (2026-03) argues that the em dash is "markdown leaking into prose". Across 12 models from 5 providers, overt markdown (headers, bullets, bold) disappears when the model is told to avoid markdown, but em dashes persist. Llama is the exception, and base models show the tendency before RLHF. This is about markdown habit generally, not dialect — [arXiv 2603.27006](https://arxiv.org/abs/2603.27006).
- **"The Announcement Carries the Cue"** (2026-08) surveys notation density across 13 pretraining corpora. It gives no per-dialect figures — [arXiv 2608.09093](https://arxiv.org/abs/2608.09093).
- **Exposure proxy: GitHub code-search `total_count` by extension, 2026-10-14** (approximate; these are indexed files, not training tokens): `.md` 249,561,088; `.rst` 8,306,688; `.mdx` 5,308,416; `.adoc` 1,501,184; `.qmd` 782,336; `.dj` 8,016; `.djot` 1,094. Retrieved with `gh api search/code?q=extension:X`. The `.md` count does not separate GFM, Obsidian or Pandoc content, and `.dj` may include files that are not Djot — [GitHub code search API](https://docs.github.com/en/rest/search/search#search-code).
- **Obsidian agent skills:** `kepano/obsidian-skills` was created 2026-01-02 and had 49,546 stars on 2026-10-14. It "teach[es] your agent to use Obsidian CLI and open formats including Markdown, Bases, JSON Canvas". Its `obsidian-markdown` skill covers "only Obsidian-specific extensions — standard Markdown … is assumed knowledge" — [github.com/kepano/obsidian-skills](https://github.com/kepano/obsidian-skills), [obsidian-markdown SKILL.md](https://github.com/kepano/obsidian-skills/blob/main/skills/obsidian-markdown/SKILL.md), [overview by dsebastien](https://www.dsebastien.net/obsidian-ai-skills-by-steph-ango/).
- **Djot:** web searches for Djot plus LLM familiarity turned up nothing relevant. A search of the jgm/djot issue tracker for "LLM" found two issues (#32 Citations, #403 a security-docs request), neither about LLM familiarity — [jgm/djot issues](https://github.com/jgm/djot/issues).
- **MDX and LLMs:** I found no source documenting LLM-specific MDX failure rates. The documented hazard is structural: MDX's own docs say unescaped `<` and `{` "have to be escaped" — [What is MDX](https://mdxjs.com/docs/what-is-mdx/).

### Inferences
- The probes contradict the naive exposure prediction: Djot appears about 30,000× less often than `.md` by file count, yet the strong models write it nearly perfectly. Djot's spec is small and regular and was written by the author of CommonMark and pandoc, and models seem to learn it from its documentation rather than from a large corpus. Exposure looks like it matters most for *defaults and tie-breaking* (Q2), not for *competence when named*.
- The popularity of the Obsidian skills repo shows that people perceive a gap, but my probes found the frontier models already competent at core Obsidian syntax. The skills likely add the most for less common constructs (Bases, JSON Canvas, properties types) and for weaker models.

### Gaps
- I found no corpus-level counts of dialect usage *within* `.md` files (for example, how many contain `[[wikilinks]]` or `> [!NOTE]`). The syntax/popularity researchers may have usage data that bears on this.
- I found no vendor statements (Anthropic, OpenAI, Google, xAI) on which markdown dialect their chat surfaces render or train toward. I didn't specifically search vendor docs beyond the LangChain guide, so this gap is partly unsearched rather than confirmed empty.
