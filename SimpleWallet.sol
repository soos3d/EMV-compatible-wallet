// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleWallet {

    // Set up events when:
    event transferReceived(address sender, uint value);     // The wallet receives funds
    event withdrawFunds(uint fundsTaken);                   // Funds are withdrawn (how much)
    event balance(uint balanceLeft);                        // Balance left after withdraw

    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }


    receive() external payable {
        emit transferReceived(msg.sender, msg.value);
    }


    function withdraw(uint _amount) external {
        require(msg.sender == owner, "Only the owner can withdraw");
        payable(msg.sender).transfer(_amount); 

        uint currentBalance = address(this).balance - _amount;
        emit withdrawFunds(_amount);
        emit balance(currentBalance);
    }


    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}
