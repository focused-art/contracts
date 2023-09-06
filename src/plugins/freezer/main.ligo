(*                                          *)
(*             NTT Transfer Hook            *)
(*                                          *)
(*      Built by Codecrafting <♥> Labs      *)
(*                                          *)

#include "../../common/types.ligo"
#include "../../common/utils/fa2.ligo"
#include "../../common/utils/timestamp.ligo"
#include "types.ligo"
#include "views.ligo"
#include "entrypoints.ligo"

(* Main entrypoint *)
function main (const action : entry_action; var s : storage) : return is {
  assert_with_error(Tezos.get_amount() = 0tz, "FA_DONT_SEND_TEZ");
} with case action of [
  | Freeze(params) -> freeze(params, s)
  | Transfer_hook(params) -> transfer_hook(params, s)
  | Burn_hook(params) -> burn_hook(params, s)
]
