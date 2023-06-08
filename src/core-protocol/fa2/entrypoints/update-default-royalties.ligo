(* Update default token royalties *)
function update_default_royalties (const input : royalties; var s : storage) : return is {
  assert_with_error(is_royalties_manager(Tezos.get_sender(), s), "FA2_INVALID_ROYALTIES_MANAGER_ACCESS");
  s.default_royalties := input;
} with (nil, s)
