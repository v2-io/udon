---
source: nexum repo — ADR-002 (documents the autopax CLI; filed in nexum/docs/ADR/)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/_core/nexum/docs/ADR/002-command-line-interface.md
source_commit: c87c75ce20aeaad9290732e17be256601b45a338
categories: [safety-signaling, porcelain-plumbing, command-surface, exit-codes, output-formats, agent-cli-conventions]
why_included: >
  2025-11-12. The clearest statement of "safety-signaling through the command surface": a git-style
  three-tier model — PORCELAIN (safe, idempotent, guided, top-level) wraps PLUMBING (namespaced
  crypto.* / principia.*, unsafe, no validation) wraps pure lib, plus a DEV tier; namespacing itself
  *signals* danger, every command carries --format json|quiet, preconditions are checked before
  destructive ops, gas/cost is confirmed. Directly relevant to UDON's schema-guarded mutation tools
  (make the dangerous operation look dangerous) and to any harness deciding what an edit/observation
  tool must signal before it acts. NOTE: the doc's worked example is the *autopax* CLI even though the
  file lives under nexum/docs/ADR/ — the transferable content is the tiering/safety model, not the
  autopax-specific commands.
---
# ADR-002: Command-Line Interface (CLI)

**Status:** WORKING DECISION (evolutionary, will be refined)
**Date:** 2025-11-12
**Supersedes:** N/A
**Related:** ADR-001 (Cryptographic Architecture - more concrete/lasting decisions)

---

## ⚠️ Important Context

This ADR documents the **working structure** for the autopax CLI. Unlike ADR-001 (which contains concrete, long-lasting cryptographic decisions), this ADR:

- **Will evolve** as we understand user workflows better
- **Extrapolates into the future** (especially porcelain commands)
- **Is implemented piecemeal** - we add components as needed, not all at once
- **Contains draft examples** - actual porcelain will emerge from real usage

Consider this a **living document** that captures current thinking, not final design.

---

## Context

Autopax implements a complete cryptographic stack for entity identity and sovereignty (SIGNUM, DIDs, CHRONICA, grants). We need a CLI that:

1. Provides **safe, guided workflows** (porcelain) for common tasks
2. Exposes **low-level, powerful operations** (plumbing) for experts
3. Clearly signals **safety vs risk** (porcelain vs plumbing)
4. Allows **composition** (porcelain calls plumbing, plumbing calls lib)
5. Supports **incremental implementation** (build what's needed when needed)

**Framework:** toys-core (already in use for version command)

---

## Decision

### Three-Tier Command Structure

**PORCELAIN (top-level):**
- Safe, idempotent where possible
- High-level, good UX
- Interactive, guided workflows
- What users reach for by default

**PLUMBING (namespaced: crypto.*, principia.*, env.*):**
- Unsafe (can corrupt state if misused)
- Low-level, granular, powerful
- Assumes expert knowledge
- Namespaced to signal "be careful here"

**DEV (namespaced: dev.*):**
- Testing, debugging, development tooling
- Not for production use
- Safe to run in development environment
- Namespaced to signal "dev only"

### Namespace Organization

```
autopax
├── entity.*              # Porcelain (safe, guided entity lifecycle)
├── chat                  # Porcelain (existing conversation interface)
├── version               # Porcelain (existing version management)
│
├── crypto.*              # Plumbing (⚠️ unsafe crypto operations)
│   ├── crypto.did.*
│   ├── crypto.keys.*
│   └── crypto.util.*
│
├── principia.*           # Plumbing (⚠️ unsafe Principia operations)
│   ├── principia.signum.*
│   ├── principia.chronica.*
│   └── principia.grant.*
│
├── env.*                 # Plumbing (⚠️ unsafe environment operations)
│
└── dev.*                 # Dev/testing tooling (not production)
    ├── dev.test.*
    ├── dev.bench.*
    ├── dev.lint.*
    └── dev.fixtures.*
```

**Namespace Separator:** Publicized as `.` (dot), but toys accepts all three: `crypto.did`, `crypto did`, `crypto:did`

---

## Command Reference

### Porcelain Commands (Safe, Top-Level)

#### `autopax entity` - Entity Lifecycle Management

**NOTE:** These are **draft examples**. Actual porcelain will emerge from real usage patterns.

```bash
# Create new entity (safe, interactive, guided)
autopax entity create <name> [--classification ELI|HUM|PELI] [--network sepolia|mainnet]

# Show entity status (safe, read-only)
autopax entity inspect <entity_id>

# Bootstrap existing entity from SIGNUM (safe, idempotent)
autopax entity bootstrap <name> --from-signum <path>

# Integrate pre-existing entity from history (safe, guided import)
autopax entity integrate <name> --history <path> --emerged-at <date>

# Graduate proto entity to production (safe, validates state, confirms cost)
autopax entity graduate <name> --from-network sepolia --to-network mainnet

# Diagnose entity issues (safe, suggests fixes)
autopax entity doctor <entity_id>

# List all entities (safe, read-only)
autopax entity list
```

**Properties:**
- Check preconditions before acting
- Interactive prompts with defaults
- Validate state before destructive operations
- Show cost estimates before blockchain operations
- Idempotent where possible (re-running is safe)

**Example Interaction:**
```bash
$ autopax entity create ziamtur
→ Checking preconditions...
  ✓ No existing entity 'ziamtur' found
  ✓ Network 'sepolia' available (free gas via faucet)
→ Generate keys? [Y/n]
→ Classification: [ELI]
→ Emerged date: [2025-11-12]
→ Creating DID: did:ethr:11155111:0xZIAMTUR...
→ SIGNUM created: ~/eli/ziamtur/SIGNUM.md
→ Principia structure created: ~/eli/ziamtur/principia/
→ Git repo initialized
→ Ready! Next steps:
  - Edit SIGNUM: vim ~/eli/ziamtur/SIGNUM.md
  - Inspect status: autopax entity inspect ziamtur
  - Start chat: autopax chat --entity ziamtur
```

#### `autopax chat` - Conversation Interface (Existing)

```bash
# Start/resume conversation (default command)
autopax chat [--entity <entity_id>] [--resume <session>]
```

#### `autopax version` - Version Management (Existing)

```bash
# Show version
autopax version show

# Bump version
autopax version bump [--major|--minor|--patch]
```

---

### Plumbing Commands (⚠️ Unsafe, Namespaced)

**WARNING:** Plumbing commands assume expert knowledge. They can corrupt state, cost gas, or break things if misused. Prefer porcelain commands for safe workflows.

#### `autopax crypto.did` - DID Operations

```bash
# Create DID (⚠️ no validation)
autopax crypto.did create --network <sepolia|mainnet> [--trezor] [--output <path>]

# Resolve DID to DID Document (safe: read-only)
autopax crypto.did resolve <did>

# Register DID on ERC-1056 (⚠️ costs gas, no validation)
autopax crypto.did register --did <did> --network <network> --signum <path>

# Set DID attribute (⚠️ costs gas, modifies blockchain)
autopax crypto.did set-attribute --did <did> --key <key> --value <value> --validity <seconds>

# Revoke DID attribute (⚠️ costs gas)
autopax crypto.did revoke-attribute --did <did> --key <key>

# Graduate DID manually (⚠️ prefer `autopax entity graduate`)
autopax crypto.did graduate --entity <id> --from-network sepolia --to-network mainnet

# Show DID info (safe: read-only)
autopax crypto.did show <did>
```

#### `autopax crypto.keys` - Key Management

```bash
# Generate key (⚠️ overwrites if exists)
autopax crypto.keys generate --type <ML-DSA-87|secp256k1> --entity <id> [--output <path>]

# Rotate key (⚠️ can break if timed wrong)
autopax crypto.keys rotate --entity <id> --type <signing|did> [--overlap-days 14]

# Export key (safe: read-only)
autopax crypto.keys export --entity <id> --output <path>

# Import key (⚠️ overwrites)
autopax crypto.keys import --entity <id> --input <path>

# List keys (safe: read-only)
autopax crypto.keys list --entity <id>

# Show key info (safe: read-only)
autopax crypto.keys show --entity <id> --type <signing|did>

# Store passphrase in keychain (⚠️ writes to OS keychain)
autopax crypto.keys store-passphrase --entity <id>

# Get passphrase from keychain (safe: read-only)
autopax crypto.keys get-passphrase --entity <id>

# Delete passphrase from keychain (⚠️ removes from keychain)
autopax crypto.keys delete-passphrase --entity <id>
```

**Passphrase Resolution Order:**
1. Session cache (entered once per run, stored in memory)
2. Environment variable (`AUTOPAX_KEY_PASSPHRASE`)
3. OS keychain (if stored via `store-passphrase`)
4. Prompt user

#### `autopax crypto.util` - Crypto Utilities

```bash
# Test ML-DSA-87 implementation (safe: testing only)
autopax crypto.util test-ml-dsa [--iterations 100]

# Check entity readiness for Level 1 (safe: diagnostic)
autopax crypto.util readiness-check --entity <id>

# Show assurance level (safe: read-only)
autopax crypto.util assurance-level --entity <id>

# Set assurance level (⚠️ changes enforcement)
autopax crypto.util set-assurance-level --entity <id> --level <0|1>
```

#### `autopax principia.signum` - SIGNUM Operations

```bash
# Create new SIGNUM (⚠️ no validation)
autopax principia.signum new --classification <HUM|ELI|PELI|AI|AUX> --name <name> [--output <path>]

# Sign SIGNUM (⚠️ overwrites signature)
autopax principia.signum sign <path>

# Verify SIGNUM signature (safe: read-only)
autopax principia.signum verify <path>

# Schema versioning
autopax principia.signum schema bump-major   # 1.0.0 → 2.0.0
autopax principia.signum schema bump-minor   # 1.0.0 → 1.1.0
autopax principia.signum schema bump-patch   # 1.0.0 → 1.0.1
autopax principia.signum schema show         # Display current version
```

#### `autopax principia.chronica` - Event Log Operations

```bash
# Verify CHRONICA integrity (safe: read-only)
autopax principia.chronica verify --entity <id> [--verbose]

# Batch anchor multiple entities (⚠️ costs gas ~$4)
autopax principia.chronica anchor --entities <all|id1,id2> [--network mainnet]

# Show integrity status (safe: read-only)
autopax principia.chronica status --entity <id>

# Show anchor history (safe: read-only)
autopax principia.chronica anchors --entity <id>
```

#### `autopax principia.grant` - Authorization & Delegation

```bash
# Create grant (⚠️ grants permissions)
autopax principia.grant create \
  --issuer <did> \
  --subject <did> \
  --type <memory_access|capability|migration_attestation> \
  --resource <uri> \
  --permissions <read,write,execute> \
  --expires <date|never>

# Verify grant (safe: read-only)
autopax principia.grant verify --grant-file <path>

# Revoke grant (⚠️ deletes file)
autopax principia.grant revoke --grant-file <path>

# List grants (safe: read-only)
autopax principia.grant list --entity <id>

# Show grant details (safe: read-only)
autopax principia.grant show --grant-file <path>
```

#### `autopax env` - Environment & API Keys

**Default action:** If no subcommand, runs `env.show` (safe)

```bash
# Show loaded environment (safe: read-only, redacted)
autopax env
autopax env.show

# Load .env file (⚠️ side-effect: modifies ENV)
autopax env.load [--file <path>]

# Encrypt .env file (⚠️ overwrites .env.age)
autopax env.encrypt --input <.env> [--output <.env.age>]

# Decrypt .env file (⚠️ writes plaintext)
autopax env.decrypt --input <.env.age> [--output <.env>]

# Check required variables (safe: validation only)
autopax env.check --entity <id>
```

#### `autopax dev` - Development & Testing Tooling

**NOTE:** Development commands - not for production use.

```bash
# Run test suite
autopax dev.test [--pattern <pattern>] [--coverage]

# Run unit tests only
autopax dev.test-unit

# Run integration tests
autopax dev.test-integration

# Run crypto-specific tests
autopax dev.test-crypto

# Run end-to-end workflow tests
autopax dev.test-e2e

# Run benchmarks
autopax dev.bench [--iterations 1000]

# Benchmark ML-DSA-87 operations
autopax dev.bench-crypto

# Run linters
autopax dev.lint [--fix]

# Generate test coverage report
autopax dev.coverage [--format html]

# Generate test fixtures
autopax dev.fixtures-create [--type <entity|signum|chronica>]

# Validate test fixtures
autopax dev.fixtures-validate

# Debug utilities
autopax dev.debug-context <entity_id>    # Dump entity context
autopax dev.debug-did <did>              # Inspect DID resolution
autopax dev.debug-keys <entity_id>       # Show key locations/status

# CI/CD helpers
autopax dev.ci-setup                     # Set up CI environment
autopax dev.ci-teardown                  # Clean up CI artifacts
```

**Properties:**
- Not for production use
- May create/modify test fixtures
- May run expensive operations (benchmarks)
- Safe to run in development environment
- **⚠️ WARNING:** All `dev.*` commands check if run from autopax repository root
  - If pwd is not autopax repo, displays warning and prompts for confirmation
  - Prevents accidental execution in production directories

**Examples:**
```bash
# Run all tests with coverage (from autopax repo)
$ cd ~/src/autopax
$ autopax dev.test --coverage
→ Running unit tests... 45 passed
→ Running integration tests... 12 passed
→ Running crypto tests... 8 passed
→ Coverage: 87.3%
→ Report: coverage/index.html

# Generate entity test fixtures
$ autopax dev.fixtures-create --type entity
→ Created: spec/fixtures/joseph-hum.signum.md
→ Created: spec/fixtures/ziamtur-eli.signum.md
→ Created: spec/fixtures/test-alpha-peli.signum.md

# Attempt to run from wrong directory
$ cd ~/
$ autopax dev.test
⚠️  WARNING: Not in autopax repository
   Current directory: /Users/joseph
   Expected: /Users/joseph/src/autopax

   Dev commands should only run from autopax repo to avoid
   accidental modification of production files/fixtures.

   Continue anyway? [y/N] n
   Aborted.
```

---

## Configuration Hierarchy

Commands resolve configuration from (highest to lowest priority):

1. **CLI flags** - `--network mainnet`
2. **Environment variables** - `AUTOPAX_NETWORK=mainnet`
3. **Entity Principia** - `~/eli/<entity>/principia/config.yml`
4. **Global config** - `~/.autopax/config.yml`
5. **Hardcoded defaults**

---

## Output Formats

All commands support:
- **Human-readable** (default): Colors, tables, emojis (if TTY)
- **JSON** (`--format json`): Machine-parseable
- **Quiet** (`--quiet`): Success/failure only (exit codes)

Example:
```bash
# Human-readable
$ autopax crypto.did show did:ethr:1:0xABC...
DID: did:ethr:1:0xABC...
Network: mainnet (chain ID: 1)
Attributes:
  ✓ canonical_signum_location: https://logostasis.v2.io/...
  ✓ signing_key: ML-DSA-87 (registered 2025-11-12)

# JSON
$ autopax crypto.did show did:ethr:1:0xABC... --format json
{"did":"did:ethr:1:0xABC...","network":"mainnet","attributes":[...]}

# Quiet (for scripts)
$ autopax crypto.did show did:ethr:1:0xABC... --quiet && echo "Valid"
```

---

## Exit Codes

- **0** - Success
- **1** - General error
- **2** - Invalid arguments
- **3** - Verification failure (signature invalid, integrity check failed)
- **4** - Not found (DID not found, file not found)
- **5** - Permission denied (no capability grant, insufficient gas)
- **64** - Network error (RPC timeout, IPFS unreachable)

---

## Implementation Structure

### Directory Layout

```
bin/
  autopax                    # Main executable (toys-core)

.toys/
  entity.rb                  # Porcelain namespace
  crypto.rb                  # Plumbing namespace (crypto.*)
  principia.rb               # Plumbing namespace (principia.*)
  env.rb                     # Plumbing namespace (env.*)
  dev.rb                     # Development/testing namespace (dev.*)
  chat.rb                    # Existing chat command
  version.rb                 # Existing version command

lib/autopax/
  entity/                    # Porcelain implementations
    creator.rb               # Safe entity creation workflow
    inspector.rb             # Status/diagnostics
    bootstrapper.rb          # Safe bootstrap from existing
    graduator.rb             # Safe proto→mainnet
    integrator.rb            # Safe import existing entity

  crypto/                    # Crypto plumbing implementations
    did/
      creator.rb             # Low-level DID creation
      resolver.rb            # Blockchain resolution
      registrar.rb           # setAttribute/revoke
    keys/
      generator.rb           # Key generation
      rotator.rb             # Key rotation
      storage.rb             # age encryption
      keychain.rb            # OS keychain (macOS/Linux)
    util/
      ml_dsa.rb              # ML-DSA-87 FFI wrapper (roqs gem)
      readiness.rb           # Assurance level checks

  principia/                 # Principia plumbing implementations
    signum/
      parser.rb              # Parse SIGNUM frontmatter + markdown
      signer.rb              # ML-DSA-87 signing
      validator.rb           # Field validation
    chronica/
      verifier.rb            # Hash chain + signature verification
      anchor.rb              # Merkle tree anchoring
    grant/
      creator.rb             # Generate .grant files
      verifier.rb            # Verify signatures + TTL + delegation

  env/                       # Environment plumbing implementations
    loader.rb                # Load .env files (with age decryption)
    encryptor.rb             # Encrypt/decrypt .env with age
    validator.rb             # Check required environment variables
```

### Architecture Pattern

**Porcelain (safe) calls Lib (implementation):**
```ruby
# .toys/entity.rb
tool "entity" do
  tool "create" do
    def run
      # Porcelain wraps lib with safety checks
      creator = Autopax::Entity::Creator.new
      creator.create_interactive(name: name)
    end
  end
end
```

**Plumbing (unsafe) wraps Lib (thin wrapper):**
```ruby
# .toys/crypto.rb
tool "crypto" do
  tool "did" do
    tool "create" do
      def run
        # Thin wrapper - no safety checks
        creator = Autopax::Crypto::DID::Creator.new
        did = creator.create(network: network)
        puts did
      end
    end
  end
end
```

**Lib (pure implementation):**
```ruby
# lib/autopax/crypto/did/creator.rb
module Autopax
  module Crypto
    module DID
      class Creator
        def create(network:, trezor: false)
          # Pure implementation, no CLI concerns
          # Returns DID string
        end
      end
    end
  end
end
```

---

## Phased Implementation

**IMPORTANT:** We do **not** implement all of this at once. We build incrementally as needed.

### Week 1 (Foundation)
- Stub all plumbing commands in toys
- Implement lib/autopax/crypto/util/ml_dsa.rb (roqs wrapper)
- Implement lib/autopax/crypto/keys/generator.rb (ML-DSA-87 generation)
- Implement lib/autopax/env/loader.rb (.env loading)
- Working command: `autopax crypto.util test-ml-dsa`

### Week 2 (Identity)
- Implement lib/autopax/crypto/did/creator.rb (secp256k1 generation)
- Implement lib/autopax/principia/signum/parser.rb (SIGNUM parsing)
- Implement lib/autopax/principia/signum/signer.rb (ML-DSA-87 signing)
- Working commands: `autopax crypto.did create`, `autopax principia.signum sign`

### Week 3 (Registration)
- Implement lib/autopax/crypto/did/resolver.rb (ERC-1056 resolution)
- Implement lib/autopax/crypto/did/registrar.rb (setAttribute)
- Working command: `autopax crypto.did register`

### Week 4 (First Porcelain)
- Implement lib/autopax/entity/creator.rb (safe entity creation)
- Working command: `autopax entity create` (first porcelain!)
- This composes multiple plumbing operations safely

### Future Weeks
- Add porcelain as workflows become clear from real usage
- Refine safety checks based on user mistakes
- Add more plumbing as needed for porcelain

---

## Rationale

**Why three-tier (porcelain/plumbing/dev):**
- Porcelain: What users reach for (safe, can't break things)
- Plumbing: Escape hatch for experts (powerful but dangerous)
- Dev: Testing/debugging tooling (not production, but not dangerous)
- Clear signal: Namespaced = "be careful" or "dev only"

**Why namespace with dots:**
- Reads like module structure: `crypto.did.create`
- Familiar from other CLIs (docker, kubectl)
- Toys accepts all three formats (`.`, ` `, `:`) for flexibility

**Why lib/autopax separation:**
- Lib is pure logic (testable, reusable)
- Toys is thin wrapper (CLI concerns only)
- Allows future reuse (logostasis can use lib directly)

**Why incremental implementation:**
- Don't know final porcelain shape until real usage
- Build what's needed when needed
- Avoid over-engineering early

**Why working decision:**
- Porcelain will evolve as we learn user workflows
- Safety boundaries will shift based on real mistakes
- Command names/structure may change

---

## Notes

- Porcelain commands check preconditions, validate state, confirm destructive ops
- Plumbing commands assume expert knowledge, no validation
- All blockchain operations show gas estimates before execution
- Trezor support for steward keys only (not entity keys)
- Network config determines Assurance Level (sepolia=0, mainnet=1 after readiness)
- Secrets metadata lives in Principia (`~/eli/<entity>/principia/secrets.yml`), not SIGNUM
- SIGNUM = identity (who), Principia = operational config (how)
- **Dev commands safety:** All `dev.*` commands check for autopax repo markers:
  - Presence of `.git/` directory
  - Presence of `lib/autopax/` directory
  - Presence of `.toys/` directory
  - If not found, warn and prompt for confirmation

---

## Open Questions (To Be Resolved Through Usage)

1. What other porcelain workflows are needed?
2. Where should safety boundaries be? (Some operations might move between porcelain/plumbing)
3. Should `env` have a safe default action? (`autopax env` → `autopax env.show`)
4. What diagnostics are most useful in `entity doctor`?
5. How much interactivity in porcelain? (Always prompt vs flags with prompts for missing)

These will be answered as we build and use the system.

---

**Document Status:** Working decision - expect evolution
**Next Action:** Implement Week 1 foundation (ML-DSA-87, .env loading), then iterate based on real needs
