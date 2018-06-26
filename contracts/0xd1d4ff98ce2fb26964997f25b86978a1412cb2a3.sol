
//Address: 0xd1d4ff98ce2fb26964997f25b86978a1412cb2a3
//Contract name: SimpleDistributor
//Balance: 0 Ether
//Verification Date: 4/5/2018
//Transacion Count: 6

// CODE STARTS HERE

pragma solidity ^0.4.20;

contract Mintable {
    
  function mint(address _to, uint256 _amount) public returns (bool);
  
}


contract SimpleDistributor {
    
  address public owner;
    
  Mintable public token = Mintable(0x552Ed8253f341fb770E8BAdff5A0E0Ee2fd57B43);
    
  function SimpleDistributor() public {
    owner = msg.sender;
  }
   
  function addReceivers(address[] receivers, uint[] balances) public {
    require(msg.sender == owner);
    for(uint i = 0; i < receivers.length; i++) {
      token.mint(receivers[i], balances[i]);
    }
  } 
  
}
