---
source: 2025-11-17-intent-surfacing.md (autopax/practica ideology corpus, Part II sec 4)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/autopax/docs/exp/2025-11-17-intent-surfacing.md
source_commit: 033af13c5ca686ca5898645f6dc772e4435c0523
categories: [intent, structure-carries-intent, persistence, agent-handoff]
why_included: >
  Nov 17 2025. Intent as the "why" that is most valuable and most easily lost; three-level intent hierarchy (immediate/design/strategic); making intent visible, persistent, traceable, shareable across sessions and agents. The demand behind UDON's case that structure should carry intent -- and behind any harness memory/context system.
---

# Intent Surfacing, Documenting, Tracing, Auditing, and Sharing
*Initial thoughts on compressed note #9*

## Core Principle
"Intent surfacing / documenting / tracing / auditing / sharing"

Intent is the "why" behind code - the most valuable and most easily lost information. This is about making intent visible, persistent, traceable, and shareable across sessions and agents.

## The Intent Hierarchy

### Level 1: Immediate Intent
What this code is trying to do right now
```ruby
# Intent: Validate user can access resource
def can_access?(user, resource)
  user.admin? || resource.owner == user
end
```

### Level 2: Design Intent
Why it's structured this way
```ruby
# Design Intent: Using strategy pattern because access rules
# will likely get more complex (teams, roles, time-based access)
class AccessStrategy
  def self.for(user, resource)
    case resource
    when Document then DocumentAccessStrategy.new
    when Project  then ProjectAccessStrategy.new
    else DefaultAccessStrategy.new
    end
  end
end
```

### Level 3: Strategic Intent
How this fits into larger goals
```ruby
# Strategic Intent: Building toward multi-tenant architecture
# This isolation layer will make tenant separation easier
module TenantIsolation
  # Future: This will handle data isolation per tenant
  # Current: Single tenant, but structured for expansion
  def with_tenant(tenant = current_tenant)
    Thread.current[:tenant] = tenant
    yield
  ensure
    Thread.current[:tenant] = nil
  end
end
```

## Intent Surfacing Patterns

### In-Code Intent Documentation
```ruby
class RateLimiter
  # INTENT: Prevent abuse while allowing burst traffic
  # STRATEGY: Token bucket algorithm (not sliding window) because:
  #   1. Allows burst traffic for legitimate users
  #   2. Simple to implement and understand
  #   3. Memory efficient (just 2 numbers per user)
  # TRADE-OFF: Less precise than sliding window
  # FUTURE: Consider Redis-based distributed rate limiting

  def allow?(user, tokens = 1)
    bucket = get_bucket(user)
    bucket.refill!

    if bucket.tokens >= tokens
      bucket.consume!(tokens)
      true
    else
      # INTENT: Return false without exception
      # so callers can handle gracefully
      false
    end
  end
end
```

### Commit Message Intent
```
feat: Add rate limiting to API endpoints

INTENT: Protect against abuse while maintaining good UX
APPROACH: Token bucket at controller level
REASONING:
- Controller level catches all endpoints consistently
- Token bucket allows burst traffic (better UX)
- Per-user buckets (not IP) to avoid proxy issues

REJECTED ALTERNATIVES:
- Nginx rate limiting: Too blunt, can't consider user tiers
- Sliding window: More complex, minimal benefit for our use case
- Queue-based throttling: Adds latency for legitimate users

FUTURE CONSIDERATION:
When we add paid tiers, will need tier-based limits
```

### Architecture Decision Intent
```markdown
# ADR-007: Use Event Sourcing for Audit Trail

## Intent
Provide complete audit trail for compliance while maintaining performance

## Context Intent
- Regulatory requirement for full audit trail (SOC2)
- Current approach (callbacks) is fragile and incomplete
- Need to support "as-of" queries for investigations

## Decision Intent
Use event sourcing pattern for critical entities

## Implementation Intent
- Start with high-risk entities (Payment, User, AccessGrant)
- Events are immutable and append-only
- Separate read models for performance
- Events contain intent metadata

## Example Event with Intent
{
  "event_type": "UserPasswordChanged",
  "intent": "user_requested",  // vs "admin_reset" vs "security_forced"
  "reason": "Regular password rotation",
  "initiated_by": "user_123",
  "ip_address": "192.168.1.1",
  "timestamp": "2024-11-17T10:00:00Z"
}
```

## Intent Tracing

### Request-Level Intent
```ruby
class ApplicationController
  before_action :capture_request_intent

  def capture_request_intent
    Thread.current[:request_intent] = {
      feature: request.headers['X-Feature-Flag'],
      purpose: request.headers['X-Purpose'],  # "analytics", "user_action", "sync"
      initiator: current_user&.id || 'anonymous',
      correlation_id: request.uuid
    }
  end
end
```

### Intent Propagation
```ruby
class Order
  def process!
    # Intent propagates through the call chain
    with_intent("process_order", reason: "user_checkout") do
      validate_items!      # Inherits intent context
      calculate_total!     # Inherits intent context
      charge_payment!      # Inherits intent context
      send_confirmation!   # Inherits intent context
    end
  end

  private

  def with_intent(action, metadata = {})
    prior_intent = Thread.current[:intent]
    Thread.current[:intent] = {
      action: action,
      **metadata,
      parent: prior_intent
    }
    yield
  ensure
    Thread.current[:intent] = prior_intent
  end
end
```

## Intent Auditing

### Audit Log with Intent
```ruby
class AuditLog
  def self.record(action, target, intent: nil)
    create!(
      action: action,
      target_type: target.class.name,
      target_id: target.id,
      intent: intent || Thread.current[:intent],
      user: current_user,
      session_id: current_session_id,
      ip_address: current_ip,
      user_agent: current_user_agent,
      timestamp: Time.current,

      # Intent-specific metadata
      feature_flag: Thread.current[:request_intent]&.dig(:feature),
      purpose: Thread.current[:request_intent]&.dig(:purpose),
      correlation_id: Thread.current[:request_intent]&.dig(:correlation_id)
    )
  end
end
```

### Intent Query Patterns
```ruby
# Find all actions with specific intent
AuditLog.where("intent->>'purpose' = ?", 'user_requested')

# Trace intent chain
def trace_intent_chain(correlation_id)
  logs = AuditLog.where("intent->>'correlation_id' = ?", correlation_id)
                 .order(:timestamp)

  logs.map do |log|
    {
      action: log.action,
      intent: log.intent,
      timestamp: log.timestamp,
      duration_ms: log.duration_ms
    }
  end
end
```

## Intent Sharing

### Between Sessions
```markdown
## Session 41 Intent Summary

### What I Was Trying to Achieve
- Implement secure password reset flow
- Prevent timing attacks on token validation
- Ensure tokens are single-use

### Why I Made These Choices
- Used constant-time comparison to prevent timing attacks
- Added token expiry to limit exposure window
- Stored hashed tokens (not plain) in database

### What I Didn't Finish (Intent for Next Session)
- Rate limiting on reset requests (prevent bombardment)
- Email notification of password changes
- Audit logging of security events
```

### Between Agents
```ruby
# Intent markers for agent handoff
class PaymentProcessor
  # INTENT-HANDOFF: Next agent should:
  # 1. Add retry logic for network failures (not business failures!)
  # 2. Consider implementing circuit breaker for payment gateway
  # 3. Add metrics for payment success/failure rates

  # INTENT-CONTEXT: Current implementation assumes:
  # - Single payment gateway (Stripe)
  # - USD currency only
  # - Synchronous processing

  # INTENT-CAUTION: Don't auto-retry failed payments!
  # Double-charging is worse than missing a payment
end
```

### Between Human and Agent
```markdown
## Feature Request Intent

User Story: "As a user, I want to export my data"

### Real Intent (from discussion):
- PRIMARY: GDPR compliance (legal requirement)
- SECONDARY: User trust/transparency
- NOT: Users actually analyzing their data

### Implementation Guidance:
- Focus on completeness over format
- Include ALL user data (even internal IDs)
- Machine-readable format (JSON) is fine
- Don't spend time on pretty formatting
```

## Intent Preservation Patterns

### The Intent Comment Block
```ruby
# === INTENT ===
# PURPOSE: Prevent duplicate processing in distributed system
# APPROACH: Idempotency keys with 24-hour TTL
# ASSUMPTION: Clients will retry with same key
# RISK: Key collision if not UUID (acceptable, <0.001% chance)
# === END INTENT ===
```

### The Intent Test
```ruby
describe PaymentProcessor do
  # TEST INTENT: Verify double-charge prevention
  # This is our most critical business rule
  it "prevents double charging even with retries" do
    # Setup: Same idempotency key
    key = SecureRandom.uuid

    # First charge succeeds
    result1 = processor.charge(amount: 100, key: key)
    expect(result1).to be_success

    # Second charge returns same result (no new charge)
    result2 = processor.charge(amount: 100, key: key)
    expect(result2).to eq(result1)

    # Verify only one actual charge
    expect(payment_gateway.charges.count).to eq(1)
  end
end
```

## Anti-Patterns

### Intent Hiding
```ruby
# Bad: What is this magic number?
if user.score > 74
  activate_premium
end

# Good: Intent visible
PREMIUM_THRESHOLD = 74  # Marketing determined this converts best
if user.score > PREMIUM_THRESHOLD
  activate_premium
end
```

### Intent Drift
Original intent gets lost over modifications:
```ruby
# Original intent: Prevent brute force
def check_password(attempts)
  attempts < 3  # Still here but why 3? Original reason lost
end
```

### False Intent
```ruby
# Comment says one thing, code does another
# Intent: Validate email format
def validate_email(email)
  # Actually does more than just format validation!
  check_format(email) && !blacklisted?(email) && not_duplicate?(email)
end
```

## For Autopax

### Intent Infrastructure
```ruby
# Built into base classes
class ApplicationRecord
  def with_intent(intent, &block)
    IntentTracer.trace(intent, self, &block)
  end
end

# Automatic intent capture
class IntentTracer
  def self.trace(intent, context)
    prior = Thread.current[:intent_stack] ||= []
    prior.push({ intent: intent, context: context, timestamp: Time.current })

    yield
  ensure
    prior.pop
  end
end
```

### Intent in Tools
```bash
# Commit with intent
toys dev commit --intent "refactor for performance" \
                --reasoning "N+1 queries causing timeout" \
                --measurement "200ms -> 50ms response time"

# Generate intent report
toys dev intent-report --session 42
```

The goal: Make intent so visible and persistent that future developers (human or AI) understand not just what the code does, but why it exists, why it's structured this way, and what was intended to happen next.