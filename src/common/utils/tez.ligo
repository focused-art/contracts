function tez_min (const a : tez; const b : tez) : tez is
  if a < b then a else b;

function tez_max (const a : tez; const b : tez) : tez is
  if a > b then a else b;

function tez_to_nat (const a : tez) : nat is
  a / 1mutez

function tez_to_int (const a : tez) : int is
  int(tez_to_nat(a))

function tez_transfer (const destination : address; const amt : tez) : operation is
  block {
    const receiver : contract (unit) =
      case (Tezos.get_contract_opt (destination): option(contract(unit))) of [
        Some (contract) -> contract
      | None -> (failwith ("FA_INVALID_TEZ_DESTINATION") : (contract(unit)))
      ];
  } with Tezos.transaction(unit, amt, receiver);
