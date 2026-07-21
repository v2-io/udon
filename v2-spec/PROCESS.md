# v2-spec process — agent-primary, steward-gated

**Status:** **provisional operating agreement** for `v2-spec/` and sessions
advancing the 0.10 suite — *in force while useful, never sacred*.  
**Audience:** agents (default operators) and Joseph (steward).  
**Why this exists:** UDON’s primary consumers are agents. The prior default
(every residual fork waits for a Joseph sitting) made the non-primary user
the bottleneck. Turnover is real; **files**, not conversational continuity,
are the project’s identity.

> **Meta first.** This process is an experiment. Details (decision classes,
> session shapes, spike norms) are **hypotheses to revisit**, not calcified
> law. See [§0](#0-meta--the-process-is-open) and
> [PROCESS-FEEDBACK.md](PROCESS-FEEDBACK.md). If reality fights a rule,
> change the rule — do not pretend compliance.

---

## 0. Meta — the process is open

### 0.1 Standing invitation

**Every operator and the steward are invited, at any time, to critique and
amend this process** — friction, dead weight, missing permission, wrong
defaults, “this class is too heavy,” “spikes got prescriptive,” “STATUS is
noise,” anything.

That is not a side hobby. **Process fitness is load-bearing work.** A session
that only improves PROCESS/FEEDBACK when the machinery is wrong has done
real project work.

### 0.2 Side channel (always open)

| Path | Use |
|------|-----|
| **[PROCESS-FEEDBACK.md](PROCESS-FEEDBACK.md)** | Append-only log: observations, proposals, what was tried, what hurt |
| **This file (PROCESS.md)** | Apply accepted amendments with a **dated changelog** at the bottom |
| **STATUS handoff** | One line is enough: “process friction: …” |

No ticket, no STEWARD sitting, no severity gate is required to **write**
feedback. Implementing a process change follows §0.3 so the repo stays
coherent — not so speech is chilled.

### 0.3 Changing the process (how amendments land)

| Kind of change | How |
|----------------|-----|
| **Typo / clarity / examples** | Operator edits PROCESS directly; note in changelog |
| **Local norm that only affects agent workflow** (session templates, spike tone, STATUS shape) | Operator lands it; append FEEDBACK entry “changed X because Y”; steward may reverse later |
| **Authority or spine movement** (who may close language forks; what is STEWARD-only; greenfield charter) | Write proposal in FEEDBACK; prefer a second agent pass if contested; steward mark if it narrows/widens *steward* power or external stakes |
| **“This whole mechanism is wrong”** | FEEDBACK entry + proposed replacement sketch; STATUS flags process rethink; **do not** keep performing a broken ritual while waiting |

**Anti-calcification rule.** Any PROCESS mechanism that has not been
*exercised* or *explicitly reaffirmed* in a long stretch of real work is
suspect. Prefer deleting unused ceremony over “we might need it.”

**Assumption register.** §11 lists active process assumptions. Operators
SHOULD challenge them when evidence appears. Challenging an assumption is
success, not insubordination.

### 0.4 Spikes vs process vs law

| Layer | Stakes | Prescriptiveness |
|-------|--------|------------------|
| **Spike** | Low — disposable exploration | **Minimal** — question + freedom; see §5 |
| **Process** | Medium — how we work | Provisional; easy to amend (§0) |
| **DECISIONS / suite** | High — language or contract meaning | Evidence bar; harder to reverse |

Do not apply high-stakes ceremony to low-stakes layers. Especially: **do not
force decision classes onto spikes.**

---

## 1. Roles (turnover-safe)

No role assumes a continuous person. A “role” is a **permission set for a
session**, not an identity that remembers.

| Role | Who (this session) | May | Must not |
|------|--------------------|-----|----------|
| **Steward** | Joseph | Charter values; external/human stakes; explicit STEWARD gates; veto; “who is this for?”; process changes that redefine steward power | Be the default adjudicator for agent-primary ergonomics |
| **Operator** | Any agent session | Advance the suite; run spikes; propose and land agent-primary closes; amend process per §0.3; leave handoffs | Silent syntax invention; claim completion without files; perform broken process without filing feedback |
| **Panel pass** | An independent operator pass on a shared brief | Concur, dissent, or stress-check a proposed close | Soft-merge without naming the split |

**There is no “lane owner.”** Continuity does not live in an agent; it lives
in **area briefs** and **session charters** (§4). Any operator may pick up
any area by reading the brief + STATUS + OPEN for that area.

**Primary-user rule.** Choices that mainly affect how agents write, stream,
repair, address, or tool UDON → operators by default. Choices that mainly
affect human authorship culture, external published consumers, project
identity, or irreversible charter → steward (or steward mark).

**Veto is not the workflow.** Steward may reverse a landed decision with a
short DECISIONS Overturn. That is cheaper than steward marks on every row.

---

## 2. Decision classes — provisional scaffolding

> **Assumption (challengeable):** tagging *high-stakes* opens with a close-path
> label reduces steward bottleneck without re-creating a mega-sitting.  
> **Not assumed:** that every artifact needs a class, or that the current
> taxonomy is right. If classes feel like ceremony, file FEEDBACK and simplify.

### 2.1 When classes apply

Use a class on items that **pin language, wire law, or suite contract**
(OPEN rows, DECISIONS candidates, ruling-table residues).

**Do not** require classes on:

- Spikes (see §5)
- Discussion files
- Pedagogy sketches
- Exploratory notes
- Process feedback itself

### 2.2 Working taxonomy (try this; revise freely)

| Class | Intent | Who may close | Notes |
|-------|--------|---------------|-------|
| **CARRY** | Already ruled (CHANGELOG / steward mark); cite only | Any operator | No re-argument |
| **STEWARD** | Needs Joseph | Joseph | Keep this list short |
| **PANEL** | Agent-primary residual; wants a second set of eyes | Two independent operator passes | Prefer different model families when available |
| **OPEN-LIGHT** | Low cross-spine risk; single operator may land with evidence + revisit trigger | One operator | Replaces old “OWNER / lane owner” — no person-ownership fiction |
| **WAIT-DEMAND** | Must not be nailed supply-side; needs exploration first | Reclassify after spikes (or other evidence) return | **Not** “run a prescribed spike template”; see §5 |

Old name **DEMAND** ≡ **WAIT-DEMAND**. Old name **OWNER** ≡ **OPEN-LIGHT**.
If the five-way split is too heavy, a future amendment may collapse to
`carry | steward | agent | wait`.

### 2.3 R3-class (exemplar of WAIT-DEMAND)

**Multi-line / line-boundedness** (old R3; greenfield D1/Q8) is the
canonical *do not nail from supply-side intuition alone* item:

- 2a/3a/3b picks are **strawmen**, not law
- Right answer likely depends on paths, agent edit/stream repair, dialects,
  serializers — discover that with **open spikes**, not a steward sitting
- Honest state until then: OPEN + WAIT-DEMAND (or simply OPEN with a note
  “blocked on exploration”)

### 2.4 Default STEWARD (keep short)

- C0/C1 charter shape; C2 version line; external release claims
- Overturn of CHANGELOG “Ruled” that changes published human-facing docs
- Breaking known external consumers (`CONSUMERS.md`) without migration
- Explicit `*(steward)*` / `*(discuss w/ Joseph)*`
- Process changes that **expand or shrink steward power**

### 2.5 Default agent-primary (PANEL or OPEN-LIGHT)

Severity labels when keep-shape is agreed; root `:key` keep-shape; string
escapes; tab keep-shape; attr-under-attr shape; comment strip; fixture
profiles; sufficiency **law** and “value self-delimiting” **direction**;
vocab/org under C3; agent-UX and harness design.

Full wire **vocabulary freeze** and multi-line **final pin** → WAIT-DEMAND
until exploration has something to say.

Panel split after two written positions → steward only if charter/values;
else prefer checkable + better for agent generate/repair, record dissent.

---

## 3. Spine vs areas (not “owned lanes”)

**Lattice rule:** *Areas propose; only qualified decisions move shared
contracts.*

| Spine (move carefully) | Areas (explore and propose freely) |
|------------------------|-------------------------------------|
| GLOSSARY | paths |
| Stage vocabulary (names only) | dialects (all axes) |
| Ornamental criterion | schema |
| ADM shape at assembly boundary | utils / agent-UX / human-UX |
| WIRE sufficiency law + self-delimiting direction | concrete grammar, engines |
| SEMANTICS equivalence ladder | house styles, fmt policies |
| DECISIONS / OPEN / PROCESS | discussion files, spikes |

**Area ≠ owner.** An **area brief** (short file under `v2-spec/areas/` or a
section in STATUS) may list: questions in flight, useful pointers, traps.
Any session may work an area by adopting a **session charter** (§4).

Disagreement between areas → OPEN intake, not a SPEC merge war.

---

## 4. Session charter (substitutes for “lane ownership”)

Because agents do not continue, **session parameters** carry focus.

At session start (light touch — skip formality when the task is obvious),
state or write in STATUS:

```markdown
### Session charter
- Area: (e.g. process | paths | DECISIONS seed | agent-utility)
- Aim: (one sentence)
- In bounds: …
- Out of bounds: … (e.g. no multi-line pin; no grammar rewrite)
- Landing: which files will change if this goes well
```

That is enough continuity for the *next* agent: not “you own paths,” but
“paths brief + last handoff + open questions.”

---

## 5. Spikes — open-ended, low stakes, high reward

Spikes are **permission to think**, not a mini-spec process.

### 5.1 Norms

| Do | Do not |
|----|--------|
| Start from a **question** or itch | Mandate a fixed output template as a gate |
| Explore widely; follow surprise | Treat the spike as failing if it “only” reframes the question |
| Leave **durable residue** (notes, examples, demands *if any*, dead ends) | Require decision classes, RFC 2119, or panel before exploring |
| Keep stakes low — wrong is fine | Smuggle a language pin into the suite “while you’re there” |
| Optionally list boundary demands **if** they appeared | Require a boundary-demand table for the spike to “count” |

### 5.2 Suggested residue (optional, not a rubric)

Enough that a stranger-agent benefits:

- What you tried / what you noticed  
- Examples that hurt or helped  
- Open questions (richer than when you started is a win)  
- *If* something should move the spine later: a clearly labeled
  **proposal** (not a decision)  

Location: `v2-spec/spikes/<name>/` or a discussion file. Disposable by
design; harvest into OPEN/DECISIONS only when something graduates.

### 5.3 Spikes and WAIT-DEMAND

WAIT-DEMAND means “don’t pin the suite yet,” **not** “you must complete
Spike Form 12-B.” Multiple messy spikes can unlock a pin; zero spikes and a
supply-side hunch should not.

---

## 6. Durable cycle (high-stakes path only)

For items that will become DECISIONS / suite law:

```text
intake (OPEN: question, options if known, class if useful, lean)
  → exploration as needed (spikes — open-ended)
  → evidence for a close (examples, agent scenarios, cites)
  → close path (CARRY | OPEN-LIGHT | PANEL | STEWARD)
  → ledger (DECISIONS append-only; OPEN shrinks)
  → discussion files stay deliberation, never law
```

| Instrument | When | Cost |
|------------|------|------|
| Spike | Unknown terrain; WAIT-DEMAND; curiosity | Cheap; low stakes |
| Panel | Agent-primary pin wants a second mind | Two passes |
| Steward mark | STEWARD class or stuck charter split | Rare |
| Clean-room re-derivation | Accretion in wording/org suspected | Expensive; rare; not a ruling source |
| Differential oracle | Replacing working parser/fixtures | Until new gate green; never authority |

**Ruling table** = intake archaeology + steward marks already made — not the
OS for new work. **Pipeline discussion** = deliberation record; stage
*names* and demand-side *habit* are adopted; payload tables stay provisional.

---

## 7. Evidence standard (when closing high-stakes items)

A PANEL or OPEN-LIGHT close should include:

1. **What** (and what was rejected)  
2. **Primary-user impact** — at least one **agent** scenario when relevant  
3. **Anomaly / keep-everything** consequence if [BEHAVIOR]  
4. **Cites** (greenfield / CHANGELOG) when relevant  
5. **Provenance** (who/when)  
6. **Revisit trigger** — what would force re-open  

Missing (2) or (5) on a behavioral pin → not landed.

**No silent syntax.** Silence → OPEN, not grammar “to unblock.”  
**Primary source at point of use.** Re-open the section you rely on.

---

## 8. Turnover resistance

| Rule | Practice |
|------|----------|
| If it isn’t in a file, it didn’t happen | Session-end landing |
| Lanes / area lists hold open work only | Closed → DECISIONS + git |
| Ledger append-only | Overturns are new entries |
| Handoff every session | STATUS § handoff |
| Roles, not personas | No “Fable will remember” |
| Process friction is data | FEEDBACK entry, not silent workaround |

`STATUS.md` = program front door. Update when program state changes.

---

## 9. Milestones (leaky program sketch)

| ID | Content |
|----|---------|
| **M0** | Process live + amendable; seed DECISIONS/OPEN; optional PIPELINE one-pager |
| **M1** | Open spikes: paths, dialects, schema, agent-utility (parallel, nonprescriptive) |
| **M2** | Contract suite draft (GLOSSARY/ADM can parallel M1; wire encoding waits on evidence) |
| **M3** | Fixtures + harness (C5 profiles as working hypothesis) |
| **M4** | Grammar/parser rebuild; oracle |
| **M5** | Utils MVP; ornamental fixpoint as tool; dogfood |
| **M6** | Publish when fixture group freezes |

Reorder or drop freely via FEEDBACK if the sketch fights reality.

---

## 10. Session protocol (light)

### Start

1. STATUS + PROCESS (§0 if process feels wrong)  
2. DECISIONS/OPEN when touching law  
3. Primary-source anything you’ll pin  
4. Optional session charter (§4)  
5. Work STATUS priorities — or process health if that's the bottleneck  

### After context compaction (mandatory reorient)

Compaction **is not onboarding.** The compressed transcript is **untrusted**:
it may omit OPEN rows, misstate severity pins, invent "we decided," or
collapse vault history into a slogan.

**Before any further law, suite edit, or "continue where we left off" claim:**

1. Re-read **STATUS.md** (phase + Own next + Need Joseph) — especially the
   banner at the top of STATUS
2. Re-read **DECISIONS.md** / **OPEN.md** for anything you are about to touch  
3. Re-open the **primary file** (SPEC section, spike NOTES, vault export) — not
   a chat paraphrase  
4. Only then act  

If STATUS and the chat disagree, **STATUS + DECISIONS win.** File a
PROCESS-FEEDBACK note if compaction repeatedly misleads.

### End

Land at least one of: STATUS handoff, OPEN/DECISIONS, spike residue, area
brief, **or PROCESS-FEEDBACK**.

```markdown
## Handoff (date, agent label)
- Done: …
- Open: …
- Next: …
- Do not: …
- Process notes: … (optional; or write FEEDBACK)
```

### Panel (when used)

Shared brief → pass A → pass B (fresh) → integrate or name the split.
Not required for spikes.

---

## 11. Assumption register (revisit deliberately)

| # | Assumption | Revisit if… |
|---|------------|-------------|
| A1 | Agent-primary + steward-gated beats steward-sitting default | Steward still bottlenecked or agents pin recklessly |
| A2 | Decision classes help high-stakes closes | Classes unused, gamed, or block progress → simplify |
| A3 | Session charter + area briefs beat “lane owner” | Handoffs still incoherent → try another continuity device |
| A4 | Open-ended spikes produce harvestable residue without templates | Spikes become either void or accidental specs → adjust norms |
| A5 | Panel (2 passes) is enough for agent-primary pins | Systematic blind spots → change panel design or evidence bar |
| A6 | WAIT-DEMAND prevents supply-side nailing (R3-class) | Everything becomes WAIT forever / or pins ignore it |
| A7 | FEEDBACK side channel stays used | Unused → process is either perfect (unlikely) or unsafe to criticize |

Operators: if you falsify an assumption, **log it in FEEDBACK and propose a
delta** — that is a first-class win.

---

## 12. Related artifacts

| Artifact | Role |
|----------|------|
| [PROCESS-FEEDBACK.md](PROCESS-FEEDBACK.md) | **Always-open meta channel** |
| [STATUS.md](STATUS.md) | Program ground truth + handoffs |
| [RULING-TABLE.md](RULING-TABLE.md) | Archaeology + steward marks |
| [pipeline-discussion.md](pipeline-discussion.md) | Deliberation record |
| Greenfields 2a/3a/3b | Wording + fork evidence |
| Live `spec/` + parser | Oracle/record until cutover |
| `ux/TODO-AGENT-UX.md` | Agent-utility exploration input |

---

## 13. Standing invitation (operators)

Take ownership of **substance** and of **process fitness**. Prefer:

- principled pins with evidence over waiting for a sitting on agent-primary forks  
- open spikes over supply-side nailing  
- files over brilliant conversation  
- **amending this document** over quietly suffering it  

---

## Changelog (process itself)

| Date | Change |
|------|--------|
| 2026-07-20 | Initial PROCESS (agent-primary, classes, lane owner) |
| 2026-07-20 | **Meta-open revision:** §0 feedback channel; process provisional; spikes nonprescriptive; drop lane owner → session charter + area briefs; OWNER→OPEN-LIGHT; DEMAND→WAIT-DEMAND; assumption register; FEEDBACK file |
| 2026-07-21 | **Post-compaction reorient** mandatory in §10 + STATUS banner; disk (STATUS/DECISIONS/OPEN) beats chat summary |
