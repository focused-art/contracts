(*                                          *)
(*                   FA2                    *)
(*                                          *)
(*      Built by Codecrafting <♥> Labs      *)
(*                                          *)

#include "fa2.ligo"

function fa2_main_using_constants (const action : token_action; var s : token_storage) : token_return is
  case action of [
  | Transfer(params)                  -> transfer_as_constant(params, s)
  | Update_operators(params)          -> update_operators_as_constant(params, s)
  | Assert_balances(params)           -> assert_balances_as_constant(params, s)
  | Balance_of(params)                -> balance_of_as_constant(params, s)
  ];

function fa2_main_transfer_with_hook_using_constants (const action : token_action; var s : token_storage) : token_return is
  case action of [
  | Transfer(params)                  -> transfer_with_hook_as_constant(params, s)
  | Update_operators(params)          -> update_operators_as_constant(params, s)
  | Assert_balances(params)           -> assert_balances_as_constant(params, s)
  | Balance_of(params)                -> balance_of_as_constant(params, s)
  ];
