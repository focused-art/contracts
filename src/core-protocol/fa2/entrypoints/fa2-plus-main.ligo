#include "burn.ligo"
#include "create.ligo"
#include "mint.ligo"

function fa2_plus_main (const action : fa2_plus_action; var s : storage) : return is
  case action of [
  | Create(params) -> create(params, s)
  | Mint(params) -> mint(params, s)
  | Burn(params) -> burn(params, s)
  ]

function fa2_plus_main_as_constant (const action : fa2_plus_action; var s : storage) : return is
  ((Tezos.constant("exprvByofuajxu9XbaRHkr5fzZbdZpPnX2VEZBtYX4RKyosxiWDe3V") : fa2_plus_action * storage -> return))((action, s))
