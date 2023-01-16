(* Add transfer hook contract *)
function add_transfer_hook (const input : trusted; var s : storage) : return is {
  (* Validate transfer hook *)
  const _ : contract (transfer_params) = get_transfer_hook(input);
  s.roles.transfer_hook := Set.add(input, s.roles.transfer_hook);
} with (noOperations, s)
