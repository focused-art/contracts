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

function update_operators (const params : update_operator_params; var s : token_storage) : token_return is
  (noops, List.fold(iterate_update_operator, params, s))

function update_operators_as_constant (const params : update_operator_params; var s : token_storage) : token_return is
  ((Tezos.constant("expruEJ9gH42pz4WzGajmtA4UZrR7Kk9fVJbg3GAcMSQQxDyG98yr7") : update_operator_params * token_storage -> token_return))(params, s)
