(*                                          *)
(*                   FA2+                   *)
(*                                          *)
(*      Built by Codecrafting <♥> Labs      *)
(*                                          *)

#include "main.ligo"

(* Main entrypoint *)
function fa2_plus_main_using_constants (const action : entry_action; var s : storage) : return is {
  assert_with_error(Tezos.get_amount() = 0tz, "FA2_DONT_SEND_TEZ")
} with case action of [
  | Assets(params) -> {
      const res : token_return = fa2_main_transfer_with_hook_using_constants(params, s.assets);
      s.assets := res.1;
    } with (res.0, s)
  | Owner_action(params) -> owner_main_as_constant(params, s)
  | Renounce_roles(params) -> renounce_roles_as_constant(params, s)
  | Create(params) -> create_as_constant(params, s)
  | Mint(params) -> mint_as_constant(params, s)
  | Update_metadata(params) -> update_metadata_as_constant(params, s)
  | Update_royalties(params) -> update_royalties_as_constant(params, s)
  | Update_default_royalties(params) -> update_default_royalties_as_constant(params, s)
  | Burn(params) -> burn_as_constant(params, s)
  | Confirm_ownership -> confirm_ownership_as_constant(s)
  | Internal_transfer_hook(params) -> internal_transfer_hook_as_constant(params, s)
];
