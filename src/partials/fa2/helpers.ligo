(***)
(* Helpers *)
(***)

function internal_get_token_total_supply (const token_id : token_id; const s : token_storage) : nat is
  case s.token_total_supply[token_id] of [
    None -> 0n
  | Some(supply) -> supply
  ];

function internal_get_balance_of (const owner : owner; const token_id : token_id; const s : token_storage) : nat is
  case s.ledger[(owner, token_id)] of [
    None -> 0n
  | Some(bal) -> bal
  ];

function internal_is_operator (const owner : owner; const operator : operator; const token_id : token_id; const s : token_storage) : bool is
  owner = operator or Big_map.mem ((owner, (operator, token_id)), s.operators)

function validate_operator (const owner : owner; const operator : operator; const token_id : token_id; const s : token_storage) : unit is
  assert_with_error(internal_is_operator(owner, operator, token_id, s) = True, "FA2_NOT_OPERATOR")

function validate_owner (const owner : owner) : unit is
  assert_with_error(Tezos.get_sender() = owner, "FA2_NOT_OWNER")

function validate_token_id (const token_id : token_id; const s : token_storage) : unit is
  assert_with_error(token_id < s.next_token_id, "FA2_TOKEN_UNDEFINED")
