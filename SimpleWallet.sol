// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleWallet {

    // Set up events when:
    event transferReceived(address sender, uint value);     // The wallet receives funds
    event withdrawFunds(uint fundsTaken);                   // Funds are withdrawn (how much)
    event balance(uint balanceLeft);                        // Balance left after withdraw

    address payable public owner;

    // Only the owner can call transactions marked with this modifier
    modifier onlyOwner() {
        require(owner == msg.sender, "Only the owner can call this function");
        _;
    }

    // Assigns the address deploying the contract as the owner
    constructor() {
        owner = payable(msg.sender);
    }


    // Allows the owner to transfer ownership of the contract
    function transferOwnership(address payable _newOwner) external onlyOwner {
        owner = _newOwner;
    }


    // Function to allow the contract to receive funds.
    receive() external payable {
        emit transferReceived(msg.sender, msg.value);
    }


    // Allows the owner to specify and amount and withdraw it
    function withdraw(uint _amount) external onlyOwner{
        payable(msg.sender).transfer(_amount);

        uint currentBalance = address(this).balance - _amount;
        emit withdrawFunds(_amount);
        emit balance(currentBalance);
    }


    // Retrieve the current contract balance
    function getBalance() external view returns (uint) {
        return address(this).balance;
    }


    // Destroy this contract, withdraw all the funds before destroying it
    function destroy(address payable recipient) public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
        selfdestruct(recipient);
    }
}
