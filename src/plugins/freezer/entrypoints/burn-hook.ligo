(* Burn hook *)
function burn_hook (const params : mint_burn_params; const s : storage) : return is {
  const token : fa2 = record [
    address = Tezos.get_sender();
    token_id = params.token_id;
  ];
  assert_with_error(is_frozen((params.owner, token), s) = False, "FA_FROZEN_TOKEN_BURN_DENIED");
} with (noops, s);
