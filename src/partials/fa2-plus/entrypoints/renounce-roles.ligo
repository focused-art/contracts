function iterate_renounce_role (var s : storage; const params : renounce_role_params) : storage is {
  case params of [
  | Renounce_ownership -> {
      assert_with_error(is_owner(Tezos.get_sender(), s), "FA2_INVALID_OWNER_ACCESS");
      s.roles.owner := c_NULL_ADDRESS;
    }
  | Renounce_creator -> {
      assert_with_error(is_creator(Tezos.get_sender(), s), "FA2_INVALID_CREATOR_ACCESS");
      s.roles.creator := Set.remove(Tezos.get_sender(), s.roles.creator);
    }
  | Renounce_minter -> {
      assert_with_error(is_minter(Tezos.get_sender(), s), "FA2_INVALID_MINTER_ACCESS");
      s.roles.minter := Set.remove(Tezos.get_sender(), s.roles.minter);
    }
  | Renounce_metadata_manager -> {
      assert_with_error(is_metadata_manager(Tezos.get_sender(), s), "FA2_INVALID_METADATA_MANAGER_ACCESS");
      s.roles.metadata_manager := Set.remove(Tezos.get_sender(), s.roles.metadata_manager);
    }
  | Renounce_royalties_manager -> {
      assert_with_error(is_royalties_manager(Tezos.get_sender(), s), "FA2_INVALID_ROYALTIES_MANAGER_ACCESS");
      s.roles.royalties_manager := Set.remove(Tezos.get_sender(), s.roles.royalties_manager);
    }
  ]
} with s

function renounce_roles (const params : renounce_roles_params; var s : storage) : return is
  (noops, List.fold(iterate_renounce_role, params, s))

function renounce_roles_as_constant (const params : renounce_roles_params; var s : storage) : return is
  ((Tezos.constant("exprumejcVu4H2uwFYbWR6V8uCEgygP6Tb7HRpZPYxXh18P5t6fyev") : renounce_roles_params * storage -> return))(params, s)
