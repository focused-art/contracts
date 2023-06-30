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
function is_creator (const k : contract_address * address; const s : storage) : bool is
  case s.roles[k.0] of [
    Some(entry) -> entry.creator contains k.1
  | None -> False
  ]

[@view]
function is_minter (const k : contract_address * address; const s : storage) : bool is
  case s.roles[k.0] of [
    Some(entry) -> entry.minter contains k.1
  | None -> False
  ]

[@view]
function is_metadata_manager (const k : contract_address * address; const s : storage) : bool is
  case s.roles[k.0] of [
    Some(entry) -> entry.metadata_manager contains k.1
  | None -> False
  ]

[@view]
function is_royalties_manager (const k : contract_address * address; const s : storage) : bool is
  case s.roles[k.0] of [
    Some(entry) -> entry.royalties_manager contains k.1
  | None -> False
  ]

[@view]
function get_transfer_hooks (const k : contract_address; const s : storage) : set (trusted) is {
  var hooks : set (trusted) := (get_hooks(k, s)).transfer;
  for h in set s.protocol_hooks.transfer {
    hooks := Set.add(h, hooks);
  };
} with hooks

[@view]
function get_create_hooks (const k : contract_address; const s : storage) : set (trusted) is {
  var hooks : set (trusted) := (get_hooks(k, s)).create;
  for h in set s.protocol_hooks.create {
    hooks := Set.add(h, hooks);
  };
} with hooks

[@view]
function get_mint_hooks (const k : contract_address; const s : storage) : set (trusted) is {
  var hooks : set (trusted) := (get_hooks(k, s)).mint;
  for h in set s.protocol_hooks.mint {
    hooks := Set.add(h, hooks);
  };
} with hooks

[@view]
function get_burn_hooks (const k : contract_address; const s : storage) : set (trusted) is {
  var hooks : set (trusted) := (get_hooks(k, s)).burn;
  for h in set s.protocol_hooks.burn {
    hooks := Set.add(h, hooks);
  };
} with hooks

[@view]
function get_update_metadata_hooks (const k : contract_address; const s : storage) : set (trusted) is {
  var hooks : set (trusted) := (get_hooks(k, s)).update_metadata;
  for h in set s.protocol_hooks.update_metadata {
    hooks := Set.add(h, hooks);
  };
} with hooks
