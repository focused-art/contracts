#include "fa2-core/transfer.ligo"
#include "fa2-core/update-operators.ligo"
#include "fa2-core/assert-balances.ligo"
#include "fa2-core/balance-of.ligo"

function fa2_core_main (const action : fa2_core_action; var s : storage) : return is
  case action of [
  | Transfer(params)                  -> transfer_with_hook(params, s)
  | Update_operators(params)          -> update_operators(params, s)
  | Assert_balances(params)           -> assert_balances(params, s)
  | Balance_of(params)                -> balance_of(params, s)
  ]

function fa2_core_main_as_constant (const action : fa2_core_action; var s : storage) : return is
  ((Tezos.constant("exprtw9s1HfB4mnFPhMb6PNqTQvoYc1Wb4jNwi5DhQQAbioJHoVDhi") : fa2_core_action * storage -> return))((action, s))
