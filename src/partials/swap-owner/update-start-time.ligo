(* Update swap start time *)
function update_start_time (var swap : swap; const t : timestamp) : swap is {
  swap.start_time := t;
} with swap
