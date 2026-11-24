(* Generated from /Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/diagnostics_probe.ud by udon2ml.py *)
(* Negative diagnostics probe: tests how ocamlc reports errors back to .ud lines *)
(* AND how udon2ml catches broken ubiquitous-language [ref] prose links. *)
(** This file mentions [status] (exists) and [phantom-concept] (does NOT exist!). *)

# 6 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/diagnostics_probe.ud"
type status =
  | Draft
  | Accepted
  | Gap

(* 1. Non-exhaustive match (missing |Gap) — ocamlc -w +8 should warn at this .ud line! *)
# 12 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/diagnostics_probe.ud"
let describe s : string =
  (match s with
# 14 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/diagnostics_probe.ud"
    | Draft -> "draft"
# 15 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/diagnostics_probe.ud"
    | Accepted -> "accepted"
  )

(* 2. Type error (returning string from int function) — ocamlc should error at this .ud line! *)
# 18 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/diagnostics_probe.ud"
let broken_count x : int =
  (("not an int: ") ^ x)

