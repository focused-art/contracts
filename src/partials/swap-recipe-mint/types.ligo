type wallet_record is
  [@layout:comb]
  record [
    total_minted              : nat;
    total_paid                : tez;
    last_block                : nat;
    block_minted              : nat;
  ]

type recipient is address
type recipients is map (recipient, nat)

type ingredient is
  [@layout:comb]
  record [
    token                     : fa2;
    amount                    : nat;
  ]

type recipe is
  [@layout:comb]
  record [
    burns                     : set (ingredient);
    transfers                 : map (ingredient, recipient);
  ]

type swap is
  [@layout:comb]
  record [
    owner                     : address;
    paused                    : bool;
    token                     : fa2;
    recipe                    : recipe;
    price                     : tez;
    recipients                : recipients;
    minted                    : nat;
    start_time                : timestamp;
    duration                  : int;
    max_supply                : nat;
    max_per_block             : nat;
    max_per_wallet            : nat;
  ]

type swap_id is nat

type storage is
  [@layout:comb]
  record [
    metadata            : big_map (string, bytes);
    swaps               : big_map (swap_id, swap);
    next_swap_id        : swap_id;
    ledger              : big_map (address * swap_id, wallet_record);
  ]

(* define return for readability *)
type return is list (operation) * storage

(* define noop for readability *)
const noops: list (operation) = nil;

(***)
(* Entrpoint params *)
(***)

type create_swap_params is
  [@layout:comb]
  record [
    token                     : fa2;
    recipe                    : recipe;
    price                     : tez;
    recipients                : recipients;
    start_time                : timestamp;
    duration                  : int;
    max_supply                : nat;
    max_per_block             : nat;
    max_per_wallet            : nat;
  ]

type swap_update_action is
  | Pause_swap of swap_id * bool
  | Update_price of swap_id * tez
  | Update_start_time of swap_id * timestamp
  | Update_duration of swap_id * int
  | Update_max_per_block of swap_id * nat
  | Update_max_per_wallet of swap_id * nat
  | Update_recipients of swap_id * recipients

type swap_owner_action is
  | Cancel_swap of swap_id
  | Swap_update_action of swap_update_action

type entry_action is
  | Swap_owner_action of swap_owner_action
  | Create_swap of create_swap_params
  | Mint of swap_id * nat * recipient
