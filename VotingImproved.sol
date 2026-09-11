// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/// @title Voting
/// @notice A simple voting contract with candidate list and vote tracking
contract Voting {
    mapping(string => uint256) public votes;
    mapping(address => bool) public hasVoted;
    string[] public candidates;

    error AlreadyVoted();
    error InvalidCandidate();
    error EmptyCandidateList();

    event Voted(address indexed voter, string candidate);
    event CandidateAdded(string candidate);

    constructor(string[] memory _candidates) {
        if (_candidates.length == 0) revert EmptyCandidateList();
        candidates = _candidates;
    }

    /// @notice Vote for a candidate
    /// @param candidate The name of the candidate
    function vote(string calldata candidate) external {
        if (hasVoted[msg.sender]) revert AlreadyVoted();

        bool valid = false;
        for (uint256 i = 0; i < candidates.length; i++) {
            if (keccak256(bytes(candidates[i])) == keccak256(bytes(candidate))) {
                valid = true;
                break;
            }
        }
        if (!valid) revert InvalidCandidate();

        hasVoted[msg.sender] = true;
        votes[candidate] += 1;

        emit Voted(msg.sender, candidate);
    }

    /// @notice Get list of all candidates
    function getCandidates() external view returns (string[] memory) {
        return candidates;
    }

    /// @notice Get number of votes for a specific candidate
    function getVotes(string calldata candidate) external view returns (uint256) {
        return votes[candidate];
    }

    /// @notice Get total number of candidates
    function getCandidateCount() external view returns (uint256) {
        return candidates.length;
    }

    /// @notice Get total votes cast across all candidates
    function getTotalVotes() external view returns (uint256 total) {
        for (uint256 i = 0; i < candidates.length; i++) {
            total += votes[candidates[i]];
        }
    }
}