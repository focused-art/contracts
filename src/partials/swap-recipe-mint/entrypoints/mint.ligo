(* Mint the swap *)
function mint (const swap_id : swap_id; const mint_amount : nat; const recipient : recipient; var s : storage) : return is {

  const swap : swap = get_swap_or_fail(swap_id, s);

  (* Swap is paused? *)
  assert_with_error(swap.paused = False, "FA_SWAP_PAUSED");

  (* Swap started? *)
  assert_with_error(Tezos.get_now() >= swap.start_time, "FA_SWAP_NOT_STARTED");

  (* Sale ended? *)
  if swap.duration > 0 then
    assert_with_error(Tezos.get_now() < (swap.start_time + swap.duration), "FA_SWAP_ENDED");

  (* Max supply reached *)
  if swap.max_supply > 0n and get_total_supply(swap.token) + mint_amount > swap.max_supply then
    failwith ("FA_MAX_SUPPLY_EXCEEDED");

  (* Must be sending valid amount of tez *)
  if Tezos.get_amount() =/= (swap.price * mint_amount) then
    failwith ("FA_INVALID_TEZ_AMOUNT");

  (* Get wallet record *)
  var wallet_record : wallet_record := get_wallet_record((Tezos.get_sender(), swap_id), s);

  (* Minted max per wallet *)
  if swap.max_per_wallet > 0n and wallet_record.total_minted + mint_amount > swap.max_per_wallet then
    failwith ("FA_MAX_MINT_PER_WALLET_EXCEEDED");

  (* Minted max per block *)
  if wallet_record.last_block =/= Tezos.get_level() then {
    wallet_record.block_minted := 0n;
    wallet_record.last_block := Tezos.get_level();
  };

  if swap.max_per_block > 0n and wallet_record.block_minted + mint_amount > swap.max_per_block then
    failwith ("FA_MAX_MINT_PER_BLOCK_EXCEEDED");

  (* initialize operations *)
  var operations : list (operation) := nil;

  (* Mint operation *)
  operations := fa2_mint(swap.token, recipient, mint_amount) # operations;

  (* Swap recipe burn operations *)
  for burn in set swap.recipe.burns {
    operations := fa2_burn(burn.token, Tezos.get_sender(), burn.amount * mint_amount) # operations;
  };

  (* Swap recipe transfer operations *)
  for transfer -> recipient in map swap.recipe.transfers {
    operations := fa2_transfer(transfer.token, Tezos.get_sender(), recipient, transfer.amount * mint_amount) # operations;
  };

  (* Swap has a price *)
  if swap.price > 0mutez then {

    (* Pay royalties *)
    var tezRemaining : tez := Tezos.get_amount();
    const royalty_shares : royalty_shares = get_royalty_shares(swap.token, tez_to_nat(tezRemaining));

    for receiver -> share in map royalty_shares {
      if share > 0n and tezRemaining > 0mutez then {
        const shareTez : tez = nat_to_tez(share);
        operations := tez_transfer(receiver, shareTez) # operations;
        tezRemaining := Option.unopt(tezRemaining - shareTez);
      };
    };

    (* Transfer remaining tez to recipients *)
    if tezRemaining > 0mutez then {
      const tezRemainingAfterRoyalties : tez = tezRemaining;
      for recipient -> pct in map swap.recipients {
        const tezAmount : tez = tez_min(tezRemaining, tezRemainingAfterRoyalties * pct / 10_000n);
        if (tezAmount > 0mutez) then {
          operations := tez_transfer(recipient, tezAmount) # operations;
          tezRemaining := Option.unopt(tezRemaining - tezAmount);
        };
      };
    }

  };

  (* Updates storage *)
  wallet_record.total_minted := wallet_record.total_minted + mint_amount;
  wallet_record.block_minted := wallet_record.block_minted + mint_amount;
  wallet_record.total_paid := wallet_record.total_paid + Tezos.get_amount();
  s.ledger[(Tezos.get_sender(), swap_id)] := wallet_record;

  var updated_swap : swap := swap;
  updated_swap.minted := swap.minted + mint_amount;
  s.swaps[swap_id] := updated_swap;

} with (operations, s)
