//! Test infrastructure for UDON parser
//!
//! Provides fixture loading, stochastic test generation, and assertion helpers.

mod loader;
mod harness;
mod generators;

// Re-exports are consumed unevenly across the several integration-test crates
// that share this module (canonical / boundaries / spans), so some are unused
// per-crate — that is expected, not dead code.
#[allow(unused_imports)]
pub use loader::{TestCase, ExpectedEvent, load_fixtures, load_fixtures_by_name, active_fixture_names, active_group_dir, fixtures_root, ACTIVE_GROUP};
pub use harness::{run_test, run_with_variations};
pub use generators::Gen;
