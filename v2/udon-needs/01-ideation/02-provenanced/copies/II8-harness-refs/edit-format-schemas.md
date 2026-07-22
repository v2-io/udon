---
source: three shipping coding-CLI edit-format specs, copied verbatim side-by-side (codex apply_patch · aider SEARCH/REPLACE · Claude Code exact-string Edit)
gathered: 2026-07-21
status: gathered — verbatim copies of each format's canonical agent-facing prose; framing is editorial
paths:
  - /Users/josephwecker-v2/src/_ref/codex/codex-rs/apply-patch/apply_patch_tool_instructions.md   # whole (75 lines)
  - /Users/josephwecker-v2/src-ext/aider/aider/coders/editblock_prompts.py   # excerpted: main_system + system_reminder (SEARCH/REPLACE rules)
  - /Users/josephwecker-v2/src/_ref/claude-code-snapshot/tools/FileEditTool/prompt.ts   # whole description string
source_commit:
  - "_ref/codex: 1cd1cf17c"
  - "src-ext/aider: 5dc9490b (same content also at src-ext/codex 0fb559f0f core/prompt_with_apply_patch_instructions.md)"
  - "_ref/claude-code-snapshot: d7de150 (Apr 2026)"
categories: [edit-tooling, file-mutation-schema, llm-friendly-format, cross-tool-convergence, tier-2-shipped-practice, harness-handover]
why_included: >
  THE highest-value convergence in this section. Three independently-shipped
  production answers to one question — "how should an LLM express a file edit so
  the harness can apply it exactly and safely?" — copied verbatim so UDON's
  edit-tooling design and the harness programme can compare them directly. This
  is genuine cross-tool triangulation (three vendors, three shapes), not
  single-author coherence: apply_patch (codex/OpenAI) is an envelope diff with
  fuzzy @@ anchors; SEARCH/REPLACE (aider) is exact-match paired blocks; Claude
  Code's Edit is a single exact old_string→new_string replacement with a
  uniqueness contract. The witness question answered: what an edit tool must
  carry so a model can mutate a file reliably — exact-match anchoring, uniqueness
  disambiguation, new-file/rename/delete handling, and a read-before-edit gate.
---

> **Why these three, together.** Extraction agents in this compilation are
> warned that most of the corpus shares one author, so agreement is coherence
> not corroboration. This file is the exception the rule is looking for: three
> *different* vendors, shipping to *different* frontier models, converged on the
> same load-bearing requirements for LLM file-editing — while differing sharply
> on the surface form. Read the divergences as the design space, and the shared
> invariants (exact match, uniqueness, explicit action header, read-before-edit)
> as what any UDON-native or harness edit tool will also have to carry.

---

## 1. codex `apply_patch` — the envelope-diff schema (OpenAI/GPT-5 family)

*Verbatim, whole (`_ref/codex/codex-rs/apply-patch/apply_patch_tool_instructions.md`; identical content ships in the July src-ext codex tree at `core/prompt_with_apply_patch_instructions.md`). Self-described as "a stripped-down, file-oriented diff format designed to be easy to parse and safe to apply."*

````
## `apply_patch`

Use the `apply_patch` shell command to edit files.
Your patch language is a stripped‑down, file‑oriented diff format designed to be easy to parse and safe to apply. You can think of it as a high‑level envelope:

*** Begin Patch
[ one or more file sections ]
*** End Patch

Within that envelope, you get a sequence of file operations.
You MUST include a header to specify the action you are taking.
Each operation starts with one of three headers:

*** Add File: <path> - create a new file. Every following line is a + line (the initial contents).
*** Delete File: <path> - remove an existing file. Nothing follows.
*** Update File: <path> - patch an existing file in place (optionally with a rename).

May be immediately followed by *** Move to: <new path> if you want to rename the file.
Then one or more "hunks", each introduced by @@ (optionally followed by a hunk header).
Within a hunk each line starts with:

For instructions on [context_before] and [context_after]:
- By default, show 3 lines of code immediately above and 3 lines immediately below each change. If a change is within 3 lines of a previous change, do NOT duplicate the first change's [context_after] lines in the second change's [context_before] lines.
- If 3 lines of context is insufficient to uniquely identify the snippet of code within the file, use the @@ operator to indicate the class or function to which the snippet belongs. For instance, we might have:
@@ class BaseClass
[3 lines of pre-context]
- [old_code]
+ [new_code]
[3 lines of post-context]

- If a code block is repeated so many times in a class or function such that even a single `@@` statement and 3 lines of context cannot uniquely identify the snippet of code, you can use multiple `@@` statements to jump to the right context. For instance:

@@ class BaseClass
@@ 	 def method():
[3 lines of pre-context]
- [old_code]
+ [new_code]
[3 lines of post-context]

The full grammar definition is below:
Patch := Begin { FileOp } End
Begin := "*** Begin Patch" NEWLINE
End := "*** End Patch" NEWLINE
FileOp := AddFile | DeleteFile | UpdateFile
AddFile := "*** Add File: " path NEWLINE { "+" line NEWLINE }
DeleteFile := "*** Delete File: " path NEWLINE
UpdateFile := "*** Update File: " path NEWLINE [ MoveTo ] { Hunk }
MoveTo := "*** Move to: " newPath NEWLINE
Hunk := "@@" [ header ] NEWLINE { HunkLine } [ "*** End of File" NEWLINE ]
HunkLine := (" " | "-" | "+") text NEWLINE

A full patch can combine several operations:

*** Begin Patch
*** Add File: hello.txt
+Hello world
*** Update File: src/app.py
*** Move to: src/main.py
@@ def greet():
-print("Hi")
+print("Hello, world!")
*** Delete File: obsolete.txt
*** End Patch

It is important to remember:

- You must include a header with your intended action (Add/Delete/Update)
- You must prefix new lines with `+` even when creating a new file
- File references can only be relative, NEVER ABSOLUTE.

You can invoke apply_patch like:

```
shell {"command":["apply_patch","*** Begin Patch\n*** Add File: hello.txt\n+Hello, world!\n*** End Patch\n"]}
```
````

**Note the explicit design rationale in the format itself** — a real grammar
(EBNF given to the model), a *fuzzy* anchoring scheme (`@@ class`/`@@ def` to
disambiguate rather than line numbers), and a stated safety/parse-ability goal.
This is the closest analogue in the corpus to a UDON-native structured-mutation
schema, and it comes with its own grammar — a direct comparator.

---

## 2. aider SEARCH/REPLACE blocks — the paired exact-match schema (multi-model)

*Excerpted from `src-ext/aider/aider/coders/editblock_prompts.py` — the `main_system` framing and the `system_reminder` rules verbatim. (Aider ships a whole family of edit-format prompts — `udiff`, `patch`, `wholefile`, `editor_diff_fenced`, `architect`, `ask` — this is the flagship `editblock`.)*

From `main_system`:

```
All changes to files must use this *SEARCH/REPLACE block* format.
ONLY EVER RETURN CODE IN A *SEARCH/REPLACE BLOCK*!
```

The `system_reminder` — the canonical rules:

```
# *SEARCH/REPLACE block* Rules:

Every *SEARCH/REPLACE block* must use this format:
1. The *FULL* file path alone on a line, verbatim. No bold asterisks, no quotes around it, no escaping of characters, etc.
2. The opening fence and code language, eg: {fence[0]}python
3. The start of search block: <<<<<<< SEARCH
4. A contiguous chunk of lines to search for in the existing source code
5. The dividing line: =======
6. The lines to replace into the source code
7. The end of the replace block: >>>>>>> REPLACE
8. The closing fence: {fence[1]}

Use the *FULL* file path, as shown to you by the user.
Every *SEARCH* section must *EXACTLY MATCH* the existing file content, character for character, including all comments, docstrings, etc.
If the file contains code or other data wrapped/escaped in json/xml/quotes or other containers, you need to propose edits to the literal contents of the file, including the container markup.

*SEARCH/REPLACE* blocks will *only* replace the first match occurrence.
Including multiple unique *SEARCH/REPLACE* blocks if needed.
Include enough lines in each SEARCH section to uniquely match each set of lines that need to change.

Keep *SEARCH/REPLACE* blocks concise.
Break large *SEARCH/REPLACE* blocks into a series of smaller blocks that each change a small portion of the file.
Include just the changing lines, and a few surrounding lines if needed for uniqueness.
Do not include long runs of unchanging lines in *SEARCH/REPLACE* blocks.

Only create *SEARCH/REPLACE* blocks for files that the user has added to the chat!

To move code within a file, use 2 *SEARCH/REPLACE* blocks: 1 to delete it from its current location, 1 to insert it in the new location.

If you want to put code in a new file, use a *SEARCH/REPLACE block* with:
- A new file path, including dir name if needed
- An empty `SEARCH` section
- The new file's contents in the `REPLACE` section
```

**Aider also teaches the format by worked example**, not just rules — its
`example_messages` show a two-turn dialogue (import `math`, delete a function,
call `math.factorial`; then "refactor hello() into its own file") rendered as
concrete SEARCH/REPLACE blocks. The pedagogy-by-example is itself a convention
worth noting: the format is taught the way a cheat-sheet would teach UDON.

---

## 3. Claude Code `Edit` — single exact-string replacement with a uniqueness contract

*Verbatim, the whole description string from `_ref/claude-code-snapshot/tools/FileEditTool/prompt.ts` (Apr 2026). Constructed at runtime; the branches (`ant`-user hint, compact-line-prefix) are preserved as they render.*

```
Performs exact string replacements in files.

Usage:
- You must use your `Read` tool at least once in the conversation before editing. This tool will error if you attempt an edit without reading the file.
- When editing text from Read tool output, ensure you preserve the exact indentation (tabs/spaces) as it appears AFTER the line number prefix. The line number prefix format is: [spaces + line number + arrow  OR  line number + tab]. Everything after that is the actual file content to match. Never include any part of the line number prefix in the old_string or new_string.
- ALWAYS prefer editing existing files in the codebase. NEVER write new files unless explicitly required.
- Only use emojis if the user explicitly requests it. Avoid adding emojis to files unless asked.
- The edit will FAIL if `old_string` is not unique in the file. Either provide a larger string with more surrounding context to make it unique or use `replace_all` to change every instance of `old_string`.
- [ant-only hint:] Use the smallest old_string that's clearly unique — usually 2-4 adjacent lines is sufficient. Avoid including 10+ lines of context when less uniquely identifies the target.
- Use `replace_all` for replacing and renaming strings across the file. This parameter is useful if you want to rename a variable for instance.
```

Companion `Write` tool description (same tree, `FileWriteTool/prompt.ts`), for
the new-file / full-rewrite case that `Edit` deliberately doesn't cover:

```
Writes a file to the local filesystem.

Usage:
- This tool will overwrite the existing file if there is one at the provided path.
- If this is an existing file, you MUST use the Read tool first to read the file's contents. This tool will fail if you did not read the file first.
- Prefer the Edit tool for modifying existing files — it only sends the diff. Only use this tool to create new files or for complete rewrites.
- NEVER create documentation files (*.md) or README files unless explicitly requested by the User.
- Only use emojis if the user explicitly requests it. Avoid writing emojis to files unless asked.
```

---

## The convergence, distilled (for phase-2 synthesis + the harness handover)

Three vendors, three surface forms, but the *invariants* line up — and the
divergences map the design space:

| Concern | codex `apply_patch` | aider SEARCH/REPLACE | Claude Code `Edit` |
|---|---|---|---|
| **Match basis** | fuzzy — 3 lines context + `@@` anchors | exact — character-for-character | exact — `old_string` verbatim |
| **Disambiguation** | `@@ class`/`@@ def`, stacked | "enough lines to uniquely match" | uniqueness enforced; error if not unique; `replace_all` escape |
| **New file / delete / rename** | explicit headers (`Add`/`Delete`/`Update`+`Move to`) | new file = empty SEARCH; move = 2 blocks | separate `Write` tool; no rename primitive |
| **Read-before-edit gate** | (shell-mediated) | files must be "added to the chat" | hard error if not Read first |
| **Batching** | many file-ops in one envelope | many blocks, first-match each | one edit per call (or `replace_all`) |
| **Format goal stated to model** | "easy to parse and safe to apply" + full EBNF | rules + worked examples | terse usage bullets |

**What this witnesses for UDON + the harness:** an edit representation for agents
needs (a) an exact or reliably-anchored match basis, (b) a uniqueness/ambiguity
story, (c) first-class create/delete/rename, (d) a read-before-mutate
precondition, and (e) a decision about batching granularity. UDON's structural
addressing (paths/skeleton) is a *fourth* point in this space — an edit could
name a node instead of matching a string — which is exactly the kind of
demand-vs-affordance question synthesis should weigh these three against. All
three of these are string/line-oriented because their target documents have no
addressable structure; a structured document format could offer an edit schema
none of them can. That gap is the UDON-specific signal here.
