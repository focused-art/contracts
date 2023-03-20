(*                                          *)
(*                   FA2                    *)
(*                                          *)
(*      Built by Codecrafting <♥> Labs      *)
(*                                          *)

#include "../types.ligo"
#include "types.ligo"
#include "helpers.ligo"
#include "views.ligo"
#include "entrypoints.ligo"

function fa2_main (const action : token_action; var s : token_storage) : token_return is
  case action of [
  | Transfer(params)                  -> transfer(params, s)
  | Update_operators(params)          -> update_operators(params, s)
  | Assert_balances(params)           -> assert_balances(params, s)
  | Balance_of(params)                -> balance_of(params, s)
  ];

function fa2_main_transfer_with_hook (const action : token_action; var s : token_storage) : token_return is
  case action of [
  | Transfer(params)                  -> transfer_with_hook(params, s)
  | Update_operators(params)          -> update_operators(params, s)
  | Assert_balances(params)           -> assert_balances(params, s)
  | Balance_of(params)                -> balance_of(params, s)
  ];
