// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/// @title SimpleNFT
/// @notice Minimal NFT contract
contract SimpleNFT {
    string public name = "Simple NFT";
    string public symbol = "SNFT";
    uint256 public totalSupply;

    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    mapping(uint256 => string) private _tokenURIs;

    error ZeroAddress();
    error NotOwner();
    error TokenDoesNotExist();

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    function mint(string calldata tokenURI) external {
        uint256 tokenId = totalSupply;
        totalSupply += 1;

        _owners[tokenId] = msg.sender;
        _balances[msg.sender] += 1;
        _tokenURIs[tokenId] = tokenURI;

        emit Transfer(address(0), msg.sender, tokenId);
    }

    function ownerOf(uint256 tokenId) external view returns (address) {
        address owner = _owners[tokenId];
        if (owner == address(0)) revert TokenDoesNotExist();
        return owner;
    }

    function balanceOf(address owner) external view returns (uint256) {
        if (owner == address(0)) revert ZeroAddress();
        return _balances[owner];
    }

    function tokenURI(uint256 tokenId) external view returns (string memory) {
        if (_owners[tokenId] == address(0)) revert TokenDoesNotExist();
        return _tokenURIs[tokenId];
    }

    function transfer(address to, uint256 tokenId) external {
        if (_owners[tokenId] != msg.sender) revert NotOwner();
        if (to == address(0)) revert ZeroAddress();

        _balances[msg.sender] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(msg.sender, to, tokenId);
    }
}