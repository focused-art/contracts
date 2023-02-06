(* Update token metadata *)
function update_metadata (const input : update_token_metadata_params; var s : storage) : return is {
  assert_with_error(is_metadata_manager(Tezos.get_sender(), s), "FA2_INVALID_METADATA_MANAGER_ACCESS");
  for token_id -> metadata in map input {
    s.assets.token_metadata[token_id] := metadata;
  };
} with (noops, s)

function update_metadata_as_constant (const params : update_token_metadata_params; var s : storage) : return is
  ((Tezos.constant("exprtcanxWtd21U8mXNbDYwgDoSA6hWcbbAvn5Y8ZpK9LmWB4u8ev7") : update_token_metadata_params * storage -> return))(params, s)
