(***)
(* Views *)
(***)

[@view]
function get_mint_owner (const k : mint_id; const s : storage) : address is
  case s.mints[k] of [
    None -> failwith("FA_INVALID_MINT_ID")
  | Some(mint) -> mint.owner
  ];

[@view]
function is_mint_owner (const k : mint_id * address; const s : storage) : bool is
  case s.mints[k.0] of [
    None -> False
  | Some(mint) -> mint.owner = k.1
  ];

[@view]
function get_mint_start_time (const k : mint_id; const s : storage) : timestamp is
  case s.mints[k] of [
    None -> failwith("FA_INVALID_MINT_ID")
  | Some(mint) -> mint.start_time
  ];

[@view]
function get_mint_duration (const k : mint_id; const s : storage) : int is
  case s.mints[k] of [
    None -> failwith("FA_INVALID_MINT_ID")
  | Some(mint) -> mint.duration
  ];

[@view]
function get_num_minted (const k : mint_id; const s : storage) : nat is
  case s.mints[k] of [
    None -> failwith("FA_INVALID_MINT_ID")
  | Some(mint) -> mint.minted
  ];
