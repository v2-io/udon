*Saved by the coordinator from the agent's returned message. The harness refused the agent's own write; offered a renamed file, the agent declined, judging a renamed findings file to be a way around the block rather than a way of honoring it. Content as returned.*

# Report: Sonnet 5.5, BASICS-only ("fresh")

I wrote the full COLD answers into a refused Write call before I opened `OPTIONS.md`; the "as first written" text below is copied from it. Nothing was committed or edited, and no other report was read.

## 0. Exposure

- **Files read:** `BASICS.md`, `COLD.md` (before answering), then `OPTIONS.md` (after answering). I did not open the spec store or any other file in the trial directory.
- **Contamination I can't undo:** my session started in `~/src/arch/firmatum/udon`, so the harness auto-loaded that repo's `CLAUDE.md` and `README.md` before I read anything. Those carry 0.9-line UDON: `:urgent?` flags, a `<…>` typing remark, a quoted `:timestamp "2025-01-15"`, and "bare date is a string". I answered from BASICS and instinct as far as I could tell, but I can't certify the README had no pull on me. I flag it below where I felt it.
- **COLD leaked into itself:** the Read half of COLD.md (`:mass.kg`, `:mass(kg)`, `date(...)`, `~date`) was visible while I wrote the Write half. I used none of those shapes, but I wasn't ignorant of them.

## 1. COLD answers, as first written

### Write

**1. 3.2 kg, 21.5 °C**

```udon
|sample :mass 3.2 kg :temperature 21.5 °C
```

Reasoning at the time: the unquoted value runs until ` :name`, so `3.2 kg` becomes one value and so does `21.5 °C`. It reads naturally to a human and to an agent. I'd hesitate about whether the value is then the string `3.2 kg` or something a tool parses into a number plus unit. I'd want a rule saying whether any parsing happens, and if it does, what shape the unit must take. The alternative I considered and rejected as clunky was `:mass 3.2 :mass-unit kg`.

**2. 1 October 2026, 90 minutes, 14:30 in Denver**

```udon
|event :date 2026-10-01 :start 14:30 :tz America/Denver :duration 90 min
```

Hesitations: (a) whether to fold date, time, and zone into one ISO-ish value (`2026-10-01T14:30 America/Denver`, or with `-06:00`) or keep them separate as above; I picked separate because it's easier to read without a parser. (b) `90 min` vs `PT90M` vs `1h30m`. (c) whether `2026-10-01` bare means a date or the string `"2026-10-01"`. I'd want a rule for that last one.

**3. Regex and Windows path**

```udon
|rule :pattern '^\d{3}-\d{4}$'
|file :path 'C:\Users\me'
```

BASICS says `"..."` has Ruby-like escapes, so I'd read that as `\d` getting eaten in double quotes and choose single quotes as the raw form. Unquoted would probably also work (`:pattern ^\d{3}-\d{4}$`, since `\d` isn't a *framed* ` \ `), but I'm not sure enough, so I quote. Hesitation: what happens with a path that ends in a backslash (`C:\Users\`) inside single quotes, and whether single quotes are really fully raw. I'd want that stated.

**4. Server**

```udon
|server :host localhost :port 8080 :debug false :retries 3 :owner null
```

Big hesitation: nothing in BASICS says whether `8080`, `false`, `null` are typed or are just strings that happen to look that way. If everything unquoted is a string, `:owner null` is the string "null", which is not "explicitly nothing". I'd want to be told (i) whether bare values are typed, and (ii) if there is a null/true/false, what spells them. I wrote it the way I'd write YAML/JSON out of habit.

**5. "Hello," she said.**

```udon
|p
  "Hello," she said.
```

I put the sentence on its own indented line as prose, because as I read BASICS, quotes only mean "quoted value" in a value position, and a line that doesn't start with a marker is prose. On the same line, `|p "Hello," she said.`, I'm genuinely unsure whether the leading `"` opens a quoted value (leaving `she said.` as leftover `$main`). So I'd take the indented form to be safe.

**6. Three holiday dates**

```udon
|holidays :dates [2026-01-01 2026-07-04 2026-12-25]
```

Hesitations: I avoided `|holidays [...]` because `[...]` right after a name is a key per BASICS (and with a space I don't know what it'd be). I don't know whether commas are allowed in lists, whether the bare dates are strings or dates inside the list, and whether I'd rather make them child elements with names (`|holiday[new-year] :date 2026-01-01`) if each date wanted a label.

**7. Version 1.10, zip 01234**

```udon
|part :version "1.10" :zip "01234"
```

I quoted both on purpose. I don't know whether bare `1.10` / `01234` become numbers (which would lose the trailing zero and the leading zero), so quoting is the defensive move. A rule I'd want: "bare values are always strings" or "bare values that look like numbers are numbers" (either is livable if stated). Part of this defensiveness may come from having seen the README's quoted `:timestamp "2025-01-15"` in my context.

**8. Link**

```udon
|a :href https://example.com \ Click here
```

I used the framed backslash because BASICS shows exactly that shape (`|a :href /notes \ the notes`). My own instinct if BASICS hadn't shown it would have been `|a :href "https://example.com" Click here`, and I'm not sure that leftover text after a closing quote is allowed as `$main`. The `:` in `https:` is fine since there's no space before it.

### Read

Format: what I'd expect, then confidence.

1. `|p "Hello," she said.` — a `p` whose `$main` is the literal text `"Hello," she said.` including the quote marks, since quoting is for attribute values. But I'd put it at only about 65%: the alternative is that a leading quote opens a quoted value and `she said.` is the leftover.

2. `|sample :mass.kg 3.2` — I'd read "mass is 3.2 kg": the `.kg` is a unit-ish tag on the attribute. But BASICS says `.word` after an element name is a *trait*, so a literal reading is "attribute `mass` carrying trait `kg`, value `3.2`", or just an attribute whose name is the dotted string `mass.kg`. Confidence in the unit reading: ~55%; I'd be comfortable acting on it but not confident that tools agree.

3. `|sample :mass(kg) 3.2` — attribute `mass`, annotated with `kg` in parentheses (unit or kind), value `3.2`. ~65%. It looks like a type/unit annotation to me, though I could also see a parser treating `mass(kg)` as the whole name.

4. `|ev :on date(2026-10-01)` — a value built by a constructor-looking form: `on` is a *date* value, 2026-10-01. ~65% (could just be the literal string `date(2026-10-01)`; it looks like a function call, so I lean typed).

5. `|ev :on ~date 2026-10-01` — I'd guess `~date` marks the kind of the value that follows, so again a date 2026-10-01. ~40%: I don't have a convention for `~`, and the other reading, that the whole thing `~date 2026-10-01` is just a string, is nearly as likely.

6. `|h3 date(format)` — `$main` is the text `date(format)`; a heading about a function called `date` with an argument `format`. Plain text, no typing, since it's `$main` and not a value after an attribute. ~80%.

7. `|config :server.port 8080` — attribute named `server.port`, read as config path server -> port = 8080. ~55%. I notice that this `.x` is a path-step here but a unit in line 2: the same punctuation doing two different jobs would be a friction point.

8. `|server :host: localhost` — attribute named `host:` (the colon included) with value `localhost`, i.e. probably an accident carried over from YAML habit. Or the colon is tolerated and dropped. ~50%; I'd say I'd avoid writing it and distrust it when reading it.

9. `|li printf(x) prints x` — `$main` is plain text `printf(x) prints x`. ~85%.

---

## 2. What OPTIONS.md did to my COLD answers

Scoring myself against the stated rules (bare text, plus `nil`/`true`/`false`/JSON-style numbers):

- **Item 4:** `:owner null` is the string "null" here. The spelling is `nil`, and BASICS never says so, so any agent writing `null`, `None`, `~` or an empty value gets silent wrongness, not an error.
- **Item 7:** `1.10` is a valid JSON number, so bare `:version 1.10` reads as 1.1. `01234` is not JSON-style, so bare `:zip 01234` is text. My quoting was right for the version and unneeded for the zip.
- **Item 6:** my bare-date list holds strings. It's only dates under B-style name annotation (`:dates(date) [...]`) or per-item `date(...)`.
- **Item 8:** my alternative `|a :href "https://example.com" Click here` is a trap under the Q2 rule. See Q2.
- **Item 3:** single quotes worked by luck. The backtick form is the one OPTIONS offers, and I'd never have guessed it.

## 3. Trying the options

### Q1. Kind on the attribute name

**Config**

```udon
; A
|service[api] :timeout.duration 30s :cache-ttl.duration 15min :max-body.bytes 10MB
  :started.datetime 2026-10-01T08:00Z
  :db.url postgres://localhost/app       ; slip: attribute `db`, kind `url`

; B
|service[api] :timeout(duration) 30s :cache-ttl(duration) 15min :max-body(bytes) 10MB
  :started(datetime) 2026-10-01T08:00Z
  :db.url postgres://localhost/app       ; an ordinary dotted key, no clash

; C
|service[api] :timeout duration(30s) :cache-ttl duration(15min) :max-body qty(10 MB)
  :started datetime(2026-10-01T08:00Z)
  :db.url postgres://localhost/app
```

**Science rows**

```udon
; B
|run[r17] :t(s) 0.0 :mass(kg) 3.2 :temp(°C) 21.5 :p(kPa) 101.3
|run[r18] :t(s) 30.0 :mass(kg) 3.1 :temp(°C) 24.0 :p(kPa) 101.2

; A: units that aren't plain words have nowhere to go
|run[r17] :t.s 0.0 :mass.kg 3.2 :temp.degC 21.5 :speed.m/s 4.1 :accel.m/s^2 9.8

; C
|run[r17] :t qty(0.0 s) :mass qty(3.2 kg) :temp qty(21.5 °C) :p qty(101.3 kPa)

; my sketch: say the units once, rows stay plain
|table[runs] :cols [t(s) mass(kg) temp(°C) p(kPa)]
  |row 0.0 3.2 21.5 101.3
  |row 30.0 3.1 24.0 101.2
```

**Homogeneous list**

```udon
|holidays :dates(date) [2026-01-01 2026-07-04 2026-12-25]        ; B: the kind distributes over the list
|holidays :dates [date(2026-01-01) date(2026-07-04) date(2026-12-25)]   ; C / Q3-A, per item
```

**A/B fork**

```udon
|sample :mass(kg) 3.2          ; unit lives in the name
|sample :mass(qty) 3.2 kg      ; unit lives in the value, as :lasts(duration) 90min already does
```

**Notes with dates in prose**

```udon
|notes[sync-2026-10-28] :on(date) 2026-10-28
  Met Dana on |{date 2026-10-24}; launch moves from |{date 2026-11-03} to |{date 2026-11-17}.
  Follow-up due in |{duration 2w}.
```

**Friction and findings for Q1**

- **A's dot is overloaded.** `.` already means trait on elements, and real config keys are dotted (`spring.datasource.url`, `server.port`). I'd expect A to produce silent misreads of ordinary keys.
- **A can't carry arbitrary unit text.** The A example itself used `degC`, not `°C`. B's parentheses take `°C`, `%`, `m/s²`.
- **A needs two mechanisms.** The dot handles simple kinds, and `.date(YY-MM-DD pivot 1950)` adds B's parentheses back on top of it. B does both with one.
- **A and B fork "where does the unit live".** `:mass(kg) 3.2` and `:mass(qty) 3.2 kg` both exist, and `:lasts(duration) 90min` already shows the second. A corpus will contain both. C has one way, `qty(3.2 kg)`, and it is the closest to my untaught instinct (unit inside the value, COLD item 1).
- **Kinds and units share one slot in A and B.** `(kg)` and `(datetime)` sit in the same position, so `m` (metre or minute), `min`, `T`, `C`, `h` and `in` could collide with kind names. A resolution rule is needed.
- **B plus Q3-A inverts the parentheses.** `:mass(kg) 3.2` has the kind inside the parentheses. `qty(3.2 kg)` has the value inside. I'd expect agents to write `:mass(3.2 kg)` or `qty(kg)` now and then. C plus Q3-A has parentheses always holding the value.
- **Q1-C is Q3-A.** The trial treats Q1 and Q3 as separate questions, but C on Q1 costs no syntax if A wins Q3. That is a coherence point, not a question.
- **Dates in prose.** Only `|{date ...}` works inside running text, which Q3 shows as option C. A requires the value to stand alone, and B has no end delimiter. A/B only reach attribute-value positions.
- **Cost of C in tables:** `qty(...)` per cell is noisy. B is clearly easier to scan for rows of measurements.
- **My own hesitation:** `:when.date(YY-MM-DD pivot 1950) 27-03-05`. I had to look back to infer what the pivot does, since the example doesn't say. C's quoted-format variant `date("YY-MM-DD pivot 1950" 27-03-05)` reads as forced.

### Q2. A quoted value that stands alone

```udon
|part :version "1.10" :zip "01234" :sep ", " :note "a ; b"   ; quotes protect type, whitespace, ' ; '
|p "To be, or not to be."                  ; A: marks vanish. B: marks stay
|p "To be, or not to be," said Hamlet.     ; marks stay (not standalone)
|a :href "https://example.com" Click here  ; trap: not standalone, so href is the whole line, quotes included
|a :href "https://example.com" \ Click here   ; presumably fine
|msg :from alice \ "See you at 5."
```

- **Attribute position: A.** Quotes are delimiters everywhere else agents have seen them (JSON, YAML, HTML). B returns `:sep ", "` with the marks attached. I'd expect consumers to disagree about which of the two readings to use, since it can be read as either.
- **`$main` position: A loses quote marks that B keeps.** A paragraph that is entirely a quotation is common (dialogue, epigraphs, transcripts). A drops the marks, and adding one word brings them back. That cliff is the thing most likely to surprise authors. A rule I'd propose: `$main` and prose are never quoted values (marks stay), while attribute values and list items follow A. It matches what BASICS already says about indented prose lines.
- **The HTML-habit trap.** `|a :href "https://example.com" Click here` makes href the whole line, quotes included. Agents will write this form a lot. Either let a closing quote end an attribute value (leftover becomes `$main`, with `$main` still treating a leading quote as text), or make it fail loudly. I'd prefer not to leave it a silent text value. The same applies to `:title "War and Peace" (1869)`.

### Q3. A value naming its own notation

```udon
; A
|ev[launch] :on date(2026-10-01) :lasts duration(3mo 5d) :span interval(date(2026-01) date(2026-06))
|meta :values [date(2026-10-01) qty(3.2 kg) 42 hello]
|h3 date(format)               ; stands alone: constructor or text? I want text
|fn :sig max(a b)              ; same question in an attribute value
|li printf(x) prints x         ; text, fine

; B
|ev[launch] :on ~date 2026-10-01 :lasts ~duration 3mo 5d :span ~interval 2026-01/2026-06
|meta :values [~date 2026-10-01 ~duration 3mo 5d hello]   ; does ~duration stop at 3mo? is 5d an item?
|ev :eta ~noon                 ; looks like a kind named noon

; C
|ev[launch] :on |{date 2026-10-01} :lasts |{duration 3mo 5d} :span |{interval |{date 2026-01} |{date 2026-06}}
|meta :values [|{date 2026-10-01} |{qty 3.2 kg} 42 hello]

; verbatim
|rule[phone] :pattern re`^\d{3}-\d{4}$` :message Use the form 555-1234
|file :path `C:\Users\me` :sep `\`
|cmd :run `ls -la`
```

- **A:**
  - Cleanest in lists and nested values, and parentheses give an end delimiter.
  - The risk is a standalone `word(...)` in `$main` or an attribute (`|h3 date(format)`, `:sig max(a b)`, `:call sum(1 2 3)`). I'd want constructors recognised only for registered kind names and only in value or list-item positions, with unknown names and `$main` staying text.
- **B:**
  - The most visually distinct, so it collides least with ordinary text.
  - It has no end marker. The B list in OPTIONS.md avoids multi-token values (`~qty 3.2kg`, no space) where the A and C lists write `3.2 kg`. That looks like evidence it breaks in lists.
  - It also can't work in prose, and `~` is YAML's null and common shorthand for "about".
- **C:**
  - Zero new syntax, so zero learning cost, and the one option that works in prose.
  - Heavy for the commonest case. The value becomes a node, so a consumer must know which element names are values.
- **Verbatim backticks:** I like them, and I predict agents will still write quotes out of habit.
  - The tag form `re` isn't parentheses or tilde, so it's a fourth family of notation.
  - I'd want to know how a backtick inside the text is written, and what `|p `ls -la`` at `$main` does (same cliff as Q2).

### Q4. Trailing colon

```udon
; A
|server[web] :host localhost :port 8080 :debug false
  :owner nil

; B
|server[web] :host: localhost :port: 8080 :debug: false
  :owner: nil
  :mass(kg): 3.2                      ; clutter once stacked with Q1-B
```

- **A.** The leading `:` already marks the name, so the trailing one is redundant. It looks like a Lisp keyword plus YAML at once, and it stacks badly with Q1.
- **B allows two spellings with one meaning.** That fragments a corpus (mixed `:host: x :port 8080`), noisier diffs, and `grep ':host '` misses half. I'd expect agents with a YAML prior to emit colons at some rate whichever option wins.
- **What I'd want if A wins:** `:host: localhost` should warn or error, not silently make an attribute named `host:`. That was my read of COLD item 8, and it's the worst outcome.

## 4. Preferences and why (instincts, not measurements)

- **Q1:**
  - I'd choose C, with A dropped. It's one mechanism, parentheses always hold the value, and it matches my untaught instinct to put the unit inside the value.
  - B is the one I'd enjoy writing for dense measurement records and homogeneous lists (`:dates(date) [...]` is the only list form with no per-item noise). Its cost is the inverted parentheses once Q3-A is also adopted, plus the A/B unit-in-name versus unit-in-value fork.
  - If tables matter a lot, my `|table :cols [...]` sketch may beat all three. It's a sketch I haven't stress-tested, and it reuses B-style `mass(kg)` in a header list.
- **Q2:** A for attribute values and list items, text as typed for `$main` and prose, and the closing-quote trap fixed. "This seems right to me" is most of my evidence.
- **Q3:** A for value and list positions, with registered-kind-only recognition. C comes free in prose because `|{…}` already exists. B is the one I'd drop.
- **Q4:** A.

## 5. What I'd expect other agents to get wrong

- Spelling nil as `null`, `None`, `~` or empty, which silently gives the string "null" (the only COLD answer I got wrong in this way).
- Bare `1.10`-style versions (and `1.0`, `1e5`-shaped ids and short hashes), read as numbers. Quote them, which needs Q2-A.
- JSON-style commas in lists (`[a, b, c]`), which I'd expect to give `a,` as an item.
- Under A, dotted config keys read as kinds (`:db.url`).
- Under Q4-A, writing `:host: localhost` out of YAML habit.
- Under Q1 A/B, mixing unit-in-name and unit-in-value.
- Writing `|a :href "…" Click here`.
- Backslash-heavy values in `"…"` or `'…'` instead of backticks.
- A standalone `foo(bar)` in headings or attributes being read as a constructor.

## 6. Feedback on the trial

- **Unspecified:** do `$main` and prose values get number/boolean/nil readings? `|td 1.10`, `|li true`, `|h2 2026` and `|p nil` would all be affected. OPTIONS.md says "a bare value" without saying. This is the first thing I'd ask Joseph, since it can matter more than any of Q1–Q4. HTML-ish content is mostly text attributes (`:value 1.10`, `:tabindex 0`) and the numeric reading is the main friction there.
- **Q1 and Q3 aren't independent.** Show them as packages (for example C+A, B+A, A+B) so agents can react to combinations.
- **Q2's standalone rule and Q3-A's standalone rule are the same cliff.** I'd treat them as one question.
- **Context coverage:** the options are shown on one small example each. Prose-with-dates only works under C, which the page doesn't make visible, and table-like data isn't shown at all.
- **COLD ordering:** the Read half primes the Write half. A two-file split (Write first, Read revealed after) would measure the untaught guess cleaner.
- **Contamination:** any agent launched from inside the udon repo gets `CLAUDE.md` and `README.md` auto-loaded with 0.9-line syntax. For the BASICS-only cohort I'd launch from a neutral directory.
- **Unexplained example:** `:when.date(YY-MM-DD pivot 1950) 27-03-05` has no gloss, so I couldn't tell whether I was reading it correctly.
- **No spelling is given for null.** BASICS never mentions `nil`, so COLD item 4 can't measure "what do agents write for null" fairly.
