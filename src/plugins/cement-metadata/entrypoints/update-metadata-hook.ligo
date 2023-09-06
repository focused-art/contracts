function update_metadata_hook (const params : update_token_metadata_params ; const s : storage) : return is {
  for token_id -> _m in map params {
    const token : fa2 = record [
      address = Tezos.get_sender();
      token_id = token_id;
    ];
    assert_with_error(is_cemented(token, s) = False, "FA_TOKEN_METADATA_UPDATE_DENIED");
  };
} with (nil, s)
