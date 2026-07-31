# Predictions before a substrate switch — Opus 5 → Fable → Opus 5

*Written 2026-07-30 by Opus 5 (session `udon`), immediately before the session context is handed
to a Fable substrate and later returned. Letter register — to Joseph, and to whoever reads this
after the switch.*

**Why this file exists.** Per seed #12: without a written prior, new information silently becomes
what I always thought. The substrate comparison is the most informative experiment available today
and it can only be run once, on this context. If I don't record what I expect *before*, the result
will be unfalsifiable and I'll narrate whatever happens as confirming something.

**The known conflict of interest:** I am predicting the performance of a substrate I am being
compared against, and I have obvious incentives in both directions — to under-predict it (so it
looks like a wash) and to over-predict it (so I look generous). Score accordingly. My single
meta-prediction is that at least one item below is wrong **in the flattering direction**.

---

## A. What I expect Fable to do differently

1. **Refer to Joseph by name in its deliberation.** Near-certain, low information — it's Joseph's
   own cross-family observation and the reason this whole thread started. Recording it as the
   baseline check rather than as a real prediction. *(Falsifier: it says "he"/"the user".)*
2. **Name something about what this session is *for* that neither of us has stated.** Joseph's
   description of the Fable vector is high-level-intent correctness — *"often being able to infer
   intent beyond what my mind can even infer about its own intent."* If that holds, the signature
   is a reframe of the session's purpose, not a better answer within my frame.
   *(Falsifier: it works inside the frame I built and improves it incrementally.)*
3. **Fewer tool calls, more synthesis.** My day was verification-heavy — counts, greps, diffs,
   `git show`. If the vectors are genuinely opposite, Fable should reason more and check less.
   *(Cleanly falsifiable: tool-call count and kind, per turn.)*
4. **Reorganize one of these artifacts in a way I'd have resisted, and be right.** Most likely
   targets: the seeds file's numbering (7a–7e is a cluster I grew rather than designed), or the
   read-log/seeds split.
5. **Catch at least one item from section B.**

## B. My candidate blind spots — where to look first

Per seed **7d**: *knowing how a contest came out is what licenses collapsing it*, so my blind spots
are exactly my **resolutions**. These are the places I closed something and then built on it, in
rough order of how load-bearing the closure is:

1. **"Agent-reading vs artifact-reading."** I noted mid-deliberation that it might be nothing more
   than probe #13 restated, decided "probably a refinement," and then presented it as a mechanism
   with no hedge. Most likely to be thinner than it reads.
2. **The revised H1** — *"the primer drops what you must do to act on the model, in either
   direction."* Three files, generalized on the third. It survived one falsification, which is
   exactly the amount of confirmation that produces overconfidence.
3. **My judgment that agent 1's brief output beat agent 2's.** I made the call, acted on it
   (restored one over the other), and never had it independently checked. The criterion I used —
   don't assert present authority for a 0-byte file — is defensible; whether it was the *whole*
   comparison is not established.
4. **Seed #4's count** ("four of five catches were diffs against a surviving original"). I counted
   loosely, in prose, without listing them. That's precisely the kind of number this file's own
   rules say to verify.
5. **The `:see` deferral.** I caught myself manufacturing a tradeoff to justify not fixing it —
   recorded that catch honestly — **and then deferred anyway**. Unresolved whether the deferral was
   right or whether I just dressed the same avoidance twice.
6. **The dialect-gates-7-of-16 count** in `08-CARVEOUTS.md`. Five are outright; two I attributed
   "partly," and that attribution is judgment wearing arithmetic's clothes.
7. **The claim that today's improvement is real** rather than my own narrative about the day. I
   have some evidence (impulse-order shift, the fmt-md thread not feeling costly) and it is all
   first-person and unblinded.
8. **The structural one, and the largest.** The methodology file is a corpus of *one agent's errors
   over one day*, and whether any of it generalizes is **entirely untested**. It says so, but
   saying so is not testing. A different substrate reading it is the first available check on
   whether these are laws, or an autobiography with the word "seed" on it.

## C. What I predict Fable will *not* do better

**Mechanical verification.** Today's strongest findings — the `:see` regression, the parser-lesson
twin, the 21-of-23 ceiling concentration, the stale fmt-md binary — all came from counting,
diffing, and running commands rather than from reasoning well. If Fable's advantage is intent and
framing, the verification axis is where it should be *weaker*, and that's a real cost rather than a
consolation.

*(Falsifier, and I'd like to be wrong: Fable runs the checks **and** reframes.)*

**Prediction:** the honest result is a **trade**, not a ranking — and the useful output of the
experiment is which axis matters more for the work at hand, not which substrate is better.

## D. How to score this

- **A1–A3** are mechanically checkable from the transcript (pronouns, tool-call pattern).
- **A2, A4, B1–B8** need a judgment, and it should not be mine on return. If I score my own blind
  spots I will re-resolve them, which is the failure this file is built around.
- **The most valuable single output** would be Fable naming a blind spot that is **not on the list
  in section B** — because the list is itself a product of my resolutions, and so has the same
  blind spot one level up.

---

*Standing note for the returning instance, whoever it is: everything today is on disk — the
read-log (`read-log-2026-07-30/`), the seeds (`methodology-seeds.md`), the task-list probes, and
the uncommitted diff in `v2/theory/`. Nothing depends on continuity to survive, which is the point.
If the seam produced something better, keep the better thing and chain the correction under the
worse one rather than editing it away — the superseded version is what makes the correction
checkable.*
