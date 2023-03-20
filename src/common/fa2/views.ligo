(* Views *)
#if !FA2__VIEWS
[@view]
function get_balance (const params : balance_of_request; const s : token_storage) : nat is
  internal_get_balance_of(params.owner, params.token_id, s)

[@view]
function total_supply (const token_id : token_id; const s : token_storage) : nat is
  internal_get_token_total_supply(token_id, s)

[@view]
function is_operator (const params : operator_param; const s : token_storage) : bool is
  internal_is_operator(params.owner, params.operator, params.token_id, s)

[@view]
function get_royalties (const token_id : token_id; const s : token_storage) : royalties is
  case s.royalties[token_id] of [
    Some(royalties) -> royalties
  | None -> record [
      total_shares = 0n;
      shares = map [];
    ]
  ]
#endif