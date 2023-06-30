(*                                          *)
(*              FA2 Permissions             *)
(*                                          *)
(*      Built by Codecrafting <♥> Labs      *)
(*                                          *)

#include "../common/types.ligo"
#include "../common/utils/fa2.ligo"
#include "constants.ligo"
#include "types.ligo"
#include "helpers.ligo"
#include "views.ligo"
#include "entrypoints.ligo"

(* Main entrypoint *)
function main (const action : entry_action; var s : storage) : return is {
  assert_with_error(Tezos.get_amount() = 0tz, "FA2_DONT_SEND_TEZ")
} with case action of [
  | Init(params) -> init(params, s)
  | Transfer_ownership(params) -> transfer_ownership(params.0, params.1, s)
  | Update_roles(params) -> update_roles(params, s)
  | Renounce_roles(params) -> renounce_roles(params, s)
  | Update_hooks(params) -> update_hooks(params, s)
  | Confirm_ownership(params) -> confirm_ownership(params, s)
];
