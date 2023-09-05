(* Update token metadata *)
function update_metadata (const input : update_token_metadata_params; var s : storage) : return is {
  assert_with_error(has_role((Tezos.get_sender(), Metadata_manager), s), "FA2_INVALID_METADATA_MANAGER_ACCESS");

  (* initialize operations *)
  var operations : list (operation) := nil;

  for token_id -> token_info in map input {
    s.token_metadata[token_id] := record [
      token_id = token_id;
      token_info = token_info;
    ];

    (* events *)
    const token_metadata_update_event : token_metadata_update_event = record [
      token_id = token_id;
      new_metadata = Some(token_info)
    ];
    operations := Tezos.emit("%token_metadata_update", token_metadata_update_event) # operations;
  };

  (* send any metadata update hooks *)
  for hook in set get_hooks(Metadata_hook, s) {
    operations := Tezos.transaction (input, 0tz, get_update_metadata_hook(hook)) # operations;
  };

} with (operations, s)
