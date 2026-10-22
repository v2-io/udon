# Branch page: what a delimiter at the start of a value commits (D2, the `$main` side)

*Spike b, 2026-10-22. Raised independently by fork P (§4 item 7) and by me (E6). Frequency claims here are my own writing instinct, not counts from the corpus (Joseph's note).*

## The cases

Each of these, as the cards read today, splits at a value-initial delimiter ([checked] [[rule:unquoted-run-is-one-value]] Statement 1 lists `"`, `'`, `<`, `[` as delimiters; [[rule:leftover-values]] stacks what follows):

```udon
|p "Hello," she said.
|li [Docs](https://x.org) for more
|li <kbd>Ctrl</kbd> to copy
|li '90s music, mostly
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
    :$main <kbd>              (raw-carry card; an error under a strict interior)
    :$main ‹Ctrl</kbd> to copy›
  |li
    ERROR: unclosed single-quoted string
````

The quote marks of `"Hello,"` become delimiters and are gone from the content. Joining the stack back into display text gives `Hello,` + `she said.`: speech without its quotes. The Markdown link is destroyed silently. I can't think of a writer who would mean either reading. [instinct, high confidence] Every one of these is text a writer would put at the start of a line item or paragraph.

## Branches

### δ1: delimiters commit wherever a value starts, and the residue stacks (current cards and Joseph's 2026-10-21 lean, "perfectly fine … I think")
Gives the trees above. **Kept as the incumbent.** Cost: C2 and C3 (silent loss of quotes and links), A3.

### δ2: `$main` never commits at a delimiter; only attribute values do
`|p "Hello," she said.` is all text, while `:caption "Hello," she said.` still splits. This breaks the sameness of element and attribute samelines, which was the reason for `$main` ("fully consistent 'sameline' behavior whether the line started with an element or an attribute", 2026-09-29). **Pruned** on that ground, and on A6.

### δ3: a delimited value must stand alone; otherwise the whole run is text (proposed)
Rule: **a value is either exactly one delimited form, followed by the end of the value (a space and a start, a framed ` \ `, or the end of the line), or it is a run.** A delimited form followed directly by more material is not a delimited value. The material is a run, and the delimiter characters are content.

```udon
|p "Hello," she said.
|li [Docs](https://x.org) for more
|el :a "x" :b [1 2] :c <8080>
|el :a "x" y
|el :a "x" \ y
```
````tree
root
  |p
    :$main ‹"Hello," she said.›
  |li
    :$main ‹[Docs](https://x.org) for more›
  |el
    :a "x"
    :b [‹1› ‹2›]  ⇒ [1 2]
    :c 8080
  |el
    :a ‹"x" y›
  |el
    :a "x"
    :$main ‹y›
````

Pushed toward its implications:

- **One rule everywhere, strengthened.** Today `:c 1 z` is one text (the run rule) but `:c "1" z` is two values. Under δ3 both are one text: residue on a value's line joins the value, whatever the value began with. The two value shapes become parallel instead of special-cased. [inferred]
- **No re-scan (a precision the rule needs).** The delimited form is always scanned by its own rules, so `"a :b c" d` keeps ` :b` inert inside the quotes. If the form doesn't stand alone, the run *begins with* its characters exactly as scanned and continues from the closer. Otherwise, a run read from the first character would have ended at ` :b`, and the shape would depend on the decision at the closer. With this precision, nothing before the closer depends on it: `:a "a :b c" d` gives `:a ‹"a :b c" d›`. [inferred]
- **Escapes stay compatible.** [checked] The proposed value-line escape set includes `"`, `'`, `[`, `<` ([[rule:value-line-escapes]]). Inside a string, `\"` is the quote character; in a run, `\"` is also the quote character. So `"a\"b" c` gives the same characters whichever way the decision goes, and only the outer quote marks' status (delimiter or content) waits on it.
- **Streaming.** The decision is made at the closer plus one character. The closer is on the same line (strings, lists and `<…>` must close on their line), and the parser holds the span until its closer today anyway ([ran] fork S). So δ3 adds no holdback beyond the line, the same bound as the `[key]` HOLD that already exists. B1 passes, provided the parser can mark a held string as "run after all". On a kind-first wire this is one more HOLD/RELEASE use. [inferred]
- **What δ3 does not fix:** `|li '90s music, mostly` has no closing `'` on its line, so it is still an unclosed-string error, as today. I'd keep it that way: a run-on-no-closer rule would turn every genuinely unclosed string into a silent text. The error can teach: "did you mean `\'90s`?" [inferred]
- **Lists.** `:tags [a b] extra` becomes a text. That's right, I think: it can't have been meant as two values. [taste]
- **What it costs.** A writer who meant `"x"` and then a stacked `y` on the same line has to write ` \ ` between them, which is the spelling already ruled for stacking (`|el asdf \ ghijk`, Joseph 2026-10-21). That writer is rare. [instinct]
- **Cards it touches:** [[rule:leftover-values]] (its example inverts; its Statement narrows to values separated by ` \ ` or by a start); [[rule:unquoted-run-is-one-value]] (Statement 1: a delimiter starts a value only if the delimited form stands alone); [[def:main]] and [[def:prose]] (their `|q "Hello," she said` examples invert; def-prose's three-way point survives); [[rule:adjacent-quoted-strings]] (`"a""b"` is now a run `"a""b"`, not two strings with a warning; worth a look); Joseph's 2026-10-21 lean on the residue after a self-ending value.

### δ4: the residue is an error ("a quoted value followed by more text; did you mean `\"Hello,"`?")
Errors over guesses (B3, B4). But it makes the most ordinary prose (`|p "Hello," she said.`) an error that every writer will hit. **Pruned** on A2: an error on the thing everyone writes is a guessability failure, not a teaching moment.

## Scores [hyp]

| Factor (weight) | δ1 commit + stack | **δ3 stand alone** | basis |
|---|---|---|---|
| A2 guessability (10) | 5 | **8** | writers don't expect a leading quote to change the kind of a sentence |
| A3 cold comprehension (10) | 5 | **8** | a reader of `|p "Hello," she said.` sees one sentence |
| A6 spec clarity (9) | 7 | **8** | "one delimited form, or a run" |
| A7 simplicity (8) | 8 | **7** | one more check at the closer |
| B3 stability (10) | 9 | 9 | |
| C2 XML/HTML (10) | 5 | **9** | mixed content keeps its punctuation |
| C3 Markdown (9) | 4 | **9** | links and quotes at the start of a value survive |
| weighted | 383 | **537** | |

Confidence moderate. The case rests on instinct about what writers mean, which per Joseph's note is the right evidence here. The cost side (the rare writer who wanted two values) is small and has a spelling.

## Put to Joseph as one question

`|p "Hello," she said.`: one text with its quote marks, or a string `Hello,` stacked with the text `she said.`?
