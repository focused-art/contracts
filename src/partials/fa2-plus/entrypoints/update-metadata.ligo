(* Update token metadata *)
function update_metadata (const input : update_token_metadata_params; var s : storage) : return is {
  for token_id -> metadata in map input {
    s.assets.token_metadata[token_id] := metadata;
  };
} with (noOperations, s)
