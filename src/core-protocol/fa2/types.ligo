type trusted is address

type create_params is
  [@layout:comb]
  record [
    token_metadata            : token_metadata;
    royalties                 : royalties;
    max_supply                : nat;
  ]

type update_royalties_params is map (token_id, royalties)
type update_token_metadata_params is map (token_id, token_metadata)

type mint_burn_params is
  [@layout:comb]
  record [
    owner                     : address;
    token_id                  : token_id;
    amount                    : nat;
  ]

type role_type is
  | Creator
  | Minter
  | Metadata_manager
  | Royalties_manager

type update_role_param is
  | Add of role_type * trusted
  | Remove of role_type * trusted

type update_roles_params is list (update_role_param)

type renounce_role_params is
  | Ownership of unit
  | Creator of unit
  | Minter of unit
  | Metadata_manager of unit
  | Royalties_manager of unit

type renounce_roles_params is list (renounce_role_params)

type hook_type is
  | Transfer
  | Create
  | Mint
  | Burn
  | Metadata

type update_hook_param is
  | Add of hook_type * trusted
  | Remove of hook_type * trusted

type update_hooks_params is list (update_hook_param)

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

type hooks is
  [@layout:comb]
  record [
    transfer                  : set (trusted);
    create                    : set (trusted);
    mint                      : set (trusted);
    burn                      : set (trusted);
    update_metadata           : set (trusted);
  ]

(* contract storage *)
type storage is
  [@layout:comb]
  record [
    metadata                  : big_map (string, bytes);
    roles                     : permissions;
    hooks                     : hooks;
    assets                    : token_storage;
    token_max_supply          : big_map (token_id, nat);
    default_royalties         : royalties;
  ]

type token_metadata_update_event is
  [@layout:comb]
  record [
    token_id                  : token_id;
    new_metadata              : option (token_info);
  ]

type token_royalties_update_event is
  [@layout:comb]
  record [
    token_id                  : token_id;
    new_royalties             : option (royalties);
  ]

type owner_diff is
  [@layout:comb]
  record [
    owner                     : owner;
    owner_diff                : int;
  ]

type total_supply_update_event is
  [@layout:comb]
  record [
    [@annot] owner_diffs      : list (owner_diff);
    token_id                  : token_id;
    new_total_supply          : nat;
    diff                      : int;
  ]

(* define return type for readability *)
type return is list (operation) * storage

type owner_action is
  | Transfer_ownership of trusted
  | Update_roles of update_roles_params
  | Update_hooks of update_hooks_params

type entry_action is
  | Assets of token_action
  | Owner_action of owner_action
  | Renounce_roles of renounce_roles_params
  | Create of create_params
  | Mint of mint_burn_params
  | Update_metadata of update_token_metadata_params
  | Update_royalties of update_royalties_params
  | Update_default_royalties of royalties
  | Confirm_ownership of unit
  | Burn of mint_burn_params
  | Internal_transfer_hook of transfer_params
