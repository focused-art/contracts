(***)
(* Views *)
(***)

[@view]
function is_revocable (const k : hook_type; const _ : storage) : bool is
  case k of [
  | Transfer_hook -> False
  | Create_hook -> True
  | Mint_hook -> True
  | Burn_hook -> False
  | Metadata_hook -> True
  ]

[@view]
function is_frozen (const k : owner * fa2; const s : storage) : bool is
  case s.frozen_tokens[k] of [
    Some(t) -> t > Tezos.get_now()
  | None -> False
  ]
