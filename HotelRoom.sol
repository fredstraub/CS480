pragma solidity ^0.6.0;

contract HotelRoom {

    // Enum "vairable" for room status.
    enum Statuses { Vacant, Occupied }
    Statuses currentStatus;
    address payable public owner;

    event Occupy(address _occupant, uint _value);

    // Make owner the person that deploys the contract, set room to vacant iitially.
    constructor() public {
        owner = msg.sender;
        currentStatus = Statuses.Vacant;
    }

    // Room must be vacant or error message sent.
    modifier onlyWhileVacant {
        require(currentStatus == Statuses.Vacant, "Currently Occupied.");
        _;
    }

    // Payment must be at least 2 Ether.
    modifier costs(uint _amount) {
        require(msg.value >= _amount, "Not enough Ether provided.");
        _;
    }

    // Make room occupied, and pay the owner ether.  Calls up when paid.    
    receive() external payable onlyWhileVacant costs(2 ether){
        currentStatus = Statuses.Occupied;
        owner.transfer(msg.value);
        emit Occupy(msg.sender, msg.value);
        }
}