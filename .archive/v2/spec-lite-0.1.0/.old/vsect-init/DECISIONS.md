# DECISIONS — present-truth ledger for spec-lite-0.1.0

**Proposed seed (2026-09-30), not yet adopted.** Every entry below is carried from `influx/README.md` §"Decided so far (Joseph, 2026-09-29)". That README is a coordinator's rendering of the session, so every *Holds* line here is a rendering too, and no entry has been re-read with Joseph. Adopt, amend, or discard the whole file.

**Rules for this ledger:**

- One entry per decision. Append a new entry or expressly overturn an old one; never silently rewrite. Lower entries supersede earlier ones.
- Rules, fixtures, and other records cite entries by their heading key, e.g. `per: [implied-root]`.
- **Reasoning and assumptions are required sections**, because they are what a later reopen has to check. If the source records none, the section says *not recorded*. It is never filled with a plausible reason after the fact: a reason reconstructed later reads exactly like one given at the time, and that is how interpretations become law.
- Anything an agent infers (an assumption, a reading) is marked as inferred and unconfirmed until Joseph confirms it.

**Conflict protocol** (carried from `v2/DECISIONS.md`'s note on the K-rows). When an entry conflicts with anything else, do not settle it by weighing entry against entry. The conflict means an interpretation has become load-bearing. Go back to Joseph: "when you said X, were you also implying Y?"

**Entry template:**

```markdown
## key

- **Holds:** what is decided, stated as narrowly as the record supports
- **Quote:** Joseph's verbatim words, when located (otherwise: not located)
- **Wording:** verbatim | rendering (whose words Holds is in)
- **Reasoning:** why, as recorded (otherwise: not recorded)
- **Assumptions:** what must stay true for this to stay right; each marked as recorded, or inferred (unconfirmed)
- **Alternatives set aside:** with why, if recorded
- **Decided-by / date / source:** decided-by vocabulary below
- **Open:** parts deliberately not decided, by pre-design question number
- **Reopen when:** the condition that reopens it, if known

### Working notes
```

**Decided-by vocabulary** (verisectorium template / references DECISIONS):

- `steward`: the steward made the call; an agent or council ratified it
- `ratified`: an agent made the call; the steward ratified it
- `council`: an agent's call after red-teaming and unified validation from other agents
- `supported`: an agent's call with provisional steward or council support; easier to revisit
- `defacto`: "decided" without really being decided; recorded so the record exists
- `proposed`: from the steward or any agent; not blocking anything yet
- `transition`: rejected but still existing somewhere; defacto-but-being-fixed

---

## reserve-not-ignore

- **Holds:** A lite parser recognizes future syntax just well enough to refuse it, keeping the bytes; it never reads future syntax as ordinary text. Any document a lite parser accepts produces the same tree under every future full version.
- **Quote:** not located.
- **Wording:** rendering.
- **Reasoning** (as recorded in the README): "Authors can't accidentally write something that changes meaning later." Behind it, lite itself exists because "the corpus already needs a basic, stable UDON *now* … The parts of the language that point elsewhere or run later (`!`, `@`, interpolation) are still being designed."
- **Assumptions:**
  - (inferred, unconfirmed) The future full language will not give new meaning to spellings lite reads as plain text. Or, if it might, lite reserves them now. 09 Q1 and 84 show how much this one assumption carries, e.g. for `@name` in prose.
  - (inferred, unconfirmed) Refusing is acceptable to authors: a document containing a reserved spelling is not valid lite, rather than "valid, with a warning".
- **Alternatives set aside:** *ignore* (read future syntax as text) is implied by the name; its reason is the Reasoning above.
- **Decided-by / date / source:** steward · 2026-09-29 · `influx/README.md`
- **Open:** 09, 12, 84, 87
- **Reopen when:** not recorded.

### Working notes

- The second assumption depends on 12 Q1 (what "accepts" means). If warnings count as accepted, every warning's keep-shape becomes part of this promise.

## inline-elements-in

- **Holds:** Inline elements `|{…}` are in lite.
- **Quote:** not located.
- **Wording:** rendering.
- **Reasoning** (as recorded): essential for the XML/HTML use case.
- **Assumptions:**
  - (inferred, unconfirmed) XML/HTML-style mixed content (text interleaved with elements on one line) is a first-class lite use, not an edge case.
- **Alternatives set aside:** not recorded.
- **Decided-by / date / source:** steward · 2026-09-29 · `influx/README.md`
- **Open:** 10, 50, 51
- **Reopen when:** not recorded.

### Working notes

## explicit-typed-value-in

- **Holds:** `<…>` is in lite. The parser finds where it ends and carries its text and optional type label, attaching no meaning. Dates, times, and durations are not typed in lite.
- **Quote:** not located.
- **Wording:** rendering.
- **Reasoning:** not recorded. The README adds that "the existing temporal parser may be reattached at implementation time", which is a plan, not a reason.
- **Assumptions:**
  - (inferred, unconfirmed) Carrying the text without meaning is forward-stable: a later dialect can give it meaning without changing the tree lite produced.
- **Alternatives set aside:** not recorded. 07's discussion file has the history.
- **Decided-by / date / source:** steward · 2026-09-29 · `influx/README.md`
- **Open:** 07, 89
- **Reopen when:** not recorded.

### Working notes

- The inferred assumption is itself a claim to check: if the tree carries `<…>` as one raw string (07 Q3 option A), a later split into label and body changes the tree. That would be a forward-stability question for `prop-forward-stability`.

## suffixes-lose-special-status

- **Holds:** The suffix characters `? ! * +` lose their special status on elements.
- **Quote:** not located.
- **Wording:** rendering.
- **Reasoning:** not recorded.
- **Assumptions** (recorded): Joseph recalls that the intent was to make them ordinary identity characters; the README marks this "to be confirmed".
- **Alternatives set aside:** 06 lists keeping the sugar (A), ordinary name characters (B), and reserving them (C); none was recorded as set aside.
- **Decided-by / date / source:** steward · 2026-09-29 · `influx/README.md`
- **Open:** 06
- **Reopen when:** the history pass does not confirm the recollection.

### Working notes

## ast-centric

- **Holds:** Lite is specified as the tree it produces, not as an event stream.
- **Quote:** not located.
- **Wording:** rendering.
- **Reasoning:** not recorded.
- **Assumptions:** not recorded.
- **Alternatives set aside:** an event-stream (wire) specification, implied. The history is in 13's discussion file.
- **Decided-by / date / source:** steward · 2026-09-29 · `influx/README.md`
- **Open:** 13, 60
- **Reopen when:** not recorded.

### Working notes

## implied-root

- **Holds:** Every document has one implied root node, and everything starts as its children. The root may carry metadata such as the filename.
- **Quote:** not located.
- **Wording:** rendering.
- **Reasoning:** not recorded.
- **Assumptions:** not recorded.
- **Alternatives set aside:** "no implicit root wrapper" (Dec 2025 – Jul 2026; `design/udon-ast.md`), held then for streaming, fragments, and multi-root. The 70-survey index says the new decision "answers" those reasons; that is the survey agent's reading, not a recorded reason.
- **Decided-by / date / source:** steward · 2026-09-29 · `influx/README.md`
- **Open:** 04, 13, 84, 89
- **Reopen when:** not recorded.

### Working notes

- Append-safety (68) relies on this decision together with the fact that no spelled root is ever required.

## references-vocabulary

- **Holds:** Lite uses the addressing theory's vocabulary (`../references/def/`) wherever it applies (lite has no addressing, so only part of it does). Lite's own definitions will live in `lexicon.md`, not yet written. The lite term for an `<…>` or bare value is `typed value` (explicit / implicit).
- **Quote:** not located.
- **Wording:** rendering.
- **Reasoning:** not recorded.
- **Assumptions:** not recorded.
- **Alternatives set aside:** not recorded.
- **Decided-by / date / source:** steward · 2026-09-29 · `influx/README.md`
- **Open:** where lite's own definitions live. The README says `lexicon.md`; the 2026-09-30 directory layout has `def/`, and the samples follow `def/`.
- **Reopen when:** not recorded.

### Working notes

## no-bespoke-parser

- **Holds:** No bespoke lite parser is needed; the mainline recursive-descent grammar (descent) is the implementation route.
- **Quote:** not located.
- **Wording:** rendering.
- **Reasoning** (as recorded): earlier throwaway Python parsers couldn't track the nuance.
- **Assumptions:**
  - (inferred, unconfirmed) The mainline grammar can be configured to refuse reserved spellings without forking.
- **Alternatives set aside:** tiny standalone parsers (`v2/INBOX-REQUESTS.md`, 2026-08-30), implied.
- **Decided-by / date / source:** steward · 2026-09-29 · `influx/README.md`
- **Open:** none recorded.
- **Reopen when:** not recorded.

### Working notes
