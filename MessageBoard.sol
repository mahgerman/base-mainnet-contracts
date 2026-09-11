// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/// @title MessageBoard
/// @notice Simple message board contract
contract MessageBoard {
    struct Message {
        address sender;
        string content;
        uint256 timestamp;
    }

    Message[] public messages;

    event MessagePosted(address indexed sender, string content, uint256 timestamp);

    function postMessage(string calldata content) external {
        messages.push(Message({
            sender: msg.sender,
            content: content,
            timestamp: block.timestamp
        }));
        emit MessagePosted(msg.sender, content, block.timestamp);
    }

    function getMessageCount() external view returns (uint256) {
        return messages.length;
    }

    function getMessage(uint256 index) external view returns (address sender, string memory content, uint256 timestamp) {
        require(index < messages.length, "Invalid index");
        Message storage message = messages[index];
        return (message.sender, message.content, message.timestamp);
    }
}