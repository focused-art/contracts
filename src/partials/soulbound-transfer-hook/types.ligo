type storage is
  [@layout:comb]
  record [
    metadata            : big_map (string, bytes);
    soulbound_tokens    : big_map (fa2, unit);
  ]

(* define return for readability *)
type return is list (operation) * storage

(* define noop for readability *)
const noops: list (operation) = nil;

(***)
(* Entrpoint params *)
(***)

type entry_action is
  | Make_soulbound of fa2
  | Transfer_hook of transfer_params
