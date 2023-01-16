(* Create new swap *)
function create_swap (const params : create_swap_params; var s : storage) : return is {

  (* Must be owner of FA2 *)
  assert_with_error(is_fa2_owner(params.token, Tezos.get_sender()), "FA_SELLER_NOT_FA2_OWNER");

  (* This contract must have minter permissions *)
  assert_with_error(is_fa2_minter(params.token, Tezos.get_self_address()), "FA_SELF_NOT_FA2_MINTER");

  (* Validate recipients *)
  var recipients : recipients := map [];
  if params.price > 0mutez then {
    var total : nat := 0n;
    for _recipient -> pct in map params.recipients {
      total := total + pct;
    };
    assert_with_error(total = 10_000n, "FA_INVALID_RECIPIENT_PCTS");
    recipients := params.recipients;
  };

  (* Create swap *)
  s.swaps[s.next_swap_id] := record [
    owner = Tezos.get_sender();
    paused = False;
    token = params.token;
    recipe = params.recipe;
    price = params.price;
    recipients = recipients;
    minted = 0n;
    start_time = params.start_time;
    duration = params.duration;
    max_supply = params.max_supply;
    max_per_block = params.max_per_block;
    max_per_wallet = params.max_per_wallet;
  ];

  s.next_swap_id := s.next_swap_id + 1n;

} with (noops, s)
