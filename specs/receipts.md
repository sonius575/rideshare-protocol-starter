# Ride Receipts (off-chain)

```txt
message RideReceipt {
  bytes32 rideId;
  bytes32 nonce;
  string  type;      // "start" | "finish"
}
signature = EIP-191 personal_sign over keccak256(abi.encode(...))
```
- Both *rider* and *driver* signatures collected by either party.
- Submitted to `complete(id, riderSig, driverSig)`; MVP may skip sig check during early testing.
