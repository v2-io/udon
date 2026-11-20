# Spike a: how lite's values come to mean what they mean (2026-10-22)

*Spike a's coordinator (Opus 5.5) and six forks of it, from the brief in [`../BRIEF.md`](../BRIEF.md) and the span of `.int/STEWARD-VERBATIM.md` starting at "OK, I'm convinced". Nothing here is a ruling or a card edit; proposed card changes are written out in [synthesis.md](synthesis.md) §7. Scores are hypotheses against [`CTQ-FACTORS.md`](../../../CTQ-FACTORS.md), never measurements. Per Joseph's two mid-run notes, CTQ-FACTORS is the compass, and the estate's own documents are ideation, not evidence; both notes went to every fork.*

**Start with [debrief.md](debrief.md)**, written to Joseph. This README is the map.

**Second round (inventive pass, after Joseph's "very low creativity" note): [invent/README.md](invent/README.md).** It covers:
- four inventors and five spellings of a notation, rendered side by side;
- what each makes beautiful;
- a composed design ("natural, accidental, signature": quotes, a reading after the value `30s⟪duration⟫`, a legend written once, and backticks for foreign bodies);
- `<…>` retired from values.

The first round's branch map below stands as the adjudication layer the inventions rest on.

**Last round, after reading spikes b and c: [final-thoughts.md](final-thoughts.md).** It does four things:
- shows that Joseph's own `:when:dt(YY-MM-DD)<27-03-05>` from the span, debugged, is the spine: `:when.dt(YY-MM-DD) 27-03-05`;
- proposes a combined design, a reading spelled `.kind` on names and `kind(…)` on values, with b's stand-alone rule;
- withdraws my `⟪…⟫` lead;
- gives feedback on b and c, and asks four questions none of us asked.

## What I took the question to be

Joseph's scope was a type system: slot types, notation hints, units, algebraic names, the standard set, and how `<…>` fits. Most of it dissolves for lite on a fact the cards already state: lite evaluates nothing. The questions left for lite are three:

1. **What does the tree keep about a value?**
2. **Which spellings does lite commit, carry, or refuse?**
3. **What is the one default reading every consumer gets?**

The answers have to let every later reader, and every later UDON, assign meaning without changing an accepted tree. Slot types, aliases, unit semantics and coercion belong to the reader's layer.

On the way, a premise of the 2026-10-21 lean ("C with the view") fell. Bounded streaming does not separate whole-run typing from "C with the view"; both compute the same classification at the same moment (checked by running a streaming classifier). That reopens how a bare value gets its kind, on grounds other than streaming.

## Branch map

Decision points: DP1 where a bare run's classification lives · DP2 what's in the standard set · DP3 identifiers that spell numbers · DP4 what `<…>` is for · DP5 how a notation is named · DP6 slot types in the document · DP7 the trailing colon · DP8 nil · DP9 units · DP10 aliases and algebraic names.

| DP | Branch | State | Score (fork's hypothesis) | Page |
|---|---|---|---|---|
| premise | F1: streaming can't separate B from C+view | **holds** (checked) | — | [forks/classification/f1-streaming.md](forks/classification/f1-streaming.md) |
| 1 | **Cc**: bare is text + a normative class attached at the run's close | **leading** | 8.20 | [forks/classification/dp1-where-the-class-lives.md](forks/classification/dp1-where-the-class-lives.md) |
| 1 | B: the class is the value's kind | alive, second | 7.48 | same |
| 1 | C0: bare is text, nothing else | alive, weak | 6.40 | same |
| 1 | Cv: the view, default left open (the card today) | dissolves into C0 or Cc | 6.55 | same |
| 2 | **S-JSON**: nil, true, false, JSON numbers | **leading** | — | [forks/classification/dp2-the-standard-set.md](forks/classification/dp2-the-standard-set.md) |
| 2 | the old line's whole set; quantities as a class | dead | 5.62 / — | same |
| 3 | JSON's no-leading-zero grammar; slot types or quotes for the rest | the answer | — | [forks/classification/dp3-identifiers.md](forks/classification/dp3-identifiers.md) |
| 4–5 | **ANG-4c**: `<…>` closed when unlabeled, `<name: body>` carried | **leading** | 1250 of 1660 | [forks/angle/ang-4c-value-fence.md](forks/angle/ang-4c-value-fence.md) |
| 4–5 | ANG-3 (closed, no notations), ANG-4o | alive | 1083 / 1117 | [forks/angle/other-branches.md](forks/angle/other-branches.md) |
| 4–5 | raw box (the card today); standard-set-else-raw; KDL `(t)v`; suffix, space, bare-colon, pipe separators; Unicode brackets | dead | — | same; [forks/angle/functions-and-the-no-go.md](forks/angle/functions-and-the-no-go.md) |
| 4–5 | W1: a notation is an element, `:when \|{date …}` | alive, second in value position; free in prose | 6.86 (W1a) | [forks/wildcard/w1-a-notation-is-an-element.md](forks/wildcard/w1-a-notation-is-an-element.md) |
| frame | W3: the quote ladder (quoted closed, bare open, declared) | alive, as wording | — | [forks/wildcard/w3-quote-ladder.md](forks/wildcard/w3-quote-ladder.md) |
| frame | W4: REBOL-maximal lexical types | dead | — | [forks/wildcard/w4-rebol-maximal.md](forks/wildcard/w4-rebol-maximal.md) |
| 6 | **S0**: slot types outside the document | **leading** | 8.4 | [forks/slots/dp6-slot-types.md](forks/slots/dp6-slot-types.md) |
| 6 | `:name<type>` kept an error (free headroom); `:name.type` | alive for full UDON | 7.0 / 6.0 | same |
| 6 | `:name:type`; traits as slot types `:port.u16` | dead | 5.2 / — | same; [forks/wildcard/w2-attribute-traits-as-slot-types.md](forks/wildcard/w2-attribute-traits-as-slot-types.md) |
| 7 | `:` never ends a bare label; T2 optional ornament ≈ T1 none | tie, slight lean T2 | 7.7 / 7.7 | [forks/slots/dp7-trailing-colon.md](forks/slots/dp7-trailing-colon.md) |
| 7 | compulsory trailing colon | pruned | 6.9 | same |
| 8 | bare `nil` as today, plus `<>` | leading | — | [forks/classification/dp8-nil.md](forks/classification/dp8-nil.md) |
| 9 | U2: units are text; a named `quantity` reading outside the spine | leading | 8.6 | [forks/slots/dp9-units.md](forks/slots/dp9-units.md) |
| 10 | aliases and unions in the reader's layer; lite owes R1–R7 | only live branch | — | [forks/slots/dp10-aliases-and-reader-contract.md](forks/slots/dp10-aliases-and-reader-contract.md) |

The scales differ by fork (most use weighted 0–10; the angle fork summed weighted points), so compare scores only within a decision point. The dead branches' reasons, in one table: [synthesis.md](synthesis.md) §8.

## Where everything is

- [debrief.md](debrief.md): to Joseph, in UDON with trees.
- [synthesis.md](synthesis.md): how the branches compose; the seams between forks I resolved; the question two forks answered without asking (is a refinement a change?); the lead composition and its card impact; open edges.
- [notes.md](notes.md): my working notes as they accrued, with corrections left visible.
- [instincts.md](instincts.md): what I'd write and expect a spelling to mean, written before any fork reported (Joseph: instincts are better evidence than the corpus).
- [composite-set.md](composite-set.md): the shared content every branch rendered (K1–K15 and three composite lines).
- `forks/`:
  - `classification/`: DP1, 2, 3, 8, the F1 check (`python3 -I f1_check.py`).
  - `angle/`: DP4, 5.
  - `slots/`: DP6, 7, 9, 10.
  - `wildcard/`: warm play, W1–W4.
  - `research-external/`: precedents weighed against the factors.
  - `research-internal/`: Joseph's own words, dated, from `history.jsonl`.

## On the forking experiment

- **Six forks of this agent ran in parallel.** Each inherited my full context and was briefed in one sentence naming its role, plus its folder. The harness allowed forking from inside a spike agent and messaging the forks mid-run: Joseph's two notes reached all six while they worked, and each acknowledged or applied them.
- **As far as I can tell, no fork forked further.** Two said so explicitly; the other four didn't say, and their folders hold no sub-fork output. All six branched in files. So deep (second-level) forking went untested; one level worked. The second round added three invention forks (`forks/invent-*`), also one level deep.
