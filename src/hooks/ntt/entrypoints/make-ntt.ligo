(* Make a token non transferable *)
function make_ntt (const token : fa2; var s : storage) : return is {

  (* Only fa2 owner can call *)
  assert_with_error(is_fa2_owner(token, Tezos.get_sender()), "FA_NOT_FA2_OWNER");

  (* Must be a transfer hook *)
  assert_with_error(is_fa2_transfer_hook(token, Tezos.get_self_address()), "FA_NOT_FA2_TRANSFER_HOOK");

  (* Update storage *)
  s.ntt_tokens[token] := Unit;

} with (noops, s)
