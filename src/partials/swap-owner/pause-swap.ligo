(* Pause swap *)
function pause_swap (var swap : swap; const paused : bool) : swap is {
  swap.paused := paused;
} with swap
