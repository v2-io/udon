# W3. The quote ladder: quoted means "itself", bare means "the reader decides"

*Wildcard fork, spike a. Status: **alive**, as a frame for the spec's wording rather than a syntax change. It overlaps the classification work (DP1, DP3) in sibling forks; what's mine here is the semantics, not the mechanism.*

## The idea

Joseph's first distinction in the span is Lisp's quote: keep something as itself, or resolve it. Lite already has three spellings for a value, and they line up as three levels of commitment:

| Spelling | What the writer is saying | Who may give it meaning |
|---|---|---|
| `"8080"` / `'8080'` (quoted) | "this is exactly these characters" | nobody: it is a string, never classified, never resolved by alias |
| `8080` (bare) | "this is the domain's word for it; you know what it means" | readers: the default reading (the standard set), a slot type, a vocabulary (`ssh` → 22) |
| `<8080>` or `|{u64 0xff}` (declared) | "I am telling you what it is" | the writer, checked by lite (the standard set) or by a dialect |

Under this, the «string» / «text» split stops being a puzzle about forms ("is bare `hello` a string of form bare?") and becomes a statement about intent: **a bare run is open, a quoted string is closed.** That is why a bare run is a «text» and not a string: it is waiting for a reader.

## Why I think it's more than wording

- **It explains his current lean from the inside.** C with the view isn't "lite refuses to type numbers": a bare run is open by definition, the view is the reader every consumer gets for free, and a schema is a better-informed reader. `:port 8080` that "I haven't turned into a number yet" (his words, 2026-10-21) is exactly an open value.
- **It gives identifier safety (K2) a one-line teaching rule:** quote what must not be interpreted. `:zip "01234"`, `:version "1.10"`, `:sha "1234567"`. Every YAML-trained agent already knows the move. YAML quoted scalars are never tag-resolved (**from memory**, YAML 1.2 §10.3: resolution applies to plain scalars only). YAML's trouble was its default reader (a large set, `no`, octal), not the ladder; lite's default reader is tiny.
- **It gives aliases (K7) their place:** `:port ssh` is open, so a slot vocabulary may resolve it; `:port "ssh"` is the writer saying "the string ssh", and a strict slot may refuse it.
- **It makes his gotcha principled:** `:width 7 ;{px}` stays text because the run isn't a bare spelling of one thing (a piece is a comment), so the default reader declines it. It isn't an accident of the rule.

## Composite lines under it

```udon
|server[web] :port 8080 :host "web-01" :backup nil
|pkg :zip "01234" :version "1.10" :count 3
|p Chapter 3: The Return
```
````tree
root
  |server
    :$key ‹web›
    :port ‹8080›          ← open; default reader: 8080
    :host "web-01"         ← closed
    :backup ‹nil›         ← open; default reader: nil
  |pkg
    :zip "01234"
    :version "1.10"
    :count ‹3›            ← open; default reader: 3
  |p
    :$main ‹Chapter 3: The Return›
````

## Costs and edges

- **K10, the word `nil` in a sentence.** `:say nil` is open, so the default reader makes it nil. To get the word, quote it: `:say "nil"`. Under the ladder that is correct; whether it surprises depends on how often a bare lone `nil` is meant as a word. My instinct: rarely.
- **Generative guessability (A2).** Agents quote to force strings already; that move costs nothing to learn. The risk is the other way: an agent writing `:port "8080"` from JSON habit gets a string where a number was meant. That's a silent miss for a schema-less reader, and the same miss JSON itself has.
- **It doesn't decide DP1.** Whether the default reader's result lives in the raw tree (B), as an attachment (C+class) or in a view (C+view) is still open; the ladder fits all three. It only says the reader acts on bare runs and never on quoted ones.

## For the spec, if it's taken up

One sentence for [[def:string]] and [[def:text]]: a «string» is a value written as itself; a bare run is a «text» a reader may read as something more. Lite reads nothing (B2-safe); the default reading is the reader lite specifies for consumers who have no schema.
