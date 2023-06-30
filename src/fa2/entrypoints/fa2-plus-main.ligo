#include "fa2-plus/burn.ligo"
#include "fa2-plus/create.ligo"
#include "fa2-plus/mint.ligo"

function fa2_plus_main (const action : fa2_plus_action; var s : storage) : return is
  case action of [
  | Create(params) -> create(params, s)
  | Mint(params) -> mint(params, s)
  | Burn(params) -> burn(params, s)
  ]

function fa2_plus_main_as_constant (const action : fa2_plus_action; var s : storage) : return is
  ((Tezos.constant("exprusHswVQ4VxrUhXTF3vC9gFJn4KY6FbeahNDdj7reGxXkAe1GCZ") : fa2_plus_action * storage -> return))((action, s))
