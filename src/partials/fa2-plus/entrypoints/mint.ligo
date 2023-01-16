(* Mint some tokens *)
function iterate_mint (var s : storage; const input : mint_burn_tx) : storage is {
  validate_token_id(input.token_id, s.assets);
  s.assets.ledger[(input.owner, input.token_id)] := internal_get_balance_of(input.owner, input.token_id, s.assets) + input.amount;
  s.assets.token_total_supply[input.token_id] := internal_get_token_total_supply(input.token_id, s.assets) + input.amount;
} with s

function mint (const params : mint_burn_params; var s : storage) : return is
  (noOperations, List.fold(iterate_mint, params, s))
