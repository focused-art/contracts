(*                                          *)
(*               Mint Recipes               *)
(*                                          *)
(*      Built by Codecrafting <♥> Labs      *)
(*                                          *)

#include "../../common/types.ligo"
#include "../../common/utils/fa2.ligo"
#include "../../common/utils/tez.ligo"
#include "../../common/utils/nat.ligo"
#include "../../common/utils/int.ligo"
#include "../../common/payments.ligo"

#include "types.ligo"
#include "helpers.ligo"
#include "views.ligo"
#include "entrypoints.ligo"

(* Main entrypoint *)
function main (const action : entry_action; var s : storage) : return is
  case action of [
    | Mint_owner_action(params) -> mint_owner_main(params, s)
    | Create(params) -> create(params, s)
    | Mint(params) -> mint(params, s)
  ];
