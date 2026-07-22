---
source: zoetica PRAXES.md — project practice doc (~Oct 2025)
gathered: 2026-07-21
status: gathered (verbatim whole-file copy)
paths:
  - /Users/josephwecker-v2/src/_core/zoetica/PRAXES.md
source_commit: 6ac3961
categories: [practices, prefactor-first-TST, repo-as-training-ground, append-only-event-log, small-linkable-chunks]
why_included: >
  Practice-in-force: prefactor-first workflow (a TST application), treating the repo as training-ground for
  specialized agents (stable names/dirs so retrieval finds patterns), append-only event log + projections (never
  mutate past conversations), and structuring guidance into "small, linkable chunks so multi-stage retrieval
  (keyword -> embedding -> graph) can compose context." The small-linkable-chunks demand is UDON self-chunking
  stated operationally; the append-only-log demand recurs across the live UDON consumers (Part I §5).
---

# Project PRAXES

This document outlines the core practices, procedures, and models for development within the Zoetica project.

- Use context7 for code generation, setup or configuration steps, or library/API documentation. This means you should automatically use the Context7 MCP tools to resolve library id and get library docs without having to be explicitly asked.

- Use praxes.praxes_query before writing any code, setup or configuration steps, library/API documentation, documentation generally, or architectural recommendations. This means you should automatically use the praxes MCP tool and then READ IN at least the first 3 result entries that are not in your working context already.

- A core discipline of this project is the **Prefactor-First Workflow**. A "prefactor" is a structural, behavior-neutral change performed *before* implementing features. This practice is a direct application of Temporal Software Theory (TST), as it delivers necessary abstractions and generalizations when they are needed, rather than prematurely. It also provides a principled reason and place for unit tests, which are used to verify that no behavior has changed after the structural modifications.

- The following practices are derived from the principles of code analysis and context engineering detailed in [[refs/analyzing-codebases-for-specialized-agents]]:
    - Treat the repository as training ground for specialized agents: keep module names, directories, and docs consistent so retrieval systems find stable patterns.
    - Record intent and context in journals, tribunal notes, and commits—cite Praxes, owners, and instruments touched so future agents have socio-technical breadcrumbs.
    - Maintain an append-only event log for sessions and use projections for runtime, API payloads, and dialog exports; never mutate past conversations.
    - Structure Praxes and AGENTS guidance in small, linkable chunks so multi-stage retrieval (keyword ➜ embedding ➜ graph expansion) can compose relevant context efficiently.

---

## Key Foundational Praxes

The following PRAXES from the shared `eli` repository are particularly relevant to the Zoetica project's methodology.

**Notation:** PRAXES references use the format ⧼praxis-name⧽ or ⧼praxis-uuid⧽, which refer to files in `~/eli/_shared/PRAXES/[praxis-name].md`. These are living practices maintained across ELI projects.

- **On Observability & Production Readiness (TST T-12):**

    This section outlines the exact logging, telemetry, and health check patterns to be followed in the Zoetica project. Adherence to these practices is mandatory to ensure system transparency and minimize production debugging time, which decreases exponentially with system observability (`t_debug ∝ e^-kτ`).

    #### The Three Pillars of Observability

    | Concern | Tool | Use Case | Output |
    |---|---|---|---|
    | **Events** (what happened) | `Logger` | Errors, state changes, audit trail | Text/JSON logs |
    | **Metrics** (how much/fast) | `:telemetry` | Performance, throughput, latency | Time-series data |
    | **Traces** (request flow) | `OpenTelemetry` | Distributed correlation | Spans/traces |

    #### Praxis: Structured & Correlated Logging

    All log entries must be structured with queryable metadata. Raw string interpolation is an anti-pattern.

    - **DO**: `Logger.info("Message processed", turn_id: id, duration_ms: 2340)`
    - **DON'T**: `Logger.info("Turn #{id} processed in 2340ms")`

    Two correlation IDs are mandatory for tracing causality:

    1.  **`interaction_id`**: Born in the `Console` on user input. Traces the entire causal chain of a single user action across all apps.
    2.  **`turn_id`**: Born in `Anima.Entity` at the start of a processing cycle. Groups all work for a single cognitive turn.

    Every log entry must include, at a minimum:
    - `interaction_id`
    - `turn_id`
    - `entity_id`
    - `component` (e.g., `:anima`, `:principia`)
    - Per-app tee logging writes to `~/.zoetica/logs/<app>.log` via `Zoetica.Logging.ensure_handler/2` while the umbrella default handler maintains `~/.zoetica/logs/zoetica.log` parity.
    - Phoenix/LiveView (`Zoetica.Web`) exposes the LiveDashboard at `/dev/dashboard` for dev-only metrics backed by `Zoetica.Web.Telemetry.metrics/0`.

    #### Praxis: The "Let It Crash" Logging Model

    In an OTP system, exceptions in supervised processes should not be manually rescued simply to be logged. The framework provides superior, automatic error logging.

    **The Correct Pattern:**
    1.  Code encounters a bug or impossible state.
    2.  The process is allowed to crash. **Do not rescue the exception.**
    3.  The `Logger` application automatically intercepts the crash and writes a detailed `ERROR` report with the exception and full stack trace.
    4.  The supervisor restarts the process in a clean state.

    **The Anti-Pattern (DO NOT USE):**
    ```elixir
    try do
      risky_operation()
    rescue
      e ->
        Logger.error("Operation failed: #{inspect(e)}") # Redundant!
        reraise e, __STACKTRACE__
    end
    ```
    Manual `Logger.error` calls are reserved for critical, non-crashing system faults (e.g., a circuit breaker opening).

    #### Praxis: Lifecycle & Boundary Logging

    Log every significant state transition and the entry/exit of major operational boundaries. This creates a clear narrative of the system's execution.

    ```elixir
    def handle_cast({:process_message, message, metadata}, state) do
      # Set correlation IDs for all subsequent logs in this turn
      Logger.metadata(interaction_id: metadata.interaction_id, turn_id: UUID.uuid4())

      # Log the boundary crossing and state transition
      Logger.info("Entity turn started", phase: :operational, from_state: state.phase, to_state: :processing)
      
      # ... do work ...

      Logger.info("Entity turn complete", duration_ms: 1234)
      {:noreply, %{state | phase: :idle}}
    end
    ```

    #### Praxis: Health Checks for Orchestration

    To operate reliably in production, the system must expose two distinct health check endpoints:

    -   **Liveness (`/live`):** Answers "Is the process running?" Should be fast and **never** check external dependencies. A failure tells the orchestrator to restart the container.
    -   **Readiness (`/ready`):** Answers "Is the application ready for traffic?" **Should** check critical dependencies. A failure tells the load balancer to stop sending requests, but does not trigger a restart.

- **On Refactoring & Investment (TST T-06):**
    - ⧼forensic-refactoring-prioritization⧽
    - ⧼refactoring-gardening⧽
    - ⧼change-cost-assessment⧽

- **On Change-Set Size & Proximity (TST T-08, T-09):**
    - ⧼cohesion-proximity-measurement-framework⧽
    - ⧼code-proximity-analysis⧽

- **On Code Evolution & Maintenance (TST T-04):**
    - ⧼code-aging-three-generations⧽
    - ⧼maintenance-first-development⧽

- **On Architectural Decisions & Coupling (TST T-10, T-11):**
    - ⧼tst-subsystem-prioritization⧽
    - ⧼temporal-coupling-abstraction-detection⧽

---

## Tactical Shortcuts & Crypto Decisions (Family Reunion)

- **2025-10-14 – PQ Signatures PoC:** Integrating ML-DSA-65 (CRYSTALS-Dilithium 3) through `liboqs` + Rustler bindings so Principia can verify messages. Use `assurance_level: 0` only during the short validation window while PQ tests run; flip to `assurance_level: 1` with enforced verification for Family Reunion. If the spike blocks the schedule, fall back to Ed25519 + hash-chain while logging the deviation and the plan to re-sign later.
- **Test discipline:** Follow the ML-DSA test expectations (NIST KATs, property checks, Elixir integration smoke tests, latency benchmarks) described in `docs/identity-sovereignty.md` so shortcuts remain auditable.
- **2025-10-14 – PQ Hardening Pass:** Added zeroization of secret-key buffers in the Rust NIF, documented residual side-channel TODOs, and captured initial timing benchmarks. Further work (blinding, TEEs, memory locking) remains logged in `apps/zoetica_pq/README.md`.
- **2025-10-14 – ZoeticaPQ integration:** Promoted the ML-DSA implementation into `apps/zoetica_pq`; Principia should depend on this package instead of the archived `experiments/ml_dsa_poc` prototype.
- **2025-10-14 – ElixirTUI integration decision:** Keep `~/src/elixir-tui` as a separate repository. Consume it from Zoetica via local git dependency first, then tag releases once the API stabilizes (future Hex publish optional).
