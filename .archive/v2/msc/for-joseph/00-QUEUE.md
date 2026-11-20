# Morning adjudication queue — 2026-08-09 (overnight passes complete)

> **2026-08-10: partially superseded.** The merge/repair/fold-in all happened;
> branch table and probe results below remain accurate as record. **The live
> decision sheet is [01-PLAIN-DECISIONS.md](01-PLAIN-DECISIONS.md)** — D1,
> D3–D9, D11 are what still block Joseph.

*Coordinator's single front door for everything awaiting Joseph. Delete after
adjudication. All work is committed on branches; nothing merges without you
(the merge gate is yours by design).*

## Where the work lives

| What | Branch | Commit | Worktree path |
|---|---|---|---|
| **Pass 1** — UNIF-PASS rewrite (K1–K14 native; two-space model; `{label, content}`; key/label/kind split; 0.10.0-alpha.1) | `worktree-agent-a2a87c49aab940bdc` | `2de5907` | `.claude/worktrees/agent-a2a87c49aab940bdc/` |
| **Pass 2** — arc reframing on top of pass 1 (§0 seven-axiom spine; Q2 sharpened; Q8 found) | `unif-pass-2` | `4ccd9f8` | `.claude/worktrees/agent-a1e3f81f5f517acd7/` |

**Primary read:** `v2/spec-0.10.00/MORNING-ADJUDICATION.md` on `unif-pass-2`
(pass 2 wrote it for you specifically), then `UNIF-PASS-QUESTIONS.md` beside it
(pass 1's said/assumed/ask items). Everything below is the index, not a
substitute.

## The decision queue

1. **Bless or revert §0** (pass 2's seven-axiom spine: columns · virtual
   lines/dual operators · two spaces · everything-is-an-assignment · two
   extents · frozen typing · keep-everything). The full physical reorder is
   proposed-not-executed (it churns every section number). Probe evidence
   below leans bless.
2. **Q2 — pick a principle, the table falls out.** Pass 2 showed pass 1's
   three clean-value-position leans (list items yes / identity brackets no /
   deferred-first-line no) follow from *no single principle*; two candidates
   (P-scan / P-line), each uniform, give different tables. One pick settles
   all three cells.
3. **Q8 (new, pass 2) — attached escape under an open value.**
   `|element :attribute hello \:-) how are you?` — K13-consistent reading now
   in the text (escaped material **joins the open value**; no `$main`), but
   your original worked example predates the K13 split and may have intended
   the framed reading. Said/assumed/ask form in the adjudication doc.
4. **Q4 — four load-bearing inferences** (pass 1): bare `:disabled?` → Error;
   framed ` ; ` still terminates values; `AttributeAfterChildren` name (vs
   `LateAttribute`); late-`$key` streaming note. Each one confirm/deny.
5. **Q7 — the envelope "label ladder"** is a third sense of *label*;
   provisionally renamed "envelope ladder." Your word if different.
6. **Q5 relics:** content-phase retired as a concept (behavior kept); element
   suffix sugar = last bare-`?` meaning (keep/retire); `EscapeOutsideHeadPosition`
   advisory probably describes nothing post-K13 (axioms strengthen this).
7. **Merge** — whichever of pass 1 / pass 1+2 you bless lands on main.
8. **Standing small list** (pre-overnight): directory rename
   (`spec-0.10.00/` → ?); `.un` extension intentional?; the older OPEN
   steward closes — **REF-SLASH / REF-BRACKET soonest** (paths corpus live);
   S4, N-jargon, IND/IND-2, FIX-FRAME whenever.

## Fresh-mind comprehension probe (pass 1 vs pass 2; n=1 each, sonnet, zero context)

Same five inputs, each reader given one suite, blind to the other:

| Input | Ruled answer | Pass-1 reader | Pass-2 reader |
|---|---|---|---|
| `:first with a value and :second …` | two attributes | ✓ (verbatim example) | ✓ (verbatim example) |
| `:hello \:value` | `hello=":value"` | ✓ (verbatim example) | ✓ (verbatim example) |
| `\|task[cleanup] Wash dishes :assignee sam` | `$key`+`$main`+attr | ✓ (composed two rules) | ✓ (composed three rules) |
| `\|el \|{a} \|{b}` | two stacked `$main`s | ✓ (near-verbatim example) | ✓ (near-verbatim example) |
| `\|el :a 1 extra :b 2` | `a=1 · $main="extra" · b=2` | ✗ — stuck between two wrong readings, honestly flagged unresolvable | **✓** — reconstructed the §6.5 ownership chain, "confident rather than guessing" |

**Findings:** (a) worked-example coverage is the dominant variable — every
verbatim example was a free correct answer; your ratified `:a 1 extra` example
belongs in the spec text verbatim (it's the one ruled case neither suite
prints). (b) The one differential case favors pass 2: its §6.5
slot-ownership wording ("open slot owns → otherwise the line root's stack")
made the finished-value→`$main` handoff *derivable*; pass 1's did not.
Caveats: single probe each, same model, pass 2 also simply newer text — 
suggestive, not proof.

## Session provenance (for the record)

K1–K14 + Overturns in `v2/DECISIONS.md` (provenance banner governs — rows are
interpretation; conflict-time protocol applies). Theory docs in
`v2/theory/to-integrate/primary/` (capture, couplings, fork-notes, K9 record).
Probe transcripts in the session task files.
