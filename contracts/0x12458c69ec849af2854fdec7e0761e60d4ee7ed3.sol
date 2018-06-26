
//Address: 0x12458c69ec849af2854fdec7e0761e60d4ee7ed3
//Contract name: ConsensysAcademy
//Balance: 0 Ether
//Verification Date: 6/8/2017
//Transacion Count: 5

// CODE STARTS HERE

pragma solidity ^0.4.11;

contract ConsensysAcademy{
    mapping(address=>bytes32) public names;
    address[] public addresses;
    
    modifier onlyUnique(){
        if(names[msg.sender] == 0){ _; }else{ throw; }
    }
    function register(bytes32 name) onlyUnique{
        names[msg.sender] = name; //32 character limit (first 32 used)
        addresses.push(msg.sender);
    }
    function getAddresses() returns(address[]){ return addresses; }
}
