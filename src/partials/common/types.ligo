type recipient is address
type recipients is map (recipient, nat)

(* define noop for readability *)
const noops: list (operation) = nil;

const c_NULL_ADDRESS : address = ("tz1Ke2h7sDdakHJQh8WX4Z372du1KChsksyU" : address);