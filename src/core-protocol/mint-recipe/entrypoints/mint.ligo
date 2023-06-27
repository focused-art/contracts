(* Mint the mint *)
function mint (const params : mint_params; var s : storage) : return is {

  const recipient : recipient = case params.recipient of [
    Some(recipient) -> recipient
  | None -> Tezos.get_sender()
  ];

  const mint : mint = get_mint_or_fail(params.mint_id, s);

  (* Mint is paused? *)
  assert_with_error(mint.paused = False, "FA_MINT_PAUSED");

  (* Mint started? *)
  assert_with_error(Tezos.get_now() >= mint.start_time, "FA_MINT_NOT_STARTED");

  (* Mint ended? *)
  if mint.duration > 0 then
    assert_with_error(Tezos.get_now() < (mint.start_time + mint.duration), "FA_MINT_ENDED");

  (* Max mint reached *)
  if mint.max_mint > 0n and mint.minted + params.mint_amount > mint.max_mint then
    failwith ("FA_MAX_MINT_EXCEEDED");

  (* Get wallet record *)
  var wallet_record : wallet_record := get_wallet_record((Tezos.get_sender(), params.mint_id), s);

  (* Minted max per wallet *)
  if mint.max_per_wallet > 0n and wallet_record.minted + params.mint_amount > mint.max_per_wallet then
    failwith ("FA_MAX_MINT_PER_WALLET_EXCEEDED");

  (* Minted max per block *)
  if wallet_record.last_block =/= Tezos.get_level() then {
    wallet_record.block_minted := 0n;
    wallet_record.last_block := Tezos.get_level();
  };

  if mint.max_per_block > 0n and wallet_record.block_minted + params.mint_amount > mint.max_per_block then
    failwith ("FA_MAX_MINT_PER_BLOCK_EXCEEDED");

  (* initialize operations *)
  var operations : list (operation) := nil;

  (* Mint recipe instructions *)
  const recipe : recipe = case mint.recipes[params.recipe_id] of [
    Some(recipe) -> recipe
  | None -> failwith ("FA_INVALID_RECIPE_ID")
  ];

  var required_tez : tez := 0mutez;

  for recipe_step -> instruction in map recipe {

    const step_input : set (fa2_with_amount) = case params.recipe_steps[recipe_step] of [
      Some (input) -> input
    | None -> set []
    ];

    function validate_ingredient (const ingredient : ingredient) : unit is {
      var sum : nat := 0n;
      for input in set step_input {
        case ingredient.tokens[input.token.address] of [
          Some (tokens) -> case tokens of [
            | Token_id(token_id) -> assert_with_error(input.token.token_id = token_id, "FA_INVALID_RECIPE_STEP")
            | Range(start_token_id, end_token_id) -> assert_with_error(input.token.token_id >= start_token_id and input.token.token_id <= end_token_id, "FA_INVALID_RECIPE_STEP")
            | Set(token_ids) -> assert_with_error(token_ids contains input.token.token_id, "FA_INVALID_RECIPE_STEP")
            | Any -> skip
          ]
        | None -> failwith("FA_INVALID_RECIPE_STEP")
        ];
        sum := sum + input.amount;
      };
      assert_with_error(sum = ingredient.amount, "FA_INVALID_RECIPE_STEP");
    } with unit;

    case instruction of  [
      Burn(ingredient) -> {
        validate_ingredient(ingredient);
        for input in set step_input {
          operations := fa2_burn(input.token, Tezos.get_sender(), input.amount * params.mint_amount) # operations;
        };
      }
    | Hold(ingredient) -> skip
    | Freeze(ingredient, freeze_until) -> {
        validate_ingredient(ingredient);
        for input in set step_input {
          operations := fa2_freeze(input.token, Tezos.get_sender(), input.amount * params.mint_amount, freeze_until) # operations;
        };
      }
    | Transfer(ingredient, recipients) -> {
        validate_ingredient(ingredient);
        for input in set step_input {
          operations := fa2_transfer(input.token, Tezos.get_sender(), recipients, input.amount * params.mint_amount) # operations;
        };
      }
    | Pay(amount) -> {
        assert_with_error(Set.size(step_input) = 0n, "FA_INVALID_RECIPE_STEP");
        required_tez := required_tez + (amount * params.mint_amount);
      }
    ];
  };

  (* Must be sending valid amount of tez *)
  if Tezos.get_amount() =/= required_tez then
    failwith ("FA_INVALID_TEZ_AMOUNT");

  (* split tez per product *)
  var required_tez_per_product : tez := 0mutez;
  var remainder_count : nat := 0n;

  const ediv1 : option (int * nat) = ediv(tez_to_int(required_tez), Set.size(mint.products));
  case ediv1 of [
    Some (quotient, remainder) -> {
      required_tez_per_product := int_to_tez(quotient);
      remainder_count := remainder;
    }
  | None -> skip
  ];

  for product in set mint.products {
    (* Mint operations *)
    operations := fa2_mint(product.token, recipient, product.amount * params.mint_amount) # operations;

    (* Pay out royalties and recipients *)
    if required_tez_per_product > 0mutez or remainder_count > 0n then {
      var t : tez := required_tez_per_product;
      if remainder_count > 0n then {
        t := t + 1mutez;
        remainder_count := Option.unopt(is_nat(remainder_count - 1n));
      };
      operations := pay_royalties_and_recipients(product.token, mint.recipients, t, operations);
    };
  };

  (* Updates storage *)
  wallet_record.minted := wallet_record.minted + params.mint_amount;
  wallet_record.block_minted := wallet_record.block_minted + params.mint_amount;
  s.ledger[(Tezos.get_sender(), params.mint_id)] := wallet_record;

  s.mints[params.mint_id] := mint with record [ minted += params.mint_amount ];

} with (operations, s)
