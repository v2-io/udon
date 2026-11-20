---
source: agentic-tooling sweep 2026-07-21 — area "harness-invivo" (repo ~/src/_ref/obsidian-help)
gathered: 2026-07-21
status: vetted mining-spot map
repo_clone_version: git HEAD d867b9e, last commit 2025-08-25 (files dated Aug 30 2025)
---

# Obsidian Help (`~/src/_ref/obsidian-help`) — mining-spot map

## What this repo actually is (center of mass, and a caveat)

This is **not** an agent harness or CLI codebase. It is the source content for help.obsidian.md — a set of stand-alone Markdown "vaults" (one per language: `en`, plus ar/da/es/fa/fr/id/it/ja/km/ko/pt-br/ru/vi/zh), published via Obsidian Publish. There is **no tool-definition JSON, no system prompt, no edit-tool design, no agent-mode CLI** anywhere in the tree — I searched (see log). So the "how does this harness use tools in vivo" question has no answer here.

Its value to UDON is the framing the brief anticipated for Obsidian repos: **prior art for fmt/lint over a markdown-family document format** — how Obsidian defines its own markdown flavor, how it models frontmatter as typed "Properties" (human-and-machine-readable structured data at the top of every file), and the human style/normalization rules its docs are held to. All of that lives in the English vault only; the other 13 language dirs are translations of the same structure (dry wells for our purposes).

Everything below is in `en/`.

---

## High priority — format/frontmatter model as prior art

- **`en/Editing and formatting/Properties.md`** (278 lines) — Obsidian's typed frontmatter model, the closest analog to UDON's typed-attribute ambitions. Lines ~30–45: the six **property types** (Text, List, Number, Checkbox, Date, Date & time) with the rule "once a type is assigned to a name, *all* notes in the vault use that type." Lines ~85–95 ("Not supported"): explicit design limits worth noting for UDON — **no nested properties, no Markdown inside properties** ("intentional limitation as properties are meant for small, atomic bits of information that are both human and machine readable"). Lines ~150–278: the storage contract — YAML at top of file, `name: value`, names must be unique per note (`tags` can't repeat), values are text/number/bool/list. Its own frontmatter (lines 1–13) demonstrates `aliases`, `cssclasses`, `permalink`, `publish`, `mobile` as reserved keys. Date: Aug 2025. **HIGH** — this is the single most directly relevant file: a shipping "structured frontmatter with a type system and deliberate scalar-only constraints" design.

- **`en/Editing and formatting/Obsidian Flavored Markdown.md`** (24 lines) — the spec-in-miniature of Obsidian's markdown dialect: a table of the extensions on top of CommonMark + GFM (`[[Link]]`, `![[Link]]`, `![[Link#^id]]` embeds, `^id` block refs, `%%comment%%`, `==highlight==`, `> [!note]` callouts) and the stated constraint "does not support Markdown or blank lines inside HTML tags." Date: Aug 2025. **HIGH** — compact enumeration of exactly the "markdown-family syntax surface" UDON positions against.

- **`en/Contributing to Obsidian/Style guide.md`** (303 lines) — the human normalization ruleset the docs are linted against (adopts Google + Microsoft style guides). Lines ~105–107: sentence-case-not-title-case for headings. Lines **142–166: the "Markdown" section** — the one machine-checkable rule here: *require blank newlines between markdown blocks* (heading/paragraph/list), with recommended-vs-not-recommended examples — a normalization rule UDON's `fmt` faces an analog of. Lines ~186+: image format/naming conventions (`lucide-` / `obsidian-icon-` prefixes, 18px SVG). Date: Aug 2025. **HIGH** for the Markdown-block-spacing rule specifically; medium for the rest.

## Medium priority

- **`en/Editing and formatting/Basic formatting syntax.md`** (495 lines) — the full user-facing markdown reference (paragraphs, bold/italic/`==highlight==`, headings, quotes, code blocks, task lists, footnotes, `%%comments%%`). Lines ~28–40 carry a normalization fact UDON should note: **multiple adjacent spaces and multiple blank lines collapse to a single space/paragraph break in Reading view** — i.e. the render step normalizes whitespace the source preserves. Date: Aug 2025. **MEDIUM** — reference-grade enumeration of the sibling format's whole surface; skim for the whitespace-collapse semantics.

- **`en/Editing and formatting/Advanced formatting syntax.md`** (~1–60 read) — table syntax and the parsing rule "header row must contain at least two hyphens; cells need not be aligned," plus the `\|` escape for vertical bars inside table cells / aliases. Date: Aug 2025. **MEDIUM** — a worked example of where a markdown-family format needs escaping around its own delimiter (`|`), directly parallel to UDON delimiter-escaping concerns.

- **`en/Editing and formatting/Callouts.md`** (234 lines) — the `> [!type] Title` blockquote-callout convention: type identifier drives rendering, foldable variants (`[!info]-`), custom titles, nesting. Date: Aug 2025. **MEDIUM** — an example of overloading an existing markdown construct (blockquote) with a typed tag in the first line, a design pattern adjacent to UDON's typed elements.

- **`.editorconfig`** (repo root, 8 lines) — the mechanical format contract the whole repo enforces: `charset=utf-8`, **`end_of_line = crlf`**, `insert_final_newline = true`, `indent_style = tab`, `tab_width = 4`. Date: Aug 2025. **MEDIUM** — concrete normalization settings; the CRLF choice is a notable data point for a cross-platform text format.

## Low priority

- **`en/Editing and formatting/Tags.md`, `Attachments.md`, `HTML content.md`, `Folding.md`, `Embed web pages.md`** — remaining pieces of the markdown-surface reference; each documents one construct. **LOW** — enumerate the format but add little beyond the HIGH/MEDIUM files above; consult only if cataloguing the full Obsidian syntax surface.

- **`README.md`** (repo root) — describes the multi-vault translation workflow and a `git diff <SHA> HEAD -- en/` staying-up-to-date convention. **LOW** — process, not format; interesting only as a document-corpus versioning pattern.

- **`en/Contributing to Obsidian/Developers.md`** + **`en/Extending Obsidian/*`** (Community plugins, CSS snippets, Obsidian URI, Themes, Plugin security) — point outward to the *developer* docs (docs.obsidian.md, a separate repo) and describe plugins/themes in TypeScript/CSS. **LOW** — no tool schemas or harness code here; the actual plugin API lives in the un-cloned obsidian-developer-docs repo. `Obsidian URI.md` is the only machine-interface doc (an `obsidian://` URL scheme) but it's an app-launch protocol, not agent tooling.

---

## Dry wells / negatives (logged so overlap reconciles)

- **No agent/harness/CLI/tool content.** `grep -rliE 'tool_use|json schema| system prompt|str.?replace|function call|"tools"'` over the tree: **zero** hits relevant to LLM tooling.
- **No linter/formatter code or CI.** `.github/` contains only ISSUE_TEMPLATE markdown + `config.yml` — no workflows, no markdownlint/prettier config, no build. The "linting" is the human `Style guide.md`, not tooling.
- **The 13 non-`en` language dirs** (`ar da es fa fr id it ja km ko pt-br ru vi zh`) are structural translations of `en/`; no unique format/tooling content. Dry wells for this sweep.
- **`Release notes/`** (~300 files) — spot-checked as changelog prose about Obsidian app versions; no format-spec or tooling material. Dry well.
- **`Sandbox/`, `publish.css`, `publish.js`** (en) — Publish-site styling/scaffold, not document-format material. Low/dry.

## Commands run

- `git log -1` → HEAD d867b9e, 2025-08-25 (repo clone/version anchor).
- `ls -R` top level + `find -maxdepth 2 -type d` → 14 language vaults + Release notes + Sandbox.
- Read in full or in part: `.editorconfig`, `.gitattributes`, `README.md`, `en/` dir listing, `Properties.md` (1–160), `Obsidian Flavored Markdown.md` (whole), `Basic formatting syntax.md` (1–40), `Callouts.md` (1–45), `Style guide.md` (1–40, 142–210), `Advanced formatting syntax.md` (1–60), `Developers.md` (1–30).
- `grep -ni 'markdown|frontmatter|heading|code block|table|format'` over Style guide → located the Markdown-block-spacing rule at line 142.
- `find .github -type f` → issue templates only, no CI/lint config.
