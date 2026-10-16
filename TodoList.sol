// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/// @title TodoList
/// @notice Advanced todo list with priorities, deadlines and completion tracking
contract TodoList {
    address public immutable owner;
    uint256 public taskCount;

    enum Priority { Low, Medium, High }
    enum Status { Pending, InProgress, Completed, Cancelled }

    struct Task {
        uint256 id;
        string title;
        string description;
        Priority priority;
        Status status;
        uint256 createdAt;
        uint256 deadline;
        address creator;
    }

    mapping(uint256 => Task) public tasks;
    mapping(address => uint256[]) public userTasks;

    error NotTaskOwner();
    error TaskNotFound();
    error InvalidStatus();
    error EmptyTitle();
    error DeadlineInPast();

    event TaskCreated(uint256 indexed id, address indexed creator, string title, Priority priority);
    event TaskUpdated(uint256 indexed id, Status newStatus);
    event TaskDeleted(uint256 indexed id);

    constructor() {
        owner = msg.sender;
    }

    function createTask(
        string calldata title,
        string calldata description,
        Priority priority,
        uint256 deadline
    ) external {
        if (bytes(title).length == 0) revert EmptyTitle();
        if (deadline <= block.timestamp) revert DeadlineInPast();

        taskCount += 1;
        uint256 id = taskCount;

        tasks[id] = Task({
            id: id,
            title: title,
            description: description,
            priority: priority,
            status: Status.Pending,
            createdAt: block.timestamp,
            deadline: deadline,
            creator: msg.sender
        });

        userTasks[msg.sender].push(id);

        emit TaskCreated(id, msg.sender, title, priority);
    }

    function updateStatus(uint256 id, Status newStatus) external {
        Task storage task = tasks[id];
        if (task.id == 0) revert TaskNotFound();
        if (task.creator != msg.sender) revert NotTaskOwner();

        task.status = newStatus;
        emit TaskUpdated(id, newStatus);
    }

    function deleteTask(uint256 id) external {
        Task storage task = tasks[id];
        if (task.id == 0) revert TaskNotFound();
        if (task.creator != msg.sender) revert NotTaskOwner();

        delete tasks[id];
        emit TaskDeleted(id);
    }

    function getTask(uint256 id) external view returns (Task memory) {
        if (tasks[id].id == 0) revert TaskNotFound();
        return tasks[id];
    }

    function getUserTasks(address user) external view returns (uint256[] memory) {
        return userTasks[user];
    }

    function getTaskCount() external view returns (uint256) {
        return taskCount;
    }
}
