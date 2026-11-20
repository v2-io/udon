# The composite set under Cc + S-JSON (and where the others differ)

*Classification fork, spike a, 2026-10-22. Items belonging to sibling forks (temporal values, units, aliases, host types, notations: K4–K9, K15) are rendered only as far as classification touches them: as texts with no class, which a slot type or a notation then reads. `#integer` etc. mark a classification attached to a text (illustrative notation).*

```udon
|server[web] :port 8080 :enabled true :weight 0.75 :backup nil
|part :zip 01234 :version 1.10 :commit 1234567 :id 1e10
|book :title 1984 :year 1949
|book :title 1984 is a novel :year 1949
|box :width 920px :margin 1.5em :opacity 50%
|job :timeout 5m :length 5m
|svc :port ssh
|words :w "nil" :none nil :empty ""
|nums :ints [1 2 3] :tags [a b c]
|step[3]
```
````tree
root
  |server
    :$key ‹web›
    :port ‹8080› #integer
    :enabled ‹true› #true
    :weight ‹0.75› #decimal
    :backup ‹nil› #nil
  |part
    :zip ‹01234›                ← no class: a leading zero is not a JSON number
    :version ‹1.10› #decimal
    :commit ‹1234567› #integer
    :id ‹1e10› #decimal
  |book
    :title ‹1984› #integer
    :year ‹1949› #integer
  |book
    :title ‹1984 is a novel›
    :year ‹1949› #integer
  |box
    :width ‹920px›              ← no class; a slot type `length` reads it
    :margin ‹1.5em›
    :opacity ‹50%›
  |job
    :timeout ‹5m›               ← minutes by the slot `timeout: duration`
    :length ‹5m›                ← meters by the slot `length: length`
  |svc
    :port ‹ssh›                 ← the slot `port: u16 | standard-port` reads it
  |words
    :w "nil"
    :none ‹nil› #nil
    :empty ""
  |nums
    :ints [‹1› #integer ‹2› #integer ‹3› #integer]
    :tags [‹a› ‹b› ‹c›]
  |step
    :$key ‹3› #integer
````

**The data reading** of `|server` is `{"port": 8080, "enabled": true, "weight": 0.75, "backup": null}` plus the key; each number token is copied byte for byte. Of `|part`: `"zip": "01234"`, `"version": 1.10`, `"commit": 1234567`, `"id": 1e10`. The last three are where an identifier meets a data reading with no slot type ([dp3](dp3-identifiers.md)).

**K14, insisting on a number:** classification never errors; a writer who wants `8080x` to be an error writes the number in whatever committed form the `<…>` fork keeps (`<8080>` in today's lean), or a schema says `port: u16`.

## The three composite lines

```udon
|server[web] :port 8080 :timeout 30s :started 2026-07-21T14:20 ; prod
|p Chapter 3: The Return
  See |{a :href /x the docs} for more ;{TODO link}.
|cfg :tags [1 two 2026-10-22]
```
````tree
root
  |server
    :$key ‹web›
    :port ‹8080› #integer
    :timeout ‹30s›
    :started ‹2026-07-21T14:20›
    ; prod                       ← attached per [[rule:framed-comments]]
  |p
    :$main ‹Chapter 3: The Return›     ← no class, no colon warning ("Chapter" isn't followed by ": ")
    ‹See |{a …} for more ;{TODO link}.›    ← prose: a text of pieces; prose is never classified
  |cfg
    :tags [‹1› #integer ‹two› ‹2026-10-22›]
````

The dates here are bare texts; whether they belong in `<…>` instead is the `<…>` fork's call. Prose is never classified: classification applies only to a value's run, never to text below an element. (That is my reading of the cards' "value" positions; the cards don't yet say it in so many words.)

## Where the other branches differ on these lines

- **C0:** every `#…` above disappears; `port`, `enabled`, `weight` and `backup` need `<…>` to be data; the data reading of `|server` is all strings.
- **Cv:** identical to Cc if the view is on, to C0 if it is off; the document doesn't say which.
- **B:** `|book :title 1984` gives a title that is the integer 1984 in the tree; `|step[3]` a key that is a number, which raises whether `|step[3.0]` is the same step.
