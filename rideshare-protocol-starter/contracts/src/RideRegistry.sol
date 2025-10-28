// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract RideRegistry {
    event RidePosted(
        bytes32 indexed rideId,
        address indexed rider,
        address token,
        uint256 maxFare,
        bytes32 areaHash,
        string metaCID,
        uint64 expiry
    );
    event RideAccepted(bytes32 indexed rideId, address indexed driver, string driverCID);

    /// @notice Post a ride offer summary (all sensitive data stays off-chain)
    function postRide(
        bytes32 rideId,
        address token,
        uint256 maxFare,
        bytes32 areaHash,
        string calldata metaCID,
        uint64 expiry
    ) external {
        require(rideId != bytes32(0), "invalid id");
        require(expiry > block.timestamp, "expired");
        emit RidePosted(rideId, msg.sender, token, maxFare, areaHash, metaCID, expiry);
    }

    /// @notice A driver accepts a ride (off-chain DM carries contact bundle)
    function acceptRide(bytes32 rideId, string calldata driverCID) external {
        require(rideId != bytes32(0), "invalid id");
        emit RideAccepted(rideId, msg.sender, driverCID);
    }
}
