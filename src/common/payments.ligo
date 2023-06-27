(* Pay out royalties and recipients *)
function pay_royalties_and_recipients (
  const token : fa2;
  const recipients : recipients;
  const price : tez;
  var operations : op_list
) : op_list is {

  var tez_remaining : tez := price;

  if tez_remaining > 0mutez then {

    (* Pay royalties *)
    const royalty_shares : royalty_shares = get_royalty_shares(token, tez_to_nat(tez_remaining));
    var total_royalties : tez := 0mutez;
    for receiver -> share in map royalty_shares {
      if share > 0n and tez_remaining > 0mutez then {
        const share_tez : tez = nat_to_tez(share);
        operations := tez_transfer(receiver, share_tez) # operations;
        total_royalties := total_royalties + share_tez;
      };
    };

    (* Sanity check royalties *)
    assert_with_error(tez_remaining >= total_royalties, "FA_INVALID_ROYALTIES");

    if total_royalties > 0mutez then {
      tez_remaining := Option.unopt(tez_remaining - total_royalties);
    };

    (* Transfer remaining tez to recipients *)
    if tez_remaining > 0mutez then {
      const num_recipients : nat = Map.size(recipients);
      var count : nat := 1n;
      var total_sent : tez := 0mutez;
      for recipient -> pct in map recipients {
        if tez_remaining > 0mutez then {
          var tez_amount : tez := 0mutez;
          if count = num_recipients then {
            tez_amount := tez_remaining;
          } else {
            tez_amount := tez_remaining * pct / 10_000n;
          };

          if (tez_amount > 0mutez) then {
            tez_amount := tez_min(tez_remaining, tez_amount);
            operations := tez_transfer(recipient, tez_amount) # operations;
            tez_remaining := Option.unopt(tez_remaining - tez_amount);
          };
        };
        count := count + 1n;
      };
    };
  };

} with operations
