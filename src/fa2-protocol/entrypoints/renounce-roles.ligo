function renounce_roles (const params : renounce_roles_params; var s : storage) : return is {
  for entry in list params {
    const kt1 : contract_address = entry.0;
    const renounce_role_params : renounce_role_params = entry.1;
    const permissions : permissions = get_permissions_or_fail(kt1, s);
    s.roles[kt1] := case renounce_role_params of [
    | Ownership -> {
        assert_with_error(is_owner((kt1, Tezos.get_sender()), s), "FA2_INVALID_OWNER_ACCESS");
      } with permissions with record [ owner = c_NULL_ADDRESS ]
    | Creator -> {
        assert_with_error(has_role((kt1, Tezos.get_sender(), Creator), s), "FA2_INVALID_CREATOR_ACCESS");
      } with permissions with record [ creator = Set.remove(Tezos.get_sender(), permissions.creator) ]
    | Minter -> {
        assert_with_error(has_role((kt1, Tezos.get_sender(), Minter), s), "FA2_INVALID_MINTER_ACCESS");
      } with permissions with record [ minter = Set.remove(Tezos.get_sender(), permissions.minter) ]
    | Metadata_manager -> {
        assert_with_error(has_role((kt1, Tezos.get_sender(), Metadata_manager), s), "FA2_INVALID_METADATA_MANAGER_ACCESS");
      } with permissions with record [ metadata_manager = Set.remove(Tezos.get_sender(), permissions.metadata_manager) ]
    | Royalties_manager -> {
        assert_with_error(has_role((kt1, Tezos.get_sender(), Royalties_manager), s), "FA2_INVALID_ROYALTIES_MANAGER_ACCESS");
      } with permissions with record [ royalties_manager = Set.remove(Tezos.get_sender(), permissions.royalties_manager) ]
    ]
  };
} with (nil, s)
