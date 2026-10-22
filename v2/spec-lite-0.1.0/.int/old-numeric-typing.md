# Old-line UDON numeric and temporal typing: every form, what it parsed to, and where it came from

*Compiled 2026-10-22 for Joseph. `v2/` was not consulted at any point.*

> [!note] Status: exploration, not a ruling
> This is archaeology of the pre-0.8 line, written by an agent sent to dig it up. Nothing in it is adjudicated, normative, definitive or prescriptive for spec-lite. It records what the old parsers *did*, which is often not what their specs *said*, and neither is what spec-lite has decided. It is kept as evidence and provocation. When it disagrees with anything in `spec-lite-0.1.0/`, spec-lite stands and this file is merely informative.
>
> **Provenance.** Joseph asked (session `01C143TjBpCdjCEu9eEc4zEE`): *"could you look in the older udon/{spec,test} stuff for a comprehensive example of the numeric typing it was able to perform including the temporal/datetime stuff? (I know of some things it allowed for numbers while still parsing very quickly that I'm holding out as a canary)."* The coordinating agent delegated the dig so that old-spec material would stay out of its spec-lite context. That agent wrote this file; the coordinator read it but did not re-run its probes. The behavioral claims rest on the agent's runs of three historical parsers (section 0). Joseph then moved the file here from the session scratchpad.
>
> **Reading notes from the coordinator:**
>
> - **Why it was fast** (section 4). It made one forward pass, deciding on a single byte at each step, with no lookahead and no backtracking. A failed match falls to a string from the same starting mark, so nothing is ever re-read. It classified but never converted: each value was emitted as a type tag plus a zero-copy slice of the source, and the host did the conversion. TIME-SPEC's "priority list" was really a decision tree that forks on the byte after the digit run. Keywords went through a perfect hash, and only once a token was label-shaped. The commit that introduced the grammar says "2.3x faster than value.rs for type detection." That is the only isolated measurement; the other figures are whole-document throughput.
> - **What that speed cost** (section 4 item 6; sections 3 and 5). Anything that requires counting or remembering was never checked: digit counts, ranges, component order, week-mixing, fraction placement, and every warning in TIME-SPEC. The defects that aren't about validation:
>   - Suffix arms return without checking the terminator: `30seconds` gives `30s` plus the text "econds", and `1d12h` gives two Durations in an array. This persists in 0.9 for `i` and `r`.
>   - Leading punctuation was absorbed into the number: `$9.99` was a Float. Fixed in 0.9.
>   - `3-4i` stopped being Complex from 2026-01-09 to 07-15.
>   - Zero-led forms lack the arms that other numbers have: `0s` is a string, `00s` a Duration.
>   - In a block attribute, the type depends on what follows on the line.
> - **The question raised for Joseph** (section 5 item 6). 0.9 accepts `0d83.23` as a Float, and `design/composite-types.md` calls that leaf an "explicit-decimal float". CORE defines `0d` only as an integer prefix. Nothing found says whether `0d` on a fraction is meant to mean an exact decimal.
> - **Old ideas that never reached any 2025-26 spec** (section 6): numbers with a unit or kind suffix (`29.5px`, `990xl`, `50%`), color literals, NaN/infinity, bignums, intervals.
> - **The probe tooling is gone.** The last paragraph of section 7 points to scripts and parser binaries in a session scratchpad. That directory is temporary and won't outlive the session, so treat those paths as dead unless the tooling is copied somewhere durable.

## 0. What "the old line" turned out to be, and how this was checked

Five layers hold numeric typing before the 0.8 reboot. Only one of them is a working implementation of the full set:

| Era | Where | What it is |
|---|---|---|
| 2011-07 to 2012-01 | `~/src/_older/udon` (vim syntax, `.attic/`), `~/src/_older/udon-c/docs` | Plans and a highlighter only. Neither the C parser nor the Ruby state table types any scalar. See section 6. |
| 2025-12-23 to 2026-01-01 | umbrella `SPEC.md` @ `f5813bd`, later `FULL-SPEC.md` + `FULL-EBNF.md` @ `2a813a0` | Spec text: "Numeric literals follow Ruby conventions." |
| 2025-12-24 to 2026-01-02 | `value.rs` (umbrella `3ac833b` `crates/udon-core/src/value.rs`, the same file in libudon until `a6d23e7`) | A hand-written classifier that also converted values (i64, f64, num/den, re/im). |
| 2025-12-30 to 2026-07-15 | `generator/values.desc` (libudon; byte-identical at umbrella tag `grammar-v0.7` as `core/generator/values.desc`, 836 lines) | **The real thing.** A descent state machine. Temporal forms were added 2026-01-09 (`d4c639b`). The fixtures are `core/fixtures/legacy-pre-0.8/{value_types,temporal,values}.yaml`, byte-identical to libudon's `udon-core/tests/fixtures/`. |
| 2026-01-09 / 01-13 | `TIME-SPEC.md` (`3c5447d`, then `ca3ddd3`). Now `spec/TIME-SPEC.md`, the same text plus an 11-line banner. | The temporal spec. |

**Verification.** I didn't infer behaviour from the grammar text. I built three parsers in the scratchpad (all offline, from `git archive`, so no repo was touched):

- umbrella tag `grammar-v0.7`, the last tree with bare temporal still in the grammar;
- libudon HEAD (`4e91483`, 2026-01-13);
- libudon `a6d23e7` (2026-01-02), the last tree before temporal.

I also ran the existing 0.9 debug build in `core/target/debug/examples/stdin_parse` (built Sep 29, after the last grammar change on Jul 19) for contrast. About 250 lexemes went through each parser in four value contexts (sameline attr, block attr, array item, embedded `|{…}` attr).

The annotations in section 1 are the parser's actual events. A generator script wrote them; nothing in them was hand-typed. libudon HEAD and `grammar-v0.7` classify every lexeme identically, with one array/embed exception noted in section 5 item 9.

Source keys used below:

- **S1** = `SPEC.md`@`f5813bd` (EBNF 455-470; Value Types 506-560)
- **S2** = `FULL-SPEC.md`@`2a813a0` (Value Types 1493-1530; terminator rules 273-340). `FULL-EBNF.md`@`2a813a0` has the number productions at 106-115.
- **T** = `spec/TIME-SPEC.md` (current line numbers; text from `ca3ddd3`)
- **G** = `values.desc` line numbers (identical in libudon and at `grammar-v0.7`)
- **F** = the `legacy-pre-0.8` fixture files

## 1. The comprehensive document

One UDON document; every line is one form. The comment gives the events `grammar-v0.7` emitted. When the four contexts disagree, all four are listed. `[0.9: …]` appears only when the current parser differs, and `-- …` is my note. Each section header carries its spec, grammar and fixture citations.

```udon
; ---- Decimal integers  [S1 EBNF 462-463, S2 1513-1527; G num_dec 303-332, num_zero 283-300; F value_types 49-67, values 11-21]
|integers
  |v :x 0                          ; Integer "0"
  |v :x 42                         ; Integer "42"
  |v :x -42                        ; Integer "-42"
  |v :x +42                        ; Integer "+42"   -- EBNF of the era had only '-' sign; grammar takes '+'
  |v :x 0755                       ; Integer "0755"   -- leading zero stays decimal (S2 1527), not C-octal
  |v :x 007                        ; Integer "007"
  |v :x 1_000_000                  ; Integer "1_000_000"   -- F value_types:49
  |v :x 1__0                       ; Integer "1__0"   -- doubled separator accepted
  |v :x 1_                         ; Integer "1_"   -- trailing separator accepted
  |v :x 0d42                       ; BareValue "0d42"   [0.9: Integer "0d42"]   -- spec S1/S2 lists explicit-decimal 0d; old grammar has no arm
  |v :x 0D42                       ; BareValue "0D42"   [0.9: Integer "0D42"]
  |v :x 0d                         ; BareValue "0d"   [0.9: Integer "0d"]

; ---- Hex / octal / binary  [S1 464-466; G num_hex 635-647, num_oct 650-662, num_bin 665-677; F value_types 9-47, values 31-51]
|bases
  |v :x 0xFF                       ; Integer "0xFF"
  |v :x 0xff                       ; Integer "0xff"
  |v :x 0XFF                       ; Integer "0XFF"   -- uppercase prefix
  |v :x 0xDEAD_BEEF                ; Integer "0xDEAD_BEEF"
  |v :x -0xFF                      ; Integer "-0xFF"   -- signed hex
  |v :x +0xFF                      ; Integer "+0xFF"
  |v :x 0x                         ; Integer "0x"   -- prefix with no digits
  |v :x 0x_                        ; Integer "0x_"
  |v :x 0xG                        ; BareValue "0xG"
  |v :x 0o755                      ; Integer "0o755"
  |v :x 0O17                       ; Integer "0O17"
  |v :x 0o8                        ; BareValue "0o8"
  |v :x 0o                         ; Integer "0o"
  |v :x 0b1010                     ; Integer "0b1010"
  |v :x 0B11                       ; Integer "0B11"
  |v :x 0b2                        ; BareValue "0b2"
  |v :x 0b                         ; Integer "0b"

; ---- Floats  [S1 467-468, S2 1515-1524; G num_float_frac 680-702, num_float_exp 705-734; F value_types 71-111, values 61-71]
|floats
  |v :x 3.14                       ; Float "3.14"
  |v :x -3.14                      ; Float "-3.14"
  |v :x +2.5                       ; Float "+2.5"
  |v :x 1_000.5                    ; Float "1_000.5"
  |v :x 0.5                        ; Float "0.5"
  |v :x 5.                         ; Float "5."   -- no digit after '.' (EBNF requires one)
  |v :x .5                         ; Integer ".5"   [0.9: BareValue ".5"]   -- no leading digit
  |v :x 1.2.3                      ; BareValue "1.2.3"
  |v :x 1e10                       ; Float "1e10"   -- S1 EBNF required a '.', S1 prose lists 1e10; F value_types:91 sides with prose
  |v :x 1E10                       ; Float "1E10"
  |v :x 1.5e-3                     ; Float "1.5e-3"
  |v :x 1.5E+10                    ; Float "1.5E+10"
  |v :x -1.5e3                     ; Float "-1.5e3"
  |v :x 1e10_0                     ; Float "1e10_0"   -- separator in exponent
  |v :x 1_000e1_0                  ; Float "1_000e1_0"
  |v :x 1e                         ; Float "1e"   -- exponent with no digits
  |v :x 1e+                        ; Float "1e+"
  |v :x 0e5                        ; Float "0e5"
  |v :x 1.5e3.2                    ; BareValue "1.5e3.2"
  |v :x 0d83.23                    ; BareValue "0d83.23"   [0.9: Float "0d83.23"]   -- the composite-types example leaf

; ---- Rationals (integer '/' integer 'r')  [S1 469 + table 517; G num_rational_denom 739-752; F value_types 115-123]
|rationals
  |v :x 1/3r                       ; Rational "1/3r"
  |v :x 22/7r                      ; Rational "22/7r"
  |v :x -1/2r                      ; Rational "-1/2r"
  |v :x +1/2r                      ; Rational "+1/2r"
  |v :x 1_000/3r                   ; Rational "1_000/3r"
  |v :x 1/0r                       ; Rational "1/0r"   -- zero denominator not checked (value.rs rejected it)
  |v :x 0/3r                       ; BareValue "0/3r"   -- num_zero has no '/' arm
  |v :x 1/3                        ; BareValue "1/3"   -- 'r' is mandatory
  |v :x 1/3R                       ; BareValue "1/3R"   -- lowercase r only
  |v :x 1.5/2r                     ; BareValue "1.5/2r"
  |v :x 1e3/2r                     ; BareValue "1e3/2r"
  |v :x 0x1F/3r                    ; BareValue "0x1F/3r"
  |v :x 1/3rd                      ; inline: Rational "1/3r" + Text "d" / block: Rational "1/3r" + Text "d" / array: Rational "1/3r" + BareValue "d" / embed: Rational "1/3r" + Text "d"   [0.9: inline: Rational "1/3r" + Text "d" / block: Rational "1/3r" + Warning "AttributeValueExtendedByTrailingText" + Text "d" / array: Rational "1/3r" + BareValue "d" / embed: Rational "1/3r" + Text "d"]   -- suffix arm returns without checking the terminator
  |v :x 1/3r5                      ; inline: Rational "1/3r" + Text "5" / block: Rational "1/3r" + Text "5" / array: Rational "1/3r" + Integer "5" / embed: Rational "1/3r" + Text "5"   [0.9: inline: Rational "1/3r" + Text "5" / block: Rational "1/3r" + Warning "AttributeValueExtendedByTrailingText" + Text "5" / array: Rational "1/3r" + Integer "5" / embed: Rational "1/3r" + Text "5"]

; ---- Complex (real +/- imag 'i', or imag 'i')  [S1 470 + table 518; G num_dec 309/315, num_complex_* 757-822; F value_types 125-143]
|complex
  |v :x 3+4i                       ; Complex "3+4i"
  |v :x 3-4i                       ; BareValue "3-4i"   [0.9: Complex "3-4i"]   -- see section 4: lost on 2026-01-09, restored 2026-07-15
  |v :x -3-4i                      ; Complex "-3-4i"   -- signed real takes '-' imag
  |v :x 5i                         ; Complex "5i"
  |v :x -5i                        ; Complex "-5i"
  |v :x +5i                        ; Complex "+5i"
  |v :x 0i                         ; BareValue "0i"   -- num_zero has no 'i' arm
  |v :x 0+4i                       ; BareValue "0+4i"
  |v :x 3.5-2i                     ; Complex "3.5-2i"   -- float real takes '-' imag
  |v :x 1.5+2.5i                   ; Complex "1.5+2.5i"
  |v :x 1e3+2i                     ; Complex "1e3+2i"
  |v :x 1+2e3i                     ; Complex "1+2e3i"   -- exponent in imaginary part
  |v :x 1E+3i                      ; Complex "1E+3i"
  |v :x 1e3i                       ; Complex "1e3i"
  |v :x 3+4I                       ; BareValue "3+4I"   -- lowercase i only
  |v :x 5ix                        ; inline: Complex "5i" + Text "x" / block: Complex "5i" + Text "x" / array: Complex "5i" + BareValue "x" / embed: Complex "5i" + Text "x"   [0.9: inline: Complex "5i" + Text "x" / block: Complex "5i" + Warning "AttributeValueExtendedByTrailingText" + Text "x" / array: Complex "5i" + BareValue "x" / embed: Complex "5i" + Text "x"]   -- suffix arm returns without checking the terminator

; ---- Keywords (phf perfect hash)  [S2 table 1499-1511; G keywords 47-51, accumulate 100-112; F value_types 147-209]
|keywords
  |v :x true                       ; BoolTrue
  |v :x false                      ; BoolFalse
  |v :x True                       ; BareValue "True"   -- lowercase only
  |v :x nil                        ; Nil
  |v :x null                       ; Nil
  |v :x ~                          ; BareValue "~"   -- S1 (2025-12-23) and value.rs had ~ as nil; dropped 2026-01-01
  |v :x NaN                        ; BareValue "NaN"   -- no special float spellings at any point
  |v :x inf                        ; BareValue "inf"
  |v :x -inf                       ; BareValue "-inf"
  |v :x Infinity                   ; BareValue "Infinity"

; ---- Dates  [T 30-49; G num_dec 311, maybe_date_month..date_complete 336-374; F temporal 269-287]
|dates
  |v :x 2025-01-03                 ; Date "2025-01-03"   [0.9: BareValue "2025-01-03"]
  |v :x 2025-12                    ; Date "2025-12"   [0.9: BareValue "2025-12"]   -- T calls this YearMonth; grammar emits Date
  |v :x 2025-1-3                   ; BareValue "2025-1-3"   -- T 307: should also WARN; no warning emitted
  |v :x 1-01                       ; Date "1-01"   [0.9: BareValue "1-01"]   -- digit count before '-' is not checked
  |v :x 12-34                      ; Date "12-34"   [0.9: BareValue "12-34"]
  |v :x 99999-01-01                ; Date "99999-01-01"   [0.9: BareValue "99999-01-01"]
  |v :x 2025-13-45                 ; Date "2025-13-45"   [0.9: BareValue "2025-13-45"]   -- no range check

; ---- Times  [T 52-77, 274-282, 352-362; G num_dec 313, maybe_time_min..time_frac 378-428; F temporal 293-341]
|times
  |v :x 09:00                      ; Time "09:00"   [0.9: BareValue "09:00"]
  |v :x 9:30                       ; Time "9:30"   [0.9: BareValue "9:30"]   -- T 309: should be WARN + bare string
  |v :x 123:45                     ; Time "123:45"   [0.9: BareValue "123:45"]
  |v :x 14:30:00                   ; Time "14:30:00"   [0.9: BareValue "14:30:00"]
  |v :x 14:30:00.123               ; Time "14:30:00.123"   [0.9: BareValue "14:30:00.123"]
  |v :x 14:30:00.123456789012      ; Time "14:30:00.123456789012"   [0.9: BareValue "14:30:00.123456789012"]   -- T 358: all digits kept
  |v :x 24:00:00                   ; Time "24:00:00"   [0.9: BareValue "24:00:00"]   -- T 274-282: end-of-day midnight kept literally
  |v :x 99:99:99                   ; Time "99:99:99"   [0.9: BareValue "99:99:99"]   -- no range check
  |v :x 14:30:00.                  ; Time "14:30:00."   [0.9: BareValue "14:30:00."]   -- empty fraction accepted
  |v :x 14:30.5                    ; BareValue "14:30.5"
  |v :x 14:30:00Z                  ; BareValue "14:30:00Z"   -- no zone on a bare Time
  |v :x 14:30:00+05:00             ; BareValue "14:30:00+05:00"

; ---- DateTimes  [T 81-110, 339-350, 456-469; G datetime_* 432-534; F temporal 347-395]
|datetimes
  |v :x 2025-01-03T14:30:00        ; DateTime "2025-01-03T14:30:00"   [0.9: BareValue "2025-01-03T14:30:00"]
  |v :x 2025-01-03T14:30:00Z       ; DateTime "2025-01-03T14:30:00Z"   [0.9: BareValue "2025-01-03T14:30:00Z"]
  |v :x 2025-01-03T14:30:00+05:30  ; DateTime "2025-01-03T14:30:00+05:30"   [0.9: BareValue "2025-01-03T14:30:00+05:30"]
  |v :x 2025-01-03T14:30:00-08:00  ; DateTime "2025-01-03T14:30:00-08:00"   [0.9: BareValue "2025-01-03T14:30:00-08:00"]
  |v :x 2025-01-03T14:30:00-00:00  ; DateTime "2025-01-03T14:30:00-00:00"   [0.9: BareValue "2025-01-03T14:30:00-00:00"]   -- T 339-350: accepted as UTC
  |v :x 2025-01-03T14:30:00.123Z   ; DateTime "2025-01-03T14:30:00.123Z"   [0.9: BareValue "2025-01-03T14:30:00.123Z"]
  |v :x 2025-01-03T14:30:00.123456789+05:30 ; DateTime "2025-01-03T14:30:00.123456789+05:30"   [0.9: BareValue "2025-01-03T14:30:00.123456789+05:30"]
  |v :x 2025-01-03T14:30           ; DateTime "2025-01-03T14:30"   [0.9: BareValue "2025-01-03T14:30"]   -- no seconds
  |v :x 2025-01-03T14:30Z          ; DateTime "2025-01-03T14:30Z"   [0.9: BareValue "2025-01-03T14:30Z"]
  |v :x 2025-01-03T14:30:00+05     ; DateTime "2025-01-03T14:30:00+05"   [0.9: BareValue "2025-01-03T14:30:00+05"]   -- offset hour without :MM accepted (T lists only +HH:MM)
  |v :x 2025-01-03T14:30:00+0530   ; BareValue "2025-01-03T14:30:00+0530"   -- basic-format offset rejected
  |v :x 2025-01T14:30              ; DateTime "2025-01T14:30"   [0.9: BareValue "2025-01T14:30"]   -- YearMonth + T + time accepted
  |v :x 2025-01-03T25:99:99        ; DateTime "2025-01-03T25:99:99"   [0.9: BareValue "2025-01-03T25:99:99"]   -- no range check
  |v :x 2025-01-03t14:30:00        ; BareValue "2025-01-03t14:30:00"   -- T and Z must be uppercase
  |v :x 2025-01-03T14:30:00z       ; BareValue "2025-01-03T14:30:00z"
  |v :x 2026-03-24T03:12:4.993290109288-says-what ; BareValue "2026-03-24T03:12:4.993290109288-says-what"   -- T 459: the spec's own no-lookahead example

; ---- Shorthand durations (number + s|m|h|d|w|mo|y)  [T 142-178, 249-255; G num_dec 317-322, dur_m 538-550, num_float_frac 687-692; F temporal 21-129]
|shorthand
  |v :x 30s                        ; Duration "30s"   [0.9: BareValue "30s"]
  |v :x 30S                        ; Duration "30S"   [0.9: BareValue "30S"]   -- case-insensitive (T 168)
  |v :x 5m                         ; Duration "5m"   [0.9: BareValue "5m"]   -- minutes
  |v :x 5M                         ; Duration "5M"   [0.9: BareValue "5M"]   -- also minutes
  |v :x 1mo                        ; Duration "1mo"   [0.9: BareValue "1mo"]   -- months
  |v :x 1Mo                        ; Duration "1Mo"   [0.9: BareValue "1Mo"]
  |v :x 1MO                        ; Duration "1MO"   [0.9: BareValue "1MO"]
  |v :x 2h                         ; Duration "2h"   [0.9: BareValue "2h"]
  |v :x 90d                        ; Duration "90d"   [0.9: BareValue "90d"]
  |v :x 2w                         ; Duration "2w"   [0.9: BareValue "2w"]
  |v :x 2y                         ; Duration "2y"   [0.9: BareValue "2y"]
  |v :x 1.5h                       ; Duration "1.5h"   [0.9: BareValue "1.5h"]   -- fractional
  |v :x 0.5d                       ; Duration "0.5d"   [0.9: BareValue "0.5d"]
  |v :x .5h                        ; Duration ".5h"   [0.9: BareValue ".5h"]
  |v :x 1_000s                     ; Duration "1_000s"   [0.9: BareValue "1_000s"]
  |v :x 0s                         ; BareValue "0s"   -- num_zero has no suffix arms
  |v :x 00s                        ; Duration "00s"   [0.9: BareValue "00s"]
  |v :x 0m                         ; BareValue "0m"
  |v :x 1e3s                       ; BareValue "1e3s"
  |v :x 30ms                       ; BareValue "30ms"
  |v :x 5min                       ; BareValue "5min"
  |v :x 30sec                      ; inline: Duration "30s" + Text "ec" / block: Duration "30s" + Text "ec" / array: Duration "30s" + BareValue "ec" / embed: Duration "30s" + Text "ec"   [0.9: BareValue "30sec"]   -- suffix arm returns without checking the terminator
  |v :x 30seconds                  ; inline: Duration "30s" + Text "econds" / block: Duration "30s" + Text "econds" / array: Duration "30s" + BareValue "econds" / embed: Duration "30s" + Text "econds"   [0.9: BareValue "30seconds"]
  |v :x 3days                      ; inline: Duration "3d" + Text "ays" / block: Duration "3d" + Text "ays" / array: Duration "3d" + BareValue "ays" / embed: Duration "3d" + Text "ays"   [0.9: BareValue "3days"]
  |v :x 1d12h                      ; inline: Duration "1d" + Text "12h" / block: Duration "1d" + Text "12h" / array: Duration "1d" + Duration "12h" / embed: Duration "1d" + Text "12h"   [0.9: BareValue "1d12h"]   -- T 172-178: compound shorthand is NOT recognized

; ---- ISO 8601 durations (P...)  [T 118-140, 264-270, 314-337, 364-375; G iso_dur_* 557-632; F temporal 135-263, 515-543]
|iso
  |v :x P1Y                        ; Duration "P1Y"   [0.9: BareValue "P1Y"]
  |v :x P2M                        ; Duration "P2M"   [0.9: BareValue "P2M"]   -- months (date side)
  |v :x PT2M                       ; Duration "PT2M"   [0.9: BareValue "PT2M"]   -- minutes (time side)
  |v :x P15D                       ; Duration "P15D"   [0.9: BareValue "P15D"]
  |v :x P2W                        ; Duration "P2W"   [0.9: BareValue "P2W"]
  |v :x P2M15D                     ; Duration "P2M15D"   [0.9: BareValue "P2M15D"]
  |v :x PT1H30M                    ; Duration "PT1H30M"   [0.9: BareValue "PT1H30M"]
  |v :x P1Y2M3DT4H5M6S             ; Duration "P1Y2M3DT4H5M6S"   [0.9: BareValue "P1Y2M3DT4H5M6S"]
  |v :x PT1.5H                     ; Duration "PT1.5H"   [0.9: BareValue "PT1.5H"]
  |v :x P0.5D                      ; Duration "P0.5D"   [0.9: BareValue "P0.5D"]
  |v :x P1_000D                    ; Duration "P1_000D"   [0.9: BareValue "P1_000D"]
  |v :x p1y                        ; Duration "p1y"   [0.9: BareValue "p1y"]   -- lowercase p accepted (F temporal:255)
  |v :x pt1h                       ; Duration "pt1h"   [0.9: BareValue "pt1h"]
  |v :x P1W2D                      ; Duration "P1W2D"   [0.9: BareValue "P1W2D"]   -- T 320: should WARN + reject
  |v :x P2WT4H                     ; Duration "P2WT4H"   [0.9: BareValue "P2WT4H"]   -- T 321: should WARN + reject
  |v :x PT1.5H30M                  ; Duration "PT1.5H30M"   [0.9: BareValue "PT1.5H30M"]   -- T 333: should WARN + reject
  |v :x P1.5DT2H                   ; Duration "P1.5DT2H"   [0.9: BareValue "P1.5DT2H"]   -- T 334: should WARN + reject
  |v :x P1D2Y                      ; Duration "P1D2Y"   [0.9: BareValue "P1D2Y"]   -- T 139 requires Y,M,D order; grammar takes any order
  |v :x P                          ; BareValue "P"   -- T 371
  |v :x PT                         ; BareValue "PT"   -- T 372
  |v :x P1                         ; BareValue "P1"
  |v :x P1DT                       ; BareValue "P1DT"
  |v :x Pizza                      ; BareValue "Pizza"
  |v :x P1Yx                       ; BareValue "P1Yx"

; ---- Relative times (+/- duration)  [T 182-220; G num_sign 116-120, rel_* 124-280; F temporal 401-509]
|relative
  |v :x +30d                       ; RelativeTime "+30d"   [0.9: BareValue "+30d"]
  |v :x -1h                        ; RelativeTime "-1h"   [0.9: BareValue "-1h"]
  |v :x +2w                        ; RelativeTime "+2w"   [0.9: BareValue "+2w"]
  |v :x +5m                        ; RelativeTime "+5m"   [0.9: BareValue "+5m"]
  |v :x +3mo                       ; RelativeTime "+3mo"   [0.9: BareValue "+3mo"]
  |v :x +1.5h                      ; RelativeTime "+1.5h"   [0.9: BareValue "+1.5h"]
  |v :x +P3M                       ; RelativeTime "+P3M"   [0.9: BareValue "+P3M"]
  |v :x -P1Y2M3D                   ; RelativeTime "-P1Y2M3D"   [0.9: BareValue "-P1Y2M3D"]
  |v :x +PT30M                     ; RelativeTime "+PT30M"   [0.9: BareValue "+PT30M"]
  |v :x -P1D                       ; RelativeTime "-P1D"   [0.9: BareValue "-P1D"]   -- T 289: the way to say a negative duration
  |v :x +5                         ; Integer "+5"   -- plain signed integer stays Integer
  |v :x -3.5                       ; Float "-3.5"
  |v :x -0s                        ; BareValue "-0s"
  |v :x +00s                       ; RelativeTime "+00s"   [0.9: BareValue "+00s"]
  |v :x +P                         ; BareValue "+P"
  |v :x -PT                        ; BareValue "-PT"

; ---- Leading-punctuation absorption (old :main default arm, values.desc 79)  [G typed_value :main 68-79]
|absorb
  |v :x $100                       ; Integer "$100"   [0.9: BareValue "$100"]
  |v :x $9.99                      ; Float "$9.99"   [0.9: BareValue "$9.99"]
  |v :x %5                         ; Integer "%5"   [0.9: BareValue "%5"]
  |v :x =5                         ; Integer "=5"   [0.9: BareValue "=5"]
  |v :x ~5                         ; Integer "~5"   [0.9: BareValue "~5"]
  |v :x *5                         ; Integer "*5"   [0.9: BareValue "*5"]
  |v :x /5                         ; Integer "/5"   [0.9: BareValue "/5"]
  |v :x _1                         ; Integer "_1"   [0.9: BareValue "_1"]
  |v :x __0xFF                     ; Integer "__0xFF"   [0.9: BareValue "__0xFF"]
  |v :x &1/3r                      ; Rational "&1/3r"   [0.9: BareValue "&1/3r"]
  |v :x ^2025-01-03                ; Date "^2025-01-03"   [0.9: BareValue "^2025-01-03"]
  |v :x €30s                       ; Duration "€30s"   [0.9: BareValue "€30s"]
  |v :x ..30s                      ; Duration "..30s"   [0.9: BareValue "..30s"]
  |v :x é5                         ; Integer "é5"   [0.9: BareValue "é5"]
  |v :x -.5                        ; BareValue "-.5"
  |v :x (42)                       ; BareValue "(42)"

; ---- Not numbers in any old era  [2011 notes only (section 6)]
|never
  |v :x 29.5px                     ; BareValue "29.5px"   -- 2011 attic: 'number with unit'
  |v :x 990xl                      ; BareValue "990xl"
  |v :x 50%                        ; BareValue "50%"
  |v :x 1k                         ; BareValue "1k"
  |v :x 42%                        ; BareValue "42%"
  |v :x 42,000                     ; BareValue "42,000"
  |v :x 1,5                        ; BareValue "1,5"

```

**Contexts.** Most lines behave the same everywhere. The differences are about what may follow the token (section 5, item 5). Two block-attribute cases stand out. In `|el` / `  :v 42 apples`, the whole line is `BareValue "42 apples"`: in block context space is content, so a number only stays typed if the line ends or hits ` ;`. And `  :v 42 ; note` gives `Integer "42 "`, with the trailing space inside the lexeme.

**What "parsed to" means here.** The old parser never converted anything. Each event is a type tag plus a zero-copy slice of the source (`Integer "0xFF"`, not 255). The tree layer kept the same shape: `tree.rs`@`grammar-v0.7` lines 106-136 hold `Value::Integer(Cow<str>)`, `Value::Duration(Cow<str>)` and so on. T 441-493 states the contract: the host parses the validated string. The only old code that produced actual numbers was `value.rs`, summarized in section 6.

## 2. The forms as a grammar, per source

### 2a. Spec text (S1 2025-12-23; S2 2026-01-01 kept the number part)

S1 EBNF 461-470, verbatim:

```
number        = float | integer ;
integer       = [ "-" ] ( dec_int | hex_int | oct_int | bin_int ) ;
dec_int       = [ "0d" ] DIGIT { DIGIT | "_" }* ;
hex_int       = "0x" HEX { HEX | "_" }* ;
oct_int       = "0o" OCT { OCT | "_" }* ;
bin_int       = "0b" BIN { BIN | "_" }* ;
float         = [ "-" ] DIGIT { DIGIT | "_" }* "." DIGIT { DIGIT | "_" }* [ exponent ] ;
exponent      = ( "e" | "E" ) [ "+" | "-" ] DIGIT { DIGIT }* ;
rational      = [ "-" ] DIGIT { DIGIT }* "/" DIGIT { DIGIT }* "r" ;
complex       = ( number | "" ) ( "+" | "-" ) number "i" | number "i" ;
```

S1 prose (525-535): "Numeric literals follow Ruby conventions: integers, floats, scientific notation (`1e10`), hex (`0x`), octal (`0o`), binary (`0b`), explicit decimal (`0d`), rationals (`1/3r`), and complex (`3+4i`). Underscores allowed for readability." It adds: "Plain `0755` is decimal `755` (leading zeros stripped, no implicit octal)."

S1 also had `nil_value = "null" | "nil" | "~"` (457). S2 (2026-01-01) dropped `~`; the rest of the number text is unchanged in S2 1513-1528.

### 2b. TIME-SPEC (T), 2026-01-09, revised 2026-01-13

| Type (T name) | Patterns | T lines |
|---|---|---|
| Date / **YearMonth** | `YYYY-MM-DD`, `YYYY-MM` | 30-49 |
| Time | `HH:MM`, `HH:MM:SS`, `HH:MM:SS.n…` (says "up to 9 digits" at 68, but "preserve all" at 352-362); `24:00:00` allowed | 52-77, 272-282 |
| DateTime | `<date>T<time>` with optional `Z`, `+HH:MM`, `-HH:MM`; `T` required, space not allowed; `-00:00` = UTC | 81-110, 339-350 |
| Duration (ISO) | `P[nY][nM][nD]`, `PT[nH][nM][nS]`, `P…T…`, `PnW`; components in order; fraction only on the smallest unit; at least one component | 118-140, 314-337, 364-375 |
| Duration (shorthand) | `N` + `s m h d w mo y`, integer or decimal N, case-insensitive, `m` = minutes and `mo` = months, no compounds (`1d12h` not recognized) | 142-178, 249-255 |
| RelativeTime | `+`/`-` + either duration form; `-P1D` is how to write a negative duration | 182-220, 284-291 |
| Recognition priority | bool, nil, relative, datetime, date, time, ISO duration, shorthand duration, number, string | 224-243 |
| Warnings | missing leading zeros, weeks mixed with other units, fraction on a non-smallest unit: each warns and falls to a string | 295-386 |
| Open questions | intervals `2025-01-01/2025-12-31`, RRULE, `2025-Q1`/`2025-H2`, IANA zones | 497-507 |

T 441-493 is worth reading whole. It explains why the events carry raw strings, using the example `2026-03-24T03:12:4.993290109288-says-what`. The 2026-01-09 draft (`3c5447d`) had specified decomposed components instead (`Date { year: u16, month: u8, day: Option<u8> }`, `Offset::Fixed { hours: i8, minutes: u8 }`, `Direction::{Past,Future}`). The 2026-01-13 revision replaced them with typed raw strings.

### 2c. The grammar (G), as a dispatch tree

What the machine actually accepts is laxer than T and S1 in specific places (section 3). Here it is from the first byte (G 67-79):

```
@          -> reference
0          -> num_zero:  x/X hex · o/O oct · b/B bin · . frac · e/E exp · [0-9_] -> num_dec
              (no arms for d, /, i, +, -, or duration suffixes)
[1-9]      -> num_dec:   [0-9_]* then
                 .   float_frac  (then e/E, i, +/-, or a duration suffix)
                 e/E float_exp   (then [+-]? [0-9_]*, i, +/-)
                 /   rational_denom [0-9_]* 'r'
                 i   Complex (returns immediately)
                 +   complex_sign ...'i'
                 -   date probe:  DD-MM[-DD][T…]   (digit count before '-' is NOT checked)
                 :   time probe:  HH:MM[:SS[.f*]]  (digit count before ':' is NOT checked)
                 s h d w y  Duration (returns immediately)   m -> m | mo
+ / -      -> num_sign:  P -> relative ISO · 0 · [1-9] -> rel_num_dec (as num_dec, but
              suffixes emit RelativeTime, and both + and - lead into complex)
p / P      -> ISO duration: digits then Y M D W, optional T then H M S; '.' fraction anywhere
letter     -> accumulate label chars -> phf keyword lookup (true false null nil) or BareValue
other      -> stays in :main and is absorbed into the token (section 5, item 2)
any mismatch anywhere -> :string, keeping the original MARK -> BareValue
```

## 3. Where the spec and the grammar disagree (both sides shown)

| Form | Spec says | Grammar did (`grammar-v0.7`, verified) |
|---|---|---|
| `0d42` explicit decimal | S1 463, S1/S2 prose: Integer | `BareValue`: `num_zero` has no `d` arm. Added 2026-07-15 (`7764e03`); 0.9 gives `Integer "0d42"` |
| `3-4i` | S1 470 allows `-`; `value.rs` parsed it; the pre-temporal grammar (`a6d23e7`, built and run) gave `Complex "3-4i"` | `BareValue`. Commit `d4c639b` (2026-01-09) changed `num_dec`'s complex arm from `'+-'` to `'+'` so that `-` could feed the date probe. `-3-4i` and `3.5-2i` still worked. Restored in `7764e03`. Already flagged in `spec/msc/FULL-EBNF.md` 366-376. |
| `1e10` (no point) | S1 EBNF 467: float needs `.`; S1 prose 527 lists `1e10` | `Float`. F value_types:91-94 records siding with the prose. |
| `+42`, `+2.5` | S1 EBNF: sign is `-` only | Accepted |
| `5.`, `1e`, `1e+`, `0x`, `0o`, `0b` | EBNF needs at least one digit after `.`, after `e`, and after a prefix | `Float "5."`, `Float "1e"`, `Integer "0x"`, and so on |
| `1/0r` | S1 silent; `value.rs` rejected a zero denominator | `Rational "1/0r"` |
| `0/3r`, `0i`, `0+4i` | S1 grammar allows `0` as numerator or real part | `BareValue` (no arms in `num_zero`) |
| `~` | S1 457 nil; S2 not | `BareValue "~"` (F value_types:167) |
| `2025-12` | T 37: **YearMonth** type | `Date` (G 343-348). Also flagged in REVIEW-JULY-2026 §4 #3. |
| `9:30`, `2025-1-3` | T 300-312: warn, then bare string | `Time "9:30"`. `2025-1-3` is a string but with no warning. No temporal warning exists anywhere in the parser; the deferral is noted at F temporal:565. |
| `1-01`, `12-34`, `99999-01-01`, `123:45` | T: `YYYY`, `HH` | All typed: digit counts aren't checked |
| `2025-13-45`, `99:99:99`, `T25:99:99` | ISO ranges implied | Typed. No range checks at all. |
| `P1W2D`, `P2WT4H` | T 314-324: warn and reject | `Duration` |
| `PT1.5H30M`, `P1.5DT2H` | T 326-337: warn and reject | `Duration` |
| `P1D2Y` | T 139: Y, M, D order | `Duration` |
| `+05` offset (no `:MM`) | T 89-90, 103: `±HH:MM` | `DateTime` (G 504-506, commented "+HH without :MM") |
| `2025-01T14:30` | T: `<date>T<time>` | `DateTime`: YearMonth + T is accepted (G 345) |
| `1d12h` | T 172-178: compound shorthand NOT recognized, so a string | `Duration "1d" + Text "12h"`; in an array, **two** Durations (section 5, item 1) |
| `0s`, `0m` | T 166: "integer or decimal number followed by unit" | `BareValue`, while `00s` is `Duration` and `+00s` is `RelativeTime` |
| `14:30:00.` | T: fraction digits | `Time` with an empty fraction |
| T and Z case | T silent; examples uppercase | `T`/`Z` uppercase only. `P`/`T` inside ISO durations are case-insensitive (`p1y`, `pt1h` both Duration; F temporal:255 asserts `p1y`). |

The 2026-07-08 estate review (`_archive/REVIEW-JULY-2026.md` §4, defect 3) ran a 49-case temporal audit and found "5 divergences — all in the validation layer, none in recognition". My audit confirms those five and adds the rows above that aren't validation: the `3-4i` regression, the suffix-split, the absorption, and the zero-led gaps.

## 4. How it stayed cheap to recognize

The evidence for each point is in the grammar and commit history cited.

1. **One forward pass, one byte per decision, no lookahead and no backtracking.** Every state is a byte-class switch (`|c['…']`). When a token stops looking like a number, the machine goes to `:string` and keeps the MARK set at the value's start (G 67). Nothing is rewound: the bytes already consumed simply become the string. A typed value and its string fallback cost the same O(len). T 456-469 states this as the design reason, and its `…-says-what` example is the case it addresses.
2. **Classify, never convert.** Emits are `Type(USE_MARK)`, a tag plus a zero-copy slice. Conversion is the host's job. The first `values.desc` (`3963593`, 2025-12-30) was a minimal integer/float-only classifier, written to benchmark against `lexical-core` with property tests. Its commit message: **"2.3x faster than value.rs for type detection."** `value.rs` scanned the token several times (`contains('.')`, `contains('e')`, `last()=='i'`) and built a `String` to parse each float. The same reasoning appears to be why TIME-SPEC dropped decomposed components between 01-09 and 01-13.
3. **The "priority list" is really a decision tree.** T 224-243 reads like an ordered try-list. The grammar realizes it as a structural fork at one byte after the digit run: `-` means date, `:` means time, `/` rational, `i` or `+` complex, `.` or `e` float, and a letter suffix means duration. `m` against `mo` costs one extra byte of consumption (`dur_m`). Nothing is ever tried twice.
4. **Keywords are looked up only once the token is label-shaped,** through a phf perfect hash (`|keywords[bare_kw]`, G 47-51, from `1c47224` 2025-12-31). Numbers never touch the hash.
5. **One machine for every context.** Termination is a parameter (`:space_term`, `:bracket`; G 13-15), so block, sameline, embedded and array share the same states. The cost is 3 states per form: every `*_space` / `*_block` pair in G is that plumbing. libudon `PLAN.md` lists "values.desc number parsing - 21 nearly-identical states" as an open DRY item.
6. **The flip side.** Everything a single-pass byte switch can't see without counting or remembering is exactly what's missing: digit counts, ranges, component order, week-mixing, fraction placement, and the T warnings. The validation layer was deferred and never built (F temporal:565).

For scale, these are the whole-document numbers of that era; numeric parsing was never benchmarked in isolation beyond the 2.3x figure. libudon `README.md`:47-61 gives the 15 KB comprehensive document at 1.35 GiB/s streaming. The umbrella `README.md` table gives 744-897 MB/s, against 335-372 MB/s for serde_json.

## 5. Surprises (all verified by running the parsers)

1. **A suffix arm returns without checking what comes next.** `30seconds` becomes `Duration "30s"` + `Text "econds"`, and `3days` becomes `Duration "3d"` + `Text "ays"`. `1d12h` gives `Duration "1d"` + `Text "12h"`, and in an array it gives **two** Durations. That directly contradicts T 172-178. The same shape affects `5ix` (`Complex "5i"` + `x`) and `1/3rd` (`Rational "1/3r"` + `d`). The cause is G 130, 133-138, 190-198, 309, 317-322, 540, 684, 687-692, 723 and 742: each emits on the suffix byte and `|return`s. **This still happens in 0.9 for `i` and `r`**: `30_udon.values` line 246 is `c['i'] | -> | Complex(USE_MARK) | return` and line 304 is the same for `r`, so 0.9 emits `Complex "5i"` + `Text "x"`, with an `AttributeValueExtendedByTrailingText` warning added in block context.
2. **Leading punctuation is absorbed into the number.** `$9.99` gives `Float "$9.99"`, and likewise `$100` and `%5` give Integer, `&1/3r` Rational, `^2025-01-03` Date, `€30s` Duration, `.5h` Duration, and `_1` and `.5` Integer. Cause: G 79, where `:main`'s `default | -> |>>` consumes the byte and stays in `:main`, so the first digit decides the type and the MARK still includes the junk. This was present from at least `a6d23e7` and fixed in 0.9 (`default -> :string`).
3. **`3-4i` was lost for six months** (2026-01-09 to 07-15) when temporal took the `-` after a digit run (section 3).
4. **Zero-led forms miss arms.** `0s`, `0m`, `-0s`, `0i`, `0/3r` and `0+4i` are strings, while `00s`, `+00s` and `0.5d` are typed. `num_zero` (G 283-300) never got the suffix, `/`, `i` or `+`/`-` arms that `num_dec` has. In 0.9, `0i`, `0/3r` and `0+4i` are still strings.
5. **In block context, the type depends on the rest of the line.** `:v 42 apples` gives one `BareValue "42 apples"`, and `:v true story` gives `BareValue "true story"`. This is by design (S2 277-291: space is content in block values) and stays single-pass: `*_block` states wait for ` ;` or EOL, and anything else becomes `:string`. Side effects found: `:v 42 ; note` gives `Integer "42 "` with the space in the lexeme, and `:v 30s later` gives `Duration` + `Warning "Inconsistent indentation"` + `Text`. 0.9 replaced all of this with self-terminating numbers plus the text-blob boundary model.
6. **`0d` was in every spec layer but never in the old grammar.** It appears in the 2011 vim highlighter, S1/S2 and `value.rs`; the grammar only got it in 0.9. One open point: 0.9 accepts `0d83.23` as `Float`. `design/composite-types.md` calls that leaf (in `<r: <i: 3 -7> 0d83.23>`) an "explicit-decimal float", but CORE's Numbers table defines `0d` only as an integer base prefix. Whether `0d` on a fraction is meant to signal an *exact decimal* type is not written down anywhere I found.
7. **Empty digit runs are accepted everywhere.** `0x`, `0o` and `0b` give Integer; `1e`, `1e+` and `5.` give Float; `14:30:00.` gives Time. 0.9 adds `0d`, which gives `Integer "0d"`.
8. **The case rules are a patchwork.** Shorthand suffixes are case-insensitive (`1MO` is months, `5M` is minutes), and so are ISO `p`/`t`. DateTime `T`/`Z` are uppercase only, while rational `r` and complex `i` are lowercase only.
9. **libudon HEAD build only:** when a value fails into `:string` inside `[…]` or `|{…}`, it ate the closing bracket. `[0xG]` gave `BareValue "0xG]"` + Error, and the same happened for `1/3R`, `30ms`, `29.5px` and others. `values.desc` is identical in both trees, so this comes from the rest of that era's grammar or codegen, not the value machine. `grammar-v0.7` doesn't do it. Anything consuming the January 2026 parser would have seen it.
10. **No overflow or range notion in the grammar at all.** `value.rs` returned String for an i64 overflow (`checked_mul`), so `9223372036854775808` was a string there. The grammar emits `Integer` for any digit run.
11. **A semver trap in the canonical example.** libudon `examples/comprehensive.udon`:11 has `:version 1.0`, which types as `Float`, while `:version 0.7.0` (line 307) is a string.

## 6. Earlier and adjacent material

**2011 (`~/src/_older/udon`).** These are design and highlighting only; no parser ever typed a scalar. I grepped `udon-c/lib/udon.c`, its `.machine` files and `ruby/udon/udon.statetable`: no numeric states.

- `misc/udon.vim` 43-50 (2011-07/08) has the most concrete number patterns of the era:
  - decimal with an **optional `0[dD]` prefix**: `\%(0[dD]\)\=\%(0\|[1-9]\d*\%(_\d\+\)*\)`;
  - hex `0[xX]\x\+\%(_\x\+\)*`;
  - octal `0[oO]\=\o\+…`, which means **a bare leading-zero `0755` was octal** (C-style), the opposite of the 2025 rule;
  - binary `0[bB][01]\+…`;
  - floats with an optional exponent `[eE][-+]\=\d\+`;
  - underscores only *between* digit groups;
  - only a `-` sign, guarded so `a-1` isn't negative;
  - a color literal `#\x\{1,8\}`.

  Every number pattern also ends in `\(\w*\|%\)*`, highlighted as `udonMVType`: a unit or kind suffix glued to the number.
- `.attic/examples_old/for_syn.udon` 26-34 is the highlighter's test sheet: `:float 39902.9`, `:int 1290`, `:date 3/7/2011`, `:time 5:23:90`, `:datetime 3/7/11 4:33am`, `:color #3221f902`, `:float-with-kind 29.5px`, `:int-with-kind 990xl`, `:interval 5-hours`.
- `.attic/syntax2.udon` 279-290 lists the planned scalars: string, string with encodings, integer (no size constraint), real, date, time, datetime, time-interval, color, "number with unit (e.g., 18px)". `.attic/syntax.udon` 221-224 adds "Integer (Bignum)".
- `examples/overview.udon` 31-41 lists: "int - decimal, hex, octal, binary", float, "infinity/neg-infinity/NaN (?)", "boolean (true,t,y,Yes,on,FALSE,...)", "date/time/datetime (w and w/o timezone)", "datetime-interval".
- `udon-c/docs/DECIDED.md` 216-241 (2011-12 to 2012-01): "Numbers: Integers (specified w/ Scientific Notation) (bignum?) Hex Octal Binary Floating point", plus Regex, Bitstrings, Binary, "(plugin for scalars)".

Numbers with units, colors, NaN/infinity, bignum and intervals never reached any 2025-26 spec or grammar. Intervals reappear only as `<temporal:interval:2026-01/2026-06>` in the 0.9 envelope fixtures.

**`value.rs` (2025-12-24 to 2026-01-02).** This was the converting classifier: `Integer(i64)`, `Float(f64)`, `Rational{numerator,denominator}` (i64s, rejecting a zero denominator), and `Complex{real,imag}` (f64s, splitting at the last sign that isn't part of an exponent). It accepted `~` as nil and `0d`. Overflow fell back to a string. Its bench list (`benches/values.rs`@`3963593`) includes `3-4i` and `1.5+2.5i` as Complex. Code: `git -C ~/src/_older/libudon show a6d23e7^:udon-core/src/value.rs`.

**udon-ruby (Dec 2025 to Jan 2026)** only re-exposed the event tag and raw content. It never got temporal: `_archive/implementation-status.md` 64-84 has the cross-implementation matrix.

**What survived into 0.8 and 0.9, for contrast.** Bare recognition is int and float. Rational and complex are "provisional" (CORE Numbers). `0d` is in. All temporal moved behind `<…>`, ratified 2026-07-11 in `_archive/DECIDED.bak.md` 196-232 ("ALL temporal values require the `<…>` envelope — including ISO date/time/datetime forms"). Envelope content passes through as a string with `Warning NoDialectsLoaded`. The working temporal machine is preserved verbatim, so the dialect can reuse it, at `core/generator/temporal-value.desc.setaside` (519 lines).

## 7. Limits of this sweep

- `test/usability/` and `test/scenarios/` were grepped for numeric literals but not read. They are agent-usage evidence and corpus documents, not specs.
- `spec/msc/greenfield-*` (the 2026-07-19 clean-room re-derivations, which were in git history only) were left out, as newer than the line asked about.
- The 2011 `udon-ruby`/genmachine submodules were never cloned (`submodules/` is empty), so any 2011 Ruby-side scalar experiments aren't here.
- I didn't regenerate `parser.rs` from `values.desc` myself; I ran the parsers committed with each tree. `grammar-v0.7` passes its own suite (7 tests, including `fuzz_temporal_values` with 1000 iterations). My probe results agree with every expectation in `legacy-pre-0.8/temporal.yaml` and `value_types.yaml` that I compared, but I didn't run those two files through a harness. At that tag they weren't part of the active group.

Probe tooling and raw outputs are in the same scratchpad directory, under `scripts/` and `probe-*.txt`, if you want to rerun with other lexemes. Usage: `python3 -I scripts/probe.py <parser-binary> < cases.txt`; the binaries are under `v07/`, `libudon/` and `pretemporal/`.
