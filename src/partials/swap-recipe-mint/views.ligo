(***)
(* Views *)
(***)

[@view]
function get_swap_owner (const k : swap_id; const s : storage) : address is
  case s.swaps[k] of [
    None -> failwith("FA_INVALID_SWAP_ID")
  | Some(swap) -> swap.owner
  ];

[@view]
function is_swap_owner (const k : swap_id * address; const s : storage) : bool is
  case s.swaps[k.0] of [
    None -> False
  | Some(swap) -> swap.owner = k.1
  ];

[@view]
function get_swap_price (const k : swap_id; const s : storage) : tez is
  case s.swaps[k] of [
    None -> failwith("FA_INVALID_SWAP_ID")
  | Some(swap) -> swap.price
  ];

[@view]
function get_swap_start_time (const k : swap_id; const s : storage) : timestamp is
  case s.swaps[k] of [
    None -> failwith("FA_INVALID_SWAP_ID")
  | Some(swap) -> swap.start_time
  ];

[@view]
function get_swap_duration (const k : swap_id; const s : storage) : int is
  case s.swaps[k] of [
    None -> failwith("FA_INVALID_SWAP_ID")
  | Some(swap) -> swap.duration
  ];

[@view]
function get_swap_minted (const k : swap_id; const s : storage) : nat is
  case s.swaps[k] of [
    None -> failwith("FA_INVALID_SWAP_ID")
  | Some(swap) -> swap.minted
  ];
