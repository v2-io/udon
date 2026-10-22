# I2–I6: the other typographic inventions

*Invention fork (typography), spike a, 2026-10-22. Each one is invented and rendered first, then I say what I find beautiful, then weigh it. Tree glyphs as in [i1-readings.md](i1-readings.md).*

---

## I2. Meaning brackets `⟦…⟧`: what `<…>` becomes when it stops looking like HTML

**Source.** In denotational semantics, `⟦e⟧` (Scott, or "Oxford", brackets) means *the meaning of e*. The glyph is U+27E6/7, MATHEMATICAL WHITE SQUARE BRACKET, narrow (checked).

**The invention.** Everything the angle fork's lead gave `<…>`, but spelled `⟦…⟧`, so that `<` goes back to being an ordinary character on a value line:

```udon
|server[web] :port ⟦8080⟧ :backup ⟦⟧ :when ⟦date 2026-07-21⟧ :reg ⟦u64 0xff⟧
|ev :on ⟦dt[DD-MM-YY] 05-03-27⟧ :note a <b>bold</b> claim :slot <placeholder>
|cfg :tags [1 two ⟦date 2026-10-22⟧]
```
````tree
root
  |server
    :$key ⸨web⸩
    :port ⸨8080⸩ #integer ✓
    :backup nil
    :when notation date ⟬2026-07-21⟭
    :reg notation u64 ⟬0xff⟭
  |ev
    :on notation dt
      :$key ⸨DD-MM-YY⸩
      ⟬05-03-27⟭
    :note ⸨a <b>bold</b> claim⸩          ← HTML in a bare value is just text again
    :slot ⸨<placeholder>⸩
  |cfg
    :tags [⸨1⸩ #integer ⸨two⸩ notation date ⟬2026-10-22⟭]
````

The notation head is separated by a plain space, not `: `. Inside `⟦…⟧` there's no HTML or URL prior to collide with, so `⟦today⟧` (one word, no body) can simply be an error: "a notation needs a body".

**What I find beautiful.** The bracket *says what it does*: "the meaning of". It ends `<…>`'s worst collision, with every agent's strongest prior for angle brackets (an HTML tag, a `<placeholder>`). Without that collision, the error-heavy closed design isn't needed to protect against it. White brackets look like a container for something held apart, which is what a notation body is.

**Weighed.** Beauty high (A1 8). A5 7: the plumbing still leads the value. A2 4 from zero exposure, but nothing collides. B6 good: `<` is returned. A4 8: very distinct from `[`. One cost the spike's tree notation must absorb: Joseph had listed `⟦ ⟧` among candidate glyphs for the tree, so if lite takes it, the tree can't. I1's readings beat it on domain-forwardness; I2 is the better choice if Joseph wants the notation name to come first, as streaming prefers.

---

## I3. Quine corners `⌜…⌝`: mention, not use

**Source.** Logicians mark the use/mention distinction typographically. Quine's corner quotes, `⌜…⌝`, mean "this expression, as an expression". The UCD's own chart heading for U+231C/D is "Quine corners" (checked).

**The invention.** Joseph's first distinction, "Quoted vs unquoted (Lisp's quote): keep a reference or a value as itself, or resolve it", gets its own glyph instead of overloading `<…>` (`@{<…>}`):

```udon
|cite :source @{jw/papers/inquiry} :link ⌜@{jw/papers/inquiry}⌝
|tmpl :greeting ⌜Hello, |{name}!⌝
```
````tree
root
  |cite
    :source ⸨@{jw/papers/inquiry}⸩              ← a reference: a reader resolves it to its referent
    :link mention ⟬@{jw/papers/inquiry}⟭        ← the reference itself, held, never resolved
  |tmpl
    :greeting mention ⟬Hello, |{name}!⟭          ← UDON held as UDON, unparsed
````

**What I find beautiful.** It is the one bracket whose meaning has been fixed since Quine introduced it (his *Mathematical Logic*, 1940, from memory, unchecked) and is exactly the job: *this, mentioned, not used*. The angle fork found that quoting is a different kind of job from the other six it lists for `<…>`, and should get its own spelling. This gives it one, without spending ASCII.

**Weighed.** A1 8; A3 6 (logicians recognize it, others won't); C9 composition and references gain; B6 good. Small scope, so a small risk. It probably belongs to full UDON's references more than to lite 0.1, but it would let lite drop `@{<…>}` from its open questions.

---

## I4. Typeset numerals: numbers the way they're printed, which no identifier ever looks like

**Source.** Typeset mathematics and engineering.

**The invention.** The standard set takes printed number forms that can't collide with identifiers, in place of the forms that do:

| Printed | Means | Replaces |
|---|---|---|
| `22⁄7` | a rational (U+2044 FRACTION SLASH, "for composing arbitrary fractions") | `22/7r` |
| `6.02×10²³` | scientific notation | `6.02e23` |
| `ff₁₆`, `1010₂`, `755₈` | a base, written as a subscript | `0xff`, `0b1010`, `0o755` |
| `1920×1080` | a pair, or dimensions | REBOL's `1920x1080` |
| `12°34′56″` | an angle or coordinate | none |

```udon
|part :id 1e10 :avogadro 6.02×10²³ :ratio 22⁄7 :mask ff₁₆ :screen 1920×1080
```
````tree
root
  |part
    :id ⸨1e10⸩                     ← no `e` exponents in the set: an id is never a float
    :avogadro ⸨6.02×10²³⸩ #decimal
    :ratio ⸨22⁄7⸩ #rational
    :mask ⸨ff₁₆⸩ #integer
    :screen ⸨1920×1080⸩ #pair
````

**What I find beautiful.** It turns the identifier problem (DP3) around. The forms that bite identifiers (`1e10`, `0x…`-looking hashes, `1/3`) are ASCII shapes that ids also take. Typeset forms are shapes *only numbers* take: no zip code, SHA or version contains `⁄`, `×` or `₁₆`. The classifier gets safer as it gets richer. And the values look like what they are.

**Weighed.**
- A1 8; A3 9 (every model reads `6.02×10²³` correctly).
- A2 3: nobody writes `ff₁₆` unprompted.
- C1 cost: lite → JSON no longer copies numbers byte for byte, so the host guide has to convert them.
- A real column hazard: `₁ × ² ° ′` are East-Asian-*ambiguous* width (checked), so before a sameline element they can make the visual column differ from the counted one. That gap in the cards ("how a column counts after non-ASCII characters") would need closing first.
- Host portability fails for rationals and pairs, which the classification fork's membership tests reject.

My keep from it is one move: **drop `e` exponents from the bare set and offer `×10ⁿ`** (the classification fork's "S-JSON−e" branch, made beautiful instead of merely restrictive).

---

## I5. Glyph sigils: the picture *is* the type (strange)

**Source.** Pictographic labels on maps and forms, and Elixir sigils (`~D[…]`) taken to their visual end.

**The invention.** One glyph before the value names its notation, so it is known at the first character:

```udon
|decision :date 📅2026-07-21 :at 🕙10:12 :window ⏱60s :stamp 📅2026-07-21T14:20
|job :timeout ⏳5m :length 📏5m
|misc :color 🎨3221f9 :price 💲9.99 :at 📍40.71,-74.00
```
````tree
root
  |decision
    :date notation 📅 ⟬2026-07-21⟭
    …
  |job
    :timeout notation ⏳ ⟬5m⟭     ← minutes: the hourglass completes the unit
    :length notation 📏 ⟬5m⟭      ← meters: the ruler does
````

**What I find beautiful.** `⏳5m` against `📏5m` is the most legible disambiguation of the unit problem I've seen: no reader of any kind needs it explained. Cold comprehension is close to perfect, and streaming is perfect.

**Weighed, and where it breaks.**
- It is an **open vocabulary**, against Parsimony's "small, well-chosen set". Who decides that `📅` means an ISO date and not some other calendar?
- The glyphs are **wide** (📅 ⏳ 📏 🕙, checked). `⏱` has no Emoji_Presentation, so it renders as text or emoji depending on a variation selector: an invisible difference.
- Judges will split on A1 (playful, or unserious). I can't make it beautiful enough to survive B3 stability and A8 parsimony.

**Dead as a notation.** One thing survives: an error that sees `📅2026-07-21` can say "did you mean `2026-07-21⟪date⟫`?". Agents will write emoji sigils sometimes, and a teaching error is cheap.

---

## I6. The narrow no-break space: SI's own unit binder (dead, with a finding)

**Source.** SI typography puts a space between a number and its unit (`5 m`), and fine typesetting uses U+202F NARROW NO-BREAK SPACE so they never split.

**The invention.** `5 m` with U+202F would be a quantity, while `5 m` with an ordinary space is just a text.

**Why it dies.** It is the most typographically correct idea here and the least visible. In plain text an agent can't see the difference, so A4 is near zero and every miss is silent.

**The finding I keep:** typographic correctness that a plain-text reader can't see is anti-beauty for this notation. Every mark in lite should be visible as a different shape: `⟪` and `⟦` pass, U+202F fails, and `«` vs `⟪` is borderline.
