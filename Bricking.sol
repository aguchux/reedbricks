// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Bricking is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    bool private bricked;
    event Bought(uint256 amount);
    event Sold(uint256 amount);
    mapping(address => uint256) private _blocks;
    uint8 private _brickDivisor;

    constructor() ERC721("Factory NFT", "FTN") {}

    function createToken(string memory tokenURI) public returns (uint256) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();

        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    function buy(uint256 _tokenId, uint256 bricks) public payable {}
    function sell(uint256 _tokenId, uint256 bricks) public {}

    function _brick() internal view returns (address) {
        return msg.sender;
    }

    function _unbrick() internal view returns (address) {
        return msg.sender;
    }
}
