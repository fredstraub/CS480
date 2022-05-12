pragma solidity ^0.6.0;

contract myContract {
        // State Variables - stored on blockcahin
        string public myString = "Hello, World!";
        // for more performance
        bytes32 public myBytes32 = "Hello, World!";
        
        int myInt = 1;
        // only >0 values (256 bit value)
        uint public myUint = 1;
        // 256 bit value
        uint256 public myUnit256 = 1;
        // 8 bit value
        uint8 public myUint8 = 1;

        // every user has an address (this is a random address)
        address public myAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

        // structure varible declaration
        struct MyStruct {
            uint myUint;
            string myString;
        }

        MyStruct public myStruct = MyStruct(1, "Hello, World!");

        // Local Variables - in function scope
        function getValue() public pure returns(uint) {
            uint value = 1;
            return value;
        }

        // Arrays
        uint[] public uintArray = [1,2,3];

        string[] public stringArray = ["apple","banana","carrot"];
        //delcare an empty string array
        string[] public values;

        // 2 dimensional array
        uint[][] public array2D = [ [1,2,3], [4,5,6] ];

        // .push inserts value to the end of the array
        function addValue(string memory _value) public {
            values.push(_value);
        }

        // length of array is the number of elements in the array
        function valueCount() public view returns (uint) {
            return values.length;
        }

        //Mappings - key, value storage
        // mapping(key => value) myMapping <---- format of a mapping
        mapping(uint => string) public names;
        mapping(uint => Book) public books;
        mapping(address => mapping(uint => Book)) public myBooks;

        struct Book {
            string titles;
            string Author;
        }

        /* Can only have one constructor at a time, one below is needed for the tutorial.
        // run only once when deployed 
        constructor() public {
            names[1] = "Adam";
            names[2] = "Bruce";
            names[3] = "Carl";
        }

        */

        function addBook(uint _id, string memory _title, string memory _Author) public {
            books[_id] = Book(_title, _Author);
        }

        function addMyBook(uint _id, string memory _title, string memory _Author) public {
            myBooks[msg.sender][_id] = Book(_title, _Author);
        }

        // Conditionals & Loops

        uint[] public numbers = [1,2,3,4,5,6,7,8,9,10];

        address public owner;

        constructor() public {
            owner = msg.sender;
        }

        function isEvenNumber(uint _number) public view returns(bool){
            if(_number % 2 == 0) {
                return true;
            } else {
                return false;
            }
        }

        function countEvenNumbers() public view returns (uint){
            uint count = 0;
            for(uint i = 0; i < numbers.length; i++) {
                if(isEvenNumber(numbers[i])){
                    count ++;
                }
            }
            return count;
        }

        function isOwner() public view returns(bool) {
            return(msg.sender == owner);
            
            /* The single line above refactors the 4 lines below.
            if(msg.sender == owner) {
                return true;
            } else {
                return false;
            } */
        }
}