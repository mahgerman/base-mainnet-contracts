// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/// @title SimpleLottery
/// @notice Simple lottery with fixed ticket price
contract SimpleLottery {
    address public immutable owner;
    address[] public players;
    uint256 public constant TICKET_PRICE = 0.01 ether;
    bool public isOpen = true;

    error NotOwner();
    error LotteryClosed();
    error IncorrectTicketPrice();
    error NoPlayers();
    error TransferFailed();

    event PlayerEntered(address indexed player);
    event WinnerPicked(address indexed winner, uint256 prize);

    constructor() {
        owner = msg.sender;
    }

    function enter() external payable {
        if (!isOpen) revert LotteryClosed();
        if (msg.value != TICKET_PRICE) revert IncorrectTicketPrice();

        players.push(msg.sender);
        emit PlayerEntered(msg.sender);
    }

    function getPlayers() external view returns (address[] memory) {
        return players;
    }

    function pickWinner() external {
        if (msg.sender != owner) revert NotOwner();
        if (players.length == 0) revert NoPlayers();

        uint256 index = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, players.length))) % players.length;
        address winner = players[index];
        uint256 prize = address(this).balance;

        isOpen = false;

        (bool success, ) = payable(winner).call{value: prize}("");
        if (!success) revert TransferFailed();

        emit WinnerPicked(winner, prize);
    }
}