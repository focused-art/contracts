(***)
(* Helpers *)
(***)

function get_mint_or_fail (const k : mint_id; const s : storage) : mint is
  case s.mints[k] of [
    None -> failwith ("FA_INVALID_MINT_ID")
  | Some(mint) -> mint
  ]

function get_wallet_record (const k : address * mint_id; const s : storage) : wallet_record is
  case s.ledger[k] of [
    None -> record [
      minted = 0n;
      last_block = 0n;
      block_minted = 0n;
    ]
  | Some(wallet_record) -> wallet_record
  ]
