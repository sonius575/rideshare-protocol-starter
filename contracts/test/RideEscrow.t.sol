// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/RideEscrow.sol";
import "./mocks/MockERC20.sol";

contract RideEscrowTest is Test {
    RideEscrow esc;
    MockERC20 usdc;
    address rider = address(0x1);
    address driver = address(0x2);
    bytes32 constant RID = keccak256("ride-1");

    function setUp() public {
        esc = new RideEscrow(address(this)); // test contract acts as arbitrator
        usdc = new MockERC20("USDC","USDC",6);
        usdc.mint(rider, 1000e6);
        vm.prank(rider);
        usdc.approve(address(esc), type(uint256).max);
    }

    function testFundStartComplete() public {
        vm.prank(rider);
        esc.create(RID, address(usdc), 100e6, driver, uint64(block.timestamp + 1 days));

        vm.prank(driver);
        esc.start(RID);

        // Completion (receipt sig checks omitted in MVP)
        vm.prank(driver);
        esc.complete(RID, "", "");

        assertEq(usdc.balanceOf(driver), 100e6);
    }

    function testTimeoutRefund() public {
        vm.warp(block.timestamp - 1 days);
        vm.prank(rider);
        esc.create(RID, address(usdc), 50e6, driver, uint64(block.timestamp + 1 hours));
        vm.warp(block.timestamp + 2 days);
        esc.timeout(RID);
        assertEq(usdc.balanceOf(rider), 1000e6); // refunded
    }
}
