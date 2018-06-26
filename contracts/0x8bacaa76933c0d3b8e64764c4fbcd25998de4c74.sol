
//Address: 0x8bacaa76933c0d3b8e64764c4fbcd25998de4c74
//Contract name: Vault
//Balance: 0 Ether
//Verification Date: 4/23/2018
//Transacion Count: 1

// CODE STARTS HERE

pragma solidity ^0.4.20;

contract Vault {
    mapping (address=>uint256) public eth_stored;
    address public owner;
    address public primary_wallet;
    
    constructor (address main_wallet) public {
        owner = msg.sender;
        primary_wallet = main_wallet;
    }
    
    function () public payable {
        eth_stored[msg.sender] += msg.value;
    }
    
    modifier owner_only{
        require(msg.sender==owner);
        _;
    }
    
    function withdraw_all () public owner_only {
        primary_wallet.transfer(address(this).balance);
    }
    
    function kill () public owner_only {
        selfdestruct(primary_wallet);
    }
}
