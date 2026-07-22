---
source: Joseph turn in pipeline-discussion (fold → accumulation list + ornamental fixpoint)
gathered: 2026-07-21
status: gathered excerpt from deliberation record
paths:
  - v2/udon-needs/pipeline-discussion.md:98-130
categories:
  - accumulation
  - ornamental
  - stages-homelessness
why_included: |
  Primary statement that 'the host decides' hid many distinct accumulation needs; ornamental double-round-trip criterion.
---

> **Why gathered:** Primary statement that 'the host decides' hid many distinct accumulation needs; ornamental double-round-trip criterion.

<!-- excerpt v2/udon-needs/pipeline-discussion.md:98-130 -->
## Joseph
*[Objection and brainstorm (verbatim), clearly frustrated at the presumptuous and patronizing "I can drop this 'corrected diagram'..." 7/20]*

❯ Sorry, you can draw it all you want but it won't convince me that it's right yet. I'm trying to determine if there's a better or more accurate or descriptive term for "fold" and "result channel" vs ADR vs AST.  The things that aren't determinable at construct arrival on the wire include (off the top of my head, not comprehensive) the list below. This is a consequence of us not having a pre-existing tokenizer -> lexer -> parser divisions due to the extra friction those would add to this language in particular, which means we have significant flexibility in (and have to be very thoughtful about) the assembly line. So, what needs some level of accumulation of raw events before it can be determined. In the 0.8 and 0.9 lines we were overwhelmed enough trying to nail down the event-stream that we often conflated the stages, but the spec *did* start to gather things that were "the parser/host decides" etc. which was essentially shorthand for "some stage after the raw event stream" except we had to do at least a naive text flattening to even get that right. Some of the things that require various degrees of assembly first but that also still stepwise / chunky-streamable to one degree or another, not in any order:

  - ornamental blank line detection (blank lines that are determined to be 'geometric' for making the udon doc legible instead of being part of a text block, even sometimes when adjacent to text blocks [or whatever we will call those])
  - full text-block grouping (the only one you defined "fold" as an incomplete example)
  - attribute correspondance rules (e.g., value stacking)
  - key integrity checks on definitions
  - key integrity checks on references
  - mixins
  - value typing & parsing (default included dialects)
  - value typing & parsing (chosen dialects)
  - schema compliance
  - dialect loading (possibly)
  - liquid dialect *checking* (early)
  - liquid dialect *processing* (later but still stepwise capable, or outputs a runable template against any context object)
  - temporal dialect processing
  - rust dialect processing (will probably affect types available and runnable liquid areas)
  - potentially, unmet expectations (many beyond closed delimiters, such as template if-clause closings, etc.)
  - ...

  Due to the friction that had accumulated in the undisciplined / disorganized original spec, natural drift, and accumulated drift in the grammar, mixed with the disorganized chain of processing (which is not an indictment-- that tactical intuition allows us to be more organized now), we had to limit ourselves to just trying to get a stable event-stream with simple text fold. But we now can look at everything holistically and figure out what is "right" in a way that is more holistic than just fixing what we were struggling with tactically before now.
 
 (NOTE: I have only started going through the results from you and the other t parts of the rulings table-- so it's almost certain there are more refinedideas that aren't represented yet above. If it isn't yet, I think we should consider defining "ornamental" as 'choices about things that change how the udon looks without changing the AST (or some late consumable form before that), except they mayn namespace for exact verbatim round-trip. But it can be proven to beornamental if a round-trip is made that strips them before going back to udon, and then a second round trip results in the same original AST + exactly the same udon as the result
  of the first round-trip, i.e.:

```
    original.udon  -> (drop ornamental)       original.ast -> house-style.udon
  house-style.udon -> (drop house ornamental) original.ast -> house-style.udon
```

)

