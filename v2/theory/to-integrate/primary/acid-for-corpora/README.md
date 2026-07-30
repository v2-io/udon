# ACID for corpora — an adversarial prior-art pass

*2026-07-29, Fable (second instance). Commissioned against [`../underlying-logical-model.md`](../underlying-logical-model.md) §2 and §4, with the letter's own invitation as the brief: "this is the part I'd most like attacked, because the central identification is mine and unchecked." What follows is the attack, the names the field already has for what we built, and the two places the letter turned out to be more right than it knew.*

**Register key.** *measured* = I ran it, here, and say what against · *sourced* = a named source states it, cited · *reported* = a research agent surfaced it and I did not go to the primary · *inference* = my reasoning, unsourced · *open* = I do not know. Descriptions of what a source says are kept separate from conclusions drawn from them. Where the letter is wrong I say so plainly; where we reinvented something with a name, the name is stated without softening.

---

## Conclusions, up front

1. **The central identification does not survive, and it fails on quantifier.** `#def-system-coherence` is *"the expected proximity of changes within a module"* — an expectation. Atomicity is a property of *every* invariant-bearing changeset. The letter's own sentence carries the refutation: it proposes choosing placements so the **typical** changeset fits one atomicity unit, and *typical* is the one word atomicity does not accept. These are two constraints that agree on the bulk of the distribution and give **opposite** recommendations on the tail — and the tail is where all the corruption lives. (§1)

2. **But the move itself is real, and has five names across (honestly counted) two or three independent lineages.** Transaction chopping (Shasha et al., TODS 1995), invariant confluence (Bailis et al., VLDB 2014), DDD aggregate design (Evans/Vernon), NoSQL partition-key co-location (DynamoDB/Cosmos "single-table design"), and — oldest — Parnas's 1972 information-hiding criterion, which is TST coherence's actual ancestor. The letter *underclaims* against chopping and I-confluence: both supply a **decision procedure** for exactly the question the letter leaves to judgment. (§2)

3. **The repair is a strengthening, not a softening.** Atomicity is the *feasibility constraint*; coherence is the *objective function over the feasible region*. This is strictly more useful than the identification because an identity cannot break a tie and this can. (§1.3)

4. **§2's premise "multi-file transactions don't exist" is false.** The estate ships one and uses it constantly: a **git commit** is an all-or-nothing multi-file transaction and a corpus-wide consistent snapshot. The cluster-record anomaly the letter files as "counter-evidence to watch for" — *"cross-store reads that disagree with no local signal"* — has an available fix the estate already owns: read from a commit, not the working tree. (§3)

5. **The no-lock decision's justification does not transfer from role (a) to role (b), and the letter inherits it silently.** "The collision surfaces in `git status`" is true for one-record-per-file. For a multi-record file under read-modify-write it is **false** — the loser is not preserved anywhere, and nothing appears in any diff. This is the classic **lost update**, and it is the single most actionable defect I found. (§4)

6. **§4 factor 3 is more strongly supported than the letter claims.** The letter says the contraction rate under cheap tooling is "unmeasured anywhere." That is no longer true, twice over: I re-ran the estate's own survey database (*measured*) and found contraction share ranges **0.2% → 19.8%** across projects, sorting by deployment fan-out; and an external study in a cheap-contraction regime found ADD and DROP within the same order of magnitude, not 5:1 (*reported*). The letter's "tool-confounded" caution was right, and its bet now has data behind it. (§5.3)

7. **"Decompose the write set" is the estate's choice, not the field's default.** Where N-file atomicity is genuinely needed, the field's repeated move is to **build a small named atomicity primitive once and reuse it** — Iceberg's catalog CAS, Delta Lake's log append, SQLite's super-journal, git's own multi-ref transaction. All four share one shape: *stage N files that are not yet the truth, then do exactly one atomic thing that makes them so.* Git — our own tooling ancestor — built a transaction manager rather than decomposing the need away. And the canonical "design the need away" citation (Helland, CIDR 2007) turns out **not to reach our scope**: it argues against atomicity spanning entities that may land on different machines, while explicitly permitting one entity to span many files within a single scope of serializability — which is where we live. It withholds support rather than refuting. (§3.2, §3.3)

8. **Two things appear genuinely unnamed** and may be ours to contribute: the fault-attribution principle behind `.rejected` vs `.needs-review`, and bare `git status` as the conflict-resolution UI. A third candidate (VCS-commit-as-snapshot) was **discounted by my own later research** and is now presented as inheriting a standard technique rather than as ours. (§7)

---

## 1. The identification, attacked

### 1.1 What the letter claims

> "**Atomicity** exists in the corpus at exactly one grain: the single-placement atomic write... the estate's universal answer is a design move, not a workaround: *shape the write set so it decomposes into single-placement writes*... I think it's secretly a rule — **choose placements so the typical atomic changeset fits inside one atomicity unit** — and if that's right, TST's coherence and ACID's A are the same constraint seen from two disciplines."

### 1.2 Four separable failures

**(a) Quantifier mismatch — the demolition.** *sourced (the definition) + inference (the argument).* `#def-system-coherence` (`axiomatic`) reads *"the expected proximity of changes within a module."* An expectation is a mean over a distribution of changesets. Atomicity is universally quantified: it must hold of every changeset that bears an invariant, and it is violated precisely by the atypical one. A layout that contains 95% of changesets is *excellent* coherence and *broken* atomicity. You cannot optimize a predicate as though it were a continuum; doing so produces 95%-correct safety, which is a category of thing that does not exist.

This is not a quibble about phrasing. It is the difference between a metric you trade off and a constraint you satisfy.

**(b) They give opposite recommendations on the tail.** *inference.* Take a changeset that spans two placements, is rare, and bears an invariant. Coherence says: the co-change is rare, so co-locating buys little and costs proximity for the common case — **keep them apart**. Atomicity says: contain it or install an explicit reconciler — **you must co-locate**. Not one constraint seen twice; two constraints that are strongly correlated in the bulk and anti-correlated exactly where correctness is decided.

**(c) Different failure currencies.** *inference.* Coherence failure costs edit effort and staleness: visible, recoverable, priced in review capacity. Atomicity failure costs silent corruption: invisible, unrecoverable, discovered late. Even where the two agree on direction they disagree on how much to pay — and "same constraint" gives no guidance on the only question a designer actually has.

**(d) The identification would license a known-confounded instrument for a safety property.** *inference, resting on the estate's own C2.* If coherence ≡ atomicity, then co-change measurement justifies atomicity boundaries. But C2 — named in the very segments the letter cites — says co-change measurement is confounded by the layout it justifies. Borrowing a confounded instrument to site a safety boundary compounds the error rather than transferring a result.

**External corroboration that atomicity is the wrong target.** *reported, with citation.* Bailis et al. frame invariant confluence as explicitly **not** the same idea as atomicity/serializability: I-confluence can hold for histories that are not serializable and fail for operations that are individually atomic (Bailis, Fekete, Franklin, Ghodsi, Hellerstein, Stoica, "Coordination Avoidance in Database Systems," PVLDB 8(3), 2014). So the literature that most precisely studies "which invariants survive uncoordinated writes" holds the target property apart from ACID's A by construction. Separately, Kleppmann (*Designing Data-Intensive Applications*, Ch. 7) argues A/I/D are database properties and **C is an application property** — which, if the letter wants a letter at all, makes coherence a better match for **C than for A**. *(The "C was added to make the acronym work" gloss is widely restated but I could not run it to an exact quote — treat as folklore, not citation.)*

### 1.3 The strengthening

Per the house discipline, the move is to strengthen before softening. Do not retreat to "they're related." The repair keeps everything the identification wanted and adds what it lacked:

> **Atomicity is the feasibility constraint; coherence is the objective function over the feasible region.**
> Choose placements to minimize expected changeset spread, *subject to*: every invariant-bearing changeset is either contained in one placement, or carries an explicit reconciler.

Strictly stronger than the identification, on three counts. It tells you what happens when the two conflict (the constraint wins, always — an identity has no tie-break). It is falsifiable per-corpus: enumerate the invariants, check containment. And it plugs directly into two existing decision procedures (§2), where an identity plugs into nothing.

What is genuinely lost: the unification. What is gained: the rule now works at the tail, which is the only place it was ever needed.

### 1.4 The evidence was already collected — the letter files it as a thing to watch

The letter lists as counter-evidence-to-watch-for: *"cluster records (one logical record spanning body + regions + sibling event dirs) are exactly where the estate's observed anomalies live."*

The source report is blunter than that. `doc-store-and-schemas-report.md` §12.4 opens: *"Everything above has assumed a record is a file. **It usually is not.** Across this estate a record is routinely a **cluster** — several files and/or several regions within one file, carrying different roles, different canonicity, and different rules,"* and adds that *"the estate answers it four different ways without ever naming it as one problem."*

So the cluster record is not an exception the rule tolerates. Per the estate's own review it is the **normal case**. Two consequences the letter should absorb:

- "The estate's universal answer" overstates. It is the answer the estate gives where it happens to hold; where it does not hold is (i) the majority of records and (ii) precisely where the anomalies are.
- The anomaly observation is not counter-evidence to watch for. It is the disproof, already in hand.

**And the DDD literature predicts this failure by name.** *reported.* The practitioner consensus is that an invariant genuinely spanning two aggregates is read as **evidence the boundary was drawn wrong** — not as a fact about the world requiring cross-object transactions. That is a stronger and more falsifiable claim than the letter's, and it converts §12.4's "four different answers" from an untidiness into a diagnosis: four unnamed answers to one problem is what a mis-drawn boundary looks like from inside.

---

## 2. What the move is actually called — five names, and two decision procedures

*All §2 entries are `reported` with citations unless marked otherwise.*

**A discount applied to my own strongest claim first.** My initial draft said these five literatures "don't cite each other much, which makes the convergence real evidence that the move is an engineering law." `shipping-practice.md`'s lineage-disentangle — most apparent ecosystem convergence is common descent, not independent arrival — applies to this table as much as to harness counts, so: **five names are not five independent arrivals.** Chopping, I-confluence and partition co-location are all database transaction theory, one lineage sharing vocabulary and reviewers. Parnas → Evans is plausibly descent rather than convergence; DDD's lineage runs through object modeling, which read Parnas. Honestly counted, this is **two, possibly three, genuinely independent lineages** — database transaction theory, and software-modularity/object-modeling — which is still meaningful convergence (they have different failure currencies and different objects of study) but well short of five. *inference; I did not trace citation graphs.* The weaker true claim is the one to carry.

| Name | Source | What it adds beyond the letter |
|---|---|---|
| **Transaction chopping** | Shasha, Llirbat, Simon, Valduriez, *TODS* 20(3), 1995, pp. 325–363 | A static, design-time criterion: build the **SC-graph** (S-edges join pieces of the same transaction, C-edges join conflicting pieces of different ones); the chopping is safe if no cycle contains both an S- and a C-edge. |
| **Invariant confluence** | Bailis et al., *PVLDB* 8(3), 2014; decision procedure in Whittaker et al., VLDB 2019 | Proven **necessary and sufficient** for safe coordination-free execution. The 2019 follow-on builds an actual interactive checker. |
| **Aggregate design** | Evans 2003; Vernon, "Effective Aggregate Design" 2011 | *"A properly designed Bounded Context modifies only one Aggregate instance per transaction in all cases."* Plus the diagnosis in §1.4. |
| **Partition-key co-location** | DynamoDB "single-table design"; Azure Cosmos DB partitioning docs | The industrial version at production scale: co-locate related items under one partition key to get transactional behavior across them. |
| **Information hiding** | Parnas, 1972 | *inference:* group by what is likely to change together — this is TST's `#def-system-coherence` in its original form, predating every database citation above. Worth knowing the lineage runs through software modularity, not database theory. |

**The letter underclaims twice.** Chopping tells you the estate's practice — never span two placements — is a *maximally conservative special case*: if a changeset never spans placements, no SC-cycle can arise, so the question never comes up. The literature characterizes exactly how much further you could safely push. I-confluence generalizes that to arbitrary declared invariants and gives a checker. The letter leaves to judgment a question two literatures have made decidable.

*Caveat carried honestly:* SC-graph acyclicity was verified as a **sufficient** condition from secondary sources; necessity was not confirmed against the 1995 primary. Do not cite "necessary and sufficient" for chopping without that check. (The necessity claim *is* verified for I-confluence.)

**And I-confluence names our identity problem exactly.** *reported.* **Primary-key uniqueness is generally not I-confluent** — two uncoordinated branches can each mint a record under colliding keys, and no merge rule repairs it afterward. That is §4 factor 4 ("identity must be resolved, never minted") as a *predicted* consequence rather than a lesson learned at cost. The literature says this breaks under concurrency **no matter how well placements are chosen for the mean changeset** — which is, independently, the same conclusion as §1.2(a).

---

## 3. "Multi-file transactions don't exist" is false — the estate ships one

*inference, resting on facts the estate already states.*

`../tst-grounding.md` §6.3 says it in passing: *"git records commits, and a commit is the observational grain."* A commit is also, and more usefully, a **transaction**:

| | What a git commit supplies | Caveat |
|---|---|---|
| **A** | All-or-nothing across arbitrarily many files. The commit exists or it does not. | Contingent on the commit landing — see `index.lock`, §4.3. |
| **Snapshot / I** | A commit is a **corpus-wide consistent snapshot**. `git show <ref>:<path>` reads a cross-placement-agreeing view. | No isolation *between* concurrent writers sharing one working tree. |
| **D** | Durable modulo the usual few-seconds window. | Git does **not** fsync loose objects by default (*reported*, git 2.36 release notes / `core.fsyncObjectFiles` history). |
| **C** | Nothing. As designed — the non-invasive-judge position holds. | — |

So the honest §2 statement is not "atomicity exists at exactly one grain" but: **atomicity exists at two grains — the single-placement write and the commit — and the estate's tooling uses only the first.**

The design consequence is concrete and cheap. The cluster record's missing transaction *is* a commit. The cluster record's missing consistent read *is* `git show <ref>:<path>` instead of reading the working tree. The letter's named anomaly — "cross-store reads that disagree with no local signal" — is by construction impossible against a commit, because a commit is exactly the object that cannot disagree with itself.

### 3.1 The ecosystem has the same hole, which is calibration rather than comfort

*sourced, from our own corpus.* `shipping-practice.md` records the gap directly: across 17 harness maps, **none discuss multi-file atomic edits** — transactional all-or-nothing changes across several files in one tool call — **except grok-build's hashline batch semantics**, where `LINE:HASH→content` anchors are applied bottom-up and *any* stale anchor rejects the whole batch.

Two readings, and they point opposite ways:

- *Charitable:* if fourteen independently-built harnesses do not offer multi-file atomicity, the demand may genuinely be low, which is mild support for the letter's "decompose the write set" instinct as a description of what everyone does.
- *Uncharitable, and I think closer to right (inference):* absence across harnesses is weak evidence about demand, because per `shipping-practice.md`'s own descent-disentangle most harness uniformity is common descent rather than independent arrival — and these tools are optimized for a single agent editing a working tree under human supervision, not for a multi-agent corpus with durability requirements. Our case is the one where the hole bites.

The grok-build exception is worth naming precisely: *inference*, that is not a transaction, it is **optimistic concurrency control with content-hash anchors** — a precondition check, not atomicity, and it fails the batch rather than rolling it back. Which is the right primitive for a corpus and is the thing `safe_write` currently cannot express (§4.2: `rename()` clobbers where `link()` would refuse).

### 3.2 The field's default is not "avoid it" — it is "build the primitive once"

*This section corrects a framing I had accepted from the letter and carried into my own first draft.*

The letter presents "shape the write set so it decomposes into single-placement writes" as *the* answer, the estate's and everyone's. Against the primary sources, it is **one legitimate answer among several, and not the field's most common one.** Where N-file atomicity is actually needed, the field's repeated move is to **build a small, named atomicity primitive once and reuse it** — general-purpose infrastructure, not a per-document design discipline:

| System | The primitive | Isolation actually claimed |
|---|---|---|
| **Apache Iceberg** | atomic swap of one metadata-file pointer, CAS'd in an external catalog (not the filesystem) | *"Serializable isolation"* (spec, verbatim) |
| **Delta Lake** | optimistic write of data files, then one new numbered entry in a JSON log | *"Snapshot Isolation for Reads"* (protocol doc, verbatim) — a **weaker** claim than Iceberg's; do not flatten the two |
| **SQLite (ATTACH)** | a **super-journal** listing every attached DB's journal; deleting it is the multi-file commit point | full ACID across N files |
| **git** | `update-ref --stdin` with `start`/`prepare`/`commit` — a real multi-ref transaction over per-ref lock files | all-or-nothing outcome, but *"a concurrent reader may still see a subset of the modifications"* |

*sourced, all four fetched from primary specs/docs.* Three consequences for the letter:

1. **The structural invariant is uniform and worth stating as a design primitive in its own right** (*inference, drawn from all four*): nobody has multi-file atomicity as a primitive; everybody **stages N files that are not yet the truth, then does exactly one atomic thing that makes them so**, plus a way to detect a conflicting concurrent flip. Pointer swap, log append, journal delete, ref transaction — one shape. That is a far more useful thing for the letter to carry than "we decompose," because it is constructive and it is what our own `safe_write` already does at N=1.
2. **Our own tooling ancestor declined the letter's rule.** Git stores one record per object and, when it needed atomicity across more than one pointer, **built a transaction manager rather than decomposing the need away.** That is a counter-datapoint from inside the estate's lineage.
3. **SQLite's super-journal is a worked, non-database answer to precisely our question** — N-file atomic commit on a plain filesystem, costing one extra small file plus a specific fsync ordering. Not exotic; but machinery, honestly priced.

And SQLite's own failure-mode section supplies the most human warning in this entire report, which lands directly on our `.tmp` sweep and any recovery artifact: *"A power failure occurs... a well-meaning user or system administrator begins looking around on the disk for damage... The user then deletes the hot journal, thinking that they are helping to clean up the system."* Recovery evidence that looks like garbage gets tidied away by someone helping.

### 3.3 The counter-case, sourced — and it does not reach our scope

*This section replaces an "unverified recollection" gap in my first draft. The paper was subsequently read cover-to-cover at the primary (Pat Helland, "Life beyond Distributed Transactions: an Apostate's Opinion," CIDR 2007, pp. 132–141). It resolves in favor of my own §3.2 finding, which is a reason to state it more carefully rather than less.*

Helland is the canonical citation for "design the need away," and he does argue it: **[docs state, verbatim]** *"Atomic Transactions Cannot Span Entities... the uniquely identified entity is the scope of serializability,"* with cross-entity coordination replaced by at-least-once messaging and application-implemented idempotence. Three findings, in ascending order of how much they matter to us.

**(a) The cost-shape is the opposite of the build-once pattern, and Helland says so.** His discipline recurs *per relationship*: *"If an entity works with many partners, it will have many activities. These are one per partner,"* and *"the scale-agnostic application contains application specific logic to ensure redundant processing of messages has no substantive impact on the entity."* So the two families of prior art in §3.2 and here are not two flavors of one answer — they price differently. One buys a **reusable primitive once**; the other accepts a **continuing per-relationship design obligation**. That is a real asymmetry the letter should choose between knowingly, because "decompose the write set" is the second kind of cost and the letter presents it as free.

**(b) Both sides of this argument rest substantially on assertion, asymmetrically.** The paper self-describes: *"Let's start out with three assumptions which are asserted and not justified. We simply assume these are true based on experience,"* and *"the nice thing about writing a position paper is that you can express wild opinions."* It carries **no citation apparatus at all** — no bibliography, no named systems, no postmortems. Its evidence that distributed transactions get built and regretted is career testimony: *"I have invested a non-trivial portion of my career as a strong advocate... My experience over the last decade has led me to liken these platforms to the Maginot Line."* This is not a dismissal — testimony from a senior architect generalizing across many projects is real evidence, and this paper is deservedly influential. It is a statement about *kind*: §3.2's four systems are checkable against running specs and code; this side is one credible person's uncorroborated experience. Treating "Helland says so" as equivalent-strength to "here is Iceberg's spec text" would flatten a distinction worth keeping.

**(c) The scope mismatch — the most important item in this section.** Helland's argument is not "avoid multi-file atomicity." It is "avoid atomicity spanning independently-partitioned entities that may end up on different machines under repartitioning," in an almost-infinite-scale regime. **Within** a single entity, atomicity is not merely permitted but assumed, and he explicitly allows an entity to be multi-file: **[docs state, verbatim]** *"One possible representation is as a collection of SQL records (potentially across many tables) whose primary key begins with the entity-key,"* and *"the entity itself can reside within a single scope of serializability."*

Our storage is a single local filesystem with no multi-machine repartitioning concern — in Helland's own terms, much closer to *one scope of serializability* than to the regime his paper addresses. So: **citing Helland to justify "every change must fit in one file" at our scope would be a scope mismatch.** State this precisely, because the honest version is narrower than the convenient one: the paper does not *refute* the letter's approach, and the letter may still be right for reasons Helland never discusses (reviewability, coherence, git-diff legibility). What it does is **withhold the support** the letter's position would most want — the field's best-known "design the need away" argument turns out to be about a problem we do not have.

*open:* whether any Git-backed database (Dolt, Irmin, TerminusDB, Noms) has written this up. Two independent searches came back negative, with both agents flagging their own negative as under-confident. What was found: those projects all build their own diff/merge layer rather than exposing VCS porcelain, and none was confirmed to derive cross-object snapshots from git's mechanics rather than from their own transaction layer. If the negative holds this is a small contribution of ours (§7).

---

## 4. Isolation — the justification that does not transfer

### 4.1 The transfer error

relata's no-lock decision is justified by one sentence, quoted in the source report: *"the collision surfaces as a pending change in `git status`, which is the right place for the resolution."*

That justification is **sound in a one-record-per-file world**. Two writers to one key produce a whole-file disagreement a human sees.

It **does not transfer to role (b) multi-record files**, and the letter carries it across silently. Trace it (*inference*, mechanism-level, no measurement of live incidence):

> Agent A reads `DECISIONS.decision-log.udon`, appends record X in memory. Agent B reads the same file, appends record Y, writes. Agent A writes. **Record Y is gone.** `git status` shows one clean modification. `git diff` shows record X added. Nothing anywhere signals Y ever existed.

This is the classic **lost update**, and the no-lock decision's own safety net is *structurally unable* to fire — because the disagreement never becomes a content disagreement. It becomes an **absence**, and absences do not appear in diffs.

The letter has the hazard ("two agents' unrelated appends can last-writer-win over each other") but reads it as a property of record-grain-vs-file-grain. The sharper finding is that the *warrant for having no locks at all* was earned in a regime where this cannot happen and was inherited into a regime where it can.

**A live specimen** (*measured*, 2026-07-29): `~/src/arch/vivarium/DECISIONS.decision-log.udon` is 464,661 bytes, 129 top-level `|` records, 89 commits touching it, recent commits adding 7–24 lines each. It is exactly the shape above.

### 4.2 The prior art's verdict on this shape is unusually flat

*reported.* Maildir (Bernstein, 1995) is the closest documented precedent to the estate's whole record store — `tmp/` + unique filename + atomic rename, explicitly designed to need no locking — and it exists **because mbox's one-file-many-records design failed**. mbox has no standard locking mechanism ("a matter of local policy"), three incompatible schemes in the wild, and two documented corruption/deadlock classes arising from that.

The verdict, as the research came back: **the mature prior art uniformly avoids true multi-writer concurrent append to one shared file rather than solving it.** Bitcask is single-writer/multi-reader with writers rotating to new segments; Kafka segments its logs; Maildir gives each message its own file. None trusts concurrent `O_APPEND` to one target.

*(POSIX `O_APPEND` atomicity is real on local filesystems, but **per-syscall, not per-logical-record** — buffering or a chunked write can still interleave — and it is explicitly not guaranteed on NFS. The oft-repeated PIPE_BUF size cap is a pipe guarantee misapplied to regular files.)*

One precise, inheritable design difference: **some Maildir implementations use `link()`+`unlink()` rather than `rename()` deliberately, because `link()` fails loudly on a name collision while `rename()` silently overwrites.** `safe_write`'s `File.rename(tmp, path)` clobbers. Wherever "this key should not already exist" is the intent, the primitive currently cannot express it — and that is the same non-I-confluent uniqueness invariant from §2, showing up at the syscall layer.

### 4.3 The `git status` net has a second failure mode

*reported, currently-live.* Git takes an exclusive `.git/index.lock` for any index-touching operation. Two agents committing concurrently in one repo: the second gets `fatal: Unable to create '.git/index.lock': File exists`, and if the first was killed rather than exiting cleanly the lock is **orphaned and blocks every subsequent git operation from every agent**. This is being actively reported in exactly the multi-agent shape (including against Claude Code) through 2026. Since "the collision surfaces in `git status`" presupposes each agent can successfully commit, `index.lock` contention is a second mechanism that defeats the assumption — this one loudly rather than silently, which is the better failure but still a gap in the story as told.

### 4.4 The reframe that partially rescues LWW — and where it fails

*reported (the reframe) + inference (its boundary).* Every LWW critique in the literature — Jepsen, Kleppmann, Riak's own docs — evaluates LWW as the **terminal, fully automated** resolution mechanism. None evaluates the case where the loser is *preserved* and a human reconciles later, which is what the estate's design actually does: the loser sits in the git object database.

That is a genuine defense, and it means "LWW is dangerous" does not transfer to us unmodified. But note precisely where it stops: it holds for role (a), where the loser reaches git. It **fails for role (b)**, where per §4.1 the loser never enters git at all. The reframe and the defect are the same boundary seen from two sides.

---

## 5. Durability, and §4's five factors

### 5.1 The durability lean, honestly accounted

*reported, verified against the actual source file by the researching agent; machine confirmed APFS.* The lean is **directionally correct and well-precedented** — the same shape as Maildir and PostgreSQL's own `durable_rename()` — with one documented omission whose bite differs by filesystem.

- **`rename(2)` is atomic for *visibility*, not for *durability across a crash*.** The contract's first half is undisputed. What it does not cover: the rename's directory-metadata update is itself just a write, and if it is not flushed, a crash can lose the rename. The `.tmp` sweep handles "the rename never happened," not "the rename happened and was lost."
- **The missing step is `fsync` of the containing directory after the rename.** Corroborated independently by Dan Luu's "Files are hard" and by PostgreSQL's 2016 `durable_rename()` hardening (commit subject: *"Avoid unlikely data-loss scenarios due to rename() without fsync"*). This is the single most citable gap in the code as written.
- **Its bite is smaller than the ext4 folklore suggests, in both directions.** On ext4 the classic auto_da_alloc zero-length-file disaster hits code with *no* fsync at all; `safe_write` does fsync the data, so its residual exposure is a lost rename → stale read, recoverable from git, not corruption. On APFS, Apple documents a copy-on-write "atomic safe-save" design targeting exactly this scenario — *vendor-stated intent, not independently crash-tested*, and worth holding at that tier.
- **macOS `fsync()` is weaker than the name implies** — Apple's own man page says it does not guarantee the drive persists on power loss; `F_FULLFSYNC` does, and `F_BARRIERFSYNC` is the cheaper ordering-only option. Scope this precisely: it bites on **power loss / kernel panic**, not on the process-crash case the sweep is designed around.
- **fsyncgate (PostgreSQL, 2018)** is calibration, not a defect: a failed writeback can have its page silently marked clean, so a *retried* fsync can return success over discarded data. `safe_write`'s `rescue`+re-raise handles direct failure correctly; the subtle case is not addressable at this layer, and the exposure is shared with `cp`, `rsync`, and most editors. Worth one honest sentence, not a fix.
- **Systematic research exists** and is the name for this whole exposure: Pillai et al., *"All File Systems Are Not Created Equal,"* OSDI 2014 — applications that "worked" on one filesystem broke on another because they relied on stronger ordering than POSIX promises. More applications corrupted data on btrfs/XFS than ext3/ext4. The relevant reading for us: `safe_write` was developed and tested on APFS; whether it behaves the same on Linux corpora or network shares is empirical, and this paper's whole point is not to assume yes.

### 5.2 Factors 1, 2, 4, 5 — the names

**Factor 1 — "the target may be plural or absent."** *reported.* The SQL standard requires a runtime **cardinality violation** when a MERGE's ON-clause lets more than one source row match one target row — enforced identically in PostgreSQL, Hive, Iceberg, Delta. "If present, exactly one" is not merely a desirable arity; it is a **named, standardized error condition**. If the arity/expectation axis is currently unnamed internally, *cardinality violation* is the field's word.

**Factor 2 — "the target may be a part, while other parts belong to other actors and clocks."** *reported, and this is the one that should worry us.* Cassandra resolves conflicts **per column**, and Jepsen's Cassandra writeup documents both the loss rate (**28% of acknowledged writes lost** under QUORUM with a perfect lock service and synced clocks) and the exact mechanism: with per-column timestamp tiebreaks, concurrent writes of `[1,-1]` and `[2,-2]` to a two-column row can resolve to `[2,-1]` — **a state no writer ever wrote**. Per-part write rules manufacture records that never existed as a whole. The letter proposes per-part write rules for cluster records; this is the named, measured pathology of that design, and it should be on the letter's face rather than in a research file.

**Factor 4 — "identity must be resolved, never minted."** *reported.* Three independent traditions converge here, and one of them is a century old:
- **Record linkage** — Fellegi & Sunter, *JASA*, 1969.
- **Authority control** — library science; name authority files, VIAF, ORCID. Genuinely the same operation, arrived at independently.
- **MDM "golden record" + survivorship rules** — maps most directly onto "resolve-then-enrich."
- And per §2, **the invariant is provably non-I-confluent**, which upgrades the estate's lesson from empirical to predicted.

The estate's own measured case is a clean specimen of the literature's failure mode: 29 same-expression duplicate clusters (58 entries; in 7, the *cited* key was the metadata-poorer twin), caused by an import ladder that *"synthesizes a disambiguated key instead of routing into a same-work check."* Its survivor rule — cited key wins, else metadata-richer, merge as field-union — is *inference:* a hand-rolled deterministic merge function, i.e. the shape a convergent (CRDT-ish) merge has to have, with "usage, not richness" as the tiebreak that makes it deterministic.

**Factor 5 — "non-atomic batch with typed residue."** *reported.* The mechanism has names: ETL's **quarantine pattern** (reject vs. hold-for-review), **dead-letter queue** / poison message, and the **landing zone / staging area** for the spool. `safe_write`-plus-drainer is functionally the drain half of the **transactional outbox** (Richardson) — worth checking the drainer is idempotent against double-processing, since outbox-without-idempotent-consumer yields at-least-once, not exactly-once. Known operational failure modes to inherit: retry storms and silent DLQ accumulation. **But see §7** — the *principle* behind the two-outcome split appears to be ours.

### 5.3 Factor 3 — the expand:contract ratio, where the letter was more right than it knew

The letter treats the 5:1 as tool-confounded and calls the rate-under-cheap-tooling "unmeasured anywhere," making it the falsifiable fork the O4/O7 design bets on. Two new lines of evidence.

**(a) External counter-datapoint** (*reported*). The closest actual measurement found outside Rails — Wu & Neamtiu, HotSWUp 2011, on **embedded** database schema changes — reports ADD ~32.5% and DROP ~26.4%: **the same order of magnitude, not 5:1**. Embedded databases are close to a cheap-contraction regime (you ship the whole application; there is no fleet of deployments you do not control). The researching agent's honest structural finding is worth carrying verbatim in spirit: nobody studies this ratio in a regime where contraction is cheap, *because the pattern's entire purpose is to avoid expensive contraction* — the corpus is structurally incapable of answering the question.

**(b) The estate's own survey database, re-run** (*measured*, 2026-07-29, `~/src/rowan/tmp/migration_survey.sqlite3`, 23 repos / 12,072 mutations). The pooled 5:1 (5,011 expand / 926 contract) is real, and its central tendency is robust — per-repo median ratio ≈ 5.8. **The dispersion is the finding.** Contraction as a share of all mutations, projects with >200 mutations:

| Project | mutations | contractions | contraction share |
|---|---|---|---|
| gitlabhq | 554 | 1 | **0.2%** |
| mastodon | 713 | 5 | **0.7%** |
| lobsters | 412 | 14 | 3.4% |
| discourse | 2,945 | 150 | 5.1% |
| openstreetmap-website | 551 | 37 | 6.7% |
| foreman | 839 | 67 | 8.0% |
| littleredbrick | 393 | 52 | 13.2% |
| forem | 1,614 | 250 | **15.5%** |
| kobble | 506 | 100 | **19.8%** |

A ~100× spread, at sample sizes where it is not small-denominator noise. *inference, and the confounders are real:* the extremes sort by **deployment fan-out** — the cost of a contraction to the person deciding whether to do one. GitLab and Mastodon are self-hosted by thousands of operators the maintainers do not control, making a column drop maximally expensive; the high-contraction projects are single-deployment applications. The cleanest natural comparison in the table is **forem vs. mastodon**: same domain (large Rails social platform), opposite fan-out, **15.5% vs 0.7% — a 22× difference in contraction share.** Confounders I have not controlled for: project age, team size, monolith-vs-extracted architecture, and whatever selection produced this repo list.

**What this does to the letter.** Three amendments, all in the direction of *more* support:
- "Unmeasured anywhere" is no longer accurate — say instead that the ratio has never been measured in a cheap-contraction regime *by design*, and cite the two partial signals.
- The pooled 5:1 should not be quoted as a property of schema evolution at all. It is a property of a *sample*, and repo-level factors dominate it by two orders of magnitude — which is exactly what "tool-confounded" predicts, stated more strongly than the letter states it.
- One guess of mine died usefully and should not be revived: I predicted Rails' `rename_column` would show up as a cheap-contraction escape hatch used more than explicit removal. *measured:* renames total 341 (283 column + 58 table) against 926 contractions. It does not. Rails' rename is itself a flag-day in any rolling-deploy world, which is precisely why expand/contract exists as a pattern.

*The pattern's names* (*reported*): Fowler's **"Parallel Change"** (2014) is the commonly-cited name; Ambler & Sadalage, *Refactoring Databases* (2006), is the earlier database-specific source — and the estate already holds ~60 of its pattern files under `rowan/docs/ref/patterns/`.

---

## 6. Names for the rest of the letter

*All `reported` with citations. Brief because these are outside the commissioned sections, but the letter cites them and they were cheap to get.*

- **§1 bowl/serving** = **logical vs. physical data independence**, the ANSI/SPARC three-schema architecture — citable as Tsichritzis & Klug, *"The ANSI/X3/SPARC DBMS Framework," Information Systems* 3(3), **1978** (not the informal "1975"). The field's own limits are worth inheriting with the name: the **view-update problem** was never solved in the general case, and physical independence leaks in practice through index and partition choice. A second framing exists in digital preservation: OAIS/ISO 14721 **"significant properties."**
- **§5(d) membership-edge attributes** = **UML association class** (Rumbaugh et al., OMT 1991) structurally; **property-graph edge properties** natively; and — the sharpest one for us — **RDF reification** (W3C REC 1999), which was tried, found to lose information and cost ~4× the triples, and effectively deprecated in favor of **RDF-star** (Hartig & Thompson, ~2014). That is the field trying the wrong way first and correcting *toward the letter's move*, which is about as good as prior art gets: we can cite the correction rather than repeat the mistake. The duplicated-`stage` rot is Codd's original update-anomaly motivation (1970).
- **§5(c) snippet-as-element-interior** = **XML external parsed entity** (parse-time substitution; the fragment is *content*, not a document — the letter's formal reading is exactly the spec's). **XInclude** (W3C REC 2006) is a *distinct*, post-parse mechanism with its own attack surface. Inherit the failure literature with the name: **Billion Laughs** (Amit Klein, 2002) and XXE, and the field's converged lesson — *any layer producing arbitrarily-longer output from short input recursively needs an explicit resource cap*, not just well-formedness checking. Neither inclusion mechanism is the safe one by default. This bears directly on §7's include design and its "whole-or-inert" degradation rule, which is the right instinct and is not by itself a resource cap.
- **§7 prefilter/postfilter** = the lexical-vs-syntactic transformation tier. Canonical citation: Kohlbecker, Friedman, Felleisen & Duba, *"Hygienic Macro Expansion,"* LFP '86 (coined "hygiene"). The finding is stronger than the letter's: **hygiene is specifically a postfilter-tier guarantee — it is a category error to ask for it at the byte tier**, and the field's verdict on the C-preprocessor and pre-hygiene-Lisp failures is that *conflating the two tiers* is the named root cause. Two language communities reached the letter's thesis independently, decades apart. The letter can state this as inherited rather than proposed.
- **§2 event-store shape** = textbook **event sourcing** / **CQRS** (Fowler; Young); the hash chain is a standard **tamper-evident log** (Crosby & Wallach, USENIX Security 2009; Certificate Transparency RFC 6962 as the heavyweight non-blockchain citation) — "genesis" and tombstone-instead-of-delete are established vocabulary there, independent of blockchain. "Spool" is the deepest-lineage word in the whole design (Unix print/mail spoolers). The **filesystem realization** of CQRS is the genuinely uncharted part: no writeup was found, positive or negative.
- **Event-sourcing regret literature** (*reported*, practitioner-tier, not peer-reviewed) converges on four things, of which two are ours: **schema evolution as the #1 regret** (long upcasting chains — directly §4 factor 3), and **projection/read-model rot with hidden inter-projector dependencies** — which is §5(d)'s derived-views layer, and a warning the letter does not currently carry. Also: aggregate-boundary changes force painful backward-incompatible refactors, and that is sharper for us than for most, because our keys are filenames — a boundary change means **moving files**, not an `UPDATE`.

---

## 7. What appears to be genuinely ours

*Stated at the tier the searches support: two independent agents reported failing to find these, and both flagged their own negatives as under-confident. Treat as "not found," not "does not exist."*

1. **The fault-attribution principle behind `.rejected` vs `.needs-review`.** The *mechanism* has names (quarantine, DLQ). The *principle* — that conflating submitter-error with system-uncertainty "mislabels system-uncertainty as user-error" and "trains agents to retry things that retrying cannot fix" — was not found articulated anywhere as a named design maxim. HTTP's 4xx/5xx split is the closest formal ancestor and is a status-code convention, not a stated principle about machine-facing refusals. For an agent-facing store this looks like a real contribution, and it is the kind that publishes.

2. **A VCS commit read as a consistent snapshot** (§3) — **and this claim is now substantially discounted by my own later research, which is worth showing rather than quietly editing out.** The *idea* is thoroughly standard: Iceberg's spec states plainly that *"readers always use a consistent snapshot of the table without holding a lock,"* and Delta Lake commits to *"Snapshot Isolation for Reads."* Snapshot-reads-over-immutable-files is the lakehouse table format's whole design. What remains possibly-unexplored is much narrower: obtaining it from **git's own mechanics** rather than from a purpose-built metadata layer. The §3 recommendation is unaffected and if anything stronger — it is now backed by two industrial designs rather than being a novelty — but it should be presented as **inheriting a standard technique**, not as ours.

3. **Bare `git status` as the conflict-resolution UI.** Found nowhere — Dolt, Irmin, Noms and Datomic all mediate. *inference:* this is genuinely novel and, per §4, genuinely load-bearing in a way that currently exceeds what it can carry; it works because there is a human at a prompt, and it fails silently in exactly the role-(b) case.

---

## 8. Recommended amendments, itemized

For §2:
1. Replace the identification with the constraint/objective formulation (§1.3). Delete the identity claim rather than softening it — it is not a weaker version of a true thing, it is a different thing.
2. Correct "atomicity exists at exactly one grain" → two grains, the second being the commit, currently unused (§3).
3. Move the cluster-record observation from "counter-evidence to watch for" into the argument as the disproof, and cite §12.4's "it usually is not" (§1.4).
4. Split the isolation claim by role: the `git status` warrant holds for (a) and fails for (b), with the lost-update trace (§4.1).
5. State the durability lean with the macOS/Linux split rather than one verdict, and name the directory-fsync omission plainly (§5.1).
5b. Reframe "the estate's universal answer" as **the estate's choice among several**, and carry the stage-then-flip invariant as the constructive primitive it is (§3.2). If the letter keeps "decompose" as our position, it should read as a *decision with a reason*, not as a description of what everyone does — and it should price the decision honestly: this is the continuing-per-relationship cost shape, not the build-once one (§3.3a).
5c. Do **not** cite Helland for "design the need away" at our scope. His argument is about entities that may land on different machines under repartitioning, and he explicitly permits an entity to span many files within one scope of serializability — which is where we live. He withholds support rather than refuting; the letter's position needs a different warrant (§3.3c).

For §4:
6. Name factors 1, 4, 5 (cardinality violation; record linkage / authority control / MDM survivorship; quarantine + DLQ + outbox) — §5.2.
7. Put the Cassandra frankenrow result on factor 2's face. It is the measured pathology of the exact design the factor proposes (§5.2).
8. Rewrite factor 3's caution per §5.3 — stronger, with the two new evidence lines and the dead rename guess.

Elsewhere: §1, §5(c), §5(d), §7 each get a name and an inherited failure literature (§6) — the RDF-star correction and the hygiene tier-conflation result are the two most worth landing, since both are the field having already made and corrected the mistake the letter is reasoning its way around.

## 9. What I did not check

- The chopping necessity direction, against the 1995 primary (§2).
- The Kleppmann A/I/D-vs-C passage against the book itself (§1.2).
- Any empirical crash test of APFS. The vendor-intent claim stands at vendor tier (§5.1).
- Whether the estate's spool drainer is actually idempotent (§5.2, factor 5).
- Whether the role-(b) lost update has **occurred**. The mechanism is demonstrated; incidence is unmeasured, and `git log` cannot show it — which is the point.
- The two "genuinely ours" negatives at more than two-agent search depth (§7).
- Live incidence of `index.lock` contention in this estate specifically (§4.3).
- *(Closed during this pass — Helland CIDR 2007 was read at the primary; see §3.3. The counter-case question resolved to "no documented case-study literature inside the paper; it is expert testimony without citations," which was the finding rather than a gap.)*
- Whether a documented counter-case literature exists **outside** Helland — actual postmortems of built-and-regretted multi-file transaction layers. Not searched. §3.3(b)'s asymmetry claim is about the canonical paper, not about the whole field.
- Whether Iceberg's and Delta's pointer-swap designs descend from git's ref-update specifically or from the older shadow-paging/MVCC literature. Open, and it bears on how much §3.2's convergence is worth.
