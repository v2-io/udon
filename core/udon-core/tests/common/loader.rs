//! Fixture loading from YAML files
//!
//! TODO: Once UDON parser is solid, convert fixtures to UDON format (dogfooding)

use serde::Deserialize;

use std::path::{Path, PathBuf};

/// The active compliance-fixture group directory name under `core/fixtures/`.
///
/// This is the single knob that selects which version-scoped group the harness
/// runs. Bump it when the spec advances and a new group directory is created.
pub const ACTIVE_GROUP: &str = "v0.9";

/// A single test case from a fixture file
#[derive(Debug, Clone, Deserialize)]
pub struct TestCase {
    pub id: String,
    pub desc: String,
    pub udon: String,
    pub events: Vec<ExpectedEvent>,
    /// If true, skip element-wrapping mutations (test requires document root semantics)
    #[serde(default)]
    pub root_only: bool,
}

/// Expected event - either a bare name or [name, content]
#[derive(Debug, Clone, Deserialize)]
#[serde(untagged)]
pub enum ExpectedEvent {
    /// Bracket event with no content (ElementStart, ElementEnd, etc.)
    Bare(String),
    /// Content event [EventName, "content"]
    WithContent(String, String),
}

impl ExpectedEvent {
    pub fn name(&self) -> &str {
        match self {
            ExpectedEvent::Bare(name) => name,
            ExpectedEvent::WithContent(name, _) => name,
        }
    }

    pub fn content(&self) -> Option<&str> {
        match self {
            ExpectedEvent::Bare(_) => None,
            ExpectedEvent::WithContent(_, content) => Some(content),
        }
    }
}

/// Load all test cases from a YAML fixture file
pub fn load_fixtures(path: &Path) -> Vec<TestCase> {
    let content = std::fs::read_to_string(path)
        .unwrap_or_else(|e| panic!("Failed to read fixture file {:?}: {}", path, e));
    serde_yaml::from_str(&content)
        .unwrap_or_else(|e| panic!("Failed to parse fixture file {:?}: {}", path, e))
}

/// Root of the version-scoped fixture corpus: `core/fixtures/`.
///
/// Fixtures were lifted out of `udon-core/tests/` (2026-07-14) so the corpus
/// is a first-level concern. `CARGO_MANIFEST_DIR` is `core/udon-core`, so its
/// parent is `core/`.
pub fn fixtures_root() -> PathBuf {
    Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .expect("udon-core crate has a parent directory (core/)")
        .join("fixtures")
}

/// Directory of the active compliance-fixture group (`core/fixtures/v0.8/`).
pub fn active_group_dir() -> PathBuf {
    fixtures_root().join(ACTIVE_GROUP)
}

/// Names (file stems) of every `*.yaml` fixture in the active group, sorted.
///
/// Discovery is dynamic so cases added during the rebuild are picked up without
/// touching the harness.
pub fn active_fixture_names() -> Vec<String> {
    let dir = active_group_dir();
    let mut names: Vec<String> = std::fs::read_dir(&dir)
        .unwrap_or_else(|e| panic!("Failed to read fixture group {:?}: {}", dir, e))
        .filter_map(|entry| {
            let path = entry.ok()?.path();
            if path.extension()?.to_str()? == "yaml" {
                path.file_stem()?.to_str().map(str::to_string)
            } else {
                None
            }
        })
        .collect();
    names.sort();
    names
}

/// Load fixtures by name from the active compliance-fixture group.
pub fn load_fixtures_by_name(name: &str) -> Vec<TestCase> {
    let path = active_group_dir().join(format!("{}.yaml", name));
    load_fixtures(&path)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_load_active_group() {
        let names = active_fixture_names();
        assert!(!names.is_empty(), "active fixture group is empty");
        let cases = load_fixtures_by_name(&names[0]);
        assert!(!cases.is_empty());
    }
}
