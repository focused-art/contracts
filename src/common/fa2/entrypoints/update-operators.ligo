function update_operators (const params : update_operator_params; var s : token_storage) : token_return is {
  (* initialize operations *)
  var operations : list (operation) := nil;

  for update_operator_param in list params {
    case update_operator_param of [
    | Add_operator(param) -> {
      validate_token_id(param.token_id, s);
      validate_owner(param.owner);
      s.operators := Big_map.update((param.owner, (param.operator, param.token_id)), Some (Unit), s.operators);

      const operator_update_event : operator_update_event = record [
        owner = param.owner;
        operator = param.operator;
        token_id = param.token_id;
        is_operator = True;
      ];
      operations := Tezos.emit("%operator_update", operator_update_event) # operations;
    }
    | Remove_operator(param) -> {
      validate_token_id(param.token_id, s);
      validate_owner(param.owner);
      s.operators := Big_map.remove((param.owner, (param.operator, param.token_id)), s.operators);

      const operator_update_event : operator_update_event = record [
        owner = param.owner;
        operator = param.operator;
        token_id = param.token_id;
        is_operator = False;
      ];
      operations := Tezos.emit("%operator_update", operator_update_event) # operations;
    }
    ];
  };
} with (operations, s)

function update_operators_as_constant (const params : update_operator_params; var s : token_storage) : token_return is
  ((Tezos.constant("exprtdBxWxRb5ni1wGhB9VvPe13W4e5LFDcKkcAgXyxeWwTaQDgPRE") : update_operator_params * token_storage -> token_return))((params, s))
