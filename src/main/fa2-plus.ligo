(*                                          *)
(*                   FA2+                   *)
(*                                          *)
(*      Built by Codecrafting <♥> Labs      *)
(*                                          *)

#if !FA2__ROYALTIES
#define FA2__ROYALTIES
#endif

#if !FA2__VIEWS
#define FA2__VIEWS
#endif

#if !FA2__TRANSFER_HOOK
#define FA2__TRANSFER_HOOK
#endif

#include "../partials/fa2/base.ligo"
#include "../partials/utils/nat.ligo"
#include "../partials/fa2-plus/types.ligo"
#include "../partials/fa2-plus/helpers.ligo"
#include "../partials/fa2-plus/views.ligo"
#include "../partials/fa2-plus/entrypoints.ligo"

(* Contract owner entrypoints *)
function owner_main (const action : owner_action; var s : storage) : return is {
  assert_with_error(is_owner(Tezos.get_sender(), s), "FA2_INVALID_OWNER_ACCESS");
} with case action of [
  | Transfer_ownership(params) -> transfer_ownership(params, s)
  | Renounce_ownership -> renounce_ownership(s)
  | Add_minter(params) -> add_minter(params, s)
  | Remove_minter(params) -> remove_minter(params, s)
  | Add_creator(params) -> add_creator(params, s)
  | Remove_creator(params) -> remove_creator(params, s)
  | Add_metadata_manager(params) -> add_metadata_manager(params, s)
  | Remove_metadata_manager(params) -> remove_metadata_manager(params, s)
  | Add_royalties_manager(params) -> add_royalties_manager(params, s)
  | Remove_royalties_manager(params) -> remove_royalties_manager(params, s)
  | Add_transfer_hook(params) -> add_transfer_hook(params, s)
  | Remove_transfer_hook(params) -> remove_transfer_hook(params, s)
];

(* Creator entrypoints *)
function creator_main (const action : creator_action; var s : storage) : return is {
  assert_with_error(is_creator(Tezos.get_sender(), s), "FA2_INVALID_CREATOR_ACCESS");
} with case action of [
  | Create(params) -> create(params, s)
  | Renounce_creator -> renounce_creator(s)
];

(* Contract minter entrypoints *)
function minter_main (const action : minter_action; var s : storage) : return is {
  assert_with_error(is_minter(Tezos.get_sender(), s), "FA2_INVALID_MINTER_ACCESS");
} with case action of [
  | Mint(params) -> mint(params, s)
  | Renounce_minter -> renounce_minter(s)
];

(* Metadata manager entrypoints *)
function metadata_manager_main (const action : metadata_manager_action; var s : storage) : return is {
  assert_with_error(is_metadata_manager(Tezos.get_sender(), s), "FA2_INVALID_METADATA_MANAGER_ACCESS");
} with case action of [
  | Update_metadata(params) -> update_metadata(params, s)
  | Renounce_metadata_manager -> renounce_metadata_manager(s)
];

(* Royalties manager entrypoints *)
function royalties_manager_main (const action : royalties_manager_action; var s : storage) : return is {
  assert_with_error(is_royalties_manager(Tezos.get_sender(), s), "FA2_INVALID_ROYALTIES_MANAGER_ACCESS");
} with case action of [
  | Update_royalties(params) -> update_royalties(params, s)
  | Update_default_royalties(params) -> update_default_royalties(params, s)
  | Renounce_royalties_manager -> renounce_royalties_manager(s)
];

(* Main entrypoint *)
function fa2_plus_main (const action : entry_action; var s : storage) : return is {
  assert_with_error(Tezos.get_amount() = 0tz, "FA2_DONT_SEND_TEZ")
} with case action of [
  | Assets(params) -> block {
      const res : (list (operation) * token_storage) = fa2_main(params, s.assets);
      s.assets := res.1;
    } with (res.0, s)
  | Owner_action(params) -> owner_main(params, s)
  | Creator_action(params) -> creator_main(params, s)
  | Minter_action(params) -> minter_main(params, s)
  | Metadata_manager_action(params) -> metadata_manager_main(params, s)
  | Royalties_manager_action(params) -> royalties_manager_main(params, s)
  | Burn(params) -> burn(params, s)
  | Confirm_ownership -> confirm_ownership(s)
  | Internal_transfer_hook(params) -> internal_transfer_hook(params, s)
];
