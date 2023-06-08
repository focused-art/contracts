(* Update contract level metadata *)
function update_contract_metadata (const input : map (string, bytes); var s : storage) : return is {
  s.metadata := big_map [];
  for key -> value in map input {
    s.metadata[key] := value;
  };
} with (nil, s)
