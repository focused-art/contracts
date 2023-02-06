(* Define types *)

type token_id is [@annot:token_id] nat
type owner is address
type operator is address

type royalty_shares is map (address, nat)

type royalties is
  [@layout:comb]
  record [
    total_shares              : nat;
    shares                    : royalty_shares;
  ]

type token_metadata is
  [@layout:comb]
  record [
    token_id            : token_id;
    token_info          : map (string, bytes);
  ]

type token_storage is
  [@layout:comb]
  record [
    next_token_id             : nat;
    token_total_supply        : big_map (token_id, nat);
    ledger                    : big_map (owner * token_id, nat);
    operators                 : big_map (owner * (operator * token_id), unit);
    token_metadata            : big_map (token_id, token_metadata);
    royalties                 : big_map (token_id, royalties);
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
    from_                     : address;
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
  | Add_operator    of operator_param
  | Remove_operator of operator_param

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

type token_action is
  | Transfer                of transfer_params
  | Balance_of              of balance_params
  | Update_operators        of update_operator_params
  | Assert_balances         of assert_balance_params

(* define return type for readability *)
type token_return is list (operation) * token_storage
