#include "transfer-ownership.ligo"
#include "update-contract-metadata.ligo"
#include "update-hooks.ligo"
#include "update-roles.ligo"

function owner_main (const action : owner_action; var s : storage) : return is {
  assert_with_error(is_owner(Tezos.get_sender(), s), "FA2_INVALID_OWNER_ACCESS");
} with case action of [
  | Transfer_ownership(params) -> transfer_ownership(params, s)
  | Update_roles(params) -> update_roles(params, s)
  | Update_hooks(params) -> update_hooks(params, s)
  | Update_contract_metadata(params) -> update_contract_metadata(params, s)
]

function owner_main_as_constant (const action : owner_action; var s : storage) : return is
  ((Tezos.constant("expruU5GvmZa1PfpPrwdXp4wECZBZ6TUUhYxuvJKBuWz3Bz5JtoVwL") : owner_action * storage -> return))((action, s))
