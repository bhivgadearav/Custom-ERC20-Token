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

    // Sets the treasury address to receive funds from the token sale.
    function setTreasury(address _treasury) external onlyOwner {
        treasury = _treasury;
    }

    // Allocates amount% of the total token supply for the ICO.
    function allocateTokensForSale(uint8 amount) external onlyOwner {
        require(amount > 0 && amount < 100);
        uint256 temp = (amount/100) * totalSupply;
        totalSupply -= temp;
        tokensForSale += temp;
    }

    function getAvailableTokens() public view returns(uint256 tokensLeftForSale) {
        return tokensForSale;
    }

    function placeBid(uint8 tokensWanted) public payable {
        require(tokensWanted < tokensForSale, "Bid amount is greater than available number of tokens for sale.");
        require(msg.value > 1 ether, "You have to place a bid of 1 ETH minimum");
        require(block.timestamp < endTime, "ICO has ended");
        require(msg.value > 0, "Bid must be greater than 0");
         if (bids[msg.sender].amount == 0) {
            bidders.push(msg.sender);  // Add new bidder
        }
        bids[msg.sender].amount += msg.value;  // Update bid amount
    }

    function checkForBotActivity(address bidder) internal view returns(bool status) {

    }

    function detectBot(address bidder) internal {
        if (checkForBotActivity(bidder)) {
            isBot[bidder] = true;
        }
    }

    function redirectToFakeNFT(address botAddress) external view {
        require(isBot[botAddress], "Not flagged as a bot");
        // Logic to redirect bot to botRedirectContract
    }


}