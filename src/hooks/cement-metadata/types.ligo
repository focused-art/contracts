type storage is
  [@layout:comb]
  record [
    metadata            : big_map (string, bytes);
    cemented_tokens     : big_map (fa2, timestamp);
  ]

(* define return for readability *)
type return is list (operation) * storage

(***)
(* Entrpoint params *)
(***)

type cement_metadata_param is
  [@layout:comb]
  record [
    token               : fa2;
    delay               : int;
  ]

type cement_metadata_params is list (cement_metadata_param)

type entry_action is
  | Cement_metadata of cement_metadata_params
  | Update_metadata_hook of update_token_metadata_params
