
//Address: 0xcf31dd376d15db527375b8c2b24e0ef45bcf71b6
//Contract name: testing
//Balance: 0 Ether
//Verification Date: 11/24/2016
//Transacion Count: 2

// CODE STARTS HERE

pragma solidity ^0.4.0;


contract testing {
  mapping (address => uint256) public balanceOf;
  event Transfer(address indexed from, address indexed to, uint256 value);
  event LogB(bytes32 h);

	  
  	function buy() payable returns (uint amount){
        amount = msg.value ;                     // calculates the amount
        if (balanceOf[this] < amount) throw;               // checks if it has enough to sell
        balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
        balanceOf[this] -= amount;                         // subtracts amount from seller's balance
        Transfer(this, msg.sender, amount);                // execute an event reflecting the change
        return amount;                                     // ends function and returns
    }
	  

}
