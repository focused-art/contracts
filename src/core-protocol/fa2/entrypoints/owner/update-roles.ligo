function update_roles (const params : update_roles_params; var s : storage) : return is {
  for update_role_param in list params {
    case update_role_param of [
      | Add(p) -> case p.0 of [
        | Creator -> { s.roles.creator := Set.add(p.1, s.roles.creator) }
        | Minter -> { s.roles.minter := Set.add(p.1, s.roles.minter) }
        | Metadata_manager -> { s.roles.metadata_manager := Set.add(p.1, s.roles.metadata_manager) }
        | Royalties_manager -> { s.roles.royalties_manager := Set.add(p.1, s.roles.royalties_manager) }
      ]
      | Remove(p) -> case p.0 of [
        | Creator -> { s.roles.creator := Set.remove(p.1, s.roles.creator) }
        | Minter -> { s.roles.minter := Set.remove(p.1, s.roles.minter) }
        | Metadata_manager -> { s.roles.metadata_manager := Set.remove(p.1, s.roles.metadata_manager) }
        | Royalties_manager -> { s.roles.royalties_manager := Set.remove(p.1, s.roles.royalties_manager) }
      ]
    ];
  };
} with (nil, s)
