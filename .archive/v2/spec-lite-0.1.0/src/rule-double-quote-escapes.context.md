# Context: [[rule:double-quote-escapes]]

*History and provenance for the card beside it. Not spec text and not a record; nothing here binds.*

- **His words.** 2026-10-08: "ruby strings:  right--- no interpolation, #{} gets passed through as normal text, and go ahead and error on unknown escape sequences in ""." On the list, after the escape-sequence report (`.int/escape-sequences-2026-10-08.md`) was relayed with four calls:
  > escape sequence responses
  > 1. agree
  > 2. agree about the surrogate pairs
  > 3. I can support dropping \v and \a
  > 4. It sure makes certain terminal behavior easier by having it instead of ansi sequences... (like animated character). That said, I'm fine erroring as reserved for right now.

  That is: `\s` an error ("agree"); a correctly ordered surrogate pair accepted as one code point and a lone surrogate refused ("agree"; the lone-surrogate error was part of the same lean, report §2.2); `\v` and `\a` dropped; `\b` reserved for now.
- **Where the list came from.** He thought an improved escape set existed in the mainline 0.9 spec; the search found none, and the report built the list from Ruby's, lined up with lite's number rules (hence no octal). The rest of the list is the report's proposal, relayed and unobjected. The `\u{…}` spacing details are an agent default.
