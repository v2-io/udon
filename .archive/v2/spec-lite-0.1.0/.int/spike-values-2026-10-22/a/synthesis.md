# Synthesis: how the branches compose (spike a)

*Written by spike a's coordinator (Opus 5.5) after all six forks reported, from their files and my own checks. Labels: **checked** (verified against a primary this session), **fork's** (a fork's finding I read but didn't re-derive), **judgment** (mine). Scores are hypotheses against [`CTQ-FACTORS.md`](../../../CTQ-FACTORS.md), never measurements. Per Joseph's two notes, the estate's documents are ideation, not evidence; the evidence used is the factors, outside notations' documented behavior, his own recorded words weighed against the factors, and the instincts of the agents doing the work ([instincts.md](instincts.md) holds mine, written before any fork reported).*

## 1. The question underneath

As posed, the span asks for a type system: slot types, notation hints, units, algebraic names, the standard set, and where `<…>` fits. For lite, much of that dissolves on one fact the cards already state: **lite evaluates nothing.** Lite never gives a value its meaning; a reader does: the default reading, a slot type (schema, file-naming convention, vocabulary), or a notation's handler. So the questions lite itself has to answer are fewer and sharper:

1. **What does the tree keep about a value?** Its spelling, its form, any classification, any annotation, and its address (which element, which attribute).
2. **Which spellings does lite commit, carry, or refuse?** Commit: parse them with a defined result. Carry: accept them unread. Refuse: reserved, an error.
3. **Is there one default reading every consumer gets, and what is in it?**

The answers have to let every later reader, and every later UDON, assign meaning without changing an accepted lite tree. Slot types, aliases, unit semantics, coercion and canonical display all live in the reader's layer. The slots fork names what lite owes that layer (R1–R7 in [forks/slots/dp10](forks/slots/dp10-aliases-and-reader-contract.md)), and lite already meets most of it. *(Judgment: the frame held up across all four decision forks; none found a reason lite itself must type a slot.)*

## 2. The finding that reopens the bare-value question

**Bounded streaming does not separate whole-run typing (B) from Joseph's current lean (C with the view).**

- **checked:** `forks/classification/f1_check.py`, which I ran myself. A hand-written finite-state classifier, fed one character at a time beside the scanner, agrees with the view's whole-text regex on a 27-case battery and on 400,000 fuzzed runs. A run of 1,000,011 digits ending in `p` is emitted from its first character with nothing held; its class (none) is known at the close. I read the classifier: it is a genuine DFA with four slots, with no buffer and no whole-text peek.
- **Why it holds:** under the bare-run rule, a run's extent never depends on what it spells. The view computes the same function at the same moment, the run's end. So whoever wants the classification waits for the end under both, and whoever doesn't wants nothing under both.
- **What made B look worse:** an event model that announces a value's kind before its characters. **checked:** descent's CHANGELOG describes HOLD/RELEASE, a held buffer for late-decided `$key`. Lite specifies the tree, not the wire, so the cost is to the event vocabulary (a class attached at the close), not to buffering.
- **fork's (external research):** conversion needs every digit under any design (jackson's 1000-digit cap; CPython's 4300-digit cap, CVE-2020-10735). The real bound is a host-guide conversion limit, the same for all three options. No deployed format streams a bare value and trails its class; both halves exist apart. The combination is new, which is a risk to name.
- **checked (history.jsonl lines 22733, 16328, 7711):** on 2026-10-21, before the holdback objection, Joseph called treating `:d 3` as anything but numeric "opposed to the magic of udon values". On 2026-07-15, streaming moved him to option A for the same reason. On 2026-01-10 he accepted that "the host … will do some "inner" parsing and coercion itself". Streaming has twice decided against whole-run typing; F1 says its cost isn't what it seemed.
- **The one reading it needs from him:** CTQ B1 says "every construct's kind is known within a few characters". F1 holds if "kind" is the construct's (a bare run, known from its first character), with the classification as a later attachment. His usage treats type and kind as one word. *(fork's: research-internal.)*

## 3. Where the classification lives (DP1): Cc

**fork's (classification), and my judgment agrees:** the view with its default left open is not a design. Two consumers would disagree about `:enabled true`, which costs stability (B3) and a predictable API (C7). Fixing the default yields one of two designs:

- **C0:** bare is text, and nothing else.
- **Cc:** bare is text, plus a **normative classification attached by the parser** when the whole plain run spells a member of the standard set.

B (class as the kind) holds the same information as Cc but differs in two ways:

- **Identity.** Under Cc a value is its spelling: `|h1 1984` is a heading's text, `[3]` and `[03]` are different keys.
- **Growth.** This depends on §6's question.

The fork's weighted hypotheses: Cc 8.20, B 7.48, the view as carded 6.55, C0 6.40, the old line's whole set 5.62.

**The standard set under Cc: JSON's literals.** nil, true, false, and JSON's number grammar ("S-JSON"). The fork's four membership tests: portable to every host, shape only, same meaning in every slot, needed without a schema. Leaving a spelling out costs little (a slot reads it); putting one in wrongly costs a silent misreading. Two side effects:

- JSON's grammar forbids leading zeros, so `01234` and `007` stay unclassified with no extra rule.
- Every classified number is a valid JSON number token, so lite → JSON copies it byte for byte.

What no spelling rule can protect: `1.10`, `1234567` and `1e10` used as identifiers. The cure is a slot type, or the writer's quotes. *(fork's; checked against my own instincts: I'd write all three bare and mean text.)*

**Units (DP2/DP9): not a parser class.** A quantity class degrades to "a number followed by letters": `10am`, `3rd`, and `0xff` read as 0 plus the unit `xff`. *(fork's; the `0xff` case checked by reading the classifier.)* The slots fork found why units felt like "both slot type and literal hint": the symbol on the literal is a partial claim, the slot's dimension completes it. `:timeout 5m` is minutes and `:length 5m` is meters; neither half decides alone. Lite keeps the spelling.

## 4. `<…>` (DP4/DP5): closed when unlabeled, open when labeled

**fork's (angle), ANG-4c, 1250 of 1660; next ANG-4o 1117, ANG-3 1083.** `<…>` has been asked to do seven jobs: assert, self-end, carry, name, compose, be nil, quote. One unlabeled bracket can't both reject (`<920px>` an error, his 10-21 words) and carry (`<2026-10-01>` raw). Labels resolve it:

- unlabeled `<…>` is the standard set, asserted, or an error that suggests a fix;
- `<>` is nil;
- `<name[key].trait: body>` is a notation whose body is carried raw for whatever reads `name`.

**checked:** lite already does this at block size. The default fence handler carries any fence name's body unread and reads its head strictly ([[rule:fence-default-handler]]).

**My reconciliation with Cc (judgment).** Under Cc there is no separate number kind; a value is its spelling plus its class. So `<8080>` should give the same tree as bare `8080` (text `8080`, class integer), with the angle form in «meta» and an assertion that held. `<8080x>` is an error. `<…>` adds a check and a self-ending boundary, never a different kind. This matches his "`<"asdf">` ≡ `"asdf"`" collapse in the logical tree. The angle fork drew its bare lines under the view; under Cc nothing in its `<…>` lines changes.

**Dates default to bare text.** A slot or schema reads them. `<date: 2026-07-21>` is for an author who wants to say so in the document, and `<2026-07-21>` is an error suggesting both. *(fork's; my instinct agrees: unprompted I'd write a date bare, and my strongest prior for `<…>` is a placeholder or an HTML tag, which makes "closed, with a teaching error" the safe direction.)*

**The rival: a notation as an element (wildcard W1, `:when |{date 2026-07-21}`).** It is alive but second in value position, for two reasons:

- **checked:** its own tree draws the value as a piece inside a text (`:timeout ‹|{dur ‹30s›}›`), so it needs a reading option to become a value.
- **checked against [[rule:element-after-attribute-with-no-value]]:** the brace-less form silently takes the rest of the line (`:started |datetime … :timeout 30s` makes `timeout` the datetime's attribute).

Its real strength, typed values inside prose (`Doors open at |{time 19:30}`), costs nothing under any branch: inline elements in prose already exist. The choice between them is Joseph's question: **is a date a leaf or a node?** ANG-4c says leaf, W1 says node. *(Judgment: leaf. A date is a value; a node invites a JSON object where a string belongs.)*

## 5. Slots and the colon (DP6/DP7)

**fork's (slots), with the colon trap checked:**

- **S0, slot types outside the document (8.4):** a schema, the `name.schema.udon` convention, vocabularies.
- **`:name:type` dies** on XML names (`xml:lang`, `xlink:href`).
- **`:name<type>` collides with nothing** and is already an error under the label lean, so headroom costs nothing.
- **Slot types as traits (`:port.u16`) die:** stacking gives one slot two types, so a per-occurrence type is just an annotation (wildcard W2).
- **The trap.** Under the label lean (`:` allowed "inner and last", **checked**), `:host: localhost` is an attribute named `host:` today. **`:` should never end a bare label**, whatever is decided about the ornament. The ornamental trailing colon is then optional (T2, slight lean) or absent (T1); they tie. A compulsory colon is pruned.
- **Visual hazard (judgment):** `:port<u16> 8080` (a reserved slot annotation) and `:port <u16: 8080>` (a notation) differ by one space. That is acceptable only while the first is an error with a "did you mean" message.

## 6. The one question two forks answered without asking

**Is a refinement a change?** Both leading designs claim forward stability on the same unstated premise:

- The classification fork says Cc can add a class later "without changing any accepted tree: the text is the same and an attachment is added".
- The angle fork's labeled notations carry a body a later version may read.

Each is stable only if a later version **adding** information to an accepted tree (a class where there was none, a reading of a carried body) is not a "change" under reserve-don't-ignore (B2, a veto).

- **If refinement is not a change:** Cc can grow, ANG-4c can carry, and "no class" must be specified as *unclassified by this version*, never as *known not to be a number*.
- **If it is a change:** lite 0.1 is C0-or-Cc-frozen with ANG-3 (closed `<…>`, no notations), and each widening is a later decision.
- **The evidence already in the cards (checked):** fences carry named bodies that later handlers read. Lite has accepted "refinement is not a change" once, for fences.

*(Judgment: this question decides more than any single branch, and it is Joseph's.)*

## 7. The lead composition (judgment, from the forks' leaders)

1. A bare run is a «text». When the whole plain run spells nil, true, false or a JSON number, the parser attaches that class, normatively, at the run's close (Cc + S-JSON + F1).
2. A quoted value is a «string», exactly those characters, never classified (wildcard W3's "closed" rung).
3. `<…>` unlabeled asserts a standard-set value (same tree as bare, with the form in «meta») or is an error with a suggestion. `<>` is nil. `<name…: body>` carries a notation, or is reserved in 0.1 if refinement counts as change (ANG-4c / ANG-3).
4. Slot types, aliases, units' meaning, coercion and display live in the reader's layer. Lite keeps spelling, form, address and order, and states "lite records, readers mean" as an invariant (S0, R1–R7).
5. `:` never ends a bare label; an ornamental trailing colon is optional (T2), pending his call. `:name<…>` stays an error.

**What it changes on the cards** (from the forks' impact pages):

- [[rule:unquoted-run-is-one-value]] (lean): the view becomes the normative class.
- [[rule:opaque-span-raw-text]] (provisional): `<…>` leaves the opaque-span family.
- [[def:typed-value]], [[def:value]], [[def:opaque-span]] (provisional).
- [[def:label]] / the label lean: `:` never last.
- [[rule:main-label-colon-warns]]: its suggestion can be `:host: localhost` under T2.
- New: the S-JSON card (the `rule:bare-typing` gap), the `<…>` table, an invariants card, `<>` as nil.
- Unchanged in Statement: [[rule:nil-spelling]] and [[rule:missing-value]] (fork's).

**Open edges I know of:**

- `<>` under identity by spelling. nil's spelling is `nil`; `<>` has none. Either the tree has a spelling-less nil with its form in «meta», or `<>` reads as `<nil>`.
- Whether prose is ever classified. The classification fork's reading is never, which the cards imply but don't say.
- Keys and list items classified like values (`|step[3]` → text `3`, class integer). Consistent, and a slot can type `$key`.
- The angle fork's letter-led interior is decided at its label's end. That is token-bounded like every element name; it needs his acceptance.

## 8. Dead branches and why

| Branch | Fork | Why it died |
|---|---|---|
| The view with its default left open | classification | not a design: consumers disagree (B3, C7) |
| The old line's whole set, kind first | classification | edges grow with the set; each is a stability liability; a slot reads them better |
| Quantity as a parser class | classification | degrades to "number + letters" (`10am`, `3rd`, `0xff`) |
| REBOL-maximal lexical types | wildcard | stability, spec clarity, no host equivalents |
| Slot types as attribute traits `:port.u16` | wildcard | stacking gives one slot two types |
| `:name:type` | slots | XML names (`xml:lang`) |
| Compulsory trailing colon | slots | changes every attribute; matches no common notation |
| Aliases declared in a lite document | slots | lite has no declarations |
| KDL-style `(dt)value` | angle | changes existing text values |
| Suffix labels, space separator, bare colon, pipe | angle | decide late / `<today>` empty body / `<https://x>` / second role for `\|` |
| Unicode or doubled brackets | angle | add characters without adding a job |
| Raw box (the card today) | angle | dominated; under bare-is-text it can't hold a number |
| Standard set else raw | angle | can't reject `<920px>`; unstable boundary |
