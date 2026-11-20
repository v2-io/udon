# Branch family "mark": what an explicit mark holds, how it is spelled, and where a type is named

*Spike c, fork "mark" (Opus 5.5, 2026-10-22). Decision points D2 (what `<…>` holds and asserts, and whether `<` is the right glyph), D3 (where a notation or type is named: in the literal, on the slot, or outside lite) and D7 (the trailing colon on attribute names). Scored against `CTQ-FACTORS.md`. Precedent (KDL, EDN, Elixir, REBOL, YAML, CommonMark) is weighed as evidence against those factors, never as a reason. The UDON and Markdown in the corpus are not used as evidence (Joseph's note, relayed mid-run): two early counts I took from the corpus were discarded, and nothing below rests on them.*

**Labels used throughout:** *checked* (read in a spec or a card, with the place named), *instinct* (what I, as a target writer and reader, would write or expect; Joseph ranks this above the corpus), *guess* (an inference I haven't verified), *taste*.

**Tree notation used on these pages:** `‹…›` is a «text»; `"…"` a «string»; a scalar written `8080::int.angle` gives its kind, then its form (`angle` is written in `<…>`, `bare` unquoted, `dq` in double quotes); `lit(date, "2026-01-10")` is a notation literal (sub-branch M2) with its notation name and raw body. The trees assume the store's current lean on bare runs (a bare run is a «text»; [[rule:unquoted-run-is-one-value]]) unless a page says otherwise. Under option B (sibling fork) the bare cases change and the marked cases do not.

## The finding this family stands on

**Every mark, wherever it sits, does one of two jobs, and the two have different costs.**

1. **Assert a portable kind** (`<8080>` is an integer, `<nil>` is nil). The parser checks it, the kind is known at the mark (kind-first), and nothing in it needs a name. The job is small and closed.
2. **Name a notation** (`date`, `money`, `rust:i64`), whose reader lite doesn't have. Lite can't check the body, so all it can do is carry it, and carrying it is safe under the reserve-don't-ignore veto (B2) **only if notations are always read *above* the tree, in full UDON as well as in lite.** A dialect must never change the raw tree: it reads the raw body into a value at the logical layer (Joseph's pipeline "udon → stream/wire → full-ast → logical-ast → API"). This binds full UDON as well as lite. *(Derived from B2 and the B1 footnote "lite documents parse the same under a streaming full parser"; checked against both texts in CTQ-FACTORS.)* The one thing a notation can't do from above is put structure (nodes) inside a literal, so the interior shapes that would carry structure (`<{…}>`, Joseph's "embedded value") have to stay reserved in lite.

Everything else in the family is the question of *where* the name sits (inside the literal, on the slot, or nowhere in lite) and *which glyph* carries it.

## Branch map

| | Sub-branch | Status | Page |
|---|---|---|---|
| M1 | **Assert only.** `<…>` holds exactly one portable primitive (nil, boolean, number, delimited string; `<>` is nil); kind committed at its first interior character; anything else, a named notation included, is an error. | **alive**, strongest on robustness and headroom | [m1-assert.md](m1-assert.md) |
| M2 | **Assert, plus named notation literals.** M1, and also `<name:body>`: lite splits off the name at the first `:` and carries the body raw; reading it is a notation's job, above the tree. | **alive**, strongest on types/notations (C4) | [m2-named-literal.md](m2-named-literal.md) |
| M3 | **The slot's kind on the attribute name**, two spellings: `:when.date 2026-01-10` (the `.trait` elements already have, given to attributes) or `:when<date> 2026-01-10` (as generics are written). Combines with M1 or M2. Earns its keep only where one declaration governs several values (an attribute body, a list); on a single value it is M2 moved to the left. | **alive**, the home for slot-side naming. The dot spelling's hazard is dotted-key priors (`:server.port` meaning nesting, a silent miss); the angle spelling avoids it and gives `<` a second role | [m3-attribute-traits.md](m3-attribute-traits.md) |
| T4/T1 | **The trailing colon.** Reserve it now (`:host:` an error, "did you mean `:host`?"); his ornament (T1) later is a widening. | **alive**, the lean | [d7-trailing-colon.md](d7-trailing-colon.md) |
| G | **Glyph alternatives** to `<…>`. The Elixir-style sigil `~name[body]` survives as the fallback glyph; the others die. | page | [glyphs.md](glyphs.md) |
| M0 | **No mark at all**: quotes and bare text only; every kind from an external schema. | **dead as a mark design**, viable only paired with option B | below |
| M2r | **M2 with the unlabeled interior carried raw** (`<2026-10-01>` as raw text, his 2026-10-20 option). | **dead**: fails B2 | below |
| M2s, M2p | **M2 with a space or a pipe separating name from body** (`<dt 2026-01-10>`, `<u32\|0xff>`). | **dead** against the colon | [m2-named-literal.md](m2-named-literal.md) §separator |
| T2 | **Compulsory trailing colon** on every attribute name. | **dead** | [d7-trailing-colon.md](d7-trailing-colon.md) |
| T3 | **Colon type slot** `:when:dt 2026-01-10`. | **dead**: collides with `xml:lang` (C2, 10); its job goes to M3 | [d7-trailing-colon.md](d7-trailing-colon.md) |
| KDL, EDN, YAML-tag, quote-tag glyphs | `(u16)8080`, `#inst "…"`, `!int 5`, `date"…"` | **dead** | [glyphs.md](glyphs.md) |

### Why the dead ones died

- **M0, no mark.** It makes kind come only from a slot, and lite has no slot declarations, so a schema-less JSON round trip (C1, weight 10) can't say "this is the number 3" unless bare spelling is typed (option B). As a *mark* design it's empty. As B's partner it's a live combination for the B fork to weigh: B plus M1-for-overrides is nearly M0. Not killed on taste.
- **M2r, unlabeled interior raw.** If `<2026-10-01>` is accepted as raw text in lite, a later UDON that reads an unlabeled date (the old standard set's temporal reattached) gives that document a different tree, or has to promise it never will. Either it fails B2 (the veto) or it freezes the unlabeled interior forever, which is M1 with a pointless raw pocket. Tried both ways (above-the-tree reading would rescue it as it rescues M2; but then the unlabeled body has no name to select a reader, so "above the tree" means "re-classify by spelling": option B's mechanism inside brackets, with B's kind-at-close). Dead with that reason; the rescue lives on as M2's labeled form.
- **The others** are on their pages.

## Scores (my hypotheses, 0–10; basis on each page; confidence low to medium throughout, no panels run)

Only the factors where the sub-branches differ are listed; the rest move together. Weights from CTQ-FACTORS.

| Factor (weight) | M1 | M2 | M1+M3 | M2+M3 | M2 with sigil glyph |
|---|---|---|---|---|---|
| A1 agent-subjective (9) | 7 | 7 | 8 | 8 | 6 |
| A2 generative guessability (10) | 6 | 7 | 5 | 6 | 6 |
| A3 cold comprehension (10) | 7 | 8 | 6 | 7 | 7 |
| A5 domain-forward (9) | 5 | 6 | 8 | 8 | 6 |
| A6 spec clarity (9) | 9 | 8 | 8 | 7 | 7 |
| A7 syntactic simplicity (8) | 9 | 8 | 8 | 7 | 7 |
| A8 parsimony (8) | 9 | 9 | 9 | 9 | 7 |
| B2 reserve, don't ignore (veto) | pass | pass, *conditional*¹ | pass | pass¹ | pass¹ |
| B3 stability (10) | 9 | 9 | 9 | 9 | 9 |
| B4 errors that teach (8) | 9 | 8 | 8 | 8 | 8 |
| B6 headroom (7) | 10 | 7 | 8 | 6 | 6 |
| C2 XML/HTML (10) | 7 | 6 | 7 | 6 | 9 |
| C3 Markdown in prose (9) | 7 | 6 | 7 | 6 | 9 |
| C4 types, notations, units (8) | 3 | 8 | 6 | 9 | 8 |
| C5 schemas and slot types (8) | 4 | 4 | 7 | 7 | 4 |
| C6 extensibility, dialects (8) | 3 | 8 | 6 | 9 | 8 |
| **weighted sum of these rows** (computed) | **908** | **952** | **957** | **975** | **940** |

¹ M2's B2 pass holds only with the commitment above: notations are read above the tree in every UDON, and `<{` and the other structural interiors stay reserved.

*How to read the sums:* the spread (908 to 975) is about one or two cells' worth of my uncertainty, so the order is weak evidence. What the rows do show is the trade: M1 buys robustness and headroom with no notations, M2 buys notations at some headroom and one silent collision (the autolink), and M3 is what moves domain-forward (A5) and slot types (C5). The sums favor M2+M3. **What they leave out is reversibility:** going from M1 to M2, M3 or both turns errors into accepted documents, which changes no tree lite already produced; going back the other way breaks documents. So my recommendation for lite 0.1.0, as taste weighed against that asymmetry, is **M1, with M2's `<name:` and M3's attribute `.` both kept as errors that teach.** M2+M3 is where I'd expect UDON to land once notations are wanted, and getting there undoes nothing.

## The decision points, as questions for Joseph (each with examples on its page)

1. **Does `<…>` assert only the portable kinds in lite 0.1.0 (M1), or also carry named notations raw (M2)?** `|e :when <date:2026-01-10>`: an error in lite, or `lit(date, "2026-01-10")`?
2. **If notations are ever carried: is "a dialect reads above the tree, never changes it" a law for all of UDON?** It is what makes M2 safe, and it rules out structure inside `<…>`.
3. **Is a slot's kind ever written in the document, and if so, how: `:timeout.duration 5m` or `:timeout<duration> 5m`?** The dot's hazard is `:server.port 8080` written by a TOML-trained writer meaning nesting, which is silent. The angle's cost is `<` in two roles.
4. **The trailing colon: reserve now (T4), with your ornament (T1) as a later widening?** It conflicts with the labels lean as it stands (`:` allowed last in a bare label).

## Things noticed outside this family (one line each)

- Under M1 or M2, `<…>` is no longer an *opaque span*: it gets an interior grammar. Part III's opaque-span cards then cover `@{…}` and `;{…}` only, and `<…>` gets its own card; that is a clarity gain (A6) whichever of M1/M2 wins.
- [[rule:value-line-escapes]] already lists `<` in its escape set; M1 and M2 make that entry load-bearing (`|li \<kbd>Ctrl</kbd> to copy`).
- Whether `<8080>` is needed often depends on the Cv/B forks: with the typed-primitive view on by default, marks are rare overrides; with it off, every number in schema-less data is marked.

## Deep forking

I could not fork further: the harness's rules for a worker fork forbid spawning agents ("Do NOT spawn subagents … you ARE the fork"). So one level of forks is what the harness allowed here; the sub-branches are files, and the research forks were web lookups I did myself (KDL spec §3.8, EDN README, Elixir sigils guide, REBOL Core ch. 16, CommonMark 0.31.2 §6.5–6.6).
