// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./interfaces/IERC20.sol";

/// @title RideEscrow
/// @notice Minimal escrow for ride fares with dispute + timeout handling.
contract RideEscrow {
    enum State { None, Funded, InProgress, Completed, Disputed, Resolved, Refunded }
    struct Escrow {
        address rider;
        address driver;
        address token;
        uint256 amount;
        State state;
        uint64 expiry;
    }

    mapping(bytes32 => Escrow) public escrows;
    address public arbitrator; // could be a contract; start as EOAs for MVP

    event EscrowCreated(bytes32 indexed rideId, address token, uint256 amount, address rider, address driver, uint64 expiry);
    event EscrowState(bytes32 indexed rideId, State state);

    constructor(address _arbitrator) {
        arbitrator = _arbitrator;
    }

    modifier onlyParties(bytes32 id) {
        Escrow memory e = escrows[id];
        require(msg.sender == e.rider || msg.sender == e.driver, "not a party");
        _;
    }

    function create(bytes32 id, address token, uint256 amount, address driver, uint64 expiry) external {
        require(escrows[id].state == State.None, "exists");
        require(expiry > block.timestamp, "expiry");
        escrows[id] = Escrow({
            rider: msg.sender,
            driver: driver,
            token: token,
            amount: amount,
            state: State.Funded,
            expiry: expiry
        });
        require(IERC20(token).transferFrom(msg.sender, address(this), amount), "transferFrom fail");
        emit EscrowCreated(id, token, amount, msg.sender, driver, expiry);
        emit EscrowState(id, State.Funded);
    }

    function start(bytes32 id) external onlyParties(id) {
        Escrow storage e = escrows[id];
        require(e.state == State.Funded, "bad state");
        e.state = State.InProgress;
        emit EscrowState(id, State.InProgress);
    }

    /// @dev For MVP we assume receipt sigs checked off-chain. Wire in signature checks later.
    function complete(bytes32 id, bytes calldata /*riderSig*/, bytes calldata /*driverSig*/) external onlyParties(id) {
        Escrow storage e = escrows[id];
        require(e.state == State.InProgress, "bad state");
        e.state = State.Completed;
        require(IERC20(e.token).transfer(e.driver, e.amount), "payout fail");
        emit EscrowState(id, State.Completed);
    }

    function dispute(bytes32 id) external onlyParties(id) {
        Escrow storage e = escrows[id];
        require(e.state == State.InProgress, "bad state");
        e.state = State.Disputed;
        emit EscrowState(id, State.Disputed);
    }

    function resolve(bytes32 id, bool payDriver) external {
        require(msg.sender == arbitrator, "arb only");
        Escrow storage e = escrows[id];
        require(e.state == State.Disputed, "bad state");
        e.state = State.Resolved;
        require(IERC20(e.token).transfer(payDriver ? e.driver : e.rider, e.amount), "resolve payout fail");
        emit EscrowState(id, State.Resolved);
    }

    function timeout(bytes32 id) external {
        Escrow storage e = escrows[id];
        require(e.state == State.Funded || e.state == State.InProgress, "bad state");
        require(block.timestamp > e.expiry, "not expired");
        e.state = State.Refunded;
        require(IERC20(e.token).transfer(e.rider, e.amount), "refund fail");
        emit EscrowState(id, State.Refunded);
    }
}
