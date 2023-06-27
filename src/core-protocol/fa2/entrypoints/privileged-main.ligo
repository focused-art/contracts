#include "privileged/renounce-roles.ligo"
#include "privileged/update-metadata.ligo"
#include "privileged/cement-metadata.ligo"
#include "privileged/confirm-ownership.ligo"
#include "privileged/update-royalties.ligo"
#include "privileged/update-default-royalties.ligo"

function privileged_main (const action : privileged_action; var s : storage) : return is
  case action of [
  | Renounce_roles(params) -> renounce_roles(params, s)
  | Update_metadata(params) -> update_metadata(params, s)
  | Cement_metadata(params) -> cement_metadata(params, s)
  | Update_royalties(params) -> update_royalties(params, s)
  | Update_default_royalties(params) -> update_default_royalties(params, s)
  | Confirm_ownership -> confirm_ownership(s)
  ]

function privileged_main_as_constant (const action : privileged_action; var s : storage) : return is
  ((Tezos.constant("expruBrVeSyayhN73xkkULj2a7PLpdS4th15zFt3p48oHDx8pkxvGx") : privileged_action * storage -> return))((action, s))
