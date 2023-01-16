(* Update swap recipients *)
function update_recipients (var swap : swap; const r : recipients) : swap is {
  swap.recipients := r;
} with swap
