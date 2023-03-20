#include "transfer-ownership.ligo"
#include "update-hooks.ligo"
#include "update-roles.ligo"

function owner_main (const action : owner_action; var s : storage) : return is {
  assert_with_error(is_owner(Tezos.get_sender(), s), "FA2_INVALID_OWNER_ACCESS");
} with case action of [
  | Transfer_ownership(params) -> transfer_ownership(params, s)
  | Update_roles(params) -> update_roles(params, s)
  | Update_hooks(params) -> update_hooks(params, s)
]

function owner_main_as_constant (const action : owner_action; var s : storage) : return is {
  assert_with_error(is_owner(Tezos.get_sender(), s), "FA2_INVALID_OWNER_ACCESS");
} with case action of [
  | Transfer_ownership(params) -> transfer_ownership_as_constant(params, s)
  | Update_roles(params) -> update_roles_as_constant(params, s)
  | Update_hooks(params) -> update_hooks_as_constant(params, s)
]
