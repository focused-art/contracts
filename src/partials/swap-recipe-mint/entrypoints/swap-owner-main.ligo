#include "../../swap-owner/pause-swap.ligo"
#include "../../swap-owner/update-price.ligo"
#include "../../swap-owner/update-start-time.ligo"
#include "../../swap-owner/update-duration.ligo"
#include "../../swap-owner/update-max-per-block.ligo"
#include "../../swap-owner/update-max-per-wallet.ligo"
#include "../../swap-owner/update-recipients.ligo"

(* Swap owner main entrypoint *)
function swap_owner_main (const action : swap_owner_action; var s : storage) : return is {
  const swap_id : swap_id = case action of [
    | Cancel_swap(params) -> params
    | Swap_update_action(update_action) -> case update_action of [
      | Pause_swap(params) -> params.0
      | Update_price(params) -> params.0
      | Update_start_time(params) -> params.0
      | Update_duration(params) -> params.0
      | Update_max_per_block(params) -> params.0
      | Update_max_per_wallet(params) -> params.0
      | Update_recipients(params) -> params.0
    ]
  ];

  assert_with_error(is_swap_owner((swap_id, Tezos.get_sender()), s), "FA_INVALID_SWAP_OWNER_ACCESS");

  const swap : swap = get_swap_or_fail(swap_id, s);

  (* Update stoage *)
  s.swaps := case action of [
    | Cancel_swap(_params) -> Big_map.remove(swap_id, s.swaps)
    | Swap_update_action(update_action) -> {
      const updated_swap : swap = case update_action of [
        | Pause_swap(params) -> pause_swap(swap, params.1)
        | Update_price(params) -> update_price(swap, params.1)
        | Update_start_time(params) -> update_start_time(swap, params.1)
        | Update_duration(params) -> update_duration(swap, params.1)
        | Update_max_per_block(params) -> update_max_per_block(swap, params.1)
        | Update_max_per_wallet(params) -> update_max_per_wallet(swap, params.1)
        | Update_recipients(params) -> update_recipients(swap, params.1)
      ];
      s.swaps[swap_id] := updated_swap;
    } with s.swaps
  ];

} with (noops, s)
