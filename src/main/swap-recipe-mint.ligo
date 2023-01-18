(*                                          *)
(*            Swap Recipe Minting           *)
(*                                          *)
(*      Built by Codecrafting <♥> Labs      *)
(*                                          *)

#include "../partials/common/types.ligo"
#include "../partials/utils/fa2.ligo"
#include "../partials/utils/nat.ligo"
#include "../partials/utils/tez.ligo"
#include "../partials/common/payments.ligo"
#include "../partials/swap-recipe-mint/types.ligo"
#include "../partials/swap-recipe-mint/helpers.ligo"
#include "../partials/swap-recipe-mint/views.ligo"
#include "../partials/swap-recipe-mint/entrypoints.ligo"

(* Main entrypoint *)
function main (const action : entry_action; var s : storage) : return is
  case action of [
    | Swap_owner_action(params) -> swap_owner_main(params, s)
    | Create_swap(params) -> create_swap(params, s)
    | Mint(params) -> mint(params.0, params.1, params.2, s)
  ];
