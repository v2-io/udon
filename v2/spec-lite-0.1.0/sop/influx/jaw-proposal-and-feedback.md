# Outline rows and fields: Joseph's proposal, with feedback

*A working document for iterating on how outline rows and record fields are typed in spec-lite-0.1.0. Started 2026-09-30 by the aat-refactored coordinator (Opus 5.5). §1 is Joseph's words verbatim, in the order he gave them. §2 is my rendering of the proposal as it now stands, so it can be checked against §1. §3 is the feedback from me and from the fork that wrote `proposed-verisectorium.md`. Both of us come from one session and one context, so where we agree that is coherence, not two independent confirmations. §4 is what is still open. Register: proposed, and nothing here is decided. Add to it in place. It lives in `sop/influx/`, the SOP store's influx: once the points settle, they are carved into `sop/src/` segments listed in the SOP outline. **Paths in this file are relative to the `spec-lite-0.1.0/` root.***

## 1. Joseph's words (verbatim)

### 1.1 The proposal (2026-09-30)

> Here's the thing-- there is also right now a conflation between what is *official* canonical data-- contained in the frontmatter of the segments themselves, vs what in the outline only but relevant to the canon as it comes together -- such as known gaps, proposed rows of any kind, and example rows of any kind -- vs what is in the outline tables that is a quick-reference *REFLECTION* of the official canonical data (such as per, max, acceptance-state) -- which needs a bin/ script to lint and/or update -- vs outline parts (including potentially fields in the table) that are about *process* and *view/projection concerns*, not canon concerns. Order linting can be considered possibly 2nd concern or 3rd concern or a little of both-- depending on whether or not "depends-on" or "prerequisites" or something is in the segments generally that indicates a partial ordering that outline tables are expected to comply with.
>
> As for "state" as it is right now in the tables, it doesn't even conform with the verisectorium view that they are *individual flags*. Right now we have three, maybe four, types of rows in the outline. The principle is that THE OUTLINE MUST ALWAYS BE TRUE. That becomes difficult when we are first assembling it and trying things out etc.
>
> Things we can put in an outline without needing any decision:
> - suspected or known gaps
> - proposed undrafted rows
> - proposed drafted rows
> - exemplar rows
> - templates
> - (sometimes) hypothesis-grade claims/assertions (I don't think those will apply here)
> - exploratory drafted rows (unlike proposed-drafted, these don't know yet if they want to actually be proposed until more exploration is done)
>
> Anything else we will consider
> - landed (implies drafted)
> - missing (implies known-canon missing even a first draft)
>
> ok... making these more orthogonal-- above was more kind of flow of thought-- tell me what you think about this concrete proposal (and what the fork thinks):
>
> row-type: example, gap, template, exploratory, proposed, landed (becomes proper way to indicate a gap in the theory, "landed" starts them on the ladder below)  
> doc-state: missing, drafted, verified (i.e., doc-verified) (i.e., format-verified and compliant for that kind) (this is the thing that is "not a ladder", and that can get new fields+flags easily)  
> \# (The rest of these are official -- recorded canonically in the yaml frontmatter, in the table as desired as a reflection (or even combination etc.) & linted/updated via script):  
> awaiting-second?: true or false -- whether or not it's waiting for any other entity to give it a thorough once-over  
> awaiting-decision?: true or false -- whether or not it's waiting for steward to review and make a decision  
> needs-work?: true or false -- whether or not it is waiting for known work to happen -- if yes, implies details are in working-notes, even if it's a pointer to an audit report or spike result etc.  
> verification-level: (or something-- this one is a bit hand-wavy, but depends on the kind-- depends on how sure it is to not "fail" per kind? examples wanted...)  
> status: (this is the one that we probably want to have in the tables in the views but as an update-via-script-only column.
>
> From a practical perspective, for things in the outline that we want to designate as "read-only-- filled in via vsect (or our bespoke outline linter at the moment)" should get a header that has some special indicator in it-- "🔒 Needs<br>Work" for example maybe or something...

### 1.2 On doc-state and the column notation

> "doc-state is still a ladder" -- either the doc is missing, written but not necessarily formatted correctly, or written and formatted correctly. What am I missing?

> I noted "doc-verified" distinct from general verified, but yeah, let's just change it to "conforms" for brevity's sake though. I think we see eye-to-eye on it. One minor subtlety-- it means that the lock icon does *not* necessarily mean "derived from frontmatter" -- Instead of the lock, let's use ∂(Field Name) for derived by the linter and ※(Field Name) for anything that comes from that field name in the frontmatter (a special simplified case of derived).

### 1.3 Views choose columns; corrections to my first synthesis

> It's up to the outline / view to decide which ∂ and ※ it wants to surface as a column for *easy inspection* -- which is distinct from whether or not they actually *exist* and are measured etc. etc. -- in other words, the outline tables will almost always have some columns that are subsets of the ones available, and each table makes its own choices there. The outline linter / vsect should write a — or something for cells of a row-type or row-kind where the calculated column is not applicable, and a ∅ when it is *applicable* for that kind, but missing...
>
> 1. "reads as canon"? What does that mean? What field is "canon" to you? because that usually implies row-type = landed (one of the values you happened to skip in your feedback-- which makes me wonder what your actual feedback is), and usually implies some degree of "accepted / correct / verified / " status that is high (the 'ladder'). You also say "process and ordering are view concerns" which isn't what I said *at all*.

### 1.4 Addendum: landed vs integrated; directories

> So I think we can modify my proposal:  
> landed != integrated (which should be used for tracking influx stuff-- from the perspective of influx stuff- not something we track in the segments or outlines usually)  
> and second, subdirectories are often flat directories that share the same *kind* or small set of *kinds* -- but are for organizational purposes only-- I don't believe the directory that stores an atom should be used to imply or indicate anything other than that for right now-- and even *that* much doesn't necessarily need to be enforced right now. In general, you may notice how the table links in outlines *don't* give the directory-- they instead imply the kind by slug-prefix. Tooling will basically look for the segments of that kind everywhere there are segments-- or, in the future, even in a database if desired, etc. It's an organizational convenience orthogonal to everything else.

### 1.5 Kind in frontmatter; resolving `[[kind:slug]]`

> *frontmatter* declares kind, and its home directory and slug prefix *can* be clues / quick indications for kind-- but it will require explicit rules for the outline linter-- for example, right now if the outline is looking for `rule-implied-root` -- it would look for the *rule* -- not the fixture. So naming one kind of record with a prefix of another kind of record is *definitely* a problem regardless of how they're organized. It would be better if it was dat/implied-root.yaml and we can specify a mapping. This has been an open question for a long time-- originally slugs / segments never had prefixes for kind-- but in AAT there were hundreds in a single flat src/ and giving them prefixes was a quick and easy way to make the `ls` a little more legible, and it also reinforced that usually the slug didn't really make sense without the kind prefix, and it reinforced that a `kind` doesn't change-- helped keep it orthogonal from evidences and epistemic value etc. But more and more it makes just as much sense to say:
>
> [[kind:slug]] (or kind in its own column and just [[slug]] without any prefix) -> search for, in this order:
>
> 1. [look in kind+slug -> referent mapping in .vsect]
> 2. src/&lt;kind&gt;-&lt;slug&gt;.{ud,md}
> 3. &lt;kind&gt;/&lt;slug&gt;.{ud,md}
> 4. \*\*/&lt;slug&gt;.{ud,md} & kind matches in frontmatter

### 1.6 Agreement on the resolution rules; kind change; no mixing

> 1--5, agreed. wrt kind-mutation, it's rare because it really does require one to essentially retire the old and integrate it reconstructively into new kind(s) -- so much changes (including its authority and verification level etc. etc.) or rather, because the very way "it can fail" changes, it's really not so much a mutation as a dissolution and emergence of something else. Which allows for was as a historical provinance marker etc.  
> I agree [[kind:slug]] everywhere-- [[slug]] on its own we will consider underspecified and not resolvable.  
> No need to worry about obsidian anymore, as I've got 'limen' far enough along to start effectively replacing it, and I get to have limen follow links etc. based on whatever we're deciding here :-)
>
> WRT your smaller point-- it brings up a parallel concern-- referencing mixed (or even just "named only") segments/records.
>
> In many ways these are precisely the kinds of things that the *non*-lite udon will give us very nicely-- logical udon stores (don) that can be treated more like a record database than us manually translating logical addresses to paths. But this is good intermediate practice.
>
> I think for right now we need to *not* allow mixing -- because we have no good way to have multiple frontmatters in a single markdown segment, as well as the fact that we've pretty much just landed on addressing having files as a referent. I'm ok if the references/wikilinks use some other kind of addressing for yaml-- which will have more test cases etc. than we end up inlining into our actual segments as examples. We might not put them in any outline, but rather have them as `Counter-example:\n![[dat/stub.yaml#C7]]\n Here you see that ...` or something. And/or it simply gets referenced as `test-fixtures: dat/stub.yaml` within the frontmatter of the rule that needs it. It's a kind of record that is used for mechanisms outside of the outline...

*(The "1–5" he agrees to are the resolver points in §3.11 below. The Obsidian remark answers the rendering cost raised there.)*

### 1.7 Answers to the adjudication list

> 1. isn't this already answered by my prior comments? — / ∅ Are you talking about a non ※ / ∂ column?
> 2. seems like a calculated field that has a different measure depending on the kind (and possibly other flags/fields), right?
> 3. I actually see value in allowing both-- let's allow for it in .vsect/kind-map.yaml or something
> 4. in project root's .vsect/kind-match.yaml or something. Propose a format but I think it should show the resolution steps we discussed, except \*\*/... is replaced by explicit {src,obj,def,...}/\*.{ud,md,yaml} -- we can keep it bespoke and pragmatic for now-- literally a list of globs with &lt;kind&gt; and &lt;slug&gt; replacement tags, first match w/ correct frontmatter marker wins.
> 5. That sounds good-- but what kind of cell would require it?
> 6. for this project-- undecided for now-- you can leave it open until we have enough to start needing the outline linter working. for now we're just getting the policy/sops/skeleton in place
> 7. sure-- although for now, again, just put that as the process in sops with notes for the future linter
> 8. sounds good... assuming verification level is kind-specified (since, for example, it's mostly about authorized decision in our case).
> 9. sounds fine for now
> 10. '"fixture" leaves the record kinds' ? what does tha mean? Why? agree on attaching to citing rule's hash for change propagation-- but that's far more advanced than any of the other bespoke pre-verisectorium stuff we're doing here... I suppose this could be the place we would want that machinery to start to get built and made concrete. I'm all the more confused though by what looks like a suggestion to make them *not* verisectorium records, while simultaneously giving them *more* verisectorium-record machinery...
> 11. "view membership"??? "carried by"?? The SOP outline, used for orientation and as a lookup table for SoPs in order to work in the project hasn't been created yet. Neither have the sop/src/ themselves-- they have their own kinds etc. I don't know what you are meaning here.
> 12. Those, along with all of the other stuff in proposed\*\* and jaw-proposal-and-feedback.md, as well as much of what is currently in the actual outline and other sample files, will all be in sop/src/ segments referenced by the sop table. You're very familiar with all of that verisectorium stuff, right??
>
> Let's get that far and then we can talk about the others.

*(The numbers refer to the adjudication list given in chat that round; its items are carried in §3 and §4 below.)*

### 1.8 Kinds file, verification as the epistemic core, the kinds map as what the corpus is, term delimiters

> 4- looks good. Another option is to merge the two and have each kind declare its alias(es) *and* the glob for where they're found. oh- just read your #8-- yes, that would add three things and allow us to really start to flesh out kinds from a tooling perspective...
>
> 5- sounds good
>
> 8- this is kind of the very critical core of verisectorium's epistemology in general-- something that might need more clarity later or a revisit of RC1 etc. if you wouldn't mind making a note.
>
> 10- this brings up an interesting point-- it really is the kinds-map that tells us what the corpus is-- reinforcing the idea that outlines are just views/projections (although I'm not suggesting that that will continue to hold in the future-- there very well might be a call for `at least one canonical full view`-- maybe not, but the "outline = view" is a *working theory* and not a fixed ideal).
>
> Go ahead and update the jaw document and move it over to sop/influx/ (we'll use the full instead of .int, because it can and should be more prominent and won't be visual noise over there) while you're at it, along with the other propose\* stuff and.
>
> One thing, if I haven't mentioned it yet-- officially defined terms should always be deliniated-- we need some kind of syntax, even if it's not traditional markdown-- «...» maybe for sop-related, and ‹...› for domain-defined? something like that?
>
> When you've moved stuff over let me know what the remaining items are, with your lean.

### 1.9 Answers to the remaining items

> 1. agreed.
> 2. i can sustain your lean
> 3. yes-- keep in mind that everything we've talked about gets its own place in sop/.vsect/ etc. as well. but this doesn't need a decision from us because it's easy now to simply update the kinds.yaml
> 4. along with the note about sop/.vsect just now, sop absolutely needs its own adr/dec set -- all process decisions, which yes, should all start getting recorded asap-- distinct from udon-lite spec decisions. BTW-- this is an example of where authority/provinance/accountability/decision-space \*is\* proper even in something like AAT-- where there is still "chain of command" for processes, so to speak.
> 5. yes
> 6. if you are referring to udon ones, let's leave that to the udon team. If you mean sops, yes.
> 7. don't know what this is referring to.
> 8. leave it to the udon team-- everything from us here is example & proposed & template. BTW-- that's one of our main tasks next after getting the SOPs in place, is actually fixing the outline so that they have the right columns and so that row-type indicates them as examples etc.
> 9. candidate rule undecided in sops
> 10. max is a difficult one because it is essentially an aspiration or intuition at first and basically helps define the 'kind' later. Let's drop max altogether for udon-lite for now unless there's something important that it's giving us.

*(The numbers refer to §4's list as it stood before this round.)*

And, mid-round:

> btw-- I vote lower case on sop/sop.outline.md

### 1.10 Primary outlines named `main`; #7 to `.int/`; closers and `wut/`

> actually, I think we should normalize primary outlines, even while keeping them as "just one among possibly many views" -- main.outline.md -- if you wouldn't mind changing spec to main and then sop/main.outline.md as well.
>
> WRT #7-- Ahhhhh, right, that definitely needs to be prominent in .int/ still
>
> wrt #4 yes-- although I suspect they're going to want to specifically have open questions kind, as someone has already proposed in the past-- when it gets to it I'm going to vote for a `wut/` directory for those.
>
> All yours -- please feel free to delegate where you can

*(Done on 2026-09-30: `spec.outline.md` renamed `main.outline.md`, and references updated. The SOP outline will be `sop/main.outline.md`. The vsect requirements are now `.int/vsect-requirements-on-lite.md`, with a pointer from `.int/README.md`. Closer routing goes to the udon team, carrying Joseph's intended vote for an open-question kind in a `wut/` directory.)*

### 1.11 Later rulings in chat (2026-09-30), each recorded as a decision in `sop/adr/`

On `convention` as an SOP kind (→ `sop-kind-convention`):

> 3. sure

On decisions in outlines (→ `outline-is-current-truth`):

> in an outline? they usually don't end up in an outline as a table or something, but if they did, the row-type would need to be landed. As for the decision kind, I don't know what "landed" means-- I assume you mean 'accepted' or 'decided' or something.

> outlines are generally meant as *current truth* -- the *results* of decisions -- not big compilations of those decisions...

On working notes (→ `working-notes-and-frozen`), and the section-order convention:

> 1. Policy should be that every record has the ability to have working-notes, but it cannot be considered frozen (if there is such an equivalent field in that kind, like 'final' or 'fully-verified') if there are any notes in it. Whether or not the header has to be there when its empty is irrelevant to me and the engine.
>
> 2. proposed, or even exploratory

On open questions (→ `open-questions-in-working-notes`), and the examples:

> Traditionally, open questions have been the bread and butter of "working notes" (and sometimes "discussion" if they are more permanently open questions). That's where I'd probably recommemd they stay in this context. The original dump of questions into the main outline as we verisectified this spec-lite was a guess due to open questions being the main thing in influx at the time. It's not a reflection of a well-written spec.
>
> Those samples are part of what we're proposing to the udon team-- please have the fork launch helpers to update all of the examples to comply with and illustrate the sops

On the remaining setup decisions (→ `setup-delegated-to-coordinator`, and the ten decisions made under it):

> If you are looking at everything holistically and thoughfully to be an exemplar for moving the udon work forward which will move verisectorium and the agentic systems framework / theory forward-- I am happy to defer to you for the rest of those and other decisions related to the setup. Just mark decisions as made by you from authority given from me and as still needing ratification (where applicable)

### 1.12 Joseph's messages typed into the fork's thread (2026-09-30)

*Copied verbatim from the fork's transcript (`~/.claude/projects/-Users-josephwecker-v2-src-aat-refactored/073f016a-cd06-4410-898f-dc8454e79123/subagents/agent-a709e77019230eca0.jsonl`, Joseph's typed turns only), because several decisions rest on them and no kept file held them before. The harness's wrapper lines are removed, and the long pasted MADR template is elided, as marked. Times are UTC.*

**2026-09-30T16:19:43.959Z**

> (Joseph here)-- excellent work. I will start looking at everything shortly but want to consider two things: For now, would it make more sense (since udon-lite isn't nailed down) to do it all in markdown (i.e., traditional), and 2, just want to make sure that decisions include reasoning and assumptions, since those have ended up being critical. Also, 3 I guess, making sure there is allowances for working-notes everywhere...

**2026-09-30T17:54:28.137Z**

> I've started modifying some things (such as fixtures/ -> std/) -- I've created a directory adr for decisions -- I was thinking something like this chat-generated template per adr / decision file:  
> [… a pasted MADR decision template, elided here; it is the starting point of `adr/TEMPLATE.md` …]
>
> would you make sure it has the right verisectorium fields etc. based on your expertise? (such as supersedes, superseded by, etc. etc.) -- and drop the example in adr/ ?

**2026-09-30T18:00:22.187Z**

> Excellent. Thank you. I also just created an sop/ directory (and changed .archive to .old and changed influx/ to int for integrate). Would you update the proposal here in the spec/ top level with the changes so far? (don't worry about the copy in .old). I will then remove DECISIONS.md since the agent in charge over in udon already knows to look at the copy in the vsect-init for examples etc. (as well as, now, the template and proposal).  Within SOP, let's have sop/def/ and start populating it with verisectorium definitions from proposal and from TEMPLATE

**2026-09-30T18:03:57.660Z**

> Right now what are the different "kinds" that you have suggested for src/ ?

**2026-09-30T18:16:54.680Z**

> Would you go ahead and make a note in proposed that says the following are *possible* "higher-level" segment types to reference:  
> objective  
> principle  
> fitness
>
> (fitness being something that isn't a binary objective but a scalar being optimized, or something along those lines). Mention also that there might be all three for one concept--  an fitness that is a concrete measure or proxy associated with a UX principle with objective (which we should propose could also be req for requirement or critical requirement) that indicates a minimal fitness threshold we need to pass. Also, we should probably distinguish between  objectives, non-objectives, and critical-objectives (as sub-categories, however that is most cleanly done), and we should assume that there will be some degree of mixing obj/principle/fitness into the same segment (correctly headed), which should always be split out the moment one of them needs to be reused or as modifications start getting appended to the objective etc.)
>
> Before doing anything-- does that seem in line with our overarching concerns, truth-wise and effectiveness-wise? Or am I steering away from things in an overzealous attempt to make this work well in these circumstances but that mess with our vision for vsect and spec-lite-0.1.1?

**2026-09-30T18:17:36.302Z**

> Oh-- I created a new directory -- obj/ -- where I think we should put objectives, fitness, requirements, and principles...

**2026-09-30T18:23:21.954Z**

> Excellent-- I agree with the three refinements. I would also love to have the stuff from your earlier response-- Goodhart, the refraining from adding measured proxy before adding the objective threshold, etc.  Go ahead and make the changes if you would. I've also added an empty bin/ directory where we'll put some bespoke processing scripts that will inform vsect in the near future.

**2026-09-30T18:30:51.315Z**

> I was trying to restate something you said earlier "Two guards keep it honest:" .... Goodhart ..... and "- Commitment. An objective's threshold on a fitness must be set before the measurement it gates. A threshold chosen after seeing the numbers is tuned, not tested (RC1's commitment law)."

### 1.13 Working notes are drained, and are not history (2026-09-30)

On the superseded "working notes hold only open work" (→ `notes-drained-not-history`):

> First-- maybe re-add your "working notes only hold open work" as "it is highly encouraged but not currently enforced that working notes get drained continually so that they hold open work only for the most part." You can also add this decision I'm articulating now: that working notes are *NOT* for history, changelog, or breadcrumbs for past work that will not be needed. Those things should be part of the changelog records [which we may not have defined yet] and git log history. An empty and "still relevant only" working notes section is, normatively, far superior to an accumulation of historical cruft that has to be constantly readjudicated.

### 1.14 Force stays a separate field; required versus critical (2026-09-30)

Answering whether `force` should give way to the RFC 2119 key words in an objective's Statement (→ `force-critical-is-ctq`):

> Ah right-- objectives (and or principles and or fitness)-- I think that it is appropriate to have this separate force for objective-level kinds here.  
> And with that in mind, I can tell you the difference between required and critical. Required is an intention for this version. Critical is a CTQ objective-- critical to quality-- where, due to other factors, it is expected to have an outsized impact on the success or utility of the [spec, in this case].

### 1.15 Critical implies required; a landed row may lack its document (2026-09-30)

Answering the two questions left open by `force-critical-is-ctq` and `row-type` (→ `critical-implies-required`, `landed-may-be-missing`):

> 1. critical should be assumed (for now) to be required.  
> 2. landed (a row state) *can* have a doc-state missing. Often this is when it is pretty small and the core is covered in the table description field and/or something in .int / influx that just hasn't been moved to the right place yet. It also comes up when something gets refactored away and the agent forgets to update the outline.

### 1.16 Decisions don't point to records (2026-09-30)

On how a landed row with no document finds its decision (→ `record-to-decision-links-for-now`):

> That sounds like what we'd expect. A decision doesn't point to records though... hmmmm.... that might be problematic. I hope that's shown as an implementation choice for right now in case it needs to be revisited...

### 1.17 Whose decision; when ratification happens (2026-09-30)

> I literally just made the record-to-decision-links-*for-now* decision-- I shouldn't need to also ratify it. I won't ratify any of the others until the udon team has weighed in.

### 1.18 Supported, not ratified; a fuller authority proposal (2026-09-30)

> I was being a little to harsh-- I actually think it was wise of you to double check instead of assume "that's what we'd expect" was a full ratification. It was just the word ratify that threw me off a little. Something like "And as for the new issue, can I mark that as your decided position?"  In vivarium we have a "supported" as well-- which allows me to give a basic support for the agent-decided or agent-described decision, without the full weight of "ratified" -- basically supported implies agent and human alike should feel much more free to say "hold on-- let's rethink this one..." instead of "well, it's official, so off-limits"

Answering whether `record-to-decision-links-for-now` should be `supported` rather than `steward`:

> Hmmm, yes. As a matter of fact-- it's not as well organized in some ways as we are here, but why don't you have an agent read core/src/norm-decision-authority.md (and any adjacent/related ones over there) fully and any related things in verisectorium (especially in it's influx RC1 stuff)-- and give us a more complete proposal that allows for the council, support, and so forth...

### 1.19 Asides on the authority proposal (2026-09-30)

> (we don't have to hold to anything it recommends obviously-- there are also options like "delegated" etc. -- I think what I'm curious about is how RC1 may have already kind of extended or clarified authority from it's already developed vivarium state)

> One day we'll have very serious councils for these sorts of decisions on more serious topics-- as per ~/src/arch/msc/councils/ :-) :-)

## 2. The proposal as it now stands (my rendering; check against §1)

**Four concerns.** Every outline cell belongs to exactly one:

1. **Canon data:** segment frontmatter, the official record.
2. **Outline-only material relevant to the canon as it comes together:** gap rows, proposed rows, example rows, and so on. The outline is the authority for these.
3. **Reflections of canon:** table cells that mirror or compute from canon data. A linter checks them and may rewrite them.
4. **Process and view/projection concerns:** things about how this view presents, not about canon.

**Ordering** is concern 2 or 3, or a little of both. Segments carry `depends:`, which is a partial order the outline is expected to follow.

**The principle:** the outline must always be true.

**Column notation:**
- **※(Field):** the value of that frontmatter field.
- **∂(Field):** derived by the linter or vsect. ※ is a simplified special case of ∂.
- **No marker:** authored in the outline.
- **Choosing columns is the view's business.** Each table surfaces the ※ and ∂ columns it wants for easy inspection. Whether a field exists and is measured is a separate question.
- **Cell values the linter writes:**
  - `—` where the column does not apply to that row's type or kind;
  - `∅` where it applies but is missing (looked, nothing there);
  - `⚠` where it applies but the inputs couldn't be read (couldn't look): unparseable frontmatter, or a `per`/`depends` target that doesn't resolve.

**Fields:**

| Field | Where it lives | Values |
|---|---|---|
| row-type | outline (concern 2) | example · gap · template · exploratory · proposed · landed. `landed` needs a decision and implies drafted; it starts a row on the fields below. |
| ∂(doc-state) | computed | missing · drafted · conforms (format-conformant for the row's kind). Exhaustive, reversible, recomputed. New checks arrive as separate flags beside it. |
| awaiting-second? | frontmatter | true / false: waiting for another entity's thorough once-over. As a ※ column it shows `—` on rows with no document; a pending decision about such a row lives in its ADR or pre-design question (§1.7 item 1). |
| awaiting-decision? | frontmatter | true / false: waiting for the steward to review and decide |
| needs-work? | frontmatter | true / false: waiting on known work, with the details (or a pointer to an audit or spike) in the working notes |
| verification-level | frontmatter | Each kind declares its own ladder (in this corpus, mostly about authorized decision). Written only by the act that verifies, with an evidence pointer (§3.9, §3.14). |
| ∂(status) | computed | Calculated per kind, from that kind's verification-level and the flags (§1.7 item 2). |

**Two amendments (§1.4):**
- **`landed` ≠ `integrated`.** *Integrated* belongs to influx items, seen from the influx side. It is not tracked in segments or outlines.
- **Directories are organizational only.** A directory implies nothing about an atom, and not even kind needs enforcing for now. Kind comes from the slug prefix, and tooling finds segments of a kind wherever segments are, or later in a database. *(Refined by §1.5: frontmatter declares kind; prefix and directory are only clues.)*

**Identity and references (§1.5–1.6):**
- **Kind** is declared in frontmatter. Slug prefix and directory are clues only. A record named with another kind's prefix is an error wherever it lives.
- **Every reference is `[[kind:slug]]`.** A bare `[[slug]]` is underspecified and does not resolve. Identity is the pair (kind, slug), so a slug only needs to be unique within its kind.
- **Resolution** runs through a bespoke, pragmatic list in `.vsect/`: explicit bindings first, then globs with `<kind>` and `<slug>` tags over an explicit directory list (no `**/`). The first match whose frontmatter kind matches wins. Kind names may be canonical or aliases. The format is in §3.13, including the merged form in which each kind declares its aliases, its globs and its verification ladder.
- **The kinds map is what tells us what the corpus is** (§1.8). Outlines are views and projections over it. "Outline = view" is a working theory, not a fixed ideal: there may yet be a call for at least one canonical full view.
- **A change of kind is not a mutation.** The old record is dissolved and one or more new records emerge, with a different way to fail, a different authority and a different verification level. `was:` records that as historical provenance.
- **No mixing.** One record, one kind, one frontmatter per file, because files are the referent and markdown can't hold several frontmatters.
- **Fixtures are records of kind `fixture`, at file grain, that no outline lists.** Case ids are anchors inside the record, like headings. They are cited as `test-fixtures: dat/implied-root.yaml` from a rule's frontmatter, or transcluded as `![[dat/implied-root.yaml#root_two_top_level_elements]]` in prose.
- **Officially defined terms are always delimited** (§1.8, syntax proposed): `«…»` for SOP terms and `‹…›` for domain (lite) terms. See §3.15.
- **Links are resolved by limen and vsect,** following these rules. Obsidian rendering no longer constrains the syntax.
- **Horizon:** full udon's logical stores (don) will make records addressable like a database, with no hand translation from logical addresses to paths. This is intermediate practice toward that.

## 3. Feedback

### 3.1 Overall

It's coherent. Every field has one home, one author, and one reason to change (both of us). The four concerns are what make "the outline must always be true" achievable. Every cell gets a named source of truth, and only the concern-3 cells can drift, which is exactly what the linter checks. The two amendments remove the last ambiguities I had raised; see §3.2 and §3.3.

### 3.2 row-type

- **Keep it as one field.** The fork first proposed splitting it into role (example, template, gap, record) and commitment (exploratory, proposed, landed). It has withdrawn that. In this model an example row is illustration and never lands, and a canon fixture is a `landed` row of kind fixture. So the six values are mutually exclusive.
- **"Canon" means exactly `landed`,** the one value that needs a decision. That makes row-type the outline's decision surface. Your "missing = known canon without even a first draft" becomes `landed` plus doc-state `missing`.
- **Withdrawn (mine), because of the directory amendment.** I had worried that a drafted `exploratory` or `proposed` file sitting in `src/` would read as canon. With directories carrying no meaning, a file's location claims nothing, so the worry goes away. The outline is the authority on row-type. A file read on its own makes no claim about landedness, and doesn't need to.
- **Lint (fork).** Flag any `landed` row whose segment cites no decision in `per`. That keeps the one decision-bearing value true.

### 3.3 landed ≠ integrated

This resolves a collision I'd flagged: "landed" was being used both as a row-type and as an influx outcome.

- **Knock-on edit.** `sop/def/def-integration.md` still names the influx crossing outcomes **landed** · rejected · needs-review · skipped, and says "an item counts as landed only if it passes the delete-test". Under this amendment the influx outcome becomes **integrated**, and `landed` is used only as a row-type.
- **The same sweep** covers `sop/influx/proposed-verisectorium.md` (formerly at the root, line 243) ("landed in rules, cases, and ADRs").
- **One consequence worth stating once:** the two terms can now combine without contradiction. An influx item can be *integrated* by landing its content into a row that is only `proposed`. Integration is about the influx item; landing is about the row.

### 3.4 Directories carry no meaning: what that implies for slugs

*(Superseded by §1.5: frontmatter declares kind, and prefixes are only clues. Kept for the reasoning.)* If kind comes from the slug prefix alone, every record needs a prefix that names its kind, and no record may carry another kind's prefix. Checking the files as they stand today:

- **`dat/rule-implied-root.yaml`** is a fixture file, but its slug prefix `rule-` names the rule kind. It needs a fixture prefix of its own, such as `fix-implied-root`, so it stays distinct from `src/rule-implied-root.md` wherever tooling finds it.
- **ADRs** are proposed as `adr/<slug>.md`, e.g. `adr/reserve-not-ignore.md`, with no prefix. Once the directory carries no meaning, a decision's kind can't be recovered from its slug. It needs one, such as `adr-reserve-not-ignore` or `dec-…`.
- ~~**`sop/def/` versus `def/`** needs another carrier; view membership.~~ **Withdrawn (§1.7 item 11).** I misapplied the directory amendment to the SOP store's boundary. The SOP store is its own small verisectorium, with its own outline, `src/` and kinds. The amendment applies within a store, so `sop/def/` terms are SOP-store terms because they are in that store.
- **Prefixes in use elsewhere are already consistent:** `obj-`, `prin-`, `rule-`, `def-`, and the planned `prop-` and `expl-`.

### 3.5 ∂(doc-state): missing · drafted · conforms

Agreed (both). I was wrong to call it a ladder. The three values are exhaustive, move both ways, and are recomputed rather than typed. It shows `—` on gap rows. Later checks, such as fixtures passing or links resolving, go beside it as separate flags, never as more values of this field; otherwise it becomes two facts sharing one field.

### 3.6 Ordering

This is the "little of both" you anticipated (fork's placement; I agree):
- **Concern 3:** ∂(order) checks rows that have documents against the `depends:` partial order in their frontmatter.
- **Concern 2:** the outline authors deliberate forward references, which need a marker on the row, and the order of rows with no document yet (gaps, undrafted proposed rows), since nothing canonical exists yet to check them against.

### 3.7 Cell values and notation

- **The ※ / ∂ split and views choosing their columns** are both right. Separating "exists and is measured" from "surfaced in this table" means nobody mistakes an unshown field for an absent one. Hand-editing a ※ or ∂ cell is a lint failure.
- **One more cell value (fork; I agree): the linter tried and failed,** e.g. `⚠`. Otherwise a crash and a genuine absence both print `∅`, which breaks the empty-versus-failed-versus-not-run distinction.
- **An applicability table would help (mine):** row-type × kind × field, saying where `—` applies. The linter reads it, and it doubles as the documentation for each field's scope.

### 3.8 The three flags

- `awaiting-second?`, `awaiting-decision?` and `needs-work?` are good independent flags, and each says who moves next (both).
- **Adjudicated (§1.7 item 1): option a.** A ※ column shows `—` on rows with no document, and the pending decision lives in the ADR or question. I had been proposing a non-※ authored column, which conflicts with the notation.
- **The strain (fork):** gap rows and undrafted proposed rows have no frontmatter, yet they are the rows most likely to be awaiting a decision. Two ways out:
  - a. show `—` on those rows, and keep the pending decision in the ADR or pre-design question it concerns (fork's preference: the concerns stay cleaner);
  - b. let the outline author these flags only for rows whose doc-state is `missing`.
- **Optional sharpening (both).**
  - `awaiting-second` names the kind of look it needs: format check, re-derivation, reader test.
  - `needs-work` carries a pointer to the working note, spike or audit.
  - Either lets the linter catch a flag that has outlived its referent. Plain booleans work to start.

### 3.9 verification-level: examples per kind

| Kind | verification-level |
|---|---|
| rule | fixtures written → fixtures cross-checked by someone other than the author → a parser agrees |
| property | derivation drafted → steps checked → independently re-derived, or a counterexample search came up empty |
| definition | consistency of use checked across the corpus |
| fixture | derived from its rule → cross-checked → parser-run |
| explanation | reader-tested |
| objective | met or unmet against its fitness threshold where one exists; otherwise `—` |
| decision | `—` (its `decided-by` carries this) |

- **Keeping it honest (fork).** It should only ever be written by the act that verifies, with a pointer to the evidence in the working notes. The linter checks that every level has a pointer.
- **Addition (mine).** The pointer should include the git hash of the text that was checked. The linter can then show a level as stale once the file has changed since the check. That gives verisectorium's reset-on-edit behavior without anyone remembering to reset anything.

### 3.10 status

**Adjudicated (§1.7 item 2):** ∂, calculated per kind from that kind's measure and the flags. The earlier discussion is kept below.

Still the least defined field (both).
- **Candidate:** the headline a reader should conclude right now, computed from verification-level plus the three flags, with any open finding shown first.
- If so, it earns its place, because verification-level answers "how checked?" and status answers "what should I conclude?". If it would only restate verification-level, drop it.

### 3.11 Resolving `[[kind:slug]]` (the five points agreed in §1.6)

The lookup order is the addressing theory's resolution ladder: step 1 consults a maintained binding (`../../references/def/` `def-binding`), and steps 2–4 are ever-wider matches (`def-match`), which fail silently unless they carry something to check against. So:

1. **Every step checks the frontmatter kind,** not only step 4. A step-2 hit on `src/rule-x.md` whose frontmatter says `kind: fixture` is a lint error, not a hit.
2. **When linting, look in every step,** not just until the first hit. Stopping at the first hit is fine for fast lookup, but two different files for one `kind:slug` are a collision, which first-hit-wins would hide.
3. **Write resolutions back into step 1.** A checked resolution goes into the `.vsect` mapping, so later lookups use a maintained binding, and a moved file shows up as a dangle rather than a silent miss.
4. **Step 4 excludes archives and influx.** `**/<slug>` would find `.old/vsect-init/src/rule-implied-root.md` today. Exempt paths are declared, and they never answer live lookups (RC1's "exempt visibly").
5. **Each kind declares its extensions,** rather than a fixed `{ud,md}`.

Further consequences, all following from §1.6:

- **Identity is (kind, slug).** A slug is unique within its kind, which is the same shape as udon's own `(element-type, key)` uniqueness. Same-noun pairs across kinds (`rule:implied-root` and `prop:implied-root`) are fine.
- **Rename and change of kind resolve differently.**
  - A rename (same kind, new slug) is an alias: a link to the old name resolves to the new record.
  - A change of kind is dissolution and emergence. A link to the old `kind:slug` resolves to the retired record, which carries forward pointers, and never follows silently to the new one, because the new record makes a different claim and fails a different way.
  - So `was:` on the new record is provenance (a supersession of type *invalidated*), not an alias the resolver follows.
- **A bare `[[slug]]` is a lint error** that names the candidate kinds, never a guess (verisectorium's `form-addressing`: "never silent best-guess").

### 3.12 No mixing; fixture files as mechanism files

- **One record, one kind, one frontmatter per file** follows from files being the referent.
- ~~**"Fixture" leaves the record kinds** and becomes a mechanism-file class.~~ **Withdrawn (§1.7 item 10).** I conflated "not in the outline" with "not a record". A fixture file is a record of kind `fixture` at file grain, declaring its kind in a top-level YAML key, that no outline lists. Outline membership is a view's choice, not what makes something a record, and the kinds map is what defines the corpus (§1.8). Case ids are anchors inside the record. This keeps fixtures under the same machinery as everything else.
- **References to fixture cases need linting too.** So `test-fixtures: dat/stub.yaml` and `![[dat/stub.yaml#C7]]` must be checked the same way a `kind:slug` is: a missing file or case id is a dangle.
- **Case ids stay stable names, never reused.** The fork's fixture key already says so. A name like `root_two_top_level_elements` survives reordering; `C7` doesn't.
- **Canonical cases are normative, even outside the outline.** Flipping one changes what the spec means. The rule that cites the file is where that gets tracked: its verification check ("a parser agrees") records the fixture file's git hash beside its own (§3.9). **Parked (§1.7 item 10):** this is more advanced than anything else in the corpus right now, so it waits as a note for the future linter. This may also be where that machinery first gets built and made concrete.
- **Transcluded cases carry a staleness obligation.** When a case transcluded as `![[dat/stub.yaml#C7]]` changes, the "Here you see that…" prose around it is stale, the same rule that applies to teaching prose narrating a record that has changed.
- **§3.4's fixture point is resolved:** `dat/rule-implied-root.yaml` becomes `dat/implied-root.yaml`, cited from `rule:implied-root` by `test-fixtures:`.
- **§3.4's ADR point, restated:** decisions are records, so they resolve as `[[decision:reserve-not-ignore]]` or `[[adr:reserve-not-ignore]]` (an alias). The file needs no prefix; frontmatter carries the kind.

### 3.13 The `.vsect` resolution config

Agreed in outline (§1.7 items 3–4, §1.8 item 4). The separate form, as first proposed:

```yaml
# .vsect/kind-map.yaml: kind names. Frontmatter `kind:` uses the canonical name;
# links may use the canonical name or any alias.
kinds:
  objective:   {aliases: [obj]}
  principle:   {aliases: [prin]}
  definition:  {aliases: [def]}
  rule:        {aliases: []}
  property:    {aliases: [prop]}
  explanation: {aliases: [expl]}
  decision:    {aliases: [adr, dec]}
  fixture:     {aliases: [fix]}
```

```yaml
# .vsect/kind-match.yaml: resolving [[kind:slug]].
# <kind> expands to the canonical name and each alias; <slug> to the slug.
# The first existing file whose frontmatter kind matches wins.
bindings:                      # step 1: explicit, still frontmatter-checked
  # rule:implied-root: src/rule-implied-root.md
globs:                         # steps 2 to 4, in order
  - src/<kind>-<slug>.{ud,md}
  - <kind>/<slug>.{ud,md}
  - "{src,obj,def,adr,dat}/<slug>.{ud,md,yaml}"
  - "{obj,def,sop/def}/<kind>-<slug>.{ud,md}"   # only for today's filenames; drop once renamed
```

**The merged form (§1.8), my lean:** one file in which each kind declares its aliases, where it is found, and its verification ladder. That gives the three things that start to flesh out kinds from a tooling perspective.

```yaml
# .vsect/kinds.yaml
bindings: {}                   # step 1, shared across kinds
kinds:
  rule:
    aliases: []
    find: [src/<kind>-<slug>.{ud,md}, <kind>/<slug>.{ud,md}]
    verification: [authorized, fixtures-written, fixtures-cross-checked, parser-agrees]
  fixture:
    aliases: [fix]
    find: [dat/<slug>.yaml]
    verification: [derived-from-rule, cross-checked, parser-run]
  decision:
    aliases: [adr, dec]
    find: [adr/<slug>.md]
    verification: []           # a decision carries status and decided-by instead
  # ...one entry per kind
```

- **The explicit directory lists** replace both `**/` and my exclusion guard: `.old/` and the influx surfaces are never listed.
- **Notes for the future linter, not rules now:**
  - report any later glob that also matches, since that's a collision;
  - write checked resolutions into `bindings`.
- **One decision inside this:** canonical kind names in frontmatter, aliases only in links, so the frontmatter check stays an exact match.
- **The verification ladders above are placeholders.** They come from §3.9 and still need confirming kind by kind.

### 3.14 Note: verification is the core of verisectorium's epistemology

*(Recorded at Joseph's request, §1.8 item 8. It may need a revisit of RC1.)*

What this corpus surfaced: verification-level is not one ladder, but a ladder each kind declares. In spec-lite, what verifies a rule is mostly *authorization*: an accepted decision behind it. Evidence (fixtures, a parser agreeing) comes second. In AAT the order is the reverse: derivation and evidence carry everything, and authority is noise. So the same slot holds different things by kind and by corpus.

RC1 already has pieces of this:
- *kind as dimension-composition* (03);
- the `decision/*` namespace, with accountability as a ladder;
- the substitution law: *ruled* never makes something true.

What RC1 doesn't yet state cleanly:
- how a kind's single verification-level relates to its several dimensions, i.e. whether verification-level is a declared projection over them;
- how a corpus whose records are mostly *decided* (a spec) differs from one whose records are mostly *derived* (a theory) in which dimensions it opens by default.

The kinds file's `verification:` field is the first concrete place where this becomes declared rather than implicit. What it teaches should flow back to RC1 03 and 10 (Q4 to Q6) through verisectorium's influx.

### 3.15 Delimiting defined terms

Agreed that officially defined terms should always be delimited. Four points:

- **It frees backticks for code.** The current convention (`.int/README.md`: "Terms defined in `lexicon.md` … are written in backticks") collides with code spans, and this spec is full of code.
- **It's lintable.** Every `«x»` must resolve to a term in an SOP-store definition, and every `‹x›` to a term in a lite definition. Otherwise it's a dangle. Each term group's `terms:` frontmatter list is the index.
- **A caution about `‹…›`.** In a spec *about* `<…>` typed values, single guillemets look very like angle brackets, especially in monospace. Readers will confuse `‹typed-value›` with `<typed-value>`. Options:
  - keep `‹…›` and accept the risk;
  - swap, so lite terms (the more frequent ones) take the distinctive `«…»` and SOP terms take something else, such as `⟦…⟧`.
- **My lean:** `«…»` for lite (domain) terms, because they're the most frequent and the most confusable in this corpus, and `⟦…⟧` for SOP terms. It's your call; the principle matters more than the glyphs.

## 4. Status of the items (after §1.9)

**Settled:**
- merged `.vsect/kinds.yaml` (§3.13);
- term delimiters `«…»` for domain (lite) terms and `⟦…⟧` for SOP terms (§3.15);
- lexicon in `def/` plus a generated view;
- `max` dropped for udon-lite for now;
- the proxy-before-threshold rule recorded in the SOPs as undecided.

**Settled, with scope made explicit:**
- **Everything from this side is example, proposed or template.** Lite's own decisions (converting its eight seeded decisions to ADRs, `force` on reserve-don't-ignore) belong to the udon team.
- **The SOP store has its own `.vsect/`** (`sop/.vsect/kinds.yaml` for its own kinds) **and its own decision set** (`sop/adr/`, or `sop/dec/`), separate from lite's spec decisions. Process decisions start being recorded as soon as possible.
- **Kinds are updated in `kinds.yaml` as needed.** Adopting "the model" doesn't need a decision.
- **Authority and accountability are proper for process decisions,** even in a corpus like AAT, where they are noise for theory claims (§1.9 item 4).

**Still open:**
- **Closer routing** in the outline's Open questions table goes to the udon team (§1.10). Joseph expects them to want an open-question kind, and intends to vote for a `wut/` directory for it.
- **vsect's requirements on lite** (the item §1.9 numbered 7) are handed to the udon team as `.int/vsect-requirements-on-lite.md` (§1.10). They are input, not a decision here.

**Next, in order (§1.9 item 8):**
1. Carve the SOPs: `sop/main.outline.md`, `sop/src/`, `sop/.vsect/kinds.yaml` and the SOP decision set.
2. Fix the spec outline: right columns, with row-type marking this side's rows as examples.

## Working notes

- **Edits this implies, none made yet:**
  - rename the influx outcome `landed` → `integrated` in `sop/def/def-integration.md` and `sop/influx/proposed-verisectorium.md`;
  - replace `state` with `row-type`, and add the new frontmatter fields, in `sop/def/def-record-fields.md`;
  - keep `fixture` in `sop/def/def-record-kinds.md`, and add that a record may be listed in no outline (§3.12, as corrected);
  - retitle the outline's columns with ※ and ∂, and rewrite its links as `[[kind:slug]]`;
  - rename `dat/rule-implied-root.yaml` → `dat/implied-root.yaml`, and add `test-fixtures:` to `src/rule-implied-root.md`'s frontmatter;
  - soften the proposal's "Lives in" column (kind → directory) to "usually kept in", per §1.4 and §1.5;
  - note in the proposal that kind comes from frontmatter, and that prefix and directory are clues only.
  - ~~record this session's process decisions in the SOP decision set~~ **done 2026-09-30:** `sop/adr/`, 22 records (20 accepted, 2 undecided), each quoting Joseph verbatim from §1;
  - carve the settled parts of this file, the proposal and `sop/def/` into `sop/src/` segments, and start `sop/main.outline.md` (from verisectorium's template sop outline);
  - replace the backtick convention for terms with the chosen delimiters.
- **History of this file:** started in `.int/`, and moved to `sop/influx/` at Joseph's direction (§1.8), together with `proposed-verisectorium.md`.
