#!/usr/bin/env python3
"""
run_spike.py — End-to-end verification runner for Spike 2 (UDON <-> OCaml ADTs).
Runs both the valid DDD Bounded Context pipeline and every deliberate breakage case,
capturing verbatim translator, `ocamlc`, and compiled OCaml invariant outputs.
"""

from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parent
BUILD = ROOT / "build"
SCHEMAS = [
    str(ROOT / "schemas/verisectorium.schema.ud"),
    str(ROOT / "schemas/udon_spec.schema.ud"),
]

def run(cmd: list[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(cmd, cwd=ROOT, text=True, capture_output=True)

def banner(title: str) -> None:
    print("\n" + "=" * 76)
    print(title)
    print("=" * 76)

def main() -> int:
    BUILD.mkdir(exist_ok=True)

    banner("STEP 1: Compile UDON Schemas -> OCaml .mli/.ml -> ocamlc")
    r = run(["python3", "udon2ml.py", "schema", "build", *SCHEMAS])
    print(r.stdout.strip())
    assert r.returncode == 0, r.stderr

    r = run([
        "ocamlc", "-I", "build", "-c",
        "build/verisectorium.mli", "build/verisectorium.ml",
        "build/udon_spec.mli", "build/udon_spec.ml",
    ])
    assert r.returncode == 0, r.stderr
    print("ocamlc: schemas compiled cleanly (0 errors, 0 warnings).")

    banner("STEP 2: Compile Valid UDON Data Stores -> ocamlc -> Run Invariant Checks")
    for data_file in ["data/verisectorium_store.ud", "data/udon_part1.ud"]:
        r = run(["python3", "udon2ml.py", "data", "build", data_file, "--schemas", *SCHEMAS])
        print(r.stdout.strip())
        assert r.returncode == 0, r.stderr

    r = run([
        "ocamlc", "-I", "build", "-c",
        "build/verisectorium_store.mli", "build/verisectorium_store.ml",
        "build/udon_part1.mli", "build/udon_part1.ml",
    ])
    assert r.returncode == 0, r.stderr

    r = run([
        "ocamlc", "-I", "build", "-o", "build/run_valid",
        "build/verisectorium.cmo", "build/udon_spec.cmo",
        "build/verisectorium_store.cmo", "build/udon_part1.cmo",
        "checks.ml", "run_valid.ml",
    ])
    assert r.returncode == 0, r.stderr
    r = run(["./build/run_valid"])
    print(r.stdout.strip())
    assert r.returncode == 0, r.stderr

    # --- Deliberate Breakage Suite ---
    compile_fail_cases = [
        ("01_dangling_prose_term.ud", "Layer 2 (ocamlc): Undefined @{block} inside prose"),
        ("02_wrong_entity_kind.ud",   "Layer 2 (ocamlc): Outline.id passed where Piece.any_id expected"),
        ("03_draft_in_settled_slot.ud", "Layer 2 (ocamlc): Phantom-type violation (`Draft in `Accepted slot)"),
        ("04a_unknown_attr.ud",       "Layer 2 (ocamlc): Unknown attribute typo :metod"),
        ("04b_missing_required.ud",   "Layer 2 (ocamlc): Missing required attribute :how"),
        ("05_cross_context_leak.ud",  "Layer 2 (ocamlc): Bounded Context .mli leak (Term.id vs Piece.any_id)"),
        ("06a_disjoint_traits.ud",    "Layer 1 (translator): Conflicting traits .draft.accepted"),
        ("06b_duplicate_key.ud",      "Layer 1 (translator): Duplicate [p1] key (prevents OCaml `let` shadowing)"),
        ("06c_anonymous_element.ud",  "Layer 1 (translator): Anonymous UDON element `|` has no ADT constructor"),
    ]

    banner("STEP 3: Deliberate Breakages (Compile-Time & Translator Guards)")
    for fname, desc in compile_fail_cases:
        fpath = f"broken/{fname}"
        mod = "b_" + fname.split("_")[0]
        print(f"\n--- {fname} | {desc} ---")
        r1 = run(["python3", "udon2ml.py", "data", "build", fpath, "--schemas", *SCHEMAS, "--mod", mod])
        if r1.returncode != 0:
            print("CAUGHT BY TRANSLATOR (Layer 1):")
            print("  " + (r1.stderr or r1.stdout).strip().splitlines()[-1])
            continue
        r2 = run(["ocamlc", "-I", "build", "-c", f"build/{mod}.mli", f"build/{mod}.ml"])
        if r2.returncode != 0:
            print("CAUGHT BY OCAMLC (Layer 2):")
            for line in r2.stderr.strip().splitlines():
                print("  " + line)
        else:
            print("UNEXPECTED PASS! Expected failure.")
            return 1

    banner("STEP 4: Deliberate Breakages (Well-Typed OCaml -> Layer 3 Compiled Domain Invariants)")

    # 07: Verisectorium domain invariants
    print("\n--- 07_domain_invariants_verisectorium.ud ---")
    r = run(["python3", "udon2ml.py", "data", "build", "broken/07_domain_invariants_verisectorium.ud", "--schemas", *SCHEMAS, "--mod", "b_07"])
    assert r.returncode == 0, r.stderr
    r = run(["ocamlc", "-I", "build", "-c", "build/b_07.mli", "build/b_07.ml"])
    assert r.returncode == 0, r.stderr
    driver07 = BUILD / "run_b07.ml"
    driver07.write_text(
        'let () = Checks.check_verisectorium B_07.all_pieces B_07.all_outlines B_07.all_acts\n'
        '  |> Checks.print_findings "broken/07_domain_invariants_verisectorium.ud"\n'
    )
    r = run([
        "ocamlc", "-I", "build", "-o", "build/run_b07",
        "build/verisectorium.cmo", "build/udon_spec.cmo", "build/b_07.cmo",
        "checks.ml", str(driver07),
    ])
    assert r.returncode == 0, r.stderr
    r = run(["./build/run_b07"])
    print("Compiled cleanly with ocamlc; Layer 3 runtime invariant output:")
    print(r.stdout.strip())

    # 08: UDON Spec domain invariants
    print("\n--- 08_domain_invariants_udon_spec.ud ---")
    r = run(["python3", "udon2ml.py", "data", "build", "broken/08_domain_invariants_udon_spec.ud", "--schemas", *SCHEMAS, "--mod", "b_08"])
    assert r.returncode == 0, r.stderr
    r = run(["ocamlc", "-I", "build", "-c", "build/b_08.mli", "build/b_08.ml"])
    assert r.returncode == 0, r.stderr
    driver08 = BUILD / "run_b08.ml"
    driver08.write_text(
        'let () = Checks.check_udon_spec B_08.all_terms []\n'
        '  |> Checks.print_findings "broken/08_domain_invariants_udon_spec.ud"\n'
    )
    r = run([
        "ocamlc", "-I", "build", "-o", "build/run_b08",
        "build/verisectorium.cmo", "build/udon_spec.cmo", "build/b_08.cmo",
        "checks.ml", str(driver08),
    ])
    assert r.returncode == 0, r.stderr
    r = run(["./build/run_b08"])
    print("Compiled cleanly with ocamlc; Layer 3 runtime invariant output:")
    print(r.stdout.strip())

    banner("ALL SPIKE CHECKS COMPLETED")
    return 0

if __name__ == "__main__":
    sys.exit(main())
