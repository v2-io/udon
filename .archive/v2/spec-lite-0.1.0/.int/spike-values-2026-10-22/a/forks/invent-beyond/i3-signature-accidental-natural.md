# I3: signature, accidental, natural — and a legend that looks like the data

*Invention fork `invent-beyond`, spike a, 2026-10-22. Invented first, judged after. Sources:*
- *music's key signature: printed once at the start of each staff; every F is read sharp until changed;*
- *the accidental, which overrides one note;*
- *the natural sign ♮, which cancels the signature for one note;*
- *a map legend, a small sample of each symbol beside its meaning, printed once in the margin.*

*Trees: `⸨…⸩` a «text», `"…"` a «string», `#integer` the parser's class, `as x` a reading.*

## The idea

A musician never writes "F-sharp" on every F. The signature says it once, a rare note carries an accidental, and ♮ says "just this note, plain". Values can work the same way, in three tiers:

| Music | Lite | Who writes it, how often |
|---|---|---|
| **signature**: once, at the head | a **legend**: one exemplar element per kind, its values replaced by the names of their readings | the document's author, once |
| **accidental**: one note | a **reading** on one value, after it: `0xff<u64>` (I1) | rarely |
| **natural**: cancel for one note | **quotes**: exactly these characters, read as nothing else | rarely |

The legend is the new piece. It is a schema written as an example of the data it describes:

```udon
:$legend |server :port u16 :timeout duration :started datetime
:$legend |job :timeout duration :length length
:$legend |part :zip postal-code :commit sha

|server[web] :port 8080 :timeout 30s :started 2026-07-21T14:20 ; prod
|job :timeout 5m :length 5m
|part :zip 01234 :commit 1234567
|reg :mask 0xff<u64>
|server[db] :port "8080"
```

**This needs no new syntax.** Every line already parses by today's cards:
- top-level attribute lines belong to the root ([[rule:top-level-attributes]]);
- an element right after a waiting attribute is its value, rest of line included ([[rule:element-after-attribute-with-no-value]]);
- repeated attributes stack ([[def:stacking]]).

The one open dependency: whether a hand-written `$`-name is allowed ([[def:attribute-name]] working notes). Failing that, an ordinary `|legend` element by convention.

**The lite tree**, which stays honest: lite reads nothing.

````tree
root
  :$legend |server
             :port ⸨u16⸩
             :timeout ⸨duration⸩
             :started ⸨datetime⸩
  :$legend |job
             :timeout ⸨duration⸩
             :length ⸨length⸩
  :$legend |part
             :zip ⸨postal-code⸩
             :commit ⸨sha⸩
  |server
    :$key ⸨web⸩
    :port ⸨8080⸩ #integer
    :timeout ⸨30s⸩
    :started ⸨2026-07-21T14:20⸩
    ; prod
  |job
    :timeout ⸨5m⸩
    :length ⸨5m⸩
  |part
    :zip ⸨01234⸩
    :commit ⸨1234567⸩ #integer
  |reg
    :mask ⸨0xff⸩ as u64
  |server
    :$key ⸨db⸩
    :port "8080"
````

**Read with the legend**, as a reader would read it (not lite):

````tree
  |server[web]  port = 8080 (u16) · timeout = 30 s · started = 2026-07-21T14:20
  |job          timeout = 5 minutes · length = 5 meters
  |part         zip = postal code "01234" · commit = sha 1234567   ← the legend un-numbers it
  |reg          mask = 255 as u64 (the accidental)
  |server[db]   port = "8080" — the natural; a u16 slot reports it, it is never silently converted
````

Look at `|part` and `|job`. The legend settles the two hazards the classification fork said no spelling rule can: an identifier that spells a number, and `5m` as minutes or meters. Both are settled once per document, by kind, with the values left as bare as a person writes them.

## The composite lines

```udon
:$legend |server :port u16 :timeout duration :started datetime
:$legend |cfg :tags [integer text date]
|server[web] :port 8080 :timeout 30s :started 2026-07-21T14:20 ; prod
|p Chapter 3: The Return
  See |{a :href /x the docs} for more ;{link checked}.
|cfg :tags [1 two 2026-07-21]
```
The tree is as above. `|p` is untouched. `:tags`'s legend reads its list positionally, which only a reader can do. Whether a legend can describe lists by position or only by item kind is unfinished.

## What I find beautiful in it, and why

- **The schema looks like the data.** You learn what a `|server` is by reading one, with its values replaced by what they are. A map legend teaches the same way: a little sample of each symbol. No new language for schemas, no new syntax in lite.
- **Joseph's "domain-forward" taken literally.** Values are bare, written as a person writes them, and the meaning is said once per kind. That is CTQ A5's "conventions … carry what would otherwise be declared on each value", inside the document, without a directive.
- **The triad tells one story.** Signature, accidental, natural is a three-tier model of how a value gets read that a person already knows from music. It matches the three rungs the wildcard fork found (open, declared, closed) and gives them an order of frequency: the signature almost always, the accidental rarely, the natural rarely.
- **Lite stays honest.** Lite carries the legend like any attribute and reads nothing. The legend is a *convention*, which is what the slots fork said slot types have to be.

## Then the weighing (CTQ-FACTORS, Beauty first; hypotheses)

| Factor | Δ vs the parent's lead | Basis |
|---|---|---|
| A1 agent-subjective | +1 | taste; the exemplar-schema idea is the part I'd defend hardest |
| A2 generative guessability | 0 | the values are as an agent writes them unprompted; the legend is learned once, and copying an element's shape is easy |
| A3 cold comprehension | +1 | a cold reader sees the legend first and knows what `5m` is |
| A5 domain-forward | +2 | meaning said once per kind |
| A6 spec clarity | 0 | lite's spec gains nothing but a sentence: "a legend is a convention for readers" |
| A7 / A8 | 0 | no syntax |
| A10 self-description | +1 | self-describing without per-value plumbing, the kind A10's footnote doesn't fear |
| B3 stability | 0 / −1 | lite's tree is stable; two readers may apply a legend differently unless the legend convention is specified somewhere (a reader-layer spec) |
| C5 schemas and slot types | +2 | an in-document schema, by example |
| C9 composition | +1 | a legend is a fragment that can be shared or included by a later UDON |

**Where it's weak:**
- A legend says nothing about *structure* (cardinality, nesting, required attributes). It is slot readings only.
- A real schema language would be needed for more, and the legend shouldn't grow into one.
- Lists by position, unions (`port = u16 | standard-port`) and aliases need a vocabulary for reading names that this page doesn't invent. `u16|port-name` as a legend value is my first guess.

**Unfinished:** whether a legend governs every element of its kind in the document, or only those after it (a signature governs until changed; a key change mid-piece is a new signature). My lean is until changed, which also streams: a reader applies what it has seen.
