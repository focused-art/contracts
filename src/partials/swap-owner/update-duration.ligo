(* Update swap duration *)
function update_duration (var swap : swap; const d : int) : swap is {
  swap.duration := d;
} with swap
