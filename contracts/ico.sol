// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

struct Bid {
    uint256 amount;                   // Amount of ETH bid
    bool isWinner;                    // Whether this bid is among the top 500k
}

contract InitialCoinOffering is Ownable {
    uint256 public totalSupply;            // Total supply of tokens
    uint256 public tokensForSale;         // 50% of totalSupply for the ICO
    address public treasury;              // Treasury address to receive funds
    uint256 public totalETH;              // Total ETH held by the contract  
    uint256 public startTime;             // Start time of the ICO
    uint256 public endTime;               // End time of the ICO (startTime + 2 days)
    mapping(address => Bid) public bids;  // Mapping of bidder addresses to their bids
    address[] public bidders;             // List of all bidders
    uint256 public maxWinners = 500000;   // Maximum number of winning bids
    address[] public winners;            // List of top 500k winning addresses
    mapping(address => bool) public isBot;      // Tracks flagged bot addresses
    address public botRedirectContract;         // Address of the bot-handling contract
    bool public icoEnded;                // Tracks whether the ICO has ended

    constructor(uint256 _totalSupply, address _treasury) Ownable(msg.sender) {
        totalSupply = _totalSupply;
        tokensForSale = totalSupply / 2;         // Allocate 50% for ICO
        treasury = _treasury;
        startTime = block.timestamp;            // ICO starts now
        endTime = startTime + 2 days;           // ICO ends in 2 days
        icoEnded = false;
    }

}