(* Remove metadata manager *)
function remove_metadata_manager (const input : trusted; var s : storage) : return is {
  s.roles.metadata_manager := Set.remove(input, s.roles.metadata_manager);
} with (noOperations, s)
