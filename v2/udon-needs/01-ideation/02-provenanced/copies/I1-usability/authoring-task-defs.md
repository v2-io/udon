---
source: UDON repo — test/usability/lib/realistic_tests.rb (TASKS) + test/usability/lib/context_comparison.rb (TASKS) — the genre briefs agents were asked to author, plus the LLM-judge rubric
gathered: 2026-07-21
status: gathered — verbatim excerpts of the two TASKS hashes and the realistic judge rubric; Ruby plumbing (load_context/build_prompt wrappers) omitted
paths:
  - test/usability/lib/realistic_tests.rb:18-88
  - test/usability/lib/realistic_tests.rb:131-178
  - test/usability/lib/context_comparison.rb:18-30
source_commit: 3d8e5b9c52b2a581c4ab9021984423073a694693
categories: [genre-catalog, authoring-tasks, what-was-asked, conversion-round-trip, minimum-viable-context, judge-rubric]
why_included: >
  The concrete genres the team believed agents would author in UDON — read these
  BEFORE sampling the bulky realistic/context_comparison result yamls, per the
  target-file note. realistic_tests probes conversion/authoring (yaml-frontmatter,
  experiment report, yaml-config-with-comments, conversation log, recipe from
  scratch); context_comparison probes six shapes (config, mixed API tutorial, org
  chart, inline-heavy science prose, blog schema, HTML email template) each run at
  three context levels (cheatsheet / minimal / comprehensive) to find the MINIMUM
  VIABLE CONTEXT an agent needs to produce good UDON — a direct agent-tooling
  question (how much reference does a model need in-context to author correctly).
  The judge rubric encodes the team's own "correct UDON" priors: attributes for
  metadata, elements for containers, inline for prose markup, and the anti-pattern
  `|title "value"` vs `:title value`.
---

# Authoring-task genre briefs + judge rubric

Two harness tracks, verbatim. `realistic_tests` = conversion/authoring with a
reference example and LLM-judged output. `context_comparison` = same six task
shapes run at three context levels to locate minimum viable context.

## realistic_tests TASKS (`realistic_tests.rb:18-88`)

```
yaml_frontmatter — "Convert YAML frontmatter + prose to UDON"
  input: an API Authentication Guide (title/version/last_updated/author{name,email}/
         tags frontmatter + "Getting Started" bearer-token prose)
  prompt: "Convert this to UDON."

experiment_report — "Structure an experiment description"
  input: a caffeine-vs-reaction-time paragraph (50 participants, 245ms SD=32 vs
         289ms SD=41, p<0.001, 3 reported jitteriness)
  prompt: "Convert this to UDON, marking up the key data points."

yaml_config — "Convert YAML config with comments to UDON"
  input: database{host,port,pool #increase for production,ssl} / cache{host,ttl #seconds}
         / features[- dark_mode, - notifications, - beta_features #remove before launch]
  prompt: "Convert this to UDON."

conversation_log — "Structure a conversation log"
  input: a 7-turn timestamped User/Agent debugging transcript ([2025-01-15 14:32:01] …)
  prompt: "Convert this conversation to UDON."

recipe — "Create a recipe document from scratch"
  prompt: "Write a UDON document for a simple pasta recipe with prep time, cook time,
           ingredients, and instructions."
```

Build-prompt tail (verbatim): "Output UDON only. No explanation."

## realistic_tests judge rubric (`realistic_tests.rb:131-178`, verbatim criteria)

```
Rate each 1-5:

1. Syntax correctness: Does it use UDON syntax properly?
   - |element for structure, :attr for attributes, |{inline} for inline
   - NOT |title "value" when :title value is appropriate
   - Proper indentation for nesting

2. Appropriate structure: Did it choose the right patterns?
   - Attributes for metadata (version, date, author)
   - Elements for containers (sections, items)
   - Inline elements for marking up prose without breaking flow
   - NOT everything as child elements when attributes fit better

3. Prose flow: Does prose still read naturally?
   - Inline elements enhance rather than interrupt
   - Document structure doesn't fragment the narrative

4. Task completion: Did it accomplish what was asked?

Output JSON only:
{"syntax": N, "structure": N, "flow": N, "completion": N, "notes": "brief explanation"}
```

## context_comparison TASKS (`context_comparison.rb:18-30`, verbatim)

Purpose (file header): "Compares agent UDON output quality across different
context levels (cheatsheet, minimal, comprehensive) to find minimum viable context."

```
config:      "Write a UDON config file for a web server with host, port, SSL
              settings, and a list of allowed origins."

mixed_doc:   "Write a UDON document that's a short tutorial explaining how to use
              an API. Include prose explanation with inline code references, a
              structured endpoint definition, and a note about rate limits."

nested:      "Write UDON representing a company org chart: CEO with two VPs, each
              VP has 2-3 managers, each manager has a team. Include names and titles."

inline_heavy:"Write a UDON paragraph (prose) about a scientific experiment. Embed
              inline elements for: the hypothesis, key measurements (with units as
              attributes), and a reference to another experiment."

schema:      "Write a UDON schema for a blog post with required title, optional
              subtitle, author (with name and email), list of tags, and published date."

template:    "Write a UDON template for an HTML email that greets the user by name,
              shows their recent orders in a loop, and has conditional content for
              premium vs regular users."
```

Each task × {cheatsheet, minimal, comprehensive} reference contexts = the
21-file `udon-context_comparison-*.yaml` matrix.
