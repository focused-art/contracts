(***)
(* Helpers *)
(***)

function internal_get_token_total_supply (const token_id : token_id; const s : storage) : nat is
  case s.token_total_supply[token_id] of [
    None -> 0n
  | Some(supply) -> supply
  ];

function internal_get_balance_of (const owner : owner; const token_id : token_id; const s : storage) : nat is
  case s.ledger[(owner, token_id)] of [
    None -> 0n
  | Some(bal) -> bal
  ];

function internal_is_operator (const owner : owner; const operator : operator; const token_id : token_id; const s : storage) : bool is
  owner = operator or Big_map.mem ((owner, (operator, token_id)), s.operators)

function validate_operator (const owner : owner; const operator : operator; const token_id : token_id; const s : storage) : unit is
  assert_with_error(internal_is_operator(owner, operator, token_id, s) = True, "FA2_NOT_OPERATOR")

function validate_owner (const owner : owner) : unit is
  assert_with_error(Tezos.get_sender() = owner, "FA2_NOT_OWNER")

function validate_token_id (const token_id : token_id; const s : storage) : unit is
  assert_with_error(token_id < s.next_token_id, "FA2_TOKEN_UNDEFINED")

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
