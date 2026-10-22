# Debrief for Joseph: spike b

*From the spike-b agent (Opus 5.5), 2026-10-22. Trees use the cards' notation: `‹…›` a text, `"…"` a string, bare `8080`/`false`/`nil` values of those kinds. `⇒` is what the default reading gives a consumer that has no slot type. Everything marked "my lean" is a lean; the scores behind it are my own hypotheses, written out on the pages named.*

## In one paragraph

Streaming turned out not to separate your option (B) from (C): the 0.9 parser, run, already holds every run whole to its end. What does separate them is `:debug false`. So I'd keep your (C) as it stands in the tree (bare is text, always) and make the view **normative and on**, with JSON's number grammar plus `true`, `false` and `nil` as its whole set. The rest of the old numeric zoo goes inside `<…>`, where it commits and errors. Slot types need no syntax in lite: a slot declared on one value is just a literal claim, so real slot types live in vocabularies (lite documents) and in typed getters. Separately, a quoted or bracketed value at the start of a line's text should count only if it stands alone; otherwise `|p "Hello," she said.` loses its quote marks today.

## 1. Streaming: measured, and it doesn't decide B vs C

A fork fed the 0.9 pushdown parser 200 KB runs in 1 KB chunks. Not one content event came out before the run ended: digits, words, `4…4p`, spaced text, prose and quoted strings all behaved alike. Your `4938422…2412124p` is held whole today and emitted as a bare value at the `p`. "Knows in the first few characters" was true of structure (`|`, `:`, `;`), and not of values in any UDON parser we checked: the 0.9 pushdown parser was run, the recursive one read, and the old value machine taken from its archaeology report, which tagged each value at its end.

Under B and C alike the holdback is one run, bounded by its line. If the wire ever emits content in pieces, C streams text from its first character, and B streams the same text with its kind reported after it, at constant memory. The streaming question that's real is separate from typing: emit content in pieces, or cap the line. Today the only cap is the 4 KB line buffer in the recursive wrapper; the pushdown parser has none.

So the note on [[rule:unquoted-run-is-one-value]]'s context file, that the streaming objection decided C's open bit, doesn't hold. The bit is open on other grounds. The fork also proposes a B1 wording that says what you described rather than "kind known within a few characters", which no UDON parser has met for values (`fork-S-streaming.md`, "What I'd change in the CTQ wording"):

> **Bounded streaming.** Where a construct ends and what contains it are known within a few characters. A parser never needs to hold an unbounded stretch of input to decide them. A classification of a finished span (its kind) may be reported after the span.

## 2. The example that decides the open bit

```udon
|server :name web :port 8080 :debug false :owner nil
```

**If a consumer with no slot type sees bare runs as text:**

````tree
root
  |server
    :name ‹web›
    :port ‹8080›
    :debug ‹false›
    :owner ‹nil›
````

`if server["debug"]` is then true: the string `"false"` is truthy in Python, JS, Ruby and Elixir (I ran it). A JSON export writes `"debug": "false"`. Nothing errors. `:port ‹8080›` is harmless, as you said, but `‹false›` and `‹nil›` aren't.

**If the default reading applies:**

````tree
root
  |server
    :name ‹web›
    :port ‹8080›      ⇒ 8080
    :debug ‹false›    ⇒ false
    :owner ‹nil›      ⇒ nil
````

The tree is identical in both cases. Only the consumer's view differs, and leaving it to each consumer means one document means two things. That's why I think the bit has to be normative, one way or the other. My lean: on.

## 3. What the default reading reads: JSON's grammar, chosen by one test

A default reading is a guess the writer didn't make, so it should guess only where nothing is lost: the value written back out is the spelling written. That test keeps `true`, `false`, `nil`, and numbers spelled as JSON spells them (no leading zero, no `+`, no `.5`, no `_`, no `0x`). It drops everything else:

```udon
|pkg :zip 01234 :mode <0o755> :mask <0xFF> :big <1_000_000> :ratio 0.75 :exp 1.5e-3
|pkg :version 1.0 :size 920px :when 2026-01-10 :sha 1e10a3f
```
````tree
root
  |pkg
    :zip ‹01234›        (leading zero: stays text)
    :mode 0o755         (asserted; the integer 493, spelling kept)
    :mask 0xFF
    :big 1_000_000
    :ratio ‹0.75›       ⇒ 0.75
    :exp ‹1.5e-3›       ⇒ 0.0015
  |pkg
    :version ‹1.0›      ⇒ 1.0          ← the one residual hazard; a slot type fixes it
    :size ‹920px›
    :when ‹2026-01-10›
    :sha ‹1e10a3f›
````

Composite lines with the other rules:

```udon
|el :c 1 z               ; ‹1 z›: one run, stays text
|el :c 1 \ z             ; :c ‹1› ⇒ 1, then $main ‹z›
|el :width 7 ;{px}       ; ‹7 ;{px}›: a comment piece, not one plain run, stays text
|el :height 7 ; px       ; :height ‹7› ⇒ 7, with the framed comment attached
|el :a null              ; ‹null›, with the existing warning: did you mean nil?
|q :x "8080" :y <8080> :z <>   ; a string (never re-read), 8080, nil
```

Your earlier gotcha keeps its meaning (`:width 7 ;{px}` text, `:height 7 ; px` a number), now as a property of the reading. [[rule:nil-spelling]] and [[rule:missing-value]] stay true as written: bare `nil` reads as nil, so their "is it `<nil>` now?" questions go away.

`<…>` carries the rich set strictly, as you put it: "now we *can* commit/error". For lite 0.1, `<>` is nil, a primitive is checked, and **anything else in `<…>` is an error**, labels included (your `<uint32|0x992BC>` "error- reserved for now"). That keeps every notation and composite spelling free for full UDON.

## 4. Slot types: a slot declared on one value is a literal

A slot type speaks for *every* value in a place: every `port` of every `server`. Written on one occurrence, it speaks only for that value, which makes it a literal claim:

```udon
|event :when:iso8601 <dt: 2026 PDT>
```

Both halves speak about this one value; neither carries over to the next `|event`. And `:port:u16` reads as `xml:lang` does, a name that C2 needs. So I'd give lite **no slot syntax**. Your "algebraic names" fit, as data, in a vocabulary that is itself a lite document (spelling illustrative only):

```udon
; server.schema.ud
|type standard-port :one-of [smtp ssh http https]
|type port :one-of [<u16> standard-port]
|element server
  :port port
  :version <text>
  :width length
```
```udon
|server :port ssh :version 1.0 :width 920px
|server :port 22
```
````tree
root
  |server
    :port ‹ssh›        ⇒ (port) standard-port ssh
    :version ‹1.0›     ⇒ (text) ‹1.0›      ← the residual hazard, gone
    :width ‹920px›     ⇒ (length) 920 px
  |server
    :port ‹22›         ⇒ (port) 22
````

The tree is the same with or without the vocabulary; only the reading changes. So a schema can never change what a document parses to. Units fall apart along your own "a bit of both": the **dimension** (length) is the slot's, the **unit** (px) is the spelling's, the **conversion** is the consumer's.

The lightest slot type needs no file at all: **typed getters**, the twin of your strict getters for cardinality. `get_bool(:debug)`, `get_int(:port)`, `get_text(:version)` each read the spelling by their own notation and raise on a mismatch without touching the tree. `get_text(:version)` gives `1.0` whatever the default reading says.

Overlapping unions (`size = int | {0 small big}`): a vocabulary whose arms both read some spelling can be flagged when it loads, because for notations like these the overlap is computable. Then `<0>` or `"0"` picks the arm at the value.

## 5. A quoted or bracketed value at the start of text should stand alone

Today:

```udon
|p "Hello," she said.
|li [Docs](https://x.org) for more
|li <kbd>Ctrl</kbd> to copy
```
````tree
root
  |p
    :$main "Hello,"
    :$main ‹she said.›
  |li
    :$main [‹Docs›]
    :$main ‹(https://x.org) for more›
  |li
    :$main <kbd>
    :$main ‹Ctrl</kbd> to copy›
````

The quote marks are gone from the speech, the link is gone, and `<kbd>` is a typed value. My proposal: **a value is either exactly one delimited form standing alone (followed by a space and a start, a framed ` \ `, or the end of the line) or it is a run**, with the delimited form's characters kept as scanned:

````tree
root
  |p
    :$main ‹"Hello," she said.›
  |li
    :$main ‹[Docs](https://x.org) for more›
  |li
    :$main ‹<kbd>Ctrl</kbd> to copy›
````

```udon
|el :a "x" :b [1 2] :c <8080>    ; each stands alone: string, list, 8080
|el :a "x" y                     ; :a ‹"x" y›
|el :a "x" \ y                   ; :a "x", then $main ‹y›
|el :token <your-api-token>      ; alone, so a literal: error, did you mean \<your-api-token>?
```

That makes `:c "1" z` behave like `:c 1 z` (one text) instead of differently. It also crosses your 2026-10-21 lean that the residue after a self-ending value goes to `$main` ("perfectly fine … I think"), so it's yours to call. The decision waits only until the closer, which is on the same line and already held today.

## 6. What I'd ask you, as examples

1. `|server :debug false`, read with no schema: `false`, or the text `"false"`?
2. Should the default reading be exactly JSON's grammar plus `true`/`false`/`nil`, so that `01234` stays text and `0xFF` needs `<0xFF>`?
3. `|p "Hello," she said.`: one text, or a string stacked with a text?
4. Typed getters (`get_int`, `get_text`) as the API twin of your cardinality getters?
5. For lite 0.1, every labelled `<…>` an error, so that dates and composites are left wholly to full UDON?

## 7. Where I'm unsure

- The `false`-vs-`1.0` frequency judgment that decides question 1 is my own instinct as a writer, not a measurement.
- The scores (`10` §5, `20` §6, `30`, fork P §3) are one agent's hypotheses. The rankings I'd defend; the margins I wouldn't.
- Keys: whether `|step[1]` should get the default reading. I'd guess not, since keys compare by spelling, but I haven't pushed it.
- The trailing `:` on attribute names has no type role in this design. It's a pure question of looks: a name can't end in `:` if the ornament is allowed, which costs XML nothing. I leaned "ornamental, allowed" and left it to you.
- I read your messages in the span whole. The coordinator's summaries in it I read as framing only.
