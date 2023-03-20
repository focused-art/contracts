(* Mint some tokens *)
function mint (const input : mint_burn_params; var s : storage) : return is {
  assert_with_error(is_minter(Tezos.get_sender(), s), "FA2_INVALID_MINTER_ACCESS");
  validate_token_id(input.token_id, s.assets);

  const new_owner_bal : nat = internal_get_balance_of(input.owner, input.token_id, s.assets) + input.amount;
  s.assets.ledger[(input.owner, input.token_id)] := new_owner_bal;

  const new_total_supply : nat = internal_get_token_total_supply(input.token_id, s.assets) + input.amount;
  s.assets.token_total_supply[input.token_id] := new_total_supply;

  (* initialize operations *)
  var operations : list (operation) := nil;

  (* send any mint hooks *)
  for hook in set s.hooks.mint {
    operations := Tezos.transaction (input, 0tz, get_mint_hook(hook)) # operations;
  };

  (* Events *)
  const total_supply_update_event : total_supply_update_event = record [
    owner_diffs = list [ record [
      owner = input.owner;
      owner_diff = int(input.amount);
    ] ];
    token_id = input.token_id;
    new_total_supply = new_total_supply;
    diff = int(input.amount);
  ];
  operations := Tezos.emit("%total_supply_update", total_supply_update_event) # operations;

  const balance_update_event : balance_update_event = record [
    owner = input.owner;
    token_id = input.token_id;
    new_balance = new_owner_bal;
    diff = int(input.amount);
  ];
  operations := Tezos.emit("%balance_update", balance_update_event) # operations;

} with (operations, s)

function mint_as_constant (const params : mint_burn_params; var s : storage) : return is
  ((Tezos.constant("exprthvHuVPs3FMsg29eprbwf4Rsd4jbw9Ek4h2B7mPEnX8mT9qqnH") : mint_burn_params * storage -> return))((params, s))
