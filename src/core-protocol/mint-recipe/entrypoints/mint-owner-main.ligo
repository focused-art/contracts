(* Mint owner main entrypoint *)
function mint_owner_main (const action : mint_owner_action; var s : storage) : return is {
  const mint_id : mint_id = case action of [
    | Cancel(params) -> params
    | Mint_update_action(update_action) -> case update_action of [
      | Pause(params) -> params.0
      | Update_start_time(params) -> params.0
      | Update_duration(params) -> params.0
      | Update_max_per_block(params) -> params.0
      | Update_max_per_wallet(params) -> params.0
      | Update_recipients(params) -> params.0
    ]
  ];

  assert_with_error(is_mint_owner((mint_id, Tezos.get_sender()), s), "FA_INVALID_MINT_OWNER_ACCESS");

  const mint : mint = get_mint_or_fail(mint_id, s);

  (* Update storage *)
  s.mints := case action of [
    | Cancel(_params) -> Big_map.remove(mint_id, s.mints)
    | Mint_update_action(update_action) -> {
      const updated_mint : mint = case update_action of [
        | Pause(params) -> mint with record [ paused = params.1 ]
        | Update_start_time(params) -> mint with record [ start_time = params.1 ]
        | Update_duration(params) -> mint with record [ duration = params.1 ]
        | Update_max_per_block(params) -> mint with record [ max_per_block = params.1 ]
        | Update_max_per_wallet(params) -> mint with record [ max_per_wallet = params.1 ]
        | Update_recipients(params) -> mint with record [ recipients = params.1 ]
      ];
      s.mints[mint_id] := updated_mint;
    } with s.mints
  ];

} with (nil, s)
