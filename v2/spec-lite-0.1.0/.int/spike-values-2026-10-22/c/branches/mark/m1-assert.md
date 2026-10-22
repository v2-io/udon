# M1 — `<…>` asserts one portable kind, and nothing else

*Sub-branch of the mark family. Alive.*

## The rule, as it would be carded

1. `<` where a value is expected opens an **explicit value**. Its interior, between optional spaces (ornament), MUST be exactly one of: `nil`; `true`; `false`; a number in the standard numeric notation (its spelling is the `core` fork's: D4); a «delimited-string»; or nothing. `<>` is nil (Joseph's lean, 2026-10-22).
2. The kind is committed at the interior's first character: `n` nil, `t` true, `f` false, a digit, sign or `.` a number, `"` or `'` a string, `>` empty. Any other first character, or a mismatch later, is an **error** that says what was probably meant (B4).
3. A name before a colon (`<date:…>`), a `{` (`<{…}>`) and every other interior are errors: reserved for a later UDON.

## What it asserts

The writer says: "this is the integer 8080, not the text `8080`." The parser checks the claim, so a wrong mark fails loudly. That is all the mark means. It names nothing, so it can't be misread as a type system.

## Composite set (`../../composite-examples.md`)

```udon
|server :name web :port <8080> :host localhost :tls <true> :retries <3> :ratio <0.5>
  :zip 01234
  :version 1.10
  :note <>
|book :title 1984 :year <1949> :price <9.99>
|book :title 1984 is a novel
|post :tags [<1> <2> three]
  |step[1] Mix
|n :big <12345678901234567890123> :hex <0xFF> :sci <1e10> :negz <-0>
|e :empty "" :off <false> :old null
|t :when 2026-01-10 :at 2026-01-10T14:30Z :timeout 30s :span P1Y2M :born 27-03-05
|u :width 920px :timeout 5m :length 5m :share 50% :size 1.5GB
|p :port ssh
|p :port 22
|x :addr <0x73DDF>
|a :href https://example.com Click here
|li \<https://example.com>
|li \<= 5 items
|img :alt 5 < 6
|h1 Chapter 3: The Return
|m :width 7 ;{px} :height 7 ; px
```
````tree
root
  |server
    :name ‹web›   :port 8080::int.angle   :host ‹localhost›   :tls true::bool.angle
    :retries 3::int.angle   :ratio 0.5::float.angle
    :zip ‹01234›   :version ‹1.10›   :note nil::nil.angle
  |book  :title ‹1984›   :year 1949::int.angle   :price 9.99::float.angle
  |book  :title ‹1984 is a novel›
  |post  :tags [1::int.angle 2::int.angle ‹three›]
    |step  :$key ‹1›   :$main ‹Mix›
  |n  :big 12345678901234567890123::int.angle   :hex 0xFF::int.angle   :sci 1e10::float.angle   :negz -0::(core fork)
  |e  :empty ""::string.dq   :off false::bool.angle   :old ‹null› + warning "did you mean <nil>?"
  |t  :when ‹2026-01-10›   :at ‹2026-01-10T14:30Z›   :timeout ‹30s›   :span ‹P1Y2M›   :born ‹27-03-05›
  |u  :width ‹920px›   :timeout ‹5m›   :length ‹5m›   :share ‹50%›   :size ‹1.5GB›
  |p  :port ‹ssh›
  |p  :port ‹22›
  |x  :addr 0x73DDF::int.angle
  |a  :href ‹https://example.com Click here›      ← the run reaches the end of the line; no $main
  |li :$main ‹<https://example.com>›   (the escaped `<` is text; the backslash is consumed)
  |li :$main ‹<= 5 items›
  |img :alt ‹5 < 6›
  |h1 :$main ‹Chapter 3: The Return›
  |m  :width ‹7 ;{px}›   :height ‹7› ; comment ‹px›
````

| Item | Verdict |
|---|---|
| E1 | renders with plumbing: 5 marks for 5 non-text values. **No trap**: `01234` and `1.10` stay text unless marked, which is the classic YAML failure avoided (YAML 1.1's `3.10` → 3.1 and leading-zero octal are documented field experience, not corpus). |
| E2 | renders. `:title 1984` is the title. |
| E3 | renders with plumbing (a mark per item). A list mixing marked and bare items is legal and reads honestly. |
| E4 | renders; how big integers map to hosts is the core fork's host mapping guide. `NaN` has no spelling unless the core fork gives it one; written as text it stays text. |
| E5 | renders. `null` → text with the existing warning, which should now suggest `<nil>` or `<>`. |
| E6, E7 | **text only.** M1 can't attach a notation, so `5m` minutes and `5m` metres are the same text; only a slot (an external schema, or M3) tells them apart. Honest, not wrong: lite's tree doesn't claim a meaning it can't check. |
| E8 | renders as text both times; the union `u16 \| standard-port` is a schema's job. A writer can mark `<22>` to force the integer arm. |
| E9 | the value renders (`<0x73DDF>`, if hex is core); the storage type (Rust i64) has no place, which I count as right: A5 says the plumbing between domain and machine shouldn't show. |
| E10 `\|a` | **silent near-miss, a cost of the bare-run rule ([[rule:unquoted-run-is-one-value]] §1), not of any mark:** an HTML-trained writer who puts attributes first, `|a :href https://example.com Click here`, gets `href ‹https://example.com Click here›` and no `$main`, because `Click` isn't a start. The link text has to go first (`|a Click here :href https://example.com`) or the run has to be ended (` \ `). |
| E10 `\|li` | **near-miss caught, not silent**: `|li <https://example.com>` and `|li <= 5 items` unescaped are errors ("a value starting with `<` is an explicit value; to write text, escape it: `\<`"). The escape is already in [[rule:value-line-escapes]]'s proposed set. |
| E11 | unaffected by marks. |
| E12 | see [d7-trailing-colon.md](d7-trailing-colon.md). |

## Implications for the other rules

- [[rule:opaque-span-raw-text]] loses `<…>`: it is no longer opaque, it has a small interior grammar. `@{…}` and `;{…}` keep the raw rule. `<…>` gets its own card; [[rule:opaque-span-escapes]], [[rule:matched-pairs-need-no-escape]] and [[rule:newline-in-opaque-span-is-error]] drop it (a delimited string inside carries its own escapes; `<"a>b">` needs no `\>`, because the string closes first). [[def:opaque-span]] and [[def:typed-value]] are rewritten: «type-label» has nothing to name.
- [[rule:reserved-spellings]] gains `<name:`, `<{` and every other non-primitive interior (all one row: "anything inside `<…>` but a primitive").
- [[rule:nil-spelling]]: the warning for bare `null` suggests `<nil>`/`<>` under the bare-run lean.
- Joseph's 2026-10-21 `<920px>` "error I can understand" and `<uint32|0x992BC>` "error- reserved for now" are exactly M1. His 2026-10-20 option, carrying other interiors raw, is M2r (dead: fails B2, see branch.md).
- Impact radius: about eight cards, all `provisional` or `lean` except [[rule:opaque-span-raw-text]]'s 2026-10-08 raw-text call for `<…>` (his "I vote", which he reopened himself on 2026-10-20 and 2026-10-22).

## Scores and basis (hypotheses)

- **A2 6.** Instinct: writing data, I'd type `:port 8080` and not think of `<8080>`. Under the bare-run lean that gives text, which the typed-primitive view recovers, so the miss is soft. I'd guess `<nil>` and `<true>` once I'd seen `<8080>`.
- **A3 7.** Instinct: `<8080>` reads as "something special about this value". The hazard is the man-page placeholder reading (`:file <path>`), and M1 errors on that, so it is caught, not silent.
- **A5 5.** Marks are plumbing: they say "integer", not anything about the domain.
- **A6 9, A7 9.** One small card; the interior grammar is the core set's spelling, which the spec needs anyway.
- **B4 9, B6 10.** Every collision is an error with a fix; spends nothing new (`<` is already lite's).
- **C2/C3 7.** The tax is one escape on sameline text that starts with `<` (inline HTML in a list item, an autolink, `<=`). Prose lines are untouched, since `<` only matters where a value starts.
- **C4 3, C6 3.** No notations and no dialects in lite. That is the cost.

Confidence: medium on the robustness rows, low on A2/A3 (no panel).
