pragma solidity ^0.6.0;

contract Counter {
    uint public count = 0;

/*  Removed and replaced by setting inital variable at declaration.
    
    constructor() public {
        count = 0;
    }
*/

/*  Removed and replaced by adding public to declaration.

    function getCount() public view returns(uint) {
        return count;
    }
*/

    function incrementCount () public {
        // count = count + 1;
        // shorter way to write this.
        count ++;
    }
}