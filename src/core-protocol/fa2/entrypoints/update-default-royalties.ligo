(* Update default token royalties *)
function update_default_royalties (const input : royalties; var s : storage) : return is {
  assert_with_error(is_royalties_manager(Tezos.get_sender(), s), "FA2_INVALID_ROYALTIES_MANAGER_ACCESS");
  s.default_royalties := input;
} with (noops, s)

function update_default_royalties_as_constant (const input : royalties; var s : storage) : return is
  ((Tezos.constant("exprtbPHMpXeYcyLezk5M2XxrEKPe2CaXmYKg9pPBHJnjp7iWNJ8JG") : royalties * storage -> return))((input, s))