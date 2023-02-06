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

#if FA2__TRANSFER_HOOK
function transfer (const params : transfer_params; var s : token_storage) : token_return is {
  const transfer_hook_entrypoint : contract (transfer_params) =
    case (Tezos.get_entrypoint_opt("%internal_transfer_hook", Tezos.get_self_address()) : option(contract(transfer_params))) of [
      None -> failwith ("FA2_INTERNAL_TRANSFER_HOOK_UNDEFINED")
    | Some(entrypoint) -> entrypoint
    ];
  const hook_operation : operation = Tezos.transaction (params, 0tz, transfer_hook_entrypoint);
} with (list [hook_operation], List.fold(iterate_transfer, params, s))
#else
function transfer (const params : transfer_params; var s : token_storage) : token_return is
  (noops, List.fold(iterate_transfer, params, s))
#endif

#if FA2__TRANSFER_HOOK
function transfer_as_constant (const params : transfer_params; var s : token_storage) : token_return is
  ((Tezos.constant("exprv4kvcKTSCUszCEALnwFuwEA5qbgFwNx2m31YpW532icu9c5SqA") : transfer_params * token_storage -> token_return))(params, s)
#else
function transfer_as_constant (const params : transfer_params; var s : token_storage) : token_return is
  ((Tezos.constant("exprtnG1aeWRoYSqN8V5XP4BQiHndpSjWgCr1XkbFbXHriESy2cfTP") : transfer_params * token_storage -> token_return))(params, s)
#endif
