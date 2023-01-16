(* Create new token *)
function create (const input : create_params; var s : storage) : return is {

  assert_with_error(Big_map.mem(input.token_metadata.token_id, s.assets.token_metadata) = False, "FA2_DUP_TOKEN_ID");

  s.assets.token_metadata[input.token_metadata.token_id] := input.token_metadata;
  s.assets.royalties[input.token_metadata.token_id] := input.royalties;
  s.assets.token_total_supply[input.token_metadata.token_id] := 0n;
  s.assets.next_token_id := nat_max(s.assets.next_token_id, input.token_metadata.token_id + 1n);

} with (noOperations, s)
