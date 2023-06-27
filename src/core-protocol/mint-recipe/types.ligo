type wallet_record is
  [@layout:comb]
  record [
    minted                    : nat;
    last_block                : nat;
    block_minted              : nat;
  ]

type fa2_with_amount is
  [@layout:comb]
  record [
    token                     : fa2;
    amount                    : nat;
  ]

type token_id_opts is
  | Token_id of token_id
  | Range of token_id * token_id
  | Set of set (token_id)
  | Any of unit

type ingredient is
  [@layout:comb]
  record [
    tokens                    : map (address, token_id_opts);
    amount                    : nat;
  ]

type instruction is
  | Burn of ingredient
  | Hold of ingredient
  | Freeze of ingredient * timestamp
  | Transfer of ingredient * recipient
  | Pay of tez

type recipe_step is nat
type recipe_id is nat
type recipe is map (recipe_step, instruction)
type products is set (fa2_with_amount)

type mint is
  [@layout:comb]
  record [
    owner                     : address;
    paused                    : bool;
    recipes                   : map (recipe_id, recipe);
    products                  : products;
    recipients                : recipients;
    minted                    : nat;
    start_time                : timestamp;
    duration                  : int;
    max_mint                  : nat;
    max_per_block             : nat;
    max_per_wallet            : nat;
  ]

type mint_id is nat

type storage is
  [@layout:comb]
  record [
    metadata            : big_map (string, bytes);
    mints               : big_map (mint_id, mint);
    next_mint_id        : mint_id;
    ledger              : big_map (address * mint_id, wallet_record);
  ]

(* define return for readability *)
type return is op_list * storage

(***)
(* Entrpoint params *)
(***)

type create_params is
  [@layout:comb]
  record [
    recipes                   : map (recipe_id, recipe);
    products                  : products;
    recipients                : recipients;
    start_time                : timestamp;
    duration                  : int;
    max_mint                  : nat;
    max_per_block             : nat;
    max_per_wallet            : nat;
  ]

type mint_params is
  [@layout:comb]
  record [
    mint_id                   : mint_id;
    recipe_id                 : recipe_id;
    recipe_steps              : map (recipe_step, set (fa2_with_amount));
    mint_amount               : nat;
    recipient                 : option (recipient);
  ]

type mint_update_action is
  | Pause of mint_id * bool
  | Update_start_time of mint_id * timestamp
  | Update_duration of mint_id * int
  | Update_max_per_block of mint_id * nat
  | Update_max_per_wallet of mint_id * nat
  | Update_recipients of mint_id * recipients

type mint_owner_action is
  | Cancel of mint_id
  | Mint_update_action of mint_update_action

type entry_action is
  | Mint_owner_action of mint_owner_action
  | Create of create_params
  | Mint of mint_params
