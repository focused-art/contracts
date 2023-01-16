function nat_max (const a : nat; const b : nat) : nat is
  if a > b then a else b;

function nat_to_tez (const a : nat) : tez is
  a * 1mutez
