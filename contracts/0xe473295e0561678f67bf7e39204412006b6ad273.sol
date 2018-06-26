
//Address: 0xe473295e0561678f67bf7e39204412006b6ad273
//Contract name: BountyEscrow
//Balance: 0 Ether
//Verification Date: 9/28/2017
//Transacion Count: 2

// CODE STARTS HERE

pragma solidity^0.4.17;

contract BountyEscrow {

  address public admin;

  function BountyEscrow() public {
    admin = msg.sender;
  }
  
  event Payout(
    address indexed sender,
    address indexed recipient,
    uint256 indexed sequenceNum,
    uint256 amount,
    bool success
  );

  // transfer deposits funds to recipients
  // Gas used in each `send` will be default stipend, 2300
  function payout(address[] recipients, uint256[] amounts) public {
    require(admin == msg.sender);
    require(recipients.length == amounts.length);
    for (uint i = 0; i < recipients.length; i++) {
      Payout(
        msg.sender,
        recipients[i],
        i + 1,
        amounts[i],
        recipients[i].send(amounts[i])
      );
    }
  }
  
  function () public payable { }
}
