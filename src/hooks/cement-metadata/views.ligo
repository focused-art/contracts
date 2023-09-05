(***)
(* Views *)
(***)

[@view]
function is_revocable (const k : hook_type; const _ : storage) : bool is
  case k of [
  | Transfer_hook -> True
  | Create_hook -> True
  | Mint_hook -> True
  | Burn_hook -> True
  | Metadata_hook -> False
  ]

[@view]
function is_cemented (const k : fa2; const s : storage) : bool is
  case s.cemented_tokens[k] of [
    Some(t) -> t >= Tezos.get_now()
  | None -> False
  ]
