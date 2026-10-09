---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: true
terms: [empty-line, blank-line]
per: []
depends: [rule:blank-line-sets-no-indent]
consequences: [rule:blank-line-sets-no-indent, rule:blank-line-any-whitespace, rule:blank-line-whitespace-in-text]
---

# empty-line · blank-line

*An «empty-line» is a newline with nothing before it on its line; a «blank-line» is an «empty-line» or a line of only whitespace.*

## Terms

- **empty-line:** a newline that is the first character of the «document» or directly follows another newline.
- **blank-line:** an «empty-line», or a line holding only Unicode whitespace. Every «empty-line» is a «blank-line».

## Invariants

- A «blank-line» never sets or changes indentation ([[rule:blank-line-sets-no-indent]]).

## Examples

```udon
|node some $main prose
    child prose section starting...
      
    more prose...
```

Line 3 holds six spaces: a «blank-line» that is not an «empty-line». Joseph's reassembled text: `"child prose section starting...\n  \nmore prose..."`.

## Avoid

"Joseph" marks his own words; everything else is an agent's or a spec draft's.

- **empty line for a whitespace-only line** — YAML 1.2.2 §6.4: "An empty line line consists of the non-content prefix followed by a line break", where the prefix may hold indentation, so YAML's "empty line" is roughly lite's «blank-line». A YAML-fluent reader may carry that sense over.
- **blank** (a tree node), **BlankLine** (an event) — the pre-design tree notation (`└ blank`) and the 0.9 wire event (`BlankLine`, Joseph's own 2026-01-14 sketch, L7859). Lite's tree has no blank node; edge «blank-line»s are not content ([[rule:edge-blank-lines]]).
- **whitespace-only line** as a separate category — 0.10.0 §7.4 heading "Blank and whitespace-only lines". In lite a whitespace-only line *is* a «blank-line».
- **blank line = "not protruding past the content base"** — 0.10.0's glossary ("Blank line — a whitespace-only line not protruding past the content base"). Lite's «blank-line» is defined by the line alone; whether its whitespace is content is [[rule:blank-line-whitespace-in-text]]'s business.
- **double-newline** — Joseph, 2026-01-14: a whitespace-only line "should be equivalent to a double-newline unless in raw triple-backtick mode" (L7854). That was a behavior description, not a name.
- **blank line ends a value or comment** — pre-design 90's options B–D. Lite: a «blank-line» never ends anything by itself.

## Working notes

- **Not reviewed with Joseph.** Joseph, 2026-10-09: "I haven't looked at any or been asked about any of those things … but the idea that they can just kind of organically be whatever would cause serious trouble really soon if allowed to continue." Every term here is provisional until he rules on it; `.int/lexicon-inventory-2026-10-09.md` lists where each came from.
- **These two terms are Joseph's own, defined by him** (2026-10-08, `.int/STEWARD-VERBATIM.md`):
  > That reminds me-- if it's not already a rule or planned-- we need to make sure we explicitly denote "blank lines" distinct from (a superset with) "empty lines" -- blank lines do *not* change indent levels. In some cases whitespace on blank lines is considered ornamentation, in some cases it can be part of prose:

  > Your defined terms are my intention yes-- empty would be a newline as the first of the document or any newline directly after an earlier newline. blank can be empty or have (unicode specified) whitespace.

  What remains open is wording the definitions, not choosing the words.
- **Precedent: POSIX matches his split exactly.** POSIX.1-2017 (XBD 3.75): "Blank Line: A line consisting solely of zero or more <blank> characters terminated by a <newline>; see also Empty Line." XBD 3.145: "Empty Line: A line consisting of only a <newline>; see also Blank Line." Two differences: POSIX's <blank> is "either a <tab> or a <space>" in the POSIX locale, where Joseph's is "(unicode specified) whitespace"; and POSIX lines end with a newline, so a final whitespace-only stretch with no newline after it is not a line in POSIX. CommonMark has one term: "A line containing no characters, or a line containing only spaces (`U+0020`) or tabs (`U+0009`), is called a blank line." Python's lexical reference also says "blank line" for a whitespace-only line (from memory, not re-checked).
- **Three wording questions in the current definitions:**
  1. **Category.** «empty-line» is defined as *a newline* (a character), «blank-line» as *a line*. Joseph's wording has the same shape ("empty would be a newline…"). If empty lines are a subset of blank lines, both are probably lines: "a line with no characters before its newline". POSIX's wording does this.
  2. **Which whitespace.** Unicode `White_Space` includes the line terminators (U+000A, U+000B, U+000C, U+000D, U+0085, U+2028, U+2029) and U+00A0 NO-BREAK SPACE. "Holding only Unicode whitespace" needs to exclude whatever lite treats as line endings (slice B's [[rule:source-lines]] gap). Does a line of only U+2028 count as blank or as two line breaks? [[rule:blank-line-sets-no-indent]]'s working notes already leave this open ("probably `White_Space`, to confirm").
  3. **The last line.** Is the end of input with nothing after the final newline an «empty-line»? Under "a newline that … directly follows another newline", no line exists there. A whitespace-only stretch at the end with no newline: is it a «blank-line»? Probably yes, but it isn't stated.
- **The neighboring term: ornamentation / layout.** The cards say edge «blank-line»s are "layout, not content" ([[rule:edge-blank-lines]]). Joseph's words, in date order:
  - "ornamentation", his coinage: "blank lines in *non-prose* mode / positional construct detection etc. are (or should be) considered *UDON-level decoration* … (Maybe call this ornamentation, vs text-literal or something)" (2026-07-19, L16875);
  - his definition: "defining "ornamental" as 'choices about things that change how the udon looks without changing the AST (or some late consumable form before that), except they may be preserved in their own namespace for exact verbatim round-trip" (2026-07-20, L17001);
  - his layering lean: "content < content+meta < content+meta+ornament / round-trip only optionally preserves meta" (2026-09-30, L21322);
  - on the cards' word, 2026-10-09: "correct-- layout (== ornamental)".

  So "layout" is the drafter's word, which he accepted as equal to his. *A substantive point for the coordinator:* [[rule:edge-blank-lines]] says an edge blank line "MAY be kept in «meta»". Joseph's 09-30 lean puts ornament in a layer *beyond* meta. Whether ornament is a kind of «meta» or its own layer is a slice D question (document and tree), and it decides where these lines go. Whoever owns «meta» may want an "ornament" term, with "layout" and "decoration" in its Avoid list.
- **Questions of register.** "Blank" can suggest "missing" or "unfilled" (a blank value, "leave it blank"). Joseph's own phrase on 2026-10-09, "'' for blank string" ([[rule:missing-value]]'s error message), uses "blank" in exactly that sense. In error messages, a «blank-line» and a "blank string" sit close together. "Empty" has the same double use ("empty text", `:a \`). Probably harmless, as each is always followed by its noun.
- **My lean (this agent's):** keep both words as Joseph defined them; reword «empty-line» as a line ("a line with nothing before its newline"); name the whitespace set and exclude line terminators explicitly once slice B settles line endings; and route "ornament" vs "layout" to the «meta» owner, not here.
