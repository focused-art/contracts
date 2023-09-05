(* Views *)
[@view]
function get_owner (const k : contract_address; const s : storage) : trusted is
  case s.roles[k] of [
    Some(entry) -> entry.owner
  | None -> c_NULL_ADDRESS
  ]

[@view]
function is_owner (const k : contract_address * address; const s : storage) : bool is
  case s.roles[k.0] of [
    Some(entry) -> entry.owner = k.1
  | None -> False
  ]

[@view]
function has_role (const k : contract_address * address * role_type; const s : storage) : bool is
  case s.roles[k.0] of [
    Some(roles) -> case k.2 of [
      | Creator             -> roles.creator contains k.1
      | Minter              -> roles.minter contains k.1
      | Metadata_manager    -> roles.metadata_manager contains k.1
      | Royalties_manager   -> roles.royalties_manager contains k.1
    ]
  | None -> False
  ]

[@view]
function get_hooks (const k : contract_address * hook_type; const s : storage) : set (trusted) is
  case k.1 of [
  | Transfer_hook -> {
      var hooks : set (trusted) := (internal_get_hooks(k.0, s)).transfer;
      for h in set s.protocol_hooks.transfer {
        hooks := Set.add(h, hooks);
      };
    } with hooks
  | Create_hook -> {
      var hooks : set (trusted) := (internal_get_hooks(k.0, s)).create;
      for h in set s.protocol_hooks.create {
        hooks := Set.add(h, hooks);
      };
    } with hooks
  | Mint_hook -> {
      var hooks : set (trusted) := (internal_get_hooks(k.0, s)).mint;
      for h in set s.protocol_hooks.mint {
        hooks := Set.add(h, hooks);
      };
    } with hooks
  | Burn_hook -> {
      var hooks : set (trusted) := (internal_get_hooks(k.0, s)).burn;
      for h in set s.protocol_hooks.burn {
        hooks := Set.add(h, hooks);
      };
    } with hooks
  | Metadata_hook -> {
      var hooks : set (trusted) := (internal_get_hooks(k.0, s)).update_metadata;
      for h in set s.protocol_hooks.update_metadata {
        hooks := Set.add(h, hooks);
      };
    } with hooks
  ]
