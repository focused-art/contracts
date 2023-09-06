(***)
(* Views *)
(***)

[@view]
function is_ntt (const k : fa2; const s : storage) : bool is
  case s.ntt_tokens[k] of [
    Some(_u) -> True
  | None -> False
  ]
