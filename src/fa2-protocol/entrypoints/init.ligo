const create_fa2 : create_fa2 =
[%Michelson ( {| { UNPPAIIR ;
                  CREATE_CONTRACT
#include "../../../build/contracts/fa2.tz"
        ;
          PAIR } |}
 : create_fa2)];

(* Init a new collection *)
function init (const metadata : map (string, bytes); var s : storage) : return is {
  const owner : address = Tezos.get_sender();

  var fa2_storage : fa2_storage := record [
    metadata = big_map [];
    protocol = Tezos.get_self_address();
    next_token_id = 0n;
    token_total_supply = big_map [];
    ledger = big_map [];
    operators = big_map [];
    token_metadata = big_map [];
    royalties = big_map [];
    token_max_supply = big_map [];
    default_royalties = record [
      total_shares = 0n;
      shares = map [];
    ];
  ];

  for key -> value in map metadata {
    fa2_storage.metadata[key] := value;
  };

  const res : (operation * address) = create_fa2(((None : option(key_hash)), 0tz, fa2_storage));
  const kt1 : contract_address = res.1;

  s.roles[kt1] := record [
    owner = owner;
    pending_owner = (None : option (address));
    creator = set [owner];
    minter = set [owner];
    metadata_manager = set [owner];
    royalties_manager = set [owner];
  ];
} with (list [res.0], s)
