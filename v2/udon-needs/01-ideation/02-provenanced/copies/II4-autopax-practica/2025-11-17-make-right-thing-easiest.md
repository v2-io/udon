---
source: 2025-11-17-make-right-thing-easiest.md (autopax/practica ideology corpus, Part II sec 4)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/autopax/docs/exp/2025-11-17-make-right-thing-easiest.md
source_commit: 033af13c5ca686ca5898645f6dc772e4435c0523
categories: [ease-gradient, cli-ergonomics, naming, friction-as-signal]
why_included: >
  Nov 17 2025. The ease-gradient applied concretely: naming gradients (delete_all!), complexity gradients, "make context-preservation easiest," friction-events as design signal, single-command-does-everything-right workflows. The practical/CLI-facing version of THE-PATTERN -- directly usable as harness-side and utils-side demand.
---

# Make the Right Thing the Easiest Thing
*Initial thoughts on compressed note #5*

## Core Principle
"Make the right thing the easiest thing"

This is a fundamental design principle that shapes everything from API design to development workflows. It's about creating systems where the path of least resistance is also the correct path.

## The Physics of Development

Developers (human and AI) are like water - they follow the path of least resistance. Instead of fighting this nature, we design the landscape so the easiest path leads where we want.

### Traditional Approach
"Here are the rules, please follow them" → Requires discipline, fails under pressure

### Easiest Path Approach
"The obvious way is the right way" → Natural compliance, works under pressure

## Examples in Practice

### API Design
```ruby
# Hard to use wrong (the right thing is easiest)
class User
  def self.create_with_confirmation(email:, name:)
    user = create!(email: email, name: name)
    user.send_confirmation_email
    user
  end
end

# vs. Easy to use wrong (requires remembering steps)
user = User.create(email: email, name: name)
# Oops, forgot: user.send_confirmation_email
```

### File Organization
```
# Make the right location obvious
autopax/
├── lib/autopax/
│   ├── cli/           # CLI stuff goes here (obvious)
│   ├── principia/     # PRINCIPIA stuff goes here (obvious)
│   └── crypto/        # Crypto stuff goes here (obvious)

# vs. Ambiguous organization
autopax/
├── lib/
│   ├── utils/         # Wait, does CLI go here?
│   ├── helpers/       # Or here?
│   └── core/          # Or here?
```

### Error Handling
```ruby
# Make error handling unavoidable
def process_file(path)
  File.read(path)
rescue Errno::ENOENT => e
  raise Autopax::FileNotFound, "Cannot process #{path}: #{e.message}"
end

# vs. Easy to forget error handling
def process_file(path)
  File.read(path)  # Crashes with cryptic error
end
```

## Workflow Design

### Making Good Commits Easiest
```bash
# The easy command does everything right
$ toys dev commit "Add user authentication"
# Automatically:
# - Runs tests
# - Formats code
# - Updates CHANGELOG
# - Creates semantic commit
# - Updates LOG.md

# vs. Manual process (easy to skip steps)
$ git add .
$ git commit -m "stuff"  # Forgot tests, formatting, etc.
```

### Making Documentation Easiest
```ruby
# Documentation is part of the code
def calculate_interest(principal:, rate:, years:)
  # Interest = Principal × Rate × Time
  # Example: calculate_interest(principal: 1000, rate: 0.05, years: 2) => 100
  principal * rate * years
end

# vs. Separate documentation (easy to drift)
# See docs/api/calculate_interest.md  # <- Never updated
```

## Testing Patterns

### Make Testing Natural
```ruby
# Test file location mirrors source
lib/autopax/user.rb           # Source
spec/autopax/user_spec.rb     # Test (obvious location)

# Test naming mirrors method naming
def calculate_total            # Method
describe '#calculate_total'    # Test (obvious what it tests)
```

### Make Test Data Easy
```ruby
# Fixtures make tests easy to write
let(:valid_user) { create(:user) }  # Easy, works
let(:invalid_user) { create(:user, :invalid) }  # Easy, clear

# vs. Manual setup (error-prone)
let(:user) do
  User.new(
    email: "test@example.com",
    name: "Test",
    # ... 20 more fields
  )
end
```

## Security by Default

### Make Secure Choices Easiest
```ruby
# Secure by default
class APIClient
  def initialize(api_key = ENV['API_KEY'])
    @api_key = api_key || raise("API_KEY required")
    @conn = Faraday.new(ssl: { verify: true })  # SSL verification on
  end
end

# vs. Insecure is easier (bad!)
class APIClient
  def initialize(api_key = nil, ssl_verify = false)
    @api_key = api_key  # Might be nil
    @conn = Faraday.new(ssl: { verify: ssl_verify })  # Often false
  end
end
```

## Agent-Specific Applications

### Make Context Preservation Easiest
```ruby
# Session management built-in
$ toys dev session start
# Automatically loads previous context
# Shows what was done last session
# Suggests next steps

$ toys dev session end
# Automatically saves context
# Commits work
# Updates logs
```

### Make Correct Patterns Obvious
```ruby
# Pattern templates
$ toys dev new command user_create
# Generates:
# - lib/autopax/commands/user_create.rb (with correct structure)
# - spec/autopax/commands/user_create_spec.rb (with test template)
# - Updates CLI registry automatically
```

## The Gradient Principle

Create gradients that guide toward correctness:

### Naming Gradients
```ruby
# Dangerous operations are obviously dangerous
def delete_all_users!  # The ! screams danger
def unsafe_direct_sql(query)  # "unsafe" is clear

# Safe operations are obviously safe
def find_user(id)  # Clearly just reading
def validate_email(email)  # No side effects
```

### Complexity Gradients
```ruby
# Simple case is simple
User.create(email: "test@example.com")  # Works for 80% of cases

# Complex case is possible but clearly complex
User.create_with_options(
  email: "test@example.com",
  skip_confirmation: true,
  admin: true,
  org_id: 5
)
```

## Environmental Design

### Directory Structure Guides Behavior
```
docs/
├── ADR/                    # Decisions go here (not elsewhere)
│   └── template.md        # Template makes format obvious
├── guides/                # Guides go here
└── exp/                   # Experiments go here
    └── README.md          # "These are exploratory, not final"
```

### Tool Commands Guide Workflow
```bash
$ toys dev
Available commands:
  start-feature    # Start new feature (right way)
  test            # Run tests (no excuses)
  ship            # Ship feature (does everything)
```

## Anti-Patterns

### The Punishment Path
Making the right thing harder than the wrong thing:
- Complex security that gets bypassed
- Elaborate processes that get skipped
- Perfect being enemy of good

### False Simplicity
Making the wrong thing look easy:
- Skipping error handling "for simplicity"
- Global variables "for convenience"
- Missing abstractions "to keep it simple"

### The Maze
Multiple equally easy paths with different correctness:
- Inconsistent patterns
- Multiple ways to do same thing
- No clear conventions

## For Autopax

### Immediate Applications
1. **Command structure** - One obvious place for each command type
2. **Error handling** - Built into base classes
3. **Testing** - Test file generation with commands
4. **Documentation** - Inline with code, not separate
5. **Workflows** - Single commands that do everything right

### Design Questions
Before adding any feature, ask:
1. What's the easiest way someone might use this?
2. Is that way correct?
3. If not, how do we make the correct way easier?
4. What could make the wrong way harder?

### Measurement
Track "friction events":
- When agents do something wrong
- When processes get skipped
- When documentation isn't updated

Each friction event suggests a design improvement opportunity.

The ultimate goal: A system where doing things right requires less effort than doing things wrong.