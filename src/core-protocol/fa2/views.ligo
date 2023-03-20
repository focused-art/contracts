(* Views *)
[@view]
function get_owner (const _ : unit; const s : storage) : trusted is s.roles.owner

[@view]
function is_owner (const input : address; const s : storage) : bool is
  input = s.roles.owner

[@view]
function is_creator (const input : address; const s : storage) : bool is
  s.roles.creator contains input

[@view]
function is_minter (const input : address; const s : storage) : bool is
  s.roles.minter contains input

[@view]
function is_metadata_manager (const input : address; const s : storage) : bool is
  s.roles.metadata_manager contains input

[@view]
function is_royalties_manager (const input : address; const s : storage) : bool is
  s.roles.royalties_manager contains input

[@view]
function is_transfer_hook (const input : address; const s : storage) : bool is
  s.hooks.transfer contains input

[@view]
function is_create_hook (const input : address; const s : storage) : bool is
  s.hooks.create contains input

[@view]
function is_mint_hook (const input : address; const s : storage) : bool is
  s.hooks.mint contains input

[@view]
function is_burn_hook (const input : address; const s : storage) : bool is
  s.hooks.burn contains input

[@view]
function is_metadata_update_hook (const input : address; const s : storage) : bool is
  s.hooks.update_metadata contains input

[@view]
function next_token_id (const _ : unit; const s : storage) : nat is
  s.assets.next_token_id

[@view]
function get_balance (const params : balance_of_request; const s : storage) : nat is
  internal_get_balance_of(params.owner, params.token_id, s.assets)

[@view]
function get_total_supply (const token_id : token_id; const s : storage) : nat is
  internal_get_token_total_supply(token_id, s.assets)

[@view]
function is_operator (const params : operator_param; const s : storage) : bool is
  internal_is_operator(params.owner, params.operator, params.token_id, s.assets)

[@view]
function get_token_metadata (const token_id : token_id; const s : storage) : token_info is
  case s.assets.token_metadata[token_id] of [
    Some(token_metadata) -> token_metadata.token_info
  | None -> map []
  ]

[@view]
function is_token (const token_id : token_id; const s : storage) : bool is
  Big_map.mem(token_id, s.assets.token_total_supply)

[@view]
function get_royalties (const token_id : token_id; const s : storage) : royalties is
  case s.assets.royalties[token_id] of [
    Some(royalties) -> royalties
  | None -> s.default_royalties
  ]
