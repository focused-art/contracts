(* Mint some tokens *)
function mint (const input : mint_burn_params; var s : storage) : return is {
  assert_with_error(is_minter(Tezos.get_sender(), s), "FA2_INVALID_MINTER_ACCESS");
  validate_token_id(input.token_id, s.assets);
  s.assets.ledger[(input.owner, input.token_id)] := internal_get_balance_of(input.owner, input.token_id, s.assets) + input.amount;
  s.assets.token_total_supply[input.token_id] := internal_get_token_total_supply(input.token_id, s.assets) + input.amount;

  (* initialize operations *)
  var operations : list (operation) := nil;

  (* send any burn hooks *)
  for hook in set s.hooks.mint {
    operations := Tezos.transaction (input, 0tz, get_mint_hook(hook)) # operations;
  };

} with (operations, s)

function mint_as_constant (const params : mint_burn_params; var s : storage) : return is
  ((Tezos.constant("exprtmdfMnvMYqXNasxgUSWvmCDiGcoCGay3nGWM1ZBfeZm3TXj1uL") : mint_burn_params * storage -> return))(params, s)
