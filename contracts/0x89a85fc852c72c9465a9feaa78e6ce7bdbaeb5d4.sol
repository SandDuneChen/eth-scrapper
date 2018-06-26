
//Address: 0x89a85fc852c72c9465a9feaa78e6ce7bdbaeb5d4
//Contract name: Migrations
//Balance: 0 Ether
//Verification Date: 8/31/2017
//Transacion Count: 3

// CODE STARTS HERE

pragma solidity ^0.4.4;

contract Migrations {
  address public owner;
  uint public last_completed_migration;

  modifier restricted() {
    if (msg.sender == owner) _;
  }

  function Migrations() {
    owner = msg.sender;
  }

  function setCompleted(uint completed) restricted {
    last_completed_migration = completed;
  }

  function upgrade(address new_address) restricted {
    Migrations upgraded = Migrations(new_address);
    upgraded.setCompleted(last_completed_migration);
  }
}
