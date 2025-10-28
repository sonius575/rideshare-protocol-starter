# Threat Model (outline)

- **Sybil**: bond stake for drivers; attestations (EAS); social proofs.
- **Location spoofing**: coarse zones; mutual proof-of-proximity; never put lat/lon on-chain.
- **Griefing**: timeouts/refunds; minimal on-chain state.
- **Censorship**: multiple frontends, IPFS/ENS, P2P discovery.
- **Key loss**: AA + social recovery; avoid raw seed UX.
- **Oracle risk**: no price oracle needed for escrow logic; display FX client-side only.
