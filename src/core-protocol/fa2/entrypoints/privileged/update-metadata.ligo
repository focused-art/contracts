(* Update token metadata *)
function update_metadata (const input : update_token_metadata_params; var s : storage) : return is {
  assert_with_error(is_metadata_manager(Tezos.get_sender(), s), "FA2_INVALID_METADATA_MANAGER_ACCESS");

  (* initialize operations *)
  var operations : list (operation) := nil;

  for token_id -> metadata in map input {
    assert_with_error(token_id = metadata.token_id, "FA2_TOKEN_ID_MISMATCH");
    assert_with_error(is_cemented(token_id, s) = False, "FA_TOKEN_METADATA_UPDATE_DENIED");
    s.token_metadata[token_id] := metadata;

    (* events *)
    const token_metadata_update_event : token_metadata_update_event = record [
      token_id = token_id;
      new_metadata = Some(metadata.token_info)
    ];
    operations := Tezos.emit("%token_metadata_update", token_metadata_update_event) # operations;
  };

  (* send any metadata update hooks *)
  for hook in set s.hooks.update_metadata {
    operations := Tezos.transaction (input, 0tz, get_update_metadata_hook(hook)) # operations;
  };

} with (operations, s)
