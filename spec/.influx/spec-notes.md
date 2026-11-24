# Specifications

{{ video_embed | replace("%%VID%%", "ehe96Xnkjys")}}

A *specification* is a contract between a *client* of some unit of code and the
*implementer* of that code. The most common place we find specifications is as
comments in the interface (`.mli`) files for a module. There, the implementer of
the module spells out what the client may and may not assume about the module's
behavior. This contract makes it clear who to blame if something goes wrong: Did
the client misuse the module? Or did the implementer fail to deliver the
promised functionality?

Specifications usually involve preconditions and postconditions. The
preconditions inform what the client must guarantee about inputs they pass in,
and what the implementer may assume about those inputs. The postconditions
inform what the client may assume about outputs they receive, and what the
implementer must guarantee about those outputs.

An implementation *satisfies* a specification if it provides the behavior
described by the specification. There may be many possible implementations of a
given specification that are feasible. The client may not assume anything about
which of those implementations is actually provided. The implementer, on the
other hand, gets to provide one of their choice.

Clear specifications serve many important functions in software development
teams. One important one is when something goes wrong, everyone can agree on
whose job it is to fix the problem: either the implementer has not met the
specification and needs to fix the implementation, or the client has written
code that assumes something not guaranteed by the spec, and therefore needs to
fix the using code. Or, perhaps the spec is wrong, and then the client and
implementer need to decide on a new spec. This ability to decide whose problem a
bug is prevents problems from slipping through the cracks.

**Writing Specifications.** Good specifications have to balance two conflicting
goals; they must be

* sufficiently restrictive, ruling out implementations that would be useless
  to clients, as well as

* sufficiently general, not ruling out implementations that would be useful
  to clients.

Some common mistakes include not stating enough in preconditions, failing to
identify when exceptions will be thrown, failing to specify behavior at boundary
cases, writing operational specifications instead of definitional and stating
too much in postconditions.

Writing good specifications is hard because the language and compiler do nothing
to check the correctness of a specification: there's no type system for them, no
warnings, etc. (Though there is ongoing research on how to improve
specifications and the writing of them.) The specifications you write will be
read by other people, and with that reading can come misunderstanding. Reading
specifications requires close attention to detail.

Specifications should be written quite early. As soon as a design decision is
made, document it in a specification. Specifications should continue to be
updated throughout implementation. A specification becomes obsolete only when
the code it specifies becomes obsolete and is removed from the code base.

**Abstraction by Specification.** Abstraction enables modular programming by
hiding the details of implementations. Specifications are a part of that kind of
abstraction: they reveal certain information about the behavior of a module
without disclosing all the details of the module's implementation.

*Locality* is one of the benefits of abstraction by specification. A module can
be understood without needing to examine its implementation. This locality is
critical in implementing large programs, and even in implementing smaller
programs in teams. No one person can keep the entire system in their head at a
time.

*Modifiability* is another benefit. Modules can be reimplemented without
changing the implementation of other modules or functions. Software libraries
depend upon this to improve their functionality without forcing all their
clients to rewrite code every time the library is upgraded. Modifiability also
enables performance enhancements: we can write simple, slow implementations
first, then improve bottlenecks as necessary.

The client should not assume more about the implementation than is given in the
spec because that allows the implementation to change. The specification forms
an *abstraction barrier* that protects the implementer from the client and vice
versa. Making assumptions about the implementation that are not guaranteed by
the specification is known as *violating the abstraction barrier*. The
abstraction barrier enforces local reasoning. Further, it promotes *loose
coupling* between different code modules. If one module changes, other modules
are less likely to have to change to match.


---
## (Video Transcript)
*(a little bit mangled; sorry. Source https://www.youtube.com/watch?v=ehe96Xnkjys&list=PLre5AT9JnKShBOPeuiD9b-I4XROIJhkIU&index=71)*

It's been said that computer science is the science of abstraction or perhaps
efficient abstractions what is an abstraction well as a verb to abstract here
means to forget information with the purpose of being able to treat related
things as being the same that is you're forgetting about the details that
aren't important and focusing on what is important what the common pieces are
as a noun abstraction means the artifacts that result from that process those
artifacts might be functions or modules or classes or whatever your programming
language uses to organize its code when we create those functions say one of
the important pieces of abstraction is writing specifications specification
here as a noun means the intended behavior of the abstraction we're
communicating to other humans what the behavior is supposed to be as a verb to
specify that's the act of creating such an artifact creating a specification
there's two different audiences for specifications and we write documentation
for both audiences though it's not the same documentation because they have
different needs there are clients and implementers the clients are the people
who are going to consume the specification perhaps it's a standard library for
example and you're the client because you're reading the documentation in the
standard library the implementers are the people who are going to be
maintaining the code or perhaps writing it the first time these are the people
who need to understand maybe more pieces maybe lower level pieces of the
specification than the clients do to a client a specification tells them what
they must guarantee here i'm thinking of this particularly in terms of
functions that is what the preconditions are a client must arrange such that
when they call a function they have satisfied the precondition for that
function the specification for a function also tells the client what they can
assume as a post condition they get to know what the output of the function is
according to whatever the documentation tells them for implementers it's a bit
opposite the specification tells an implementer what they can assume as a
precondition because the client had to satisfy that so at that function
boundary whoever's implementing the function gets to say all right i am assured
that that precondition holds because the client would never get to call me if
it didn't they might of course but that's not the implementor's fault that's
the client's fault and the specification tells the implementer what they must
guarantee as a post condition right so now it's the implementer's
responsibility to arrange for something to hold not the clients so there's a
kind of duality going on here between clients and implementers between
preconditions and post conditions between assumptions and guarantees
specifications give us a lot of benefits in terms of modular programming they
help us with locality we can understand an abstraction without needing to read
the implementation of it when the specification gives enough information to the
clients specifications also help us with modifiability by clarifying exactly
what it is the code is supposed to do the implementer now as they evolve the
code later in time gets to change that implementation without breaking the
client code because it was clear what the client could rely on and finally
specifications give us accountability they clarify who is to blame when
something goes wrong is the client to blame because they violated a
precondition or is the implementer to blame because they violated the post
commission we say that an implementation satisfies a specification 

Chapter 2: An implementation satisfies a specification if it provides the
described behavior if it provides the described behavior now of course there
are many implementations that might satisfy a given specification there's again
a duality between the client the client can't make any particular assumption
about which of those implementations the implementer chose but the implementer
does get at the end of the day to pick which one they want that doesn't mean
the implementer should be perverse or malicious both parties here should be
acting in good faith in order to agree as to what the specification means but
ambiguities can arise let's think about this from the

Chapter 3: Factors creating ambiguity
• The client didn't understand what they wanted you to implement
• The client genuinely didn't care
• You didn't understand the meaning of some piece

perspective of the implementer here are some factors that might create
ambiguity maybe the client didn't really understand what they wanted you to
implement if the client had something in their head and they tried to ask for
it but they didn't quite manage to express it right this happens all the time
in software development maybe the client genuinely didn't care like they left a
piece of something unspecified because they were good with whatever you gave
them as long as it met the rest of the specification or maybe you as an
implementer don't actually understand the meaning of some piece of the
specification like there's a word in it you didn't actually understand the
technical meaning of all of these can lead to what is perceived as or maybe
actually is ambiguity and a specification so what strategies might you follow
in the future when you encounter ambiguous specs

Chapter 4: What if spec is ambiguous? Ambiguity is a fact of life. Do the most
reasonable thing you can. well first off let's recognize that ambiguity is a
fact of life but let's also act in good faith as implementers we should try to
do the most reasonable thing we can now it's true that when a precondition is
violated you could do anything you want like set the computer on fire but
probably setting the computer on fire is not the most reasonable thing to do so
let's ask who wrote the specification if you are the one who wrote the
specification and you discover ambiguity you can seek to improve refine that
specification into something that is clearer if the client provided the
specification then you can seek clarification from the client but you need to
be a little careful about this there's a difference between asking for a few
clarifications and asking for 500 clarifications you do the latter and the
client might just not hire you again because you couldn't figure out how to
resolve low-level ambiguities yourself and only percolate up to them for the
really important ones so this is a balancing act it requires the development of
some good common sense as voltaire wrote common sense is not so common



---

