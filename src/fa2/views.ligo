(* Views *)

[@view]
function get_protocol (const _ : unit; const s : storage) : trusted is
  s.protocol

[@view]
function get_owner (const _ : unit; const s : storage) : trusted is
  case (Tezos.call_view("get_owner", Tezos.get_self_address(), s.protocol) : option(trusted)) of [
    Some(response) -> response
  | None -> c_NULL_ADDRESS
  ]

[@view]
function is_owner (const input : address; const s : storage) : bool is
  case (Tezos.call_view("is_owner", (Tezos.get_self_address(), input), s.protocol) : option(bool)) of [
    Some(response) -> response
  | None -> False
  ]

[@view]
function has_role (const k : address * role_type; const s : storage) : bool is
  case (Tezos.call_view("has_role", (Tezos.get_self_address(), k.0, k.1), s.protocol) : option(bool)) of [
    Some(response) -> response
  | None -> False
  ]

[@view]
function get_hooks (const k : hook_type; const s : storage) : set (trusted) is
  case (Tezos.call_view("get_hooks", (Tezos.get_self_address(), k), s.protocol) : option(set(trusted))) of [
    Some(response) -> response
  | None -> set []
  ]

[@view]
function is_hook (const k : address * hook_type; const s : storage) : bool is
  get_hooks(k.1, s) contains k.0

[@view]
function next_token_id (const _ : unit; const s : storage) : nat is
  s.next_token_id

[@view]
function get_balance (const params : balance_of_request; const s : storage) : nat is
  internal_get_balance_of(params.owner, params.token_id, s)

[@view]
function get_total_supply (const token_id : token_id; const s : storage) : nat is
  internal_get_token_total_supply(token_id, s)

[@view]
function get_max_supply (const token_id : token_id; const s : storage) : nat is
  case s.token_max_supply[token_id] of [
    Some(max_supply) -> max_supply
  | None -> 0n
  ]

[@view]
function is_operator (const params : operator_param; const s : storage) : bool is
  internal_is_operator(params.owner, params.operator, params.token_id, s)

[@view]
function get_token_metadata (const token_id : token_id; const s : storage) : token_info is
  case s.token_metadata[token_id] of [
    Some(token_metadata) -> token_metadata.token_info
  | None -> map []
  ]

[@view]
function is_token (const token_id : token_id; const s : storage) : bool is
  Big_map.mem(token_id, s.token_total_supply)

[@view]
function get_royalties (const token_id : token_id; const s : storage) : royalties is
  case s.royalties[token_id] of [
    Some(royalties) -> royalties
  | None -> s.default_royalties
  ]
