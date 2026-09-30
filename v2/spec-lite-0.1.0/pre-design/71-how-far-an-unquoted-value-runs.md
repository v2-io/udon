# 71 — How far does an unquoted value run on a line?

## The question

When an attribute's value is written without quotes, where does it stop?

```udon
|task :title Fix the login page :owner sam
```

Is `title` the word `Fix`, the words `Fix the login page`, or everything to the end of the line (`Fix the login page :owner sam`)?

## Why lite must decide

This is the rule a reader applies to almost every line of a data document. It has been answered at least five different ways over UDON's history, and files 01, 02 and 03 all assume one answer (the current one) without restating it. The answer also decides how often authors must quote, and which everyday text (emoticons, URLs, Ruby/Elixir-style `:symbols`, times like `10:30`) collides with structure.

## What the texts say, in date order

- **2011, `udon-c/docs/DECIDED.md`:** an unquoted value "STOPS ON: dedented newline or space __plus__ `[|#.!:]`" — i.e. at the next space followed by a marker character. Same file: "Once data text has started on a line, pipes etc. are all treated literally like any other text."
- **2011, `udon/.attic/syntax2.udon` §"Implied attribute types":** "If it's only one word though, not quotes necessary. Also, if the attribute started on its own line, it can have multiple words up until the newline or a word starting with '.' or ':'." Example there: `|namespace:type … :mental-state crazy So true` → `mental-state = crazy`, children `["So true"]`.
- **Dec 2025, 0.7-draft (`_archive/SPEC.md` §Bare String Terminators):** on the element's line a value is **one space-delimited token** ("quote for spaces"); on an attribute's own line the value **runs to end of line**. So `|el :a x y z` gave `a = "x"` and `y z` as the element's text.
- **Jul 2026, 0.8.0:** block attribute lines keep "value to end-of-line (one attribute per block line)" (`spec/msc/CHANGELOG.md` 0.8.0 "Stranded second-attr").
- **2026-07-15, 0.9 "bare-token boundary rule"** (CHANGELOG 0.9.0-alpha.1): after one bare token, if a marker follows, the token was a single-token value; if plain text follows, the rest of the line becomes one text value ("blob") to end of line. So `:title Fix the login page :owner sam` → `title = "Fix the login page :owner sam"`.
- **2026-07-20, archived night session** (`v2/.archived/second-pass/spikes/session-vault/raw/grok/019f67df-orientation.md` L1572–1590, Joseph, verbatim, indentation as in the file):
  ```udon
  |el :summary val and this starts the text for el so :this-is-part-of-the-text yes
  |el
      :summary val and this starts the text ..... :this-is-partof...
  ```
  "Exact same behavior, no? Only a problem when:"
  ```udon
  |el :s "a b c d" e :still-text f ; el.children[0] == 'e :still-text f'
  |el
     :s "a b c d e" e :still-text f ; ERROR because two text values for one attribute
  |el
     :s "a b c d e" :xyz trailing text for :xyz value ; no problem
  ```
  The agent's restatement, which Joseph did not correct: "Letter-first bare value = one space-delimited token, then parent `el` owns the rest of the line." In that model the rest of the line is the element's **text**, and a later `:label` inside it is literal.
- **2026-08-08, K10** (`v2/DECISIONS.md`): an unquoted value "is a quoted string with a different closing delimiter": it ends at a space followed by a real marker (` :label`, ` |name`, ` @ref`, ` !name`, a fence, ` \ `), at a framed ` ; `, at end of line, or at `}`/`]` in those contexts. Joseph's words recorded with it: the old end-of-line greed existed to make sameline prose work, and "*this* was what my brain was remembering as the complications that same-line-is-value suddenly clarifies… fighting same-line user needs." 0.10.0 §6.4 carries K10.
- **2026-08-08 history note** (OPEN ESC-BREAKOUT, Joseph verbatim): "One of the primary uses of `\` was to break out of attribute-value pairs on sameline. We had to put it in place when we started associating the text with the most recent attribute instead of the prior 0.8 and earlier behavior … where `|e :a x y z` would assign 'x' as the value for `:a`, and 'y z' is the child text for `|e`. … when we changed it, it made it more visually coherent, but it became difficult to say 'and now the body line'."
- **Fresh-reader probe** (0.10.0 `working-notes/UNIF-PASS-QUESTIONS.md` Q3): a zero-context model read `|el :a 1 extra` as `a = "1 extra"` and `:note hello there :b 2` as one value swallowing `:b 2` — the end-of-line reading, not K10.
- **Real documents hit the collision** (2026-07-19 corpus cleanup, memorata `~/.claude.bak.2026-07-22/…9649850b….jsonl:1047`): `:actor-role == :accountant`-style Ruby/Elixir atom fragments in `design/examples/ash-like-*.udon` were re-read as attributes.
- **Old parser (evidence only, not an oracle):** `|el :a hello   world   :b 1` → one text value `"hello   world   :b 1   "` (the 0.9 blob rule).

## Alternatives

Each shows the same two lines.

```udon
|task :title Fix the login page :owner sam
|note :text see :foo for details
```

### A — one token (2011 on the element's line; 0.7; Joseph 2026-07-20)

The value is the first space-free token. What happens to the rest of the line splits two ways:

**A1 — the rest of the line is the element's text, markers in it literal** (Joseph's 2026-07-20 examples):

```text
document
├ element task
│   title "Fix"
│   $main "the login page :owner sam"   ; or a text child, per file 13 Q3
└ element note
    text  "see"
    $main ":foo for details"
```

**A2 — the rest of the line is scanned again** (further `:label`s are attributes, other words are the element's text):

```text
document
├ element task
│   title "Fix"
│   owner "sam"
│   $main "the login page"
└ element note
    text "see"
    foo  "for"                        ; one token again
    $main "details"
```

Multi-word values must be quoted: `:title "Fix the login page"`.

### B — to the next framed marker (2011 DECIDED.md; K10; 0.10.0)

```text
document
├ element task
│   title "Fix the login page"
│   owner "sam"
└ element note
    text "see"
    foo  "for details"
```

A word that looks like a marker ends the value unless escaped or quoted: `:text see \:foo for details`.

### C — to end of line

```text
document
├ element task
│   title "Fix the login page :owner sam"
└ element note
    text "see :foo for details"
```

Several attributes on one line then need quoting of every value but the last.

### D — to end of line on an attribute's own line, one token on the element's line (0.7; 2011 syntax2)

```udon
|task :title Fix the login page :owner sam      ; title "Fix", rest → element
|task
  :title Fix the login page :owner sam          ; title "Fix the login page :owner sam"
```

### E — the 0.9 split: one token if a marker follows it, otherwise to end of line

```udon
|task :title Fix :owner sam                      ; title "Fix", owner "sam"
|task :title Fix the login page :owner sam       ; title "Fix the login page :owner sam"
```

## Edge cases any alternative has to state

```udon
|el :url https://x.io/a?q=1;s=2 :b 1        ; unspaced : and ; inside a token
|el :t 10:30 :face :-) :ratio 3:1            ; emoticon " :-)" passes the : guard under B
|el :cmd make build ; run it                 ; framed " ; " — comment or value text?
|el :path C:\Users\me :x 1                   ; mid-token backslash
|el :a x  :b 1                               ; two spaces before the marker — trimmed?
|el :a "quoted" rest of words                ; quoted value then more words (see 73)
```

## Interactions

- [02](02-escape-inside-open-value.md): the escape rules are shaped by whichever extent rule is chosen; ESC-BREAKOUT (the framed ` \ `) exists because of the change from A to C.
- [01](01-sameline-element-child-or-value.md): under A and D the rest of the line goes to the element; that is where `|b` would land too.
- [03](03-semicolon-in-prose.md) and [78](78-what-a-comment-owns.md): whether ` ; ` ends a value.
- [80](80-which-spaces-are-content.md): whether spaces before a terminator belong to the value.
- [74](74-attribute-values-on-following-lines.md): whether an attribute's own line and the element's line follow one rule.
