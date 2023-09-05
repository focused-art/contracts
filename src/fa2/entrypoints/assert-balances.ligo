function assert_balances (const params : assert_balance_params; const s : storage) : return is {
  for param in list params {
    assert_with_error(internal_get_balance_of(param.owner, param.token_id, s) >= param.balance, "FA2_INSUFFICIENT_BALANCE")
  };
} with (nil, s)
