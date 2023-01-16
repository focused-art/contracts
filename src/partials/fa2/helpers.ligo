function mintTokens (const owner : address; const tokenId : token_id; const amount_ : nat; var s : token_storage) : token_storage is
  block {
    validate_token_id(tokenId, s);
    s.ledger[(owner, tokenId)] := internal_get_balance_of(owner, tokenId, s) + amount_;
    s.token_total_supply[tokenId] := internal_get_token_total_supply(tokenId, s) + amount_;
  } with s

function burnTokens (const owner : address; const tokenId : token_id; const amount_ : nat; var s : token_storage) : token_storage is
  block {
    (* Token id check *)
    validate_token_id(tokenId, s);

    (* Balance check *)
    const owner_bal : nat = internal_get_balance_of(owner, tokenId, s);
    if owner_bal < amount_ then
      failwith("FA2_INSUFFICIENT_BALANCE")
    else skip;

    (* Burn them! *)
    s.ledger[(owner, tokenId)] := abs(internal_get_balance_of(owner, tokenId, s) - amount_);
    s.token_total_supply[tokenId] := abs(internal_get_token_total_supply(tokenId, s) - amount_);
  } with s
