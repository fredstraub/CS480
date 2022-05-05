//SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

contract PurchaseAgreement {

    uint public price;
    address payable public seller;
    address payable public buyer;

    enum State {Created, Locked, Release, Inactive}

    State public state;
    constructor() payable {
        seller = payable(msg.sender);
        price = msg.value / 2;
    }

    // The function cannot be alled at the current state.
    error InvalidState();


    modifier inState(State _state){
        if(state != _state){
            revert InvalidState();
        }
        _;
    }

    function confirmPurchase() inState(State.Created) payable {

    }

    function confirmedRecieved() onlyBuyer inState(State.Locked){

    }

    function paySeller() onlySeller inState(State.Release){
        
    }
}