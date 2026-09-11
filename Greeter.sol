// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/// @title Greeter
/// @notice Simple greeter contract
contract Greeter {
    string public greeting;

    event GreetingChanged(string newGreeting);

    constructor(string memory _greeting) {
        greeting = _greeting;
    }

    function setGreeting(string calldata _greeting) external {
        greeting = _greeting;
        emit GreetingChanged(_greeting);
    }

    function greet() external view returns (string memory) {
        return greeting;
    }
}