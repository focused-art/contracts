(*                                          *)
(*                   FA2                    *)
(*                                          *)
(*      Built by Codecrafting <♥> Labs      *)
(*                                          *)

#include "../partials/common/types.ligo"
#include "../partials/fa2/types.ligo"
#include "../partials/fa2/helpers.ligo"
#include "../partials/fa2/views.ligo"
#include "../partials/fa2/entrypoints.ligo"

function fa2_main (const action : token_action; var s : token_storage) : token_return is
  case action of [
  | Transfer(params)                  -> transfer(params, s)
  | Update_operators(params)          -> update_operators(params, s)
  | Assert_balances(params)           -> assert_balances(params, s)
  | Balance_of(params)                -> balance_of(params, s)
  ];
