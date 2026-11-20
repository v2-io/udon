#!/usr/bin/env python3
"""Shape-lint the spec-0.10.01 fixture corpus (no parser). Exit 1 on violations.

Adapted from .archived/second-pass/fixtures/lint_corpus.py: descriptive cases
may carry `gap:` (audit item) or `open:` (carve-out) and use `readings:` in
place of `adm`; gate cases must carry `adm`.
"""

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
    deltas: dict[int, int] = {}
    gaps: dict[str, int] = {}
    files = sorted(ROOT.rglob("*.yaml"))

    for path in files:
        try:
            data = yaml.safe_load(path.read_text())
        except Exception as e:  # noqa: BLE001
            errors.append(f"{path}: YAML parse error: {e}")
            continue
        if not isinstance(data, list):
            errors.append(f"{path}: top level must be a list of cases")
            continue
        for i, case in enumerate(data):
            if not isinstance(case, dict):
                errors.append(f"{path}[{i}]: case must be a mapping")
                continue
            rel = path.relative_to(ROOT)
            loc = f"{rel}[{i}]"
            cid = case.get("id")
            if not cid or not isinstance(cid, str):
                errors.append(f"{loc}: missing string id")
            elif cid in seen_ids:
                errors.append(f"{loc}: duplicate id {cid!r} (also {seen_ids[cid]})")
            else:
                seen_ids[cid] = rel
            prof = case.get("profile")
            if prof not in PROFILES:
                errors.append(f"{loc}: profile must be one of {sorted(PROFILES)}, got {prof!r}")
            else:
                counts[prof] += 1
                if str(rel).split("/")[0] != prof:
                    errors.append(f"{loc}: profile {prof} but file lives under {rel.parts[0]}/")
            if not case.get("desc"):
                errors.append(f"{loc}: missing desc")
            if "udon" not in case or case["udon"] is None:
                errors.append(f"{loc}: missing udon")
            res = case.get("result", "complete")
            if res not in RESULTS:
                errors.append(f"{loc}: result must be one of {sorted(RESULTS)}, got {res!r}")
            d = case.get("deltas")
            if d is not None:
                if not isinstance(d, int) or not 1 <= d <= 14:
                    errors.append(f"{loc}: deltas must be a DELTAS row number 1..14, got {d!r}")
                else:
                    deltas[d] = deltas.get(d, 0) + 1
            if prof == "descriptive":
                if not (case.get("gap") or case.get("open")):
                    errors.append(f"{loc}: descriptive requires gap: (audit item) or open: (carve-out)")
                if "readings" not in case and "adm" not in case:
                    errors.append(f"{loc}: descriptive needs readings: or adm:")
                g = case.get("gap")
                if g:
                    gaps[str(g)] = gaps.get(str(g), 0) + 1
            elif prof in ("idiomatic", "comprehensive"):
                if case.get("gap") or case.get("open"):
                    errors.append(f"{loc}: gate profile {prof} must not set gap:/open: (move to descriptive/)")
                if "adm" not in case:
                    errors.append(f"{loc}: gate case needs adm:")
                if "readings" in case:
                    errors.append(f"{loc}: gate case must not carry readings: (pin one adm or demote)")

    print(f"files: {len(files)}")
    print(f"cases: {sum(counts.values())}  {counts}")
    print("deltas pinned: " + ", ".join(f"{k}×{v}" for k, v in sorted(deltas.items())))
    print("gaps probed:   " + ", ".join(f"{k}×{v}" for k, v in sorted(gaps.items())))
    if errors:
        print(f"violations: {len(errors)}", file=sys.stderr)
        for e in errors:
            print(f"  {e}", file=sys.stderr)
        return 1
    print("ok")
    return 0


if __name__ == "__main__":
    sys.exit(main())
