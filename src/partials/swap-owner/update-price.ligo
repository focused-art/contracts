(* Update swap price *)
function update_price (var swap : swap; const price : tez) : swap is {
  swap.price := price;
} with swap
