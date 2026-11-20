# Markdown dialects — usage, popularity, and trend (CommonMark, GFM, Obsidian, Pandoc, MDX, Djot, plus other sizable players)

*Researcher notes, gathered 2026-10-14. Most numbers here are **measured directly** from registry and platform APIs (npm, PyPI, crates.io, CRAN, GitHub REST, Stack Exchange, VS Code Marketplace) on that date. Each one cites the endpoint it came from, so it can be re-run. The rest come from web sources and are cited inline. Raw pulls are in the session scratchpad (`.../scratchpad/mdpop/`) and are not kept.*

**Method caveat for the whole file:** these dialects don't map one-to-one onto packages. Most parsers implement **CommonMark plus GFM extensions**, so "GFM usage" and "CommonMark usage" can't be cleanly separated at the library level. Obsidian Flavored Markdown has no parser package or file extension of its own, so its proxy is the Obsidian user base. Pandoc Markdown's proxy is pandoc, Quarto, and R Markdown. Download counts measure installs, which include CI runs and transitive dependencies, not people. **npm traffic overall grew about 2–4× between Sep 2025 and Sep 2026**, so raw growth figures for 2026 need normalizing (see Q2).

---

## Q1. How big is each dialect in absolute terms right now?

### Takeaway
GFM-flavored CommonMark is the de facto Markdown. It is the default in the largest parsers on every major registry, it runs on GitHub, GitLab, Reddit, Stack Exchange and Discourse, and `.md` files outnumber every alternative on GitHub by one to two orders of magnitude. MDX is a real but bounded niche (about 2% as many files as `.md`), confined to the React/JS docs world. Pandoc-family Markdown (pandoc, Quarto, R Markdown) has a large, durable base in academic, scientific and data publishing. Obsidian is a large end-user population (about 1.5M users reported) that mostly sits off GitHub. **Djot is tiny on every measure**, roughly three to four orders of magnitude below the mainstream.

### Cited Findings

**GitHub file counts by extension** (GitHub code search `total_count`. These are estimates from GitHub's legacy code-search index, so read them as orders of magnitude.)
- `.md` ≈ 272.6M files; `.markdown` ≈ 1.22M — [GitHub code search API, `q=extension:md`](https://api.github.com/search/code?q=extension:md)
- `.mdx` ≈ 5.54M (about 2.0% of `.md`) — [GitHub code search API, `q=extension:mdx`](https://api.github.com/search/code?q=extension:mdx)
- `.Rmd` ≈ 1.05M; `.qmd` (Quarto) ≈ 848k — [GitHub code search API, `q=extension:qmd`](https://api.github.com/search/code?q=extension:qmd)
- `.djot` ≈ 1,186; `.dj` ≈ 9,056 (`.dj` is ambiguous with other uses, so treat it as an upper bound) — [GitHub code search API, `q=extension:djot`](https://api.github.com/search/code?q=extension:djot)
- For comparison: `.rst` ≈ 8.72M, `.adoc` (AsciiDoc) ≈ 1.54M, `.org` ≈ 645k, `.mdoc` (Markdoc) ≈ 30k — [GitHub code search API](https://api.github.com/search/code?q=extension:adoc)
- GitHub repository topics: `markdown` 42,017; `obsidian` 11,095 (+ `obsidian-plugin` 4,363); `mdx` 3,211; `quarto` 2,379; `pandoc` 1,814; `commonmark` 461; `gfm` 388; `myst` 107; `markdoc` 70; `djot` 42 — [GitHub repo search API, `q=topic:djot`](https://api.github.com/search/repositories?q=topic:djot)

**npm monthly downloads, September 2026** (JS ecosystem)
- `marked` (GFM-by-default) 318.4M; `micromark` (CommonMark core of remark/MDX) 239.7M; `remark-parse` 214.7M; `remark-gfm` 166.3M; `react-markdown` 143.5M; `markdown-it` (CommonMark plus plugins) 119.7M — [npm downloads API](https://api.npmjs.org/downloads/point/2026-09-01:2026-09-30/marked,micromark,remark-parse,remark-gfm,react-markdown,markdown-it)
- MDX: `@mdx-js/react` 86.4M; `@mdx-js/mdx` 46.1M; `@mdx-js/loader` 8.1M; `@next/mdx` 6.7M; `next-mdx-remote` 4.4M — [npm downloads API](https://api.npmjs.org/downloads/point/2026-09-01:2026-09-30/@mdx-js/mdx)
- `commonmark` (the commonmark.js reference implementation) 3.13M — [npm downloads API](https://api.npmjs.org/downloads/point/2026-09-01:2026-09-30/commonmark)
- `@markdoc/markdoc` (Stripe's Markdoc) 2.34M — [npm downloads API](https://api.npmjs.org/downloads/point/2026-09-01:2026-09-30/@markdoc/markdoc)
- **`@djot/djot` (the official djot.js) 3,955/month** — [npm downloads API](https://api.npmjs.org/downloads/point/2026-09-01:2026-09-30/@djot/djot). That is about 1/80,000 of `marked`.
- MyST: `mystmd` 17,215; `markdown-it-myst` 45,806 — [npm downloads API](https://api.npmjs.org/downloads/point/2026-09-01:2026-09-30/mystmd,markdown-it-myst)

**PyPI downloads, last 30 days**
- `markdown-it-py` 448.5M (inflated: it is a hard dependency of `rich`, which declares `markdown-it-py>=2.2.0` — [PyPI rich metadata](https://pypi.org/pypi/rich/json)) — [pypistats](https://pypistats.org/api/packages/markdown-it-py/recent)
- `markdown` (Python-Markdown, Gruber-lineage plus extensions; a dependency of MkDocs, which declares `markdown>=3.3.6` — [PyPI mkdocs metadata](https://pypi.org/pypi/mkdocs/json)) 90.9M — [pypistats](https://pypistats.org/api/packages/markdown/recent)
- `mistune` 60.9M (a dependency of `nbconvert`, which declares `mistune<4,>=2.0.3` — [PyPI nbconvert metadata](https://pypi.org/pypi/nbconvert/json)) — [pypistats](https://pypistats.org/api/packages/mistune/recent)
- `mkdocs` 13.1M, `mkdocs-material` 11.7M; `myst-parser` 5.18M; `pypandoc` 4.14M + `pypandoc-binary` 3.14M; `commonmark` 3.31M; `jupyter-book` 218k; **`djot` 46** — [pypistats](https://pypistats.org/api/packages/djot/recent)

**crates.io (Rust), all-time / last 90 days**
- `pulldown-cmark` (CommonMark with optional GFM extensions; its use by rustdoc/mdBook is from training knowledge and wasn't re-verified this session) 175.5M / 55.9M — [crates.io API](https://crates.io/api/v1/crates/pulldown-cmark)
- `markdown` (markdown-rs; MDX support per training knowledge, not re-verified) 11.8M / 3.93M; `comrak` (GFM-compatible) 8.94M / 2.79M — [crates.io API](https://crates.io/api/v1/crates/comrak)
- **`jotdown` (Rust djot) 367k / 193k**, roughly 0.35% of pulldown-cmark's recent downloads; `djot` crate 3.5k / 57 — [crates.io API](https://crates.io/api/v1/crates/jotdown)

**GitHub stars (snapshot 2026-10-14; star counts measure attention, not usage)**
- pandoc 46,587; marked 37,238; obsidian-releases 22,246; markdown-it 21,979; mdx-js/mdx 19,825; react-markdown 15,919; remark 9,019; markdoc 8,506; quarto-cli 6,087; vercel/streamdown 5,698 (created 2025-08-15); commonmark-spec 5,151; goldmark 5,058; Python-Markdown 4,251; rmarkdown 3,064; pulldown-cmark 2,739; micromark 2,233; **jgm/djot 2,044 (created 2022-07-11; last push 2026-07-01)**; cmark 2,039; kramdown 1,782; comrak 1,718; cmark-gfm 1,134; MyST-Parser 895; MultiMarkdown-6 679; mystmd 526; jotdown 232; djot.js 207; djot.lua 80. Non-Markdown comparators: typst 56,617; asciidoctor 5,221 — [GitHub REST `repos/{owner}/{repo}`](https://api.github.com/repos/jgm/djot)

**Editor tooling (VS Code Marketplace installs)**
- Markdown All in One 14.75M; markdownlint 12.38M; MDX (unifiedjs) 1.27M + MDX (silvenon, older) 679k; AsciiDoc 755k; Quarto 510k; Foam (an Obsidian-like PKM) 282k; MyST highlight 61k; **djot extensions: 258, 166** — [VS Code Marketplace gallery API](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one)

**Obsidian**
- About 1.5M users and about $25M ARR, as reported April 2026 (secondary source; the Kinja original wasn't located) — [Tech Insider](https://tech-insider.org/obsidian-vs-notion-2026/). About 1M users estimated in 2023 from GitHub download counts — [Wikipedia, citing Fast Company](https://en.wikipedia.org/wiki/Obsidian_(software))
- A single desktop release (v1.13.7, published 2026-08-12) has had 1.84M in-app-update (`.asar.gz`) downloads, 1.96M `.exe` and 1.52M `.dmg` downloads in about two months — [GitHub releases API, obsidianmd/obsidian-releases](https://api.github.com/repos/obsidianmd/obsidian-releases/releases)
- Stack Overflow Developer Survey "Obsidian" used by 16.1% of respondents (2025) — [SO Survey 2025](https://survey.stackoverflow.co/2025/technology/)

**Pandoc family**
- Pandoc GitHub release-asset downloads: 6.89M for releases published in 2025; 4.65M for 2026 releases through mid-October. Pandoc 3.11 alone has 533k — [GitHub releases API, jgm/pandoc](https://api.github.com/repos/jgm/pandoc/releases)
- Quarto CLI release downloads: 5.66M (2024 releases), 6.89M (2025), 4.10M (2026 so far) — [GitHub releases API, quarto-dev/quarto-cli](https://api.github.com/repos/quarto-dev/quarto-cli/releases)
- CRAN `rmarkdown` 1.62M downloads (Sep 2026) — [cranlogs](https://cranlogs.r-pkg.org/downloads/total/2026-09-01:2026-09-30/rmarkdown,quarto,knitr,bookdown,ggplot2)

### Inferences
- **The scale order** (by files, packages, and tooling): GFM/CommonMark ≫ Pandoc-family ≈ MDX (different populations: scientific publishing vs JS docs) > Obsidian (large population, but private vaults, so it barely shows on GitHub) ≫ MyST/Markdoc ≫ Djot. Every djot metric (npm, PyPI, crates, VS Code, file counts, topics) lands 3–5 orders of magnitude below the mainstream. Its 2,044 stars are its only "medium" number, which reflects jgm's reputation and attention more than use.
- The Obsidian `.asar.gz` count (1.84M updates for one release in about two months) suggests a desktop installed base on the order of 2M. That fits the 1.5M-user claim (it is a different unit: installs, multiple devices). Mobile app-store installs aren't counted, so this is not an upper bound.
- Pandoc release downloads understate pandoc use substantially: Quarto bundles pandoc, and Homebrew, apt, conda and `pypandoc-binary` (3.1M/month) are separate channels. Pandoc is probably the most-installed Markdown *converter* by a wide margin, but most people use it as a format-conversion utility, not as a Pandoc-Markdown authoring dialect.
- The Python numbers are dominated by transitive dependencies (`rich`→markdown-it-py, `nbconvert`→mistune, `mkdocs`→markdown). They say little about which dialect people author in. They do confirm that CommonMark-conformant parsers (markdown-it-py) have become infrastructure.

### Gaps
- No direct measure of how many people **author** in each dialect. Every number above is a proxy: installs, files, stars or survey self-report.
- Pandoc distribution totals across all channels (Homebrew analytics, Debian popcon, conda) weren't collected.
- No official 2026 Obsidian user figure. The 1.5M is secondary and unverified.
- GitHub code-search counts are index estimates of unclear coverage (the legacy API doesn't index every file or fork), so use them as ratios and orders of magnitude.
- I couldn't get a djot GitHub star history (the stargazers endpoint returned 404 for that repo via `gh`), so there's no djot star *trend*.

---

## Q2. What are the trends — who is growing, flat, or declining?

### Takeaway
After normalizing for the 2026 npm-wide surge, the **clear relative winners are GFM, and Markdown as the format for rendering and ingesting LLM output**: `remark-gfm`, `react-markdown`, `turndown` (HTML→Markdown) and Vercel's `streamdown` all outgrew the baseline. **MDX is declining in relative share** (absolute downloads still grow). **The commonmark.js reference implementation is falling in absolute terms.** Quarto is replacing R Markdown inside the pandoc family. **Obsidian is growing steadily** (release downloads up about 1.5×/year). **Djot is growing from almost nothing to almost nothing.** Markdown's overall standing among developers *rose* over 2023→2025.

### Cited Findings

**The npm baseline problem.** Sep 2025 → Sep 2026 raw multiples for general packages: `react` 3.8×, `express` 2.7×, `lodash` 2.2× — [npm downloads API](https://api.npmjs.org/downloads/point/2026-09-01:2026-09-30/react,express,lodash). The monthly series shows a steady ramp, not a one-off step: `react` 192M (2025-09) → 275M (2026-01) → 464M (2026-03) → 731M (2026-09) — [npm range API](https://api.npmjs.org/downloads/range/2025-03-01:2026-09-30/react). Third-party analysis warns that npm counts installs (CI, agents, transitive pulls), not users, and documents CI-driven spikes in 2026 — [amplifying.ai](https://amplifying.ai/coding-agents/npm).

**Markdown packages, Sep 2025 → Sep 2026 raw multiple** (compare with the 2.2–3.8× baseline) — all from the [npm downloads API](https://api.npmjs.org/downloads/point/2025-09-01:2025-09-30/marked,markdown-it,remark-parse,micromark,remark-gfm,commonmark,showdown,markdown-to-jsx,react-markdown,turndown,streamdown):
- Above baseline: `streamdown` 0.53M → 26.0M (**49×**); `remark-gfm` 31.7M → 166.3M (**5.3×**); `react-markdown` 28.1M → 143.5M (**5.1×**); `turndown` 8.1M → 39.0M (**4.8×**); `@markdoc/markdoc` 4.6×; `@next/mdx` 4.7×; `marked` 4.5×; `obsidian` (plugin-API types package) 83k → 474k (5.7×)
- At or below baseline: `micromark` 3.8×; `remark-parse` 3.7×; `@mdx-js/mdx` 3.5×; `markdown-it` 2.7×; `@mdx-js/react` 2.4×
- **Absolute decline:** `commonmark` (commonmark.js) 4.07M → 3.13M (0.8×). Weak: `showdown` 1.4×, `markdown-to-jsx` 1.4×
- Djot: `@djot/djot` 1,297 → 3,955/month (3.0×, from a negligible base)

**Long-run shares (downloads per 1,000 `react` downloads, each September)** — derived from the [npm downloads API](https://api.npmjs.org/downloads/point/2022-09-01:2022-09-30/react):
- `@mdx-js/mdx`: 234 (2022) → 149 → 105 → 69 → **63 (2026)**. A steady relative decline. `@mdx-js/loader`: 88 → 11.
- `remark-gfm`: 56 (2022) → 96 → 138 → 165 → **228 (2026)**. A steady relative rise.
- `react-markdown`: 80 → 91 → 113 → 146 → **196**.
- `commonmark`: 20 → 14 → 17 → 21 → **4**.
- **GFM attach rate inside the remark ecosystem:** `remark-gfm` / `remark-parse` went from 4.0M/37.6M = **11% (Sep 2022) → 166M/215M = 77% (Sep 2026)** — [npm downloads API](https://api.npmjs.org/downloads/point/2022-09-01:2022-09-30/remark-gfm,remark-parse)

**Stack Overflow Developer Survey — "Markdown File" as a documentation/collaboration tool (used, all respondents)**
- 2023: 26.17% (71,878 responses) — [SO Survey 2023](https://survey.stackoverflow.co/2023/)
- 2024: 29.1%, with Obsidian at 13% (49,931 responses) — [SO Survey 2024](https://survey.stackoverflow.co/2024/technology)
- 2025: **34.8%**, ahead of Confluence (32.8%); Obsidian 16.1%; Notion 16.5% (30,065 responses) — [SO Survey 2025](https://survey.stackoverflow.co/2025/technology/)
- The 2025 survey describes Markdown as the most admired tool in this category for the third year running (per a secondary read of the page) — [SO Survey 2025 via search summary](https://survey.stackoverflow.co/2025/technology/)

**Obsidian release downloads by release-publish year** (these accrue over time, which biases recent years *downward*): 2021 2.28M → 2022 5.84M → 2023 11.23M → 2024 15.90M → 2025 23.86M → **2026 (Jan–mid-Oct) 31.48M** — [GitHub releases API](https://api.github.com/repos/obsidianmd/obsidian-releases/releases). Reported users: about 1M (2023) → about 1.5M (Apr 2026) — [Wikipedia](https://en.wikipedia.org/wiki/Obsidian_(software)); [Tech Insider](https://tech-insider.org/obsidian-vs-notion-2026/).

**Pandoc family**
- Stack Overflow new questions per year — `r-markdown`: 1,568 (2020) → 799 (2023) → 336 (2024) → 100 (2025); `quarto`: 343 (2022) → 524 (2023) → **339 (2024, overtaking r-markdown's 336)** → **143 (2025 vs 100)** — [Stack Exchange API](https://api.stackexchange.com/2.3/questions?site=stackoverflow&tagged=quarto&filter=total)
- Quarto CLI release downloads by year: 0.91M (2022) → 1.98M (2023) → 5.66M (2024) → 6.89M (2025) — [GitHub releases API](https://api.github.com/repos/quarto-dev/quarto-cli/releases)
- Quarto is described as R Markdown's successor. Posit announced in April 2026 a Rust rewrite, Quarto 2, targeting late 2026 — [Wikipedia: Quarto](https://en.wikipedia.org/wiki/Quarto_(software))
- Pandoc release downloads by year: 2.29M (2020) → 4.48M (2022) → 9.35M (2023) → 5.18M (2024) → 6.89M (2025) — [GitHub releases API](https://api.github.com/repos/jgm/pandoc/releases). Roughly flat to rising, and noisy.
- CRAN `rmarkdown` (Sep): 1.01M (2022) → 0.92M → 1.07M → 1.66M → 1.62M (2026) — [cranlogs](https://cranlogs.r-pkg.org/downloads/total/2026-09-01:2026-09-30/rmarkdown,quarto,knitr,bookdown,ggplot2)

**Stack Overflow as a trend source has collapsed.** New `markdown`-tagged questions fell 972 (2020) → 353 (2024) → 119 (2025) → 25 (2026 through 13 Oct) — [Stack Exchange API](https://api.stackexchange.com/2.3/questions?site=stackoverflow&tagged=markdown&filter=total). All-time tag totals: r-markdown 10,819; markdown 9,021; pandoc 2,689; quarto 1,364; github-flavored-markdown 549; commonmark 54 — [Stack Exchange tags API](https://api.stackexchange.com/2.3/tags/markdown;pandoc;commonmark;quarto;r-markdown;github-flavored-markdown/info?site=stackoverflow). **The SO `mdx` tag (3,951) is mostly MDX the OLAP query language (Multidimensional Expressions)**, so it is unusable as an MDX-the-markup signal.

### Inferences
- **GFM is becoming the default even inside "pure CommonMark" stacks.** remark users went from mostly plain CommonMark (11% adding GFM) to mostly GFM (77%) in four years. The strongest growers are React components rendering Markdown (react-markdown, streamdown) and HTML→Markdown converters (turndown). That fits Markdown becoming the I/O format for LLM chat UIs and for content ingestion by agents. This is inferred from package roles; I didn't find a source that measured the causal attribution.
- **MDX's relative decline** (a 3.7× drop in share since 2022) while its absolute numbers grow suggests MDX is held by the React docs-framework install base (Docusaurus, Next.js, Nextra) without expanding beyond it. `@mdx-js/react` (the runtime) holds share better than `@mdx-js/mdx` (the compiler). That is consistent with prebuilt sites and frameworks consuming MDX, rather than new pipelines adopting it.
- **CommonMark "won" as a substrate but not as a brand.** The reference JS implementation is shrinking absolutely, while CommonMark-conformant engines (micromark, markdown-it, markdown-it-py, pulldown-cmark, cmark-gfm) are everywhere. People adopt "Markdown (= CommonMark + GFM)"; few pick plain CommonMark.
- **Djot shows no adoption inflection** four years after launch: about 4k npm downloads/month, 46 PyPI downloads/month, a few hundred VS Code installs, 42 GitHub topic repos. Its repo's last push was 2026-07-01. Growth multiples are positive but meaningless at this base.
- Pandoc Markdown as an authoring dialect is consolidating under **Quarto**, which is moving to a new Rust implementation in 2026.

### Gaps
- No Google Trends pull (no accessible API from here). Search-interest trends for "djot", "MDX", "Obsidian" etc. remain unmeasured.
- Stack Overflow survey samples shrank (71.9k → 49.9k → 30.1k respondents) and probably skew differently each year, so the 26% → 35% rise in Markdown File is suggestive, not rigorous.
- The cause of the 2026 npm-wide surge isn't established from a primary source (AI agents and CI are the leading hypotheses). That limits how far the "above baseline" reading can be pushed.
- PyPI trend data from pypistats covers only about 180 days. The September 2026 dip seen across *all* packages, `requests` included, looks like a data artifact, so no PyPI year-over-year trend was computed.

---

## Q3. Where does each dialect live — which platforms and ecosystems have standardized on it?

### Takeaway
CommonMark/GFM is the platform standard for code hosts and forums: GitHub, GitLab, Codeberg, Reddit, Stack Exchange, Discourse, Swift, Qt. MDX is the React docs-framework dialect. Pandoc Markdown underpins Quarto/R Markdown and academic writing. Obsidian's dialect is tied to one (very popular) app. MyST is the Jupyter and scientific-Python docs dialect. Djot has no platform adopters beyond its own tooling, a WordPress plugin and a phpDocumentor add-on.

### Cited Findings
- CommonMark adopters named by Wikipedia: Codeberg, Discourse, GitHub, GitLab, Reddit, Qt, Stack Exchange (Stack Overflow), Swift — [Wikipedia: Markdown](https://en.wikipedia.org/wiki/Markdown)
- Stack Exchange moved its whole network to CommonMark. As of June 20, 2020 "all sites are on CommonMark", using markdown-it client-side and markdig server-side, with a migration of existing posts — [Meta Stack Exchange post (mirror)](https://backiee.wasmer.app/https_meta_stackexchange_com/a/349119); [Joplin forum](https://discourse.joplinapp.org/t/stackexchange-picks-markdown-it-for-client-side-rendering/9466)
- CommonMark spec history: first release 2014-10-25; latest **0.31.2 (2024-01-28)**; a 1.0 planned for 2019 has not shipped, "as major issues still remain unsolved". RFC 7763/7764 (March 2016) registered `text/markdown` and variants (MultiMarkdown, GFM, Pandoc, Markdown Extra) — [Wikipedia: Markdown](https://en.wikipedia.org/wiki/Markdown)
- **The GFM spec is frozen at "Version 0.29-gfm (2019-04-06)"**, two CommonMark revisions behind — [GitHub GFM spec](https://github.github.com/gfm/)
- The CommonMark wiki lists about 63 implementations (about 54 maintained, across about 30 languages) — [CommonMark implementations wiki](https://github.com/commonmark/commonmark-spec/wiki/List-of-CommonMark-Implementations). Applications listed as supporting it include VS Code, Ghost, HackMD, Jekyll, Hugo, Zola and Pandoc — [Applications supporting CommonMark wiki](https://github.com/commonmark/commonmark-spec/wiki/Applications-supporting-CommonMark)
- Other variant users: Bitbucket, Discord, OpenStreetMap, SourceForge. Markdown Extra is used in Drupal, Grav, Textpattern and TYPO3. Discord-style `||spoiler||` syntax has spread to Telegram, Matrix clients and others — [Wikipedia: Markdown](https://en.wikipedia.org/wiki/Markdown)
- Docs platforms (share among sites that use *any* monitored docs platform, May 2026): GitBook 22.7%, Docusaurus (MDX-based) 17.9%, Mintlify (MDX-based) 9.1%. 99.8% of all websites use none of them — [W3Techs via search summary](https://w3techs.com/technologies/subdetails/documentation). Docusaurus is about 3M weekly downloads vs Astro Starlight about 200k (third-party guide) — [PkgPulse](https://www.pkgpulse.com/guides/best-documentation-frameworks-2026)
- Djot: the official site says "Djot isn't completely stable yet, minor future changes to the syntax are expected". It lists six implementations (JS, Lua, Prolog, Rust/jotdown, Go, PHP) and names no adopters — [djot.net](https://djot.net/). Known adopters found: a WordPress "Djot Markup" plugin — [WordPress.org](https://is.wordpress.org/plugins/djot-markup/); phpDocumentor's guides-djot input format — [GitHub phpDocumentor/guides-djot](https://github.com/phpDocumentor/guides-djot). Pandoc reads and writes djot — [try.pandoc.org](https://try.pandoc.org)
- MyST / Jupyter Book 2: rebuilt on the MyST engine as an official Jupyter subproject. Adopters include The Turing Way, QuantEcon, Project Pythia and QIIME 2. The project cites over 14,000, later over 18,000, Jupyter Book sites (ecosystem-wide, not only JB2) — [SciPy 2025 talk](https://cfp.scipy.org/scipy2025/talk/NYPUVH/); [SciPy Proceedings](https://proceedings.scipy.org/articles/hwcj9957); [FOSDEM](https://fosdem.org/schedule/event/ZY9WYD-introducing-jb-2)

### Inferences
- **Network effects are lopsided:** writing GFM works on essentially every major code host and forum. Every other dialect is bound to a toolchain (MDX → React build; Pandoc → pandoc/Quarto; Obsidian → one app; MyST → Jupyter Book/Sphinx). That makes the "portability" each one offers outside its home very different.
- GFM's spec freezing in 2019 while usage kept growing implies GFM's *de facto* definition now lives in implementations (cmark-gfm, github.com rendering, and practices like alerts/callouts) more than in the spec. The syntax researcher may want to confirm whether GitHub's newer features (e.g. `> [!NOTE]` alerts) appear in any spec at all.
- Djot has the profile of a design-reference dialect: influential among people who think about markup design (jgm authored both CommonMark and pandoc), with no ecosystem pull yet.

### Gaps
- Didn't verify GitLab's GLFM spec status or Reddit's current renderer from primary sources (Wikipedia is the citation).
- No quantitative adoption figures for Markdoc beyond npm and GitHub (Stripe docs is the known flagship, but I didn't verify it this session).
- No platform-level adoption list for Obsidian Flavored Markdown compatibility in other apps (Logseq, Foam etc. are adjacent and the overlap is unmeasured).

---

## Q4. What macro forces are reshaping Markdown usage (especially LLMs and agents)?

### Takeaway
Markdown has become the **default interchange format between LLMs, agents and the web**. LLM chat UIs render (mostly GFM) Markdown. Instruction files for coding agents (AGENTS.md, CLAUDE.md) are Markdown. Websites now serve Markdown to agents (Cloudflare "Markdown for Agents", llms.txt). This pushes toward GFM-shaped Markdown specifically, and adds weight to "what LLMs already emit and parse" as a selection pressure.

### Cited Findings
- Cloudflare's "Markdown for Agents" (changelog 2026-02-12) converts HTML to Markdown at the edge when a client sends `Accept: text/markdown`. It returns `content-type: text/markdown` and an `x-markdown-tokens` estimate, enabled per zone — [Cloudflare docs](https://developers.cloudflare.com/fundamentals/reference/markdown-for-agents/); [Cloudflare changelog](https://developers.cloudflare.com/changelog/2026-02-12-markdown-for-agents)
- HackMD announced Markdown-native content negotiation for agentic workflows (March 2026) — [HackMD blog](https://hackmd.io/blog/2026/03/22/agentic-workflow-2026)
- AGENTS.md: the Agentic AI Foundation cited adoption by over 60,000 open-source projects (Dec 2025, a self-reported figure); GitHub code search found about 96.6k root-level AGENTS.md files (June 2026); in sampled top repos, about 20–60% carry one depending on sampling — [agentmarketcap.ai](https://agentmarketcap.ai/blog/2026/04/17/agents-md-60k-adoption-aaif-donation-standards-floor); [Towards AI](https://pub.towardsai.net/does-claude-code-read-your-agents-md-we-checked-283-repos-in-161-it-still-reads-claude-md-cb6199708fc1); [LevelUp](https://levelup.gitconnected.com/claude-code-vs-codex-vs-cursor-vs-copilot-in-2-200-github-repos-4-in-10-claude-md-2aa1f98c003e)
- llms.txt: 8.7% of the top 1,000 sites by June 2026 (up from about 0.3% in June 2025) — [Rankability](https://www.rankability.com/data/llms-txt-adoption/); 8,598 of the top 100k domains (Sept 2026) — [SEOmator](https://seomator.com/blog/llms-txt-adoption). But Ahrefs found 97% of llms.txt files got zero requests in May 2026 — [PPC Land](https://ppc.land/llms-txt-adoption-rises-8-8x-but-97-of-files-get-zero-ai-requests/)
- Vercel's `streamdown` (launched Aug 2025) is a react-markdown drop-in built for streaming AI output. It auto-completes unterminated syntax such as unclosed bold or partial code fences, and powers the AI Elements Response component — [Vercel changelog](https://vercel.com/changelog/introducing-streamdown). npm: 0.53M (Sep 2025) → 26.0M (Sep 2026) per month — [npm downloads API](https://api.npmjs.org/downloads/point/2026-09-01:2026-09-30/streamdown)
- Wikipedia now lists large language models among Markdown's main uses — [Wikipedia: Markdown](https://en.wikipedia.org/wiki/Markdown)

### Inferences
- The LLM channel reinforces **GFM specifically** (tables, fenced code, task lists): it is what chat UIs render and what renderers like react-markdown+remark-gfm and streamdown support. A new or niche dialect now faces a familiarity deficit in models as well as humans. (The LLM-familiarity researcher's probes should confirm or refute this. I only measured the renderer side.)
- streamdown's existence is evidence of a real dialect-design pressure: **streaming-robust parsing** of partial input. Mainstream Markdown handles it poorly enough that a dedicated repair layer took off. That may matter to UDON's design, which has its own positional/delimited EOF model.
- AGENTS.md and llms.txt carry "Markdown" with no dialect named. In practice "Markdown" now means "whatever GFM-ish thing GitHub and LLMs render", which is the de facto standard any newcomer competes against.

### Gaps
- No measurement found of which dialect LLMs *emit* by default (assumed GFM-like; that's the familiarity researcher's area).
- The llms.txt and AGENTS.md figures come from secondary trackers with differing methods. Treat them as directional.

---

## Q5. Which other sizable players belong in the comparison?

### Takeaway
Beyond the six named, the sizable players are **Python-Markdown/MkDocs** (very large docs footprint), **MyST** (scientific Python and Jupyter), **Quarto and R Markdown** (Pandoc-family, data science), **Markdoc** (Stripe; small but growing), **kramdown** (Jekyll/GitHub Pages lineage), **Goldmark** (Hugo's CommonMark+GFM engine), and outside Markdown proper **reStructuredText** and **AsciiDoc**. **Typst** isn't Markdown but competes for the pandoc/LaTeX authoring niche and is being adopted by Quarto and Jupyter Book for PDF output.

### Cited Findings
- MkDocs: `mkdocs` 13.1M, `mkdocs-material` 11.7M PyPI downloads/month; MkDocs depends on Python-Markdown — [pypistats](https://pypistats.org/api/packages/mkdocs/recent); [PyPI mkdocs metadata](https://pypi.org/pypi/mkdocs/json)
- MyST: `myst-parser` 5.18M/month PyPI; mystmd 526 stars; MyST-Parser 895 stars — [pypistats](https://pypistats.org/api/packages/myst-parser/recent); [GitHub API](https://api.github.com/repos/jupyter-book/mystmd)
- Markdoc: 2.34M npm/month (Sep 2026), 0.4 → 3.2 per 1,000 react downloads over 2022→2026; 8,506 stars; about 30k `.mdoc` files — [npm downloads API](https://api.npmjs.org/downloads/point/2026-09-01:2026-09-30/@markdoc/markdoc); [GitHub API](https://api.github.com/repos/markdoc/markdoc)
- Goldmark 5,058 stars; kramdown 1,782 stars (last push 2026-01-31); MultiMarkdown-6 679 — [GitHub API](https://api.github.com/repos/yuin/goldmark)
- reStructuredText ≈ 8.72M files on GitHub (about 3% of `.md`); AsciiDoc ≈ 1.54M files, Asciidoctor 5,221 stars, VS Code AsciiDoc extension 755k installs — [GitHub code search API](https://api.github.com/search/code?q=extension:rst); [VS Code Marketplace](https://marketplace.visualstudio.com/items?itemName=asciidoctor.asciidoctor-vscode)
- Typst 56,617 GitHub stars (more than pandoc's 46,587); Quarto uses Typst for PDF output in place of LaTeX, per a 2024 conference writeup ([UC ANR](https://ucanr.edu/node/115337)), and Jupyter Book 2 advertises Typst PDF export ([SciPy 2025 talk](https://cfp.scipy.org/scipy2025/talk/NYPUVH/)) — stars from [GitHub API](https://api.github.com/repos/typst/typst)
- Org-mode ≈ 645k `.org` files on GitHub — [GitHub code search API](https://api.github.com/search/code?q=extension:org)

### Inferences
- If the comparison is about *what people author in*, MkDocs (Python-Markdown) and MyST deserve rows alongside MDX: their docs footprints are comparable or larger in their ecosystems. Markdoc is the most interesting "designed alternative to MDX" by trend (rising share), but it is still about 1/20 of MDX by downloads.
- Typst out-starring pandoc is an attention signal that the "rich-document authoring" niche Pandoc Markdown occupies is contested from outside Markdown entirely.

### Gaps
- Didn't measure Slack/Discord/Teams/Notion "Markdown-ish" input syntaxes. They're huge in user count but aren't file formats, so they have no registry proxy.
- No GitLab GLFM-specific or Bitbucket figures.
- Hugo/Goldmark site counts weren't pulled (W3Techs or BuiltWith would be the source).
