(***)
(* Views *)
(***)

[@view]
function is_cemented (const k : fa2; const s : storage) : bool is
  case s.cemented_tokens[k] of [
    Some(_u) -> True
  | None -> False
  ]
