
//Address: 0x715641fd955890299863a73c906209b71a8a4ce9
//Contract name: WhiteList
//Balance: 0 Ether
//Verification Date: 6/15/2018
//Transacion Count: 4

// CODE STARTS HERE

pragma solidity ^0.4.11;

contract WhiteList {
    
    mapping (address => bool)   public  whiteList;
    
    address  public  owner;
    
    function WhiteList() public {
        owner = msg.sender;
        whiteList[owner] = true;
    }
    
    function addToWhiteList(address [] _addresses) public {
        require(msg.sender == owner);
        
        for (uint i = 0; i < _addresses.length; i++) {
            whiteList[_addresses[i]] = true;
        }
    }
    
    function removeFromWhiteList(address [] _addresses) public {
        require (msg.sender == owner);
        for (uint i = 0; i < _addresses.length; i++) {
            whiteList[_addresses[i]] = false;
        }
    }
}
