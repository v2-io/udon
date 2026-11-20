# Fork S: bounded streaming, and whether it chooses between whole-run typing and "bare is text"

*Fork S of spike b, 2026-10-22. Labels: **[ran]** = I executed it; **[read]** = I read it in code or docs; **[inferred]** = my reasoning; **[taste]**.*

## What I found, and how sure I am

1. **No UDON parser, old or current, streams a value's characters before the value ends.** The 0.9 resumable (pushdown) parser emits each content event once, whole, at the end of its run, and it holds the whole run in its buffer until then. This holds for a number, a bare word, sameline text with spaces, a prose line and a quoted string alike. **[ran]**, high confidence: I fed `|el :a <200 KB run>` in 1 KB chunks. The first content event arrived only after the last byte, for every one of the six kinds of run I tried (digits, letters, `4…4p`, `ab ab …`, a prose line, a quoted string). The code says the same: `drain_consumed` keeps the buffer from `mark_pos`, and every emit is `Type(USE_MARK)` at `TERM` ([read] `core/udon-core/src/parser_pd.rs` 655–700, 782–830; `core/generator/20-udon.attributes.descent.udon` 382–452). The line-oriented wrapper over the recursive backend holds each whole line and errors past 4 KB (`parser.rs` `StreamingParser`, `max_buffer` 4096). The old libudon wrapper had the same 4 KB line buffer [read], and the old value machine emitted tag + slice at the token's end [read, via `old-numeric-typing.md` §4].
2. **So the streaming objection does not separate whole-run typing (B) from "bare is text" (C) on the parser as built.** Both hold exactly the run, which in lite is bounded by its line. Joseph's `4938422…2412124p` is already held whole by the 0.9 parser today, and it comes out as `BareValue` *after* the `p` [ran]. That is whole-run classification, at no extra cost, because the run was being held anyway. High confidence.
3. **The principle "shape within a bounded distance; the kind of a finished span may trail it" is true as a statement of what is possible. It meets Joseph's actual concern only together with a wire change that neither option has today.** His concern: "buffer essentially unlimited amount of the incoming stream before being able to output any partial text or partial node." Output of partial text requires content events that can be emitted in fragments. Once the wire has those, C's text streams from its first character. B's text streams too, with its kind reported after it as a trailer, and a finite-state classifier running alongside costs O(1) memory. Without fragments, neither streams partial text. [inferred], high confidence on the logic.
4. **The codebase has met this choice once, as a matter of fact, and put the kind first with holding.** descent's HOLD/RELEASE exists because "the ruled wire puts the Attr BEFORE the value events, which no lookahead-free single pass could otherwise produce" (`tools/descent/CHANGELOG.md`, Unreleased; `$key` vs `$partial-key`, decided at the `]`). That is a late-decided head label, buffered up to the end of the line. A trailer (emit `$key`, then the value, then "it was partial") was the alternative and wasn't taken. [read]. This is precedent, not a reason. It shows only that the choice is real and has a working mechanism either way; whether kind-first is right has to be judged against the CTQ factors (below), not inherited.
5. **Who actually needs a value's kind before its characters: almost no one, and under C they have it anyway at the raw layer.** Details below. The genuine cases are a pass-through filter by kind and a live highlighter. Under C the raw kind is known at the first character (the form decides it). A consumer that uses the typed-primitive view is back to learning the kind at the end, exactly as under B. [inferred], medium-high confidence.

**Net:** the streaming veto, as Joseph framed it, is not a reason to prefer C over B, nor to deny C's view a place in the language. B vs C has to be decided on its other grounds: misclassification risk (`:version 1.0`, `:sha 1e10a3f`), stability (one tree everywhere), domain-forwardness. What streaming does decide is a separate and real question: **should lite's wire emit content in fragments, or cap the line?** Today the only defense against Joseph's DoS case is the 4 KB line cap in the recursive wrapper; the pushdown parser has none [read: no cap in `parser_pd.rs`].

## The checks, in more detail

**What was run.** A scratch crate (outside the repo; `CARGO_TARGET_DIR` in the session scratchpad) depending on `udon-core` by path, feeding documents to `PushdownParser::push_chunk` in 1024-byte chunks and logging the fed-byte count at each event:

| Document | First content event after | Event |
|---|---|---|
| `|el :a ` + 200 000 × `4` | all 200 008 bytes | `Integer` |
| `|el :a ` + 200 000 × `a` | all 200 008 | `BareValue` |
| `|el :a ` + 200 000 × `4` + `p` | all 200 009 | `BareValue` |
| `|el :a ` + 70 000 × `ab ` | all 210 008 | `Text` |
| `|el` / `  ` + 70 000 × `ab ` (prose) | all 210 007 | `Text` |
| `|el :a "` + 200 000 × `a` + `"` | all 200 010 | `StringValue` |

Structure events (`ElementStart`, `Name`, `Attr`) fired in the first chunk; content waited for its end in every case.

**What lite's line structure implies.** [inferred from the cards] In lite, no capture spans a line end: delimited strings and `<…>`, `@{…}`, `;{…}` must close on their line; sameline runs end at the line end; prose and fence bodies are line by line. So the worst holdback of any lite construct, under the current event model, is **one line**, and a line is unbounded. The practical streaming law for lite is therefore "longest line × (holding vs fragmenting)", and it is independent of how values are typed.

## Shape decisions and their real lookahead (inventory)

The principle needs shape decisions to be bounded. From the cards and the grammar [inferred unless marked]:

| Decision | Lookahead | Bounded? |
|---|---|---|
| Structure at a line start (`|`, `:`, `;`, backticks, `!`, `@`) and `{` for an embed | 1–2 characters (Joseph's `!'{'`) | yes |
| A text run ends at ` |name`, ` :name` | space + marker + first name character | yes |
| A framed ` ; ` or ` \ ` | 3 characters | yes |
| Trailing spaces before a terminator | held as a count (memory O(1); the spaces themselves are re-emittable) | yes |
| Fence opener (N backticks) | a count | yes |
| `[key]` vs `[partial-key` (attr name before the value) | the key, to the `]` or the line end | **only by the line**; done today by HOLD |
| Suffix-colon attributes (`|el first: 1`, set aside 2026-10-22) | one whole label, to see whether a `:` follows | **only with a label-length cap**. Joseph proposed exactly that cap ("if we had a length limit on attribute name labels"), so his intuition matches this inventory. |
| Whole-run typing (B) | none for shape: the run's *end* is found by the same bounded guards as under C. Only its kind waits. | shape yes; the kind trails |

So B and C have the same shape behavior. They differ only in whether a kind label is attached to the finished run.

## Who needs the kind before the characters

| Consumer | Needs kind first? | Note |
|---|---|---|
| Tree builder | no | stores the node after the content arrives anyway |
| Converter to host values (int, bignum, float) | no | needs every digit regardless; it holds the spelling under any design, and that hold is the consumer's, not the parser's |
| Schema / slot validator | no | validates the finished value |
| Round-trip re-emitter, formatter | no | |
| Pass-through filter by kind ("drop all numbers, stream the rest") | **yes**, or it holds each run until its trailer arrives | under C, raw kind is known at the head; with the view, it's not |
| Live highlighter streaming to a terminal | **yes**, or it holds/recolors per run | display latency of one run; editors re-highlight anyway |
| Routing of a value to typed storage (columnar) | no; routing happens at the value's end | |

[inferred] The two that need it are real but narrow, and both can hold a single run (bounded by its line), which is what every parser does today anyway.

## What I'd change in the CTQ wording (for Joseph; a proposal)

`CTQ-FACTORS.md` currently says, under "What has moved", "Every construct's kind is known within a few characters", and B1's footnote says "No construct holds an unbounded stretch before its kind is known". Read literally, that wording makes B fail a veto that Joseph's stated concern does not make it fail, and it is not true of any UDON parser that has existed: each one learns a value's kind at the value's end. A wording that says what he described:

> **Bounded streaming.** Where a construct ends and what contains it are known within a few characters. A parser never needs to hold an unbounded stretch of input to decide them. A classification of a finished span (its kind) may be reported after the span. Whether content itself is emitted in fragments or held to its line end is a wire choice, measured as the longest holdback (today: one line).

**Its grounds, in CTQ terms** (my reasoning):
- **B1, bounded streaming.** Its purpose, in Joseph's words, is that a parser is never "forced to buffer essentially unlimited amount of the incoming stream" (DoS, overflow). The rewording vetoes exactly that and nothing more. The current wording also vetoes a reported-after kind, which holds nothing.
- **B3, stability.** Unaffected: the tree is the same whichever end of the span the kind is reported at.
- **B5, parse speed.** A trailer costs nothing. Kind-first costs a hold-and-flush wherever the kind is late (descent's own measurement for HOLD is ~50 ns per held cycle, a fact about that mechanism rather than a reason).
- **A7, syntactic simplicity, and A6, spec clarity.** One rule ("shape bounded, kinds may trail") replaces a requirement that every parser in this line has had to work around.
- **Against it:** the two consumers in the table above (filter by kind, live highlighting) get the kind later. That's a cost under D1 (agent tooling) and D3 (editor integration), each bounded by one run.

Whether "kind may trail" is acceptable is Joseph's call.

## Where this leaves the open bit of (C)

The coordinator's context file records that "the same objection decided C's open bit: a bare run spelling a primitive is not typed" (`src/rule-unquoted-run-is-one-value.context.md`). On the evidence here, that objection does not decide it. The bit is still open and has to be settled on non-streaming grounds. Joseph's own non-streaming reason ("8080 being text that I haven't turned into a number yet … is definitely ok to me surprisal-wise") stands untouched. It just stands alone.

## Limits

- I did not run the recursive backend's `StreamingParser` (I read it); nor the old parsers (I relied on `old-numeric-typing.md` and its agent's runs).
- I did not test multi-line constructs (attribute bodies, comment blocks), since none of them holds a single capture across lines in lite as carded.
- "No consumer needs the kind first beyond the two listed" is an enumeration, not a proof.
- Scratch probe: `/private/tmp/claude-505/-Users-josephwecker-v2-src-arch-firmatum-udon/1be2ea77-59e1-4dec-803a-2bcb3f1f7265/scratchpad/forkS/src/main.rs` (temporary; the table above is its output).
