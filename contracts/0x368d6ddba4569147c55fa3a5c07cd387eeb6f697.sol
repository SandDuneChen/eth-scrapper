
//Address: 0x368d6ddba4569147c55fa3a5c07cd387eeb6f697
//Contract name: TeamTimeLock
//Balance: 0 Ether
//Verification Date: 2/14/2018
//Transacion Count: 1

// CODE STARTS HERE

pragma solidity ^0.4.19;

//Dentacoin token import
contract exToken {
  function transfer(address, uint256) pure public returns (bool) {  }
  function balanceOf(address) pure public returns (uint256) {  }
}


// Timelock
contract TeamTimeLock {

  uint constant public year = 2023;
  address public owner;
  uint public lockTime = 1782 days;
  uint public startTime;
  uint256 lockedAmount;
  exToken public tokenAddress;

  modifier onlyBy(address _account){
    require(msg.sender == _account);
    _;
  }

  function () public payable {}

  function TeamTimeLock() public {

    owner = 0xd0b4b0165320f9Eeaf683174A5A3Ac93309c37d7;  //Radostina
    startTime = now;
    tokenAddress = exToken(0x08d32b0da63e2C3bcF8019c9c5d849d7a9d791e6);
  }

  function withdraw() onlyBy(owner) public {
    lockedAmount = tokenAddress.balanceOf(this);
    require((startTime + lockTime) < now);
    tokenAddress.transfer(owner, lockedAmount);
  }
}
