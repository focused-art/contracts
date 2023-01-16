(* Remove creator *)
function remove_creator (const input : trusted; var s : storage) : return is {
  s.roles.creator := Set.remove(input, s.roles.creator);
} with (noOperations, s)
