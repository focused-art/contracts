type token_id is [@annot:token_id] nat
type token_ids is set (token_id)
type owner is address
type operator is address
type royalty_shares is map (address, nat)
type token_info is map (string, bytes)

type royalties is
  [@layout:comb]
  record [
    total_shares              : nat;
    shares                    : royalty_shares;
  ]

type token_metadata is
  [@layout:comb]
  record [
    token_id                  : token_id;
    token_info                : token_info;
  ]

type transfer_destination is
  [@layout:comb]
  record [
    to_                       : address;
    token_id                  : token_id;
    amount                    : nat;
  ]

type transfer_param is
  [@layout:comb]
  record [
    from_                     : owner;
    txs                       : list (transfer_destination);
  ]

type balance_of_request is
  [@layout:comb]
  record [
    owner                     : owner;
    token_id                  : token_id;
  ]

type balance_of_response is
  [@layout:comb]
  record [
    request                   : balance_of_request;
    balance                   : nat;
  ]

type balance_params is
  [@layout:comb]
  record [
    requests                  : list (balance_of_request);
    callback                  : contract (list (balance_of_response));
  ]

type operator_param is
  [@layout:comb]
  record [
    owner                     : owner;
    operator                  : operator;
    token_id                  : token_id;
  ]

type update_operator_param is
  | Add_operator              of operator_param
  | Remove_operator           of operator_param

type transfer_params is list (transfer_param)
type update_operator_params is list (update_operator_param)

type assert_balance_param is
  [@layout:comb]
  record [
    owner                     : owner;
    token_id                  : token_id;
    balance                   : nat;
  ]

type assert_balance_params is list (assert_balance_param)

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

(* contract storage *)
type storage is
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

type operator_update_event is
  [@layout:comb]
  record [
    owner                     : owner;
    operator                  : operator;
    token_id                  : token_id;
    is_operator               : bool;
  ]

type transfer_event is
  [@layout:comb]
  record [
    from_                     : owner;
    to_                       : address;
    token_id                  : token_id;
    amount                    : nat;
  ]

type balance_update_event is
  [@layout:comb]
  record [
    owner                     : owner;
    token_id                  : token_id;
    new_balance               : nat;
    diff                      : int;
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
type return is op_list * storage

type privileged_action is
  | Update_contract_metadata  of map (string, bytes)
  | Update_metadata           of update_token_metadata_params
  | Update_royalties          of update_royalties_params
  | Update_default_royalties  of royalties

type entry_action is
  | Privileged_action         of privileged_action
  | Transfer                  of transfer_params
  | Balance_of                of balance_params
  | Update_operators          of update_operator_params
  | Assert_balances           of assert_balance_params
  | Create                    of create_params
  | Mint                      of mint_burn_params
  | Burn                      of mint_burn_params
