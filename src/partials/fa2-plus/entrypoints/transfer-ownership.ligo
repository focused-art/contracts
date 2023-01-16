(* Transfer contract ownership *)
function transfer_ownership (const input : address; var s : storage) : return is {
  s.roles.pending_owner := Some (input);
} with (noOperations, s)
