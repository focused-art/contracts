(* Update token royalties *)
function update_royalties (const input : update_royalties_params; var s : storage) : return is {
  for token_id -> royalties in map input {
    s.assets.royalties[token_id] := royalties;
  };
} with (noOperations, s)
