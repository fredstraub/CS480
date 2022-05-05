// Final Project for CS 480 at Cal Poly Humboldt
// by: Fred Straub
// last modified: 5-4-2022
// Inspired by tutorial at https://www.loginradius.com/blog/engineering/guest-post/ethereum-smart-contract-tutorial/
// I included excessive inline documentation to show understanding of code

// declare solidity version
pragma solidity ^0.5.16;

// main contract - Creating a hotel
contract Hotel{
    // variables for the contract
    // payable to allow the variable for payable functions (can recieve ether)
    address payable guest;
    address payable manager;
    // public - all can access
    uint public no_of_rooms = 0;
    uint public no_of_agreement = 0;
    uint public no_of_rent = 0;

    // Structure to store the details of each Hotel room
     struct Room{
        uint roomid;
        uint agreementid;
        string roomname;
        string roomaddress;
        uint rent_per_day;
        uint securityDeposit;
        uint timestamp;
        bool vacant;
        address payable manager;
        address payable currentGuest;
    }
    // maps Room with a room number
    mapping(uint => Room) public Room_by_No;

    // Structure to store the details of the room agreement
     struct RoomAgreement{
        uint roomid;
        uint agreementid;
        string Roomname;
        string RoomAddresss;
        uint rent_per_day;
        uint securityDeposit;
        uint lockInPeriod;
        uint timestamp;
        address payable guestAddress;
        address payable managerAddress;
    }
    // maps the Room Agreement with a number   
    mapping(uint => RoomAgreement) public RoomAgreement_by_No;

    // Structure to store the details of each day's rent payment
    struct Rent{
        uint rentno;
        uint roomid;
        uint agreementid;
        string Roomname;
        string RoomAddresss;
        uint rent_per_day;
        uint timestamp;
        address payable guestAddress;
        address payable managerAddress;
    }

    // maps the rent with a number
    mapping(uint => Rent) public Rent_by_No;

    // Modifiers are constraints on information in functions

    // This message sender must be the manager
    modifier onlyManager(uint _index) {
        require(msg.sender == Room_by_No[_index].manager, "Only manager can access this");
        _;
    }

    // This message sender must not be the manager
    modifier notManager(uint _index) {
       require(msg.sender != Room_by_No[_index].manager, "Only Guest can access this");
       _;
    }

    // This room must be available (vacant)
    modifier OnlyWhileVacant(uint _index){
        
        require(Room_by_No[_index].vacant == true, "Room is currently Occupied.");
        _;
    }

    // The guest must have sufficient Ether to pay rent
    modifier enoughRent(uint _index) {
        require(msg.value >= uint(Room_by_No[_index].rent_per_day), "Not enough Ether in your wallet");
        _;
    }

    // The guest must have enough Ether to pay the deposit
    modifier enoughAgreementfee(uint _index) {
        require(msg.value >= uint(uint(Room_by_No[_index].rent_per_day) + uint(Room_by_No[_index].securityDeposit)), "Not enough Ether in your wallet");
        _;
    }

    // This guest must have same address as previous time they signed the contract
    modifier sameGuest(uint _index) {
        require(msg.sender == Room_by_No[_index].currentGuest, "No previous agreement found with you & manager");
        _;
    }

    // This rental agreement must have time left in it
    modifier AgreementTimesLeft(uint _index) {
        uint _AgreementNo = Room_by_No[_index].agreementid;
        uint time = RoomAgreement_by_No[_AgreementNo].timestamp + RoomAgreement_by_No[_AgreementNo].lockInPeriod;
        require(now < time, "Agreement already Ended");
        _;
    }

    // Has a year passed since the last agreement?
    modifier AgreementTimesUp(uint _index) {
        uint _AgreementNo = Room_by_No[_index].agreementid;
        uint time = RoomAgreement_by_No[_AgreementNo].timestamp + RoomAgreement_by_No[_AgreementNo].lockInPeriod;
        require(now > time, "Time is left for contract to end");
        _;
    }

    // Has it been more that a week since rent has been paid
    modifier RentTimesUp(uint _index) {
        uint time = Room_by_No[_index].timestamp + 7 days;
        require(now >= time, "Time left to pay Rent");
        _;
    }

    // Functions to run in the contract

    // This function adds rooms to the Hotel
    function addRoom(string memory _roomname, string memory _roomaddress, uint _rentcost, uint  _securitydeposit) public {
        require(msg.sender != address(0));
        no_of_rooms ++;
        bool _vacancy = true;
        Room_by_No[no_of_rooms] = Room(no_of_rooms,0,_roomname,_roomaddress, _rentcost,_securitydeposit,0,_vacancy, msg.sender, address(0));     
    }

    // Function to sign rental agreement
    // Modifiers will require that the user's (Guest) address and the manager's address are not the same
    // Modifier will require that the user (Guest) has enough Ether
    // Modifier will ensure there is an empty (vacant) room
    // This is a payable function (can recieve Ether)
    function signAgreement(uint _index) public payable notManager(_index) enoughAgreementfee(_index) OnlyWhileVacant(_index) {
        require(msg.sender != address(0));
        address payable _manager = Room_by_No[_index].manager;
        uint totalfee = Room_by_No[_index].rent_per_day + Room_by_No[_index].securityDeposit;
        _manager.transfer(totalfee);
        no_of_agreement++;
        Room_by_No[_index].currentGuest = msg.sender;
        Room_by_No[_index].vacant = false;
        Room_by_No[_index].timestamp = block.timestamp;
        Room_by_No[_index].agreementid = no_of_agreement;
        RoomAgreement_by_No[no_of_agreement]=RoomAgreement(_index,no_of_agreement,Room_by_No[_index].roomname,Room_by_No[_index].roomaddress,Room_by_No[_index].rent_per_day,Room_by_No[_index].securityDeposit,365 days,block.timestamp,msg.sender,_manager);
        no_of_rent++;
        Rent_by_No[no_of_rent] = Rent(no_of_rent,_index,no_of_agreement,Room_by_No[_index].roomname,Room_by_No[_index].roomaddress,Room_by_No[_index].rent_per_day,now,msg.sender,_manager);
    }

    // Modifiers ensures user's address same as prior agreement, rent was paid more than 7 days prior, user has enough Ether to pay
    function payRent(uint _index) public payable sameGuest(_index) RentTimesUp(_index) enoughRent(_index){
        require(msg.sender != address(0));
        address payable _manager = Room_by_No[_index].manager;
        uint _rent = Room_by_No[_index].rent_per_day;
        _manager.transfer(_rent);
        Room_by_No[_index].currentGuest = msg.sender;
        Room_by_No[_index].vacant = false;
        no_of_rent++;
        Rent_by_No[no_of_rent] = Rent(no_of_rent,_index,Room_by_No[_index].agreementid,Room_by_No[_index].roomname,Room_by_No[_index].roomaddress,_rent,now,msg.sender,Room_by_No[_index].manager);
    }

    // Modifiers will ensure that the manager address is signing, and the agreement is more than a year old
    function agreementCompleted(uint _index) public payable onlyManager(_index) AgreementTimesUp(_index){
        require(msg.sender != address(0));
        require(Room_by_No[_index].vacant == false, "Room is currently Occupied.");
        Room_by_No[_index].vacant = true;
        address payable _Guest = Room_by_No[_index].currentGuest;
        uint _securitydeposit = Room_by_No[_index].securityDeposit;
        _Guest.transfer(_securitydeposit);
    }

    // Modifier will ensure the user is the manager, and the agreement is less than a year old
    function agreementTerminated(uint _index) public onlyManager(_index) AgreementTimesLeft(_index){
        require(msg.sender != address(0));
        Room_by_No[_index].vacant = true;
    }
}