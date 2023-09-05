(* Create new token *)
function create (const input : create_params; var s : storage) : return is {

  assert_with_error(has_role((Tezos.get_sender(), Creator), s), "FA2_INVALID_CREATOR_ACCESS");

  const token_id : token_id = s.next_token_id;

  assert_with_error(Big_map.mem(token_id, s.token_metadata) = False, "FA2_DUP_TOKEN_ID");

  s.token_metadata[token_id] := record [
    token_id = token_id;
    token_info = input.token_metadata;
  ];
  s.token_total_supply[token_id] := 0n;
  s.token_max_supply[token_id] := input.max_supply;

  case input.royalties of [
    Some(royalties) -> s.royalties[token_id] := royalties
  | None -> skip
  ];

  s.next_token_id := s.next_token_id + 1n;
  (*s.next_token_id := nat_max(s.next_token_id, input.token_metadata.token_id) + 1n;*)

  (* initialize operations *)
  var operations : list (operation) := nil;

  (* send any create hooks *)
  for hook in set get_hooks(Create_hook, s) {
    operations := Tezos.transaction (input, 0tz, get_create_hook(hook)) # operations;
  };

  const token_metadata_update_event : token_metadata_update_event = record [
    token_id = token_id;
    new_metadata = Some(input.token_metadata)
  ];
  operations := Tezos.emit("%token_metadata_update", token_metadata_update_event) # operations;

} with (operations, s)
