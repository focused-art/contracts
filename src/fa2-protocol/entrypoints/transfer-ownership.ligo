(* Transfer contract ownership *)
function transfer_ownership (const kt1 : contract_address; const new_owner : address; var s : storage) : return is {
  assert_with_error(is_owner((kt1, Tezos.get_sender()), s), "FA2_INVALID_OWNER_ACCESS");
  const permissions : permissions = get_permissions_or_fail(kt1, s);
  s.roles[kt1] := permissions with record [ pending_owner = Some (new_owner) ];
} with (nil, s)
