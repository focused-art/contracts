(* Make a token non transferable *)
function make_ntt (const token : fa2; var s : storage) : return is {

  (* Only fa2 owner can call *)
  assert_with_error(is_fa2_owner(token, Tezos.get_sender()), "FA_NOT_FA2_OWNER");

  (* Set as transfer hook *)
  const op : operation = case (Tezos.get_entrypoint_opt("%add_transfer_hook", token.address) : option(contract(address))) of [
    Some(entrypoint) -> Tezos.transaction (Tezos.get_self_address(), 0tz, entrypoint)
  | None -> failwith ("FA_ADD_TRANSFER_HOOK_ENTRYPOINT_UNDEFINED")
  ];

  (* Update storage *)
  s.ntt_tokens[token] := Unit;

} with (list [op], s)
