---
source: ~/src/_ref/_arch/sar2/experiment/results/*/confidence_intervals.csv — the actual measured response-latency data from the SAR game-engine comprehension experiment (4 model families, n=10)
gathered: 2026-07-21
status: gathered (verbatim excerpt of the 4 main-run CSVs + editorial; the .archive/ runs and per-run .json/.time raw files not copied — say so)
paths:
  - /Users/josephwecker-v2/src/_ref/_arch/sar2/experiment/results/claude-run-2025-11-14-n10/confidence_intervals.csv
  - /Users/josephwecker-v2/src/_ref/_arch/sar2/experiment/results/deepseek-run-2025-11-14-n10/confidence_intervals.csv
  - /Users/josephwecker-v2/src/_ref/_arch/sar2/experiment/results/codex-run-2025-11-14-n10/confidence_intervals.csv
  - /Users/josephwecker-v2/src/_ref/_arch/sar2/experiment/claude-run-2025-11-14-n10/confidence_intervals.csv
source_commit: (non-git) source_mtime 2025-11-14 (haiku run 2025-11-16)
categories: [agent-comprehension, empirical-demand-evidence, honest-negative-result, alignment-cognitive-load, eval-methodology, tier2-shipped-practice]
why_included: >
  Un-cherry-picked measured data on whether notation alignment makes an agent
  FASTER — and it is a mixed, partly-negative result, which is exactly the kind of
  honest evidence the compilation values over a clean claim. This is the empirical
  counterweight to the README's "aligned = ~14% faster" hypothesis (see
  sar2-experiment-README-GAME-ENGINE.md). Surfaced as a Joseph-facing open item
  below. See the three-way note before relying on any single number.
---

> **Editorial banner — read before citing any number.** These are **response-latency**
> measurements (median wall-time per model response, in microseconds, per code
> variant `{elixir, sar, sar_aligned}`, n=10 per cell, with MAD / bootstrap CIs /
> trimmed means). **Latency is NOT the comprehension metric** the experiment's
> README advertises — the README's headline ("aligned SAR: 100% immediate
> comprehension, no tool re-reads; ~14% faster") comes from a *prior genserver*
> run and is about re-read behavior + accuracy, which are scored by
> `compare_answers.rb` / `analyze_turns.rb` against the raw per-run JSON, **not
> pre-computed into any summary in the tree** (confirmed: no written
> conclusions file exists; `grep -rl 'conclusion|winner' sar2/experiment/*.md`
> matched only the README). So what we have verbatim is the latency layer.
>
> **The three-way picture (factual, not a verdict):**
> - **README claim:** aligned notation → faster + fewer re-reads (from the prior
>   genserver experiment).
> - **This game-engine latency data:** does **not** cleanly reproduce a speed
>   advantage for alignment. Of the four model families, only **codex** shows
>   `sar_aligned` fastest; **claude** shows `sar_aligned` *slowest* (aligned median
>   246,645 µs > plain elixir 215,530 µs — the counter-result); **deepseek** and the
>   archived **opus n15** run both put plain `elixir` fastest with aligned in the
>   middle.
> - **Caveat that keeps both alive:** latency ≠ comprehension. The alignment thesis
>   is fundamentally about *reader parse cost / re-read avoidance*, and that signal
>   was never extracted from these runs. A slower response can even co-occur with
>   deeper (single-pass) reading. The honest status: **the speed sub-claim does not
>   robustly reproduce here; the comprehension claim is neither confirmed nor
>   refuted by this data — it was left unmeasured.**
>
> **Why this belongs in the compilation:** it is genuine, un-massaged demand-side
> evidence for *and against* the "regular notation helps the agent" hypothesis that
> UDON's alignment/autocolor work rests on — the rare cross-model empirical probe in
> the whole neighborhood, honest enough to have logged a result its own README
> hoped against.

## `*(open question — worth Joseph's eye)*`

The README asserts a comprehension + speed win from alignment on the strength of a
prior genserver run; this larger game-engine run's latency data pushes back on the
speed half and the comprehension half was never scored into an artifact. Worth a
call: is the alignment-speed claim one to (a) re-run the scorer over the existing
raw JSON to settle, (b) carry forward as "comprehension-plausible, speed-unproven,"
or (c) treat the whole SAR-alignment thesis as a hypothesis UDON should test fresh
against CORE-0.9 notation rather than inherit? Flagging rather than adjudicating.

---

## Verbatim data — the four main runs (`n=10`)

### claude-run-2025-11-14-n10 — *the counter-result (aligned slowest)*

```csv
variant,median,mad,ci_lower,ci_upper,percentile_lower,percentile_upper,bootstrap_lower,bootstrap_upper,min,p5,p10,p25,trimmed_mean_25,n
elixir,215530.0,47484.712799999994,122459.96291200002,308600.037088,176106.025,330710.60000000003,185249.0,267844.0,174466.0,177746.05,181026.1,190270.0,180490.0,10
sar,233089.5,48138.539399999994,138737.96277600003,327441.03722399997,164078.30000000002,294984.5,208239.0,272556.0,156845.0,171311.6,185778.2,210817.5,184692.33333333334,10
sar_aligned,246645.5,28391.0487,190999.044548,302291.955452,224865.15,283192.0,233178.5,273958.5,224259.0,225471.30000000002,226683.6,238867.0,229966.66666666666,10
```

### codex-run-2025-11-14-n10 — *the one run where aligned is fastest*

```csv
variant,median,mad,ci_lower,ci_upper,percentile_lower,percentile_upper,bootstrap_lower,bootstrap_upper,min,p5,p10,p25,trimmed_mean_25,n
elixir,175920.0,77780.9025,23469.431100000016,328370.56889999995,92395.57500000001,253881.67500000002,104435.0,226348.0,89523.0,95268.15,101013.3,112169.5,98749.33333333333,10
sar,147700.0,35397.8163,78320.280052,217079.71994799998,48761.525,263402.07500000007,64318.0,168931.0,46775.0,50748.05,54721.1,79681.5,55565.666666666664,10
sar_aligned,136161.0,95986.4892,-51972.518832,324294.518832,43655.67500000001,232045.90000000002,91397.0,228048.13749999995,33773.0,53538.350000000006,73303.70000000001,95643.5,67987.0,10
```

### deepseek-run-2025-11-14-n10 — *elixir fastest, aligned middle*

```csv
variant,median,mad,ci_lower,ci_upper,percentile_lower,percentile_upper,bootstrap_lower,bootstrap_upper,min,p5,p10,p25,trimmed_mean_25,n
elixir,151093.0,14839.3434,122007.886936,180178.113064,96428.0,164651.525,135745.5,158434.16249999998,85664.0,107192.0,128720.0,139507.0,119051.66666666667,10
sar,163053.5,22963.9914,118044.076856,208062.923144,111469.55,210552.15000000002,131376.0,178542.5,111416.0,111523.1,111630.2,140248.5,119900.66666666667,10
sar_aligned,155209.5,27173.8341,101948.785164,208470.214836,130801.25,242206.62500000003,135371.0,178003.5749999999,130664.0,130938.50000000001,131213.0,139237.75,133699.66666666666,10
```

### ollama-run — *no confidence_intervals.csv in main results (only raw runs); not summarized*

Directories `results/ollama-run-2025-11-14-n10/` and `.../n3/` exist but carry no
`confidence_intervals.csv`, so no aggregate row is available without re-running the
analyzer.

### archived: opus-run-2025-11-14-n15 (`.archive/`) — *elixir fastest, aligned middle; larger n but archived*

```csv
variant,median,mad,ci_lower,ci_upper,percentile_lower,percentile_upper,bootstrap_lower,bootstrap_upper,min,p5,p10,p25,trimmed_mean_25,n
elixir,158735.0,40289.655,79767.27620000001,237702.72379999998,124007.25,292276.0,131560.0,255078.0,122185.0,125829.5,129474.0,136436.0,127739.66666666667,11
sar,152083.5,50151.1689,53787.208956,250379.791044,29186.25000000003,262499.55,118257.0,205200.17499999987,-1523.0,59895.50000000001,110744.0,119327.0,74913.66666666667,12
sar_aligned,141348.0,49211.2005,44894.04702,237801.95298,-5188.049999999999,312598.32499999995,111595.5,208233.8749999999,-5864.0,-4512.1,7347.400000000009,115329.25,31619.333333333332,12
```

*(An older `codex-run-...-n15` is also in `.archive/` with much larger absolute
latencies — different run conditions — and per-model raw `*.json`/`*.time` files
sit beside each CSV, not copied here. The scoring harness that turns raw runs into
answer-accuracy/turn-count is `analyze.rb`, `analyze_turns.rb`, `compare_answers.rb`,
`plot_confidence_intervals.py` — reusable methodology, not itself a finding.)*
