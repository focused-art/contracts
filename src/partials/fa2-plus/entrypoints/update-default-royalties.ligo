(* Update default token royalties *)
function update_default_royalties (const input : royalties; var s : storage) : return is {
  s.default_royalties := input;
} with (noOperations, s)
