# Labels: the Unicode options (2026-10-20)

*Research for Joseph's 2026-10-20 ask: "let's do it right and first talk about our options as far as XID, UAX31, etc." Written by the udon-team agent (Opus 5.5) from primaries it read itself on 2026-10-20: UAX #31 revision 45 (Unicode 18.0.0, dated 2026-09-01), read whole; UTS #55 §3 (Computer Language Specifications); XML 1.0 Fifth Edition §2.3 and Appendix J; CSS Syntax Level 3 §4.2 (ident code points) and its changes list; KDL v2 §3.10 and §3.19. Character properties were checked against UCD 18.0.0 `PropList.txt` and `DerivedCoreProperties.txt`. Nothing here is decided; it is input for the label discussion ([[def:label]]).*

## Two facts that frame every option

1. **Every ASCII punctuation character except `_` is `Pattern_Syntax`:** `` !"#$%&'()*+,-./:;<=>?@[\]^`{|}~ `` (checked, UCD 18). So `-` in `data-id`, `:` in `xml:lang`, and `? ! * +` are outside every Unicode identifier definition. Whatever lite allows of them is a declared profile on top of whichever Unicode option it takes. That is a separate question (ASCII punctuation in bare labels).
2. **Unicode offers two different stabilities** (UAX #31 §1.1):
   - `XID_Start` / `XID_Continue` only grow: "once a string qualifies as an identifier, it does so in all future versions" (R1b; guaranteed for unprofiled R1/R2). But new letters arrive in every version, so an older parser doesn't know a newer name.
   - `Pattern_Syntax` and `Pattern_White_Space` "are immutable and will not change over successive versions of Unicode".

## Why this bites lite harder than a programming language

Pre-design 69: if the guard that decides "does `|` here open an element?" asks whether the next character is `XID_Start`, then a line whose name starts with a letter from a recent Unicode version is an element to a new parser and text to an old one, with no error on either side. UTS #55 §3.1: "Computer languages that require forward compatibility in their identifier definitions should use the definition of identifiers given by requirement UAX31-R2 Immutable Identifiers. Unless they require forward as well as backward compatibility, computer languages should use the definition of identifiers given by requirement UAX31-R1 Default Identifiers."

## The options

- **A. Default identifiers (UAX31-R1):** `XID_Start XID_Continue*` plus a declared profile. Word-like names; closed under normalization (§5.1.3); the UTS #39 security tooling applies. Cost: version-dependent. Either the spec pins a Unicode version (parsers can't simply use their host's tables) or two conforming parsers disagree on new letters.
- **B. Immutable identifiers (UAX31-R2-1):** any non-empty string with no `Pattern_White_Space`, `Pattern_Syntax`, Control, Private_Use, Surrogate or noncharacter. Fixed forever. UAX #31 §3: "The drawback of this method is that it allows "nonsense" to be part of identifiers"; immutable identifiers that allow unassigned characters "cannot be compared for NFC, NFKC, or case-insensitive equality" and "are unsuitable for restrictions such as those in UTS #39". UAX #31's own compromise profile: everything R1 allows as of some Unicode version N, plus every code point unassigned in N (word-like and immutable, at the cost of large fixed tables).
- **C. XML's fixed ranges** (XML 1.0 Fifth Edition, productions [4] NameStartChar and [4a] NameChar): about fifteen inclusive ranges, independent of Unicode version. "Almost all characters are permitted in names, except those which either are or reasonably could be used as delimiters. The intention is to be inclusive rather than exclusive, so that writing systems not yet encoded in Unicode can be used in XML names." UAX #31 (rev. 45): "The XML NameChar repertoire is similar to the repertoire of immutable identifiers." CSS Syntax 3 adopted the same ranges for its non-ASCII ident code points, "to be consistent with HTML's valid custom element names." XML pairs the inclusive grammar with non-normative guidance (Appendix J): first character `ID_Start` or `_`, the rest `ID_Continue`, names in NFC.
- **D. ASCII only for bare labels; everything else quoted** (as TOML bare keys, `A-Za-z0-9_-`). Stable and tiny. Latin-centric: `|café` must be written `|'café'`.
- **E. A negative definition, KDL-style:** anything except a short list of syntax characters, whitespace and forbidden code points. KDL v2 forbids `(){}[]/\"#;=`, whitespace and newlines, its "disallowed literal code points" (C0 controls other than whitespace, DEL, surrogates, the bidi controls U+200E–200F, U+202A–202E, U+2066–2069, and a BOM except at the start), plus number-like starts. The most permissive. Lite would choose its own reserved ASCII set instead of `Pattern_Syntax`.

Where the options differ, by example (bare names only; the guard question is below):

| Written | A | B | C | D | E |
|---|---|---|---|---|---|
| `\|café` | name | name | name | quote it | name |
| `\|名前` | name | name | name | quote it | name |
| `\|👍` (U+1F44D, not XID, not Pattern_Syntax) | not a name | name | name (≥ U+10000) | quote it | name |
| `\|→x` (U+2192, Pattern_Syntax) | not a name | not a name | not a name | quote it | lite's choice |
| a letter first encoded in Unicode N+1 | depends on the parser's version | name | name | quote it | name |

## A structural point, independent of the option (the agent's, not from the primaries)

Separate "does this open an element?" from "is this a valid name?". If the guard tests only an immutable class (for example: `|` followed by anything that is neither whitespace nor `Pattern_Syntax` opens an element), and the name is then validated, with an invalid name an error rather than text, then even option A can't silently diverge: an old parser errors on a newer letter instead of reading the line as prose. That is the reserve-not-ignore posture applied to names. Markdown's `| a |` and `|---|` stay text either way (space and `-` fail the guard).

## Choices every option still needs

- **Case.** Lite never folds case: `|Div` and `|div` are different names. UTS #55 §3.1.2 adds that a language should not rely on case alone for meaning (unicameral scripts).
- **Normalization.** UTS #55 §3.1.1: case-sensitive languages should treat identifiers as equal under NFC (UAX31-R4), and "Programming languages should not silently normalize the contents of string literals." For lite this decides when two attribute names are "the same" for stacking, and when two keys collide. Choices: byte equality; NFC equality (needs normalization tables in every parser); or require names to be in NFC (UAX31-R6, an error otherwise).
- **Default-ignorable and bidi characters** (ZWJ, ZWNJ, ZWSP, variation selectors, LRM/RLM, the embedding and isolate controls). UAX #31 §2.3: a profile "should be used to remove them from general-purpose identifiers". KDL forbids the bidi controls literally anywhere in a document. UAX31-R3a and UTS #55 §3.2 instead recommend allowing LRM and RLM as ignorable between tokens, so plain-text display can be corrected. This belongs with "what a label may never hold, even quoted".

## The agent's lean (put to Joseph 2026-10-20; not his)

C as the grammar, with the guard/validation split, plus a default-off warning (his new category, [[rule:warnings-can-be-toggled]]) for a bare label that isn't a UAX #31 default identifier or isn't in NFC. That is XML's own two layers: inclusive grammar, narrower guidance. Reasons: version-free, so no pinned Unicode tables and no host-table drift; one small table any tiny parser can carry; XML and HTML names carry over as written, which is the critical objective; non-Latin authors write bare names. Costs: emoji and other odd characters are legal names, word-likeness is only advised, and no normalization guarantee comes from the grammar.
