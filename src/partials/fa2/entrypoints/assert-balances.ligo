function iterate_assert_balance (const s : token_storage; const params : assert_balance_param) : token_storage is {
  assert_with_error(internal_get_balance_of(params.owner, params.token_id, s) >= params.balance, "FA2_INSUFFICIENT_BALANCE")
} with s

function assert_balances (const params : assert_balance_params; var s : token_storage) : token_return is
  (noops, List.fold(iterate_assert_balance, params, s))

function assert_balances_as_constant (const params : assert_balance_params; var s : token_storage) : token_return is
  ((Tezos.constant("exprvRgGuJMvLwq8Md7T9yNjd7mHQFMeeJZYWAqNijVWdMapMZfsiT") : assert_balance_params * token_storage -> token_return))(params, s)
