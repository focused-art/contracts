(*                                          *)
(*                   FA2+                   *)
(*                                          *)
(*      Built by Codecrafting <♥> Labs      *)
(*                                          *)

#include "../common/types.ligo"
#include "../common/utils/nat.ligo"
#include "types.ligo"
#include "helpers.ligo"
#include "views.ligo"
#include "entrypoints.ligo"

(* Main entrypoint *)
function main (const action : entry_action; var s : storage) : return is {
  assert_with_error(Tezos.get_amount() = 0tz, "FA2_DONT_SEND_TEZ")
} with case action of [
  | Privileged_action(params)         -> privileged_main(params, s)
  | Transfer(params)                  -> transfer(params, s)
  | Update_operators(params)          -> update_operators(params, s)
  | Assert_balances(params)           -> assert_balances(params, s)
  | Balance_of(params)                -> balance_of(params, s)
  | Create(params)                    -> create(params, s)
  | Mint(params)                      -> mint(params, s)
  | Burn(params)                      -> burn(params, s)
];
