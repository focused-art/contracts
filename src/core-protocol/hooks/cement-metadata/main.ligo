(*                                          *)
(*           Cement Metadata hook           *)
(*                                          *)
(*      Built by Codecrafting <♥> Labs      *)
(*                                          *)

#include "../../../common/types.ligo"
#include "../../../utils/fa2.ligo"
#include "types.ligo"
#include "views.ligo"
#include "entrypoints.ligo"

(* Main entrypoint *)
function main (const action : entry_action; var s : storage) : return is {
  assert_with_error(Tezos.get_amount() = 0tz, "FA_DONT_SEND_TEZ");
} with case action of [
  | Cement_metadata(params) -> cement_metadata(params, s)
  | Update_metadata_hook(params) -> update_metadata_hook(params, s)
]
