(* Renounce being a minter *)
function renounce_minter (var s : storage) : return is {
  s.roles.minter := Set.remove(Tezos.get_sender(), s.roles.minter);
} with (noOperations, s)
