#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

TMP="_probe_tmp"
rm -rf "$TMP"
mkdir -p "$TMP"
trap 'rm -rf "$TMP"' EXIT

echo "=================================================================="
echo "PROBE 1: Type error in .ml chunk (dedented vs --preserve-indent)"
echo "=================================================================="
sed 's/let element_name e = e.el_name/let element_name e = 123/' udon_ast.ud > "$TMP/p1.ud"
mkdir -p "$TMP/p1_dedent" "$TMP/p1_exact"
./udon_lit --out "$TMP/p1_dedent" "$TMP/p1.ud" >/dev/null
./udon_lit --preserve-indent --out "$TMP/p1_exact" "$TMP/p1.ud" >/dev/null
echo "--- dedented (standard UDON fence dedent) ---"
(cd "$TMP/p1_dedent" && ocamlc -c udon_ast.mli && ocamlc -c udon_ast.ml) 2>&1 || true
echo "--- --preserve-indent (exact .ud column numbers) ---"
(cd "$TMP/p1_exact" && ocamlc -c udon_ast.mli && ocamlc -c udon_ast.ml) 2>&1 || true

echo ""
echo "=================================================================="
echo "PROBE 2: Abstraction leak (consumer reaching into abstract element)"
echo "=================================================================="
sed 's/assert (Udon_ast.element_name el = Some "user");/let _ = el.Udon_ast.el_attrs in assert (Udon_ast.element_name el = Some "user");/' udon_ast.ud > "$TMP/p2.ud"
mkdir -p "$TMP/p2"
./udon_lit --out "$TMP/p2" "$TMP/p2.ud" >/dev/null
(cd "$TMP/p2" && ocamlc -c udon_ast.mli && ocamlc -c udon_ast.ml && ocamlc -o udon_ast_verify udon_ast.cmo udon_ast_verify.ml) 2>&1 || true

echo ""
echo "=================================================================="
echo "PROBE 3: Runtime I.e. invariant failure with OCAMLRUNPARAM=b"
echo "=================================================================="
# Break equal_element_content so it returns false on attribute comparison
sed 's/&& map_equal (list_equal equal_value_content) e1.el_attrs e2.el_attrs/\&\& false/' udon_ast.ud > "$TMP/p3.ud"
mkdir -p "$TMP/p3"
./udon_lit --out "$TMP/p3" "$TMP/p3.ud" >/dev/null
(cd "$TMP/p3" && ocamlc -g -c udon_ast.mli && ocamlc -g -c udon_ast.ml && ocamlc -g -o udon_ast_verify udon_ast.cmo udon_ast_verify.ml && OCAMLRUNPARAM=b ./udon_ast_verify) 2>&1 || true

echo ""
echo "=================================================================="
echo "PROBE 4: Ubiquitous language violation (undefined «term» + :avoid)"
echo "=================================================================="
sed 's/An «element» has three parts and no others:/An «element» tag has three «widget» parts and no others:/' udon_ast.ud > "$TMP/p4.ud"
./udon_lit --audit-only "$TMP/p4.ud" 2>&1 || true

echo ""
echo "=================================================================="
echo "PROBE 5: Multi-line OCaml string hazard under --preserve-indent"
echo "=================================================================="
cat > "$TMP/p5.ud" <<'EOF'
|context[multiline-probe]
  |tangle[m] :file m.ml :projection impl :traits [ml]
    :layout [main]
  |term[sample]
    ```ocaml[s].ml :section main
    let s = {|line1
    line2|}
    let () = Printf.printf "len=%d content=%S\n" (String.length s) s
    ```
EOF
mkdir -p "$TMP/p5_dedent" "$TMP/p5_exact"
./udon_lit --out "$TMP/p5_dedent" "$TMP/p5.ud" >/dev/null
./udon_lit --preserve-indent --out "$TMP/p5_exact" "$TMP/p5.ud" >/dev/null
echo "--- dedented ---"
(cd "$TMP/p5_dedent" && ocamlc -o m m.ml && ./m)
echo "--- --preserve-indent ---"
(cd "$TMP/p5_exact" && ocamlc -o m m.ml && ./m)
