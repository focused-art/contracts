(*                                          *)
(*                   FA2+                   *)
(*                                          *)
(*      Built by Codecrafting <♥> Labs      *)
(*                                          *)

#if !FA2__VIEWS
#define FA2__VIEWS
#endif

#include "../../common/fa2/main-using-constants.ligo"
#include "../../utils/nat.ligo"
#include "types.ligo"
#include "helpers.ligo"
#include "views.ligo"
#include "entrypoints.ligo"

(* Main entrypoint *)
function fa2_plus_main (const action : entry_action; var s : storage) : return is {
  assert_with_error(Tezos.get_amount() = 0tz, "FA2_DONT_SEND_TEZ")
} with case action of [
  | Assets(params) -> {
      const res : token_return = fa2_main_transfer_with_hook_using_constants(params, s.assets);
      s.assets := res.1;
    } with (res.0, s)
  | Owner_action(params) -> owner_main(params, s)
  | Renounce_roles(params) -> renounce_roles(params, s)
  | Create(params) -> create(params, s)
  | Mint(params) -> mint(params, s)
  | Update_metadata(params) -> update_metadata(params, s)
  | Update_royalties(params) -> update_royalties(params, s)
  | Update_default_royalties(params) -> update_default_royalties(params, s)
  | Burn(params) -> burn(params, s)
  | Confirm_ownership -> confirm_ownership(s)
  | Internal_transfer_hook(params) -> internal_transfer_hook(params, s)
];
