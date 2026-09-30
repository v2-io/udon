# 06 — Suffix characters `? ! * +`: discussion

**Written by:** Claude (Opus 5.5), history agent, 2026-09-29. I wrote the history section without seeing any lean. I had read only the neutral file `06-suffix-characters.md`, `pre-design/README.md`, `spec-lite-0.1.0/README.md`, and `v2/WHERE-THINGS-STAND-2026-09-27.md`.

**What this is:** the history of one question, oldest first, then my own reading, then what the neutral file leaves out. It has no lean or recommendation.

**Method.**

- **Joseph's typed words.** I scanned `~/.claude/history.jsonl` (his prompts only, no model output) whole, for all dates, with a regex, keeping prompts from udon projects or prompts that mention udon. The regex: `suffix | |name[..]?[?!*+] | $? | kleene | ?!*+ | *!?+ | zero-or-more | one-or-more | cardinality | arity | identity char | :'?'`. It returned 44 hits, and I read all of them. A second scan looked for `gut is telling me | worth the awkwardness | keep or retire | D9 | suffix sugar | special status | identity character | flag…` in udon prompts from 2026-07-10 on. I also listed every udon prompt from 2026-08-09 to 08-12, to check whether D9 was ever answered.
- **memorata-search.** I ran two batteries in JSON and merged each chronologically myself.
  - Battery 1 (`--joseph -n 60 --pool 500`, 19 queries): `suffix` · `suffixes` · `element suffix ? ! * +` · `|field? optional` · `required ! suffix` · `$? true` · `:'?' true` · `kleene star plus optional` · `optional required cardinality udon schema` · `zero-or-more one-or-more` · `suffix characters identity character` · `suffix special status retire` · `name characters allowed in element name` · `trait suffix *!?+` · `flag key ending with ?` · `question mark at end of element name` · `|field?! stacking suffixes` · `suffix after key |str[email]!` · `arity marker udon`.
  - Battery 2 (`-c agent-to-human subagent-final-response document`, 7 queries): `element suffix sugar keep or retire` · `suffix characters are not name-continue characters for element names` · `flag suffix desugar $? true alignment` · `suffix Kleene readings arity cardinality udon` · `suffix on class reserved trait` · `anonymous element |? suffix guard` · `suffix position after key |field[name]?`.
  - Ad-hoc queries: `udon element suffix ? ! * + expand to attribute` (`--until 2026-01-15 --sort oldest`), four early `--joseph` phrasings, `schemacop DSL in udon schema definition str email suffix`, `suffix trait allowed characters`, and `suffix names as just :'?' true`.
  - One flakiness note: `--joseph` combined with `--since/--until` twice returned "0 of 0 candidates" for queries that returned hits without the date filter. I stopped using date filters with `--joseph`, so an empty dated query here does not mean nothing exists.
  - Non-Claude harnesses: Codex, Grok, and Gemini sessions came up in battery 1, and none of them discusses this question.
- **Repository and git.**
  - `grep -rli suffix` over the umbrella repo (~200 files; I read the load-bearing ones listed in the entries).
  - `git log --all -G'suffix' --reverse` over the umbrella repo.
  - `git log -S` for the CORE sentences quoted below.
  - The 2011 originals are at `~/src/_older/udon/` and `~/src/_older/udon-c/`, not `~/src/_ref/` as the brief said.
  - `core/generator/10-udon.elements.descent.udon`.
  - All of `v2/`: DECISIONS, the for-joseph sheets, DISCUSSION-THOUGHTS, type-algebra, the three spec suites, the Sep 1 audit, references/.archive, theory/to-integrate, and .archived.
  - Live `.udon`/`.ud`/`.un` files under `~/src`, checked for suffix use.
- **Excluded.** I did not open raw session `.jsonl` transcripts. One memorata JSON result included an `agent-thinking` record (2026-01-02). I discarded it, filtered that class out of all later processing, and cite nothing from it. `_archive/feedback.md` is a raw transcript that contains thinking blocks. I quote only its response block (lines 147–332).
- **Missing record.** The 2025-12-22 session where the suffixes were designed (`9c70d20c`, started in `~/src/_ref/udon-c`) has no surviving transcript: only a `tool-results/` directory whose files predate the suffix exchange. That session's agent turns are therefore unknown. Joseph's side survives in `history.jsonl`.
- **Indentation.** I quote UDON only from repo files, `git show`, or `history.jsonl` parsed directly. I did not quote UDON from memorata snippets, which strip indentation.

**Dating.** "turn" means a real turn timestamp. "commit" means git commit date. A file-internal date is labeled as such.

---

## History (chronological)

### 2011-12 — the original UDON: no suffixes; `? * +` were ordinary label characters, `!` was not

- **Source:** `~/src/_older/udon-c/docs/DECIDED.md`, "SCALARS / Strings / LABEL". Commits `ecfaa4a` (2011-12-15, "solidified syntax", which introduces the rule with stop set `[|\[.]`) and `ab28dd3` (2011-12-22).
- **Speaker:** Joseph (2011 document).

> LABEL: (Restricted-non-delimited)
>     - APPLIES TO: node-name, class-name, attribute-key
>     - STOPS ON: whitespace or [|\[.!]

The 2011-12-22 diff (`ab28dd3`) *adds* `!` to the stop set (`[|\[.]` → `[|\[.!]`). The Ruby state table's name rule is also permissive: `node.identity.name` accepts `[^ \t.\[|<:\n]`, in `~/src/_older/udon/ruby/udon/udon.statetable:62`.

**Bears on this question:** in 2011, `? * +` were ordinary characters of element names, class names, and attribute keys. I found no discussion of them either way; this looks like a consequence of a permissive stop set, not a decision about these characters. `!` was deliberately added to the stop set a week later. No reason is given, but `!` opens directives in the same document. There was no suffix concept.

### 2025-12-22 19:39–19:59 (turns) — the suffixes are born, in a Schemacop-in-UDON sketch

- **Source:** `~/.claude/history.jsonl` L5428–5434, session `9c70d20c`.
- **Speakers:** Joseph, and an agent whose turns are lost (see Method).

19:39, Joseph:

> "OK-- I know this seems a little like a tangent-- but would you actually render for me an imagining of the schemacop DSL in udon? Or, in other words, what could be an udon schema definition for udon documents?"

19:46, Joseph, on the agent's rendering:

> "With the suffixes -- possibly equivalent?:  `|str[email]! ...` == `|str![email] ...` so that lexically speaking it's just splitting the element-name a bit?  Or were you thinking it gets its own treatment?"

19:49, Joseph:

> "Well, hold on. Another option, arguably as elegant:   `|str[user-name]? :min 3` == `|str[user-name] :_predicate true :min 3`"

19:51, Joseph:

> "I think :_optional and :_required are too narrow. Maybe we keep it as `?` == `:'?' true` and same with !,*,+..."

19:56, Joseph:

> "Yes. As for your class question, I think these should be acceptable:
> `|asdf?.one.two`  `|asdf[xyz]? .one.two` `|asdf?[xyz].one.two` `|asdf[xyz].one.two ?` BUT NOT `|asdf[xyz].one.two?` (or `.one?`) -- because I would like those to be used as suffixes on class identities as well (or at least reserve the possibility for now)"

19:58 and 19:59, Joseph:

> "I think we may as well also allow (but maybe not publish) `|asdf[xyz]?.one.two`" … "That second form would be accepted but not publicized also. Yes please."

**Bears on this question, directly:**

- The very first question Joseph asked was whether the suffix is *lexically part of the element name*, merely split around `[key]`, "or were you thinking it gets its own treatment?". That is exactly today's A-vs-B question.
- Within five minutes the conversation settled on "its own treatment": the attribute desugar `:'?' true`, chosen because a semantic expansion (`:_optional`) was "too narrow".
- The positions (after name, after key, spaced at end) and the trait reservation are Joseph's, from 19:56.
- Inferred from Joseph's wording, since the agent turns are lost: the agent had proposed suffixes in the rendering and apparently expanded them to `:_optional`/`:_required`-style names.

**Incidental:** `str`/`email` are schema-example vocabulary.

### 2025-12-23 13:24 (commit `f5813bd`) — first SPEC.md

- **Source:** `git show f5813bd:SPEC.md`, "Element Suffixes" and the grammar block.
- **Speaker:** document (Joseph + agent, from the Dec 22 session).

> Elements can have suffix modifiers (`?`, `!`, `*`, `+`) that expand to attributes: … `|field[name]?      →  |field[name] :'?' true` …
> UDON performs the expansion; the meaning is DSL-defined:
> - Schema DSL might interpret `?` as optional, `!` as required
> - Grammar DSL might interpret `?` as 0-or-1, `*` as 0+, `+` as 1+
>
> **Reserved** (suffix on class — for future use): `|name[id].class?  ; NOT allowed — reserved for class-level modifiers`

The grammar reads `element = "|" [ name ] [ suffix ] [ id [ suffix ] ] { class }* [ SPACE suffix ] …` and `LABEL = /[a-zA-Z_][a-zA-Z0-9_-]*/`. So names no longer admit `? * +`; that changed from 2011 here.

The companion `examples/schema-dsl.udon` puts nearly every suffix *after the key*: `|str[username]!`, `|int[age]?`, `|arr[tags]?`.

**Bears on this question:** this is the origin of the "optional/required" and "0-or-1/0+/1+" glosses, both explicitly framed as what a DSL "might" do. It is also where the dominant real-world position, suffix-after-key, was established.

### 2025-12-23 21:25 and 21:31 (turns) — "semantic meaning improperly"

- **Source:** `history.jsonl` L5520–5521, session `dd3d94a5`.
- **Speaker:** Joseph, reacting to an agent's condensed cheat-sheet that glossed `|field[email]! ; suffix ! = required` etc.

> "Why are you giving these suffixes semantic meaning improperly?"
>
> "Also, Just show exactly what these do:
>
> |functional?        ; == |functional :'?' true
> |children[clist]+   ; == |children :'+' true
>
> Showing what it does is fewer characters than incompletely explaining it, isn't it?"

**Bears on this question:** Joseph held from the start that the core assigns no meaning; the sugar is a pure spelling-to-attribute expansion.

**Incidental:** the rest of the message is about cheat-sheet ordering.

### 2025-12-23 (hallway tests) — agents' first contact

- **Source:** `test/usability/results/*.yaml`, 2025-12-23 runs.
- **Speakers:** Sonnet/Haiku test agents.
- Several first-contact reviews listed "suffixes (`!?*+`)" among the features adding cognitive load. The `topic_enablement-20251223-185501`, `-185556`, and `-190723` runs each list them among "~15 different syntactic features" or say "the spec is *dense*".
- Others adopted them unprompted as cardinality. From `topic_dsl-20251223-192241`: `|turn[user-response-1]*` with "The * suffix means 'zero or more'". From `topic_enablement-20251223-190332`: "Suffixes for cardinality (`!` required, `?` optional, `*` multi-value)".
- **Bears on this question:** this is the earliest outside-reader evidence. The characters read naturally as cardinality, and the feature registered as surface-area cost.

### 2025-12-25 18:02 and 18:19 (turns) — `?` on a class is "just part of the class-name"

- **Source:** `history.jsonl` L5732, L5736, session `38b75c32` (first libudon parser work).
- **Speaker:** Joseph.

> "I feel like maybe you didn't read the spec and don't know that: `...[myid]` == `... :'$id' myid` and `... .class1.class2` == `... :'$class' [class1 class2]` and that the '?' at the end of a class is just part of the class-name, but if it's after the id, it's == `:'$?` (which in turn is equal to `:'$?' true`)"

> "…I'm surprised though, looking at some of your thinking blocks, that you didn't ask me to clarify whether :'$?' was more correct or the SPEC's :'?' … (The answer is I'm fine with how it is in the spec right now…)"

**Bears on this question:**

- Three days after reserving class-suffixes, Joseph described a trailing `?` on a class as simply part of the class name. That is the "ordinary character" reading, for traits. It contradicted the SPEC's "reserved" line and was not reconciled until 2026-07-12.
- In the same breath, after the id, it is the attribute sugar.
- The `$?` vs `?` naming wobble starts here.

### 2025-12-27/28 (session summaries) — the parser implements the sugar

- **Source:** `~/src/_older/libudon/_archive/generator/2025-12-28-{morning,afternoon}.md`, agent-written summaries.
- "**Multiple suffixes not parsed**: `|field?!` only parsed first suffix. Fixed…" and "Added suffix handling (`?!*+`) to `:embed_name` state".
- **Bears on this question:** stacking and suffixes in embedded elements were built from the start. This is evidence of what was built, not a ruling. Stacking was not formally ruled until 2026-07-19.

### 2026-01-02 13:32 (turn) — suffix attribute names should be bare

- **Source:** `history.jsonl` L6845, session `31853cab`.
- **Speaker:** Joseph, in the same exchange where he was moving `[id]` from `$id` to plain `id`:

> "Oh-- and the suffix names as just :'?' true  etc. as well."

**Bears on this question:** this is the second turn of the desugar-target naming wobble (`?` → `$?` → `?`). The attribute *name* was never the stable part.

### 2026-01-03 (commit `b69dc0b`; session Dec 2025) — a fresh model proposes suffix-cardinality on keys too

- **Source:** `_archive/feedback.md` lines 269–314 (response block).
- **Speaker:** Opus 4.5, first-contact review, follow-up Q&A.

> "I think the answer is UDON itself, using the suffix modifiers as cardinality. … `:author! string ; required, type string` · `:date? date ; optional, type date` · `|heading! ; exactly one required` · `_text+ ; one or more text nodes` … My vote: UDON-native schema using suffixes for cardinality…"

**Bears on this question:** this is the first proposal to put suffix characters on *attribute keys* as arity marks, which is what K12 eventually made possible (2026-08-08).

### 2026-01-05 08:51 and 09:18 (turns) — Joseph uses suffixes as cardinality in a resource-DSL sketch

- **Source:** `history.jsonl` L7057–7058, session `49e83cdf` (archema).
- **Speaker:** Joseph.

> "|field[tags-by-category]? |{map :string [:integer]}  ; ? (or *,+,!) are available for elements and can indicate cardinality if we want"

> "…#2 still optional-by-default- use ! for required."

**Bears on this question:** Joseph himself treated the suffix seat as available for a dialect's cardinality ("if we want"), consistent with the Dec 23 meaning-neutral stance.

**Incidental:** `|{map …}` typing.

### 2026-01-14 16:47 (turn) — "the special attribute suffixes already in the language"

- **Source:** `history.jsonl` L7907, session `145408e9`.
- **Speaker:** Joseph.

> "…an approach similar to Relax NG that takes advantage of references and the special attribute suffixes already in the language. I suspect though, that I would like the answer to be a bit more sophisticated…"

**Bears on this question:** Joseph's own term then was "special attribute suffixes", and he was lukewarm on suffix-only schema.

### ~2026-07-07 (file-internal date; in ASF git since at least `42e2771a`, 2026-07-09) — the one live adopter

- **Source:** `~/src/arch/asf/msc/meta-process-review-2026-07-07/PROCESS-MAP-v0.udon` lines 17, 57, 127, 143, 210, 403, 419.
- **Speaker:** document (ASF process map).

> "- A `?` marks a genuinely unknown sub-process we'd have to design."
> `|process[coherence-stewardship]?`

**Bears on this question:** this is the only live consumer found by CONSUMERS.md and by the 2026-07-29 extraction probe. It uses six after-key suffixes, and its `?` means "unknown / to be designed", a natural-language question mark, not Kleene 0-or-1.

### 2026-07-08 (file `_archive/REVIEW-JULY-2026.md` §C row) — suffix naming becomes part of the identity bundle

> "DECIDE | **Identity syntax**: `@[id]` vs `|[id]`; `$id` vs `key`/`traits`; suffix-attr naming | Blocking — ASF documents accumulate exposure now…"

**Bears on this question:** the attribute naming (`?` vs `$?`) was bundled with identity. Nothing questioned the sugar itself.

### 2026-07-11 (files + turn) — identity model (C); `$?` family ratified

- **Sources:**
  - `_archive/decisions-superseded/identity-syntax-brief.md` (agent): "(c) Suffix — recommend bare `?` … suffix chars can't collide with bare attr names (non-name characters); live ASF usage is already bare-`?`."
  - Joseph at 18:06 (`history.jsonl` L15810, session `da5d1672`): "I'm kind of confused at what the problem is with the ?,!,*,+ suffixes -- you are recommending that we remove the '$' differentiator, is that right?…"
  - `identity-data-model-supplement.md` (agent): "Suffixes never drifted … already sugar-model in spec *and* impl."
  - `_archive/DECIDED.bak.md` "D1-FINAL" (ratified Joseph, 2026-07-11): "identity / traits / suffixes are **views**, not model … `?`/`!`/`*`/`+`→`$?`… into **specially-designated** (not reserved) `$`-attributes … Wire names: `$key` / `$traits` / `$?` — single family."
- **Bears on this question:**
  - This is the third turn of the naming wobble (now `$?`).
  - The agent's argument for bare `?` rested on suffix characters being *non-name characters*.
  - The model ruling made suffixes "views over designated attributes", a stronger statement of "sugar, not structure". It did not question keeping the sugar.

### 2026-07-11 (file `_archive/decisions-superseded/authority-compliance-audit.md` T1) — is "reserved syntax-space" proscription?

> "spec/FULL-SPEC.md:211–216 reserves suffix-on-class … **Question for ratification:** does the no-proscription principle extend to syntax positions (delete the Reserved subsection; suffix-on-class becomes ordinary, DSL-interpreted), or does authority 1 legitimately reserve grammar-space…?"

**Bears on this question:** this is the first time an agent framed "make it an ordinary character" as the alternative to reservation, for traits.

### 2026-07-12 00:01 (turn) — traits: "just add *!?+ to allowed identifier characters"

- **Source:** `history.jsonl` L15864, session `da5d1672`. Recorded as `_archive/DECIDED.bak.md` "D-TRAIT-SUFFIX (T1 resolved)".
- **Speaker:** Joseph.

> "suffix on class-- let's go ahead and allow right away-- just add *!?+ to allowed identifier characters that get interpreted as the trait value (we don't have "classes" anymore) without needing delimiting single-quotes"

DECIDED.bak adds: "There are no 'class modifiers' — *classes are traits now*, and the character is simply part of the trait string. (No special modifier semantics.)" It also records the disambiguation: `|foo.bar?` gives traits `["bar?"]`, `|foo.bar ?` gives traits `["bar"]` + `$?`, and `|foo?.bar` gives `$?` + traits `["bar"]`.

**Bears on this question, directly:** this is the clearest recorded instance of the move Joseph now recalls ("just another allowed identity character"), in nearly those words, but for traits, not element names.

### 2026-07-14 (subagent reports, session `da5d1672`) — parser lags the trait ruling

- Agents reported that the grammar still split `.foo?` into trait + suffix, and that ` ?` at the end became prose.
- **Bears on this question:** this is implementation lag only, and it shows the positional subtlety (maximal-munch trait vs spaced suffix) that D-TRAIT-SUFFIX created.

### 2026-07-15 14:33 (turn) — Joseph muses: keys could take `?!*+` too

- **Source:** `history.jsonl` L16328, session `18aabafc`.
- **Speaker:** Joseph, on the valueless-attribute-is-true rule.

> "That whole ':empty-attribute-is-boolean-flag' is the thing, if anything, that we could get rid of pretty easily, it's only saving a few characters. Alternately, we could make a minor modification to a recently decided thing that freed up '?!*+' etc. in trait labels (and I think attribute identifiers without needing quotes?)... Maybe we didn't touch anything about it afterall... But we could make :this-attribute? with a '?' suffix automatically a boolean if it is not followed by a value-- or maybe no rule, just a convention so that our examples make a little more sense...?"

**Bears on this question:**

- Joseph remembered (not quite correctly, by his own hedge) the trait ruling as having freed the characters more broadly.
- He offered two options for keys: a flag rule, or "no rule, just a convention".
- The flag rule was adopted that week. The "just a convention" option is what K12 later chose (2026-08-08).

### 2026-07-15 (files; CORE commit `8fa60af` 22:59) — the three-charset table; element names excluded "because suffixes"

- **Source:** `design/attribute-model-proposal-2-substrate.md` and `-3-substrate.md` §S13.
- **Speaker:** agent, "[PROPOSED]".

> "| Element **names** | XID + `-` + `/` — **not** `?!*+` as name continue (those remain element *suffixes*) | **Traits** | XID + `-` + `?!*+` + `/` | Attribute **keys** | XID + `-` + `/` + `?!*+` unquoted; **terminal `?`** = flag semantics"

CORE gained the same day: "(The suffix characters are *not* name-continue characters for element names -- there they remain element suffixes. …)"

**Bears on this question:** this is where "not name-continue for elements" became explicit text. Its only stated reason is that the characters "remain element suffixes", so the exclusion exists because of the sugar, not independently. I found no Joseph statement specifically about the element-name exclusion; it arrived inside the agent-drafted attribute section.

### 2026-07-15 (fresh-eyes review + rulings; CHANGELOG "Changed (2026-07-15 fresh-eyes review pass — rulings by Joseph)") — the `|` guard is fixed to admit suffixes

- **Source:** subagent review `agent-aa7b808e…`, item B2.
- **Speaker:** agent, with the rulings by Joseph.

> "**B2. The `|` guard makes several spec'd forms unparseable: `|?` and any suffix-first anonymous element.** … `?` is not in the guard set, so by the stated rule `|?` is prose."

CHANGELOG: "**`|` guard corrected** to include the suffix characters (`|?` parses, as Anonymous Elements always claimed)." Also: "**Spaced-trait identity form dropped**: identity is contiguous except the trailing space-separated suffix."

**Bears on this question:** the `? ! * +` entry in the `|` guard dates only from here, and exists only to make the anonymous-suffix element `|?` parse.

### 2026-07-16 02:12 and 02:55 (turns) — alignment rationale for `$?`

- **Source:** `history.jsonl` L16385, L16391, session `be2e5fbd`.
- **Speaker:** Joseph.
- At 02:12 he noticed the highlighter failing on `|field[name]*` and asked for a parser test note.
- At 02:55, on the R4 question of whether flag semantics follow quoting:

> "Hmmm.... We chose the '?' suffix specifically to *align* with the '$?' attribute being boolean and defaulting to true (actually only letting it default). I actually think that :'ready?' and :ready? staying exactly semantically equivalent is the right call. `$?` is a simple desugar. It all works out. It's already compliant..."

**Bears on this question:** this is Joseph's stated rationale for the `$?` *shape*, namely alignment with `:key?` flag attributes. Note that K12 (2026-08-08) retired flag attributes, which removes the thing it aligned with.

### 2026-07-16 (commit `4c91113`) — grammar: the spaced end-suffix never covered `!`

- **Source:** `core/generator/10-udon.elements.descent.udon` lines 98–100 and 119–123.

> "; Space-separated element-level suffix … one parameterized resolver for ? * + … ; A spaced '!' never takes this path — it keeps its dynamics meaning."

**Bears on this question:** this is evidence of what was built. In the current grammar the quartet is not symmetric: ` !` at the end of an identity is a directive opener, not a suffix. I did not check the Dec 2025 parser on this point.

### 2026-07-16 (file `spec/msc/adjudication-2026-07-paths-and-silences.md` S1) → 2026-07-19 13:43 (turn) — stacking ruled

- **Agent recommendation:** "The desugar model would make stacking free (`:'$?' true` + `:'$!' true`, order preserved)… **Recommendation: allow stacking**."
- **Joseph** (`history.jsonl` L16875): "S1 `|field?!` === `|field :'$?' true :'$!' true` - right, as desugaring would imply."
- Recorded as CHANGELOG 0.9.0-alpha.2 S1, and later v2 DECISIONS R9 and R18.
- **Bears on this question:** the ruling follows from the desugar model, with "as desugaring would imply" as its reason.

### 2026-07-19 (agent reports, session `9649850b`) — the family has no name; the double-position case is unruled

- "we don't have one canonical name for the `$[?!*+]` family — it's a naming gap." The 0.9.1 text then adopted "flag suffix".
- "`cheatsheet.udon`'s `|field?[key]+` (suffix both before *and* after the key) — the 'Suffix positions' table only shows one suffix at a time in each position; I couldn't find text ruling on combining both."
- **Bears on this question:** the positional grammar had unruled corners. The name "flag suffix" tied the sugar to flags.

### 2026-07-19/21 (files) — clean-room rewrites keep the sugar unchanged

- **Sources:** `.archived/first-pass/greenfield-2a/new-spec/SPEC.md` §4.4, `-3a/…/2-SPECIFICATION.md` §3, `-3b/new-spec/CORE.md` §5.4, and `.archived/second-pass/SPEC.md` §5.5 ("Meaning of flag suffixes is Schema/Dialect; Core only expands").
- **Bears on this question:** these are not independent evidence (all were seeded with CORE), but no rewrite questioned the sugar.

### 2026-07-22 (file `v2/spec-0.09.01/CORE.md`) — 0.9.1 baseline

§5 line 173: "The flag-suffix characters `? ! * +` are **not** name-continue characters for elements — a trailing one is a flag suffix (§5.4)." §5.4 is titled "Flag suffixes".

### 2026-07-28 (files and agent reports) — suffixes vs path syntax

- `theory/to-integrate/refine-more/paths-ideation/terminator-table.md` F-4 and §2e: "`|*.trait` is already a well-formed anonymous element carrying the `*` flag suffix."
- An agent report (session `f9626a5b`) found "the sharpest generative finding. CORE §5.4 reserves flag suffixes `? ! * +` for the schema… schemacop's DSL spells it `str! :email` / `sym? :role`."
- **Bears on this question:** the element-level meaning started blocking uses of these characters in other layers.

### 2026-07-29 (turns + register entries) — O14, O15, O17, O18: Kleene readings were "exactly *for* this"

- **Sources:**
  - `history.jsonl` L17754 (02:12): "Is the seed's 'no-globs' lean principled? It sounds like a stale hypothesis dressed as a strong effective provision, and I haven't heard anything against it or using any other Kleene star objections yet."
  - `history.jsonl` L17762 (02:26): "For clarity, maybe we say {0,1}, {1,1}, {0,N}, {1,N} or something for now-- a more exact arity?"
  - `theory/to-integrate/primary/DISCUSSION-THOUGHTS.udon` O14 (lines 543–576), O17 (694–741), O18 (743–…).
- **Speaker:** Joseph (quotes) and agent (assessments).

O14, Joseph:

> "ugh. so it's an irrelevant old grammar decision swinging our more important syntax decision-- when adding those syntactical sugars was exactly *for* this sort of thing. Ditch the "Never" at the *very least*."

The O14 assessment, by an agent, reads "the Kleene readings were the DESIGN INTENT of choosing those characters". It also records Joseph's correction: "? on an attribute key is a different mechanism from ? on an element besides."

O17, Joseph, on the `?` *flag-key* rule (not the element sugar):

> "? semantics were a forward-looking best guess that was the least complicated for the language. Forward looking to what? This. If the guess was wrong a little bit, great!…"

The O17 assessment (agent) says: "the ?!*+ element-suffix guess landed whole (the section-5.4 Kleene readings fit the arity algebra with zero grammar change) while its sibling flag-rule guess may be revised".

**Bears on this question, directly:**

- In O14, Joseph called the *desugar* ("`$*` = true", as the assessment identifies it) "an irrelevant old grammar decision". In the same sentence he said the *characters* were added "exactly *for*" Kleene/cardinality readings in other grammars.
- That separates two things the neutral file treats together: the characters' intended readings, and the core desugar.
- An agent assessment, not Joseph, judged that the element-suffix guess "landed whole".

### 2026-07-29 13:32 (turn) + `type-algebra.md` N6 — "ZERO consumers"

- **Source:** `history.jsonl` L17897; `theory/to-integrate/primary/type-algebra.md` headline 3–4, §6 N6, §7 table.
- **Speaker:** Joseph; the type-algebra fork.

Joseph:

> "There are *ZERO* consumers of the ? syntax for elements as syntactical sugar or for attributes as boolean indications."

The type-algebra §7 exemplar spells required/optional/star/plus as `|reason!` `|impact?` `|ref*` `|step+`, reading them as "`$!`/`$?`/`$*`/`$+` = true — the §5.4-intended Kleene readings, live". It spells a keyed, required element as `|decision+[key!]` ("`$key` = string `"key!"`"), and a required attribute as `:date!` ("`!` is dialect-free real estate on keys").

**Bears on this question:**

- Joseph judged the sugar consumer-free. The extraction probe the same day (`v2/spikes/extraction-probe/README.md`, committed 2026-07-29) says two things. At lines 111–113 it counts "`$?` suffix ×6 — the one live corpus using suffix flags" in PROCESS-MAP. At lines 36–39 it says "the deliberateness bits UDON has seats for (`$!`/`$?` suffixes) appear in exactly one corpus — the schema-dsl *example* — and in no live corpus". Read together, the precise figure is six `?` instances in one live document, with the `!`/`?` *deliberateness* reading found only in the example.
- The fork's schema spelling already shows the characters working as a dialect's vocabulary in three places: element sugar, the key value, and the attribute label.

### 2026-07-30 (turns + file) — Joseph's own `|segment?` and his doubt about it

- **Source:** `history.jsonl` L18145, L18146, L18185; commit `a89bbf0` (2026-07-30); `v2/theory/OUTLINE-possibilities.outline.udon` line 7.
- **Speaker:** Joseph.

> "Excellent work. Let's rename "|proposed-seg[" to "|segment?[" and then locate all of the "|gap" records and turn them into |segment? records as well."
> "…|segment? is meant to indicate a *proposed segment*"
> (13:43) "…Yes, the '?' was a quick way to make it *more* truthful technically but also misleading still (and worse, likely priming or cutting off legitimate Truth-shaped organizational forms…)"

**Bears on this question:**

- This is the largest live use in the estate: 166 `|segment?[…]` lines, all before-key.
- Joseph used `?` to name a *kind*, "proposed segment". That works as the `$?` flag under current rules, and equally as a distinct element name `segment?` under B.
- His "misleading still" remark was about the outline's organization, not the syntax.

### 2026-07-30 (files) — schema-ideation and synopsis: "one axis, four sites"

- `theory/to-integrate/refine-more/schema-ideation/README.md` §1.4 (agent): "CORE §5.4 reserves the flag suffixes `? ! * +` for the consuming schema, unassigned, suggesting '`?` optional / `!` required' — which is character-for-character Schemacop's DSL…"
- The same file's weak links, §3.3: "Four suffix characters is not many, and **§5.4's own sentence already oversubscribes them** (`?` reads as schema-optional *and* grammar-0-or-1 in one breath)."
- `theory/to-integrate/primary/late-misc-synopsis.md` line 38 (agent): the arity bounds are "the flag-suffix characters' own designed readings … one axis, four sites".
- The synopsis also suggests suffixes as seats for epistemic register-marking (line 20).
- **Bears on this question:** agents converged on the characters as a cross-layer cardinality vocabulary. One agent flagged that the core gloss already double-books them.

### 2026-08-06 23:29 and 2026-08-07 10:58 (turns) + `hypothetical-sketch.md` §4 — `h?` in a path

- **Source:** `history.jsonl` L18726, L18731; `v2/references/.archive/second-theory-iteration-2026-08-08/hypothetical-sketch.md` §4 and §5.
- **Speaker:** Joseph; agent (sketch).

Joseph:

> "@<mystuff/h?/**/p> -> any |p anywhere within any of |h1 |h2 |h3... (and use desugared @<mystuff/h:'$?' true/**/p> or something for a literal matching of `|h? |something |p the stuff`."

The sketch (agent): "The suffix characters carry their designed Kleene readings, now at a fifth site… `!` stays reserved…". It also notes the "three competing readings of `*`/`?` on selectors": name-glob, flag-match, and cardinality.

**Bears on this question:** as late as 2026-08-07, Joseph still read `|h?` as desugaring to `:'$?' true`, and wanted `?` free for globbing in selectors.

**Incidental:** `@<…>` IR spelling, `/` walk.

### 2026-08-08 13:41 (turn) + `CHEATSHEET.un` — suffix characters as arity marks on attribute labels

- **Source:** `history.jsonl` L18836; `references/.archive/second-theory-iteration-2026-08-08/CHEATSHEET.un` line 6.
- **Speaker:** Joseph (example); agent (conventions line, attributed "steward 2026-08-08").

Joseph's example (from `history.jsonl`, whitespace preserved):

```udon
|t[ REFERENCE-ACT ]  The act of supplying @[DESCRIPTOR]s that narrow the "world" down to an intended @[REFERENT]
                     |rel :descriptor+           @[DESCRIPTOR]
                          :expected-cardinality! @[EXPECTED-CARDINALITY]
                          :target+               @[REFERENT]
                          :resolved-by           @[RESOLUTION-ENGINE]
```

The CHEATSHEET conventions line reads: "suffix-bearing keys quoted (`:'verb+'` — `!` exactly-one · `?` at-most-one · `+` one-or-more · `*` zero-or-more)".

**Bears on this question:** Joseph, writing freely, put the Kleene suffixes on *attribute labels* as a plain convention, which is the K12 pattern one day early.

**Incidental:** `|t[…]`, `$main` sameline text, `@[…]`.

### 2026-08-08 23:57 and 2026-08-09 00:05 (turns) → K12 — labels: flags retire; `?!*+` become ordinary label characters

- **Source:** `history.jsonl` L18884–18887, session `6ce33695`; `v2/DECISIONS.md` K12 (jaw 2026-08-08/09).
- **Speaker:** Joseph; agent (row text).

Joseph:

> "…I think flag attributes were an overkill... Or rather, having them default to "true" and complicate the attribute-label / values  rhythm wasn't/isn't worth the awkwardness...  I'm thinking instead we make sure that we simply make sure that attribute identities get identifies that are a lot more expressive than some other identifiers-- e.g., allow them to have (in any position, without quotes):  `*` `$` `#` `!` `?` `^` `.` `,` `-` `+` `_` `=` `~` `/` `'` … + the unicode stuff."
>
> "2 seems safer, but it's not. My gut is telling me it's going to be another instance of limiting an important use-case because of an unimportant failure mode."

The K12 row (agent-written) consequences include: "the CHEATSHEET arity-suffix collision dissolves (all four suffix chars are inert key characters)… `?` is an ordinary key character… Element *suffix* sugar (`\|el?` → `:'$?' true`) survives — it writes an explicit `true` and is unaffected; retiring it too is a separate call if wanted."

Joseph, 2026-08-09 00:39 (L18898), on terminology: "You really need to stop calling attribute labels keys though don't you? Didn't we reserve that term for |abc[this is a key] ?" K12's "keys" means attribute *labels*.

**Bears on this question, directly:**

- This is the "no special status, ordinary identity character" move made in Joseph's words, for attribute labels.
- His phrasing, "attribute identities get identifiers that are a lot more expressive than some other identifiers", scopes the widening to labels and contrasts them with other identifiers.
- Retiring the element sugar was explicitly left as "a separate call".
- Since K12 removed flag keys, the 2026-07-16 alignment rationale for `$?` no longer has a counterpart.

### 2026-08-09/10 (files) — the "keep or retire" question is put to Joseph; no recorded answer

- **Sources:**
  - `v2/spec-0.10.00/CORE.md` §5.4 line 247: "*(Suffix sugar writes an explicit `true`; it is now the only place a bare `?` carries built-in meaning. Retiring it too is an open steward option — working-notes.)*"
  - `v2/spec-0.10.00/CORE.md` §6.2 line 287 (labels): "`?` `!` `*` `+` and every other character are simply part of the name. Application-level conventions (arity suffixes, grouping prefixes) are free to assign meaning; the core stores the spelling."
  - `v2/msc/for-joseph/UNIF-PASS-QUESTIONS.md` Q5 items 2 and 4.
  - `v2/msc/for-joseph/00-QUEUE.md` item 6.
  - `v2/msc/for-joseph/01-PLAIN-DECISIONS.md` D9.1.
  - `MORNING-ADJUDICATION.md` item 3.
- **Speaker:** agents (0.10.0 unification passes).

UNIF-PASS Q5.4:

> "**The `|` element guard's suffix-char clause** (`|?` parses via `? ! * +`) reads oddly now that those characters are ordinary *key* characters — fine as is, but the asymmetry (elements restrict; keys don't) is now the explanation, and the old wording implied flags."

D9.1:

> "**Element suffix sugar** `|el?` → `:$? true` — now the only bare `?` with built-in meaning anywhere. Keep (harmless, schema-facing, and your CHEATSHEET arity convention uses the suffix position) or retire. **Recommendation: keep.**"

**Bears on this question, directly:**

- The retire option was surfaced three times, with an agent recommendation to keep.
- D9's "your CHEATSHEET arity convention uses the suffix position" seems to conflate the cheat-sheet's *label* suffixes (`:descriptor+`) with the *element* sugar.
- I found no Joseph answer. His udon prompts for 2026-08-09 through 08-11 (listed in full) do not address D9, and `WHERE-THINGS-STAND` records D9 as still open.

### 2026-08-27 (files) — 0.10.1-draft keeps the sugar and adds reference cardinality

- **Sources:** `v2/spec-0.10.01/CORE.md` §5.4; `DELTAS.md` row 6; `NUANCE-AUDIT.md` line 46.
- **Speaker:** agent (Fable session).

DELTAS 6:

> "trailing `?` `*` `+` on a reference head declares {0,1}/{0,N}/{1,N}; default {1,1} … reuses the suffix vocabulary in its existing arity sense"

NUANCE-AUDIT: "Suffix sugar … **convention, kept** | schema-facing; harmless; the retire option stays open. … the two uses reinforce rather than collide."

**Bears on this question:** the characters were being reused on `@` heads. 0.10.1-draft was later called a misfire by Joseph (Sep 1), so this is an idea on record, not a direction.

### 2026-09-01 (file `v2/spec-0.10.01/working-notes/AUDIT-2026-09-01.md` A3, A5, D11) — the collision the draft missed

- **Speaker:** agent (auditor).

> "**A3. Trait-continue `?` vs cardinality `?` — collides in the draft's own example** … `@user.admin?` is **either** name `user`, trait `admin?`, cardinality `{1,1}` **or** trait `admin`, cardinality `{0,1}` — and the text decides nothing."

D11 lists "`|el?foo` — suffix then junk; `@x!` — `!` is not a cardinality".

**Bears on this question:** making `?` an ordinary identity character (already true of traits) collides with any later positional use of the same character on the same token. B would extend the trait case to names.

### 2026-09-29 18:02 (turn) — the question as posed

- **Source:** `history.jsonl` L21298.
- **Speaker:** Joseph.

> "suffixes I wanted to retire their *special status* -- I am *pretty sure* (we'll need to look into it) that the intent was to make it just another allowed identity character."

---

## Threads worth noticing

*My reading of the history above, not a lean.*

**1. What the record shows about "just another allowed identity character".**

- **What I found:**
  - I found no statement, by Joseph or any agent, that the intent for **element names** was to make `? ! * +` ordinary name characters.
  - The record does show that exact move made twice, in Joseph's own words, for the *other two* identity-ish tokens: **traits** (2026-07-12, "just add *!?+ to allowed identifier characters that get interpreted as the trait value") and **attribute labels** (2026-08-08, K12: "attribute identities get identifiers that are a lot more expressive…", with flags retired).
  - After K12, element suffix sugar was the only remaining "special status". Retiring it was put to Joseph as an explicit option three times (the K12 row, the 0.10.0 §5.4 note plus UNIF-PASS Q5, and D9) with an agent "keep" recommendation, and I found no recorded answer.
- **My inference (not verified):** the recollection fits the direction of travel, and it plausibly carries the traits and labels decisions over to elements, where the question was teed up and left open. The 07-12 wording ("allowed identifier characters") is close to the 09-29 wording ("allowed identity character").
- **The oldest datum cuts both ways.** On the very first day (2025-12-22 19:46), Joseph's first instinct was the lexical reading: "`|str[email]!` == `|str![email]` … just splitting the element-name a bit? Or were you thinking it gets its own treatment?" He then chose "its own treatment" five minutes later, because `:_optional` was "too narrow" and `:'?' true` stayed meaning-neutral. So "part of the name" was the first idea, considered and set aside, not a lost intent. The agent's reply to that question is lost.
- **Recorded reasons that point the other way:**
  - 2026-07-16: "We chose the '?' suffix specifically to *align* with the '$?' attribute… It all works out."
  - 2026-08-07: Joseph still used the desugared `|h:'$?' true` to match `|h?` literally.
  - The 07-16 alignment was with flag keys, which K12 then retired, so that reason is no longer live.

**2. The characters' readings versus the core desugar.**

- O14 (2026-07-29) separates two things. Joseph valued the characters' Kleene and cardinality readings ("adding those syntactical sugars was exactly *for* this sort of thing"). In the same sentence he dismissed the definition-layer desugar as "an irrelevant old grammar decision swinging our more important syntax decision".
- From Dec 23 ("semantic meaning improperly") onward, his stable position was that the core assigns no meaning.
- K12 shows what "keep the readings, drop the core mechanism" looks like for labels: "Application-level conventions (arity suffixes…) are free to assign meaning; the core stores the spelling".
- So retiring the special status need not mean giving up the Kleene intent. It moves the reading from a core desugar to consumers, the same way K12 did for labels.

**3. The desugar target was never stable, but "core expands, the DSL decides" was.**

The attribute name went `:'?'` (Dec 22) → `:'$?'` "is fine either way" (Dec 25) → bare `?` (Jan 2) → `$?` (Jul 11). The part that never moved was that the meaning belongs to a schema or dialect.

**4. The action is at the key position, and the real `?` is not Kleene.**

- **Where the suffix sits:**
  - Almost every example since the first SPEC puts the suffix after the key: `|str[email]!`, `|field[name]?`, and 60 lines in `design/examples/schema-dsl.udon`.
  - The one live adopter does too (`|process[k]?` ×6).
  - Joseph's own heavy use puts it before the key (`|segment?[slug]` ×166).
  - Under B, the before-key use becomes a plain name (`segment?`), with no change in reading for a human. The after-key use becomes an open problem, which is the Dec 22 question again.
- **What `?` means in real use:** "unknown sub-process we'd have to design" (PROCESS-MAP) and "proposed segment" (OUTLINE). Both mark a variant *kind* of thing, which is closer to a name than to a boolean flag or 0-or-1. Only examples and theory sketches use the Kleene readings.

**5. `!` has always been the odd one.**

- 2011 added `!` to the label stop characters (the stop set is written down without a reason; `!` opens directives in the same document).
- The spaced end-suffix does not cover `!` in the current grammar.
- Lite reserves `!` in all its forms.
- A rule that treats all four characters alike runs into `!` in ways the other three don't.

**6. The "not name-continue for element names" sentence has no reason of its own.**

It entered CORE on 2026-07-15 inside an agent-proposed charset table, whose only stated reason was "those remain element *suffixes*". Traits went from "reserved for class-level modifiers" (Dec 22) to "just part of the trait string" (Jul 12). The element-name exclusion is a consequence of the sugar, so removing the sugar removes its reason.

**7. Other layers keep wanting these characters.**

- Paths wanted `*` and `?` for globs and cardinality (Jul 28–29, Aug 6–7).
- References wanted `? * +` for cardinality (0.10.1-draft DELTAS 6).
- Schemas wanted all four (Dec 22, Jan 5, Jul 29, Jul 30).
- Each time, the element-level meaning or the identity-character meaning got in the way: `|*.trait` was already a flagged anonymous element, and `@user.admin?` was ambiguous (A3).
- This happens whether the characters are sugar or name characters. The difference is only which reading those layers have to work around.

---

## What the neutral file misses

1. **The history leaves the after-key position (B's sub-question) open.** It is the most-used position historically and live: schema-dsl ×60, PROCESS-MAP ×6, the SPEC and CORE examples. The Dec 22 question suggests a variant the neutral file doesn't list.
   - **B′, the suffix belongs to the name even when written after the key.** `|str[email]!` ≡ `|str![email]`:

     ```text
     document
     └ element str!
         $key "email"
     ```

     This is Joseph's first reading ("lexically … just splitting the element-name a bit"). It keeps every existing spelling legal and gives the after-key form a meaning, at the cost of a name that isn't contiguous in the source.
   - **B + C hybrid, name characters but refuse the old positions.** The characters are ordinary inside a name, but one directly after `]` or spaced at the end of the identity is refused as reserved. That keeps lite forward-compatible with either full-language outcome. Note that it refuses exactly the spelling the live adopter uses (`|process[k]?`).

2. **Live exposure, measured on 2026-09-29.**
   - 166 `|segment?[…]` lines in `v2/theory/OUTLINE-possibilities.outline.udon` (before-key; same human reading under A and B).
   - 6 `|process[k]?` lines in ASF `PROCESS-MAP-v0.udon` (after-key; meaning changes under B, refused under C).
   - 60 lines in `design/examples/schema-dsl.udon` (after-key), plus a few in `comprehensive.udon`, `minimal.udon`, `cheatsheet.udon` (including `|field?[key]+`), and the type-algebra exemplar.
   - The only non-example live use means "unknown / to design", not Kleene.

3. **Why `$?` has its shape, and that the reason is gone.** The `$?` spelling was chosen to "align" with `:key?` flag attributes (Joseph, 2026-07-16). K12 retired flag attributes, so A as it stands keeps a sugar whose stated reason for its shape no longer applies. This is a fact about A, not an argument about it.

4. **`!` is not like the other three.**
   - A spaced ` !` at the end of an identity is not a suffix in the current descent grammar, which routes it to directives. CORE's position table doesn't carve out `!`.
   - In 2011 `!` was deliberately added to the name stop characters.
   - In lite `!` is reserved. Under B, `|field!` is a name containing `!`; the neutral file doesn't say how that sits with "reserve `!` in all its forms", or with reserved `!{{…}}` next to a name (`|a!{{x}}`: name `a!` plus text `{{x}}` in lite, versus whatever the full language does with `!{{`).
   - Under C, `|field!` and `|!` need to be reported as reserved-suffix and not reserved-directive, or the other way round.

5. **The `|` guard's suffix clause is recent and exists only for `|?`.** It was added 2026-07-15 so the anonymous-suffix element parses. Under B, with names still starting at `XID_Start`, `?` can't start a name, so the neutral file's "element named `?`" reading would need a start-set change. The UNIF-PASS note (Q5.4) already flagged the clause as reading "oddly". The same applies to `|*`, `|+`, and `|!`.

6. **The spaced end form existed for one job.** ` ?` at the end of the identity was created so an element-level suffix could follow traits (Dec 22 and Jul 12; the spaced *trait* form was dropped Jul 15). Under B it has no job, so `|el.bar ?` would be sameline text: `$main "?"`.

7. **An unruled double position.** `|field?[key]+`, a suffix both before and after the key (in `design/examples/cheatsheet.udon`), was flagged unruled on 2026-07-19. Each alternative needs to say what it produces.

8. **Stacking under B.** `|field?!` was ruled to stack "as desugaring would imply" (S1, R18). Under B it is the name `field?!`. That is simple, but it is a change in what a ruled example means.

9. **Where the Kleene readings already live without special status.**
   - Attribute labels after K12 (`:descriptor+`, `:date!`).
   - Key values (`[key!]` → `$key "key!"`).
   - Trait values (`.foo?`).
   - The type-algebra fork's schema spelling uses all three and needs "zero grammar change".
   - The neutral file's "glossed as intended for schema/grammar readings" line is broader in the record. It covers schema cardinality, the arity algebra, path and selector cardinality, and reference expected-cardinality, all spelled as dialect conventions.

10. **Collision cases beyond `@tags*`.**
    - Selector `h?`: glob, flag-match, or (under B) literal name (2026-08-06/07).
    - `|*.trait` as a path wildcard was blocked by the anonymous `*` element (2026-07-28).
    - A reference head `@user.admin?`: trait character or cardinality (Sep 1 audit A3). Under B the same question arises for `@user?`.
    - These are future-syntax cases outside lite, but lite's contract (same tree under every future version) means whichever reading lite fixes for `|name?` constrains them.

11. **What a lite parser does today versus the history.** The current descent grammar (the implementation route named in the lite README) implements A, including stacking and suffixes in embedded `|{…}` since Dec 2025. So B and C are grammar changes to the descent source, not only spec text. The traits change of 2026-07-12 is the precedent for how small such a change was (a character-class extension).
