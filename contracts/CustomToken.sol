// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title CustomToken - An ERC20 token 
/// @dev Extends ERC20 functionality with minting/burning capabilities
contract CustomToken is ERC20, Ownable {
    /// @notice Contract constructor
    /// @dev Initializes the token 
    /// @param name Token name
    /// @param symbol Token symbol
    /// @param amount Inital supply of tokens minted to deployer's address
    constructor(
        string memory name,
        string memory symbol,
        uint256 amount
    ) ERC20(name, symbol) Ownable(msg.sender) {
        if (amount == 0) amount = 100;
        _mint(msg.sender, amount);
    }

    /// @notice Creates new tokens
    /// @dev Only callable by contract owner
    /// @param to Address to receive the minted tokens
    /// @param amount Amount of tokens to mint (including decimals)
    function mint(address to, uint256 amount) external onlyOwner {
        if (to == address(0)) revert("Zero address");
        if (amount == 0) revert("Zero amount");
        _mint(to, amount);
    }

    /// @notice Destroys tokens from caller's balance
    /// @dev Can be called by any token holder
    /// @param amount Amount of tokens to burn (including decimals)
    function burn(uint256 amount) external {
        if (amount == 0) revert("Zero amount");
        _burn(msg.sender, amount);
    }
}