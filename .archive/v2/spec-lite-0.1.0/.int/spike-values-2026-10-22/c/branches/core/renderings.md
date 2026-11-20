# Composite renderings: the core branch

*E1, E4–E8 from `../../composite-examples.md`, in this branch's recommendations: the strict standard numeric notation, K1 keywords, `<>` as nil, U1 units, dates not core.*

**Assumptions borrowed from siblings, flagged:** D1 is shown under the coordinator's lean (Cv: a bare run is a «text» in the tree; the typed-primitive view reads the core spellings), with the B reading noted where it differs (B puts the same classification in the tree). D2 is assumed as "inside `<…>` the standard notation applies; anything else is an error for now", which is the `mark` fork's to settle. Tree notation: `::kind.form` on every scalar, as the 2026-10-21 handoff has it; `view→` shows what the typed-primitive view gives.

## E1 server

```udon
|server :name web :port 8080 :host localhost :tls true :retries 3
  :ratio 0.5
  :zip 01234
  :version "1.10"
  :note <>
```
```tree
root
  |server
    :name     ‹web›::text.bare
    :port     ‹8080›::text.bare        view→ 8080::int.dec
    :host     ‹localhost›::text.bare
    :tls      ‹true›::text.bare        view→ true::bool
    :retries  ‹3›::text.bare           view→ 3::int.dec
    :ratio    ‹0.5›::text.bare         view→ 0.5::float
    :zip      ‹01234›::text.bare       (not a number: leading zero)
    :version  "1.10"::string.double
    :note     nil::nil.angle
```
**Renders.** Plumbing: two marks (`"1.10"`, `<>`), both where JSON would also need something. **Near-miss traps:** `:version 1.10` → view gives 1.1, lossy at schema-less conversion (a JSON writer's habit of quoting versions applies); `:zip 01234` is safe *because* of the leading-zero rule; `:note nil` would also work (view→ nil).

## E4 big and odd numbers

```udon
|n :big 12345678901234567890123 :mask 0xFF :sci 1e10 :neg -0 :bad NaN :nan <nan>
```
```tree
    :big   ‹12345678901234567890123›::text.bare   view→ 12345678901234567890123::int.dec  (host: bigint, or a range error from a strict getter)
    :mask  ‹0xFF›::text.bare                      view→ 0xFF::int.hex
    :sci   ‹1e10›::text.bare                      view→ 1e10::float
    :neg   ‹-0›::text.bare                        view→ -0::int.dec
    :bad   ‹NaN›::text.bare                       (text)
    :nan   ERROR (if `<…>` has no `nan`)  or  nan::float.angle (if the mark branch admits it)
```
**Renders**, except NaN, which has no core spelling; whether `<nan>` exists is the mark branch's call (my lean: admit `<nan>`, `<inf>`, `<-inf>` inside the mark only).

## E5 empties

```udon
|e :a <> :b "" :c false :d null
```
```tree
    :a  nil::nil.angle
    :b  ""::string.double
    :c  ‹false›::text.bare   view→ false::bool
    :d  ‹null›::text.bare    ⚠ warning: `null` is not lite's nil; did you mean `nil`?
```
**Renders.** `:a nil` would serve as well via the view.

## E6 temporal (not core)

```udon
|t :on 2026-01-10 :at 2026-01-10T14:30Z :wait 30s :span P1Y2M :due 27-03-05
```
```tree
    :on    ‹2026-01-10›::text.bare
    :at    ‹2026-01-10T14:30Z›::text.bare
    :wait  ‹30s›::text.bare
    :span  ‹P1Y2M›::text.bare
    :due   ‹27-03-05›::text.bare
```
**Renders as text only; meaning by slot.** A schema that says `due` is a date in `YY-MM-DD` reads 2027-03-05; nothing literal-side could, because the century is a parameter (test 1). `<2026-01-10>` is an **error** under the assumed interior rule, until a named date notation exists (mark branch). Honest cost: C4 is met only through slots in 0.1.0.

## E7 units

```udon
|box :width 920px :timeout 5m :length 5m :fill 50% :size 1.5GB
|box :width-px 920 :timeout-s 300
```
```tree
  |box
    :width    ‹920px›::text.bare
    :timeout  ‹5m›::text.bare
    :length   ‹5m›::text.bare
    :fill     ‹50%›::text.bare
    :size     ‹1.5GB›::text.bare
  |box
    :width-px   ‹920›::text.bare   view→ 920::int.dec
    :timeout-s  ‹300›::text.bare   view→ 300::int.dec
```
**Renders as text; the slot decides `5m`.** The second line is the unit-in-name convention (U4). Near-miss trap: none in the tree; `<920px>` is an error that can suggest `920px` (text) or a named notation once one exists.

## E8 algebraic name

```udon
|svc :port ssh
|svc :port 22
```
```tree
  |svc
    :port  ‹ssh›::text.bare
  |svc
    :port  ‹22›::text.bare   view→ 22::int.dec
```
**Renders, and shows why slot-first fits.** The domain's `port = u16 | {smtp, ssh, http, …}` is a slot type: a reader expecting `port` tries u16 by the standard notation and then the vocabulary. A literal-side rule can't express "this word is a member of a vocabulary I don't know"; the bare text plus slot does it with zero plumbing (A5). Under B, `22` is an int in the tree and `ssh` a text, and the slot-typed reader accepts both: the same result, so E8 doesn't discriminate D1. It does show the view must never *reject* text, only offer a reading.
