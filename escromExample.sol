//SPDX-Licesnce-Identifier: MIT
pragma solidity ^0.8.11;

contract Escrow{

    enum State { NOT_INITIATED, AWAITING_PAYMENT, AMAITING_DELIVERY, COMPLETE}

    State public currState;

    bool public isBuyerIn;
    bool public isSellerIn;

    uint public price;
    
    address public buyer;
    address payable public seller;

    modifier escrowSotStarted(){
        require(currState == State.NOT_INITIATED);
        _;
    }

    modifier onlyBuyer(){
        require(msg.sender == buyer, "Only the buyer call this function.");
        _;
    }

    constructor(address _buyer, address payable _seller, uint _price){
        buyer = _buyer;
        seller = _seller;
        price = _price * (1 ether);
    }

    function initContract() escrowSotStarted public{
        if(msg.sender == buyer){
            isBuyerIn = true;
        }
        if(msg.sender == seller){
            isSellerIn = true;
        }
        if(isSellerIn && isSellerIn){
            currState = State.AWAITING_PAYMENT;
        }
    }

    function deposit() onlyBuyer public payable{
        require(currState == State.AWAITING_PAYMENT, "You may have paid already.");
        require(msg.value == price, "You must pay the correct amount.");
        currState = State.AMAITING_DELIVERY;
    }

    function confirmationDelivery() onlyBuyer public payable{
        require(currState == State.AMAITING_DELIVERY, "Buyer cannot yet confirm delivery.");
        seller.transfer(price);
        currState == State.COMPLETE;
    }

    function withDraw() onlyBuyer payable public{
        require(currState == State.AMAITING_DELIVERY);
        payable(msg.sender).transfer(price);
        currState == State.COMPLETE;
    }
}
