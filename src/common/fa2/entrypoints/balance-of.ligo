function balance_of (const balance_params : balance_params; const s : token_storage) : token_return is {

  var accumulated_response : list (balance_of_response) := nil;

  for request in list balance_params.requests {
    (* Token id check *)
    validate_token_id(request.token_id, s);

    (* Form the response *)
    const response : balance_of_response = record [
      request   = request;
      balance   = internal_get_balance_of(request.owner, request.token_id, s);
    ];

    accumulated_response := response # accumulated_response;
  };

} with (list [ Tezos.transaction(accumulated_response, 0tz, balance_params.callback) ], s)

function balance_of_as_constant (const params : balance_params; const s : token_storage) : token_return is
  ((Tezos.constant("exprukzUFbkRrZjG8YF4zbrwWbr3cYubfqsWsDDSqzL9pBsGqy7QHJ") : balance_params * token_storage -> token_return))((params, s))