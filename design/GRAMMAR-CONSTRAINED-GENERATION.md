# Grammar-Constrained LLM Generation

*How to go from a PEG grammar to guaranteed-valid LLM output*

---

## The Problem

LLMs generate text token by token. Each token is sampled from a probability distribution. The model *usually* produces valid syntax, but not *always*:

```
Prompt: "Write a JSON object with name and age"

Output: {"name": "Alice", "age": 30}     ← usually fine
Output: {"name": "Alice", age: 30}       ← oops, missing quotes
Output: {"name": "Alice",                ← stopped mid-output
```

For structured formats (JSON, YAML, UDON, SQL, etc.), we want guarantees, not probabilities.

---

## The Solution: Constrained Decoding

Instead of letting the LLM sample any token, we *mask* invalid tokens at each step:

```
Step 1: LLM wants to generate after "{"
        Valid tokens: "name", "age", "}", whitespace, ...
        Invalid tokens: numbers, ], ), most keywords, ...
        → Mask invalid tokens to probability 0
        → Sample only from valid tokens

Step 2: LLM generates "name"
        Valid next tokens: :, whitespace
        Invalid: everything else
        → Mask and sample

... and so on
```

The grammar parser runs alongside generation, determining what's valid at each step.

---

## How It Works: The Token Masking Loop

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────────────┐  │
│  │   Grammar   │    │    Mask     │    │     LLM Decoder     │  │
│  │   Parser    │───>│  Generator  │───>│                     │  │
│  │             │    │             │    │  logits × mask      │  │
│  └─────────────┘    └─────────────┘    │  = valid_logits     │  │
│         ▲                              │                     │  │
│         │                              │  sample(valid)      │  │
│         │                              │  = next_token       │  │
│         │                              └──────────┬──────────┘  │
│         │                                         │             │
│         └─────────────────────────────────────────┘             │
│                    feed token back to parser                    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Each generation step:**

1. **Parser state** → What tokens are grammatically valid here?
2. **Generate mask** → Vector of 1s (valid) and 0s (invalid) over vocabulary
3. **Apply mask** → Multiply LLM's logits by mask (invalid → -infinity)
4. **Sample** → Pick token from masked distribution
5. **Update parser** → Feed chosen token to grammar parser
6. **Repeat** → Until end-of-sequence or grammar complete

---

## From PEG to Token Mask

### Step 1: Define the Grammar (PEG)

PEG (Parsing Expression Grammar) for a simple JSON subset:

```peg
json    <- object / array
object  <- '{' pair (',' pair)* '}' / '{' '}'
pair    <- string ':' value
array   <- '[' value (',' value)* ']' / '[' ']'
value   <- string / number / 'true' / 'false' / 'null' / object / array
string  <- '"' (!'"' .)* '"'
number  <- '-'? [0-9]+ ('.' [0-9]+)?
```

### Step 2: Build a Parser That Tracks State

The parser needs to answer: "Given what's been generated so far, what can come next?"

```python
class GrammarParser:
    def __init__(self, grammar):
        self.grammar = grammar
        self.state = initial_state(grammar)

    def feed(self, token: str):
        """Update state with new token"""
        self.state = advance(self.state, token)

    def valid_next(self) -> set[str]:
        """What strings could validly come next?"""
        return compute_valid_continuations(self.state)

    def is_complete(self) -> bool:
        """Has the grammar been fully satisfied?"""
        return self.state.is_accepting
```

### Step 3: Map Grammar Symbols to Tokens

Here's the tricky part. The grammar talks about characters/strings, but LLMs generate tokens (subwords).

**Token vocabulary might include:**
- `{"` (single token)
- `{` (single token)
- `"name"` (single token)
- `"` (single token)
- `name` (single token)
- `":` (single token)
- ... thousands more

**The mask generator must:**
1. For each token in vocabulary, check if it's a valid continuation
2. A token is valid if its characters are a prefix of (or complete) some valid grammar continuation

```python
def generate_mask(parser_state, vocabulary) -> list[float]:
    valid_continuations = parser_state.valid_next()  # Set of valid strings
    mask = []

    for token in vocabulary:
        token_str = token.decode()
        if any(valid.startswith(token_str) or token_str.startswith(valid)
               for valid in valid_continuations):
            mask.append(1.0)
        else:
            mask.append(0.0)

    return mask
```

### Step 4: Integrate with LLM Decoding

```python
def constrained_generate(prompt, grammar, max_tokens=1000):
    parser = GrammarParser(grammar)
    tokens = tokenize(prompt)

    for _ in range(max_tokens):
        # Get LLM's probability distribution
        logits = llm.forward(tokens)

        # Generate grammar mask
        mask = generate_mask(parser, llm.vocabulary)

        # Apply mask (invalid tokens → -infinity)
        masked_logits = logits + torch.log(torch.tensor(mask))

        # Sample from masked distribution
        next_token = sample(masked_logits)

        # Update state
        tokens.append(next_token)
        parser.feed(decode(next_token))

        if parser.is_complete() or next_token == EOS:
            break

    return decode(tokens)
```

---

## The Hard Parts

### 1. Token Boundary Mismatch

Grammar: expects `"name"`
Tokenizer: might split as `"`, `name`, `"` or `"name"` as one token

The mask generator must handle partial matches:
- `"na` is valid if `"name"` is valid (it's a prefix)
- `"name` is valid if `"name"` is valid (still a prefix)
- `"namex` is invalid (no valid continuation starts with this)

### 2. Performance

Checking every token (~50k vocabulary) against every valid continuation is expensive.

**Optimizations:**
- Precompute token → grammar symbol mappings
- Use trie structures for prefix matching
- Cache mask for common parser states
- Incremental mask updates (only recompute what changed)

### 3. Ambiguous Tokenization

Input string `{"name"}` could tokenize as:
- `{` `"name"` `}`
- `{"` `name` `"}`
- `{` `"` `name` `"` `}`

Different tokenizations lead to different mask sequences. The grammar parser must handle all possible tokenization paths, or the tokenizer must be deterministic.

### 4. Grammar Expressiveness

Not all constraints are expressible in PEG:
- "The closing tag must match the opening tag" (XML)
- "This number must be ≤ 100"
- "This ID must reference something defined earlier"

These require context-sensitive grammars or post-hoc validation.

---

## Existing Tools

### Outlines (Python, HuggingFace)

```python
from outlines import models, generate

model = models.transformers("mistral-7b")
generator = generate.json(model, schema)

result = generator("Generate a user profile")
# Always valid JSON matching schema
```

- Works with HuggingFace models
- Supports JSON Schema, regex, CFG
- Production-ready
- https://github.com/outlines-dev/outlines

### LMQL (Python, Query Language)

```python
@lmql.query
def generate_json():
    '''
    "Generate JSON: [JSON]" where JSON matches r'\{.*\}'
    '''
```

- Query language for constrained generation
- Supports regex and type constraints
- https://lmql.ai/

### Guidance (Python, Microsoft)

```python
from guidance import models, gen

llm = models.LlamaCpp(model_path)

program = llm + "JSON: " + gen(name="json", regex=r'\{.*\}')
```

- Template-based constrained generation
- Supports regex and grammar constraints
- https://github.com/guidance-ai/guidance

### llama.cpp (C++, GGML Format)

```bash
# Define grammar in GBNF format
./main -m model.gguf --grammar-file json.gbnf -p "Generate JSON:"
```

GBNF (GGML BNF) grammar:
```gbnf
root   ::= object
object ::= "{" pair ("," pair)* "}"
pair   ::= string ":" value
...
```

- Native grammar support in llama.cpp
- Very fast (C++ implementation)
- Works with GGUF models locally
- https://github.com/ggerganov/llama.cpp/tree/master/grammars

### XGrammar (Efficient Grammar Engine)

- Optimized grammar-constrained decoding engine
- Designed for high-throughput serving
- Used by vLLM and other inference engines
- https://github.com/mlc-ai/xgrammar

---

## For UDON Specifically

### Step 1: Write UDON Grammar

```peg
document    <- (element / prose / comment / blank_line)*
element     <- '|' name id? classes* attributes* content? children?
name        <- [a-zA-Z_] [a-zA-Z0-9_-]*
id          <- '[' [^\]]+ ']'
classes     <- '.' [a-zA-Z_] [a-zA-Z0-9_-]*
attributes  <- ':' attr_name ws+ attr_value
attr_value  <- quoted_string / number / boolean / bare_word / list
inline_el   <- '|{' name attributes* content? '}'
...
```

### Step 2: Convert to Tool Format

**For Outlines** (uses lark grammar or regex):
```python
from outlines import generate
from lark import Lark

udon_grammar = Lark('''
    start: (element | prose | COMMENT | NEWLINE)*
    element: "|" NAME id? class* attribute* content?
    ...
''')

generator = generate.cfg(model, udon_grammar)
```

**For llama.cpp** (uses GBNF):
```gbnf
root      ::= (element | prose | comment | ws)*
element   ::= "|" name id? classes* attrs* content? nl children?
name      ::= [a-zA-Z_] [a-zA-Z0-9_-]*
id        ::= "[" [^\]]+ "]"
...
```

### Step 3: Generate Constrained UDON

```python
prompt = """Generate a UDON document describing an API endpoint for user creation.
Include method, path, authentication requirements, and response codes."""

result = generator(prompt)
# Guaranteed valid UDON syntax
```

---

## Tradeoffs

| Aspect | Unconstrained | Grammar-Constrained |
|--------|---------------|---------------------|
| Validity | ~95% valid | 100% valid |
| Speed | Faster | Slower (mask computation) |
| Flexibility | Model can improvise | Locked to grammar |
| Integration | Any API | Needs decoder access |
| Hosting | Any provider | Self-hosted or specialized |

**When to use constrained generation:**
- Structured output is critical (code, config, data interchange)
- Downstream systems need parseable input
- You're self-hosting or using a compatible provider

**When unconstrained is fine:**
- Prose generation
- Flexible formats (natural language with some structure)
- Provider doesn't support constraints (OpenAI, Anthropic APIs)

---

## The Partial Tree Access Connection

With grammar-constrained generation, "partial tree access" is real:

```
Generating: |article[foo]
              :status dr█

Grammar parser state:
{
  stack: [document, element(article), attribute(status)],
  current_rule: attr_value,
  valid_next: ["aft", "published", "archived", ...],  # completions
  partial_value: "dr"
}
```

The parser *is* tracking the tree as it forms. You can query it:
- What element are we inside?
- What attributes are complete?
- What values are valid here?

This enables:
- Progress reporting ("3 elements complete, 1 in progress")
- Early termination ("enough content, stop here")
- Semantic validation ("`:status` must be one of [draft, published, archived]")
- Streaming with structure ("emit complete elements as they close")

---

## Summary

1. **Define grammar** (PEG, CFG, GBNF, regex)
2. **Build parser** that tracks valid continuations
3. **Generate token mask** at each step
4. **Integrate with decoder** (mask logits before sampling)
5. **Feed tokens back** to parser to update state

The result: LLM generates tokens, but only grammatically valid ones. The partial parse tree is always available. Output is guaranteed to match the grammar.

For UDON, this means an LLM could generate arbitrary UDON documents with guaranteed validity — no post-hoc parsing errors, no malformed syntax.

---

## Resources

- [Outlines documentation](https://outlines-dev.github.io/outlines/)
- [llama.cpp GBNF grammars](https://github.com/ggerganov/llama.cpp/blob/master/grammars/README.md)
- [Guidance library](https://github.com/guidance-ai/guidance)
- [LMQL language](https://lmql.ai/docs/)
- [XGrammar paper](https://arxiv.org/abs/2411.15100)
- ["Efficient Guided Generation for LLMs"](https://arxiv.org/abs/2307.09702) (Outlines paper)
