# UNIF-PASS — questions, findings, and probe data (2026-08-09)

**For Joseph's adjudication.** Kept per the conflict-time protocol: where the
pass hit a collision or a load-bearing inference, it is stated here in the
prescribed shape — *quote what you said, state what was assumed, ask whether
the implication holds* — rather than resolved silently. The rewritten suite
marks each dependent subsection with a pointer here; flagged readings in the
spec text are leans, not law.

## Q1 — late attributes (RESOLVED mid-pass → K14)

Your worksheet case 1 ("A warning is issued, but still becomes an attribute of
'element'") vs the K9-row rider ("no warned-accept tier needed"). Bubbled;
you ruled **accept + warn**; §6.9 is written accordingly. Kept here only as
the specimen that produced the conflict-time protocol.

## Q2 — clean-value-position scope: where do brace forms self-delimit?

**What you said:** "the current spec is the hack — the tell is the space. The
new clean model is `:'$main' [|{embed-1}, |{embed-2}]` period" — demonstrated
at the `$main` slot; and `:n |{em x}`-style attribute slots rode the same
discussion. **What was assumed** (by the spike/fork analyses, which you said
you hadn't followed the implications of): a full per-context table — list
items YES, identity brackets NO, deferred-body first line NO.

**The question, in your shape:** when you said the space-separated embeds are
stacked values, were you implying that rule reaches (a) **list items**
(`[|{a} |{b}]` — two element items? The analyses lean yes: it is the most
value-like context of all); (b) **identity brackets** (lean no — you ruled
only "block forms out of `[key]`s", and a structural `$key` seems paths-era);
(c) **a deferred body's first line** (lean no — there is no continuing scan
there for a self-delimited value to return to, so K7's first-line rule would
treat `|{em x}` alone as... currently unstated)? The spec text states only
the two positions you demonstrated and marks the rest unruled.

## Q3 — fresh-mind probe results (sonnet, zero context; useful, not binding)

- **Probe A** (bare `:key value` priming): read `|el :a 1 extra` as `a="1
  extra"` and `:note hello there :b 2` as note slurping `:b 2` — i.e. the
  naive first-contact instinct matches the *retired* greedy rule, not K10.
  Matched K13's escape exactly (`\:value` → `":value"`). Expected quotes
  *visible* in `|greeting "hi there," she said`.
- **Probe B** (inline-element priming): sided **with** K9 on embed-siblings
  and space-as-separator; read an interleaved `:height 20` after prose as an
  attribute (supports K14); expected `done?` bare to mean true (against
  K12's explicit-presence).
- Read: first-contact intuition tracks pre-K9 physics on greed and flags;
  your frequency argument (data-writing agents want multi-attribute lines
  constantly; emoticons/flag-idioms are rarer and tooling-visible) is the
  counterweight and is now stated in the spec where it applies (§3 note,
  §6.2). No action proposed; recorded as calibration data.

## Q4 — inferences I made that you should see (each: said / assumed / ask)

1. **`:disabled?` bare becomes the missing-value Error.** You said the
   implicit-true default "wasn't/isn't worth the awkwardness"; K6 says every
   assignment takes a value. Assumed: bare `:disabled?` now Errors (Nil), and the
   idiom migrates to `:disabled? true`. Were you implying the Error, or would
   you rather bare `?`-keys get some gentler landing?
2. **Framed ` ; ` terminates an open unquoted text value.** You said values
   "end with a space + valid block-start"; the framed comment was already a
   value-ender pre-K10. Assumed: it remains one (§6.4, §8). Confirm?
3. **`AttributeAfterChildren` code name survives with the keep shape
   flipped** (accepted attribute, K14). Rename candidate if you'd rather the
   name not say "after children" about something legal: `LateAttribute`.
4. **Late `$key` + streaming:** consequence noted in §6.9/§12.3 — identity
   is complete only at element close. No carve made; consumers warned. OK?

## Q7 — "label ladder" collision (terminology pass)

**What you said:** attribute name-side = label; verbatim tag = kind; key =
identity. **What surfaced:** §11.6's envelope "label ladder"
(`<dialect:type:content>`) is a *third* pre-existing sense of "label."
**Assumed provisionally:** renamed to **envelope ladder** in GLOSSARY/CORE
with a pending-steward note. Were you implying the envelope's parts also
stop being "labels" — and if so, is "envelope ladder" (or another word —
"tag"?) the name you want?

## Q5 — relics found by this pass (candidates, not rulings)

1. **"Content phase" is now vestigial as a concept.** After K14 it no longer
   closes anything — it is only the trigger for the late-attribute Warning.
   The rewrite keeps the *behavior* but retires the phrase (GLOSSARY);
   flagging in case the phase concept was doing work elsewhere in your head.
2. **Element suffix sugar (`|el?` → `:$? true`)** is now the only bare-`?`
   with built-in meaning (flagged in K12's row). Keep or retire — one call.
3. **`EscapeOutsideHeadPosition` advisory code** predates K13 and probably
   describes nothing real anymore (past-base `\` is just literal text by the
   two-space model). Candidate for retirement at fixture time.
4. **The `|` element guard's suffix-char clause** (`|?` parses via `? ! * +`)
   reads oddly now that those characters are ordinary *key* characters —
   fine as is, but the asymmetry (elements restrict; keys don't) is now the
   explanation, and the old wording implied flags.

## Q6 — versioning (RESOLVED)

0.10.0-alpha.1 inside `current-0.9.1-spec/`, banner explains, directory
rename deferred to you. Done per coordinator relay.

## Pass inventory (what changed where)

CORE.md rewritten whole (§2.2 two-spaces; §3 guards + K12 note; §4 K13; §5.3
sugar incl. $main + K1/K2; §6 rebuilt — labels/K12, terminators/K10, slots &
line roots, silent stacking/K11, node values, late-attributes/K14, $main;
§7 text-space; §11.4 four states; §14 sole-Error; appendices re-derived).
MODEL.md: Assignment = {label, content}; $main sugar row; text-law scope; value
kinds incl. InlineElement/Directive. SEMANTICS.md: $main non-equivalences,
inline-vs-block equivalence, reflow-forbidden row. GLOSSARY/TUTORIAL/README/
DELTAS/CARVEOUTS: synced (see commits). Suspect-list rule applied: every
pre-K9 "prose/blob/forced/commits" sentence was rederived, none consolidated.
