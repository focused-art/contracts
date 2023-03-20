(* Cement a token's metadata *)
function cement_metadata (const token : fa2; var s : storage) : return is {

  (* Only fa2 metadata managers can call *)
  assert_with_error(is_fa2_metadata_manager(token, Tezos.get_sender()), "FA_NOT_FA2_METADATA_MANAGER");

  (* Must be a metadata hook *)
  assert_with_error(is_fa2_update_metadata_hook(token, Tezos.get_self_address()), "FA_NOT_FA2_UPDATE_METADATA_HOOK");

  (* Update storage *)
  s.cemented_tokens[token] := Unit;

} with (noops, s)
