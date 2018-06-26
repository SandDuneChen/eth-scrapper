
//Address: 0x584e0c03b5ee9337f24d77c5ba39d566dc851ba3
//Contract name: BitcoinBravado
//Balance: 0 Ether
//Verification Date: 3/28/2018
//Transacion Count: 1

// CODE STARTS HERE

pragma solidity ^0.4.0;

contract BitcoinBravado {
    
    address public owner;
    
    mapping(address => bool) paidUsers;
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    function BitcoinBravado() public {
        owner = msg.sender;
    }
    
    function payEntryFee() public payable  {
        if (msg.value >= 0.1 ether) {
            paidUsers[msg.sender] = true;
        }
    }
    
    function getUser (address _user) public view returns (bool _isUser) {
        return paidUsers[_user];
    }
    
    function withdrawAll() onlyOwner() public {
        owner.transfer(address(this).balance);
    }
}
