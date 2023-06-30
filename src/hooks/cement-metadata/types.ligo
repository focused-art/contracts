type storage is
  [@layout:comb]
  record [
    metadata            : big_map (string, bytes);
    cemented_tokens     : big_map (fa2, unit);
  ]

(* define return for readability *)
type return is list (operation) * storage

type hook_type is
  | Transfer
  | Create
  | Mint
  | Burn
  | Metadata

(***)
(* Entrpoint params *)
(***)

type entry_action is
  | Cement_metadata of fa2
  | Update_metadata_hook of update_token_metadata_params
