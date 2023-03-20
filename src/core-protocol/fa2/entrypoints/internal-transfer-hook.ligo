(* Transfer hook *)
function internal_transfer_hook (const input : transfer_params; const s : storage) : return is {

  assert_with_error(Tezos.get_sender() = Tezos.get_self_address(), "FA2_INVALID_INTERNAL_TRANSFER_HOOK_ACCESS");

  (* initialize operations *)
  var operations : list (operation) := nil;

  (* send any transfer hooks *)
  for hook in set s.hooks.transfer {
    operations := Tezos.transaction (input, 0tz, get_transfer_hook(hook)) # operations;
  };

} with (operations, s)

function internal_transfer_hook_as_constant (const params : transfer_params; var s : storage) : return is
  ((Tezos.constant("expruPFsgsL7j4984ADp1pWUgNuJzrE4DKNnET9qQGnGkFdJB7ymQP") : transfer_params * storage -> return))((params, s))
