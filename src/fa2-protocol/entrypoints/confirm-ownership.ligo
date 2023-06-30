(* Confirm transfer of ownership *)
function confirm_ownership (const kt1 : contract_address; var s : storage) : return is {
  const permissions : permissions = get_permissions_or_fail(kt1, s);
  const pending_owner : address = Option.unopt_with_error(permissions.pending_owner, "FA2_NO_PENDING_OWNER");
  assert_with_error(Tezos.get_sender() = pending_owner, "FA2_INVALID_PENDING_OWNER_ACCESS");
  s.roles[kt1] := permissions with record [ owner = pending_owner; pending_owner = (None : option (address)) ];
} with (nil, s)
