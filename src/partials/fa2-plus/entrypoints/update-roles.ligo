function iterate_update_role (var s : storage; const params : update_role_param) : storage is {
  assert_with_error(is_owner(Tezos.get_sender(), s), "FA2_INVALID_OWNER_ACCESS");
  case params of [
  | Add_minter(p) -> {s.roles.minter := Set.add(p, s.roles.minter)}
  | Remove_minter(p) -> {s.roles.minter := Set.remove(p, s.roles.minter)}
  | Add_creator(p) -> {s.roles.creator := Set.add(p, s.roles.creator)}
  | Remove_creator(p) -> {s.roles.creator := Set.remove(p, s.roles.creator)}
  | Add_metadata_manager(p) -> {s.roles.metadata_manager := Set.add(p, s.roles.metadata_manager)}
  | Remove_metadata_manager(p) -> {s.roles.metadata_manager := Set.remove(p, s.roles.metadata_manager)}
  | Add_royalties_manager(p) -> {s.roles.royalties_manager := Set.add(p, s.roles.royalties_manager)}
  | Remove_royalties_manager(p) -> {s.roles.royalties_manager := Set.remove(p, s.roles.royalties_manager)}
  | Add_transfer_hook(p) -> {
    (* Validate transfer hook *)
    const _ : contract (transfer_params) = get_transfer_hook(p);
    s.roles.transfer_hook := Set.add(p, s.roles.transfer_hook);
  }
  | Remove_transfer_hook(p) -> {s.roles.transfer_hook := Set.remove(p, s.roles.transfer_hook)}
  ]
} with s

function update_roles (const params : update_roles_params; var s : storage) : return is
  (noops, List.fold(iterate_update_role, params, s))

function update_roles_as_constant (const params : update_roles_params; var s : storage) : return is
  ((Tezos.constant("exprufmDLCvhJK7qcj3DYqguxk7mau2t4qrEfj1cDqCAbmLHLdi8dg") : update_roles_params * storage -> return))(params, s)
