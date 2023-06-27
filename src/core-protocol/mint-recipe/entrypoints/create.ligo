(* Create new mint *)
function create (const params : create_params; var s : storage) : return is {

  (* Validate product(s) *)
  for product in set params.products {
    (* Must be owner of products *)
    assert_with_error(is_fa2_owner(product.token, Tezos.get_sender()), "FA_SELLER_NOT_FA2_OWNER");

    (* This contract must have minter permissions *)
    assert_with_error(is_fa2_minter(product.token, Tezos.get_self_address()), "FA_SELF_NOT_FA2_MINTER");
  };

  (* Validate recipients *)
  var has_price : bool := False;
  for _recipe_id -> recipe in map params.recipes {
    for _recipe_step -> instruction in map recipe {
      case instruction of [
        Burn(_a) -> skip
      | Hold(_a) -> skip
      | Freeze(_a) -> skip
      | Transfer(_s) -> skip
      | Pay(_a) -> { has_price := True }
      ]
    };
  };

  var recipients : recipients := map [];
  if has_price = True then {
    var total : nat := 0n;
    for _recipient -> pct in map params.recipients {
      total := total + pct;
    };
    assert_with_error(total = 10_000n, "FA_INVALID_RECIPIENT_PCTS");
    recipients := params.recipients;
  };

  (* Create swap *)
  s.mints[s.next_mint_id] := record [
    owner = Tezos.get_sender();
    paused = False;
    recipes = params.recipes;
    products = params.products;
    recipients = recipients;
    minted = 0n;
    start_time = params.start_time;
    duration = params.duration;
    max_mint = params.max_mint;
    max_per_block = params.max_per_block;
    max_per_wallet = params.max_per_wallet;
  ];

  s.next_mint_id := s.next_mint_id + 1n;

} with (nil, s)
