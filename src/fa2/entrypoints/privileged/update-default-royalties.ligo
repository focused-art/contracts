(* Update default token royalties *)
function update_default_royalties (const input : royalties; var s : storage) : return is {
  assert_with_error(has_role((Tezos.get_sender(), Royalties_manager), s), "FA2_INVALID_ROYALTIES_MANAGER_ACCESS");
  s.default_royalties := input;
} with (nil, s)
