# The other `<…>` branches, live and dead

*Fork `angle` of spike a, 2026-10-22. Each with the line that shows it best, why it scores where it does ([scores.md](scores.md)), and for dead branches why they died.*

## Live, scored below ANG-4c

### ANG-1: the raw box (the card today)

`<…>` carries its text raw; lite reads nothing inside. `:size <u64:0xff>` → raw `u64:0xff`; `<8080>` → raw `8080`.

- **For:** the shortest rule (A6, A7); spends nothing (B6 high).
- **Against:** under Joseph's current lean (bare is text), nothing in lite's tree is a number or nil unless a view runs, so the JSON case (C1) is met only by the view. It is open-world unlabeled, so `<920px>`, `<b>` and `<path>` are quiet values (B4, A2). Notations are carried but unstructured: a reader must split `u64:0xff` itself.
- **Status:** coherent only if DP1 classifies bare values. Even then ANG-4c does strictly more for the same streaming cost.

### ANG-2: the standard set inside, everything else raw

The coordinator's 2026-10-20 restatement: an interior that wholly spells nil, a boolean, a number or a delimited string is that value; anything else is raw.

- **Against:** the no-go. It can't reject `<920px>` or `<8O80>`, so it contradicts his 2026-10-21 "<920px> error I can understand". One bracket gives a number or raw text depending on the whole interior, which a reader can't predict without knowing the set's every edge (C7, A3). Every edge of the number grammar (`<1_000>`, `<+5>`, `<0x>`, `< 3 >`) becomes a raw-vs-number boundary that every parser must draw identically (B3).
- **Status:** dominated by ANG-4c, which has the same members and errors where this one goes quiet. **His literal 10-20 words** ("number, leading with [+\.\d-]") describe first-character commitment, which is ANG-3/ANG-4c, not this.

### ANG-3: closed, and no notations at all

Unlabeled `<…>` as in ANG-4c (the standard set or an error); no labeled form. Notations are reserved, so `<u64: 0xff>` is an error.

- **For:** strictest reading of B2; very stable (B3) and teaching (B4); simple.
- **Against:** lite can't carry a named notation (C4, C6, A10 low), so temporal values are bare text only. That's acceptable if slots and schemas carry meaning (A5), and it's where ANG-4c lands if Joseph answers "a refinement *is* a change" to the B2 question.
- **Status:** the fallback of ANG-4c, and a legitimate lite 0.1 if notations wait for full UDON. It can widen to ANG-4c later without changing any accepted document (error → accepted).

### ANG-4o: the value fence, open when unlabeled

ANG-4c's labeled form, but an unlabeled interior that isn't in the standard set is carried as raw («undetermined») instead of an error: `<2026-07-21>` is accepted, raw.

- **For:** lets the estate's spelling stand (ideation only, per Joseph); slightly fewer errors.
- **Against:** the open-world cost again: every angle-bracket prior (HTML tags, placeholders, autolinks, operators) is a quiet value. To stay forward-safe the raw must be «undetermined», never a string, and a later temporal reading of `<2026-07-21>` is then a refinement of the *unlabeled* space too, which spends headroom (B6) that ANG-4c keeps.
- **Status:** live, second to ANG-4c. The difference is one cell of the table.

### ANG-5: notations as elements; `<…>` retired

No `<…>` at all for notations: `:when |date 2026-07-21`, or, so that more can follow on the line, the embed `:when |{date 2026-07-21} :by jw`, read as its element by the one-embed reading option. `<…>` is freed for later.

- **For:** no new syntax (A7, A8); frees a bracket pair (B6 = 10); nests (`|{r |{i 3 -7} 0d83.23}`).
- **Against, found by pushing it:**
  - A bare element value takes the rest of the line ([[rule:element-after-attribute-with-no-value]], **checked**): `|el :when |date 2026-07-21 :by jw` gives `by` to the date. So only the embed works mid-line.
  - Embeds are pieces of text ([[rule:embeds-in-text]], **checked**), so the tree holds a text with one embed and needs a reading option to become a value (C7, B3).
  - A consumer can't tell markup (`|{em x}`) from a notation (`|{date …}`).
  - It's the noisiest to read (A4, A9), and the embed interior is undesigned.
- **Status:** alive only as "what if `<…>` is retired". A wildcard sibling may push it further.

## Dead, with the reason kept

- **Other brackets for the notation form.**
  - **KDL's `(dt)2026-07-21`:** `(` at a value's start is text today (`:note (see above)`), so it would silently change existing values. That fails generative guessability (A2) and stability (B3) for no gain over `<…>`.
  - **Unicode brackets (`⟨…⟩`, `«…»`):** add special characters (A8), and Joseph finds them visually confusable with `<…>`.
  - **Doubled `<<…>>`:** adds a form without a job.
  
  All three died at their first composite line.
- **A suffix label (`<2026-07-21:dt>`):** decides late, against UDON's "decide and start parsing sooner" (Joseph, 2026-10-22), and collides with times (`<10:12>`). Dead.
- **Head separators other than `: `:**
  - **Space only (`<dt 2026-07-21>`):** mirrors the fence and the element exactly, which made it the most tempting. It died on single words: `<today>` and `<infinity>` would be notations with empty bodies, and `<hello there>` a notation named `hello`.
  - **Bare colon (`<dt:2026-07-21>`):** 0.9's label ladder. It reads `<https://x>` as a notation named `https`, and `<a:b>` is ambiguous.
  - **Pipe (`<u64|0xff>`):** Joseph used it twice (2026-07-11, 10-21). It gives `|`, the element marker, a second role inside a value, which reads as an element to a model scanning without highlighting (A4, A8).
  
  `: ` with a required space has none of these collisions.
- **Notation declared only on the slot (`:when:dt 2026-07-21`):** not this fork's; the slots fork owns it. One fact for it (**checked** against the label lean): `:` is an inner label character in the coordinator's lean (`xml:lang`), so `:when:dt` reads as an attribute named `when:dt` unless the label rule changes.
- **`<…>` also doing quotation (`@{<…>}`):** a different job (Lisp's `quote`); recommended to get its own spelling, not decided here.
