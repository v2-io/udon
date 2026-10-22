# Spike c: how lite's values come to mean what they mean

*Spike c of three (`a/`, `b/`, `c/`), launched 2026-10-22 from the brief in `../BRIEF.md`. Worked by one Opus 5.5 spike agent and four fork agents it launched (`Cv`, `B`, `mark`, `core`). Nothing here is decided. Every score is an agent's hypothesis against `CTQ-FACTORS.md`, with its basis and confidence; nothing was measured except the two checks in `checks/`. The other spikes' directories were not read, so this one branches independently.*

**Start with [`debrief.md`](debrief.md)**: it is written to Joseph, in UDON examples and trees.

## The question as I took it

The span (verbatim record lines 1543–1751) opens on the trailing colon, `<>` as nil, and "`<…>` in all of its forms is still very cheap to change". It then widens to the whole territory: slot type vs literal notation, units, algebraic names, the old standard set, dialects, host types and display. For lite 0.1.0 the decision is narrower: **what the lite tree records about a value, what lite's spelling lets a writer assert, and where every other kind of meaning comes from**, so that types, notations and units can be layered on later without changing any tree lite has already produced.

The frame that organized the whole spike (`00-frame.md`): a value's kind can come from only three places. These are the **slot** (known before the value), a **start mark** (known at its first character), or its **spelling** (known only at its end). Every branch is a choice of which of the three carries which kinds.

## Branch map

| Branch | Decision point | Status | Page |
|---|---|---|---|
| **D0**: lite has no type system at all | frame rejection | **dead as a design** (nil can't be spelled; C1 fails), **alive as the principle**: the tree records what was written, and the reader brings the kind | [`branches/D0-no-types-in-lite.md`](branches/D0-no-types-in-lite.md) |
| **Cv**: bare is text; the view is a typed read (`int(:port)`); `<…>` holds only the primitives; any other interior is reserved | D1, D2 | **survives** | [`branches/Cv/branch.md`](branches/Cv/branch.md) |
| Cv push-view (a converted second tree) | D1 | dead: brings back every trap (`:zip 01234`, `:version 1.10`); it is B under another name | Cv page, Cv.1 |
| Cv subtree "classify" switch | D1 | dead: a parse-mode directive in disguise, and lite has no directives | Cv page, Cv.3c |
| Cv `<[1 2 3]>` (one mark over a whole list) | D2 | alive, small | Cv page, Cv.3b |
| **B\***: the whole run decides, in the tree, spelling kept | D1 | **survives on memory-bounded B1**; **fails** if B1 counts characters until the kind is known (whitespace) | [`branches/B/branch.md`](branches/B/branch.md) |
| **A**: the first character commits | D1 | dead: `920px` is an error, and `1984 is a novel` silently splits | B page, last section |
| **Σ**: the standard set is a schema, not a grammar (B's reading is one slot type, `std`) | D1 reframed | **survives, as the synthesis** in which Cv and B are one design read two ways | [`branches/Sigma-standard-set-is-a-schema.md`](branches/Sigma-standard-set-is-a-schema.md) |
| **core-J**: nil, true, false, integer, float, delimited string, list; strict spelling | D4 | **survives** | [`branches/core/branch.md`](branches/core/branch.md) |
| core-M (the old line's maximal set) | D4 | dead: every extra member fails "parameter-free" or "host-portable", and the old surprises all sit inside them | core pages |
| core-0, core-J+D (bare dates) | D4 | dead / later | core pages |
| **U1**: units are text; the slot gives meaning | D5 | **survives** | [`branches/core/units.md`](branches/core/units.md) |
| U2 (bare quantity literal `920px`) | D5 | dead: captures `1st`, `4K`, `1080p`, `401k`; `5m` still ambiguous | units page |
| U3 (unit inside a mark with a named notation) | D5 | later; forward-compatible | units page |
| **K1**: bare `nil`/`true`/`false` plus `<nil>`, `<>` | D6 | survives (under Cv the bare ones are text and the view reads them) | [`branches/core/keywords.md`](branches/core/keywords.md) |
| **M1**: `<…>` asserts exactly one portable primitive (`<>` is nil); every other interior is an error | D2 | **survives, the 0.1.0 recommendation** | [`branches/mark/m1-assert.md`](branches/mark/m1-assert.md) |
| **M2**: M1 plus named notation literals `<name:body>`, body raw | D2, D3 | **survives as the later step**, *only* under a law for all of UDON: notations are read above the tree and never change it. One silent collision: `<https://…>` | [`branches/mark/m2-named-literal.md`](branches/mark/m2-named-literal.md) |
| **M3**: a slot's kind as an attribute trait (`:dates.date`) or `:port<u16>` | D3 | survives; earns its keep only where one declaration covers several values; dot spelling has the TOML dotted-key silent miss | [`branches/mark/m3-attribute-traits.md`](branches/mark/m3-attribute-traits.md) |
| M2r (unlabeled `<…>` carried raw, today's card) | D2 | dead: fails the B2 veto | [`branches/mark/branch.md`](branches/mark/branch.md) |
| Sigil glyph `~name[…]` | D2 | kept on file: the one glyph that frees `<` from HTML and autolinks | [`branches/mark/glyphs.md`](branches/mark/glyphs.md) |
| KDL `(t)v`, EDN `#tag`, YAML `!!t`, `name"…"`, suffixes; space or pipe as name separator | D2 | dead | glyphs and M2 pages |
| **T4**: reserve the trailing colon now; T1 (your ornament) later as a widening | D7 | **survives** (conflicts with the labels lean, which allows `:` last) | [`branches/mark/d7-trailing-colon.md`](branches/mark/d7-trailing-colon.md) |
| T2 compulsory colon; T3 `:when:dt` type slot | D7 | dead: T3 collides with `:xml:lang` | same page |

## Checks (things actually run)

- [`checks/streaming-holdback.md`](checks/streaming-holdback.md): **measured**: the 0.9 reference parser holds every value, of every kind, whole until its terminator (1 MB text, digits, quoted string, prose line: 0 bytes emitted early). **Modeled**: classifying a run needs only finite state, and the holdback falls on whoever needs the kind *before* the content. `holdback-probe.rs`, `wire_model.py`, `wire_model.out.txt`.
- [`branches/B/classify_stream.py`](branches/B/classify_stream.py) (the B fork): a constant-state classifier agrees with a regex reference on 200,000 random spellings, fed whole and in random chunks.

## Other files

- [`00-frame.md`](00-frame.md): the geometry and the decision points.
- [`composite-examples.md`](composite-examples.md): the shared intents (E1–E12) every branch rendered.

## On the deep-forking experiment

The spike agent launched four forks (full-context agents) at once. Each fork reported that the harness gives forks a standing rule not to spawn agents ("you ARE the fork, execute directly"), so **forking went one level deep**. Every fork branched further in its files instead. SendMessage to running and finished forks worked. Joseph's two mid-run notes were relayed to all four. One rendering error (the mark fork's `|a :href … Click here` line, which contradicted the bare-run card) was sent back to that fork and fixed after it had reported. Each fork used about 260–300k tokens, by the harness's counts.

## What was verified, and what wasn't

- Verified: the holdback probe (run on the 0.9 parser); the wire model; the B fork's classifier fuzz (re-run by the spike agent: 0 mismatches over 200,000 short spellings). The forks' claims about card text were spot-checked where the debrief relies on them: the run's extent, the labels lean's `:` positions, and `.` in attribute names.
- Not verified: every CTQ score (each is one agent's hypothesis); the precedent readings the mark fork took from the web (KDL §3.8, EDN, Elixir sigils, REBOL ch. 16, CommonMark §6.5–6.6), which were re-checked by no one.
