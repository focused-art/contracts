type permissions is
  [@layout:comb]
  record [
    owner                     : trusted;
    pending_owner             : option (address);
    creator                   : set (trusted);
    minter                    : set (trusted);
    metadata_manager          : set (trusted);
    royalties_manager         : set (trusted);
  ]

type revocable is bool

type hooks is
  [@layout:comb]
  record [
    transfer                  : set (trusted);
    create                    : set (trusted);
    mint                      : set (trusted);
    burn                      : set (trusted);
    update_metadata           : set (trusted);
  ]

type fa2_storage is
  [@layout:comb]
  record [
    metadata                  : big_map (string, bytes);
    protocol                  : trusted;
    next_token_id             : nat;
    token_total_supply        : big_map (token_id, nat);
    ledger                    : big_map (owner * token_id, nat);
    operators                 : big_map (owner * (operator * token_id), unit);
    token_metadata            : big_map (token_id, token_metadata);
    royalties                 : big_map (token_id, royalties);
    token_max_supply          : big_map (token_id, nat);
    default_royalties         : royalties;
  ]

type create_fa2 is (option (key_hash) * tez * fa2_storage) -> (operation * address)

(* contract storage *)
type storage is
  [@layout:comb]
  record [
    metadata                  : big_map (string, bytes);
    roles                     : big_map (contract_address, permissions);
    hooks                     : big_map (contract_address, hooks);
    protocol_hooks            : hooks;
  ]

(* define return type for readability *)
type return is op_list * storage

type role_type is
  | Creator
  | Minter
  | Metadata_manager
  | Royalties_manager

type update_role_param is
  | Add                       of role_type * trusted
  | Remove                    of role_type * trusted

type update_roles_params is list ((contract_address * update_role_param))

type renounce_role_params is
  | Ownership                 of unit
  | Creator                   of unit
  | Minter                    of unit
  | Metadata_manager          of unit
  | Royalties_manager         of unit

type renounce_roles_params is list ((contract_address * renounce_role_params))

type hook_type is
  | Transfer
  | Create
  | Mint
  | Burn
  | Metadata

type update_hook_param is
  | Add                       of hook_type * trusted
  | Remove                    of hook_type * trusted

type update_hooks_params is list ((contract_address * update_hook_param))

type entry_action is
  | Init                      of map (string, bytes)
  | Transfer_ownership        of contract_address * trusted
  | Update_roles              of update_roles_params
  | Renounce_roles            of renounce_roles_params
  | Update_hooks              of update_hooks_params
  | Confirm_ownership         of contract_address
