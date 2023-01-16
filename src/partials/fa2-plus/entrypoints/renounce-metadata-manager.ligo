(* Renounce being a metadata manager *)
function renounce_metadata_manager (var s : storage) : return is {
  s.roles.metadata_manager := Set.remove(Tezos.get_sender(), s.roles.metadata_manager);
} with (noOperations, s)
