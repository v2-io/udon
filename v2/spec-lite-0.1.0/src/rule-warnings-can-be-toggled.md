---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: anomaly
per: [errors-stop-parsing]
depends: [def:anomaly]
consequences: [rule:no-break-space-counts-as-space]
---

# Each warning is on or off by default, and can be toggled

*Every «warning» lite defines is either default-on or default-off, and a parser lets its user turn each one on or off.*

## Statement

1. Each «warning» lite defines MUST be marked in its card as default-on or default-off.
2. A parser MUST report default-on warnings and MUST NOT report default-off warnings unless its user asks; it MUST let its user turn each warning on or off.

## Grounds

- Joseph, 2026-10-20: "let's distinguish between default-on and default-off warnings and specify that the parser should allow them to be toggled. This would be a default-off (our first, AFAIK)", of the no-break-space warning ([[rule:no-break-space-counts-as-space]]).

## Epistemic status

His direction, stated directly. Every warning carded before 2026-10-20 is default-on unless its card says otherwise; [[rule:no-break-space-counts-as-space]] is the first default-off one.

## Working notes

- How a parser exposes the toggles (flags, an options object, one switch per warning code) is `awaiting-implementers` ([[decision:leans-are-working-spec]]). Warning codes are still placeholders until [[view:anomalies]] names them.
- Whether toggling can also turn a warning into an error (as compilers' `-Werror` does) was not discussed.
- Not decided: whether the «tree» carries default-off warnings at all, or only reports them when they are on.
