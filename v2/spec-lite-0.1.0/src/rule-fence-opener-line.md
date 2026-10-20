---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: true
layer: tree
per: []
depends: [rule:fence-opens-with-backticks, rule:line-scan, rule:leftover-values]
consequences: [rule:fence-default-handler, rule:fence-exact-trait, rule:fence-line-comments, rule:fence-label-no-backtick]
---

# A fence's opening line reads like an element's line

*After the opening backticks, the rest of the line is read as an element's line: a name, keys, traits, attributes, leftover values as `$main`, and a framed comment, all belonging to the fence. The body starts on the next line.*

## Statement

After a fence's opening backticks, the rest of the line MUST be read as an element's line is read: an optional name, keys, traits, attributes, leftover values as the fence's `$main`, and a framed comment, all belonging to the fence. The fence's body MUST begin on the next line.

## Grounds

- Joseph, 2026-10-12: "on sameline, fence opener is like any other element and can have its own ID which is great for referencing it! and, although they can't span to the next line etc., any kinds of attributes..."
- Joseph, 2026-10-12: "Leftover text would also be part of $main on the specialized fenced node that is related to `element` now in this reading."

## Epistemic status

Joseph's proposal (2026-10-12), which the coordinator agreed with. What the fence's attributes, traits and `$main` mean is up to its handler ([[rule:fence-default-handler]]).

## Explanation

````udon
|element :attr true ```sh[example-7] :hidden false   ; a note
                      echo "seems ok."
                    ```
````
```tree
root
  |element
    :attr true
    ```sh
      :$key ‹example-7›
      :hidden false
      ; " a note"
      "echo \"seems ok.\"\n"
```
*(Tree notation provisional. `:hidden false` is an error under the default handler ([[rule:fence-default-handler]]); a handler for `sh` may accept it.)*

## Working notes

- **Joseph's words** (2026-10-12, `.int/STEWARD-VERBATIM.md`):

  > |element :attr true ```sh[example-7] :hidden false   ; oh look, on sameline, fence opener is like any other element and can have its own ID which is great for referencing it! and, although they can't span to the next line etc., any kinds of attributes...
  >                       echo "seems ok."
  >                     ```

  > Leftover text would also be part of $main on the specialized fenced node that is related to `element` now in this reading. I think we can make a note in the spec that the per-language handlers will have to figure out what they accept etc. for additional attributes including $main. We'll implement a standard handler that just cares about .exact and does the dedenting (or not) as expected, that other language handlers can extend. (or something like that-- basically for now the handling depends on the language specifics other than we apply a default handler for .exact)...
  > w/ #2 though-- you're right. The thing we have to enforce from the udon side is the fact that as soon as we get a newline-- we are capturing everything and handing it off except until we get the fence-closer. While it might make sense to cram a tiny element on the opening line to someone-- I think we can essentially error in our default handler for anything other than a (desugared) :$key(s), :$traits ⊆ {exact}, and a comment. This gives you actually the error you wanted for extra text as well, but post lexical.
  >
  > — Joseph, 2026-10-12 (`.int/STEWARD-VERBATIM.md`)

- **Consequences, not rules of their own:** the word after the backticks is the fence's name, so it is a «label» and is one word (the "word or line" question in [[def:fence-tag]] is answered). The `-` verbatim flag is gone: `-` is a name character, so ```` ```diff- ```` would be a fence named `diff-`; the trait `exact` replaces it ([[rule:fence-exact-trait]]). A nameless fence is spelled like a nameless element (```` ```[k] ````, ```` ```.exact ````).
- **Where the fence lands on a line:** by the element rules, as a child after a finished value, as the value of an attribute still waiting for one (Joseph, 2026-10-12: "I think child is the right call"; [[rule:fence-anywhere-structure]]).
- Joseph calls `sh` the fence's language (2026-10-12: "'sh' | fence language | label"), and the fence "a specialized element node".
- **Open:** whether a fence is an «element» of a special kind ("the specialized fenced node that is related to `element`"), and how the tree prints it.
- An element written later on the opening line (```` ```sh |x ````) parses, and the default handler rejects it.
- **Joseph's thought on the fence's tree (2026-10-20, a question, not a ruling):** "I don't know what the AST for a fence already looks like-- presumably it is element-like but with a different node-type and with children consisting of an optional comment, a body raw text with meta, and an optional closing comment. Thoughts?" That would also settle where a closer's comment goes, and would correct [[rule:fence-line-comments]], whose example still draws both comments as children of the enclosing element.
