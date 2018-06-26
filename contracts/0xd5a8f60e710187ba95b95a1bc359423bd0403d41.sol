
//Address: 0xd5a8f60e710187ba95b95a1bc359423bd0403d41
//Contract name: StoreValue
//Balance: 0 Ether
//Verification Date: 5/28/2018
//Transacion Count: 2

// CODE STARTS HERE

pragma solidity ^0.4.23;

contract StoreValue {
  address public owner;
  string public storedValue;

  constructor() public {
    owner = msg.sender;
  }

  modifier restricted() {
    if (msg.sender == owner) _;
  }

  function setValue(string completed) public restricted {
    storedValue = completed;
  }

  function getValue() public view returns (string) {
    return storedValue;
  }
}
