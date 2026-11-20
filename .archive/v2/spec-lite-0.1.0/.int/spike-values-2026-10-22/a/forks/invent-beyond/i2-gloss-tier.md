# I2: the gloss tier — readings written on the line below, pointing up

*Invention fork `invent-beyond`, spike a, 2026-10-22. Invented first, judged after. Sources:*
- *linguistics' interlinear glossed text (a line of form, a line of glosses aligned word by word beneath it, Leipzig rules);*
- *corpus linguistics' **standoff annotation** (annotations kept apart from the text, pointing at its character offsets);*
- *the caret-and-tilde underline every agent knows from compiler diagnostics;*
- *the README's own "Tiers of Voice", which this would add a tier to.*

*Every caret column below was produced and checked by [gloss.py](gloss.py), not aligned by eye. Trees: `⸨…⸩` a «text», `#integer` the parser's class, `as x` a reading.*

## The idea

Keep the value line pure domain. Put the readings on their own line underneath, each caret pointing up at the first character of the value it reads:

```udon
|server[web] :port 8080 :timeout 30s :started 2026-07-21T14:20 ; prod
                   ^u16          ^dur         ^datetime
```
````tree
root
  |server
    :$key ⸨web⸩
    :port ⸨8080⸩ #integer as u16
    :timeout ⸨30s⸩ as dur
    :started ⸨2026-07-21T14:20⸩ as datetime
      ; prod
````

**checked by gloss.py:** `^u16` sits at column 19, where `8080` begins; `^dur` at 33 (`30s`); `^datetime` at 46.

A gloss line is a line whose content is only `^reading` items. It glosses the nearest non-gloss line above it. A caret that doesn't sit on the first character of a value is an error that names the nearest one: "`^dur` at column 34 points at no value; `30s` starts at column 33." Several gloss lines may stack under one line, for readings that would collide.

### And in prose: typed spans with no markup in the prose at all

In prose, a caret alone doesn't know where its span ends. The plain caret's span came out as `2026-07-21.`, period included (**checked**). So prose takes the underline form, `^~~~~`, whose length is the span:

```udon
|p Doors open at 19:30 sharp, on 2026-07-21.
                 ^~~~~ time      ^~~~~~~~~~ date
```
````tree
root
  |p
    :$main ⸨Doors open at 19:30 sharp, on 2026-07-21.⸩
      standoff  cols 17–21 as time
      standoff  cols 33–42 as date
````

The text is untouched, Markdown and all (C3). The readings are standoff attachments on the text: offsets plus a reading, which change no arity and never split the text's pieces.

Close spans collide (**checked**: `^~ min` runs into `40.71,-74.00`), so they go on two gloss lines:

```udon
  The pump ran for 5m at 40.71,-74.00 before the 3rd stop.
                         ^~~~~~~~~~~~ geo
                   ^~ min
```

## The composite set (where the tier has something to say)

```udon
|part :zip 01234 :version 1.10 :commit 1234567 :id 1e10
           ^id            ^ver         ^sha        ^id
|decision :date 2026-07-21 :at 10:12 :window 60s
                ^date          ^time         ^dur
|job :timeout 5m :length 5m
              ^min       ^m
|ev :on 05-03-27
        ^dt[DD-MM-YY]
|reg :mask 0xff
           ^u64
```
````tree
root
  |part
    :zip ⸨01234⸩ as id
    :version ⸨1.10⸩ #decimal as ver
    :commit ⸨1234567⸩ #integer as sha
    :id ⸨1e10⸩ #decimal as id
  |decision
    :date ⸨2026-07-21⸩ as date
    :at ⸨10:12⸩ as time
    :window ⸨60s⸩ as dur
  |job
    :timeout ⸨5m⸩ as min
    :length ⸨5m⸩ as m
  |ev
    :on ⸨05-03-27⸩ as dt
      :$key ⸨DD-MM-YY⸩
  |reg
    :mask ⸨0xff⸩ as u64
````

The other items (K1, K3, K10–K13) are unchanged from the parent's lead: no gloss needed. Composite line C-c with a gloss: `|cfg :tags [1 two 2026-07-21]` with `^date` under the date (column 18; I first wrote 20 by hand, and the script caught it, which is A2's cost in miniature). The list's items stay plain, and the reading points into the list.

## What I find beautiful in it, and why

- **Two tiers, each pure.** The value line is exactly what a domain expert writes. The gloss line is exactly the plumbing, and you can stop reading at it. This is Joseph's "Tiers of Voice" taken one step further, and the beauty he named in the CTQ footnote: "ornament such as alignment", "constraints such as meaningful indentation".
- **The caret is honest.** It points. There is no question which value a reading belongs to, because you can see the arrow. A compiler diagnostic is the most-read form of this in any agent's training.
- **Typed spans in prose, with the prose untouched.** No other design here can say "this `19:30` is a time" inside a Markdown paragraph without changing the paragraph. I find that a little magical.
- **It's what a careful human annotator does.** Proof marks in the margin; a linguist's gloss under the line; a teacher's underline with a word written under it.

## Then the weighing (CTQ-FACTORS, Beauty first; hypotheses, low-to-medium confidence)

| Factor | Δ vs the parent's lead | Basis |
|---|---|---|
| A1 agent-subjective | +1 | my taste says +2; I'd expect a panel split, since some will see clutter |
| A2 generative guessability | −2 | no agent would guess it, and writing it means counting columns exactly, the thing models do worst. UDON already bets on column-exact writing (sameline children under `\|b`), but this bet is bigger. |
| A3 cold comprehension | +1 | a caret pointing at a value needs no teaching |
| A4 agentic readability | −1 | reading which caret sits under which value means counting columns too |
| A5 domain-forward | +2 | the value line is pure domain |
| A6 spec clarity | −1 | a new tier, a column-attachment rule, the underline form |
| A7 syntactic simplicity | −1 | a new line kind |
| A8 parsimony | −1 | spends `^` as a line start, plus `~` |
| A9 conciseness | −1 | an extra line |
| B1 bounded streaming | 0 | a value's reading arrives one line later: bounded by a line, an attachment after the fact |
| B3 stability | 0 | misalignment is an error, never a silent re-attachment |
| B4 errors that teach | +1 | "points at no value; `30s` starts at column 33" |
| B6 headroom | −1 | `^` at a line start must be reserved now if it's to mean this later |
| C3 Markdown in prose | +1 | typed spans with the prose untouched |
| C10 round-trip / editing | −1 | edit the value line and the carets must move; an edit tool has to maintain them (D1) |

**My honest read:** the most beautiful idea here on A5 and C3, and the costliest on A2 and editing. It might be right as a *reader-layer* convention (a linter that offers glosses, a view that renders them) before it's right as lite syntax. The standoff half, attachments by offset that never touch the text, is worth keeping in any design that ever types prose.

**Unfinished:** wide characters before a caret. **checked:** `№` and some subscript digits are East-Asian-width Ambiguous, so a column count and a display column can disagree. Lite counts columns in characters ([[rule:columns-count-spaces]] counts spaces for indentation; past that, one character is one column is an assumption). A gloss line under CJK text would need that settled.
