(* Remove transfer hook contract *)
function remove_transfer_hook (const input : trusted; var s : storage) : return is {
  s.roles.transfer_hook := Set.remove(input, s.roles.transfer_hook);
} with (noOperations, s)
