# Composite example set (spike c)

*Shared by every branch in `c/` so the branches can be compared. Each item is an **intent** — what a writer means — not a spelling. A branch renders each intent in its own spelling, gives the tree, and marks where it can't render the intent honestly, has to add plumbing, or where a plausible near-miss spelling silently gives a different tree. Written by the spike-c agent, 2026-10-22; the intents were chosen to collide with the rules lite already has (sameline runs, framed comments, embeds, stacking, Markdown and HTML in text, the labels lean that allows `:` inside a name).*

## Data (the JSON/YAML use, C1)

- **E1 server.** name `web` (a word); port 8080 (an integer, used as a number); host `localhost`; tls on (boolean); retries 3; ratio 0.5; zip code `01234` (a string; leading zero matters); version `1.10` (a string; `1.1` is a different version); `note` deliberately empty (nil).
- **E2 book.** title *1984* (it's a title, not a number); a second title *1984 is a novel*; year 1949 (a number); price 9.99.
- **E3 list and key.** tags: the integers 1 and 2 and the word `three`; a step element whose key is `1`.
- **E4 big and odd numbers.** 12345678901234567890123 (past 2^64); `0xFF`; `1e10`; `-0`; NaN.
- **E5 empties.** nil; an empty string; `false`; and the writer typing JSON's `null` by habit.

## Notation-bearing values (C4)

- **E6 temporal.** a date 2026-01-10; an instant 2026-01-10T14:30Z; a duration of 30 seconds; a duration P1Y2M; a date written in the domain's own format `27-03-05` meaning YY-MM-DD (so 2027-03-05).
- **E7 units.** a width 920px; a timeout of 5 minutes written `5m`; a length of 5 metres written `5m`; 50%; 1.5GB.
- **E8 algebraic name.** a port given once as `ssh` and once as `22`, where the domain says port = u16 | {smtp, ssh, http, …}.
- **E9 host-specific.** a value the writer wants stored as a Rust `i64`, written in hex `0x73DDF` (Joseph's naive model was `<rust:i64: 0x73DDF>`).

## Mixed content and prose (C2, C3)

- **E10 HTML-ish.** `|a :href https://example.com Click here`; a list item whose sameline text is the Markdown autolink `<https://example.com>`; a list item whose sameline text starts `<= 5 items`; an `alt` text `5 < 6`; sameline text `Chapter 3: The Return`.
- **E11 the gotcha pair** (Joseph: "expected behavior"): `:width 7 ;{px}` and `:height 7 ; px`.

## Names (the trailing colon; XML namespaces)

- **E12.** `|server :host: localhost :port: 8080` (his ornamental trailing colon); `|html :xml:lang en`; `|svg :xlink:href #a`.

## What a rendering reports

For each item: the spelling, the tree (kind and form on every scalar), and one of: *renders* / *renders with plumbing* (how much) / *can't render honestly* (why) / *near-miss trap* (the plausible wrong spelling and what it silently gives).
