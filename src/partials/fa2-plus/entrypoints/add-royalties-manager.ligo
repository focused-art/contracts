(* Add royalties manager *)
function add_royalties_manager (const input : trusted; var s : storage) : return is {
  s.roles.royalties_manager := Set.add(input, s.roles.royalties_manager);
} with (noOperations, s)
