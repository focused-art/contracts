(* Cement a token's metadata *)
function cement_metadata (const params : cement_metadata_params; var s : storage) : return is {

  for p in list params {

    (* Only fa2 metadata managers can call *)
    assert_with_error(is_fa2_metadata_manager(p.token, Tezos.get_sender()), "FA_NOT_FA2_METADATA_MANAGER");

    (* Update storage if not already cemented *)
    if is_cemented(p.token, s) = False then
      s.cemented_tokens[p.token] := Tezos.get_now() + p.delay;
  };

} with (noops, s)
