(* Freeze a token *)
function freeze (const params : freeze_params; var s : storage) : return is {

  (* Only fa2 operator can call *)
  const operator_param : operator_param = record [
    owner = params.owner;
    operator = Tezos.get_sender();
    token_id = params.token.token_id;
  ];
  assert_with_error(is_fa2_operator(params.token, operator_param), "FA_NOT_FA2_OPERATOR");

  (* Must be a transfer hook *)
  assert_with_error(is_fa2_transfer_hook(params.token, Tezos.get_self_address()), "FA_NOT_FA2_TRANSFER_HOOK");

  (* Must be a burn hook *)
  assert_with_error(is_fa2_burn_hook(params.token, Tezos.get_self_address()), "FA_NOT_FA2_BURN_HOOK");

  (* Update storage *)
  s.frozen_tokens[(params.owner, params.token)] := case s.frozen_tokens[(params.owner, params.token)] of [
    Some(t) -> ts_max(t, params.freeze_until)
  | None -> params.freeze_until
  ];

} with (noops, s)
