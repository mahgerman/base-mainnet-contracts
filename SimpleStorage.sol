// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/// @title SimpleStorage
/// @notice Simple storage contract
contract SimpleStorage {
    uint256 private storedValue;

    event ValueChanged(uint256 newValue);

    function store(uint256 value) external {
        storedValue = value;
        emit ValueChanged(value);
    }

    function retrieve() external view returns (uint256) {
        return storedValue;
    }
}