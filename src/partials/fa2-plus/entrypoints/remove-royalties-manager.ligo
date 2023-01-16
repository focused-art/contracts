(* Remove royalties manager *)
function remove_royalties_manager (const input : trusted; var s : storage) : return is {
  s.roles.royalties_manager := Set.remove(input, s.roles.royalties_manager);
} with (noOperations, s)
