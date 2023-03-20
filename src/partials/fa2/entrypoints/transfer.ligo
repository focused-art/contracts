function transfer (const params : transfer_params; var s : token_storage) : token_return is {

  var balance_updates : map(owner * token_id, nat) := map [];

  (* initialize operations *)
  var operations : list (operation) := nil;

  for user_trx_params in list params {

    (* Perform single transfer *)
    for transfer in list user_trx_params.txs {
      (* Check permissions *)
      validate_operator(user_trx_params.from_, Tezos.get_sender(), transfer.token_id, s);

      (* Token id check *)
      validate_token_id(transfer.token_id, s);

      (* Balance check *)
      const sender_bal : nat = internal_get_balance_of(user_trx_params.from_, transfer.token_id, s);
      if sender_bal < transfer.amount then
        failwith("FA2_INSUFFICIENT_BALANCE");

      (* Track initial balance for update events *)
      if Map.mem((user_trx_params.from_, transfer.token_id), balance_updates) = False then {
        balance_updates[(user_trx_params.from_, transfer.token_id)] := sender_bal;
      };

      (* Update storage *)
      s.ledger[(user_trx_params.from_, transfer.token_id)] := abs(sender_bal - transfer.amount);

      (* Get destination balance *)
      var dest_bal : nat := internal_get_balance_of(transfer.to_, transfer.token_id, s);

      (* Track initial balance for update events *)
      if Map.mem((transfer.to_, transfer.token_id), balance_updates) = False then {
        balance_updates[(transfer.to_, transfer.token_id)] := dest_bal;
      };

      (* Update storage *)
      s.ledger[(transfer.to_, transfer.token_id)] := dest_bal + transfer.amount;

      (* Events *)
      const transfer_event : transfer_event = record [
        from_ = user_trx_params.from_;
        to_ = transfer.to_;
        token_id = transfer.token_id;
        amount = transfer.amount;
      ];
      operations := Tezos.emit("%transfer_event", transfer_event) # operations;
    };
  };

  (* Events *)
  for k -> old_balance in map balance_updates {
    const new_balance : nat = internal_get_balance_of(k.0, k.1, s);
    const balance_update_event : balance_update_event = record [
      owner = k.0;
      token_id = k.1;
      new_balance = new_balance;
      diff = new_balance - old_balance;
    ];
    operations := Tezos.emit("%balance_update", balance_update_event) # operations;
  };

} with (operations, s)

function transfer_with_hook (const params : transfer_params; var s : token_storage) : token_return is {
  var res : token_return := transfer(params, s);

  const transfer_hook_entrypoint : contract (transfer_params) =
    case (Tezos.get_entrypoint_opt("%internal_transfer_hook", Tezos.get_self_address()) : option(contract(transfer_params))) of [
      None -> failwith ("FA2_INTERNAL_TRANSFER_HOOK_UNDEFINED")
    | Some(entrypoint) -> entrypoint
    ];
  const hook_operation : operation = Tezos.transaction (params, 0tz, transfer_hook_entrypoint);
  res.0 := hook_operation # res.0;

} with (res.0, res.1)

function transfer_as_constant (const params : transfer_params; var s : token_storage) : token_return is
  ((Tezos.constant("exprtmSbRhT6JR681qvH4znr4fGLbxv9vfkxfZgnCentVHJqGL3t15") : transfer_params * token_storage -> token_return))((params, s))

function transfer_with_hook_as_constant (const params : transfer_params; var s : token_storage) : token_return is
  ((Tezos.constant("exprurWrrDJ7XUviRYk4uTyAVW74BMnfKADEHyWxkkoyfnhcGWG366") : transfer_params * token_storage -> token_return))((params, s))
