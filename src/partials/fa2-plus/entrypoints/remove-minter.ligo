(* Remove minter *)
function remove_minter (const input : trusted; var s : storage) : return is {
  s.roles.minter := Set.remove(input, s.roles.minter);
} with (noOperations, s)
