# Peer revision pass (after Gemini ↔ Grok audit)

## Inputs

1. [`../feedback-from-gemini.md`](../feedback-from-gemini.md) — Gemini on 3b
2. [`../../greenfield-3a/feedback-from-grok.md`](../../greenfield-3a/feedback-from-grok.md) — my audit of 3a (steal list §8)
3. 3a suite shape (Grammar / Spec / Dialects / Glossary; later DECISIONS)

## What Gemini said (and what we did)

| Feedback | Action |
|----------|--------|
| DECISIONS / MODEL / comments-in-ADM / SEMANTICS praised | Kept; no regression |
| CORE still long / mechanical rules dense | Added scannable [GRAMMAR.md](../new-spec/GRAMMAR.md); dual-track README |
| Is `pop while` codified? | Already was (prose §3.2); **elevated** formula into main Nesting Rule text + GRAMMAR §2 + Appendix B pointer |

We did **not** cut CORE’s completeness to match 3a’s line count — Gemini also
called the thoroughness a strength. Compression lives in the Grammar front
door, not by deleting ownership/EOF/sugar edge rules.

## What we stole from the 3a audit (our own §8)

| Idea | Action |
|------|--------|
| Tighter landing map / dual audiences | README “Fast paths” table |
| Grammar as a real pillar | GRAMMAR.md (non-normative; CORE wins) |
| Glossary policy: parser terms out of user docs | GLOSSARY header policy paragraph |
| Compression courage | Applied to GRAMMAR extract, not by gutting CORE |

## Deliberately not stolen from 3a

- Implicit document root Element (we keep forest ADM — their feedback to
  themselves / our critique still stands)
- “Same coverage as CORE in 367 lines” framing
- Dropping one-way door, attr-under-attr, full ownership, etc.

## Files touched this pass

- `new-spec/GRAMMAR.md` (new)
- `new-spec/CORE.md` (§3.2 pop-while prominence, Appendix B)
- `new-spec/README.md` (fast paths, GRAMMAR in map)
- `new-spec/GLOSSARY.md` (vocabulary policy)
- `new-spec/DECISIONS.md` (D16)
- `work/peer-revision.md` (this file)
