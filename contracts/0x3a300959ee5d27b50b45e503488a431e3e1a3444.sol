
//Address: 0x3a300959ee5d27b50b45e503488a431e3e1a3444
//Contract name: WithdrawTokensFlixxoVesting1
//Balance: 0 Ether
//Verification Date: 10/23/2017
//Transacion Count: 1

// CODE STARTS HERE

/**
 * Copyright 2017 Icofunding S.L. (https://icofunding.com)
 * 
 */

contract MintInterface {
  function mint(address recipient, uint amount) returns (bool success);
}

/*
 *  Mint tokens of a linked token
 */
contract WithdrawTokensFlixxoVesting1 {
  address public tokenContract; // address of the token
  uint public vesting; // number of days in which the tokens are going to be blocked
  address public receiver; // receiver of the tokens
  uint public amount; // number of tokens (plus decimals) to be minted

  modifier afterDate() {
    require(now >= vesting);

    _;
  }

  modifier onlyReceiver() {
    require(msg.sender == receiver);

    _;
  }

  function WithdrawTokensFlixxoVesting1(
    address _tokenContract,
    uint _vesting,
    address _receiver,
    uint _amount
  ) {
    tokenContract = _tokenContract;
    vesting = now + _vesting * 1 days;
    receiver = _receiver;
    amount = _amount;
  }

  // Creates "amount" tokens to "receiver" address
  // Only executed after "vesting" number of days
  // Only executed once
  // Only executed by "receiver"
  function withdraw() public afterDate onlyReceiver {
    require(amount > 0);
    uint tokens = amount;

    amount = 0;
    // mint tokens
    if (!MintInterface(tokenContract).mint(receiver, tokens))
      revert();
  }
}
