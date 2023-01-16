(* Add creator *)
function add_creator (const input : trusted; var s : storage) : return is {
  s.roles.creator := Set.add(input, s.roles.creator);
} with (noOperations, s)
