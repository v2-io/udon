---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: true
layer: tree
per: []
depends: [rule:fence-opener-line, rule:fence-body-not-scanned]
consequences: [rule:fence-exact-trait, rule:fence-body-dedent]
---

# The default fence handler accepts keys, the trait `exact` and comments

*What a fence's opening line may carry, beyond keys and comments, is up to the handler for the fence's language. The default handler accepts only keys, the trait `exact` and a comment, and does the body's dedenting.*

## Statement

A fence's attributes, traits and `$main` MUST be interpreted by the handler for its name. The default handler MUST accept only keys (`$key`), the trait `exact`, and a comment, and MUST report anything else on the opening line as an error. It MUST dedent the body ([[rule:fence-body-dedent]]) unless the fence has the trait `exact` ([[rule:fence-exact-trait]]).

## Grounds

- Joseph, 2026-10-12: "the per-language handlers will have to figure out what they accept etc. for additional attributes including $main. We'll implement a standard handler that just cares about .exact and does the dedenting (or not) as expected, that other language handlers can extend."
- Joseph, 2026-10-12: "I think we can essentially error in our default handler for anything other than a (desugared) :$key(s), :$traits ⊆ {exact}, and a comment. This gives you actually the error you wanted for extra text as well, but post lexical."

## Epistemic status

Joseph's direction (2026-10-12, "or something like that"). What lite's spec says about handlers beyond this is open.

## Explanation

````udon
|a ```sh[build] .exact ; ok under the default handler
make
```
|b ```sh :hidden false
make
```
|c ```rust ignore
fn main() {}
```
````
`a` is accepted. Under the default handler, `b` (an attribute) and `c` (the `$main` text `ignore`) are errors. A handler for `sh` or `rust` may accept them.

## Working notes

- **Joseph's words** (2026-10-12, `.int/STEWARD-VERBATIM.md`):

  > Leftover text would also be part of $main on the specialized fenced node that is related to `element` now in this reading. I think we can make a note in the spec that the per-language handlers will have to figure out what they accept etc. for additional attributes including $main. We'll implement a standard handler that just cares about .exact and does the dedenting (or not) as expected, that other language handlers can extend. (or something like that-- basically for now the handling depends on the language specifics other than we apply a default handler for .exact)...
  > w/ #2 though-- you're right. The thing we have to enforce from the udon side is the fact that as soon as we get a newline-- we are capturing everything and handing it off except until we get the fence-closer. While it might make sense to cram a tiny element on the opening line to someone-- I think we can essentially error in our default handler for anything other than a (desugared) :$key(s), :$traits ⊆ {exact}, and a comment. This gives you actually the error you wanted for extra text as well, but post lexical.
  >
  > — Joseph, 2026-10-12 (`.int/STEWARD-VERBATIM.md`)

- The lexical rule underneath, from the same message: "as soon as we get a newline-- we are capturing everything and handing it off except until we get the fence-closer" ([[rule:fence-body-not-scanned]]). The opening line parses; the handler rejects what it doesn't take ("post lexical").
- **Open:** what a handler is in lite's spec: who supplies one, how a parser picks it by the fence's name, and whether a handler's error stops parsing like any lite error ([[decision:errors-stop-parsing]]). Joseph's spec note: "the per-language handlers will have to figure out what they accept".
- Dedenting now lives in the default handler: [[rule:fence-body-dedent]], [[rule:fence-body-shallower-line]] and [[rule:fence-dedent-in-meta]] describe what it does.
