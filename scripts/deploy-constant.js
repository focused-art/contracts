const { TezosToolkit, MichelsonMap } = require('@taquito/taquito');
const { InMemorySigner } = require('@taquito/signer');
const TransportNodeHid = require('@ledgerhq/hw-transport-node-hid').default;
const { LedgerSigner, DerivationType, HDPathTemplate } = require('@taquito/ledger-signer');

var args = process.argv.slice(2);
const constant_to_deploy = args[0] || "unknown";

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

  try {
    const op = await Tezos.contract.registerGlobalConstant({
      value: require(`../build/constants/${constant_to_deploy}.json`)
    });

    console.log(`Deploying global constant ${constant_to_deploy}`);

    await op.confirmation();

    console.log(`✔ Deployed ${constant_to_deploy}: ${op.globalConstantHash}`);
  } catch (e) {
    console.log(e);
  }
})();
