(* Cement a token's metadata *)
function cement_metadata (const token_ids : token_ids; var s : storage) : return is {
  assert_with_error(is_metadata_manager(Tezos.get_sender(), s), "FA2_INVALID_METADATA_MANAGER_ACCESS");
  for token_id in set token_ids {
    s.cemented_tokens[token_id] := Unit;
  };
} with (noops, s)
