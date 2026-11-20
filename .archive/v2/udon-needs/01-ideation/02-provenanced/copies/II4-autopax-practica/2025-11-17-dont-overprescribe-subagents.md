---
source: 2025-11-17-dont-overprescribe-subagents.md (autopax/practica ideology corpus, Part II sec 4)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/autopax/docs/exp/2025-11-17-dont-overprescribe-subagents.md
source_commit: 033af13c5ca686ca5898645f6dc772e4435c0523
categories: [delegation, agent-to-agent, brief-ergonomics]
why_included: >
  Nov 17 2025. The delegation-discipline principle in origin form: subagents can guess guidelines as easily as the caller; the only valuable thing to add is the unique context already in your window. Same doctrine as udon's own AGENTIC-DELEGATION.md -- a cross-context re-derivation of agent-to-agent brief ergonomics, and a direct witness of what a delegation/handoff tool must carry.
---

# Don't Over-Prescribe to Subagents
*Initial thoughts on compressed note #10*

## Core Principle
"Don't keep forgetting how bad agents are at over-prescribing things to sub-agents. They do not understand unless told that the subagents can guess at guidelines just as easily (exactly as easily) as the calling agent and that the only valuable thing the invoking agent has to add is the stuff already in its context that might be relevant."

This addresses a critical failure pattern in agent orchestration: the calling agent trying to micromanage the subagent instead of sharing context and letting the subagent use its own capabilities.

## The Over-Prescription Problem

### What Over-Prescription Looks Like
```markdown
TO SUBAGENT:
"Please implement user authentication following these exact steps:
1. Create a file called auth_controller.rb
2. In line 1, add 'class AuthController < ApplicationController'
3. In line 2, add two spaces then 'def login'
4. In line 3, add four spaces then 'user = User.find_by(email: params[:email])'
5. In line 4, add four spaces then 'if user && user.authenticate(params[:password])'
6. Check that you used exactly 2 spaces for indentation
7. Make sure to use single quotes not double quotes
8. ..."
[continues for 200 more lines]
```

### Why This Fails
1. **Subagent has same capabilities** - It knows Ruby syntax just as well
2. **Wastes context** - All that prescription uses up valuable context
3. **Brittle** - One wrong assumption cascades
4. **Slower** - Subagent could have solved it faster alone
5. **No learning** - Subagent can't apply its own patterns

## The Right Approach: Context Sharing

### Share Context, Not Instructions
```markdown
TO SUBAGENT:
"Implement user authentication for our system.

CONTEXT FROM THIS SESSION:
- We're using JWT tokens (not sessions) - decided in ADR-003
- User model already exists with bcrypt password_digest
- Rate limiting is handled at nginx level (don't implement)
- We follow RESTful conventions (POST /login, DELETE /logout)
- Error messages should not reveal whether email exists (security)
- See existing PatternController for our controller conventions

SUCCESS LOOKS LIKE:
- Users can log in with email/password
- Receive JWT token on success
- Token includes user_id and expires in 24 hours
- Failed logins return generic error message
```

## The Context vs Prescription Framework

### What to Share (Context)
```markdown
GOOD - Share context:
- Decisions already made
- Constraints that exist
- Patterns already established
- Problems already discovered
- Files already modified
- Conventions being followed
```

### What Not to Prescribe
```markdown
BAD - Don't prescribe:
- Syntax details
- File structure (unless unconventional)
- Variable names (unless domainspecific)
- Implementation order
- Testing approach (unless special requirements)
- Code style (should be consistent with existing)
```

## Real Examples

### Example 1: Code Refactoring
```markdown
❌ OVER-PRESCRIBED:
"Refactor the UserService class by:
1. First, create a new file called user_service_v2.rb
2. Copy the initialize method exactly
3. Change the process method name to process_user
4. Add a parameter called options = {}
5. Inside the method, first check if options[:async]
6. If true, call UserJob.perform_later
7. If false, call the original process logic
[... 50 more detailed steps]"

✅ CONTEXT-SHARED:
"Refactor UserService to support async processing.

CONTEXT:
- UserService currently processes synchronously
- We have Sidekiq set up with UserJob for async
- Existing API calls expect synchronous by default
- New webhook endpoints need async option
- See OrderService for similar pattern we like
```

### Example 2: Bug Fix
```markdown
❌ OVER-PRESCRIBED:
"Fix the N+1 query bug by:
1. Open app/models/post.rb
2. Go to line 23
3. Add 'includes(:comments)' after Post.where
4. Make sure it's includes not include
5. The full line should be Post.where(user: user).includes(:comments)
[... detailed formatting instructions]"

✅ CONTEXT-SHARED:
"Fix N+1 query issue in Post#user_posts method.

CONTEXT:
- Method loads posts with comments for display
- NewRelic shows 100+ queries per request
- We're hitting this endpoint 1000x/minute
- Comments are always needed when posts are loaded here
```

### Example 3: Feature Implementation
```markdown
❌ OVER-PRESCRIBED:
[200 lines of step-by-step instructions for adding export feature]

✅ CONTEXT-SHARED:
"Add data export feature for GDPR compliance.

CONTEXT FROM INVESTIGATION:
- Legal requires ALL user data be exportable
- Format can be JSON (no need for pretty PDF)
- Must complete within 30 days (async is fine)
- Similar pattern in AdminExporter (but that's CSV)
- User.personal_data scope already defines what's personal
- Export should be downloadable via signed URL (not email)

CONSTRAINTS:
- Don't expose internal IDs that could reveal other users
- Must include related data (posts, comments, etc.)
- Should handle soft-deleted records too
```

## The Information Theory Perspective

### Context Window Economics
```
Total Context = 100K tokens

❌ Over-prescribed approach:
- 60K tokens: Detailed instructions
- 20K tokens: Subagent's code reading
- 20K tokens: Implementation
Result: Cramped, possibly truncated

✅ Context-sharing approach:
- 5K tokens: Relevant context
- 20K tokens: Subagent's code reading
- 75K tokens: Implementation space
Result: Room for complex implementation
```

### Information Density
```markdown
❌ Low density:
"Create a variable called user_email and set it equal to
the email parameter from the request parameters hash"
[30 tokens for trivial information]

✅ High density:
"Email must be case-insensitive (downcase before comparing)"
[10 tokens for crucial business logic]
```

## Patterns for Effective Delegation

### The Context Sandwich
```markdown
TO SUBAGENT: [Clear goal]

CONTEXT FROM THIS SESSION:
[Relevant discoveries, decisions, constraints]

SUCCESS CRITERIA:
[What done looks like, not how to get there]
```

### The Discovery Handoff
```markdown
TO SUBAGENT: Implement the payment webhook handler

WHAT I'VE DISCOVERED:
- Stripe sends webhooks for payment.success and payment.failed
- We need to verify webhook signatures (security)
- Webhooks can arrive out of order (important!)
- Same webhook might be sent multiple times (idempotency needed)
- Our Payment model has a stripe_webhook_id field for dedup

WHAT I HAVEN'T EXPLORED:
- Exact signature verification method (check Stripe docs)
- How to handle async processing (your call)
- Error handling strategy (follow our patterns)
```

### The Pattern Reference
```markdown
TO SUBAGENT: Add audit logging to sensitive operations

SEE THESE PATTERNS:
- UserController#destroy - example of audit logging
- AuditLog model - where to write
- config/audit.yml - which operations to log

YOUR DECISIONS:
- Which other operations need auditing
- What metadata to capture
- How to handle bulk operations
```

## Trust Patterns

### Trust the Subagent's Capabilities
```ruby
# Calling agent shouldn't specify this level:
"Use a begin/rescue block with StandardError"

# Subagent knows error handling
```

### Trust the Subagent's Judgment
```ruby
# Don't prescribe:
"Put helper methods at the bottom of the file in private section"

# Subagent can organize code sensibly
```

### Trust the Subagent's Problem-Solving
```ruby
# Don't prescribe the algorithm:
"Loop through each user and check if active"

# Let subagent choose the approach:
"Remove inactive users from the results"
```

## Anti-Patterns to Avoid

### The Puppet Master
Trying to control every move the subagent makes

### The Essay Writer
Writing more instructions than the code would be

### The Syntax Teacher
Explaining language features the subagent already knows

### The Micromanager
Specifying trivial implementation details

### The Fortune Teller
Trying to predict and prescribe for every edge case

## When Prescription IS Appropriate

### Non-Obvious Requirements
```markdown
"IMPORTANT: Use constant-time comparison for passwords (timing attack prevention)"
```

### Domain-Specific Knowledge
```markdown
"Our customer IDs follow pattern CUS-YYYY-NNNNNN (year and sequence)"
```

### Hard-Won Lessons
```markdown
"Don't use Product.all.each - we have 10M products. Use find_in_batches"
```

### Specific Compatibility Needs
```markdown
"Must work with Ruby 2.7 (our production version, not latest)"
```

## For Autopax

### Subagent Invocation Template
```ruby
def invoke_subagent(task, context = {})
  prompt = build_prompt(
    goal: task,
    context: relevant_context,
    success_criteria: expected_outcome
  )

  # NOT: step_by_step_instructions

  Subagent.perform(prompt)
end
```

### Context Extraction Pattern
```ruby
def extract_relevant_context
  {
    decisions_made: current_session.decisions,
    patterns_discovered: current_session.patterns,
    constraints_found: current_session.constraints,
    files_modified: current_session.changed_files,
    # NOT: how_to_write_ruby_code
  }
end
```

### Trust Metrics
Track when over-prescription happens:
- Instruction length vs task complexity
- Subagent success rate vs prescription level
- Context waste (instructional vs informational)

The key insight: **Subagents are as capable as calling agents at the mechanics of coding.** The calling agent's unique value is the context it has accumulated, not its ability to write detailed instructions. Share context generously, prescribe sparingly.