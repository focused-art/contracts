(* Update swap max per block *)
function update_max_per_block (var swap : swap; const max : nat) : swap is {
  swap.max_per_block := max;
} with swap
