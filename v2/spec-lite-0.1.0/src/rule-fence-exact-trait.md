---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: [rule:fence-opener-line, rule:fence-default-handler, rule:fence-body-dedent]
consequences: []
test-fixtures: []
---

# A fence with the trait `exact` keeps its body's whitespace

*`.exact` on a fence replaces the `-` flag: nothing is stripped from the body, and no shallower-line warning is given.*

## Statement

The body of a fence whose traits include `exact` MUST keep every byte: no indentation is stripped, and a line shallower than the first gives no warning.

````udon
|element :attr true ```sh.exact
                            # super indented!
echo "comment was indented."
                    ```
````
```tree
root
  |element
    :attr true
    :$main ```sh
      :$traits exact
      "                            # super indented!\necho \"comment was indented.\"\n"
```
A bare ```` ```.exact ```` is an exact fence with no name.

## Grounds

- Joseph, 2026-10-12: "This time all of the whitespace will be retained / no warning on further dedent from first line... Replaces the trailing '-' flag which isn't anywhere else in udon..."
- The default handler is what gives `exact` its meaning ([[rule:fence-default-handler]]).

## Epistemic status

Joseph's proposal (2026-10-12), which the coordinator agreed with. No fixtures yet.

## Working notes

- **Joseph's words** (2026-10-12, `.int/STEWARD-VERBATIM.md`):

  > |element :attr true ```sh.exact  ; <- This time all of the whitespace will be retained / no warning on further dedent from first line... Replaces the trailing '-' flag which isn't anywhere else in udon...

- Replaces the `-` flag of 2026-10-08 ("'-' suffix for verbatim"; "bare ```- should be very obviously a fenced block preserved verbatim", 2026-10-09). The `-` had to go anyway once the fence's word is a name: `-` is a name character, so ```` ```diff- ```` would be a fence named `diff-`.
- `exact` is the only trait lite gives a meaning to, and only on a fence, through the default handler. On any other element it is an ordinary trait.
- A body whose first line must sit deeper than later ones (a patch, a code fragment) is the case it exists for.
