(***)
(* Views *)
(***)

[@view]
function is_soulbound (const k : fa2; const s : storage) : bool is
  case s.soulbound_tokens[k] of [
    Some(_u) -> True
  | None -> False
  ]
