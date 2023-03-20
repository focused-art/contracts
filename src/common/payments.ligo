(* Pay out royalties and recipients *)
function pay_royalties_and_recipients (const token : fa2; const recipients : recipients; const price : tez; var operations : list (operation)) : list (operation) is {

  (* Pay royalties *)
  var tez_remaining : tez := price;
  const royalty_shares : royalty_shares = get_royalty_shares(token, tez_to_nat(tez_remaining));

  var total_shares : tez := 0mutez;
  for receiver -> share in map royalty_shares {
    if share > 0n and tez_remaining > 0mutez then {
      const share_tez : tez = nat_to_tez(share);
      operations := tez_transfer(receiver, share_tez) # operations;
      total_shares := total_shares + share_tez;
    };
  };

  if total_shares > 0mutez then {
    tez_remaining := Option.unopt(tez_remaining - total_shares);
  };

  (* Transfer remaining tez to recipients *)
  if tez_remaining > 0mutez then {
    const num_recipients : nat = Map.size(recipients);
    var count : nat := 1n;
    var total_sent : tez := 0mutez;
    for recipient -> pct in map recipients {
      var tez_amount : tez := 0mutez;
      if count = num_recipients then {
        tez_amount := Option.unopt(tez_remaining - total_sent);
      } else {
        tez_amount := tez_remaining * pct / 10_000n;
      };

      if (tez_amount > 0mutez) then {
        operations := tez_transfer(recipient, tez_amount) # operations;
        total_sent := total_sent + tez_amount;
      };

      count := count + 1n;
    };
  };

} with operations
