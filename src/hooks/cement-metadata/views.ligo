(***)
(* Views *)
(***)

[@view]
function is_revocable (const k : hook_type; const _ : storage) : bool is
  case k of [
  | Transfer -> True
  | Create -> True
  | Mint -> True
  | Burn -> True
  | Metadata -> False
  ]

[@view]
function is_cemented (const k : fa2; const s : storage) : bool is
  case s.cemented_tokens[k] of [
    Some(_u) -> True
  | None -> False
  ]
