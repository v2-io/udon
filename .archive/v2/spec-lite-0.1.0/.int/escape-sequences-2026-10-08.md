# Escape sequences in lite's quoted strings: what history holds, and a set lined up with the number notation

*Research note, 2026-10-08, written by an Opus 5.5 subagent for the lite-spec coordinator. Input to [[decision:quoted-strings-like-ruby]] (its Working notes leave the exact list open) and to [[rule:quoted-strings]].*

**Bottom line.** I found no in-string escape *set* anywhere in UDON's history. The mainline 0.9 spec says a `\` inside a string "follows the string's own escaping", but no version ever said what that escaping is. The descent grammar only stops `\"` from closing the string and never decodes anything. Every later version said strings have **no** escapes. What Joseph may be remembering is in §1.3. Section 2 proposes a set for `"…"`. It is Ruby's set with three kinds of change: drop the implicit octal escapes (the same reason `0755` is decimal), refuse anything Ruby and the JSON languages would read differently, and let the digits inside braces follow the integer digit rules. One result Joseph may not expect: the number notation lines up for `x` and `o` but not for `b` or `d` (§3).

---

## 1. What history holds

Each item is marked as Joseph's typed words, spec text, or agent text.

### 1.1 Chronological record

- **2011, the original overview** (`~/src/_older/udon/examples/overview.udon`, lines 76–95; *spec text, the 2011 design*). There were three line-oriented data forms, and the table's `metachars` column shows that only the double-quoted one interpreted anything:
  ```
                           #      | embedded | child lines | metachars | embeds | prsv.ws | comments |
  |"datadata...            # Data | --       | --          | Yes       | Yes    | a-indent| --       |
  |'datadata...            # Data | --       | --          | --        | Yes    | a-indent| --       |
  |`datadata...            # Data | --       | --          | --        | --     | a-indent| --       |
  ```
  In 2011, then: `"` interprets metacharacters, `'` doesn't, and a backtick protects even embeds. That is the same split Joseph chose today. No list of the metacharacters survives. `udon-c/docs/DECIDED.md:150` has only an open question: "In labels, ever allow/care about escaped values?"

- **Dec 2025, 0.7-draft** (`_archive/SPEC.md:371`; *spec text*): "Inside quoted strings (`"..."` or `'...'`), the escape prefix has no special meaning—quoted strings handle their own escaping per their delimiter rules." The rules themselves are never given.

- **2025-12-31, Joseph** (`~/.claude/history.jsonl` line 6434, libudon session; *his words*, about structural escapes only): "The escape sequence for ';' as a *block* comment is `'` -- although if the desc also specifies `\\`, that would be fine also. For sameline comments … backslash is appropriate for escaping it."

- **Jul 2026, 0.8 "Escaping unified"** (`spec/msc/CHANGELOG.md:471–474`; *spec text*): "a `\` at head position forces the line to prose …; in prose flow a `\` before an inline opener `|{` / `!{` / `;{` makes it literal; anywhere else `\` is literal. Retires the old `'`-escape and the per-context `\;` mechanism."

- **2026-07-14, Joseph** (`history.jsonl` line 16209, udon session; *his words*). This is where escape sequences were moved out of the core: "Within prose itself, if a trailing backslash were simply passed through as usual, the app-layer gets to decide that it removes the subsequent newline... So... in the end... I say backslash anywhere else is passed through and gets application-level decisions on its meaning (like escape sequences or escaped newline and so forth and so on). OK-- Now I'm settled."

- **Mainline 0.9, `spec/CORE.md`** (*spec text*):
  - Line 224: "Any other `\` is literal. … with any escape-sequence reading (`\n`, `\t`, a trailing `\` as a line-join, ...) left to the host/app layer."
  - Line 257: "Inside quoted strings (`"..."` / `'...'`), `\` follows the string's own escaping, not this rule."
  - Value Types table (line 1654): `"..."` or `'...'` → String, with nothing on escapes.

  That is the whole of the "mainline old 0.9" text on string escapes.

- **Mainline 0.9, the reference grammar and EBNF** (*spec/agent text*):
  - `spec/msc/FULL-EBNF.md:381–387`: `dq_char = escaped_char | ( CHAR - '"' )`, `escaped_char = "\" ANY_CHAR`, with the note "escape prefixes have no special meaning beyond the delimiter's own escaping".
  - `core/generator/30-udon.values.descent.udon:29–34` (`quoted`) and `00-udon.core.descent.udon:176` (`skip_single_quoted`, used for quoted names, traits and keys): on `\` they step over two bytes and emit the raw span.

  So in 0.9 a `\X` pair stops `\"` from closing the string, and the bytes go through undecoded. Lexically that is the "any `\X`" rule lite has now adopted for opaque spans. No decode table was ever written.

- **2026-07-20, greenfield-3b D7 and its withdrawal** (`v2/.archived/first-pass/greenfield-3b/new-spec/DECISIONS.md:87–101`; *agent text*). The only in-string escape set any draft ever pinned was a minimal one: "`\\` and matching `\"`/`\'` inside quoted strings." Fable objected (`…/greenfield-3b/feedback-fable.md:27–29`, *agent text*): it "breaks the 'escape is positional, period' story", and `"C:\Users\new"` would get "a subtle mixed rule that authors will guess wrong in both directions". D7 was withdrawn.

- **L2, ruled A** (`v2/.archived/second-pass/RULING-SUPPLEMENT.md:182–198`; `v2/DECISIONS.md:85`). The options were A (no escapes), B (`\\` plus the delimiter quote) and C (doubling, which collides with `["x""y"]` being two items). A was adopted. The supplement states the cost: "a string needing *both* quote kinds has no single-line spelling".

- **0.9.1 / 0.10.0 §11.3** (`v2/spec-0.10.00/CORE.md:660`; *spec text*): "**There are no core in-string escapes** … hosts MUST NOT invent core escapes". The 0.10.1 wording is "No core in-string escapes, ever".

- **K13, Joseph, 2026-08-09** (`v2/DECISIONS.md:174`; *the row records his ruling*). This is the latest change to `\` outside strings: framed ` \ ` commits text mode; "attached `\X` — escapes exactly the next character where it would otherwise be structural"; "Mid-token `\` is literal (`C:\Users\me`) — the escape fires only at structural positions."

- **2026-10-08, lite, Joseph** (`.int/STEWARD-VERBATIM.md:474, 488, 495`; *his words*):
  - "I'm going to lean with you on disallowing newlines within delimited strings -- but allowing \n and other common escape sequences."
  - "I think `"..."` and `'...'` should essentially be just like ruby strings (including escape sequences in `""` but not in `''`, and including within the special constructs for labels, e.g. `|'something "hey"\'' weird node name`)". (I've put his quote marks in backticks so they read as code.)
  - "ruby strings: right--- no interpolation, #{} gets passed through as normal text, and go ahead and error on unknown escape sequences in "". I *think* we actually have an improved set of escape sequences defined in the mainline old 0.9 udon spec …"

### 1.2 Where I looked

I looked in mainline `spec/` (CORE, the companion specs, every `TODO-*`, `msc/CHANGELOG.md`, `msc/FULL-EBNF.md`), `_archive/`, `design/` (no hits), `core/generator/*.descent.udon` (current and legacy pre-0.8), `core/fixtures/legacy-pre-0.8/escapes.yaml` (the old `'`-prefix structural escapes only), `v2/` (0.9.1, 0.10.0, 0.10.1, `.archived/`, `udon-needs/`, `theory/`), `~/src/_older/{udon,udon-c}`, and the git history of every `.md` file in the repo. I grepped for escape-table spellings (`\u{`, `\uHHHH`, `\xHH`, and backtick-quoted `\n`, `\t`, `\0`). I also checked his typed words in `~/.claude/history.jsonl` and with `memorata-search --joseph`. The only escape tables that turned up belong to other languages: descent's own `'\n'`/`'\xHH'` character literals (`tools/descent/SYNTAX.md:297`) and a YAML cheat-sheet in autopax.

I didn't open every transcript in `v2/.archived/second-pass/spikes/session-vault/`. My greps over it found only the D7/L2 discussion.

### 1.3 What he may be remembering (my guesses)

- **The 0.8 "Escaping unified" rule**, refined by K13. It is the "improved" escape story of mainline 0.9: there's "no set of escapable characters to memorize" (CORE.md:195; `v2/spec-0.09.01/TUTORIAL.md:105`). But it is about `\` *outside* strings, and it explicitly hands `\n`-style sequences to the host.
- **The 0.9 grammar's `\` + any character inside quotes.** It is a real rule, but a lexical one with no decoding.
- **descent's character-literal escapes**, `'\n'` and `'\xHH'` (`tools/descent/SYNTAX.md`), which he wrote and used constantly while building the 0.9 grammar. That's a different language, but it's the escape table he typed most often in the UDON context.

So the set below is a proposal, not a recovered one.

---

## 2. Suggested set for lite's `"…"`

**The rule:** inside `"…"`, a `\` must begin one of the sequences below. Any other `\X` is an error. A raw newline is an error, per [[decision:errors-stop-parsing]]. `#{` is ordinary text.

| Escape | Gives | Ruby | JSON | Reason |
|---|---|---|---|---|
| `\\` | `\` | ✓ | ✓ | Needed to write a backslash at all. |
| `\"` | `"` | ✓ | ✓ | Needed to write the delimiter. |
| `\'` | `'` | ✓ | — | Ruby, JS and Python all accept it in double quotes, and agents write it by habit. Refusing it would only produce errors. |
| `\n` `\t` `\r` | LF, TAB, CR | ✓ | ✓ | The common core; this is what Joseph asked for with "\n and other common escape sequences". |
| `\b` `\f` | U+0008, U+000C | ✓ | ✓ | JSON writers emit these: `json.dumps` and `JSON.stringify` write `\b` and `\f` (checked here). See the regex note in §4. |
| `\v` `\a` | U+000B, U+0007 | ✓ | — | In Ruby's set, and harmless. They could be dropped; they are rare, and since unknown escapes are errors, dropping them is safe to undo later. |
| `\e` | U+001B | ✓ | — | Terminal and ANSI content. It is also where the common `\033` habit gets redirected (see the octal row in §2.1). |
| `\0` | U+0000, **only if the next character is not a digit** | ✓ | — | `\0` followed by a digit is an error. This is the numbers rule: a leading `0` never quietly means octal (`0755` is decimal 755). JS has the same `\0` rule. |
| `\/` | `/` | ✓ (via its drop-the-backslash rule) | ✓ | Some JSON emitters escape slashes. I recall PHP's `json_encode` doing it by default but didn't run it here. Ruby already reads `\/` as `/`, so accepting it costs nothing. |
| `\#` | `#` | ✓ | — | Ruby writers escape `#{` by reflex. Since lite doesn't interpolate, `"#{x}"` and `"\#{x}"` both give `#{x}`. |
| `\xHH` | U+00–U+7F | ✓ | — | **Exactly two** hex digits, and the value must be **at most 7F** (§3). |
| `\uHHHH` | one code point | ✓ | ✓ | Exactly four hex digits. A high surrogate followed by `\u` and a low surrogate is one code point; a lone surrogate is an error (§2.2). |
| `\u{H… H…}` | one or more code points | ✓ | — | The digits are hex and may contain `_` by the integer digit rule. Spaces separate several code points. Leading zeros don't count against a limit; the *value* must be at most 10FFFF and not a surrogate (§3). |

Every row except `\u{…}` and `\uHHHH` produces one fixed character. That keeps the table short to state and hard to misremember.

### 2.1 Errors, each one deliberate

| Written | Ruby gives | Lite | Why |
|---|---|---|---|
| `"C:\Users"` | `C:Users` (backslash silently dropped) | error | Joseph's call. The message can suggest `'…'` or `\\`. |
| `"\033[0m"`, `"\1"`, `"\012"` | octal: ESC, U+0001, LF | error | Implicit octal is what the number rule refuses (`0755` is decimal), and Ruby even wraps `"\400"` around to NUL (checked). The message points to `\e`, `\x1B` or `\u{1B}`. |
| `"\s"` | space | error | **This departs from Ruby; Joseph's call.** `\s` is Ruby-only. A writer with Python or regex habits writes `"\s+"` expecting the regex, and with `\s` defined that would silently become `" +"`. Leaving it undefined turns a silent misreading into an error. Ruby's own use of `\s` is rare. |
| `"\x4"`, `"\x4G"` | `\x04`, `\x04` + `G` | error | Ruby accepts one hex digit; Python and JS require two. Requiring two removes the question of where the digits end. |
| `"\xE9"` | the *byte* E9 (an invalid UTF-8 string; checked) | error | Python and JS read it as U+00E9, Ruby as a raw byte. Since the ecosystems disagree, only an error is safe. Use `\u00e9` or `\u{e9}`. |
| `"\cA"`, `"\C-a"`, `"\M-a"` | control and meta bytes (meta is invalid UTF-8; checked) | error | Little use, and meta can't produce valid text. Lite can add them later because they are errors now. |
| `\` at the end of a line | joins the two lines | error | It is a raw newline inside a string. |
| `"\{"`, `"\|"`, `"\;"`, `"\<"`, `"\ "` | the character | error | Lite's own structural escapes don't apply inside a string, because nothing in a string is structural. A UDON writer who reaches for `\|{` here learns from the error that they don't need it. |
| `"\U0001F600"`, `"\N{…}"`, `"\o{101}"`, `"\x{41}"`, `"\d{…}"` | `U…`, `N{…}`, `o{101}`, … | error | Other languages' forms. Errors now keep them free; see §3 for which could ever be added. |

### 2.2 Small edges

- **Surrogate pairs.** Ruby rejects `"\uD83D\uDE00"`, even as a pair (checked). But Python's `json.dumps` writes exactly that by default: `"😀"` becomes `"\ud83d\ude00"` (checked). So JSON pasted into lite will contain pairs. My lean is to accept a correctly ordered high-low pair as one code point and to refuse a lone surrogate, and a surrogate inside `\u{…}`. This is a superset of Ruby, and Joseph's call.
- **`\u{…}` spacing.** Ruby accepts `\u{}` (empty, giving `""`), `\u{ 41 }`, and tabs between code points (all checked). My lean is stricter: at least one code point, single spaces between code points, no space just inside the braces. Every strict choice here can be relaxed later without changing what any valid lite document means, because each relaxation only turns an error into a meaning. That is the same forward-compatibility argument as the newline error in [[decision:opaque-spans]].
- **Case.** Hex digits may be either case, as in numbers. The escape letters are lowercase only. Numbers accept `0X`, but in escapes an uppercase letter is a different escape in other languages (`\U`, `\N`, `\C-`, `\M-`), so `\X41` is an error rather than a hex escape.
- **`'…'`**, as decided: `\'` gives `'`, `\\` gives `\`, and every other backslash is literal (Ruby's behavior, checked: `'\n'` is backslash and n). The edge worth an example in the spec: `'C:\'` doesn't close, because `\'` is an escaped quote, so the string runs to the end of the line, and that is an error. The fix is `'C:\\'`.
- **Quoted names and labels** use the same two rules, as decided. One question for [[rule:element-head]]: once decoded, may a name contain control characters or a newline (`|"a\nb"`)? I didn't pursue it.

### 2.3 What the tree holds (examples)

```udon
|q :a "She said \"hi\" and it's fine" :b 'C:\Users\me' :c "tab\there\u{1F600}" :d "#{not} \#{interp}"
```
```text
element q
  a "She said \"hi\" and it's fine"
  b "C:\\Users\\me"                ; '…' keeps backslashes
  c "tab<TAB>here😀"
  d "#{not} #{interp}"
```
```udon
|q :e "C:\Users"        ; error: unknown escape \U (use '…' or \\)
|q :f "\033[1m"         ; error: octal escapes aren't lite; use \e or \x1B
|q :g "\u{1F468 200D 1F469}"   ; one string, three code points (a ZWJ sequence)
|q :h "\u{10_FFFF}"     ; U+10FFFF, `_` by the integer digit rule
|q :i "\xE9"            ; error: \x is ASCII-only; use \u{e9}
```

---

## 3. How it lines up with the number notation

A writer's model of a UDON integer (§11.2 of 0.10.0, unchanged from mainline 0.9) has five parts. For each, here is how far escapes can follow it:

1. **A letter after `0` names the base: `x` hex, `o` octal, `b` binary, `d` decimal.**
   - **`x` carries over:** `\xHH` is hex, as `0xHH` is.
   - **`o` could carry over** as `\o{…}`, which has precedent in C++23 and Perl. I suggest leaving it out of lite, because octal escapes in practice are C-heritage control codes that `\e` and `\x1B` already cover. If octal is ever wanted, its spelling is `\o{…}`, never bare digits.
   - **`b` and `d` can't.** `\b` is backspace in Ruby, JSON, C, Python and JS. And `\d{3}` is among the most common regex patterns in string literals, so a decimal escape spelled `\d{…}` would silently turn `"\d{3}"` into U+0003. That is the worst kind of surprise for an agent.
   - **Base prefixes inside `\u{…}` also fail.** `b` and `d` are hex digits, so `\u{0d05}` is already U+0D05 MALAYALAM LETTER A in Ruby, JS, Rust and Swift, and `\u{0b85}` is U+0B85 TAMIL LETTER A. People write padded forms like these. If `0d` or `0b` inside the braces meant a base, those escapes would silently change meaning.

   So: inside `\u{…}` the base is fixed to hex. This doesn't break with the number notation; it applies its stated reason. CORE says base prefixes exist "so a literal can mirror its *natural written form* — the author never has to translate a value into a different base" (mainline `spec/CORE.md`, Numbers). The natural written form of a code point is hex (U+1F600), so the code-point escape is hex.
2. **Implicit octal is refused (`0755` is decimal).** Ruby's `\NNN` octal escapes are exactly that implicit octal, so lite refuses them. This is the change most clearly driven by the number notation, and it is the one Ruby writers will hit (`"\033"`).
3. **`_` separates digits without changing the value.** `\u{…}` allows it under whatever placement rule [[rule:bare-values]] settles for integers (that rule is still open; pre-design 72 lists `1__0`, `_1`, `1_`). Rust accepts `\u{1F_600}` (from memory of the Rust reference, not run here); Ruby rejects it (checked). Fixed-width forms (`\xHH`, `\uHHHH`) don't take `_`, since they count digits.
4. **Leading zeros don't change the value.** `\u{…}` is limited by *value* (at most 10FFFF) rather than by Ruby's six-digit count, so `\u{0000041}` is `A`, as `0d0042` is 42. Ruby rejects it (checked); accepting it only adds meanings.
5. **The sign** has no counterpart in escapes.

If Joseph wanted one more step, the brace interior could be read by the integer lexer itself: a hex digit run with `_`, no sign, no prefix. Then "the digits in `\u{…}`" and "the digits after `0x`" would be one rule in the spec text, which fits [[prin:one-rule-everywhere]].

---

## 4. Surprises, by background

**A Ruby-trained writer:**
- `"#{name}"` is literal text. The surprise runs opposite to every other row here: Ruby would interpolate.
- Unknown escapes are errors (`"C:\Users"`, `"\{"`), where Ruby drops the backslash.
- Octal escapes are gone (`"\033"`), and so is `\s` if Joseph takes that lean.
- `\x` needs two digits and is ASCII-only.
- `\c`, `\C-`, `\M-` and backslash-newline are gone.
- Additions Ruby lacks: surrogate pairs, `_` in `\u{…}`, more than six digits.

**A JSON- or JS-trained writer:**
- Every JSON escape works: `\" \\ \/ \b \f \n \r \t \uHHHH`, including pairs.
- Single quotes are raw: `'\n'` is two characters, unlike JS, where `'…'` and `"…"` are the same.
- `\u{…}` exists (it's also in JS).

**A regex in a string, any background:**
- `"\d+"` and `"\w"` are errors, which is good: they point the writer to `'…'`.
- `"\bword\b"` is silently a backspace on each side, exactly as in JSON, Ruby and Python. That's the one silent regex trap left, and it remains because JSON compatibility needs `\b`.

**Across lite's own constructs**, which is what I'd most like a second opinion on. `\n` will read three ways in lite:
- newline in `"…"`;
- backslash and `n` in `'…'`;
- just `n` in `<…>`, `@{…}` and `;{…}` (the opaque spans' "any `\X` gives `X`", [[decision:opaque-spans]]).

Each choice is defensible on its own. But together an agent has to know which construct it is in to read `\n`. A regex shows it most clearly: `<re:\d+>` hands over `re:d+`. The opaque-spans record already notes that cost as a consequence.

---

## 5. Calls for Joseph, as examples

1. `"\s"`: a space (Ruby), or an error (my lean, so that `"\s+"` can't silently lose its regex)?
2. `"\uD83D\uDE00"` (what Python's JSON writes for 😀): one code point (my lean), or an error as in Ruby?
3. `"\v"`, `"\a"`, `"\0"`: keep (Ruby's set), or drop as never needed (errors now, addable later)?
4. `"\u{1F_600}"` and `"\u{0000041}"`: accept by the integer digit rules (my lean), or refuse as Ruby does?

---

## 6. Feedback on the question

The premise that mainline 0.9 had an improved escape set didn't hold up: I found no set anywhere. The second half of the question did hold up, but not in the shape it was asked. Aligning escapes with the numbers works through the *reasons* behind the number rules (no implicit octal, natural written form, `_`, leading zeros don't count) rather than through a parallel set of base letters, because `b` and `d` are already taken in escape-space and in hex-digit-space. I'd treat the three-way reading of `\n` in §4 as the larger open issue for lite's coherence. It is outside what I was asked, so I've only noted it.

*Checked here: every Ruby behavior marked "checked" was run with Ruby 4.0.0, and the JSON emitter behavior with Python 3 `json.dumps` and Node's `JSON.stringify`. PHP's slash escaping, Rust's `_` in `\u{…}`, and the C++23 and Perl precedents for `\o{…}` and `\x{…}` are from memory. The Unicode names in §3 were checked against Unicode 18.0.0 (U+0D65, the example I first reached for, turned out to be unassigned, so the example uses U+0D05).*
