(* Transfer contract ownership *)
function transfer_ownership (const input : address; var s : storage) : return is {
  s.roles.pending_owner := Some (input);
} with (noops, s)

function transfer_ownership_as_constant (const input : address; var s : storage) : return is
  ((Tezos.constant("exprtXVLya25NWhqzba8zpWvSPEBfhJm8dkPQSvYZtEbxjMTMDVyTB") : address * storage -> return))((input, s))
