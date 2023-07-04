// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Whales {
    mapping(address => mapping(uint256 => uint256)) private balances;
    mapping(uint256 => string) private tokenURIs;
    uint256 private nextTokenId;

    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);

    function createNFT(address recipient, string memory tokenURI) external returns (uint256) {
        uint256 tokenId = nextTokenId;
        balances[recipient][tokenId] = 1;
        tokenURIs[tokenId] = tokenURI;
        nextTokenId++;
        emit TransferSingle(msg.sender, address(0), recipient, tokenId, 1);
        return tokenId;
    }

    function balanceOf(address owner, uint256 tokenId) external view returns (uint256) {
        return balances[owner][tokenId];
    }

    function uri(uint256 tokenId) external view returns (string memory) {
        return tokenURIs[tokenId];
    }

    function transfer(address from, address to, uint256 tokenId) external {
        require(from == msg.sender || msg.sender == address(this), "Caller is not the token owner or approved");
        require(balances[from][tokenId] > 0, "Token does not exist or is not owned by the sender");
        
        balances[from][tokenId] -= 1;
        balances[to][tokenId] += 1;
        
        emit TransferSingle(msg.sender, from, to, tokenId, 1);
    }
}
