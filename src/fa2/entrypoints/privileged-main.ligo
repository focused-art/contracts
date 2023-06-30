#include "privileged/update-metadata.ligo"
#include "privileged/update-royalties.ligo"
#include "privileged/update-contract-metadata.ligo"
#include "privileged/update-default-royalties.ligo"

function privileged_main (const action : privileged_action; var s : storage) : return is
  case action of [
  | Update_contract_metadata(params) -> update_contract_metadata(params, s)
  | Update_metadata(params) -> update_metadata(params, s)
  | Update_royalties(params) -> update_royalties(params, s)
  | Update_default_royalties(params) -> update_default_royalties(params, s)
  ]

function privileged_main_as_constant (const action : privileged_action; var s : storage) : return is
  ((Tezos.constant("expruPzcrFU8rAzfMRT5UuVJj346sgEd3mc2K5Ywn9GZSzU1JT8U2f") : privileged_action * storage -> return))((action, s))
