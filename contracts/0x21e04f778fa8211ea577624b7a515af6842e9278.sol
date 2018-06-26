
//Address: 0x21e04f778fa8211ea577624b7a515af6842e9278
//Contract name: WithdrawTokensPreICO
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
contract WithdrawTokensPreICO {
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

  function WithdrawTokensPreICO(
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
