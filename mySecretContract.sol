pragma solidity ^0.6.0;

contract Ownable {
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Must be owner.");
        _;
    }
}

contract SecretVault {
    string secret;

    constructor(string memory _secret) public {
        secret = _secret;
        }

    function getSecret() public view returns(string memory) {
        return secret;
    }
}

// "is Ownabale" to inherit the contract Ownable.
contract mySecretContract is Ownable {
        address secretVault;
      
        constructor(string memory _secret) public {
            SecretVault _secretVault = new SecretVault(_secret);
            secretVault = address(_secretVault);
            // Calls the inheritable conract (top of page).
            super;
        }

        function getSecret() public view onlyOwner returns(string memory) {
            SecretVault _secretVault = SecretVault(secretVault);
            return _secretVault.getSecret();
        }
}