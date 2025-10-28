# Rideshare Protocol — Starter Monorepo

This is a runnable scaffold for an *unstoppable-ish* ride-share protocol:
- **contracts/** — Foundry-based Solidity contracts (RideRegistry, RideEscrow) + tests.
- **subgraph/** — The Graph subgraph for indexing `RidePosted`, `RideAccepted`, and escrow state.
- **p2p-node/** — Waku/libp2p-style skeleton (TypeScript) for decentralized discovery/messaging.
- **client-mobile/** — Minimal Expo (React Native) starter that lists nearby rides (stub) and posts an offer (stub).
- **specs/** — Message and area hashing specs.
- **docs/** — Threat model outline.
- **infra/** — GitHub Actions CI skeleton.

> This repo is intentionally **minimal** to compile and run unit tests for contracts and to give you a place to plug in networking and mobile code. Add secrets/tool configs as appropriate.

## Quickstart

### 1) Contracts
```bash
cd contracts
forge install foundry-rs/forge-std --no-commit
forge build
forge test -vv
```

### 2) Subgraph (local build)
```bash
cd subgraph
npm i
# Edit subgraph.yaml with deployed addresses before building
npm run codegen && npm run build
```

### 3) P2P node (dev skeleton)
```bash
cd p2p-node
npm i
npm run dev
```

### 4) Mobile (Expo skeleton)
```bash
cd client-mobile
npm i
npm run start
```

## Structure
```
contracts/
subgraph/
p2p-node/
client-mobile/
specs/
docs/
infra/
```
