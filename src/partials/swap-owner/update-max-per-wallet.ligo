(* Update swap max per wallet *)
function update_max_per_wallet (var swap : swap; const max : nat) : swap is {
  swap.max_per_wallet := max;
} with swap
