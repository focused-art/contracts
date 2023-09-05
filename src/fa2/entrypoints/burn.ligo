(* Burn some tokens *)
function burn (const input : mint_burn_params; var s : storage) : return is {
  validate_operator(input.owner, Tezos.get_sender(), input.token_id, s);
  validate_token_id(input.token_id, s);

  const owner_bal : nat = internal_get_balance_of(input.owner, input.token_id, s);
  assert_with_error(owner_bal >= input.amount, "FA2_INSUFFICIENT_BALANCE");

  const new_owner_bal : nat = abs(owner_bal - input.amount);
  s.ledger[(input.owner, input.token_id)] := new_owner_bal;

  const new_total_supply : nat = abs(internal_get_token_total_supply(input.token_id, s) - input.amount);
  s.token_total_supply[input.token_id] := new_total_supply;

  (* initialize operations *)
  var operations : list (operation) := nil;

  (* send any burn hooks *)
  for hook in set get_burn_hooks(Unit, s) {
    operations := Tezos.transaction (input, 0tz, get_burn_hook(hook)) # operations;
  };

  (* Events *)
  const total_supply_update_event : total_supply_update_event = record [
    owner_diffs = list [ record [
      owner = input.owner;
      owner_diff = int(input.amount) * -1;
    ] ];
    token_id = input.token_id;
    new_total_supply = new_total_supply;
    diff = int(input.amount) * -1;
  ];
  operations := Tezos.emit("%total_supply_update", total_supply_update_event) # operations;

  const balance_update_event : balance_update_event = record [
    owner = input.owner;
    token_id = input.token_id;
    new_balance = new_owner_bal;
    diff = int(input.amount) * -1;
  ];
  operations := Tezos.emit("%balance_update", balance_update_event) # operations;

} with (operations, s)
