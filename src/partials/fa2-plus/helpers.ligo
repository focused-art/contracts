(***)
(* Helpers *)
(***)

function get_transfer_hook (const c : trusted) : contract (transfer_params) is
  case (Tezos.get_entrypoint_opt("%transfer_hook", c) : option(contract(transfer_params))) of [
    None -> failwith ("FA2_TRANSFER_HOOK_UNDEFINED")
  | Some(entrypoint) -> entrypoint
  ];
