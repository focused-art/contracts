(***)
(* Helpers *)
(***)

function get_swap_or_fail (const k : swap_id; const s : storage) : swap is
  case s.swaps[k] of [
    None -> failwith ("FA_INVALID_SWAP_ID")
  | Some(swap) -> swap
  ]

function get_wallet_record (const k : address * swap_id; const s : storage) : wallet_record is
  case s.ledger[k] of [
    None -> record [
      total_minted = 0n;
      total_paid = 0tz;
      last_block = 0n;
      block_minted = 0n;
    ]
  | Some(wallet_record) -> wallet_record
  ]
