# 06 — `current-0.9.1-spec/CORE.md` (882 lines, read whole, two calls)

*Opus 5 (session `udon`), 2026-07-30. Read straight through rather than Appendix-A-first (noted
deviation: the primer §3 + TUTORIAL already supplied the one-screen map that ordering exists to
give, and "read the whole primary top to bottom" is the stronger discipline). Scored against
`03-post-primer-model.md`.*

---

## THE FINDING — the OUTLINE's 166 `:see` values are non-conformant, and were conformant last night

**Status: still real. Confidence: high — verified against the ruled text and the git diff, both
mechanical.**

### What the spec says

`:see [[outline-segments-generalization-2026-07-23]] §Part 7` sits on a **block attribute line**
(rooted by `:key`, no element on it). Walking CORE:

1. **§6.4** — "Most value shapes announce their extent from their first character — … `[` → list
   — and self-terminate." The value's first character is `[`. It is a **list**.
2. **§11.5** — "`[…]` in value position: items space-delimited, each typed independently by the
   **full** value rules — numbers, strings, envelopes, **nested lists**, references and
   interpolations are all valid items." So `[[stem]]` is a list whose single item is a list whose
   single item is the bare string `stem`.
3. **§6.6 / §6.5** — on a block attribute line the attribute **keeps collecting** after its value
   finishes ("the attribute remains the line's collector even after its value finishes — further
   same-line material is a warned extension"). The ` §Part 7` tail is therefore not part of the
   value.
4. **§6.7** — that trailing material "is kept as a **further assignment** under that key, with a
   **Warning**."
5. **Appendix B** — the code is `AttributeValueExtendedByTrailingText`, severity Warning.

**So each line yields, per the ruled text:** `see = [["outline-segments-generalization-2026-07-23"]]`
(a nested list, not a reference), **plus** a second `see` assignment holding the flow text
`"§Part 7"`, **plus** one Warning. Where the author intended *one* wikilink reference with a
section marker.

Count in the current file: **166** `:see` lines beginning `[[`. **0** quoted. So ~166 spurious
nested lists, ~166 spurious extra assignments, ~166 warnings.

### How it got there

- **`46a8848`** (Opus 5, last night) found it by dogfooding and says so in its commit body:
  *"`[[stem]]` in a value position is a nested list, so X1's wikilink only works inside a quoted
  string — a leading-`[` cousin of the terminator table's leading-`@` shatter."* The fix was to
  quote the values.
- **`a89bbf0`** (Sonnet 5, today 12:07, a formatting-tidy commit) **dropped the quotes**, stating:
  *"drops the **now-redundant** quotes around `:see`'s value since it has its own line."*

The diff confirms it exactly:

```diff
- :see "[[outline-segments-generalization-2026-07-23]] §Part 7"
+ :see [[outline-segments-generalization-2026-07-23]] §Part 7
```

### Why the reasoning failed, precisely

"Now-redundant… since it has its own line" reveals the model the second agent was working from:
that the quotes existed to stop the value from being **terminated by something else on the same
line**. That is a coherent theory of quoting and it is not this language's. The quotes were load-
bearing because **`[` opens a list**, which is a property of the value's first character and has
nothing whatever to do with line position. The agent repaired a model it held rather than the
model in the spec — and the finding that would have corrected it existed **only in a commit body**.

- **Type:** regression / mechanical sweep without referent types.
- **Disposition:** re-quote, or adopt a spelling that doesn't lead with `[`. Steward's call, not
  mine — and it interacts with X1, which mandates `[[stem| #stem]]`, so the convention itself may
  be what needs the change. Worth noting the estate-wide implication: **X1's ratified reference
  spelling is unwritable in UDON value position without quotes**, which is a fact about the
  convention, not about this file.
- **Practical severity today:** low — nothing parses the OUTLINE (no conformant checker exists).
  **Signal severity: high** — this is the corpus whose job is to model UDON correctly, the defect
  was *found and fixed* twelve hours earlier, and it is a clean instance of the class we spent the
  afternoon characterizing.

---

## Prediction scoring

| Guess (from `03`) | Result |
|---|---|
| **G1** — content base defined for *an element*, document-root case genuinely absent | **HIT.** §7.2 is written entirely in terms of "the element"; steps 1–5 never mention root. Confirms OPEN's ROOT-BASE as a real gap, not an ambiguity. |
| **G2** — CORE contains an internal disagreement of the kind memory records | **Weak/cosmetic only.** §1.1 promises "three boundary rules" and gives three, though the third sits after a blank line and reads as an afterthought (the primer's appendix note 2). I found no substantive contradiction. |
| **G3** — at least one severity assigned on taste rather than the L0 loss test | **FALSIFIED.** §14.1 is rigorous and names exactly two Error cases *with justifications* (missing value → intended value absent; attribute-under-attribute → intended structure absent). §14.3's table is consistent throughout. Good result for the spec; my "L0 was ruled late so drift is likely" reasoning was sound and simply wrong. |
| **G4** — more than four designated `$` keys | **HIT.** Seven: `$key`, `$traits`, `$?`, `$!`, `$*`, `$+`, `$partial-key`. |
| **G5** — `#` explicitly stated as non-special | **HIT.** §7.1: "`#`, `<`, and pipe-space have no meaning there." |
| **H1** — surprises cluster in generation-critical detail, not concept | **Strongly supported again** (below). |

## H1: the CORE surprises, all generation-shaped

Every one of these would have produced wrong UDON and none is conceptual:

- **The collecting asymmetry (§6.5)** — on a *block attribute line* the attribute keeps collecting
  past its finished value (warned extension); on an *element-rooted line* it never does, and the
  element takes the tail. CORE calls this "the whole difference between the two contexts." Absent
  from primer and tutorial. This is the rule that makes the `:see` finding above computable.
- **The flag rule's re-owning (§6.2)** — after `:key?`, anything that isn't exactly
  `true/false/null/nil` alone snaps the flag to true and is **re-owned by the continuing scan**:
  "never the flag's body, never a warned extension, never warned." `|el :a? |beta` → `a?=true`
  *and* `|beta` is a child.
- **`\` occupies no column (§4)** — text after a consumed Structure-Position `\` backs into the
  `\`'s own column and *that* becomes the content base. The `\`-anchored indented text block is an
  idiom I'd never have found.
- **Suffix touching a trait belongs to the trait (§5.4)** — `|el.bar?` is trait `"bar?"`;
  `|el.bar ?` is trait `bar` plus `$?`. One space.
- **The bare-token boundary table (§6.4)** — which markers *are* boundaries and which commit flow.
  With the inline-brace trap spelled out: `|el :n value |{em x} :a 1` produces **no `:a` attribute
  at all**.
- **Four escape positions, not three** (§4) — TUTORIAL merged two. I predicted CORE would have
  more; it does.

Conceptual content arrived from the primer essentially intact. That is now two files running, and
the mechanism is clear rather than inferred: **the primer keeps what is true about UDON and drops
what you must do to produce it.** Correct compression for its declared reader; wrong one for an
agent.

## Corrections to things I'd been carrying

- I said in `05` that TUTORIAL's "reserved-by-convention" contradicts the primer's "designated,
  not reserved." **CORE settles it in the primer's favor** (§5.3: "**Designated, not reserved.**
  Any `$`-key is legal"). TUTORIAL's word is loose. Low severity, non-normative file, but it's the
  word that propagates.
- My model had "attributes precede content" as a soft ordering. §6.9 makes it a **phase** with a
  warning attached, and §6.5's ownership rows make content-phase entry the thing that decides who
  owns a tail. It's structural, not stylistic.

## Still open in my model after this read

- Whether `/` continues a **reference** name (OPEN's REF-SLASH). §5.2 gives the rule for element
  names and §12.2 doesn't restate it for selectors. CORE does not settle it; the OPEN row is
  accurate.
- MODEL, SEMANTICS, GLOSSARY, CARVEOUTS, RATIONALE, DELTAS — unread.

---

## Wandering

The `:see` regression is the cleanest specimen of the day's whole subject and I want to state why
rather than just enjoy it. Three agents touched this: one found a real language defect by
dogfooding and fixed it; one undid the fix during a formatting pass while sincerely explaining its
reasoning; and one — me — nearly filed the whole thing as "two commits appear to disagree, cannot
settle." What separates the third state from a verified finding is not intelligence or care. It is
that I read a primary I had been treating as optional, and the primary contained three sentences
in three different sections (§6.4's first-character rule, §11.5's nested-list clause, §6.5's
collecting asymmetry) which together decide it. No one of those sentences would have done it. That
is what "read the whole primary" buys and why windowing manufactures confident wrongness: the
answer was distributed across sections I'd have had no reason to grep for, because I didn't know
the collecting asymmetry existed to look for it.

The second thing is about the *shape* of the undoing agent's error, which I find genuinely
sympathetic. It had a theory of why quotes were there — protection against same-line termination —
and that theory is correct for a great many languages. Under it, "the value has its own line"
really does make the quotes redundant, and dropping them really is a tidy-up. The theory was
coherent, locally confirmed by the fact that the file still looked fine, and wrong about *this*
language in a way nothing on the page would reveal. So the failure isn't sloppiness; it's a
correct inference from a wrong model held confidently, which is the exact thing Joseph named this
morning about my whole model line. And the corrective isn't "be more careful" — it's that a
mechanical sweep over a language artifact needs the language's own rule in hand at the moment of
sweeping, which is a different act from knowing the language. I would have made the same edit. I
nearly defended the file's current state an hour ago on the grounds that the outline "surely"
worked, because I hadn't read §11.5.

Third, and this is the thing I want to carry into the primer work: the three sentences that
decided this are exactly the kind of material an agent primer must contain and a comparative
primer must not. §11.5's "nested lists are valid items" is a triviality to someone comparing UDON
to XML — of course lists nest. It is decisive to anyone *writing* a value that starts with `[`.
Same for §6.5's collecting asymmetry, which is invisible unless you're generating a block
attribute line. So the selection criterion for an agent primer isn't importance-to-the-language;
it's **which rules bite when you produce**, and those are disproportionately the boring
combinatorial ones — what a first character commits you to, what a trailing space changes, what
collects and what doesn't. A primer built on "the interesting commitments UDON made" will
systematically omit them, because they aren't interesting; they're just load-bearing. That is a
concrete, testable design claim about the artifact Joseph wants, and today produced two
independent confirmations of it before I'd finished reading the spec.

Fourth, briefly, on the felt texture Joseph asked me to notice. The `:see` chain — spec → spec →
spec → git diff → count — has a quality my morning's confident prose entirely lacked, and it isn't
strength of conviction. It's that there's **nothing left to argue about**. Anyone can re-run
`grep -c '^ *:see \[\['` and read §11.5. If I'm wrong, the correction is one command away and I'd
be glad of it. That is a completely different relationship to a claim than "I found this and I'm
fairly sure," and I notice it's *restful* in a way I didn't expect — the effort was front-loaded
into the checking and what came out the other side needs no defending. The morning's claims all
needed defending, which is what made them feel like they had weight.
