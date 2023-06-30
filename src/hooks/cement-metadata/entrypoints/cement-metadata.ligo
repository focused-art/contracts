(* Cement a token's metadata *)
function cement_metadata (const token : fa2; var s : storage) : return is {

  (* Only fa2 metadata managers can call *)
  assert_with_error(is_fa2_metadata_manager(token, Tezos.get_sender()), "FA_NOT_FA2_METADATA_MANAGER");

  (* Update storage *)
  s.cemented_tokens[token] := Unit;

} with (nil, s)
