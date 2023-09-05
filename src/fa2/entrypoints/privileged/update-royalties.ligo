(* Update token royalties *)
function update_royalties (const input : update_royalties_params; var s : storage) : return is {
  assert_with_error(has_role((Tezos.get_sender(), Royalties_manager), s), "FA2_INVALID_ROYALTIES_MANAGER_ACCESS");

  (* initialize operations *)
  var operations : list (operation) := nil;

  for token_id -> royalties in map input {
    s.royalties[token_id] := royalties;

    const token_royalties_update_event : token_royalties_update_event = record [
      token_id = token_id;
      new_royalties = Some(royalties)
    ];
    operations := Tezos.emit("%token_royalties_update", token_royalties_update_event) # operations;
  };
} with (operations, s)
