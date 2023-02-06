#include "types.ligo"
#include "helpers.ligo"
#include "views.ligo"

function fa2_main (const action : token_action; var s : token_storage) : list (operation) * token_storage is
  case action of [

#if FA2__TRANSFER_HOOK
  | Transfer(params)                  -> ((Tezos.constant("exprv4kvcKTSCUszCEALnwFuwEA5qbgFwNx2m31YpW532icu9c5SqA") : transfer_params * token_storage -> list (operation) * token_storage))(params, s)
#else
  | Transfer(params)                  -> ((Tezos.constant("exprtnG1aeWRoYSqN8V5XP4BQiHndpSjWgCr1XkbFbXHriESy2cfTP") : transfer_params * token_storage -> list (operation) * token_storage))(params, s)
#endif
  | Update_operators(params)          -> ((Tezos.constant("expruEJ9gH42pz4WzGajmtA4UZrR7Kk9fVJbg3GAcMSQQxDyG98yr7") : update_operator_params * token_storage -> list (operation) * token_storage))(params, s)

  | Assert_balances(params)           -> ((Tezos.constant("exprvRgGuJMvLwq8Md7T9yNjd7mHQFMeeJZYWAqNijVWdMapMZfsiT") : assert_balance_params * token_storage -> list (operation) * token_storage))(params, s)
  | Balance_of(params)                -> ((Tezos.constant("exprv7Poi6dBzxoHe5SBiHXynjG2onFGABGf2o1UzjFVRjAuCY1V8P") : balance_params * token_storage -> list (operation) * token_storage))(params, s)
  ];
