// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/// @title SimpleBank
/// @notice Simple bank contract for deposits and withdrawals
contract SimpleBank {
    mapping(address => uint256) public balances;

    error InsufficientBalance();
    error TransferFailed();

    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);

    function deposit() external payable {
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {
        if (balances[msg.sender] < amount) revert InsufficientBalance();

        balances[msg.sender] -= amount;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        if (!success) revert TransferFailed();

        emit Withdrawal(msg.sender, amount);
    }

    function getBalance(address user) external view returns (uint256) {
        return balances[user];
    }
}