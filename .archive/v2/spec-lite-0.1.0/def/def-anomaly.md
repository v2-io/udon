---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: true
strength: provisional
terms: [anomaly, error, warning]
per: [errors-stop-parsing, reserved-is-an-error]
depends: [def:document]
consequences: [rule:no-break-space-counts-as-space, rule:column-shifting-whitespace-error, rule:unclosed-delimiter-is-error]
---

# anomaly · error · warning

*An «error» stops parsing: there is no «tree». A «warning» marks correct lite that may not do what was meant: the «tree» is produced and carries it.*

## Terms

- **anomaly:** an «error» or a «warning» a parser reports, with where it is.
- **error:** something a lite «document» may not contain. Parsing stops, the parser reports what it found and where, and no «tree» is produced. A «document» with no «error» is valid lite.
- **warning:** something that "*is* technically correct udon/udon-lite and does do a specific thing-- but possibly not what you intended it to do" (Joseph). The «tree» is produced; the «warning» travels with it.
- **default-on / default-off:** every «warning» is one or the other; a parser reports default-on warnings unless turned off, and default-off warnings only when turned on ([[rule:warnings-can-be-toggled]]; Joseph, 2026-10-20).

## Invariants

- An «error» and a «tree» never come together.
- A «warning» never makes a «document» invalid.
- "Error" here means *not lite*, not mainline UDON's "something was lost".

## Avoid

"Joseph" marks his own words; everything else is an agent's or a spec draft's.

**For «error»:**
- **error = something was lost** — Joseph, 2026-07-18, for mainline UDON: "I think warning ~= content preserved, but possibly not what was expected or desirable for the future / error ~= something was lost." (`history.jsonl` L16612); ruled into the 0.9 CHANGELOG as "Warning = content kept; Error = something lost", and into 0.10.0 §14.1 as "Error = loss". Lite's «error» means *stop*: "Disallowed == error == stop/fail" (2026-10-08).
- **non-halting error, error + nil, "recognition continues"** — 0.10.0 §14.1 ("An Error MUST NOT halt recognition"), and the `MissingAttributeValue` "Error + synthesized Nil" (Joseph, 2026-07-16: "I would vote that the error in R2 would still emit the value with a nil", L16387). In lite an «error» gives no «tree», so nothing gets a nil.
- **incomplete-input (a separate result)** — 0.10.0 §13.3. In lite it folds into «error» (Joseph, 2026-10-08: "#3 … being part of #1").
- **`$partial-key`, keep-everything, "the keep shape"** — 0.10.0 §14.2. Lite keeps nothing from a document with an «error».
- **refusal, "reports that the spelling is reserved and keeps the bytes"** — the 2026-09-29 agent wording in [[decision:reserve-not-ignore]], replaced by [[decision:reserved-is-an-error]].
- **verdict** — grok, 2026-07-21 (`udon-needs/pipeline-discussion.md`): "schema compliance, dialect-check failure, and incomplete-input are all verdicts".

**For «warning»:**
- **warn and keep as text / warn-before-disallow** — 0.9 and 0.10.0 used a warning to hold syntax open for later meaning (K8, S2: "undefined-but-we'll-warn-before-disallowing"). Lite uses «error» (a reserved construction) for that job ([[rule:nested-attributes]]). A lite «warning» commits to a reading.
- **advisory** — 0.10.0 Appendix B's third level (`EscapeOutsideHeadPosition`, `CommentMissingFollowingSpace`, "host style advisory, optional"). Lite has two levels.
- **warning codes as names** (`AttributeAfterChildren`, `InconsistentIndentation`, `NoTabs`, `UnclosedFreeform`, `MissingAttributeValue`…) — 0.9/0.10.0 working names; several name rules lite changed. Lite's codes are placeholders until [[view:anomalies]] names them.

**For «anomaly»:**
- **anomaly ladder, anomaly posture** — 0.9 CORE's "Anomaly posture" table and 0.10.0 §14.2 "response ladder (a) warn-and-keep … (e) reject", from Joseph's 2026-07-15 S10 list (L16365). That ladder belonged to consumers; lite has two outcomes.
- **miss** — 0.10.1 draft ("`NoDialectsLoaded` (anomaly) | a **miss**").

## Working notes

- **Not reviewed with Joseph.** Joseph, 2026-10-09: "I haven't looked at any or been asked about any of those things … but the idea that they can just kind of organically be whatever would cause serious trouble really soon if allowed to continue." Every term here is provisional until he rules on it; `.int/lexicon-inventory-2026-10-09.md` lists where each came from.
- **Joseph's words** (2026-10-08, `.int/STEWARD-VERBATIM.md`):
  > My current lean is that any *error* right now is a failure / stop. … Disallowed == error == stop/fail. In some ways it will be treated more like a standard programming language, where something missing a closing delimiter is just a straight-up error and halt and you've done something wrong. Whereas *warnings* are for "this *is* technically correct udon/udon-lite and does do a specific thing-- but possibly not what you intended it to do..."
- **"error" and "warning" are Joseph's words and look settled** (lexicon inventory: "Terms that look settled"). The open naming work is (a) «anomaly», and (b) making sure "error" can't be read in its 0.9/0.10 sense, which is listed under Avoid.

### anomaly

- **Not Joseph's word.** I found no place where Joseph typed "anomaly" about UDON. My regex over his prompts in `~/.claude/history.jsonl` (udon, libudon, descent and v2 projects) and `memorata-search --joseph "anomaly"` returned only agent text he had pasted or relayed (for example the grok review in L16611) and unrelated uses. It comes from 0.9 CORE's "Anomaly posture" (agent-written, 2026-07) and 0.10.0's "Anomaly — a Warning or Error attached to recognition". His own vocabulary: "error", "warning", "fail", "halt", "stop", "disallowed", "not supported", "reserved", and once "linter (including hinter)" (2026-07-08, L15379, a CTQ list).
- **What the word invites.** "Anomaly" means an irregularity: something unusual, not necessarily wrong. That fits a «warning» well and an «error» badly. An agent reading "the parser reports an anomaly" may not expect parsing to have stopped. It is also unusual in this role: IEEE 1044 uses "anomaly" as an umbrella for software defects and incidents, but compilers and editors say "diagnostic".
- **Precedents for the umbrella:**
  - Clang, GCC and rustc call every report a "diagnostic", with levels: error and warning, plus note and help in rustc.
  - The Language Server Protocol's `Diagnostic` has severities Error, Warning, Information and Hint.
  - rustc "lints" are warnings with configurable levels (allow, warn, deny, forbid).
  - VS Code shows "Problems".
  - XML 1.0 has no umbrella. It defines "error" ("A violation of the rules of this specification; results are undefined") and "fatal error" ("An error which a conforming XML processor MUST detect and report to the application"), and says "Violations of well-formedness constraints are fatal errors".
- **Does lite need an umbrella term at all?** Errors and warnings now differ in kind: one ends the parse, the other travels with the «tree». The umbrella is used in three places: [[view:anomalies]] ("Every error and warning"), the fixtures' `anomalies:` field, and this card. "Errors and warnings" in plain words would cover all three.
- **My lean (this agent's):** drop «anomaly» as a term. Say "errors and warnings" where both are meant, and if a single noun is wanted (a field name, a view title), use "diagnostic", the word compilers, editors and the LSP already use. I hold this weakly; Joseph has never been asked.

### error

- **Precedent: XML's "fatal error" is lite's «error».** XML's fatal error must be detected and reported, and normal processing stops. XML's plain "error" (results undefined, recoverable) has no lite equivalent. And XML's *well-formed* (no fatal errors) is what this card calls "valid lite". XML's *valid* means conforming to a DTD or schema, a separate later check.
- **A collision to weigh:** "valid lite" in this card and in [[rule:valid-lite]]. To an XML-fluent reader, "valid" suggests schema conformance, which lite leaves to schemas. "Well-formed lite" would match XML's sense; "conforming" is another option. (Raised, not proposed.)
- **HTML's "parse error" is the opposite case:** "This specification defines the parsing rules for HTML documents, whether they are syntactically correct or not", with "well-defined" error handling, so a parse error there does not stop the parse. An HTML-minded reader may expect "error" to be recoverable.
- **Two kinds of error, one word?** Joseph wants a reserved-construction error's message to say "'**lite** doesn't support newlines in ....' so that it doesn't get accidentally adopted in non-lite settings as a prohibition" (2026-10-08), and the missing-value message to say "implicit missing value for attribute is not supported / reserved" (2026-10-09). An unclosed delimiter, by contrast, is "you've done something wrong". *Reading (mine):* his messages separate *not lite (yet)* from *malformed*. Whether the spec needs a word for each kind (say, "reserved" for the first, defined in [[def:reserved]]) or only the messages differ is open.
- **Open:** whether a parser reports only the first «error» or keeps scanning to report more, still producing no «tree» ([[decision:errors-stop-parsing]], working notes).

### warning

- **"The «tree» … carries it."** Is a «warning» *in* the «tree» (as «meta» on a node, say), or reported beside it? The cards' fixtures put warnings in a separate `anomalies:` list next to `tree:`. The Terms line above says "travels with". The «tree» and «meta» owner (slice D) may want to state which.
- **The word itself is Joseph's,** used consistently, and matches every precedent (compilers, LSP, linters). Nothing to avoid beyond the 0.9/0.10 senses listed above.

### Coordinator's lean (Opus 5.5, 2026-10-09; my opinion for Joseph, not a lean of his)

- **Drop «anomaly».** It isn't his word, and an "irregularity" sounds non-fatal, which an «error» is not. Say "errors and warnings" in prose; for the fixture field and the view, "diagnostics" (the compiler/LSP word) if one noun is needed.
- **"Valid lite":** I'd ask once. "Well-formed" is XML's word for exactly this (no fatal errors), and "valid" there means schema conformance, which lite leaves to schemas. Weak lean "well-formed".
- Warnings travel beside the AST (the fixtures' separate list), not inside it; the card should say so.
