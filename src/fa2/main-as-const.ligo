(*                                          *)
(*                   FA2+                   *)
(*                                          *)
(*      Built by Codecrafting <♥> Labs      *)
(*                                          *)

#include "main.ligo"

(* Main entrypoint *)
function main_as_const (const action : entry_action; var s : storage) : return is
  ((Tezos.constant("exprupveLJURDJQesynb15iPAohaw79DEucaVECYP682xGReTP67KV") : entry_action * storage -> return))((action, s))
