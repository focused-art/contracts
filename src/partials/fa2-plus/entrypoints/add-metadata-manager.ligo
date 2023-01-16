(* Add metadata manager *)
function add_metadata_manager (const input : trusted; var s : storage) : return is {
  s.roles.metadata_manager := Set.add(input, s.roles.metadata_manager);
} with (noOperations, s)
