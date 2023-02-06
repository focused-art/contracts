(* Transfer contract ownership *)
function transfer_ownership (const input : address; var s : storage) : return is {
  assert_with_error(is_owner(Tezos.get_sender(), s), "FA2_INVALID_OWNER_ACCESS");
  s.roles.pending_owner := Some (input);
} with (noops, s)

function transfer_ownership_as_constant (const input : address; var s : storage) : return is
  ((Tezos.constant("exprtZH8MMwU811f7n7zcB5z9htzPPR6wr83fDLnvGicFxCeRVvMBR") : address * storage -> return))(input, s)
