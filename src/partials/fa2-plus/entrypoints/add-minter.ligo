(* Add minter *)
function add_minter (const input : trusted; var s : storage) : return is {
  s.roles.minter := Set.add(input, s.roles.minter);
} with (noOperations, s)
