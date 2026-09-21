# Feature Requests

### 2026-08-30

#### "Tiny Parser"

Basically, with 0.10.01, a set of tiny, dependency free "simplified udon" parsers written in the host languages:
  - Python
  - Rust
  - Ruby
  - (etc.)

Basically it would be regex or very simple recursive descent on fragment with a
very simplified AST built. It would need to warn when there are constructs
(like references or directives or unknown data types etc.) that it encounters
that it won't parse.

The actual subset that they all (or each independently) will "parse" is up for
debate, as long as the result is small enough that it's convenient to just pop
in place for simple udon usage for now, dependency free, (e.g., for udon used
as a simple predictable data layout / xml equivalent / yaml-or-json
alternative), and aware of what it (or each one) can't do.


