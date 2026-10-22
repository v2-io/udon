# What `<…>` has been asked to do, and the one thing it can't do

*Fork `angle` of spike a (Opus 5.5, 2026-10-22). Labels: **checked** = verified against a card or file in this session; **instinct** = my own sense, as an agent, of what I'd write or what a spelling means (by Joseph's note, better evidence than the estate's documents, which were written by fiat); **guess** = inference not verified; **taste** = preference.*

## Seven jobs on one bracket

Reading the cards, the verbatim record and 0.9 CORE, `<…>` has been asked to do seven different things (**checked**, sources in brackets):

| Job | Example | Who asked |
|---|---|---|
| **Assert** a standard-set value, so a typo is an error | `<901.2>`, `<920px>` "error I can understand" | Joseph 2026-10-21 |
| **Self-end** a value, so more can follow on the line | `|el <42> apples` | implied by the one-value-closes lean |
| **Carry** a notation lite doesn't read | `<2026-10-01>` raw | 2026-09-29 option 2; the raw-text card |
| **Name** a notation or a host type | `<u64:0xff>`, `<dt:…>`, `<rust:i64: 0x73DDF>`, `dt(YY-MM-DD)` | Joseph, 2026-07 to 10-22 |
| **Compose** typed values | `<r: <i: 3 -7> 0d83.23>` | `design/composite-types.md`, 2026-07-14 |
| **Be nil** | `<>` | Joseph 2026-10-22 |
| **Quote** (keep a reference unresolved) | `@{<…>}` | Joseph 2026-10-20, who calls it "a little unprincipled" |

Most of the friction in the record comes from asking one bracket to do all seven. The first six are one family (a value whose meaning comes from inside the brackets). **Quote is a different job** (Lisp's `quote`: hold something unevaluated), and I'd take it off `<…>` whatever else is chosen. Out of this fork's scope beyond that sentence.

## The no-go: an unlabeled bracket can't both reject and carry

To **reject** `<920px>` or `<8O80>` (a letter O), a parser must know every notation that may legitimately stand there: a closed world. To **carry** `<2026-10-01>` or `<u64:0xff>` without reading it, the parser must accept things it doesn't know: an open world. For one unlabeled form, a given interior is either an error or carried; it can't be both. So "assert" and "carry" can't share an unlabeled `<…>`.

It shows in Joseph's own two options (**checked** against [[rule:opaque-span-raw-text]]'s working notes):

- 2026-10-20: inside `<…>`, "`nil`, `true`, `false`, (number, leading with [+\.\d-] and whatever rules), or a delimited string-- specifically *not* watching for bare-words and passing bare-words (or anything other than the above) through raw."
- 2026-10-21: "<920px> error I can understand"; `<uint32|0x992BC>` "error- reserved for now".

Read literally, these agree: a digit, sign or `.` **commits** to a number (so `<920px>` is an error, and so is `<2026-10-01>`); only *word-led* interiors pass through raw. The coordinator's restatement ("anything that isn't a primitive or a delimited string passes through raw", so `<2026-10-01>` raw) is a different design: an open world for digit-led interiors too, which can no longer reject `<920px>`. **That restatement and his 10-21 words can't both hold.** His literal 10-20 wording plus 10-21 already chose closed-for-digit-led.

**Labels dissolve the no-go.** Let the *unlabeled* form be closed (the standard set or an error) and the *labeled* form be open (`<name: …>`, carried, its body read by whatever knows `name`). Each world gets its own spelling. That's the structure of the branch I'd recommend ([ang-4c](ang-4c-value-fence.md)).

## Why closed-unlabeled matters more than it looks (instinct)

What do agents put in angle brackets? From my own priors, without looking anything up: HTML and XML tags (`<b>`), placeholders in usage text (`<file>`, `<name>`), Markdown autolinks (`<https://example.com>`), operators (`<=`, `<-`, `<3`), and generics (`Vec<T>`). A typed literal is not among my strong readings of `<…>`; only the interior's shape (`<2026-07-21>` looks like a date) suggests it.

In an **open** unlabeled `<…>`, every one of those becomes a quiet value: `:html <b>bold</b>` gives a raw `b` and then `bold</b>` as more material; `:file <path>` a raw `path`; `:link <https://example.com>` a raw URL (or, with a colon-labeled head, a notation named `https`). In a **closed** one, each is an error that can say what was probably meant ("quote it: `"<b>bold</b>"`"). By CTQ B4 (errors that teach) and A2 (silent misses weigh more), closed wins clearly. The basis is my instinct about my priors, not a measurement.

## What the choice of `<…>` depends on: DP1

Whether lite needs `<…>` for the standard set at all depends on the classification fork (DP1):

- **Bare is text, full stop (C strict):** `<…>` is the *only* way to write a number, boolean or nil in the tree, so it must hold the standard set. Raw-box designs ([ANG-1](other-branches.md)) fail the JSON case.
- **Bare is classified (a view, an attachment, or B):** the standard set is already reachable bare. `<…>` holding it is then **assertion** (K14) and **self-ending**, not a necessity.

The recommended branch serves both: its unlabeled form is "the standard set, asserted", which is necessary under C strict and useful under the others. So this fork's recommendation doesn't wait on DP1.

## The fence is already the block form of this idea (checked)

[[rule:fence-opener-line]]: after the backticks, "the rest of the line MUST be read as an element's line"; [[rule:fence-default-handler]]: the fence's attributes, traits and `$main` "MUST be interpreted by the handler for its name", and the default handler carries the body for any name (`sh`, `rust`, `sql` alike). So **lite already carries a named notation's body unread and lets a handler for the name read it later.** A labeled `<name: body>` is the same thing at value size: a value fence. One concept («notation», with a handler per name), two scales. Two consequences:

- **Spec clarity (A6, A7):** one idea instead of two; the head of `<…>` reuses the element head's pieces (name, `[key]`, `.trait`), each meaning what it means on an element: the name says which notation, a key says which one ("the `DD-MM-YY` one"), a trait says what kind.
- **Reserve-don't-ignore (B2):** if carrying a named body that a later version will read violated B2, fences would already violate it. So either B2 already admits *refinement* (a later version adds a reading without changing what lite's tree held), or the fence cards are in breach. Worth putting to Joseph as one question: **is a refinement a change?** I lean no, provided lite's tree marks the body as unread (raw), never as text or string. If the body were a string in lite's tree, a later date reading *would* change its kind, and that would fail B2.
