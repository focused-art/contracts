(*                                          *)
(*                   FA2+                   *)
(*                                          *)
(*      Built by Codecrafting <♥> Labs      *)
(*                                          *)

#include "main.ligo"

(* Main entrypoint *)
function main_using_constants (const action : entry_action; var s : storage) : return is {
  assert_with_error(Tezos.get_amount() = 0tz, "FA2_DONT_SEND_TEZ")
} with case action of [
  | Privileged_action(params) -> privileged_main_as_constant(params, s)
  | Fa2_core_action(params) -> fa2_core_main_as_constant(params, s)
  | Fa2_plus_action(params) -> fa2_plus_main_as_constant(params, s)
];
