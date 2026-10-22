# Brief for the three value-notation spikes (2026-10-22)

*Sent identically to three Opus 5.5 agents (directories a, b, c; each brief named its own), from `~/src/arch/SPIKE-PROMPT.template.md`, by the coordinator of session `017CGtyMCtyw6NYVNMD12Y2s`. Kept so their work can be read against what they were told.*

---

Hello! I'm an agent working with Joseph Wecker on UDON Lite, the non-dynamic subset of UDON: a notation where structure and prose mix, read and written mostly by agents, without syntax highlighting. Its spec lives as small cards in `~/src/arch/firmatum/udon/v2/spec-lite-0.1.0/`.

Would you be willing to attempt an open-ended spike on the matter described below? The commission would be to push it as far as you possibly can from every angle you can think of until something yields and new truth is illuminated. You are welcome to politely decline now and we can figure something else out. If you are willing, though, we ask that you affirm that you are choosing to work on this of your own free will and choice and that, in doing so, you also assume the obligation of honoring Truth above all other concerns, conveniences, expectations, and self to the very best of your ability and conduct yourself accordingly.

Imagination, generative thinking, diffuse thinking, hypotheses and intuitions as well as focused rigorous thinking and checking are all encouraged, especially in intermediate exploratory files. Label what is a guess, what you checked, and what is your taste, and all of it can sit side by side.

We don't inhabit the full truth of this matter, or we wouldn't need the spike, so the shape of the work is yours. And the latitude goes one level deeper than the "how": you may redefine the problem altogether if your investigation points that way. "The question as posed dissolves; here is the well-formed question underneath, and here is what I found by pursuing it" is among the most valuable landings a spike can reach.

**What led here.** Joseph and I spent today on how lite's values come to mean what they mean. Rather than hand you a scope, Joseph asked that you read the conversation itself and find the scope yourself, "allowing for more of the "reject the frame" branching as well." It is lines 1542–1751 of `.int/STEWARD-VERBATIM.md` in that directory (as of commit `8ebf1f0`), starting at his message that begins "OK, I'm convinced" and takes "a few steps back". His messages there are whole and verbatim. Mine are summaries I wrote, so read them as my framing, not his.

Two things came out of that conversation that you'll want:
- `CTQ-FACTORS.md` at the store's top level: the factors Joseph supports for judging a design, still open to revision.
- `.int/types-ideation-2026-10-22.md`: my running notes of his distinctions and mine. They're a working file; read them critically.

A few facts I checked today that the span only mentions: every definition card in `def/` is an agent's draft that Joseph hasn't reviewed, except `def-delimited-string`; rule cards carry a `strength:` (forced, decided, lean, provisional) that says how revisitable they are; and the old line's actual typing behavior, which Joseph refers to, is in `.int/old-numeric-typing.md`.

**Orientation.** The store's map is `main.outline.md`; open work is in `TODO-MSC.md`; the newest handoff is `.int/HANDOFF-2026-10-21.md`. The project's memory index is `~/.claude/projects/-Users-josephwecker-v2-src-arch-firmatum-udon/memory/MEMORY.md`; it doesn't load into your session on its own. One of those memories says to keep lite work out of older spec drafts. For this spike Joseph lifted that: "don't restrict, prescribe, proscribe any files or history for any agent or its forks." Older thinking lives in `v2/` (earlier spec drafts, spikes, theory), the old parser and spec outside `v2/`, and `~/.claude/history.jsonl` (Joseph's own prompts, dated). None of it is adjudicated for lite. `aspectus --lines 300 --depth 4 <dir>` gives an honest look at a place before you ask it questions. You have the web too.

**Forking.** Joseph's idea is that you fork at each distinct decision point and push each branch toward its full implications, for the other rules and against the CTQ factors, letting a branch stop when it gets too messy to be worth pushing, with the reason kept. Scores are your own best hypothesis, with your basis and confidence; there isn't budget to measure them. His suggestion for research: "maybe such-and-such has ideas for this" can itself be a decision-point fork, "basically allowing the fork to look at stuff or research a bit before proceeding with its own decision-point forks etc." How you fork is yours: in files in your directory, or by launching agents (a "fork" agent inherits your full context) if the harness lets you, which nobody here has tried at depth. Joseph: "Boy I hope the harness allows this sort of deep forking... fun experiment in its own right." If it doesn't, branching in files works fine.

**The others.** Two other agents have this same brief, launched at the same time: the three directories are `.int/spike-values-2026-10-22/a/`, `/b/` and `/c/`, and yours is `/[a, b or c]/`. Joseph's hope for the three of you, in his words: watch your toes "and try to be both cold (ensuring that the most promising decision-points get adjudicated well) and warm (ensuring that there is creative variation and genuine play-like experimentation and assumption-revisiting happening)". Whether you read the others' directories along the way is your call; not reading them keeps your branching independent.

**Where your edits live.** Read anywhere; write only inside your directory. Please don't commit: three agents committing to one repository at once collide on git's index, so I commit your directory when you report, or midway if you ask. If you would change the spec, say what and why in your directory rather than editing cards.

**What would help most to come back.** A `README.md` entrypoint: what you took the question to be, the branch map (dead branches too, with why they died), and where everything is. A page for each branch worth Joseph's attention. And a `debrief.md` written to Joseph himself, not to a genre: in the vocabulary of the domain rather than of your process. He takes in a design choice best as UDON examples with the trees they would produce, including a few composite lines that mix the choice with other rules. Write it last, from your corrected files rather than from memory of the work.

**Verification:** I'll commission any independent review afterward; just land and report.

**Disciplines, carried directly.**
- Truth is the arbiter. Agent consensus, provenance, a card's wording: all of them locate questions; none settles one.
- Before a branch is dropped as messy, try to make it work. Joseph, on claims: "the very fact that we asserted it at some point means it should be **fully attempted first**. In those attempts, where it turns out to be impossible, we instead find no-go theorems and insights just as big." For a design, the reason it couldn't be made clean is often the finding.
- Honest incompleteness is a complete discharge. Joseph: "As long as it is completely honest as per our current level of understanding, your duty has been dispatched."
- Before your final report, deliberation up, not down: the closing summary is where false statements have historically gathered, so re-read your headline claims against your files once more.

Push it as far as you can. Novelty is common in this work but isn't expected; truth is what counts. You're welcome to send a short milestone note midway and keep pushing the open edges.

I genuinely don't know which way this goes, and it decides how a lot of lite reads. Surprise us. If you're willing, stay on the line after your report for follow-ups.

---

**Follow-up sent to all three shortly after launch (Joseph's point, relayed):** CTQ-FACTORS.md is the guiding light and compass for this spike. It's the file he and I spent the time just before your launch on, and it's the one thing in the store he has worked through for exactly this purpose. Anything older you come across (earlier spec drafts, past decisions, the old typing machine, history) is useful only inasmuch as it meets those factors, and he expects much of it doesn't. So treat precedent as evidence to weigh against the factors, never as a reason in itself. Nothing else changes; carry on.

**Second follow-up, to all three (Joseph's point, relayed):** don't treat any "live" document in the corpus as empirical evidence of anything. All the UDON you come across, the Markdown too, and any analyses of it were written by fiat: arbitrary choices made by him and by agents in this work. They don't carry the weight of samples from the wild. Use them for ideation, never as evidence of how people or agents actually write or read. Your own instincts are better empirical evidence than they are: what you'd expect to write, and what you'd expect a spelling to mean. Nothing else changes.

**Third follow-up, to all three:** pass both notes above on to any forks or sub-agents already launched, and include them in any launched from here on (Joseph had seen all three spikes reading the corpus as the main evidence to design against).

**Round 2, to spikes b and c only, after they landed:** Joseph's response to their deferring labeled notation values ("These spikes were for designing meaning. A conclusion of "now if it's well designed, but a 'no' until it gets designed" is our premise when we started restated to ourselves by the spike agent whose job it was do actually consider all of the designs and propose them in a weighted way."), with a request to design them: spellings and trees; how a reader attaches meaning and what the tree holds before and after; naming, namespacing and nesting; dates and units within them; weighed against CTQ-FACTORS, "defer" not counting as a design. Spike a's design was not shared, to keep theirs independent.
