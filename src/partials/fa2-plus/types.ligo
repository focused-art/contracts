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

type permissions is
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

(* define return types for readability *)
type opReturn is list (operation)

(* define noop for readability *)
const noOperations: list (operation) = nil;

(* define return type for readability *)
type return is opReturn * storage

type owner_action is
  | Transfer_ownership of trusted
  | Renounce_ownership of unit
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

type creator_action is
  | Create of create_params
  | Renounce_creator of unit

type minter_action is
  | Mint of mint_burn_params
  | Renounce_minter of unit

type metadata_manager_action is
  | Update_metadata of update_token_metadata_params
  | Renounce_metadata_manager of unit

type royalties_manager_action is
  | Update_royalties of update_royalties_params
  | Update_default_royalties of royalties
  | Renounce_royalties_manager of unit

type entry_action is
  | Assets of token_action
  | Owner_action of owner_action
  | Creator_action of creator_action
  | Minter_action of minter_action
  | Metadata_manager_action of metadata_manager_action
  | Royalties_manager_action of royalties_manager_action
  | Confirm_ownership of unit
  | Burn of mint_burn_params
  | Internal_transfer_hook of transfer_params
