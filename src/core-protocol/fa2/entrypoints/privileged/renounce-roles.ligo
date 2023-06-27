function renounce_roles (const params : renounce_roles_params; var s : storage) : return is {
  for renounce_role_params in list params {
    case renounce_role_params of [
    | Ownership -> {
        assert_with_error(is_owner(Tezos.get_sender(), s), "FA2_INVALID_OWNER_ACCESS");
        s.roles.owner := c_NULL_ADDRESS;
      }
    | Creator -> {
        assert_with_error(is_creator(Tezos.get_sender(), s), "FA2_INVALID_CREATOR_ACCESS");
        s.roles.creator := Set.remove(Tezos.get_sender(), s.roles.creator);
      }
    | Minter -> {
        assert_with_error(is_minter(Tezos.get_sender(), s), "FA2_INVALID_MINTER_ACCESS");
        s.roles.minter := Set.remove(Tezos.get_sender(), s.roles.minter);
      }
    | Metadata_manager -> {
        assert_with_error(is_metadata_manager(Tezos.get_sender(), s), "FA2_INVALID_METADATA_MANAGER_ACCESS");
        s.roles.metadata_manager := Set.remove(Tezos.get_sender(), s.roles.metadata_manager);
      }
    | Royalties_manager -> {
        assert_with_error(is_royalties_manager(Tezos.get_sender(), s), "FA2_INVALID_ROYALTIES_MANAGER_ACCESS");
        s.roles.royalties_manager := Set.remove(Tezos.get_sender(), s.roles.royalties_manager);
      }
    ]
  };
} with (nil, s)
