(*                                          *)
(*                   FA2+                   *)
(*                                          *)
(*      Built by Codecrafting <♥> Labs      *)
(*                                          *)

#if !FA2__VIEWS
#define FA2__VIEWS
#endif

#if !FA2__TRANSFER_HOOK
#define FA2__TRANSFER_HOOK
#endif

#include "fa2-using-constants.ligo"
#include "../partials/utils/nat.ligo"
#include "../partials/fa2-plus/types.ligo"
#include "../partials/fa2-plus/helpers.ligo"
#include "../partials/fa2-plus/views.ligo"
#include "../partials/fa2-plus/entrypoints.ligo"

(* Main entrypoint *)
function fa2_plus_main (const action : entry_action; var s : storage) : return is {
  assert_with_error(Tezos.get_amount() = 0tz, "FA2_DONT_SEND_TEZ")
} with case action of [
  | Assets(params) -> {
      const res : (list (operation) * token_storage) = fa2_main_using_constants(params, s.assets);
      s.assets := res.1;
    } with (res.0, s)
  | Transfer_ownership(params) -> transfer_ownership(params, s)
  | Update_roles(params) -> update_roles(params, s)
  | Update_hooks(params) -> update_hooks(params, s)
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
