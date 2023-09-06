(***)
(* Views *)
(***)

[@view]
function is_revocable (const k : hook_type; const _ : storage) : bool is
  case k of [
  | Transfer_hook -> False
  | Create_hook -> True
  | Mint_hook -> True
  | Burn_hook -> True
  | Metadata_hook -> True
  ]

[@view]
function is_ntt (const k : fa2; const s : storage) : bool is
  case s.ntt_tokens[k] of [
    Some(_u) -> True
  | None -> False
  ]
