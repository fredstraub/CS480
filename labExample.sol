// SPDX License-MIT
pragma solidity ^0.8.11;

contract VendingM{
    address public owner;
    mapping(address => uint) public candy;
    // lab should have several items

constructor() {
    owner = msg.sender;
    candy[address(this)] = 50; // will start with 50 in the vending machine
}

function getNumberOfItems() public view returns (uint) {
    return candy[address(this)];
}

function addMore(uint amount) public {
    require(msg.sender == owner, "Only the owner can add items to the machine");
    require(amount <= 200, "The machine can only hold 200");
    candy[address(this)] += amount;
}

function purchase(uint amount) public payable {
    // will make a button with a field for the amount
    // payable keyword makes it possible for someone to pay
    require(msg.value >= amount * 1, "You are not paying enough");
    require(candy[address(this)] >= amount, "Not enough candy");
    candy[address(this)] = candy[address(this)] - amount;
    candy[msg.sender] = candy[msg.sender] + amount;
}

}