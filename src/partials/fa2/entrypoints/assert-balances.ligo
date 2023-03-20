function assert_balances (const params : assert_balance_params; const s : token_storage) : token_return is {
  for param in list params {
    assert_with_error(internal_get_balance_of(param.owner, param.token_id, s) >= param.balance, "FA2_INSUFFICIENT_BALANCE")
  };
} with (noops, s)

function assert_balances_as_constant (const params : assert_balance_params; var s : token_storage) : token_return is
  ((Tezos.constant("exprv1W3deX8DGQTE1kScuwH9EkBEhhPSgtC6vuNuSJNFFsFFCXjHv") : assert_balance_params * token_storage -> token_return))((params, s))
