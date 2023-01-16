(* Renounce contract ownership *)
function renounce_ownership (var s : storage) : return is {
  s.roles.owner := ("tz1Ke2h7sDdakHJQh8WX4Z372du1KChsksyU" : address);
} with (noOperations, s)
