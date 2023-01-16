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
