// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title CustomToken - An ERC20 token with image URI support
/// @dev Extends ERC20 functionality with image metadata and minting/burning capabilities
contract CustomToken is ERC20, Ownable {
    /// @notice Storage for token image URI
    /// @dev This can be updated by the contract owner
    string public imageURI;
    
    /// @notice Contract constructor
    /// @dev Initializes the token with initial supply and image URI
    /// @param name Token name
    /// @param symbol Token symbol
    /// @param _imageURI Token image URI
    /// @param _amount Initial supply (before decimals)
    constructor(
        string memory name,
        string memory symbol,
        string memory _imageURI,
        uint256 _amount
    ) ERC20(name, symbol) Ownable(msg.sender) {
        if (bytes(_imageURI).length == 0) revert("Empty URI");
        imageURI = _imageURI;
        
        uint8 decimalsValue = decimals();
        if (_amount > type(uint256).max / (10 ** decimalsValue)) {
            revert("Amount too large");
        }
        
        _mint(msg.sender, _amount * 10 ** decimalsValue);
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

    /// @notice Updates the token's image URI
    /// @dev Only callable by contract owner
    /// @param newImageURI New URI to set for the token image
    function setImageURI(string memory newImageURI) external onlyOwner {
        if (bytes(newImageURI).length == 0) revert("Empty URI");
        imageURI = newImageURI;
    }
}