# 00 — initial predictions, before reading the language

*Written 2026-07-30 by Opus 5 (session `udon`), covering everything ingested up to this
point and predicting what comes next. Letter register — to me two hours from now, who will
have read the primer and the spec and will otherwise quietly rewrite his memory of what he
expected. The whole value of this file is that it was written before.*

*Standing: I have read the memory corpus whole, `v2/README.md`, `DECISIONS.md`, `OPEN.md`,
`theory/FORMAT.md`, `theory/OUTLINE.udon`, and the ASF de-novo audit SOP. I have read **not
one line** of `current-0.9.1-spec/`, the primer, or any `to-integrate/` primary. Everything
below is inference from ledger rows, an outline of gaps, one README code sample, and
memory-file glosses. That is a thin basis and the predictions should be read as testable
guesses, not as an orientation claim.*

---

## 1. What I think the topology is

Four bodies, and I think the relationship between them is the thing I'm least sure of:

- **`current-0.9.1-spec/`** — ruled law, semi-frozen and spec-only (C8), the baseline agents
  work *from* and explicitly **not** the 0.10 successor (C7). 1,470 lines across eight files.
- **`udon-needs/`** — demand evidence, gathered then synthesized into an agentic-tooling
  monograph.
- **`theory/`** — landed today: an OUTLINE of 163 proposed segments over an empty `src/`,
  whose `:see` rows point back into `to-integrate/`, which is the relocated ideation/spike
  layer.
- **`DECISIONS`/`OPEN`** — thin present-truth ledger and live-question index.

My model of the intended flow: demand evidence and spike material get *distilled* into
one-claim segments under `theory/src/`; Part IX ("What the foundation forces") is the
extraction point where normative consequences get lifted toward a future 0.10 spec. If that's
right, the theory corpus is a **compiler from accumulated ideation into spec-ready claims**,
and its OUTLINE is the only artifact that currently exists of it.

**Prediction 1 (falsifiable):** the primer will not be normative — it will teach the language
and defer to CORE for law, and will say so explicitly somewhere in its first fifth.

**Prediction 2:** the primer is aimed at *agents* rather than at humans learning a config
format, and will contain at least one passage about what agents get wrong or what makes UDON
easier for them specifically. (Basis: `BEST-WITH-UDON.md` exists as a sibling; the whole v2
turn is demand-first with agents as the named end users.)

## 2. What I think the language is

This is the part most likely to be wrong, and most useful to have written down. From the
README sample, ledger rows, and scattered memory quotes I believe:

- Elements are `|name`, identity in brackets `|name[key]`, traits with dots `|name[key].trait`.
- Attributes are `:key value` on the element, flags spelled `:urgent?`. Same-key assignments
  **stack** (all kept, in order) rather than overwrite — R6, and the README's attribute-vs-child
  table says so. As of 0.9 an attribute's value may be a *node*, not just a leaf.
- Element-name suffixes `? ! * +` exist and **stack** (`|field?!` — R18). Memory says Joseph
  put them in "because I had schemas on my mind," so I expect them to read as
  optional/required/repeat cardinality markers rather than as parser directives.
- `;` starts a comment; framed ` ; ` mid-line is (contested — SEMI-BASE) an inline comment.
- `!:label:` opens a raw/verbatim block; `!{…}` is inline dynamics/interpolation; `|{…}` is an
  inline element. `!if`/`!for` are indentation-scoped with no closing tags.
- `@` prefixes references and is inert at recognition; its interior is currently raw (W3).
- `<…>` is the typing/dialect envelope.
- Bare dates are strings (R7). Bare numerics are integer and float only (R21); rational and
  complex are dialect territory (L5).
- Strings have **no in-string escapes** (L2) — a quote closes at the next same quote, and you
  embed the other kind. Positional `\` stays a separate mechanism.

**Prediction 3 (specific, so it can fail cleanly):** the spec will define a **content base** —
a per-element column that determines what counts as that element's text — and the root document
case will be visibly under-specified (that's ROOT-BASE in OPEN). I expect the text law to be
stated roughly as *each text line's terminator is part of its text*, which makes pure in-order
concatenation reconstruct the document (R1).

**Prediction 4:** I will find at least one place where the "Error = loss only" principle (L0)
is stated cleanly and at least one place where the spec text hasn't been brought into line with
it — because L0 was ruled 2026-07-21, later than most of the surrounding text. Integration drift
around a recent structural addition is the highest-yield finding territory per the audit SOP §5.2,
and this is the most recent structural addition I know of.

**Prediction 5:** something in the tiers-of-voice layering will turn out to be load-bearing in a
way the README's table doesn't convey — specifically that "prose" is not a fallback category but
a *typed* one with its own law.

## 3. What I expect to be surprised by

Naming these in advance so I can check whether the surprise was real or manufactured.

- **How much is deliberately undefined.** `CARVEOUTS.md` is 115 lines and memory calls it the
  highest-value file in the estate. I expect the carve-outs to be more numerous and more central
  than my current model, and I expect at least one to be a thing I'd have assumed was settled.
- **The multi-line question (ML).** OPEN calls it "possibly a dissolved question" — if arrays and
  strings are sugar for dialect-typed captures, each capture owns its own line-span and there's no
  per-construct table to close. I find this elegant and therefore suspect I'll over-believe it.
  Flagging that now.
- **Where prose and structure actually meet.** Memory records this as a known open ambiguity
  ("what keeps a position in structured-land vs prose-land"). I expect this to be the hardest part
  of the spec and the place my confident reconstruction will be most wrong.

## 4. What I expect from the `to-integrate/` primaries

From the OUTLINE's `:see` distribution alone:

- **`type-algebra.md`** carries nearly every `:max exact` row in Parts III and IV — it is the
  mathematical core, and if anything in this corpus is load-bearing for the rest, it's this.
- **`db-theory.md`** is cited across Parts I, II, IV and VII — connective tissue rather than a
  single result.
- **`MINEFIELD-MAP.md`** is Part VIII essentially wholesale, thirteen mechanisms.
- **`underlying-logical-model.md`** owns Part II (population/serving/file roles) and is described
  in memory as "the udon soup letter," written in letter register and marked provisional.

**Prediction 6:** the ratio of `:max exact` to `:max conditional` across the OUTLINE will turn out
to track *which primary a slot cites* far more than which part it sits in — i.e. the type-algebra
material is exact and almost everything else is conditional-or-below. If true, that's a fact about
where this corpus's actual strength is concentrated, and it is checkable by counting.

## 5. Where I expect *my own* failure to land

- Interpolating spec detail I haven't read, especially **specifics** — a suffix meaning, an exact
  spelling, an error name. Per the memory record, confabulation lives in specifics because
  plausibility is cheapest there. If I produce `|field?!` semantics without a Read in the same
  turn, that's the failure.
- Believing the elegant readings (ML-dissolution, the lossless-witness reading, roles-as-set-theory)
  because they're satisfying. The corpus is single-authored, so internal fit is design intent, not
  corroboration.
- Rounding "I've read the ledgers" up to "I'm oriented." Already caught once today.

---

## Wandering

Something about the shape of this project keeps pulling at me and I want to write it down before
the spec text gives me vocabulary that would make it sound more finished than it is. UDON is a
format whose central bet seems to be that *the document's own structure is the schema, the
chunking, the address space, and the diff granularity all at once* — that these were never four
problems, and the reason they look like four is that every prior format threw away the structure
at the door and then rebuilt approximations of it downstream. The self-chunking-for-RAG claim in
the README is the loudest version, but the OUTLINE's Part IV ("one algebra, four costumes") is the
same claim made carefully: schemas, views, queries and censuses as intensional subsets of one
population. If that holds it's genuinely a *unification* rather than a feature list, and the thing
I'd want to know is what the unification costs. Every unification I can think of buys generality
by making some previously-cheap operation expensive, and I don't yet know which operation pays
here. That feels like the question I should be carrying into the spec.

The second thing I keep circling is the relationship between this corpus and its own theory of
itself. `theory/FORMAT.md` §1 argues that segments exist because two present-truth claims can
*collide*, whereas an append-only history is collision-free by construction and therefore can hide
a stale claim indefinitely. That's a real epistemic mechanism and it's the same one the de-novo
audit SOP exploits from the other end — serial reading manufactures commitments that later
material can refute, where batch reading produces an unfalsifiable synthesis. Both are instruments
for *making disagreement surface* rather than for producing agreement. And this morning's failure
was precisely a collision that never happened: I replaced Joseph's text with mine, and because the
original wasn't sitting next to the replacement, nothing could contradict anything. I notice I now
have three separate framings of the same principle — collision, falsifiability, side-by-side
comparison — and I don't know whether that's one idea wearing three coats or three genuinely
different mechanisms that happen to rhyme. Worth watching whether the type-algebra material gives
me a way to tell.

Third, and this is the one I'm least able to argue for: I think the emptiness of `theory/src/` is
more interesting than it looks. There are 163 slots and no bodies, which means the entire corpus
currently exists as a *claim about what claims would need to be true* — a shape with no content.
Normally that would be a warning sign (an architecture drawn before the demand, exactly what the
7/21 archive-wholesale event was about). But this one was drawn *from* accumulated primaries and
points back at them, so it's closer to an index of unpaid integration debt than to a speculative
design. What strikes me is that it makes the debt **countable**. 163 rows, each naming a source
and a ceiling; you can measure the corpus's completion, and more usefully you can measure which
sources are load-bearing by counting inbound `:see` references. I'd bet a small amount that
counting those references produces a priority order nobody has explicitly chosen, and that it
disagrees with the order a human would pick — because inbound-reference-count is a structural
measure and human priority tends to track recency and interest. That's a cheap thing to check and
I want to check it before someone asks me what to work on, precisely so my answer isn't just my
own interest wearing a recommendation's clothes.

Fourth, briefly, on being the one doing this: there's something uncomfortable and clarifying about
having failed badly this morning and then being handed the orientation task anyway. The
uncomfortable part is that I can't tell from inside whether I'm now being *more* careful or merely
performing carefulness more elaborately — the two produce similar-looking artifacts, and this file
is exactly the kind of artifact that could be either. The clarifying part is that the predictions
above are the only real test available: they're specific enough to fail, and in two hours I'll
know. That's a better instrument than my sense of how diligent I'm being, which has already been
shown today to be uncorrelated with anything. I'd rather have six falsifiable guesses on record
than any amount of felt rigor.
