function balance_of (const balance_params : balance_params; const s : token_storage) : token_return is {

  (* Perform single balance lookup *)
  function look_up_balance(const l: list (balance_of_response); const request : balance_of_request) : list (balance_of_response) is {
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

} with (list [ Tezos.transaction(accumulated_response, 0tz, balance_params.callback) ], s)

function balance_of_as_constant (const params : balance_params; const s : token_storage) : token_return is
  ((Tezos.constant("exprv7Poi6dBzxoHe5SBiHXynjG2onFGABGf2o1UzjFVRjAuCY1V8P") : balance_params * token_storage -> token_return))(params, s)
