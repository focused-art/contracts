function update_hooks (const params : update_hooks_params; var s : storage) : return is {
  for entry in list params {
    const kt1 : contract_address = entry.0;
    const update_hook_param : update_hook_param = entry.1;
    const hooks : hooks = get_hooks(kt1, s);
    s.hooks[kt1] := case update_hook_param of [
      | Add(p) -> {
          assert_with_error(is_owner((kt1, Tezos.get_sender()), s), "FA_INVALID_ADD_HOOK_ACCESS");
        } with case p.0 of [
        | Transfer -> {
            (* Validate hook *)
            const _ : contract (transfer_params) = get_transfer_hook(p.1);
          } with hooks with record [ transfer = Set.add(p.1, hooks.transfer) ]
        | Create -> {
            (* Validate hook *)
            const _ : contract (create_params) = get_create_hook(p.1);
          } with hooks with record [ create = Set.add(p.1, hooks.create) ]
        | Mint -> {
            (* Validate hook *)
            const _ : contract (mint_burn_params) = get_mint_hook(p.1);
          } with hooks with record [ mint = Set.add(p.1, hooks.mint) ]
        | Burn -> {
            (* Validate hook *)
            const _ : contract (mint_burn_params) = get_burn_hook(p.1);
          } with hooks with record [ burn = Set.add(p.1, hooks.burn) ]
        | Metadata ->  {
            (* Validate hook *)
            const _ : contract (update_token_metadata_params) = get_update_metadata_hook(p.1);
          } with hooks with record [ update_metadata = Set.add(p.1, hooks.update_metadata) ]
      ]
      | Remove(p) -> {
          assert_with_error(is_revocable(p.1, p.0) = True, "FA_IRREVOCABLE_HOOK");
          assert_with_error(
            is_owner((kt1, Tezos.get_sender()), s) or
            p.1 = Tezos.get_sender(), "FA_INVALID_REMOVE_HOOK_ACCESS");
        } with case p.0 of [
        | Transfer -> hooks with record [ transfer = Set.remove(p.1, hooks.transfer) ]
        | Create -> hooks with record [ create = Set.remove(p.1, hooks.create) ]
        | Mint -> hooks with record [ mint = Set.remove(p.1, hooks.mint) ]
        | Burn -> hooks with record [ burn = Set.remove(p.1, hooks.burn) ]
        | Metadata -> hooks with record [ update_metadata = Set.remove(p.1, hooks.update_metadata) ]
      ]
    ];
  };
} with (nil, s)
