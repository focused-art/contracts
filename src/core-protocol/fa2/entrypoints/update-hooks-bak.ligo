function iterate_update_hook (var s : storage; const params : update_hook_param) : storage is {
  assert_with_error(is_owner(Tezos.get_sender(), s), "FA2_INVALID_OWNER_ACCESS");
  case params of [
  | Add_transfer_hook(p) -> {
    (* Validate hook *)
    const _ : contract (transfer_params) = get_transfer_hook(p);
    s.hooks.transfer := Set.add(p, s.hooks.transfer);
  }
  | Remove_transfer_hook(p) -> {s.hooks.transfer := Set.remove(p, s.hooks.transfer)}
  | Add_create_hook(p) -> {
    (* Validate hook *)
    const _ : contract (create_params) = get_create_hook(p);
    s.hooks.create := Set.add(p, s.hooks.create);
  }
  | Remove_create_hook(p) -> {s.hooks.create := Set.remove(p, s.hooks.create)}
  | Add_mint_hook(p) -> {
    (* Validate hook *)
    const _ : contract (mint_burn_params) = get_mint_hook(p);
    s.hooks.mint := Set.add(p, s.hooks.mint);
  }
  | Remove_mint_hook(p) -> {s.hooks.mint := Set.remove(p, s.hooks.mint)}
  | Add_burn_hook(p) -> {
    (* Validate hook *)
    const _ : contract (mint_burn_params) = get_burn_hook(p);
    s.hooks.burn := Set.add(p, s.hooks.burn);
  }
  | Remove_burn_hook(p) -> {s.hooks.burn := Set.remove(p, s.hooks.burn)}
  | Add_update_metadata_hook(p) -> {
    (* Validate hook *)
    const _ : contract (update_token_metadata_params) = get_update_metadata_hook(p);
    s.hooks.update_metadata := Set.add(p, s.hooks.update_metadata);
  }
  | Remove_update_metadata_hook(p) -> {s.hooks.update_metadata := Set.remove(p, s.hooks.update_metadata)}
  ]
} with s

function update_hooks (const params : update_hooks_params; var s : storage) : return is
  (noops, List.fold(iterate_update_hook, params, s))

function update_hooks_as_constant (const params : update_hooks_params; var s : storage) : return is
  ((Tezos.constant("expru65xR5Woj7b3MNvCt6jECAHRNPU7m1b1uxLEswSR9nJtifuM2B") : update_hooks_params * storage -> return))(params, s)
