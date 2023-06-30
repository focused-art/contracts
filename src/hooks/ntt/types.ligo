type storage is
  [@layout:comb]
  record [
    metadata            : big_map (string, bytes);
    ntt_tokens          : big_map (fa2, unit);
  ]

(* define return for readability *)
type return is list (operation) * storage

(***)
(* Entrpoint params *)
(***)

type entry_action is
  | Make_ntt of fa2
  | Transfer_hook of transfer_params
