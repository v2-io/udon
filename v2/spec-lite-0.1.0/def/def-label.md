---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: false
terms: [label]
per: [suffixes-lose-special-status]
depends: [def:element-name, def:attribute-name, def:trait, def:quoted-name]
consequences: [def:element-name, def:attribute-name, def:trait, def:quoted-name, def:fence-tag]
---

# label

*A «label» is a name spelled by the rules lite gives for writing identifying names, bare or in quotes. «element-name»s, «attribute-name»s and «trait»s are labels. The word says how a name is spelled, never what it does. Which other names are labels, and whether all labels share one character set, is open.*

## Terms

- **label:** a name spelled by the label rules, the rules lite gives for writing an identifying name, bare or in quotes ([[def:quoted-name]]). An «element-name», an «attribute-name» and a «trait» are labels. A name's role has its own term; "label" says only that it is spelled by these rules.

## Invariants

- "Label" is about spelling. The «tree» holds element names, attribute names and traits; "label" is not a fourth kind of thing in it.

## Examples

```udon
|user[jw].admin :role editor
  ```sh
  make
  ```
```

`user` (an «element-name»), `admin` (a «trait») and `role` (an «attribute-name») are labels. `jw` is a «key», which lite reads as a value ([[rule:key-holds-a-value]]), so it is not a label by these rules even though it looks like one. `sh` is the fence's name, so it is a label too ([[rule:fence-opener-line]], 2026-10-12).

## Avoid

- **"label" for an attribute, or for an attribute's name.** The sense lite's cards and outline used until 2026-10-09 ("The next value on the line goes to the label that has none yet", "What a label written more than once gives", "Values written on the lines under a label", "An element name or attribute label written in quotes"; card slugs `rule-waiting-label`, `rule-label-after-empty-label`, `rule-element-after-waiting-label`, `rule-repeated-labels`, `rule-quoted-names-and-labels`). It came from 0.10.0's `GLOSSARY.md` (agents, 2026-08-09): "**label** = an assignment's name-side (`:label value`)", one leg of a "three-way name split" (key / label / kind). Joseph has used the word this way himself (below), and still writes `:label` as a placeholder for "an attribute". Use «attribute» and «attribute-name».
- **"label" for a fence's tag** (`sh` in ```` ```sh ````). 0.9.1 CORE §10 and `GLOSSARY.md` ("info label"; "**Label** — a verbatim form's optional tag"); lite's fence cards since 2026-10-08. Whether the tag is a label is the open question in [[def:fence-tag]]; calling it "the fence's label" answers it by default.
- **"label" for a typed value's type** (`u64` in `<u64:0xff>`). 0.9.1 CORE §11.6 ("type-labelled", "Label ladder"); [[def:typed-value]]'s «type-label». Lite carries `<…>`'s text whole and never splits a type from it ([[rule:opaque-span-raw-text]]), so lite never reads `u64` as anything.
- **"label" for a value.** 2011 `udon-c/docs/DECIDED.md`: "all ':' attributes are "simple" - label for key & label for value". The 2011 class included unquoted simple values; lite's values follow value rules, not label rules.
- **"the label that owns the line"**: an agent's phrase (2026-09-30) that Joseph flagged as ambiguous "exactly where the lean is weighing in".
- **"label" for an edge of a scope graph.** The addressing theory's sense (`v2/references/def/def-scope.ud`: "labeled **EDGES**", "the universal edge label is **CONTAINMENT**"). A separate sense in a neighboring store; lite has no addressing, so the two don't meet yet.
- **"LABEL" as a state-machine character class** (`LABEL_CONT`, "element name (LABEL)", in a 2025-12-26 agent sketch of the old `udon.machine`). The same lexical idea, in implementation dress.

## Working notes

- **Not reviewed with Joseph.** This card states his 2026-10-09 preference as the draft definition. What it covers ("etc.") and whether it is one rule or several are not decided.

- **His words, 2026-10-09** (`.int/STEWARD-VERBATIM.md`; `history.jsonl` L22059):

  > the first item tells me we still don't even have a nailed down lexicon, as you are referring to 'label' which I prefer to use as the rules for how identifying labels are put together (the node-name, the attribute-name, a trait-name, etc.---  all "labels" lexically).

  > Again I keep seeing you use "label" when you mean "attribute" or if you're being more specific "the attribute's name's label construct"

  *Reading, not his words:* "label" here names both the rules ("the rules for how identifying labels are put together") and each name they produce ("all 'labels' lexically"). "The attribute's name's label construct" reads as: the attribute has a name, and that name is built by the label construct. Both fit the draft above.

- **His earlier uses, oldest first.** Two senses run through them: **(L)** the lexical class, and **(A)** the attribute or its name. *The sorting into L and A is my reading.*
  - **2011-12-15, L.** `udon-c/docs/DECIDED.md` (his commit `ecfaa4a`): "LABEL: (Restricted-non-delimited) – APPLIES TO: node-name, class-name, attribute-key – STOPS ON: whitespace or [|\[.!]". The same three members as his 2026-10-09 list (node-name, attribute-name, trait-name), fifteen years earlier. The same file: "':' allowed in labels (so allowed in attribute keys and node names, etc.)"; "PROTECTED/SHIELDED: [parentheses]-delimited label or value" (a 2011 quoted-name form); "if you want an attribute starting with a colon (ala ruby labels)". The same day he removed an older LABELS section ("removed outdated def. of labels", `2a32fae`).
  - **2025-12-28, tag.** `history.jsonl` L6058: "`!:label` is what I was thinking initially, but I think I'm going to land on `!:json: …` … (which would emit the raw label/namespace)". The verbatim block's tag.
  - **2025-12-31, L.** L6466: "XID, XID+underscore (what we call label I think) are unicode standards that you can use".
  - **2026-07-14, L.** L16198: "the unicode identifier and label nuances"; "what constitutes an identifier or label and what keeps you in structured-land vs prose-land".
  - **2026-07-15, A (semantic).** L16325: "They are labeled, where the label is the parent's perspective, not the child's perspective. That label is conserved in the sense that the parent just has one of each, and its values accumulate". This is a meaning-level use: the label is the attribute's name *as the parent's word for the value*. It is the use 0.10.0's "three-way name split" built on.
  - **2026-07-15, L.** L16327: "expanding the characters that are allowed as part of a label/identity"; L16328: "freed up '?!*+' etc. in trait labels (and I think attribute identifiers without needing quotes?)".
  - **2026-08-09, A and L.** L18884: "complicate the attribute-label / values rhythm"; "(if not starting/ending/within a single-quoted label)". L18898: "You really need to stop calling attribute labels keys though don't you?"
  - **2026-10-08, A, L and tag.** "a label with no value"; "special constructs for labels, e.g. `|'something "hey"\'' weird node name`" (a quoted *element* name, so L); "Agree no backticks on the fence's label" (the agent's message just before is summarized in the verbatim file as calling the tag "a separate raw label"); ":label-under-open-attribute".
  - **2026-10-09, A and L.** "we have reserved nested attribute-labels"; "top-level :labels" (with ":attributes" in the same message); the lexical-class statement above.

  *Reading:* his stated preference is L, and L is also his oldest written sense. A appears mostly as a placeholder spelling (`:label`) and as a compound ("attribute-label"); the one place A carries meaning is 2026-07-15, where "label" is the parent's word for the value. An agent reading his examples will keep meeting `:label value`, so spec text and examples may want `:name value` or `:attr value` as the placeholder.

- **Agents' leans.** 0.10.0's glossary (agents, 2026-08-09) split names three ways: key (`[k]`), label (attribute name), kind (verbatim tag), and retired "label (verbatim/fence tag)" for "kind". 0.9.1 (agents, 2026-07-22) used "label" for the verbatim tag and for typed-value types, and "key" for attribute names. The coordinator's reading, 2026-10-09: "attribute" names the role while "label" names the shared spelling rules. [[def:typed-value]] already tells readers to avoid "label" alone for `u64`.

- **Which names are labels?** His list ends in "etc.". Each candidate:

  | Name | Label? | What decides it |
  |---|---|---|
  | element name, `\|user` | yes (his list) | |
  | attribute name, `:role` | yes (his list) | |
  | trait, `.admin` | yes (his list; "Traits are names", 2026-10-09) | |
  | quoted name, `\|'weird name'` | probably: he called it a "special construct for labels" (2026-10-08) | *reading* |
  | key, `[jw]` | no, by [[rule:key-holds-a-value]]: `[1]` is an integer, `["01"]` a string, `[one two]` a text | unless keys get their own name rules |
  | fence tag, ```` ```sh ```` | open: the rest of the opening line, so `rust ignore` (with a space) would be one tag | [[def:fence-tag]] |
  | `u64` in `<u64:0xff>` | lite never reads it ([[rule:opaque-span-raw-text]]) | C's slice, [[def:typed-value]] |
  | the name after a reserved `@` or `!` | lite must recognize "`@` followed by a name" and "`!` followed by a word" to refuse them ([[rule:prose-line-start-reserved]], [[rule:reserved-spellings]]); what counts as that name is unsaid | probably the label rules, or the future reference and generator name rules |
  | `$key`, `$traits`, `$main` | attribute names, so labels; is `$` a label character in lite? (pre-design 58 Q2) | |

- **One rule, or a family?** 0.10.0 had three character sets: element names `XID_Start` then `XID_Continue`, `-`, `/` (narrow); traits the same plus `? ! * +`; attribute names almost anything but space (K12, wide). His K12 words (2026-08-09): "attribute identities get [identifiers] that are a lot more expressive than some other identifiers". His 2026-10-09 words: "all 'labels' lexically" and, under things still to discuss, "suffix characters (actually, labels generally)" and "discussion of what characters are allowed in labels needs to decide this when we have it". These can be read as (i) one shared rule for every label (pre-design 76's option C), or (ii) a family of rules with per-kind character sets that share quoting and the word. *Not resolved; he may not have meant either.* The suffix decision ([[decision:suffixes-lose-special-status]], pre-design 06) and pre-design 76 feed it.

- **Precedents.**
  - **Ruby**, whose lexer calls `name:` a **label**: `Ripper.lex("f(a: 1)")` gives `[:on_label, "a:"]` (checked 2026-10-09 with the local `ruby`). Ruby's label is a token class, and it sits exactly where UDON's attribute name sits (`name:` before a value). His 2011 "ala ruby labels" points here. It supports both senses at once.
  - **XML 1.0** has one production, `Name`, for element type names, attribute names, processing-instruction targets and entity names: one lexical class shared by several kinds of name, with the kinds named separately. That is the L reading's shape. (From memory, not re-checked.)
  - **Lexer vocabulary** usually calls this class **identifier** (C, Java, CSS's `ident-token`, Python's `NAME`). In programming languages "label" usually means a jump target (C `done:`, assembly) or a record field's name (OCaml/SML record labels, OCaml labelled arguments `~label:`); the second is the attribute-name sense.
  - **Property graphs** (Neo4j/openCypher, `(n:Person:Admin)`): node "labels" classify a node, the role «trait» has.
  - **Everyday and HTML usage:** a label is a caption or tag stuck on something: HTML's `<label>` element, ARIA's `aria-label`, Graphviz's `label`, Kubernetes labels, his own "epistemic labels" (2026-07) and "labels/tags" (2026-10-09, another project).

- **What the word invites, and collisions.**
  - **To an agent reading without syntax highlighting**, "the label of X" reads as "X's caption" or "X's name". The lexical sense has to be taught; the English word doesn't carry it. That is why agents drifted into the A sense.
  - **In documents lite exists to represent**, "label" is content: `|label :for email` and `:aria-label Site` (the second is in [[rule:framed-backslash-frame]]). Sentences such as "the label `label`" or "aria-label's label" become possible.
  - **Rules, class, or token?** Spec text may want "the label rules" for the rules and "a label" for a name they produce.
  - **What type is a label in the «tree»?** A trait is "a name, not text" (Joseph, 2026-10-09). If labels are only lexical, the tree still needs to say what `$traits` holds: a «string»? a name? See [[def:trait]].
  - **"Identifier" and "identity".** He uses "identifier", "identity character" and "label" close together (2026-07-12 "allowed identifier characters"; 2026-09-29 "allowed identity character"; 2026-07-14 "identifier or label"). "Identity" was also an old name for `[key]` (0.9.1 "Identity `[key]`"), and in 2011 `syntax2.udon` for an element's namespace plus name.

- **Candidate words for the class**, if he wants to reconsider:
  - **label**: his, oldest (2011), Ruby's token name. Collides with the A habit and with "label" as content in HTML.
  - **identifier**: conventional in lexers. Drags "identity", an old name for the key.
  - **name**: plain. Collides with the addressing theory's name (a token bound by a binding, [[references/def:binding]]) and with each role's "X name".
  - **word**: Rebol's analog (`word!`). Collides with "`!` followed by a word" in the reserved-spelling cards.
  - **token**: generic, and means something else to every parser author.

- **My own opinion** (the drafting agent's, not a lean of Joseph's): keep "label" in his L sense. Its roots in his own 2011 notes and in Ruby's lexer are real, and every alternative collides with something worse. Let it name spelling only: in spec text, "label" never stands for a role, and every role keeps its "X name" (or «trait»). A spec sentence would then read "an element name is a label", never "the element's label". I'd also put the one-rule-or-family question to him early, as UDON examples, because every name card waits on it.

- **Joseph's lean on which names are labels** (2026-10-12, `.int/STEWARD-VERBATIM.md`):

  > | 'user' | element name  | label |
  > | 'admin' | trait        | label |
  > | 'role', 'size' | attribute names | label |
  > | '$key', '$traits', '$main' | attribute names (& desugar targets) | label |
  > | 'jw' | :$key value | value | (parsed like any other value after ':attribute ', for example, but with distinct closing delimeter-- might need some rework)
  > | 'u64' | opaque for now | (part of a typed-value) |
  > | 'sh' | fence language | label |

  The fence's `sh` is a label since the opening line reads like an element's line ([[rule:fence-opener-line]]).

- **For the label-characters discussion** (Joseph, 2026-10-12, his words):

  > When we get to it, to be clear-- *quoted* labels can hold just about anything except newlines-- :'#$%^&  WOW -----|>>><>[]\''  awful but allowed label.
  > The only question is what characters are allowed for labels *without* quoting. Former versions were somewhat restrictive, and then allowed, for example, cardinality-like suffixes as suffixes (ala ruby methods allowing '?' or '!' but only at the end of the identifier). The truth is, I've lost most of my reasons for being so restrictive with labels-- especially since it's a syntactical efficiency question and not a semantic question per se.  Spaces and quotes themselves and backticks and backslashes should probably require being quoted... as should all udon starters in addition to backtick if they are at the beginning... hmmm.. this needs more careful thought. We'll cover this independently shortly I think, where we'll discuss what's not allowed even when quoted (control characters maybe (except via escape sequences in "..." delimited labels)? Invalid unicode codepoints?...) and then what, when unquoted, is allowed as first-character, inner, and final if different from inner.

  Already decided that bears on it: an unquoted label can't begin with `.` (provisional, [[rule:traits-may-follow-spaces]]).

- **Which characters (2026-10-20).** Joseph: "Since it's time to take it on, let's do it right and first talk about our options as far as XID, UAX31, etc." The options, from UAX #31 (Unicode 18), UTS #55, XML 1.0, CSS Syntax 3 and KDL v2, are laid out in `.int/labels-unicode-options-2026-10-20.md`: default identifiers (XID), immutable identifiers, XML's fixed ranges, ASCII only, a KDL-style negative definition; the guard-versus-validation split; and the case, normalization and invisible-character choices any option still needs.

### Coordinator's lean (Opus 5.5, 2026-10-09; my opinion for Joseph, not a lean of his)

- **Agree with the drafter:** «label» in his 2026-10-09 sense, a lexical class only. Spec sentences say "an element name is a label", never "the element's label". The cards' current "label" for the attribute's name, the fence tag and the type tag all go.
- **One rule or a family?** I lean **one rule** for every label, with quoting as the escape hatch for anything outside it. Reasons: lite's own [[prin:one-rule-everywhere]]; a reader without highlighting can then learn one shape; and 0.10.0's three character sets came from three different design passes, not from a decision that names *need* different sets. The cost is K12's wider attribute names ("attribute identities get [identifiers] that are a lot more expressive"): `:data[1]` would need quotes. That cost is the question to ask him, with that example.
- **Which names are labels:** element names, attribute names, traits — yes. The fence's word (if it is a word) — yes. The key — no, it is a value ([[rule:key-holds-a-value]]). The `u64` in `<u64:0xff>` — lite never reads it, so the question doesn't arise in lite.
