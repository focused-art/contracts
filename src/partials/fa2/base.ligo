#include "types.ligo"

(* Helper function to get token total supply *)
function internal_get_token_total_supply (const token_id : token_id; const s : token_storage) : nat is
  case s.token_total_supply[token_id] of [
    None -> 0n
  | Some(supply) -> supply
  ];

(* Helper function to get token balance *)
function internal_get_balance_of (const owner : owner; const token_id : token_id; const s : token_storage) : nat is
  case s.ledger[(owner, token_id)] of [
    None -> 0n
  | Some(bal) -> bal
  ];

function internal_is_operator (const owner : owner; const operator : operator; const token_id : token_id; const s : token_storage) : bool is
  owner = operator or Big_map.mem ((owner, (operator, token_id)), s.operators)

(* helper functions for validations *)

function validate_operator (const owner : owner; const operator : operator; const token_id : token_id; const s : token_storage) : unit is
  if internal_is_operator(owner, operator, token_id, s) = False then
    failwith ("FA2_NOT_OPERATOR")
  else Unit;

function validate_owner (const owner : owner) : unit is
  if Tezos.get_sender() =/= owner then
    failwith ("FA2_NOT_OWNER")
  else Unit;

function validate_token_id (const token_id : token_id; const s : token_storage) : unit is
  if token_id >= s.next_token_id then
    failwith ("FA2_TOKEN_UNDEFINED")
  else Unit;

(* Perform transfers from one owner *)
function iterate_transfer (var s : token_storage; const user_trx_params : transfer_param) : token_storage is
  block {

    (* Perform single transfer *)
    function make_transfer(var s : token_storage; const transfer : transfer_destination) : token_storage is
      block {
        (* Check permissions *)
        validate_operator(user_trx_params.from_, Tezos.get_sender(), transfer.token_id, s);

        (* Token id check *)
        validate_token_id(transfer.token_id, s);

        (* Balance check *)
        const sender_bal : nat = internal_get_balance_of(user_trx_params.from_, transfer.token_id, s);
        if sender_bal < transfer.amount then
          failwith("FA2_INSUFFICIENT_BALANCE");

        (* Update storage *)
        s.ledger[(user_trx_params.from_, transfer.token_id)] := abs(sender_bal - transfer.amount);

        (* Get destination balance *)
        var dest_bal : nat := internal_get_balance_of(transfer.to_, transfer.token_id, s);

        (* Update storage *)
        s.ledger[(transfer.to_, transfer.token_id)] := dest_bal + transfer.amount;
    } with s;

} with (List.fold (make_transfer, user_trx_params.txs, s))

(* Perform single operator update *)
function iterate_update_operator (var s : token_storage; const params : update_operator_param) : token_storage is
  block {
    case params of [
    | Add_operator(param) -> {
      validate_token_id(param.token_id, s);
      validate_owner(param.owner);
      s.operators := Big_map.update((param.owner, (param.operator, param.token_id)), Some (Unit), s.operators);
    }
    | Remove_operator(param) -> {
      validate_token_id(param.token_id, s);
      validate_owner(param.owner);
      s.operators := Big_map.remove((param.owner, (param.operator, param.token_id)), s.operators);
    }
    ]
  } with s

(* Perform balance look up *)
function get_balance_of (const balance_params : balance_params; const s : token_storage) : list(operation) is
  block {

    (* Perform single balance lookup *)
    function look_up_balance(const l: list (balance_of_response); const request : balance_of_request) : list (balance_of_response) is
      block {
        (* Token id check *)
        validate_token_id(request.token_id, s);

        (* Form the response *)
        const response : balance_of_response = record [
          request   = request;
          balance   = internal_get_balance_of(request.owner, request.token_id, s);
        ];
      } with response # l;

    (* Collect balances info *)
    const accumulated_response : list (balance_of_response) = List.fold(look_up_balance, balance_params.requests, (nil: list(balance_of_response)));
  } with list [ Tezos.transaction(accumulated_response, 0tz, balance_params.callback) ]

(* Assert balance or fail *)
function iterate_assert_balance (const s : token_storage; const params : assert_balance_param) : token_storage is
  block {
    if internal_get_balance_of(params.owner, params.token_id, s) < params.balance then
      failwith("FA2_INSUFFICIENT_BALANCE");
  } with s

function fa2_main (const action : token_action; var s : token_storage) : list (operation) * token_storage is
  block {
    skip
  } with case action of [
#if FA2__TRANSFER_HOOK
    | Transfer(params)                  -> block {
        const transfer_hook_entrypoint : contract (transfer_params) =
          case (Tezos.get_entrypoint_opt("%internal_transfer_hook", Tezos.get_self_address()) : option(contract(transfer_params))) of [
            None -> failwith ("FA2_INTERNAL_TRANSFER_HOOK_UNDEFINED")
          | Some(entrypoint) -> entrypoint
          ];
        const hook_operation : operation = Tezos.transaction (params, 0tz, transfer_hook_entrypoint);
      } with (list [hook_operation], List.fold(iterate_transfer, params, s))
#else
    | Transfer(params)                  -> ((nil : list (operation)), List.fold(iterate_transfer, params, s))
#endif
    | Balance_of(params)                -> (get_balance_of(params, s), s)
    | Update_operators(params)          -> ((nil : list (operation)), List.fold(iterate_update_operator, params, s))
    | Assert_balances(params)           -> ((nil : list (operation)), List.fold(iterate_assert_balance, params, s))
    ];

(* Views *)
#if !FA2__VIEWS
[@view]
function get_balance (const params : balance_of_request; const s : token_storage) : nat is
  internal_get_balance_of(params.owner, params.token_id, s)

[@view]
function total_supply (const token_id : token_id; const s : token_storage) : nat is
  internal_get_token_total_supply(token_id, s)

[@view]
function is_operator (const params : operator_param; const s : token_storage) : bool is
  internal_is_operator(params.owner, params.operator, params.token_id, s)
#endif
