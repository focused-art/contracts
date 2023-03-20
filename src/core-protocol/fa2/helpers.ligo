(***)
(* Helpers *)
(***)

function get_transfer_hook (const c : trusted) : contract (transfer_params) is
  case (Tezos.get_entrypoint_opt("%transfer_hook", c) : option(contract(transfer_params))) of [
    None -> failwith ("FA_TRANSFER_HOOK_UNDEFINED")
  | Some(entrypoint) -> entrypoint
  ];

function get_create_hook (const c : trusted) : contract (create_params) is
  case (Tezos.get_entrypoint_opt("%create_hook", c) : option(contract(create_params))) of [
    None -> failwith ("FA_CREATE_HOOK_UNDEFINED")
  | Some(entrypoint) -> entrypoint
  ];

function get_burn_hook (const c : trusted) : contract (mint_burn_params) is
  case (Tezos.get_entrypoint_opt("%burn_hook", c) : option(contract(mint_burn_params))) of [
    None -> failwith ("FA_BURN_HOOK_UNDEFINED")
  | Some(entrypoint) -> entrypoint
  ];

function get_mint_hook (const c : trusted) : contract (mint_burn_params) is
  case (Tezos.get_entrypoint_opt("%mint_hook", c) : option(contract(mint_burn_params))) of [
    None -> failwith ("FA_MINT_HOOK_UNDEFINED")
  | Some(entrypoint) -> entrypoint
  ];

function get_update_metadata_hook (const c : trusted) : contract (update_token_metadata_params) is
  case (Tezos.get_entrypoint_opt("%update_metadata_hook", c) : option(contract(update_token_metadata_params))) of [
    None -> failwith ("FA_UPDATE_METADATA_HOOK_UNDEFINED")
  | Some(entrypoint) -> entrypoint
  ];
