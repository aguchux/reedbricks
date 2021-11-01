// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "libraries/SafeMath.sol";

contract Bricking {
    using SafeMath for uint256;

    bool private bricked;
    uint256 private blocks;
    uint256 private assets;

    event Bought(uint256 amount);
    event Sold(uint256 amount);

    struct Block {
        uint256 id;
        string name;
        address owner;
        uint256 div;
        uint256 amount;
        uint256 price;
    }

    mapping(address => uint256) private _blocks;
    mapping(uint256 => bool) private _bricked;

    uint256 private _brickDivisor;

    constructor() {
        blocks = 0;
        assets = 0;
    }

    function brick(
        address _contract,
        address _owner,
        uint256 amount,
        uint256 _div
    ) public returns (uint256) {
        uint256 newId = blocks.increment();
        uint256 brickPrice = amount.div(_div);
        _blocks[_owner] = blocks;
        return newId;
    }

    function buy(
        address _buyer,
        uint256 _tokenId,
        uint256 bricks
    ) public payable {}

    function sell(
        address _seller,
        uint256 _tokenId,
        uint256 bricks
    ) public {}

}
