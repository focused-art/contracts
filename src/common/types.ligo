type contract_address is address
type trusted is address
type recipient is address
type recipients is map (recipient, nat)
type op_list is list (operation)

type hook_type is
  | Transfer_hook
  | Create_hook
  | Mint_hook
  | Burn_hook
  | Metadata_hook

type role_type is
  | Creator
  | Minter
  | Metadata_manager
  | Royalties_manager

(* define noop for readability *)
const noops: list (operation) = nil;

const c_NULL_ADDRESS : address = ("tz1Ke2h7sDdakHJQh8WX4Z372du1KChsksyU" : address);
