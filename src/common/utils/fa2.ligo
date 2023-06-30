#include "../../fa2/types.ligo"

type fa2 is
  [@layout:comb]
  record [
    address             : address;
    token_id            : token_id;
  ]

type calc_royalties_params is
  [@layout:comb]
  record [
    price                     : nat;
    royalties                 : royalties;
  ]

function calc_royalties (const p : calc_royalties_params) : royalty_shares is
  ((Tezos.constant("expru2hTf7Qe5QVb7UWdLKVedax3Snw3NyewjDX3aQYUQfD9xCR6YY") : calc_royalties_params -> royalty_shares))(p)

function get_royalty_shares (const token : fa2; const price : nat) : royalty_shares is {
  const royalties : royalties = Option.unopt((Tezos.call_view("get_royalties", token.token_id, token.address) : option(royalties)));
} with calc_royalties(record [ price = price; royalties = royalties; ])

function get_total_supply (const token : fa2) : nat is
  Option.unopt((Tezos.call_view("total_supply", token.token_id, token.address) : option(nat)))

function is_fa2_owner (const token : fa2; const check : address) : bool is
  case (Tezos.call_view("is_owner", check, token.address) : option(bool)) of [
    Some(response) -> response
  | None -> False
  ]

function is_fa2_minter (const token : fa2; const check : address) : bool is
  case (Tezos.call_view("is_minter", check, token.address) : option(bool)) of [
    Some(response) -> response
  | None -> False
  ]

function is_fa2_metadata_manager (const token : fa2; const check : address) : bool is
  case (Tezos.call_view("is_metadata_manager", check, token.address) : option(bool)) of [
    Some(response) -> response
  | None -> False
  ]

function is_fa2_transfer_hook (const token : fa2; const check : address) : bool is
  case (Tezos.call_view("is_transfer_hook", check, token.address) : option(bool)) of [
    Some(response) -> response
  | None -> False
  ]

function is_fa2_update_metadata_hook (const token : fa2; const check : address) : bool is
  case (Tezos.call_view("is_metadata_update_hook", check, token.address) : option(bool)) of [
    Some(response) -> response
  | None -> False
  ]

function fa2_transfer (const token : fa2; const from_ : address; const to_ : address; const amount: nat) : operation is {
  const transfer_entrypoint : contract (transfer_params) =
    case (Tezos.get_entrypoint_opt("%transfer", token.address) : option(contract(transfer_params))) of [
      None -> failwith ("FA_CANNOT_INVOKE_FA2_TRANSFER")
    | Some(entrypoint) -> entrypoint
    ];
  const transfer : transfer_param =
    record [
      from_ = from_;
      txs = list[
        record[
          to_ = to_;
          token_id = token.token_id;
          amount = amount;
        ]
      ];
    ]
} with Tezos.transaction (list [transfer], 0tz, transfer_entrypoint)

function fa2_mint (const token : fa2; const recipient : address; const amount : nat) : operation is
  case (Tezos.get_entrypoint_opt("%mint", token.address) : option(contract(mint_burn_params))) of [
    Some(entrypoint) -> Tezos.transaction (record [
        owner = recipient;
        token_id = token.token_id;
        amount = amount;
      ], 0tz, entrypoint)
  | None -> failwith ("FA_MINT_ENTRYPOINT_UNDEFINED")
  ]

function fa2_burn (const token : fa2; const owner : address; const amount : nat) : operation is
  case (Tezos.get_entrypoint_opt("%burn", token.address) : option(contract(mint_burn_params))) of [
    Some(entrypoint) -> Tezos.transaction (record [
        owner = owner;
        token_id = token.token_id;
        amount = amount;
      ], 0tz, entrypoint)
  | None -> fa2_transfer(token, owner, c_NULL_ADDRESS, amount)
  ]

function fa2_freeze (const token : fa2; const owner : address; const amount : nat; const freeze_until : timestamp) : operation is
  fa2_transfer(token, owner, c_NULL_ADDRESS, amount)
