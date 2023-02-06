type trusted is address

type create_params is
  [@layout:comb]
  record [
    token_metadata            : token_metadata;
    royalties                 : royalties;
  ]

type update_royalties_params is map (token_id, royalties)
type update_token_metadata_params is map (token_id, token_metadata)

type mint_burn_tx is
  [@layout:comb]
  record [
    owner                     : address;
    token_id                  : token_id;
    amount                    : nat;
  ]

type mint_burn_params is list (mint_burn_tx)

type update_role_param is
  | Add_minter of trusted
  | Remove_minter of trusted
  | Add_creator of trusted
  | Remove_creator of trusted
  | Add_metadata_manager of trusted
  | Remove_metadata_manager of trusted
  | Add_royalties_manager of trusted
  | Remove_royalties_manager of trusted
  | Add_transfer_hook of trusted
  | Remove_transfer_hook of trusted

type update_roles_params is list (update_role_param)

type renounce_role_params is
  | Renounce_ownership of unit
  | Renounce_creator of unit
  | Renounce_minter of unit
  | Renounce_metadata_manager of unit
  | Renounce_royalties_manager of unit

type renounce_roles_params is list (renounce_role_params)

type permissions is
  [@layout:comb]
  record [
    owner                     : trusted;
    pending_owner             : option (address);
    creator                   : set (trusted);
    minter                    : set (trusted);
    metadata_manager          : set (trusted);
    royalties_manager         : set (trusted);
    transfer_hook             : set (trusted);
  ]

(* contract storage *)
type storage is
  [@layout:comb]
  record [
    metadata                  : big_map (string, bytes);
    roles                     : permissions;
    assets                    : token_storage;
    default_royalties         : royalties;
  ]

(* define return type for readability *)
type return is list (operation) * storage

type entry_action is
  | Assets of token_action
  | Transfer_ownership of trusted
  | Update_roles of update_roles_params
  | Renounce_roles of renounce_roles_params
  | Create of create_params
  | Mint of mint_burn_params
  | Update_metadata of update_token_metadata_params
  | Update_royalties of update_royalties_params
  | Update_default_royalties of royalties
  | Confirm_ownership of unit
  | Burn of mint_burn_params
  | Internal_transfer_hook of transfer_params
