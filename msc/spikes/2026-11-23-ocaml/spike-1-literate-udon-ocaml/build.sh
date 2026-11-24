#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

echo "==> 1. Compiling udon_lit (zero-dependency OCaml 5.5 tangler + auditor)"
ocamlc -g -o udon_lit udon_lit.ml

echo "==> 2. Tangling udon_ast.ud -> gen/{udon_ast.mli, udon_ast.ml, udon_ast_verify.ml} + Verisectorium audit"
./udon_lit --out gen udon_ast.ud

echo "==> 3. Compiling Consumer (.mli), Implementer (.ml), and Verification harness with ocamlc"
(
  cd gen
  ocamlc -g -c udon_ast.mli
  ocamlc -g -c udon_ast.ml
  ocamlc -g -o udon_ast_verify udon_ast.cmo udon_ast_verify.ml
  OCAMLRUNPARAM=b ./udon_ast_verify
)
