// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

// Set path for SafeYorkERC20Token.sol to import 
import "./SafeYorkERC20Token.sol";

contract DEX {

    IERC20 public token;

    event Bought(uint256 amount);
    event Sold(uint256 amount);

    constructor() {
        token = new YorkERC20Token();
    }
    
    function buy() payable public {
        // Caller can send Ether and get token and exchange 1 token for 1 Ether
        uint256 etherAmount = msg.value;
        uint256 tokenAmount = etherAmount;

        // Check the amount
        require(etherAmount > 0, "Error: You need to send some ether to buy tokens.");
        require(token.balanceOf(address(this)) >= tokenAmount, "Error: Not enough tokens.");

        // Emit the Transfer from YorkERC20Token.sol
        // and Bought event from the DEX contract
        token.transfer(msg.sender, tokenAmount);
        emit Bought(tokenAmount);

    }
    
    function sell(uint256 amount) public {
        // Check the amount
        require(token.balanceOf(msg.sender) >= amount, "Error: You don't have enough tokens to sell. Buy Ether first to get tokens!");

        // Caller can send token back in exchange for Ether
        // Check if the transfer from the caller address to the contract address
        token.transferFrom(msg.sender, address(this), amount);
        payable(msg.sender).transfer(amount);

        // Emit 
        emit Sold(amount);

    }
}