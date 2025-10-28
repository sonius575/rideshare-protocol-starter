# Area Hashing

- Use **Geohash precision 5** (~4.9km). Only publish the *geohash5* on P2P topics.
- On-chain store **areaHash = keccak256(geohash5)** (bytes32).
- Topic name: `rs/v1/rides/{geohash5}`.
