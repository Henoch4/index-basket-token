# MINT MIX

Track basket components and transfer index-token balances. Component weights are managed by the token owner.

## Mainnet status

Contract on BOT Chain mainnet (677): [0x6E2B16811A648b9732baaf00Ad8F758550Fe07AF](https://scan.botchain.ai/address/0x6E2B16811A648b9732baaf00Ad8F758550Fe07AF).

Wallet actions require BOT Chain mainnet, deployed bytecode, and a connected compatible wallet. Every action is simulated before a transaction review; only a subsequent wallet confirmation can send it.

## Interface

- Live reads use the configured mainnet address; an unavailable RPC produces an explicit error.
- No seeded financial metrics, synthetic receipts, or assessment traces appear in the product.
- Management actions require proof of the connected account’s owner, creator, oracle, merchant, guardian, or record role. The contract remains the authority.
- Account/network changes invalidate an open transaction review.
- The footer provides BOT Chain and BOTScan homepage links; deployed products also link to their contract.
- Ethers is vendored locally with its license. No CDN script is required for wallet or contract operations.

## Contract interface

`frontend/product.json` uses the current-source ABI, verified against the deployed mainnet bytecode.

| Action | Contract signature |
|---|---|
| Add a component (owner only) | `addComponent(address,uint256)` |
| Approve a token allowance | `approve(address,uint256)` |
| Burn index tokens (owner only) | `burn(address,uint256)` |
| Mint index tokens (owner only) | `mint(address,uint256)` |
| Remove a component (owner only) | `removeComponent(address)` |
| Transfer tokens | `transfer(address,uint256)` |
| Transfer approved tokens | `transferFrom(address,address,uint256)` |
| Change a component weight (owner only) | `updateWeight(address,uint256)` |

## Run locally

Serve the frontend over HTTP so the browser can load its configuration:

```sh
python -m http.server 8080 --directory frontend
```

Open http://localhost:8080. Only connect a wallet when you intend to use the configured mainnet contract.

## Regression test

```sh
npm install
npm test
```

The test requires Chromium or Edge. Windows defaults to the standard Edge installation; set `BROWSER_PATH` to another Chromium executable when needed. It mocks all chain requests and broadcasts no transactions. Tests cover pending deployment, RPC failure, read-only initialization and missing-wallet handling.

## Deployment and assessment

Update `frontend/product.json` only after confirming the new contract's network, bytecode and ABI. Do not substitute placeholder addresses or remove truthful limitations. Operator-wallet testing proves technical activity, not independent users. Official social accounts, launch posts, independent users and continuous operation require separate evidence.
