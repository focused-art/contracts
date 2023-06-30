function update_roles (const params : update_roles_params; var s : storage) : return is {
  for entry in list params {
    const kt1 : contract_address = entry.0;
    const update_role_param : update_role_param = entry.1;
    assert_with_error(is_owner((kt1, Tezos.get_sender()), s), "FA2_INVALID_OWNER_ACCESS");
    const permissions : permissions = get_permissions_or_fail(kt1, s);
    s.roles[kt1] := case update_role_param of [
      | Add(p) -> case p.0 of [
        | Creator -> permissions with record [ creator = Set.add(p.1, permissions.creator) ]
        | Minter -> permissions with record [ minter = Set.add(p.1, permissions.minter) ]
        | Metadata_manager -> permissions with record [ metadata_manager = Set.add(p.1, permissions.metadata_manager) ]
        | Royalties_manager -> permissions with record [ royalties_manager = Set.add(p.1, permissions.royalties_manager) ]
      ]
      | Remove(p) -> case p.0 of [
        | Creator -> permissions with record [ creator = Set.remove(p.1, permissions.creator) ]
        | Minter -> permissions with record [ minter = Set.remove(p.1, permissions.minter) ]
        | Metadata_manager -> permissions with record [ metadata_manager = Set.remove(p.1, permissions.metadata_manager) ]
        | Royalties_manager -> permissions with record [ royalties_manager = Set.remove(p.1, permissions.royalties_manager) ]
      ]
    ];
  };
} with (nil, s)
