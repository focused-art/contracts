(* Confirm transfer of ownership *)
function confirm_ownership (var s : storage) : return is {
  const pending_owner : address = Option.unopt_with_error(s.roles.pending_owner, "FA2_NO_PENDING_OWNER");
  assert_with_error(Tezos.get_sender() = pending_owner, "FA2_INVALID_PENDING_OWNER_ACCESS");
  s.roles.owner := pending_owner;
  s.roles.pending_owner := (None : option (address));
} with (noops, s)

function confirm_ownership_as_constant (var s : storage) : return is
  ((Tezos.constant("expruVbPWAVhz2QqMhBFFfSzDXuf8dRYbi6Hwy1L3WhaERoykeXLEF") : storage -> return))(s)
