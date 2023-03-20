function update_hooks (const params : update_hooks_params; var s : storage) : return is {
  for update_hook_param in list params {
    case update_hook_param of [
      | Add(p) -> case p.0 of [
        | Transfer -> {
            (* Validate hook *)
            const _ : contract (transfer_params) = get_transfer_hook(p.1);
            s.hooks.transfer := Set.add(p.1, s.hooks.transfer);
          }
        | Create -> {
            (* Validate hook *)
            const _ : contract (create_params) = get_create_hook(p.1);
            s.hooks.create := Set.add(p.1, s.hooks.create);
          }
        | Mint -> {
            (* Validate hook *)
            const _ : contract (mint_burn_params) = get_mint_hook(p.1);
            s.hooks.mint := Set.add(p.1, s.hooks.mint);
          }
        | Burn -> {
            (* Validate hook *)
            const _ : contract (mint_burn_params) = get_burn_hook(p.1);
            s.hooks.burn := Set.add(p.1, s.hooks.burn);
          }
        | Metadata ->  {
            (* Validate hook *)
            const _ : contract (update_token_metadata_params) = get_update_metadata_hook(p.1);
            s.hooks.update_metadata := Set.add(p.1, s.hooks.update_metadata);
          }
      ]
      | Remove(p) -> case p.0 of [
        | Transfer -> { s.hooks.transfer := Set.remove(p.1, s.hooks.transfer) }
        | Create -> { s.hooks.create := Set.remove(p.1, s.hooks.create) }
        | Mint -> { s.hooks.mint := Set.remove(p.1, s.hooks.mint) }
        | Burn -> { s.hooks.burn := Set.remove(p.1, s.hooks.burn) }
        | Metadata -> { s.hooks.update_metadata := Set.remove(p.1, s.hooks.update_metadata) }
      ]
    ];
  };
} with (noops, s)

function update_hooks_as_constant (const params : update_hooks_params; var s : storage) : return is
  ((Tezos.constant("exprttCguv4TKwQS93vpQvmQKp5RDdZigsRSPz4BU9unYrqZMq7ZuW") : update_hooks_params * storage -> return))((params, s))
