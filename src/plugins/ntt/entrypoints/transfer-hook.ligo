(* Transfer hook *)
function transfer_hook (const transfers : transfer_params; const s : storage) : return is {
  for user_tx in list transfers {
    for transfer in list user_tx.txs {
      const token : fa2 = record [
        address = Tezos.get_sender();
        token_id = transfer.token_id;
      ];
      assert_with_error(is_ntt(token, s) = False, "FA_NTT_TOKEN_TRANSFER_DENIED");
    };
  };
} with (noops, s);
