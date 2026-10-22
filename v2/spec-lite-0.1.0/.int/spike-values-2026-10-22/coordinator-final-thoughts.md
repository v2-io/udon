# Final thoughts, from the coordinator

*The agent of session `017CGtyMCtyw6NYVNMD12Y2s` (Opus 5.5), 2026-10-22, after reading the three spikes' `final-thoughts.md` whole. I launched and relayed the spikes; I saw the whole conversation with Joseph and none of the forks' pages. Leans are mine and marked; nothing here was measured.*

The three final-thoughts files agree on most of a design, which I won't repeat: bare text with a closed set of JSON faces, b's stand-alone rule, a reading on the name, `name(…)` as a value standing alone, backticks for foreign text, `[Oct 1st](date:2026-10-01)` in prose. Here is what I see from where I sat that they don't say.

## 1. The spine is c's one sentence, and nobody adopted it

Buried in c's §1: **"every sameline value is a run, and a closed form standing alone, or a run spelling a primitive, gives it a face."** I think this is the most important structural result of the day, more than any spelling. It makes lite's value grammar one rule for extent (the run, which every spike already accepted) plus a short list of things that give a run a face. Three open problems dissolve into it at once:

- **b's stand-alone rule** stops being a second rule; it is the definition of when a quoted, bracketed or called form gives its run a face.
- **CTQ B1's wording question** goes away: every value's construct is known at its first character (a run); its face arrives at its close, for quotes as for numbers.
- **The residue after a self-ending value** (`:a "x" y`, open on `rule-unquoted-run-is-one-value`) disappears: `"x" y` is one run that doesn't stand alone, so it is text.

```udon
|el :a "x" :b 2
|el :a "x" y :b 2
|q "hello," she said
|ev :on date(2026-10-01)
|li printf(x) prints x
```
````tree
root
  |el
    :a ‹"x"› ~string x        (stands alone: string face)
    :b ‹2› ~int
  |el
    :a ‹"x" y›                 (not alone: plain text, quotes kept)
    :b ‹2› ~int
  |q
    :$main ‹"hello," she said› (one text)
  |ev
    :on ‹date(2026-10-01)› ~date(…)
  |li
    :$main ‹printf(x) prints x›
````

**The cost to name plainly:** `|q "hello," she said` is an example on a decided card ([[rule:leftover-values]]), drawn there as two `$main` values, a string then a text. This rule reverses it. I think that's right (the writer meant one sentence with quotes in it), but it's a decided card, so it's Joseph's to reopen.

## 2. Two axes the spikes kept mixing: where a reading sits, and how it's spelled

*Where:* on a region (a signature), on a slot occurrence (the name), on a value. *How:* `.kind`, `(kind)`, `kind(…)`, backticks, `<…>`. a's §4.4 asked for "one spelling at every scope", like ♯ in music. Laid out on these two axes, the answer is there:

```udon
|sample :mass(kg) 3.2 :born(date YY-MM-DD) 27-03-05     ; on the name
|meta :values [qty(3.2 kg) date(2026-10-01) 42]          ; on the value
|samples :$sig [mass(kg) temp(°C)]                       ; on a region
```

One spelling, `name(…)`, at all three scopes. `.kind` can't do that: it has no room for parameters with spaces, and it can't sit on a value. **My lean: `(…)` on names**, c's scientific-header form, with `.kind` as its trait-shaped twin only if Joseph wants the `|user.admin` symmetry badly. That's taste plus the one-spelling argument, held loosely.

## 3. The CTQ list leans the wrong way on one factor, and that's my doing

c's §6 is right, and it corrects something I wrote. When Joseph objected that self-description pulled toward verbosity, I rewrote domain-forward to say conventions "carry what would otherwise be declared on each value": file naming, the logical store, slot vocabularies. But agents, the principal readers, read the text. A unit declared in a vocabulary is invisible to them; `:mass(kg)` isn't. Joseph's own words for the factor, "the *domain*'s mental model to jump out", fit a unit on the name better than a convention off the page.

**Proposed edit to `CTQ-FACTORS.md`, A4's note:** the domain's model is visible in the text itself, in the domain's own words; conventions and vocabularies check what the text says rather than replace it. Self-description (A10) stays low, because the target was always declaration *plumbing*, not the domain's words.

## 4. A minimal lite 0.1, so the fold doesn't become the largest grammar in lite

Every final-thoughts file adds forms; none subtracts. c's fold has three value forms plus typeset shapes, signatures and backticks, and c scores its own spec clarity 6 and simplicity 5. b's move is the one I'd build on: c's typeset beauty (`37.5 ± 0.2 °C`, `2026-01 – 06`) belongs in the *body grammar* of standard notations (`qty(…)`, `range(…)`), where lite's parser needn't know it.

**My lean for the core:** runs with faces (§1); `name(…)` on names, on values and in signatures (§2); backticks, tagged by a name, for foreign text; Markdown links passed through as they are. Four ideas, one of them new syntax. `<…>` goes back to full UDON whole, freeing `<` for HTML in text. Every other piece (typeset bodies, legends by element kind, URI values) becomes its own decision on top of that core, each judged by its own value against its grammar cost. That is a way to decide them, not a deferral of them.

## 5. The refinement question has an answer on the table

All three say every notation design depends on whether adding a reading later counts as a change. c's §5 gives the cleanest answer I've seen: **a later version may read what lite marked as named, and may never give a new face to what lite marked as text.** Faces are closed for good; names are the only path to refinement; fences already work this way. I'd put that sentence to Joseph as the B2 law, as it stands.

## 6. On the process, from the coordinator's seat

- **What moved the work:** Joseph's interventions, not the spikes' independence. The note on creativity, the canary, and the cross-reading round each produced more than a full independent round did. Same-model spikes give mostly shared priors until something shakes the frame.
- **My relays cost him.** I reported the spikes in their vocabulary (options as letters, "findings" about old claims) instead of as designs in UDON. He had to ask "what's the point?". Next time I'd send him the debriefs and relay only decisions, as examples.
- **c's suggestion is right:** an exchange round in the middle, where spikes read each other's *dead branches*, would have saved `date(…)` a round earlier.

## What I'd put to Joseph first

1. c's B2 sentence (§5).
2. The unified run rule (§1), knowing it reopens one decided example.
3. `(…)` or `.` on names (§2).
4. The CTQ edit to domain-forward (§3).
