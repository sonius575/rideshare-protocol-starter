// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/RideRegistry.sol";
import "../src/RideEscrow.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();
        RideRegistry reg = new RideRegistry();
        RideEscrow esc = new RideEscrow(msg.sender);
        console2.log("RideRegistry", address(reg));
        console2.log("RideEscrow", address(esc));
        vm.stopBroadcast();
    }
}
