(* Update token royalties *)
function update_royalties (const input : update_royalties_params; var s : storage) : return is {
  assert_with_error(is_royalties_manager(Tezos.get_sender(), s), "FA2_INVALID_ROYALTIES_MANAGER_ACCESS");
  for token_id -> royalties in map input {
    s.assets.royalties[token_id] := royalties;
  };
} with (noops, s)

function update_royalties_as_constant (const params : update_royalties_params; var s : storage) : return is
  ((Tezos.constant("exprts8V2EAaSpMUP4wsN8gV3Prm4vud34opVbaPCSoqhaz7HECBhx") : update_royalties_params * storage -> return))(params, s)
