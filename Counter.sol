// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/// @title Counter
/// @notice A simple counter contract with increment and decrement
contract Counter {
    uint256 public count;

    error BelowZero();

    event CountChanged(uint256 newCount);

    function increment() external {
        unchecked {
            count += 1;
        }
        emit CountChanged(count);
    }

    function decrement() external {
        if (count == 0) revert BelowZero();
        unchecked {
            count -= 1;
        }
        emit CountChanged(count);
    }

    function getCount() external view returns (uint256) {
        return count;
    }
}