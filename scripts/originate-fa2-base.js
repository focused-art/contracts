const { TezosToolkit, MichelsonMap } = require('@taquito/taquito');
const { InMemorySigner } = require('@taquito/signer');
const TransportNodeHid = require('@ledgerhq/hw-transport-node-hid').default;
const { LedgerSigner, DerivationType, HDPathTemplate } = require('@taquito/ledger-signer');
const fs = require('fs');

(async () => {
  const Tezos = new TezosToolkit(process.env.TEZOS_RPC_URL);
  let signer;

  if (process.env.TEZOS_LEDGER_PATH) {
    const transport = await TransportNodeHid.create();
    signer = new LedgerSigner(
      transport,
      process.env.TEZOS_LEDGER_PATH,
      false, // prompt optional
      DerivationType.ED25519 // derivationType optional
    );
  } else {
    signer = new InMemorySigner(process.env.TEZOS_ADMIN_SK);
  }

  Tezos.setProvider({ signer });

  const contractCode = fs.readFileSync(__dirname + `/../build/contracts/fa2-base.tz`, 'utf8');
  const initial_storage = {
    next_token_id: 0,
    token_total_supply: MichelsonMap.fromLiteral({}),
    ledger: MichelsonMap.fromLiteral({}),
    operators: MichelsonMap.fromLiteral({}),
    token_metadata: MichelsonMap.fromLiteral({}),
  };

  try {
    const origOp = await Tezos.contract.originate({
      code: contractCode,
      storage: initial_storage
    });

    console.log(`Sending operation: ${origOp.hash}`);

    contract = await origOp.contract();
    console.log(`✔ Originated contract: ${contract.address}`);
  } catch (e) {
    console.log(e);
  }
})();
