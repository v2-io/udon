# The composite set every branch renders (spike a)

*The same meaning, which each branch writes in its own spelling and shows the tree for. Written in plain words, not UDON, so it doesn't favor any branch. A branch that can't render an item honestly says so, and that counts against it. Items marked (estate) echo spellings the estate's own documents use; per Joseph those documents were written by fiat and are ideation, not evidence of how anyone writes.*

| # | Meaning to write | Pressure it puts on a design |
|---|---|---|
| K1 | A server record: name `web`, port 8080, enabled true, weight 0.75, a backup that is nil | the JSON case (C1) |
| K2 | A US zip code `01234`, a version `1.10`, a commit `1234567`, a part id `1e10` | identifiers that spell numbers (DP3) |
| K3 | A book: title `1984`, year 1949; a second book titled `1984 is a novel` | a number as text, text starting with a number |
| K4 | (estate) A decision dated 2026-07-21; a session at 10:12; a window of 60 seconds; a timestamp 2026-07-21T14:20 | temporal values (the estate writes them in `<…>`, by fiat) |
| K5 | A CSS-ish box: width 920px, margin 1.5em, opacity 50% | units on literals (DP9) |
| K6 | A timeout of 5 minutes and a length of 5 meters, both naturally written `5m` | the same literal, different meanings by slot |
| K7 | A port given by name, `ssh`, where the domain says port = u16 or a standard port name | aliases / algebraic names (DP10) |
| K8 | A register value that the author wants stored as an unsigned 64-bit integer, written `0xff` | a host type stated by the author |
| K9 | A date written day-first, `05-03-27` meaning 2027-03-05, by an author who says which notation it is | a notation with parameters (his `dt(YY-MM-DD)`) |
| K10 | The text `nil` (a word in a sentence), the value nil, and the empty string | nil vs text vs empty |
| K11 | An HTML paragraph: `See <a href="/x">the docs</a>.`, and an element with `xml:lang="en"` | mixed content and a namespaced attribute name (C2) |
| K12 | A list of three integers 1, 2, 3, and a list of three tags `a b c` | lists |
| K13 | A key: the third step, `|step[3]`, and a user keyed `jw` | keys |
| K14 | An author who wants to *insist* that a value is a number, so a typo is an error rather than silently text | write-site validation |
| K15 | A value whose notation lite doesn't know yet (e.g. a color `#3221f9`, a money amount `$9.99`, a geo point) | headroom and reserve-don't-ignore (B2, B6) |

**Composite lines.** Each branch also writes these three lines with its rules mixed in, and shows their trees:

- C-a: element `server` keyed `web`, with port 8080, a timeout of 30 seconds, a started-at timestamp, and a framed comment `; prod`, all on one line.
- C-b: a paragraph-level element `p` whose own line is `Chapter 3: The Return`, followed below by prose holding an inline element and an inline comment.
- C-c: an attribute `tags` whose value is a list mixing the integer 1, the text `two`, and a date.
