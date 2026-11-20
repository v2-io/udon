#!/usr/bin/env python3
"""Lint v2-spec/fixtures corpus shape (no parser). Exit 1 on violations."""

from __future__ import annotations

import sys
from pathlib import Path

try:
    import yaml
except ImportError:
    print("lint_corpus: need PyYAML (pip install pyyaml)", file=sys.stderr)
    sys.exit(2)

ROOT = Path(__file__).resolve().parent
PROFILES = {"idiomatic", "comprehensive", "descriptive"}
RESULTS = {"complete", "incomplete-input"}


def main() -> int:
    errors: list[str] = []
    seen_ids: dict[str, Path] = {}
    counts = {p: 0 for p in PROFILES}
    files = sorted(ROOT.rglob("*.yaml"))

    for path in files:
        try:
            data = yaml.safe_load(path.read_text())
        except Exception as e:
            errors.append(f"{path}: YAML parse error: {e}")
            continue
        if not isinstance(data, list):
            errors.append(f"{path}: top level must be a list of cases")
            continue
        for i, case in enumerate(data):
            if not isinstance(case, dict):
                errors.append(f"{path}[{i}]: case must be a mapping")
                continue
            loc = f"{path.relative_to(ROOT)}[{i}]"
            cid = case.get("id")
            if not cid or not isinstance(cid, str):
                errors.append(f"{loc}: missing string id")
            else:
                if cid in seen_ids:
                    errors.append(f"{loc}: duplicate id {cid!r} (also {seen_ids[cid]})")
                else:
                    seen_ids[cid] = path.relative_to(ROOT)
            prof = case.get("profile")
            if prof not in PROFILES:
                errors.append(f"{loc}: profile must be one of {sorted(PROFILES)}, got {prof!r}")
            else:
                counts[prof] += 1
            if not case.get("desc"):
                errors.append(f"{loc}: missing desc")
            if "udon" not in case or case["udon"] is None:
                errors.append(f"{loc}: missing udon")
            res = case.get("result", "complete")
            if res not in RESULTS:
                errors.append(f"{loc}: result must be one of {sorted(RESULTS)}, got {res!r}")
            if prof == "descriptive" and not case.get("open"):
                errors.append(f"{loc}: descriptive profile requires open: hole name")
            if prof in ("idiomatic", "comprehensive") and case.get("open"):
                # allow with warning-style note — still error for gate purity
                errors.append(
                    f"{loc}: gate profile {prof} should not set open: (move to descriptive/)"
                )
            # incomplete.yaml twin_array_interior was demoted — if open on comprehensive, catch

    print(f"files: {len(files)}")
    print(f"cases: {sum(counts.values())}  {counts}")
    if errors:
        print(f"violations: {len(errors)}", file=sys.stderr)
        for e in errors:
            print(f"  {e}", file=sys.stderr)
        return 1
    print("ok")
    return 0


if __name__ == "__main__":
    sys.exit(main())
