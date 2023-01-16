(* Burn some tokens *)
function iterate_burn (var s : storage; const input : mint_burn_tx) : storage is {
  validate_operator(input.owner, Tezos.get_sender(), input.token_id, s.assets);
  validate_token_id(input.token_id, s.assets);
  const owner_bal : nat = internal_get_balance_of(input.owner, input.token_id, s.assets);
  assert_with_error(owner_bal >= input.amount, "FA2_INSUFFICIENT_BALANCE");
  s.assets.ledger[(input.owner, input.token_id)] := abs(internal_get_balance_of(input.owner, input.token_id, s.assets) - input.amount);
  s.assets.token_total_supply[input.token_id] := abs(internal_get_token_total_supply(input.token_id, s.assets) - input.amount);
} with s

function burn (const params : mint_burn_params; var s : storage) : return is
  (noOperations, List.fold(iterate_burn, params, s))
