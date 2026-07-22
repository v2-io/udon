---
source: harness-invivo sweep — ~/src/_ref/obsidian-linter
gathered: 2026-07-21
status: vetted mining-spot map
repo_version: HEAD b8f4168 (2025-08-18, "Merge PR #1366"); working tree dated Aug 30 2025; test-vault touched Jan 20 2026
---

# obsidian-linter — mining-spot map

## Framing / center of mass

This is **not an agent harness** — no LLM, no tool-calling, no JSON-schema tool
definitions, no edit-tool/str-replace, no streaming/exit-codes/agent-mode. It is
a TypeScript Obsidian plugin that formats/normalizes Markdown-family notes. Its
entire relevance to UDON is as **prior art for a fmt/lint engine over a
markdown-family document**: how rules are modeled, ordered, made
region-aware, self-documented, and self-tested. The gold is concentrated in
`src/rules.ts`, `src/rules-runner.ts`, `src/utils/ignore-types.ts`,
`src/rules/rule-builder.ts`, and the auto-doc/example-test machinery. Everything
below is that. The rule-file corpus (66 files in `src/rules/`) is a menu of
concrete normalization behaviors UDON's `fmt`/lint will face analogues of.

The center of mass is exactly where the area brief predicted (linter/fmt prior
art), so no relocation — but I'm flagging up front that the "harness in vivo"
questions (tool schemas, edit tools, agent-mode) have **no answers here**; that's
a dry well for this repo, logged below.

## High priority

- **`src/rules.ts`** (201 lines; esp. 20-27, 29-117, 147-187) — The core data
  model: a `Rule` = {name, description, type ∈ {YAML, Heading, Footnote,
  Content, Spacing, Paste}, `applyAfterIgnore(text,options)→text` pure string
  transform, examples[], options[], `hasSpecialExecutionOrder`, `ignoreTypes[]`}.
  `apply()` wraps the transform in `ignoreListOfTypes` (region protection).
  `RuleTypeOrder` drives phase ordering; `sortRules` sorts by type then key;
  `getDisabledRules` reads a `disabled rules:` frontmatter key (with an `all`
  sentinel that skips the whole file). This is the whole "what is a lint rule"
  abstraction UDON would need an answer for. Date: 2025-08.

- **`src/utils/ignore-types.ts`** (236 lines; esp. 9-72) — The **region-protection
  mechanism**, the single most transferable idea for a structure-aware formatter:
  before running a rule, matched regions (code blocks, inline code, math, tables,
  YAML, wiki/markdown links, tags, HTML, a user `custom-ignore` span, etc.) are
  swapped out for placeholder strings, the rule runs on the safe remainder, then
  placeholders are restored in reverse order. `IgnoreType.replaceAction` is a
  union of {mdast node type | RegExp | custom fn}. Directly analogous to what
  UDON fmt must do to avoid reformatting inside fences/blobs. Date: 2025-08.

- **`src/rules-runner.ts`** (338 lines; esp. 57-126, 128-147, 149-212, 238-271)
  — The **orchestration / phase pipeline**. Rules run in explicit phases:
  `runBeforeRegularRules` (YAML-escape, tag-format, math-block-normalize,
  misspellings — things that must precede YAML parsing) → the main loop over
  `rules` (skipping disabled, `hasSpecialExecutionOrder`, and Paste rules) →
  custom-regex replacements → `runAfterRegularRules` (capitalize headings, YAML
  title/alias, trailing spaces, consecutive-blank-lines, **YAML timestamp run
  LAST so it can detect whether anything else changed** — lines 182-191 — then
  YAML key-sort). The interdependency-driven ordering and the "did-anything-change"
  gating of the modified-timestamp are the load-bearing insight: lint rules are
  not commutative and the runner encodes a hand-tuned order. Also `runPasteLint`
  (a separate on-paste rule set) and `runCustomRegexReplacement` (user regex
  find/replace, itself run inside `ignoreListOfTypes`). Date: 2025-08.

- **`src/rules/rule-builder.ts`** (323 lines; esp. 12-69, 82-160, 189-323) — The
  **rule authoring framework**: `RuleBuilder<TOptions>` base class each rule
  extends; `@RuleBuilder.register` decorator self-registers into the global rule
  list; `applyIfEnabledBase` gates on the rule's `enabled` option, merges
  settings+extra options, times execution, and wraps errors. Typed `OptionBuilder`
  subclasses (Boolean/Number/Dropdown/TextArea/Text/MomentFormat/MdFilePicker) map
  a rule's config schema to both defaults and UI. `ExampleBuilder` binds
  before/after examples to the rule. This is the "how do you declare a rule +
  its options + its examples once and get config, UI, docs, and tests from it"
  pattern. Date: 2025-08.

## Medium priority

- **`src/docs.ts`** (~180 lines; esp. 1-60) — **Docs are auto-generated from the
  rules' embedded examples.** `generateReadme()` + `generateDocs()` iterate
  `rules`, emitting each rule's before/after `Example`s as fenced markdown into
  README + wiki pages, grouped by rule type, with an autogen-warning banner.
  Single-source-of-truth: example = spec = doc. Directly relevant to a UDON fmt
  whose behaviors should be documented from the same fixtures that test them.
  Date: 2025-08.

- **`__tests__/common.ts`** (`ruleTest` helper, lines 24-40) + the ~60
  per-rule `*.test.ts` files — **Example-driven / golden testing**: every rule is
  tested as `expect(rule.apply(before, options)).toBe(after)`, the same
  before/after pairs that also generate the docs. The fmt-fixture discipline UDON
  already uses (compliance groups) has a close cousin here. Date: 2025-08.

- **`src/utils/yaml.ts`** (508 lines; exports mapped at 8-15, 22-137, 177-486) —
  **Frontmatter handling** with real footguns addressed: `getYAMLText`/`formatYAML`
  (operate only on the `---…---` block), `setYamlSection`/`getYamlSectionValue`/
  `removeYamlSection` (nested-key aware), array-format normalization
  (`formatYamlArrayValue`, single vs multiline arrays, tag/alias-specific styles),
  `escapeStringIfNecessaryAndPossible` / `isValueEscapedAlready` (quoting/escaping
  decisions), `getExactDisabledRuleValue`. This is a catalog of the YAML-quoting/
  escaping/array-shape decisions any frontmatter-bearing format (UDON attrs)
  must make — the "Norway problem" surface, worked. Date: 2025-08.

- **`src/utils/mdast.ts`** (1230 lines; exports listed 107-1205) — The
  **structural-transform toolkit** built on a markdown AST (`getPositions`,
  `ensureEmptyLinesAroundFencedCodeBlocks`/math/blockquotes/horizontal-rules,
  `updateOrderedListItemIndicators`, `getAllTablesInText`,
  `ensureFencedCodeBlocksHasLanguage`, `moveFootnotesToEnd`, `reIndexFootnotes`,
  emphasis/bold normalization). Evidence that once you need position-accurate
  reformatting you end up needing a real parse tree, not regex — a data point for
  where UDON's fmt would lean on its own tree. Skim by export name, not
  cover-to-cover. Date: 2025-08.

- **`src/rules/compact-yaml.ts`** (whole; ~90 lines) + **`yaml-key-sort.ts`**
  (whole) — Two concrete worked rules read in full: a simple regex-based YAML
  blank-line compactor with embedded before/after examples, and a
  `hasSpecialExecutionOrder` priority-key-sort operating on the YAML CST. Good
  "what a rule actually looks like end to end" samples (simple + complex). Date:
  2025-08.

## Low priority

- **`docs/docs/settings/custom-rules.md`** (custom regex + custom lint commands)
  — User-authored regex find/replace rules "run before the YAML timestamp rule
  but after most others," and a warning that regex lookbehinds break on iOS.
  Prior art for user-extensible lint rules + the ordering-contract that
  extensions plug into. Date: 2025-08.

- **`src/rules/_rule-template.ts.txt`** — the scaffold contributors copy to add a
  rule; compact statement of the required rule shape. Low, but a fast orientation
  to the authoring contract. Date: 2025-08.

- **`README.md`** (esp. the note at ~line 17) — states each rule is designed to
  run independently and calls out that some rule *combinations* interfere (e.g.
  "Paragraph blank lines" × "Two Spaces Between Lines with Content"). Honest
  admission that lint rules are not cleanly composable — a caution for UDON if it
  offers many toggleable fmt rules. Date: 2025-08.

## Dry wells (searched, nothing relevant)

- **The core "harness in vivo" questions have no answer in this repo.** No
  LLM/agent code, no tool JSON schemas, no system prompts, no edit-tool /
  str-replace / diff/patch design, no structured-output/streaming, no agent-mode
  (exit codes / non-interactive flags / machine-readable output), no
  context-management-around-tool-results. Confirmed by: `grep -ri` for
  anthropic/openai/llm/tool_call/json-schema/streaming (none); the plugin's only
  "commands" are Obsidian editor commands, not agent tools.
- `src/cm6/`, `src/ui/`, `src/lang/` — CodeMirror6 editor integration, settings
  UI, and i18n translation tables; editor plumbing, not format/lint logic.
- `test-vault/`, `__integration__/`, `__mocks__/` — Obsidian fixture vault and
  integration scaffolding; not spec/lint content.
- `esbuild.config.mjs`, `manifest*.json`, `versions.json`, `package-lock.json`,
  `scripts/`, `.github/` — build/release/plugin-manifest plumbing.

## Commands run

- `git log -1` → HEAD b8f4168 2025-08-18; `ls -la` + `find -maxdepth 2 -type d`
  for structure.
- `ls src/rules/*.ts | wc -l` → 66 rule files; `wc -l src/utils/*.ts` for util
  sizing (mdast 1230, strings 537, yaml 508, ignore-types 236 …).
- Read in full: `src/rules.ts`, `src/rules-runner.ts`,
  `src/utils/ignore-types.ts`, `src/rules/rule-builder.ts`, `__tests__/common.ts`,
  `src/rules/compact-yaml.ts` (partial), `src/rules/yaml-key-sort.ts` (partial),
  `src/docs.ts` (head), `docs/docs/settings/custom-rules.md`.
- `grep -n "export function" src/utils/{yaml,mdast}.ts` to index the util
  surfaces without reading them cover-to-cover.
- Dry-well grep for agent/LLM/tool-schema/streaming terms across the tree — no
  hits (repo is a pure editor-side formatter).
