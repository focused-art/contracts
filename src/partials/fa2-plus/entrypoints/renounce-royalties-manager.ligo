(* Renounce being a royalties manager *)
function renounce_royalties_manager (var s : storage) : return is {
  s.roles.royalties_manager := Set.remove(Tezos.get_sender(), s.roles.royalties_manager);
} with (noOperations, s)
