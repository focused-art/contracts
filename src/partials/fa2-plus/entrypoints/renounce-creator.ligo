(* Renounce being a creator *)
function renounce_creator (var s : storage) : return is {
  s.roles.creator := Set.remove(Tezos.get_sender(), s.roles.creator);
} with (noOperations, s)
