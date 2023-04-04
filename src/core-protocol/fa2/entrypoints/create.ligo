(* Create new token *)
function create (const input : create_params; var s : storage) : return is {

  assert_with_error(is_creator(Tezos.get_sender(), s), "FA2_INVALID_CREATOR_ACCESS");

  assert_with_error(Big_map.mem(input.token_metadata.token_id, s.assets.token_metadata) = False, "FA2_DUP_TOKEN_ID");

  s.assets.token_metadata[input.token_metadata.token_id] := input.token_metadata;
  s.assets.royalties[input.token_metadata.token_id] := input.royalties;
  s.assets.token_total_supply[input.token_metadata.token_id] := 0n;
  s.assets.next_token_id := nat_max(s.assets.next_token_id, input.token_metadata.token_id + 1n);
  s.token_max_supply[input.token_metadata.token_id] := input.max_supply;

  (* initialize operations *)
  var operations : list (operation) := nil;

  (* send any create hooks *)
  for hook in set s.hooks.create {
    operations := Tezos.transaction (input, 0tz, get_create_hook(hook)) # operations;
  };

  const token_metadata_update_event : token_metadata_update_event = record [
    token_id = input.token_metadata.token_id;
    new_metadata = Some(input.token_metadata.token_info)
  ];
  operations := Tezos.emit("%token_metadata_update", token_metadata_update_event) # operations;

} with (operations, s)

function create_as_constant (const params : create_params; var s : storage) : return is
  ((Tezos.constant("exprtX949TczmNVB2eZY8f9ZbMbSqSP8Bn9XwH3t6WsPQQX1t3Ye9d") : create_params * storage -> return))((params, s))
