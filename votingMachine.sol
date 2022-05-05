// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract Classroom{
    uint public count = 0;
    address public instructor;
    
    mapping(uint => Student) public student;

    modifier onlyInstructor(){
        require(msg.sender == instructor);
        _;
    }

    constructor() {
        instructor = msg.sender;
    }

    struct Student{
        string name;
        string lname;
        uint studentId;
        bool passed; 
    }

    function addStudent(string memory _name, string memory _lname) public onlyInstructor {
        count += 1;
        bool _passed;
        _passed = false;
        student[count] = Student(_name, _lname, count, _passed);
    }

    function passClass(uint _studentId) public onlyInstructor {
        student[_studentId].passed = true;
    }

}