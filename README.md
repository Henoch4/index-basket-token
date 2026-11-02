# MINT MIX — Index Basket Token

> MINT MIX bundles several assets into one ERC-20-style basket token. Deposit a set of underlying amounts and receive basket units that track the whole holding, redeemable per-composition anytime.

## What it does

MINT MIX bundles several assets into one ERC-20-style basket token. Deposit a set of underlying amounts and receive basket units that track the whole holding, redeemable per-composition anytime. The entire lifecycle lives in one contract, every button in the UI calls a real function on it — there is no mock backend.

## Contract

| | |
|---|---|
| File | `contracts/IndexBasketToken.sol` |
| Contract name | `IndexBasketToken` (inherits `ReentrancyGuard, Ownable`) |
| Solidity | `^0.8.20` |
| State functions | 12 (of which 0 payable) |
| Deployed (mainnet 677) | not yet deployed — placeholder `0x000…000` |

### Function surface

| Function | Type | Returns |
|---|---|---|
| `owner` | view | address |
| `addComponent` | write | result / revert |
| `removeComponent` | write | result / revert |
| `updateWeight` | write | result / revert |
| `mint` | write | result / revert |
| `burn` | write | result / revert |
| `transfer` | write | bool |
| `transferFrom` | write | bool |
| `approve` | write | bool |
| `balanceOf` | view | uint256 |
| `allowance` | view | uint256 |
| `getComponent` | view | address token, uint256 weightBps, bool active |

### Events

| Event | Signature |
|---|---|
| `OwnershipTransferred` | (address indexed previousOwner, address indexed newOwner) |
| `ComponentAdded` | (address indexed token, uint256 weightBps) |
| `ComponentRemoved` | (address indexed token) |
| `WeightsUpdated` | (address indexed token, uint256 newWeightBps) |
| `Transfer` | (address indexed from, address indexed to, uint256 value) |
| `Approval` | (address indexed owner, address indexed spender, uint256 value) |

## Network

| | |
|---|---|
| Chain | BOT Chain Mainnet (chainId `677`) |
| RPC | `https://rpc.botchain.ai` |
| Explorer | `https://scan.botchain.ai` |
| Native currency | BOT (18 decimals) |
| Testnet | BOT Chain Testnet (chainId `968`) - `https://rpc.bohr.life` |

## Frontend

- **Wallet connection** - [Reown/AppKit](https://reown.com) (Web3Modal v2, inline modal, `subscribeAccount` / `subscribeNetwork`)
- **Web3 library** - ethers.js v6 (`BrowserProvider`, `Contract`, `parseEther`)
- **Animation** - GSAP 3 + ScrollTrigger (`expo.out` entrances, `prefers-reduced-motion` fallback renders content instantly)
- **Zero build step** - single `index.html`, CDN imports via ESM import map; no bundler, no framework runtime
- **Accessibility** - auto-generated `aria-label`s on all binary and form controls, focus-visible styles, button busy states

## Run it locally

```bash
git clone https://github.com/Henoch4/index-basket-token.git
cd index-basket-token
# open the frontend directly (no build step)
start frontend/index.html   # Windows
# or serve it if your browser blocks file:// modules:
npx serve frontend
```

> **Note** — contract addresses: the UI reads its deploy target from the `CA` constant at the top of the inline script. Until the contract is deployed to mainnet 677, the demo runs against the deterministic sample data built into the page; after deployment, set `CA['677']` to the real address and every button goes live.