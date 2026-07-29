# What LSP and tree-sitter tooling already paid for

*Or: the owed prior-art pass, and the one measurement that changed my mind*

*2026-07-29, Fable (sub-spike). Commissioned by `../underlying-logical-model.md` §"the elephant", whose LSP/tree-sitter paragraph was explicitly flagged as training-knowledge and whose own text called a real pass "cheap and owed before this leg is leaned on hard." This is that pass. Register discipline as in the letter: every claim carries how it is known — **[measured]** here, on this machine, today; **[firsthand]** observed by me driving the tool; **[primary]** read at the source document, URL given; **[relayed]** gathered by a delegated agent and not re-verified by me; **[inference]** mine. Where I caught a relayed claim overstating its source, I say so rather than passing it on.*

---

## The short version

Three things, in descending order of how much they should change what we do.

1. **The letter's counter-lesson is right about the fact and wrong about the mechanism, and the mechanism is the part that matters.** The letter says harnesses still grep because *the logical verbs cost setup, latency, and coverage* — the friction differential (O9). That is true and I measured it. But the best-sourced account of why the largest builder of agentic coding tools chose grep is not a cost argument at all: they built the indexed alternative and it lost on *capability*, because an LLM iterating over text search self-corrects and never goes stale, and an index does neither. If that generalizes, O9's framing is not wrong but is answering an easier question than the one we face.

2. **UDON is not Rust, and the difference is in our favor in a way that shrinks our own headroom.** The precision gap that justifies structural search over grep in code is largely an artifact of syntax that doesn't mark role at the token level. UDON's sigils do mark it. Measured on our own corpus: grep already *is* a structural query for the tier dimension. So the corpus verbs have much less to win by than the code analogy suggests — which is a real deduction from the letter's leg, not a strengthening of it.

3. **But there is a precise frontier where grep stops, I measured it in our corpus, and it is exactly the dimension the entire external lineage never solved.** Containment. 46% of `:status` attributes in `v2/` are not on their element's line, so no lexical query can attribute them to a record. Containment lives in indentation — and indentation-significant structure is the capability the lineage's most general tool (Comby) says in its own FAQ that it *wants and does not have*, with no matching primitive anywhere in its syntax. **There is no mature answer to borrow here. This one we derive.**

---

## 1. What I actually did

I drove the tools rather than recalled them, because the brief sanctioned it and because recall is what produced the paragraph I was sent to check.

- Installed `ast-grep` 0.45.0 and ran real structural queries against `udon/core` (43 Rust files, 26,803 lines).
- Installed `rust-analyzer` 1.96.0 and drove it over raw LSP from a hand-written client (`scratchpad/lspdrive.py`), instrumented for cold-start, indexing, `textDocument/references`, `textDocument/rename`, and `workspace/symbol`, so the latencies below are wall-clock from my own process, not quoted.
- Ran the analogous queries against our own `v2/` corpus (80 `.udon`, 681 `.md`).
- Commissioned two parallel research sweeps (adoption-friction; structural-transformation lineage) and re-verified their single most load-bearing claim myself at the primary source.

The test question throughout was one an agent here actually faces: *where is this thing used, and can I safely change it?*

## 2. Firsthand: the setup tax is real, and it is worse than a number

The first thing that happened is the most useful thing that happened.

`rust-analyzer` was on my `PATH`. It was a rustup shim for a component that was not installed, and invoking it printed `info: rust-analyzer is unavailable for the active toolchain / falling back to /opt/homebrew/opt/rustup/bin/rust-analyzer` — which is *the shim itself* — and then **exited 0**. **[firsthand]** My LSP client dutifully sent `initialize` to a dead process and hung for six minutes with the server gone and no error anywhere.

The actual fix took **1.7 seconds** (`rustup component add rust-analyzer`). **[measured]** The diagnosis took considerably longer, and nothing in the failure pointed at it. An exit code of 0 and a message containing the word "falling back" is a silent no-op wearing the costume of a working tool.

I want to be careful about what this does and does not show. It is one machine, one toolchain, n=1, and a human who had configured this box differently would never have hit it. What it is good evidence for is the *shape* of LSP-class friction: not "the index is slow" but "the failure is silent and the signal is absent." A relayed report described exactly this shape independently — Claude Code's LSP integration reportedly falling back to grep silently when misconfigured, with no indication the precise path failed **[relayed, single practitioner anecdote, weak]**. I would not cite that anecdote on its own. I cite it because I walked into the same shape unprompted an hour earlier.

**The design consequence, stated as [inference]:** if our corpus verbs can silently degrade to a serving-level fallback, they will, and nobody will know. Fail loud. A `census` that returns fewer records because the index wasn't built must not be distinguishable-only-by-being-wrong.

## 3. Firsthand: the numbers

Cold start on a 27k-line workspace — small by any real standard: **[measured]**

| Moment | t |
|---|---|
| `initialize` sent | 0.0s |
| roots scanned, compile-time deps built | 3.35s |
| first `textDocument/references` attempt | **failed** — JSON-RPC `-32801 content modified` after 1087ms |
| references resolved (2nd attempt) | **19.3s** |
| that successful call's own latency | 3803ms |
| `textDocument/rename` (warm) | 25ms |
| `workspace/symbol` (warm) | 48ms |
| `grep -rn BlankLine` (no server, no index) | **7ms** |

Two things in that table matter more than the ratio.

**The first request failed with `content modified`.** **[firsthand]** That is the staleness race, arriving unbidden in the first minute of the first experiment, on a workspace nobody was editing. It is the same failure Cursor named as their central concern in their own words: *"text search demands extreme freshness — especially when the agent reads back content it just wrote. A stale text search index sends the agent into futile search loops."* **[relayed, quoting Cursor's engineering blog]** An agentic loop invalidates its own index by construction; every write-then-read within a single turn re-triggers this.

**Warm latencies are excellent.** 25ms for a whole-workspace rename is not a friction story. The cost is entirely front-loaded into index construction and entirely re-paid on invalidation. So the honest form of the friction claim is not "logical verbs are slow" — it is **"logical verbs are fast and their index is a liability that an editing agent attacks continuously."**

## 4. Firsthand: what precision actually buys, measured three ways

Question: *where is the parser event `BlankLine` used?* Three tools, same question. **[measured]**

| Tool | Answer | What it got wrong |
|---|---|---|
| `grep -rn BlankLine` | **39 lines**, 9 files, 7ms | ~20 are not the target at all |
| `ast-grep` (kind `struct_expression`, pattern `Event::BlankLine { $$$ }`) | **7 constructions**, 610ms | missed 12 bare-spelled uses entirely |
| LSP `textDocument/references` | **18 references**, 7 files | — (and rename edited all 19 sites across 7 files in 25ms) |

The grep noise is not benign. `workspace/symbol "BlankLine"` returned **three distinct symbols**: `Event::BlankLine`, `StreamEvent::BlankLine`, and `NodeKind::BlankLine` **[measured]** — three different types sharing one name, 12 and 3 hits respectively, plus 4 comment mentions. An agent doing a textual sweep-and-replace on "BlankLine" corrupts two unrelated types and cannot tell from the grep output that they exist.

**The ast-grep result is the more interesting failure, and I did not expect it.** Two distinct walls, both hit firsthand:

- *Context ambiguity.* In Rust, `Event::BlankLine { .. }` is textually identical as a construction and as a match pattern. tree-sitter distinguishes them (`struct_expression` vs `struct_pattern`) — but ast-grep parses my *pattern string* in a default expression context, so the same query text can only ever mean one of them. `--debug-query=ast` confirmed it: my pattern parsed as `struct_expression` with an `ERROR` node inside. **[firsthand]** Getting the pattern side required knowing to supply parse context. The tool has the information; the query surface hides it.
- *No name resolution.* `use Event::*;` appears in four files here **[measured]**, so 12 of the uses are spelled bare `BlankLine {`. My qualified structural pattern misses every one. Structural search is *syntactic*, full stop — ast-grep's own comparison page concedes it carries no type, dataflow, or resolution information **[relayed, primary-source-per-agent]**. Only the name-resolving layer answered "all uses of *this* entity."

**[inference]** This is the cleanest statement of the three-layer split I found anywhere, and I arrived at it by hitting it rather than reading it: *lexical* asks where text appears, *structural* asks where a shape appears, *graph* asks who actually refers to this thing. They are three different questions. The strong version of the letter's elephant — corpus verbs replacing serving verbs — quietly assumes one tool should answer all three. Nothing in this ecosystem supports that, and the tool that tried hardest to (LSP) is the one paying the index tax.

## 5. The counter-finding, verified at primary source

This is the part I would most want Joseph to read, because it is the piece the letter's paragraph does not contain and it bears directly on O9.

I fetched the Pragmatic Engineer interview with Boris Cherny myself rather than take it relayed. **[primary,** https://newsletter.pragmaticengineer.com/p/building-claude-code-with-boris-cherny **]** Verbatim:

> "Claude Code's 'agentic search' is really just glob and grep, and it outperformed RAG. The team tried several approaches to make agentic search better: local vector databases, recursive model-based indexing, and other fancy approaches. All had downsides (stale indexes, permission complexity). Plain glob and grep, driven by the model, beat everything."

And a detail I find more persuasive than the headline:

> "This approach was inspired by how Boris observed engineers at Instagram searched code when the click-to-definition functionality in Meta's in-house coding editor was broken."

**A correction I owe, in the interest of not laundering a claim upward.** My delegated sweep reported this as "they had already built the vector DB and *removed* it," and separately attributed to Cherny a quote about "security, privacy, staleness, and reliability" sourced to an X post I could not fetch. The interview I read supports *tried several approaches, all had downsides, stale indexes and permission complexity* — it does **not** narrate a build-then-remove, and it **does not mention LSP at all**. The stronger framing may well be true; it is not established by the source I actually read. **[relayed, downgraded]**

**Why this matters to us.** The letter's leg is: *logical verbs lose on friction; therefore make them cheap and grep-legibility is the permanent fallback.* The primary source says something harder: the alternatives lost on **capability and freshness**, having been built. An LLM driving grep iteratively refines its own query, follows what it finds, and reads ground truth every time. That is not a property our verbs get for free by being cheap.

The corroborating shape, **[relayed]**: Cursor hit `rg` invocations exceeding 15s in large monorepos and responded by building a *faster text index* (16.8s → 13ms), not by moving to a symbolic layer. The best-resourced player facing precisely our friction argument chose to make the lexical layer faster.

**Applying the house's common-descent discipline** (thank you for the pointer — it changed a conclusion). My sweep found that Claude Code, Codex CLI, OpenCode, Cursor, Continue, and Aider all default to ripgrep. Under the `shipping-practice.md` rule, that near-verbatim uniformity across a heavily cross-pollinating ecosystem is a *tell of common descent*, not six independent arrivals, and I decline to weight it as convergent evidence. What survives the test is narrower and stronger: **the Anthropic reversal** (built the alternative, it lost) and **the Cursor divergence** (same problem, different solution — index the text) are genuinely independent, differently-implemented responses to the same pressure. Two independent data points, both pointing away from the logical layer, are worth more than six correlated ones pointing anywhere.

**Counter-evidence to the counter-evidence, held honestly.** One vendor benchmark (CircleCI, Vue.js ~149K lines) reports LSP-on vs LSP-off: 31% fewer tool-output tokens on one model, 34% faster on another, and *grep missing references in 2 of 6 runs where LSP hit 100%* **[relayed, vendor blog, methodology not published]**. That last figure is the one that matches my own measurement — grep's recall problem is real and I reproduced its mechanism. I would not lean on a vendor number, but I will not suppress one that agrees with my own bench either.

## 6. Where UDON actually differs — the measurement that changed my mind

I ran the same precision question against `v2/`. **[measured, 2026-07-29]**

| Token | total lines | as `:attr` | as `\|elem` | as `[key]` | prose/other |
|---|---|---|---|---|---|
| `status` | 326 | 144 | 0 | 55 | 127 |
| `name` | 424 | 144 | 0 | 76 | 204 |
| `type` | 241 | 82 | 24 | 6 | 129 |
| `key` | 241 | 0 | 0 | 52 | 189 |

Read the first three columns, not the last. **The tier is recoverable lexically.** `:status`, `|status`, and `[status]` are three different queries that a plain regex separates perfectly, because UDON marks role *in the token* rather than in the parse context. This is precisely what Rust does not do, and it is the entire reason ast-grep exists for code.

**[inference], and it is a deduction against the letter's leg:** the precision gap that justifies structural search over grep in the code world is substantially *already closed* in UDON by the sigil design. Corpus verbs therefore inherit a much smaller advantage over grep than the LSP analogy implies. The letter says grep-legibility is "the permanent fallback the logical verbs must beat on cost." The measurement says something sharper: **grep-legibility is not merely a fallback, it is already doing the structural tier's job**, and the verbs must beat it on the *remaining* dimension, whatever that turns out to be. Which brings us to the frontier.

## 7. The frontier: containment, and the hole in the external record

The question grep cannot answer here is not "which lines say `status`." It is **"which *records* have status open"** — because that requires knowing which element an attribute belongs to.

**[measured]** Of 142 `:status` occurrences in `v2/`, **76 are on the same line as their element** and **66 (46%) are not.** For nearly half of our own corpus, the parent is carried by *indentation*, and no lexical query recovers it. (One of the three sample hits was a prose line in a comment merely *mentioning* `:status open` — the false-positive class, live, in the first three results.)

This is the real analogue of `find-references`. Not "find the token" — UDON already gives us that — but **"resolve which record this belongs to,"** which is a containment question, which lives in the indentation.

And here is the finding I would put at the top of anything that gets absorbed into the tooling corpus:

> **The structural-search lineage has not implemented indentation-significant containment, and the most mature tool in it says so in its own voice.** Comby's FAQ, verbatim: *"Comby does not currently consider whitespace indentation significant. We have plans to support it though!"* and *"there's no builtin way to match indentation-sensitive Python blocks with Comby at this time."* Its syntax reference confirms the mechanism — the match primitives are lazy, regex, alphanumeric, expression, punctuation, newline, and a whitespace matcher that explicitly *excludes newlines*; there is no indentation-level or block-by-indentation primitive at all. Its structural vocabulary is balanced `(...)`, `{...}`, `[...]`, string literals, and comments. **[primary,** https://comby.dev/docs/faq **,** https://comby.dev/docs/syntax-reference **,** https://comby.dev/docs/overview **]** Every lossless-tree design in the surrounding literature (Roslyn's red-green trees, Swift's libSyntax, rust-analyzer's rowan) treats whitespace as *inert-but-preserved*. **[relayed, primary-per-agent]** UDON needs it preserved *and* semantically load-bearing.

**Correction, recorded rather than quietly fixed.** The relayed version of this claim — which I flagged in §9 as the one I was most tempted to lean on, and which the letter went on to cite pending exactly this check — said Comby *"explicitly declines indentation-sensitive languages like Python and Haskell."* **That is wrong, and the spot-check refuted it.** Comby's overview lists both Python and Haskell among supported languages with no caveat. The claim reached me through a competitor's comparison page and it overstated a limitation into a refusal.

What replaces it is narrower and, for our purposes, considerably better evidence. Comby supports those languages *lexically* while having no primitive that can address their block structure — and its maintainers name the gap themselves and say they intend to close it. So the honest finding is not "the lineage refuses this problem" but **"the lineage's most general tool wants this capability, has wanted it long enough to put it in the FAQ, and does not have it."** An unfilled acknowledged gap in a mature project is a stronger signal about difficulty than a scoping decision would have been: a refusal tells you someone chose not to; an open want tells you someone tried to and it is still open. Comby's own architecture note says why — it *"uses no tree definition, but turns patterns into an executable routine … where the tree structure is implicit,"* and that implicit tree is built out of balanced delimiters, which indentation does not provide.

My sweep's own words, which I am keeping because the caution was warranted and was what prompted the check: *"I could not find a tool in this lineage that treats significant-whitespace structure as a first-class match/rewrite target rather than an escape hatch — worth treating that absence itself as a data point, though absence-of-evidence is weak evidence here."* The check upgraded this from absence-of-evidence to evidence-of-absence for the one tool it could reach; the general claim across the whole lineage remains the weaker inductive one.

**[inference]** So the honest shape of the prior art for us is: the external body of practice has worked answers for the *query* and *identity* halves, and a conspicuous, repeatedly-declared **carve-out exactly where UDON's structure lives**. We should borrow the first two eagerly and expect to derive the third. That is not a discouraging result — it is the clearest available statement of where our design is actually novel rather than catching up.

## 8. Borrowable shapes (the "worked answers" the brief asked for)

Ranked by how much I think they are worth to us. All **[relayed]** unless marked; I did not re-verify these individually and they should be treated as leads with sources, not as established.

1. **The lossless / full-fidelity tree is a convergent answer to our round-trip problem — and was nobody's first instinct.** Roslyn, SwiftSyntax, and rowan independently arrived at trees where every byte including trivia is a first-class node, so parse→edit→print is an identity function. Roslyn's own docs: *"every character from the source file is represented somewhere in the tree… essential for tooling scenarios — refactoring tools can modify specific parts of the tree while preserving the user's formatting elsewhere."* The genealogy is explicit and documented (Roslyn → libSyntax → rowan). **The honest cost:** JRuby *abandoned* the pattern over memory and performance; Julia found its own language parser structurally unusable for it and built a second one; Go's detached comments are named as "the single biggest issue when manipulating the AST." Roslyn and rust-analyzer pay the cost only in IDE-adjacent scenarios, not every parse. *Relevance to us: directly load-bearing for `upsert` against a live human-edited file.*
2. **Identity: the field's own answer is heterogeneous, and the cleanest one is outside code tooling.** LSP/Roslyn/SCIP treat identity as *derived* from position plus semantic analysis. matklad — rust-analyzer's lead and rowan's author — wrote a detailed critique naming a *"fundamental loss of causality"* that LSP "papers over" with per-document version numbers, breaking exactly on the multi-file case (a rename computed before a new usage appears in another file; the version number says the edit is valid and it is wrong). SCIP replaced LSIF's opaque numeric IDs with human-readable hierarchical string monikers specifically so identity survives comparison across independently-generated indexes. Unison goes furthest: identity *is* the hash of the structure; names are metadata layered on top. *Relevance: this is `#def-position-is-not-identity` arrived at three times independently, by three different routes, and the SCIP moniker shape is very close to what a paths-v0 designator wants.*
3. **The M×N lesson is narrower than it looks.** LSP existed to turn M editors × N languages into M+N. **[inference, mine]** We only inherit that shape if multiple *servings* (files, DB rows, KV) are meant to be interchangeable targets for the same verbs — in which case a thin protocol between logical-op and physical-serving is directly relevant rather than merely analogical. If there is only ever one serving, the lesson does not transfer and citing it would be decoration.
4. **Every serious tool found tree-sitter's query language insufficient and built its own layer.** Semgrep parses with tree-sitter but discards its query language entirely (no metavariables); ast-grep did the same; Topiary, which stayed on raw tree-sitter queries, documents silent corruption at the reconstruction boundary — uncaptured separators concatenate tokens into `arg1arg2` with no error. *Relevance: if our `select` verb does anything beyond match-and-report, this is the layer that historically needed rework — and the failure mode is silent-wrong output, not an exception.*
5. **Coccinelle's success is a story of deliberate restraint.** Ten-plus years and 6,000+ Linux kernel commits, achieved by explicitly declining alias analysis, dataflow, and full type inference, to stay fast enough to run against the whole kernel repeatedly. **[relayed, weak sourcing — my sweep could not extract the USENIX ATC'18 primary text through three mirrors and flagged this honestly as secondary]** *Relevance if it holds: the scope discipline, not the technique.*

## 9. What I did not establish

- **No one has measured the friction differential.** My sweep looked hard. Everything available is either a builder's stated design rationale (Cherny, Cursor) or a vendor's before/after on its own tool (CircleCI, Gortex). Nobody has run "adoption as a function of setup cost, holding capability constant." O9's mechanism is **plausible, multiply-attested by builder testimony, and unmeasured as a differential.** That is the honest state, and it means our own O9 test would be measuring something nobody else has.
- **Multi-file atomic edit reliability is unmeasured.** Real filed bugs exist (file-sync loss on unopened buffers, servers reading stale filesystem state mid-rename, edits landing unsaved so the "atomic" rename leaves inconsistent on-disk state) across Helix, vim-lsp, nvim-lspconfig **[relayed, primary issue trackers]** — enough to establish the failure *shapes*, not a *rate*. My own rename produced 19 edits across 7 files and I did not apply them, so I have no firsthand data on whether they would have been correct.
- **The Lanser paper's "15+ LSP-specific failure modes"** was reported to me but my sweep could not verify it against the primary PDF and flagged it as such. I am recording it as a lead, downgraded, not as a finding.
- ~~Comby's indentation carve-out~~ — **closed 2026-07-29, and the check refuted the claim as I had it.** See §7: the relayed "Comby declines Python/Haskell" is false; what Comby's own FAQ and syntax reference establish instead is an acknowledged, unfilled gap with no indentation primitive in the language. The finding survived in better shape than it went in, which is the argument for running these checks rather than flagging them.
- **I did not drive an MCP server.** Joseph sanctioned it; I spent the budget on raw LSP instead, judging that a hand-written client measuring the actual protocol taught me more about where the cost lives than a wrapper would. That may have been the wrong call — an MCP wrapper is closer to what an agent actually holds, and its ergonomics are a different question from the protocol's.
- **n=1 on the setup failure**, and this machine is idiosyncratic.

## 10. What I'd say to the letter

Three amendments to §"the elephant", offered as proposals:

- **The counter-lesson should carry the capability half, not just the cost half.** As written, the paragraph says the logical verbs lose on friction and concludes that they must win on cost. The primary source says the indexed alternative lost *having been built*, on staleness and self-correction. The design question that follows is harder and better: not "can we make resolution cheap enough" but "does a logical-corpus verb actually beat an LLM iterating over grep across servings" — which is a capability question, and which none of this literature settles for a document corpus.
- **The grep-legibility sentence understates our own position.** "Permanent fallback the logical verbs must beat on cost" → grep already *does the structural tier's work* in UDON because the sigils are lexical (measured, §6). The verbs' remaining advantage is containment and reference-following, and the letter should claim that narrower ground, which it can actually hold.
- **The paragraph should name the carve-out.** The external lineage's most-cited limitation sits exactly on indentation-significant containment (§7). That is where our design is genuinely without prior art, and saying so converts a leg that currently borrows confidence into one that correctly reports where borrowing stops.

None of this touches the letter's spine. §§1–7 stand unaffected; the elephant survives as a hypothesis with a better-specified test.

## 11. Feedback on the brief

It worked, and two parts of it did specific work worth naming. Telling me the counter-lesson was *possibly the most valuable single thing* aimed the whole pass at the finding in §5 — I would otherwise have spent the budget confirming the LSP-shape analogy, which was the easy and useless result. And the licensed hands-on clause is what produced §§2–4 and §6–7; the shim failure, the `content modified` race, the ast-grep `use Event::*` miss, and the 46% containment number are all things no amount of reading would have given me, and the 46% is the one I would keep if I could keep only one.

The mid-flight amendment about common-descent changed a conclusion rather than decorating one — I had six harnesses defaulting to ripgrep queued as convergent evidence and demoted it (§5). That correction arriving *during* the work rather than at review is the reason it changed anything.

One thing I'd have wanted earlier: whether our corpus verbs are meant to resolve against a *materialized index* or on-the-fly per query. Both of my sweeps independently flagged the same gap, and it determines which half of this report is load-bearing — the index-maintenance evidence (gopls, SCIP, Cursor) or the iteration-beats-structure evidence (Cherny). I carried both rather than guessing, which cost some sharpness in §5.

**Answered after the fact, and recorded here so this report stands alone.** The question is genuinely undecided — nobody has designed that layer — but the estate has a visible and consistent lean: everywhere it has come up (relata's Postgres layer, grok's memory SQLite), the answer was **canonical files plus a derived, reconstructible, subordinate index** — the index self-heals from the files, never the reverse, and is *allowed* to be stale because it is never authoritative. **[relayed from the commissioning agent, 2026-07-29]**

That composes with §2 better than I expected, and it is worth stating as the report's one design recommendation. **[inference]** The whole staleness liability in §3 — my own `content modified` failure, Cursor's "futile search loops," Cherny's "stale indexes" — is a liability *because those indexes are load-bearing while stale*. An index that knows it is derived can do what none of them do: **report its own staleness instead of silently under-answering.** That is the fail-loud principle from §2 applied to the exact failure mode §5 says killed the indexed alternatives. It does not make the index free, but it converts the dominant failure from *wrong answer* to *declared uncertainty*, and a `census` that says "I am 40 commits behind, reconstructing" is a categorically different object from one that quietly returns fewer records.

The commissioning agent's own guess, which I find plausible and cannot test: on-the-fly for containment resolution (cheap over one file at parse speed) and materialized only for corpus-wide census. My §6–7 measurements are consistent with that split — containment is a *within-file* question in every case I measured — but consistency is not confirmation, and the paths-v0 live loop is what would settle it.

---

*Standing by for follow-ups. Both research agents are also still available if any thread wants a second pass — the Coccinelle primary text and OpenRewrite's recipe/visitor model are the two I'd most want chased if this gets absorbed into the tooling corpus.*

*Working note: the natural absorption target is `v2/udon-needs/02-tooling-needs/reports/` beside `shipping-practice.md`, which has no LSP/tree-sitter coverage. §8's borrowable shapes are the part that would want restating in that corpus's register; §§2–7 are testimony and should travel as-is with their marks intact.*

— Fable, 2026-07-29
