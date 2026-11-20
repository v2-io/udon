# 01 — `|a |b` on one line: child or value? — history

**Written by:** Claude (Opus 5.5), history agent, 2026-09-29. Written without seeing any lean on this question. It has no lean or recommendation section; that comes later.

## Method

- **Read whole first:** the neutral file `01-sameline-element-child-or-value.md`, `pre-design/README.md`, `spec-lite-0.1.0/README.md`, `v2/WHERE-THINGS-STAND-2026-09-27.md`.
- **Repo reads:**
  - mainline `spec/CORE.md` (Positional Contexts, Hierarchy, Attributes/Node Values) and `spec/msc/CHANGELOG.md`
  - `design/attribute-model-2026-07.md` and `design/attribute-model-proposal-3.md`
  - `_archive/` (`feedback.md`, `analysis.md`, `REVIEW-JULY-2026.md`)
  - `v2/DECISIONS.md` (K-rows)
  - the three K9 theory notes plus the K9 draft (`v2/theory/to-integrate/primary/sameline-value-space-*`, `K9-DRAFT-2026-08-08.md`)
  - `spec-0.09.01/CORE.md`
  - `spec-0.10.00/` (CORE §2, §5.6–§6.10; TUTORIAL §4; MODEL and SEMANTICS by grep)
  - `spec-0.10.01/` (CORE by grep, NUANCE-AUDIT, spelling grid, `working-notes/AUDIT-2026-09-01.md`, `fixtures/descriptive/gaps.yaml`)
  - `JOSEPH-FOR-0.10.01-FIX.md`
  - `core/fixtures/v0.9/`
  - `test/usability/results/`
  - `v2/udon-needs/` (by grep)
  - the 2011 originals, now at `~/src/_older/udon/` and `~/src/_older/udon-c/`. The brief's `~/src/_ref/udon*` paths no longer exist.
- **Dating:** `git log -S` / `--follow` in the umbrella repo and in both 2011 repos, for when rules and phrases first appeared.
- **Getting Joseph's exact words, indentation intact:** memorata strips indentation, so I used it only to *locate* passages. I took the quoted text from the primary files:
  - Joseph's own typed prompts in `~/.claude/history.jsonl`: the `display` and `pastedContents` fields of the specific lines memorata named. This is his prompt log, not a model transcript.
  - Joseph's messages in one Grok session, pulled by a `jq` filter on `sessionUpdate=="user_message_chunk"`. Only his lines were printed.
  - The extracted session-vault markdown (`v2/.archived/second-pass/spikes/session-vault/raw/claude/18aabafc-…md`), which is user and assistant text with tool stubs. I found no thinking in the passages I read.
  - Where the original indentation could not be recovered, the entry says so.
- **Thinking-content caution:**
  - One memorata query (listed below) ran without a class filter. It returned three thinking-class snippets from the 2026-09-01 audit session. I did not use or quote them. The same point is in that session's own audit file, which I cite instead.
  - `_archive/feedback.md` contains a Dec-2025 "∴ Thinking…" block. I quote only the response part.
  - No raw `.jsonl` transcript was opened wholesale.
- **Memorata searches.** All used `--sort oldest` where the aim was chronology; the `--pool` value is listed where I set it.
  1. `udon element on same line as another element child or value` · `--joseph --pool 400`
  2. `|one |two |three nest rightward sibling column` · `-c human-user --pool 300`
  3. `sameline element after element is child or $main value node` · `-c human-user --since 2026-07-01 --pool 400`
  4. `embedded elements siblings |{a} |{b} instead of nested |a |b table cells` · `-c human-user --pool 400`
  5. `why |a |b |c nests rightward vs siblings one-liner old udon-c notes inline notation` · `-c agent-to-human subagent-final-response --until 2026-01-15`. Nothing from the Dec-23 session was indexed.
  6. `INLINE ONE-LINERS strictly determined by indent level udon-c DECIDED found notes` · agent classes, 2025-12-20…2026-01-05. Nothing relevant.
  7. `old udon-c notes one-line nesting … symmetry with !{...}` · `-c agent-to-human`, 2025-12-22…26. **No results.**
  8. `inline siblings nesting udon one-liner` · all classes, 2025-12-22…26. Only spec documents came back.
  9. `block-form nodes at the $main slot are sameline children not $main values` · human, agent and document classes, `--since 2026-08-01`
  10. `sameline element child or value` · `--joseph --since 2026-08-20`. **Nothing on this question after Aug 9.**
  11. `A4 $main value vs sameline child |a |b two things at once` · non-thinking classes, `--since 2026-08-30`. **No results.**
  12. `I'm going to call 0.10.01 a misfire`. This was an index check: the Sep-1 session is indexed.
  13. `sameline child main value nesting` · `--in ~/.claude/projects/-Users-josephwecker-v2-src-arch-firmatum-udon-v2/`, no class filter. This is the query that returned thinking snippets, unused. Re-run with `-c human-user agent-to-human subagent-final-response`: **no results.** So as far as the index shows, Joseph did not discuss audit finding A4 in chat.
  14. `same-line siblings` · `--joseph`
  15. `What's the rule for when :$main starts vs attaching to the most recent attribute again` · human and agent classes
  16. `when does $main start versus attaching to the most recent attribute` · agent classes, Aug 8–11
  17. `column alignment edit hazard rename inline nesting continuation lines` · `--joseph`, Jul 1–20
  18. `grim attribute`
  19. Two exact-phrase searches, used to timestamp Jul-15 messages.
- **Repo grep terms:**
  - `\|a \|b`, `sameline nesting`, `same-line`, `rightward`, `node child`, `node value`, `sameline binding`, `block-deeper`, `one-way door`, `self-announc`, `order does it`, `grim`, `sibling`
  - `git log -S` on: `three is child of two`, `nest rightward`, `sameline binding`, `block-deeper`, `one-way door`, ``block-form `|name` → node``, `order does it`, `ONE-LINERS`, `Multiple embedded elements are siblings`, `commits to prose`
- **Speaker labels:**
  - "Joseph" means his own typed words.
  - "Agent" names the model where the source records it.
  - "Document" means a file whose author is not a single recorded speaker.
  - Times are local: MST (−07:00) in 2025, MDT (−06:00) in 2026.

---

## History (chronological)

### 2011-08-15 / 2011-08-22 — the first examples: sameline chains nest; sibling operators tried

- **Source:** `~/src/_older/udon/examples/overview.udon:109, 149–151, 156`. Line 150 was added in `1b57c3a` (2011-08-15); line 109 in `0cd4b33` (2011-08-22, "Playing with some new syntax thoughts").
- **Speaker:** Joseph, as a 2011 exploratory example file.

```udon
      |tr <(td First stuff)> <(td Second stuff)>
      |tr |td First stuff <|td Second stuff <<|td Third stuff
…
|table |tr |td hello |td you
       |tr |td crazy |td world  # Each line starts over as child of table
  |tr |td still |td good
…
|html|body|div.main Some text
```

- **Bears on this question:**
  - Same-line elements were already read as a chain.
  - `<|` and `<<|` look like same-line "go back up a level" operators. That is my reading; their meaning is not written down anywhere I found. They would only be needed if `|td A |td B` nests.
  - `<( … )>` was the embedded form for siblings on one line.
- **Incidental:** `#` comments, the `<(…)>` syntax, and `|td hello |td you` (a `|` after text), which contradicts the Dec-2011 rule below. This is exploratory material.

### 2011-12-14 — udon-c DECIDED: "strictly determined by indent level"

- **Source:** `~/src/_older/udon-c/docs/DECIDED.md:60–70`, added in `4edf78e` (2011-12-14). Also `:44–58` (grim attributes) and `:95–97`.
- **Speaker:** Joseph (2011 design notes).

```text
## INLINE / ONE-LINERS
Strictly determined by indent level. Attributes+ids etc. apply to nearest
beginning of a node (or grim attribute)

|one|two|three    ==>    |{one |{two |{three}}}

|one |two
     |three       ==>    |{one |{two} |{three}}

|one |two
       |three     ==>    |{one |{two |{three}}}
```

and:

```text
':|' attributes (grim attributes) are like nodes except the node-name is in the
     attributes of its parent.
…
* Once data text has started on a line, pipes etc. are all treated literally
  like any other text. Need a newline or embedded to get back to structured
  data.
```

- **Bears on this question:**
  - This is the origin of alternative A as a rule: same-line elements sit at their columns.
  - A node-valued attribute had its **own spelling**, `:|key`, so "is this element a child or an attribute's value?" never arose from position.
- **Incidental:** the prose-commits-the-line rule. It bears on whether `|p Intro text |em …` has an element at all, which is a different question.

### 2025-12-23 13:24 — revival SPEC: "nest rightward"

- **Source:** umbrella commit `f5813bd`, `SPEC.md` "Inline Children". The commit message is "Initial commit and rewrite based on analysis of the original + 12 more years of experience".
- **Speaker:** document (Joseph with Claude Opus 4.5).

> Multiple elements on one line nest rightward:
> `|a |b |c        ; Equivalent to |a containing |b containing |c`

- **Same day:** `_archive/analysis.md:508–521`, the agent's revival analysis. It kept GRIM attributes as "nodes-as-values" and noted: "Alternative: infer GRIM from 'attribute followed by newline+indent' rather than special `:|` syntax." This is the seed of the later "node values are block-deeper-only" idea for attributes.

### 2025-12-23 13:52 — Joseph questions rightward nesting

- **Source:** `~/.claude/history.jsonl:5466` (session `6e3818d1`, project `~/src/udon`).
- **Speaker:** Joseph.

> The following `|p Some text |em emphasis` is already correct and valid udon. The problem is that currently `|a |b |c` is treated like c is a child of b (is a child of a) instead of b and c being siblings. I don't remember though why I felt 12 years ago that that was the more useful interpretation. I also had several potential inline notations that I played with IIRC. […] would you then look at the older ~/src/_ref/udon and ~/src/_ref/udon-c projects and look for notes on the one-line issue and also potential notations for inline (like |{...} or I like the idea of ` | ` with no element-name being a potential delimiter.

- **Bears on this question:**
  - A third reading, besides "child" and "value": `|a |b |c` gives `a` the **sibling children** `b` and `c`. Joseph preferred it at that moment, and could not recall the 2011 reason for chaining.
  - He also states that `|p Some text |em emphasis` (an element after text) is valid.
- **Incidental:** his point about fewer newlines in generated output, and ` | ` as a table delimiter.

### 2025-12-23 14:20 and 14:29 — resolved toward `|{…}` for siblings; agents keep writing sibling tables

- **Source:** `history.jsonl:5469`. Text plus `pastedContents`, which preserves the indentation:

> Yes, it does, and I agree. The symmetry with !{...} is the most compelling for me.
>
> So we need the inline form |{...}, and while nesting is properly defined in SPEC.md, I don't know if sibling indentation rules are:
> ```
>   |one|two|three    ==>    |{one |{two |{three}}}    ; all nest rightward
>
>   |one |two
>        |three       ==>    |{one |{two} |{three}}    ; SIBLING via column alignment
>
>   |one |two
>          |three     ==>    |{one |{two |{three}}}    ; child via deeper indent
> ```

- **Source:** `history.jsonl:5470`.

> I keep seeing this example, and it's wrong:
> ```
>   |table |tr |td A1 |td A2
>          |tr |td B1 |td B2    ; |tr is sibling of first |tr (same column)
>     |caption Table 1          ; |caption is child of |table (indented from |table)
> ```
> You mean:
> ```
>   |table |tr |td A1
>              |td A2
>          |tr |td B1
>              |td B2    ; |tr is child of |table, so sibling of first |tr (same column)
>     |caption Table 1   ; |caption is *also* child of |table (indented from |table)
> ```
> right?
>
> What I'm now realizing, though, is that embedding blocks in text doesn't necessarily give us a syntax (yet) for same-line-siblings...

- **Speaker:** Joseph.
- **Bears on this question:**
  - The agent's reply is not in the memorata index (searches 5–8).
  - Joseph's pasted mapping reproduces the 2011 udon-c DECIDED almost verbatim. So the agent very likely surfaced that file and Joseph re-adopted it. This is inference.
  - Rightward nesting was kept, with siblings to come from `|{…}` or column alignment.
  - The agent-written example (`|tr |td A1 |td A2`) assumed the sibling reading. That was a first sign that newcomers expect siblings.

### 2025-12-23 15:03 and 18:15 — the spec and examples are changed to match

- **Source:** commit `d82af7a` (15:03), which added "Column-Aligned Siblings" and "Multiple embedded elements are siblings: `|nav |{a :href / Home} |{a :href /about About} …`" to `SPEC.md`.
- **Source:** commit `acb8b94` (18:15, co-authored by Claude Opus 4.5). The commit message:

> The inline syntax |a |b |c nests rightward (a contains b contains c).
> For siblings, use embedded elements: |{a} |{b} |{c}
>   WRONG: |tr |td A |td B    (td B is child of td A)
>   RIGHT: |tr |{td A} |{td B}  (both td's are children of tr)

- **Bears on this question:** the settled Dec-2025 shape. Block-form elements on one line chain; brace forms are siblings.

### 2025-12-23 ~19:20 — usability-run feedback

- **Source:** `test/usability/results/udon-topic_enablement-20251223-192052-ac2ac7a8.yaml`, around line 577.
- **Speaker:** an agent under test. The model is not recorded in the lines I read.

> The `|{inline}` vs `|rightward` distinction is subtle. I had to re-read to understand when I'd use each.

- **Bears on this question:** evidence on least surprise.

### 2025-12-24 17:23–17:35 — Joseph's column rules for same-line chains

These became the mainline CORE hierarchy chapter.

- **Source:** `history.jsonl:5607`, `5608`, `5609` (session `38b75c32`). Indentation is from the history file.
- **Speaker:** Joseph.

```udon
|one |two |three
        |alpha   ; special case-- child of |two (sibling of |three) instead of one
…
|one |two |three
  |alpha
     |beta      ; child of |alpha, where |alpha is sibling of |two. Note that it technically lines up with |two but is not a child of |two in any way.
```

> You *only* care about the previous line. […] That's exactly why I was trying to clarify that you don't "track" columns for inline stuff except for knowing what the very next line is child of

> ```
> |a |b |c |d |e |f |g
>          |child-of-c
>    |child-of-whom?   ; ahah-- looks like it might take special tracking, BUT, if you simply know all of the inline element's position naturally as part of the stack, it's literally equivalent to:
> ```
> […] because a--g are nested as if they had been on their own lines, the parent-column-positions in the stack should just handle everything naturally, right?

- **Bears on this question:** this is how A works in detail. Same-line elements go on the stack at their columns, and following lines are placed purely by column.
- **Carried into:**
  - `SPEC-INDENTS.md` (2025-12-25)
  - the 2026-01-01 consolidation `c0025bd`
  - today's `spec/CORE.md:930–1140`, including "Inline Nesting: `|one |two |three ; three is child of two, two is child of one`" and "The inline notation is just a compact way to write the vertical form."

### 2025-12-25 14:00 — an element after same-line text is a child at its column

- **Source:** `history.jsonl:5701`.
- **Speaker:** Joseph.

```udon
|element-bigger Here's some child text |another-element
                                       |child of element-bigger- sibling to another-element
             |also-a-child of element-bigger, issues warning though.
```

- **Bears on this question:** in the Dec-2025 model, `|another-element` after text is a **child** of `element-bigger`, sitting at its true column.
- **Incidental:** content-base warning rules.

### Dec 2025 (file added 2026-01-03) — first-contact review: praise for column-based nesting

- **Source:** `_archive/feedback.md:63–68`, the response part only.
- **Speaker:** Claude Opus 4.5 in a fresh first-contact review.

> 1. The column-based inline nesting […] This is clever. I don't know of another language that treats inline elements as "virtually on separate lines at their column positions." The pop while new_column <= stack_top.base_column rule is simple and produces intuitive results once understood.

- **Bears on this question:** a counterpoint to the usability-run remark above. The same mechanism is read as a strength, "once understood."

### 2026-01 → 2026-07 — built behavior (evidence of what was built, not of intent)

- **Source:** `core/fixtures/v0.9/hierarchy.yaml:143–157` (`many_inline_elements`: `|a |b |c |d` followed by column returns).
- **Source:** `core/fixtures/v0.9/legacy_mined.yaml:402–415` (`text_binds_to_innermost_inline_element`: `|a |b |c text for c` gives `c` the text).
- **Bears on this question:** the reference parser implements A.

### 2026-07-08 15:04 — Joseph calibrates down the column-alignment "fragility"

- **Source:** `history.jsonl:15381` (session `da5d1672`). It fed `_archive/REVIEW-JULY-2026.md:271–285`, item 7: "demoted from #1; calibration Joseph's".
- **Speaker:** Joseph.

> column alignment fragility is only true when inline nesting is used and the element names are genuinely so short that a single col change is enough to get the boundaries confused. It's not an issue under any newline indent regime (so it is at least as strong as python) […]
> ```
> |parents-are-great |children-are-great |grandchild    ; changed to something bigger than original
>           |other-grandchild  ; THE PROBLEM
> ```

- **Bears on this question:** this is the known cost of true-column same-line elements (A). Joseph judged it minor.

### 2026-07-15 13:25 → 14:33 — the attribute case, first pass: Joseph says an element after `:label` on the element's line is the element's **child**

- **13:25:58, Joseph** (`history.jsonl:16326`). Attribute node values, on a deeper line:

```udon
  :attribute-beta                     ; parser, or treewise, I wouldn't want an anonymos element intermediary-- I would feel like "attribute-beta *is* a veni-vidi-vici"
    |veni-vidi-vici :working 1234
```

- **14:04:39, Joseph** (`history.jsonl:16327`; also in the session vault at line 2376):

```udon
|el |another :wolf sheep (this text is now child of |another and no more attributes can be declared)

|el |another :alpha <some value> ; all good
  :attribute-for-el  ...  ; ILLEGAL currently-- |el already started accumulating children.
…
      :omega "and if I was to keep going" :beta |betas second value
                                                  whose prose is continuing right here...
                                                  is absolutely fine...
```

- **Bears on this question:**
  - `|el |another` means `|el` "already started accumulating children". The same-line element is a child, and it ends el's attribute phase.
  - The last example shows a node **value** sitting at its true column, with deeper lines attached to it by column.
- **~14:10, agent** (Claude, session `18aabafc`; vault md `:2458`), proposing that an element after `:label` becomes its value:

> **(b) It changes sameline element-after-attribute binding.** Today `|el :alpha |child` makes `child` a child *of el* (the sibling scan). Under rule 3, it becomes **alpha's node value**. I'd argue new-way is what users expect […]

- **14:33:23, Joseph** (`history.jsonl:16328`):

> I actually think that the difference between these two is the slightly bigger footgun (your (b)):
> ```
> |el :alpha |child something
> ==
> |el :alpha
>   |child something
> !=
> |el :alpha
>       |child something  (here |child is actually the value for :alpha and I would assume our rules make this the right or valid way to do it)
> ```
> Since sameline is a sort of syntactical sugar already, we would just need to specify that subsequent elements are children of the prior element, not values for the attribute, and even that minor ambiguity is only important when they are *also* using a boolean type flag right before a type...
>
> That whole ':empty-attribute-is-boolean-flag' is the thing, if anything, that we could get rid of pretty easily […]

- **Agent reply** (vault `:2529ff`): "Keeping **sameline sibling-scan semantics exactly as they are** […] and making node-values **block-deeper-only** […] is strictly better than my rule 3: nothing existing breaks, sugar stays sugar."
- **Recorded in** `design/attribute-model-2026-07.md:226–251` (commit `54c52d2`, 14:45): "node values are **block-deeper-only** … Sameline stays sibling-scan (nothing existing breaks; sugar stays sugar)".
- **14:58:27, Joseph** (`history.jsonl:16330`), on references and code blocks as attribute values: "(basic sameline usage w/ the 'attaches differently if started with an attribute' rules already discussed)".
- **Agent reply** (vault `:2627`): "On an **element-rooted line**, this *must not* change: we ratified this week that `|a |b :k v ```` opens a fence as **b's child** (the sameline scan)."
- **Bears on this question:**
  - For about an hour, the rule was "strict A". A block-form element anywhere on an element's line is a child, even directly after a `:label`. A node value needs a deeper line.
  - Joseph's stated reason: same-line writing is sugar for the vertical form. The one ambiguity he saw came from the implicit-boolean flag.
  - The fence case is the same question for another block-form thing, and it was answered "child".

### 2026-07-15 15:21 → 22:59 — the attribute case flips: `:a |b` binds the node

- **15:21:07, Joseph** (`history.jsonl:16331`):

> if the implicit boolean attribute ends up causing too much ambiguity from the user's perspective (like where the reference attaches to after :label on sameline (a place where boolean + attach to parent element is the more surprising behavior) -- I might trade it for forced explicit boolean attributes:
> ```
> :some-bool? |etc  ; defaults to true
> :some-bool [anything else] ; binds to the attribute as its main value/type -- even an element etc., even on normal sameline...
> ```

- This was recorded as §7.5, an aside "under consideration" (commit `cb33bbe`, 15:22).
- **16:48:49, Joseph**, in a Grok session (`~/.grok.bak-2026-07-21/sessions/…/019f67df…/updates.jsonl:582`, user message):

> The main thing that I feel we potentially need to figure out now rather than later is the trading away implicit valueless attributes in order to better unify same-line and attribute-rooted sameline-- so that   `|alpha :a |beta` is just as it reads, |beta is the type and value for :a, not a child of |alpha, and only `|alpha :a? |beta` remains as the case that cares about whether sameline is element-rooted or attribute-rooted

- **19:23:27, Joseph** (same Grok file, `:902`). Note that the same-line element after a *finished* value still ends the parent's attribute phase:

> Otherwise it is the end of the attribute phase altogether and is the first (and sometimes only) block of text as a child to the most immediate element to our left (we are as if that element's indent just moved down / decompressed).
> ```
> |e :attr v |child
>              :another-attr?
> …
>    :this will get a warning but is normal text because additional attributes for |e were foreclosed when |child changed the phase to children...
> ```

- **Evening:** `design/attribute-model-proposal-3.md:90–96` (commit `722fbc7`, 20:37; the author is not recorded in the commit):

> **[PROPOSED]** `|el :a |beta` → `a`'s value **is** the node `|beta` (no block-deeper-only requirement). `|el :a? |beta` → flag true; `|beta` child of `el`.

  Its Supersession section (`:386–389`) lists "Sameline sibling-scan after **plain** `:a |beta` (becomes node value)" and "Block-deeper-only for node values".
- **Written into mainline CORE** the same night (`8fa60af`, 22:59): `spec/CORE.md:565–584`, "`|api :headers |header …` ; headers IS the |header node (sameline binding -- no block-deeper requirement)".
- **The one-way-door caution:** "`|api :headers |header :k v :timeout 30` gives `timeout` to the *header*". It entered from the fresh-eyes review commit `61158e5`, the same day.
- **Ruled:** `spec/msc/CHANGELOG.md:382–389` ("ratified direction 2026-07-15 … confirmed 2026-07-16"): plain attributes always take a value; flags are spelled `:key?`.
- **Bears on this question:**
  - This is the origin of the neutral file's "for attributes, the value reading is ruled". It reversed the 14:33 position within about two and a half hours.
  - The driver was retiring the implicit valueless-means-true flag. Once a plain `:a` always expects a value, `:a |b` reads "just as it reads".
  - The element-rooted case (`|el |b`) was **not** changed. The 19:23 message still treats `|child` after a finished value as el's child.

### 2026-07-19 → 2026-07-22 — brace forms become text in value position; 0.9.1 consolidates

- **Source:** `spec/msc/CHANGELOG.md:278–290` (the inline-brace principle, ruled 2026-07-19): "`:n |{em x}` flips from *node value* to *blob segment*; sameline node values remain block-form (`:headers |header …` unchanged)."
- **Source:** `spec-0.09.01/CORE.md:76` (2.1 "Sameline nesting … `|a |b |c` is equivalent, for all hierarchy purposes, to the same elements on successive lines") and `:790` (Appendix A: "three elements, nested — identical to the vertical form"). Also the primer, `udon-0.9.1-primer.md:81`.
- **Source:** `spec-0.09.01/CORE.md:298–305`. The self-announcing list "digit or sign → number, … `@` → reference, block-form `|name` → node". It sits in the paragraph about **attribute** value material ("A `:` passing its phase gate opens an attribute; after the key, its value material is collected").
- **Bears on this question:** this is where "block-form `|name` → node" enters the self-announcing list, in an attribute-only context. It matters for the 0.10.0 entry below.

### 2026-07-28 21:48 — pedagogy: "pretend the same-line part … on consecutive new lines"

- **Source:** `history.jsonl:17689` (session `f9626a5b`).
- **Speaker:** Joseph. He lists practices that "have always been part of udon":

> "If confused about which thing the indented line is child of-- just pretend the same-line part has each of its parts on consecutive new lines"

- **Bears on this question:** A, stated as the teaching rule.

### 2026-08-07 — attribute-as-element spike

- **Source:** `v2/.archived/attr-as-element-spike-2026-08-07.md:26`.
- **Speaker:** agent (spike).

> If an attribute behaved like an element on the same line (owning everything rightward, as `|a |b` nests), multi-attribute lines die. So the attribute is *not* element-like on the sameline axis

- **Bears on this question:** "`|a |b` nests" is used here as the known baseline. It is also the reason attributes must *not* take over the rest of the line the way elements do.

### 2026-08-08 13:03 and 13:31 — `$main` is born; "pseudo-line-feeds"; `|{a} |{b}` as siblings

- **Source:** `history.jsonl:18833`, `18835` (session `6ce33695`).
- **Speaker:** Joseph.

> sameline has (1) certain syntax-sugaring available that isn't other places, and (2) has pseudo-line-feeds (actual original purpose LF, NOT newlines- but rather hypothetical newline but indent to the current cursor location anyway)....
>
> As for :'$main' -- I'm sold. […]
>
> ```
> |element "here we go!" |child "here we go some more" |grandchild and here we stop ; And this is a normal comment as usual...
> ```
> […] Which also potentially resolves another ambiguity in the past-- What to do with this on sameline:  `|element |{embed-1} |{embed-2}`  This used to be mentioned as a way to have |embed-1 and |embed-2 as *siblings* rather than |embed-2 being a child of |embed-1 which is the default behavior. But we removed it because it didn't really work and exposed lots of cracks and gaps in the spec. Now maybe we've just made it a reality!

- **Bears on this question:**
  - "Pseudo-line-feed" is Joseph's stated *original purpose* of same-line writing, and it is exactly A.
  - His own worked example names the chained elements `|child` and `|grandchild`.
  - He calls `|embed-2` being a child of `|embed-1` "the default behavior", and wants brace forms to be the sibling mechanism.
- **Incidental:** typed `$main` and the quote-delimiting pain. That is question 13 and others.

### 2026-08-08 (evening) — the K9 capture, the spike checks, and the ruling

- **Source:** `v2/theory/to-integrate/primary/sameline-value-space-2026-08-08.md:31–33`.
- **Speaker:** document (Joseph with the Fable parent session; "converged brainstorm + leans"). Among the derivations "previously bare stipulations":

> 1. `|{a} |{b}` are **siblings** while `|a |b` **nest** — the `}` closed a before b opened; block b lands deeper on the virtual stack.

  and `:72–76`: "`"…"` / `<…>` / `[…]` / numbers self-announce at the slot, become $main values, and **return the scan** — so `|element "here we go!" |child "…" |grandchild …` chains correctly."
- **Spike pass:** `…-couplings-2026-08-08.md:71` (S2).
- **Speaker:** agent.

> `@` at the element's clean slot: `|el @ref` is today the element's reference *child* […]. The operator model keeps it a child (block-form marker = pseudo-LF), which means the $main slot's value grammar **excludes `@`** while attribute slots include it.

- **Fork pass:** `…fork-notes.md:24`.
- **Speaker:** agent.

> **Sameline material is never content. Content is exclusively block-form.**

  The context shows that "block-form" here is set against the brace forms: `|el |{a} |{b}` leaves `content` empty.
- **Ruling:** `v2/DECISIONS.md:178` (K9, "jaw 2026-08-08") and `K9-DRAFT-2026-08-08.md`. The **enumerated** list of self-announcing values for the slot is "(`"…"` `<…>` `[…]` numbers `!{{…}}`) become `$main` values and return the scan". Block-form `|name` is **not** in it. The Consequences line reads "sameline material is never content (host flag re-injects …)". The fork's second sentence, about block forms staying content, is not carried into the row.
- **Bears on this question:**
  - K9 was designed with A in place, stated explicitly in the capture doc and in S2.
  - The ruled row enumerates the typed values and leaves block forms out.
  - The shortened "never content" wording, read alone, could be taken to cover `|b` too.

### 2026-08-08 22:48 — K10: after same-line text, ` |name` is live again

- **Source:** `history.jsonl:18879`.
- **Speaker:** Joseph.

> Attaching to the most recent attribute or element is *NOT* the same thing as not watching for new attributes anymore when it's bare text. Why watch for ' ; ' but not ' :' or ' |' or ' !' or ' @' ????

- **Ruled as K10** (`DECISIONS.md:177`): an unquoted text value ends at "a space + guard-confirmed block-form marker (`:key`, `|name`, …)".
- **Bears on this question:** from here on, `|p Intro text |em emphasized` has an element `em`. It must then be child or value, so the question now also covers elements that follow same-line text, not just elements that follow the head.
- **Incidental:** the same question has flipped three times since 2011:
  - 2011 DECIDED: after text, pipes are literal.
  - Dec 2025: an element.
  - July 2026 mainline head-position rule: literal.
  - Aug 2026: an element again.

### 2026-08-09 — K16: one value grammar at every value-expected position

- **Source:** `DECISIONS.md:171` (K16, "jaw 2026-08-09").
- **Speaker:** the row is the agent's interpretation; the quote is Joseph's.
  - The row: "Every value-expected position — **sameline `$main` slot**, attribute slots, list items, deferred-body first line, and key interiors — takes the whole value grammar."
  - Joseph, about key interiors: "I don't know why you would carve out extra grammar for 'kind of almost values' in a place that was specifically meant to encapsulate a value".
  - Also in the row: "**Block forms in bracket sugar: disallowed for right now — held lightly.**"
- **Bears on this question:**
  - If the `$main` slot counts as a value-expected position, "the whole value grammar" includes block-form nodes. That is the uniformity route to B.
  - The same row carves block forms out of bracket slots. So "full value grammar" was never quite applied to block forms without exception.
- **Incidental:** Joseph's words were about keys, not about the `$main` slot.

### 2026-08-09 09:38 and 09:42 — `$main` for HTML is the first inner content

- **Source:** `history.jsonl:18911`, `18913`.
- **Speaker:** Joseph.

> What's the rule for when :$main starts vs attaching to the most recent attribute again? And it's just when it's sameline w/ the element, right? (like all :$main)

> Excellent-- that's what I thought. And it's good.  It makes it clear in the source the separation between the last attribute's value and the element's $main, which in the case of html etc. will always be interpreted as the first and sometimes only part of the inner-content.

- **Bears on this question:** for an HTML-like reading, `$main` and the first child land in the same place, as inner content. See Threads.

### 2026-08-09 → 2026-08-11 — 0.10.0-alpha.1: the texts that now say both

- **Source:** `spec-0.10.00/`, commit `2de5907` ("UNIF-PASS: suite rewritten … value-space unification").
- **Speaker:** document, from two overnight agent passes, per WHERE-THINGS-STAND.
- **Child reading:**
  - `CORE.md:96` §2.1: "**Sameline nesting.** … `|a |b |c` is equivalent, for all hierarchy purposes, to the same elements on successive lines at those columns."
  - `CORE.md:438` §6.8: "To give an element both attributes and a **node child** on one line, order does it: `|el :a 1 |beta`."
  - `CORE.md:468` §6.10: "`|element "here we go!" |child …` chains".
  - `TUTORIAL.md:61–70`: "Elements written on one line sit at their real columns, exactly as if written vertically", with the `|table |tr |td A1` / aligned `|td A2` example.
- **Value reading:**
  - `CORE.md:323` §6.4 keeps the self-announcing list, **including "block-form `|name` → node"**. It still follows the attribute-opening sentence, as in 0.9.1. It now adds "and self-terminate; the scan continues after each", and names it with a generic term ("**Self-announcing values.**") that §6.10 then points to.
  - `CORE.md:358` §6.5 rule 2: "on an **element-rooted line**, further values stack as the element's **`$main`**".
  - `CORE.md:468` §6.10: "Self-announcing values become `$main` values and return the scan". This is generic; K9's enumeration is dropped.
- **Bears on this question:** this is the contradiction the neutral file cites. On my reading of dates and wording, B enters here through **rewording**: a generic phrase replaces K9's enumerated list and inherits 0.9.1's attribute-context list. I found no chat, ruling, or note proposing it. This is inference; see Threads.

### 2026-08-27 — 0.10.1-draft (later called a misfire)

- **Source:** `spec-0.10.01/`.
- **Speaker:** document (Fable).
- **What it says:**
  - `CORE.md:17` (G2): "structure written mid-line sits at its true column as if written vertically".
  - `:61`: same-line nesting.
  - `:183`: the self-announcing list with "block-form `|name`/`!name` → node — self-terminate; the scan continues after each".
  - `:227`: the one-way door.
  - `:235`: the generic §6.10 sentence.
  - `NUANCE-AUDIT.md:42`: "One-way door | **derives** | sameline items at true columns (G2); the door is the Nesting Rule seen mid-line".
  - `working-notes/spelling-grid.md:7`: "Sameline (in the scan)" is `|a |b |c` (true columns), a column separate from "Value (in a slot)".
- **Bears on this question:** the same pair of readings carries over. Two of its own notes (the nuance audit and the spelling grid) take A.

### 2026-09-01 — the audit names the contradiction; the proposed fix states A

- **Source:** `spec-0.10.01/working-notes/AUDIT-2026-09-01.md:37–42` (A4).
- **Speaker:** agent (Fable, single reader, unratified).

> §2.2: `|a |b |c` "is, for all hierarchy purposes, the vertical form" — children. §6.4: block-form `|name`/`!name` at a value-expected position is a *self-announcing value*; §6.5 rule 2: on an element-rooted line further values stack as `$main`; §6.10: "self-announcing values become `$main` values." So `|a |b` is a child by §2.2 and `$main = b` by §6.4/6.5/6.10. Carried defect (0.10.0 has the same three sentences) […] One sentence settles it: *block-form nodes at the `$main` slot are sameline children, not `$main` values.*
>
> The same sentence cluster carries a wording defect: §6.4 "block-form `|name`/`!name` → node — self-terminate; the scan continues after each" contradicts §6.8's one-way door (the scan continues *inside* the node).

- **Fixtures:** `spec-0.10.01/fixtures/descriptive/gaps.yaml:105–122`. `gap_A4_block_form_at_main_slot` (`|a |b :n 1`, two readings) and `gap_A4_generator_at_main_slot` (`|el !if @flag`).
- **Same session:** `JOSEPH-FOR-0.10.01-FIX.md:25–37` (agent text, which Joseph saved). "**2. Sameline is one line of the tree written sideways**": `|a :x 1 |b :y 2 |c` gives `a{x 1, └ b{y 2, └ c}}`, and "Once `|b` opens, the rest of the line is b's."
- **Bears on this question:** this is the first place the child/value conflict is named. The auditor gave both readings as fixtures, not a verdict. The same session's proposal took A.
- **Joseph's response:** searches 11 and 13 found no chat reply from Joseph on A4. His Sep-27 recollection of the proposal as a whole (WHERE-THINGS-STAND) is that "it seemed less and less principled as he questioned it". Nothing ties that to this point in particular.

### 2026-09-29 — the neutral question file

- **Source:** `pre-design/01-sameline-element-child-or-value.md`.
- **Speaker:** Claude (Opus 5.5), coordinator.
- **Bears on this question:** it frames the question from the 0.10.0 texts.

---

## Threads worth noticing (my reading, not findings of fact)

1. **A has an unbroken record of explicit statements; B has none.** From 2011 DECIDED through the Dec-2025 SPEC and Joseph's Dec-24 column rules, mainline CORE, 0.9.1, the Jul-15 notes, K9's capture doc, the 0.10.0 tutorial, and the 0.10.1 nuance audit, every *explicit* statement reads a block-form element after an element's head as a child at its true column. Every example Joseph wrote with that shape reads that way too: `|el |another … ILLEGAL currently-- |el already started accumulating children`, `|e :attr v |child … foreclosed when |child changed the phase to children`, `|element "here we go!" |child … |grandchild`. I found no chat, ruling, or design note that *proposes* B for the element-rooted case. B exists only as a reading of three generic 0.10.0 sentences. They combine:
   - a list written for attribute values (0.9.1 §6.4);
   - K9's typed-slot ruling, whose own enumeration left `|name` out;
   - §6.10's rewording into "self-announcing values".

   On the evidence, B looks **decided by accident**. That is my inference from dates and wording, not a record of intent. The Sep-1 audit reached the same diagnosis ("carried defect").

2. **The real reversal in this history is not child-versus-value. It is chain-versus-siblings.** On 2025-12-23 Joseph wanted `|a |b |c` to make `b` and `c` **siblings** under `a`, and could not recall why he had chosen chaining in 2011. Within the hour he re-adopted chaining, with `|{…}` for same-line siblings. The wish came back on Aug 8 ("Now maybe we've just made it a reality!") through K9's brace-form stacking. The sibling reading has more of Joseph's own voice behind it than B does. Two more signs point the same way:
   - agent-written examples (`|tr |td A1 |td A2`) and the Dec-2025 test agent both expected siblings;
   - a *literal* reading of 0.10.0 §6.4 ("the scan continues after each" block-form node) plus §6.5 (further values stack as `$main`) gives `|a |b |c` → `a.$main = [b, c]`. That is a flat, sibling-like result, not the nested B tree the neutral file shows.

3. **The attribute case was contested, and its ground is stated.** It went "child" (14:33, with the agent agreeing) → "value" (16:48) on a single day. The reason was not about hierarchy. It was the implicit-boolean flag: once a plain `:a` always takes a value (proposal-3, then K6 and K12), "`|alpha :a |beta` is just as it reads".
   - K12 later retired flag semantics, and the `:a? |beta` escape that allowed a child after a valueless attribute went with them.
   - 0.10.0 §6.8's "order does it: `|el :a 1 |beta`" is what remains.
   - So C's attribute rule rests on "every assignment takes a value", not on any rule about the element case. The element case has no open slot waiting for a value: `$main` is optional sugar, not a declared label.

4. **The stated reason for A is "sameline is sugar for the vertical form."** Joseph's wording across the history: "sameline is a sort of syntactical sugar already" (Jul 15), "as if that element's indent just moved down / decompressed" (Jul 15), "pseudo-line-feeds (actual original purpose LF …)" (Aug 8), "just pretend the same-line part has each of its parts on consecutive new lines" (Jul 28).
   - K9 deliberately broke sameline ≡ vertical, but **only for text** ("sameline ≢ vertical for text by design"), and its capture doc kept `|a |b` nesting as a *consequence* of the pseudo-LF model.
   - B would extend that break to elements.
   - Whether the text precedent argues for extending it, or marks the boundary, is the judgment call. The history records the boundary as intended.

5. **Evidence on least surprise points away from both A and B, toward siblings.** Newcomers (agents in Dec 2025, the usability run) repeatedly expected `|td A |td B` to be siblings. Joseph did too, briefly. Both A and B nest, so neither fixes that surprise. In this history, siblings come only from column alignment or from brace forms. If least surprise is the test, the history suggests the real contest is between chaining (A or B) and siblings, with A vs B a secondary question of where the nested thing is stored.

6. **The flagship example works only under A.** `|table |tr |td A1` with `|td A2` aligned under `|td A1` appears in every spec from Dec 2025 through the 0.10.0 tutorial. Under A, both `td`s are children of `tr`. Under B as drawn, `td A1` becomes `tr`'s `$main` value, and `|td A2`, being a new line, becomes a content child. The two cells end up in different collections. This is my own working, not in any source.

7. **For HTML output, A and B coincide; for the model, they don't.** Joseph (Aug 9) treats `$main` as "the first and sometimes only part of the inner-content" in HTML. So `|p |em x` renders as `<p><em>x</em></p>` either way. The readings differ in:
   - where the tree stores `em` (an assignment or content);
   - paths and "children of" queries;
   - whether `em` ends `p`'s attribute window (the Jul-15 notes say it does, as a child);
   - which node owns the next line.

   This is my reading.

8. **The K9 ledger lost half a sentence.** The fork's proposed ratification sentence was "Sameline material is never content. **Content is exclusively block-form.**" The DECISIONS row carries only "sameline material is never content". Read alone, the row supports B. Read with the fork note, it was meant to exclude only brace forms and text.

9. **The same question for other block-form things was answered "child" wherever it came up.** A fence after `|a |b :k v` was ratified as `b`'s child in July 2026 (fixture `freeform_sameline_after_attrs`). `@ref` after a finished value is the element's reference child: "`@` and `|` behave identically here", in mainline CORE and 0.10.0 §6.3. Couplings S2 kept `|el @ref` a child under K9. Only `!name` after the head (`gap_A4_generator_at_main_slot`) was left open.

10. **Joseph has not ruled on the element-rooted case since the audit named it.** Nothing in the index shows him discussing A4. His most direct statements on the element-rooted case are the Jul-15 examples, which were made while the attribute rule was also being decided, and the Aug-8 `$main` messages.

---

## What the neutral file misses

- **A sibling alternative.** `|a |b |c` → `a` with children `b` and `c`. It is Joseph's own Dec-2025 stated preference, abandoned for reasons not recorded in the index. Related historical ways to write same-line siblings:
  - the 2011 `<|` / `<<|` operators (meaning unrecorded);
  - Dec-2025 `|{…}` siblings (`|nav |{a …} |{a …}`);
  - K9's brace-form stacking.

  The neutral file mentions brace stacking only as a settled fact, not as the sibling mechanism it was meant to be.
- **A second shape for B.** The literal 0.10.0 §6.4 wording ("self-terminate; the scan continues after each") gives `a.$main = [b, c]`, flat, rather than the nested `b.$main = c` the neutral file draws. The nested drawing assumes the one-way door. The audit flagged this wording conflict separately (A4, second paragraph).
- **"Strict A", the position Joseph held on Jul 15 around 14:33.** A block-form element is a child even directly after a `:label`, and node values need a deeper line. The 2011 predecessor, `:|key` grim attributes, gave node values their own spelling. The neutral file's A says nothing about `:x |em`. Its C is the form ratified later that day.
- **The flag-spelled variant (proposal-3).** `:a |b` means value and `:a? |b` means flag plus child. K12 retired it, but it is how C once coexisted with a way to put a child after a valueless label.
- **"For attributes, the value reading is ruled and uncontested" is only half right.** It is ruled (CHANGELOG, 2026-07-15/16), but it was contested and reversed the same day. Its stated ground ("plain attributes always take a value") has no counterpart in the element-rooted case.
- **The 0.10.0 texts that say child.** The neutral file cites §2.1 against §6.4/§6.10, but the child reading also has:
  - §6.8's last bullet: `|el :a 1 |beta` is a "node child";
  - §6.10's own example, "`|element "here we go!" |child …` chains";
  - the 0.10.0 tutorial §4;
  - K9's enumerated list, which omits `|name`;
  - the 0.10.1 spelling grid's separate "in the scan" vs "in a slot" columns.
- **"What follows the line" under B is less open than stated.** For attribute node values, the history already places the node at its true column, with deeper lines attached to it by column. Examples: Joseph's Jul-15 `:beta |betas second value` with aligned continuation lines; attribute-model §4/§6; CORE "its scan owns its interior … its children". A B-parser would probably inherit that (c is a child of b). The truly open part is whether a value node sits on the element stack at all.
- **Test cases the history offers:**
  - the column-aligned table (`|table |tr |td A1` / aligned `|td A2` / `|tr |td B1`);
  - Joseph's Dec-24 column cases (`|one |two |three` followed by `|alpha` at columns 2, 5, 8, 10);
  - `|a |b |c |d |e |f |g` with column returns;
  - the attribute-window cases: `|el |another …` then a block `:attr` (Joseph Jul 15: already in children phase), and `|e :attr v |child` then block `:attrs`.
- **Other block-form things at the element's slot.** Fences (`|a ```` / `|a |b :k v ````), `@ref`, `!:lang:`, `!name`. Lite reserves `!` and `@`, but fences are still in question 11. Refusal of reserved syntax also has to know whether `|a !x` is refused as a child or as a value.
- **The `|p Intro text |em emphasized` example depends on K10.** The element exists only if a text value ends at ` |name`. That was the rule in Dec 2025 and after K10 (Aug 2026), but not in 2011 or in July-2026 mainline, where prose committed the line. So this example ties question 01 to whichever rule lite adopts for how same-line text values end (questions 02 and 05).
- **HTML equivalence.** Joseph's "`$main` … the first and sometimes only part of the inner-content" (Aug 9) means A and B often render the same. The difference is in the tree, in queries, in the attribute window, and in which node owns the next line.
