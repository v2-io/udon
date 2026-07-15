# Changelog — UDON core spec (`CORE.md`)

All notable changes to the **UDON core specification** are recorded here. This
versions the *contract*, not the code: implementations declare which spec version
they pass (see `../CLAUDE.md` → Tracking & Workflow). Each released version has a
frozen **compliance-fixture group**; an implementation is "compliant with vX.Y.Z"
iff it passes that group.

Format: [Keep a Changelog]. Versioning: [Semantic Versioning] (pre-1.0, so minor
bumps may break).

## [Unreleased]

## [0.8.0-rc.1] — 2026-07-14

First release candidate of the **rebooted** spec (descent-rewrite era). The spec
is ratified and frozen for review; **no implementation is compliant yet** — the
descent grammar and generated parser are still on the pre-reboot model, so the
compliance gate is RED *by construction* until they catch up. `0.8.0` is
finalized once a parser passes the 0.8.0 compliance-fixture group.

> *Draft — verify this change list against `CORE.md` and git history before the
> version is frozen.*

### Changed (from 0.7-draft)
- **Escaping unified** to one positional rule: a `\` at head position forces the
  line to prose (consumed; anchors indent); in prose flow a `\` before an inline
  opener `|{` / `!{` / `;{` makes it literal; anywhere else `\` is literal.
  Retires the old `'`-escape and the per-context `\;` mechanism.
- **Identity model**: `[key]` desugars to `$key`, `.trait` to `$traits` (with an
  always-a-list `traits` view); `id`/`class` retired as wire-names.
- **Explicit typing `<…>`**: every non-core (dialect) type — *including all
  temporal* — requires the envelope; a bare `2026-07-11` is now the string. The
  envelope is `<>`-balanced for nesting.
- **Numbers**: bare recognition frozen to **integer + float** only (four bases,
  incl. explicit-decimal `0d`); **rational and complex marked provisional**
  (candidates for a standard-types dialect).
- **References `@` are inert** at the core level; the `:[id]` attribute-merge
  syntax **removed** (merge is now a host resolution mode).
- Freeform fences open at **any** head position; **attribute stacking** is the
  uniform rule; bare-name char class fixed to Unicode `XID_Start` /
  `XID_Continue` + `-`.

### Notes
- The spec is *ahead of the parser*; the pre-reboot 0.7-draft parser/grammar and
  its fixtures do not comply and are being rebuilt to this version.

## Pre-history (informal, pre-SemVer)
- **0.7-draft** (Dec 2025) and earlier — the ruby-gem-era spec, before the
  descent rewrite. Legacy lineage, no conformance contract.
- Tags: `pre-umbrella-2026-07` (last pre-reboot commit) · `v0.8.0-reboot` (the
  2026-07-09 umbrella restructure).

[Keep a Changelog]: https://keepachangelog.com/en/1.1.0/
[Semantic Versioning]: https://semver.org/spec/v2.0.0.html
