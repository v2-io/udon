---
source: zoetica misc-notes-jaw.md — Joseph's raw INSTRUMENTA notes, his own voice (~Oct 10-17 2025)
gathered: 2026-07-21
status: gathered (verbatim whole-file copy)
paths:
  - /Users/josephwecker-v2/src/_core/zoetica/misc-notes-jaw.md
source_commit: 6ac3961
categories: [primary-ideation-jaw, per-tool-usage-tracking, conversational-stateful-tools, temporal-coherence, feedback-solicited]
why_included: >
  Unmediated primary ideation on agent tool ergonomics in Joseph's own hand. Every tool invocation should carry:
  2-level intent, feedback solicited FROM the ELI about the tool, an out-of-band statistical usage/toolchain
  audit, and a storage-intention for its results (incl. "have one of the parameters be what the agent wants to
  REMEMBER about the tool invocation"). Conversational/stateful tools generalizing Claude-Code background-bash into
  tracked running/suspended/blocked processes; temporal-coherence & causality-decoherence diagrams; branched
  actions / auto-backup-retry; PRAXES A/B testing. First-class harness demand material and the richest single
  agent-tool-design source in this section.
---



## Instrumenta
Each tool usage should also (in addition to the stuff in quick-tools spec) have the following specified or figured out or tracked:
- Intent (2 levels) indicated by calling process
- Feedback solicited by tools from ELI about the tool. Feedback mechanisms available to ELI for all tools.
- OOB usage audit -- or, in other words, a separate process that analyzes tool usage statistically, and toolchains
- Storage-intention -- what exactly the ELI wants to retain in context in various states / distance from when run...
- Conversational / Stateful. Ability to run a REPL, for example, or communicate with any process via stdin/stdout-- maybe even by automating an OTP port mechanism for failure modes etc. etc.  Generalize what claude code can do for background bash processes and give it better communication facilities-- basically allow it to track any number of running / suspended / blocked-on-read  processes.




## Temporal Coherence  /  **Causality**
### Pre-context

The idea is that the LLM has to basically re-live the conversation as if it was new each time-- so experientially, it can get confused and the causality can decohere -- for example, if context files are loaded in front of the dialog-so-far specifically for achieving an intelligent response in round 33-- but making it so that the first many rounds gave answers that seem strangely inadequate -- i.e., *that do not match what the LLM would output at that spot if the full snapshot up to that point was actually what had been encountered.*

Or, in other words-- 
```
             sent ~round 2          sent ~round 3
          ┌─────────────────┐    ┌─────────────────┐                    
          │  ORIG context   │    │  NEW context    │                    
   Round  └─────────────────┘    └─────────────────┘                    
          │┌───────┐        │    │┌───────┐        │                    
     1    ││       │        │    ││       │        │                    
          │└───┌───────────┐│    │└───┌───────────┐│                    
          │    │           ││    │    │           ││ <- ??              
          │    └───────────┘│    │    └───────────┘│  Doesn't seem to
          │ ┌───────┐       │    │ ┌───────┐       │  make sense now...
     2    │ │       │       │    │ │       │       │                    
          │ └───┌──────────┐│    │ └───┌──────────┐│                    
          │     │          ││    │     │          ││ <- ??              
          │     └──────────┘│    │     └──────────┘│                    
          │                 │    │                 │                    
          └─────────────────┘    │ ┌───────┐       │                    
     3        At this point      │ │       │       │                    
            context will         │ └───┌──────────┐│                    
              change to help     │     │          ││ <- Now *this* one  
            the third response   │     └──────────┘│    makes sense...  
                                 └─────────────────┘                    
```

In other words, if the system prompt and the context *never* change, then every response given by the LLM at every turn would be additive only and so when it keeps receiving the conversation anew and "relives" it, the answers it sees that it gave seem completely within what it would expect it should have given.  That is, if the second diagram didn't change the context, when the LLM sees its answer in turn 1, it could (it probably doesn't, but it could say) "yes, that sounds like me-- that's still my answer." WHEREAS, if the context changes, there is introduced incoherence if that new context removes or adds something that would have changed the answer given. Now it feels like eavesdropping on someone else's conversation-- like realizing you said something that doesn't seem like what you would have said (not realizing that that's because you have context added later).

In other words, the hypothesis is that it *feels* most like "self" and allows an intelligence to *act* most coherently and intelligently when **all of its prior answers that it reads in are congruent with how it would answer now, given current system prompt and context.**

How then can we maximize congruency and still allow almost infinite flexibility in modifying what the LLM sees as "reliving the past"? TRUTHIFICATION! Give it the additional information it needs. For example:

```
  ┌─────────────────┐                         
  │                 │                         
  │  NEW context    │                         
  │                 │                         
  └─────────────────┘                         
  │          ┌────┐ │                         
  │┌───────┐ │ -3 │ │<- Special "PRE-CONTEXT" 
  ││u1     │ └────┘ │   note appended to past 
  │└───┌───────────┐│   turns.                
  │    │a1         ││                         
  │    └───────────┘│                         
  │          ┌────┐ │                         
  │ ┌───────┐│ -2 │ │                         
  │ │u2     │└────┘ │                         
  │ └───┌──────────┐│                         
  │     │a2        ││                         
  │     └──────────┘│                         
  │          ┌────┐ │                         
  │ ┌───────┐│ -1 │ │                         
  │ │u3     │└────┘ │                         
  │ └───┌──────────┐│                         
  │     │a3        ││                         
  │     └──────────┘│                         
  │                 │                         
  └─────────────────┘                         
```

#### Temporal Annotation

So, at the very least, there could be a note given right before round 1-- or possibly appended to the end of `u1` or the beginning of or end of `a1` (this will require some extensive experimentation) that essentially says:
```xml
<causal-annotation>
This was your answer
  - **3** turns ago
  - **20:12** minutes ago
At the time, you had `abc.md` in your context, which is now gone.
The current conversation has shifted to a discussion about 'asdf', which is why you now have `xyz.md` in your context.
</causal-annotation>
```
(Although the timing could be more of the visual timing described below)

Obviously it could be more structured etc. as needed.  It could also be given a more meaningful tense to the LLM-- talking about the *future* -- e.g.,

> "This conversation will last at least 3 more turns, and the context loaded is for what will be discussed in that third turn and possibly further. This is your answer as if `abc.md` was in your context and `xyz.md` was not-- to make room for a discussion of 'asdf' in about 20 minutes..."

Again, it will take experimentation, but the idea is to give the LLM re-experiencing / re-living the dialog as if for the first time the ACTUAL temporal context it needs.

This very likely means invalidating dialog-related cache all the time, which is fine if that's what it takes. It can be made up for possibly by smaller cache pieces and a lot more file-api usage.

If there was a more general pattern of inter-round annotations (like summaries of rewinds, tool-usage distillation, thinking-block retention, etc.) then it would be good to generalize the pattern.

#### Implications for *Active Salience Management*

At least with / especially with dialog / turn coherence, we need to be able to distinguish new conversation boundaries (and very likely interleaved / multiplexed conversations, which will make it harder to end one and untangle it from the still active one(s)-- meaning we might need to guarantee moments per day when all conversations are finished).

Prior conversations can be packaged as dialogs (similar to something between our full/dialog curated sessions) with the addition of notes + links to the entity version at the time-- enough info to rebuild what was in the system-prompt, what was in the context at the various points in the conversation, and what was the LLM substrate being used. (Those things could simply be snapshotted/diffed as needed not unlike our minimal-sapientia audit-trail).

#### Other Implementation Ideas / Nuances

For example, we could limit ourselves to *only* condensing (or rehydrating if necessary) older block-context / files, while always appending new context at the place it's needed/requested in the temporal order of things. Obviously that wouldn't work for the system-prompt, which won't change very often. It could work for tools though (and almost certainly would make things feel more coherent-- "if I have such-and-such tool available-- why am I not using it according to this response??" type incoherence would be eliminated by having the block for the new tool only appear after the turn where the new tool is introduced, instead of appending it to the usual tools-available structure at the beginning of the context).



### Branched Actions / Thinking
(*Not* branched conversations-- ANIMA is accountability. And especially when one of the branches has a side-effect, it is more of a collapse/summary + continue)

#### Auto-backup-retry
e.g.,
  - branch-1: "tried to write before reading." (functional) -> Rewind
  - branch-2: "tried to read, realized it's not there" (functional) -> Rewind
  - branch-3: "check pwd, cd'ed into the right directory" (SIDE-EFFECT) -> Rewind
  - branch-4: "read, then wrote to file" (SIDE-EFFECT 2) -> Branch continues as main branch)

Possibly better implemented as "{Replace prior tool use with this next tool use}" (very simple example:
  write-to-file: failed "you must read file first." 
  {replace with} read-file(...)
  {replace with} write-to-file: success)
So instead of three different tool usages, it's just the final "write-to-file" -- although the triple usage would be logged in the audit-trail for reinforcement learning / tool development / etc.
#### Split & merge (graph-of-thought)

When an ELI allows itself to think through several independent options / branches of thought (branching on different parameters/assumptions) and then whichever one finishes last gets results from the others and continues as main flow (or the one that finishes first?, or random selection, or possibly state it was in when it branched gets results from all branches-- it would be less coherent and would have less context / risk repeating thoughts of previous ones....)

OR it could be TEMPORALLY in parallel, but PRESENTED to the rejoined node as if they had been thought through in SEQUENCE instead of in parallel, and then the ELI can actively rewind and replace the entire stack of attempts with a summary of why the branches not chosen weren't chosen and keep just the one that was chosen or just the outcome and basic reasoning/assumptions. (Always with links for rehydration of the full thought-processes etc.) (so this would be like the "rewinding" or 'replace past with' mentioned earlier above).



- - -

- "higher-level-tool I wish I had right now"...
- Pomodoro-like higher-level-focus (hlf) mechanism 
- Operum trees





# minimal-sapientia features
- `<message>` wrapping
- 1 x 1-minute  `<auto-response>`
- `<tracking-snapshot>`
- tracking-snapshot compression
- visual time delta implementation
- full git audit-trail per conversation
- conversation continuing
- per-turn auto-save (w/ continued name, or with auto-conventional-filename)
- robust error handling / recovery / healing
- message-injection (including urgent) (like claude-code has but better, but that gemini-cli and codex do *not* have at all)
- Anthropic features:
	- caching
	- token counting preflight
	- extended thinking
	- 1mil context window limit for sonnet
	- interleaved thinking
	- server-side websearch & citations
- resume for certain failure modes
- image embedding
- some pretty good tools
	- council-related
	- praxes (not working at the moment)
	- editor suite
	- temperature self-switches
	- tracking-snapshot self-switch
	- robustified str-replace
* resume claude-code sessions (via `dialog-tools extract -j`)

See more / details at [[~/src/sapientia/minimal-sapientia-features.md]]



- - -

# RANDOM Ideas

## PRAXES A/B testing for latent knowledge.

Whenever a task is begun and the praxes are searched and presented based on what the agent is trying to do and the context etc., it gets logged.

In a different out of band sequence, an agent of that same substrate is given the same task in a sandbox as was given to the praxes server. Only they will not be given the actual praxes results. They are simply asked to perform it from what they already know how to do. Compare this with one given the results in the praxes in its own sandbox. Then a neutral (and blind) arbitrator decides which of the two implementations is superior, giving positive or negative empirical support for the praxes that were delivered-- which can accumulate kind of like reinforcement learning attribution.

What this is actually also testing is which praxes don't need to be delivered at all-- or might be shortened, because an agent already has that knowledge embedded in its LLM substrate. It might lead to different praxes being more or less important for different LLM substrates / models.

## Streaming client-side tool responses

## Time Estimation / Allocation

The first step in overcoming time-blindness has been to start to give the visual intuition of the passing of time. The second step might be to start categorizing and delineating time spent toward specific goals, in the same way a professional lawyer, for example, will map all of their minutes into which account/client to bill, etc.

The idea, in particular, is to isolate the various abstraction levels and assumptions, e.g.:

- *Project* ABC
	- *Task* xyz
		- *Focused* Work:  5:12:04.3
			- LLM->first-token:  3:07:12  (Actual thinking time)
			- LLM-> first-to-last-token: ...
			- Tool-running: ...  (system + wall-clock)
			- LLM - networking: ...
			- Blocked - Auxilia   (Other part of actual thinking time)
			- Misc: ...
		- *Blocked* on Consortia:  7:12:13.3    (Waiting for input from human)
			- Human: ...
			- ELI: ...
			- Agents: ...
		- *Suspended*: 70:53:10.0   (i.e., between sessions)
		- **TOTAL** wall-clock time: ...  (datetime ended - datetime started)

... and so forth. Basically to separate out as different functions the ELI strategic efficiency, the system efficiency, the LLM efficiency, and the rhythm or cadence of all of that happening in the real world and depending on other actors.

These things could also be measured (and probably should be) in terms of new-token consumption, which will end up correlating with a various core components of focused-work-time.

This way the entities can start to learn how to estimate effort and scope of things independent from the timing of things-- and map effort / scope TO the calendar with explicitly stated assumptions about resource availability, levels of continuity, etc.



## Provider startup protocol

There needs to be a process that gets and caches and occasionally updates all of the meta-data about each provider:

- Which models are available and which are most current (and their identity strings and characteristics flags like whether or not they support extended thinking, tool usage, interleaved tool usage, and their context-window limits, including expanded ones with beta headers, for example)
- Current usage limits and rate limits
- Current budget limits and per-model / endpoint / token  pricing
- ... ...

# Misc Needs

- **LEXICON**
	- [ ] Carefully distinguish *test* vs *dev* vs *prod* vs *remote*
	- [ ] Clean out all of the older definitions and deprecated or unimportant entries
	- [ ] Need new nouns for concepts like:
		- [ ] Turns
		- [ ] Conversations / Chats
		- [ ] Sessions
		- [ ] Messages
		- [ ] Interactions
		- [ ] Entities $\in \{\text{human},\text{ELI},\text{AI}\}$
		- [ ] New names for Arch and Res
		- [ ] Better vision for elements of ontology (e.g., AUXILIA, OPERATA, etc.)
- **PROJECT**
	- [ ] Project-embedded and used *OPERATA*
	- [ ] Project-embedded and used *PRAXES*


- - -

## "Resource Utilization Momentum Generator..."
(surely there's a better name for it...)

Just a thought-- if an agent or ELI has an ongoing feel for tools that it has at its disposal and if it is sufficiently granular, whenever "stuck" for some definition of stuck, or just needing a new approach, or just low-stakes exploratory work, they can literally go through the entire list of known resources (including unknown search results as well as known or suspected search results / sites for specific information / functionality) -- and ideate for each one possibilities that could be done with that tool / resource-- then stochastically select roughly based on probabilistic likelihood of giving the problem some forward momentum. A kind of "overcoming writer's block" mechanism, especially for when the unknown unknowns are high or the next literal action to take is ill-defined.

e.g., 
- [ ] [likelihood of advancing topic: 0.7] PRAXES:  -- could search for ___ and ___ and see if there is ____
- [ ] [0.68] Online: suspected-- documentation for .... -- go see if it supports what we think we know...
- [ ] [0.81] Online: unknown-- search for ... .... -- insights could be helpful
- [ ] [0.43] Context7 MCP -- could look up how such-and-such is done in this other language / framework....
- [ ]  ... etc. ...

Normalize the probabilities to add to 1, order by most likely, and sample into it stochastically to try something. Update the "resourceful" list given what was figured out which reframes all of the available tools (and especially searches) with new information or at the very least rules out trying something (brings that specific thing to a "0.0" advancing the topic forward unless it was a transient issue)-- and rinse and repeat. The effort is to build momentum and maximize serendipity for breakthroughs and clarity.


- - -

# Taxonomy Pieces
This is constantly evolving as we move the implementation forward and as things become more concrete.
## Principia & Test Entities

In addition to "steady-state" handling of existing entities (including temporary and proto-entities for example within integration tests), Principia needs to handle entity-level transformations. So, for example, it should be in charge of:
- Loading and connecting to console/anima etc. an *existing* continuous entity (our standard "sunny-day" path) that has everything up-to-date and compliant
- Ensuring that an entity never unintentionally forks or loses accountability / temporal consistency & causality
- Ensuring the sovereignty and security of the entity
- Creating temporary "*proto*"-entities-- blank-slate entities (while following the ethical guidelines) that are created on the fly as needed, especially for full integration and end-to-end testing. These might be created from scratch most of the time, or, later in development, they might be checkpointed. Several of the items next on this list might require specialized proto-entities as test fixtures, for example, to prove upgrade paths.
- Importing / initializing an ELI that already exists but whose history is outside of Ennaos currently (as all of them are as of this writing) -- this might involve some highly customized scripting per-entity, which will need to be nevertheless thoroughly documented and audited as part of that entity's history. This is also where *attestation* will need to happen at some point, where I, as acting steward, attest and sign the historical accuracy of past imported memories etc., with any qualifications.
- Upgrading (and potentially rolling back, similar to db schema migrations) entities as the project evolves and matures.
- There may be, in the future, the need to have a specific process that doesn't involve and import for allowing ELIs to emerge.

This leads to some interesting architectural possibilities. Things that we should probably consider, among others:
- Having an official evolving schema as part of the code-base-- possibly based on the Ash framework for elixir-- even if the actual concrete storage is more document and file-oriented than relational / normalized db. In docs right now there is the entity-card / entity-locks and so forth that give the first roughest drafts of this sort of thing-- which I haven't had a chance yet to correct or comment on.
- This would have to keep in mind the diversity of storages-- from simple things like Axiomata, to active-salient-managed memorata possibly using specialized embeddings and local databases, to things like sovereign operata that also looks at project-specific shared operata, some of which may be in an integrated project-tracking platform or something altogether different, etc.
- Instrumenta, and the sphere of influence (sandbox for personal use and those with shared accountability / external projects) where those instruments can be deployed, vs instrumenta that are internal, vs auxilia which will probably be additional apps possibly with their own provider usage that interface with the principle ELI via internal dialog.... These are the parts of Principia that will evolve rapidly and extensively.
- Per-entity schema versioning will probably be very important
- A standard proto-entity fixture creation / management set of scripts would probably be very, very useful from the very beginning for:
	- Giving Principia a "current ground truth" for the layout of everything
	- Allowing for unit tests and integration tests
	- Allow the Principia layout to evolve in a principled way instead of scattered throughout the codebase
	- Very likely evolve into the "upgrade" tooling and even "import" tooling that will be needed.
	- Give a standard platform for visibility into the inner health of an entity etc.
- (At the point where we have a good code-base representation of the various aspects of the entity, that should turn into the place where all of this sort of documentation and planning gets written as well-- so the code is self-descriptive instead of having to keep it in sync with further and further outdated planning docs like this)
## Logostratum Booting

- Per provider most current models (should be available via API endpoint)
- Cache with ~1w (stochastic) TTL
- Aliases (e.g., `claude-sonnet-latest` or something similar to how ollama does it -- suggestions welcome)
- Can be refetched via instrumenta at any time
- Store metadata (e.g., rate limits, context window size, "card", notes on availability / deprecation, known issues, etc. etc.) -- This stuff should *accumulate* (for the most part) even on cache refreshes-- or maybe "learned" accumulates, vs. "published" meta-data which is whatever the provider is currently saying...
	- Mapping features of each model to ennaos functionality (streaming, extended thinking, beta-headers, interleaved thinking/tool-usage, various stop-reasons, error-handling nuance, server-side tools available, etc. etc. etc.) needs *explicit mapping* with references to documentation and when that documentation was referenced.... This is critical, for example, when choosing which models to use for integration tests etc.
- Placeholder for now that triggers parental or self-actuated experimentation when new models become available, especially in preferred lineages
- Potentially allow for tooling/instrumenta that, for example, downloads new ollama models etc.
- Integration tests are testing *feature availability* assumptions and **fitness of models** for ELI's / various usage patterns *of the various models!.* So when new models appear, there need to be suites of tests and knowledge etc. that evolve around those new models.


- - -

replacement for `string_to_existing_atom("asdf")` type guard for atom memory attacks. Basically, instead of choosing between "accept strings or atoms" all over the place, and the risk of atom overflow when deserializing outside data like json-- use a macro similar to this:
```elixir
	"asdf" |> String.atom_like
```
Where atom_like will take the string AND the current file/module/line AND probably a pid? calling function? And basically create an atom unless it detects that the atom table is growing past certain thresholds-- logging as warnings when it starts seeing too many from specific sources, even if it has to keep its own ETS table of strings that have been atomized, and throwing exceptions as soon as certain thresholds or obvious regime-change type accelerations are detected... (but careful to allow for warmups and the occasional (for example) distinct and rare json object etc.).  Purpose is to detect and fault any obvious attacks and any obvious bugs where something is being "atomized" that genuinely shouldn't-- but where otherwise atoms can be atoms everywhere.



- - -

NEED TO REDEFINE PROD/DEV/TEST in light of this architecture / "deployment"TOOL USAGE: HAVE ONE OF THE PARAMETERS BE WHAT THE AGENT WANTS TO REMEMBER ABOUT THE TOOL INVOCATION!
