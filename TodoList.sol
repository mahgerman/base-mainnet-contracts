// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/// @title TodoList
/// @notice Simple todo list contract
contract TodoList {
    struct Task {
        string content;
        bool completed;
        address creator;
    }

    Task[] public tasks;

    event TaskCreated(uint256 indexed id, string content, address creator);
    event TaskCompleted(uint256 indexed id);

    function createTask(string calldata content) external {
        tasks.push(Task({
            content: content,
            completed: false,
            creator: msg.sender
        }));
        emit TaskCreated(tasks.length - 1, content, msg.sender);
    }

    function completeTask(uint256 id) external {
        require(id < tasks.length, "Invalid task");
        require(tasks[id].creator == msg.sender, "Not creator");
        tasks[id].completed = true;
        emit TaskCompleted(id);
    }

    function getTaskCount() external view returns (uint256) {
        return tasks.length;
    }

    function getTask(uint256 id) external view returns (string memory content, bool completed, address creator) {
        require(id < tasks.length, "Invalid task");
        Task storage task = tasks[id];
        return (task.content, task.completed, task.creator);
    }
}