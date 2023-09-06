type storage is
  [@layout:comb]
  record [
    metadata            : big_map (string, bytes);
    frozen_tokens       : big_map (owner * fa2, timestamp);
  ]

(* define return for readability *)
type return is list (operation) * storage

(***)
(* Entrpoint params *)
(***)

type freeze_params is
  [@layout:comb]
  record [
    owner               : address;
    token               : fa2;
    freeze_until        : timestamp;
  ]

type entry_action is
  | Freeze of freeze_params
  | Transfer_hook of transfer_params
  | Burn_hook of mint_burn_params
