(*                                          *)
(*                   FA2+                   *)
(*                                          *)
(*      Built by Codecrafting <♥> Labs      *)
(*                                          *)

#include "../../common/types.ligo"
#include "../../utils/nat.ligo"
#include "types.ligo"
#include "helpers.ligo"
#include "views.ligo"
#include "entrypoints.ligo"

(* Main entrypoint *)
function main (const action : entry_action; var s : storage) : return is {
  assert_with_error(Tezos.get_amount() = 0tz, "FA2_DONT_SEND_TEZ")
} with case action of [
  | Owner_action(params) -> owner_main(params, s)
  | Privileged_action(params) -> privileged_main(params, s)
  | Fa2_core_action(params) -> fa2_core_main(params, s)
  | Fa2_plus_action(params) -> fa2_plus_main(params, s)
];
