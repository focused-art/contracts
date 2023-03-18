(* Burn some tokens *)
function burn (const input : mint_burn_params; var s : storage) : return is {
  validate_operator(input.owner, Tezos.get_sender(), input.token_id, s.assets);
  validate_token_id(input.token_id, s.assets);
  const owner_bal : nat = internal_get_balance_of(input.owner, input.token_id, s.assets);
  assert_with_error(owner_bal >= input.amount, "FA2_INSUFFICIENT_BALANCE");
  s.assets.ledger[(input.owner, input.token_id)] := abs(internal_get_balance_of(input.owner, input.token_id, s.assets) - input.amount);
  s.assets.token_total_supply[input.token_id] := abs(internal_get_token_total_supply(input.token_id, s.assets) - input.amount);

  (* initialize operations *)
  var operations : list (operation) := nil;

  (* send any burn hooks *)
  for hook in set s.hooks.burn {
    operations := Tezos.transaction (input, 0tz, get_burn_hook(hook)) # operations;
  };

} with (operations, s)

function burn_as_constant (const params : mint_burn_params; var s : storage) : return is
  ((Tezos.constant("exprv5QuqVpfpHxDySZirNyDXW5xu7sWjjkawFCG1ADfkSQSH9UBnK") : mint_burn_params * storage -> return))(params, s)
