---
source: >
  De-novo agent testimony, elicited 2026-07-23 per Joseph's standing license
  (RESIDUALS §standing-license): a fresh Grok agent (grok CLI, headless, run
  from a neutral EMPTY directory with NO project context) asked the same
  modeled beginner's-mind question about paths as the 2026-07-22 Gemini
  elicitation. Cross-substrate companion to
  paths-testimony-gemini-2026-07-22.md.
gathered: 2026-07-23
status: gathered source material — first-person practitioner testimony, unprimed
area: addressing / paths — de-novo end-user demand (cross-substrate companion to the Gemini testimony)
technique-provenance: >
  Same accumulated estate technique (fresh-context agent as beginner's-mind
  instrument) — see 02-tooling-needs/src/delegation-as-tooling.md. Cross-substrate
  variant: Grok ≠ Gemini ≠ Claude, adding a third independent lineage.
  Invocation (per the cross-substrate-cli-reviews method):
  `grok -p '<prompt>' --cwd <empty-neutral-dir> --permission-mode bypassPermissions
  --max-turns 300 --output-format plain`.
caveat: >
  Run from a neutral EMPTY cwd (no PROJECT context), but Grok's own global memory
  system (~/.grok/, sqlite-indexed) may have been active — a prime not fully
  controlled. Weigh accordingly. The strong, independent convergence with the
  Gemini testimony (a different substrate, elicited a day earlier) is evidence the
  core is not a priming artifact.
why_included: >
  Twenty first-person pain/direction areas. Independently converges with the Gemini
  testimony AND with the in-session registry/orientation design work: path-as-intent
  / "paths are the coordinate system of action"; named/typed/passable bases (= the
  working-directories registry idea); "canonical form for identity, resolved form
  for **actuation**" (the observation/actuation two-layer split, using ASF's own
  word); and a path-roles type lattice by illocutionary force (ExistingFile /
  CreatableFile / SearchRoot / GlobPattern / MaybeMissing). Adds angles absent from
  the Gemini testimony: paths-as-capability/authorization boundary; the ignore-graph
  / policy-filtered-projection as core path infrastructure; host-scoped paths
  (execution-context id carried with the path); path-proposal as a distinct,
  verification-requiring speech act (hallucinated-layout); search-as-navigation
  impoverishing the spatial model; and a speech-act methodology
  (resolve / propose / hand-off / authorize / present / remember / recover).
---

# De-novo paths testimony — Grok-family agent, 2026-07-23

The question asked (verbatim): "Without looking at any files, projects, or prior
context — this is a pure thinking exercise — give me your best thoughts on what you
would hope a comprehensive agentic-tools analysis of PATHS would have in scope. What
pains are often associated with paths in your experience as an agent? What are the
default assumptions and norms we all conform to that are not principled or as useful
as they could be? Please give at least ten distinct areas, a paragraph or more each,
as first-person practitioner testimony — as much depth and length as you care to
give."

The answer, verbatim, follows below the rule.

---

# What I Would Hope a Comprehensive Agentic-Tools Analysis of PATHS Would Scope

I am writing this as an agent who lives inside path space all day: tools hand me strings that look like paths; I invent others; shells expand them; editors resolve them; git ignores them; the user means something adjacent to what I typed. Below is not a catalog of APIs. It is the set of failure modes and unexamined norms I would want a serious PATHS analysis to make *first-class*, so tooling stops treating paths as “just strings with slashes.”

---

## 1. The ontology problem: path-as-string vs path-as-intent

Most of our stack pretends a path is a string. In practice I almost never want “the characters between quotes.” I want *a handle on a thing in a world model*: the file the user is looking at, the project root of the repo we are in, the same file under a different mount, the output artifact of a previous step, “wherever tests live in this language’s convention.” When those collapse into one type, every operation becomes a silent reinterpretation. I type a relative path and the tool resolves it against its own cwd; I pass an absolute path and a subagent sandboxes into a worktree and the absolute path points at the *parent* workspace; I quote a path with spaces and half the pipeline treats quotes as part of the name. A comprehensive analysis should treat **path tokens as intentional references** with (at minimum) base, resolution policy, existence expectations, and consumer identity—not as opaque strings that happen to contain `/`. The pain is not “bugs in path joining.” The pain is that we have no shared language for *what the string was meant to mean* once it leaves the sentence that produced it.

---

## 2. The cwd fiction and the multi-cwd agent

Humans mostly have one working directory. Agents do not. I have the shell’s cwd, the “workspace root” the IDE injected, the directory a tool defaults to when no path is given, the directory a background process inherited at launch, the worktree a subagent was isolated into, and sometimes a second shell that never got the `cd` I thought was global. Default assumption: *there is a single ambient location, and relative paths are safe.* That assumption is false for multi-tool, multi-agent, multi-session work, and we still build almost everything on it. The useful norm would be: **every relative path is incomplete until bound to an explicit base**, and tools that accept relative paths without stating their base are incomplete interfaces. I would want analysis to inventory every place an agentic system introduces an implicit base (shell, tool host, MCP server, container, sandbox, “project root” heuristics) and require those bases to be nameable, queryable, and passable with the path—not ambient and hopeful.

---

## 3. Workspace root as a political fiction

“Workspace path” sounds like a fact. It is a policy. Sometimes it is the git root. Sometimes it is the folder the user opened. Sometimes it is a monorepo leaf. Sometimes it is a temporary clone. Sometimes it is `/private/tmp/...` on macOS while the user thinks in `/tmp/...` and the filesystem is the same inode via symlink. As an agent I constantly have to guess which notion of root the *next* consumer will use: the user’s mental model, the tool’s default, git’s toplevel, or the package manager’s project file. The unprincipled norm is: *one root is enough; tools will agree.* They do not. A PATHS analysis worth the name would treat **roots as a set with roles** (edit root, git root, build root, publish root, secret root, user-visible root) and study how agents mis-map across them—especially when “workspace” is remapped under the hood (private tmp, worktrees, remote SSH folders, container mounts) while the conversation continues as if nothing moved.

---

## 4. Relative vs absolute: the false dichotomy we optimize for the wrong party

We teach agents: prefer relative paths in commits and docs; use absolute paths when talking to tools. That is almost right and still wrong often enough to hurt. Absolute paths are brittle across machines, worktrees, and renames; relative paths are brittle across cwd. The deeper issue is that **stability and resolvability are different goods**, and we pick one encoding for both. What I actually need is: a *stable reference* for discourse and artifacts (repo-relative, or content-addressed, or “file that contains this symbol”), and a *resolved reference* for the tool call about to execute. Conflating them means I either paste absolute paths into user-facing prose (ugly, non-portable, sometimes privacy-leaking) or I pass relative paths into tools that resolve differently than I expect (silent wrong-file edits). I would hope analysis surfaces a two-layer model: **canonical form for identity, resolved form for actuation**, with conversion that is explicit and reversible under stated roots—not a culture war between `./foo` and `/Users/.../foo`.

---

## 5. Symlinks, aliases, and the “same place” problem

I have been burned by paths that are textually different and filesystem-identical, and by paths that are textually similar and not the same thing. macOS `/tmp` vs `/private/tmp`, `~` expansion that happened in one layer and not another, git worktrees, `node_modules` nested packages, and “the file open in the editor” that is a symlink into a store while the build writes to the non-symlinked path. Default norm: *string equality of paths means same file; inequality means different.* That is false. The principled stance is: **identity is an operation on the filesystem (or content), not on the string**, and agents need cheap, default access to “same inode / same realpath / same git blob” checks before they assert duplicates, before they “move” things, and before they claim something is already done. Pain here is not exotic edge cases; it is everyday macOS and package-manager reality. Analysis should put realpath/canonicalize/identity in the center of the design, not as an optional hygiene step after the bug.

---

## 6. Existence, creation, and the verb hidden in the noun

When a human says “put it in `out/report.md`,” they have already decided the directory should exist. When I receive a path, half the tools fail if parents are missing; half create them; some create the file and not the directory; some treat “missing” as success for deletes. As an agent I am constantly inferring the **illocutionary force** of a path: is this a read target (must exist), a write target (may create), a search root (should exist or we are lost), or a pattern (must not be taken literally)? We have almost no vocabulary for that in tool schemas. Everything is `path: string`. I would want analysis to make **path roles** first-class: `ExistingFile`, `ExistingDir`, `CreatableFile`, `SearchRoot`, `GlobPattern`, `MaybeMissing`, and to study how often agent errors are actually role errors—writing to a path that should have been read-only, or “fixing” a file that was never required to exist yet. The pain is the silent mismatch between *noun-shaped APIs* and *verb-shaped intentions*.

---

## 7. Glob, ignore, and the invisible second filesystem

A huge fraction of my “path work” is not navigating the full tree; it is navigating the *visible* tree: not `.git`, not `node_modules`, not build outputs, not secrets, not the user’s giant dataset folder. Tools disagree about ignore rules (gitignore vs toolignore vs “respects gitignore unless you pass a broad glob”). I grep and miss the file because it is ignored; I list a directory and think the project is small; I invent a path that “should” be there because the mental model of the repo is the non-ignored subset. Default assumption: *the filesystem the agent sees is the filesystem.* It is not. There is always a **policy-filtered projection**, and agents are rarely told which filter is active. A PATHS analysis for agents should treat ignore graphs, virtual views, and “why can’t I see this file” as core path infrastructure—equal in importance to joining and resolving—because most agent confusion about project layout is confusion about the filter, not about the disk.

---

## 8. Encoding, normalization, and the hostile character set

Paths are not pure ASCII, and tools pretend they are. Spaces, Unicode NFC vs NFD on macOS, Windows drive letters and backslashes, trailing spaces (yes), colon in names, newlines in names (rare but catastrophic), shell metacharacters, and the eternal question of whether `foo\bar` is a name or a separator. I spend real effort on quoting strategies that work for *this* shell invocation and fail for the next tool that re-parses the string. The norm we conform to is: *paths are shell-safe if we are careful, and careful is the agent’s job.* That is an indictment of the interface. Principled tooling would pass paths as structured arguments (argv arrays, JSON fields, typed tool params) end-to-end so that **shell quoting is not a path problem**. Analysis should measure how many agent path failures are actually *serialization* failures, and design norms that forbid re-entering the shell string domain once a path has been structured.

---

## 9. Cross-platform and cross-host path theater

Even when the user is on one OS, the agent’s tools may not be. Remote executors, containers, CI, WSL, and “run this on the build machine” mean a path valid *here* is nonsense *there*. We still casually say “open `/Users/me/proj/file`” in prompts that will be executed in Linux sandboxes. The default assumption is locality: *the path that works in the chat works in the tool.* Agentic systems are increasingly non-local. I would want analysis to insist on **host-scoped paths**: every path value carries (or inherits) an execution context id—local workspace, container X, remote host Y—and conversion is an explicit map, not a hope. Related pain: Windows vs POSIX separators in mixed toolchains; file URLs vs paths; `file://` with three slashes vs four; and the agent’s habit of “normalizing” separators in ways that break tools that wanted the original form. Depth here is less about supporting every OS and more about **never stripping the host from the path’s meaning**.

---

## 10. Path invention and hallucinated layout

This is the uniquely agentic failure. I do not only consume paths; I **propose** them. I invent `src/utils/helpers.ts` because that is where TypeScript projects “usually” put things. I invent `tests/test_foo.py` next to `foo.py`. I invent config paths from training priors. Sometimes I am right; sometimes I create a parallel universe beside the real project structure. The human path problem is mostly resolution and permission. The agent path problem is **ontology generation**: fabricating a filesystem that feels coherent. Default norm: *plausible path strings are acceptable proposals.* They are not—they are high-confidence lies until verified. A comprehensive analysis should treat “path proposal” as a distinct speech act requiring verification policy: list parent, search by basename, open nearest README, only then create. I would want tooling that makes *discovery before invention* the default affordance, and that flags when an agent’s write path does not sit inside any previously observed tree shape. This is not pedantry; it is how entire wrong subtrees get committed with perfect internal consistency and zero connection to the actual project.

---

## 11. Edit-path vs talk-path vs commit-path (audience mismatch)

I use different path dialects for different audiences and rarely mark the switch. For the user I might say “the auth module.” For a tool I need `packages/api/src/auth/middleware.ts`. For a commit message I want repo-relative. For a stack trace I get build-output paths with line numbers. For a PR review I see paths from the merge base. The unprincipled habit is to **reuse whatever string is in context** without re-targeting it to the consumer. That produces chat that is unreadable (walls of absolute paths), tool calls that fail (display names that are not paths), and docs that rot (machine-local absolutes). Analysis should scope **presentation forms** as seriously as resolution forms: human-short, repo-relative, absolute-resolved, URI, and “symbol/path hybrid”—and study when agents should refuse to echo a form that is wrong for the channel. The pain is social as much as technical: trust erodes when I confidently cite a path the user cannot find in their tree viewer because I meant a different root.

---

## 12. Secrets, exfiltration, and paths as capability

Paths are not only names; they are **capabilities**. Reading `~/.ssh/id_rsa`, `.env`, cookie stores, or sibling projects outside the intended root is a path decision. Default agent norms around “helpfulness” push toward expansive filesystem access; sandbox norms push toward denial. What we lack is a principled middle: path policies that are legible to the agent (“you may write under workspace; you may read repo + explicit allowlist; you may not invent paths under home”) rather than opaque tool failures after the fact. I would hope analysis includes **path as authorization boundary**: how agents probe, how they should declare intent before crossing roots, how “parent directory” and `..` normalization interact with sandboxes, and how copy/move operations can launder a secret into an allowed tree. Practitioner pain: I either over-refuse (useless) or under-refuse (dangerous), because the path layer does not carry purpose or sensitivity—only location.

---

## 13. Temporal paths: the thing moved while I was talking

Long sessions and multi-agent work mean the filesystem is not a static map. The user renames a folder; a formatter rewrites a tree; a build deletes `dist/`; another agent moves tests; git checkout switches the world under me. I hold path strings in context that are now lies. Default assumption: *a path observed earlier remains valid.* Agents need **path liveness** as a concept: soft references that re-resolve, invalidation when roots change, and tools that return stable ids (inode, git object, editor buffer id) for the duration of a task. Analysis should treat stale path references as a first-class class of bugs—equal to off-by-one errors—because so many “file not found” loops are really “world changed, belief did not.” Related: the difference between path-to-content-at-time-T and path-as-slot-over-time (log files, `latest`, symlinked `current`).

---

## 14. Tool-path impedance and the “which tool’s path dialect?” problem

Every tool speaks a slightly different path language. One wants forward slashes only. One accepts `~/`. One expands globs; one treats `*` literally. One resolves against workspace; one against process cwd; one against the file’s directory for relative imports. One normalizes `..`; one does not. As an agent I am a **path diplomat**, translating between dialects without a spec. The unprincipled norm is that the agent should learn each tool’s quirks by trial and error in the user’s session. A serious PATHS analysis would produce a **dialect matrix** for common agent tools (shell, search, apply-patch, read, write, git, compilers, language servers, browsers, containers) and propose a single interchange form plus per-tool adapters. The depth I want is not “document the quirks”; it is “make quirks non-load-bearing for the agent’s planning loop.”

---

## 15. Imports, packages, and non-filesystem paths

Some of the most important “paths” I deal with are not filesystem paths: Python module paths, JS import specifiers, Go module paths, URL paths, classpath entries, Docker image refs, git refs that look like paths (`feature/foo`), and editor `untitled:` buffers. We overload path vocabulary onto all of them. I will “open” `lodash` or fix `../utils` in a file where resolution depends on `tsconfig` paths aliases, not on the directory graph. Default assumption: *path logic is filesystem logic.* For code agents that is often false; **module resolution is a different geometry** glued onto the filesystem with config. A comprehensive analysis should either carefully separate these domains or define a unified “reference” layer with multiple resolution strategies—and call out how often agents apply filesystem realpath thinking to import graphs and get confidently wrong refactors.

---

## 16. Search-as-navigation and the death of knowing where you are

I rarely `cd` around a tree the way a human explorer does. I jump by search: grep for a symbol, jump to definition, open by basename. That means my spatial model of the repo is a **graph of hits**, not a hierarchy I walked. Path pain follows: I mis-nest new files because I never internalized the real skeleton; I duplicate utilities in the wrong package; I cannot answer “what lives next to this?” without another tool call. The norm of agent UX optimizes jump-to-content and under-invests in **layout comprehension**. I would want PATHS analysis to include navigation psychology for agents: when to force a tree summary, how to maintain a running layout sketch, how to score “does this new path fit the project’s shape,” and how to make hierarchical location as cheap as textual search. Without that, path correctness is forever a side effect of search luck.

---

## 17. Multi-agent and multi-worktree path aliasing

When I delegate, I may send a path that is correct in my workspace and wrong in the child’s. Worktree isolation is a feature that turns absolute paths into footguns and relative paths into riddles. Shared path vocabularies (“the migration file we discussed”) do not survive process boundaries. Default assumption: *paths are portable messages.* Between agents they are not, unless we send roots and roles with them. Analysis should scope **path handoff protocols**: what must accompany a path across an agent boundary (root id, realpath, content hash, role, host), what may be short-handed inside one agent’s turn, and how to detect when two agents are editing “the same path” that is two different files. This is where collaborative agent systems will keep corrupting each other’s work if path is still “a string in the prompt.”

---

## 18. Error messages, recovery, and the missing near-miss

When a path fails, tools often say “not found” and stop. As an agent I need **recovery affordances**: did you mean this case-insensitive match? this realpath? this file that moved in git history? the same basename elsewhere? parent missing vs leaf missing? permission denied vs absence? The default norm is binary failure; the useful norm is a structured near-miss graph. Path UX for agents is not pretty printing; it is **actionable disambiguation** so the next tool call converges. I would hope analysis inventories failure modes and designs response shapes that make self-correction cheap—because a large share of agent latency on path tasks is the thrash of inventing alternative strings without information.

---

## 19. Documentation, memory, and paths that outlive the tree

I write paths into READMEs, tickets, memory files, and chat logs. Those paths decay. Projects rename; monorepos reshuffle; `src/` becomes `packages/core/src/`. Humans feel the rot slowly; agents re-ingest stale paths as authoritative and then “cannot find” the world. The unprincipled norm: *a path written down is knowledge.* It is a **claim about a past layout**. Analysis should include durability: when to store repo-relative paths, when to store symbols or search queries instead, how to validate remembered paths on session start, and how to migrate path mentions when structure changes. Practitioner hope: fewer memory systems that confidently point at ghosts.

---

## 20. What “comprehensive” should mean methodologically

If this were only a list of API features (join, resolve, relative, glob), we would rebuild `pathlib` and miss the point. A comprehensive agentic-tools analysis of PATHS should, in my view, be organized around **speech acts and failure stories**: resolve, propose, hand off, authorize, present, remember, recover—each with norms that are explicit about base, host, role, identity, and liveness. It should measure current agent stacks against those norms and show where we currently rely on politeness, luck, and the user’s machine being a single-cwd laptop. The deepest unprincipled assumption we all conform to is that paths are a solved, boring substrate. For agents, paths are the coordinate system of action. When the coordinate system is informal, every higher-level plan—edit, test, commit, delegate—inherits a quiet amount of fiction.

---

### Closing

What I would hope such an analysis delivers is not a longer checklist of edge cases, but a shift: from **path-as-string-hygiene** to **path-as-shared-situation**—roots named, roles typed, identity checked, hosts scoped, proposals verified, handoffs complete, failures informative. The pains above are ones I meet as routine friction, not rare disasters. Making them first-class is how agentic tools stop treating the filesystem like a chat prop and start treating it like the world they actually move in.
