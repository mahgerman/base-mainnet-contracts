// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/// @title SimpleBank
/// @notice A basic bank contract with deposit, withdraw and interest features
contract SimpleBank {
    address public immutable owner;
    uint256 public totalDeposits;
    uint256 public constant INTEREST_RATE = 5;
    uint256 public constant MIN_DEPOSIT = 0.0005 ether;

    mapping(address => uint256) public balances;
    mapping(address => uint256) public lastDepositTime;

    error NotOwner();
    error BelowMinimumDeposit();
    error InsufficientBalance();
    error TransferFailed();
    error ZeroAmount();

    event Deposited(address indexed user, uint256 amount, uint256 timestamp);
    event Withdrawn(address indexed user, uint256 amount);
    event InterestPaid(address indexed user, uint256 interest);

    constructor() {
        owner = msg.sender;
    }

    function deposit() external payable {
        if (msg.value < MIN_DEPOSIT) revert BelowMinimumDeposit();

        balances[msg.sender] += msg.value;
        totalDeposits += msg.value;
        lastDepositTime[msg.sender] = block.timestamp;

        emit Deposited(msg.sender, msg.value, block.timestamp);
    }

    function withdraw(uint256 amount) external {
        if (amount == 0) revert ZeroAmount();
        if (balances[msg.sender] < amount) revert InsufficientBalance();

        balances[msg.sender] -= amount;
        totalDeposits -= amount;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        if (!success) revert TransferFailed();

        emit Withdrawn(msg.sender, amount);
    }

    function calculateInterest(address user) public view returns (uint256) {
        if (balances[user] == 0 || lastDepositTime[user] == 0) return 0;

        uint256 timePassed = block.timestamp - lastDepositTime[user];
        uint256 interest = (balances[user] * INTEREST_RATE * timePassed) / (100 * 365 days);

        return interest;
    }

    function claimInterest() external {
        uint256 interest = calculateInterest(msg.sender);
        if (interest == 0) return;

        lastDepositTime[msg.sender] = block.timestamp;
        balances[msg.sender] += interest;
        totalDeposits += interest;

        emit InterestPaid(msg.sender, interest);
    }

    function getBalance(address user) external view returns (uint256) {
        return balances[user];
    }

    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
